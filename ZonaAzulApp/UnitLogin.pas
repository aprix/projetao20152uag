unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Objects;

type
  ILoginListener = interface
    procedure OnSucess;
  end;

type
  TFrameLogin = class(TFrame)
    Layout1: TLayout;
    Layout3: TLayout;
    VertScrollBox1: TVertScrollBox;
    Layout5: TLayout;
    EditCPF: TEdit;
    LayoutPassword: TLayout;
    EditPassword: TEdit;
    ButtonLogin: TSpeedButton;
    Image1: TImage;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    LabelAccountRecovery: TLabel;
    Layout4: TLayout;
    Layout6: TLayout;
    procedure EditCPFChange(Sender: TObject);
    procedure ButtonLoginClick(Sender: TObject);
    procedure EditPasswordEnter(Sender: TObject);
    procedure EditPasswordExit(Sender: TObject);
    procedure EditCPFExit(Sender: TObject);
    procedure EditCPFEnter(Sender: TObject);
    procedure LabelAccountRecoveryClick(Sender: TObject);
  private
    { Private declarations }
    var
    LoginListener: ILoginListener;
  public
    { Public declarations }
    constructor Create(AWoner: TComponent; LoginListener: ILoginListener); overload;
  end;

implementation

{$R *.fmx}

uses UnitRoutines, UnitDataModuleGeral, UnitAccountRecovery;

procedure TFrameLogin.ButtonLoginClick(Sender: TObject);
begin
  try
    //Realiza o login do usuário.
    DataModuleGeral.Login(EditCPF.Text, UnitRoutines.GenerateMD5(EditPassword.Text));

    //Executa o procedimento de sucesso do objeto ouvinte de eventos.
    LoginListener.OnSucess;
  except
    on Error: Exception do
    begin
      //Exibe a mensagem do erro para o usuário.
      ShowMessage(Error.Message);
    end;
  end;
end;

constructor TFrameLogin.Create(AWoner: TComponent;
  LoginListener: ILoginListener);
begin
  inherited Create(AWoner);

  //Inicializa os atributos de objeto.
  Self.LoginListener := LoginListener;
end;

procedure TFrameLogin.EditCPFChange(Sender: TObject);
begin
  if (EditCPF.Text <> 'CPF') then
  begin
    //Permite apenas números no campo de CPF.
    EditCPF.Text := UnitRoutines.GetJustNumbersOfString(EditCPF.Text);
  end;
end;

procedure TFrameLogin.EditCPFEnter(Sender: TObject);
begin
  if (EditCPF.Text = 'CPF') then
  begin
    try
      EditCPF.Text := '';
    except
    end;
  end;
end;

procedure TFrameLogin.EditCPFExit(Sender: TObject);
begin
  if (EditCPF.Text = EmptyStr) then
    EditCPF.Text := 'CPF';
end;

procedure TFrameLogin.EditPasswordEnter(Sender: TObject);
begin
  if not(EditPassword.Password) then
  begin
    EditPassword.Text     := '';
    EditPassword.Password := True;
  end;
end;

procedure TFrameLogin.EditPasswordExit(Sender: TObject);
begin
  if (EditPassword.Text = EmptyStr) then
  begin
    EditPassword.Text     := 'Senha';
    EditPassword.Password := False;
  end;
end;

procedure TFrameLogin.LabelAccountRecoveryClick(Sender: TObject);
begin
  //Exibe o formulário de recuperação de conta.
  UnitRoutines.Show(TFormAccountRecovery.Create(Self));
end;

end.
