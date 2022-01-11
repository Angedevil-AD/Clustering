 //k - medoids clustering algorithm
 //M.Aek Progs ANGEDEVIL AD
unit Unit1;

interface

uses
  Winapi.Windows,math,system.Generics.collections, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom,
  Xml.XMLDoc, Vcl.Grids;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button3: TButton;
    Label1: TLabel;
    Edit2: TEdit;
    ListBox2: TListBox;
    GroupBox1: TGroupBox;
    Button4: TButton;
    TabSheet3: TTabSheet;
    xml: TXMLDocument;
    sg: TStringGrid;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Button5: TButton;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;



type
t=tlist<double>;
type
yr=tlist<integer>;
type
cntr=tlist<string>;

type
cluster=record
element: T;
years: yr;
country: cntr;
size:integer;
sum:extended;
end;

type
XMED=record
medoid: double;
years: integer;
country: string;
end;


var
Form1: TForm1;
minn,maxx:double;
possg:longint;
prevrow:integer;
setrow:integer;
keyw:string;
XMLmedoids:array of XMED;
const
INFINITE= false;

implementation

{$R *.dfm}





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
//K Midoids one dimension
//--------------------------------------------------
function k_medoids():integer;
var
d:double;
i,index,b:integer;
observ:array of integer;
observf:array of double;
medoids:array of double;
arrcost:array of double;
cost,newcost:double;
clst:array of cluster;
mini:double;
res:integer;
end__:integer;
K:integer;
x,y:integer;
size:integer;
ret,val:integer;
bypass,cst:integer;
datalen:integer;
begin


K:= strtoint(form1.edit4.text);
datalen:=strtoint(form1.edit5.text);
setlength(observ,datalen);
setlength(observf,datalen);
setlength(arrcost,datalen-k);
setlength(medoids,k);
setlength(clst,k);


randomize;
for I := 0 to datalen-1 do begin
while True do begin
val:= random(40) +i;
ret:=check_rep(val,observf);
if ret = 0 then
break;
end;
observf[i]:= val;
observ[i]:= val;
end;


//init clusters
for I := 0 to k-1 do begin
clst[i].element := T.create;
clst[i].element := T.create;
clst[i].years := yr.create;
clst[i].sum:= 0;
end;


//gen medoids
randomize;
for I := 0 to k-1 do begin
while True do begin
val:= observ[random(length(observ)-1)];
ret:=check_rep(val,medoids);
if ret = 0 then
break;
end;
medoids[i]:=val;
clst[i].element.Add(val);
end;


form1.Memo1.Lines.Add('Medoids:');
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add(medoids[i].ToString())  ;
end;
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');


cst:=0;
bypass:=0;
for y := 0 to length(observ)-1 do begin
mini := 10000000;
index:=0;
bypass:=0;

for I := 0 to k-1 do begin

if medoids[i] = observ[y] then begin
bypass:=1;
end;


d := (power(observ[y]-medoids[i] ,2));
form1.Memo1.Lines.Add('observation: '+observ[y].ToString+'<--> Centroid: '+medoids[i].ToString+' offset: '+i.ToString+ ' distance = '+d.ToString())  ;
if d < mini then begin
index := i;
mini := d;
end;
end;

if bypass=1 then
continue;

arrcost[cst]:= mini;
inc(cst);
clst[index].element.Add(observ[y]);
form1.Memo1.Lines.Add('observation: '+observ[y].ToString+' add to '+index.ToString())  ;
end;


//get all min dist
form1.Memo1.Lines.Add('Min dist: ');
for I := 0 to length(arrcost)-1 do begin
form1.Memo1.Lines.Add(arrcost[i].ToString());
end;

//calc sum cost
cost:=0;
for I := 0 to length(arrcost)-1 do begin
cost := cost+arrcost[i];
end;
form1.Memo1.Lines.Add('cost: ');
form1.Memo1.Lines.Add(cost.ToString());

//






//SWAP //------------------------------------------------
repeat
begin
bypass:=0;
for I := 0 to k-1 do begin
clst[i].element.Clear;
while True do begin
val:= observ[random(length(observ)-1)];
ret:=check_rep(val,medoids);
if ret = 0 then
break;
end;
medoids[i]:=val;
clst[i].element.Add(val);
end;

form1.Memo1.Lines.Add('---------------------------------------');
form1.Memo1.Lines.Add('SWAP Medoids:');
form1.Memo1.Lines.Add('');
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add(medoids[i].ToString())  ;
end;
form1.Memo1.Lines.Add('---------------------------------------');
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');


cst:=0;
bypass:=0;
for y := 0 to length(observ)-1 do begin
mini := 10000000;
index:=0;
bypass:=0;
for I := 0 to k-1 do begin

if medoids[i] = observ[y] then begin
bypass:=1;
end;


d := (power(observ[y]-medoids[i] ,2));
form1.Memo1.Lines.Add('observation: '+observ[y].ToString+'<--> Centroid: '+medoids[i].ToString+' offset: '+i.ToString+ ' distance = '+d.ToString())  ;
if d < mini then begin
index := i;
mini := d;
end;
end;

if bypass=1 then
continue;

arrcost[cst]:= mini;
inc(cst);
clst[index].element.Add(observ[y]);
form1.Memo1.Lines.Add('observation: '+observ[y].ToString+' add to '+index.ToString())  ;
end;


//get all min dist
form1.Memo1.Lines.Add('Min dist: ');
for I := 0 to length(arrcost)-1 do begin
form1.Memo1.Lines.Add(arrcost[i].ToString());
end;

//calc sum cost
newcost:=0;
for I := 0 to length(arrcost)-1 do begin
newcost := newcost+arrcost[i];
end;
form1.Memo1.Lines.Add('cost: ');
form1.Memo1.Lines.Add(newcost.ToString());

if newcost > cost then
break
else
cost := newcost;
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add('Medoids '+i.ToString+' : '+medoids[i].ToString()) ;
end;

end;
until INFINITE;

//---------------------------------------------------------




//result
form1.Memo1.Lines.Add('converged:') ;
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add('Medoids '+i.ToString+' : '+medoids[i].ToString()) ;
end;
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add('cluster: '+i.ToString()+ ' size: '+clst[i].element.Count.ToString()) ;
for y := 0 to clst[i].element.Count-1 do begin
form1.Memo1.Lines.Add(clst[i].element.Items[y].ToString());
end;
end;


for I := 0 to k-1 do begin
clst[i].element.Clear;
end;



end;












//--------------------------------------------------
//K Midoids Exemple
//--------------------------------------------------
procedure TForm1.Button1Click(Sender: TObject);
begin
memo1.Clear;
if edit4.Text='' then exit;
if strlen(pchar(edit4.Text))=0 then exit;
if (strtoint(edit4.Text) = 0) then exit;

if edit5.Text='' then exit;
if strlen(pchar(edit5.Text))=0 then exit;
if (strtoint(edit5.Text) < 5) then exit;
if (strtoint(edit5.Text) < strtoint(edit4.Text)) then exit;
k_medoids();
end;































function check_repl(val:double):integer;
var
i:integer;
begin
result:= 0;

for I := 0 to form1.listbox2.count-1 do begin
if floattostr(val) = form1.listbox2.Items[i] then begin
result:= 1;
break;
end;
end;

end;














//--------------------------------------------------
//no operation
//--------------------------------------------------
function nop:bool;stdcall;
begin
asm
nop
end;
end;









//--------------------------------------------------
// Avoid Duplication  f
//--------------------------------------------------
function check_repF(val:extended;arr:array of XMED):integer;
var
i:integer;
begin
result:= 0;

for I := 0 to length(arr)-1 do begin
if val = arr[i].medoid then begin
result:= 1;
break;
end;
end;

end;














//--------------------------------------------------
// Midoids XML
// randomiz MEDIODS
//--------------------------------------------------
function RandomXMLmedoids():integer;
var
i,j:integer;
a,b:integer;
ret:integer;
val:double;
data:ixmlnode;
nodecount:integer;
fieldcount:integer;
root:ixmlnode;
rec:ixmlnode;
field:ixmlnode;
k:longint;
value:extended;
year:integer;
country:string;
begin

k:= length(xmlmedoids);
form1.xml.FileName:= 'gdp.xml';
form1.xml.Active:=true;

//root
root := form1.xml.DocumentElement;
form1.xml.DocumentElement.NextSibling;

//data
data := form1.xml.DocumentElement.ChildNodes[0];
nodecount := data.ChildNodes.Count;
//memo1.Lines.Add(nodecount.ToString());

form1.xml.DocumentElement.NextSibling;
data := form1.xml.DocumentElement.ChildNodes[0];



//random Rec
for I := 0 to k-1 do begin

while True do  begin

randomize;
rec := data.ChildNodes[random(nodecount-1)];
fieldcount := rec.ChildNodes.Count;

value:=-0.9;

for j := 0 to fieldcount-1 do begin
field := rec.ChildNodes[j];

if field.Attributes['name']='Value' then begin
if strlen(pchar(field.Text))= 0 then
nop
else if field.Text= '' then
nop
else begin
value := strtofloat(stringreplace(field.Text,'.',',',[rfIgnoreCase]));
end;
end;

if field.Attributes['name']='Year' then begin
year := strtoint(field.Text);
end;

if field.Attributes['name']='Country or Area' then begin
country := field.Text;
end;


end; //fieldcount

if value <> -0.9 then begin

ret:=check_repf(value,xmlmedoids);
if ret = 0 then
break;


end;

end;//whl

//...
xmlmedoids[i].medoid := value;
xmlmedoids[i].years := year;
xmlmedoids[i].country := country;
end;//

end;

//--------------------------------------------------
// Midoids XML
// randomiz MEDIODS
//--------------------------------------------------
procedure TForm1.Button3Click(Sender: TObject);
var
i,k:longint;

begin

listbox2.Clear;
if edit2.Text='' then exit;
if strlen(pchar(edit2.Text))=0 then exit;
if (strtoint(edit2.Text) = 0) then exit;

k:= strtoint(edit2.Text);
setlength(XMLmedoids,k);

RandomXMLmedoids();

for I := 0 to k-1 do begin
listbox2.Items.Add(floattostr(XMLmedoids[i].medoid));
end;


end;

















function Compute_OBSRV_XML():longint;
var
element:extended;
tmp:string;
mm,k,i,j,y:longint;
data:ixmlnode;
nodecount:integer;
fieldcount:integer;
root:ixmlnode;
rec:ixmlnode;
field:ixmlnode;
count:longint;
datalen: longint;
begin


result:=0;
count := 0;
form1.xml.FileName:= 'gdp.xml';
form1.xml.Active:=true;

//root

root := form1.xml.DocumentElement;
form1.xml.DocumentElement.NextSibling;

//data
data := form1.xml.DocumentElement.ChildNodes[0];
nodecount := data.ChildNodes.Count;

form1.xml.DocumentElement.NextSibling;
data := form1.xml.DocumentElement.ChildNodes[0];







for I := 0 to nodecount-1 do begin
rec := data.ChildNodes[i];
fieldcount := rec.ChildNodes.Count;
for j := 0 to fieldcount-1 do begin
field := rec.ChildNodes[j];



if field.Attributes['name'] = 'Value' then begin  // name value

if strlen(pchar(field.Text))= 0 then begin
element:=-1;
continue;
end;
tmp := stringreplace(field.Text,'.',',',[rfIgnoreCase]);
element := strtofloat(tmp);

end;


end; ///////////////
if (element=-1) then
continue;
count := count+1;
end;
result:= count;
end;















//--------------------------------------------------
// K Midoids XML
//
//--------------------------------------------------
function K_medoids_xml():integer;
var
year:longint;
tmp,country:string;
element:double;
mm,k,i,j,y:longint;
observ:array of integer;
clst:array of cluster;
arrcost:array of double;
cost,newcost:double;
cst,records:longint;
data:ixmlnode;
nodecount:integer;
fieldcount:integer;
root:ixmlnode;
rec:ixmlnode;
field:ixmlnode;
mini:extended;
index:longint;
bypass:longint;
d:extended;
datalen: longint;
begin

//compute number of observation
datalen := Compute_OBSRV_XML();

k:= length(xmlmedoids);


setlength(clst,k);
setlength(arrcost,datalen-k);

for I := 0 to k-1 do begin
clst[i].element := T.create;
clst[i].years := yr.create;
clst[i].country := cntr.create;

clst[i].sum:= 0;
clst[i].element.Add(xmlmedoids[i].medoid);
clst[i].years.Add(xmlmedoids[i].years);
clst[i].country.Add(xmlmedoids[i].country);
end;




form1.memo2.Lines.Add('Medoids:');
for I := 0 to k-1 do begin
form1.memo2.Lines.Add(xmlmedoids[i].medoid.ToString())  ;
end;
form1.memo2.Lines.Add('');
form1.memo2.Lines.Add('');
form1.Memo2.Lines.Add('');


form1.xml.FileName:= 'gdp.xml';
form1.xml.Active:=true;

//root

root := form1.xml.DocumentElement;
form1.xml.DocumentElement.NextSibling;

//data
data := form1.xml.DocumentElement.ChildNodes[0];
nodecount := data.ChildNodes.Count;

form1.xml.DocumentElement.NextSibling;
data := form1.xml.DocumentElement.ChildNodes[0];







cst:=0;
for I := 0 to nodecount-1 do begin
rec := data.ChildNodes[i];
fieldcount := rec.ChildNodes.Count;
for j := 0 to fieldcount-1 do begin
field := rec.ChildNodes[j];


if field.Attributes['name'] = 'Year' then begin  // name value
 year:=0;
year := strtoint(field.Text);
 end;

if field.Attributes['name'] = 'Country or Area' then begin // name value
country:='';
country := field.Text;
end;

if field.Attributes['name'] = 'Value' then begin  // name value

if strlen(pchar(field.Text))= 0 then begin
element:=-1;
continue;
end;
tmp := stringreplace(field.Text,'.',',',[rfIgnoreCase]);
element := strtofloat(tmp);

end;


end; ///////////////  fields
if (country='') or (year=0) or(element=-1) then
continue;



mini := 1E18;
index:=0;
bypass:=0;

for y := 0 to k-1 do begin

if xmlmedoids[y].medoid = element then begin
bypass:=1;
end;

d := sqrt(power(element- xmlmedoids[y].medoid ,2));
//form1.Memo2.Lines.Add('observation: '+element.ToString+'<--> Centroid: '+xmlmedoids[y].medoid.ToString+' offset: '+i.ToString+ ' distance = '+d.ToString())  ;
if d < mini then begin
index := y;
mini := d;
end;
end;


if bypass=0 then begin
arrcost[cst]:= mini;
inc(cst);
clst[index].element.Add(element);
clst[index].years.Add(year);
clst[index].country.Add(country);
//form1.Memo2.Lines.Add('clst: '+arrcost[cst-1].ToString())  ;

end;

end;/// records



//get all min dist
//form1.Memo2.Lines.Add('Min dist: ');
//for I := 0 to 20 do begin
//form1.Memo2.Lines.Add(arrcost[i].ToString());
//end;

//calc sum cost
cost:=0;
for I := 0 to length(arrcost)-1 do begin
cost := cost+arrcost[i];
end;
//form1.Memo2.Lines.Add('cost: ');
//form1.Memo2.Lines.Add(cost.ToString());
//form1.Memo2.Lines.Add('');
//form1.Memo2.Lines.Add('');









//SWAP //------------------------------------------------
repeat
begin
bypass:=0;
for I := 0 to k-1 do  begin
clst[i].element.Clear;
clst[i].years.Clear;
clst[i].country.Clear;
end;


RandomXMLmedoids(); //
for I := 0 to k-1 do begin
clst[i].element.Add(xmlmedoids[i].medoid);
clst[i].years.Add(xmlmedoids[i].years);
clst[i].country.Add(xmlmedoids[i].country);
end;


{
form1.Memo1.Lines.Add('---------------------------------------');
form1.Memo2.Lines.Add('SWAP Medoids:');
form1.Memo2.Lines.Add('');
for I := 0 to k-1 do begin
form1.Memo2.Lines.Add(xmlmedoids[i].medoid.ToString())  ;
end;
form1.Memo1.Lines.Add('---------------------------------------');
form1.Memo2.Lines.Add('');
form1.Memo2.Lines.Add('');
form1.Memo2.Lines.Add('');
}
cst:=0;
bypass:=0;
for I := 0 to nodecount-1 do begin
rec := data.ChildNodes[i];
fieldcount := rec.ChildNodes.Count;
for j := 0 to fieldcount-1 do begin
field := rec.ChildNodes[j];


if field.Attributes['name'] = 'Year' then begin  // name value
 year:=0;
year := strtoint(field.Text);
 end;

if field.Attributes['name'] = 'Country or Area' then begin // name value
country:='';
country := field.Text;
end;

if field.Attributes['name'] = 'Value' then begin  // name value

if strlen(pchar(field.Text))= 0 then begin
element:=-1;
continue;
end;
tmp := stringreplace(field.Text,'.',',',[rfIgnoreCase]);
element := strtofloat(tmp);

end;


end; ///////////////  fields
if (country='') or (year=0) or(element=-1) then
continue;



mini := 1E18;
index:=0;
bypass:=0;

for y := 0 to k-1 do begin

if xmlmedoids[y].medoid = element then begin
bypass:=1;
end;


d := sqrt(power(element- xmlmedoids[y].medoid ,2));
//form1.Memo2.Lines.Add('observation: '+observ[y].ToString+'<--> Centroid: '+medoids[i].ToString+' offset: '+i.ToString+ ' distance = '+d.ToString())  ;
if d < mini then begin
index := y;
mini := d;
end;
end;

if bypass=0 then begin


arrcost[cst]:= mini;
inc(cst);
clst[index].element.Add(element);
clst[index].years.Add(year);
clst[index].country.Add(country);
//form1.Memo2.Lines.Add('observation: '+element.ToString+' add to '+index.ToString())  ;

end;


end;/// records



//get all min dist
//form1.Memo2.Lines.Add('Min dist: ');
//for I := 0 to length(arrcost)-1 do begin
//form1.Memo2.Lines.Add(arrcost[i].ToString());
//end;

//calc sum cost
newcost:=0;
for I := 0 to length(arrcost)-1 do begin
newcost := newcost+arrcost[i];
end;
{
form1.Memo2.Lines.Add('cost: ');
form1.Memo2.Lines.Add(newcost.ToString());
form1.Memo2.Lines.Add('');
form1.Memo2.Lines.Add('');
}
if newcost > cost then
break
else
cost :=newcost;

{
for I := 0 to k-1 do begin
form1.Memo2.Lines.Add('newMedoids '+i.ToString+' : '+xmlmedoids[i].medoid.ToString()) ;
end;
form1.Memo2.Lines.Add('');
form1.Memo2.Lines.Add('');
}

end;
until INFINITE;



//result
form1.Memo2.Lines.Add('------------------------------') ;
form1.Memo2.Lines.Add('converged:') ;
form1.Memo2.Lines.Add('------------------------------') ;
form1.Memo2.Lines.Add('') ;

for I := 0 to k-1 do begin
form1.Memo2.Lines.Add('Medoids '+i.ToString+' : '+xmlmedoids[i].medoid.ToString()) ;
end;


form1.Memo2.Lines.Add('') ;
for I := 0 to k-1 do begin
form1.Memo2.Lines.Add('----------------------------------------------') ;
form1.Memo2.Lines.Add('cluster: '+i.ToString()+ ' size: '+clst[i].element.Count.ToString()) ;
form1.Memo2.Lines.Add('----------------------------------------------') ;
form1.Memo2.Lines.Add('') ;

{
form1.Memo2.Lines.BeginUpdate;
for y := 0 to clst[i].element.Count-1 do begin
form1.Memo2.Lines.Add('val: '+clst[i].element.Items[y].ToString());
end;
form1.Memo2.Lines.EndUpdate;
end;
}
end;



//update sg--------------
form1.sg.Cells[1,0]:= 'Country';
form1.sg.Cells[2,0]:= 'year';
form1.sg.Cells[3,0]:= 'value';

possg:=1;
records:=0;
for I := 0 to k-1 do begin
for y := 0 to clst[i].element.Count-1 do begin
if possg > 1 then
form1.sg.Rowcount:=form1.sg.Rowcount+1;
form1.sg.Cells[0,possg]:= 'Cluster ( '+i.ToString+')';
form1.sg.Cells[1,possg]:= clst[i].country.Items[y];
form1.sg.Cells[2,possg]:= clst[i].years.Items[y].ToString;
form1.sg.Cells[3,possg]:= clst[i].element.Items[y].ToString;
inc(possg);
records:= records+1;
end;
end;


form1.label3.Caption := records.ToString();

//update medoids
form1.listbox2.Clear;
for I := 0 to k-1 do begin
form1.listbox2.Items.Add(xmlmedoids[i].medoid.ToString());
end;

//clear
for I := 0 to k-1 do begin
clst[i].element.Clear;
clst[i].years.Clear;
clst[i].country.Clear;

end;


end;




















//--------------------------------------------------
//K Midoids
//--------------------------------------------------
procedure TForm1.Button4Click(Sender: TObject);
begin
memo2.Clear;
if listbox2.Count <> strtoint(edit2.Text) then
exit;
K_medoids_xml();

end;




procedure TForm1.Button5Click(Sender: TObject);
var
i:longint;
begin
sg.Invalidate;

if  edit3.Text='' then
exit;
if strlen(pchar(edit3.Text))=0 then
exit;


if keyw<> edit3.Text then
possg:=0;
for I := possg to sg.RowCount-1 do begin
if comparetext(edit3.Text,sg.Cells[1,i]) = 0 then begin
sg.Row:=i;
possg := i+1;
keyw:=edit3.Text;
setrow:= sg.Row;
exit;
end;
possg:=0;
end;



end;

procedure TForm1.FormCreate(Sender: TObject);
begin
possg:=0;
setrow:=-1;
prevrow:=-1;
end;

procedure TForm1.sgClick(Sender: TObject);
begin
sg.Invalidate;
end;

procedure TForm1.sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin


 if (ARow  = setrow) and (acol>0) then begin
 sg.Canvas.Brush.Color := clred;
 sg.Canvas.Font.Style:=[fsbold];
 sg.Canvas.Font.Color:= clyellow;
 sg.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, sg.cells[acol, arow]);
 sg.Canvas.FrameRect(Rect);
 end;

 if (ARow  = setrow) and (acol=0) then begin
 sg.Canvas.Brush.Color := clyellow;
 sg.Canvas.Font.Style:=[fsbold];
 sg.Canvas.Font.Color:= clred;
 sg.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, sg.cells[acol, arow]);
 sg.Canvas.FrameRect(Rect);
 end;

end;



end.
