unit Unit1;

interface

uses
  Winapi.Windows,math,system.Generics.collections, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, Vcl.ExtCtrls,
  VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Chart: TChart;
    Series1: TPointSeries;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;


type
AOA=array of array of extended;

type
tpointf=record
x,y: extended;
end;

var
Form1: TForm1;
line:array of TLineSeries;
similarities:AOA;
responsibilities:AOA;
availabilities:AOA;
exemplar:AOA;
tmpsim:AOA;
exemplar_table:array of extended;
Pex:array of double;
observ: array of tpointf;
dict:tdictionary<integer,extended>;
arr:tarray<extended>;
linecount:longint;
const
dfactor = 0.3; // 0<=df<1
implementation

{$R *.dfm}




//--------------------------------------------------
//print MAT
//--------------------------------------------------
function printmatrix(Matrix:AOA;title:string;len:longint):integer;
var
i,j,k:longint;
begin


form1.Memo1.Lines.Add('------ '+title+': --------');
//
form1.Memo1.Lines.Add('len: '+(len*len).ToString());
for i := 0 to len-1 do begin
form1.Memo1.Lines.Add('');
for k := 0 to len-1 do begin
form1.Memo1.Text:= form1.Memo1.Text+ (Matrix[i][k].ToString())+' ';
end;
form1.Memo1.Lines.Add('');
end;
form1.Memo1.Lines.Add('');



end;







//--------------------------------------------------
//print MAT
//--------------------------------------------------
function printmatrixf(Matrix:AOA;title:string;len:longint):integer;
var
i,j,k:longint;
begin

form1.Memo1.Lines.BeginUpdate;
form1.Memo1.Lines.Add('------ '+title+': --------');
//
for i := 0 to len-1 do begin
form1.Memo1.Lines.Add('');
for k := 0 to len-1 do begin
form1.Memo1.Text:= form1.Memo1.Text+ format('%.2f',[Matrix[i][k]])+' ';
end;
form1.Memo1.Lines.Add('');
end;
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.endUpdate;
end;




//--------------------------------------------------
// Avoid Duplication
//--------------------------------------------------
function check_rep(val:integer;arr:array of double):integer;
var
i:integer;
begin
result:= 0;

for I := 0 to length(arr)-1 do begin
if val = arr[i] then begin
result:= 1;
break;
end;
end;

end;















//--------------------------------------------------
//respons
//--------------------------------------------------
function responsibility_(len:integer):integer;
var
i,k,ka:integer;
s:extended;
maximum:AOA;
maxx:extended;
SIAV:extended;
begin

//eq r(i,k) <-- s(i,k) - max(a(i,k') + s(i,k'))

//max(a(i,k') + s(i,k')
// k not equal = k'
//get max value in k'

for I := 0 to len-1 do begin
for k := 0 to len-1 do begin //
maxx:=-100000000000000000;

for ka := 0 to len-1 do begin
if ka<>k then begin // k not = k'
// get the max val in k
if (similarities[i][ka] + availabilities[i][ka])>maxx then
maxx:= similarities[i][ka] + availabilities[i][ka];
end;//avoid k = k'
end;

//maximum[i][k]:= maxx;
//
//compute
//s(i,k) - max(a(i,k') + s(i,k'))
responsibilities[i][k] := dfactor*responsibilities[i][k] + (1-dfactor)*(similarities[i][k] - maxx);
end;
end;


end;







//--------------------------------------------------
//similarity
//--------------------------------------------------
function similarity_(ob:array of tpointf;len:integer):integer;
var
midp:integer;
mid:double;
i,k:integer;
s:double;
tmp:extended;
ad,m,x:integer;
begin

setlength(tmpsim,len);
for I := 0 to len-1 do
setlength(tmpsim[i],len);


//compute similarity
//form1.Memo1.Lines.Add('---------- Compute similarity ---------');
for I := 0 to len-1 do begin
//form1.Memo1.Lines.Add('-----------------------------');
for k := 0 to len-1 do begin
//form1.Memo1.Lines.Add('---- '+ob[i].ToString()+' & '+ob[k].ToString()+'-----');
//calc similiarity
s := - (((ob[i].X-ob[k].X)*(ob[i].x-ob[k].x)) +((ob[i].y-ob[k].y)*(ob[i].Y-ob[k].Y))) ;
similarities[i][k] := s;
//form1.Memo1.Lines.Add(s.ToString());
end;
//form1.Memo1.Lines.Add('-----------------------------');
end;




printmatrix(similarities,'sim',len);

//move similarities to dict--------------------------
dict  := tdictionary<integer,extended>.create;
for i := 0 to len-1 do begin
for k := 0 to len-1 do begin
dict.Add(i*len +k,similarities[i][k]);
end;
end;

arr := dict.Values.ToArray;
tarray.Sort<extended>(arr);

//med
midp := (len div 2)-1;
mid :=  arr[midp*len + midp];
form1.Memo1.Lines.Add('--------------- Median: ----------------------');
form1.Memo1.Lines.Add('MID: '+format('%.02f',[mid]));
form1.Memo1.Lines.Add('');
dict.Free;
//--------------------------------------------





//Assign median to diagonal
for i := 0 to len-1 do begin
for k := 0 to len-1 do begin
if(i=k) then
similarities[i][k] := mid;
end;
end;

printmatrix(similarities,'Set Diagonal',len);

end;
































//--------------------------------------------------
//Availability
//--------------------------------------------------
function availability_(len:integer):integer;
var
i,k:integer;
s:integer;
tmp:integer;
ad,m,x:integer;
maxx:extended;
diagonalRKK:extended;
begin
// a(i,k) <-- min ( 0 , r(k,k) + sum max( 0, r(i',k))
// i not equal = k.. i' not belong to (i,k)

//sum max( 0, r(i',k))
//i not belong i,k



//min ( 0 , r(k,k) + sum max( 0, r(i',k))
for i := 0 to len-1 do begin
for k := 0 to len-1 do begin
//get MAX________
//sum max( 0, r(i',k))
//i not belong(i,k)
maxx:=0;
for m := 0 to len-1 do begin
if (i =m) then continue;
maxx := maxx + max(0,responsibilities[m][k]);
end;

//______________

if i = k then begin // i not equal k
//diagonal;
availabilities[i][k] := (1-dfactor)*maxx + dfactor*availabilities[i][k];
end
else begin
diagonalRKK := responsibilities[k][k] ;
availabilities[i][k] :=  dfactor*availabilities[i][k] + (1-dfactor)*min(0,diagonalRKK+maxx);
end;

end;
end;



end;












//--------------------------------------------------
//exemplar
//--------------------------------------------------
function Exemplar_(len:integer):integer;
var
i,j,k,p,size:integer;
s:integer;
ad,m,x:integer;
maxx:extended;
clust:double;
loc,deff:integer;
clusters:array of integer;
ex:array of double;
tss:tstringlist;
begin


result :=-1; // looooop

for I := 0 to len-1 do begin
for k := 0 to len-1 do begin
exemplar[i][k] := responsibilities[i][k] + availabilities[i][k];
end;
end;

//printmatrix(exemplar,'Exemplar',len);

result :=-1;
//

//extract positive diagonal
setlength(ex,len);
for I := 0 to len-1 do
ex[i] := -99;

p := 0;
for i := 0 to len-1 do begin
for k := 0 to len-1 do begin
if (i = k) then begin
if exemplar[i][k] > 0 then begin
ex[p] :=i;
inc(p);
end;
end;
end;

end;



//compare pex & ex----------------------
deff :=0;
for I := 0 to length(ex)-1 do  begin
if (ex[i] <> pex[i]) then begin
deff := 1;
end;
end;

if deff= 1 then begin
for I := 0 to length(ex)-1 do  begin
pex[i] := ex[i];
end;
exit;
end;



setlength(ex,p);
setlength(exemplar_table,len);


for i := 0 to len-1 do begin //col
maxx :=-1000000000000000000;
for k := 0 to len-1 do begin    //row
//get the maxx sim in row using ex index
for p := 0 to length(ex)-1 do begin
if k = ex[p] then begin

if Similarities[i][k] > maxx then begin
maxx :=Similarities[i][k];
clust:= ex[p];
Loc:=i;
end;

end;
end;
end; //end row

//form1.Memo1.Lines.Add('--> '+observ[loc].ToString+' --> add to cluster  --> '+clust.ToString());
exemplar_table[loc] := clust;
end;


//ADjust exemplar pos
for I := 0 to length(exemplar_table)-1 do begin
for j := 0 to length(exemplar_table)-1 do begin
if j = exemplar_table[i] then begin // if j in exemplar table
exemplar_table[j]:= j; //adjust position
end;
end;
end;



//exemplar table
form1.Memo1.Lines.Add('Exemplar table');
for i := 0 to len-1 do begin //
if (i mod 5) = 0 then
form1.Memo1.Lines.Add('');
form1.Memo1.Text :=form1.Memo1.Text+exemplar_table[i].ToString+',';
end;
form1.Memo1.Lines.Add('');


//save exemplar & data----------------------------------------------
tss := tstringlist.Create;
tss.Add('');
tss.Strings[0] := 'exemplar= ';
for i := 0 to len-1 do begin //
if i= len-1 then
tss.Strings[0] :=tss.Strings[0]+exemplar_table[i].ToString
else
tss.Strings[0] :=tss.Strings[0]+exemplar_table[i].ToString+',';
end;
tss.SaveToFile('exemplar.txt');

//
tss.Clear;
tss.Add('');
tss.Strings[0] := 'datasrc= ';
for i := 0 to len-1 do begin //
if i= len-1 then
tss.Strings[0] :=tss.Strings[0]+'('+observ[i].X.ToString+','+observ[i].y.ToString+')'
else
tss.Strings[0] :=tss.Strings[0]+'('+observ[i].X.ToString+','+observ[i].y.ToString+'),';
end;
tss.SaveToFile('datasource.txt');
tss.Free;



//-----------------------------------------------------------

result := 1;

end;










//--------------------------------------------------
//Affinity Propa Itera
//--------------------------------------------------
function APiteration(len:longint):integer;
var
d:double;
i,index,b,numiter:integer;
mini:double;
res:integer;
K,ret,val:integer;
s:double;
freq,tstart,tend:int64;
ms:extended;
fnret: integer;
MAX_check: integer;

begin

//somtimes
//prev exemplar = current exemplar .. but its make lie convergence
//therfore we check exemplar again and again
// ex : curent = prev = rev-1 = prev -2 ......max_check
MAX_check := 10;

setlength(pex,len);
for I := 0 to len-1 do
pex[i]:=-88;
queryperformancefrequency(freq);
queryperformancecounter(tstart);


numiter:=0;

fnret:=0;
while(true) do begin


responsibility_(len);
availability_(len);

numiter := numiter+1;
ret :=exemplar_(len);
if ret = 1 then begin;
fnret := fnret+1;
end
else
fnret:=0;

if(fnret = MAX_check) then break;
end;

queryperformancecounter(tend);
form1.memo1.Lines.Add('END!!!!!!!!!');
form1.memo1.Lines.Add('');
form1.memo1.Lines.Add('number of iteration = '+(numiter-1).ToString());
ms :=(tend-tstart) / 1000;
form1.memo1.Lines.Add('time elapsed = '+ms.ToString()+' ms');

end;






//--------------------------------------------------
//Affinity Propa one dimension
//--------------------------------------------------
function Affinity_Propagation():integer;
var
d:double;
i,index,b:integer;
observf:array of tpoint;
mini:double;
res:integer;
K,ret,val,val2:integer;
datalen:integer;
s:double;
size:integer;
idx:integer;
begin
size:=7; // size of one range
datalen:=size*size; //matrix size (sizexsize = 5x5 = 25)
//datalen:=7;

setlength(observ,datalen );  //observ len= 25
setlength(similarities,datalen);  //s
setlength(responsibilities,datalen);
setlength(availabilities,datalen);
setlength(exemplar,datalen);

//set all matrixs sim & resp & avail & exemplar len
for I := 0 to datalen-1 do begin
setlength(similarities[i],datalen);
setlength(responsibilities[i],datalen);
setlength(availabilities[i],datalen);
setlength(exemplar[i],datalen);
end;


//init sim & avail == 0
for I := 0 to datalen-1 do begin
for k := 0 to datalen-1 do begin
responsibilities[i][k] := 0;
availabilities[i][k]:=0;
end;
end;


 //fill observ
 //

 idx := 0;
for I := 0 to size-1 do begin
if not odd(i) then
datalen := datalen - (size div 2)
else
datalen := datalen - ((size div 2)+1);

for k := 0 to size-1 do begin
if not odd(i) and not odd(k)  then  begin
observ[idx].x:= i;
observ[idx].y:= k;
inc(idx);
end;
if  odd(i) and  odd(k)  then  begin
observ[idx].x:= i;
observ[idx].y:= k;
inc(idx);

end;
end;

end;




form1.Memo1.Lines.Add('-----dataset------:');
form1.Memo1.Lines.Add('len: '+datalen.ToString());
for I := 0 to datalen-1 do begin
if (i > 0)and(i mod 5 = 0) then
form1.memo1.lines.Add('');
form1.Memo1.text :=form1.Memo1.text+('('+observ[i].X.ToString()+','+observ[i].y.ToString()+')  ');

end;

form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');



Similarity_(observ,datalen);
APiteration(datalen);


end;










function init_data():integer;
var
i:integer;
begin
if linecount > 2 then begin
for I := 0 to linecount-1 do
line[i].free;
end;
linecount:=0;



form1.chart.Series[0].Clear;
//updata chart
for I := 0 to length(observ)-1 do
form1.chart.Series[0].AddXY(observ[i].x,observ[i].y,'',clblue);

end;



procedure TForm1.Button1Click(Sender: TObject);
begin
memo1.Clear;
Affinity_Propagation();
Init_data();
end;












procedure TForm1.Button2Click(Sender: TObject);
var
i,j:integer;
location:tpointf;
pss:integer;

begin
chart.Series[0].clear;

if (length(observ)-1 = 0) or ( length(exemplar_table)-1 = 0) then
exit;



if linecount > 2 then begin
for I := 0 to linecount-1 do
line[i].free;
end;


linecount := length(exemplar_table)*2;
setlength(line,linecount);

for I := 0 to linecount-1 do begin
line[i]:=TLineSeries.Create(Self);
line[i].ParentChart:= chart;

Line[i].SeriesColor := clgreen;
Line[i].LinePen.Width := 2  ;

Line[i].Pointer.SizeFloat:=2.4;
Line[i].Pointer.Style:=psCircle  ;
Line[i].Pointer.Pen.Color := clred;
Line[i].Pointer.Color := clyellow ;
Line[i].Pointer.Visible := True ;
Line[i].Transparency := 50;
end;


chart.Series[0].Clear;
//updata chart
for I := 0 to length(observ)-1 do
chart.Series[0].AddXY(observ[i].x,observ[i].y,'',cllime);


// color exemplar
for I := 0 to length(exemplar_table)-1 do begin
location.x := observ[round(exemplar_table[i])].x;
location.y := observ[round(exemplar_table[i])].y;
chart.Series[0].AddXY(location.x,location.y,'',clred);
end;

//link
for I := 0 to length(exemplar_table)-1 do begin
Line[i].AddXY( observ[i].x, observ[i].y );
pss :=round(exemplar_table[i]);
Line[i].AddXY( observ[pss].x, observ[pss].y);


end;



end;












procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
i:integer;
begin
for I := 0 to linecount-1 do
line[i].free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
chart.Series[0].Clear;
linecount:=0;
end;

end.
