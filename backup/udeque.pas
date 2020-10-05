unit udell;
interface
uses sysutils;
type node = record
  dat:integer;
  prev:^node;
  next:^node;
end;
type dell = record
  front,back:^node;
end;
procedure pop_back(var a:dell);
procedure pop_front(var a:dell);
procedure push_back(var a:dell;data:integer);
procedure push_front(var a:dell;data:integer);
function front(a:dell):integer;
function back(a:dell):integer;
function at(a:dell; ind:integer):integer;
function size(a:dell):integer;
procedure show(a:dell);
implementation
procedure pop_back(var a:dell);
begin
  if(a.back<>nil) then
                   if (a.front=a.back) then begin
                     dispose(a.front);a.front:=nil;a.back:=nil;
                   end else begin
                      a.back:=a.back^.prev; dispose(a.back^.next);a.back^.next:=nil;
                   end;
end;

procedure push_back(var a:dell; data:integer);
var newnode:^node;
begin
  new(newnode);
  newnode^.dat:=data;
  newnode^.next:=nil;
  newnode^.prev:=nil;
  if (a.back<>nil) then begin
    newnode^.prev:=a.back;
    (a.back^).next:= newnode;
    a.back:=newnode;
  end else begin

    a.front:= newnode;
    a.back:= newnode;
  end;
end;

procedure pop_front(var a:dell);
begin
     if(a.front<>nil) then if (a.front=a.back) then begin
                      dispose(a.front); a.front:=nil; a.back:=nil;
     end else begin
                      a.front:=a.front^.next;
                      dispose(a.front^.prev);
                      a.front^.prev:=nil;
     end;
end;
procedure push_front(var a:dell; data:integer);
var newnode:^node;
begin
  new(newnode);
  newnode^.dat:= data;
  newnode^.next:=nil;
  newnode^.prev:=nil;
  if(a.front=nil) then begin
                   a.front:=newnode;
                   a.back:=newnode;
  end else begin
                   a.front^.prev:=newnode;
                   newnode^.next:=a.front;
                   a.front:=newnode
  end;
end;
function size(a:dell):integer;
var n:^node;
begin
  size:=0;
  if(a.front=nil) then exit
  else begin
       n:=a.front;
       size:=1;
       while (n^.next <> nil) do begin
             size:=size+1;
             n:=n^.next;
       end;
  end;
end;
function front(a:dell):integer;
begin
    front:=a.front^.dat;
end;
function back(a:dell):integer;
begin
    back:=a.back^.dat;
end;
function at(a:dell;ind:integer):integer;
var i:integer; n:^node;
begin
     n:= a.front;
     if ind>0 then for i:= 1 to ind-1 do begin
          n:=n^.next;
     end
     else begin
           n:= a.back;
           for i:=-1 downto ind do n:=n^.prev;
     end;

     at:=n^.dat;
end;
procedure show(a:dell);
var i:integer;
begin
    write('[ ');
    for i:=1 to size(a) do write(at(a,i),' ');
    writeln(']');
end;
end.




