unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

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
    Label3: TLabel;
    LayoutPassword: TLayout;
    EditPassword: TEdit;
    Label4: TLabel;
    ButtonLogin: TSpeedButton;
    procedure EditCPFChange(Sender: TObject);
    procedure ButtonLoginClick(Sender: TObject);
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

uses UnitRoutines, UnitDataModuleGeral;

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
  //Permite apenas números no campo de CPF.
  EditCPF.Text := UnitRoutines.GetJustNumbersOfString(EditCPF.Text);
end;

end.
