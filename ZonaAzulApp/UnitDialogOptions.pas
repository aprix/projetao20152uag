unit UnitDialogOptions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  Datasnap.DBClient, FMX.Controls.Presentation, FMX.ListView, FMX.Layouts,
  Data.Bind.GenData, Data.Bind.ObjectScope;

type
 TOnResult = reference to procedure(ModalResult: TModalResult; IndexSelected: Integer);

type
  TFrameDialogOptions = class(TFrame)
    LayoutCenter: TLayout;
    ListView1: TListView;
    DataSetOptions: TClientDataSet;
    DataSetOptionsIndex: TIntegerField;
    DataSetOptionsName: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    procedure FrameClick(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    var
    OnResult : TOnResult;
  public
    { Public declarations }
    constructor Create(AWoner: TComponent; Parent: TFmxObject; Options: array of String; OnResult: TOnResult);
  end;

implementation

{$R *.fmx}

{ TFrame1 }

constructor TFrameDialogOptions.Create(AWoner: TComponent; Parent: TFmxObject; Options: array of String;
  OnResult: TOnResult);
var
I, Height: Integer;
begin
  //Chama o construtor herdado da superclasse.
  inherited Create(AWoner);

  //Atribui o parente do frame de diálogo, identificando aonde o frame será exibido.
  Self.Parent := Parent;
  BringToFront;

  //Atribui ao atributo OnResult a referência do procedimento passado como argumento.
  Self.OnResult := OnResult;

  //Adiciona as opções no conjunto de opções.
  DataSetOptions.CreateDataSet;
  for I := 0 to Length(Options) - 1 do
  begin
    DataSetOptions.Append;
    DataSetOptionsIndex.AsInteger := I;
    DataSetOptionsName.AsString := Options[I];
    DataSetOptions.Post;
  end;

  //Determina a altura do diálogo de acordo com a quantidade de opções.
  Height := DataSetOptions.RecordCount * 45;
  if (Height >= Self.Height) then
  begin
    LayoutCenter.Align := Align.alClient;
  end
  else
  begin
    LayoutCenter.Align := Align.alVertCenter;
    LayoutCenter.Height:= Height;
  end;
end;

procedure TFrameDialogOptions.FrameClick(Sender: TObject);
begin
  //Fecha o diálogo e retorna mrCancel como resultado do diálogo.
  Visible := False;
  OnResult(mrCancel, -1);
end;

procedure TFrameDialogOptions.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  //Fecha o diálogo e retorna como resultado o índice do item pressionado.
  Visible := False;
  OnResult(mrOk, AItem.Index);
end;

end.
