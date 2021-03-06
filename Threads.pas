unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TContador = class (TThread)
  private
    FTempo: Integer;
  public
    constructor create;
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
    procedure aumentaPosicao;
  end;
  TfThreads = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    BtAbort: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtAbortClick(Sender: TObject);
  private
    { Private declarations }
    FVetor: Array of TContador;
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;
  FAbortarProcesso: boolean;

implementation

{$R *.dfm}

procedure TfThreads.BtAbortClick(Sender: TObject);
begin
  FAbortarProcesso := true;
end;

procedure TfThreads.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  FAbortarProcesso := False;
  ProgressBar1.Max := StrtoInt(Edit1.Text) * 101;
  ProgressBar1.Position := 0;
  SetLength(FVetor, StrToInt(Edit1.Text));

  for i := 0 to StrToInt(Edit1.Text)-1 do
    FVetor[i] := TContador.create;

  Button1.Enabled := False;
  BtAbort.Enabled := true;
end;

{ TContador }
procedure TContador.aumentaPosicao;
begin
  fThreads.ProgressBar1.Position := fThreads.ProgressBar1.Position + 1;
end;

constructor TContador.create;
begin
  inherited Create(false);
  fThreads.Memo1.Lines.Add(IntToStr(Self.ThreadID) + ' ? Iniciando processamento');

  FreeOnTerminate := True;
  Priority := tpNormal;
end;

procedure TContador.DoTerminate;
begin
  inherited;
  fThreads.Memo1.Lines.Add(IntToStr(Self.ThreadID) + ' ? Processamento Terminado');
end;

procedure TContador.execute;
var
  I: Integer;
begin
  for I := 0 to 100 do
  begin
    if FAbortarProcesso then
    begin
      Self.Terminate;
      abort;
    end;
    Randomize;
    Self.FTempo := Random(StrToInt(fThreads.Edit2.Text));
    sleep(Self.FTempo);
    Synchronize(Self, aumentaPosicao);
  end;
  inherited;
end;

procedure TfThreads.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
begin
   if high(FVetor) > 0  then
     for i := 0 to StrToInt(Edit1.Text)-1 do
       if not FVetor[i].Finished then
       begin
         Application.MessageBox('Existem Threads em execu??o. Aguarde o processamento!', 'Aviso');
         CanClose := false;
         break;
       end;
end;

end.
