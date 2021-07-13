unit LibRandomTest;

interface

procedure PerformLootTableTest;

implementation

uses
  LibRandom, LibMaterial, Sysutils, Vcl.Dialogs;

procedure PerformLootTableTest;
var
  i, count: Integer;
  Table: TLootTable;
  arr: TArray<Integer>;
  s: string;
begin
  SetLength(Table, Integer(High(TMaterialType)));
  for i := 0 to Length(Table) - 1 do begin
    Table[i].option := i;
    Table[i].chance := 1;
  end;

  Table[1].chance := 5;
  Table[2].chance := 1;

  count := 10000;
  arr := LootFromTable(Table, count);

  for i := 0 to Length(Table) - 1 do begin
    Table[i].chance := 0;
  end;

  for i := 0 to Length(arr) - 1 do begin
    Table[arr[i]].chance := Table[arr[i]].chance + 1;
  end;

  for i := 0 to Length(Table) - 1 do begin
    s := Format('%s%d: %f%%%s', [s, Table[i].option, Table[i].chance/count*100, #13#10]);
  end;
  showmessage(s);
end;

end.
