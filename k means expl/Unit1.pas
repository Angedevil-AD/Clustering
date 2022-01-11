 //k - means clustering algorithm
 //M.Aek Progs ANGEDEVIL AD
unit Unit1;

interface

uses
  Winapi.Windows,math,activex,msxml,system.Generics.collections, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
    Button2: TButton;
    ListBox1: TListBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit1: TEdit;
    Button3: TButton;
    Label1: TLabel;
    Edit2: TEdit;
    ListBox2: TListBox;
    GroupBox1: TGroupBox;
    Button4: TButton;
    TabSheet3: TTabSheet;
    xml: TXMLDocument;
    sg: TStringGrid;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

var
Form1: TForm1;
minn,maxx:double;
possg:longint;
prevrow:integer;
setrow:integer;
keyw:string;

const
INFINITE= false;

implementation

{$R *.dfm}





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


function k_means():integer;
var
d:double;
i,index,b:integer;
observ:array of integer;
centeroid:array of double;
clst:array of cluster;
prev_clst:array of cluster;
mini:double;
res:integer;
end__:integer;
K:integer;
x,y:integer;
size:integer;
ret,val:integer;
label rep ;
begin

if form1.radiobutton3.Checked then begin
K:= 2;
setlength(observ,6);
setlength(centeroid,k);
setlength(clst,k);
setlength(prev_clst,k);


observ[0]:= 98;
observ[1]:= 8;
observ[2]:= 22;
observ[3]:= 87;
observ[4]:= 65;
observ[5]:= 20;

centeroid[0]:= 8;
centeroid[1]:= 65;


end


else if form1.radiobutton4.Checked then begin
K:= randomrange(10,20);
setlength(observ,30);
setlength(centeroid,k);
setlength(clst,k);
setlength(prev_clst,k);
for I := 0 to 29 do
observ[i]:= i+1;

for I := 0 to k-1 do begin

while True do begin
val:= randomrange(1,20);
ret:=check_rep(val,centeroid);
if ret = 0 then
break;
end;
centeroid[i]:=val;
end;



form1.Memo1.Lines.Add('center:');
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add(centeroid[i].ToString())  ;
end;
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');
form1.Memo1.Lines.Add('');

end;


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
for y := 0 to length(observ)-1 do begin
//form1.Memo1.Lines.Add('new:')  ;

mini := 10000000;
index:=0;
for I := 0 to k-1 do begin
d := (power(observ[y]-centeroid[i] ,2));
//form1.Memo1.Lines.Add('d= √('+observ[y].ToString+'-'+centeroid[i].ToString+')²')  ;
form1.Memo1.Lines.Add('observation: '+observ[y].ToString+'<--> Centroid: '+centeroid[i].ToString+' offset: '+i.ToString+ ' distance = '+d.ToString())  ;
if d < mini then begin
index := i;
mini := d;
end;
end;

clst[index].element.Add(observ[y]);
form1.Memo1.Lines.Add('observation: '+observ[y].ToString+' add to '+index.ToString())  ;

end;


form1.Memo1.Lines.Add('run all clusters:') ;
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add('cluster: '+i.ToString()+ ' size: '+clst[i].element.Count.ToString()) ;

for y := 0 to clst[i].element.Count-1 do begin
form1.Memo1.Lines.Add('ele: '+clst[i].element.Items[y].ToString());
clst[i].sum := clst[i].sum+clst[i].element.Items[y];
end;

if (clst[i].sum = 0) or (clst[i].element.Count=0)  then
centeroid[i]:= 0
else
centeroid[i]:= (clst[i].sum /clst[i].element.Count);

form1.Memo1.Lines.Add('Cluster sum: '+clst[i].sum.ToString);
form1.Memo1.Lines.Add('new center: '+centeroid[i].ToString) ;
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




procedure TForm1.Button2Click(Sender: TObject);
var
data:ixmlnode;
nodecount:integer;
fieldcount:integer;
root:ixmlnode;
rec:ixmlnode;
field:ixmlnode;
i,j:integer;
country:string;
ccmin,ccmax:string;
year,minyear,maxyear:integer;
val:extended;
tmp:string;
begin
xml.FileName:= 'gdp.xml';
xml.Active:=true;
listbox1.Clear;
ListBox1.TabWidth:= 70;


//root
root := xml.DocumentElement;
xml.DocumentElement.NextSibling;

//data
data := xml.DocumentElement.ChildNodes[0];
nodecount := data.ChildNodes.Count;
//memo1.Lines.Add(nodecount.ToString());

xml.DocumentElement.NextSibling;
data := xml.DocumentElement.ChildNodes[0];

minn :=  10000000000000 ;
maxx := -10000000000000 ;



for I := 0 to nodecount-1 do begin
rec := data.ChildNodes[i];
fieldcount := rec.ChildNodes.Count;
for j := 0 to fieldcount-1 do begin
field := rec.ChildNodes[j];
//memo1.Text :=memo1.Text+field.Attributes['name']+': ';
//memo1.Text :=memo1.Text+field.Text+' ';
//memo1.Lines.Add('');

if field.Attributes['name']='Country or Area' then
country:=field.Text;

if field.Attributes['name']='Year' then
year:=field.Text.ToInteger;

if field.Attributes['name']='Value' then begin
if strlen(pchar(field.Text))<> 0 then begin
tmp := stringreplace(field.Text,'.',',',[rfReplaceAll]);
val :=  strtofloat(tmp);
if val< minn then begin
minn := val;
ccmin:= country;
minyear := year;
end;
if val> maxx then begin
maxx := val;
ccmax:= country;
maxyear := year;
end;

end;
end;

end;

end;



listbox1.items.Add('Min Gdp Value: '+minn.ToString()+#9+minyear.ToString+#9+ 'country: '+ccmin);
listbox1.items.Add('Max Gdp Value: '+maxx.ToString()+#9+maxyear.ToString+#9+'country: '+ccmax);
groupbox1.Enabled:= true;

end;








function RND(const AR: int64): int64;
var
str:string;
lo,hi:integer;
comp:int64rec;
a,b:string;
begin

comp :=int64rec(ar);
lo :=  comp.Lo;
hi := comp.hi;
randomize;
lo:=random(lo);
hi:=random(hi);

comp.lo :=  Lo;
comp.Hi := hi;
result :=int64(comp);

end;


function RRF(mn,mx:double):double;
var
minimiz:int64;
itf:double;
it64 :int64;
i64:int64rec;
begin
minimiz := round((mx) - (mn));
minimiz:=RND(minimiz);
result := mn + minimiz;
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







procedure TForm1.Button3Click(Sender: TObject);
var
i:integer;
a,b:integer;
ret:integer;
val:double;
begin
listbox2.Clear;
if radiobutton1.Checked then begin
if strtoint(edit2.Text) <= 0 then
exit;

if listbox2.Count> strtoint(edit2.Text)-1 then
exit;

if (strtofloat(edit1.Text)< minn) or  (strtofloat(edit1.Text)> maxx)then
exit;

listbox2.Items.Add(edit1.text);
end


else if  radiobutton2.Checked  then begin


for I := 0 to strtoint(edit2.Text)-1 do begin
//listbox2.Items.Add(floattostr(RRF(minn,maxx))) ;
while True do begin
val:= RRF(minn,maxx);
ret:=check_repL(val);
if ret = 0 then
break;
end;

listbox2.Items.Add(floattostr(val));
end;

end;




end;






















procedure TForm1.Button4Click(Sender: TObject);
var
records:longint;
data:ixmlnode;
nodecount:integer;
fieldcount:integer;
root:ixmlnode;
rec:ixmlnode;
field:ixmlnode;
i,j:integer;
country:string;
ccmin,ccmax:string;
year,minyear,maxyear:integer;
val:extended;
tmp:string;
d:extended;
index,b:integer;
observ:array of integer;
centeroid:array of double;
clst:array of cluster;
prev_clst:array of cluster;
mini:double;
res:integer;
end__:integer;
K:integer;
x,y:integer;
size:integer;
element:double;
ic:integer;
mm:integer;
flag:integer;
possg:integer;
begin
if listbox2.Count <> strtoint(edit2.Text) then
exit;




K:= listbox2.Count;

setlength(centeroid,k);
setlength(clst,k);
setlength(prev_clst,k);

for I := 0 to k-1 do begin
centeroid[i]:= strtofloat(listbox2.Items[i]);
end;


for I := 0 to k-1 do begin
clst[i].element := T.create;
prev_clst[i].element := T.create;
clst[i].years := yr.create;
clst[i].country := cntr.create;
clst[i].sum:= 0;
prev_clst[i].sum:= 0;
end;

end__:=0;
b:=0;



xml.FileName:= 'gdp.xml';
xml.Active:=true;

//root

root := xml.DocumentElement;
xml.DocumentElement.NextSibling;

//data
data := xml.DocumentElement.ChildNodes[0];
nodecount := data.ChildNodes.Count;

xml.DocumentElement.NextSibling;
data := xml.DocumentElement.ChildNodes[0];


//
mm:=1;
repeat
begin
inc(mm);

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


end; ////////////

if (country='') or (year=0) or(element=-1) then
continue;





//euclidean dist
mini := 1000000000000000;
index:=0;
for Ic := 0 to k-1 do begin
d := sqrt(power(centeroid[ic] - element,2));
//form1.Memo1.Lines.Add('observation: '+element.ToString+'<--> Centroid: '+centeroid[ic].ToString+ ' distance = '+d.ToString())  ;
if d <= mini then begin
index := ic;
mini := d;
end;
end;

flag:=99;

clst[index].element.Add(element);
clst[index].years.Add(year);
clst[index].country.Add(country);


end; ///////////







for I := 0 to k-1 do begin

for y := 0 to clst[i].element.Count-1 do begin

clst[i].sum := clst[i].sum+clst[i].element.Items[y];
end;

if (clst[i].sum = 0) or (clst[i].element.Count=0)  then
centeroid[i]:= 0
else
centeroid[i]:= (clst[i].sum /clst[i].element.Count);
end;






//compare
res := 0;
if b > 0 then begin
res := 99;
for I := 0 to k-1 do begin
if clst[i].element.Count <> prev_clst[i].element.Count then begin
res:=-1;
break;
end;

size := clst[i].element.Count;
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
//form1.Memo1.Lines.Add('end ....') ;
break;
end;



//copy curr to prev
for I := 0 to k-1 do begin
prev_clst[i].element.Clear;

prev_clst[i].element := clst[i].element;

end;

//clear curr

for I := 0 to k-1 do begin
clst[i].element.Clear;
clst[i].sum:=0;
end;


inc(b);



end; //////////////
until infinite;





//result


{
form1.Memo1.Lines.Add('converged:') ;
for I := 0 to k-1 do begin
form1.Memo1.Lines.Add('cluster: '+i.ToString()+ ' size: '+clst[i].element.Count.ToString()+' centroid: '+centeroid[i].tostring) ;

for y := 0 to clst[i].element.Count-1 do begin
form1.Memo1.Lines.Add(clst[i].country.Items[y]);
form1.Memo1.Lines.Add(clst[i].years.Items[y].ToString());
form1.Memo1.Lines.Add(clst[i].element.Items[y].ToString());
end;
form1.Memo1.Lines.Add('') ;
form1.Memo1.Lines.Add('') ;
form1.Memo1.Lines.Add('') ;
end;
}





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
form1.sg.Cells[1,possg]:= clst[i].country.Items[y];;
form1.sg.Cells[2,possg]:= clst[i].years.Items[y].ToString;
form1.sg.Cells[3,possg]:= clst[i].element.Items[y].ToString;
inc(possg);
records:= records+1;
end;
end;

label3.Caption := records.ToString();



for I := 0 to k-1 do begin
clst[i].element.Clear;
prev_clst[i].element.Clear;
clst[i].years.Clear;
clst[i].country.Clear;

end;





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
prevrow:= setrow;
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
