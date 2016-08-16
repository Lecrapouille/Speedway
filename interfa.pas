unit interfa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, BoucledeJeu, typege, jpeg;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Image3: TImage;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label12: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ComboBox3: TComboBox;
    Image1: TImage;
    GroupBox3: TGroupBox;
    ComboBox4: TComboBox;
    Image2: TImage;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label7: TLabel;
    Label10: TLabel;
    CheckBox1: TCheckBox;
    GroupBox6: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Edit1: TEdit;
    TrackBar4: TTrackBar;
    GroupBox9: TGroupBox;
    TrackBar5: TTrackBar;
    Edit2: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    TrackBar6: TTrackBar;
    Edit3: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    TrackBar7: TTrackBar;
    GroupBox11: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label11: TLabel;
    TrackBar9: TTrackBar;
    Edit5: TEdit;
    Edit6: TEdit;
    TrackBar10: TTrackBar;
    TrackBar11: TTrackBar;
    Edit7: TEdit;
    Label16: TLabel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    GroupBox12: TGroupBox;
    TrackBar1: TTrackBar;
    ComboBox5: TComboBox;
    Image5: TImage;
    Label13: TLabel;
    GroupBox13: TGroupBox;
    TrackBar2: TTrackBar;
    ComboBox6: TComboBox;
    Image6: TImage;
    Label15: TLabel;
    GroupBox14: TGroupBox;
    TrackBar3: TTrackBar;
    ComboBox7: TComboBox;
    Image7: TImage;
    Label9: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    GroupBox15: TGroupBox;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Label39: TLabel;
    Label40: TLabel;
    GroupBox16: TGroupBox;
    CheckBox6: TCheckBox;
    Label2: TLabel;
    Button12: TButton;
    Panel1: TPanel;
    Image4: TImage;
    RichEdit1: TRichEdit;
    CheckBox7: TCheckBox;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure TrackBar10Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar11Change(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
    procedure TrackBar7Change(Sender: TObject);
//    procedure TrackBar8Change(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  param : T_param;

implementation

{$R *.DFM}

procedure sauvegarder();
var
  OutFile : file;
begin
  AssignFile(OutFile, GetCurrentDir + '\data\config.cfg');
  Reset(OutFile);
  blockWrite(OutFile, param, 1);
  CloseFile(OutFile);
end;

procedure charger();
var
  InFile : file;
begin
  AssignFile(InFile, GetCurrentDir + '\data\config.cfg');
  Reset(InFile);
  blockread(InFile, param, 1);
  CloseFile(InFile);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  application.terminate;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  sauvegarder();
  WinMain( hInstance, hPrevInst, CmdLine, CmdShow, param );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   PageControl1.ActivePage := TabSheet1;
   charger;
   //Parametre video
   ComboBox1.text := inttostr(param.video.Width)
                     + ' x '
                     + inttostr(param.video.Height);
   ComboBox2.text := inttostr(param.video.PixelDepth);
   CheckBox1.Checked := param.video.FullScreen;
   CheckBox2.Checked := param.video.fog;
   CheckBox6.Checked := param.radar;
   CheckBox7.Checked := param.AmbiancePluie;
   if CheckBox6.Checked then Label2.Caption := 'activé' else  Label2.Caption := 'désactivé';
   if CheckBox7.Checked then Label1.Caption := 'activée' else  Label1.Caption := 'désactivée';
   //Parametre de config
   ComboBox5.ItemIndex := param.config.TypeAmis;
   ComboBox6.ItemIndex := param.config.TypeNeutres;
   ComboBox7.ItemIndex := param.config.TypeEnnemis;

   ComboBox4.ItemIndex := param.config.carte;

   case param.config.voiture of
     Troman       : ComboBox3.ItemIndex := 0;
     Tquentin     : ComboBox3.ItemIndex := 1;
     Tjoel        : ComboBox3.ItemIndex := 2;
     Tpriscillien : ComboBox3.ItemIndex := 3;
     Tpelleteuse  : ComboBox3.ItemIndex := 4;
   end;

   case param.config.goodies of
     Troman :       begin
                      ComboBox5.ItemIndex := 0;
                      Image5.Picture.LoadFromFile(getcurrentdir + '\data\voiture\tank5.bmp');
                    end;
     Tquentin :     begin
                      ComboBox5.ItemIndex := 1;
                      Image5.Picture.LoadFromFile(getcurrentdir + '\data\voiture\blinde.bmp');
                    end;
     Tjoel :        begin
                      ComboBox5.ItemIndex := 2;
                      Image5.Picture.LoadFromFile(getcurrentdir + '\data\voiture\jeep.bmp');
                    end;
     Tpriscillien : begin
                      ComboBox5.ItemIndex := 3;
                      Image5.Picture.LoadFromFile(getcurrentdir + '\data\voiture\Camion.bmp');
                    end;
     Tpelleteuse :  begin
                      ComboBox5.ItemIndex := 4;
                      Image5.Picture.LoadFromFile(getcurrentdir + '\data\voiture\pelleteuse.bmp');
                    end;
   end;

      case param.config.neutres of
     Troman :       begin
                      ComboBox6.ItemIndex := 0;
                      Image6.Picture.LoadFromFile(getcurrentdir + '\data\voiture\tank5.bmp');
                    end;
     Tquentin :     begin
                      ComboBox6.ItemIndex := 1;
                      Image6.Picture.LoadFromFile(getcurrentdir + '\data\voiture\blinde.bmp');
                    end;
     Tjoel :        begin
                      ComboBox6.ItemIndex := 2;
                      Image6.Picture.LoadFromFile(getcurrentdir + '\data\voiture\jeep.bmp');
                    end;
     Tpriscillien : begin
                      ComboBox6.ItemIndex := 3;
                      Image6.Picture.LoadFromFile(getcurrentdir + '\data\voiture\Camion.bmp');
                    end;
     Tpelleteuse :  begin
                      ComboBox6.ItemIndex := 4;
                      Image6.Picture.LoadFromFile(getcurrentdir + '\data\voiture\pelleteuse.bmp');
                    end;
   end;

      case param.config.badies of
     Troman :       begin
                      ComboBox7.ItemIndex := 0;
                      Image7.Picture.LoadFromFile(getcurrentdir + '\data\voiture\tank5.bmp');
                    end;
     Tquentin :     begin
                      ComboBox7.ItemIndex := 1;
                      Image7.Picture.LoadFromFile(getcurrentdir + '\data\voiture\blinde.bmp');
                    end;
     Tjoel :        begin
                      ComboBox7.ItemIndex := 2;
                      Image7.Picture.LoadFromFile(getcurrentdir + '\data\voiture\jeep.bmp');
                    end;
     Tpriscillien : begin
                      ComboBox7.ItemIndex := 3;
                      Image7.Picture.LoadFromFile(getcurrentdir + '\data\voiture\Camion.bmp');
                    end;
     Tpelleteuse :  begin
                      ComboBox7.ItemIndex := 4;
                      Image7.Picture.LoadFromFile(getcurrentdir + '\data\voiture\pelleteuse.bmp');
                    end;
   end;

   case ComboBox4.ItemIndex of
      0 : Image2.Picture.LoadFromFile(getcurrentdir + '\data\map\ville.jpg');
      1 : Image2.Picture.LoadFromFile(getcurrentdir + '\data\map\chaud.jpg');
      2 : Image2.Picture.LoadFromFile(getcurrentdir + '\data\map\Hell.jpg');
      3 : Image2.Picture.LoadFromFile(getcurrentdir + '\data\map\BlackMesa.jpg');
      4 : Image2.Picture.LoadFromFile(getcurrentdir + '\data\map\Carte.jpg');
      5 : Image2.Picture.LoadFromFile(getcurrentdir + '\data\map\Foret.jpg');
      6 : Image2.Picture.LoadFromFile(getcurrentdir + '\data\map\laby.jpg');
   end;

   ComboBox3Change(sender);
   //Parametre de joueur
   TrackBar1.Position := param.config.BotsAmis;
   TrackBar2.Position := param.config.BotsNeutre;
   TrackBar3.Position := param.config.BotsEnnemis;
   TrackBar4.Position := trunc(10*param.VitesseJeu);
   TrackBar11.Position := trunc(10*param.Frottement);
   TrackBar5.Position := param.FrequenceTirs;
   TrackBar6.Position := param.FrequenceEclair;
   TrackBar7.Position := param.DureeEblouit;
   TrackBar10.Position := param.config.ia;
   CheckBox3.Checked := param.Orage;
   CheckBox5.Checked := param.SonON;
   CheckBox4.Checked := param.AmbianceSonore;
   CheckBox4.Enabled := CheckBox5.Checked;
   Label5.Enabled := CheckBox3.Checked;
   Label6.Enabled := CheckBox3.Checked;
   TrackBar6.Enabled := CheckBox3.Checked;
   TrackBar7.Enabled := CheckBox3.Checked;
   Edit3.Enabled := CheckBox3.Checked;
   Edit5.Enabled := CheckBox3.Checked;
   if CheckBox3.Checked then Label35.Caption := 'activé'
     else Label35.Caption := 'desactivé';
   if CheckBox5.Checked then CheckBox5.Caption := 'activé'
     else CheckBox5.Caption := 'desactivé';

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
   case ComboBox1.ItemIndex of
      0 : begin param.video.Width := 640;
                param.video.Height := 480;
                param.police := 18;
          end;
      1 : begin param.video.Width := 800;
                param.video.Height := 600;
                param.police := 22;
          end;
      2 : begin param.video.Width := 1024;
                param.video.Height := 768;
                param.police := 26;
          end;
      3 : begin param.video.Width := 1280;
                param.video.Height := 1024;
                param.police := 32;
          end;
      4 : begin param.video.Width := 1600;
                param.video.Height := 1200;
                param.police := 38;
          end;
   end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
   case ComboBox2.ItemIndex of
      0 : param.video.PixelDepth := 8;
      1 : param.video.PixelDepth := 16;
      2 : param.video.PixelDepth := 24;
      3 : param.video.PixelDepth := 32;
   end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
   param.video.FullScreen := CheckBox1.Checked;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
   param.config.BotsAmis := TrackBar1.Position;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var chemin : string;
begin
   chemin := '\data\voiture\';
   case ComboBox3.ItemIndex of
      0 : begin chemin := chemin + 'tank5.bmp';
                param.config.voiture := Tquentin;
          end;
      1 : begin chemin := chemin + 'blinde.bmp';
                param.config.voiture := Troman;
          end;
      2 : begin chemin := chemin + 'jeep.bmp';
                param.config.voiture := Tjoel;
          end;
      3 : begin chemin := chemin + 'Camion.bmp';
                param.config.voiture := Tpriscillien;
          end;
      4 : begin chemin := chemin + 'pelleteuse.bmp';
                param.config.voiture := Tpelleteuse;
          end;
   end;
   Image1.Picture.LoadFromFile(getcurrentdir + chemin);
end;

procedure TForm1.ComboBox4Change(Sender: TObject);
var chemin : string;
begin
   chemin := '\data\map\';
   param.config.carte := ComboBox4.ItemIndex;
   case ComboBox4.ItemIndex of
      0 : chemin := chemin + 'ville.jpg';
      1 : chemin := chemin + 'chaud.jpg';
      2 : chemin := chemin + 'Hell.jpg';
      3 : chemin := chemin + 'BlackMesa.jpg';
      4 : chemin := chemin + 'Carte.jpg';
      5 : chemin := chemin + 'Foret.jpg';
      6 : chemin := chemin + 'laby.jpg';
   end;
   Image2.Picture.LoadFromFile(getcurrentdir + chemin);
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
   param.config.BotsNeutre := TrackBar2.Position;
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
   param.config.BotsEnnemis := TrackBar3.Position;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
   param.video.fog := CheckBox2.Checked;
end;

procedure TForm1.ComboBox5Change(Sender: TObject);
var chemin : string;
begin
   chemin := '\data\voiture\';
   param.config.TypeAmis := ComboBox5.ItemIndex;
   case ComboBox5.ItemIndex of
      0 : begin chemin := chemin + 'tank5.bmp';
                param.config.goodies := Tquentin;
          end;
      1 : begin chemin := chemin + 'blinde.bmp';
                param.config.goodies := Troman;
          end;
      2 : begin chemin := chemin + 'jeep.bmp';
                param.config.goodies := Tjoel;
          end;
      3 : begin chemin := chemin + 'Camion.bmp';
                param.config.goodies := Tpriscillien;
          end;
      4 : begin chemin := chemin + 'pelleteuse.bmp';
                param.config.goodies := Tpelleteuse;
          end;
   end;
   Image5.Picture.LoadFromFile(getcurrentdir + chemin);
end;

procedure TForm1.ComboBox6Change(Sender: TObject);
var chemin : string;
begin
   chemin := '\data\voiture\';
   param.config.TypeNeutres := ComboBox6.ItemIndex;
   case ComboBox6.ItemIndex of
      0 : begin chemin := chemin + 'tank5.bmp';
                param.config.neutres := Tquentin;
          end;
      1 : begin chemin := chemin + 'blinde.bmp';
                param.config.neutres := Troman;
          end;
      2 : begin chemin := chemin + 'jeep.bmp';
                param.config.neutres := Tjoel;
          end;
      3 : begin chemin := chemin + 'Camion.bmp';
                param.config.neutres := Tpriscillien;
          end;
      4 : begin chemin := chemin + 'pelleteuse.bmp';
                param.config.neutres := Tpelleteuse;
          end;
   end;
   Image6.Picture.LoadFromFile(getcurrentdir + chemin);
end;

procedure TForm1.ComboBox7Change(Sender: TObject);
var chemin : string;
begin
   chemin := '\data\voiture\';
   param.config.TypeEnnemis := ComboBox7.ItemIndex;
   case ComboBox7.ItemIndex of
      0 : begin chemin := chemin + 'tank5.bmp';
                param.config.badies := Tquentin;
          end;
      1 : begin chemin := chemin + 'blinde.bmp';
                param.config.badies := Troman;
          end;
      2 : begin chemin := chemin + 'jeep.bmp';
                param.config.badies := Tjoel;
          end;
      3 : begin chemin := chemin + 'Camion.bmp';
                param.config.badies := Tpriscillien;
          end;
      4 : begin chemin := chemin + 'pelleteuse.bmp';
                param.config.badies := Tpelleteuse;
          end;
      {5 : begin chemin := chemin + 'pelleteuse.bmp';
                param.config.badies := Camion;
          end; }

   end;
   Image7.Picture.LoadFromFile(getcurrentdir + chemin);
end;

procedure TForm1.TrackBar10Change(Sender: TObject);
begin
  param.config.ia := TrackBar10.Position;
   case TrackBar10.Position of
     0 : Edit6.Text := 'Capture the FLAG (Flouz Licite A Gagner)';
     1 : Edit6.Text := 'Dernière équipe en vie';
  end;
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
begin
  param.VitesseJeu := 0.1*TrackBar4.Position;
  Edit1.Text := IntToStr(TrackBar4.Position);
end;

procedure TForm1.TrackBar5Change(Sender: TObject);
begin
  param.FrequenceTirs := TrackBar5.Position;
  Edit2.Text := IntToStr(TrackBar5.Position);
end;

procedure TForm1.TrackBar11Change(Sender: TObject);
begin
  param.Frottement := 0.1*TrackBar11.Position;
  Edit7.Text := IntToStr(TrackBar11.Position);
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  param.Orage := CheckBox3.Checked;
  Label5.Enabled := CheckBox3.Checked;
  Label6.Enabled := CheckBox3.Checked;
  TrackBar6.Enabled := CheckBox3.Checked;
  TrackBar7.Enabled := CheckBox3.Checked;
  Edit3.Enabled := CheckBox3.Checked;
  Edit5.Enabled := CheckBox3.Checked;
  if CheckBox3.Checked then Label35.Caption := 'activé'
   else Label35.Caption := 'desactivé'
end;

procedure TForm1.TrackBar6Change(Sender: TObject);
begin
  param.FrequenceEclair := TrackBar6.Position;
  Edit3.Text := IntToStr(TrackBar6.Position);
end;

procedure TForm1.TrackBar7Change(Sender: TObject);
begin
  param.DureeEblouit := TrackBar7.Position;
  Edit5.Text := IntToStr(TrackBar7.Position);
end;

{procedure TForm1.TrackBar8Change(Sender: TObject);
begin
  param.NbParticules := TrackBar8.Position;
  Edit4.Text := IntToStr(TrackBar8.Position);
end;}

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
  param.SonON := CheckBox5.Checked;
  CheckBox4.Enabled := CheckBox5.Checked;
  if CheckBox5.Checked then CheckBox5.Caption := 'activé'
  else CheckBox5.Caption := 'desactivé';
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  param.AmbianceSonore := CheckBox4.Checked;
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
  param.Radar := CheckBox6.Checked;
  if CheckBox6.Checked then Label2.Caption := 'activé' else  Label2.Caption := 'désactivé';
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  param.VitesseJeu := 1;
  param.VitesseJeu := 0.8;
  param.FrequenceTirs := 7;
  param.FrequenceEclair := 100;
  param.DureeEblouit := 100;
  TrackBar4.Position := trunc(10*param.VitesseJeu);
  TrackBar11.Position := trunc(10*param.VitesseJeu);
  TrackBar5.Position := param.FrequenceTirs;
  TrackBar6.Position := param.FrequenceEclair;
  TrackBar7.Position := param.DureeEblouit;
end;

procedure TForm1.CheckBox7Click(Sender: TObject);
begin
  param.AmbiancePluie := CheckBox7.Checked;
  if CheckBox7.Checked then label1.Caption := 'activée'
  else label1.Caption := 'désactivée'
end;

end.
