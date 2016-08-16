unit caractere;

interface

USES
opengl,
Windows,
SysUtils,
Repere,
Messages;

procedure glTexte(posx,posy, colorr,colorg,colorb : glfloat; texte : string);
function IntTopChar( i : integer): pChar;
//procedure texte(str : string);
function StringTopChar(str : String) : pChar;

VAR
base : Gluint;
h_DC : HDC;

implementation


//----------------------------------------------------------------------------//

procedure KillFont;
begin
  glDeleteLists(base, 96);
end;

//----------------------------------------------------------------------------//

procedure glPrint(text : pchar);
begin
  if (text = '') then
          Exit;
  glPushMatrix;
    glListBase(base - 32);
    glCallLists(length(text), GL_UNSIGNED_BYTE, text);
  glPopMatrix;
end;

procedure glTexte(posx,posy, colorr,colorg,colorb : glfloat; texte : string);
begin
glPushMatrix;
  OrthoMode(0,0,1024,768);
  glColor3f(colorr, colorg, colorb);
  glDisable(GL_DEPTH_TEST);


  glRasterpos2f(posx,posy);
  glPrint(@texte[1]);


  glEnable(GL_DEPTH_TEST);

  PerspectiveMode;
glPopMatrix;
end;
//----------------------------------------------------------------------------//

function IntTopChar( i : integer): pChar;
var
tmp : pChar;
begin
tmp := 'i';
result := tmp;
end;
//----------------------------------------------------------------------------//
function StringTopChar(str : String) : pChar;
var
tmp : pChar;
begin
tmp := @str;
result := tmp;
end;

end.

