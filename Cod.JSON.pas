{***********************************************************}
{                    Codruts JSON Parser                    }
{                                                           }
{                        version 1.0                        }
{                           BETA                            }
{                                                           }
{                                                           }
{              Developed by Petculescu Codrut               }
{            Copyright (c) 2025 Codrut Software.            }
{***********************************************************}

unit Cod.JSON;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, IOUTils;

const
  DEFAULT_IDENT = 4;

type
  // [Interfaces]
  IJValue = interface;
  IJObject = interface;
  IJArray = interface;

  IJValue = interface(IInterface)
    ['{b1327b67-c9aa-4d5a-8049-397b7634dd62}']
    function AsObject: IJObject;
    function AsArray: IJArray;
    function AsString: string;
    function AsInteger: Integer;
    function AsBoolean: Boolean;
    function AsFloat: Extended;

    function IsObject: Boolean;
    function IsArray: Boolean;
    function IsString: Boolean;
    function IsInteger: Boolean;
    function IsFloat: Boolean;
    function IsBoolean: Boolean;

    function Copy: IJValue;
    function ToJSON: string;
    function Format(Indentation: Integer=DEFAULT_IDENT; BaseIdent: Integer=0): string;
  end;

  IJObject = interface(IJValue)
    ['{fbddbaa5-cc22-4b15-b9bd-3a92ce1aa016}']
    procedure Clear;

    function GetItemKey(Index: Integer): string;
    function GetKeyIndex(Key: string): Integer;

    function KeyExists(Key: string): boolean;

    function Get(Index: Integer): IJValue; overload;
    function Get(Key: string): IJValue; overload;
    procedure Put(Index: Integer; const Value: IJValue); overload;
      procedure Put(Index: Integer; Value: string); overload;
      procedure Put(Index: Integer; Value: Integer); overload;
      procedure Put(Index: Integer; Value: Extended); overload;
      procedure Put(Index: Integer; Value: Boolean); overload;
    procedure Put(Key: string; const Value: IJValue); overload;
      procedure Put(Key: string; Value: string); overload;
      procedure Put(Key: string; Value: Integer); overload;
      procedure Put(Key: string; Value: Extended); overload;
      procedure Put(Key: string; Value: Boolean); overload;
    procedure Remove(Index: Integer); overload;
    procedure Remove(Key: string); overload;

    property Items[Key: string]: IJValue read Get write Put; default;

    function Count: Integer;
  end;

  IJArray = interface(IJValue)
    ['{dfc7c578-7bda-4a9f-b5f0-503d34e0c20c}']
    procedure Clear;

    function Get(Index: Integer): IJValue;
    procedure Put(Index: Integer; const Value: IJValue);
    procedure Remove(Index: Integer);

    function Count: Integer;

    procedure Add(Value: IJValue); overload;
      procedure Add(Value: string); overload;
      procedure Add(Value: Integer); overload;
      procedure Add(Value: Extended); overload;
      procedure Add(Value: Boolean); overload;
    procedure Insert(Index: Integer; Value: IJValue); overload;
      procedure Insert(Index: Integer; Value: string); overload;
      procedure Insert(Index: Integer; Value: Integer); overload;
      procedure Insert(Index: Integer; Value: Extended); overload;
      procedure Insert(Index: Integer; Value: Boolean); overload;

    property Items[Index: Integer]: IJValue read Get write Put; default;
  end;

  // [Classes]
  // Values pre-define
  TJNull = class;
  TJObject = class;
  TJArray = class;
  TJString = class;
  TJInteger = class;
  TJFloat = class;
  TJBoolean = class;

  // Main value
  TJValue = class(TInterfacedObject, IJValue) {By default, this represents the null class}
  public
    constructor Create;
    destructor Destroy; override;

    function AsObject: IJObject; virtual;
    function AsArray: IJArray; virtual;
    function AsString: string; virtual;
    function AsInteger: Integer; virtual;
    function AsFloat: Extended; virtual;
    function AsBoolean: Boolean; virtual;

    function IsObject: Boolean; virtual;
    function IsArray: Boolean; virtual;
    function IsString: Boolean; virtual;
    function IsInteger: Boolean; virtual;
    function IsFloat: Boolean; virtual;
    function IsBoolean: Boolean; virtual;

    function IsNull: Boolean;

    function Copy: IJValue; virtual;
    function ToJSON: string; virtual;
    function Format(Indentation: Integer=DEFAULT_IDENT; BaseIdent: Integer=0): string; virtual;

    // Constructor 2
    class function CreateNew: IJValue; overload; static; // null
    class function CreateNew(Value: string): IJValue; overload; static;
    class function CreateNew(Value: Integer): IJValue; overload; static;
    class function CreateNew(Value: Extended): IJValue; overload; static;
    class function CreateNew(Value: Boolean): IJValue; overload; static;

    class function ParseJson(Source: string): IJValue; static;
  end;

  // V*Null
  TJNull = class(TJValue);

  // V*Object
  TJObject = class(TJValue, IJObject)
  private
    FList: TList;
    type TPair = record
        Key: string;
        Item: IJValue;
      end;
      TPairP = ^TPair;

  protected
    procedure _addKey(Key: string; Value: IJValue);

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    // Value
    function AsObject: IJObject; override;
    function IsObject: Boolean; override;

    function Copy: IJValue; override;
    function ToJSON: string; override;
    function Format(Indentation: Integer=DEFAULT_IDENT; BaseIdent: integer=0): string; override;

    // List
    function GetItemKey(Index: Integer): string;
    function GetKeyIndex(Key: string): Integer;

    function KeyExists(Key: string): boolean;

    function Get(Index: Integer): IJValue; overload;
    function Get(Key: string): IJValue; overload;
    procedure Put(Index: Integer; const Value: IJValue); overload;
      procedure Put(Index: Integer; Value: string); overload;
      procedure Put(Index: Integer; Value: Integer); overload;
      procedure Put(Index: Integer; Value: Extended); overload;
      procedure Put(Index: Integer; Value: Boolean); overload;
    procedure Put(Key: string; const Value: IJValue); overload;
      procedure Put(Key: string; Value: string); overload;
      procedure Put(Key: string; Value: Integer); overload;
      procedure Put(Key: string; Value: Extended); overload;
      procedure Put(Key: string; Value: Boolean); overload;
    procedure Remove(Index: Integer); overload;
    procedure Remove(Key: string); overload;

    property Items[Key: string]: IJValue read Get write Put; default;

    function Count: Integer;

    // Constructor 2
    class function CreateNew: IJObject; static;
  end;

  // V*Array
  TJArray = class(TJValue, IJArray)
  private
    FList: TList;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    // Value
    function AsArray: IJArray; override;
    function IsArray: Boolean; override;

    function Copy: IJValue; override;
    function ToJSON: string; override;
    function Format(Indentation: Integer=DEFAULT_IDENT; BaseIdent: integer=0): string; override;

    // List
    function Get(Index: Integer): IJValue;
    procedure Put(Index: Integer; const Value: IJValue);
    procedure Remove(Index: Integer);

    function Count: Integer;

    procedure Add(Value: IJValue); overload;
      procedure Add(Value: string); overload;
      procedure Add(Value: Integer); overload;
      procedure Add(Value: Extended); overload;
      procedure Add(Value: Boolean); overload;
    procedure Insert(Index: Integer; Value: IJValue); overload;
      procedure Insert(Index: Integer; Value: string); overload;
      procedure Insert(Index: Integer; Value: Integer); overload;
      procedure Insert(Index: Integer; Value: Extended); overload;
      procedure Insert(Index: Integer; Value: Boolean); overload;

    property Items[Index: Integer]: IJValue read Get write Put; default;

    // Constructor 2
    class function CreateNew: IJArray; static;
  end;

  // V*String
  TJString = class(TJValue)
  private
    FValue: string;
  public
    constructor Create(Value: string);

    function AsString: string; override;
    function IsString: Boolean; override;

    function Copy: IJValue; override;
    function ToJSON: string; override;
  end;

  // V*Integer
  TJInteger = class(TJValue)
  private
    FValue: Integer;
  public
    constructor Create(Value: Integer);

    function AsInteger: Integer; override;
    function IsInteger: Boolean; override;

    function Copy: IJValue; override;
    function ToJSON: string; override;
  end;

  // V*Float
  TJFloat = class(TJValue)
  private
    FValue: Extended;
  public
    constructor Create(Value: Extended);

    function AsFloat: Extended; override;
    function IsFloat: Boolean; override;

    function Copy: IJValue; override;
    function ToJSON: string; override;
  end;

  // V*Boolean
  TJBoolean = class(TJValue)
  private
    FValue: Boolean;
  public
    constructor Create(Value: Boolean);

    function AsBoolean: Boolean; override;
    function IsBoolean: Boolean; override;

    function Copy: IJValue; override;
    function ToJSON: string; override;
  end;

// Functions
function StringToJValue(Json: string): IJValue;

type
  TEJIncorrectJValueType = type Exception;
  TEJInvalidJsonFormat = type Exception;

implementation

function StringToJValue(Json: string): IJValue;
begin
  Result := TJValue.ParseJson(JSON);
end;

function CreateIdent(Count: integer): string;
begin
  Result := '';
  for var I := 1 to Count do
    Result := Result + ' ';
end;

function StringValueToJSONString(const Value: string): string;
var
  P, PEnd: PChar;
  UnicodeValue: Integer;
  Buff: array [0 .. 5] of Char;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('"'); // Open quote

    P := PChar(Value);
    PEnd := P + Length(Value);

    while P < PEnd do
    begin
      case P^ of
        '"': SB.Append('\"');
        '\': SB.Append('\\');
        '/': SB.Append('\/');
        #$8: SB.Append('\b');
        #$9: SB.Append('\t');
        #$a: SB.Append('\n');
        #$c: SB.Append('\f');
        #$d: SB.Append('\r');
        #0 .. #7, #$b, #$e .. #31, #$80 .. High(Char):
          begin
            UnicodeValue := Ord(P^);
            Buff[0] := '\';
            Buff[1] := 'u';
            Buff[2] := IntToHex((UnicodeValue shr 12) and $F, 1)[1];
            Buff[3] := IntToHex((UnicodeValue shr 8) and $F, 1)[1];
            Buff[4] := IntToHex((UnicodeValue shr 4) and $F, 1)[1];
            Buff[5] := IntToHex(UnicodeValue and $F, 1)[1];
            SB.Append(Buff);
          end;
      else
        SB.Append(P^);
      end;
      Inc(P);
    end;

    SB.Append('"'); // Close quote
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

{ TJValue }

function TJValue.AsArray: IJArray;
begin
  raise TEJIncorrectJValueType.Create('JValue is not of [ARRAY] type.');
end;

function TJValue.AsBoolean: Boolean;
begin
  raise TEJIncorrectJValueType.Create('JValue is not of [BOOLEAN] type.');
end;

function TJValue.AsFloat: Extended;
begin
  raise TEJIncorrectJValueType.Create('JValue is not of [FLOAT] type.');
end;

function TJValue.AsInteger: Integer;
begin
  raise TEJIncorrectJValueType.Create('JValue is not of [INTEGER] type.');
end;

function TJValue.AsObject: IJObject;
begin
  raise TEJIncorrectJValueType.Create('JValue is not of [OBJECT] type.');
end;

function TJValue.AsString: string;
begin
  raise TEJIncorrectJValueType.Create('JValue is not of [STRING] type.');
end;

function TJValue.Copy: IJValue;
begin
  Result := TJValue.Create;
end;

constructor TJValue.Create;
begin
  inherited Create;
end;

class function TJValue.CreateNew(Value: string): IJValue;
begin
  Result := TJString.Create(Value);
end;

class function TJValue.CreateNew(Value: Integer): IJValue;
begin
  Result := TJInteger.Create(Value);
end;

class function TJValue.CreateNew(Value: Extended): IJValue;
begin
  Result := TJFloat.Create(Value);
end;

class function TJValue.CreateNew(Value: Boolean): IJValue;
begin
  Result := TJBoolean.Create(Value);
end;

class function TJValue.CreateNew: IJValue;
begin
  Result := TJValue.Create;
end;

destructor TJValue.Destroy;
begin
  inherited;
end;

function TJValue.Format(Indentation: Integer; BaseIdent: Integer): string;
begin
  Result := ToJSON;
end;

function TJValue.IsArray: Boolean;
begin
  Result := false;
end;

function TJValue.IsBoolean: Boolean;
begin
  Result := false;
end;

function TJValue.IsFloat: Boolean;
begin
  Result := false;
end;

function TJValue.IsInteger: Boolean;
begin
  Result := false;
end;

function TJValue.IsNull: Boolean;
begin
  Result := not (IsObject or IsArray or IsString or IsInteger or IsFloat or IsBoolean);
end;

function TJValue.IsObject: Boolean;
begin
  Result := false;
end;

function TJValue.IsString: Boolean;
begin
  Result := false;
end;

class function TJValue.ParseJson(Source: string): IJValue;
var
  S: string;

  I: integer;
  F: Extended;
  Fmt: TFormatSettings;
begin
  S := Trim(Source);

  // String
  if (Length(S) >= 2) and (S[1] = '"') and (S[Length(S)] = '"') then
    Exit(TJString.Create( System.Copy(S, 2, Length(S)-2) ));

  // Boolean
  if SameText(S, 'true') then
    Exit(TJBoolean.Create(True));
  if SameText(S, 'false') then
    Exit(TJBoolean.Create(False));

  // Null
  if SameText(S, 'null') then
    Exit(TJNull.Create);

  // Object
  if (Length(S) >= 2) and (S[1] = '{') and (S[Length(S)] = '}') then begin
    var Obj := TJObject.Create;
    var Content := Trim(System.Copy(S, 2, Length(S)-2));
    if Content <> '' then
    begin
        I := 1;
        var Key, ValueStr: string;
        var InString, InEscape, InValueString: Boolean;
        var Braces, Brackets: Integer;
        var StartPos, SepPos: Integer;
        while I <= Length(Content) do
        begin
            // Find key
            while (I <= Length(Content)) and (Content[I] <= ' ') do Inc(I);
            if (I > Length(Content)) or (Content[I] <> '"') then
                raise TEJInvalidJsonFormat.Create('Expected string key at position ' + I.ToString);
            InString := True; InEscape := False; StartPos := I + 1;
            Inc(I);
            while (I <= Length(Content)) and InString do
            begin
                if InEscape then
                    InEscape := False
                else if Content[I] = '\' then
                    InEscape := True
                else if Content[I] = '"' then
                    InString := False;
                Inc(I);
            end;
            Key := System.Copy(Content, StartPos, I-StartPos-1);

            // Find colon
            while (I <= Length(Content)) and (Content[I] <= ' ') do Inc(I);
            if (I > Length(Content)) or (Content[I] <> ':') then
                raise TEJInvalidJsonFormat.Create('Expected ":" after key at position ' + I.ToString);
            Inc(I);

            // Find value
            while (I <= Length(Content)) and (Content[I] <= ' ') do Inc(I);
            StartPos := I;
            Braces := 0; Brackets := 0; InValueString := False; InEscape := False;
            while I <= Length(Content) do
            begin
                var C := Content[I];
                if InValueString then
                begin
                    if InEscape then
                        InEscape := False
                    else if C = '\' then
                        InEscape := True
                    else if C = '"' then
                        InValueString := False;
                end
                else
                begin
                    if C = '"' then
                        InValueString := True
                    else if C = '{' then
                        Inc(Braces)
                    else if C = '}' then
                    begin
                        if Braces = 0 then Break;
                        Dec(Braces);
                    end
                    else if C = '[' then
                        Inc(Brackets)
                    else if C = ']' then
                        Dec(Brackets)
                    else if (C = ',') and (Braces = 0) and (Brackets = 0) then
                        Break;
                end;
                Inc(I);
            end;
            SepPos := I;
            ValueStr := Trim(System.Copy(Content, StartPos, SepPos-StartPos));
            const P = TJValue.ParseJson(ValueStr).ToJSON;
            Obj.Put(Key, TJValue.ParseJson(ValueStr));
            // Skip comma
            while (I <= Length(Content)) and ((Content[I] = ',') or (Content[I] <= ' ')) do Inc(I);
        end;
    end;
    Exit(Obj);
  end;

  // Array
  if (Length(S) >= 2) and (S[1] = '[') and (S[Length(S)] = ']') then
  begin
    var Arr := TJArray.Create;
    var Content := Trim(System.Copy(S, 2, Length(S)-2));
    if Content <> '' then
    begin
        I := 1;
        var StartPos: Integer;
        var InString, InEscape: Boolean;
        var Braces, Brackets: Integer;
        while I <= Length(Content) do
        begin
            // Skip whitespace
            while (I <= Length(Content)) and (Content[I] <= ' ') do Inc(I);
            if I > Length(Content) then Break;
            StartPos := I;
            Braces := 0; Brackets := 0; InString := False; InEscape := False;
            while I <= Length(Content) do
            begin
                var C := Content[I];
                if InString then
                begin
                    if InEscape then
                        InEscape := False
                    else if C = '\' then
                        InEscape := True
                    else if C = '"' then
                        InString := False;
                end
                else
                begin
                    if C = '"' then
                        InString := True
                    else if C = '{' then
                        Inc(Braces)
                    else if C = '}' then
                        Dec(Braces)
                    else if C = '[' then
                        Inc(Brackets)
                    else if C = ']' then
                        Dec(Brackets)
                    else if (C = ',') and (Braces = 0) and (Brackets = 0) then
                        Break;
                end;
                Inc(I);
            end;
            var ValueStr := Trim(System.Copy(Content, StartPos, I-StartPos));
            if ValueStr <> '' then
                Arr.Add(TJValue.ParseJson(ValueStr));
            // Skip comma
            while (I <= Length(Content)) and ((Content[I] = ',') or (Content[I] <= ' ')) do Inc(I);
        end;
    end;
    Exit(Arr);
  end;

  // Integer
  if TryStrToInt(S, I) then
    Exit(TJInteger.Create(I));

  // Float
  Fmt.DecimalSeparator := '.';
  if TryStrToFloat(S, F, Fmt) then
    Exit(TJFloat.Create(F));

  raise TEJInvalidJsonFormat.Create('Invalid Json format provided.');
end;

function TJValue.ToJSON: string;
begin
  Result := 'null';
end;

function TJObject.AsObject: IJObject;
begin
  Result := Self;
end;

procedure TJObject.Clear;
var
  I: Integer;
begin
  // Free list records
  for I := 0 to Count-1 do begin
    TPairP(FList[I])^.Item._Release; // release reference

    FreeMem(FList[I], SizeOf(TPair));
  end;

  FList.Clear;
end;

function TJObject.Copy: IJValue;
var
  I: integer;
  Obj: TPairP;
begin
  Result := TJObject.Create;

  for I := 0 to Count-1 do begin
    // Allocate clone item
    Obj := AllocMem(SizeOf(TPair));

    const NewCopy = TPairP(FList[I])^.Item.Copy; NewCopy._AddRef; // create reference

    Obj.Key := TPairP(FList[I])^.Key;
    Obj.Item := NewCopy;

    // Append
    TJObject(Result).FList.Add( Obj );
  end;
end;

function TJObject.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TJObject.Create;
begin
  inherited Create;

  FList := TList.Create;
end;

class function TJObject.CreateNew: IJObject;
begin
  Result := TJObject.Create;
end;

destructor TJObject.Destroy;
begin
  // Free items
  Clear;

  // Free list
  FreeAndNil(FList);

  inherited;
end;

function TJObject.Format(Indentation: Integer; BaseIdent: integer): string;
var
  Items: TArray<string>;
  I: Integer;
  Content: string;
begin
  SetLength(Items, Count);
  for I := 0 to Count-1 do
    Items[I] := CreateIdent(BaseIdent+Indentation)
      +StringValueToJSONString(TPairP(FList[I])^.Key)+': '+TPairP(FList[I])^.Item.Format(Indentation, BaseIdent+Indentation);

  Content := '';
  if Length(Items) > 0 then
    Content := #13+string.Join(','#13, Items)+#13;
  Result := CreateIdent(BaseIdent)+'{'
    +Content
    +CreateIdent(BaseIdent)+'}';
end;

function TJObject.Get(Index: Integer): IJValue;
begin
  Result := TPairP(FList[Index])^.Item.Copy;
end;

function TJObject.Get(Key: string): IJValue;
begin
  Result := TPairP(FList[GetKeyIndex(Key)])^.Item.Copy;
end;

function TJObject.GetItemKey(Index: Integer): string;
begin
  Result := TPairP(FList[Index])^.Key;
end;

function TJObject.GetKeyIndex(Key: string): Integer;
var
  I: Integer;
begin
  for I := 0 to Count-1 do
    if Key = TPairP(FList[I])^.Key then
      Exit(I);
  Exit(-1);
end;

function TJObject.IsObject: Boolean;
begin
  Result := true;
end;

function TJObject.KeyExists(Key: string): boolean;
begin
  Result := GetKeyIndex(Key) <> -1;
end;

procedure TJObject.Put(Key: string; const Value: IJValue);
var
  Index: integer;
begin
  Index := GetKeyIndex(Key);
  if Index = -1 then
    _addKey(Key, Value)
  else
    Put( Index, Value);
end;

procedure TJObject.Put(Index: Integer; const Value: IJValue);
begin
  TPairP(FList[Index])^.Item._Release; // release reference
  const NewCopy = Value.Copy; NewCopy._AddRef; // create reference

  TPairP(FList[Index])^.Item := NewCopy;
end;

procedure TJObject.Remove(Key: string);
begin
  Remove( GetKeyIndex(Key) );
end;

procedure TJObject.Remove(Index: integer);
begin
  if (Index >= 0) and (Index < FList.Count) then begin
    TPairP(FList[Index])^.Item._Release; // release reference

    // Free memory
    FreeMem(FList[Index], SizeOf(TPair));
  end;

  // Delete
  FList.Delete( Index );
end;

function TJObject.ToJSON: string;
var
  Items: TArray<string>;
  I: Integer;
begin
  SetLength(Items, Count);
  for I := 0 to Count-1 do
    Items[I] := StringValueToJSONString(TPairP(FList[I])^.Key)+':'+TPairP(FList[I])^.Item.ToJSON;
  Result := '{'+string.Join(',', Items)+'}';
end;

procedure TJObject._addKey(Key: string; Value: IJValue);
var
  Obj: TPairP;
  InsertIndex: integer;
begin
  const NewCopy = Value.Copy; NewCopy._AddRef; // create reference

  Obj := AllocMem(SizeOf(TPair));

  Obj.Key := Key;
  Obj.Item := NewCopy;

  // Get insert index
  InsertIndex := FList.Count;
  while (InsertIndex > 0)
    and (Obj.Key < TPairP(FList[InsertIndex-1])^.Key) do
      Dec(InsertIndex);

  // Insert object
  FList.Insert(InsertIndex, Obj);
end;

constructor TJArray.Create;
begin
  inherited Create;

  FList := TList.Create;
end;

class function TJArray.CreateNew: IJArray;
begin
  Result := TJArray.Create;
end;

destructor TJArray.Destroy;
begin
  // Free items
  Clear;

  // Free list
  FreeAndNil(FList);

  inherited;
end;

function TJArray.Format(Indentation, BaseIdent: integer): string;
var
  Items: TArray<string>;
  I: Integer;
  Content: string;
begin
  SetLength(Items, Count);
  for I := 0 to Count-1 do
    Items[I] := CreateIdent(BaseIdent+Indentation)
      +IJValue(FList[I]).Format(Indentation, BaseIdent+Indentation);

  Content := '';
  if Length(Items) > 0 then
    Content := #13+string.Join(','#13, Items)+#13;
  Result := CreateIdent(BaseIdent)+'['
    +Content
    +CreateIdent(BaseIdent)+']';
end;

function TJArray.Get(Index: Integer): IJValue;
begin
  Result := IJValue(FList[Index]).Copy;
end;

procedure TJArray.Add(Value: IJValue);
begin
  const NewCopy = Value.Copy; NewCopy._AddRef; // create reference

  FList.Add( NewCopy );
end;

procedure TJArray.Add(Value: Boolean);
begin Add( TJValue.CreateNew(Value) ); end;

procedure TJArray.Add(Value: Extended);
begin Add( TJValue.CreateNew(Value) ); end;

procedure TJArray.Add(Value: Integer);
begin Add( TJValue.CreateNew(Value) ); end;

procedure TJArray.Add(Value: string);
begin Add( TJValue.CreateNew(Value) ); end;

function TJArray.AsArray: IJArray;
begin
  Result := Self;
end;

procedure TJArray.Insert(Index: integer; Value: IJValue);
begin
  const NewCopy = Value.Copy; NewCopy._AddRef; // create reference

  FList.Insert( Index, NewCopy );
end;

procedure TJArray.Insert(Index: Integer; Value: Boolean);
begin Insert( Index, TJValue.CreateNew(Value) ); end;

procedure TJArray.Insert(Index: Integer; Value: Extended);
begin Insert( Index, TJValue.CreateNew(Value) ); end;

procedure TJArray.Insert(Index, Value: Integer);
begin Insert( Index, TJValue.CreateNew(Value) ); end;

procedure TJArray.Insert(Index: Integer; Value: string);
begin Insert( Index, TJValue.CreateNew(Value) ); end;

function TJArray.IsArray: Boolean;
begin
  Result := true;
end;

procedure TJArray.Put(Index: integer; const Value: IJValue);
begin
  IJValue(FList[Index])._Release; // release reference
  const NewCopy = Value.Copy; NewCopy._AddRef; // create reference

  FList[Index] := NewCopy;
end;

procedure TJArray.Clear;
begin
  FList.Clear;
end;

procedure TJArray.Remove(Index: integer);
begin
  IJValue(FList[Index])._Release; // release reference

  FList.Delete(Index);
end;

function TJArray.Copy: IJValue;
var
  I: integer;
begin
  Result := TJArray.Create;

  for I := 0 to Count-1 do
    TJArray(Result).Add( IJValue(FList[I]) ); // a copy will be created in Add()
end;

function TJArray.ToJSON: string;
var
  Items: TArray<string>;
  I: Integer;
begin
  SetLength(Items, Count);
  for I := 0 to Count-1 do
    Items[I] := IJValue(FList[I]).ToJSON;
  Result := '[' + string.Join(',', Items) + ']';
end;

function TJArray.Count: Integer;
begin
  Result := FList.Count;
end;


{ TJString }

function TJString.AsString: string;
begin
  Result := FValue;
end;

function TJString.Copy: IJValue;
begin
  Result := TJString.Create(FValue);
end;

constructor TJString.Create(Value: string);
begin
  FValue := Value;
  inherited Create;
end;

function TJString.IsString: Boolean;
begin
  Result := true;
end;

function TJString.ToJSON: string;
begin
  Result := StringValueToJSONString(FValue);
end;

{ TJInteger }

function TJInteger.AsInteger: Integer;
begin
  Result := FValue;
end;

function TJInteger.Copy: IJValue;
begin
  Result := TJInteger.Create(FValue);
end;

constructor TJInteger.Create(Value: Integer);
begin
  FValue := Value;
  inherited Create;
end;

function TJInteger.IsInteger: Boolean;
begin
  Result := true;
end;

function TJInteger.ToJSON: string;
begin
  Result := FValue.ToString;
end;

{ TJFloat }

function TJFloat.AsFloat: Extended;
begin
  Result := FValue;
end;

function TJFloat.Copy: IJValue;
begin
  Result := TJFloat.Create(FValue);
end;

constructor TJFloat.Create(Value: Extended);
begin
  FValue := Value;
  inherited Create;
end;

function TJFloat.IsFloat: Boolean;
begin
  Result := true;
end;

function TJFloat.ToJSON: string;
begin
  Result := FValue.ToString;
end;

{ TJBoolean }

function TJBoolean.AsBoolean: Boolean;
begin
  Result := FValue;
end;

function TJBoolean.Copy: IJValue;
begin
  Result := TJBoolean.Create(FValue);
end;

constructor TJBoolean.Create(Value: Boolean);
begin
  FValue := Value;
  inherited Create;
end;

function TJBoolean.IsBoolean: Boolean;
begin
  Result := true;
end;

function TJBoolean.ToJSON: string;
begin
  if FValue then Exit('true') else Exit('false');
end;

{ TJObject.TPair }

procedure TJObject.Put(Index: Integer; Value: Boolean);
begin Put( Index, TJValue.CreateNew(Value) ); end;

procedure TJObject.Put(Index: Integer; Value: Extended);
begin Put( Index, TJValue.CreateNew(Value) ); end;

procedure TJObject.Put(Index, Value: Integer);
begin Put( Index, TJValue.CreateNew(Value) ); end;

procedure TJObject.Put(Index: Integer; Value: string);
begin Put( Index, TJValue.CreateNew(Value) ); end;

procedure TJObject.Put(Key: string; Value: Boolean);
begin Put( Key, TJValue.CreateNew(Value) ); end;

procedure TJObject.Put(Key: string; Value: Extended);
begin Put( Key, TJValue.CreateNew(Value) ); end;

procedure TJObject.Put(Key: string; Value: Integer);
begin Put( Key, TJValue.CreateNew(Value) ); end;

procedure TJObject.Put(Key, Value: string);
begin Put( Key, TJValue.CreateNew(Value) ); end;

end.