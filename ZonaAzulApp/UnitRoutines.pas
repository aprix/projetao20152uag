unit UnitRoutines;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants
  , FMX.Edit, FMX.ListBox, FMX.Controls, FMX.Forms;

procedure SetTextUpperCaseEditChange(Sender: TObject);
procedure AllowJustLettersEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);

function GetJustNumbersOfString(Value: String): String;

function FormatValue(Value : Double): String;

function Max(x, y: Integer): Integer;

function Min(x, y: Integer): Integer;

procedure ValidateValueComponent(Control: TControl; Value: String; Msg : String = 'Valor obrigatório'; QuantityCaracters: Integer = 0); overload;
procedure ValidateValueComponent(Control: TControl; Value: Double; Msg : String = 'Valor obrigatório'); overload;
procedure ValidateValueComponent(Control: TControl; Value: Integer; Msg : String = 'Valor obrigatório'); overload;

function StrToDateTimeFromWebService(DateTime : String): TDatetime;

procedure Show(Form: TForm);

implementation

procedure SetTextUpperCaseEditChange(Sender: TObject);
begin
  (Sender as TEdit).Text := AnsiUpperCase((Sender as TEdit).Text);
end;

procedure AllowJustLettersEditKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin

  {$IFDEF Android}
  if not CharInSet(Key, ['A'..'Z','a'..'z']) then
    KeyChar := #0;
  {$ENDIF}

  {$IFDEF Win32 or Win64}
  if not (KeyChar in ['A'..'Z', 'a'..'z']) then
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
                                  , Copy(DateTime, 12, 8)]);
  Result := StrToDateTime(StrDateTime);
end;


end.
