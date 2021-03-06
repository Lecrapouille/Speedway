unit loader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  StdCtrls,
  typege,
  maths,
  GLAUX,
  opengl;


var
  InFile : text;
  buffer : string;

   {D�claration des proc�dures "OpenGL32.dll" utiles au texture car elle
  n'est pas dans le Unit OpenGL.pas}
   Procedure glBindTexture(target: GLEnum;
                           texture: GLuint);
                           Stdcall; External 'OpenGL32.dll';
   Procedure glGenTextures(n: GLsizei;
                           Textures: PGLuint);
                           Stdcall; External 'OpenGL32.dll';
   Procedure glDeleteTextures(n: GLsizei;
                            textures: PGLuint);
                            Stdcall; External 'OpenGL32.dll';

procedure loaderAse(nomfich : string; obj : pObjet);



implementation


Procedure CreerTexture(TAB_CHEMIN_BITMAP : String; obj : pObjet);
{Objectif :Charger un texture en m�moire. Les chemins acc�dant aux textures
           sont pass�s en param�tre.}
Var
   {Pointeur sur une structure PTAUX_RGBImageRec stockant les pixels de l'image}
    pTextures         :PTAUX_RGBImageRec;
   {Message d'erreurs pour les textures non-trouv�e}
    Msg_Erreur        :String;

Begin
    {R�cup�rer le nombre de textures qui seront � g�n�rer}
  //   SetLength(IDTexture, I );

    {G�n�ration de "x" nom pour la texture}
     glGenTextures( 1, @obj^.TextureQueue^.Id);

          {V�rifier si le fichier existe}
          If FileExists( TAB_CHEMIN_BITMAP ) Then
          Begin
               {Charger la texture en m�moire}
               pTextures := auxDIBImageLoadA( PChar(TAB_CHEMIN_BITMAP) );

               {Si fichier bitmap charg� en m�moire alors cr�er la texture}
               If Assigned( pTextures ) Then
               Begin
                    {Charge la texture portant le ID "IDTexture" donc la I i�me}
                    glBindTexture(GL_TEXTURE_2D, obj^.TextureQueue^.Id);

                    {Param�trage d'application de la texture
                     Ici on prend GL_LINEAR du fait que l'application est
                     beaucoup plus net que GL_NEAREST. Fait le changement et
                     vous verrez...}
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
                                    GL_LINEAR);
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
                                    GL_LINEAR);

                    {Type de  combinaison de la texture avec le tampon
                     chronomatique}
                    glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE );

                    {D�finition de la texture 2D}
                    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGB,
                                  pTextures^.SizeX, pTextures^.SizeY,
                                  0, GL_RGB, GL_UNSIGNED_BYTE,
                                  pTextures^.Data);
               End
               Else
                   Begin
                   {Avertir que la texture n'a pue �tre trouv�}
                   Msg_Erreur := 'Erreur au chargement de la texture "' +
                                  TAB_CHEMIN_BITMAP + '"';
                   MessageBox( 0, PChar(Msg_Erreur), 'Textures',
                               MB_OK And MB_ICONWARNING );
              End;
          End
          Else
              Begin
                   {Avertir que la texture n'a pue �tre trouv�}
                   Msg_Erreur := 'Texture : "' + TAB_CHEMIN_BITMAP + '" n''a pas'
                                 + ' �t� trouv�e';
                   MessageBox( 0, PChar(Msg_Erreur), 'Textures',
                               MB_OK And MB_ICONWARNING );
              End;
End;

//----------------------------------------------------------------------------//

function recherche(s2, s1: string) : boolean;
var
  i, j, taille1, taille2 : integer;
begin
  i := 1;
  j := 1;
  taille1 := length(s1);
  taille2 := length(s2);
  while (i<=taille1) and (j<=taille2) do begin
    j := 1;
    while s1[i+j-1]=s2[j] do begin
      j := j+1;
    end;
    i := i+1;
  end;
  result:= j>taille2
end;

//----------------------------------------------------------------------------//

function convertfloat(buffer : string; nbr : integer) : GLFloat;
var retour : GLFloat;
    i, j, V : integer;
begin
   i := 1;
   j := 1;
   while buffer[i]<>'*' do
      inc(i);
   while nbr>0 do
   begin
     while ord(buffer[i])<>$09 do
         inc(i);
     dec(nbr);
     inc(i);
   end;
   while buffer[i+j]<>'.' do
      inc(j);
   inc(j);
   while (ord(buffer[i+j])>=ord('0')) and (ord(buffer[i+j])<=ord('9')) do
     inc(j);
   val(copy(buffer, i, j), retour, V);
   result := retour;
end;
//----------------------------------------------------------------------------//

procedure loadmateriauxlist (obj : pObjet);
var j : integer;
    s1 : string;
begin
  obj^.TextureQueue := @obj^.TextureHead;
  while buffer[1]<>'}' do
  begin
    readln(Infile, buffer);
    if (recherche('*BITMAP ', buffer))then
    begin
       s1 := '';
       j := 0;
       while (j<length(buffer)) and (buffer[j]<>'"') do
            inc(j);
       inc(j);
       while buffer[j]<>'"' do
       begin
         if buffer[j]='\' then
              s1 := '';
         s1 := s1 + buffer[j];
         inc(j);
       end;
       s1 := GetCurrentDir + '\data\textures\' + s1;
       CreerTexture(s1, obj);
       obj^.TextureQueue^.Next := AllocMem(SizeOf(TTexture));
       obj^.TextureQueue := obj^.TextureQueue^.Next;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function loadPvertex(nbr : integer; obj : pObjet) : PVertex;
var i : integer;
begin
       obj^.MeshQueue^.VertexQueue := @obj^.MeshQueue^.VertexHead;
       i := 0;
       while i<nbr do
       begin
          obj^.MeshQueue^.VertexQueue := obj^.MeshQueue^.VertexQueue^.Next;
          inc(i);
       end;
       result := obj^.MeshQueue^.VertexQueue;
end;

//----------------------------------------------------------------------------//

function loadPTex(nbr : integer; obj : pObjet) : PVertex;
var i : integer;
begin
       obj^.MeshQueue^.CoordTextQueue := @obj^.MeshQueue^.CoordTextHead;
       i := 0;
       while i<nbr do
       begin
          obj^.MeshQueue^.CoordTextQueue := obj^.MeshQueue^.CoordTextQueue^.Next;
          inc(i);
       end;
       result := obj^.MeshQueue^.CoordTextQueue;
end;

//----------------------------------------------------------------------------//

procedure loadvertex(obj : pObjet);
begin
  obj^.MeshQueue^.VertexQueue := @obj^.MeshQueue^.VertexHead;
  while not recherche('}', buffer) do
  begin
    readln(Infile, buffer);
    if (recherche('*MESH_VERTEX ', buffer))then
    begin
       obj^.MeshQueue^.VertexQueue^.x := convertfloat(buffer, 1);
       obj^.MeshQueue^.VertexQueue^.z := convertfloat(buffer, 2);
       obj^.MeshQueue^.VertexQueue^.y := convertfloat(buffer, 3);
       obj^.MeshQueue^.VertexQueue^.Next := AllocMem(SizeOf(TVertex));
       obj^.MeshQueue^.VertexQueue := obj^.MeshQueue^.VertexQueue^.Next;
    end;
  end;
  readln(Infile, buffer);
end;

//----------------------------------------------------------------------------//

procedure loadTex(obj : pObjet);
begin
  obj^.MeshQueue^.CoordTextQueue := @obj^.MeshQueue^.CoordTextHead;
  while not recherche('}', buffer) do
  begin
    readln(Infile, buffer);
    if (recherche('*MESH_TVERT ', buffer))then
    begin
       obj^.MeshQueue^.CoordTextQueue^.x := convertfloat(buffer, 1);
       obj^.MeshQueue^.CoordTextQueue^.y := convertfloat(buffer, 2);
       obj^.MeshQueue^.CoordTextQueue^.z := convertfloat(buffer, 3);
       obj^.MeshQueue^.CoordTextQueue^.Next := AllocMem(SizeOf(TVertex));
       obj^.MeshQueue^.CoordTextQueue := obj^.MeshQueue^.CoordTextQueue^.Next;
    end;
  end;
  readln(Infile, buffer);
end;

//----------------------------------------------------------------------------//

procedure loadface(obj : pobjet);
var
    i, j, valeur, V : integer;
begin
  obj^.MeshQueue^.FaceQueue := @obj^.MeshQueue^.FaceHead;
  while not recherche('}', buffer) do
  begin
    readln(Infile, buffer);
    if (recherche('*MESH_FACE ', buffer))then
    begin
       i := 1;
       j := 1;
       while (buffer[i]<>'A') or (buffer[i+1]<>':') do
          inc(i);
       i := i+2;
       while buffer[i]=' ' do
          inc(i);
       while buffer[i+j]<>' ' do
          inc(j);
       val(copy(buffer, i, j), valeur, V);
       obj^.MeshQueue^.FaceQueue^.v[1] := loadPvertex(valeur, obj);

       j := 1;
       while (buffer[i]<>'B') and (buffer[i+1]<>':') do
          inc(i);
       i := i+2;
       while buffer[i]=' ' do
          inc(i);
       while buffer[i+j]<>' ' do
          inc(j);
       val(copy(buffer, i, j), valeur, V);
       obj^.MeshQueue^.FaceQueue^.v[2] := loadPvertex(valeur, obj);

       j := 1;
       while (buffer[i]<>'C') and (buffer[i+1]<>':') do
          inc(i);
       i := i+2;
       while buffer[i]=' ' do
          inc(i);
       while buffer[i+j]<>' ' do
          inc(j);
       val(copy(buffer, i, j), valeur, V);
       obj^.MeshQueue^.FaceQueue^.v[3] := loadPvertex(valeur, obj);

       obj^.MeshQueue^.FaceQueue^.Next := AllocMem(SizeOf(TFace));
       obj^.MeshQueue^.FaceQueue := obj^.MeshQueue^.FaceQueue^.Next;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure loadnormal(obj : pobjet);
var v, w : position;
    l : real;
begin
  obj^.MeshQueue^.FaceQueue := @obj^.MeshQueue^.FaceHead;
  while obj^.MeshQueue^.FaceQueue^.Next<>NIL do
  begin
     v.coordx := obj^.MeshQueue^.FaceQueue^.v[1].x - obj^.MeshQueue^.FaceQueue^.v[2].x;
     v.coordy := obj^.MeshQueue^.FaceQueue^.v[1].y - obj^.MeshQueue^.FaceQueue^.v[2].y;
     v.coordz := obj^.MeshQueue^.FaceQueue^.v[1].z - obj^.MeshQueue^.FaceQueue^.v[2].z;
     w.coordx := obj^.MeshQueue^.FaceQueue^.v[1].x - obj^.MeshQueue^.FaceQueue^.v[3].x;
     w.coordy := obj^.MeshQueue^.FaceQueue^.v[1].y - obj^.MeshQueue^.FaceQueue^.v[3].y;
     w.coordz := obj^.MeshQueue^.FaceQueue^.v[1].z - obj^.MeshQueue^.FaceQueue^.v[3].z;
     obj^.MeshQueue^.FaceQueue^.U.x := v.coordy * w.coordz - v.coordz * w.coordy;
     obj^.MeshQueue^.FaceQueue^.U.y := v.coordz * w.coordx - v.coordx * w.coordz;
     obj^.MeshQueue^.FaceQueue^.U.z := v.coordx * w.coordy - v.coordy * w.coordx;
     l := sqrt(sqr(obj^.MeshQueue^.FaceQueue^.U.x)+
               sqr(obj^.MeshQueue^.FaceQueue^.U.y)+
               sqr(obj^.MeshQueue^.FaceQueue^.U.z));
     obj^.MeshQueue^.FaceQueue^.U.x := obj^.MeshQueue^.FaceQueue^.U.x/l;
     obj^.MeshQueue^.FaceQueue^.U.y := obj^.MeshQueue^.FaceQueue^.U.y/l;
     obj^.MeshQueue^.FaceQueue^.U.z := obj^.MeshQueue^.FaceQueue^.U.z/l;

     obj^.MeshQueue^.FaceQueue^.D := -(obj^.MeshQueue^.FaceQueue^.U.x*obj^.MeshQueue^.FaceQueue^.v[2].x+
                                       obj^.MeshQueue^.FaceQueue^.U.y*obj^.MeshQueue^.FaceQueue^.v[2].y+
                                       obj^.MeshQueue^.FaceQueue^.U.z*obj^.MeshQueue^.FaceQueue^.v[2].z);
     if (obj^.MeshQueue^.FaceQueue^.U.z=0) and
        (obj^.MeshQueue^.FaceQueue^.U.x=0) and
        (obj^.MeshQueue^.FaceQueue^.U.y=0) then MessageBox( 0,
        PChar('dans Loader.pas procedure loadnormal(ob :pobjet), normale 0'),'WARNING', MB_OK And MB_ICONWARNING );;
     obj^.MeshQueue^.FaceQueue := obj^.MeshQueue^.FaceQueue^.Next;
  end;
end;

//----------------------------------------------------------------------------//

procedure loadTexFace(obj : pobjet);
var
    i, j, valeur, V : integer;
begin
  obj^.MeshQueue^.FaceQueue := @obj^.MeshQueue^.FaceHead;
  while not recherche('}', buffer) do
  begin
    readln(Infile, buffer);
    if (recherche('*MESH_TFACE ', buffer))then
    begin
       i := 1;
       j := 1;
       while buffer[i]<>'*' do
          inc(i);
       while buffer[i]<>#09 do
          inc(i);
       inc(i);
       while (ord(buffer[i+j])>=ord('0')) and (ord(buffer[i+j])<=ord('9')) do
          inc(j);
       val(copy(buffer, i, j), valeur, V);
       obj^.MeshQueue^.FaceQueue^.TextCoord[1] := loadPTex(valeur, obj);

       i := i+j+1;
       j := 1;
       while (ord(buffer[i+j])>=ord('0')) and (ord(buffer[i+j])<=ord('9')) do
          inc(j);
       val(copy(buffer, i, j), valeur, V);
       obj^.MeshQueue^.FaceQueue^.TextCoord[2] := loadPTex(valeur, obj);

       i := i+j+1;
       j := 1;
       while (ord(buffer[i+j])>=ord('0')) and (ord(buffer[i+j])<=ord('9')) do
          inc(j);
       val(copy(buffer, i, j), valeur, V);
       obj^.MeshQueue^.FaceQueue^.TextCoord[3] := loadPTex(valeur, obj);

       obj^.MeshQueue^.FaceQueue := obj^.MeshQueue^.FaceQueue^.Next;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure loadMesh (obj : pobjet);
var
    i, j, valeur, V : integer;
begin
  obj^.MeshQueue := @Obj^.MeshHead;
  while not EOF(InFile) do
  begin
    readln(Infile, buffer);

    if (recherche('*MESH_VERTEX_LIST {', buffer))then loadvertex(obj);
    if (recherche('*MESH_FACE_LIST {', buffer))then
    begin
      loadface(obj);
      loadnormal(obj);
    end;
    if (recherche('*MESH_TVERTLIST {', buffer))then loadTex(obj);
    if (recherche('*MESH_TFACELIST {', buffer))then loadTexFace(obj);
    if (recherche('*MATERIAL_REF ', buffer))then
    begin
       i := 1;
       j := 1;
       while (ord(buffer[i])<ord('0')) or (ord(buffer[i])>ord('9')) do
           inc(i);
       while (ord(buffer[i+j])>=ord('0')) and (ord(buffer[i+j])<=ord('9')) do
           inc(j);
       val(copy(buffer, i, j), valeur, V);
       obj^.TextureQueue := @obj^.TextureHead;
       while valeur>0 do
       begin
          obj^.TextureQueue := obj^.TextureQueue^.Next;
          dec(valeur);
       end;
       obj^.MeshQueue^.Texture := obj^.TextureQueue;
    end;
    if recherche('*MESH {',buffer) then
    begin
       obj^.MeshQueue^.Next := AllocMem(SizeOf(TMesh));
       obj^.MeshQueue := obj^.MeshQueue^.Next;
    end;
  end;
end;


//----------------------------------------------------------------------------//

procedure loaderAse(nomfich : string; obj : pobjet);
begin
  AssignFile(InFile, nomfich);
  Reset(InFile);
  while not EOF(InFile) do
  begin
    readln(Infile, buffer);

    if (recherche('*MATERIAL_LIST {', buffer))then loadmateriauxlist(obj);
    if (recherche('*MESH {', buffer))then loadmesh(obj);

  end;
  CloseFile(InFile);
  obj.List := glGenLists(1);
glNewList(obj.list,GL_COMPILE);

   glpushmatrix;
       glEnable(GL_TEXTURE_2D);
       Obj.MeshQueue := @Obj.MeshHead;
       while Obj.MeshQueue<>NIL do
       begin
          Obj^.MeshQueue^.FaceQueue := @Obj^.MeshQueue^.FaceHead;

          {S�lection de la premi�re texture}
          glBindTexture( GL_TEXTURE_2D, Obj^.MeshQueue^.Texture^.Id );

              glBegin(GL_TRIANGLES);
                    while Obj^.MeshQueue^.FaceQueue^.Next<>NIL do
                    begin
                       //glColor3f( 0.0 , 0.0 , 0.0 );
                       glTexCoord3f( Obj^.MeshQueue^.FaceQueue^.TextCoord[1].x,
                                     Obj^.MeshQueue^.FaceQueue^.TextCoord[1].y,
                                     Obj^.MeshQueue^.FaceQueue^.TextCoord[1].z );
                       glVertex3f(Obj^.MeshQueue^.FaceQueue^.v[1].x,
                                  Obj^.MeshQueue^.FaceQueue^.v[1].y,
                                  Obj^.MeshQueue^.FaceQueue^.v[1].z );
                       glTexCoord3f( Obj^.MeshQueue^.FaceQueue^.TextCoord[2].x,
                                     Obj^.MeshQueue^.FaceQueue^.TextCoord[2].y,
                                     Obj^.MeshQueue^.FaceQueue^.TextCoord[2].z );
                       glVertex3f(Obj^.MeshQueue^.FaceQueue^.v[2].x,
                                  Obj^.MeshQueue^.FaceQueue^.v[2].y,
                                  Obj^.MeshQueue^.FaceQueue^.v[2].z );
                       glTexCoord3f( Obj^.MeshQueue^.FaceQueue^.TextCoord[3].x,
                                     Obj^.MeshQueue^.FaceQueue^.TextCoord[3].y,
                                     Obj^.MeshQueue^.FaceQueue^.TextCoord[3].z );
                       glVertex3f(Obj^.MeshQueue^.FaceQueue^.v[3].x,
                                  Obj^.MeshQueue^.FaceQueue^.v[3].y,
                                  Obj^.MeshQueue^.FaceQueue^.v[3].z );
                       Obj^.MeshQueue^.FaceQueue := Obj^.MeshQueue^.FaceQueue^.Next;
                    end;
              glEnd();
          Obj^.MeshQueue := Obj^.MeshQueue^.Next;
   end;
   glDisable(GL_TEXTURE_2D);
   glpopmatrix;
glEndList;
end;

//----------------------------------------------------------------------------//
end.

