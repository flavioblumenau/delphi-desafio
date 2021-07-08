unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.AppEvnts;

type
  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure btThreadsClick(Sender: TObject);
  private
  public
  end;

var
  fMain: TfMain;

implementation

uses
  DatasetLoop, ClienteServidor, Threads;

{$R *.dfm}


procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
  fDatasetLoop.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
  fClienteServidor.Show;
end;

procedure TfMain.btThreadsClick(Sender: TObject);
begin
  fThreads.Show;
end;

procedure TfMain.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
var
  vrLogFile: String;
begin
  vrLogFile := ExtractFilePath(Application.ExeName) + 'log-exceptions.log';
  with TStringList.Create do
  begin
    if FileExists(vrLogFile) then
      LoadFromFile(vrLogFile);

    Add('----');
    Add('Exception Às ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', now));
    Add('Classe: ' + E.ClassName);
    Add('Descrição: '+ E.Message);
    SaveToFile(vrLogFile);

    Free;
  end;

  raise E;
end;

end.
