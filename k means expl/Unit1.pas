 //k - means algorithm
 //M.Aek Progs ANGEDEVIL AD
unit Unit1;

interface

uses
  Winapi.Windows,math,system.Generics.collections, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;


TYPE
t=tlist<integer>;
type
cluster=record
element: T;
size:integer;
sum:integer;
end;

var
Form1: TForm1;
const
INFINITE= false;

implementation

{$R *.dfm}





function k_means():integer;
var
d:double;
i,index,b:integer;
observ:array of integer;
centroid:array of double;
clst:array of cluster;
prev_clst:array of cluster;
mini:double;
res:integer;
end__:integer;
K:integer;
x,y:integer;
size:integer;
begin

K:= 3;
setlength(observ,13);
setlength(centroid,k);
setlength(clst,k);
setlength(prev_clst,k);


observ[0]:= 98;
observ[1]:= 8;
observ[2]:= 22;
observ[3]:= 87;
observ[4]:= 65;
observ[5]:= 20;
observ[6]:= 201;
observ[7]:= 94;
observ[8]:= 390;
observ[9]:= 395;
observ[10]:= 145;
observ[11]:= 74;
observ[12]:= 54;

centroid[0]:= 40;
centroid[1]:= 94;
centroid[2]:= 410;




for I := 0 to k-1 do begin
clst[i].element := T.create;
prev_clst[i].element := T.create;
clst[i].sum:= 0;
prev_clst[i].sum:= 0;
end;

end__:=0;




b:=0;
repeat
begin


form1.Memo1.Lines.Add('calc euclidean distance:')  ;
for y := 0 to 12 do begin
form1.Memo1.Lines.Add('new:')  ;

mini := 100000;
index:=0;
for I := 0 to k-1 do begin
d := sqrt(power(centroid[i] - observ[y],2)+power(centroid[i] - observ[y],2));
form1.Memo1.Lines.Add('observation: '+observ[y].ToString+'<--> Centroid: '+centroid[i].ToString+ ' distance = '+d.ToString())  ;
if d < mini then
index := i;
mini := d;
end;

clst[index].element.Add(observ[y]);

end;


form1.Memo1.Lines.Add('run all clusters:') ;
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add('cluster: '+i.ToString()+ ' size: '+clst[i].element.Count.ToString()) ;

for y := 0 to clst[i].element.Count-1 do begin
form1.Memo1.Lines.Add(clst[i].element.Items[y].ToString());
clst[i].sum := clst[i].sum+clst[i].element.Items[y];
end;

if (clst[i].sum = 0) or (clst[i].element.Count=0)  then
centroid[i]:= 0
else
centroid[i]:= (clst[i].sum /clst[i].element.Count);

form1.Memo1.Lines.Add('Cluster sum: '+clst[i].sum.ToString);
form1.Memo1.Lines.Add('new center: '+centroid[i].ToString) ;
form1.Memo1.Lines.Add('');
end;


//compare
res := 0;
if b > 0 then begin
res := 99;
for I := 0 to k-1 do begin
size := min(clst[i].element.Count,prev_clst[i].element.Count);
if size =0 then
size:=1;
for y := 0 to size-1 do begin

if clst[i].element.Items[y] <> prev_clst[i].element.Items[y] then begin
res := -1;
end;

end;
end;


if res=99 then
end__:=1;
end;


if(end__=1) then begin
form1.Memo1.Lines.Add('end ....') ;
break;
end;

//copy curr to prev
for I := 0 to k-1 do begin
prev_clst[i].element.Clear;
for y := 0 to clst[i].element.Count-1 do begin
prev_clst[i].element := clst[i].element;
end;
end;

//clear curr
for I := 0 to k-1 do begin
clst[i].element.Clear;
clst[i].sum:=0;
end;

inc(b);
end;

until INFINITE;



//result
form1.Memo1.Lines.Add('converged:') ;
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add('cluster: '+i.ToString()+ ' size: '+clst[i].element.Count.ToString()) ;
for y := 0 to clst[i].element.Count-1 do begin
form1.Memo1.Lines.Add(clst[i].element.Items[y].ToString());
end;
end;


for I := 0 to k-1 do begin
clst[i].element.Clear;
prev_clst[i].element.Clear;
end;



end;














procedure TForm1.Button1Click(Sender: TObject);
begin
memo1.Clear;
k_means();
end;

end.
