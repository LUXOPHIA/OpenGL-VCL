﻿unit Main;

interface //#################################################################### ■

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL, Winapi.OpenGLext,
  System.UITypes,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.GLView,
  LUX.GPU.OpenGL.Buffer,
  LUX.GPU.OpenGL.Buffer.Unif,
  LUX.GPU.OpenGL.Buffer.Vert,
  LUX.GPU.OpenGL.Buffer.Elem,
  LUX.GPU.OpenGL.Pluger,
  LUX.GPU.OpenGL.Shader,
  LUX.GPU.OpenGL.Engine;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
      TabSheetV: TTabSheet;
        Panel1: TPanel;
          GLView1: TGLView;
          GLView2: TGLView;
        Panel2: TPanel;
          GLView3: TGLView;
          GLView4: TGLView;
      TabSheetS: TTabSheet;
        PageControlS: TPageControl;
          TabSheetSV: TTabSheet;
            MemoSVS: TMemo;
            SplitterSV: TSplitter;
            MemoSVE: TMemo;
          TabSheetSF: TTabSheet;
            MemoSFS: TMemo;
            SplitterSF: TSplitter;
            MemoSFE: TMemo;
      TabSheetP: TTabSheet;
        MemoP: TMemo;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MemoSVSChange(Sender: TObject);
    procedure MemoSFSChange(Sender: TObject);
  private
    { Private 宣言 }
    _Angle :Single;
    ///// メソッド
    procedure EditShader( const Shader_:TGLShader; const Memo_:TMemo );
  public type
    TCamera = record
    private
    public
      Proj :TSingleM4;
      Move :TSingleM4;
    end;
  public
    { Public 宣言 }
    _CameraUs :TGLBufferU<TCamera>;
    _GeometP  :TGLBufferVS<TSingle3D>;
    _GeometC  :TGLBufferVS<TSingle3D>;
    _GeometF  :TGLBufferI<TCardinal3D>;
    _GeometUs :TGLBufferU<TSingleM4>;
    _PlugerV  :TGLPlugerV;
    _PlugerU1 :TGLPlugerU;
    _PlugerU2 :TGLPlugerU;
    _PlugerU3 :TGLPlugerU;
    _PlugerU4 :TGLPlugerU;
    _ShaderV  :TGLShaderV;
    _ShaderF  :TGLShaderF;
    _Engine   :TGLEngine;
    ///// メソッド
    procedure InitCamera;
    procedure InitGeomet;
    procedure InitPluger;
    procedure InitShader;
    procedure InitEngine;
    procedure DrawModel;
    procedure InitRender;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.dfm}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.EditShader( const Shader_:TGLShader; const Memo_:TMemo );
begin
     if Memo_.Focused then
     begin
          TabSheetV.Enabled := False;

          TIdleTask.Run( procedure
          begin
               Shader_.Source.Assign( Memo_.Lines );

               with _Engine do
               begin
                    TabSheetV.Enabled := Status;

                    if not Status then PageControl1.TabIndex := 1;
               end;
          end );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitCamera;
const
     _N :Single = 0.1;
     _F :Single = 1000;
var
   C :TCamera;
begin
     with _CameraUs do
     begin
          Count := 4;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -3, +3, -3, +3, _N, _F );

               Move := TSingleM4.Translate( 0, +5, 0 )
                     * TSingleM4.RotateX( DegToRad( -90 ) );
          end;

          Items[ 0 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -3, +3, -2, +2, _N, _F );

               Move := TSingleM4.RotateX( DegToRad( -45 ) )
                     * TSingleM4.Translate( 0, 0, +5 );
          end;

          Items[ 1 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -3, +3, -1.5, +1.5, _N, _F );

               Move := TSingleM4.Translate( 0, 0, +5 );
          end;

          Items[ 2 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjPers( -4/4*_N, +4/4*_N, -3/4*_N, +3/4*_N, _N, _F );

               Move := TSingleM4.RotateX( DegToRad( -45 ) )
                     * TSingleM4.Translate( 0, -0.25, +3 );
          end;

          Items[ 3 ] := C;
     end;
end;

//------------------------------------------------------------------------------

function BraidedTorus( const T_:TdSingle2D ) :TdSingle3D;
const
     LoopR :Single = 1.00;  LoopN :Integer = 3; 
     TwisR :Single = 0.50;  TwisN :Integer = 5;
     PipeR :Single = 0.25;
var
   T :TdSingle2D;
   cL, cT, cP, TX, PX, R,
   sL, sT, sP, TY, PY, H :TdSingle;
begin
     T := Pi2 * T_;

     CosSin( LoopN * T.U, cL, sL );
     CosSin( TwisN * T.U, cT, sT );
     CosSin(         T.V, cP, sP );

     TX := TwisR * cT;  PX := PipeR * cP;
     TY := TwisR * sT;  PY := PipeR * sP;

     R := LoopR * ( TX +  1 ) + PX;
     H := LoopR * ( TY + PY )     ;

     with Result do
     begin
          X := R * cL;
          Y := H;
          Z := R * sL;
     end;
end;

procedure TForm1.InitGeomet;
const
     DivX :Integer = 440;
     DivY :Integer =  20;
//·························
     function XYtoI( const X_,Y_:Integer ) :Integer;
     begin
          Result := ( DivX + 1 ) * Y_ + X_;
     end;
     //····················
     procedure MakeVerts;
     var
        X, Y, I :Integer;
        Ps, Ns :TGLBufferData<TSingle3D>;
        T :TSingle2D;
        M :TSingleM4;
     begin
          _GeometP.Count := ( DivY + 1 ) * ( DivX + 1 );
          _GeometC.Count := ( DivY + 1 ) * ( DivX + 1 );

          Ps := _GeometP.Map( GL_WRITE_ONLY );
          Ns := _GeometC.Map( GL_WRITE_ONLY );

          for Y := 0 to DivY do
          begin
               T.V := Y / DivY;
               for X := 0 to DivX do
               begin
                    T.U := X / DivX;

                    I := XYtoI( X, Y );

                    M := Tensor( T, BraidedTorus );

                    Ps.Items[ I ] := M.AxisP;
                    Ns.Items[ I ] := M.AxisZ;
               end;
          end;

          _GeometP.Unmap;
          _GeometC.Unmap;
     end;
     //····················
     procedure MakeElems;
     var
        X, Y, I, I00, I01, I10, I11 :Integer;
        Es :TGLBufferData<TCardinal3D>;
     begin
          _GeometF.Count := 2 * DivY * DivX;

          Es := _GeometF.Map( GL_WRITE_ONLY );

          I := 0;
          for Y := 0 to DivY-1 do
          begin
               for X := 0 to DivX-1 do
               begin
                    I00 := XYtoI( X+0, Y+0 );  I01 := XYtoI( X+1, Y+0 );
                    I10 := XYtoI( X+0, Y+1 );  I11 := XYtoI( X+1, Y+1 );

                    Es.Items[ I ] := TCardinal3D.Create( I00, I10, I11 );  Inc( I );
                    Es.Items[ I ] := TCardinal3D.Create( I11, I01, I00 );  Inc( I );
               end;
          end;

          _GeometF.Unmap;
     end;
//·························
begin
     MakeVerts;
     MakeElems;

     with _GeometUs do
     begin
          Count := 1{Pose};
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitPluger;
begin
     with _PlugerV do
     begin
          Add( 0{Port}, _GeometP );
          Add( 1{Port}, _GeometC );
     end;

     with _PlugerU1 do
     begin
          Add( 0{Port}, _CameraUs, 0{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;

     with _PlugerU2 do
     begin
          Add( 0{Port}, _CameraUs, 1{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;

     with _PlugerU3 do
     begin
          Add( 0{Port}, _CameraUs, 2{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;

     with _PlugerU4 do
     begin
          Add( 0{Port}, _CameraUs, 3{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitShader;
begin
     with _ShaderV do
     begin
          OnCompiled := procedure
          begin
               MemoSVE.Lines.Assign( Errors );

               _Engine.Link;
          end;
     end;

     with _ShaderF do
     begin
          OnCompiled := procedure
          begin
               MemoSFE.Lines.Assign( Errors );

               _Engine.Link;
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitEngine;
begin
     with _Engine do
     begin
          with Shaders do
          begin
               Add( _ShaderV );
               Add( _ShaderF );
          end;

          with VerPorts do
          begin
               Add( 0{Port}, '_Vertex_Pos', 3, GL_FLOAT, 0 );
               Add( 1{Port}, '_Vertex_Nor', 3, GL_FLOAT, 0 );
          end;

          with UniPorts do
          begin
               Add( 0{Port}, 'TCamera' );
               Add( 1{Port}, 'TGeomet' );
          end;

          with FraPorts do
          begin
               Add( 0{Port}, '_FragColor' );
          end;

          OnLinked := procedure
          begin
               MemoP.Lines.Assign( Errors );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawModel;
begin
     with _Engine do
     begin
          Use;

          with _PlugerV do  // TGLEngine needs to be used before TGLPulgerV.
          begin
               Use;

                 _GeometF.Draw;

               Unuse;
          end;

          Unuse;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitRender;
begin
     GLView1.OnPaint := procedure
     begin
          with _PlugerU1 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;

     GLView2.OnPaint := procedure
     begin
          with _PlugerU2 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;

     GLView3.OnPaint := procedure
     begin
          with _PlugerU3 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;

     GLView4.OnPaint := procedure
     begin
          with _PlugerU4 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _CameraUs := TGLBufferU<TCamera>    .Create( GL_STATIC_DRAW  );

     _GeometP  := TGLBufferVS<TSingle3D> .Create( GL_STATIC_DRAW  );
     _GeometC  := TGLBufferVS<TSingle3D> .Create( GL_STATIC_DRAW  );
     _GeometF  := TGLBufferI<TCardinal3D>.Create( GL_STATIC_DRAW  );
     _GeometUs := TGLBufferU<TSingleM4>  .Create( GL_DYNAMIC_DRAW );

     _PlugerV  := TGLPlugerV             .Create;

     _PlugerU1 := TGLPlugerU             .Create;
     _PlugerU2 := TGLPlugerU             .Create;
     _PlugerU3 := TGLPlugerU             .Create;
     _PlugerU4 := TGLPlugerU             .Create;

     _ShaderV  := TGLShaderV             .Create;
     _ShaderF  := TGLShaderF             .Create;

     _Engine   := TGLEngine              .Create;

     //////////

     InitCamera;
     InitGeomet;
     InitPluger;
     InitShader;
     InitEngine;
     InitRender;

     //////////

     with _ShaderV do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

          MemoSVS.Lines.Assign( Source );
     end;

     with _ShaderF do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

          MemoSFS.Lines.Assign( Source );
     end;

     //////////

     _Angle := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Engine  .DisposeOf;

     _ShaderV .DisposeOf;
     _ShaderF .DisposeOf;

     _PlugerU1.DisposeOf;
     _PlugerU2.DisposeOf;
     _PlugerU3.DisposeOf;
     _PlugerU4.DisposeOf;

     _PlugerV .DisposeOf;

     _GeometP .DisposeOf;
     _GeometC .DisposeOf;
     _GeometF .DisposeOf;
     _GeometUs.DisposeOf;

     _CameraUs.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     _GeometUs.Items[ 0 ] := TSingleM4.RotateY( DegToRad( _Angle ) );

     GLView1.Repaint;
     GLView2.Repaint;
     GLView3.Repaint;
     GLView4.Repaint;
end;

//------------------------------------------------------------------------------

procedure TForm1.MemoSVSChange(Sender: TObject);
begin
     EditShader( _ShaderV, MemoSVS );
end;

procedure TForm1.MemoSFSChange(Sender: TObject);
begin
     EditShader( _ShaderF, MemoSFS );
end;

end. //######################################################################### ■
