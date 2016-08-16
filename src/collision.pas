unit collision;

interface

uses
  opengl,
  SysUtils,
  Windows,
  maths,
  typege;

function interOPlanDroite(p : position; face: PFace) : position;
function interPlanDroite(p, p2 : position; face: PFace) : position;
function interieur(A, B, C : position) : boolean;
function vraicolli(i : position; face : PFace) : boolean;
implementation

//--------------------------------------------------------------------------------------

function max(A, B, C : real) : real;
begin
  if A>B then if A>C then result := A
              else result := C
  else if B>C then result := B
       else result := C;
end;
//--------------------------------------------------------------------------------------

function pretestVM(face : PFace; A : position) : boolean;
begin
   if (face.v[1].x>A.coordx+7) and
      (face.v[2].x>A.coordx+7) and
      (face.v[3].x>A.coordx+7) then result := false
   else if (face.v[1].x<A.coordx-7) and
           (face.v[2].x<A.coordx-7) and
           (face.v[3].x<A.coordx-7) then result := false
   else if (face.v[1].z<A.coordz-7) and
           (face.v[2].z<A.coordz-7) and
           (face.v[3].z<A.coordz-7) then result := false
   else if (face.v[1].z>A.coordz+7) and
           (face.v[2].z>A.coordz+7) and
           (face.v[3].z>A.coordz+7) then result := false
   else result := true;

end;
//--------------------------------------------------------------------------------------

function interieur(A, B, C : position) : boolean;
begin
  result := (abs(A.coordx-B.coordx)+abs(B.coordx-C.coordx)=abs(A.coordx-C.coordx)) and
            (abs(A.coordy-B.coordy)+abs(B.coordy-C.coordy)=abs(A.coordy-C.coordy)) and
            (abs(A.coordz-B.coordz)+abs(B.coordz-C.coordz)=abs(A.coordz-C.coordz));
end;

//--------------------------------------------------------------------------------------

function vraicolli(i : position; face : PFace) : boolean;
var X, Y, Z : real;
    a, b, c : position;
begin
   a.coordx := face^.v[1].x-i.coordx;
   a.coordy := face^.v[1].y-i.coordy;
   a.coordz := face^.v[1].z-i.coordz;
   b.coordx := face^.v[2].x-i.coordx;
   b.coordy := face^.v[2].y-i.coordy;
   b.coordz := face^.v[2].z-i.coordz;
   c.coordx := face^.v[3].x-i.coordx;
   c.coordy := face^.v[3].y-i.coordy;
   c.coordz := face^.v[3].z-i.coordz;
   if max(abs(face^.U.x), abs(face^.U.y), abs(face^.U.z))= abs(face^.U.x) then
   begin
      X := (a.coordz*b.coordy-a.coordy*b.coordz)/(a.coordz-b.coordz);
      Y := (b.coordz*c.coordy-b.coordy*c.coordz)/(b.coordz-c.coordz);
      Z := (c.coordz*a.coordy-c.coordy*a.coordz)/(c.coordz-a.coordz);
      if abs(a.coordz-b.coordz)<abs(a.coordz)+abs(b.coordz) then
        if abs(a.coordz-c.coordz)<abs(a.coordz)+abs(c.coordz) then
          result := false
        else result := abs(y-z)=abs(y)+abs(z)
      else if abs(a.coordz-c.coordz)<abs(a.coordz)+abs(c.coordz) then
             result := abs(y-x)=abs(y)+abs(x)
           else result := abs(z-x)=abs(z)+abs(x);
   end
   else if max(abs(face^.U.x), abs(face^.U.y), abs(face^.U.z))= abs(face^.U.y) then
   begin
      X := (a.coordx*b.coordz-a.coordz*b.coordx)/(a.coordx-b.coordx);
      Y := (b.coordx*c.coordz-b.coordz*c.coordx)/(b.coordx-c.coordx);
      Z := (c.coordx*a.coordz-c.coordz*a.coordx)/(c.coordx-a.coordx);
      if abs(a.coordx-b.coordx)<abs(a.coordx)+abs(b.coordx) then
        if abs(a.coordx-c.coordx)<abs(a.coordx)+abs(c.coordx) then
          result := false
        else result := abs(y-z)=abs(y)+abs(z)
      else if abs(a.coordx-c.coordx)<abs(a.coordx)+abs(c.coordx) then
             result := abs(y-x)=abs(y)+abs(x)
           else result := abs(z-x)=abs(z)+abs(x);
   end
   else if max(abs(face^.U.x), abs(face^.U.y), abs(face^.U.z))= abs(face^.U.z) then
   begin
      X := (a.coordy*b.coordx-a.coordx*b.coordy)/(a.coordy-b.coordy);
      Y := (b.coordy*c.coordx-b.coordx*c.coordy)/(b.coordy-c.coordy);
      Z := (c.coordy*a.coordx-c.coordx*a.coordy)/(c.coordy-a.coordy);
      if abs(a.coordy-b.coordy)<abs(a.coordy)+abs(b.coordy) then
        if abs(a.coordy-c.coordy)<abs(a.coordy)+abs(c.coordy) then
          result := false
        else result := abs(y-z)=abs(y)+abs(z)
      else if abs(a.coordy-c.coordy)<abs(a.coordy)+abs(c.coordy) then
             result := abs(y-x)=abs(y)+abs(x)
           else result := abs(z-x)=abs(z)+abs(x);
   end;
end;

//--------------------------------------------------------------------------------------
function interPlanDroite(p, p2 : position; face: PFace) : position;
var i : position;
    ux, uy, uz : real;
begin
    i.init(0,0,0);
    ux := p.coordx-p2.coordx;
    uy := p.coordy-p2.coordy;
    uz := p.coordz-p2.coordz;
    //risque de danger lorsque 'face.U.x*ux + face.U.y*uy + face.U.z*uz = 0'
    if face.U.x*ux + face.U.y*uy + face.U.z*uz<>0 then
    begin
    i.coordx := (p.coordx*(face.U.y*uy+face.U.z*uz) - ux*(face.U.y*p.coordy+face.U.z*p.coordz+face^.D))
                  /(face.U.x*ux + face.U.y*uy + face.U.z*uz);
    i.coordy := (p.coordy*(face.U.x*ux+face.U.z*uz) - uy*(face.U.x*p.coordx+face.U.z*p.coordz+face^.D))
                  /(face.U.x*ux + face.U.y*uy + face.U.z*uz);
    i.coordz := (p.coordz*(face.U.y*uy+face.U.x*ux) - uz*(face.U.y*p.coordy+face.U.x*p.coordx+face^.D))
                  /(face.U.x*ux + face.U.y*uy + face.U.z*uz);
    end;
    result := i
end;
//--------------------------------------------------------------------------------------
function interOPlanDroite(p : position; face: PFace) : position;
var i : position;
    xn2, yn2, zn2 : real;
begin
    i.init(0,0,0);
    xn2 := sqr(face^.U.x);
    yn2 := sqr(face^.U.y);
    zn2 := sqr(face^.U.z);
    //risque de danger lorsque 'xn2+yn2+zn2 = 0'
    if xn2+yn2+zn2<>0 then
    begin
       i.coordx := (p.coordx*(yn2+zn2)-face^.U.x*(face^.U.y*p.coordy+face^.U.z*p.coordz+face^.D))
                   /(xn2+yn2+zn2);
       i.coordy := (p.coordy*(xn2+zn2)-face^.U.y*(face^.U.x*p.coordx+face^.U.z*p.coordz+face^.D))
                   /(xn2+yn2+zn2);
       i.coordz := (p.coordz*(xn2+yn2)-face^.U.z*(face^.U.x*p.coordx+face^.U.y*p.coordy+face^.D))
                   /(xn2+yn2+zn2);
    end;
    result := i;
end;

end.
