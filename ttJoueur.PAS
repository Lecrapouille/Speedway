unit Joueur;

interface

USES
windows,
voiture,
Armes,
Hud,
maths,
nbrarme,
effet,
Caractere,
collision,
typege,
DDirectSound,
OpenGL;

TYPE
//----------------------------------------------------------------------------//
T_IA =(humain,artificielle);
T_Equipe =(bleu,neutre,rouge);
//----------------------------------------------------------------------------//
T_pJoueur = ^T_Joueur;

T_Joueur = object
    Id : integer;
    Armeselectionne : T_PNbrArme;
    Invincible : Boolean;
    Mort : Boolean;
    vie, VieMax : integer;
    Categorie : T_IA;
    Timer : integer;
    Equipe : T_Equipe;
    Voiture : T_Voiture;
    arme : T_pArme;
    pointdevue, grade : integer;
    Vex, Vey : real;
    DrawArme1 : Position;
    next : T_pJoueur;
    arme_1 : T_NbrArme;
    arme_2 : T_NbrArme;
    arme_3 : T_NbrArme;
    arme_4 : T_NbrArme;
    arme_5 : T_NbrArme;
    arme_6 : T_NbrArme;


   constructor Init(typemap : integer; player : string;
                    modele : T_Modele; categorie_1 : T_IA;
                    equipe_1 : T_Equipe; var j : integer);
   procedure Meurt;
   procedure Degat(i : integer);
   procedure Tire;
   procedure ArmeSuivante;
   procedure Affiche;
   procedure convertion(jtete : T_pJoueur);
   procedure collision(jtete : T_Pjoueur;var listep : T_pSysteme_de_particules;
                             map : PObjet; dsb : array of  TDirectSoundBuffer);
private
   procedure colliVM(map : PObjet; dsb : array of  TDirectSoundBuffer);
   procedure colliVV(j1 : T_pJoueur; dsb : array of  TDirectSoundBuffer);
   procedure colliAV(j1 : T_pJoueur;var listep : T_pSysteme_de_particules;
                         dsb : array of  TDirectSoundBuffer);
   procedure colliAM(map : PObjet;var listep : T_pSysteme_de_particules;
                         dsb : array of  TDirectSoundBuffer);
end;
procedure AjouterJoueur(typemap : integer;
                        player: string;
                        modele : T_Modele;
                        categorie_1 : T_IA;equipe_1 : T_Equipe;
                        var liste : T_pJoueur;
                        var j : integer);
procedure Suprimerjoueur(nom : string; liste : T_pJoueur);
procedure DetruireListeJoueur(var liste : T_pJoueur);
procedure AfficherJoueur(liste : T_pJoueur);
procedure ChangerJoueur( liste : T_pJoueur);
function ousontlesbleus(jtete : T_pJoueur) : boolean;

//----------------------------------------------------------------------------//
implementation

//----------------------------------------------------------------------------//

constructor T_Joueur.Init(typemap : integer;
                          player : string;
                          modele : T_Modele;
                          categorie_1 : T_IA; equipe_1 : T_Equipe;
                          var j : integer);
begin
  case modele of
       Tjoel :        begin
                        VieMax := 100;
                        vie := 100;
                      end;
       Tpriscillien : begin
                        VieMax := 80;
                        vie := 80;
                      end;
       Tquentin :     begin
                        VieMax := 150;
                        vie := 150;
                      end;
       Troman:        begin
                      VieMax := 70;
                      vie := 70;
                      end;
       Tpelleteuse:   begin
                      VieMax := 70;
                      vie := 70;
                      end;
  end;
  id := j;
  inc(j);
  pointdevue := 0;
  armeselectionne := @arme_6;
  Invincible := false;
  Mort := false;
  categorie := categorie_1;
  equipe := equipe_1;
  DrawArme1.Init(0.0, 0.0, 0.0);
  voiture.Init(typemap,modele);
  arme := nil;
  arme_1.init(99, 99, 1);
  arme_2.init(20, 20, 2);
  arme_3.init(20, 20, 3);
  arme_4.init(20, 20, 4);
  arme_5.init(5, 5, 5);
  arme_6.init(20, 20, 6);
end;
//----------------------------------------------------------------------------//

procedure T_Joueur.degat(i : integer);
begin
  if not invincible then
  begin
    vie := vie - i;
    if vie <= 0 then
    begin
      vie := 0;
      meurt;
    end;
  end;
end;
//----------------------------------------------------------------------------//
procedure T_Joueur.meurt;
begin
  voiture.vitesse.norme := 0;
  mort := true;
end;
//----------------------------------------------------------------------------//

procedure T_Joueur.Tire;
begin
  armeselectionne.tire(voiture, arme, pointdevue);
end;

//----------------------------------------------------------------------------//
procedure T_Joueur.Affiche;
begin
  voiture.Actualise;
  if categorie=artificielle then voiture.affiche;
  glPushMatrix;
    
    glTranslatef(voiture.emplacement.coordx,
                 voiture.emplacement.coordy + 7.0,
                 voiture.emplacement.coordz);
    glcolor3f(0.5,0.5,0.5);
    if not Mort then
    begin
      case Equipe of
           bleu   :       glColor3f(0.0,0.0,1.0);
           neutre :       glColor3f(0.0,1.0,0.0);
           rouge  :       glColor3f(1.0,0.0,0.0);
      end;
    end;
    
    glBegin(GL_QUADS);
      glVertex3f( 0.5, 0.5, 0.5 );
      glVertex3f(-0.5, 0.5, 0.5 );
      glVertex3f(-0.5,-0.5, 0.5 );
      glVertex3f( 0.5,-0.5, 0.5 );

      glVertex3f( 0.5, 0.5, 0.5 );
      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );
      glVertex3f( 0.5,-0.5, 0.5 );

      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );

      glVertex3f( 0.5, 0.5, 0.5 );
      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5, 0.5 );

      glVertex3f( 0.5,-0.5, 0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f(-0.5,-0.5, 0.5 );

      glVertex3f(-0.5, 0.5, 0.5 );
      glVertex3f(-0.5,-0.5, 0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
    glEnd;
  glPopMatrix;
  if (DrawArme1.coordx<>0) or
     (DrawArme1.coordy<>0) or
     (DrawArme1.coordz<>0) then
  begin
    DrawArme1.Translate(0.0, 2.0, 0.0);
    glPushMatrix();
      glColor3f(1.0, 0.0, 1.0);
      glBegin(GL_LINES);
         glVertex3f(voiture.emplacement.coordx,
                    voiture.emplacement.coordy + 2,
                    voiture.emplacement.coordz);
         glVertex3f( DrawArme1.coordx,DrawArme1.coordy, DrawArme1.coordz);
      glEnd();
    glPopMatrix ();
    DrawArme1.Init(0.0, 0.0, 0.0);
  end;
  AfficheArme(arme);
  if categorie = humain then
  begin
    AfficheHud;
    HudMort(mort);
    HudArme(armeselectionne, arme_1, arme_2, arme_3,
            arme_4, arme_5, arme_6);
    HudVie(vie,VieMax,invincible);
    HudEssence(voiture.essence);
  end;
end;
//----------------------------------------------------------------------------//
procedure T_Joueur.ArmeSuivante;
begin
  case Armeselectionne.Id of
    1 : Armeselectionne := @arme_2;
    2 : Armeselectionne := @arme_3;
    3 : Armeselectionne := @arme_4;
    4 : Armeselectionne := @arme_5;
    5 : Armeselectionne := @arme_6;
    6 : Armeselectionne := @arme_1;
  end;

end;

//----------------------------------------------------------------------------//
procedure T_Joueur.convertion(jtete : T_pJoueur);
var d : real;
    j1 : T_pJoueur;
begin
  j1 := jtete;
   while j1<>nil do
   begin
     if (j1.Mort)and not(mort) then
     begin
       d := sqrt(sqr(Voiture.emplacement.coordx-j1^.Voiture.emplacement.coordx)+
                 sqr(Voiture.emplacement.coordz-j1^.Voiture.emplacement.coordz));

       if d<20 then
       begin
         j1.Equipe := Equipe;
         j1.Mort := false;
         j1.Voiture.Essence := j1.Voiture.EssenceMax;
         j1.vie := jtete.VieMax;
         if j1.Categorie=humain then changerjoueur(jtete);
       end;
     end;
     j1 := j1^.next;
   end;
end;

//----------------------------------------------------------------------------//
procedure T_Joueur.collision(jtete : T_Pjoueur;var listep : T_pSysteme_de_particules;
                             map : PObjet; dsb : array of  TDirectSoundBuffer);
var j2 : T_Pjoueur;
begin

  // collision arme-map
  colliAM(map, listep, dsb);

  // collision voiture-map
  colliVM(map, dsb);

  j2 := jtete;
  while j2<>NIL do
  begin
    // collision voiture-voiture
    colliVV(j2,dsb);

    // collision arme-voiture
    colliAV(j2, listep, dsb);

    j2 := j2^.next;
  end;
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

procedure AjouterJoueur(typemap : integer;
                        player: string;
                        modele : T_Modele;
                        categorie_1 : T_IA;equipe_1 : T_Equipe;
                        var liste : T_pJoueur;
                        var j : integer);
var
  courant : T_pJoueur;
begin
  new(courant);
  courant.init(typemap,player,modele,categorie_1,equipe_1, j);
  courant^.next := liste;
  liste := courant;
end;

//----------------------------------------------------------------------------//
procedure SuprimerJoueur(nom : string; liste : T_pJoueur);
begin
end;

//----------------------------------------------------------------------------//
procedure DetruireListeJoueur(var liste : T_pJoueur);
var
  courant : T_pJoueur;
begin
   // liberer les joueurs
   while liste <> NIL do
   begin
   courant := liste;
   liste := liste^.next;
   freemem(courant);
   end;
end;

//----------------------------------------------------------------------------//
procedure AfficherJoueur(liste : T_pJoueur);
var courant : T_pJoueur;
    nb_mort, nb_amis, nb_neutre, nb_ennemis : integer;
begin
  courant := liste;
  nb_mort := 0;
  nb_amis := 0;
  nb_neutre := 0;
  nb_ennemis := 0;
  while courant <> NIL do
  begin
    courant.Affiche;
    if courant.Mort then inc(nb_mort)
    else if courant.Equipe=bleu then inc(nb_amis)
    else if courant.Equipe=neutre then inc(nb_neutre)
    else inc(nb_ennemis);
    courant := courant^.next;
  end;
  HudEtat(nb_mort,nb_amis,nb_neutre,nb_ennemis);
end;

//----------------------------------------------------------------------------//
procedure ChangerJoueur( liste : T_pJoueur);
var
  courant1, courant2 : T_pJoueur;
begin
  courant1 := liste;
  while (courant1<>NIL)and(courant1.Categorie=artificielle) do
    courant1 := courant1^.next;
  courant1.Categorie := artificielle;
  if courant1.next=nil  then courant2 := liste
  else courant2 := courant1.next;
  while (courant2.id<>courant1.id)and(courant2.Equipe<>courant1.Equipe) do
    if courant2.next=nil  then courant2 := liste
    else courant2 := courant2.next;
  courant2.Categorie := humain;
end;

//----------------------------------------------------------------------------//
function ousontlesbleus(jtete : T_pJoueur) : boolean;
var jtete2 : T_Pjoueur;
begin
  jtete2 := jtete;
  while (jtete<>nil)and((jtete.equipe=rouge)or(jtete.mort)) do
     jtete := jtete.next;
  while (jtete2<>nil)and((jtete2.equipe<>bleu)or(jtete2.mort)) do
     jtete2 := jtete2.next;
  result := (jtete=nil) or (jtete2=nil);
end;
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
// collision voiture map
procedure T_Joueur.colliVM(map : PObjet; dsb : array of  TDirectSoundBuffer);
var i : position;
    cpt : integer;
    pretest, sortir : boolean;
begin
  sortir := false;
  map^.MeshQueue := @map^.MeshHead;
  while map^.MeshQueue<>NIL do
  begin
    map^.MeshQueue^.FaceQueue := @map^.MeshQueue^.FaceHead;
    while (map^.MeshQueue^.FaceQueue^.next<>NIL)  do
    begin
      if not sortir then
      begin
         if (map.MeshQueue.FaceQueue.v[1].x>Voiture.emplacement.coordx+7) and
            (map.MeshQueue.FaceQueue.v[2].x>voiture.emplacement.coordx+7) and
            (map.MeshQueue.FaceQueue.v[3].x>voiture.emplacement.coordx+7) then pretest := false
         else if (map.MeshQueue.FaceQueue.v[1].x<voiture.emplacement.coordx-7) and
                 (map.MeshQueue.FaceQueue.v[2].x<voiture.emplacement.coordx-7) and
                 (map.MeshQueue.FaceQueue.v[3].x<voiture.emplacement.coordx-7) then pretest := false
         else if (map.MeshQueue.FaceQueue.v[1].z<voiture.emplacement.coordz-7) and
                 (map.MeshQueue.FaceQueue.v[2].z<voiture.emplacement.coordz-7) and
                 (map.MeshQueue.FaceQueue.v[3].z<voiture.emplacement.coordz-7) then pretest := false
         else if (map.MeshQueue.FaceQueue.v[1].z>voiture.emplacement.coordz+7) and
                 (map.MeshQueue.FaceQueue.v[2].z>voiture.emplacement.coordz+7) and
                 (map.MeshQueue.FaceQueue.v[3].z>voiture.emplacement.coordz+7) then pretest := false
         else pretest := true;
        cpt := 0;
        if pretest then
        while not(sortir) and (cpt<4) do
        begin
            i := interPlanDroite(Voiture.bbox2.tab[cpt], Voiture.bbox2.tab[(cpt+1)mod 4], map.MeshQueue.FaceQueue);
            if (i.coordx<>0) and
               (i.coordy<>0) and
               (i.coordx<>0) and
               interieur(Voiture.bbox2.tab[cpt], i, Voiture.bbox2.tab[(cpt+1)mod 4]) then
                if vraicolli(i, map.MeshQueue.FaceQueue) then
                begin
                 degat(5);
                 voiture.choc;
                 if Categorie=humain then dsb[4].Play(0);
                 sortir := true;
                  // possibilite de collission
                end;
            inc(cpt);
        end;
      end;
      map^.MeshQueue^.FaceQueue := map^.MeshQueue^.FaceQueue^.Next;
    end;
    map^.MeshQueue := map^.MeshQueue^.Next;
  end;
end;

//----------------------------------------------------------------------------//
// collision voiture voiture
procedure T_Joueur.colliVV(j1 : T_pJoueur; dsb : array of  TDirectSoundBuffer);
var d : GLFloat;
begin
  if j1.id<>id then
  begin
    d := sqrt(sqr(j1^.voiture.emplacement.coordx-voiture.emplacement.coordx)+
              sqr(j1^.voiture.emplacement.coordz-voiture.emplacement.coordz));
    if d<j1^.voiture.bsphere.rayon+voiture.bsphere.rayon then
    begin
       degat(5);
       voiture.choc;
       if Categorie=humain then dsb[7].Play(0);
    end;
  end;
end;

//----------------------------------------------------------------------------//
// collision arme voiture
procedure T_Joueur.colliAV(j1 : T_pJoueur;var listep : T_pSysteme_de_particules;
                           dsb : array of  TDirectSoundBuffer);
var d, Vx, Vz, Ax, Az, pscal : real;
    a : T_pArme;
begin
  if j1.Id<>Id then
  begin
     if (arme<>nil)and(arme.id=1) then
     begin
       Ax := j1^.voiture.emplacement.coordx-Voiture.emplacement.coordx;
       Az := j1^.voiture.emplacement.coordz-Voiture.emplacement.coordz;
       d := sqrt(sqr(Ax)+
                 sqr(Az));
       Vx := Voiture.orientation.norme*sin(Voiture.orientation.teta);
       Vz := Voiture.orientation.norme*cos(Voiture.orientation.teta);
       pscal := Vx*Ax + Vz*Az;
       d := sqrt(sqr(d)-sqr(pscal));
       if d<j1^.voiture.bsphere.rayon then
       begin
         j1^.degat(Arme.degats);
       end;
       //detruire la balle.
       a := Arme;
       Arme := Arme.next;
       freemem(a);
     end;
     //traitement des autres armes
     a := arme;
     while a<>NIL do
     begin
        d := sqrt(sqr(abs(j1^.voiture.emplacement.coordx-a^.emplacement.coordx))+
                  sqr(abs(j1^.voiture.emplacement.coordz-a^.emplacement.coordz)));
        if d<j1^.voiture.bsphere.rayon then
        begin
           j1^.degat(a^.degats);
           if (a.id=3)or(a.id>4)then Ajouter_Systeme_de_Particule(a^.emplacement,listep);
           if (a.id = 4) then
              begin
                j1^.Voiture.Essence := j1^.Voiture.Essence - 15;
                if j1^.Voiture.Essence < 0 then
                   Voiture.essence := Voiture.Essence + 15 + j1^.Voiture.Essence
                else
                   Voiture.Essence := Voiture.Essence + 15;
                if Voiture.Essence > Voiture.EssenceMax then
                   Voiture.Essence := Voiture.EssenceMax;
              end;
           if a^.id = 5 then
           begin
             pointdevue := 2;
           end;
           //detruire le missile.
           SupprimerArme(a, arme);
           if Categorie=humain then dsb[5].Play(0);
        end;
        if a<>nil then a := a^.next;
     end;
  end;
end;


//----------------------------------------------------------------------------//
// collision arme map
procedure T_Joueur.colliAM(map : PObjet;var listep : T_pSysteme_de_particules;
                           dsb : array of  TDirectSoundBuffer);
var d, dvrai : real;
    a : T_pArme;
    i, iarrive : position;
begin
  if (arme<>nil)and(arme.id=1) then
  begin
    dvrai := 1000;
    iarrive := arme.emplacement;
    iarrive.Translate(-arme.orientation.norme*sin(arme.orientation.teta)*dvrai,
                      0.0,
                      -arme.orientation.norme*cos(arme.orientation.teta)*dvrai);
    map^.MeshQueue := @map^.MeshHead;
    while map^.MeshQueue<>NIL do
    begin
      map^.MeshQueue^.FaceQueue := @map^.MeshQueue^.FaceHead;
      while (map^.MeshQueue^.FaceQueue^.next<>NIL)  do
      begin
        i := interPlanDroite(arme.emplacement, iarrive, map^.MeshQueue^.FaceQueue);
        if ((i.coordx<>0) or
            (i.coordy<>0) or
            (i.coordx<>0)) and
            interieur(arme.emplacement, i, iarrive)and
            (abs(map^.MeshQueue^.FaceQueue.U.y)<0.2) then
           if vraicolli(i, map^.MeshQueue^.FaceQueue) then
           begin
             d := sqrt(sqr(Arme.emplacement.coordx-i.coordx)+
                       sqr(Arme.emplacement.coordz-i.coordz));
             if d<dvrai then
             begin
               dvrai := d;
               iarrive := i;
             end;
           end;
           map^.MeshQueue^.FaceQueue := map^.MeshQueue^.FaceQueue^.Next;
      end;
      map^.MeshQueue := map^.MeshQueue^.Next;
    end;
    DrawArme1.Init(iarrive.coordx, iarrive.coordy, iarrive.coordz);
  end;

  // traitement des autres armes
    map^.MeshQueue := @map^.MeshHead;
    while map^.MeshQueue<>NIL do
    begin
      map^.MeshQueue^.FaceQueue := @map^.MeshQueue^.FaceHead;
      while (map^.MeshQueue^.FaceQueue^.next<>NIL)  do
      begin
        a := arme;
        while a<>NIL do
        begin
          if a^.id<>3 then
          begin
            i := interOPlanDroite(a^.emplacement, map^.MeshQueue^.FaceQueue);
            d := sqrt(sqr(i.coordx-a^.emplacement.coordx)+
                      sqr(i.coordy-a^.emplacement.coordy)+
                      sqr(i.coordz-a^.emplacement.coordz));
            if ((i.coordx<>0) or
                (i.coordy<>0) or
                (i.coordx<>0)) and
                (d<a^.bsphere.rayon) then
              if vraicolli(i, map^.MeshQueue^.FaceQueue) then
              begin
                if a.id>4then Ajouter_Systeme_de_Particule(a^.emplacement,listep);
                if a^.id = 5 then
                begin
                  pointdevue := 2;
                end;
                SupprimerArme(a, arme);
                if Categorie=humain then dsb[5].Play(0);
              end;
            end;
          if a<>nil then a := a^.next
        end;
        map^.MeshQueue^.FaceQueue := map^.MeshQueue^.FaceQueue^.Next;
      end;
      map^.MeshQueue := map^.MeshQueue^.Next;
    end;
end;




end.
