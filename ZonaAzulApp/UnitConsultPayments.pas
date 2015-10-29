unit UnitConsultPayments;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit, DateUtils;

type
  TFrameConsultPayments = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Layout8: TLayout;
    editPlateLetters: TEdit;
    Label2: TLabel;
    editPlateNumbers: TEdit;
    LayoutResultConsult: TLayout;
    LabelResult: TLabel;
    buttonConsultTicket: TSpeedButton;
    RectangleResult: TRectangle;
    Layout4: TLayout;
    LabelTimeInterval: TLabel;
    procedure buttonConsultTicketClick(Sender: TObject);
    procedure editPlateNumbersChange(Sender: TObject);
    procedure editPlateLettersChange(Sender: TObject);
    procedure editPlateLettersKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    procedure SetPaymentAuthorized(DayTime, DeadlineTime: TDateTime);
    procedure SetPaymentUnauthorized;
    procedure SetFontColorResultLabels(Color: TAlphaColor);
    procedure ValidateValuesComponents;
  public
    { Public declarations }
    constructor Create(AWOner: TComponent); override;
    procedure ClearComponents;
  end;

var
  FrameConsultPayments: TFrameConsultPayments;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitRoutines;

{ TFrameConsultPayments }

procedure TFrameConsultPayments.buttonConsultTicketClick(Sender: TObject);
var
DayTime, DeadlineTime: TDateTime;
Plate: String;
begin

  try
    //Valida os valores dos campos.
    ValidateValuesComponents;

    //Junta as letras e números da placa.
    Plate := editPlateLetters.Text+editPlateNumbers.Text;

    //Consulta no servidor se o estacionamento está pago para a placa informada.
    if (DataModuleGeral.ConsultPayment(Plate, DayTime, DeadlineTime)) then
    begin
      //Exibe como resultado que o pagamento foi confirmado.
      SetPaymentAuthorized(DayTime, DeadlineTime);
    end
    else
    begin
      //Exibe o resultado de não pagamento do estacionamento.
      SetPaymentUnauthorized;
    end;
  except
    on Error: Exception do
    begin
      ShowMessage(Error.Message);
    end;
  end;
end;

procedure TFrameConsultPayments.ClearComponents;
begin
  //Limpa os campos da consulta.
  RectangleResult.Visible := False;
end;

constructor TFrameConsultPayments.Create(AWOner: TComponent);
begin
  inherited Create(AWOner);

  //Limpa os campos referente à consulta.
  ClearComponents;
end;

procedure TFrameConsultPayments.editPlateLettersChange(Sender: TObject);
begin
  //Deixa as letras da placa em maiúsculo.
  SetTextUpperCaseEditChange(Sender);
end;

procedure TFrameConsultPayments.editPlateLettersKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  //Permite apenas a digitação de letras.
  AllowJustLettersEditKeyDown(Sender, Key, KeyChar, Shift);
end;

procedure TFrameConsultPayments.editPlateNumbersChange(Sender: TObject);
begin
  //Permite apenas números no campo editPlateNumbers.
  editPlateNumbers.Text := GetJustNumbersOfString(editPlateNumbers.Text);
end;

procedure TFrameConsultPayments.SetFontColorResultLabels(Color: TAlphaColor);
begin
  //Atribui aos labels a cor de fonte passada como argumento.
  LabelResult.TextSettings.FontColor := Color;
  LabelTimeInterval.TextSettings.FontColor := Color;
end;

procedure TFrameConsultPayments.SetPaymentAuthorized(DayTime, DeadlineTime: TDateTime);
begin
  //Exibe os campos de resultados.
  RectangleResult.Visible := True;

  //Atribui os dados do pagamento aos campos de resultados.
  LabelResult.Text := 'Estacionamento Autorizado';
  LabelTimeInterval.Text := Format('de %s'+#13+' a %s'
                                  ,[FormatDateTime('dd/mm/yyyy hh:MM', DayTime)
                                   ,FormatDateTime('dd/mm/yyyy hh:MM', DeadlineTime)]);

  //Coloca a fonte verde nos labels de resultado.
  SetFontColorResultLabels(TAlphaColors.Green);
end;

procedure TFrameConsultPayments.SetPaymentUnauthorized;
begin
  //Exibe os campos de resultados.
  RectangleResult.Visible := True;

  //Atribui ao label de resultado o texto de não autorização.
  LabelResult.Text := 'Estacionamento'+#13+'Não Autorizado';
  LabelTimeInterval.Text := FormatDateTime('dd/mm/yyyy hh:MM', now);

  //Coloca a fonte vermelha nos labels de resultado.
  SetFontColorResultLabels(TAlphaColors.Red);
end;

procedure TFrameConsultPayments.ValidateValuesComponents;
begin
  //Verifica os valores dos campos.
  editPlateNumbers.Text := GetJustNumbersOfString(editPlateNumbers.Text);
  ValidateValueComponent(editPlateLetters, editPlateLetters.Text, 'Informe as letras da placa!', 3);
  ValidateValueComponent(editPlateNumbers, editPlateNumbers.Text, 'Informe os números da placa!', 4);
end;

end.
