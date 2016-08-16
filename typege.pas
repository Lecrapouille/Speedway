unit typege;

interface

uses
  opengl,
  maths;

type
////////////////////////////////////
T_chaine = record
  x, y, z : integer;
end;
////////////////////////////////////
T_Modele = (Tjoel, Tpriscillien, Tquentin, Troman, Tpelleteuse);
////////////////////////////////////
T_BSphere = record
      rayon : real;
   end;
T_BBox = record
     tab : array [0..3] of position;
   end;
////////////////////////////////////
  T_config = record
     BotsAmis : integer;
     BotsNeutre : integer;
     BotsEnnemis : integer;
     TypeAmis : integer;
     TypeEnnemis : integer;
     TypeNeutres : integer;
     ia : integer;
     voiture : T_Modele;
     neutres : T_Modele;
     goodies : T_Modele;
     badies : T_Modele;
     carte : integer;
  end;

  T_video = record
     FullScreen : Boolean;
     Width  : Integer;
     Height : Integer;
     PixelDepth : Integer;
     fog : boolean;
  end;

  T_param = record
     config : T_config;
     video : T_video;
     police : integer;
     VitesseJeu : real;
     Frottement : real;
     FrequenceTirs : integer;
     FrequenceEclair : integer;
     DureeEblouit : integer;
     NbParticules : integer;
     radar : boolean;
     Orage,AmbianceSonore,SonON : boolean;
     AmbiancePluie : boolean;
     
  end;
//////////////////////////////////
  pVertex = ^TVertex;
  TVertex = record
    x, y, z : glFloat;
    Next : pVertex;
    end;

  TNormale = record
    x, y, z : glFloat;
    end;

  pFace = ^TFace;
  TFace = record
    v : array[1..3] of pVertex;
    TextCoord : array[1..3] of pVertex;
    U  : TNormale;
    D : GLFloat;
    Next : pFace;
    end;

  pTexture = ^TTexture;
  TTexture = record
    Id : GLuint;
    Next : pTexture;
    end;

  pMesh = ^TMesh;
  TMesh = record
    VertexHead : TVertex;
    VertexQueue : pVertex;
    FaceHead : TFace;
    FaceQueue : pFace;
    CoordTextHead : TVertex;
    CoordTextQueue : pVertex;
    Texture : pTexture;
    Next : pMesh;
    end;

  pObjet = ^TObjet;
  TObjet = record
    MeshHead : TMesh;
    MeshQueue : pMesh;
    TextureHead : TTexture;
    TextureQueue : pTexture;
    List : GLUint;
    end;

implementation

end.
