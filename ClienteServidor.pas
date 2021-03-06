unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB;

type
  TServidor = class
  private
    FPath: String;
  public
    constructor Create;
    //Tipo do par?metro n?o pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;
    procedure RollbackArquivos(ARegistro: Integer);
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure ClientDataSet1PostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
  private
    FPath: String;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;
  QTD_BLOCO = 5;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  cds := InitDataset;
  ProgressBar.Max :=  QTD_ARQUIVOS_ENVIAR;
  ProgressBar.Position := 0;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    try
      cds.Append;
      cds.FieldByName('ID').AsInteger := i;
      TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
      cds.Post;

      {$REGION Simula??o de erro, n?o alterar}
      if i = (QTD_ARQUIVOS_ENVIAR/2) then
        FServidor.SalvarArquivos(NULL);
      {$ENDREGION}

      ProgressBar.Position := i;
      Application.ProcessMessages;
    except
      FServidor.RollbackArquivos(i);
    end;
  end;

  if not FServidor.SalvarArquivos(cds.Data) then
  begin
    Application.MessageBox('Erro ao Salvar os arquivos', 'O sistema n?o conseguiu salvar os arquivos');
    FServidor.RollbackArquivos(QTD_ARQUIVOS_ENVIAR);
  end;
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: array of TClientDataset;
  i, iBloco: integer;
begin
  iBloco := 0;
  setLength(cds, 1);
  cds[iBloco] := InitDataset;
  ProgressBar.Max :=  QTD_ARQUIVOS_ENVIAR;
  ProgressBar.Position := 0;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    if (i > 0) and (i mod QTD_BLOCO = 0) then
    begin
      FServidor.SalvarArquivos(cds[iBloco].Data);
      cds[iBloco].EmptyDataSet;
      cds[iBloco].free;

      Inc(iBloco);
      setLength(cds, iBloco + 1);
      cds[iBloco] := InitDataset;
    end;
    cds[iBloco].Append;
    cds[iBloco].FieldByName('ID').AsInteger := i;
    TBlobField(cds[iBloco].FieldByName('Arquivo')).LoadFromFile(FPath);
    cds[iBloco].Post;

    ProgressBar.Position := i;
    Application.ProcessMessages;
  end;
  cds[iBloco].EmptyDataSet;
  cds[iBloco].free;
end;

procedure TfClienteServidor.ClientDataSet1PostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
//
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
  FServidor := TServidor.Create;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(Self);
  Result.FieldDefs.Add('Id', ftInteger);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
  Result.OnPostError := ClientDataSet1PostError;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
  if not DirectoryExists(FPath) then
    CreateDir(FPath);
end;

procedure TServidor.RollbackArquivos(ARegistro: Integer);
var
  Filename: String;
  i: integer;
begin
  for i := 0 to ARegistro do
  begin
     FileName := FPath + IntToStr(i) + '.pdf';
     if TFile.Exists(FileName) then
        TFile.Delete(FileName);
  end;
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
begin
  Result := False;
  cds    := nil;
  try
    cds := TClientDataset.Create(nil);
    cds.Data := AData;

    {$REGION Simula??o de erro, n?o alterar}
    if cds.RecordCount = 0 then
      Exit;
    {$ENDREGION}

    cds.First;

    while not cds.Eof do
    begin
      FileName := FPath + cds.FieldByName('ID').AsString + '.pdf';
      if TFile.Exists(FileName) then
        TFile.Delete(FileName);

      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
      cds.Next;
    end;

    cds.EmptyDataSet;
    cds.Free;

    Result := True;
  except
    cds.EmptyDataSet;
    cds.Free;
    raise;
  end;
end;



end.
