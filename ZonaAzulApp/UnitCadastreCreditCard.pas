unit UnitCadastreCreditCard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit, FMX.ListBox, DateUtils
  ,StrUtils, System.ImageList, FMX.ImgList, FMX.ExtCtrls;

type
  TFormCadastreCreditCard = class(TForm)
    Layout1: TLayout;
    MasterToolBar: TToolBar;
    Rectangle1: TRectangle;
    Label3: TLabel;
    Layout2: TLayout;
    Label1: TLabel;
    EditName: TEdit;
    Layout4: TLayout;
    Layout5: TLayout;
    Label4: TLabel;
    ComboboxMonth: TComboBox;
    ComboboxYear: TComboBox;
    buttonSave: TSpeedButton;
    Layout7: TLayout;
    Label6: TLabel;
    EditNumber: TEdit;
    Layout6: TLayout;
    ImageFlag: TImage;
    IconsGenericList: TImageList;
    Layout3: TLayout;
    procedure EditNameChange(Sender: TObject);
    procedure buttonSaveClick(Sender: TObject);
    procedure EditNameKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure EditNumberChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    var
    Id: Integer;
  protected
    { Protected declarations }
    procedure ValidateValuesComponents; virtual;

    var
    Flag: String;
  public
    { Public declarations }
    constructor Create(AWoner: TComponent); overload;
    constructor Create(AWoner: TComponent; NumberForEdit: String); overload;
    function GetFlag(): String;
    function GetNumber(): String;
    function GetName(): String;
    function GetMonth(): Integer;
    function GetYear(): Integer;
  end;

var
  FormCadastreCreditCard: TFormCadastreCreditCard;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitRoutines, UnitDataModuleLocal;

procedure TFormCadastreCreditCard.buttonSaveClick(Sender: TObject);
begin
  try
    //Valida os valores dos campos.
    ValidateValuesComponents;

    //Envia o cartão de crédito para o servidor.
    DataModuleGeral.SendCreditCard(Id
                                  ,Flag
                                  ,EditName.Text
                                  ,EditNumber.Text
                                  ,StrToInt(ComboboxMonth.Selected.Text)
                                  ,StrToInt(ComboboxYear.Selected.Text)
                                  ,True);

    //Fecha o cadastro do cartão de crédito.
    Hide;
    ModalResult := mrOk;
  except
    on Error: Exception do
    begin
      //Exibe o erro para o usuário.
      ShowMessage(Error.Message);
    end;
  end;
end;

constructor TFormCadastreCreditCard.Create(AWoner: TComponent);
begin
  //Chama o construtor herdado.
  inherited Create(AWoner);
  Id := 0;
end;

constructor TFormCadastreCreditCard.Create(AWoner: TComponent;
  NumberForEdit: String);
begin
  //Chama o construtor herdado.
  inherited Create(AWoner);

  //Busca o registro a ser editado no conjunto de cartões.
  if (DataModuleGeral.DataSetCreditCards.Locate('Number', NumberForEdit, [])) then
  begin
    //Carrega nos campos os valores do cartão de crédito a ser editado.
    Id              := DataModuleGeral.GetIdCreditCardSelected();
    EditName.Text   := DataModuleGeral.GetNameCreditCardSelected();
    EditNumber.Text := DataModuleGeral.GetNumberCreditCardSelected();
    ComboboxMonth.ItemIndex:= DataModuleGeral.GetMonthCreditCardSelected - 1;
    ComboboxYear.ItemIndex := ComboboxYear.Items.IndexOf(IntToStr(DataModuleGeral.GetYearCreditCardSelected));
  end;
end;

procedure TFormCadastreCreditCard.EditNameChange(Sender: TObject);
begin
  //Permite apenas letras A-Z, e deixa as letras em maiúsculo.
  EditName.Text := GetJustLettersOfString(editName.Text);
  SetTextUpperCaseEditChange(Sender);
end;

procedure TFormCadastreCreditCard.EditNameKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  AllowJustLettersEditKeyDown(Sender, Key, KeyChar, Shift);
end;

procedure TFormCadastreCreditCard.EditNumberChange(Sender: TObject);
var
Index: Integer;
begin
  //Permite apenas números no campo editNumber.
  EditNumber.Text := GetJustNumbersOfString(editNumber.Text);

  //Atualiza o ícone da bandeira relacionada ao cartão digitado~.
  {$IFDEF Win32 or Win64}
  Index := 1;
  {$ELSE}
  Index := 0;
  {$ENDIF}
  if (EditNumber.Text.Length > 0) and (EditNumber.Text[Index] = '4') then
  begin
    ImageFlag.Bitmap := IconsGenericList.Bitmap(TSizeF.Create(32,32), 0);
    Flag := 'VISA';
  end
  else
  begin
    ImageFlag.Bitmap := IconsGenericList.Bitmap(TSizeF.Create(32,32), 1);
    Flag := 'MASTERCARD';
  end;
end;

procedure TFormCadastreCreditCard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose    := True;
  Hide;
  ModalResult := mrCancel;
end;

function TFormCadastreCreditCard.GetFlag: String;
begin
  Result := Flag;
end;

function TFormCadastreCreditCard.GetMonth: Integer;
begin
  Result := StrToInt(ComboboxMonth.Selected.Text);
end;

function TFormCadastreCreditCard.GetName: String;
begin
  Result := EditName.Text;
end;

function TFormCadastreCreditCard.GetNumber: String;
begin
  Result := EditNumber.Text.Replace('-', '');
end;

function TFormCadastreCreditCard.GetYear: Integer;
begin
  Result := StrToInt(ComboboxYear.Selected.Text);
end;

procedure TFormCadastreCreditCard.ValidateValuesComponents;
var
Month, Year, MonthCurrent, YearCurrent: Integer;
begin
  //Valida os valores de todos os campos.
  Focused := nil;
  EditName.Text := GetJustLettersOfString(editName.Text);
  EditNumber.Text := GetJustNumbersOfString(editNumber.Text);
  ValidateValueComponent(EditName, editName.Text, 'Informe o nome impresso no cartão!');
  ValidateValueComponent(EditNumber, editNumber.Text, 'Informe o número do cartão!', 16);

  //Verifica se o cartão de crédito está vencido.
  Month := StrToInt(ComboboxMonth.Selected.Text);
  Year  := StrToInt(ComboboxYear.Selected.Text);
  MonthCurrent := MonthOf(Date);
  YearCurrent  := YearOf(Date);
  if (Year < YearCurrent)
  or ((Month < MonthCurrent) and (Year = YearCurrent)) then
  begin
    //Levanta uma exceção informando sobre a validade do cartão de crédito.
    raise Exception.Create('Cartão de crédito vencido!');
  end;

end;

end.
