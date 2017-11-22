unit UDebuggerTests;

interface

uses
   Classes, SysUtils, Variants, ComObj,
   dwsXPlatformTests, dwsComp, dwsCompiler, dwsExprs, dwsErrors, dwsInfo,
   dwsUtils, dwsSymbols, dwsDebugger, dwsStrings, dwsEvaluate, dwsScriptSource,
   dwsCompilerContext;

type

   TDebuggerTests = class (TTestCase)
      private
         FCompiler : TDelphiWebScript;
         FUnits : TdwsUnit;
         FDebugger : TdwsDebugger;

         FDebugEvalAtLine : Integer;
         FDebugEvalExpr : String;
         FDebugLastEvalResult : String;
         FDebugLastMessage : String;
         FDebugLastNotificationPos : TScriptPos;
         FDebugResumed : Integer;

         procedure DoCreateExternal(Info: TProgramInfo; var ExtObject: TObject);
         procedure DoCleanupExternal(externalObject : TObject);
         procedure DoGetValue(Info: TProgramInfo; ExtObject: TObject);

         procedure DoDebugEval(exec: TdwsExecution; expr: TExprBase);
         procedure DoDebugMessage(const msg : String);
         procedure DoDebugExceptionNotification(const exceptObj : IInfo);
         procedure DoDebugSuspended(sender : TObject);

         procedure DoToggleBreakpointEnabled(info : TProgramInfo);

      public
         procedure SetUp; override;
         procedure TearDown; override;

      published
         procedure EvaluateSimpleTest;
         procedure EvaluateOutsideOfExec;
         procedure EvaluateContextTest;
         procedure EvaluateLocalVar;
         procedure EvaluateBlockVar;
         procedure EvaluateAfterBlock;
         procedure EvaluateArray;

         procedure ExecutableLines;

         procedure AttachToScript;

         procedure DebugMessage;

         procedure ExceptionNotification;

         procedure BreakpointsStatic;
         procedure BreakpointsDynamic;
   end;

   TDebuggerOptimizedTests = class (TDebuggerTests)
      public
         procedure SetUp; override;
   end;


// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

type
   TTestObject = class
      private
         FField : String;
      public
         constructor Create(const value : String);
   end;

// Create
//
constructor TTestObject.Create(const value : String);
begin
   FField:=value;
end;

// ------------------
// ------------------ TDebuggerTests ------------------
// ------------------

// SetUp
//
procedure TDebuggerTests.SetUp;
var
   cls : TdwsClass;
   cst : TdwsConstructor;
   meth : TdwsMethod;
   fn : TdwsFunction;
   p : TdwsParameter;
begin
   FCompiler:=TDelphiWebScript.Create(nil);
   FCompiler.Config.CompilerOptions:=[coContextMap, coAssertions];
   FUnits:=TdwsUnit.Create(nil);
   FUnits.UnitName:='TestUnit';
   FUnits.Script:=FCompiler;
   FDebugger:=TdwsDebugger.Create(nil);
   FDebugger.OnDebug:=DoDebugEval;
   FDebugger.OnDebugMessage:=DoDebugMessage;
   FDebugger.OnNotifyException:=DoDebugExceptionNotification;
   FDebugger.OnDebugSuspended:=DoDebugSuspended;

   cls:=FUnits.Classes.Add;
   cls.Name:='TTestClass';
   cls.OnCleanUp:=DoCleanupExternal;
   cst:=cls.Constructors.Add as TdwsConstructor;
   cst.Name:='Create';
   cst.OnEval:=DoCreateExternal;

   meth:=cls.Methods.Add as TdwsMethod;
   meth.ResultType:='String';
   meth.Name:='GetValue';
   meth.OnEval:=DoGetValue;

   fn := FUnits.Functions.Add;
   fn.Name := 'ToggleBreakpointEnabled';
   p := fn.Parameters.Add;
   p.Name := 'index';
   p.DataType := SYS_INTEGER;
   fn.OnEval := DoToggleBreakpointEnabled;
end;

// TearDown
//
procedure TDebuggerTests.TearDown;
begin
   FDebugger.Free;
   FUnits.Free;
   FCompiler.Free;
end;

// DoCreateExternal
//
procedure TDebuggerTests.DoCreateExternal(Info: TProgramInfo; var ExtObject: TObject);
begin
   ExtObject:=TTestObject.Create('Hello');
end;

// DoCleanupExternal
//
procedure TDebuggerTests.DoCleanupExternal(externalObject : TObject);
begin
   externalObject.Free;
end;

// DoGetValue
//
procedure TDebuggerTests.DoGetValue(Info: TProgramInfo; ExtObject: TObject);
begin
   Info.ResultAsString:=(ExtObject as TTestObject).FField;
end;

// DoDebugEval
//
procedure TDebuggerTests.DoDebugEval(exec: TdwsExecution; expr: TExprBase);
var
   p : TScriptPos;
begin
   p:=expr.ScriptPos;
   if p.Line=FDebugEvalAtLine then
      FDebugLastEvalResult:=FDebugger.EvaluateAsString(FDebugEvalExpr, @p);
end;

// DoDebugMessage
//
procedure TDebuggerTests.DoDebugMessage(const msg : String);
begin
   FDebugLastMessage:=msg;
end;

// DoDebugExceptionNotification
//
procedure TDebuggerTests.DoDebugExceptionNotification(const exceptObj : IInfo);
var
   expr : TExprBase;
begin
   if exceptObj<>nil then
      expr:=exceptObj.Exec.GetLastScriptErrorExpr
   else expr:=nil;
   if expr<>nil then
      FDebugLastNotificationPos:=expr.ScriptPos
   else FDebugLastNotificationPos:=cNullPos;
end;

// DoDebugSuspended
//
procedure TDebuggerTests.DoDebugSuspended(sender : TObject);
begin
   Inc(FDebugResumed);
   FDebugger.Resume;
end;

// DoToggleBreakpointEnabled
//
procedure TDebuggerTests.DoToggleBreakpointEnabled(info : TProgramInfo);
var
   bp : TdwsDebuggerBreakpoint;
begin
   bp := FDebugger.Breakpoints[info.ParamAsInteger[0]];
   bp.Enabled := not bp.Enabled;
end;

// EvaluateSimpleTest
//
procedure TDebuggerTests.EvaluateSimpleTest;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
   expr : IdwsEvaluateExpr;
   buf : String;
begin
   prog:=FCompiler.Compile('var i := 10;');
   try
      exec:=prog.BeginNewExecution;
      try
         exec.RunProgram(0);

         CheckEquals(10, exec.Info.ValueAsInteger['i'], 'value of i');

         expr:=TdwsEvaluateExpr.Evaluate(exec, 'i+i*10');
         try
            CheckEquals(110, expr.Expression.EvalAsInteger(exec.ExecutionObject), 'i+i*10');
         finally
            expr:=nil;
         end;

         expr:=TdwsEvaluateExpr.Evaluate(exec, 'StrToInt(''123'')');
         try
            CheckEquals(123, expr.Expression.EvalAsInteger(exec.ExecutionObject), 'StrToInt(''123'')');
         finally
            expr:=nil;
         end;

         expr:=TdwsEvaluateExpr.Evaluate(exec, 'i +* i');
         try
            expr.Expression.EvalAsString(exec.ExecutionObject, buf);
            CheckEquals('Syntax Error: Expression expected [line: 1, column: 4]', buf, 'i +* i');
         finally
            expr:=nil;
         end;

      finally
         exec.EndProgram;
         exec:=nil;
      end;
   finally
      prog:=nil;
   end;
end;

// EvaluateOutsideOfExec
//
procedure TDebuggerTests.EvaluateOutsideOfExec;
var
   expr : IdwsEvaluateExpr;
begin
   expr:=TdwsEvaluateExpr.Evaluate(nil, 'StrToInt(''113'')+10');
   try
      CheckEquals(123, expr.Expression.EvalAsInteger(expr.Execution.ExecutionObject), 'StrToInt(''113'')+10');
   finally
      expr:=nil;
   end;
end;

// EvaluateContextTest
//
procedure TDebuggerTests.EvaluateContextTest;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   prog:=FCompiler.Compile( 'var i := 1;'#13#10
                           +'procedure Test;'#13#10
                           +'var i := 2;'#13#10
                           +'begin'#13#10
                              +'PrintLn(i);'#13#10    // line 5
                           +'end;'#13#10
                           +'Test;');                 // line 7

   try
      exec:=prog.CreateNewExecution;
      try
         FDebugEvalExpr:='i';

         FDebugEvalAtLine:=5;
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('2', FDebugLastEvalResult, 'i at line 5');
         finally
            FDebugger.EndDebug;
         end;

         FDebugEvalAtLine:=7;
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('1', FDebugLastEvalResult, 'i at line 7');
         finally
            FDebugger.EndDebug;
         end;
      finally
         exec:=nil;
      end;
   finally
      prog:=nil;
   end;
end;

// EvaluateLocalVar
//
procedure TDebuggerTests.EvaluateLocalVar;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   prog:=FCompiler.Compile( 'for var i := 1 to 1 do'#13#10
                              +'PrintLn(i);');
   try
      exec:=prog.CreateNewExecution;
      try
         FDebugEvalExpr:='i';

         FDebugEvalAtLine:=2;
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('1', FDebugLastEvalResult, 'i at line 2');
         finally
            FDebugger.EndDebug;
         end;
      finally
         exec:=nil;
      end;
   finally
      prog:=nil;
   end;
end;

// EvaluateBlockVar
//
procedure TDebuggerTests.EvaluateBlockVar;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   prog:=FCompiler.Compile( 'begin'#13#10
                           +'var i := 123;'#13#10
                           +'Print(i);'#13#10
                           +'end');
   try
      exec:=prog.CreateNewExecution;
      try
         FDebugEvalExpr:='i';

         FDebugEvalAtLine:=3;
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('123', FDebugLastEvalResult, 'i at line 3');
         finally
            FDebugger.EndDebug;
         end;
      finally
         exec:=nil;
      end;
   finally
      prog:=nil;
   end;
end;

// EvaluateAfterBlock
//
procedure TDebuggerTests.EvaluateAfterBlock;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   FCompiler.Config.CompilerOptions := FCompiler.Config.CompilerOptions + [coOptimize];
   prog:=FCompiler.Compile( 'var a := 0;'#13#10
                           +'var b := 0;'#13#10
                           +'repeat'#13#10
                           +'   begin'#13#10
                           +'      var x :=0;'#13#10
                           +'   end'#13#10
                           +'until  (a=b) ;');
   try
      exec:=prog.CreateNewExecution;
      try
         FDebugEvalExpr:='a';

         FDebugEvalAtLine:=7;
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('0', FDebugLastEvalResult, 'a at line 7');
         finally
            FDebugger.EndDebug;
         end;
      finally
         exec:=nil;
      end;
   finally
      FCompiler.Config.CompilerOptions := FCompiler.Config.CompilerOptions - [coOptimize];
      prog:=nil;
   end;
end;

// EvaluateArray
//
procedure TDebuggerTests.EvaluateArray;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   prog:=FCompiler.Compile( 'var a : array of String; for var i := 1 to 3 do a.Add("*"+i.ToString);'#13#10
                           +'PrintLn(a.Join(","));');
   try
      FDebugEvalAtLine:=2;

      exec:=prog.CreateNewExecution;
      try
         FDebugEvalExpr:='a';
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('array of String', FDebugLastEvalResult, 'a at line 2');
         finally
            FDebugger.EndDebug;
         end;
      finally
         exec:=nil;
      end;

      exec:=prog.CreateNewExecution;
      try
         FDebugEvalExpr:='a.Length';
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('3', FDebugLastEvalResult, 'a.Length at line 2');
         finally
            FDebugger.EndDebug;
         end;
      finally
         exec:=nil;
      end;

      exec:=prog.CreateNewExecution;
      try
         FDebugEvalExpr:='a.Join(";")';
         FDebugLastEvalResult:='';
         FDebugger.BeginDebug(exec);
         try
            CheckEquals('*1;*2;*3', FDebugLastEvalResult, 'a.Join(";") at line 2');
         finally
            FDebugger.EndDebug;
         end;
      finally
         exec:=nil;
      end;
   finally
      prog:=nil;
   end;
end;

// ExecutableLines
//
procedure TDebuggerTests.ExecutableLines;
var
   prog : IdwsProgram;
   breakpointables : TdwsBreakpointableLines;

   function ReportBreakpointables : String;
   var
      i, j : Integer;
      lines : TBits;
      sourceNames : TStringList;
   begin
      Result:='';
      sourceNames:=TStringList.Create;
      try
         breakpointables.Enumerate(sourceNames);
         sourceNames.Sort;
         for i:=0 to sourceNames.Count-1 do begin
            if i>0 then
               Result:=Result+#13#10;
            Result:=Result+sourceNames[i]+': ';
            lines:=sourceNames.Objects[i] as TBits;
            for j:=0 to lines.Size-1 do
               if lines[j] then
                  Result:=Result+IntToStr(j)+',';
         end;
      finally
         sourceNames.Free;
      end;
   end;

begin
   prog:=FCompiler.Compile( 'var i := 1;'#13#10
                           +'procedure Test;'#13#10
                           +'var i := 2;'#13#10
                           +'begin'#13#10
                              +'PrintLn(i);'#13#10
                           +'end;'#13#10
                           +'Test;');
   CheckEquals('2'#13#10, prog.Execute.Result.ToString, 'Result 1');

   breakpointables:=TdwsBreakpointableLines.Create(prog);
   CheckEquals('*MainModule*: 1,3,5,7,', ReportBreakpointables, 'Case 1');
   breakpointables.Free;

   prog:=FCompiler.Compile( 'var i := 1;'#13#10
                           +'procedure Test;'#13#10
                           +'begin'#13#10
                              +'var i := 2;'#13#10
                              +'PrintLn(i);'#13#10
                           +'end;'#13#10
                           +'i:=i+1;');
   CheckEquals('', prog.Execute.Result.ToString, 'Result 2');

   breakpointables:=TdwsBreakpointableLines.Create(prog);
   CheckEquals('*MainModule*: 1,4,5,7,', ReportBreakpointables, 'Case 2');
   breakpointables.Free;
end;

// AttachToScript
//
procedure TDebuggerTests.AttachToScript;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   prog:=FCompiler.Compile( 'var i : Integer;'#13#10
                           +'procedure Test;'#13#10
                           +'begin'#13#10
                              +'Print(Inc(i));'#13#10
                           +'end;'#13#10
                           +'Test;');

   CheckEquals('', prog.Msgs.AsInfo, 'compile');

   exec:=prog.BeginNewExecution;

   exec.RunProgram(0);
   try
      CheckEquals('1', exec.Result.ToString, 'run');

      FDebugger.AttachDebug(exec);

      CheckEquals('1', FDebugger.EvaluateAsString('i'), 'eval after attach');

      exec.Info.Func['Test'].Call;

      CheckEquals('2', FDebugger.EvaluateAsString('i'), 'eval after call');
      CheckEquals('12', exec.Result.ToString, 'result after call');

      FDebugger.DetachDebug;

      CheckEquals(DBG_NotDebugging, FDebugger.EvaluateAsString('i'), 'eval after detach');

      exec.Info.Func['Test'].Call;

      CheckEquals('123', exec.Result.ToString, 'result after re-call');
   finally
      exec.EndProgram;
   end;
end;

// DebugMessage
//
procedure TDebuggerTests.DebugMessage;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   prog:=FCompiler.Compile( 'OutputDebugString("hello");');

   CheckEquals('', prog.Msgs.AsInfo, 'compile');

   FDebugLastMessage:='';

   exec:=prog.CreateNewExecution;

   FDebugger.BeginDebug(exec);
   FDebugger.EndDebug;

   CheckEquals('', exec.Msgs.AsInfo, 'exec');
   CheckEquals('hello', FDebugLastMessage, 'msg');
end;

// ExceptionNotification
//
procedure TDebuggerTests.ExceptionNotification;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;

   procedure RunExceptNotification(const source : String);
   begin
      prog:=FCompiler.Compile(source);
      CheckEquals('', prog.Msgs.AsInfo, 'compile '+source);

      FDebugLastNotificationPos:=cNullPos;

      exec:=prog.CreateNewExecution;

      FDebugger.BeginDebug(exec);
      FDebugger.EndDebug;
   end;


begin
   RunExceptNotification('var i : Integer;'#13#10'raise Exception.Create("here");');
   CheckEquals(' [line: 2, column: 31]', FDebugLastNotificationPos.AsInfo, '1');

   RunExceptNotification('var i : Integer; Assert(False);');
   CheckEquals(' [line: 1, column: 18]', FDebugLastNotificationPos.AsInfo, '2');

   RunExceptNotification('var i : Integer;'#13#10'try i := i div i; except end;');
   CheckEquals(' [line: 2, column: 12]', FDebugLastNotificationPos.AsInfo, '3');

   RunExceptNotification('procedure Test;'#13#10'begin'#13#10'var i:=0;'#13#10'i := i div i;'#13#10'end;'#13#10'Test');
   CheckEquals(' [line: 4, column: 8]', FDebugLastNotificationPos.AsInfo, '4');
end;

// BreakpointsStatic
//
procedure TDebuggerTests.BreakpointsStatic;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   FDebugger.Breakpoints.Add(2, SYS_MainModule);
   try
      prog := FCompiler.Compile( 'var a := "a";'#13#10
                                +'a += "b";'#13#10
                                +'a += "c";'#13#10);
      FDebugEvalExpr := 'a';
      FDebugEvalAtLine := 3;

      FDebugLastEvalResult := '';
      FDebugResumed := 0;

      exec := prog.CreateNewExecution;
      FDebugger.BeginDebug(exec);
      FDebugger.EndDebug;

      CheckEquals(1, FDebugResumed, 'Breakpoint not resumed');
      CheckEquals('ab', FDebugLastEvalResult, 'with breakpoint');

      FDebugLastEvalResult := '';
      FDebugResumed := 0;
      FDebugger.Breakpoints[0].Enabled := False;

      exec := prog.CreateNewExecution;
      FDebugger.BeginDebug(exec);
      FDebugger.EndDebug;

      CheckEquals(0, FDebugResumed, 'Breakpoint resumed');
      CheckEquals('ab', FDebugLastEvalResult, 'with breakpoint disabled');
   finally
      FDebugger.Breakpoints.Clear;
   end;
end;

// BreakpointsDynamic
//
procedure TDebuggerTests.BreakpointsDynamic;
var
   prog : IdwsProgram;
   exec : IdwsProgramExecution;
begin
   FDebugger.Breakpoints.Add(3, SYS_MainModule);
   try
      prog := FCompiler.Compile( 'var a := "a";'#13#10
                                +'ToggleBreakpointEnabled(0);'#13#10
                                +'a += "b";'#13#10
                                +'Print(a);');
      CheckEquals('', prog.Msgs.AsInfo);

      FDebugResumed := 0;

      exec := prog.CreateNewExecution;
      FDebugger.BeginDebug(exec);
      FDebugger.EndDebug;

      CheckEquals(0, FDebugResumed, 'disabled at runtime');
      CheckEquals('ab', exec.Result.ToString, 'case 1');

      FDebugger.Breakpoints[0].Enabled := False;

      exec := prog.CreateNewExecution;
      FDebugger.BeginDebug(exec);
      FDebugger.EndDebug;

      CheckEquals(1, FDebugResumed, 'enabled at runtime');
      CheckEquals('ab', exec.Result.ToString, 'case 2');
   finally
      FDebugger.Breakpoints.Clear;
   end;
end;

// ------------------
// ------------------ TDebuggerOptimizedTests ------------------
// ------------------

// SetUp
//
procedure TDebuggerOptimizedTests.SetUp;
begin
   inherited SetUp;
   FCompiler.Config.CompilerOptions:=FCompiler.Config.CompilerOptions+[coOptimize];
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

   RegisterTest('DebuggerTests', TDebuggerTests);
   RegisterTest('DebuggerOptimizedTests', TDebuggerOptimizedTests);

end.
