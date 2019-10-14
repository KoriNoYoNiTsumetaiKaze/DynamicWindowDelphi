unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TWin = record
     Form:TForm;
     Button:TButton;
   end;

var
  Form1: TForm1;
  WinArray:array of TWin;
  BtnFormLeft,BtnFormTop:integer;

implementation

{$R *.dfm}

procedure TForm1.ButtonClick(Sender: TObject);
var NumForm:integer;
begin
  NumForm:=StrToInt((Sender as TButton).Caption);
  if WinArray[NumForm].Form<>nil then WinArray[NumForm].Form.Show;
end;

procedure TForm1.N2Click(Sender: TObject);
var NumForm:integer;
    NewForm:TForm;
    Memo:TMemo;
    BtnForm:TButton;
begin
  NumForm:=Length(WinArray);
  SetLength(WinArray,NumForm+1);

  NewForm:=TForm.Create(Application);
  NewForm.Caption:=IntToStr(NumForm);
  NewForm.Left:=round(Screen.Width/2);
  NewForm.Top:=round(Screen.Height/2);
  NewForm.Show;

  WinArray[NumForm].Form:=NewForm;

  Memo:=TMemo.Create(NewForm);
  Memo.Parent:=NewForm;
  Memo.Left:=10;
  Memo.Top:=10;
  Memo.Width:=NewForm.Width-30;
  Memo.Height:=NewForm.Height-50;

  BtnForm:=TButton.Create(Form1);
  BtnForm.Parent:=Form1;
  BtnForm.Caption:=IntToStr(NumForm);
  BtnForm.Left:=BtnFormLeft;
  BtnForm.Top:=BtnFormTop;
  BtnForm.OnClick:=ButtonClick;

  WinArray[NumForm].Button:=BtnForm;

  BtnFormLeft:=BtnFormLeft+BtnForm.Width+10;
  if BtnFormLeft+BtnForm.Width+10>Form1.Width then
    begin
      BtnFormLeft:=10;
      BtnFormTop:=BtnFormTop+BtnForm.Height+10;
    end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BtnFormLeft:=10;
  BtnFormTop:=10;
end;

procedure FormAndButtonFree(NumForm:integer);
var BtnForm:TButton;
begin
  if WinArray[NumForm].Form<>nil then WinArray[NumForm].Form.Free;
  if WinArray[NumForm].Button<>nil then
    begin
      BtnForm:=WinArray[NumForm].Button;
      if (NumForm+1)=Length(WinArray) then
        begin
          BtnFormLeft:=BtnFormLeft-BtnForm.Width-10;
          if BtnFormTop<>BtnForm.Top then
            begin
              BtnFormTop:=BtnForm.Top;
              BtnFormLeft:=BtnForm.Left;
            end;
          SetLength(WinArray,NumForm);
        end;
      BtnForm.Free;
    end;
end;

procedure TForm1.N3Click(Sender: TObject);
var NumForm:integer;
begin
  NumForm:=Length(WinArray);
  if NumForm=0 then Exit;
  NumForm:=NumForm-1;
  FormAndButtonFree(NumForm);
end;

procedure TForm1.N4Click(Sender: TObject);
var NumForm:integer;
begin
  try
    NumForm:=StrToInt(InputBox('Номер окна','Введите номер закрываемого окна','0'));
  except
  on E : Exception do
    begin
      ShowMessage(E.ClassName+' Ошибка ввода номера окна '+E.Message);
      Exit;
    end;
  end;
  if NumForm<0 then Exit;
  if NumForm>=Length(WinArray) then Exit;
  FormAndButtonFree(NumForm);
end;

procedure TForm1.N5Click(Sender: TObject);
var NumForm:integer;
begin
  for NumForm:=0 to Length(WinArray)-1 do
    FormAndButtonFree(NumForm);
  BtnFormLeft:=10;
  BtnFormTop:=10;
  SetLength(WinArray,0);
end;

end.
