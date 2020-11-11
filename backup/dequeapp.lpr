program dellappl;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, udell, crt
  { you can add units after this };

type

  { dellApp }

  dellApp = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ dellApp }

procedure dellApp.DoRun;
var
  ErrorMsg, query: String;
  history: array[1..10000] of String;
  hsize, curhindex, valprovided:integer;
  k:char;
  m:dell;
  dict:array[1..8] of string = ('help', 'show', 'popback', 'popfront', 'pushback', 'pushfront', 'at','insafter');
  chopped:tstringarray;
  legit:boolean;
  i:integer;
  val:array[1..3] of integer;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

   query:='';
   hsize:=0;

  repeat begin
        hsize:=hsize+1;
        history[hsize]:='';
        query:='';
        curhindex:=hsize;
        repeat begin
              clrscr;
              write(query);
               k:=readkey;
               if k=#13 then break
               else if (k=#9) then begin

        for i:=1 to 8 do begin
           if(leftstr(dict[i],length(chopped[0]))=chopped[0]) then begin
             legit:=true;
             break;
           end;
        end;
        query:=dict[i];
                 end
               else if k=#8 then query:=leftstr(query, length(query)-1)
               else if  k=#0 then begin
                 k:=readkey;
                 if (k=#80) and (curhindex<hsize) then begin
                           curhindex:=curhindex+1;
                           query:=history[curhindex];
                 end;
                 if (k=#72) and (curhindex>1) then begin
                           curhindex:=curhindex-1;
                           query:=history[curhindex];
                 end;
               end else query:=query+k;
               if curhindex=hsize then history[hsize]:=query;
        end until false;
        if query='' then continue;
        chopped:=query.split(' ');
        valprovided:=0;
        legit:=false;
        try
           while true do  begin
              val[valprovided+1]:=strtoint(chopped[valprovided+1]);
              valprovided:=valprovided+1;
           end;
        except

        end;
        if query[1]='q' then break;
        for i:=1 to 8 do begin
           if(leftstr(dict[i],length(chopped[0]))=chopped[0]) then begin
             legit:=true;
             break;
           end;
        end;
        if legit then begin
          writeln;
              if i=1 then begin write('help, show, popback, popfront, pushback [value], pushfront [value], at [index], insafter [index] [value], q* to quit. Press Enter to continue.'); readln; end else
              if i=2 then begin show(m); write('Press Enter to continue');readln; end else
              if i=3 then pop_back(m) else
              if i=4 then pop_front(m) else
              if valprovided >0 then begin
                 if i=5 then push_back(m, val[1]) else
                 if i=6 then push_front(m, val[1]) else if (val[1]<size(m)) and (val[1]>0) then
                 if i=7 then begin writeln(at(m,val[1])); writeln('Press Enter to continue.');readln; end else
                 if (i=8) and (valprovided>1) then begin insertafter(m, val[1], val[2]); end else
                    begin
                       writeln('Value wasn`t provided, use help. Press Enter to continue.');readln;
                    end
                 else begin writeln('Index out of bounds. Press Enter to continue.');readln; end;
              end else begin write('Value or index wasn`t provided or couldnt be converted to integer. Press Enter to continue'); readln; end;
        end else begin
              writeln;
              write('Command '+chopped[0]+' not found. Try "help" and use lowercase. Press Enter to continue.'); readln;
        end;
  end until false;

  // stop program loop
  Terminate;
end;

constructor dellApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor dellApp.Destroy;
begin
  inherited Destroy;
end;

procedure dellApp.WriteHelp;
begin
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: dellApp;
begin
  Application:=dellApp.Create(nil);
  Application.Title:='Linked List';
  Application.Run;
  Application.Free;
end.

