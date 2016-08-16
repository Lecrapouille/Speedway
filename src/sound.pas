unit sound;

interface
uses
  Windows,
  sysutils,
  MMsystem,
  DDirectSound,
  typege,
  lancement,
  DSound,
  Wave;

const
  NBSOUND = 72;  //si vous ajoutez un son n'oubliez pas de modifier la valeur du tableau de TDirectSoundBuffer
                 //dans l'unit 'Boucledejeu'

var
  // variable pour le son.
  DS: TDirectSound;

procedure initsound(var DSB : array of  TDirectSoundBuffer; param :T_param);
procedure InitSilence(var DSB : array of  TDirectSoundBuffer; param :T_param);

implementation
//----------------------------------------------------------------------------//

function NewDirectSoundBuffer( FileName: String;
  var pwfx: PWAVEFORMATEX ): TDirectSoundBuffer;
var
  bd, bd2: Pointer;
  dsbd: TDSBufferDesc;
  Len, Len2: DWord;
  pbData: Pointer;
  cbSize: Longint;
begin
  {Creation d'un buffer de sons}
  WaveLoadFile( Filename, cbSize, pwfx, pbData );
  try
    try
      ZeroMemory( @dsbd, sizeof(dsbd) );
      dsbd.dwSize := sizeof(TDSBUFFERDESC);
      dsbd.dwFlags := DSBCAPS_STATIC;
      dsbd.dwBufferBytes := cbSize;
      dsbd.lpwfxFormat := pwfx;

      Result := TDirectSoundBuffer.Create( DS, dsbd );

      Result.Lock( 0, cbSize, bd, Len, bd2, Len2, 0 );
      try
        CopyMemory( bd, pbData, cbSize );
      finally
        Result.Unlock( bd, cbSize, nil, 0 );
      end;
    except
      on EDirectSoundError do
      begin
        FreeMem( pwfx );
        Result.Free;
        raise;
      end;
    end;
  finally
    FreeMem( pbData );
  end;
end;

//----------------------------------------------------------------------------//
procedure initsound(var DSB : array of  TDirectSoundBuffer; param :T_param);
var
  cnt : integer;
  pwfx: array [0..NBSOUND] of PWAVEFORMATEX;
begin
  {Tableau de buffer de sons encapsule}
  DS := TDirectSound.Create( nil, 0 );
  DS.SetCooperativeLevel( h_wnd, DSSCL_NORMAL);
  for Cnt := 0 to NBSOUND do
  begin
    DSB[Cnt] := NewDirectSoundBuffer('Data/Sons/Sound' + inttostr(1 + Cnt) + '.wav',
    pwfx[Cnt]);
  end;
end;

procedure InitSilence(var DSB : array of  TDirectSoundBuffer; param :T_param);
var
  cnt : integer;
  pwfx: array [0..NBSOUND] of PWAVEFORMATEX;
begin
  {Tableau de buffer de sons encapsule}
  DS := TDirectSound.Create( nil, 0 );
  DS.SetCooperativeLevel( h_wnd, DSSCL_NORMAL);
  for Cnt := 0 to NBSOUND do
  begin
    DSB[Cnt] := NewDirectSoundBuffer('Data/Sons/silence.wav',
    pwfx[Cnt]);
  end;
end;

end.
