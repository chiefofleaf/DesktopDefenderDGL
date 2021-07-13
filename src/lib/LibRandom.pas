unit LibRandom;

interface

uses
  LibMaterial;

type
  TPossibility = record
    option: Integer;
    chance: Double;
  end;

  TLootTable = TArray<TPossibility>;

  function LootFromTable(Table: TLootTable; count: Integer): TArray<Integer>;

implementation

function LootFromTable(Table: TLootTable; count: Integer): TArray<Integer>;
var
  i, j: Integer;
  r, chanceAcc, chanceSum: Double;
begin
  chanceSum := 0;

  for i := 0 to Length(Table) - 1 do begin
    chanceSum := chanceSum + Table[i].chance;
  end;

  SetLength(Result, count);

  for i := 0 to count - 1 do begin

    r := Random * chanceSum;
    chanceAcc := 0;
    j := -1;

    repeat
      j := j + 1;
      chanceAcc := chanceAcc + Table[j].chance;
    until chanceAcc >= r;

    Result[i] := Table[j].option;
  end;

end;

end.
