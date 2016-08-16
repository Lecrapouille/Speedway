unit Voiture;

interface
USES
maths,
math,
Opengl,
SysUtils,
typege;

TYPE
T_Voiture = object
    proprietaire : string;
    modele : T_Modele;
    emplacement : position;
    orientation : vecteurPol;
    vitesse     : vecteurPol;
    accellemax : GLFloat;
    deccelaration : GLFloat;
    vitessemax : GLFloat;
    EssenceMax : integer;
    Essence : real;
    bbox1, bbox2 : T_BBox;
    bsphere : T_BSphere;
    Vex, Vey : real;
    NbTirs : integer;
    a : GLFloat;  //acceleration

    constructor Init(typemap : integer ; modele_1 : T_modele);
    procedure Avance;
    procedure Recule;
    procedure Stop;
    procedure Gauche;
    procedure Droite;
    procedure Affiche;
    procedure Actualise;
    procedure Choc;
end;

VAR
joel_m, priscillien_m, quentin_m, roman_m, pelleteuse_m,
VR,VB,TR,TB,DR,DB,DrapeauBleu,DrapeauRouge : TObjet;
ch : array [1..20] of T_chaine;
pointeur : integer=1;
//----------------------------------------------------------------------------//
implementation

//----------------------------------------------------------------------------//
constructor T_Voiture.Init(typemap : integer ; modele_1 : T_modele);
var inFile : file;
begin
  case typemap of
    0 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
    1 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
    2 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
    3 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
    4 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
    5 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
    6 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
    7 : AssignFile(inFile, GetCurrentDir + '\data\map\Quick arena b.pos');
  end;

  Reset(inFile, SizeOf(ch));
  blockread(inFile, ch, 1);
  CloseFile(inFile);
  emplacement.Init(ch[pointeur].x, 0, ch[pointeur].z);
  if pointeur<20 then inc(pointeur)
  else pointeur := 1;

  modele := modele_1;
  EssenceMax := 100;
  essence := 100;
  orientation.Init(0.0,0.0,0.0);
  vitesse.Init (0.0,0.0,0.0);
  a := 1;

  Vex := 0; Vey := 0;
  NbTirs := 0;
  case modele of
       Tjoel :        begin
                      accellemax := 0.08;
                      deccelaration := 0.09;
                      vitessemax := 5;
                      bsphere.rayon := 5;
                      bbox1.tab[0].Init(4,2,4);
                      bbox1.tab[1].Init(-4,2,4);
                      bbox1.tab[2].Init(-4,2,-4);
                      bbox1.tab[3].Init(4,2,-4);
                      end;
       Tpriscillien : begin
                      accellemax := 0.09;
                      deccelaration := 0.09;
                      vitessemax := 5;
                      bsphere.rayon := 6;
                      bbox1.tab[0].Init(4,2,4);
                      bbox1.tab[1].Init(-4,2,4);
                      bbox1.tab[2].Init(-4,2,-4);
                      bbox1.tab[3].Init(4,2,-4);
                      end;
       Tquentin :     begin
                      accellemax := 0.06;
                      deccelaration := 0.09;
                      vitessemax := 5;
                      bsphere.rayon := 6;
                      a:= 1.0;
                      bbox1.tab[0].Init(4,2,4);
                      bbox1.tab[1].Init(-4,2,4);
                      bbox1.tab[2].Init(-4,2,-4);
                      bbox1.tab[3].Init(4,2,-4);
                      end;
       Troman:        begin
                      accellemax := 0.06;
                      deccelaration := 0.09;
                      vitessemax := 5;
                      bsphere.rayon := 6;
                      bbox1.tab[0].Init(4,2,4);
                      bbox1.tab[1].Init(-4,2,4);
                      bbox1.tab[2].Init(-4,2,-4);
                      bbox1.tab[3].Init(4,2,-4);
                      end;
       Tpelleteuse:   begin
                      accellemax := 0.05;
                      deccelaration := 0.09;
                      vitessemax := 5;
                      bsphere.rayon := 6;
                      bbox1.tab[0].Init(4,2,4);
                      bbox1.tab[1].Init(-4,2,4);
                      bbox1.tab[2].Init(-4,2,-4);
                      bbox1.tab[3].Init(4,2,-4);
                      end;
  end;
end;
//----------------------------------------------------------------------------//

procedure T_Voiture.Avance;
begin
if essence <> 0 then
begin
   //if a < 10 then a:= a + accellemax;
   vitesse.norme := min(vitesse.norme + 1,vitessemax);//ln(1+a);
end;
end;

procedure T_Voiture.Recule;
begin
if essence <> 0 then
begin
  { if a > -0.7 then
   begin
     vitesse.norme := vitesse.norme - deccelaration;
     a := exp(vitesse.norme)-1;
   end; }

   //vitesse.norme := max(vitesse.norme - 1,0);

   vitesse.norme := Max(vitesse.norme - 1,-vitessemax);
end;
end;

//----------------------------------------------------------------------------//
procedure T_Voiture.Stop;
begin
 { if (vitesse.norme > deccelaration/5) then
  begin
    vitesse.norme := vitesse.norme - deccelaration/5;
    a := exp(vitesse.norme)-1;
  end
  else
  if (vitesse.norme < -deccelaration/5) then
  begin
    vitesse.norme := vitesse.norme + deccelaration/5;
    a := exp(vitesse.norme)-1;
  end;  }
end;

//----------------------------------------------------------------------------//

procedure T_Voiture.Gauche;
begin
  if essence <> 0 then
    begin
    //if vitesse.norme <> 0 then
    //  begin
      vitesse.Inc(0.0, 0.05, 0.0);
      orientation.teta := orientation.teta + 0.05;
      //end;
    end;
end;

//----------------------------------------------------------------------------//

procedure T_Voiture.Droite;
begin
  if essence <> 0 then
    begin
    //if vitesse.norme <> 0 then
     // begin
      vitesse.Inc(0.0, -0.05, 0.0);
      orientation.teta := orientation.teta - 0.05;
     // end;
    end;
end;

//----------------------------------------------------------------------------//

procedure T_Voiture.Affiche;
begin
    glPushMatrix;
      glTranslated(emplacement.coordx,emplacement.coordy,emplacement.coordz);
      glRotated( orientation.teta*180/pi,0.0,1.0,0.0 );
      case modele of
        Tjoel : glCallList(joel_m.list);
        Tpriscillien : glCallList(priscillien_m.list);
        //Tquentin : if (vie <> 0) then glCallList(quentin_m.list) else glCallList(tankdestroy.list);
        Tquentin : glCallList(quentin_m.list);
        Troman : glCallList(roman_m.list);
        Tpelleteuse : glCallList(pelleteuse_m.list);
      end;
    glPopMatrix;
end;
//----------------------------------------------------------------------------//
procedure T_Voiture.Actualise;
var
i : integer;
begin
  if  essence > 0 then
  begin
    if vitesse.norme <> 0 then
    begin
      emplacement.deplace(vitesse);
      essence := essence - 0.01;
      stop;
      if essence < 0.2 then essence := 0;// pour les problemes d'arrondi
    end;
    //-------------------------------------------------------------//
    for i:=0 to 3 do
    begin
      bbox2.tab[i].coordx := (bbox1.tab[i].coordx*cos(orientation.teta)+
                             bbox1.tab[i].coordz*sin(orientation.teta)+
                             emplacement.coordx);
      bbox2.tab[i].coordy := (bbox1.tab[i].coordy+
                             emplacement.coordy);
      bbox2.tab[i].coordz := (-bbox1.tab[i].coordx*sin(orientation.teta)+
                             bbox1.tab[i].coordz*cos(orientation.teta)+
                             emplacement.coordz);
    end;
  end;
end;
//----------------------------------------------------------------------------//
procedure T_Voiture.Choc;
begin
   vitesse.norme := -vitesse.norme;
   
  // a := exp(vitesse.norme)-1;
end;
//----------------------------------------------------------------------------//

end.
