unit IA;

interface
uses
  joueur,
  maths,
  math,
  Armes,
  collision,
  bonus,
  typege;

const CoefTuerie = 1;
      Coefpeur = 0;
      CoefVitesse = 1;

function voitvoiture(j1, jtete : T_Pjoueur; map : PObjet) : T_Pjoueur;
function voitbonus(j1 : T_Pjoueur; listeb : T_pBonus; map : PObjet) : T_pBonus;
procedure ChampVV(j1, j2 : T_pJoueur);
procedure ChampVB(j1 : T_pJoueur; listeb : T_pBonus);
procedure ChampVM(j1 : T_pJoueur; map : PObjet);

implementation

function voitvoiture(j1, jtete : T_Pjoueur; map : PObjet) : T_Pjoueur;
var i : position;
    d, Vx, Vz, Ax, Az, pscal : real;
    retour : T_Pjoueur;
    sortie : boolean;
begin
   retour := nil;
   while (jtete<>nil)and(retour=nil) do
   begin
     if (j1.Equipe<>jtete.Equipe)and(j1.Equipe<>neutre)or (jtete.Mort) then
     begin
       sortie := true;
       Ax := j1^.Voiture.emplacement.coordx-jtete^.Voiture.emplacement.coordx;
       Az := j1^.Voiture.emplacement.coordz-jtete^.Voiture.emplacement.coordz;
       d := sqrt(sqr(Ax)+
                 sqr(Az));

       Vx := j1.Voiture.orientation.norme*sin(j1.Voiture.orientation.teta);
       Vz := j1.Voiture.orientation.norme*cos(j1.Voiture.orientation.teta);


       pscal := (Vx*Ax + Vz*Az)/d;
       if (d<300)and(pscal>0.80) then
       begin
         map^.MeshQueue := @map^.MeshHead;
         while map^.MeshQueue<>NIL do
         begin
           map^.MeshQueue^.FaceQueue := @map^.MeshQueue^.FaceHead;
           while (map^.MeshQueue^.FaceQueue^.next<>NIL)  do
           begin
             i := interPlanDroite(j1^.Voiture.emplacement, jtete^.Voiture.emplacement, map^.MeshQueue^.FaceQueue);
             if (i.coordx<>0) and
                (i.coordy<>0) and
                (i.coordx<>0) and
                 interieur(j1^.Voiture.emplacement, i, jtete^.Voiture.emplacement) then
                 if vraicolli(i, map^.MeshQueue^.FaceQueue) then sortie := false;

              map^.MeshQueue^.FaceQueue := map^.MeshQueue^.FaceQueue^.Next;
           end;
           map^.MeshQueue := map^.MeshQueue^.Next;
         end;
         if sortie then retour := jtete;
       end;
     end;
     jtete := jtete^.next;
   end;
   result := retour;
end;

function voitbonus(j1 : T_Pjoueur; listeb : T_pBonus; map : PObjet) : T_pBonus;
var i : position;
    d, Vx, Vz, Ax, Az, pscal : real;
    retour : T_pBonus;
    sortie : boolean;
begin
   retour := nil;
   while (listeb<>nil)and(retour=nil) do
   begin
     sortie := true;
     Ax := j1^.Voiture.emplacement.coordx-listeb.emplacement.coordx;
     Az := j1^.Voiture.emplacement.coordz-listeb.emplacement.coordz;
     d := sqrt(sqr(Ax)+
               sqr(Az));

     Vx := j1.Voiture.orientation.norme*sin(j1.Voiture.orientation.teta);
     Vz := j1.Voiture.orientation.norme*cos(j1.Voiture.orientation.teta);

     pscal := (Vx*Ax + Vz*Az)/d;
     if (d<500)and(pscal>0.80) then
     begin
       map^.MeshQueue := @map^.MeshHead;
       while map^.MeshQueue<>NIL do
       begin
         map^.MeshQueue^.FaceQueue := @map^.MeshQueue^.FaceHead;
         while (map^.MeshQueue^.FaceQueue^.next<>NIL)  do
         begin
           i := interPlanDroite(j1^.Voiture.emplacement, listeb.emplacement, map^.MeshQueue^.FaceQueue);
           if (i.coordx<>0) and
              (i.coordy<>0) and
              (i.coordx<>0) and
               interieur(j1^.Voiture.emplacement, i, listeb.emplacement) then
               if vraicolli(i, map^.MeshQueue^.FaceQueue) then sortie := false;

            map^.MeshQueue^.FaceQueue := map^.MeshQueue^.FaceQueue^.Next;
         end;
         map^.MeshQueue := map^.MeshQueue^.Next;
       end;
       if sortie then retour := listeb;
     end;
     listeb := listeb^.next;
   end;
   result := retour;
end;

//****************************************************************************//
//****************************Champ de force**********************************//
//****************************************************************************//
procedure ChampVV(j1, j2 : T_pJoueur);
var d, Vx, Vz, Ax, Az, pvect, pscal : real;
begin
   Ax := j2^.Voiture.emplacement.coordx-j1^.Voiture.emplacement.coordx;
   Az := j2^.Voiture.emplacement.coordz-j1^.Voiture.emplacement.coordz;

   d := sqrt(sqr(Ax)+sqr(Az));

   Vx := j1.Voiture.orientation.norme*sin(j1.Voiture.orientation.teta);
   Vz := j1.Voiture.orientation.norme*cos(j1.Voiture.orientation.teta);

   pvect := (Vx*Az - Vz*Ax)/d;
   pscal := (Vx*Ax + Vz*Az)/d;

   if (pscal<=-0.97)and(d<80)and not(j2.Mort)and(j1.Timer=5)and
      (j1.Armeselectionne<>@j1.arme_1) then j1^.Tire;
   if pscal>-0.97 then
   if pvect>0 then j1^.Voiture.Gauche
   else j1^.Voiture.Droite;

   if d<40 then j1.Voiture.Stop
   else j1.Voiture.Avance;
end;

procedure ChampVB(j1 : T_pJoueur; listeb : T_pBonus);
var d, Vx, Vz, Ax, Az, pvect, pscal : real;
begin
   Ax := listeb.emplacement.coordx-j1^.Voiture.emplacement.coordx;
   Az := listeb.emplacement.coordz-j1^.Voiture.emplacement.coordz;

   d := sqrt(sqr(Ax)+sqr(Az));

   Vx := j1.Voiture.orientation.norme*sin(j1.Voiture.orientation.teta);
   Vz := j1.Voiture.orientation.norme*cos(j1.Voiture.orientation.teta);

   pvect := (Vx*Az - Vz*Ax)/d;
   pscal := (Vx*Ax + Vz*Az)/d;

   if pscal<0.97 then
   if pvect>0 then j1^.Voiture.Gauche
   else j1^.Voiture.Droite;
   j1.Voiture.Avance;
end;

procedure ChampVM(j1 : T_pJoueur; map : PObjet);
var i, pos : position;
    d, Vx, Vz, Ax, Az, pvect, pscal : real;
     droite : real;
begin
   droite := 0;
   map^.MeshQueue := @map^.MeshHead;
   while map^.MeshQueue<>NIL do
   begin
     map^.MeshQueue^.FaceQueue := @map^.MeshQueue^.FaceHead;
     while (map^.MeshQueue^.FaceQueue^.next<>NIL)  do
     begin
       pos := j1^.Voiture.emplacement;
       pos.Translate(0.0,2.0,0.0);
       i := interOPlanDroite(pos, map^.MeshQueue^.FaceQueue);
       if (i.coordx<>0) or
          (i.coordy<>0) or
          (i.coordx<>0) then
           if vraicolli(i, map^.MeshQueue^.FaceQueue) then
           begin
             Ax := i.coordx-j1^.Voiture.emplacement.coordx;
             Az := i.coordz-j1^.Voiture.emplacement.coordz;
             d := sqrt(sqr(Ax)+
                       sqr(Az));
             if (d<40)and(abs(map^.MeshQueue^.FaceQueue.U.y)<0.1) then
             begin
               Vx := j1.Voiture.vitesse.norme*sin(j1.Voiture.vitesse.teta);
               Vz := j1.Voiture.vitesse.norme*cos(j1.Voiture.vitesse.teta);

               pvect := (Vx*Az - Vz*Ax)/d;
               pscal := (Vx*Ax + Vz*Az)/d;
               if pscal<0.1 then
                 if pvect>0 then Droite := Droite +1/d
                 else Droite:= Droite -1/d;
             end;
           end;
        map^.MeshQueue^.FaceQueue := map^.MeshQueue^.FaceQueue^.Next;
     end;
     map^.MeshQueue := map^.MeshQueue^.Next;
   end;
   if droite<>0 then
   begin
     //j1.Voiture.Stop;
     if Droite>0 then j1^.Voiture.Droite
     else j1^.Voiture.Gauche;
   end;
end;



end.
