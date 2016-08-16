program Speedway;

uses
  Forms,
  interfa in 'interfa.pas' {Form1},
  lancement in 'lancement.pas',
  Armes in 'Armes.pas',
  Joueur in 'Joueur.PAS',
  caractere in 'caractere.pas',
  U_chargement in 'U_chargement.pas',
  Voiture in 'Voiture.pas',
  Boucledejeu in 'Boucledejeu.pas',
  UControle in 'UControle.pas',
  Bonus in 'Bonus.pas',
  Repere in 'Repere.pas',
  Hud in 'Hud.pas',
  IA in 'IA.pas',
  effet in 'effet.pas',
  UCamera in 'UCamera.pas',
  nbrarme in 'nbrarme.pas',
  QQ in 'QQ.pas',
  collision in 'collision.pas',
  sound in 'sound.pas',
  loader in 'loader.pas',
  typege in 'typege.pas',
  BoucleBot in 'BoucleBot.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SpeedWay';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
