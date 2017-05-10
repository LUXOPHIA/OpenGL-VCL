﻿unit Main;

interface //#################################################################### ■

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL, Winapi.OpenGLext,
  System.UITypes,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  LUX, LUX.D3, LUX.GPU.OpenGL, LUX.GPU.OpenGL.Shader, LUX.GPU.OpenGL.GLView;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
      TabSheetV: TTabSheet;
        Panel1: TPanel;
          GLView1: TGLView;
          GLView2: TGLView;
        GLView3: TGLView;
        GLView4: TGLView;
      TabSheetP: TTabSheet;
        MemoP: TMemo;
      TabSheetS: TTabSheet;
        PageControlS: TPageControl;
          TabSheetSV: TTabSheet;
            PageControlSV: TPageControl;
              TabSheetSVS: TTabSheet;
                MemoSVS: TMemo;
              TabSheetSVE: TTabSheet;
                MemoSVE: TMemo;
          TabSheetSF: TTabSheet;
            PageControlSF: TPageControl;
              TabSheetSFS: TTabSheet;
                MemoSFS: TMemo;
              TabSheetSFE: TTabSheet;
                MemoSFE: TMemo;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private 宣言 }
    _Angle :Single;
  public
    { Public 宣言 }
    _BufV :TGLBufferV<TSingle3D>;
    _BufC :TGLBufferV<TAlphaColorF>;
    _BufF :TGLBufferI<Cardinal>;
    _ShaV :TGLShaderV;
    _ShaF :TGLShaderF;
    _Prog :TGLProgram;
    _Arra :TGLArray;
    ///// メソッド
    procedure MakeModel;
    procedure DrawModel;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.dfm}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.MakeModel;
const
     Ps :array [ 0..7 ] of TSingle3D = ( ( X:-1; Y:-1; Z:-1 ),
                                         ( X:+1; Y:-1; Z:-1 ),
                                         ( X:-1; Y:+1; Z:-1 ),
                                         ( X:+1; Y:+1; Z:-1 ),
                                         ( X:-1; Y:-1; Z:+1 ),
                                         ( X:+1; Y:-1; Z:+1 ),
                                         ( X:-1; Y:+1; Z:+1 ),
                                         ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..7 ] of TAlphaColorF = ( ( R:0; G:0; B:0; A:1 ),
                                            ( R:1; G:0; B:0; A:1 ),
                                            ( R:0; G:1; B:0; A:1 ),
                                            ( R:1; G:1; B:0; A:1 ),
                                            ( R:0; G:0; B:1; A:1 ),
                                            ( R:1; G:0; B:1; A:1 ),
                                            ( R:0; G:1; B:1; A:1 ),
                                            ( R:1; G:1; B:1; A:1 ) );
     Fs :array [ 0..11, 0..2 ] of Cardinal = ( ( 0, 4, 6 ), ( 6, 2, 0 ),
                                               ( 0, 1, 5 ), ( 5, 4, 0 ),
                                               ( 0, 2, 3 ), ( 3, 1, 0 ),
                                               ( 7, 5, 1 ), ( 1, 3, 7 ),
                                               ( 7, 3, 2 ), ( 2, 6, 7 ),
                                               ( 7, 6, 4 ), ( 4, 5, 7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5

     ///// バッファ

     with _BufV do
     begin
          Count := 8;

          Bind;
            glBufferData( GL_ARRAY_BUFFER, SizeOf( Ps ), @Ps[ 0 ], GL_STATIC_DRAW );
          Unbind;
     end;

     with _BufC do
     begin
          Count := 8;

          Bind;
            glBufferData( GL_ARRAY_BUFFER, SizeOf( Cs ), @Cs[ 0 ], GL_STATIC_DRAW );
          Unbind;
     end;

     with _BufF do
     begin
          Count := 36;

          Bind;
            glBufferData( GL_ELEMENT_ARRAY_BUFFER, SizeOf( Fs ), @Fs[ 0, 0 ], GL_STATIC_DRAW );
          Unbind;
     end;

     ///// シェーダ

     with _ShaV do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

          MemoSVS.Lines.Assign( Source );
          MemoSVE.Lines.Assign( Error  );

          if not Success then PageControlSV.TabIndex := 1;
     end;

     with _ShaF do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

          MemoSFS.Lines.Assign( Source );
          MemoSFE.Lines.Assign( Error  );

          if not Success then PageControlSF.TabIndex := 1;
     end;

     ///// プログラム

     with _Prog do
     begin
          Attach( _ShaV );
          Attach( _ShaF );

          Link;

          MemoP.Lines.Assign( Error  );

          if not Success then PageControl1.TabIndex := 1;
     end;

     ///// アレイ

     with _Arra do
     begin
          Bind;

            glEnableClientState( GL_VERTEX_ARRAY );
            glEnableClientState( GL_COLOR_ARRAY  );

            with _BufV do
            begin
                 Bind;
                   glVertexPointer( 3, GL_FLOAT, 0, nil );
                 Unbind;
            end;

            with _BufC do
            begin
                 Bind;
                   glColorPointer( 4, GL_FLOAT, 0, nil );
                 Unbind;
            end;

            _BufF.Bind;

            _Prog.Use;

          Unbind;
     end;
end;

procedure TForm1.DrawModel;                                                     { OpenGL 3.0 - GLSL 1.3 }
begin
     with _Arra do
     begin
          Bind;

            glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );

          Unbind;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
const
     MIND :Single = 0.1;
     MAXD :Single = 1000;
begin
     _Angle := 0;

     _BufV := TGLBufferV<TSingle3D>   .Create;
     _BufC := TGLBufferV<TAlphaColorF>.Create;
     _BufF := TGLBufferI<Cardinal>    .Create;

     _ShaV := TGLShaderV.Create;
     _ShaF := TGLShaderF.Create;
     _Prog := TGLProgram.Create;

     _Arra := TGLArray.Create;

     MakeModel;

     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, MIND, MAXD );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +90, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView2.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -4, +4, -2, +2, MIND, MAXD );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( -90, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView3.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -3, +3, MIND, MAXD );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView4.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glFrustum( -4/8*MIND, +4/8*MIND,
                       -3/8*MIND, +3/8*MIND, MIND, MAXD );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -8 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( -30, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Arra.DisposeOf;

     _ShaV.DisposeOf;
     _ShaF.DisposeOf;
     _Prog.DisposeOf;

     _BufV.DisposeOf;
     _BufC.DisposeOf;
     _BufF.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     GLView1.Repaint;
     GLView2.Repaint;
     GLView3.Repaint;
     GLView4.Repaint;
end;

end. //######################################################################### ■
