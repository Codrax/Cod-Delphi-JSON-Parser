# Cod-Delphi-JSON-Parser
An easier refrence-count based JSON parser and reader for Delphi.


## Examples
```
var
  Obj: IJObject;
begin
  Obj := TJValue.ParseJson('{"cats":123, "items":false, "rub":{"why":false, "name":"lol"}}') as IJObject;

  ShowMessage( Obj.Format );
```
```
var
  Obj: IJObject;
begin
  Obj := TJObject.CreateNew;

  Obj.Put('name', 'David');
  Obj.Put('age', 22);
  Obj.Put('height', 150.23);
  Obj.Put('employed', true);

  ShowMessage( Obj.Format );
```
```
var
  Obj: IJObject;
  Arr: IJArray;
begin
  Obj := TJObject.CreateNew;

  Obj.Put('name', 'David');
  Obj.Put('age', 22);
  Obj.Put('height', 150.23);
  Obj.Put('employed', true);

  // Get
  ShowMessage( Obj['name'].AsString );

  // Test
  if Obj['height'].IsBoolean then
    ShowMessage( Obj['height'].AsBoolean.ToString )
  else
    if Obj['height'].IsFloat then
      ShowMessage( Obj['height'].AsFloat.ToString );

  // Array
  Obj['items'] := TJValue.ParseJson('["hello", "world"]');

  if Obj.KeyExists('items') then
    if Obj['items'].IsArray  then
      ShowMessage(
        Obj['items'].AsArray.ToJSON
        );
```
