# Cod-Delphi-JSON-Parser
An easier refrence-count based JSON parser and reader for Delphi.

## Important notes
Do ***NOT*** use `<class-name>.Create()` unless you are planning to free the memory yourself. That creates a managed instance of the class object which *you* have to free. The **correct** way to create any values is with `<class-name>.CreateNew()`.

Examples:
Create object/array
```
TJObject.CreateNew;
TJArray.CreateNew;
```
Create other value types
```
TJValue.CreateNew('hello world') or TJString.CreateNew('hello world')
TJValue.CreateNew(true) or TJBoolean.CreateNew(true)
TJValue.CreateNew(10) or TJInteger.CreateNew(10)
TJValue.CreateNew(3.14) or TJFloat.CreateNew(3.14)
```

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
