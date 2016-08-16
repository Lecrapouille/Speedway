unit maths;


interface

uses
Windows,
  Messages,
  SysUtils,
  OpenGL;

type VecteurPol = object
     norme, teta, fi : GLFloat;
     Procedure Init  (norme1, teta1, fi1 : GLFloat);
     Procedure Inc   (norme1, teta1, fi1 : GLFloat);
     Procedure Somme (v1, v2 : VecteurPol);
end;

type Position = object
     coordx, coordy, coordz : GLFloat;
     Procedure Init (x, y, z : GLFloat);
     Procedure Deplace (v3 : VecteurPol);
     Procedure Translate(x, y, z : GLFloat);
end;

function Distance (point1,point2 : position) : real;
implementation

{Objet Vecteur}
Procedure VecteurPol.Init  (norme1, teta1, fi1 : GLFloat);
begin
norme := norme1;
teta := teta1;
fi := fi1;
end;

Procedure VecteurPol.Inc (norme1, teta1, fi1 : GLFloat);
begin
  norme := norme + norme1;
  teta := teta + teta1;
  fi := fi + fi1;
end;

Procedure VecteurPol.Somme (v1, v2 : VecteurPol);
begin
norme := sqrt(sqr(v1.norme*sin(v1.teta)+v2.norme*sin(v2.teta))+sqr(v1.norme*sin(v1.fi)+v2.norme*sin(v2.fi))+sqr(v1.norme*cos(v1.teta)+v2.norme*cos(v2.teta)));
teta := (v1.teta + v2.teta)/2;
fi := (v1.fi + v2.fi)/2;
end;

{Objet Position}
Procedure Position.Init (x, y, z : GLFloat);
begin
coordx:= x;
coordy:= y;
coordz:= z;
end;

Procedure Position.Deplace (v3 : VecteurPol);
begin
coordx := coordx - v3.norme*sin(v3.teta);
coordy := coordy - v3.norme*sin(v3.fi);
coordz := coordz - v3.norme*cos(v3.teta);
end;

Procedure Position.Translate(x, y, z : GLFloat);
begin
coordx := coordx + x;
coordy := coordy + y;
coordz := coordz + z;
end;

function Distance (point1,point2 : position) : real;
begin
result := sqrt ( sqr (point1.coordx - point2.coordx) +
                 sqr (point1.coordy - point2.coordy) +
                 sqr (point1.coordz - point2.coordz));
end;
end.

