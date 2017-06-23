﻿unit Main;

interface //#################################################################### ■

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL, Winapi.OpenGLext,
  System.UITypes,
  Vcl.ExtCtrls,
  LUX, LUX.D3,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.Viewer,
  LUX.GPU.OpenGL.Buffer,
  LUX.GPU.OpenGL.Buffer.Verter,
  LUX.GPU.OpenGL.Buffer.Elemer,
  LUX.GPU.OpenGL.Shader,
  LUX.GPU.OpenGL.Progra;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
      GLViewer1: TGLViewer;
      GLViewer2: TGLViewer;
    Panel2: TPanel;
      GLViewer3: TGLViewer;
      GLViewer4: TGLViewer;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private 宣言 }
    _Angle :Single;
  public
    { Public 宣言 }
    _VerterP :TGLVerterS<TSingle3D>;
    _VerterC :TGLVerterS<TAlphaColorF>;
    _Elemer  :TGLElemertria32;
    _ShaderV :TGLShaderV;
    _ShaderF :TGLShaderF;
    _Progra  :TGLProgra;
    ///// メソッド
    procedure InitGeomet;
    procedure DrawModel;
    procedure InitRender;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.dfm}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitGeomet;
const
     Ps :array [ 0..8-1 ] of TSingle3D
           = ( ( X:-1; Y:-1; Z:-1 ), ( X:+1; Y:-1; Z:-1 ),
               ( X:-1; Y:+1; Z:-1 ), ( X:+1; Y:+1; Z:-1 ),
               ( X:-1; Y:-1; Z:+1 ), ( X:+1; Y:-1; Z:+1 ),
               ( X:-1; Y:+1; Z:+1 ), ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..8-1 ] of TAlphaColorF
           = ( ( R:0; G:0; B:0; A:1 ), ( R:1; G:0; B:0; A:1 ),
               ( R:0; G:1; B:0; A:1 ), ( R:1; G:1; B:0; A:1 ),
               ( R:0; G:0; B:1; A:1 ), ( R:1; G:0; B:1; A:1 ),
               ( R:0; G:1; B:1; A:1 ), ( R:1; G:1; B:1; A:1 ) );
     Es :array [ 0..12-1 ] of TCardinal3D
           = ( ( X:0; Y:4; Z:6 ), ( X:6; Y:2; Z:0 ), ( X:7; Y:5; Z:1 ), ( X:1; Y:3; Z:7 ),
               ( X:0; Y:1; Z:5 ), ( X:5; Y:4; Z:0 ), ( X:7; Y:3; Z:2 ), ( X:2; Y:6; Z:7 ),
               ( X:0; Y:2; Z:3 ), ( X:3; Y:1; Z:0 ), ( X:7; Y:6; Z:4 ), ( X:4; Y:5; Z:7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5

     ///// バッファ

     _VerterP.Import( Ps );
     _VerterC.Import( Cs );
     _Elemer .Import( Es );

     ///// シェーダ

     with _ShaderV do
     begin
          with Source do
          begin
               BeginUpdate;

                 Add( '#version 120' );
                 Add( 'void main()' );
                 Add( '{' );
                 Add( '  gl_Position   = gl_ModelViewProjectionMatrix * gl_Vertex;' );
                 Add( '  gl_FrontColor = gl_Color;' );
                 Add( '}' );

               EndUpdate;
          end;

          Assert( Status, Errors.Text );
     end;

     with _ShaderF do
     begin
          with Source do
          begin
               BeginUpdate;

                 Add( '#version 120' );
                 Add( 'void main()' );
                 Add( '{' );
                 Add( '  gl_FragColor = gl_Color;' );
                 Add( '}' );

               EndUpdate;
          end;

          Assert( Status, Errors.Text );
     end;

     ///// プログラム

     with _Progra do
     begin
          Attach( _ShaderV );
          Attach( _ShaderF );

          Link;

          Assert( Status, Errors.Text );
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawModel;
begin
     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );

       with _VerterP do
       begin
            Bind;
              glVertexPointer( 3, GL_FLOAT, 0, nil );
            Unbind;
       end;

       with _VerterC do
       begin
            Bind;
              glColorPointer( 4, GL_FLOAT, 0, nil );
            Unbind;
       end;

       with _Elemer do
       begin
            Bind;

              with _Progra do
              begin
                   Use;
                     glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );
                   Unuse;
              end;

            Unbind;
       end;

     glDisableClientState( GL_VERTEX_ARRAY );
     glDisableClientState( GL_COLOR_ARRAY  );
end;

//------------------------------------------------------------------------------

procedure TForm1.InitRender;
const
     _N :Single = 0.1;
     _F :Single = 1000;
begin
     GLViewer1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -3, +3, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +90, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLViewer2.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLViewer3.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -1.5, +1.5, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLViewer4.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glFrustum( -4/4*_N, +4/4*_N,
                       -3/4*_N, +3/4*_N, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, +0.3, 0 );
            glTranslatef( 0, 0, -3 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _VerterP := TGLVerterS<TSingle3D>   .Create( GL_STATIC_DRAW );
     _VerterC := TGLVerterS<TAlphaColorF>.Create( GL_STATIC_DRAW );
     _Elemer  := TGLElemerTria32         .Create( GL_STATIC_DRAW );

     _ShaderV := TGLShaderV              .Create;
     _ShaderF := TGLShaderF              .Create;

     _Progra  := TGLProgra               .Create;

     InitGeomet;
     InitRender;

     _Angle := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Progra .DisposeOf;

     _ShaderV.DisposeOf;
     _ShaderF.DisposeOf;

     _VerterP.DisposeOf;
     _VerterC.DisposeOf;
     _Elemer .DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     GLViewer1.Repaint;
     GLViewer2.Repaint;
     GLViewer3.Repaint;
     GLViewer4.Repaint;
end;

end. //######################################################################### ■
