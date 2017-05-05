﻿unit Main;

interface //#################################################################### ■

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL,
  System.UITypes,
  Vcl.ExtCtrls,
  LUX, LUX.D3, LUX.GPU.OpenGL.GLView;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
      GLView1: TGLView;
      GLView2: TGLView;
      GLView3: TGLView;
      GLView4: TGLView;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private 宣言 }
    _Angle :Single;
  public
    { Public 宣言 }
    ///// メソッド
    procedure DrawModel;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.dfm}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.DrawModel;                                                     { OpenGL 1.1 (1997) }
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

     glVertexPointer( 3, GL_FLOAT, 0, @Ps[ 0 ] );
     glColorPointer ( 4, GL_FLOAT, 0, @Cs[ 0 ] );

     glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, @Fs[ 0, 0 ] );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Angle := 0;

     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );

     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, 0.1, 100 );
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
            glOrtho( -4, +4, -2, +2, 0.1, 100 );
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
            glOrtho( -3, +3, -3, +3, 0.1, 100 );
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
            glOrtho( -4, +4, -3, +3, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( -30, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;
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
