unit UnitLagrange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, Math;

const MAXIMOPONTOS=1000;

type

 Polinomio = array [0..MAXIMOPONTOS] of double;

  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    gridPontos: TStringGrid;
    radioVariavel: TRadioGroup;
    botaoCalcular: TBitBtn;
    GroupBox2: TGroupBox;
    memoResultado: TMemo;
    botaoLimpar: TBitBtn;
    Label1: TLabel;
    procedure botaoLimparClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure botaoCalcularClick(Sender: TObject);



  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  nPontos: integer;  // guarda o numero de pontos
  h      : double;


 procedure inicializaPolinomio(var pol: Polinomio);
 procedure multiplicaPorConstante(var pol: Polinomio; valor: double);
 procedure multiplicaPorBinomio(var pol: Polinomio; valor: double);
 function somaPolinomios(pol1, pol2: Polinomio): Polinomio;
 function polinomioToString(pol: Polinomio; nomeVariavel: string): string;
 procedure limpaPontos();
 function LagrangeX(): Polinomio;
 function LagrangeU(): Polinomio;
 function ConverteUparaX(lagU: Polinomio): Polinomio;
 function AvaliaPolinomio(pol: Polinomio): String;


implementation

{$R *.dfm}

//////////////////////////////////////////////////////////////////////////////
                   { MANIPULAÇÃO DE POLINÔMIOS }
//////////////////////////////////////////////////////////////////////////////

// Inicializa Polinômio
procedure inicializaPolinomio(var pol: Polinomio);
var i: integer;
begin
    for i:=0 to MAXIMOPONTOS-1 do
      begin
           pol[i]:=0.0;
      end;
end;

// Multiplica Por constante
procedure multiplicaPorConstante(var pol: Polinomio; valor: double);
var i: integer;
begin
    for i:=0 to MAXIMOPONTOS-1 do
      begin
           pol[i]:=pol[i]*valor;
      end;
end;

// Soma dois polinômios
function somaPolinomios(pol1, pol2: Polinomio): Polinomio;
var resultado: Polinomio;
    i: integer;
Begin
    for i:=0 to MAXIMOPONTOS-1 do
      begin
           resultado[i]:=pol1[i]+pol2[i];
      end;
    somaPolinomios:=resultado;
end;

// Multiplica Por binômio da forma "x+valor"
procedure multiplicaPorBinomio(var pol: Polinomio; valor: double);
var i: integer;
    pol1, pol2: Polinomio;
begin
    // Polinomio = Polinomio*valor + Polinomio*x
    pol1:=pol;   // será multiplicado por valor
    pol2:=pol;   //   ||  ||          ||   x
    multiplicaPorConstante(pol1, valor);

    for i:=MAXIMOPONTOS-2 downto 0 do
      begin
           pol2[i+1] := pol2[i];
      end;
    pol2[0]:=0; // não mais existe constante

    pol:=somaPolinomios(pol1, pol2);
end;

// Converte para a representação usual de um polinômio
function polinomioToString(pol: Polinomio; nomeVariavel: string): string;
var
   resultado: string;
   i        : integer;
   sinal    : string;
begin
    resultado:='';
    for i:=0 to MAXIMOPONTOS-1 do
      begin
           if pol[i] <> 0 then // o termo existe
             begin
                 if pol[i] > 0 then // é positivo
                       sinal:= '+'
                 else   // negativo
                       sinal:='';
             resultado := resultado + sinal + FloatToStrF(pol[i], ffFixed, 4, 4);
             if i<> 0 then resultado := resultado + '.' + nomeVariavel+ '^'+IntToStr(i);
             resultado := resultado + '  ';
             end;
      end;
    polinomioToString := resultado;
end;

// Avalia o polinômio para todos os valores de X
function AvaliaPolinomio(pol: Polinomio): String;
var
   i, j      : integer;
   soma, x   : double;
   resultado : string;

Begin
    resultado:='';
    for i:=1 to nPontos do
      Begin
         x:=StrToFloat(Form1.gridPontos.Cells[i, 1]);
         resultado := resultado + 'P('+FloatToStrF(x, ffFixed, 4, 4)+') = ';
         soma:=0;
         for j:=0 to MAXIMOPONTOS-1 do
          begin
             if pol[j] <> 0 then soma := soma + pol[j]*Power(x, j);
          end;
         resultado := resultado + FloatToStrF(soma, ffFixed, 4, 4) + #13#10;
      End;
    AvaliaPolinomio:=resultado;
End;


//////////////////////////////////////////////////////////////////////////////
                             { LAGRANGE }
//////////////////////////////////////////////////////////////////////////////


// Lagrange na variável x
function LagrangeX(): Polinomio;
var polLag, polNumerador:   Polinomio;
    i, j, k : integer;
    denominador: double;

Begin
inicializaPolinomio(polLag);
for k:=0 to nPontos -1 do
Begin
     inicializaPolinomio(polNumerador);
     polNumerador[0] := 1;
     denominador := 1.0;
     for j:= 0 to nPontos-1 do
       begin
            if j <> k then
              begin
                 multiplicaPorBinomio(polNumerador, -StrToFloat(Form1.gridPontos.Cells[j+1, 1]));
                 denominador := denominador * (  StrToFloat(Form1.gridPontos.Cells[k+1, 1]) - StrToFloat(Form1.gridPontos.Cells[j+1, 1])      );
              end;
       end;
     multiplicaPorConstante(polNumerador, (1.0/denominador)); // divide pelo denominador
     multiplicaPorConstante(polNumerador, StrToFloat(Form1.gridPontos.Cells[k+1, 2]) );   // multip. por yK
     polLag := somaPolinomios(polLag, polNumerador);
End;
     LagrangeX := polLag;
End;

// Lagrange para pontos equidistantes => variável u
function LagrangeU(): Polinomio;
var polLag, polNumerador:   Polinomio;
    i, j, k : integer;
    denominador: double;

Begin
inicializaPolinomio(polLag);
h:= StrToFloat(Form1.gridPontos.Cells[2, 1]) - StrToFloat(Form1.gridPontos.Cells[1, 1]) ;
for k:=0 to nPontos -1 do
Begin
     inicializaPolinomio(polNumerador);
     polNumerador[0] := 1;
     denominador := 1.0;
     for j:= 0 to nPontos-1 do
       begin
            if j <> k then
              begin
                 multiplicaPorBinomio(polNumerador, -j);
                 denominador := denominador * (  k - j );
              end;
       end;
     multiplicaPorConstante(polNumerador, (1.0/denominador)); // divide pelo denominador
     multiplicaPorConstante(polNumerador, StrToFloat(Form1.gridPontos.Cells[k+1, 2]) );   // multip. por yK
     polLag := somaPolinomios(polLag, polNumerador);
End;
     LagrangeU := polLag;
End;

// Constrói o polinômio em X a partir de um na variável U
function ConverteUparaX(lagU: Polinomio): Polinomio;
var
    PolX, PolAux: Polinomio;
    i, j        : integer;
Begin
    inicializaPolinomio(PolX);
    for i:=0 to MAXIMOPONTOS-1 do
      begin
           inicializaPolinomio(PolAux);
           polAux[0]:=1;
             if lagU[i] <> 0 then
               Begin
                  for j:=0 to i-1 do
                   begin
                      multiplicaPorBinomio(PolAux, -StrToFloat(Form1.gridPontos.Cells[1, 1]));
                      multiplicaPorConstante(PolAux, (1.0/h));
                   end;
               End;
           multiplicaPorConstante(PolAux, lagU[i]);
           PolX := SomaPolinomios(PolX, PolAux);
      end;
    ConverteUparaX := PolX;
End;


//////////////////////////////////////////////////////////////////////////////
                        { ROTINAS AUXILIARES }
//////////////////////////////////////////////////////////////////////////////


// Limpa os pontos da tabela e lê numero de pontos
procedure limpaPontos();
var  stringEntrada: string;
     i            : integer;
begin
   stringEntrada :=  InputBox('Número de pontos', 'Entre com o número de pontos para o cálculo do polinômio interpolador:', '');
   if Trim(stringEntrada) <> '' then
      begin
          nPontos := StrToInt(Trim(stringEntrada));
          Form1.gridPontos.ColCount := 1 + nPontos;
          Form1.gridPontos.Cells[0,0] :='i';
          Form1.gridPontos.Cells[0, 1] := 'Xi';
          Form1.gridPontos.Cells[0, 2] := 'Yi';
          for i:=1 to nPontos+1 do
           begin
              Form1.gridPontos.Cells[i,0] := IntToStr(i-1);
           end;
          Form1.botaoCalcular.Enabled := True; 

      end;

end;

procedure TForm1.botaoLimparClick(Sender: TObject);
begin
  limpaPontos();
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 limpaPontos();
end;

procedure TForm1.botaoCalcularClick(Sender: TObject);
var LagU, LagX: Polinomio;
begin
  memoResultado.Clear;
  if radioVariavel.ItemIndex = 0 then
    begin
        LagX := LagrangeX();
        memoResultado.Lines.Append('Polinômio de Lagrange na variável x: ');
        memoResultado.Lines.Append(polinomioToString(LagX, 'x'));
        memoResultado.Lines.Append('');
        memoResultado.Lines.Append('Avaliação do Polinômio nos pontos');
        memoResultado.Lines.Append(AvaliaPolinomio(LagX));
    end
  else
    begin
        memoResultado.Lines.Append('Polinômio de Lagrange na variável u: ');
        LagU:=LagrangeU;
        memoResultado.Lines.Append(polinomioToString(LagU, 'u'));
        memoResultado.Lines.Append('');
        memoResultado.Lines.Append('h = '+ FloatToStrF(h, ffFixed, 4, 4));
        memoResultado.Lines.Append('');
        memoResultado.Lines.Append('Convertido para a variável x:');
        LagX:=ConverteUParaX(LagU);
        memoResultado.Lines.Append(polinomioToString(LagX, 'x'));
        memoResultado.Lines.Append('');
        memoResultado.Lines.Append('Avaliação do Polinômio nos pontos');
        memoResultado.Lines.Append(AvaliaPolinomio(LagX));
    end;
  // vai para a 1ª linha do resultado
  memoResultado.SelStart := memoResultado.Perform(EM_LINEINDEX, 0, 0);
  memoResultado.Perform(EM_SCROLLCARET, 0, 0);
  botaoCalcular.Enabled := false;
end;

end.
