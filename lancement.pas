unit lancement;

interface

uses
  Windows,
  Messages,
  Opengl,
  repere,
  Hud,
  Sysutils,
  typege,
  bmp,
  caractere;

const
  WND_TITLE = 'SPEEDWAY';
  FPS_TIMER = 1;                     // Timer to calculate FPS
  FPS_INTERVAL = 500;               // Calculate FPS every 1000 ms

var
  h_Wnd  : HWND;                       // Global window handle
  h_DC   : HDC;                        // Global device context
  h_RC   : HGLRC;                      // OpenGL rendering context
  keys   : Array[0..255] of Boolean;   // Holds keystrokes
  FPSCount : Integer = 0;              // Counter for FPS


function glCreateWnd(param : T_param) : Boolean;

procedure glKillWnd(Width, Height : Integer; Fullscreen : Boolean);

implementation
//----------------------------------------------------------------------------//
procedure loading(Width, Height : integer; nom : string);
var Texture: GLuint;
begin
  LoadTexture(GetCurrentDir + '\data\textures\' + nom, Texture);
  glClearColor(0.0, 0.0, 0.0, 0.0);

  glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  //glDepthMask(GL_FALSE);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, Texture);
  glPushMatrix;
    OrthoMode(0,0,Width,Height);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0,1.0);             glVertex2f(Width/4,Height/3);
      glTexCoord2f(1.0,1.0);             glVertex2f(Width/4*3,Height/3);
      glTexCoord2f(1.0,0.0);             glVertex2f(Width/4*3,Height/3*2);
      glTexCoord2f(0.0,0.0);             glVertex2f(Width/4,Height/3*2);
    glEnd;
    PerspectiveMode;
  glPopMatrix;
//  glDepthMask(GL_TRUE);
  glDisable(GL_TEXTURE_2D);
  SwapBuffers(h_DC);

end;


{------------------------------------------------------------------}
{  Initialise OpenGL                                               }
{------------------------------------------------------------------}
procedure InitialisationOpengl(Width: GLsizei; Height: GLsizei; fog : boolean);
var
fWidth, fHeight  : GLfloat;
fogColor : array [0..3] of GLfloat;
begin
  fogcolor[0] := 0.7;
  fogcolor[1] := 0.7;
  fogcolor[2] := 0.7;
  fogcolor[3] := 0.0;
//  glClearColor(0.7, 0.7, 0.7, 0.0); 	                // Background
glClearColor(0.0, 0.0, 0.0, 1.0); 	   // Black Background


  glClearDepth(1.0);				        // Enables Clearing Of The Depth Buffer
  glDepthFunc(GL_LESS);				        // The Type Of Depth Test To Do
  glEnable(GL_DEPTH_TEST);			        // Enables Depth Testing
  glShadeModel(GL_SMOOTH);			        // Enables Smooth Color Shading
  glDisable(GL_DEPTH_TEST);			       	// Disable Depth Testing
  glEnable(GL_BLEND);				       	// Enable Blending
  glBlendFunc(GL_SRC_ALPHA,GL_ONE);
  glDisable(Gl_BLEND);

  if fog then
  begin
    glFogi(GL_FOG_MODE, GL_LINEAR);				// This is an exponentional method (nice)
    glFogfv(GL_FOG_COLOR, @fogColor);			// Sets Fog Color
    glFogf(GL_FOG_DENSITY, 0.01);		                // How dense the fog will be
    glHint(GL_FOG_HINT, GL_NICEST);			// Let openGL choose the quality of the fog
    glFogf(GL_FOG_START, 0.1);				// Fog Start Depth
    glFogf(GL_FOG_END, 1000.0);				// Fog End Depth
    glDisable(GL_FOG);
  end;

  glHint(GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST);	// Really Nice Perspective Calculations
  glMatrixMode(GL_PROJECTION);			        // Select The Projection Matrix
  glLoadIdentity();				        // Reset The Projection Matrix							// Reset The Projection Matrix

  fWidth := Width;
  fHeight := Height;
  gluPerspective(45.0, fWidth/fHeight,0.1,1000.0);	// Calculate The Aspect Ratio Of The Window
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);   //Realy Nice perspective calculations

  glMatrixMode(GL_MODELVIEW);				// Select The Modelview Matrix
end;
//----------------------------------------------------------------------------//


function IntToStr(Num : Integer) : String;
begin
  Str(Num, result);
end;
//----------------------------------------------------------------------------//
procedure BuildFont( police : integer);
var font: HFONT;
begin
  base := glGenLists(96);
  font := CreateFont(-1* police,
		     0,
		     0,
		     0,
		     FW_BOLD,
		     0,
		     0,
		     0,
		     ANSI_CHARSET,
		     OUT_TT_PRECIS,
		     CLIP_DEFAULT_PRECIS,
		     ANTIALIASED_QUALITY,
		     FF_DONTCARE or DEFAULT_PITCH,
		     'Courier New');

  SelectObject(h_DC, font);

  wglUseFontBitmaps(h_DC, 32, 96, base);
end;
//----------------------------------------------------------------------------//
//  Handle window resize                                                      //
//----------------------------------------------------------------------------//
procedure glResizeWnd(Width, Height : Integer);
begin
  if (Height = 0) then                // prevent divide by zero exception
    Height := 1;
  glViewport(0, 0, Width, Height);    // Set the viewport for the OpenGL window
  glMatrixMode(GL_PROJECTION);        // Change Matrix Mode to Projection
  glLoadIdentity();                   // Reset View
  gluPerspective(45.0, Width/Height, 1.0, 3000.0);  // Do the perspective calculations. Last value = max clipping depth    QQ

  glMatrixMode(GL_MODELVIEW);         // Return to the modelview matrix
  glLoadIdentity();                   // Reset View
end;

//----------------------------------------------------------------------------//
//  Determines the application’s response to the messages received            //
//----------------------------------------------------------------------------//
function WndProc(hWnd: HWND; Msg: UINT;  wParam: WPARAM;  lParam: LPARAM): LRESULT; stdcall;
begin
  case (Msg) of
    WM_CREATE:
      begin
        // Insert stuff you want executed when the program starts
      end;
    WM_CLOSE:
      begin
        PostQuitMessage(0);
        Result := 0
      end;
    WM_KEYDOWN:       // Set the pressed key (wparam) to equal true so we can check if its pressed
      begin
        keys[wParam] := True;
        Result := 0;
      end;
    WM_KEYUP:         // Set the released key (wparam) to equal false so we can check if its pressed
      begin
        keys[wParam] := False;
        Result := 0;
      end;
    WM_SIZE:          // Resize the window with the new width and height
      begin
        glResizeWnd(LOWORD(lParam),HIWORD(lParam));
        Result := 0;
      end;
{$IFDEF DEV}
    WM_TIMER :                     // Add code here for all timers to be used.
      begin
        if wParam = FPS_TIMER then
        begin
          FPSCount :=Round(FPSCount * 1000/FPS_INTERVAL);   // calculate to get per Second incase intercal is less or greater than 1 second
          SetWindowText(h_Wnd, PChar(WND_TITLE + '   [' + intToStr(FPSCount) + ' FPS]' + '   Time : ' + intToStr(ElapsedTime DIV 1000) + '.' + intToStr(ElapsedTime MOD 1000)));
          FPSCount := 0;
          Result := 0;
        end;
      end;
{$ENDIF}
    else
      Result := DefWindowProc(hWnd, Msg, wParam, lParam);    // Default result if nothing happens
  end;
end;


//----------------------------------------------------------------------------//
//  Properly destroys the window created at startup (no memory leaks)         //
//----------------------------------------------------------------------------//
procedure glKillWnd(Width, Height : Integer;Fullscreen : Boolean);
begin
  sleep(3000);
  if Fullscreen then             // Change back to non fullscreen
  begin
    ChangeDisplaySettings(devmode(nil^), 0);
    ShowCursor(true);
  end;

  // Makes current rendering context not current, and releases the device
  // context that is used by the rendering context.
  if (not wglMakeCurrent(h_DC, 0)) then
    MessageBox(0, 'Release of DC and RC failed!', 'Error', MB_OK or MB_ICONERROR);

  // Attempts to delete the rendering context
  if (not wglDeleteContext(h_RC)) then
  begin
    MessageBox(0, 'Release of rendering context failed!', 'Error', MB_OK or MB_ICONERROR);
    h_RC := 0;
  end;

  // Attemps to release the device context
  if ((h_DC = 1) and (ReleaseDC(h_Wnd, h_DC) <> 0)) then
  begin
    MessageBox(0, 'Release of device context failed!', 'Error', MB_OK or MB_ICONERROR);
    h_DC := 0;
  end;

  // Attempts to destroy the window
  if ((h_Wnd <> 0) and (not DestroyWindow(h_Wnd))) then
  begin
    MessageBox(0, 'Unable to destroy window!', 'Error', MB_OK or MB_ICONERROR);
    h_Wnd := 0;
  end;

  // Attempts to unregister the window class
  if (not UnRegisterClass('OpenGL', hInstance)) then
  begin
    MessageBox(0, 'Unable to unregister window class!', 'Error', MB_OK or MB_ICONERROR);
    hInstance := 0;
  end;
end;


//----------------------------------------------------------------------------//
//  Creates the window and attaches a OpenGL rendering context to it          //
//----------------------------------------------------------------------------//

function glCreateWnd(param : T_param) : Boolean;
var
  wndClass : TWndClass;         // Window class
  dwStyle : DWORD;              // Window styles
  dwExStyle : DWORD;            // Extended window styles
  dmScreenSettings : DEVMODE;   // Screen settings (fullscreen, etc...)
  PixelFormat : GLuint;         // Settings for the OpenGL rendering
  h_Instance : HINST;           // Current instance
  pfd : TPIXELFORMATDESCRIPTOR;  // Settings for the OpenGL window            
begin
  h_Instance := GetModuleHandle(nil);       //Grab An Instance For Our Window
  ZeroMemory(@wndClass, SizeOf(wndClass));  // Clear the window class structure

  with wndClass do                    // Set up the window class
  begin
    style         := CS_HREDRAW or    // Redraws entire window if length changes
                     CS_VREDRAW or    // Redraws entire window if height changes
                     CS_OWNDC;        // Unique device context for the window
    lpfnWndProc   := @WndProc;        // Set the window procedure to our func WndProc
    hInstance     := h_Instance;
    hCursor       := LoadCursor(0, IDC_ARROW);
    lpszClassName := 'OpenGL';
  end;

  if (RegisterClass(wndClass) = 0) then  // Attemp to register the window class
  begin
    MessageBox(0, 'Failed to register the window class!', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit
  end;

  // Change to fullscreen if so desired
  if param.video.Fullscreen then
  begin
    ZeroMemory(@dmScreenSettings, SizeOf(dmScreenSettings));
    with dmScreenSettings do begin              // Set parameters for the screen setting
      dmSize       := SizeOf(dmScreenSettings);
      dmPelsWidth  := param.video.Width;                    // Window width
      dmPelsHeight := param.video.Height;                   // Window height
      dmBitsPerPel := param.video.PixelDepth;               // Window color depth
      dmFields     := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL;
    end;

    // Try to change screen mode to fullscreen
    if (ChangeDisplaySettings(dmScreenSettings, CDS_FULLSCREEN) = DISP_CHANGE_FAILED) then
    begin
      MessageBox(0, 'Unable to switch to fullscreen!', 'Error', MB_OK or MB_ICONERROR);
      param.video.Fullscreen := False;
    end;
  end;

  // If we are still in fullscreen then
  if (param.video.Fullscreen) then
  begin
    dwStyle := WS_POPUP or                // Creates a popup window
               WS_CLIPCHILDREN            // Doesn't draw within child windows
               or WS_CLIPSIBLINGS;        // Doesn't draw within sibling windows
    dwExStyle := WS_EX_APPWINDOW;         // Top level window
    ShowCursor(False);                    // Turn of the cursor (gets in the way)
  end
  else
  begin
    dwStyle := WS_OVERLAPPEDWINDOW or     // Creates an overlapping window
               WS_CLIPCHILDREN or         // Doesn't draw within child windows
               WS_CLIPSIBLINGS;           // Doesn't draw within sibling windows
    dwExStyle := WS_EX_APPWINDOW or       // Top level window
                 WS_EX_WINDOWEDGE;        // Border with a raised edge
  end;

  // Attempt to create the actual window
  h_Wnd := CreateWindowEx(dwExStyle,      // Extended window styles
                          'OpenGL',       // Class name
                          WND_TITLE,      // Window title (caption)
                          dwStyle,        // Window styles
                          0, 0,           // Window position
                          param.video.Width, param.video.Height,  // Size of window
                          0,              // No parent window
                          0,              // No menu
                          h_Instance,     // Instance
                          nil);           // Pass nothing to WM_CREATE
  if h_Wnd = 0 then
  begin
    glKillWnd(param.video.Width, param.video.Height, param.video.Fullscreen);                // Undo all the settings we've changed
    MessageBox(0, 'Unable to create window!', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  // Try to get a device context
  h_DC := GetDC(h_Wnd);
  if (h_DC = 0) then
  begin
    glKillWnd(param.video.Width, param.video.Height, param.video.Fullscreen);
    MessageBox(0, 'Unable to get a device context!', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  // Settings for the OpenGL window
  with pfd do
  begin
    nSize           := SizeOf(TPIXELFORMATDESCRIPTOR); // Size Of This Pixel Format Descriptor
    nVersion        := 1;                    // The version of this data structure
    dwFlags         := PFD_DRAW_TO_WINDOW    // Buffer supports drawing to window
                       or PFD_SUPPORT_OPENGL // Buffer supports OpenGL drawing
                       or PFD_DOUBLEBUFFER;  // Supports double buffering
    iPixelType      := PFD_TYPE_RGBA;        // RGBA color format
    cColorBits      := param.video.PixelDepth;           // OpenGL color depth
    cRedBits        := 0;                    // Number of red bitplanes
    cRedShift       := 0;                    // Shift count for red bitplanes
    cGreenBits      := 0;                    // Number of green bitplanes
    cGreenShift     := 0;                    // Shift count for green bitplanes
    cBlueBits       := 0;                    // Number of blue bitplanes
    cBlueShift      := 0;                    // Shift count for blue bitplanes
    cAlphaBits      := 0;                    // Not supported
    cAlphaShift     := 0;                    // Not supported
    cAccumBits      := 0;                    // No accumulation buffer
    cAccumRedBits   := 0;                    // Number of red bits in a-buffer
    cAccumGreenBits := 0;                    // Number of green bits in a-buffer
    cAccumBlueBits  := 0;                    // Number of blue bits in a-buffer
    cAccumAlphaBits := 0;                    // Number of alpha bits in a-buffer
    cDepthBits      := 16;                   // Specifies the depth of the depth buffer
    cStencilBits    := 0;                    // Turn off stencil buffer
    cAuxBuffers     := 0;                    // Not supported
    iLayerType      := PFD_MAIN_PLANE;       // Ignored
    bReserved       := 0;                    // Number of overlay and underlay planes
    dwLayerMask     := 0;                    // Ignored
    dwVisibleMask   := 0;                    // Transparent color of underlay plane
    dwDamageMask    := 0;                     // Ignored
  end;

  // Attempts to find the pixel format supported by a device context that is the best match to a given pixel format specification.
  PixelFormat := ChoosePixelFormat(h_DC, @pfd);
  if (PixelFormat = 0) then
  begin
    glKillWnd(param.video.Width, param.video.Height, param.video.Fullscreen);
    MessageBox(0, 'Unable to find a suitable pixel format', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  // Sets the specified device context's pixel format to the format specified by the PixelFormat.
  if (not SetPixelFormat(h_DC, PixelFormat, @pfd)) then
  begin
    glKillWnd(param.video.Width, param.video.Height, param.video.Fullscreen);
    MessageBox(0, 'Unable to set the pixel format', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  // Create a OpenGL rendering context
  h_RC := wglCreateContext(h_DC);
  if (h_RC = 0) then
  begin
    glKillWnd(param.video.Width, param.video.Height, param.video.Fullscreen);
    MessageBox(0, 'Unable to create an OpenGL rendering context', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  // Makes the specified OpenGL rendering context the calling thread's current rendering context
  if (not wglMakeCurrent(h_DC, h_RC)) then
  begin
    glKillWnd(param.video.Width, param.video.Height, param.video.Fullscreen);
    MessageBox(0, 'Unable to activate OpenGL rendering context', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  // Initializes the timer used to calculate the FPS
{$IFDEF DEV}
  SetTimer(h_Wnd, FPS_TIMER, FPS_INTERVAL, nil);
{$ENDIF}

  // Settings to ensure that the window is the topmost window
  ShowWindow(h_Wnd, SW_SHOW);
  SetForegroundWindow(h_Wnd);
  SetFocus(h_Wnd);

  // Ensure the OpenGL window is resized properly
  InitialisationOpengl(param.video.Width, param.video.Height, param.video.fog);
  glResizeWnd(param.video.Width, param.video.Height);


  loading(param.video.Width, param.video.Height, 'chargement.bmp');
  BuildFont(param.police);
  Result := True;
end;
//----------------------------------------------------------------------------//



end.
