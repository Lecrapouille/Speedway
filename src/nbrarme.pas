unit nbrarme;

interface

uses
  armes,
  voiture;

type
  T_PNbrArme = ^T_NbrArme;
  T_NbrArme = object
    Id : integer;
    NbrArme, NbrArme_max : integer;
    procedure init(n, nmax, i : integer);
    procedure tire(var voiture : T_Voiture; var a : T_pArme; var pointdevue : integer);
  end;

implementation
procedure T_NbrArme.init(n, nmax, i : integer);
begin
  Id := i;
  NbrArme := n;
  NbrArme_max := nmax;
end;

procedure T_NbrArme.tire(var voiture : T_Voiture; var a : T_pArme; var pointdevue : integer);
var
  nouveau : T_pArme;
begin
  if NbrArme > 0 then
  begin
    dec(NbrArme);
    new(nouveau);
    case Id of
      1 : nouveau^ := T_Arme_1.Init(voiture.emplacement,voiture.orientation);
      2 : nouveau^ := T_Arme_2.Init(voiture.emplacement,voiture.orientation);
      3 : nouveau^ := T_Arme_3.Init(voiture.emplacement,voiture.orientation);
      4 : nouveau^ := T_Arme_4.Init(voiture.emplacement,voiture.orientation);
      5 : begin
            nouveau^ := T_Arme_5.Init(voiture.emplacement,voiture.orientation);
            pointdevue := 3;
            voiture.vitesse.norme := 0;
          end;
      6 : nouveau^ := T_Arme_6.Init(voiture.emplacement,voiture.orientation);
    end;
    nouveau^.next := a;
    a:= nouveau;
  end;
end;

end.
