unit UnitRoutines;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants
  , FMX.Edit, FMX.ListBox, FMX.Controls, FMX.Forms, IdHashMessageDigest, FMX.Layouts
  , UnitProgressDialog;


type
  TOnExecute = reference to procedure;

type
  TExecuteThread = class(TThread)
    public
      var
      OnExecute: TOnExecute;
      ProgressDialog: TFrameProgressDialog;
      constructor Create(ProgressDialog: TFrameProgressDialog; OnExecute: TOnExecute); reintroduce;
      procedure CloseProgressDialog;
    protected
      procedure Execute; Override;
  end;

procedure SetTextUpperCaseEditChange(Sender: TObject);
procedure AllowJustLettersEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);

function GetJustNumbersOfString(Value: String): String;

function GetJustLettersOfString(Value: String): String;

function FormatValue(Value : Double): String;

function Max(x, y: Integer): Integer;

function Min(x, y: Integer): Integer;

procedure ValidateValueComponent(Control: TControl; Value: String; Msg : String = 'Valor obrigatório'; QuantityCaracters: Integer = 0); overload;
procedure ValidateValueComponent(Control: TControl; Value: Double; Msg : String = 'Valor obrigatório'); overload;
procedure ValidateValueComponent(Control: TControl; Value: Integer; Msg : String = 'Valor obrigatório'); overload;

function StrToDateTimeFromWebService(DateTime : String): TDatetime;

procedure Show(Form: TForm);

function ValidateEmail(EMail: String):Boolean;

function ValidateCPF(CPF: string): boolean;

function GenerateMD5(Value: String): String;

procedure ExecuteAsync(Layout: TLayout; OnExecute: TOnExecute);
procedure CloseProgressDialog(ProgressDialog: TFrameProgressDialog);

implementation

procedure SetTextUpperCaseEditChange(Sender: TObject);
begin
  (Sender as TEdit).Text := AnsiUpperCase((Sender as TEdit).Text);
end;

procedure AllowJustLettersEditKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin

  {$IFDEF Android}
  if not CharInSet(Key, ['A'..'Z','a'..'z', ' ']) then
    KeyChar := #0;
  {$ENDIF}

  {$IFDEF Win32 or Win64}
  if not (KeyChar in ['A'..'Z', 'a'..'z', ' ']) then
    KeyChar := #0;
  {$ENDIF}
end;

function GetJustNumbersOfString(Value: String): String;
var
I : Integer;
begin
  Result := '';

  {$IFDEF Android}
  for I := 0 to Value.Length do
  {$ELSE}
  for I := 1 to Value.Length do
  {$ENDIF}
  begin
    if (Value[I] in ['0'..'9']) then
      Result := Result + Value[I];
  end;
end;

function GetJustLettersOfString(Value: String): String;
var
I : Integer;
begin
  Result := '';

  {$IFDEF Android}
  for I := 0 to Value.Length do
  {$ELSE}
  for I := 1 to Value.Length do
  {$ENDIF}
  begin
    if (Value[I] in ['A'..'Z', 'a'..'z', ' ']) then
      Result := Result + Value[I];
  end;
end;

function FormatValue(Value : Double): String;
begin
  Result := FormatFloat(',0.00', Value);
end;

function Max(x, y: Integer): Integer;
begin
  if (x > y) then
    Result := x
  else
    Result := y;
end;

function Min(x, y: Integer): Integer;
begin
  if (x < y) then
    Result := x
  else
    Result := y;
end;

procedure ValidateValueComponent(Control: TControl; Value: String; Msg : String; QuantityCaracters: Integer);
begin
  if (Value.Equals('')) or ((QuantityCaracters > 0) and (Value.Length <> QuantityCaracters)) then
  begin
    Control.SetFocus;
    raise Exception.Create(Msg);
  end;
end;

procedure ValidateValueComponent(Control: TControl; Value: Double; Msg : String);
begin
  if (Value = 0) then
  begin
    Control.SetFocus;
    raise Exception.Create(Msg);
  end;
end;

procedure ValidateValueComponent(Control: TControl; Value: Integer; Msg : String);
begin
  if (Value = 0) then
  begin
    Control.SetFocus;
    raise Exception.Create(Msg);
  end;
end;

procedure Show(Form: TForm);
begin
  with Form do
  begin
    try
      {$IFDEF Win32 or Win64}
      ShowModal;
      {$ELSE}
      Show;
      {$ENDIF}
    finally
      Free;
    end;
  end;
end;

function StrToDateTimeFromWebService(DateTime : String): TDatetime;
var
StrDateTime: String;
begin
  StrDateTime := Format('%s/%s/%s %s'
                                , [ Copy(DateTime, 9, 2)
                                  , Copy(DateTime, 6, 2)
                                  , Copy(DateTime, 1, 4)
                                  , Copy(DateTime, 12, 5)]);
  Result := StrToDateTime(StrDateTime);
end;

function ValidateEmail(EMail: String):Boolean;
const
  CaraEsp: array[1..39] of char =
  ( '!','#','$','%','¨','&','*',
  '(',')','+','=','§','¬','¢','¹','²',
  '³','£','´','`','ç','Ç',',',';',':',
  '<','>','~','^','?','/','|','[',']','{','}',
  'º','ª','°');
var
  EMailIn: PChar;
  i,cont   : integer;
begin
  Result := True;
  cont := 0;
  if EMail <> '' then
    if (Pos('@', EMail)<>0) and (Pos('.', EMail)<>0) then    // existe @ .
    begin
      if (Pos('@', EMail)=1) or (Pos('@', EMail)= Length(EMail)) or (Pos('.', EMail)=1) or (Pos('.', EMail)= Length(EMail)) or (Pos(' ', EMail)<>0) then
        Result := False
      else                                   // @ seguido de . e vice-versa
        if (abs(Pos('@', EMail) - Pos('.', EMail)) = 1) then
          Result := False
        else
          begin
            for i := 1 to 39 do            // se existe Caracter Especial
              if Pos(CaraEsp[i], EMail)<>0 then
                Result := False;

            {$IFDEF Android}
            for i := 0 to length(EMail)-1 do
            {$ELSE}
            for i := 1 to length(EMail)-1 do
            {$ENDIF}
            begin                                 // se existe apenas 1 @
              if EMail[i] = '@' then
                cont := cont + 1;                    // . seguidos de .
              if (EMail[i] = '.') and (EMail[i+1] = '.') then
                Result := false;
            end;

            // . no f, 2ou+ @, . no i, - no i, _ no i
            if (cont >=2) or ( EMail[length(EMail)]= '.' )
            {$IFDEF Android}
            or ( EMail[0]= '.' ) or ( EMail[0]= '_' )
              or ( EMail[0]= '-' )  then
            {$ELSE}
            or ( EMail[1]= '.' ) or ( EMail[1]= '_' )
              or ( EMail[1]= '-' )  then
            {$ENDIF}
                Result := false;
                                            // @ seguido de COM e vice-versa
            if (abs(Pos('@', EMail) - Pos('com', EMail)) = 1) then
              Result := False;
                                              // @ seguido de - e vice-versa
            if (abs(Pos('@', EMail) - Pos('-', EMail)) = 1) then
              Result := False;
                                              // @ seguido de _ e vice-versa
            if (abs(Pos('@', EMail) - Pos('_', EMail)) = 1) then
              Result := False;
          end;
    end
    else
      Result := False;
end;

function ValidateCPF(CPF: string): boolean;
var  dig10, dig11: string;
    s, i, r, peso: integer;
begin
  if ((CPF = '00000000000') or (CPF = '11111111111') or
      (CPF = '22222222222') or (CPF = '33333333333') or
      (CPF = '44444444444') or (CPF = '55555555555') or
      (CPF = '66666666666') or (CPF = '77777777777') or
      (CPF = '88888888888') or (CPF = '99999999999') or
      (length(CPF) <> 11)) then
  begin
    Result := false;
    exit;
  end;

  try
    s := 0;
    peso := 10;

    {$IFDEF Android}
    for i := 0 to 8 do
    {$ELSE}
    for i := 1 to 9 do
    {$ENDIF}
    begin
      s := s + (StrToInt(CPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig10 := '0'
    else
      str(r:1, dig10);

    s := 0;
    peso := 11;

    {$IFDEF Android}
    for i := 0 to 9 do
    {$ELSE}
    for i := 1 to 10 do
    {$ENDIF}
    begin
      s := s + (StrToInt(CPF[i]) * peso);
      peso := peso - 1;
    end;

    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig11 := '0'
    else
      str(r:1, dig11);

    {$IFDEF Android}
    if ((dig10 = CPF[9]) and (dig11 = CPF[10])) then
    {$ELSE}
    if ((dig10 = CPF[10]) and (dig11 = CPF[11])) then
    {$ENDIF}
      Result := true
    else
      Result := false;
  except
    Result := false
  end;
end;

function GenerateMD5(Value: String): String;
begin
  with TIdHashMessageDigest5.Create do
  begin
    try
      Result := HashStringAsHex(Value);
    finally
      Free;
    end;
  end;
end;

procedure ExecuteAsync(Layout: TLayout; OnExecute: TOnExecute);
var
Thread: TExecuteThread;
ProgressDialog: TFrameProgressDialog;
begin
  //Instancia um diálogo de progresso (Frame).
  ProgressDialog := TFrameProgressDialog.Create(nil);

  //Adiciona e anima o diálogo de progresso no layout passado como argumento.
  ProgressDialog.Parent := Layout;
  ProgressDialog.StartAnimation;

  //Cria a Thread para executar o procedimento desejado de forma concorrente.
  Thread := TExecuteThread.Create(ProgressDialog, OnExecute);

  //Inicia a Thread.
  Thread.Start;
end;

procedure CloseProgressDialog(ProgressDialog: TFrameProgressDialog);
begin
  //Confirma se o diálogo de progresso ainda não está sendo desalocado da memória.
  if (ProgressDialog.ProgressIndicator <> nil) then
  begin
    //Remove o diálogo do layout que o contém.
    ProgressDialog.StopAnimation;
    ProgressDialog.Free;
  end;
end;

procedure TExecuteThread.CloseProgressDialog;
begin
  UnitRoutines.CloseProgressDialog(Self.ProgressDialog);
end;

constructor TExecuteThread.Create(ProgressDialog: TFrameProgressDialog; OnExecute: TOnExecute);
begin
  //Executa o construtor herdado da superclasse.
  inherited Create(True);

  //Inicializa os atributos de objeto.
  Self.ProgressDialog := ProgressDialog;
  Self.OnExecute      := OnExecute;
  Self.FreeOnTerminate:= True;
end;

procedure TExecuteThread.Execute;
begin
  try
    //Executa o procedimento desejado.
    OnExecute;
  finally
    //Fecha o diálogo de progresso.
    Synchronize(CloseProgressDialog);
  end;
end;

end.
