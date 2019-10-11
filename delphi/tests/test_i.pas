
program TestALGLIB;
{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}
{$APPTYPE CONSOLE}

uses
    SysUtils, Math, XALGLIB;

function doc_test_bool(val: Boolean; test_val: Boolean):Boolean;
begin
    Exit((val and test_val) or ((not val) and (not test_val)));
end;

function doc_test_int(val: TALGLIBInteger; test_val: TALGLIBInteger):Boolean;
begin
    Exit(val=test_val);
end;

function doc_test_real(val: Double; test_val: Double; _threshold: Double):Boolean;
var
    s, threshold: Double;
begin
    s:=IfThen(_threshold>=0, 1.0, Abs(test_val)); 
    threshold:=Abs(_threshold);
    Exit(Abs(val-test_val)/s<=threshold);
end;

function doc_test_complex(val: Complex; test_val: Complex; _threshold: Double):Boolean;
var
    s, threshold: Double;
begin
    s:=IfThen(_threshold>=0, 1.0, C_Abs(test_val));
    threshold:=Abs(_threshold);
    Exit(C_Abs(C_Sub(val,test_val))/s<=threshold);
end;

function doc_test_bool_vector(const val: TBVector; const test_val: TBVector):Boolean;
var
    I: TALGLIBInteger;
begin
    if xlen(val)<>xlen(test_val) then
        Exit(False);
    for i:=0 to xlen(val)-1 do
        if not doc_test_bool(val[i],test_val[i]) then
            Exit(false);
    Exit(true);
end;

function doc_test_int_vector(const val: TIVector; const test_val: TIVector):Boolean;
var
    I: TALGLIBInteger;
begin
    if xlen(val)<>xlen(test_val) then
        Exit(False);
    for i:=0 to xlen(val)-1 do
        if not doc_test_int(val[i],test_val[i]) then
            Exit(false);
    Exit(true);
end;

function doc_test_real_vector(const val: TVector; const test_val: TVector; threshold: Double):Boolean;
var
    I: TALGLIBInteger;
begin
    if xlen(val)<>xlen(test_val) then
        Exit(False);
    for i:=0 to xlen(val)-1 do
        if not doc_test_real(val[i],test_val[i], threshold) then
            Exit(false);
    Exit(true);
end;

function doc_test_complex_vector(const val: TCVector; const test_val: TCVector; threshold: Double):Boolean;
var
    I: TALGLIBInteger;
begin
    if xlen(val)<>xlen(test_val) then
        Exit(False);
    for i:=0 to xlen(val)-1 do
        if not doc_test_complex(val[i],test_val[i], threshold) then
            Exit(false);
    Exit(true);
end;

function doc_test_bool_matrix(const val: TBMatrix; const test_val: TBMatrix):Boolean;
var
    I, J: TALGLIBInteger;
begin
    if xrows(val)<>xrows(test_val) then
        Exit(false);
    if xcols(val)<>xcols(test_val) then
        Exit(false);
    for i:=0 to xrows(val)-1 do
        for j:=0 to xcols(val)-1 do
            if not doc_test_bool(val[i,j],test_val[i,j]) then
                Exit(false);
    Exit(true);
end;

function doc_test_int_matrix(const val: TIMatrix; const test_val: TIMatrix):Boolean;
var
    I, J: TALGLIBInteger;
begin
    if xrows(val)<>xrows(test_val) then
        Exit(false);
    if xcols(val)<>xcols(test_val) then
        Exit(false);
    for i:=0 to xrows(val)-1 do
        for j:=0 to xcols(val)-1 do
            if not doc_test_int(val[i,j],test_val[i,j]) then
                Exit(false);
    Exit(true);
end;

function doc_test_real_matrix(const val: TMatrix; const test_val: TMatrix; threshold: Double):Boolean;
var
    I, J: TALGLIBInteger;
begin
    if xrows(val)<>xrows(test_val) then
        Exit(false);
    if xcols(val)<>xcols(test_val) then
        Exit(false);
    for i:=0 to xrows(val)-1 do
        for j:=0 to xcols(val)-1 do
            if not doc_test_real(val[i,j],test_val[i,j],threshold) then
                Exit(false);
    Exit(true);
end;

function doc_test_complex_matrix(const val: TCMatrix; const test_val: TCMatrix; threshold: Double):Boolean;
var
    I, J: TALGLIBInteger;
begin
    if xrows(val)<>xrows(test_val) then
        Exit(false);
    if xcols(val)<>xcols(test_val) then
        Exit(false);
    for i:=0 to xrows(val)-1 do
        for j:=0 to xcols(val)-1 do
            if not doc_test_complex(val[i,j],test_val[i,j],threshold) then
                Exit(false);
    Exit(true);
end;

procedure spoil_vector_by_adding_element(var X: TBVector);overload;
var
    i: TALGLIBInteger;
    y: TBVector;
begin
    y:=x;
    SetLength(x, xlen(y)+1);
    for i:=0 to xlen(y)-1 do
        x[i]:=y[i];
    x[xlen(y)]:=Random()>0.5;
end;

procedure spoil_vector_by_adding_element(var X: TIVector);overload;
var
    i: TALGLIBInteger;
    y: TIVector;
begin
    y:=x;
    SetLength(x, xlen(y)+1);
    for i:=0 to xlen(y)-1 do
        x[i]:=y[i];
    x[xlen(y)]:=Random(5)-2;
end;

procedure spoil_vector_by_adding_element(var X: TVector);overload;
var
    i: TALGLIBInteger;
    y: TVector;
begin
    y:=x;
    SetLength(x, xlen(y)+1);
    for i:=0 to xlen(y)-1 do
        x[i]:=y[i];
    x[xlen(y)]:=Random()-0.5;
end;

procedure spoil_vector_by_adding_element(var X: TCVector);overload;
var
    i: TALGLIBInteger;
    y: TCVector;
begin
    y:=x;
    SetLength(x, xlen(y)+1);
    for i:=0 to xlen(y)-1 do
        x[i]:=y[i];
    x[xlen(y)].x:=Random()-0.5;
    x[xlen(y)].y:=Random()-0.5;
end;

procedure spoil_vector_by_deleting_element(var x: TBVector);overload;
var
    I: TALGLIBInteger;
    y: TBVector;
begin
    y:=x;
    SetLength(x, xlen(y)-1);
    for i:=0 to xlen(y)-2 do
        x[i]:=y[i];
end;

procedure spoil_vector_by_deleting_element(var x: TIVector);overload;
var
    I: TALGLIBInteger;
    y: TIVector;
begin
    y:=x;
    SetLength(x, xlen(y)-1);
    for i:=0 to xlen(y)-2 do
        x[i]:=y[i];
end;

procedure spoil_vector_by_deleting_element(var x: TVector);overload;
var
    I: TALGLIBInteger;
    y: TVector;
begin
    y:=x;
    SetLength(x, xlen(y)-1);
    for i:=0 to xlen(y)-2 do
        x[i]:=y[i];
end;

procedure spoil_vector_by_deleting_element(var x: TCVector);overload;
var
    I: TALGLIBInteger;
    y: TCVector;
begin
    y:=x;
    SetLength(x, xlen(y)-1);
    for i:=0 to xlen(y)-2 do
        x[i]:=y[i];
end;

procedure spoil_matrix_by_adding_row(var x: TBMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TBMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)+1, xcols(y));
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for j:=0 to xcols(y)-1 do
        x[xrows(y),j]:=Random()>0.5;
end;

procedure spoil_matrix_by_adding_row(var x: TIMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TIMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)+1, xcols(y));
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for j:=0 to xcols(y)-1 do
        x[xrows(y),j]:=Random(5)-2;
end;

procedure spoil_matrix_by_adding_row(var x: TMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)+1, xcols(y));
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for j:=0 to xcols(y)-1 do
        x[xrows(y),j]:=Random()-0.5;
end;

procedure spoil_matrix_by_adding_row(var x: TCMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TCMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)+1, xcols(y));
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for j:=0 to xcols(y)-1 do
    begin
        x[xrows(y),j].x:=Random()-0.5;
        x[xrows(y),j].y:=Random()-0.5;
    end;
end;

procedure spoil_matrix_by_deleting_row(var x: TBMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TBMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)-1, xcols(y));
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_matrix_by_deleting_row(var x: TIMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TIMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)-1, xcols(y));
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_matrix_by_deleting_row(var x: TMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)-1, xcols(y));
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_matrix_by_deleting_row(var x: TCMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TCMatrix;
begin
    y:=x;
    SetLength(x, xrows(y)-1, xcols(y));
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_matrix_by_adding_col(var x: TBMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TBMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)+1);
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for i:=0 to xrows(y)-1 do
        x[i,xcols(y)]:=Random()>0.5;
end;

procedure spoil_matrix_by_adding_col(var x: TIMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TIMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)+1);
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for i:=0 to xrows(y)-1 do
        x[i,xcols(y)]:=Random(5)-2;
end;

procedure spoil_matrix_by_adding_col(var x: TMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)+1);
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for i:=0 to xrows(y)-1 do
        x[i,xcols(y)]:=Random()-0.5;
end;

procedure spoil_matrix_by_adding_col(var x: TCMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TCMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)+1);
    for i:=0 to xrows(y)-1 do
        for j:=0 to xcols(y)-1 do
            x[i,j]:=y[i,j];
    for i:=0 to xrows(y)-1 do
    begin
        x[i,xcols(y)].x:=Random()-0.5;
        x[i,xcols(y)].y:=Random()-0.5;
    end;
end;

procedure spoil_matrix_by_deleting_col(var x: TBMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TBMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)-1);
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_matrix_by_deleting_col(var x: TIMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TIMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)-1);
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_matrix_by_deleting_col(var x: TMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)-1);
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_matrix_by_deleting_col(var x: TCMatrix);overload;
var
    i, j: TALGLIBInteger;
    y: TCMatrix;
begin
    y:=x;
    SetLength(x, xrows(y), xcols(y)-1);
    for i:=0 to xrows(x)-1 do
        for j:=0 to xcols(x)-1 do
            x[i,j]:=y[i,j];
end;

procedure spoil_vector_by_value(var x: TBVector; val: Boolean);overload;
begin
    if xlen(x)>0 then
        x[random(xlen(x))]:=val;
end;

procedure spoil_vector_by_value(var x: TIVector; val: TALGLIBInteger);overload;
begin
    if xlen(x)>0 then
        x[random(xlen(x))]:=val;
end;

procedure spoil_vector_by_value(var x: TVector; val: Double);overload;
begin
    if xlen(x)>0 then
        x[random(xlen(x))]:=val;
end;

procedure spoil_vector_by_value(var x: TCVector; val: Complex);overload;
begin
    if xlen(x)>0 then
        x[random(xlen(x))]:=val;
end;

procedure spoil_matrix_by_value(var x: TBMatrix; val: Boolean);overload;
begin
    if xrows(x)*xcols(x)>0 then
        x[random(xrows(x)),random(xcols(x))]:=val;
end;

procedure spoil_matrix_by_value(var x: TIMatrix; val: TALGLIBInteger);overload;
begin
    if xrows(x)*xcols(x)>0 then
        x[random(xrows(x)),random(xcols(x))]:=val;
end;

procedure spoil_matrix_by_value(var x: TMatrix; val: Double);overload;
begin
    if xrows(x)*xcols(x)>0 then
        x[random(xrows(x)),random(xcols(x))]:=val;
end;

procedure spoil_matrix_by_value(var x: TCMatrix; val: Complex);overload;
begin
    if xrows(x)*xcols(x)>0 then
        x[random(xrows(x)),random(xcols(x))]:=val;
end;

procedure function1_func(const x: TVector; var func: Double; obj: Pointer);
begin
    //
    // This callback calculates f(x0,x1) = 100*(x0+3)^4 + (x1-3)^4
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    func := 100*Power(x[0]+3,4) + Power(x[1]-3,4);
end;
procedure function1_grad(const x: TVector; var func: Double; grad: TVector; obj: Pointer);
begin
    //
    // This callback calculates:
    // * f(x0,x1) = 100*(x0+3)^4 + (x1-3)^4
    // * and its derivatives df/d0 and df/dx1
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite grad parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(grad,N)".
    //
    //            The reason is that grad points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with grad parameter without
    //            reallocation/reinitializing it.
    //
    func := 100*Power(x[0]+3,4) + Power(x[1]-3,4);
    grad[0] := 400*Power(x[0]+3,3);
    grad[1] := 4*Power(x[1]-3,3);
end;
procedure function1_hess(const x: TVector; var func: Double; grad: TVector; hess: TMatrix; obj: Pointer);
begin
    //
    // This callback calculates:
    // * f(x0,x1) = 100*(x0+3)^4 + (x1-3)^4
    // * its derivatives df/d0 and df/dx1
    // * and its Hessian.
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite grad parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(grad,N)".
    //
    //            The reason is that grad points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with grad parameter without
    //            reallocation/reinitializing it. Similarly for hess.
    //
    func := 100*Power(x[0]+3,4) + Power(x[1]-3,4);
    grad[0] := 400*Power(x[0]+3,3);
    grad[1] := 4*Power(x[1]-3,3);
    hess[0,0] := 1200*Power(x[0]+3,2);
    hess[0,1] := 0;
    hess[1,0] := 0;
    hess[1,1] := 12*Power(x[1]-3,2);
end;
procedure function1_fvec(const x: TVector; fi: TVector; obj: Pointer);
begin
    //
    // This callback calculates
    // * f0(x0,x1) = 100*(x0+3)^4,
    // * f1(x0,x1) = (x1-3)^4
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi parameter without
    //            reallocation/reinitializing it.
    //
    //
    fi[0] := 10*Power(x[0]+3,2);
    fi[1] := Power(x[1]-3,2);
end;
procedure function1_jac(const x: TVector; fi: TVector; jac: TMatrix; obj: Pointer);
begin
    //
    // This callback calculates
    // * f0(x0,x1) = 100*(x0+3)^4,
    // * f1(x0,x1) = (x1-3)^4
    // * and Jacobian matrix J = [dfi/dxj]
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi/jac parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi/jac point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi/jac parameters without
    //            reallocation/reinitializing them.
    //
    fi[0] := 10*Power(x[0]+3,2);
    fi[1] := Power(x[1]-3,2);
    jac[0,0] := 20*(x[0]+3);
    jac[0,1] := 0;
    jac[1,0] := 0;
    jac[1,1] := 2*(x[1]-3);
end;
procedure function2_func(const x: TVector; var func: Double; obj: Pointer);
begin
    //
    // This callback calculates f(x0,x1) = (x0^2+1)^2 + (x1-1)^2
    //
    func := Power(x[0]*x[0]+1,2) + Power(x[1]-1,2);
end;
procedure function2_grad(const x: TVector; var func: Double; grad: TVector; obj: Pointer);
begin
    //
    // This callback calculates
    // * f(x0,x1) = (x0^2+1)^2 + (x1-1)^2
    // * and its derivatives df/d0 and df/dx1
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite grad parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(grad,N)".
    //
    //            The reason is that grad points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with grad parameter without
    //            reallocation/reinitializing it.
    //
    func := Power(x[0]*x[0]+1,2) + Power(x[1]-1,2);
    grad[0] := 4*(x[0]*x[0]+1)*x[0];
    grad[1] := 2*(x[1]-1);
end;
procedure function2_hess(const x: TVector; var func: Double; grad: TVector; hess: TMatrix; obj: Pointer);
begin
    //
    // this callback calculates f(x0,x1) = (x0^2+1)^2 + (x1-1)^2
    // its gradient and Hessian
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite grad/hess parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(grad,N)".
    //
    //            The reason is that grad/hess point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with grad/hess parameter without
    //            reallocation/reinitializing them.
    //
    //
    func := Power(x[0]*x[0]+1,2) + Power(x[1]-1,2);
    grad[0] := 4*(x[0]*x[0]+1)*x[0];
    grad[1] := 2*(x[1]-1);
    hess[0,0] := 12*x[0]*x[0]+4;
    hess[0,1] := 0;
    hess[1,0] := 0;
    hess[1,1] := 2;
end;
procedure function2_fvec(const x: TVector; fi: TVector; obj: Pointer);
begin
    //
    // This callback calculates
    // * f0(x0,x1) = 100*(x0+3)^4,
    // * f1(x0,x1) = (x1-3)^4
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi parameter without
    //            reallocation/reinitializing it.
    //
    //
    fi[0] := x[0]*x[0]+1;
    fi[1] := x[1]-1;
end;
procedure function2_jac(const x: TVector; fi: TVector; jac: TMatrix; obj: Pointer);
begin
    //
    // This callback calculates
    // * f0(x0,x1) = x0^2+1
    // * f1(x0,x1) = x1-1
    // * and Jacobian matrix J = [dfi/dxj]
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi/jac parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi/jac point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi/jac parameters without
    //            reallocation/reinitializing them.
    //
    //
    fi[0] := x[0]*x[0]+1;
    fi[1] := x[1]-1;
    jac[0,0] := 2*x[0];
    jac[0,1] := 0;
    jac[1,0] := 0;
    jac[1,1] := 1;
end;
procedure nlcfunc1_jac(const x: TVector; fi: TVector; jac: TMatrix; obj: Pointer);
begin
    //
    // this callback calculates
    // * f0(x0,x1) = -x0+x1
    // * f1(x0,x1) = x0^2+x1^2-1
    // * and Jacobian matrix J = [dfi/dxj]
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi/jac parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi/jac point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi/jac parameters without
    //            reallocation/reinitializing them.
    //
    fi[0] := -x[0]+x[1];
    fi[1] := x[0]*x[0] + x[1]*x[1] - 1.0;
    jac[0,0] := -1.0;
    jac[0,1] := +1.0;
    jac[1,0] := 2*x[0];
    jac[1,1] := 2*x[1];
end;
procedure nlcfunc2_jac(const x: TVector; fi: TVector; jac: TMatrix; obj: Pointer);
begin
    //
    // this callback calculates
    // * f0(x0,x1,x2) = x0+x1
    // * f1(x0,x1,x2) = x2-exp(x0)
    // * f2(x0,x1,x2) = x0^2+x1^2-1
    // * and Jacobian matrix J = [dfi/dxj]
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi/jac parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi/jac point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi/jac parameters without
    //            reallocation/reinitializing them.
    //
    fi[0] := x[0]+x[1];
    fi[1] := x[2]-Exp(x[0]);
    fi[2] := x[0]*x[0] + x[1]*x[1] - 1.0;
    jac[0,0] := 1.0;
    jac[0,1] := 1.0;
    jac[0,2] := 0.0;
    jac[1,0] := -Exp(x[0]);
    jac[1,1] := 0.0;
    jac[1,2] := 1.0;
    jac[2,0] := 2*x[0];
    jac[2,1] := 2*x[1];
    jac[2,2] := 0.0;
end;
procedure nsfunc1_jac(const x: TVector; fi: TVector; jac: TMatrix; obj: Pointer);
begin
    //
    // This callback calculates
    // * f0(x0,x1) = 2*|x0|+|x1|
    // * and Jacobian matrix J = [ df0/dx0, df0/dx1 ]
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi/jac parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi/jac point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi/jac parameters without
    //            reallocation/reinitializing them.
    //
    fi[0] := 2*Abs(x[0])+Abs(x[1]);
    jac[0,0] := 2*Sign(x[0]);
    jac[0,1] := Sign(x[1]);
end;
procedure nsfunc1_fvec(const x: TVector; fi: TVector; obj: Pointer);
begin
    //
    // this callback calculates
    //
    //     f0(x0,x1) = 2*|x0|+|x1|
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi parameter without
    //            reallocation/reinitializing it.
    //
    fi[0] := 2*Abs(x[0])+Abs(x[1]);
end;
procedure nsfunc2_jac(const x: TVector; fi: TVector; jac: TMatrix; obj: Pointer);
begin
    //
    // this callback calculates function vector
    // * f0(x0,x1) = 2*|x0|+x1
    // * f1(x0,x1) = x0-1
    // * f2(x0,x1) = -x1-1
    // * and Jacobian matrix J
    //
    //         [ df0/dx0   df0/dx1 ]
    //     J = [ df1/dx0   df1/dx1 ]
    //         [ df2/dx0   df2/dx1 ]
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite fi/jac parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(fi,N)".
    //
    //            The reason is that fi/jac point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with fi/jac parameters without
    //            reallocation/reinitializing them.
    //
    fi[0] := 2*Abs(x[0])+Abs(x[1]);
    jac[0,0] := 2*Sign(x[0]);
    jac[0,1] := Sign(x[1]);
    fi[1] := x[0]-1;
    jac[1,0] := 1;
    jac[1,1] := 0;
    fi[2] := -x[1]-1;
    jac[2,0] := 0;
    jac[2,1] := -1;
end;
procedure bad_func(const x: TVector; var func: Double; obj: Pointer);
begin
    //
    // this callback calculates 'bad' function,
    // i.e. function with incorrectly calculated derivatives
    //
    func := 100*Power(x[0]+3,4) + Power(x[1]-3,4);
end;
procedure bad_grad(const x: TVector; var func: Double; grad: TVector; obj: Pointer);
begin
    //
    // this callback calculates 'bad' function,
    // i.e. function with incorrectly calculated derivatives
    //
    func := 100*Power(x[0]+3,4) + Power(x[1]-3,4);
    grad[0] := 40*Power(x[0]+3,3);
    grad[1] := 40*Power(x[1]-3,3);
end;
procedure bad_hess(const x: TVector; var func: Double; grad: TVector; hess: TMatrix; obj: Pointer);
begin
    //
    // this callback calculates 'bad' function,
    // i.e. function with incorrectly calculated derivatives
    //
    func := 100*Power(x[0]+3,4) + Power(x[1]-3,4);
    grad[0] := 40*Power(x[0]+3,3);
    grad[1] := 40*Power(x[1]-3,3);
    hess[0,0] := 120*Power(x[0]+3,2);
    hess[0,1] := 1;
    hess[1,0] := 1;
    hess[1,1] := 120*Power(x[1]-3,2);
end;
procedure bad_fvec(const x: TVector; fi: TVector; obj: Pointer);
begin
    //
    // this callback calculates 'bad' function,
    // i.e. function with incorrectly calculated derivatives
    //
    fi[0] := 10*Power(x[0]+3,2);
    fi[1] := Power(x[1]-3,2);
end;
procedure bad_jac(const x: TVector; fi: TVector; jac: TMatrix; obj: Pointer);
begin
    //
    // this callback calculates 'bad' function,
    // i.e. function with incorrectly calculated derivatives
    //
    fi[0] := 10*Power(x[0]+3,2);
    fi[1] := Power(x[1]-3,2);
    jac[0,0] := 20*(x[0]+3);
    jac[0,1] := 0;
    jac[1,0] := 1;
    jac[1,1] := 20*(x[1]-3);
end;
procedure function_cx_1_func(const c: TVector; const x: TVector; var func: Double; obj: Pointer);
begin
    //
    // this callback calculates f(c,x)=exp(-c0*sqr(x0))
    // where x is a position on X-axis and c is adjustable parameter
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    if Abs(c[0])>1.0E50 then
    begin
        if c[0]>0 then
            Func:=0
        else
            Func:=1.0E100;
        Exit;
    end;
    func := Exp(-c[0]*x[0]*x[0]);
end;
procedure function_cx_1_grad(const c: TVector; const x: TVector; var func: Double; grad: TVector; obj: Pointer);
begin
    //
    // This callback calculates
    // * f(c,x)=exp(-c0*sqr(x0))
    // * and gradient G={df/dc[i]}
    // where x is a position on X-axis and c is adjustable parameter.
    //
    // IMPORTANT: gradient is calculated with respect to C, not to X
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite grad parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(grad,N)".
    //
    //            The reason is that grad points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with grad parameter without
    //            reallocation/reinitializing it.
    //
    if Abs(c[0])>1.0E50 then
    begin
        if c[0]>0 then
            Func:=0
        else
            Func:=1.0E100;
        grad[0]:=0;
        Exit;
    end;
    func := Exp(-c[0]*Power(x[0],2));
    grad[0] := -Power(x[0],2)*func;
end;
procedure function_cx_1_hess(const c: TVector; const x: TVector; var func: Double; grad: TVector; hess: TMatrix; obj: Pointer);
begin
    //
    // This callback calculates
    // * f(c,x)=exp(-c0*sqr(x0))
    // * gradient G={df/dc[i]}
    // * and Hessian H={d2f/(dc[i]*dc[j])}
    // where x is a position on X-axis and c is adjustable parameter.
    //
    // IMPORTANT: gradient/Hessian are calculated with respect to C, not to X
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite grad/hess parameters by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(grad,N)".
    //
    //            The reason is that grad/hess point to preallocated arrays;
    //            if you reallocate them, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with grad/hess parameters without
    //            reallocation/reinitializing it.
    //
    if Abs(c[0])>1.0E50 then
    begin
        if c[0]>0 then
            Func:=0
        else
            Func:=1.0E100;
        grad[0]:=0;
        hess[0,0]:=0;
        Exit;
    end;
    func := Exp(-c[0]*Power(x[0],2));
    grad[0] := -Power(x[0],2)*func;
    hess[0,0] := Power(x[0],4)*func;
end;
procedure ode_function_1_diff(const y: TVector; x: Double; dy: TVector; obj: Pointer);
begin
    //
    // This callback calculates f(y[],x)=-y[0]
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite dy parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(dy,N)".
    //
    //            The reason is that dy points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with dy parameter without
    //            reallocation/reinitializing it.
    //
    dy[0] := -y[0];
end;
procedure int_function_1_func(x: Double; xminusa: Double; bminusx: Double; var y: Double; obj: Pointer);
begin
    //
    // this callback calculates f(x)=exp(x)
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    y := Exp(x);
end;
procedure function_debt_func(const c: TVector; const x: TVector; var func: Double; obj: Pointer);
begin
    //
    // this callback calculates f(c,x)=c[0]*(1+c[1]*(pow(x[0]-1999,c[2])-1))
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    func := c[0]*(1+c[1]*(Power(x[0]-1999,c[2])-1));
end;
procedure s1_grad(const x: TVector; var func: Double; grad: TVector; obj: Pointer);
begin
    //
    // this callback calculates f(x) = (1+x)^(-0.2) + (1-x)^(-0.3) + 1000*x and its gradient.
    //
    // function is trimmed when we calculate it near the singular points or outside of the [-1,+1].
    // Note that we do NOT calculate gradient in this case.
    //
    // An additional parameter obj may be used to pass some data to this
    // callback (if you pass some pointer value as obj parameter of
    // optimizer method, it will forward this pointer to callback).
    //
    // IMPORTANT: you should NOT overwrite grad parameter by another
    //            instance of TVector array: say, you should not write
    //            code like "SetLength(grad,N)".
    //
    //            The reason is that grad points to preallocated array;
    //            if you reallocate it, optimizer will have no way of
    //            finding out reference to new array.
    //
    //            Thus, you should work with grad parameter without
    //            reallocation/reinitializing it.
    //
    if (x[0]<=-0.999999999999) or (x[0]>=+0.999999999999) then
    begin
        func := 1.0E+300;
        Exit;
    end;
    func := Power(1+x[0],-0.2) + Power(1-x[0],-0.3) + 1000*x[0];
    grad[0] := -0.2*Power(1+x[0],-1.2) +0.3*Power(1-x[0],-1.3) + 1000;
end;


function _test_nneighbor_d_1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    nx: TALGLIBInteger;
    ny: TALGLIBInteger;
    normtype: TALGLIBInteger;
    kdt: Tkdtree;
    x: TVector;
    r: TMatrix;
    k: TALGLIBInteger;

begin
    Result:=True;
    try
        kdt:=nil;

        a:=Str2Matrix('[[0,0],[0,1],[1,0],[1,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        nx:=2;
        ny:=0;
        normtype:=2;
        r:=nil;
        kdtreebuild(a, nx, ny, normtype, kdt);
        x:=Str2Vector('[-1,0]');
        k:=kdtreequeryknn(kdt, x, 1);
        Result:=Result and doc_test_int(k, 1);
        kdtreequeryresultsx(kdt, r);
        Result:=Result and doc_test_real_matrix(r, Str2Matrix('[[0,0]]'), 0.05);

    finally
        FreeAndNil(kdt);

    end;
end;


function _test_nneighbor_t_2(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    nx: TALGLIBInteger;
    ny: TALGLIBInteger;
    normtype: TALGLIBInteger;
    kdt: Tkdtree;
    x: TVector;
    rx: TMatrix;
    k: TALGLIBInteger;

begin
    Result:=True;
    try
        kdt:=nil;

        a:=Str2Matrix('[[0,0],[0,1],[1,0],[1,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        nx:=2;
        ny:=0;
        normtype:=2;
        rx:=nil;
        kdtreebuild(a, nx, ny, normtype, kdt);
        x:=Str2Vector('[+2,0]');
        k:=kdtreequeryknn(kdt, x, 2, true);
        Result:=Result and doc_test_int(k, 2);
        kdtreequeryresultsx(kdt, rx);
        Result:=Result and doc_test_real_matrix(rx, Str2Matrix('[[1,0],[1,1]]'), 0.05);
        x:=Str2Vector('[-2,0]');
        k:=kdtreequeryknn(kdt, x, 1, true);
        Result:=Result and doc_test_int(k, 1);
        kdtreequeryresultsx(kdt, rx);
        Result:=Result and doc_test_real_matrix(rx, Str2Matrix('[[0,0],[1,1]]'), 0.05);

    finally
        FreeAndNil(kdt);

    end;
end;


function _test_nneighbor_d_2(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    nx: TALGLIBInteger;
    ny: TALGLIBInteger;
    normtype: TALGLIBInteger;
    kdt0: Tkdtree;
    kdt1: Tkdtree;
    s: AnsiString;
    x: TVector;
    r0: TMatrix;
    r1: TMatrix;

begin
    Result:=True;
    try
        kdt0:=nil;
        kdt1:=nil;

        a:=Str2Matrix('[[0,0],[0,1],[1,0],[1,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        nx:=2;
        ny:=0;
        normtype:=2;
        r0:=nil;
        r1:=nil;

        //
        // Build tree and serialize it
        //
        kdtreebuild(a, nx, ny, normtype, kdt0);
        kdtreeserialize(kdt0, s);
        kdtreeunserialize(s, kdt1);

        //
        // Compare results from KNN queries
        //
        x:=Str2Vector('[-1,0]');
        kdtreequeryknn(kdt0, x, 1);
        kdtreequeryresultsx(kdt0, r0);
        kdtreequeryknn(kdt1, x, 1);
        kdtreequeryresultsx(kdt1, r1);
        Result:=Result and doc_test_real_matrix(r0, Str2Matrix('[[0,0]]'), 0.05);
        Result:=Result and doc_test_real_matrix(r1, Str2Matrix('[[0,0]]'), 0.05);

    finally
        FreeAndNil(kdt0);
        FreeAndNil(kdt1);

    end;
end;


function _test_odesolver_d1(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    x: TVector;
    eps: Double;
    h: Double;
    s: Todesolverstate;
    m: TALGLIBInteger;
    xtbl: TVector;
    ytbl: TMatrix;
    rep: Todesolverreport;

begin
    Result:=True;
    try
        s:=nil;

        y:=Str2Vector('[1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(y);
        x:=Str2Vector('[0, 1, 2, 3]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(x, Double(NegInfinity));
        eps:=0.00001;
        if _spoil_scenario=7 then
            eps:=Double(NaN);
        if _spoil_scenario=8 then
            eps:=Double(Infinity);
        if _spoil_scenario=9 then
            eps:=Double(NegInfinity);
        h:=0;
        if _spoil_scenario=10 then
            h:=Double(NaN);
        if _spoil_scenario=11 then
            h:=Double(Infinity);
        if _spoil_scenario=12 then
            h:=Double(NegInfinity);
        odesolverrkck(y, x, eps, h, s);
        odesolversolve(s, ode_function_1_diff, nil);
        odesolverresults(s, m, xtbl, ytbl, rep);
        Result:=Result and doc_test_int(m, 4);
        Result:=Result and doc_test_real_vector(xtbl, Str2Vector('[0, 1, 2, 3]'), 0.005);
        Result:=Result and doc_test_real_matrix(ytbl, Str2Matrix('[[1], [0.367], [0.135], [0.050]]'), 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_sparse_d_1(_spoil_scenario: Integer):Boolean;
var
    s: Tsparsematrix;
    v: Double;
    x: TVector;
    y: TVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // This example demonstrates creation/initialization of the sparse matrix
        // and matrix-vector multiplication.
        //
        // First, we have to create matrix and initialize it. Matrix is initially created
        // in the Hash-Table format, which allows convenient initialization. We can modify
        // Hash-Table matrix with sparseset() and sparseadd() functions.
        //
        // NOTE: Unlike CRS format, Hash-Table representation allows you to initialize
        // elements in the arbitrary order. You may see that we initialize a[0][0] first,
        // then move to the second row, and then move back to the first row.
        //
        sparsecreate(2, 2, s);
        sparseset(s, 0, 0, 2.0);
        sparseset(s, 1, 1, 1.0);
        sparseset(s, 0, 1, 1.0);

        sparseadd(s, 1, 1, 4.0);

        //
        // Now S is equal to
        //   [ 2 1 ]
        //   [   5 ]
        // Lets check it by reading matrix contents with sparseget().
        // You may see that with sparseget() you may read both non-zero
        // and zero elements.
        //
        v:=sparseget(s, 0, 0);
        Result:=Result and doc_test_real(v, 2.0000, 0.005);
        v:=sparseget(s, 0, 1);
        Result:=Result and doc_test_real(v, 1.0000, 0.005);
        v:=sparseget(s, 1, 0);
        Result:=Result and doc_test_real(v, 0.0000, 0.005);
        v:=sparseget(s, 1, 1);
        Result:=Result and doc_test_real(v, 5.0000, 0.005);

        //
        // After successful creation we can use our matrix for linear operations.
        //
        // However, there is one more thing we MUST do before using S in linear
        // operations: we have to convert it from HashTable representation (used for
        // initialization and dynamic operations) to CRS format with sparseconverttocrs()
        // call. If you omit this call, ALGLIB will generate exception on the first
        // attempt to use S in linear operations. 
        //
        sparseconverttocrs(s);

        //
        // Now S is in the CRS format and we are ready to do linear operations.
        // Lets calculate A*x for some x.
        //
        x:=Str2Vector('[1,-1]');
        if _spoil_scenario=0 then
            spoil_vector_by_deleting_element(x);
        y:=nil;
        sparsemv(s, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[1.000,-5.000]'), 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_sparse_d_crs(_spoil_scenario: Integer):Boolean;
var
    s: Tsparsematrix;
    row_sizes: TIVector;
    v: Double;
    x: TVector;
    y: TVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // This example demonstrates creation/initialization of the sparse matrix in the
        // CRS format.
        //
        // Hash-Table format used by default is very convenient (it allows easy
        // insertion of elements, automatic memory reallocation), but has
        // significant memory and performance overhead. Insertion of one element 
        // costs hundreds of CPU cycles, and memory consumption is several times
        // higher than that of CRS.
        //
        // When you work with really large matrices and when you can tell in 
        // advance how many elements EXACTLY you need, it can be beneficial to 
        // create matrix in the CRS format from the very beginning.
        //
        // If you want to create matrix in the CRS format, you should:
        // * use sparsecreatecrs() function
        // * know row sizes in advance (number of non-zero entries in the each row)
        // * initialize matrix with sparseset() - another function, sparseadd(), is not allowed
        // * initialize elements from left to right, from top to bottom, each
        //   element is initialized only once.
        //
        row_sizes:=Str2IVector('[2,2,2,1]');
        if _spoil_scenario=0 then
            spoil_vector_by_deleting_element(row_sizes);
        sparsecreatecrs(4, 4, row_sizes, s);
        sparseset(s, 0, 0, 2.0);
        sparseset(s, 0, 1, 1.0);
        sparseset(s, 1, 1, 4.0);
        sparseset(s, 1, 2, 2.0);
        sparseset(s, 2, 2, 3.0);
        sparseset(s, 2, 3, 1.0);
        sparseset(s, 3, 3, 9.0);

        //
        // Now S is equal to
        //   [ 2 1     ]
        //   [   4 2   ]
        //   [     3 1 ]
        //   [       9 ]
        //
        // We should point that we have initialized S elements from left to right,
        // from top to bottom. CRS representation does NOT allow you to do so in
        // the different order. Try to change order of the sparseset() calls above,
        // and you will see that your program generates exception.
        //
        // We can check it by reading matrix contents with sparseget().
        // However, you should remember that sparseget() is inefficient on
        // CRS matrices (it may have to pass through all elements of the row 
        // until it finds element you need).
        //
        v:=sparseget(s, 0, 0);
        Result:=Result and doc_test_real(v, 2.0000, 0.005);
        v:=sparseget(s, 2, 3);
        Result:=Result and doc_test_real(v, 1.0000, 0.005);

        // you may see that you can read zero elements (which are not stored) with sparseget()
        v:=sparseget(s, 3, 2);
        Result:=Result and doc_test_real(v, 0.0000, 0.005);

        //
        // After successful creation we can use our matrix for linear operations.
        // Lets calculate A*x for some x.
        //
        x:=Str2Vector('[1,-1,1,-1]');
        if _spoil_scenario=1 then
            spoil_vector_by_deleting_element(x);
        y:=nil;
        sparsemv(s, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[1.000,-2.000,2.000,-9]'), 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_ablas_d_gemm(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    b: TMatrix;
    c: TMatrix;
    m: TALGLIBInteger;
    n: TALGLIBInteger;
    k: TALGLIBInteger;
    alpha: Double;
    ia: TALGLIBInteger;
    ja: TALGLIBInteger;
    optypea: TALGLIBInteger;
    ib: TALGLIBInteger;
    jb: TALGLIBInteger;
    optypeb: TALGLIBInteger;
    beta: Double;
    ic: TALGLIBInteger;
    jc: TALGLIBInteger;

begin
    Result:=True;
    try

        a:=Str2Matrix('[[2,1],[1,3]]');
        b:=Str2Matrix('[[2,1],[0,1]]');
        c:=Str2Matrix('[[0,0],[0,0]]');

        //
        // rmatrixgemm() function allows us to calculate matrix product C:=A*B or
        // to perform more general operation, C:=alpha*op1(A)*op2(B)+beta*C,
        // where A, B, C are rectangular matrices, op(X) can be X or X^T,
        // alpha and beta are scalars.
        //
        // This function:
        // * can apply transposition and/or multiplication by scalar to operands
        // * can use arbitrary part of matrices A/B (given by submatrix offset)
        // * can store result into arbitrary part of C
        // * for performance reasons requires C to be preallocated
        //
        // Parameters of this function are:
        // * M, N, K            -   sizes of op1(A) (which is MxK), op2(B) (which
        //                          is KxN) and C (which is MxN)
        // * Alpha              -   coefficient before A*B
        // * A, IA, JA          -   matrix A and offset of the submatrix
        // * OpTypeA            -   transformation type:
        //                          0 - no transformation
        //                          1 - transposition
        // * B, IB, JB          -   matrix B and offset of the submatrix
        // * OpTypeB            -   transformation type:
        //                          0 - no transformation
        //                          1 - transposition
        // * Beta               -   coefficient before C
        // * C, IC, JC          -   preallocated matrix C and offset of the submatrix
        //
        // Below we perform simple product C:=A*B (alpha=1, beta=0)
        //
        // IMPORTANT: this function works with preallocated C, which must be large
        //            enough to store multiplication result.
        //
        m:=2;
        n:=2;
        k:=2;
        alpha:=1.0;
        ia:=0;
        ja:=0;
        optypea:=0;
        ib:=0;
        jb:=0;
        optypeb:=0;
        beta:=0.0;
        ic:=0;
        jc:=0;
        rmatrixgemm(m, n, k, alpha, a, ia, ja, optypea, b, ib, jb, optypeb, beta, c, ic, jc);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[4,3],[2,4]]'), 0.0001);

        //
        // Now we try to apply some simple transformation to operands: C:=A*B^T
        //
        optypeb:=1;
        rmatrixgemm(m, n, k, alpha, a, ia, ja, optypea, b, ib, jb, optypeb, beta, c, ic, jc);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[5,1],[5,3]]'), 0.0001);

    finally

    end;
end;


function _test_ablas_d_syrk(_spoil_scenario: Integer):Boolean;
var
    n: TALGLIBInteger;
    k: TALGLIBInteger;
    alpha: Double;
    ia: TALGLIBInteger;
    ja: TALGLIBInteger;
    optypea: TALGLIBInteger;
    beta: Double;
    ic: TALGLIBInteger;
    jc: TALGLIBInteger;
    isupper: Boolean;
    a: TMatrix;
    c: TMatrix;

begin
    Result:=True;
    try

        //
        // rmatrixsyrk() function allows us to calculate symmetric rank-K update
        // C := beta*C + alpha*A'*A, where C is square N*N matrix, A is square K*N
        // matrix, alpha and beta are scalars. It is also possible to update by
        // adding A*A' instead of A'*A.
        //
        // Parameters of this function are:
        // * N, K       -   matrix size
        // * Alpha      -   coefficient before A
        // * A, IA, JA  -   matrix and submatrix offsets
        // * OpTypeA    -   multiplication type:
        //                  * 0 - A*A^T is calculated
        //                  * 2 - A^T*A is calculated
        // * Beta       -   coefficient before C
        // * C, IC, JC  -   preallocated input/output matrix and submatrix offsets
        // * IsUpper    -   whether upper or lower triangle of C is updated;
        //                  this function updates only one half of C, leaving
        //                  other half unchanged (not referenced at all).
        //
        // Below we will show how to calculate simple product C:=A'*A
        //
        // NOTE: beta=0 and we do not use previous value of C, but still it
        //       MUST be preallocated.
        //
        n:=2;
        k:=1;
        alpha:=1.0;
        ia:=0;
        ja:=0;
        optypea:=2;
        beta:=0.0;
        ic:=0;
        jc:=0;
        isupper:=true;
        a:=Str2Matrix('[[1,2]]');

        // preallocate space to store result
        c:=Str2Matrix('[[0,0],[0,0]]');

        // calculate product, store result into upper part of c
        rmatrixsyrk(n, k, alpha, a, ia, ja, optypea, beta, c, ic, jc, isupper);

        // output result.
        // IMPORTANT: lower triangle of C was NOT updated!
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[1,2],[0,4]]'), 0.0001);

    finally

    end;
end;


function _test_ablas_t_complex(_spoil_scenario: Integer):Boolean;
var
    a: TCMatrix;
    b: TCMatrix;
    c: TCMatrix;

begin
    Result:=True;
    try


        // test cmatrixgemm()
        a:=Str2CMatrix('[[2i,1i],[1,3]]');
        b:=Str2CMatrix('[[2,1],[0,1]]');
        c:=Str2CMatrix('[[0,0],[0,0]]');
        cmatrixgemm(2, 2, 2, 1.0, a, 0, 0, 0, b, 0, 0, 0, 0.0, c, 0, 0);
        Result:=Result and doc_test_complex_matrix(c, Str2CMatrix('[[4i,3i],[2,4]]'), 0.0001);

    finally

    end;
end;


function _test_matinv_d_r1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2Matrix('[[1,-1],[1,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(a);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(a);
        rmatrixinverse(a, info, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_real_matrix(a, Str2Matrix('[[0.5,0.5],[-0.5,0.5]]'), 0.00005);
        Result:=Result and doc_test_real(rep.r1, 0.5, 0.00005);
        Result:=Result and doc_test_real(rep.rinf, 0.5, 0.00005);

    finally

    end;
end;


function _test_matinv_d_c1(_spoil_scenario: Integer):Boolean;
var
    a: TCMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2CMatrix('[[1i,-1],[1i,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(a);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(a);
        cmatrixinverse(a, info, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_complex_matrix(a, Str2CMatrix('[[-0.5i,-0.5i],[-0.5,0.5]]'), 0.00005);
        Result:=Result and doc_test_real(rep.r1, 0.5, 0.00005);
        Result:=Result and doc_test_real(rep.rinf, 0.5, 0.00005);

    finally

    end;
end;


function _test_matinv_d_spd1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2Matrix('[[2,1],[1,2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(a);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(a);
        spdmatrixinverse(a, info, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_real_matrix(a, Str2Matrix('[[0.666666,-0.333333],[-0.333333,0.666666]]'), 0.00005);

    finally

    end;
end;


function _test_matinv_d_hpd1(_spoil_scenario: Integer):Boolean;
var
    a: TCMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2CMatrix('[[2,1],[1,2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(a);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(a);
        hpdmatrixinverse(a, info, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_complex_matrix(a, Str2CMatrix('[[0.666666,-0.333333],[-0.333333,0.666666]]'), 0.00005);

    finally

    end;
end;


function _test_matinv_t_r1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2Matrix('[[1,-1],[-2,2]]');
        rmatrixinverse(a, info, rep);
        Result:=Result and doc_test_int(info, -3);
        Result:=Result and doc_test_real(rep.r1, 0.0, 0.00005);
        Result:=Result and doc_test_real(rep.rinf, 0.0, 0.00005);

    finally

    end;
end;


function _test_matinv_t_c1(_spoil_scenario: Integer):Boolean;
var
    a: TCMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2CMatrix('[[1i,-1i],[-2,2]]');
        cmatrixinverse(a, info, rep);
        Result:=Result and doc_test_int(info, -3);
        Result:=Result and doc_test_real(rep.r1, 0.0, 0.00005);
        Result:=Result and doc_test_real(rep.rinf, 0.0, 0.00005);

    finally

    end;
end;


function _test_matinv_e_spd1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2Matrix('[[1,0],[1,1]]');
        spdmatrixinverse(a, info, rep);

    finally

    end;
end;


function _test_matinv_e_hpd1(_spoil_scenario: Integer):Boolean;
var
    a: TCMatrix;
    info: TALGLIBInteger;
    rep: Tmatinvreport;

begin
    Result:=True;
    try

        a:=Str2CMatrix('[[1,0],[1,1]]');
        hpdmatrixinverse(a, info, rep);

    finally

    end;
end;


function _test_minlbfgs_d_1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlbfgsstate;
    rep: Tminlbfgsreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // using LBFGS method, with:
        // * initial point x=[0,0]
        // * unit scale being set for all variables (see minlbfgssetscale for more info)
        // * stopping criteria set to "terminate after short enough step"
        // * OptGuard integrity check being used to check problem statement
        //   for some common errors like nonsmoothness or bad analytic gradient
        //
        // First, we create optimizer object and tune its properties
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsg:=0;
        if _spoil_scenario=6 then
            epsg:=Double(NaN);
        if _spoil_scenario=7 then
            epsg:=Double(Infinity);
        if _spoil_scenario=8 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=9 then
            epsf:=Double(NaN);
        if _spoil_scenario=10 then
            epsf:=Double(Infinity);
        if _spoil_scenario=11 then
            epsf:=Double(NegInfinity);
        epsx:=0.0000000001;
        if _spoil_scenario=12 then
            epsx:=Double(NaN);
        if _spoil_scenario=13 then
            epsx:=Double(Infinity);
        if _spoil_scenario=14 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        minlbfgscreate(1, x, state);
        minlbfgssetcond(state, epsg, epsf, epsx, maxits);
        minlbfgssetscale(state, s);

        //
        // Activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target function (C0 continuity violation)
        // * nonsmoothness of the target function (C1 continuity violation)
        // * erroneous analytic gradient, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION. DO NOT USE IT IN PRODUCTION CODE!!!!!!!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        minlbfgsoptguardsmoothness(state);
        minlbfgsoptguardgradient(state, 0.001);

        //
        // Optimize and examine results.
        //
        minlbfgsoptimize(state, function1_grad, nil, nil);
        minlbfgsresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the gradient - say, add
        //       1.0 to some of its components.
        //
        minlbfgsoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlbfgs_d_2(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    stpmax: Double;
    maxits: TALGLIBInteger;
    state: Tminlbfgsstate;
    rep: Tminlbfgsreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of f(x,y) = 100*(x+3)^4+(y-3)^4
        // using LBFGS method.
        //
        // Several advanced techniques are demonstrated:
        // * upper limit on step size
        // * restart from new point
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsg:=0;
        if _spoil_scenario=6 then
            epsg:=Double(NaN);
        if _spoil_scenario=7 then
            epsg:=Double(Infinity);
        if _spoil_scenario=8 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=9 then
            epsf:=Double(NaN);
        if _spoil_scenario=10 then
            epsf:=Double(Infinity);
        if _spoil_scenario=11 then
            epsf:=Double(NegInfinity);
        epsx:=0.0000000001;
        if _spoil_scenario=12 then
            epsx:=Double(NaN);
        if _spoil_scenario=13 then
            epsx:=Double(Infinity);
        if _spoil_scenario=14 then
            epsx:=Double(NegInfinity);
        stpmax:=0.1;
        if _spoil_scenario=15 then
            stpmax:=Double(NaN);
        if _spoil_scenario=16 then
            stpmax:=Double(Infinity);
        if _spoil_scenario=17 then
            stpmax:=Double(NegInfinity);
        maxits:=0;

        // create and tune optimizer
        minlbfgscreate(1, x, state);
        minlbfgssetcond(state, epsg, epsf, epsx, maxits);
        minlbfgssetstpmax(state, stpmax);
        minlbfgssetscale(state, s);

        // Set up OptGuard integrity checker which catches errors
        // like nonsmooth targets or errors in the analytic gradient.
        //
        // OptGuard is essential at the early prototyping stages.
        //
        // NOTE: gradient verification needs 3*N additional function
        //       evaluations; DO NOT USE IT IN THE PRODUCTION CODE
        //       because it leads to unnecessary slowdown of your app.
        minlbfgsoptguardsmoothness(state);
        minlbfgsoptguardgradient(state, 0.001);

        // first run
        minlbfgsoptimize(state, function1_grad, nil, nil);
        minlbfgsresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

        // second run - algorithm is restarted
        x:=Str2Vector('[10,10]');
        if _spoil_scenario=18 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=19 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=20 then
            spoil_vector_by_value(x, Double(NegInfinity));
        minlbfgsrestartfrom(state, x);
        minlbfgsoptimize(state, function1_grad, nil, nil);
        minlbfgsresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

        // check OptGuard integrity report. Why do we need it at all?
        // Well, try breaking the gradient by adding 1.0 to some
        // of its components - OptGuard should report it as error.
        // And it may also catch unintended errors too :)
        minlbfgsoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlbfgs_numdiff(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    diffstep: Double;
    maxits: TALGLIBInteger;
    state: Tminlbfgsstate;
    rep: Tminlbfgsreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of f(x,y) = 100*(x+3)^4+(y-3)^4
        // using numerical differentiation to calculate gradient.
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        epsg:=0.0000000001;
        if _spoil_scenario=3 then
            epsg:=Double(NaN);
        if _spoil_scenario=4 then
            epsg:=Double(Infinity);
        if _spoil_scenario=5 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=6 then
            epsf:=Double(NaN);
        if _spoil_scenario=7 then
            epsf:=Double(Infinity);
        if _spoil_scenario=8 then
            epsf:=Double(NegInfinity);
        epsx:=0;
        if _spoil_scenario=9 then
            epsx:=Double(NaN);
        if _spoil_scenario=10 then
            epsx:=Double(Infinity);
        if _spoil_scenario=11 then
            epsx:=Double(NegInfinity);
        diffstep:=1.0e-6;
        if _spoil_scenario=12 then
            diffstep:=Double(NaN);
        if _spoil_scenario=13 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=14 then
            diffstep:=Double(NegInfinity);
        maxits:=0;

        minlbfgscreatef(1, x, diffstep, state);
        minlbfgssetcond(state, epsg, epsf, epsx, maxits);
        minlbfgsoptimize(state, function1_func, nil, nil);
        minlbfgsresults(state, x, rep);

        Result:=Result and doc_test_int(rep.terminationtype, 4);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_linlsqr_d_1(_spoil_scenario: Integer):Boolean;
var
    a: Tsparsematrix;
    b: TVector;
    s: Tlinlsqrstate;
    rep: Tlinlsqrreport;
    x: TVector;

begin
    Result:=True;
    try
        a:=nil;
        s:=nil;

        //
        // This example illustrates solution of sparse linear least squares problem
        // with LSQR algorithm.
        // 
        // Suppose that we have least squares problem min|A*x-b| with sparse A
        // represented by sparsematrix object
        //         [ 1 1 ]
        //         [ 1 1 ]
        //     A = [ 2 1 ]
        //         [ 1   ]
        //         [   1 ]
        // and right part b
        //     [ 4 ]
        //     [ 2 ]
        // b = [ 4 ]
        //     [ 1 ]
        //     [ 2 ]
        // and we want to solve this system in the least squares sense using
        // LSQR algorithm. In order to do so, we have to create left part
        // (sparsematrix object) and right part (dense array).
        //
        // Initially, sparse matrix is created in the Hash-Table format,
        // which allows easy initialization, but do not allow matrix to be
        // used in the linear solvers. So after construction you should convert
        // sparse matrix to CRS format (one suited for linear operations).
        //
        sparsecreate(5, 2, a);
        sparseset(a, 0, 0, 1.0);
        sparseset(a, 0, 1, 1.0);
        sparseset(a, 1, 0, 1.0);
        sparseset(a, 1, 1, 1.0);
        sparseset(a, 2, 0, 2.0);
        sparseset(a, 2, 1, 1.0);
        sparseset(a, 3, 0, 1.0);
        sparseset(a, 4, 1, 1.0);

        //
        // Now our matrix is fully initialized, but we have to do one more
        // step - convert it from Hash-Table format to CRS format (see
        // documentation on sparse matrices for more information about these
        // formats).
        //
        // If you omit this call, ALGLIB will generate exception on the first
        // attempt to use A in linear operations. 
        //
        sparseconverttocrs(a);

        //
        // Initialization of the right part
        //
        b:=Str2Vector('[4,2,4,1,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(b);

        //
        // Now we have to create linear solver object and to use it for the
        // solution of the linear system.
        //
        linlsqrcreate(5, 2, s);
        linlsqrsolvesparse(s, a, b);
        linlsqrresults(s, x, rep);

        Result:=Result and doc_test_int(rep.terminationtype, 4);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[1.000,2.000]'), 0.005);

    finally
        FreeAndNil(a);
        FreeAndNil(s);

    end;
end;


function _test_minbleic_d_1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminbleicstate;
    rep: Tminbleicreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // subject to box constraints
        //
        //     -1<=x<=+1, -1<=y<=+1
        //
        // using BLEIC optimizer with:
        // * initial point x=[0,0]
        // * unit scale being set for all variables (see minbleicsetscale for more info)
        // * stopping criteria set to "terminate after short enough step"
        // * OptGuard integrity check being used to check problem statement
        //   for some common errors like nonsmoothness or bad analytic gradient
        //
        // First, we create optimizer object and tune its properties:
        // * set box constraints
        // * set variable scales
        // * set stopping criteria
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=6 then
            spoil_vector_by_deleting_element(s);
        bndl:=Str2Vector('[-1,-1]');
        if _spoil_scenario=7 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[+1,+1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_deleting_element(bndu);
        epsg:=0;
        if _spoil_scenario=11 then
            epsg:=Double(NaN);
        if _spoil_scenario=12 then
            epsg:=Double(Infinity);
        if _spoil_scenario=13 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=14 then
            epsf:=Double(NaN);
        if _spoil_scenario=15 then
            epsf:=Double(Infinity);
        if _spoil_scenario=16 then
            epsf:=Double(NegInfinity);
        epsx:=0.000001;
        if _spoil_scenario=17 then
            epsx:=Double(NaN);
        if _spoil_scenario=18 then
            epsx:=Double(Infinity);
        if _spoil_scenario=19 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        minbleiccreate(x, state);
        minbleicsetbc(state, bndl, bndu);
        minbleicsetscale(state, s);
        minbleicsetcond(state, epsg, epsf, epsx, maxits);

        //
        // Then we activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target function (C0 continuity violation)
        // * nonsmoothness of the target function (C1 continuity violation)
        // * erroneous analytic gradient, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION. DO NOT USE IT IN PRODUCTION CODE!!!!!!!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        minbleicoptguardsmoothness(state);
        minbleicoptguardgradient(state, 0.001);

        //
        // Optimize and evaluate results
        //
        minbleicoptimize(state, function1_grad, nil, nil);
        minbleicresults(state, x, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 4);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-1,1]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the gradient - say, add
        //       1.0 to some of its components.
        //
        minbleicoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minbleic_d_2(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    c: TMatrix;
    ct: TIVector;
    state: Tminbleicstate;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    maxits: TALGLIBInteger;
    rep: Tminbleicreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // subject to inequality constraints
        //
        // * x>=2 (posed as general linear constraint),
        // * x+y>=6
        //
        // using BLEIC optimizer with
        // * initial point x=[0,0]
        // * unit scale being set for all variables (see minbleicsetscale for more info)
        // * stopping criteria set to "terminate after short enough step"
        // * OptGuard integrity check being used to check problem statement
        //   for some common errors like nonsmoothness or bad analytic gradient
        //
        // First, we create optimizer object and tune its properties:
        // * set linear constraints
        // * set variable scales
        // * set stopping criteria
        //
        x:=Str2Vector('[5,5]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=6 then
            spoil_vector_by_deleting_element(s);
        c:=Str2Matrix('[[1,0,2],[1,1,6]]');
        if _spoil_scenario=7 then
            spoil_matrix_by_value(c, Double(NaN));
        if _spoil_scenario=8 then
            spoil_matrix_by_value(c, Double(Infinity));
        if _spoil_scenario=9 then
            spoil_matrix_by_value(c, Double(NegInfinity));
        if _spoil_scenario=10 then
            spoil_matrix_by_deleting_row(c);
        if _spoil_scenario=11 then
            spoil_matrix_by_deleting_col(c);
        ct:=Str2IVector('[1,1]');
        if _spoil_scenario=12 then
            spoil_vector_by_deleting_element(ct);
        epsg:=0;
        if _spoil_scenario=13 then
            epsg:=Double(NaN);
        if _spoil_scenario=14 then
            epsg:=Double(Infinity);
        if _spoil_scenario=15 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=16 then
            epsf:=Double(NaN);
        if _spoil_scenario=17 then
            epsf:=Double(Infinity);
        if _spoil_scenario=18 then
            epsf:=Double(NegInfinity);
        epsx:=0.000001;
        if _spoil_scenario=19 then
            epsx:=Double(NaN);
        if _spoil_scenario=20 then
            epsx:=Double(Infinity);
        if _spoil_scenario=21 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        minbleiccreate(x, state);
        minbleicsetlc(state, c, ct);
        minbleicsetscale(state, s);
        minbleicsetcond(state, epsg, epsf, epsx, maxits);

        //
        // Then we activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target function (C0 continuity violation)
        // * nonsmoothness of the target function (C1 continuity violation)
        // * erroneous analytic gradient, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION. DO NOT USE IT IN PRODUCTION CODE!!!!!!!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        minbleicoptguardsmoothness(state);
        minbleicoptguardgradient(state, 0.001);

        //
        // Optimize and evaluate results
        //
        minbleicoptimize(state, function1_grad, nil, nil);
        minbleicresults(state, x, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 4);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[2,4]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the gradient - say, add
        //       1.0 to some of its components.
        //
        minbleicoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minbleic_numdiff(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    state: Tminbleicstate;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    maxits: TALGLIBInteger;
    diffstep: Double;
    rep: Tminbleicreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // subject to box constraints
        //
        //     -1<=x<=+1, -1<=y<=+1
        //
        // using BLEIC optimizer with:
        // * numerical differentiation being used
        // * initial point x=[0,0]
        // * unit scale being set for all variables (see minbleicsetscale for more info)
        // * stopping criteria set to "terminate after short enough step"
        // * OptGuard integrity check being used to check problem statement
        //   for some common errors like nonsmoothness or bad analytic gradient
        //
        // First, we create optimizer object and tune its properties:
        // * set box constraints
        // * set variable scales
        // * set stopping criteria
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=6 then
            spoil_vector_by_deleting_element(s);
        bndl:=Str2Vector('[-1,-1]');
        if _spoil_scenario=7 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[+1,+1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_deleting_element(bndu);
        epsg:=0;
        if _spoil_scenario=11 then
            epsg:=Double(NaN);
        if _spoil_scenario=12 then
            epsg:=Double(Infinity);
        if _spoil_scenario=13 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=14 then
            epsf:=Double(NaN);
        if _spoil_scenario=15 then
            epsf:=Double(Infinity);
        if _spoil_scenario=16 then
            epsf:=Double(NegInfinity);
        epsx:=0.000001;
        if _spoil_scenario=17 then
            epsx:=Double(NaN);
        if _spoil_scenario=18 then
            epsx:=Double(Infinity);
        if _spoil_scenario=19 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        diffstep:=1.0e-6;
        if _spoil_scenario=20 then
            diffstep:=Double(NaN);
        if _spoil_scenario=21 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=22 then
            diffstep:=Double(NegInfinity);

        minbleiccreatef(x, diffstep, state);
        minbleicsetbc(state, bndl, bndu);
        minbleicsetscale(state, s);
        minbleicsetcond(state, epsg, epsf, epsx, maxits);

        //
        // Then we activate OptGuard integrity checking.
        //
        // Numerical differentiation always produces "correct" gradient
        // (with some truncation error, but unbiased). Thus, we just have
        // to check smoothness properties of the target: C0 and C1 continuity.
        //
        // Sometimes user accidentally tries to solve nonsmooth problems
        // with smooth optimizer. OptGuard helps to detect such situations
        // early, at the prototyping stage.
        //
        minbleicoptguardsmoothness(state);

        //
        // Optimize and evaluate results
        //
        minbleicoptimize(state, function1_func, nil, nil);
        minbleicresults(state, x, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 4);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-1,1]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // Want to challenge OptGuard? Try to make your problem
        // nonsmooth by replacing 100*(x+3)^4 by 100*|x+3| and
        // re-run optimizer.
        //
        minbleicoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minqp_d_u1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    b: TVector;
    x0: TVector;
    s: TVector;
    x: TVector;
    state: Tminqpstate;
    rep: Tminqpreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = x0^2 + x1^2 -6*x0 - 4*x1
        //
        // Exact solution is [x0,x1] = [3,2]
        //
        // We provide algorithm with starting point, although in this case
        // (dense matrix, no constraints) it can work without such information.
        //
        // Several QP solvers are tried: QuickQP, BLEIC, DENSE-AUL.
        //
        // IMPORTANT: this solver minimizes  following  function:
        //     f(x) = 0.5*x'*A*x + b'*x.
        // Note that quadratic term has 0.5 before it. So if you want to minimize
        // quadratic function, you should rewrite it in such way that quadratic term
        // is multiplied by 0.5 too.
        //
        // For example, our function is f(x)=x0^2+x1^2+..., but we rewrite it as 
        //     f(x) = 0.5*(2*x0^2+2*x1^2) + .... 
        // and pass diag(2,2) as quadratic term - NOT diag(1,1)!
        //
        a:=Str2Matrix('[[2,0],[0,2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(a);
        b:=Str2Vector('[-6,-4]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(b, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(b, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(b, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(b);
        x0:=Str2Vector('[0,1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=11 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        if _spoil_scenario=12 then
            spoil_vector_by_deleting_element(x0);
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=13 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=14 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=15 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=16 then
            spoil_vector_by_deleting_element(s);

        // create solver, set quadratic/linear terms
        minqpcreate(2, state);
        minqpsetquadraticterm(state, a);
        minqpsetlinearterm(state, b);
        minqpsetstartingpoint(state, x0);

        // Set scale of the parameters.
        // It is strongly recommended that you set scale of your variables.
        // Knowing their scales is essential for evaluation of stopping criteria
        // and for preconditioning of the algorithm steps.
        // You can find more information on scaling at http://www.alglib.net/optimization/scaling.php
        //
        // NOTE: for convex problems you may try using minqpsetscaleautodiag()
        //       which automatically determines variable scales.
        minqpsetscale(state, s);

        //
        // Solve problem with QuickQP solver.
        //
        // This solver is intended for medium and large-scale problems with box
        // constraints (general linear constraints are not supported), but it can
        // also be efficiently used on unconstrained problems.
        //
        // Default stopping criteria are used, Newton phase is active.
        //
        minqpsetalgoquickqp(state, 0.0, 0.0, 0.0, 0, true);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[3,2]'), 0.005);

        //
        // Solve problem with BLEIC-based QP solver.
        //
        // This solver is intended for problems with moderate (up to 50) number
        // of general linear constraints and unlimited number of box constraints.
        // Of course, unconstrained problems can be solved too.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgobleic(state, 0.0, 0.0, 0.0, 0);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[3,2]'), 0.005);

        //
        // Solve problem with DENSE-AUL solver.
        //
        // This solver is optimized for problems with up to several thousands of
        // variables and large amount of general linear constraints. Problems with
        // less than 50 general linear constraints can be efficiently solved with
        // BLEIC, problems with box-only constraints can be solved with QuickQP.
        // However, DENSE-AUL will work in any (including unconstrained) case.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgodenseaul(state, 1.0e-9, 1.0e+4, 5);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[3,2]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minqp_d_bc1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    b: TVector;
    x0: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    x: TVector;
    state: Tminqpstate;
    rep: Tminqpreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = x0^2 + x1^2 -6*x0 - 4*x1
        // subject to bound constraints 0<=x0<=2.5, 0<=x1<=2.5
        //
        // Exact solution is [x0,x1] = [2.5,2]
        //
        // We provide algorithm with starting point. With such small problem good starting
        // point is not really necessary, but with high-dimensional problem it can save us
        // a lot of time.
        //
        // Several QP solvers are tried: QuickQP, BLEIC, DENSE-AUL.
        //
        // IMPORTANT: this solver minimizes  following  function:
        //     f(x) = 0.5*x'*A*x + b'*x.
        // Note that quadratic term has 0.5 before it. So if you want to minimize
        // quadratic function, you should rewrite it in such way that quadratic term
        // is multiplied by 0.5 too.
        // For example, our function is f(x)=x0^2+x1^2+..., but we rewrite it as 
        //     f(x) = 0.5*(2*x0^2+2*x1^2) + ....
        // and pass diag(2,2) as quadratic term - NOT diag(1,1)!
        //
        a:=Str2Matrix('[[2,0],[0,2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(a);
        b:=Str2Vector('[-6,-4]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(b, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(b, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(b, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(b);
        x0:=Str2Vector('[0,1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=11 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        if _spoil_scenario=12 then
            spoil_vector_by_deleting_element(x0);
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=13 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=14 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=15 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=16 then
            spoil_vector_by_deleting_element(s);
        bndl:=Str2Vector('[0.0,0.0]');
        if _spoil_scenario=17 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=18 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[2.5,2.5]');
        if _spoil_scenario=19 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=20 then
            spoil_vector_by_deleting_element(bndu);

        // create solver, set quadratic/linear terms
        minqpcreate(2, state);
        minqpsetquadraticterm(state, a);
        minqpsetlinearterm(state, b);
        minqpsetstartingpoint(state, x0);
        minqpsetbc(state, bndl, bndu);

        // Set scale of the parameters.
        // It is strongly recommended that you set scale of your variables.
        // Knowing their scales is essential for evaluation of stopping criteria
        // and for preconditioning of the algorithm steps.
        // You can find more information on scaling at http://www.alglib.net/optimization/scaling.php
        //
        // NOTE: for convex problems you may try using minqpsetscaleautodiag()
        //       which automatically determines variable scales.
        minqpsetscale(state, s);

        //
        // Solve problem with QuickQP solver.
        //
        // This solver is intended for medium and large-scale problems with box
        // constraints (general linear constraints are not supported).
        //
        // Default stopping criteria are used, Newton phase is active.
        //
        minqpsetalgoquickqp(state, 0.0, 0.0, 0.0, 0, true);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 4);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[2.5,2]'), 0.005);

        //
        // Solve problem with BLEIC-based QP solver.
        //
        // This solver is intended for problems with moderate (up to 50) number
        // of general linear constraints and unlimited number of box constraints.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgobleic(state, 0.0, 0.0, 0.0, 0);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[2.5,2]'), 0.005);

        //
        // Solve problem with DENSE-AUL solver.
        //
        // This solver is optimized for problems with up to several thousands of
        // variables and large amount of general linear constraints. Problems with
        // less than 50 general linear constraints can be efficiently solved with
        // BLEIC, problems with box-only constraints can be solved with QuickQP.
        // However, DENSE-AUL will work in any (including unconstrained) case.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgodenseaul(state, 1.0e-9, 1.0e+4, 5);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[2.5,2]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minqp_d_lc1(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    b: TVector;
    s: TVector;
    c: TMatrix;
    ct: TIVector;
    x: TVector;
    state: Tminqpstate;
    rep: Tminqpreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = x0^2 + x1^2 -6*x0 - 4*x1
        // subject to linear constraint x0+x1<=2
        //
        // Exact solution is [x0,x1] = [1.5,0.5]
        //
        // IMPORTANT: this solver minimizes  following  function:
        //     f(x) = 0.5*x'*A*x + b'*x.
        // Note that quadratic term has 0.5 before it. So if you want to minimize
        // quadratic function, you should rewrite it in such way that quadratic term
        // is multiplied by 0.5 too.
        // For example, our function is f(x)=x0^2+x1^2+..., but we rewrite it as 
        //     f(x) = 0.5*(2*x0^2+2*x1^2) + ....
        // and pass diag(2,2) as quadratic term - NOT diag(1,1)!
        //
        a:=Str2Matrix('[[2,0],[0,2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(a);
        b:=Str2Vector('[-6,-4]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(b, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(b, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(b, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(b);
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=11 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=12 then
            spoil_vector_by_deleting_element(s);
        c:=Str2Matrix('[[1.0,1.0,2.0]]');
        if _spoil_scenario=13 then
            spoil_matrix_by_value(c, Double(NaN));
        if _spoil_scenario=14 then
            spoil_matrix_by_value(c, Double(Infinity));
        if _spoil_scenario=15 then
            spoil_matrix_by_value(c, Double(NegInfinity));
        ct:=Str2IVector('[-1]');

        // create solver, set quadratic/linear terms
        minqpcreate(2, state);
        minqpsetquadraticterm(state, a);
        minqpsetlinearterm(state, b);
        minqpsetlc(state, c, ct);

        // Set scale of the parameters.
        // It is strongly recommended that you set scale of your variables.
        // Knowing their scales is essential for evaluation of stopping criteria
        // and for preconditioning of the algorithm steps.
        // You can find more information on scaling at http://www.alglib.net/optimization/scaling.php
        //
        // NOTE: for convex problems you may try using minqpsetscaleautodiag()
        //       which automatically determines variable scales.
        minqpsetscale(state, s);

        //
        // Solve problem with BLEIC-based QP solver.
        //
        // This solver is intended for problems with moderate (up to 50) number
        // of general linear constraints and unlimited number of box constraints.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgobleic(state, 0.0, 0.0, 0.0, 0);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[1.500,0.500]'), 0.05);

        //
        // Solve problem with DENSE-AUL solver.
        //
        // This solver is optimized for problems with up to several thousands of
        // variables and large amount of general linear constraints. Problems with
        // less than 50 general linear constraints can be efficiently solved with
        // BLEIC, problems with box-only constraints can be solved with QuickQP.
        // However, DENSE-AUL will work in any (including unconstrained) case.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgodenseaul(state, 1.0e-9, 1.0e+4, 5);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[1.500,0.500]'), 0.05);

        //
        // Solve problem with QuickQP solver.
        //
        // This solver is intended for medium and large-scale problems with box
        // constraints, and...
        //
        // ...Oops! It does not support general linear constraints, -5 returned as completion code!
        //
        minqpsetalgoquickqp(state, 0.0, 0.0, 0.0, 0, true);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_int(rep.terminationtype, -5);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minqp_d_u2(_spoil_scenario: Integer):Boolean;
var
    a: Tsparsematrix;
    b: TVector;
    x0: TVector;
    s: TVector;
    x: TVector;
    state: Tminqpstate;
    rep: Tminqpreport;

begin
    Result:=True;
    try
        a:=nil;
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = x0^2 + x1^2 -6*x0 - 4*x1,
        // with quadratic term given by sparse matrix structure.
        //
        // Exact solution is [x0,x1] = [3,2]
        //
        // We provide algorithm with starting point, although in this case
        // (dense matrix, no constraints) it can work without such information.
        //
        // IMPORTANT: this solver minimizes  following  function:
        //     f(x) = 0.5*x'*A*x + b'*x.
        // Note that quadratic term has 0.5 before it. So if you want to minimize
        // quadratic function, you should rewrite it in such way that quadratic term
        // is multiplied by 0.5 too.
        //
        // For example, our function is f(x)=x0^2+x1^2+..., but we rewrite it as 
        //     f(x) = 0.5*(2*x0^2+2*x1^2) + ....
        // and pass diag(2,2) as quadratic term - NOT diag(1,1)!
        //
        b:=Str2Vector('[-6,-4]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(b);
        x0:=Str2Vector('[0,1]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(x0);
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(s);

        // initialize sparsematrix structure
        sparsecreate(2, 2, 0, a);
        sparseset(a, 0, 0, 2.0);
        sparseset(a, 1, 1, 2.0);

        // create solver, set quadratic/linear terms
        minqpcreate(2, state);
        minqpsetquadratictermsparse(state, a, true);
        minqpsetlinearterm(state, b);
        minqpsetstartingpoint(state, x0);

        // Set scale of the parameters.
        // It is strongly recommended that you set scale of your variables.
        // Knowing their scales is essential for evaluation of stopping criteria
        // and for preconditioning of the algorithm steps.
        // You can find more information on scaling at http://www.alglib.net/optimization/scaling.php
        //
        // NOTE: for convex problems you may try using minqpsetscaleautodiag()
        //       which automatically determines variable scales.
        minqpsetscale(state, s);

        //
        // Solve problem with BLEIC-based QP solver.
        //
        // This solver is intended for problems with moderate (up to 50) number
        // of general linear constraints and unlimited number of box constraints.
        // It also supports sparse problems.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgobleic(state, 0.0, 0.0, 0.0, 0);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[3,2]'), 0.005);

    finally
        FreeAndNil(a);
        FreeAndNil(state);

    end;
end;


function _test_minqp_d_nonconvex(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    x0: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    x: TVector;
    state: Tminqpstate;
    rep: Tminqpreport;
    nobndl: TVector;
    nobndu: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of nonconvex function
        //     F(x0,x1) = -(x0^2+x1^2)
        // subject to constraints x0,x1 in [1.0,2.0]
        // Exact solution is [x0,x1] = [2,2].
        //
        // Non-convex problems are harded to solve than convex ones, and they
        // may have more than one local minimum. However, ALGLIB solves may deal
        // with such problems (altough they do not guarantee convergence to
        // global minimum).
        //
        // IMPORTANT: this solver minimizes  following  function:
        //     f(x) = 0.5*x'*A*x + b'*x.
        // Note that quadratic term has 0.5 before it. So if you want to minimize
        // quadratic function, you should rewrite it in such way that quadratic term
        // is multiplied by 0.5 too.
        //
        // For example, our function is f(x)=-(x0^2+x1^2), but we rewrite it as 
        //     f(x) = 0.5*(-2*x0^2-2*x1^2)
        // and pass diag(-2,-2) as quadratic term - NOT diag(-1,-1)!
        //
        a:=Str2Matrix('[[-2,0],[0,-2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(a, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(a);
        x0:=Str2Vector('[1,1]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(x0);
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=11 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=12 then
            spoil_vector_by_deleting_element(s);
        bndl:=Str2Vector('[1.0,1.0]');
        if _spoil_scenario=13 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=14 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[2.0,2.0]');
        if _spoil_scenario=15 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=16 then
            spoil_vector_by_deleting_element(bndu);

        // create solver, set quadratic/linear terms, constraints
        minqpcreate(2, state);
        minqpsetquadraticterm(state, a);
        minqpsetstartingpoint(state, x0);
        minqpsetbc(state, bndl, bndu);

        // Set scale of the parameters.
        // It is strongly recommended that you set scale of your variables.
        // Knowing their scales is essential for evaluation of stopping criteria
        // and for preconditioning of the algorithm steps.
        // You can find more information on scaling at http://www.alglib.net/optimization/scaling.php
        //
        // NOTE: there also exists minqpsetscaleautodiag() function
        //       which automatically determines variable scales; however,
        //       it does NOT work for non-convex problems.
        minqpsetscale(state, s);

        //
        // Solve problem with BLEIC-based QP solver.
        //
        // This solver is intended for problems with moderate (up to 50) number
        // of general linear constraints and unlimited number of box constraints.
        //
        // It may solve non-convex problems as long as they are bounded from
        // below under constraints.
        //
        // Default stopping criteria are used.
        //
        minqpsetalgobleic(state, 0.0, 0.0, 0.0, 0);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[2,2]'), 0.005);

        //
        // Solve problem with DENSE-AUL solver.
        //
        // This solver is optimized for problems with up to several thousands of
        // variables and large amount of general linear constraints. Problems with
        // less than 50 general linear constraints can be efficiently solved with
        // BLEIC, problems with box-only constraints can be solved with QuickQP.
        // However, DENSE-AUL will work in any (including unconstrained) case.
        //
        // Algorithm convergence is guaranteed only for convex case, but you may
        // expect that it will work for non-convex problems too (because near the
        // solution they are locally convex).
        //
        // Default stopping criteria are used.
        //
        minqpsetalgodenseaul(state, 1.0e-9, 1.0e+4, 5);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[2,2]'), 0.005);

        // Hmm... this problem is bounded from below (has solution) only under constraints.
        // What it we remove them?
        //
        // You may see that BLEIC algorithm detects unboundedness of the problem, 
        // -4 is returned as completion code. However, DENSE-AUL is unable to detect
        // such situation and it will cycle forever (we do not test it here).
        nobndl:=Str2Vector('[-inf,-inf]');
        if _spoil_scenario=17 then
            spoil_vector_by_value(nobndl, Double(NaN));
        if _spoil_scenario=18 then
            spoil_vector_by_deleting_element(nobndl);
        nobndu:=Str2Vector('[+inf,+inf]');
        if _spoil_scenario=19 then
            spoil_vector_by_value(nobndu, Double(NaN));
        if _spoil_scenario=20 then
            spoil_vector_by_deleting_element(nobndu);
        minqpsetbc(state, nobndl, nobndu);
        minqpsetalgobleic(state, 0.0, 0.0, 0.0, 0);
        minqpoptimize(state);
        minqpresults(state, x, rep);
        Result:=Result and doc_test_int(rep.terminationtype, -4);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlp_basic(_spoil_scenario: Integer):Boolean;
var
    a: TMatrix;
    al: TVector;
    au: TVector;
    c: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    x: TVector;
    state: Tminlpstate;
    rep: Tminlpreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates how to minimize
        //
        //     F(x0,x1) = -0.1*x0 - x1
        //
        // subject to box constraints
        //
        //     -1 <= x0,x1 <= +1 
        //
        // and general linear constraints
        //
        //     x0 - x1 >= -1
        //     x0 + x1 <=  1
        //
        // We use dual simplex solver provided by ALGLIB for this task. Box
        // constraints are specified by means of constraint vectors bndl and
        // bndu (we have bndl<=x<=bndu). General linear constraints are
        // specified as AL<=A*x<=AU, with AL/AU being 2x1 vectors and A being
        // 2x2 matrix.
        //
        // NOTE: some/all components of AL/AU can be +-INF, same applies to
        //       bndl/bndu. You can also have AL[I]=AU[i] (as well as
        //       BndL[i]=BndU[i]).
        //
        a:=Str2Matrix('[[1,-1],[1,+1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_deleting_row(a);
        if _spoil_scenario=2 then
            spoil_matrix_by_deleting_col(a);
        al:=Str2Vector('[-1,-inf]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(al, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(al);
        au:=Str2Vector('[+inf,+1]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(au, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_deleting_element(au);
        c:=Str2Vector('[-0.1,-1]');
        if _spoil_scenario=7 then
            spoil_vector_by_value(c, Double(NaN));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(c);
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_deleting_element(s);
        bndl:=Str2Vector('[-1,-1]');
        if _spoil_scenario=11 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=12 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[+1,+1]');
        if _spoil_scenario=13 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=14 then
            spoil_vector_by_deleting_element(bndu);

        minlpcreate(2, state);

        //
        // Set cost vector, box constraints, general linear constraints.
        //
        // Box constraints can be set in one call to minlpsetbc() or minlpsetbcall()
        // (latter sets same constraints for all variables and accepts two scalars
        // instead of two vectors).
        //
        // General linear constraints can be specified in several ways:
        // * minlpsetlc2dense() - accepts dense 2D array as input; sometimes this
        //   approach is more convenient, although less memory-efficient.
        // * minlpsetlc2() - accepts sparse matrix as input
        // * minlpaddlc2dense() - appends one row to the current set of constraints;
        //   row being appended is specified as dense vector
        // * minlpaddlc2() - appends one row to the current set of constraints;
        //   row being appended is specified as sparse set of elements
        // Independently from specific function being used, LP solver uses sparse
        // storage format for internal representation of constraints.
        //
        minlpsetcost(state, c);
        minlpsetbc(state, bndl, bndu);
        minlpsetlc2dense(state, a, al, au, 2);

        //
        // Set scale of the parameters.
        //
        // It is strongly recommended that you set scale of your variables.
        // Knowing their scales is essential for evaluation of stopping criteria
        // and for preconditioning of the algorithm steps.
        // You can find more information on scaling at http://www.alglib.net/optimization/scaling.php
        //
        minlpsetscale(state, s);

        // Solve
        minlpoptimize(state);
        minlpresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[0,1]'), 0.0005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minnlc_d_inequality(_spoil_scenario: Integer):Boolean;
var
    x0: TVector;
    s: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    bndl: TVector;
    bndu: TVector;
    state: Tminnlcstate;
    rho: Double;
    outerits: TALGLIBInteger;
    rep: Tminnlcreport;
    x1: TVector;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x0,x1) = -x0+x1
        //
        // subject to box constraints
        //
        //    x0>=0, x1>=0
        //
        // and nonlinear inequality constraint
        //
        //    x0^2 + x1^2 - 1 <= 0
        //
        x0:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.000001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        bndl:=Str2Vector('[0,0]');
        bndu:=Str2Vector('[+inf,+inf]');

        //
        // Create optimizer object and tune its settings:
        // * epsx=0.000001  stopping condition for inner iterations
        // * s=[1,1]        all variables have unit scale; it is important to
        //                  tell optimizer about scales of your variables - it
        //                  greatly accelerates convergence and helps to perform
        //                  some important integrity checks.
        //
        minnlccreate(2, x0, state);
        minnlcsetcond(state, epsx, maxits);
        minnlcsetscale(state, s);

        //
        // Choose one of the nonlinear programming solvers supported by minnlc
        // optimizer:
        // * SLP - successive linear programming NLP solver
        // * AUL - augmented Lagrangian NLP solver
        //
        // Different solvers have different properties:
        // * SLP is the most robust solver provided by ALGLIB: it can solve both
        //   convex and nonconvex optimization problems, it respects box and
        //   linear constraints (after you find feasible point it won't move away
        //   from the feasible area) and tries to respect nonlinear constraints
        //   as much as possible. It also usually needs less function evaluations
        //   to converge than AUL.
        //   However, it solves LP subproblems at each iterations which adds
        //   significant overhead to its running time. Sometimes it can be as much
        //   as 7x times slower than AUL.
        // * AUL solver is less robust than SLP - it can violate box and linear
        //   constraints at any moment, and it is intended for convex optimization
        //   problems (although in many cases it can deal with nonconvex ones too).
        //   Also, unlike SLP it needs some tuning (penalty factor and number of
        //   outer iterations).
        //   However, it is often much faster than the current version of SLP.
        //
        // In the code below we set solver to be AUL but then override it with SLP,
        // so the effective choice is to use SLP. We recommend you to use SLP at
        // least for early prototyping stages.
        //
        // You can comment out line with SLP if you want to solve your problem with
        // AUL solver.
        //
        rho:=1000.0;
        outerits:=5;
        minnlcsetalgoaul(state, rho, outerits);
        minnlcsetalgoslp(state);

        //
        // Set constraints:
        //
        // 1. boundary constraints are passed with minnlcsetbc() call
        //
        // 2. nonlinear constraints are more tricky - you can not "pack" general
        //    nonlinear function into double precision array. That's why
        //    minnlcsetnlc() does not accept constraints itself - only constraint
        //    counts are passed: first parameter is number of equality constraints,
        //    second one is number of inequality constraints.
        //
        //    As for constraining functions - these functions are passed as part
        //    of problem Jacobian (see below).
        //
        // NOTE: MinNLC optimizer supports arbitrary combination of boundary, general
        //       linear and general nonlinear constraints. This example does not
        //       show how to work with general linear constraints, but you can
        //       easily find it in documentation on minnlcsetlc() function.
        //
        minnlcsetbc(state, bndl, bndu);
        minnlcsetnlc(state, 0, 1);

        //
        // Activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target/constraints (C0 continuity violation)
        // * nonsmoothness of the target/constraints (C1 continuity violation)
        // * erroneous analytic Jacobian, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION, THUS DO NOT USE IT IN PRODUCTION CODE!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        minnlcoptguardsmoothness(state);
        minnlcoptguardgradient(state, 0.001);

        //
        // Optimize and test results.
        //
        // Optimizer object accepts vector function and its Jacobian, with first
        // component (Jacobian row) being target function, and next components
        // (Jacobian rows) being nonlinear equality and inequality constraints.
        //
        // So, our vector function has form
        //
        //     {f0,f1} = { -x0+x1 , x0^2+x1^2-1 }
        //
        // with Jacobian
        //
        //         [  -1    +1  ]
        //     J = [            ]
        //         [ 2*x0  2*x1 ]
        //
        // with f0 being target function, f1 being constraining function. Number
        // of equality/inequality constraints is specified by minnlcsetnlc(),
        // with equality ones always being first, inequality ones being last.
        //
        minnlcoptimize(state, nlcfunc1_jac, nil, nil);
        minnlcresults(state, x1, rep);
        Result:=Result and doc_test_real_vector(x1, Str2Vector('[1.0000,0.0000]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the Jacobian - say, add
        //       1.0 to some of its components.
        //
        minnlcoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minnlc_d_equality(_spoil_scenario: Integer):Boolean;
var
    x0: TVector;
    s: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminnlcstate;
    rho: Double;
    outerits: TALGLIBInteger;
    rep: Tminnlcreport;
    x1: TVector;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x0,x1) = -x0+x1
        //
        // subject to nonlinear equality constraint
        //
        //    x0^2 + x1^2 - 1 = 0
        //
        x0:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.000001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer object and tune its settings:
        // * epsx=0.000001  stopping condition for inner iterations
        // * s=[1,1]        all variables have unit scale
        //
        minnlccreate(2, x0, state);
        minnlcsetcond(state, epsx, maxits);
        minnlcsetscale(state, s);

        //
        // Choose one of the nonlinear programming solvers supported by minnlc
        // optimizer:
        // * SLP - successive linear programming NLP solver
        // * AUL - augmented Lagrangian NLP solver
        //
        // Different solvers have different properties:
        // * SLP is the most robust solver provided by ALGLIB: it can solve both
        //   convex and nonconvex optimization problems, it respects box and
        //   linear constraints (after you find feasible point it won't move away
        //   from the feasible area) and tries to respect nonlinear constraints
        //   as much as possible. It also usually needs less function evaluations
        //   to converge than AUL.
        //   However, it solves LP subproblems at each iterations which adds
        //   significant overhead to its running time. Sometimes it can be as much
        //   as 7x times slower than AUL.
        // * AUL solver is less robust than SLP - it can violate box and linear
        //   constraints at any moment, and it is intended for convex optimization
        //   problems (although in many cases it can deal with nonconvex ones too).
        //   Also, unlike SLP it needs some tuning (penalty factor and number of
        //   outer iterations).
        //   However, it is often much faster than the current version of SLP.
        //
        // In the code below we set solver to be AUL but then override it with SLP,
        // so the effective choice is to use SLP. We recommend you to use SLP at
        // least for early prototyping stages.
        //
        // You can comment out line with SLP if you want to solve your problem with
        // AUL solver.
        //
        rho:=1000.0;
        outerits:=5;
        minnlcsetalgoaul(state, rho, outerits);
        minnlcsetalgoslp(state);

        //
        // Set constraints:
        //
        // Nonlinear constraints are tricky - you can not "pack" general
        // nonlinear function into double precision array. That's why
        // minnlcsetnlc() does not accept constraints itself - only constraint
        // counts are passed: first parameter is number of equality constraints,
        // second one is number of inequality constraints.
        //
        // As for constraining functions - these functions are passed as part
        // of problem Jacobian (see below).
        //
        // NOTE: MinNLC optimizer supports arbitrary combination of boundary, general
        //       linear and general nonlinear constraints. This example does not
        //       show how to work with general linear constraints, but you can
        //       easily find it in documentation on minnlcsetbc() and
        //       minnlcsetlc() functions.
        //
        minnlcsetnlc(state, 1, 0);

        //
        // Activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target/constraints (C0 continuity violation)
        // * nonsmoothness of the target/constraints (C1 continuity violation)
        // * erroneous analytic Jacobian, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION, THUS DO NOT USE IT IN PRODUCTION CODE!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        minnlcoptguardsmoothness(state);
        minnlcoptguardgradient(state, 0.001);

        //
        // Optimize and test results.
        //
        // Optimizer object accepts vector function and its Jacobian, with first
        // component (Jacobian row) being target function, and next components
        // (Jacobian rows) being nonlinear equality and inequality constraints.
        //
        // So, our vector function has form
        //
        //     {f0,f1} = { -x0+x1 , x0^2+x1^2-1 }
        //
        // with Jacobian
        //
        //         [  -1    +1  ]
        //     J = [            ]
        //         [ 2*x0  2*x1 ]
        //
        // with f0 being target function, f1 being constraining function. Number
        // of equality/inequality constraints is specified by minnlcsetnlc(),
        // with equality ones always being first, inequality ones being last.
        //
        minnlcoptimize(state, nlcfunc1_jac, nil, nil);
        minnlcresults(state, x1, rep);
        Result:=Result and doc_test_real_vector(x1, Str2Vector('[0.70710,-0.70710]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the Jacobian - say, add
        //       1.0 to some of its components.
        //
        minnlcoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minnlc_d_mixed(_spoil_scenario: Integer):Boolean;
var
    x0: TVector;
    s: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminnlcstate;
    rep: Tminnlcreport;
    x1: TVector;
    rho: Double;
    outerits: TALGLIBInteger;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x0,x1) = x0+x1
        //
        // subject to nonlinear inequality constraint
        //
        //    x0^2 + x1^2 - 1 <= 0
        //
        // and nonlinear equality constraint
        //
        //    x2-exp(x0) = 0
        //
        x0:=Str2Vector('[0,0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        s:=Str2Vector('[1,1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.000001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer object and tune its settings:
        // * epsx=0.000001  stopping condition for inner iterations
        // * s=[1,1]        all variables have unit scale
        // * upper limit on step length is specified (to avoid probing locations where exp() is large)
        //
        minnlccreate(3, x0, state);
        minnlcsetcond(state, epsx, maxits);
        minnlcsetscale(state, s);
        minnlcsetstpmax(state, 10.0);

        //
        // Choose one of the nonlinear programming solvers supported by minnlc
        // optimizer:
        // * SLP - successive linear programming NLP solver
        // * AUL - augmented Lagrangian NLP solver
        //
        // Different solvers have different properties:
        // * SLP is the most robust solver provided by ALGLIB: it can solve both
        //   convex and nonconvex optimization problems, it respects box and
        //   linear constraints (after you find feasible point it won't move away
        //   from the feasible area) and tries to respect nonlinear constraints
        //   as much as possible. It also usually needs less function evaluations
        //   to converge than AUL.
        //   However, it solves LP subproblems at each iterations which adds
        //   significant overhead to its running time. Sometimes it can be as much
        //   as 7x times slower than AUL.
        // * AUL solver is less robust than SLP - it can violate box and linear
        //   constraints at any moment, and it is intended for convex optimization
        //   problems (although in many cases it can deal with nonconvex ones too).
        //   Also, unlike SLP it needs some tuning (penalty factor and number of
        //   outer iterations).
        //   However, it is often much faster than the current version of SLP.
        //
        // In the code below we set solver to be AUL but then override it with SLP,
        // so the effective choice is to use SLP. We recommend you to use SLP at
        // least for early prototyping stages.
        //
        // You can comment out line with SLP if you want to solve your problem with
        // AUL solver.
        //
        rho:=1000.0;
        outerits:=5;
        minnlcsetalgoaul(state, rho, outerits);
        minnlcsetalgoslp(state);

        //
        // Set constraints:
        //
        // Nonlinear constraints are tricky - you can not "pack" general
        // nonlinear function into double precision array. That's why
        // minnlcsetnlc() does not accept constraints itself - only constraint
        // counts are passed: first parameter is number of equality constraints,
        // second one is number of inequality constraints.
        //
        // As for constraining functions - these functions are passed as part
        // of problem Jacobian (see below).
        //
        // NOTE: MinNLC optimizer supports arbitrary combination of boundary, general
        //       linear and general nonlinear constraints. This example does not
        //       show how to work with boundary or general linear constraints, but you
        //       can easily find it in documentation on minnlcsetbc() and
        //       minnlcsetlc() functions.
        //
        minnlcsetnlc(state, 1, 1);

        //
        // Activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target/constraints (C0 continuity violation)
        // * nonsmoothness of the target/constraints (C1 continuity violation)
        // * erroneous analytic Jacobian, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION, THUS DO NOT USE IT IN PRODUCTION CODE!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        minnlcoptguardsmoothness(state);
        minnlcoptguardgradient(state, 0.001);

        //
        // Optimize and test results.
        //
        // Optimizer object accepts vector function and its Jacobian, with first
        // component (Jacobian row) being target function, and next components
        // (Jacobian rows) being nonlinear equality and inequality constraints.
        //
        // So, our vector function has form
        //
        //     {f0,f1,f2} = { x0+x1 , x2-exp(x0) , x0^2+x1^2-1 }
        //
        // with Jacobian
        //
        //         [  +1      +1       0 ]
        //     J = [-exp(x0)  0        1 ]
        //         [ 2*x0    2*x1      0 ]
        //
        // with f0 being target function, f1 being equality constraint "f1=0",
        // f2 being inequality constraint "f2<=0". Number of equality/inequality
        // constraints is specified by minnlcsetnlc(), with equality ones always
        // being first, inequality ones being last.
        //
        minnlcoptimize(state, nlcfunc2_jac, nil, nil);
        minnlcresults(state, x1, rep);
        Result:=Result and doc_test_real_vector(x1, Str2Vector('[-0.70710,-0.70710,0.49306]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the Jacobian - say, add
        //       1.0 to some of its components.
        //
        minnlcoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minbc_d_1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    state: Tminbcstate;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    maxits: TALGLIBInteger;
    rep: Tminbcreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // subject to box constraints
        //
        //     -1<=x<=+1, -1<=y<=+1
        //
        // using MinBC optimizer with:
        // * initial point x=[0,0]
        // * unit scale being set for all variables (see minbcsetscale for more info)
        // * stopping criteria set to "terminate after short enough step"
        // * OptGuard integrity check being used to check problem statement
        //   for some common errors like nonsmoothness or bad analytic gradient
        //
        // First, we create optimizer object and tune its properties:
        // * set box constraints
        // * set variable scales
        // * set stopping criteria
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=6 then
            spoil_vector_by_deleting_element(s);
        bndl:=Str2Vector('[-1,-1]');
        if _spoil_scenario=7 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[+1,+1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_deleting_element(bndu);
        epsg:=0;
        if _spoil_scenario=11 then
            epsg:=Double(NaN);
        if _spoil_scenario=12 then
            epsg:=Double(Infinity);
        if _spoil_scenario=13 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=14 then
            epsf:=Double(NaN);
        if _spoil_scenario=15 then
            epsf:=Double(Infinity);
        if _spoil_scenario=16 then
            epsf:=Double(NegInfinity);
        epsx:=0.000001;
        if _spoil_scenario=17 then
            epsx:=Double(NaN);
        if _spoil_scenario=18 then
            epsx:=Double(Infinity);
        if _spoil_scenario=19 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        minbccreate(x, state);
        minbcsetbc(state, bndl, bndu);
        minbcsetscale(state, s);
        minbcsetcond(state, epsg, epsf, epsx, maxits);

        //
        // Then we activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target function (C0 continuity violation)
        // * nonsmoothness of the target function (C1 continuity violation)
        // * erroneous analytic gradient, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION. DO NOT USE IT IN PRODUCTION CODE!!!!!!!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        minbcoptguardsmoothness(state);
        minbcoptguardgradient(state, 0.001);

        //
        // Optimize and evaluate results
        //
        minbcoptimize(state, function1_grad, nil, nil);
        minbcresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-1,1]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the gradient - say, add
        //       1.0 to some of its components.
        //
        minbcoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minbc_numdiff(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    state: Tminbcstate;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    maxits: TALGLIBInteger;
    diffstep: Double;
    rep: Tminbcreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // subject to box constraints
        //
        //    -1<=x<=+1, -1<=y<=+1
        //
        // using MinBC optimizer with:
        // * numerical differentiation being used
        // * initial point x=[0,0]
        // * unit scale being set for all variables (see minbcsetscale for more info)
        // * stopping criteria set to "terminate after short enough step"
        // * OptGuard integrity check being used to check problem statement
        //   for some common errors like nonsmoothness or bad analytic gradient
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=6 then
            spoil_vector_by_deleting_element(s);
        bndl:=Str2Vector('[-1,-1]');
        if _spoil_scenario=7 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[+1,+1]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_deleting_element(bndu);
        epsg:=0;
        if _spoil_scenario=11 then
            epsg:=Double(NaN);
        if _spoil_scenario=12 then
            epsg:=Double(Infinity);
        if _spoil_scenario=13 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=14 then
            epsf:=Double(NaN);
        if _spoil_scenario=15 then
            epsf:=Double(Infinity);
        if _spoil_scenario=16 then
            epsf:=Double(NegInfinity);
        epsx:=0.000001;
        if _spoil_scenario=17 then
            epsx:=Double(NaN);
        if _spoil_scenario=18 then
            epsx:=Double(Infinity);
        if _spoil_scenario=19 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        diffstep:=1.0e-6;
        if _spoil_scenario=20 then
            diffstep:=Double(NaN);
        if _spoil_scenario=21 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=22 then
            diffstep:=Double(NegInfinity);

        //
        // Now we are ready to actually optimize something:
        // * first we create optimizer
        // * we add boundary constraints
        // * we tune stopping conditions
        // * and, finally, optimize and obtain results...
        //
        minbccreatef(x, diffstep, state);
        minbcsetbc(state, bndl, bndu);
        minbcsetscale(state, s);
        minbcsetcond(state, epsg, epsf, epsx, maxits);

        //
        // Then we activate OptGuard integrity checking.
        //
        // Numerical differentiation always produces "correct" gradient
        // (with some truncation error, but unbiased). Thus, we just have
        // to check smoothness properties of the target: C0 and C1 continuity.
        //
        // Sometimes user accidentally tries to solve nonsmooth problems
        // with smooth optimizer. OptGuard helps to detect such situations
        // early, at the prototyping stage.
        //
        minbcoptguardsmoothness(state);

        //
        // Optimize and evaluate results
        //
        minbcoptimize(state, function1_func, nil, nil);
        minbcresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-1,1]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // Want to challenge OptGuard? Try to make your problem
        // nonsmooth by replacing 100*(x+3)^4 by 100*|x+3| and
        // re-run optimizer.
        //
        minbcoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minns_d_unconstrained(_spoil_scenario: Integer):Boolean;
var
    x0: TVector;
    s: TVector;
    epsx: Double;
    radius: Double;
    rho: Double;
    maxits: TALGLIBInteger;
    state: Tminnsstate;
    rep: Tminnsreport;
    x1: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x0,x1) = 2*|x0|+|x1|
        //
        // using nonsmooth nonlinear optimizer.
        //
        x0:=Str2Vector('[1,1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.00001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        radius:=0.1;
        if _spoil_scenario=9 then
            radius:=Double(NaN);
        if _spoil_scenario=10 then
            radius:=Double(Infinity);
        if _spoil_scenario=11 then
            radius:=Double(NegInfinity);
        rho:=0.0;
        if _spoil_scenario=12 then
            rho:=Double(NaN);
        if _spoil_scenario=13 then
            rho:=Double(Infinity);
        if _spoil_scenario=14 then
            rho:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer object, choose AGS algorithm and tune its settings:
        // * radius=0.1     good initial value; will be automatically decreased later.
        // * rho=0.0        penalty coefficient for nonlinear constraints; can be zero
        //                  because we do not have such constraints
        // * epsx=0.000001  stopping conditions
        // * s=[1,1]        all variables have unit scale
        //
        minnscreate(2, x0, state);
        minnssetalgoags(state, radius, rho);
        minnssetcond(state, epsx, maxits);
        minnssetscale(state, s);

        //
        // Optimize and test results.
        //
        // Optimizer object accepts vector function and its Jacobian, with first
        // component (Jacobian row) being target function, and next components
        // (Jacobian rows) being nonlinear equality and inequality constraints
        // (box/linear ones are passed separately by means of minnssetbc() and
        // minnssetlc() calls).
        //
        // If you do not have nonlinear constraints (exactly our situation), then
        // you will have one-component function vector and 1xN Jacobian matrix.
        //
        // So, our vector function has form
        //
        //     {f0} = { 2*|x0|+|x1| }
        //
        // with Jacobian
        //
        //         [                       ]
        //     J = [ 2*sign(x0)   sign(x1) ]
        //         [                       ]
        //
        // NOTE: nonsmooth optimizer requires considerably more function
        //       evaluations than smooth solver - about 2N times more. Using
        //       numerical differentiation introduces additional (multiplicative)
        //       2N speedup.
        //
        //       It means that if smooth optimizer WITH user-supplied gradient
        //       needs 100 function evaluations to solve 50-dimensional problem,
        //       then AGS solver with user-supplied gradient will need about 10.000
        //       function evaluations, and with numerical gradient about 1.000.000
        //       function evaluations will be performed.
        //
        // NOTE: AGS solver used by us can handle nonsmooth and nonconvex
        //       optimization problems. It has convergence guarantees, i.e. it will
        //       converge to stationary point of the function after running for some
        //       time.
        //
        //       However, it is important to remember that "stationary point" is not
        //       equal to "solution". If your problem is convex, everything is OK.
        //       But nonconvex optimization problems may have "flat spots" - large
        //       areas where gradient is exactly zero, but function value is far away
        //       from optimal. Such areas are stationary points too, and optimizer
        //       may be trapped here.
        //
        //       "Flat spots" are nonsmooth equivalent of the saddle points, but with
        //       orders of magnitude worse properties - they may be quite large and
        //       hard to avoid. All nonsmooth optimizers are prone to this kind of the
        //       problem, because it is impossible to automatically distinguish "flat
        //       spot" from true solution.
        //
        //       This note is here to warn you that you should be very careful when
        //       you solve nonsmooth optimization problems. Visual inspection of
        //       results is essential.
        //
        minnsoptimize(state, nsfunc1_jac, nil, nil);
        minnsresults(state, x1, rep);
        Result:=Result and doc_test_real_vector(x1, Str2Vector('[0.0000,0.0000]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minns_d_diff(_spoil_scenario: Integer):Boolean;
var
    x0: TVector;
    s: TVector;
    epsx: Double;
    diffstep: Double;
    radius: Double;
    rho: Double;
    maxits: TALGLIBInteger;
    state: Tminnsstate;
    rep: Tminnsreport;
    x1: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x0,x1) = 2*|x0|+|x1|
        //
        // using nonsmooth nonlinear optimizer with numerical
        // differentiation provided by ALGLIB.
        //
        // NOTE: nonsmooth optimizer requires considerably more function
        //       evaluations than smooth solver - about 2N times more. Using
        //       numerical differentiation introduces additional (multiplicative)
        //       2N speedup.
        //
        //       It means that if smooth optimizer WITH user-supplied gradient
        //       needs 100 function evaluations to solve 50-dimensional problem,
        //       then AGS solver with user-supplied gradient will need about 10.000
        //       function evaluations, and with numerical gradient about 1.000.000
        //       function evaluations will be performed.
        //
        x0:=Str2Vector('[1,1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.00001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        diffstep:=0.000001;
        if _spoil_scenario=9 then
            diffstep:=Double(NaN);
        if _spoil_scenario=10 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=11 then
            diffstep:=Double(NegInfinity);
        radius:=0.1;
        if _spoil_scenario=12 then
            radius:=Double(NaN);
        if _spoil_scenario=13 then
            radius:=Double(Infinity);
        if _spoil_scenario=14 then
            radius:=Double(NegInfinity);
        rho:=0.0;
        if _spoil_scenario=15 then
            rho:=Double(NaN);
        if _spoil_scenario=16 then
            rho:=Double(Infinity);
        if _spoil_scenario=17 then
            rho:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer object, choose AGS algorithm and tune its settings:
        // * radius=0.1     good initial value; will be automatically decreased later.
        // * rho=0.0        penalty coefficient for nonlinear constraints; can be zero
        //                  because we do not have such constraints
        // * epsx=0.000001  stopping conditions
        // * s=[1,1]        all variables have unit scale
        //
        minnscreatef(2, x0, diffstep, state);
        minnssetalgoags(state, radius, rho);
        minnssetcond(state, epsx, maxits);
        minnssetscale(state, s);

        //
        // Optimize and test results.
        //
        // Optimizer object accepts vector function, with first component
        // being target function, and next components being nonlinear equality
        // and inequality constraints (box/linear ones are passed separately
        // by means of minnssetbc() and minnssetlc() calls).
        //
        // If you do not have nonlinear constraints (exactly our situation), then
        // you will have one-component function vector.
        //
        // So, our vector function has form
        //
        //     {f0} = { 2*|x0|+|x1| }
        //
        minnsoptimize(state, nsfunc1_fvec, nil, nil);
        minnsresults(state, x1, rep);
        Result:=Result and doc_test_real_vector(x1, Str2Vector('[0.0000,0.0000]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minns_d_bc(_spoil_scenario: Integer):Boolean;
var
    x0: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    epsx: Double;
    radius: Double;
    rho: Double;
    maxits: TALGLIBInteger;
    state: Tminnsstate;
    rep: Tminnsreport;
    x1: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x0,x1) = 2*|x0|+|x1|
        //
        // subject to box constraints
        //
        //        1 <= x0 < +INF
        //     -INF <= x1 < +INF
        //
        // using nonsmooth nonlinear optimizer.
        //
        x0:=Str2Vector('[1,1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        bndl:=Str2Vector('[1,-inf]');
        if _spoil_scenario=6 then
            spoil_vector_by_value(bndl, Double(NaN));
        bndu:=Str2Vector('[+inf,+inf]');
        if _spoil_scenario=7 then
            spoil_vector_by_value(bndu, Double(NaN));
        epsx:=0.00001;
        if _spoil_scenario=8 then
            epsx:=Double(NaN);
        if _spoil_scenario=9 then
            epsx:=Double(Infinity);
        if _spoil_scenario=10 then
            epsx:=Double(NegInfinity);
        radius:=0.1;
        if _spoil_scenario=11 then
            radius:=Double(NaN);
        if _spoil_scenario=12 then
            radius:=Double(Infinity);
        if _spoil_scenario=13 then
            radius:=Double(NegInfinity);
        rho:=0.0;
        if _spoil_scenario=14 then
            rho:=Double(NaN);
        if _spoil_scenario=15 then
            rho:=Double(Infinity);
        if _spoil_scenario=16 then
            rho:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer object, choose AGS algorithm and tune its settings:
        // * radius=0.1     good initial value; will be automatically decreased later.
        // * rho=0.0        penalty coefficient for nonlinear constraints; can be zero
        //                  because we do not have such constraints
        // * epsx=0.000001  stopping conditions
        // * s=[1,1]        all variables have unit scale
        //
        minnscreate(2, x0, state);
        minnssetalgoags(state, radius, rho);
        minnssetcond(state, epsx, maxits);
        minnssetscale(state, s);

        //
        // Set box constraints.
        //
        // General linear constraints are set in similar way (see comments on
        // minnssetlc() function for more information).
        //
        // You may combine box, linear and nonlinear constraints in one optimization
        // problem.
        //
        minnssetbc(state, bndl, bndu);

        //
        // Optimize and test results.
        //
        // Optimizer object accepts vector function and its Jacobian, with first
        // component (Jacobian row) being target function, and next components
        // (Jacobian rows) being nonlinear equality and inequality constraints
        // (box/linear ones are passed separately by means of minnssetbc() and
        // minnssetlc() calls).
        //
        // If you do not have nonlinear constraints (exactly our situation), then
        // you will have one-component function vector and 1xN Jacobian matrix.
        //
        // So, our vector function has form
        //
        //     {f0} = { 2*|x0|+|x1| }
        //
        // with Jacobian
        //
        //         [                       ]
        //     J = [ 2*sign(x0)   sign(x1) ]
        //         [                       ]
        //
        // NOTE: nonsmooth optimizer requires considerably more function
        //       evaluations than smooth solver - about 2N times more. Using
        //       numerical differentiation introduces additional (multiplicative)
        //       2N speedup.
        //
        //       It means that if smooth optimizer WITH user-supplied gradient
        //       needs 100 function evaluations to solve 50-dimensional problem,
        //       then AGS solver with user-supplied gradient will need about 10.000
        //       function evaluations, and with numerical gradient about 1.000.000
        //       function evaluations will be performed.
        //
        // NOTE: AGS solver used by us can handle nonsmooth and nonconvex
        //       optimization problems. It has convergence guarantees, i.e. it will
        //       converge to stationary point of the function after running for some
        //       time.
        //
        //       However, it is important to remember that "stationary point" is not
        //       equal to "solution". If your problem is convex, everything is OK.
        //       But nonconvex optimization problems may have "flat spots" - large
        //       areas where gradient is exactly zero, but function value is far away
        //       from optimal. Such areas are stationary points too, and optimizer
        //       may be trapped here.
        //
        //       "Flat spots" are nonsmooth equivalent of the saddle points, but with
        //       orders of magnitude worse properties - they may be quite large and
        //       hard to avoid. All nonsmooth optimizers are prone to this kind of the
        //       problem, because it is impossible to automatically distinguish "flat
        //       spot" from true solution.
        //
        //       This note is here to warn you that you should be very careful when
        //       you solve nonsmooth optimization problems. Visual inspection of
        //       results is essential.
        //
        //
        minnsoptimize(state, nsfunc1_jac, nil, nil);
        minnsresults(state, x1, rep);
        Result:=Result and doc_test_real_vector(x1, Str2Vector('[1.0000,0.0000]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minns_d_nlc(_spoil_scenario: Integer):Boolean;
var
    x0: TVector;
    s: TVector;
    epsx: Double;
    radius: Double;
    rho: Double;
    maxits: TALGLIBInteger;
    state: Tminnsstate;
    rep: Tminnsreport;
    x1: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x0,x1) = 2*|x0|+|x1|
        //
        // subject to combination of equality and inequality constraints
        //
        //      x0  =  1
        //      x1 >= -1
        //
        // using nonsmooth nonlinear optimizer. Although these constraints
        // are linear, we treat them as general nonlinear ones in order to
        // demonstrate nonlinearly constrained optimization setup.
        //
        x0:=Str2Vector('[1,1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.00001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        radius:=0.1;
        if _spoil_scenario=9 then
            radius:=Double(NaN);
        if _spoil_scenario=10 then
            radius:=Double(Infinity);
        if _spoil_scenario=11 then
            radius:=Double(NegInfinity);
        rho:=50.0;
        if _spoil_scenario=12 then
            rho:=Double(NaN);
        if _spoil_scenario=13 then
            rho:=Double(Infinity);
        if _spoil_scenario=14 then
            rho:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer object, choose AGS algorithm and tune its settings:
        // * radius=0.1     good initial value; will be automatically decreased later.
        // * rho=50.0       penalty coefficient for nonlinear constraints. It is your
        //                  responsibility to choose good one - large enough that it
        //                  enforces constraints, but small enough in order to avoid
        //                  extreme slowdown due to ill-conditioning.
        // * epsx=0.000001  stopping conditions
        // * s=[1,1]        all variables have unit scale
        //
        minnscreate(2, x0, state);
        minnssetalgoags(state, radius, rho);
        minnssetcond(state, epsx, maxits);
        minnssetscale(state, s);

        //
        // Set general nonlinear constraints.
        //
        // This part is more tricky than working with box/linear constraints - you
        // can not "pack" general nonlinear function into double precision array.
        // That's why minnssetnlc() does not accept constraints itself - only
        // constraint COUNTS are passed: first parameter is number of equality
        // constraints, second one is number of inequality constraints.
        //
        // As for constraining functions - these functions are passed as part
        // of problem Jacobian (see below).
        //
        // NOTE: MinNS optimizer supports arbitrary combination of boundary, general
        //       linear and general nonlinear constraints. This example does not
        //       show how to work with general linear constraints, but you can
        //       easily find it in documentation on minnlcsetlc() function.
        //
        minnssetnlc(state, 1, 1);

        //
        // Optimize and test results.
        //
        // Optimizer object accepts vector function and its Jacobian, with first
        // component (Jacobian row) being target function, and next components
        // (Jacobian rows) being nonlinear equality and inequality constraints
        // (box/linear ones are passed separately by means of minnssetbc() and
        // minnssetlc() calls).
        //
        // Nonlinear equality constraints have form Gi(x)=0, inequality ones
        // have form Hi(x)<=0, so we may have to "normalize" constraints prior
        // to passing them to optimizer (right side is zero, constraints are
        // sorted, multiplied by -1 when needed).
        //
        // So, our vector function has form
        //
        //     {f0,f1,f2} = { 2*|x0|+|x1|,  x0-1, -x1-1 }
        //
        // with Jacobian
        //
        //         [ 2*sign(x0)   sign(x1) ]
        //     J = [     1           0     ]
        //         [     0          -1     ]
        //
        // which means that we have optimization problem
        //
        //     min{f0} subject to f1=0, f2<=0
        //
        // which is essentially same as
        //
        //     min { 2*|x0|+|x1| } subject to x0=1, x1>=-1
        //
        // NOTE: AGS solver used by us can handle nonsmooth and nonconvex
        //       optimization problems. It has convergence guarantees, i.e. it will
        //       converge to stationary point of the function after running for some
        //       time.
        //
        //       However, it is important to remember that "stationary point" is not
        //       equal to "solution". If your problem is convex, everything is OK.
        //       But nonconvex optimization problems may have "flat spots" - large
        //       areas where gradient is exactly zero, but function value is far away
        //       from optimal. Such areas are stationary points too, and optimizer
        //       may be trapped here.
        //
        //       "Flat spots" are nonsmooth equivalent of the saddle points, but with
        //       orders of magnitude worse properties - they may be quite large and
        //       hard to avoid. All nonsmooth optimizers are prone to this kind of the
        //       problem, because it is impossible to automatically distinguish "flat
        //       spot" from true solution.
        //
        //       This note is here to warn you that you should be very careful when
        //       you solve nonsmooth optimization problems. Visual inspection of
        //       results is essential.
        //
        minnsoptimize(state, nsfunc2_jac, nil, nil);
        minnsresults(state, x1, rep);
        Result:=Result and doc_test_real_vector(x1, Str2Vector('[1.0000,0.0000]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_mincg_d_1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tmincgstate;
    rep: Tmincgreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // using nonlinear conjugate gradient method with:
        // * initial point x=[0,0]
        // * unit scale being set for all variables (see mincgsetscale for more info)
        // * stopping criteria set to "terminate after short enough step"
        // * OptGuard integrity check being used to check problem statement
        //   for some common errors like nonsmoothness or bad analytic gradient
        //
        // First, we create optimizer object and tune its properties
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsg:=0;
        if _spoil_scenario=6 then
            epsg:=Double(NaN);
        if _spoil_scenario=7 then
            epsg:=Double(Infinity);
        if _spoil_scenario=8 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=9 then
            epsf:=Double(NaN);
        if _spoil_scenario=10 then
            epsf:=Double(Infinity);
        if _spoil_scenario=11 then
            epsf:=Double(NegInfinity);
        epsx:=0.0000000001;
        if _spoil_scenario=12 then
            epsx:=Double(NaN);
        if _spoil_scenario=13 then
            epsx:=Double(Infinity);
        if _spoil_scenario=14 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        mincgcreate(x, state);
        mincgsetcond(state, epsg, epsf, epsx, maxits);
        mincgsetscale(state, s);

        //
        // Activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to catch common coding and problem statement
        // issues, like:
        // * discontinuity of the target function (C0 continuity violation)
        // * nonsmoothness of the target function (C1 continuity violation)
        // * erroneous analytic gradient, i.e. one inconsistent with actual
        //   change in the target/constraints
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: GRADIENT VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION. DO NOT USE IT IN PRODUCTION CODE!!!!!!!
        //
        //            Other OptGuard checks add moderate overhead, but anyway
        //            it is better to turn them off when they are not needed.
        //
        mincgoptguardsmoothness(state);
        mincgoptguardgradient(state, 0.001);

        //
        // Optimize and evaluate results
        //
        mincgoptimize(state, function1_grad, nil, nil);
        mincgresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the gradient - say, add
        //       1.0 to some of its components.
        //
        mincgoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_mincg_d_2(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    stpmax: Double;
    maxits: TALGLIBInteger;
    state: Tmincgstate;
    rep: Tmincgreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of f(x,y) = 100*(x+3)^4+(y-3)^4
        // with nonlinear conjugate gradient method.
        //
        // Several advanced techniques are demonstrated:
        // * upper limit on step size
        // * restart from new point
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsg:=0;
        if _spoil_scenario=6 then
            epsg:=Double(NaN);
        if _spoil_scenario=7 then
            epsg:=Double(Infinity);
        if _spoil_scenario=8 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=9 then
            epsf:=Double(NaN);
        if _spoil_scenario=10 then
            epsf:=Double(Infinity);
        if _spoil_scenario=11 then
            epsf:=Double(NegInfinity);
        epsx:=0.0000000001;
        if _spoil_scenario=12 then
            epsx:=Double(NaN);
        if _spoil_scenario=13 then
            epsx:=Double(Infinity);
        if _spoil_scenario=14 then
            epsx:=Double(NegInfinity);
        stpmax:=0.1;
        if _spoil_scenario=15 then
            stpmax:=Double(NaN);
        if _spoil_scenario=16 then
            stpmax:=Double(Infinity);
        if _spoil_scenario=17 then
            stpmax:=Double(NegInfinity);
        maxits:=0;

        // create and tune optimizer
        mincgcreate(x, state);
        mincgsetscale(state, s);
        mincgsetcond(state, epsg, epsf, epsx, maxits);
        mincgsetstpmax(state, stpmax);

        // Set up OptGuard integrity checker which catches errors
        // like nonsmooth targets or errors in the analytic gradient.
        //
        // OptGuard is essential at the early prototyping stages.
        //
        // NOTE: gradient verification needs 3*N additional function
        //       evaluations; DO NOT USE IT IN THE PRODUCTION CODE
        //       because it leads to unnecessary slowdown of your app.
        mincgoptguardsmoothness(state);
        mincgoptguardgradient(state, 0.001);

        // first run
        mincgoptimize(state, function1_grad, nil, nil);
        mincgresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

        // second run - algorithm is restarted with mincgrestartfrom()
        x:=Str2Vector('[10,10]');
        if _spoil_scenario=18 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=19 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=20 then
            spoil_vector_by_value(x, Double(NegInfinity));
        mincgrestartfrom(state, x);
        mincgoptimize(state, function1_grad, nil, nil);
        mincgresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

        // check OptGuard integrity report. Why do we need it at all?
        // Well, try breaking the gradient by adding 1.0 to some
        // of its components - OptGuard should report it as error.
        // And it may also catch unintended errors too :)
        mincgoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_mincg_numdiff(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    epsg: Double;
    epsf: Double;
    epsx: Double;
    diffstep: Double;
    maxits: TALGLIBInteger;
    state: Tmincgstate;
    rep: Tmincgreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of
        //
        //     f(x,y) = 100*(x+3)^4+(y-3)^4
        //
        // using numerical differentiation to calculate gradient.
        //
        // We also show how to use OptGuard integrity checker to catch common
        // problem statement errors like accidentally specifying nonsmooth target
        // function.
        //
        // First, we set up optimizer...
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsg:=0;
        if _spoil_scenario=6 then
            epsg:=Double(NaN);
        if _spoil_scenario=7 then
            epsg:=Double(Infinity);
        if _spoil_scenario=8 then
            epsg:=Double(NegInfinity);
        epsf:=0;
        if _spoil_scenario=9 then
            epsf:=Double(NaN);
        if _spoil_scenario=10 then
            epsf:=Double(Infinity);
        if _spoil_scenario=11 then
            epsf:=Double(NegInfinity);
        epsx:=0.0000000001;
        if _spoil_scenario=12 then
            epsx:=Double(NaN);
        if _spoil_scenario=13 then
            epsx:=Double(Infinity);
        if _spoil_scenario=14 then
            epsx:=Double(NegInfinity);
        diffstep:=1.0e-6;
        if _spoil_scenario=15 then
            diffstep:=Double(NaN);
        if _spoil_scenario=16 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=17 then
            diffstep:=Double(NegInfinity);
        maxits:=0;
        mincgcreatef(x, diffstep, state);
        mincgsetcond(state, epsg, epsf, epsx, maxits);
        mincgsetscale(state, s);

        //
        // Then, we activate OptGuard integrity checking.
        //
        // Numerical differentiation always produces "correct" gradient
        // (with some truncation error, but unbiased). Thus, we just have
        // to check smoothness properties of the target: C0 and C1 continuity.
        //
        // Sometimes user accidentally tried to solve nonsmooth problems
        // with smooth optimizer. OptGuard helps to detect such situations
        // early, at the prototyping stage.
        //
        mincgoptguardsmoothness(state);

        //
        // Now we are ready to run the optimization
        //
        mincgoptimize(state, function1_func, nil, nil);
        mincgresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,3]'), 0.005);

        //
        // ...and to check OptGuard integrity report.
        //
        // Want to challenge OptGuard? Try to make your problem
        // nonsmooth by replacing 100*(x+3)^4 by 100*|x+3| and
        // re-run optimizer.
        //
        mincgoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.nonc0suspected, false);
        Result:=Result and doc_test_bool(ogrep.nonc1suspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlm_d_v(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlmstate;
    rep: Tminlmreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = f0^2+f1^2, where 
        //
        //     f0(x0,x1) = 10*(x0+3)^2
        //     f1(x0,x1) = (x1-3)^2
        //
        // using "V" mode of the Levenberg-Marquardt optimizer.
        //
        // Optimization algorithm uses:
        // * function vector f[] = {f1,f2}
        //
        // No other information (Jacobian, gradient, etc.) is needed.
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.0000000001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer, tell it to:
        // * use numerical differentiation with step equal to 0.0001
        // * use unit scale for all variables (s is a unit vector)
        // * stop after short enough step (less than epsx)
        //
        minlmcreatev(2, x, 0.0001, state);
        minlmsetcond(state, epsx, maxits);
        minlmsetscale(state, s);

        //
        // Optimize
        //
        minlmoptimize(state, function1_fvec, nil, nil);

        //
        // Test optimization results
        //
        // NOTE: because we use numerical differentiation, we do not
        //       verify Jacobian correctness - it is always "correct".
        //       However, if you switch to analytic gradient, consider
        //       checking it with OptGuard (see other examples).
        //
        minlmresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,+3]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlm_d_vj(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlmstate;
    rep: Tminlmreport;
    ogrep: Toptguardreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = f0^2+f1^2, where 
        //
        //     f0(x0,x1) = 10*(x0+3)^2
        //     f1(x0,x1) = (x1-3)^2
        //
        // using "VJ" mode of the Levenberg-Marquardt optimizer.
        //
        // Optimization algorithm uses:
        // * function vector f[] = {f1,f2}
        // * Jacobian matrix J = {dfi/dxj}.
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        epsx:=0.0000000001;
        if _spoil_scenario=6 then
            epsx:=Double(NaN);
        if _spoil_scenario=7 then
            epsx:=Double(Infinity);
        if _spoil_scenario=8 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer, tell it to:
        // * use analytic gradient provided by user
        // * use unit scale for all variables (s is a unit vector)
        // * stop after short enough step (less than epsx)
        //
        minlmcreatevj(2, x, state);
        minlmsetcond(state, epsx, maxits);
        minlmsetscale(state, s);

        //
        // Activate OptGuard integrity checking.
        //
        // OptGuard monitor helps to detect erroneous analytic Jacobian,
        // i.e. one inconsistent with actual change in the target function.
        //
        // OptGuard is essential for early prototyping stages because such
        // problems often result in premature termination of the optimizer
        // which is really hard to distinguish from the correct termination.
        //
        // IMPORTANT: JACOBIAN VERIFICATION IS PERFORMED BY MEANS OF NUMERICAL
        //            DIFFERENTIATION, THUS DO NOT USE IT IN PRODUCTION CODE!
        //
        minlmoptguardgradient(state, 0.001);

        //
        // Optimize
        //
        minlmoptimize(state, function1_fvec, function1_jac, nil, nil);

        //
        // Test optimization results
        //
        minlmresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,+3]'), 0.005);

        //
        // Check that OptGuard did not report errors
        //
        // NOTE: want to test OptGuard? Try breaking the Jacobian - say, add
        //       1.0 to some of its components.
        //
        // NOTE: unfortunately, specifics of LM optimization do not allow us
        //       to detect errors like nonsmoothness (like we do with other
        //       optimizers). So, only Jacobian correctness is verified.
        //
        minlmoptguardresults(state, ogrep);
        Result:=Result and doc_test_bool(ogrep.badgradsuspected, false);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlm_d_fgh(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlmstate;
    rep: Tminlmreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = 100*(x0+3)^4+(x1-3)^4
        // using "FGH" mode of the Levenberg-Marquardt optimizer.
        //
        // F is treated like a monolitic function without internal structure,
        // i.e. we do NOT represent it as a sum of squares.
        //
        // Optimization algorithm uses:
        // * function value F(x0,x1)
        // * gradient G={dF/dxi}
        // * Hessian H={d2F/(dxi*dxj)}
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        epsx:=0.0000000001;
        if _spoil_scenario=3 then
            epsx:=Double(NaN);
        if _spoil_scenario=4 then
            epsx:=Double(Infinity);
        if _spoil_scenario=5 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        minlmcreatefgh(x, state);
        minlmsetcond(state, epsx, maxits);
        minlmoptimize(state, function1_func, function1_grad, function1_hess, nil, nil);
        minlmresults(state, x, rep);

        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,+3]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlm_d_vb(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    s: TVector;
    bndl: TVector;
    bndu: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlmstate;
    rep: Tminlmreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = f0^2+f1^2, where 
        //
        //     f0(x0,x1) = 10*(x0+3)^2
        //     f1(x0,x1) = (x1-3)^2
        //
        // with boundary constraints
        //
        //     -1 <= x0 <= +1
        //     -1 <= x1 <= +1
        //
        // using "V" mode of the Levenberg-Marquardt optimizer.
        //
        // Optimization algorithm uses:
        // * function vector f[] = {f1,f2}
        //
        // No other information (Jacobian, gradient, etc.) is needed.
        //
        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        s:=Str2Vector('[1,1]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(s, Double(NegInfinity));
        bndl:=Str2Vector('[-1,-1]');
        if _spoil_scenario=6 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[+1,+1]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(bndu);
        epsx:=0.0000000001;
        if _spoil_scenario=10 then
            epsx:=Double(NaN);
        if _spoil_scenario=11 then
            epsx:=Double(Infinity);
        if _spoil_scenario=12 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // Create optimizer, tell it to:
        // * use numerical differentiation with step equal to 1.0
        // * use unit scale for all variables (s is a unit vector)
        // * stop after short enough step (less than epsx)
        // * set box constraints
        //
        minlmcreatev(2, x, 0.0001, state);
        minlmsetbc(state, bndl, bndu);
        minlmsetcond(state, epsx, maxits);
        minlmsetscale(state, s);

        //
        // Optimize
        //
        minlmoptimize(state, function1_fvec, nil, nil);

        //
        // Test optimization results
        //
        // NOTE: because we use numerical differentiation, we do not
        //       verify Jacobian correctness - it is always "correct".
        //       However, if you switch to analytic gradient, consider
        //       checking it with OptGuard (see other examples).
        //
        minlmresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-1,+1]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlm_d_restarts(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlmstate;
    rep: Tminlmreport;

begin
    Result:=True;
    try
        state:=nil;

        //
        // This example demonstrates minimization of F(x0,x1) = f0^2+f1^2, where 
        //
        //     f0(x0,x1) = 10*(x0+3)^2
        //     f1(x0,x1) = (x1-3)^2
        //
        // using several starting points and efficient restarts.
        //
        epsx:=0.0000000001;
        if _spoil_scenario=0 then
            epsx:=Double(NaN);
        if _spoil_scenario=1 then
            epsx:=Double(Infinity);
        if _spoil_scenario=2 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // create optimizer using minlmcreatev()
        //
        x:=Str2Vector('[10,10]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(x, Double(NegInfinity));
        minlmcreatev(2, x, 0.0001, state);
        minlmsetcond(state, epsx, maxits);
        minlmoptimize(state, function1_fvec, nil, nil);
        minlmresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,+3]'), 0.005);

        //
        // restart optimizer using minlmrestartfrom()
        //
        // we can use different starting point, different function,
        // different stopping conditions, but problem size
        // must remain unchanged.
        //
        x:=Str2Vector('[4,4]');
        if _spoil_scenario=6 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=7 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=8 then
            spoil_vector_by_value(x, Double(NegInfinity));
        minlmrestartfrom(state, x);
        minlmoptimize(state, function2_fvec, nil, nil);
        minlmresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[0,1]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlm_t_1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlmstate;
    rep: Tminlmreport;

begin
    Result:=True;
    try
        state:=nil;

        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        epsx:=0.0000000001;
        if _spoil_scenario=3 then
            epsx:=Double(NaN);
        if _spoil_scenario=4 then
            epsx:=Double(Infinity);
        if _spoil_scenario=5 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        minlmcreatefj(2, x, state);
        minlmsetcond(state, epsx, maxits);
        minlmoptimize(state, function1_func, function1_jac, nil, nil);
        minlmresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,+3]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_minlm_t_2(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    state: Tminlmstate;
    rep: Tminlmreport;

begin
    Result:=True;
    try
        state:=nil;

        x:=Str2Vector('[0,0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        epsx:=0.0000000001;
        if _spoil_scenario=3 then
            epsx:=Double(NaN);
        if _spoil_scenario=4 then
            epsx:=Double(Infinity);
        if _spoil_scenario=5 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        minlmcreatefgj(2, x, state);
        minlmsetcond(state, epsx, maxits);
        minlmoptimize(state, function1_func, function1_grad, function1_jac, nil, nil);
        minlmresults(state, x, rep);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[-3,+3]'), 0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_basestat_d_base(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    mean: Double;
    variance: Double;
    skewness: Double;
    kurtosis: Double;
    adev: Double;
    p: Double;
    v: Double;

begin
    Result:=True;
    try

        x:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));

        //
        // Here we demonstrate calculation of sample moments
        // (mean, variance, skewness, kurtosis)
        //
        samplemoments(x, mean, variance, skewness, kurtosis);
        Result:=Result and doc_test_real(mean, 28.5, 0.01);
        Result:=Result and doc_test_real(variance, 801.1667, 0.01);
        Result:=Result and doc_test_real(skewness, 0.5751, 0.01);
        Result:=Result and doc_test_real(kurtosis, -1.2666, 0.01);

        //
        // Average deviation
        //
        sampleadev(x, adev);
        Result:=Result and doc_test_real(adev, 23.2, 0.01);

        //
        // Median and percentile
        //
        samplemedian(x, v);
        Result:=Result and doc_test_real(v, 20.5, 0.01);
        p:=0.5;
        if _spoil_scenario=3 then
            p:=Double(NaN);
        if _spoil_scenario=4 then
            p:=Double(Infinity);
        if _spoil_scenario=5 then
            p:=Double(NegInfinity);
        samplepercentile(x, p, v);
        Result:=Result and doc_test_real(v, 20.5, 0.01);

    finally

    end;
end;


function _test_basestat_d_c2(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    v: Double;

begin
    Result:=True;
    try

        //
        // We have two samples - x and y, and want to measure dependency between them
        //
        x:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0,1,2,3,4,5,6,7,8,9]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);

        //
        // Three dependency measures are calculated:
        // * covariation
        // * Pearson correlation
        // * Spearman rank correlation
        //
        v:=cov2(x, y);
        Result:=Result and doc_test_real(v, 82.5, 0.001);
        v:=pearsoncorr2(x, y);
        Result:=Result and doc_test_real(v, 0.9627, 0.001);
        v:=spearmancorr2(x, y);
        Result:=Result and doc_test_real(v, 1.000, 0.001);

    finally

    end;
end;


function _test_basestat_d_cm(_spoil_scenario: Integer):Boolean;
var
    x: TMatrix;
    c: TMatrix;

begin
    Result:=True;
    try

        //
        // X is a sample matrix:
        // * I-th row corresponds to I-th observation
        // * J-th column corresponds to J-th variable
        //
        x:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));

        //
        // Three dependency measures are calculated:
        // * covariation
        // * Pearson correlation
        // * Spearman rank correlation
        //
        // Result is stored into C, with C[i,j] equal to correlation
        // (covariance) between I-th and J-th variables of X.
        //
        covm(x, c);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[1.80,0.60,-1.40],[0.60,0.70,-0.80],[-1.40,-0.80,14.70]]'), 0.01);
        pearsoncorrm(x, c);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[1.000,0.535,-0.272],[0.535,1.000,-0.249],[-0.272,-0.249,1.000]]'), 0.01);
        spearmancorrm(x, c);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[1.000,0.556,-0.306],[0.556,1.000,-0.750],[-0.306,-0.750,1.000]]'), 0.01);

    finally

    end;
end;


function _test_basestat_d_cm2(_spoil_scenario: Integer):Boolean;
var
    x: TMatrix;
    y: TMatrix;
    c: TMatrix;

begin
    Result:=True;
    try

        //
        // X and Y are sample matrices:
        // * I-th row corresponds to I-th observation
        // * J-th column corresponds to J-th variable
        //
        x:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));
        y:=Str2Matrix('[[2,3],[2,1],[-1,6],[-9,9],[7,1]]');
        if _spoil_scenario=3 then
            spoil_matrix_by_value(y, Double(NaN));
        if _spoil_scenario=4 then
            spoil_matrix_by_value(y, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_matrix_by_value(y, Double(NegInfinity));

        //
        // Three dependency measures are calculated:
        // * covariation
        // * Pearson correlation
        // * Spearman rank correlation
        //
        // Result is stored into C, with C[i,j] equal to correlation
        // (covariance) between I-th variable of X and J-th variable of Y.
        //
        covm2(x, y, c);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[4.100,-3.250],[2.450,-1.500],[13.450,-5.750]]'), 0.01);
        pearsoncorrm2(x, y, c);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[0.519,-0.699],[0.497,-0.518],[0.596,-0.433]]'), 0.01);
        spearmancorrm2(x, y, c);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[0.541,-0.649],[0.216,-0.433],[0.433,-0.135]]'), 0.01);

    finally

    end;
end;


function _test_basestat_t_base(_spoil_scenario: Integer):Boolean;
var
    mean: Double;
    variance: Double;
    skewness: Double;
    kurtosis: Double;
    adev: Double;
    p: Double;
    v: Double;
    x1: TVector;
    x2: TVector;
    x3: TVector;
    x4: TVector;
    x5: TVector;
    x6: TVector;
    x7: TVector;
    x8: TVector;

begin
    Result:=True;
    try


        //
        // first, we test short form of functions
        //
        x1:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x1, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x1, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x1, Double(NegInfinity));
        samplemoments(x1, mean, variance, skewness, kurtosis);
        x2:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(x2, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(x2, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(x2, Double(NegInfinity));
        sampleadev(x2, adev);
        x3:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=6 then
            spoil_vector_by_value(x3, Double(NaN));
        if _spoil_scenario=7 then
            spoil_vector_by_value(x3, Double(Infinity));
        if _spoil_scenario=8 then
            spoil_vector_by_value(x3, Double(NegInfinity));
        samplemedian(x3, v);
        x4:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=9 then
            spoil_vector_by_value(x4, Double(NaN));
        if _spoil_scenario=10 then
            spoil_vector_by_value(x4, Double(Infinity));
        if _spoil_scenario=11 then
            spoil_vector_by_value(x4, Double(NegInfinity));
        p:=0.5;
        if _spoil_scenario=12 then
            p:=Double(NaN);
        if _spoil_scenario=13 then
            p:=Double(Infinity);
        if _spoil_scenario=14 then
            p:=Double(NegInfinity);
        samplepercentile(x4, p, v);

        //
        // and then we test full form
        //
        x5:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=15 then
            spoil_vector_by_value(x5, Double(NaN));
        if _spoil_scenario=16 then
            spoil_vector_by_value(x5, Double(Infinity));
        if _spoil_scenario=17 then
            spoil_vector_by_value(x5, Double(NegInfinity));
        if _spoil_scenario=18 then
            spoil_vector_by_deleting_element(x5);
        samplemoments(x5, 10, mean, variance, skewness, kurtosis);
        x6:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=19 then
            spoil_vector_by_value(x6, Double(NaN));
        if _spoil_scenario=20 then
            spoil_vector_by_value(x6, Double(Infinity));
        if _spoil_scenario=21 then
            spoil_vector_by_value(x6, Double(NegInfinity));
        if _spoil_scenario=22 then
            spoil_vector_by_deleting_element(x6);
        sampleadev(x6, 10, adev);
        x7:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=23 then
            spoil_vector_by_value(x7, Double(NaN));
        if _spoil_scenario=24 then
            spoil_vector_by_value(x7, Double(Infinity));
        if _spoil_scenario=25 then
            spoil_vector_by_value(x7, Double(NegInfinity));
        if _spoil_scenario=26 then
            spoil_vector_by_deleting_element(x7);
        samplemedian(x7, 10, v);
        x8:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=27 then
            spoil_vector_by_value(x8, Double(NaN));
        if _spoil_scenario=28 then
            spoil_vector_by_value(x8, Double(Infinity));
        if _spoil_scenario=29 then
            spoil_vector_by_value(x8, Double(NegInfinity));
        if _spoil_scenario=30 then
            spoil_vector_by_deleting_element(x8);
        p:=0.5;
        if _spoil_scenario=31 then
            p:=Double(NaN);
        if _spoil_scenario=32 then
            p:=Double(Infinity);
        if _spoil_scenario=33 then
            p:=Double(NegInfinity);
        samplepercentile(x8, 10, p, v);

    finally

    end;
end;


function _test_basestat_t_covcorr(_spoil_scenario: Integer):Boolean;
var
    v: Double;
    c: TMatrix;
    x1: TVector;
    y1: TVector;
    x2: TVector;
    y2: TVector;
    x3: TVector;
    y3: TVector;
    x1a: TVector;
    y1a: TVector;
    x2a: TVector;
    y2a: TVector;
    x3a: TVector;
    y3a: TVector;
    x4: TMatrix;
    x5: TMatrix;
    x6: TMatrix;
    x7: TMatrix;
    x8: TMatrix;
    x9: TMatrix;
    x10: TMatrix;
    y10: TMatrix;
    x11: TMatrix;
    y11: TMatrix;
    x12: TMatrix;
    y12: TMatrix;
    x13: TMatrix;
    y13: TMatrix;
    x14: TMatrix;
    y14: TMatrix;
    x15: TMatrix;
    y15: TMatrix;

begin
    Result:=True;
    try


        //
        // 2-sample short-form cov/corr are tested
        //
        x1:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x1, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x1, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x1, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x1);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x1);
        y1:=Str2Vector('[0,1,2,3,4,5,6,7,8,9]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y1, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y1, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y1, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y1);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y1);
        v:=cov2(x1, y1);
        x2:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=10 then
            spoil_vector_by_value(x2, Double(NaN));
        if _spoil_scenario=11 then
            spoil_vector_by_value(x2, Double(Infinity));
        if _spoil_scenario=12 then
            spoil_vector_by_value(x2, Double(NegInfinity));
        if _spoil_scenario=13 then
            spoil_vector_by_adding_element(x2);
        if _spoil_scenario=14 then
            spoil_vector_by_deleting_element(x2);
        y2:=Str2Vector('[0,1,2,3,4,5,6,7,8,9]');
        if _spoil_scenario=15 then
            spoil_vector_by_value(y2, Double(NaN));
        if _spoil_scenario=16 then
            spoil_vector_by_value(y2, Double(Infinity));
        if _spoil_scenario=17 then
            spoil_vector_by_value(y2, Double(NegInfinity));
        if _spoil_scenario=18 then
            spoil_vector_by_adding_element(y2);
        if _spoil_scenario=19 then
            spoil_vector_by_deleting_element(y2);
        v:=pearsoncorr2(x2, y2);
        x3:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=20 then
            spoil_vector_by_value(x3, Double(NaN));
        if _spoil_scenario=21 then
            spoil_vector_by_value(x3, Double(Infinity));
        if _spoil_scenario=22 then
            spoil_vector_by_value(x3, Double(NegInfinity));
        if _spoil_scenario=23 then
            spoil_vector_by_adding_element(x3);
        if _spoil_scenario=24 then
            spoil_vector_by_deleting_element(x3);
        y3:=Str2Vector('[0,1,2,3,4,5,6,7,8,9]');
        if _spoil_scenario=25 then
            spoil_vector_by_value(y3, Double(NaN));
        if _spoil_scenario=26 then
            spoil_vector_by_value(y3, Double(Infinity));
        if _spoil_scenario=27 then
            spoil_vector_by_value(y3, Double(NegInfinity));
        if _spoil_scenario=28 then
            spoil_vector_by_adding_element(y3);
        if _spoil_scenario=29 then
            spoil_vector_by_deleting_element(y3);
        v:=spearmancorr2(x3, y3);

        //
        // 2-sample full-form cov/corr are tested
        //
        x1a:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=30 then
            spoil_vector_by_value(x1a, Double(NaN));
        if _spoil_scenario=31 then
            spoil_vector_by_value(x1a, Double(Infinity));
        if _spoil_scenario=32 then
            spoil_vector_by_value(x1a, Double(NegInfinity));
        if _spoil_scenario=33 then
            spoil_vector_by_deleting_element(x1a);
        y1a:=Str2Vector('[0,1,2,3,4,5,6,7,8,9]');
        if _spoil_scenario=34 then
            spoil_vector_by_value(y1a, Double(NaN));
        if _spoil_scenario=35 then
            spoil_vector_by_value(y1a, Double(Infinity));
        if _spoil_scenario=36 then
            spoil_vector_by_value(y1a, Double(NegInfinity));
        if _spoil_scenario=37 then
            spoil_vector_by_deleting_element(y1a);
        v:=cov2(x1a, y1a, 10);
        x2a:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=38 then
            spoil_vector_by_value(x2a, Double(NaN));
        if _spoil_scenario=39 then
            spoil_vector_by_value(x2a, Double(Infinity));
        if _spoil_scenario=40 then
            spoil_vector_by_value(x2a, Double(NegInfinity));
        if _spoil_scenario=41 then
            spoil_vector_by_deleting_element(x2a);
        y2a:=Str2Vector('[0,1,2,3,4,5,6,7,8,9]');
        if _spoil_scenario=42 then
            spoil_vector_by_value(y2a, Double(NaN));
        if _spoil_scenario=43 then
            spoil_vector_by_value(y2a, Double(Infinity));
        if _spoil_scenario=44 then
            spoil_vector_by_value(y2a, Double(NegInfinity));
        if _spoil_scenario=45 then
            spoil_vector_by_deleting_element(y2a);
        v:=pearsoncorr2(x2a, y2a, 10);
        x3a:=Str2Vector('[0,1,4,9,16,25,36,49,64,81]');
        if _spoil_scenario=46 then
            spoil_vector_by_value(x3a, Double(NaN));
        if _spoil_scenario=47 then
            spoil_vector_by_value(x3a, Double(Infinity));
        if _spoil_scenario=48 then
            spoil_vector_by_value(x3a, Double(NegInfinity));
        if _spoil_scenario=49 then
            spoil_vector_by_deleting_element(x3a);
        y3a:=Str2Vector('[0,1,2,3,4,5,6,7,8,9]');
        if _spoil_scenario=50 then
            spoil_vector_by_value(y3a, Double(NaN));
        if _spoil_scenario=51 then
            spoil_vector_by_value(y3a, Double(Infinity));
        if _spoil_scenario=52 then
            spoil_vector_by_value(y3a, Double(NegInfinity));
        if _spoil_scenario=53 then
            spoil_vector_by_deleting_element(y3a);
        v:=spearmancorr2(x3a, y3a, 10);

        //
        // vector short-form cov/corr are tested.
        //
        x4:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=54 then
            spoil_matrix_by_value(x4, Double(NaN));
        if _spoil_scenario=55 then
            spoil_matrix_by_value(x4, Double(Infinity));
        if _spoil_scenario=56 then
            spoil_matrix_by_value(x4, Double(NegInfinity));
        covm(x4, c);
        x5:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=57 then
            spoil_matrix_by_value(x5, Double(NaN));
        if _spoil_scenario=58 then
            spoil_matrix_by_value(x5, Double(Infinity));
        if _spoil_scenario=59 then
            spoil_matrix_by_value(x5, Double(NegInfinity));
        pearsoncorrm(x5, c);
        x6:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=60 then
            spoil_matrix_by_value(x6, Double(NaN));
        if _spoil_scenario=61 then
            spoil_matrix_by_value(x6, Double(Infinity));
        if _spoil_scenario=62 then
            spoil_matrix_by_value(x6, Double(NegInfinity));
        spearmancorrm(x6, c);

        //
        // vector full-form cov/corr are tested.
        //
        x7:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=63 then
            spoil_matrix_by_value(x7, Double(NaN));
        if _spoil_scenario=64 then
            spoil_matrix_by_value(x7, Double(Infinity));
        if _spoil_scenario=65 then
            spoil_matrix_by_value(x7, Double(NegInfinity));
        if _spoil_scenario=66 then
            spoil_matrix_by_deleting_row(x7);
        if _spoil_scenario=67 then
            spoil_matrix_by_deleting_col(x7);
        covm(x7, 5, 3, c);
        x8:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=68 then
            spoil_matrix_by_value(x8, Double(NaN));
        if _spoil_scenario=69 then
            spoil_matrix_by_value(x8, Double(Infinity));
        if _spoil_scenario=70 then
            spoil_matrix_by_value(x8, Double(NegInfinity));
        if _spoil_scenario=71 then
            spoil_matrix_by_deleting_row(x8);
        if _spoil_scenario=72 then
            spoil_matrix_by_deleting_col(x8);
        pearsoncorrm(x8, 5, 3, c);
        x9:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=73 then
            spoil_matrix_by_value(x9, Double(NaN));
        if _spoil_scenario=74 then
            spoil_matrix_by_value(x9, Double(Infinity));
        if _spoil_scenario=75 then
            spoil_matrix_by_value(x9, Double(NegInfinity));
        if _spoil_scenario=76 then
            spoil_matrix_by_deleting_row(x9);
        if _spoil_scenario=77 then
            spoil_matrix_by_deleting_col(x9);
        spearmancorrm(x9, 5, 3, c);

        //
        // cross-vector short-form cov/corr are tested.
        //
        x10:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=78 then
            spoil_matrix_by_value(x10, Double(NaN));
        if _spoil_scenario=79 then
            spoil_matrix_by_value(x10, Double(Infinity));
        if _spoil_scenario=80 then
            spoil_matrix_by_value(x10, Double(NegInfinity));
        y10:=Str2Matrix('[[2,3],[2,1],[-1,6],[-9,9],[7,1]]');
        if _spoil_scenario=81 then
            spoil_matrix_by_value(y10, Double(NaN));
        if _spoil_scenario=82 then
            spoil_matrix_by_value(y10, Double(Infinity));
        if _spoil_scenario=83 then
            spoil_matrix_by_value(y10, Double(NegInfinity));
        covm2(x10, y10, c);
        x11:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=84 then
            spoil_matrix_by_value(x11, Double(NaN));
        if _spoil_scenario=85 then
            spoil_matrix_by_value(x11, Double(Infinity));
        if _spoil_scenario=86 then
            spoil_matrix_by_value(x11, Double(NegInfinity));
        y11:=Str2Matrix('[[2,3],[2,1],[-1,6],[-9,9],[7,1]]');
        if _spoil_scenario=87 then
            spoil_matrix_by_value(y11, Double(NaN));
        if _spoil_scenario=88 then
            spoil_matrix_by_value(y11, Double(Infinity));
        if _spoil_scenario=89 then
            spoil_matrix_by_value(y11, Double(NegInfinity));
        pearsoncorrm2(x11, y11, c);
        x12:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=90 then
            spoil_matrix_by_value(x12, Double(NaN));
        if _spoil_scenario=91 then
            spoil_matrix_by_value(x12, Double(Infinity));
        if _spoil_scenario=92 then
            spoil_matrix_by_value(x12, Double(NegInfinity));
        y12:=Str2Matrix('[[2,3],[2,1],[-1,6],[-9,9],[7,1]]');
        if _spoil_scenario=93 then
            spoil_matrix_by_value(y12, Double(NaN));
        if _spoil_scenario=94 then
            spoil_matrix_by_value(y12, Double(Infinity));
        if _spoil_scenario=95 then
            spoil_matrix_by_value(y12, Double(NegInfinity));
        spearmancorrm2(x12, y12, c);

        //
        // cross-vector full-form cov/corr are tested.
        //
        x13:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=96 then
            spoil_matrix_by_value(x13, Double(NaN));
        if _spoil_scenario=97 then
            spoil_matrix_by_value(x13, Double(Infinity));
        if _spoil_scenario=98 then
            spoil_matrix_by_value(x13, Double(NegInfinity));
        if _spoil_scenario=99 then
            spoil_matrix_by_deleting_row(x13);
        if _spoil_scenario=100 then
            spoil_matrix_by_deleting_col(x13);
        y13:=Str2Matrix('[[2,3],[2,1],[-1,6],[-9,9],[7,1]]');
        if _spoil_scenario=101 then
            spoil_matrix_by_value(y13, Double(NaN));
        if _spoil_scenario=102 then
            spoil_matrix_by_value(y13, Double(Infinity));
        if _spoil_scenario=103 then
            spoil_matrix_by_value(y13, Double(NegInfinity));
        if _spoil_scenario=104 then
            spoil_matrix_by_deleting_row(y13);
        if _spoil_scenario=105 then
            spoil_matrix_by_deleting_col(y13);
        covm2(x13, y13, 5, 3, 2, c);
        x14:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=106 then
            spoil_matrix_by_value(x14, Double(NaN));
        if _spoil_scenario=107 then
            spoil_matrix_by_value(x14, Double(Infinity));
        if _spoil_scenario=108 then
            spoil_matrix_by_value(x14, Double(NegInfinity));
        if _spoil_scenario=109 then
            spoil_matrix_by_deleting_row(x14);
        if _spoil_scenario=110 then
            spoil_matrix_by_deleting_col(x14);
        y14:=Str2Matrix('[[2,3],[2,1],[-1,6],[-9,9],[7,1]]');
        if _spoil_scenario=111 then
            spoil_matrix_by_value(y14, Double(NaN));
        if _spoil_scenario=112 then
            spoil_matrix_by_value(y14, Double(Infinity));
        if _spoil_scenario=113 then
            spoil_matrix_by_value(y14, Double(NegInfinity));
        if _spoil_scenario=114 then
            spoil_matrix_by_deleting_row(y14);
        if _spoil_scenario=115 then
            spoil_matrix_by_deleting_col(y14);
        pearsoncorrm2(x14, y14, 5, 3, 2, c);
        x15:=Str2Matrix('[[1,0,1],[1,1,0],[-1,1,0],[-2,-1,1],[-1,0,9]]');
        if _spoil_scenario=116 then
            spoil_matrix_by_value(x15, Double(NaN));
        if _spoil_scenario=117 then
            spoil_matrix_by_value(x15, Double(Infinity));
        if _spoil_scenario=118 then
            spoil_matrix_by_value(x15, Double(NegInfinity));
        if _spoil_scenario=119 then
            spoil_matrix_by_deleting_row(x15);
        if _spoil_scenario=120 then
            spoil_matrix_by_deleting_col(x15);
        y15:=Str2Matrix('[[2,3],[2,1],[-1,6],[-9,9],[7,1]]');
        if _spoil_scenario=121 then
            spoil_matrix_by_value(y15, Double(NaN));
        if _spoil_scenario=122 then
            spoil_matrix_by_value(y15, Double(Infinity));
        if _spoil_scenario=123 then
            spoil_matrix_by_value(y15, Double(NegInfinity));
        if _spoil_scenario=124 then
            spoil_matrix_by_deleting_row(y15);
        if _spoil_scenario=125 then
            spoil_matrix_by_deleting_col(y15);
        spearmancorrm2(x15, y15, 5, 3, 2, c);

    finally

    end;
end;


function _test_ssa_d_basic(_spoil_scenario: Integer):Boolean;
var
    s: Tssamodel;
    x: TVector;
    trend: TVector;
    noise: TVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // Here we demonstrate SSA trend/noise separation for some toy problem:
        // small monotonically growing series X are analyzed with 3-tick window
        // and "top-K" version of SSA, which selects K largest singular vectors
        // for analysis, with K=1.
        //
        x:=Str2Vector('[0,0.5,1,1,1.5,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));

        //
        // First, we create SSA model, set its properties and add dataset.
        //
        // We use window with width=3 and configure model to use direct SSA
        // algorithm - one which runs exact O(N*W^2) analysis - to extract
        // one top singular vector. Well, it is toy problem :)
        //
        // NOTE: SSA model may store and analyze more than one sequence
        //       (say, different sequences may correspond to data collected
        //       from different devices)
        //
        ssacreate(s);
        ssasetwindow(s, 3);
        ssaaddsequence(s, x);
        ssasetalgotopkdirect(s, 1);

        //
        // Now we begin analysis. Internally SSA model stores everything it needs:
        // data, settings, solvers and so on. Right after first call to analysis-
        // related function it will analyze dataset, build basis and perform analysis.
        //
        // Subsequent calls to analysis functions will reuse previously computed
        // basis, unless you invalidate it by changing model settings (or dataset).
        //
        ssaanalyzesequence(s, x, trend, noise);
        Result:=Result and doc_test_real_vector(trend, Str2Vector('[0.3815,0.5582,0.7810,1.0794,1.5041,2.0105]'), 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_ssa_d_forecast(_spoil_scenario: Integer):Boolean;
var
    s: Tssamodel;
    x: TVector;
    trend: TVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // Here we demonstrate SSA forecasting on some toy problem with clearly
        // visible linear trend and small amount of noise.
        //
        x:=Str2Vector('[0.05,0.96,2.04,3.11,3.97,5.03,5.98,7.02,8.02]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));

        //
        // First, we create SSA model, set its properties and add dataset.
        //
        // We use window with width=3 and configure model to use direct SSA
        // algorithm - one which runs exact O(N*W^2) analysis - to extract
        // two top singular vectors. Well, it is toy problem :)
        //
        // NOTE: SSA model may store and analyze more than one sequence
        //       (say, different sequences may correspond to data collected
        //       from different devices)
        //
        ssacreate(s);
        ssasetwindow(s, 3);
        ssaaddsequence(s, x);
        ssasetalgotopkdirect(s, 2);

        //
        // Now we begin analysis. Internally SSA model stores everything it needs:
        // data, settings, solvers and so on. Right after first call to analysis-
        // related function it will analyze dataset, build basis and perform analysis.
        //
        // Subsequent calls to analysis functions will reuse previously computed
        // basis, unless you invalidate it by changing model settings (or dataset).
        //
        // In this example we show how to use ssaforecastlast() function, which
        // predicts changed in the last sequence of the dataset. If you want to
        // perform prediction for some other sequence, use ssaforecastsequence().
        //
        ssaforecastlast(s, 3, trend);

        //
        // Well, we expected it to be [9,10,11]. There exists some difference,
        // which can be explained by the artificial noise in the dataset.
        //
        Result:=Result and doc_test_real_vector(trend, Str2Vector('[9.0005,9.9322,10.8051]'), 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_ssa_d_realtime(_spoil_scenario: Integer):Boolean;
var
    s1: Tssamodel;
    a1: TMatrix;
    sv1: TVector;
    w: TALGLIBInteger;
    k: TALGLIBInteger;
    x0: TVector;
    updateits: Double;
    s2: Tssamodel;
    a2: TMatrix;
    sv2: TVector;
    x2: TVector;

begin
    Result:=True;
    try
        s1:=nil;
        s2:=nil;

        //
        // Suppose that you have a constant stream of incoming data, and you want
        // to regularly perform singular spectral analysis of this stream.
        //
        // One full run of direct algorithm costs O(N*Width^2) operations, so
        // the more points you have, the more it costs to rebuild basis from
        // scratch.
        // 
        // Luckily we have incremental SSA algorithm which can perform quick
        // updates of already computed basis in O(K*Width^2) ops, where K
        // is a number of singular vectors extracted. Usually it is orders of
        // magnitude faster than full update of the basis.
        //
        // In this example we start from some initial dataset x0. Then we
        // start appending elements one by one to the end of the last sequence.
        //
        // NOTE: direct algorithm also supports incremental updates, but
        //       with O(Width^3) cost. Typically K<<Width, so specialized
        //       incremental algorithm is still faster.
        //
        x0:=Str2Vector('[0.009,0.976,1.999,2.984,3.977,5.002]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x0, Double(NegInfinity));
        ssacreate(s1);
        ssasetwindow(s1, 3);
        ssaaddsequence(s1, x0);

        // set algorithm to the real-time version of top-K, K=2
        ssasetalgotopkrealtime(s1, 2);

        // one more interesting feature of the incremental algorithm is "power-up" cycle.
        // even with incremental algorithm initial basis calculation costs O(N*Width^2) ops.
        // if such startup cost is too high for your real-time app, then you may divide
        // initial basis calculation across several model updates. It results in better
        // latency at the price of somewhat lesser precision during first few updates.
        ssasetpoweruplength(s1, 3);

        // now, after we prepared everything, start to add incoming points one by one;
        // in the real life, of course, we will perform some work between subsequent update
        // (analyze something, predict, and so on).
        //
        // After each append we perform one iteration of the real-time solver. Usually
        // one iteration is more than enough to update basis. If you have REALLY tight
        // performance constraints, you may specify fractional amount of iterations,
        // which means that iteration is performed with required probability.
        updateits:=1.0;
        if _spoil_scenario=3 then
            updateits:=Double(NaN);
        if _spoil_scenario=4 then
            updateits:=Double(Infinity);
        if _spoil_scenario=5 then
            updateits:=Double(NegInfinity);
        ssaappendpointandupdate(s1, 5.951, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 7.074, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 7.925, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 8.992, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 9.942, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 11.051, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 11.965, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 13.047, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        ssaappendpointandupdate(s1, 13.970, updateits);
        ssagetbasis(s1, a1, sv1, w, k);

        // Ok, we have our basis in a1[] and singular values at sv1[].
        // But is it good enough? Let's print it.
        Result:=Result and doc_test_real_matrix(a1, Str2Matrix('[[0.510607,0.753611],[0.575201,0.058445],[0.639081,-0.654717]]'), 0.0005);

        // Ok, two vectors with 3 components each.
        // But how to understand that is it really good basis?
        // Let's compare it with direct SSA algorithm on the entire sequence.
        x2:=Str2Vector('[0.009,0.976,1.999,2.984,3.977,5.002,5.951,7.074,7.925,8.992,9.942,11.051,11.965,13.047,13.970]');
        if _spoil_scenario=6 then
            spoil_vector_by_value(x2, Double(NaN));
        if _spoil_scenario=7 then
            spoil_vector_by_value(x2, Double(Infinity));
        if _spoil_scenario=8 then
            spoil_vector_by_value(x2, Double(NegInfinity));
        ssacreate(s2);
        ssasetwindow(s2, 3);
        ssaaddsequence(s2, x2);
        ssasetalgotopkdirect(s2, 2);
        ssagetbasis(s2, a2, sv2, w, k);

        // it is exactly the same as one calculated with incremental approach!
        Result:=Result and doc_test_real_matrix(a2, Str2Matrix('[[0.510607,0.753611],[0.575201,0.058445],[0.639081,-0.654717]]'), 0.0005);

    finally
        FreeAndNil(s1);
        FreeAndNil(s2);

    end;
end;


function _test_linreg_d_basic(_spoil_scenario: Integer):Boolean;
var
    xy: TMatrix;
    info: TALGLIBInteger;
    nvars: TALGLIBInteger;
    model: Tlinearmodel;
    rep: Tlrreport;
    c: TVector;

begin
    Result:=True;
    try
        model:=nil;

        //
        // In this example we demonstrate linear fitting by f(x|a) = a*exp(0.5*x).
        //
        // We have:
        // * xy - matrix of basic function values (exp(0.5*x)) and expected values
        //
        xy:=Str2Matrix('[[0.606531,1.133719],[0.670320,1.306522],[0.740818,1.504604],[0.818731,1.554663],[0.904837,1.884638],[1.000000,2.072436],[1.105171,2.257285],[1.221403,2.534068],[1.349859,2.622017],[1.491825,2.897713],[1.648721,3.219371]]');

        lrbuildz(xy, 11, 1, info, model, rep);
        Result:=Result and doc_test_int(info, 1);
        lrunpack(model, c, nvars);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.98650,0.00000]'), 0.00005);

    finally
        FreeAndNil(model);

    end;
end;


function _test_filters_d_sma(_spoil_scenario: Integer):Boolean;
var
    x: TVector;

begin
    Result:=True;
    try

        //
        // Here we demonstrate SMA(k) filtering for time series.
        //
        x:=Str2Vector('[5,6,7,8]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));

        //
        // Apply filter.
        // We should get [5, 5.5, 6.5, 7.5] as result
        //
        filtersma(x, 2);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[5,5.5,6.5,7.5]'), 0.00005);


    finally

    end;
end;


function _test_filters_d_ema(_spoil_scenario: Integer):Boolean;
var
    x: TVector;

begin
    Result:=True;
    try

        //
        // Here we demonstrate EMA(0.5) filtering for time series.
        //
        x:=Str2Vector('[5,6,7,8]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));

        //
        // Apply filter.
        // We should get [5, 5.5, 6.25, 7.125] as result
        //
        filterema(x, 0.5);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[5,5.5,6.25,7.125]'), 0.00005);


    finally

    end;
end;


function _test_filters_d_lrma(_spoil_scenario: Integer):Boolean;
var
    x: TVector;

begin
    Result:=True;
    try

        //
        // Here we demonstrate LRMA(3) filtering for time series.
        //
        x:=Str2Vector('[7,8,8,9,12,12]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));

        //
        // Apply filter.
        // We should get [7.0000, 8.0000, 8.1667, 8.8333, 11.6667, 12.5000] as result
        //    
        filterlrma(x, 3);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[7.0000,8.0000,8.1667,8.8333,11.6667,12.5000]'), 0.00005);


    finally

    end;
end;


function _test_mcpd_simple1(_spoil_scenario: Integer):Boolean;
var
    s: Tmcpdstate;
    rep: Tmcpdreport;
    p: TMatrix;
    track0: TMatrix;
    track1: TMatrix;

begin
    Result:=True;
    try
        s:=nil;

        //
        // The very simple MCPD example
        //
        // We have a loan portfolio. Our loans can be in one of two states:
        // * normal loans ("good" ones)
        // * past due loans ("bad" ones)
        //
        // We assume that:
        // * loans can transition from any state to any other state. In 
        //   particular, past due loan can become "good" one at any moment 
        //   with same (fixed) probability. Not realistic, but it is toy example :)
        // * portfolio size does not change over time
        //
        // Thus, we have following model
        //     state_new = P*state_old
        // where
        //         ( p00  p01 )
        //     P = (          )
        //         ( p10  p11 )
        //
        // We want to model transitions between these two states using MCPD
        // approach (Markov Chains for Proportional/Population Data), i.e.
        // to restore hidden transition matrix P using actual portfolio data.
        // We have:
        // * poportional data, i.e. proportion of loans in the normal and past 
        //   due states (not portfolio size measured in some currency, although 
        //   it is possible to work with population data too)
        // * two tracks, i.e. two sequences which describe portfolio
        //   evolution from two different starting states: [1,0] (all loans 
        //   are "good") and [0.8,0.2] (only 80% of portfolio is in the "good"
        //   state)
        //
        track0:=Str2Matrix('[[1.00000,0.00000],[0.95000,0.05000],[0.92750,0.07250],[0.91738,0.08263],[0.91282,0.08718]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(track0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(track0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(track0, Double(NegInfinity));
        track1:=Str2Matrix('[[0.80000,0.20000],[0.86000,0.14000],[0.88700,0.11300],[0.89915,0.10085]]');
        if _spoil_scenario=3 then
            spoil_matrix_by_value(track1, Double(NaN));
        if _spoil_scenario=4 then
            spoil_matrix_by_value(track1, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_matrix_by_value(track1, Double(NegInfinity));

        mcpdcreate(2, s);
        mcpdaddtrack(s, track0);
        mcpdaddtrack(s, track1);
        mcpdsolve(s);
        mcpdresults(s, p, rep);

        //
        // Hidden matrix P is equal to
        //         ( 0.95  0.50 )
        //         (            )
        //         ( 0.05  0.50 )
        // which means that "good" loans can become "bad" with 5% probability, 
        // while "bad" loans will return to good state with 50% probability.
        //
        Result:=Result and doc_test_real_matrix(p, Str2Matrix('[[0.95,0.50],[0.05,0.50]]'), 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_mcpd_simple2(_spoil_scenario: Integer):Boolean;
var
    s: Tmcpdstate;
    rep: Tmcpdreport;
    p: TMatrix;
    track0: TMatrix;
    track1: TMatrix;

begin
    Result:=True;
    try
        s:=nil;

        //
        // Simple MCPD example
        //
        // We have a loan portfolio. Our loans can be in one of three states:
        // * normal loans
        // * past due loans
        // * charged off loans
        //
        // We assume that:
        // * normal loan can stay normal or become past due (but not charged off)
        // * past due loan can stay past due, become normal or charged off
        // * charged off loan will stay charged off for the rest of eternity
        // * portfolio size does not change over time
        // Not realistic, but it is toy example :)
        //
        // Thus, we have following model
        //     state_new = P*state_old
        // where
        //         ( p00  p01    )
        //     P = ( p10  p11    )
        //         (      p21  1 )
        // i.e. four elements of P are known a priori.
        //
        // Although it is possible (given enough data) to In order to enforce 
        // this property we set equality constraints on these elements.
        //
        // We want to model transitions between these two states using MCPD
        // approach (Markov Chains for Proportional/Population Data), i.e.
        // to restore hidden transition matrix P using actual portfolio data.
        // We have:
        // * poportional data, i.e. proportion of loans in the current and past 
        //   due states (not portfolio size measured in some currency, although 
        //   it is possible to work with population data too)
        // * two tracks, i.e. two sequences which describe portfolio
        //   evolution from two different starting states: [1,0,0] (all loans 
        //   are "good") and [0.8,0.2,0.0] (only 80% of portfolio is in the "good"
        //   state)
        //
        track0:=Str2Matrix('[[1.000000,0.000000,0.000000],[0.950000,0.050000,0.000000],[0.927500,0.060000,0.012500],[0.911125,0.061375,0.027500],[0.896256,0.060900,0.042844]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(track0, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(track0, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(track0, Double(NegInfinity));
        track1:=Str2Matrix('[[0.800000,0.200000,0.000000],[0.860000,0.090000,0.050000],[0.862000,0.065500,0.072500],[0.851650,0.059475,0.088875],[0.838805,0.057451,0.103744]]');
        if _spoil_scenario=3 then
            spoil_matrix_by_value(track1, Double(NaN));
        if _spoil_scenario=4 then
            spoil_matrix_by_value(track1, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_matrix_by_value(track1, Double(NegInfinity));

        mcpdcreate(3, s);
        mcpdaddtrack(s, track0);
        mcpdaddtrack(s, track1);
        mcpdaddec(s, 0, 2, 0.0);
        mcpdaddec(s, 1, 2, 0.0);
        mcpdaddec(s, 2, 2, 1.0);
        mcpdaddec(s, 2, 0, 0.0);
        mcpdsolve(s);
        mcpdresults(s, p, rep);

        //
        // Hidden matrix P is equal to
        //         ( 0.95 0.50      )
        //         ( 0.05 0.25      )
        //         (      0.25 1.00 ) 
        // which means that "good" loans can become past due with 5% probability, 
        // while past due loans will become charged off with 25% probability or
        // return back to normal state with 50% probability.
        //
        Result:=Result and doc_test_real_matrix(p, Str2Matrix('[[0.95,0.50,0.00],[0.05,0.25,0.00],[0.00,0.25,1.00]]'), 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_nn_regr(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    network: Tmultilayerperceptron;
    rep: Tmlpreport;
    xy: TMatrix;
    x: TVector;
    y: TVector;

begin
    Result:=True;
    try
        trn:=nil;
        network:=nil;

        //
        // The very simple example on neural network: network is trained to reproduce
        // small 2x2 multiplication table.
        //
        // NOTE: we use network with excessive amount of neurons, which guarantees
        //       almost exact reproduction of the training set. Generalization ability
        //       of such network is rather low, but we are not concerned with such
        //       questions in this basic demo.
        //

        //
        // Training set:
        // * one row corresponds to one record A*B=C in the multiplication table
        // * first two columns store A and B, last column stores C
        //
        // [1 * 1 = 1]
        // [1 * 2 = 2]
        // [2 * 1 = 2]
        // [2 * 2 = 4]
        //
        xy:=Str2Matrix('[[1,1,1],[1,2,2],[2,1,2],[2,2,4]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        //
        // Network is created.
        // Trainer object is created.
        // Dataset is attached to trainer object.
        //
        mlpcreatetrainer(2, 1, trn);
        mlpcreate1(2, 5, 1, network);
        mlpsetdataset(trn, xy, 4);

        //
        // Network is trained with 5 restarts from random positions
        //
        mlptrainnetwork(trn, network, 5, rep);

        //
        // 2*2=?
        //
        x:=Str2Vector('[2,2]');
        y:=Str2Vector('[0]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[4.000]'), 0.05);

    finally
        FreeAndNil(trn);
        FreeAndNil(network);

    end;
end;


function _test_nn_regr_n(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    network: Tmultilayerperceptron;
    rep: Tmlpreport;
    xy: TMatrix;
    x: TVector;
    y: TVector;

begin
    Result:=True;
    try
        trn:=nil;
        network:=nil;

        //
        // Network with 2 inputs and 2 outputs is trained to reproduce vector function:
        //     (x0,x1) => (x0+x1, x0*x1)
        //
        // Informally speaking, we want neural network to simultaneously calculate
        // both sum of two numbers and their product.
        //
        // NOTE: we use network with excessive amount of neurons, which guarantees
        //       almost exact reproduction of the training set. Generalization ability
        //       of such network is rather low, but we are not concerned with such
        //       questions in this basic demo.
        //

        //
        // Training set. One row corresponds to one record [A,B,A+B,A*B].
        //
        // [ 1   1  1+1  1*1 ]
        // [ 1   2  1+2  1*2 ]
        // [ 2   1  2+1  2*1 ]
        // [ 2   2  2+2  2*2 ]
        //
        xy:=Str2Matrix('[[1,1,2,1],[1,2,3,2],[2,1,3,2],[2,2,4,4]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        //
        // Network is created.
        // Trainer object is created.
        // Dataset is attached to trainer object.
        //
        mlpcreatetrainer(2, 2, trn);
        mlpcreate1(2, 5, 2, network);
        mlpsetdataset(trn, xy, 4);

        //
        // Network is trained with 5 restarts from random positions
        //
        mlptrainnetwork(trn, network, 5, rep);

        //
        // 2+1=?
        // 2*1=?
        //
        x:=Str2Vector('[2,1]');
        y:=Str2Vector('[0,0]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[3.000,2.000]'), 0.05);

    finally
        FreeAndNil(trn);
        FreeAndNil(network);

    end;
end;


function _test_nn_cls2(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    network: Tmultilayerperceptron;
    rep: Tmlpreport;
    x: TVector;
    y: TVector;
    xy: TMatrix;

begin
    Result:=True;
    try
        trn:=nil;
        network:=nil;

        //
        // Suppose that we want to classify numbers as positive (class 0) and negative
        // (class 1). We have training set which includes several strictly positive
        // or negative numbers - and zero.
        //
        // The problem is that we are not sure how to classify zero, so from time to
        // time we mark it as positive or negative (with equal probability). Other
        // numbers are marked in pure deterministic setting. How will neural network
        // cope with such classification task?
        //
        // NOTE: we use network with excessive amount of neurons, which guarantees
        //       almost exact reproduction of the training set. Generalization ability
        //       of such network is rather low, but we are not concerned with such
        //       questions in this basic demo.
        //
        x:=Str2Vector('[0]');
        y:=Str2Vector('[0,0]');

        //
        // Training set. One row corresponds to one record [A => class(A)].
        //
        // Classes are denoted by numbers from 0 to 1, where 0 corresponds to positive
        // numbers and 1 to negative numbers.
        //
        // [ +1  0]
        // [ +2  0]
        // [ -1  1]
        // [ -2  1]
        // [  0  0]   !! sometimes we classify 0 as positive, sometimes as negative
        // [  0  1]   !!
        //
        xy:=Str2Matrix('[[+1,0],[+2,0],[-1,1],[-2,1],[0,0],[0,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        //
        //
        // When we solve classification problems, everything is slightly different from
        // the regression ones:
        //
        // 1. Network is created. Because we solve classification problem, we use
        //    mlpcreatec1() function instead of mlpcreate1(). This function creates
        //    classifier network with SOFTMAX-normalized outputs. This network returns
        //    vector of class membership probabilities which are normalized to be
        //    non-negative and sum to 1.0
        //
        // 2. We use mlpcreatetrainercls() function instead of mlpcreatetrainer() to
        //    create trainer object. Trainer object process dataset and neural network
        //    slightly differently to account for specifics of the classification
        //    problems.
        //
        // 3. Dataset is attached to trainer object. Note that dataset format is slightly
        //    different from one used for regression.
        //
        mlpcreatetrainercls(1, 2, trn);
        mlpcreatec1(1, 5, 2, network);
        mlpsetdataset(trn, xy, 6);

        //
        // Network is trained with 5 restarts from random positions
        //
        mlptrainnetwork(trn, network, 5, rep);

        //
        // Test our neural network on strictly positive and strictly negative numbers.
        //
        // IMPORTANT! Classifier network returns class membership probabilities instead
        // of class indexes. Network returns two values (probabilities) instead of one
        // (class index).
        //
        // Thus, for +1 we expect to get [P0,P1] = [1,0], where P0 is probability that
        // number is positive (belongs to class 0), and P1 is probability that number
        // is negative (belongs to class 1).
        //
        // For -1 we expect to get [P0,P1] = [0,1]
        //
        // Following properties are guaranteed by network architecture:
        // * P0>=0, P1>=0   non-negativity
        // * P0+P1=1        normalization
        //
        x:=Str2Vector('[1]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[1.000,0.000]'), 0.05);
        x:=Str2Vector('[-1]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[0.000,1.000]'), 0.05);

        //
        // But what our network will return for 0, which is between classes 0 and 1?
        //
        // In our dataset it has two different marks assigned (class 0 AND class 1).
        // So network will return something average between class 0 and class 1:
        //     0 => [0.5, 0.5]
        //
        x:=Str2Vector('[0]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[0.500,0.500]'), 0.05);

    finally
        FreeAndNil(trn);
        FreeAndNil(network);

    end;
end;


function _test_nn_cls3(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    network: Tmultilayerperceptron;
    rep: Tmlpreport;
    x: TVector;
    y: TVector;
    xy: TMatrix;

begin
    Result:=True;
    try
        trn:=nil;
        network:=nil;

        //
        // Suppose that we want to classify numbers as positive (class 0) and negative
        // (class 1). We also have one more class for zero (class 2).
        //
        // NOTE: we use network with excessive amount of neurons, which guarantees
        //       almost exact reproduction of the training set. Generalization ability
        //       of such network is rather low, but we are not concerned with such
        //       questions in this basic demo.
        //
        x:=Str2Vector('[0]');
        y:=Str2Vector('[0,0,0]');

        //
        // Training set. One row corresponds to one record [A => class(A)].
        //
        // Classes are denoted by numbers from 0 to 2, where 0 corresponds to positive
        // numbers, 1 to negative numbers, 2 to zero
        //
        // [ +1  0]
        // [ +2  0]
        // [ -1  1]
        // [ -2  1]
        // [  0  2]
        //
        xy:=Str2Matrix('[[+1,0],[+2,0],[-1,1],[-2,1],[0,2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        //
        //
        // When we solve classification problems, everything is slightly different from
        // the regression ones:
        //
        // 1. Network is created. Because we solve classification problem, we use
        //    mlpcreatec1() function instead of mlpcreate1(). This function creates
        //    classifier network with SOFTMAX-normalized outputs. This network returns
        //    vector of class membership probabilities which are normalized to be
        //    non-negative and sum to 1.0
        //
        // 2. We use mlpcreatetrainercls() function instead of mlpcreatetrainer() to
        //    create trainer object. Trainer object process dataset and neural network
        //    slightly differently to account for specifics of the classification
        //    problems.
        //
        // 3. Dataset is attached to trainer object. Note that dataset format is slightly
        //    different from one used for regression.
        //
        mlpcreatetrainercls(1, 3, trn);
        mlpcreatec1(1, 5, 3, network);
        mlpsetdataset(trn, xy, 5);

        //
        // Network is trained with 5 restarts from random positions
        //
        mlptrainnetwork(trn, network, 5, rep);

        //
        // Test our neural network on strictly positive and strictly negative numbers.
        //
        // IMPORTANT! Classifier network returns class membership probabilities instead
        // of class indexes. Network returns three values (probabilities) instead of one
        // (class index).
        //
        // Thus, for +1 we expect to get [P0,P1,P2] = [1,0,0],
        // for -1 we expect to get [P0,P1,P2] = [0,1,0],
        // and for 0 we will get [P0,P1,P2] = [0,0,1].
        //
        // Following properties are guaranteed by network architecture:
        // * P0>=0, P1>=0, P2>=0    non-negativity
        // * P0+P1+P2=1             normalization
        //
        x:=Str2Vector('[1]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[1.000,0.000,0.000]'), 0.05);
        x:=Str2Vector('[-1]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[0.000,1.000,0.000]'), 0.05);
        x:=Str2Vector('[0]');
        mlpprocess(network, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[0.000,0.000,1.000]'), 0.05);

    finally
        FreeAndNil(trn);
        FreeAndNil(network);

    end;
end;


function _test_nn_trainerobject(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    xy: TMatrix;
    wstep: Double;
    maxits: TALGLIBInteger;
    net1: Tmultilayerperceptron;
    net2: Tmultilayerperceptron;
    net3: Tmultilayerperceptron;
    rep: Tmlpreport;

begin
    Result:=True;
    try
        trn:=nil;
        net1:=nil;
        net2:=nil;
        net3:=nil;

        //
        // Trainer object is used to train network. It stores dataset, training settings,
        // and other information which is NOT part of neural network. You should use
        // trainer object as follows:
        // (1) you create trainer object and specify task type (classification/regression)
        //     and number of inputs/outputs
        // (2) you add dataset to the trainer object
        // (3) you may change training settings (stopping criteria or weight decay)
        // (4) finally, you may train one or more networks
        //
        // You may interleave stages 2...4 and repeat them many times. Trainer object
        // remembers its internal state and can be used several times after its creation
        // and initialization.
        //

        //
        // Stage 1: object creation.
        //
        // We have to specify number of inputs and outputs. Trainer object can be used
        // only for problems with same number of inputs/outputs as was specified during
        // its creation.
        //
        // In case you want to train SOFTMAX-normalized network which solves classification
        // problems,  you  must  use  another  function  to  create  trainer  object:
        // mlpcreatetrainercls().
        //
        // Below we create trainer object which can be used to train regression networks
        // with 2 inputs and 1 output.
        //
        mlpcreatetrainer(2, 1, trn);

        //
        // Stage 2: specification of the training set
        //
        // By default trainer object stores empty dataset. So to solve your non-empty problem
        // you have to set dataset by passing to trainer dense or sparse matrix.
        //
        // One row of the matrix corresponds to one record A*B=C in the multiplication table.
        // First two columns store A and B, last column stores C
        //
        //     [1 * 1 = 1]   [ 1 1 1 ]
        //     [1 * 2 = 2]   [ 1 2 2 ]
        //     [2 * 1 = 2] = [ 2 1 2 ]
        //     [2 * 2 = 4]   [ 2 2 4 ]
        //
        xy:=Str2Matrix('[[1,1,1],[1,2,2],[2,1,2],[2,2,4]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        mlpsetdataset(trn, xy, 4);

        //
        // Stage 3: modification of the training parameters.
        //
        // You may modify parameters like weights decay or stopping criteria:
        // * we set moderate weight decay
        // * we choose iterations limit as stopping condition (another condition - step size -
        //   is zero, which means than this condition is not active)
        //
        wstep:=0.000;
        if _spoil_scenario=3 then
            wstep:=Double(NaN);
        if _spoil_scenario=4 then
            wstep:=Double(Infinity);
        if _spoil_scenario=5 then
            wstep:=Double(NegInfinity);
        maxits:=100;
        mlpsetdecay(trn, 0.01);
        mlpsetcond(trn, wstep, maxits);

        //
        // Stage 4: training.
        //
        // We will train several networks with different architecture using same trainer object.
        // We may change training parameters or even dataset, so different networks are trained
        // differently. But in this simple example we will train all networks with same settings.
        //
        // We create and train three networks:
        // * network 1 has 2x1 architecture     (2 inputs, no hidden neurons, 1 output)
        // * network 2 has 2x5x1 architecture   (2 inputs, 5 hidden neurons, 1 output)
        // * network 3 has 2x5x5x1 architecture (2 inputs, two hidden layers, 1 output)
        //
        // NOTE: these networks solve regression problems. For classification problems you
        //       should use mlpcreatec0/c1/c2 to create neural networks which have SOFTMAX-
        //       normalized outputs.
        //

        mlpcreate0(2, 1, net1);
        mlpcreate1(2, 5, 1, net2);
        mlpcreate2(2, 5, 5, 1, net3);

        mlptrainnetwork(trn, net1, 5, rep);
        mlptrainnetwork(trn, net2, 5, rep);
        mlptrainnetwork(trn, net3, 5, rep);

    finally
        FreeAndNil(trn);
        FreeAndNil(net1);
        FreeAndNil(net2);
        FreeAndNil(net3);

    end;
end;


function _test_nn_crossvalidation(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    network: Tmultilayerperceptron;
    rep: Tmlpreport;
    xy: TMatrix;

begin
    Result:=True;
    try
        trn:=nil;
        network:=nil;

        //
        // This example shows how to perform cross-validation with ALGLIB
        //

        //
        // Training set: f(x)=1/(x^2+1)
        // One row corresponds to one record [x,f(x)]
        //
        xy:=Str2Matrix('[[-2.0,0.2],[-1.6,0.3],[-1.3,0.4],[-1,0.5],[-0.6,0.7],[-0.3,0.9],[0,1],[2.0,0.2],[1.6,0.3],[1.3,0.4],[1,0.5],[0.6,0.7],[0.3,0.9]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        //
        // Trainer object is created.
        // Dataset is attached to trainer object.
        //
        // NOTE: it is not good idea to perform cross-validation on sample
        //       as small as ours (13 examples). It is done for demonstration
        //       purposes only. Generalization error estimates won't be
        //       precise enough for practical purposes.
        //
        mlpcreatetrainer(1, 1, trn);
        mlpsetdataset(trn, xy, 13);

        //
        // The key property of the cross-validation is that it estimates
        // generalization properties of neural ARCHITECTURE. It does NOT
        // estimates generalization error of some specific network which
        // is passed to the k-fold CV routine.
        //
        // In our example we create 1x4x1 neural network and pass it to
        // CV routine without training it. Original state of the network
        // is not used for cross-validation - each round is restarted from
        // random initial state. Only geometry of network matters.
        //
        // We perform 5 restarts from different random positions for each
        // of the 10 cross-validation rounds.
        //
        mlpcreate1(1, 4, 1, network);
        mlpkfoldcv(trn, network, 5, 10, rep);

        //
        // Cross-validation routine stores estimates of the generalization
        // error to MLP report structure. You may examine its fields and
        // see estimates of different errors (RMS, CE, Avg).
        //
        // Because cross-validation is non-deterministic, in our manual we
        // can not say what values will be stored to rep after call to
        // mlpkfoldcv(). Every CV round will return slightly different
        // estimates.
        //

    finally
        FreeAndNil(trn);
        FreeAndNil(network);

    end;
end;


function _test_nn_ensembles_es(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    ensemble: Tmlpensemble;
    rep: Tmlpreport;
    xy: TMatrix;

begin
    Result:=True;
    try
        trn:=nil;
        ensemble:=nil;

        //
        // This example shows how to train early stopping ensebles.
        //

        //
        // Training set: f(x)=1/(x^2+1)
        // One row corresponds to one record [x,f(x)]
        //
        xy:=Str2Matrix('[[-2.0,0.2],[-1.6,0.3],[-1.3,0.4],[-1,0.5],[-0.6,0.7],[-0.3,0.9],[0,1],[2.0,0.2],[1.6,0.3],[1.3,0.4],[1,0.5],[0.6,0.7],[0.3,0.9]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        //
        // Trainer object is created.
        // Dataset is attached to trainer object.
        //
        // NOTE: it is not good idea to use early stopping ensemble on sample
        //       as small as ours (13 examples). It is done for demonstration
        //       purposes only. Ensemble training algorithm won't find good
        //       solution on such small sample.
        //
        mlpcreatetrainer(1, 1, trn);
        mlpsetdataset(trn, xy, 13);

        //
        // Ensemble is created and trained. Each of 50 network is trained
        // with 5 restarts.
        //
        mlpecreate1(1, 4, 1, 50, ensemble);
        mlptrainensemblees(trn, ensemble, 5, rep);

    finally
        FreeAndNil(trn);
        FreeAndNil(ensemble);

    end;
end;


function _test_nn_parallel(_spoil_scenario: Integer):Boolean;
var
    trn: Tmlptrainer;
    network: Tmultilayerperceptron;
    ensemble: Tmlpensemble;
    rep: Tmlpreport;
    xy: TMatrix;

begin
    Result:=True;
    try
        trn:=nil;
        network:=nil;
        ensemble:=nil;

        //
        // This example shows how to use parallel functionality of ALGLIB.
        // We generate simple 1-dimensional regression problem and show how
        // to use parallel training, parallel cross-validation, parallel
        // training of neural ensembles.
        //
        // We assume that you already know how to use ALGLIB in serial mode
        // and concentrate on its parallel capabilities.
        //
        // NOTE: it is not good idea to use parallel features on sample as small
        //       as ours (13 examples). It is done only for demonstration purposes.
        //
        xy:=Str2Matrix('[[-2.0,0.2],[-1.6,0.3],[-1.3,0.4],[-1,0.5],[-0.6,0.7],[-0.3,0.9],[0,1],[2.0,0.2],[1.6,0.3],[1.3,0.4],[1,0.5],[0.6,0.7],[0.3,0.9]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        mlpcreatetrainer(1, 1, trn);
        mlpsetdataset(trn, xy, 13);
        mlpcreate1(1, 4, 1, network);
        mlpecreate1(1, 4, 1, 50, ensemble);

        //
        // Below we demonstrate how to perform:
        // * parallel training of individual networks
        // * parallel cross-validation
        // * parallel training of neural ensembles
        //
        // In order to use multithreading, you have to:
        // 1) Install SMP edition of ALGLIB.
        // 2) This step is specific for C++ users: you should activate OS-specific
        //    capabilities of ALGLIB by defining AE_OS=AE_POSIX (for *nix systems)
        //    or AE_OS=AE_WINDOWS (for Windows systems).
        //    C# users do not have to perform this step because C# programs are
        //    portable across different systems without OS-specific tuning.
        // 3) Tell ALGLIB that you want it to use multithreading by means of
        //    setnworkers() call:
        //          * alglib::setnworkers(0)  = use all cores
        //          * alglib::setnworkers(-1) = leave one core unused
        //          * alglib::setnworkers(-2) = leave two cores unused
        //          * alglib::setnworkers(+2) = use 2 cores (even if you have more)
        //    During runtime ALGLIB will automatically determine whether it is
        //    feasible to start worker threads and split your task between cores.
        //
        setnworkers(+2);

        //
        // First, we perform parallel training of individual network with 5
        // restarts from random positions. These 5 rounds of  training  are
        // executed in parallel manner,  with  best  network  chosen  after
        // training.
        //
        // ALGLIB can use additional way to speed up computations -  divide
        // dataset   into   smaller   subsets   and   process these subsets
        // simultaneously. It allows us  to  efficiently  parallelize  even
        // single training round. This operation is performed automatically
        // for large datasets, but our toy dataset is too small.
        //
        mlptrainnetwork(trn, network, 5, rep);

        //
        // Then, we perform parallel 10-fold cross-validation, with 5 random
        // restarts per each CV round. I.e., 5*10=50  networks  are trained
        // in total. All these operations can be parallelized.
        //
        // NOTE: again, ALGLIB can parallelize  calculation   of   gradient
        //       over entire dataset - but our dataset is too small.
        //
        mlpkfoldcv(trn, network, 5, 10, rep);

        //
        // Finally, we train early stopping ensemble of 50 neural networks,
        // each  of them is trained with 5 random restarts. I.e.,  5*50=250
        // networks aretrained in total.
        //
        mlptrainensemblees(trn, ensemble, 5, rep);

    finally
        FreeAndNil(trn);
        FreeAndNil(network);
        FreeAndNil(ensemble);

    end;
end;


function _test_clst_ahc(_spoil_scenario: Integer):Boolean;
var
    s: Tclusterizerstate;
    rep: Tahcreport;
    xy: TMatrix;

begin
    Result:=True;
    try
        s:=nil;

        //
        // The very simple clusterization example
        //
        // We have a set of points in 2D space:
        //     (P0,P1,P2,P3,P4) = ((1,1),(1,2),(4,1),(2,3),(4,1.5))
        //
        //  |
        //  |     P3
        //  |
        //  | P1          
        //  |             P4
        //  | P0          P2
        //  |-------------------------
        //
        // We want to perform Agglomerative Hierarchic Clusterization (AHC),
        // using complete linkage (default algorithm) and Euclidean distance
        // (default metric).
        //
        // In order to do that, we:
        // * create clusterizer with clusterizercreate()
        // * set points XY and metric (2=Euclidean) with clusterizersetpoints()
        // * run AHC algorithm with clusterizerrunahc
        //
        // You may see that clusterization itself is a minor part of the example,
        // most of which is dominated by comments :)
        //
        xy:=Str2Matrix('[[1,1],[1,2],[4,1],[2,3],[4,1.5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        clusterizercreate(s);
        clusterizersetpoints(s, xy, 2);
        clusterizerrunahc(s, rep);

        //
        // Now we've built our clusterization tree. Rep.z contains information which
        // is required to build dendrogram. I-th row of rep.z represents one merge
        // operation, with first cluster to merge having index rep.z[I,0] and second
        // one having index rep.z[I,1]. Merge result has index NPoints+I.
        //
        // Clusters with indexes less than NPoints are single-point initial clusters,
        // while ones with indexes from NPoints to 2*NPoints-2 are multi-point
        // clusters created during merges.
        //
        // In our example, Z=[[2,4], [0,1], [3,6], [5,7]]
        //
        // It means that:
        // * first, we merge C2=(P2) and C4=(P4),    and create C5=(P2,P4)
        // * then, we merge  C2=(P0) and C1=(P1),    and create C6=(P0,P1)
        // * then, we merge  C3=(P3) and C6=(P0,P1), and create C7=(P0,P1,P3)
        // * finally, we merge C5 and C7 and create C8=(P0,P1,P2,P3,P4)
        //
        // Thus, we have following dendrogram:
        //  
        //      ------8-----
        //      |          |
        //      |      ----7----
        //      |      |       |
        //   ---5---   |    ---6---
        //   |     |   |    |     |
        //   P2   P4   P3   P0   P1
        //
        Result:=Result and doc_test_int_matrix(rep.z, Str2IMatrix('[[2,4],[0,1],[3,6],[5,7]]'));

        //
        // We've built dendrogram above by reordering our dataset.
        //
        // Without such reordering it would be impossible to build dendrogram without
        // intersections. Luckily, ahcreport structure contains two additional fields
        // which help to build dendrogram from your data:
        // * rep.p, which contains permutation applied to dataset
        // * rep.pm, which contains another representation of merges 
        //
        // In our example we have:
        // * P=[3,4,0,2,1]
        // * PZ=[[0,0,1,1,0,0],[3,3,4,4,0,0],[2,2,3,4,0,1],[0,1,2,4,1,2]]
        //
        // Permutation array P tells us that P0 should be moved to position 3,
        // P1 moved to position 4, P2 moved to position 0 and so on:
        //
        //   (P0 P1 P2 P3 P4) => (P2 P4 P3 P0 P1)
        //
        // Merges array PZ tells us how to perform merges on the sorted dataset.
        // One row of PZ corresponds to one merge operations, with first pair of
        // elements denoting first of the clusters to merge (start index, end
        // index) and next pair of elements denoting second of the clusters to
        // merge. Clusters being merged are always adjacent, with first one on
        // the left and second one on the right.
        //
        // For example, first row of PZ tells us that clusters [0,0] and [1,1] are
        // merged (single-point clusters, with first one containing P2 and second
        // one containing P4). Third row of PZ tells us that we merge one single-
        // point cluster [2,2] with one two-point cluster [3,4].
        //
        // There are two more elements in each row of PZ. These are the helper
        // elements, which denote HEIGHT (not size) of left and right subdendrograms.
        // For example, according to PZ, first two merges are performed on clusterization
        // trees of height 0, while next two merges are performed on 0-1 and 1-2
        // pairs of trees correspondingly.
        //
        Result:=Result and doc_test_int_vector(rep.p, Str2IVector('[3,4,0,2,1]'));
        Result:=Result and doc_test_int_matrix(rep.pm, Str2IMatrix('[[0,0,1,1,0,0],[3,3,4,4,0,0],[2,2,3,4,0,1],[0,1,2,4,1,2]]'));

    finally
        FreeAndNil(s);

    end;
end;


function _test_clst_kmeans(_spoil_scenario: Integer):Boolean;
var
    s: Tclusterizerstate;
    rep: Tkmeansreport;
    xy: TMatrix;

begin
    Result:=True;
    try
        s:=nil;

        //
        // The very simple clusterization example
        //
        // We have a set of points in 2D space:
        //     (P0,P1,P2,P3,P4) = ((1,1),(1,2),(4,1),(2,3),(4,1.5))
        //
        //  |
        //  |     P3
        //  |
        //  | P1          
        //  |             P4
        //  | P0          P2
        //  |-------------------------
        //
        // We want to perform k-means++ clustering with K=2.
        //
        // In order to do that, we:
        // * create clusterizer with clusterizercreate()
        // * set points XY and metric (must be Euclidean, distype=2) with clusterizersetpoints()
        // * (optional) set number of restarts from random positions to 5
        // * run k-means algorithm with clusterizerrunkmeans()
        //
        // You may see that clusterization itself is a minor part of the example,
        // most of which is dominated by comments :)
        //
        xy:=Str2Matrix('[[1,1],[1,2],[4,1],[2,3],[4,1.5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        clusterizercreate(s);
        clusterizersetpoints(s, xy, 2);
        clusterizersetkmeanslimits(s, 5, 0);
        clusterizerrunkmeans(s, 2, rep);

        //
        // We've performed clusterization, and it succeeded (completion code is +1).
        //
        // Now first center is stored in the first row of rep.c, second one is stored
        // in the second row. rep.cidx can be used to determine which center is
        // closest to some specific point of the dataset.
        //
        Result:=Result and doc_test_int(rep.terminationtype, 1);

        // We called clusterizersetpoints() with disttype=2 because k-means++
        // algorithm does NOT support metrics other than Euclidean. But what if we
        // try to use some other metric?
        //
        // We change metric type by calling clusterizersetpoints() one more time,
        // and try to run k-means algo again. It fails.
        //
        clusterizersetpoints(s, xy, 0);
        clusterizerrunkmeans(s, 2, rep);
        Result:=Result and doc_test_int(rep.terminationtype, -5);

    finally
        FreeAndNil(s);

    end;
end;


function _test_clst_linkage(_spoil_scenario: Integer):Boolean;
var
    s: Tclusterizerstate;
    rep: Tahcreport;
    xy: TMatrix;
    cidx: TIVector;
    cz: TIVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We have a set of points in 1D space:
        //     (P0,P1,P2,P3,P4) = (1, 3, 10, 16, 20)
        //
        // We want to perform Agglomerative Hierarchic Clusterization (AHC),
        // using either complete or single linkage and Euclidean distance
        // (default metric).
        //
        // First two steps merge P0/P1 and P3/P4 independently of the linkage type.
        // However, third step depends on linkage type being used:
        // * in case of complete linkage P2=10 is merged with [P0,P1]
        // * in case of single linkage P2=10 is merged with [P3,P4]
        //
        xy:=Str2Matrix('[[1],[3],[10],[16],[20]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        clusterizercreate(s);
        clusterizersetpoints(s, xy, 2);

        // use complete linkage, reduce set down to 2 clusters.
        // print clusterization with clusterizergetkclusters(2).
        // P2 must belong to [P0,P1]
        clusterizersetahcalgo(s, 0);
        clusterizerrunahc(s, rep);
        clusterizergetkclusters(rep, 2, cidx, cz);
        Result:=Result and doc_test_int_vector(cidx, Str2IVector('[1,1,1,0,0]'));

        // use single linkage, reduce set down to 2 clusters.
        // print clusterization with clusterizergetkclusters(2).
        // P2 must belong to [P2,P3]
        clusterizersetahcalgo(s, 1);
        clusterizerrunahc(s, rep);
        clusterizergetkclusters(rep, 2, cidx, cz);
        Result:=Result and doc_test_int_vector(cidx, Str2IVector('[0,0,1,1,1]'));

    finally
        FreeAndNil(s);

    end;
end;


function _test_clst_distance(_spoil_scenario: Integer):Boolean;
var
    s: Tclusterizerstate;
    rep: Tahcreport;
    disttype: TALGLIBInteger;
    xy: TMatrix;
    d: TMatrix;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We have three points in 4D space:
        //     (P0,P1,P2) = ((1, 2, 1, 2), (6, 7, 6, 7), (7, 6, 7, 6))
        //
        // We want to try clustering them with different distance functions.
        // Distance function is chosen when we add dataset to the clusterizer.
        // We can choose several distance types - Euclidean, city block, Chebyshev,
        // several correlation measures or user-supplied distance matrix.
        //
        // Here we'll try three distances: Euclidean, Pearson correlation,
        // user-supplied distance matrix. Different distance functions lead
        // to different choices being made by algorithm during clustering.
        //
        xy:=Str2Matrix('[[1, 2, 1, 2], [6, 7, 6, 7], [7, 6, 7, 6]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        clusterizercreate(s);

        // With Euclidean distance function (disttype=2) two closest points
        // are P1 and P2, thus:
        // * first, we merge P1 and P2 to form C3=[P1,P2]
        // * second, we merge P0 and C3 to form C4=[P0,P1,P2]
        disttype:=2;
        clusterizersetpoints(s, xy, disttype);
        clusterizerrunahc(s, rep);
        Result:=Result and doc_test_int_matrix(rep.z, Str2IMatrix('[[1,2],[0,3]]'));

        // With Pearson correlation distance function (disttype=10) situation
        // is different - distance between P0 and P1 is zero, thus:
        // * first, we merge P0 and P1 to form C3=[P0,P1]
        // * second, we merge P2 and C3 to form C4=[P0,P1,P2]
        disttype:=10;
        clusterizersetpoints(s, xy, disttype);
        clusterizerrunahc(s, rep);
        Result:=Result and doc_test_int_matrix(rep.z, Str2IMatrix('[[0,1],[2,3]]'));

        // Finally, we try clustering with user-supplied distance matrix:
        //     [ 0 3 1 ]
        // P = [ 3 0 3 ], where P[i,j] = dist(Pi,Pj)
        //     [ 1 3 0 ]
        //
        // * first, we merge P0 and P2 to form C3=[P0,P2]
        // * second, we merge P1 and C3 to form C4=[P0,P1,P2]
        d:=Str2Matrix('[[0,3,1],[3,0,3],[1,3,0]]');
        clusterizersetdistances(s, d, true);
        clusterizerrunahc(s, rep);
        Result:=Result and doc_test_int_matrix(rep.z, Str2IMatrix('[[0,2],[1,3]]'));

    finally
        FreeAndNil(s);

    end;
end;


function _test_clst_kclusters(_spoil_scenario: Integer):Boolean;
var
    s: Tclusterizerstate;
    rep: Tahcreport;
    xy: TMatrix;
    cidx: TIVector;
    cz: TIVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We have a set of points in 2D space:
        //     (P0,P1,P2,P3,P4) = ((1,1),(1,2),(4,1),(2,3),(4,1.5))
        //
        //  |
        //  |     P3
        //  |
        //  | P1          
        //  |             P4
        //  | P0          P2
        //  |-------------------------
        //
        // We perform Agglomerative Hierarchic Clusterization (AHC) and we want
        // to get top K clusters from clusterization tree for different K.
        //
        xy:=Str2Matrix('[[1,1],[1,2],[4,1],[2,3],[4,1.5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        clusterizercreate(s);
        clusterizersetpoints(s, xy, 2);
        clusterizerrunahc(s, rep);

        // with K=5, every points is assigned to its own cluster:
        // C0=P0, C1=P1 and so on...
        clusterizergetkclusters(rep, 5, cidx, cz);
        Result:=Result and doc_test_int_vector(cidx, Str2IVector('[0,1,2,3,4]'));

        // with K=1 we have one large cluster C0=[P0,P1,P2,P3,P4,P5]
        clusterizergetkclusters(rep, 1, cidx, cz);
        Result:=Result and doc_test_int_vector(cidx, Str2IVector('[0,0,0,0,0]'));

        // with K=3 we have three clusters C0=[P3], C1=[P2,P4], C2=[P0,P1]
        clusterizergetkclusters(rep, 3, cidx, cz);
        Result:=Result and doc_test_int_vector(cidx, Str2IVector('[2,2,1,0,1]'));

    finally
        FreeAndNil(s);

    end;
end;


function _test_randomforest_cls(_spoil_scenario: Integer):Boolean;
var
    builder: Tdecisionforestbuilder;
    nvars: TALGLIBInteger;
    nclasses: TALGLIBInteger;
    npoints: TALGLIBInteger;
    xy: TMatrix;
    ntrees: TALGLIBInteger;
    forest: Tdecisionforest;
    rep: Tdfreport;
    x: TVector;
    y: TVector;
    y0: Double;
    i: TALGLIBInteger;

begin
    Result:=True;
    try
        builder:=nil;
        forest:=nil;

        //
        // The very simple classification example: classify points (x,y) in 2D space
        // as ones with x>=0 and ones with x<0 (y is ignored, but our classifier
        // has to find out it).
        //
        // First, we have to create decision forest builder object, load dataset and
        // specify training settings. Our dataset is specified as matrix, which has
        // following format:
        //
        //     x0 y0 class0
        //     x1 y1 class1
        //     x2 y2 class2
        //     ....
        //
        // Here xi and yi can be any values (and in fact you can have any number of
        // independent variables), and classi MUST be integer number in [0,NClasses)
        // range. In our example we denote points with x>=0 as class #0, and
        // ones with negative xi as class #1.
        //
        // NOTE: if you want to solve regression problem, specify NClasses=1. In
        //       this case last column of xy can be any numeric value.
        //
        // For the sake of simplicity, our example includes only 4-point dataset.
        // However, random forests are able to cope with extremely large datasets
        // having millions of examples.
        //
        nvars:=2;
        nclasses:=2;
        npoints:=4;
        xy:=Str2Matrix('[[1,1,0],[1,-1,0],[-1,1,1],[-1,-1,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        dfbuildercreate(builder);
        dfbuildersetdataset(builder, xy, npoints, nvars, nclasses);

        // in our example we train decision forest using full sample - it allows us
        // to get zero classification error. However, in practical applications smaller
        // values are used: 50%, 25%, 5% or even less.
        dfbuildersetsubsampleratio(builder, 1.0);

        // we train random forest with just one tree; again, in real life situations
        // you typically need from 50 to 500 trees.
        ntrees:=1;
        dfbuilderbuildrandomforest(builder, ntrees, forest, rep);

        // with such settings (100% of the training set is used) you can expect
        // zero classification error. Beautiful results, but remember - in real life
        // you do not need zero TRAINING SET error, you need good generalization.

        Result:=Result and doc_test_real(rep.relclserror, 0.0000, 0.00005);

        // now, let's perform some simple processing with dfprocess()
        x:=Str2Vector('[+1,0]');
        y:=nil;
        dfprocess(forest, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[+1,0]'), 0.0005);

        // another option is to use dfprocess0() which returns just first component
        // of the output vector y. ideal for regression problems and binary classifiers.
        y0:=dfprocess0(forest, x);
        Result:=Result and doc_test_real(y0, 1.000, 0.0005);

        // finally, you can use dfclassify() which returns most probable class index (i.e. argmax y[i]).
        i:=dfclassify(forest, x);
        Result:=Result and doc_test_int(i, 0);

    finally
        FreeAndNil(builder);
        FreeAndNil(forest);

    end;
end;


function _test_randomforest_reg(_spoil_scenario: Integer):Boolean;
var
    builder: Tdecisionforestbuilder;
    nvars: TALGLIBInteger;
    nclasses: TALGLIBInteger;
    npoints: TALGLIBInteger;
    xy: TMatrix;
    ntrees: TALGLIBInteger;
    model: Tdecisionforest;
    rep: Tdfreport;
    x: TVector;
    y: TVector;
    y0: Double;
    i: TALGLIBInteger;

begin
    Result:=True;
    try
        builder:=nil;
        model:=nil;

        //
        // The very simple regression example: model f(x,y)=x+y
        //
        // First, we have to create DF builder object, load dataset and specify
        // training settings. Our dataset is specified as matrix, which has following
        // format:
        //
        //     x0 y0 f0
        //     x1 y1 f1
        //     x2 y2 f2
        //     ....
        //
        // Here xi and yi can be any values, and fi is a dependent function value.
        //
        // NOTE: you can also solve classification problems with DF models, see
        //       another example for this unit.
        //
        nvars:=2;
        nclasses:=1;
        npoints:=4;
        xy:=Str2Matrix('[[1,1,+2],[1,-1,0],[-1,1,0],[-1,-1,-2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        dfbuildercreate(builder);
        dfbuildersetdataset(builder, xy, npoints, nvars, nclasses);

        // in our example we train decision forest using full sample - it allows us
        // to get zero classification error. However, in practical applications smaller
        // values are used: 50%, 25%, 5% or even less.
        dfbuildersetsubsampleratio(builder, 1.0);

        // we train random forest with just one tree; again, in real life situations
        // you typically need from 50 to 500 trees.
        ntrees:=1;
        dfbuilderbuildrandomforest(builder, ntrees, model, rep);

        // with such settings (full sample is used) you can expect zero RMS error on the
        // training set. Beautiful results, but remember - in real life you do not
        // need zero TRAINING SET error, you need good generalization.

        Result:=Result and doc_test_real(rep.rmserror, 0.0000, 0.00005);

        // now, let's perform some simple processing with dfprocess()
        x:=Str2Vector('[+1,+1]');
        y:=nil;
        dfprocess(model, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[+2]'), 0.0005);

        // another option is to use dfprocess0() which returns just first component
        // of the output vector y. ideal for regression problems and binary classifiers.
        y0:=dfprocess0(model, x);
        Result:=Result and doc_test_real(y0, 2.000, 0.0005);

        // there also exist another convenience function, dfclassify(),
        // but it does not work for regression problems - it always returns -1.
        i:=dfclassify(model, x);
        Result:=Result and doc_test_int(i, -1);

    finally
        FreeAndNil(builder);
        FreeAndNil(model);

    end;
end;


function _test_knn_cls(_spoil_scenario: Integer):Boolean;
var
    builder: Tknnbuilder;
    nvars: TALGLIBInteger;
    nclasses: TALGLIBInteger;
    npoints: TALGLIBInteger;
    xy: TMatrix;
    k: TALGLIBInteger;
    eps: Double;
    model: Tknnmodel;
    rep: Tknnreport;
    x: TVector;
    y: TVector;
    y0: Double;
    i: TALGLIBInteger;

begin
    Result:=True;
    try
        builder:=nil;
        model:=nil;

        //
        // The very simple classification example: classify points (x,y) in 2D space
        // as ones with x>=0 and ones with x<0 (y is ignored, but our classifier
        // has to find out it).
        //
        // First, we have to create KNN builder object, load dataset and specify
        // training settings. Our dataset is specified as matrix, which has following
        // format:
        //
        //     x0 y0 class0
        //     x1 y1 class1
        //     x2 y2 class2
        //     ....
        //
        // Here xi and yi can be any values (and in fact you can have any number of
        // independent variables), and classi MUST be integer number in [0,NClasses)
        // range. In our example we denote points with x>=0 as class #0, and
        // ones with negative xi as class #1.
        //
        // NOTE: if you want to solve regression problem, specify dataset in similar
        //       format, but with dependent variable(s) instead of class labels. You
        //       can have dataset with multiple dependent variables, by the way!
        //
        // For the sake of simplicity, our example includes only 4-point dataset and
        // really simple K=1 nearest neighbor search. Industrial problems typically
        // need larger values of K.
        //
        nvars:=2;
        nclasses:=2;
        npoints:=4;
        xy:=Str2Matrix('[[1,1,0],[1,-1,0],[-1,1,1],[-1,-1,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        knnbuildercreate(builder);
        knnbuildersetdatasetcls(builder, xy, npoints, nvars, nclasses);

        // we build KNN model with k=1 and eps=0 (exact k-nn search is performed)
        k:=1;
        eps:=0;
        knnbuilderbuildknnmodel(builder, k, eps, model, rep);

        // with such settings (k=1 is used) you can expect zero classification
        // error on training set. Beautiful results, but remember - in real life
        // you do not need zero TRAINING SET error, you need good generalization.

        Result:=Result and doc_test_real(rep.relclserror, 0.0000, 0.00005);

        // now, let's perform some simple processing with knnprocess()
        x:=Str2Vector('[+1,0]');
        y:=nil;
        knnprocess(model, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[+1,0]'), 0.0005);

        // another option is to use knnprocess0() which returns just first component
        // of the output vector y. ideal for regression problems and binary classifiers.
        y0:=knnprocess0(model, x);
        Result:=Result and doc_test_real(y0, 1.000, 0.0005);

        // finally, you can use knnclassify() which returns most probable class index (i.e. argmax y[i]).
        i:=knnclassify(model, x);
        Result:=Result and doc_test_int(i, 0);

    finally
        FreeAndNil(builder);
        FreeAndNil(model);

    end;
end;


function _test_knn_reg(_spoil_scenario: Integer):Boolean;
var
    builder: Tknnbuilder;
    nvars: TALGLIBInteger;
    nout: TALGLIBInteger;
    npoints: TALGLIBInteger;
    xy: TMatrix;
    k: TALGLIBInteger;
    eps: Double;
    model: Tknnmodel;
    rep: Tknnreport;
    x: TVector;
    y: TVector;
    y0: Double;
    i: TALGLIBInteger;

begin
    Result:=True;
    try
        builder:=nil;
        model:=nil;

        //
        // The very simple regression example: model f(x,y)=x+y
        //
        // First, we have to create KNN builder object, load dataset and specify
        // training settings. Our dataset is specified as matrix, which has following
        // format:
        //
        //     x0 y0 f0
        //     x1 y1 f1
        //     x2 y2 f2
        //     ....
        //
        // Here xi and yi can be any values, and fi is a dependent function value.
        // By the way, with KNN algorithm you can even model functions with multiple
        // dependent variables!
        //
        // NOTE: you can also solve classification problems with KNN models, see
        //       another example for this unit.
        //
        // For the sake of simplicity, our example includes only 4-point dataset and
        // really simple K=1 nearest neighbor search. Industrial problems typically
        // need larger values of K.
        //
        nvars:=2;
        nout:=1;
        npoints:=4;
        xy:=Str2Matrix('[[1,1,+2],[1,-1,0],[-1,1,0],[-1,-1,-2]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        knnbuildercreate(builder);
        knnbuildersetdatasetreg(builder, xy, npoints, nvars, nout);

        // we build KNN model with k=1 and eps=0 (exact k-nn search is performed)
        k:=1;
        eps:=0;
        knnbuilderbuildknnmodel(builder, k, eps, model, rep);

        // with such settings (k=1 is used) you can expect zero RMS error on the
        // training set. Beautiful results, but remember - in real life you do not
        // need zero TRAINING SET error, you need good generalization.

        Result:=Result and doc_test_real(rep.rmserror, 0.0000, 0.00005);

        // now, let's perform some simple processing with knnprocess()
        x:=Str2Vector('[+1,+1]');
        y:=nil;
        knnprocess(model, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[+2]'), 0.0005);

        // another option is to use knnprocess0() which returns just first component
        // of the output vector y. ideal for regression problems and binary classifiers.
        y0:=knnprocess0(model, x);
        Result:=Result and doc_test_real(y0, 2.000, 0.0005);

        // there also exist another convenience function, knnclassify(),
        // but it does not work for regression problems - it always returns -1.
        i:=knnclassify(model, x);
        Result:=Result and doc_test_int(i, -1);

    finally
        FreeAndNil(builder);
        FreeAndNil(model);

    end;
end;


function _test_autogk_d1(_spoil_scenario: Integer):Boolean;
var
    a: Double;
    b: Double;
    s: Tautogkstate;
    v: Double;
    rep: Tautogkreport;

begin
    Result:=True;
    try
        s:=nil;

        //
        // This example demonstrates integration of f=exp(x) on [0,1]:
        // * first, autogkstate is initialized
        // * then we call integration function
        // * and finally we obtain results with autogkresults() call
        //
        a:=0;
        if _spoil_scenario=0 then
            a:=Double(NaN);
        if _spoil_scenario=1 then
            a:=Double(Infinity);
        if _spoil_scenario=2 then
            a:=Double(NegInfinity);
        b:=1;
        if _spoil_scenario=3 then
            b:=Double(NaN);
        if _spoil_scenario=4 then
            b:=Double(Infinity);
        if _spoil_scenario=5 then
            b:=Double(NegInfinity);

        autogksmooth(a, b, s);
        autogkintegrate(s, int_function_1_func, nil);
        autogkresults(s, v, rep);

        Result:=Result and doc_test_real(v, 1.7182, 0.005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_fft_complex_d1(_spoil_scenario: Integer):Boolean;
var
    z: TCVector;

begin
    Result:=True;
    try

        //
        // first we demonstrate forward FFT:
        // [1i,1i,1i,1i] is converted to [4i, 0, 0, 0]
        //
        z:=Str2CVector('[1i,1i,1i,1i]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(z, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(z, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(z, C_Complex(NegInfinity));
        fftc1d(z);
        Result:=Result and doc_test_complex_vector(z, Str2CVector('[4i,0,0,0]'), 0.0001);

        //
        // now we convert [4i, 0, 0, 0] back to [1i,1i,1i,1i]
        // with backward FFT
        //
        fftc1dinv(z);
        Result:=Result and doc_test_complex_vector(z, Str2CVector('[1i,1i,1i,1i]'), 0.0001);

    finally

    end;
end;


function _test_fft_complex_d2(_spoil_scenario: Integer):Boolean;
var
    z: TCVector;

begin
    Result:=True;
    try

        //
        // first we demonstrate forward FFT:
        // [0,1,0,1i] is converted to [1+1i, -1-1i, -1-1i, 1+1i]
        //
        z:=Str2CVector('[0,1,0,1i]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(z, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(z, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(z, C_Complex(NegInfinity));
        fftc1d(z);
        Result:=Result and doc_test_complex_vector(z, Str2CVector('[1+1i, -1-1i, -1-1i, 1+1i]'), 0.0001);

        //
        // now we convert result back with backward FFT
        //
        fftc1dinv(z);
        Result:=Result and doc_test_complex_vector(z, Str2CVector('[0,1,0,1i]'), 0.0001);

    finally

    end;
end;


function _test_fft_real_d1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    f: TCVector;
    x2: TVector;

begin
    Result:=True;
    try

        //
        // first we demonstrate forward FFT:
        // [1,1,1,1] is converted to [4, 0, 0, 0]
        //
        x:=Str2Vector('[1,1,1,1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        fftr1d(x, f);
        Result:=Result and doc_test_complex_vector(f, Str2CVector('[4,0,0,0]'), 0.0001);

        //
        // now we convert [4, 0, 0, 0] back to [1,1,1,1]
        // with backward FFT
        //
        fftr1dinv(f, x2);
        Result:=Result and doc_test_real_vector(x2, Str2Vector('[1,1,1,1]'), 0.0001);

    finally

    end;
end;


function _test_fft_real_d2(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    f: TCVector;
    x2: TVector;

begin
    Result:=True;
    try

        //
        // first we demonstrate forward FFT:
        // [1,2,3,4] is converted to [10, -2+2i, -2, -2-2i]
        //
        // note that output array is self-adjoint:
        // * f[0] = conj(f[0])
        // * f[1] = conj(f[3])
        // * f[2] = conj(f[2])
        //
        x:=Str2Vector('[1,2,3,4]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        fftr1d(x, f);
        Result:=Result and doc_test_complex_vector(f, Str2CVector('[10, -2+2i, -2, -2-2i]'), 0.0001);

        //
        // now we convert [10, -2+2i, -2, -2-2i] back to [1,2,3,4]
        //
        fftr1dinv(f, x2);
        Result:=Result and doc_test_real_vector(x2, Str2Vector('[1,2,3,4]'), 0.0001);

        //
        // remember that F is self-adjoint? It means that we can pass just half
        // (slightly larger than half) of F to inverse real FFT and still get our result.
        //
        // I.e. instead [10, -2+2i, -2, -2-2i] we pass just [10, -2+2i, -2] and everything works!
        //
        // NOTE: in this case we should explicitly pass array length (which is 4) to ALGLIB;
        // if not, it will automatically use array length to determine FFT size and
        // will erroneously make half-length FFT.
        //
        f:=Str2CVector('[10, -2+2i, -2]');
        fftr1dinv(f, 4, x2);
        Result:=Result and doc_test_real_vector(x2, Str2Vector('[1,2,3,4]'), 0.0001);

    finally

    end;
end;


function _test_fft_complex_e1(_spoil_scenario: Integer):Boolean;
var
    z: TCVector;

begin
    Result:=True;
    try

        z:=Str2CVector('[0,2,0,-2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(z, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(z, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(z, C_Complex(NegInfinity));
        fftc1dinv(z);
        Result:=Result and doc_test_complex_vector(z, Str2CVector('[0,1i,0,-1i]'), 0.0001);

    finally

    end;
end;


function _test_idw_d_mstab(_spoil_scenario: Integer):Boolean;
var
    v: Double;
    builder: Tidwbuilder;
    xy: TMatrix;
    model: Tidwmodel;
    rep: Tidwreport;

begin
    Result:=True;
    try
        builder:=nil;
        model:=nil;

        //
        // This example illustrates basic concepts of the IDW models:
        // creation and evaluation.
        // 
        // Suppose that we have set of 2-dimensional points with associated
        // scalar function values, and we want to build an IDW model using
        // our data.
        // 
        // NOTE: we can work with N-dimensional models and vector-valued functions too :)
        // 
        // Typical sequence of steps is given below:
        // 1. we create IDW builder object
        // 2. we attach our dataset to the IDW builder and tune algorithm settings
        // 3. we generate IDW model
        // 4. we use IDW model instance (evaluate, serialize, etc.)
        //

        //
        // Step 1: IDW builder creation.
        //
        // We have to specify dimensionality of the space (2 or 3) and
        // dimensionality of the function (scalar or vector).
        //
        // New builder object is empty - it has not dataset and uses
        // default model construction settings
        //
        idwbuildercreate(2, 1, builder);

        //
        // Step 2: dataset addition
        //
        // XY contains two points - x0=(-1,0) and x1=(+1,0) -
        // and two function values f(x0)=2, f(x1)=3.
        //
        xy:=Str2Matrix('[[-1,0,2],[+1,0,3]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        idwbuildersetpoints(builder, xy);

        //
        // Step 3: choose IDW algorithm and generate model
        //
        // We use modified stabilized IDW algorithm with following parameters:
        // * SRad - set to 5.0 (search radius must be large enough)
        //
        // IDW-MSTAB algorithm is a state-of-the-art implementation of IDW which
        // is competitive with RBFs and bicubic splines. See comments on the
        // idwbuildersetalgomstab() function for more information.
        //
        idwbuildersetalgomstab(builder, 5.0);
        idwfit(builder, model, rep);

        //
        // Step 4: model was built, evaluate its value
        //
        v:=idwcalc2(model, 1.0, 0.0);
        Result:=Result and doc_test_real(v, 3.000, 0.005);

    finally
        FreeAndNil(builder);
        FreeAndNil(model);

    end;
end;


function _test_idw_d_serialize(_spoil_scenario: Integer):Boolean;
var
    s: AnsiString;
    v: Double;
    xy: TMatrix;
    builder: Tidwbuilder;
    model: Tidwmodel;
    model2: Tidwmodel;
    rep: Tidwreport;

begin
    Result:=True;
    try
        builder:=nil;
        model:=nil;
        model2:=nil;

        //
        // This example shows how to serialize and unserialize IDW model.
        // 
        // Suppose that we have set of 2-dimensional points with associated
        // scalar function values, and we have built an IDW model using
        // our data.
        //
        // This model can be serialized to string or stream. ALGLIB supports
        // flexible (un)serialization, i.e. you can move serialized model
        // representation between different machines (32-bit or 64-bit),
        // different CPU architectures (x86/64, ARM) or even different
        // programming languages supported by ALGLIB (C#, C++, ...).
        //
        // Our first step is to build model, evaluate it at point (1,0),
        // and serialize it to string.
        //
        xy:=Str2Matrix('[[-1,0,2],[+1,0,3]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        idwbuildercreate(2, 1, builder);
        idwbuildersetpoints(builder, xy);
        idwbuildersetalgomstab(builder, 5.0);
        idwfit(builder, model, rep);
        v:=idwcalc2(model, 1.0, 0.0);
        Result:=Result and doc_test_real(v, 3.000, 0.005);

        //
        // Serialization + unserialization to a different instance
        // of the model class.
        //
        idwserialize(model, s);
        idwunserialize(s, model2);

        //
        // Evaluate unserialized model at the same point
        //
        v:=idwcalc2(model2, 1.0, 0.0);
        Result:=Result and doc_test_real(v, 3.000, 0.005);

    finally
        FreeAndNil(builder);
        FreeAndNil(model);
        FreeAndNil(model2);

    end;
end;


function _test_spline1d_d_linear(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    t: Double;
    v: Double;
    s: Tspline1dinterpolant;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We use piecewise linear spline to interpolate f(x)=x^2 sampled 
        // at 5 equidistant nodes on [-1,+1].
        //
        x:=Str2Vector('[-1.0,-0.5,0.0,+0.5,+1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[+1.0,0.25,0.0,0.25,+1.0]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        t:=0.25;
        if _spoil_scenario=10 then
            t:=Double(Infinity);
        if _spoil_scenario=11 then
            t:=Double(NegInfinity);

        // build spline
        spline1dbuildlinear(x, y, s);

        // calculate S(0.25) - it is quite different from 0.25^2=0.0625
        v:=spline1dcalc(s, t);
        Result:=Result and doc_test_real(v, 0.125, 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_spline1d_d_cubic(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    t: Double;
    v: Double;
    s: Tspline1dinterpolant;
    natural_bound_type: TALGLIBInteger;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We use cubic spline to interpolate f(x)=x^2 sampled 
        // at 5 equidistant nodes on [-1,+1].
        //
        // First, we use default boundary conditions ("parabolically terminated
        // spline") because cubic spline built with such boundary conditions 
        // will exactly reproduce any quadratic f(x).
        //
        // Then we try to use natural boundary conditions
        //     d2S(-1)/dx^2 = 0.0
        //     d2S(+1)/dx^2 = 0.0
        // and see that such spline interpolated f(x) with small error.
        //
        x:=Str2Vector('[-1.0,-0.5,0.0,+0.5,+1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[+1.0,0.25,0.0,0.25,+1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        t:=0.25;
        if _spoil_scenario=8 then
            t:=Double(Infinity);
        if _spoil_scenario=9 then
            t:=Double(NegInfinity);
        natural_bound_type:=2;
        //
        // Test exact boundary conditions: build S(x), calculare S(0.25)
        // (almost same as original function)
        //
        spline1dbuildcubic(x, y, s);
        v:=spline1dcalc(s, t);
        Result:=Result and doc_test_real(v, 0.0625, 0.00001);

        //
        // Test natural boundary conditions: build S(x), calculare S(0.25)
        // (small interpolation error)
        //
        FreeAndNil( s);
        spline1dbuildcubic(x, y, 5, natural_bound_type, 0.0, natural_bound_type, 0.0, s);
        v:=spline1dcalc(s, t);
        Result:=Result and doc_test_real(v, 0.0580, 0.0001);

    finally
        FreeAndNil(s);

    end;
end;


function _test_spline1d_d_monotone(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    s: Tspline1dinterpolant;
    v: Double;

begin
    Result:=True;
    try
        s:=nil;

        //
        // Spline built witn spline1dbuildcubic() can be non-monotone even when
        // Y-values form monotone sequence. Say, for x=[0,1,2] and y=[0,1,1]
        // cubic spline will monotonically grow until x=1.5 and then start
        // decreasing.
        //
        // That's why ALGLIB provides special spline construction function
        // which builds spline which preserves monotonicity of the original
        // dataset.
        //
        // NOTE: in case original dataset is non-monotonic, ALGLIB splits it
        // into monotone subsequences and builds piecewise monotonic spline.
        //
        x:=Str2Vector('[0,1,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0,1,1]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);

        // build spline
        spline1dbuildmonotone(x, y, s);

        // calculate S at x = [-0.5, 0.0, 0.5, 1.0, 1.5, 2.0]
        // you may see that spline is really monotonic
        v:=spline1dcalc(s, -0.5);
        Result:=Result and doc_test_real(v, 0.0000, 0.00005);
        v:=spline1dcalc(s, 0.0);
        Result:=Result and doc_test_real(v, 0.0000, 0.00005);
        v:=spline1dcalc(s, +0.5);
        Result:=Result and doc_test_real(v, 0.5000, 0.00005);
        v:=spline1dcalc(s, 1.0);
        Result:=Result and doc_test_real(v, 1.0000, 0.00005);
        v:=spline1dcalc(s, 1.5);
        Result:=Result and doc_test_real(v, 1.0000, 0.00005);
        v:=spline1dcalc(s, 2.0);
        Result:=Result and doc_test_real(v, 1.0000, 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_spline1d_d_griddiff(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    d1: TVector;
    d2: TVector;

begin
    Result:=True;
    try

        //
        // We use cubic spline to do grid differentiation, i.e. having
        // values of f(x)=x^2 sampled at 5 equidistant nodes on [-1,+1]
        // we calculate derivatives of cubic spline at nodes WITHOUT
        // CONSTRUCTION OF SPLINE OBJECT.
        //
        // There are efficient functions spline1dgriddiffcubic() and
        // spline1dgriddiff2cubic() for such calculations.
        //
        // We use default boundary conditions ("parabolically terminated
        // spline") because cubic spline built with such boundary conditions 
        // will exactly reproduce any quadratic f(x).
        //
        // Actually, we could use natural conditions, but we feel that 
        // spline which exactly reproduces f() will show us more 
        // understandable results.
        //
        x:=Str2Vector('[-1.0,-0.5,0.0,+0.5,+1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[+1.0,0.25,0.0,0.25,+1.0]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);

        //
        // We calculate first derivatives: they must be equal to 2*x
        //
        spline1dgriddiffcubic(x, y, d1);
        Result:=Result and doc_test_real_vector(d1, Str2Vector('[-2.0, -1.0, 0.0, +1.0, +2.0]'), 0.0001);

        //
        // Now test griddiff2, which returns first AND second derivatives.
        // First derivative is 2*x, second is equal to 2.0
        //
        spline1dgriddiff2cubic(x, y, d1, d2);
        Result:=Result and doc_test_real_vector(d1, Str2Vector('[-2.0, -1.0, 0.0, +1.0, +2.0]'), 0.0001);
        Result:=Result and doc_test_real_vector(d2, Str2Vector('[ 2.0,  2.0, 2.0,  2.0,  2.0]'), 0.0001);

    finally

    end;
end;


function _test_spline1d_d_convdiff(_spoil_scenario: Integer):Boolean;
var
    x_old: TVector;
    y_old: TVector;
    x_new: TVector;
    y_new: TVector;
    d1_new: TVector;
    d2_new: TVector;

begin
    Result:=True;
    try

        //
        // We use cubic spline to do resampling, i.e. having
        // values of f(x)=x^2 sampled at 5 equidistant nodes on [-1,+1]
        // we calculate values/derivatives of cubic spline on 
        // another grid (equidistant with 9 nodes on [-1,+1])
        // WITHOUT CONSTRUCTION OF SPLINE OBJECT.
        //
        // There are efficient functions spline1dconvcubic(),
        // spline1dconvdiffcubic() and spline1dconvdiff2cubic() 
        // for such calculations.
        //
        // We use default boundary conditions ("parabolically terminated
        // spline") because cubic spline built with such boundary conditions 
        // will exactly reproduce any quadratic f(x).
        //
        // Actually, we could use natural conditions, but we feel that 
        // spline which exactly reproduces f() will show us more 
        // understandable results.
        //
        x_old:=Str2Vector('[-1.0,-0.5,0.0,+0.5,+1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x_old, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x_old, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x_old, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x_old);
        y_old:=Str2Vector('[+1.0,0.25,0.0,0.25,+1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y_old, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y_old, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y_old, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y_old);
        x_new:=Str2Vector('[-1.00,-0.75,-0.50,-0.25,0.00,+0.25,+0.50,+0.75,+1.00]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(x_new, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(x_new, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(x_new, Double(NegInfinity));

        //
        // First, conversion without differentiation.
        //
        //
        spline1dconvcubic(x_old, y_old, x_new, y_new);
        Result:=Result and doc_test_real_vector(y_new, Str2Vector('[1.0000, 0.5625, 0.2500, 0.0625, 0.0000, 0.0625, 0.2500, 0.5625, 1.0000]'), 0.0001);

        //
        // Then, conversion with differentiation (first derivatives only)
        //
        //
        spline1dconvdiffcubic(x_old, y_old, x_new, y_new, d1_new);
        Result:=Result and doc_test_real_vector(y_new, Str2Vector('[1.0000, 0.5625, 0.2500, 0.0625, 0.0000, 0.0625, 0.2500, 0.5625, 1.0000]'), 0.0001);
        Result:=Result and doc_test_real_vector(d1_new, Str2Vector('[-2.0, -1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.5, 2.0]'), 0.0001);

        //
        // Finally, conversion with first and second derivatives
        //
        //
        spline1dconvdiff2cubic(x_old, y_old, x_new, y_new, d1_new, d2_new);
        Result:=Result and doc_test_real_vector(y_new, Str2Vector('[1.0000, 0.5625, 0.2500, 0.0625, 0.0000, 0.0625, 0.2500, 0.5625, 1.0000]'), 0.0001);
        Result:=Result and doc_test_real_vector(d1_new, Str2Vector('[-2.0, -1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.5, 2.0]'), 0.0001);
        Result:=Result and doc_test_real_vector(d2_new, Str2Vector('[2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]'), 0.0001);

    finally

    end;
end;


function _test_parametric_rdp(_spoil_scenario: Integer):Boolean;
var
    npoints: TALGLIBInteger;
    ndimensions: TALGLIBInteger;
    x: TMatrix;
    y: TMatrix;
    idxy: TIVector;
    nsections: TALGLIBInteger;
    limitcnt: TALGLIBInteger;
    limiteps: Double;

begin
    Result:=True;
    try

        //
        // We use RDP algorithm to approximate parametric 2D curve given by
        // locations in t=0,1,2,3 (see below), which form piecewise linear
        // trajectory through D-dimensional space (2-dimensional in our example).
        // 
        //     |
        //     |
        //     -     *     *     X2................X3
        //     |                .
        //     |               .
        //     -     *     *  .  *     *     *     *
        //     |             .
        //     |            .
        //     -     *     X1    *     *     *     *
        //     |      .....
        //     |  ....
        //     X0----|-----|-----|-----|-----|-----|---
        //
        npoints:=4;
        ndimensions:=2;
        x:=Str2Matrix('[[0,0],[2,1],[3,3],[6,3]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(x);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(x);

        //
        // Approximation of parametric curve is performed by another parametric curve
        // with lesser amount of points. It allows to work with "compressed"
        // representation, which needs smaller amount of memory. Say, in our example
        // (we allow points with error smaller than 0.8) approximation will have
        // just two sequential sections connecting X0 with X2, and X2 with X3.
        // 
        //     |
        //     |
        //     -     *     *     X2................X3
        //     |               . 
        //     |             .  
        //     -     *     .     *     *     *     *
        //     |         .    
        //     |       .     
        //     -     .     X1    *     *     *     *
        //     |   .       
        //     | .    
        //     X0----|-----|-----|-----|-----|-----|---
        //
        //
        limitcnt:=0;
        limiteps:=0.8;
        if _spoil_scenario=5 then
            limiteps:=Double(Infinity);
        if _spoil_scenario=6 then
            limiteps:=Double(NegInfinity);
        parametricrdpfixed(x, npoints, ndimensions, limitcnt, limiteps, y, idxy, nsections);
        Result:=Result and doc_test_int(nsections, 2);
        Result:=Result and doc_test_int_vector(idxy, Str2IVector('[0,2,3]'));

    finally

    end;
end;


function _test_spline3d_trilinear(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    z: TVector;
    f: TVector;
    vx: Double;
    vy: Double;
    vz: Double;
    v: Double;
    s: Tspline3dinterpolant;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We use trilinear spline to interpolate f(x,y,z)=x+xy+z sampled 
        // at (x,y,z) from [0.0, 1.0] X [0.0, 1.0] X [0.0, 1.0].
        //
        // We store x, y and z-values at local arrays with same names.
        // Function values are stored in the array F as follows:
        //     f[0]     (x,y,z) = (0,0,0)
        //     f[1]     (x,y,z) = (1,0,0)
        //     f[2]     (x,y,z) = (0,1,0)
        //     f[3]     (x,y,z) = (1,1,0)
        //     f[4]     (x,y,z) = (0,0,1)
        //     f[5]     (x,y,z) = (1,0,1)
        //     f[6]     (x,y,z) = (0,1,1)
        //     f[7]     (x,y,z) = (1,1,1)
        //
        x:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        z:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(z, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(z, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(z, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(z);
        f:=Str2Vector('[0,1,0,2,1,2,1,3]');
        if _spoil_scenario=12 then
            spoil_vector_by_value(f, Double(NaN));
        if _spoil_scenario=13 then
            spoil_vector_by_value(f, Double(Infinity));
        if _spoil_scenario=14 then
            spoil_vector_by_value(f, Double(NegInfinity));
        if _spoil_scenario=15 then
            spoil_vector_by_deleting_element(f);
        vx:=0.50;
        if _spoil_scenario=16 then
            vx:=Double(Infinity);
        if _spoil_scenario=17 then
            vx:=Double(NegInfinity);
        vy:=0.50;
        if _spoil_scenario=18 then
            vy:=Double(Infinity);
        if _spoil_scenario=19 then
            vy:=Double(NegInfinity);
        vz:=0.50;
        if _spoil_scenario=20 then
            vz:=Double(Infinity);
        if _spoil_scenario=21 then
            vz:=Double(NegInfinity);

        // build spline
        spline3dbuildtrilinearv(x, 2, y, 2, z, 2, f, 1, s);

        // calculate S(0.5,0.5,0.5)
        v:=spline3dcalc(s, vx, vy, vz);
        Result:=Result and doc_test_real(v, 1.2500, 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_spline3d_vector(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    z: TVector;
    f: TVector;
    vx: Double;
    vy: Double;
    vz: Double;
    s: Tspline3dinterpolant;
    v: TVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We use trilinear vector-valued spline to interpolate {f0,f1}={x+xy+z,x+xy+yz+z}
        // sampled at (x,y,z) from [0.0, 1.0] X [0.0, 1.0] X [0.0, 1.0].
        //
        // We store x, y and z-values at local arrays with same names.
        // Function values are stored in the array F as follows:
        //     f[0]     f0, (x,y,z) = (0,0,0)
        //     f[1]     f1, (x,y,z) = (0,0,0)
        //     f[2]     f0, (x,y,z) = (1,0,0)
        //     f[3]     f1, (x,y,z) = (1,0,0)
        //     f[4]     f0, (x,y,z) = (0,1,0)
        //     f[5]     f1, (x,y,z) = (0,1,0)
        //     f[6]     f0, (x,y,z) = (1,1,0)
        //     f[7]     f1, (x,y,z) = (1,1,0)
        //     f[8]     f0, (x,y,z) = (0,0,1)
        //     f[9]     f1, (x,y,z) = (0,0,1)
        //     f[10]    f0, (x,y,z) = (1,0,1)
        //     f[11]    f1, (x,y,z) = (1,0,1)
        //     f[12]    f0, (x,y,z) = (0,1,1)
        //     f[13]    f1, (x,y,z) = (0,1,1)
        //     f[14]    f0, (x,y,z) = (1,1,1)
        //     f[15]    f1, (x,y,z) = (1,1,1)
        //
        x:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        z:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(z, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(z, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(z, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(z);
        f:=Str2Vector('[0,0, 1,1, 0,0, 2,2, 1,1, 2,2, 1,2, 3,4]');
        if _spoil_scenario=12 then
            spoil_vector_by_value(f, Double(NaN));
        if _spoil_scenario=13 then
            spoil_vector_by_value(f, Double(Infinity));
        if _spoil_scenario=14 then
            spoil_vector_by_value(f, Double(NegInfinity));
        if _spoil_scenario=15 then
            spoil_vector_by_deleting_element(f);
        vx:=0.50;
        if _spoil_scenario=16 then
            vx:=Double(Infinity);
        if _spoil_scenario=17 then
            vx:=Double(NegInfinity);
        vy:=0.50;
        if _spoil_scenario=18 then
            vy:=Double(Infinity);
        if _spoil_scenario=19 then
            vy:=Double(NegInfinity);
        vz:=0.50;
        if _spoil_scenario=20 then
            vz:=Double(Infinity);
        if _spoil_scenario=21 then
            vz:=Double(NegInfinity);

        // build spline
        spline3dbuildtrilinearv(x, 2, y, 2, z, 2, f, 2, s);

        // calculate S(0.5,0.5,0.5) - we have vector of values instead of single value
        spline3dcalcv(s, vx, vy, vz, v);
        Result:=Result and doc_test_real_vector(v, Str2Vector('[1.2500,1.5000]'), 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_polint_d_calcdiff(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    t: Double;
    v: Double;
    dv: Double;
    d2v: Double;
    p: Tbarycentricinterpolant;

begin
    Result:=True;
    try
        p:=nil;

        //
        // Here we demonstrate polynomial interpolation and differentiation
        // of y=x^2-x sampled at [0,1,2]. Barycentric representation of polynomial is used.
        //
        x:=Str2Vector('[0,1,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        t:=-1;
        if _spoil_scenario=10 then
            t:=Double(Infinity);
        if _spoil_scenario=11 then
            t:=Double(NegInfinity);

        // barycentric model is created
        polynomialbuild(x, y, p);

        // barycentric interpolation is demonstrated
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

        // barycentric differentation is demonstrated
        barycentricdiff1(p, t, v, dv);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);
        Result:=Result and doc_test_real(dv, -3.0, 0.00005);

        // second derivatives with barycentric representation
        barycentricdiff1(p, t, v, dv);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);
        Result:=Result and doc_test_real(dv, -3.0, 0.00005);
        barycentricdiff2(p, t, v, dv, d2v);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);
        Result:=Result and doc_test_real(dv, -3.0, 0.00005);
        Result:=Result and doc_test_real(d2v, 2.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_d_conv(_spoil_scenario: Integer):Boolean;
var
    a: TVector;
    t: Double;
    a2: TVector;
    v: Double;
    p: Tbarycentricinterpolant;

begin
    Result:=True;
    try
        p:=nil;

        //
        // Here we demonstrate conversion of y=x^2-x
        // between power basis and barycentric representation.
        //
        a:=Str2Vector('[0,-1,+1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(a, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(a, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(a, Double(NegInfinity));
        t:=2;
        if _spoil_scenario=3 then
            t:=Double(Infinity);
        if _spoil_scenario=4 then
            t:=Double(NegInfinity);

        //
        // a=[0,-1,+1] is decomposition of y=x^2-x in the power basis:
        //
        //     y = 0 - 1*x + 1*x^2
        //
        // We convert it to the barycentric form.
        //
        polynomialpow2bar(a, p);

        // now we have barycentric interpolation; we can use it for interpolation
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.0, 0.005);

        // we can also convert back from barycentric representation to power basis
        polynomialbar2pow(p, a2);
        Result:=Result and doc_test_real_vector(a2, Str2Vector('[0,-1,+1]'), 0.005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_d_spec(_spoil_scenario: Integer):Boolean;
var
    y_eqdist: TVector;
    y_cheb1: TVector;
    y_cheb2: TVector;
    p_eqdist: Tbarycentricinterpolant;
    p_cheb1: Tbarycentricinterpolant;
    p_cheb2: Tbarycentricinterpolant;
    a_eqdist: TVector;
    a_cheb1: TVector;
    a_cheb2: TVector;
    t: Double;
    v: Double;

begin
    Result:=True;
    try
        p_eqdist:=nil;
        p_cheb1:=nil;
        p_cheb2:=nil;

        //
        // Temporaries:
        // * values of y=x^2-x sampled at three special grids:
        //   * equdistant grid spanning [0,2],     x[i] = 2*i/(N-1), i=0..N-1
        //   * Chebyshev-I grid spanning [-1,+1],  x[i] = 1 + Cos(PI*(2*i+1)/(2*n)), i=0..N-1
        //   * Chebyshev-II grid spanning [-1,+1], x[i] = 1 + Cos(PI*i/(n-1)), i=0..N-1
        // * barycentric interpolants for these three grids
        // * vectors to store coefficients of quadratic representation
        //
        y_eqdist:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y_eqdist, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y_eqdist, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y_eqdist, Double(NegInfinity));
        y_cheb1:=Str2Vector('[-0.116025,0.000000,1.616025]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(y_cheb1, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(y_cheb1, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y_cheb1, Double(NegInfinity));
        y_cheb2:=Str2Vector('[0,0,2]');
        if _spoil_scenario=6 then
            spoil_vector_by_value(y_cheb2, Double(NaN));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y_cheb2, Double(Infinity));
        if _spoil_scenario=8 then
            spoil_vector_by_value(y_cheb2, Double(NegInfinity));

        //
        // First, we demonstrate construction of barycentric interpolants on
        // special grids. We unpack power representation to ensure that
        // interpolant was built correctly.
        //
        // In all three cases we should get same quadratic function.
        //
        polynomialbuildeqdist(0.0, 2.0, y_eqdist, p_eqdist);
        polynomialbar2pow(p_eqdist, a_eqdist);
        Result:=Result and doc_test_real_vector(a_eqdist, Str2Vector('[0,-1,+1]'), 0.00005);

        polynomialbuildcheb1(-1, +1, y_cheb1, p_cheb1);
        polynomialbar2pow(p_cheb1, a_cheb1);
        Result:=Result and doc_test_real_vector(a_cheb1, Str2Vector('[0,-1,+1]'), 0.00005);

        polynomialbuildcheb2(-1, +1, y_cheb2, p_cheb2);
        polynomialbar2pow(p_cheb2, a_cheb2);
        Result:=Result and doc_test_real_vector(a_cheb2, Str2Vector('[0,-1,+1]'), 0.00005);

        //
        // Now we demonstrate polynomial interpolation without construction 
        // of the barycentricinterpolant structure.
        //
        // We calculate interpolant value at x=-2.
        // In all three cases we should get same f=6
        //
        t:=-2;
        if _spoil_scenario=9 then
            t:=Double(Infinity);
        if _spoil_scenario=10 then
            t:=Double(NegInfinity);
        v:=polynomialcalceqdist(0.0, 2.0, y_eqdist, t);
        Result:=Result and doc_test_real(v, 6.0, 0.00005);

        v:=polynomialcalccheb1(-1, +1, y_cheb1, t);
        Result:=Result and doc_test_real(v, 6.0, 0.00005);

        v:=polynomialcalccheb2(-1, +1, y_cheb2, t);
        Result:=Result and doc_test_real(v, 6.0, 0.00005);

    finally
        FreeAndNil(p_eqdist);
        FreeAndNil(p_cheb1);
        FreeAndNil(p_cheb2);

    end;
end;


function _test_polint_t_1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    t: Double;
    p: Tbarycentricinterpolant;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        x:=Str2Vector('[0,1,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        t:=-1;
        if _spoil_scenario=8 then
            t:=Double(Infinity);
        if _spoil_scenario=9 then
            t:=Double(NegInfinity);
        polynomialbuild(x, y, 3, p);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_t_2(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    p: Tbarycentricinterpolant;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(y);
        t:=-1;
        if _spoil_scenario=4 then
            t:=Double(Infinity);
        if _spoil_scenario=5 then
            t:=Double(NegInfinity);
        polynomialbuildeqdist(0.0, 2.0, y, 3, p);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_t_3(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    p: Tbarycentricinterpolant;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        y:=Str2Vector('[-0.116025,0.000000,1.616025]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(y);
        t:=-1;
        if _spoil_scenario=4 then
            t:=Double(Infinity);
        if _spoil_scenario=5 then
            t:=Double(NegInfinity);
        polynomialbuildcheb1(-1.0, +1.0, y, 3, p);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_t_4(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    a: Double;
    b: Double;
    p: Tbarycentricinterpolant;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(y);
        t:=-2;
        if _spoil_scenario=4 then
            t:=Double(Infinity);
        if _spoil_scenario=5 then
            t:=Double(NegInfinity);
        a:=-1;
        if _spoil_scenario=6 then
            a:=Double(NaN);
        if _spoil_scenario=7 then
            a:=Double(Infinity);
        if _spoil_scenario=8 then
            a:=Double(NegInfinity);
        b:=+1;
        if _spoil_scenario=9 then
            b:=Double(NaN);
        if _spoil_scenario=10 then
            b:=Double(Infinity);
        if _spoil_scenario=11 then
            b:=Double(NegInfinity);
        polynomialbuildcheb2(a, b, y, 3, p);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 6.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_t_5(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    v: Double;

begin
    Result:=True;
    try

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(y);
        t:=-1;
        if _spoil_scenario=4 then
            t:=Double(Infinity);
        if _spoil_scenario=5 then
            t:=Double(NegInfinity);
        v:=polynomialcalceqdist(0.0, 2.0, y, 3, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally

    end;
end;


function _test_polint_t_6(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    a: Double;
    b: Double;
    v: Double;

begin
    Result:=True;
    try

        y:=Str2Vector('[-0.116025,0.000000,1.616025]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(y);
        t:=-1;
        if _spoil_scenario=4 then
            t:=Double(Infinity);
        if _spoil_scenario=5 then
            t:=Double(NegInfinity);
        a:=-1;
        if _spoil_scenario=6 then
            a:=Double(NaN);
        if _spoil_scenario=7 then
            a:=Double(Infinity);
        if _spoil_scenario=8 then
            a:=Double(NegInfinity);
        b:=+1;
        if _spoil_scenario=9 then
            b:=Double(NaN);
        if _spoil_scenario=10 then
            b:=Double(Infinity);
        if _spoil_scenario=11 then
            b:=Double(NegInfinity);
        v:=polynomialcalccheb1(a, b, y, 3, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally

    end;
end;


function _test_polint_t_7(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    a: Double;
    b: Double;
    v: Double;

begin
    Result:=True;
    try

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(y);
        t:=-2;
        if _spoil_scenario=4 then
            t:=Double(Infinity);
        if _spoil_scenario=5 then
            t:=Double(NegInfinity);
        a:=-1;
        if _spoil_scenario=6 then
            a:=Double(NaN);
        if _spoil_scenario=7 then
            a:=Double(Infinity);
        if _spoil_scenario=8 then
            a:=Double(NegInfinity);
        b:=+1;
        if _spoil_scenario=9 then
            b:=Double(NaN);
        if _spoil_scenario=10 then
            b:=Double(Infinity);
        if _spoil_scenario=11 then
            b:=Double(NegInfinity);
        v:=polynomialcalccheb2(a, b, y, 3, t);
        Result:=Result and doc_test_real(v, 6.0, 0.00005);

    finally

    end;
end;


function _test_polint_t_8(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    p: Tbarycentricinterpolant;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        t:=-1;
        if _spoil_scenario=3 then
            t:=Double(Infinity);
        if _spoil_scenario=4 then
            t:=Double(NegInfinity);
        polynomialbuildeqdist(0.0, 2.0, y, p);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_t_9(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    a: Double;
    b: Double;
    p: Tbarycentricinterpolant;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        y:=Str2Vector('[-0.116025,0.000000,1.616025]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        t:=-1;
        if _spoil_scenario=3 then
            t:=Double(Infinity);
        if _spoil_scenario=4 then
            t:=Double(NegInfinity);
        a:=-1;
        if _spoil_scenario=5 then
            a:=Double(NaN);
        if _spoil_scenario=6 then
            a:=Double(Infinity);
        if _spoil_scenario=7 then
            a:=Double(NegInfinity);
        b:=+1;
        if _spoil_scenario=8 then
            b:=Double(NaN);
        if _spoil_scenario=9 then
            b:=Double(Infinity);
        if _spoil_scenario=10 then
            b:=Double(NegInfinity);
        polynomialbuildcheb1(a, b, y, p);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_t_10(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    a: Double;
    b: Double;
    p: Tbarycentricinterpolant;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        t:=-2;
        if _spoil_scenario=3 then
            t:=Double(Infinity);
        if _spoil_scenario=4 then
            t:=Double(NegInfinity);
        a:=-1;
        if _spoil_scenario=5 then
            a:=Double(NaN);
        if _spoil_scenario=6 then
            a:=Double(Infinity);
        if _spoil_scenario=7 then
            a:=Double(NegInfinity);
        b:=+1;
        if _spoil_scenario=8 then
            b:=Double(NaN);
        if _spoil_scenario=9 then
            b:=Double(Infinity);
        if _spoil_scenario=10 then
            b:=Double(NegInfinity);
        polynomialbuildcheb2(a, b, y, p);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 6.0, 0.00005);

    finally
        FreeAndNil(p);

    end;
end;


function _test_polint_t_11(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    v: Double;

begin
    Result:=True;
    try

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        t:=-1;
        if _spoil_scenario=3 then
            t:=Double(Infinity);
        if _spoil_scenario=4 then
            t:=Double(NegInfinity);
        v:=polynomialcalceqdist(0.0, 2.0, y, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally

    end;
end;


function _test_polint_t_12(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    a: Double;
    b: Double;
    v: Double;

begin
    Result:=True;
    try

        y:=Str2Vector('[-0.116025,0.000000,1.616025]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        t:=-1;
        if _spoil_scenario=3 then
            t:=Double(Infinity);
        if _spoil_scenario=4 then
            t:=Double(NegInfinity);
        a:=-1;
        if _spoil_scenario=5 then
            a:=Double(NaN);
        if _spoil_scenario=6 then
            a:=Double(Infinity);
        if _spoil_scenario=7 then
            a:=Double(NegInfinity);
        b:=+1;
        if _spoil_scenario=8 then
            b:=Double(NaN);
        if _spoil_scenario=9 then
            b:=Double(Infinity);
        if _spoil_scenario=10 then
            b:=Double(NegInfinity);
        v:=polynomialcalccheb1(a, b, y, t);
        Result:=Result and doc_test_real(v, 2.0, 0.00005);

    finally

    end;
end;


function _test_polint_t_13(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    t: Double;
    a: Double;
    b: Double;
    v: Double;

begin
    Result:=True;
    try

        y:=Str2Vector('[0,0,2]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        t:=-2;
        if _spoil_scenario=3 then
            t:=Double(Infinity);
        if _spoil_scenario=4 then
            t:=Double(NegInfinity);
        a:=-1;
        if _spoil_scenario=5 then
            a:=Double(NaN);
        if _spoil_scenario=6 then
            a:=Double(Infinity);
        if _spoil_scenario=7 then
            a:=Double(NegInfinity);
        b:=+1;
        if _spoil_scenario=8 then
            b:=Double(NaN);
        if _spoil_scenario=9 then
            b:=Double(Infinity);
        if _spoil_scenario=10 then
            b:=Double(NegInfinity);
        v:=polynomialcalccheb2(a, b, y, t);
        Result:=Result and doc_test_real(v, 6.0, 0.00005);

    finally

    end;
end;


function _test_lsfit_d_nlf(_spoil_scenario: Integer):Boolean;
var
    x: TMatrix;
    y: TVector;
    c: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    info: TALGLIBInteger;
    state: Tlsfitstate;
    rep: Tlsfitreport;
    diffstep: Double;
    w: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // In this example we demonstrate exponential fitting
        // by f(x) = exp(-c*x^2)
        // using function value only.
        //
        // Gradient is estimated using combination of numerical differences
        // and secant updates. diffstep variable stores differentiation step 
        // (we have to tell algorithm what step to use).
        //
        x:=Str2Matrix('[[-1],[-0.8],[-0.6],[-0.4],[-0.2],[0],[0.2],[0.4],[0.6],[0.8],[1.0]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(x);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(x);
        y:=Str2Vector('[0.223130, 0.382893, 0.582748, 0.786628, 0.941765, 1.000000, 0.941765, 0.786628, 0.582748, 0.382893, 0.223130]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        c:=Str2Vector('[0.3]');
        if _spoil_scenario=10 then
            spoil_vector_by_value(c, Double(NaN));
        if _spoil_scenario=11 then
            spoil_vector_by_value(c, Double(Infinity));
        if _spoil_scenario=12 then
            spoil_vector_by_value(c, Double(NegInfinity));
        epsx:=0.000001;
        if _spoil_scenario=13 then
            epsx:=Double(NaN);
        if _spoil_scenario=14 then
            epsx:=Double(Infinity);
        if _spoil_scenario=15 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        diffstep:=0.0001;
        if _spoil_scenario=16 then
            diffstep:=Double(NaN);
        if _spoil_scenario=17 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=18 then
            diffstep:=Double(NegInfinity);

        //
        // Fitting without weights
        //
        lsfitcreatef(x, y, c, diffstep, state);
        lsfitsetcond(state, epsx, maxits);
        lsfitfit(state, function_cx_1_func, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_int(info, 2);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.5]'), 0.05);

        //
        // Fitting with weights
        // (you can change weights and see how it changes result)
        //
        w:=Str2Vector('[1,1,1,1,1,1,1,1,1,1,1]');
        if _spoil_scenario=19 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=20 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=21 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=22 then
            spoil_vector_by_adding_element(w);
        if _spoil_scenario=23 then
            spoil_vector_by_deleting_element(w);
        FreeAndNil(state);
        lsfitcreatewf(x, y, w, c, diffstep, state);
        lsfitsetcond(state, epsx, maxits);
        lsfitfit(state, function_cx_1_func, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_int(info, 2);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.5]'), 0.05);

    finally
        FreeAndNil(state);

    end;
end;


function _test_lsfit_d_nlfg(_spoil_scenario: Integer):Boolean;
var
    x: TMatrix;
    y: TVector;
    c: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    info: TALGLIBInteger;
    state: Tlsfitstate;
    rep: Tlsfitreport;
    w: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // In this example we demonstrate exponential fitting
        // by f(x) = exp(-c*x^2)
        // using function value and gradient (with respect to c).
        //
        x:=Str2Matrix('[[-1],[-0.8],[-0.6],[-0.4],[-0.2],[0],[0.2],[0.4],[0.6],[0.8],[1.0]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(x);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(x);
        y:=Str2Vector('[0.223130, 0.382893, 0.582748, 0.786628, 0.941765, 1.000000, 0.941765, 0.786628, 0.582748, 0.382893, 0.223130]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        c:=Str2Vector('[0.3]');
        if _spoil_scenario=10 then
            spoil_vector_by_value(c, Double(NaN));
        if _spoil_scenario=11 then
            spoil_vector_by_value(c, Double(Infinity));
        if _spoil_scenario=12 then
            spoil_vector_by_value(c, Double(NegInfinity));
        epsx:=0.000001;
        if _spoil_scenario=13 then
            epsx:=Double(NaN);
        if _spoil_scenario=14 then
            epsx:=Double(Infinity);
        if _spoil_scenario=15 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // Fitting without weights
        //
        lsfitcreatefg(x, y, c, true, state);
        lsfitsetcond(state, epsx, maxits);
        lsfitfit(state, function_cx_1_func, function_cx_1_grad, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_int(info, 2);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.5]'), 0.05);

        //
        // Fitting with weights
        // (you can change weights and see how it changes result)
        //
        w:=Str2Vector('[1,1,1,1,1,1,1,1,1,1,1]');
        if _spoil_scenario=16 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=17 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=18 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=19 then
            spoil_vector_by_adding_element(w);
        if _spoil_scenario=20 then
            spoil_vector_by_deleting_element(w);
        FreeAndNil(state);
        lsfitcreatewfg(x, y, w, c, true, state);
        lsfitsetcond(state, epsx, maxits);
        lsfitfit(state, function_cx_1_func, function_cx_1_grad, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_int(info, 2);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.5]'), 0.05);

    finally
        FreeAndNil(state);

    end;
end;


function _test_lsfit_d_nlfgh(_spoil_scenario: Integer):Boolean;
var
    x: TMatrix;
    y: TVector;
    c: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    info: TALGLIBInteger;
    state: Tlsfitstate;
    rep: Tlsfitreport;
    w: TVector;

begin
    Result:=True;
    try
        state:=nil;

        //
        // In this example we demonstrate exponential fitting
        // by f(x) = exp(-c*x^2)
        // using function value, gradient and Hessian (with respect to c)
        //
        x:=Str2Matrix('[[-1],[-0.8],[-0.6],[-0.4],[-0.2],[0],[0.2],[0.4],[0.6],[0.8],[1.0]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(x);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(x);
        y:=Str2Vector('[0.223130, 0.382893, 0.582748, 0.786628, 0.941765, 1.000000, 0.941765, 0.786628, 0.582748, 0.382893, 0.223130]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        c:=Str2Vector('[0.3]');
        if _spoil_scenario=10 then
            spoil_vector_by_value(c, Double(NaN));
        if _spoil_scenario=11 then
            spoil_vector_by_value(c, Double(Infinity));
        if _spoil_scenario=12 then
            spoil_vector_by_value(c, Double(NegInfinity));
        epsx:=0.000001;
        if _spoil_scenario=13 then
            epsx:=Double(NaN);
        if _spoil_scenario=14 then
            epsx:=Double(Infinity);
        if _spoil_scenario=15 then
            epsx:=Double(NegInfinity);
        maxits:=0;

        //
        // Fitting without weights
        //
        lsfitcreatefgh(x, y, c, state);
        lsfitsetcond(state, epsx, maxits);
        lsfitfit(state, function_cx_1_func, function_cx_1_grad, function_cx_1_hess, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_int(info, 2);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.5]'), 0.05);

        //
        // Fitting with weights
        // (you can change weights and see how it changes result)
        //
        w:=Str2Vector('[1,1,1,1,1,1,1,1,1,1,1]');
        if _spoil_scenario=16 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=17 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=18 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=19 then
            spoil_vector_by_adding_element(w);
        if _spoil_scenario=20 then
            spoil_vector_by_deleting_element(w);
        FreeAndNil(state);
        lsfitcreatewfgh(x, y, w, c, state);
        lsfitsetcond(state, epsx, maxits);
        lsfitfit(state, function_cx_1_func, function_cx_1_grad, function_cx_1_hess, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_int(info, 2);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.5]'), 0.05);

    finally
        FreeAndNil(state);

    end;
end;


function _test_lsfit_d_nlfb(_spoil_scenario: Integer):Boolean;
var
    x: TMatrix;
    y: TVector;
    c: TVector;
    bndl: TVector;
    bndu: TVector;
    epsx: Double;
    maxits: TALGLIBInteger;
    info: TALGLIBInteger;
    state: Tlsfitstate;
    rep: Tlsfitreport;
    diffstep: Double;

begin
    Result:=True;
    try
        state:=nil;

        //
        // In this example we demonstrate exponential fitting by
        //     f(x) = exp(-c*x^2)
        // subject to bound constraints
        //     0.0 <= c <= 1.0
        // using function value only.
        //
        // Gradient is estimated using combination of numerical differences
        // and secant updates. diffstep variable stores differentiation step 
        // (we have to tell algorithm what step to use).
        //
        // Unconstrained solution is c=1.5, but because of constraints we should
        // get c=1.0 (at the boundary).
        //
        x:=Str2Matrix('[[-1],[-0.8],[-0.6],[-0.4],[-0.2],[0],[0.2],[0.4],[0.6],[0.8],[1.0]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(x);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(x);
        y:=Str2Vector('[0.223130, 0.382893, 0.582748, 0.786628, 0.941765, 1.000000, 0.941765, 0.786628, 0.582748, 0.382893, 0.223130]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        c:=Str2Vector('[0.3]');
        if _spoil_scenario=10 then
            spoil_vector_by_value(c, Double(NaN));
        if _spoil_scenario=11 then
            spoil_vector_by_value(c, Double(Infinity));
        if _spoil_scenario=12 then
            spoil_vector_by_value(c, Double(NegInfinity));
        bndl:=Str2Vector('[0.0]');
        if _spoil_scenario=13 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=14 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[1.0]');
        if _spoil_scenario=15 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=16 then
            spoil_vector_by_deleting_element(bndu);
        epsx:=0.000001;
        if _spoil_scenario=17 then
            epsx:=Double(NaN);
        if _spoil_scenario=18 then
            epsx:=Double(Infinity);
        if _spoil_scenario=19 then
            epsx:=Double(NegInfinity);
        maxits:=0;
        diffstep:=0.0001;
        if _spoil_scenario=20 then
            diffstep:=Double(NaN);
        if _spoil_scenario=21 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=22 then
            diffstep:=Double(NegInfinity);

        lsfitcreatef(x, y, c, diffstep, state);
        lsfitsetbc(state, bndl, bndu);
        lsfitsetcond(state, epsx, maxits);
        lsfitfit(state, function_cx_1_func, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.0]'), 0.05);

    finally
        FreeAndNil(state);

    end;
end;


function _test_lsfit_d_nlscale(_spoil_scenario: Integer):Boolean;
var
    x: TMatrix;
    y: TVector;
    c: TVector;
    epsx: Double;
    bndl: TVector;
    bndu: TVector;
    s: TVector;
    maxits: TALGLIBInteger;
    info: TALGLIBInteger;
    state: Tlsfitstate;
    rep: Tlsfitreport;
    diffstep: Double;

begin
    Result:=True;
    try
        state:=nil;

        //
        // In this example we demonstrate fitting by
        //     f(x) = c[0]*(1+c[1]*((x-1999)^c[2]-1))
        // subject to bound constraints
        //     -INF  < c[0] < +INF
        //      -10 <= c[1] <= +10
        //      0.1 <= c[2] <= 2.0
        // Data we want to fit are time series of Japan national debt
        // collected from 2000 to 2008 measured in USD (dollars, not
        // millions of dollars).
        //
        // Our variables are:
        //     c[0] - debt value at initial moment (2000),
        //     c[1] - direction coefficient (growth or decrease),
        //     c[2] - curvature coefficient.
        // You may see that our variables are badly scaled - first one 
        // is order of 10^12, and next two are somewhere about 1 in 
        // magnitude. Such problem is difficult to solve without some
        // kind of scaling.
        // That is exactly where lsfitsetscale() function can be used.
        // We set scale of our variables to [1.0E12, 1, 1], which allows
        // us to easily solve this problem.
        //
        // You can try commenting out lsfitsetscale() call - and you will 
        // see that algorithm will fail to converge.
        //
        x:=Str2Matrix('[[2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(x);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(x);
        y:=Str2Vector('[4323239600000.0, 4560913100000.0, 5564091500000.0, 6743189300000.0, 7284064600000.0, 7050129600000.0, 7092221500000.0, 8483907600000.0, 8625804400000.0]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        c:=Str2Vector('[1.0e+13, 1, 1]');
        if _spoil_scenario=10 then
            spoil_vector_by_value(c, Double(NaN));
        if _spoil_scenario=11 then
            spoil_vector_by_value(c, Double(Infinity));
        if _spoil_scenario=12 then
            spoil_vector_by_value(c, Double(NegInfinity));
        epsx:=1.0e-5;
        if _spoil_scenario=13 then
            epsx:=Double(NaN);
        if _spoil_scenario=14 then
            epsx:=Double(Infinity);
        if _spoil_scenario=15 then
            epsx:=Double(NegInfinity);
        bndl:=Str2Vector('[-inf, -10, 0.1]');
        if _spoil_scenario=16 then
            spoil_vector_by_value(bndl, Double(NaN));
        if _spoil_scenario=17 then
            spoil_vector_by_deleting_element(bndl);
        bndu:=Str2Vector('[+inf, +10, 2.0]');
        if _spoil_scenario=18 then
            spoil_vector_by_value(bndu, Double(NaN));
        if _spoil_scenario=19 then
            spoil_vector_by_deleting_element(bndu);
        s:=Str2Vector('[1.0e+12, 1, 1]');
        if _spoil_scenario=20 then
            spoil_vector_by_value(s, Double(NaN));
        if _spoil_scenario=21 then
            spoil_vector_by_value(s, Double(Infinity));
        if _spoil_scenario=22 then
            spoil_vector_by_value(s, Double(NegInfinity));
        if _spoil_scenario=23 then
            spoil_vector_by_deleting_element(s);
        maxits:=0;
        diffstep:=1.0e-5;
        if _spoil_scenario=24 then
            diffstep:=Double(NaN);
        if _spoil_scenario=25 then
            diffstep:=Double(Infinity);
        if _spoil_scenario=26 then
            diffstep:=Double(NegInfinity);

        lsfitcreatef(x, y, c, diffstep, state);
        lsfitsetcond(state, epsx, maxits);
        lsfitsetbc(state, bndl, bndu);
        lsfitsetscale(state, s);
        lsfitfit(state, function_debt_func, nil, nil);
        lsfitresults(state, info, c, rep);
        Result:=Result and doc_test_int(info, 2);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[4.142560e+12, 0.434240, 0.565376]'), -0.005);

    finally
        FreeAndNil(state);

    end;
end;


function _test_lsfit_d_lin(_spoil_scenario: Integer):Boolean;
var
    fmatrix: TMatrix;
    y: TVector;
    info: TALGLIBInteger;
    c: TVector;
    rep: Tlsfitreport;
    w: TVector;

begin
    Result:=True;
    try

        //
        // In this example we demonstrate linear fitting by f(x|a) = a*exp(0.5*x).
        //
        // We have:
        // * y - vector of experimental data
        // * fmatrix -  matrix of basis functions calculated at sample points
        //              Actually, we have only one basis function F0 = exp(0.5*x).
        //
        fmatrix:=Str2Matrix('[[0.606531],[0.670320],[0.740818],[0.818731],[0.904837],[1.000000],[1.105171],[1.221403],[1.349859],[1.491825],[1.648721]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(fmatrix, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(fmatrix, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(fmatrix, Double(NegInfinity));
        y:=Str2Vector('[1.133719, 1.306522, 1.504604, 1.554663, 1.884638, 2.072436, 2.257285, 2.534068, 2.622017, 2.897713, 3.219371]');
        if _spoil_scenario=3 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=6 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);

        //
        // Linear fitting without weights
        //
        lsfitlinear(y, fmatrix, info, c, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.98650]'), 0.00005);

        //
        // Linear fitting with individual weights.
        // Slightly different result is returned.
        //
        w:=Str2Vector('[1.414213, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_adding_element(w);
        if _spoil_scenario=12 then
            spoil_vector_by_deleting_element(w);
        lsfitlinearw(y, w, fmatrix, info, c, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[1.983354]'), 0.00005);

    finally

    end;
end;


function _test_lsfit_d_linc(_spoil_scenario: Integer):Boolean;
var
    y: TVector;
    fmatrix: TMatrix;
    cmatrix: TMatrix;
    info: TALGLIBInteger;
    c: TVector;
    rep: Tlsfitreport;
    w: TVector;

begin
    Result:=True;
    try

        //
        // In this example we demonstrate linear fitting by f(x|a,b) = a*x+b
        // with simple constraint f(0)=0.
        //
        // We have:
        // * y - vector of experimental data
        // * fmatrix -  matrix of basis functions sampled at [0,1] with step 0.2:
        //                  [ 1.0   0.0 ]
        //                  [ 1.0   0.2 ]
        //                  [ 1.0   0.4 ]
        //                  [ 1.0   0.6 ]
        //                  [ 1.0   0.8 ]
        //                  [ 1.0   1.0 ]
        //              first column contains value of first basis function (constant term)
        //              second column contains second basis function (linear term)
        // * cmatrix -  matrix of linear constraints:
        //                  [ 1.0  0.0  0.0 ]
        //              first two columns contain coefficients before basis functions,
        //              last column contains desired value of their sum.
        //              So [1,0,0] means "1*constant_term + 0*linear_term = 0" 
        //
        y:=Str2Vector('[0.072436,0.246944,0.491263,0.522300,0.714064,0.921929]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(y);
        fmatrix:=Str2Matrix('[[1,0.0],[1,0.2],[1,0.4],[1,0.6],[1,0.8],[1,1.0]]');
        if _spoil_scenario=5 then
            spoil_matrix_by_value(fmatrix, Double(NaN));
        if _spoil_scenario=6 then
            spoil_matrix_by_value(fmatrix, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_matrix_by_value(fmatrix, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_matrix_by_adding_row(fmatrix);
        if _spoil_scenario=9 then
            spoil_matrix_by_adding_col(fmatrix);
        if _spoil_scenario=10 then
            spoil_matrix_by_deleting_row(fmatrix);
        if _spoil_scenario=11 then
            spoil_matrix_by_deleting_col(fmatrix);
        cmatrix:=Str2Matrix('[[1,0,0]]');
        if _spoil_scenario=12 then
            spoil_matrix_by_value(cmatrix, Double(NaN));
        if _spoil_scenario=13 then
            spoil_matrix_by_value(cmatrix, Double(Infinity));
        if _spoil_scenario=14 then
            spoil_matrix_by_value(cmatrix, Double(NegInfinity));

        //
        // Constrained fitting without weights
        //
        lsfitlinearc(y, fmatrix, cmatrix, info, c, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[0,0.932933]'), 0.0005);

        //
        // Constrained fitting with individual weights
        //
        w:=Str2Vector('[1, 1.414213, 1, 1, 1, 1]');
        if _spoil_scenario=15 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=16 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=17 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=18 then
            spoil_vector_by_adding_element(w);
        if _spoil_scenario=19 then
            spoil_vector_by_deleting_element(w);
        lsfitlinearwc(y, w, fmatrix, cmatrix, info, c, rep);
        Result:=Result and doc_test_int(info, 1);
        Result:=Result and doc_test_real_vector(c, Str2Vector('[0,0.938322]'), 0.0005);

    finally

    end;
end;


function _test_lsfit_d_pol(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    m: TALGLIBInteger;
    t: Double;
    info: TALGLIBInteger;
    p: Tbarycentricinterpolant;
    rep: Tpolynomialfitreport;
    v: Double;
    w: TVector;
    xc: TVector;
    yc: TVector;
    dc: TIVector;

begin
    Result:=True;
    try
        p:=nil;

        //
        // This example demonstrates polynomial fitting.
        //
        // Fitting is done by two (M=2) functions from polynomial basis:
        //     f0 = 1
        //     f1 = x
        // Basically, it just a linear fit; more complex polynomials may be used
        // (e.g. parabolas with M=3, cubic with M=4), but even such simple fit allows
        // us to demonstrate polynomialfit() function in action.
        //
        // We have:
        // * x      set of abscissas
        // * y      experimental data
        //
        // Additionally we demonstrate weighted fitting, where second point has
        // more weight than other ones.
        //
        x:=Str2Vector('[0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.00,0.05,0.26,0.32,0.33,0.43,0.60,0.60,0.77,0.98,1.02]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        m:=2;
        t:=2;
        if _spoil_scenario=10 then
            t:=Double(Infinity);
        if _spoil_scenario=11 then
            t:=Double(NegInfinity);

        //
        // Fitting without individual weights
        //
        // NOTE: result is returned as barycentricinterpolant structure.
        //       if you want to get representation in the power basis,
        //       you can use barycentricbar2pow() function to convert
        //       from barycentric to power representation (see docs for 
        //       POLINT subpackage for more info).
        //
        polynomialfit(x, y, m, info, p, rep);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.011, 0.002);

        //
        // Fitting with individual weights
        //
        // NOTE: slightly different result is returned
        //
        w:=Str2Vector('[1,1.414213562,1,1,1,1,1,1,1,1,1]');
        if _spoil_scenario=12 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=13 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=14 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=15 then
            spoil_vector_by_adding_element(w);
        if _spoil_scenario=16 then
            spoil_vector_by_deleting_element(w);
        xc:=nil;
        if _spoil_scenario=17 then
            spoil_vector_by_adding_element(xc);
        yc:=nil;
        if _spoil_scenario=18 then
            spoil_vector_by_adding_element(yc);
        dc:=nil;
        if _spoil_scenario=19 then
            spoil_vector_by_adding_element(dc);
        FreeAndNil(p);
        polynomialfitwc(x, y, w, xc, yc, dc, m, info, p, rep);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.023, 0.002);

    finally
        FreeAndNil(p);

    end;
end;


function _test_lsfit_d_polc(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    w: TVector;
    xc: TVector;
    yc: TVector;
    dc: TIVector;
    t: Double;
    m: TALGLIBInteger;
    info: TALGLIBInteger;
    p: Tbarycentricinterpolant;
    rep: Tpolynomialfitreport;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        //
        // This example demonstrates polynomial fitting.
        //
        // Fitting is done by two (M=2) functions from polynomial basis:
        //     f0 = 1
        //     f1 = x
        // with simple constraint on function value
        //     f(0) = 0
        // Basically, it just a linear fit; more complex polynomials may be used
        // (e.g. parabolas with M=3, cubic with M=4), but even such simple fit allows
        // us to demonstrate polynomialfit() function in action.
        //
        // We have:
        // * x      set of abscissas
        // * y      experimental data
        // * xc     points where constraints are placed
        // * yc     constraints on derivatives
        // * dc     derivative indices
        //          (0 means function itself, 1 means first derivative)
        //
        x:=Str2Vector('[1.0,1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.9,1.1]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);
        w:=Str2Vector('[1,1]');
        if _spoil_scenario=10 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=11 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=12 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=13 then
            spoil_vector_by_adding_element(w);
        if _spoil_scenario=14 then
            spoil_vector_by_deleting_element(w);
        xc:=Str2Vector('[0]');
        if _spoil_scenario=15 then
            spoil_vector_by_value(xc, Double(NaN));
        if _spoil_scenario=16 then
            spoil_vector_by_value(xc, Double(Infinity));
        if _spoil_scenario=17 then
            spoil_vector_by_value(xc, Double(NegInfinity));
        if _spoil_scenario=18 then
            spoil_vector_by_adding_element(xc);
        if _spoil_scenario=19 then
            spoil_vector_by_deleting_element(xc);
        yc:=Str2Vector('[0]');
        if _spoil_scenario=20 then
            spoil_vector_by_value(yc, Double(NaN));
        if _spoil_scenario=21 then
            spoil_vector_by_value(yc, Double(Infinity));
        if _spoil_scenario=22 then
            spoil_vector_by_value(yc, Double(NegInfinity));
        if _spoil_scenario=23 then
            spoil_vector_by_adding_element(yc);
        if _spoil_scenario=24 then
            spoil_vector_by_deleting_element(yc);
        dc:=Str2IVector('[0]');
        if _spoil_scenario=25 then
            spoil_vector_by_adding_element(dc);
        if _spoil_scenario=26 then
            spoil_vector_by_deleting_element(dc);
        t:=2;
        if _spoil_scenario=27 then
            t:=Double(Infinity);
        if _spoil_scenario=28 then
            t:=Double(NegInfinity);
        m:=2;

        polynomialfitwc(x, y, w, xc, yc, dc, m, info, p, rep);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.000, 0.001);

    finally
        FreeAndNil(p);

    end;
end;


function _test_lsfit_d_spline(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    info: TALGLIBInteger;
    v: Double;
    s: Tspline1dinterpolant;
    rep: Tspline1dfitreport;
    rho: Double;

begin
    Result:=True;
    try
        s:=nil;

        //
        // In this example we demonstrate penalized spline fitting of noisy data
        //
        // We have:
        // * x - abscissas
        // * y - vector of experimental data, straight line with small noise
        //
        x:=Str2Vector('[0.00,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_adding_element(x);
        if _spoil_scenario=4 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.10,0.00,0.30,0.40,0.30,0.40,0.62,0.68,0.75,0.95]');
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=7 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=8 then
            spoil_vector_by_adding_element(y);
        if _spoil_scenario=9 then
            spoil_vector_by_deleting_element(y);

        //
        // Fit with VERY small amount of smoothing (rho = -5.0)
        // and large number of basis functions (M=50).
        //
        // With such small regularization penalized spline almost fully reproduces function values
        //
        rho:=-5.0;
        if _spoil_scenario=10 then
            rho:=Double(NaN);
        if _spoil_scenario=11 then
            rho:=Double(Infinity);
        if _spoil_scenario=12 then
            rho:=Double(NegInfinity);
        spline1dfitpenalized(x, y, 50, rho, info, s, rep);
        Result:=Result and doc_test_int(info, 1);
        v:=spline1dcalc(s, 0.0);
        Result:=Result and doc_test_real(v, 0.10, 0.01);

        //
        // Fit with VERY large amount of smoothing (rho = 10.0)
        // and large number of basis functions (M=50).
        //
        // With such regularization our spline should become close to the straight line fit.
        // We will compare its value in x=1.0 with results obtained from such fit.
        //
        rho:=+10.0;
        if _spoil_scenario=13 then
            rho:=Double(NaN);
        if _spoil_scenario=14 then
            rho:=Double(Infinity);
        if _spoil_scenario=15 then
            rho:=Double(NegInfinity);
        FreeAndNil(s);
        spline1dfitpenalized(x, y, 50, rho, info, s, rep);
        Result:=Result and doc_test_int(info, 1);
        v:=spline1dcalc(s, 1.0);
        Result:=Result and doc_test_real(v, 0.969, 0.001);

        //
        // In real life applications you may need some moderate degree of fitting,
        // so we try to fit once more with rho=3.0.
        //
        rho:=+3.0;
        if _spoil_scenario=16 then
            rho:=Double(NaN);
        if _spoil_scenario=17 then
            rho:=Double(Infinity);
        if _spoil_scenario=18 then
            rho:=Double(NegInfinity);
        FreeAndNil(s);
        spline1dfitpenalized(x, y, 50, rho, info, s, rep);
        Result:=Result and doc_test_int(info, 1);

    finally
        FreeAndNil(s);

    end;
end;


function _test_lsfit_t_polfit_1(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    m: TALGLIBInteger;
    t: Double;
    info: TALGLIBInteger;
    p: Tbarycentricinterpolant;
    rep: Tpolynomialfitreport;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        x:=Str2Vector('[0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.00,0.05,0.26,0.32,0.33,0.43,0.60,0.60,0.77,0.98,1.02]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        m:=2;
        t:=2;
        if _spoil_scenario=8 then
            t:=Double(Infinity);
        if _spoil_scenario=9 then
            t:=Double(NegInfinity);
        polynomialfit(x, y, 11, m, info, p, rep);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.011, 0.002);

    finally
        FreeAndNil(p);

    end;
end;


function _test_lsfit_t_polfit_2(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    w: TVector;
    xc: TVector;
    yc: TVector;
    dc: TIVector;
    m: TALGLIBInteger;
    t: Double;
    info: TALGLIBInteger;
    p: Tbarycentricinterpolant;
    rep: Tpolynomialfitreport;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        x:=Str2Vector('[0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.00,0.05,0.26,0.32,0.33,0.43,0.60,0.60,0.77,0.98,1.02]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        w:=Str2Vector('[1,1.414213562,1,1,1,1,1,1,1,1,1]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(w);
        xc:=nil;
        yc:=nil;
        dc:=nil;
        m:=2;
        t:=2;
        if _spoil_scenario=12 then
            t:=Double(Infinity);
        if _spoil_scenario=13 then
            t:=Double(NegInfinity);
        polynomialfitwc(x, y, w, 11, xc, yc, dc, 0, m, info, p, rep);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.023, 0.002);

    finally
        FreeAndNil(p);

    end;
end;


function _test_lsfit_t_polfit_3(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    w: TVector;
    xc: TVector;
    yc: TVector;
    dc: TIVector;
    m: TALGLIBInteger;
    t: Double;
    info: TALGLIBInteger;
    p: Tbarycentricinterpolant;
    rep: Tpolynomialfitreport;
    v: Double;

begin
    Result:=True;
    try
        p:=nil;

        x:=Str2Vector('[1.0,1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.9,1.1]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        w:=Str2Vector('[1,1]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(w, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(w, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(w, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(w);
        xc:=Str2Vector('[0]');
        if _spoil_scenario=12 then
            spoil_vector_by_value(xc, Double(NaN));
        if _spoil_scenario=13 then
            spoil_vector_by_value(xc, Double(Infinity));
        if _spoil_scenario=14 then
            spoil_vector_by_value(xc, Double(NegInfinity));
        if _spoil_scenario=15 then
            spoil_vector_by_deleting_element(xc);
        yc:=Str2Vector('[0]');
        if _spoil_scenario=16 then
            spoil_vector_by_value(yc, Double(NaN));
        if _spoil_scenario=17 then
            spoil_vector_by_value(yc, Double(Infinity));
        if _spoil_scenario=18 then
            spoil_vector_by_value(yc, Double(NegInfinity));
        if _spoil_scenario=19 then
            spoil_vector_by_deleting_element(yc);
        dc:=Str2IVector('[0]');
        if _spoil_scenario=20 then
            spoil_vector_by_deleting_element(dc);
        m:=2;
        t:=2;
        if _spoil_scenario=21 then
            t:=Double(Infinity);
        if _spoil_scenario=22 then
            t:=Double(NegInfinity);
        polynomialfitwc(x, y, w, 2, xc, yc, dc, 1, m, info, p, rep);
        v:=barycentriccalc(p, t);
        Result:=Result and doc_test_real(v, 2.000, 0.001);

    finally
        FreeAndNil(p);

    end;
end;


function _test_lsfit_t_4pl(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    n: TALGLIBInteger;
    a: Double;
    b: Double;
    c: Double;
    d: Double;
    rep: Tlsfitreport;
    v: Double;

begin
    Result:=True;
    try

        x:=Str2Vector('[1,2,3,4,5,6,7,8]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.06313223,0.44552624,0.61838364,0.71385108,0.77345838,0.81383140,0.84280033,0.86449822]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        n:=8;

        //
        // Test logisticfit4() on carefully designed data with a priori known answer.
        //
        logisticfit4(x, y, n, a, b, c, d, rep);
        Result:=Result and doc_test_real(a, -1.000, 0.01);
        Result:=Result and doc_test_real(b, 1.200, 0.01);
        Result:=Result and doc_test_real(c, 0.900, 0.01);
        Result:=Result and doc_test_real(d, 1.000, 0.01);

        //
        // Evaluate model at point x=0.5
        //
        v:=logisticcalc4(0.5, a, b, c, d);
        Result:=Result and doc_test_real(v, -0.33874308, 0.001);

    finally

    end;
end;


function _test_lsfit_t_5pl(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    n: TALGLIBInteger;
    a: Double;
    b: Double;
    c: Double;
    d: Double;
    g: Double;
    rep: Tlsfitreport;
    v: Double;

begin
    Result:=True;
    try

        x:=Str2Vector('[1,2,3,4,5,6,7,8]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.1949776139,0.5710060208,0.726002637,0.8060434158,0.8534547965,0.8842071579,0.9054773317,0.9209088299]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        n:=8;

        //
        // Test logisticfit5() on carefully designed data with a priori known answer.
        //
        logisticfit5(x, y, n, a, b, c, d, g, rep);
        Result:=Result and doc_test_real(a, -1.000, 0.01);
        Result:=Result and doc_test_real(b, 1.200, 0.01);
        Result:=Result and doc_test_real(c, 0.900, 0.01);
        Result:=Result and doc_test_real(d, 1.000, 0.01);
        Result:=Result and doc_test_real(g, 1.200, 0.01);

        //
        // Evaluate model at point x=0.5
        //
        v:=logisticcalc5(0.5, a, b, c, d, g);
        Result:=Result and doc_test_real(v, -0.2354656824, 0.001);

    finally

    end;
end;


function _test_spline2d_bilinear(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    f: TVector;
    vx: Double;
    vy: Double;
    v: Double;
    s: Tspline2dinterpolant;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We use bilinear spline to interpolate f(x,y)=x^2+2*y^2 sampled 
        // at (x,y) from [0.0, 0.5, 1.0] X [0.0, 1.0].
        //
        x:=Str2Vector('[0.0, 0.5, 1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        f:=Str2Vector('[0.00,0.25,1.00,2.00,2.25,3.00]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(f, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(f, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(f, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(f);
        vx:=0.25;
        if _spoil_scenario=12 then
            vx:=Double(Infinity);
        if _spoil_scenario=13 then
            vx:=Double(NegInfinity);
        vy:=0.50;
        if _spoil_scenario=14 then
            vy:=Double(Infinity);
        if _spoil_scenario=15 then
            vy:=Double(NegInfinity);

        // build spline
        spline2dbuildbilinearv(x, 3, y, 2, f, 1, s);

        // calculate S(0.25,0.50)
        v:=spline2dcalc(s, vx, vy);
        Result:=Result and doc_test_real(v, 1.1250, 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_spline2d_bicubic(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    f: TVector;
    vx: Double;
    vy: Double;
    v: Double;
    dx: Double;
    dy: Double;
    dxy: Double;
    s: Tspline2dinterpolant;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We use bilinear spline to interpolate f(x,y)=x^2+2*y^2 sampled 
        // at (x,y) from [0.0, 0.5, 1.0] X [0.0, 1.0].
        //
        x:=Str2Vector('[0.0, 0.5, 1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        f:=Str2Vector('[0.00,0.25,1.00,2.00,2.25,3.00]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(f, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(f, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(f, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(f);
        vx:=0.25;
        if _spoil_scenario=12 then
            vx:=Double(Infinity);
        if _spoil_scenario=13 then
            vx:=Double(NegInfinity);
        vy:=0.50;
        if _spoil_scenario=14 then
            vy:=Double(Infinity);
        if _spoil_scenario=15 then
            vy:=Double(NegInfinity);

        // build spline
        spline2dbuildbicubicv(x, 3, y, 2, f, 1, s);

        // calculate S(0.25,0.50)
        v:=spline2dcalc(s, vx, vy);
        Result:=Result and doc_test_real(v, 1.0625, 0.00005);

        // calculate derivatives
        spline2ddiff(s, vx, vy, v, dx, dy, dxy);
        Result:=Result and doc_test_real(v, 1.0625, 0.00005);
        Result:=Result and doc_test_real(dx, 0.5000, 0.00005);
        Result:=Result and doc_test_real(dy, 2.0000, 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_spline2d_fit_blocklls(_spoil_scenario: Integer):Boolean;
var
    xy: TMatrix;
    builder: Tspline2dbuilder;
    d: TALGLIBInteger;
    lambdav: Double;
    s: Tspline2dinterpolant;
    rep: Tspline2dfitreport;
    v: Double;

begin
    Result:=True;
    try
        builder:=nil;
        s:=nil;

        //
        // We use bicubic spline to reproduce f(x,y)=1/(1+x^2+2*y^2) sampled
        // at irregular points (x,y) from [-1,+1]*[-1,+1]
        //
        // We have 5 such points, located approximately at corners of the area
        // and its center -  but not exactly at the grid. Thus, we have to FIT
        // the spline, i.e. to solve least squares problem
        //
        xy:=Str2Matrix('[[-0.987,-0.902,0.359],[0.948,-0.992,0.347],[-1.000,1.000,0.333],[1.000,0.973,0.339],[0.017,0.180,0.968]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(xy);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(xy);

        //
        // First step is to create spline2dbuilder object and set its properties:
        // * d=1 means that we create vector-valued spline with 1 component
        // * we specify dataset xy
        // * we rely on automatic selection of interpolation area
        // * we tell builder that we want to use 5x5 grid for an underlying spline
        // * we choose least squares solver named BlockLLS and configure it by
        //   telling that we want to apply zero nonlinearity penalty.
        //
        // NOTE: you can specify non-zero lambdav if you want to make your spline
        //       more "rigid", i.e. to penalize nonlinearity.
        //
        // NOTE: ALGLIB has two solvers which fit bicubic splines to irregular data,
        //       one of them is BlockLLS and another one is FastDDM. Former is
        //       intended for moderately sized grids (up to 512x512 nodes, although
        //       it may take up to few minutes); it is the most easy to use and
        //       control spline fitting function in the library. Latter, FastDDM,
        //       is intended for efficient solution of large-scale problems
        //       (up to 100.000.000 nodes). Both solvers can be parallelized, but
        //       FastDDM is much more efficient. See comments for more information.
        //
        d:=1;
        lambdav:=0.000;
        spline2dbuildercreate(d, builder);
        spline2dbuildersetpoints(builder, xy, 5);
        spline2dbuildersetgrid(builder, 5, 5);
        spline2dbuildersetalgoblocklls(builder, lambdav);

        //
        // Now we are ready to fit and evaluate our results
        //
        spline2dfit(builder, s, rep);

        // evaluate results - function value at the grid is reproduced exactly
        v:=spline2dcalc(s, -1, 1);
        Result:=Result and doc_test_real(v, 0.333000, 0.005);

        // check maximum error - it must be nearly zero
        Result:=Result and doc_test_real(rep.maxerror, 0.000, 0.005);

    finally
        FreeAndNil(builder);
        FreeAndNil(s);

    end;
end;


function _test_spline2d_unpack(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    f: TVector;
    c: TMatrix;
    m: TALGLIBInteger;
    n: TALGLIBInteger;
    d: TALGLIBInteger;
    s: Tspline2dinterpolant;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We build bilinear spline for f(x,y)=x+2*y+3*xy for (x,y) in [0,1].
        // Then we demonstrate how to unpack it.
        //
        x:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        f:=Str2Vector('[0.00,1.00,2.00,6.00]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(f, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(f, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(f, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(f);

        // build spline
        spline2dbuildbilinearv(x, 2, y, 2, f, 1, s);

        // unpack and test
        spline2dunpackv(s, m, n, d, c);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[0, 1, 0, 1, 0,2,0,0, 1,3,0,0, 0,0,0,0, 0,0,0,0 ]]'), 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_spline2d_copytrans(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    f: TVector;
    s: Tspline2dinterpolant;
    snew: Tspline2dinterpolant;
    v: Double;
    f2: TVector;
    vr: TVector;

begin
    Result:=True;
    try
        s:=nil;
        snew:=nil;

        //
        // We build bilinear spline for f(x,y)=x+2*y for (x,y) in [0,1].
        // Then we apply several transformations to this spline.
        //
        x:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        f:=Str2Vector('[0.00,1.00,2.00,3.00]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(f, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(f, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(f, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(f);
        spline2dbuildbilinearv(x, 2, y, 2, f, 1, s);

        // copy spline, apply transformation x:=2*xnew, y:=4*ynew
        // evaluate at (xnew,ynew) = (0.25,0.25) - should be same as (x,y)=(0.5,1.0)
        spline2dcopy(s, snew);
        spline2dlintransxy(snew, 2.0, 0.0, 4.0, 0.0);
        v:=spline2dcalc(snew, 0.25, 0.25);
        Result:=Result and doc_test_real(v, 2.500, 0.00005);

        // copy spline, apply transformation SNew:=2*S+3
        FreeAndNil( snew);
        spline2dcopy(s, snew);
        spline2dlintransf(snew, 2.0, 3.0);
        v:=spline2dcalc(snew, 0.5, 1.0);
        Result:=Result and doc_test_real(v, 8.000, 0.00005);

        //
        // Same example, but for vector spline (f0,f1) = {x+2*y, 2*x+y}
        //
        f2:=Str2Vector('[0.00,0.00, 1.00,2.00, 2.00,1.00, 3.00,3.00]');
        if _spoil_scenario=12 then
            spoil_vector_by_value(f2, Double(NaN));
        if _spoil_scenario=13 then
            spoil_vector_by_value(f2, Double(Infinity));
        if _spoil_scenario=14 then
            spoil_vector_by_value(f2, Double(NegInfinity));
        if _spoil_scenario=15 then
            spoil_vector_by_deleting_element(f2);
        FreeAndNil( s);
        spline2dbuildbilinearv(x, 2, y, 2, f2, 2, s);

        // copy spline, apply transformation x:=2*xnew, y:=4*ynew
        FreeAndNil( snew);
        spline2dcopy(s, snew);
        spline2dlintransxy(snew, 2.0, 0.0, 4.0, 0.0);
        spline2dcalcv(snew, 0.25, 0.25, vr);
        Result:=Result and doc_test_real_vector(vr, Str2Vector('[2.500,2.000]'), 0.00005);

        // copy spline, apply transformation SNew:=2*S+3
        FreeAndNil( snew);
        spline2dcopy(s, snew);
        spline2dlintransf(snew, 2.0, 3.0);
        spline2dcalcv(snew, 0.5, 1.0, vr);
        Result:=Result and doc_test_real_vector(vr, Str2Vector('[8.000,7.000]'), 0.00005);

    finally
        FreeAndNil(s);
        FreeAndNil(snew);

    end;
end;


function _test_spline2d_vector(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    f: TVector;
    s: Tspline2dinterpolant;
    vr: TVector;

begin
    Result:=True;
    try
        s:=nil;

        //
        // We build bilinear vector-valued spline (f0,f1) = {x+2*y, 2*x+y}
        // Spline is built using function values at 2x2 grid: (x,y)=[0,1]*[0,1]
        // Then we perform evaluation at (x,y)=(0.1,0.3)
        //
        x:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(x);
        y:=Str2Vector('[0.0, 1.0]');
        if _spoil_scenario=4 then
            spoil_vector_by_value(y, Double(NaN));
        if _spoil_scenario=5 then
            spoil_vector_by_value(y, Double(Infinity));
        if _spoil_scenario=6 then
            spoil_vector_by_value(y, Double(NegInfinity));
        if _spoil_scenario=7 then
            spoil_vector_by_deleting_element(y);
        f:=Str2Vector('[0.00,0.00, 1.00,2.00, 2.00,1.00, 3.00,3.00]');
        if _spoil_scenario=8 then
            spoil_vector_by_value(f, Double(NaN));
        if _spoil_scenario=9 then
            spoil_vector_by_value(f, Double(Infinity));
        if _spoil_scenario=10 then
            spoil_vector_by_value(f, Double(NegInfinity));
        if _spoil_scenario=11 then
            spoil_vector_by_deleting_element(f);
        spline2dbuildbilinearv(x, 2, y, 2, f, 2, s);
        spline2dcalcv(s, 0.1, 0.3, vr);
        Result:=Result and doc_test_real_vector(vr, Str2Vector('[0.700,0.500]'), 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_rbf_d_hrbf(_spoil_scenario: Integer):Boolean;
var
    v: Double;
    model: Trbfmodel;
    xy: TMatrix;
    rep: Trbfreport;

begin
    Result:=True;
    try
        model:=nil;

        //
        // This example illustrates basic concepts of the RBF models: creation, modification,
        // evaluation.
        // 
        // Suppose that we have set of 2-dimensional points with associated
        // scalar function values, and we want to build a RBF model using
        // our data.
        // 
        // NOTE: we can work with 3D models too :)
        // 
        // Typical sequence of steps is given below:
        // 1. we create RBF model object
        // 2. we attach our dataset to the RBF model and tune algorithm settings
        // 3. we rebuild RBF model using QNN algorithm on new data
        // 4. we use RBF model (evaluate, serialize, etc.)
        //

        //
        // Step 1: RBF model creation.
        //
        // We have to specify dimensionality of the space (2 or 3) and
        // dimensionality of the function (scalar or vector).
        //
        // New model is empty - it can be evaluated,
        // but we just get zero value at any point.
        //
        rbfcreate(2, 1, model);

        v:=rbfcalc2(model, 0.0, 0.0);
        Result:=Result and doc_test_real(v, 0.000, 0.005);

        //
        // Step 2: we add dataset.
        //
        // XY contains two points - x0=(-1,0) and x1=(+1,0) -
        // and two function values f(x0)=2, f(x1)=3.
        //
        // We added points, but model was not rebuild yet.
        // If we call rbfcalc2(), we still will get 0.0 as result.
        //
        xy:=Str2Matrix('[[-1,0,2],[+1,0,3]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        rbfsetpoints(model, xy);

        v:=rbfcalc2(model, 0.0, 0.0);
        Result:=Result and doc_test_real(v, 0.000, 0.005);

        //
        // Step 3: rebuild model
        //
        // After we've configured model, we should rebuild it -
        // it will change coefficients stored internally in the
        // rbfmodel structure.
        //
        // We use hierarchical RBF algorithm with following parameters:
        // * RBase - set to 1.0
        // * NLayers - three layers are used (although such simple problem
        //   does not need more than 1 layer)
        // * LambdaReg - is set to zero value, no smoothing is required
        //
        rbfsetalgohierarchical(model, 1.0, 3, 0.0);
        rbfbuildmodel(model, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 1);

        //
        // Step 4: model was built
        //
        // After call of rbfbuildmodel(), rbfcalc2() will return
        // value of the new model.
        //
        v:=rbfcalc2(model, 0.0, 0.0);
        Result:=Result and doc_test_real(v, 2.500, 0.005);

    finally
        FreeAndNil(model);

    end;
end;


function _test_rbf_d_vector(_spoil_scenario: Integer):Boolean;
var
    x: TVector;
    y: TVector;
    model: Trbfmodel;
    xy: TMatrix;
    rep: Trbfreport;

begin
    Result:=True;
    try
        model:=nil;

        //
        // Suppose that we have set of 2-dimensional points with associated VECTOR
        // function values, and we want to build a RBF model using our data.
        // 
        // Typical sequence of steps is given below:
        // 1. we create RBF model object
        // 2. we attach our dataset to the RBF model and tune algorithm settings
        // 3. we rebuild RBF model using new data
        // 4. we use RBF model (evaluate, serialize, etc.)
        //

        //
        // Step 1: RBF model creation.
        //
        // We have to specify dimensionality of the space (equal to 2) and
        // dimensionality of the function (2-dimensional vector function).
        //
        // New model is empty - it can be evaluated,
        // but we just get zero value at any point.
        //
        rbfcreate(2, 2, model);

        x:=Str2Vector('[+1,+1]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(x, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(x, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(x, Double(NegInfinity));
        rbfcalc(model, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[0.000,0.000]'), 0.005);

        //
        // Step 2: we add dataset.
        //
        // XY arrays containt four points:
        // * (x0,y0) = (+1,+1), f(x0,y0)=(0,-1)
        // * (x1,y1) = (+1,-1), f(x1,y1)=(-1,0)
        // * (x2,y2) = (-1,-1), f(x2,y2)=(0,+1)
        // * (x3,y3) = (-1,+1), f(x3,y3)=(+1,0)
        //
        xy:=Str2Matrix('[[+1,+1,0,-1],[+1,-1,-1,0],[-1,-1,0,+1],[-1,+1,+1,0]]');
        if _spoil_scenario=3 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=4 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=5 then
            spoil_matrix_by_value(xy, Double(NegInfinity));
        rbfsetpoints(model, xy);

        // We added points, but model was not rebuild yet.
        // If we call rbfcalc(), we still will get 0.0 as result.
        rbfcalc(model, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[0.000,0.000]'), 0.005);

        //
        // Step 3: rebuild model
        //
        // We use hierarchical RBF algorithm with following parameters:
        // * RBase - set to 1.0
        // * NLayers - three layers are used (although such simple problem
        //   does not need more than 1 layer)
        // * LambdaReg - is set to zero value, no smoothing is required
        //
        // After we've configured model, we should rebuild it -
        // it will change coefficients stored internally in the
        // rbfmodel structure.
        //
        rbfsetalgohierarchical(model, 1.0, 3, 0.0);
        rbfbuildmodel(model, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 1);

        //
        // Step 4: model was built
        //
        // After call of rbfbuildmodel(), rbfcalc() will return
        // value of the new model.
        //
        rbfcalc(model, x, y);
        Result:=Result and doc_test_real_vector(y, Str2Vector('[0.000,-1.000]'), 0.005);

    finally
        FreeAndNil(model);

    end;
end;


function _test_rbf_d_polterm(_spoil_scenario: Integer):Boolean;
var
    v: Double;
    model: Trbfmodel;
    xy: TMatrix;
    rep: Trbfreport;
    nx: TALGLIBInteger;
    ny: TALGLIBInteger;
    nc: TALGLIBInteger;
    modelversion: TALGLIBInteger;
    xwr: TMatrix;
    c: TMatrix;

begin
    Result:=True;
    try
        model:=nil;

        //
        // This example show how to work with polynomial term
        // 
        // Suppose that we have set of 2-dimensional points with associated
        // scalar function values, and we want to build a RBF model using
        // our data.
        //
        // We use hierarchical RBF algorithm with following parameters:
        // * RBase - set to 1.0
        // * NLayers - three layers are used (although such simple problem
        //   does not need more than 1 layer)
        // * LambdaReg - is set to zero value, no smoothing is required
        //
        xy:=Str2Matrix('[[-1,0,2],[+1,0,3]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        rbfcreate(2, 1, model);
        rbfsetpoints(model, xy);
        rbfsetalgohierarchical(model, 1.0, 3, 0.0);

        //
        // By default, RBF model uses linear term. It means that model
        // looks like
        //     f(x,y) = SUM(RBF[i]) + a*x + b*y + c
        // where RBF[i] is I-th radial basis function and a*x+by+c is a
        // linear term. Having linear terms in a model gives us:
        // (1) improved extrapolation properties
        // (2) linearity of the model when data can be perfectly fitted
        //     by the linear function
        // (3) linear asymptotic behavior
        //
        // Our simple dataset can be modelled by the linear function
        //     f(x,y) = 0.5*x + 2.5
        // and rbfbuildmodel() with default settings should preserve this
        // linearity.
        //
        rbfbuildmodel(model, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 1);
        rbfunpack(model, nx, ny, xwr, nc, c, modelversion);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[0.500,0.000,2.500]]'), 0.005);

        // asymptotic behavior of our function is linear
        v:=rbfcalc2(model, 1000.0, 0.0);
        Result:=Result and doc_test_real(v, 502.50, 0.05);

        //
        // Instead of linear term we can use constant term. In this case
        // we will get model which has form
        //     f(x,y) = SUM(RBF[i]) + c
        // where RBF[i] is I-th radial basis function and c is a constant,
        // which is equal to the average function value on the dataset.
        //
        // Because we've already attached dataset to the model the only
        // thing we have to do is to call rbfsetconstterm() and then
        // rebuild model with rbfbuildmodel().
        //
        rbfsetconstterm(model);
        rbfbuildmodel(model, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 1);
        rbfunpack(model, nx, ny, xwr, nc, c, modelversion);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[0.000,0.000,2.500]]'), 0.005);

        // asymptotic behavior of our function is constant
        v:=rbfcalc2(model, 1000.0, 0.0);
        Result:=Result and doc_test_real(v, 2.500, 0.005);

        //
        // Finally, we can use zero term. Just plain RBF without polynomial
        // part:
        //     f(x,y) = SUM(RBF[i])
        // where RBF[i] is I-th radial basis function.
        //
        rbfsetzeroterm(model);
        rbfbuildmodel(model, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 1);
        rbfunpack(model, nx, ny, xwr, nc, c, modelversion);
        Result:=Result and doc_test_real_matrix(c, Str2Matrix('[[0.000,0.000,0.000]]'), 0.005);

        // asymptotic behavior of our function is just zero constant
        v:=rbfcalc2(model, 1000.0, 0.0);
        Result:=Result and doc_test_real(v, 0.000, 0.005);

    finally
        FreeAndNil(model);

    end;
end;


function _test_rbf_d_serialize(_spoil_scenario: Integer):Boolean;
var
    s: AnsiString;
    v: Double;
    model0: Trbfmodel;
    model1: Trbfmodel;
    xy: TMatrix;
    rep: Trbfreport;

begin
    Result:=True;
    try
        model0:=nil;
        model1:=nil;

        //
        // This example show how to serialize and unserialize RBF model
        // 
        // Suppose that we have set of 2-dimensional points with associated
        // scalar function values, and we want to build a RBF model using
        // our data. Then we want to serialize it to string and to unserialize
        // from string, loading to another instance of RBF model.
        //
        // Here we assume that you already know how to create RBF models.
        //
        xy:=Str2Matrix('[[-1,0,2],[+1,0,3]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(xy, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(xy, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(xy, Double(NegInfinity));

        // model initialization
        rbfcreate(2, 1, model0);
        rbfsetpoints(model0, xy);
        rbfsetalgohierarchical(model0, 1.0, 3, 0.0);
        rbfbuildmodel(model0, rep);
        Result:=Result and doc_test_int(rep.terminationtype, 1);

        //
        // Serialization - it looks easy,
        // but you should carefully read next section.
        //
        rbfserialize(model0, s);
        rbfunserialize(s, model1);

        // both models return same value
        v:=rbfcalc2(model0, 0.0, 0.0);
        Result:=Result and doc_test_real(v, 2.500, 0.005);
        v:=rbfcalc2(model1, 0.0, 0.0);
        Result:=Result and doc_test_real(v, 2.500, 0.005);

        //
        // Previous section shows that model state is saved/restored during
        // serialization. However, some properties are NOT serialized.
        //
        // Serialization saves/restores RBF model, but it does NOT saves/restores
        // settings which were used to build current model. In particular, dataset
        // which was used to build model, is not preserved.
        //
        // What does it mean in for us?
        //
        // Do you remember this sequence: rbfcreate-rbfsetpoints-rbfbuildmodel?
        // First step creates model, second step adds dataset and tunes model
        // settings, third step builds model using current dataset and model
        // construction settings.
        //
        // If you call rbfbuildmodel() without calling rbfsetpoints() first, you
        // will get empty (zero) RBF model. In our example, model0 contains
        // dataset which was added by rbfsetpoints() call. However, model1 does
        // NOT contain dataset - because dataset is NOT serialized.
        //
        // This, if we call rbfbuildmodel(model0,rep), we will get same model,
        // which returns 2.5 at (x,y)=(0,0). However, after same call model1 will
        // return zero - because it contains RBF model (coefficients), but does NOT
        // contain dataset which was used to build this model.
        //
        // Basically, it means that:
        // * serialization of the RBF model preserves anything related to the model
        //   EVALUATION
        // * but it does NOT creates perfect copy of the original object.
        //
        rbfbuildmodel(model0, rep);
        v:=rbfcalc2(model0, 0.0, 0.0);
        Result:=Result and doc_test_real(v, 2.500, 0.005);

        rbfbuildmodel(model1, rep);
        v:=rbfcalc2(model1, 0.0, 0.0);
        Result:=Result and doc_test_real(v, 0.000, 0.005);

    finally
        FreeAndNil(model0);
        FreeAndNil(model1);

    end;
end;


function _test_matdet_d_1(_spoil_scenario: Integer):Boolean;
var
    b: TMatrix;
    a: Double;

begin
    Result:=True;
    try

        b:=Str2Matrix('[[1,2],[2,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(b);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(b);
        a:=rmatrixdet(b);
        Result:=Result and doc_test_real(a, -3, 0.0001);

    finally

    end;
end;


function _test_matdet_d_2(_spoil_scenario: Integer):Boolean;
var
    b: TMatrix;
    a: Double;

begin
    Result:=True;
    try

        b:=Str2Matrix('[[5,4],[4,5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(b);
        a:=rmatrixdet(b, 2);
        Result:=Result and doc_test_real(a, 9, 0.0001);

    finally

    end;
end;


function _test_matdet_d_3(_spoil_scenario: Integer):Boolean;
var
    b: TCMatrix;
    a: Complex;

begin
    Result:=True;
    try

        b:=Str2CMatrix('[[1+1i,2],[2,1-1i]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(b);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(b);
        a:=cmatrixdet(b);
        Result:=Result and doc_test_complex(a, -2, 0.0001);

    finally

    end;
end;


function _test_matdet_d_4(_spoil_scenario: Integer):Boolean;
var
    a: Complex;
    b: TCMatrix;

begin
    Result:=True;
    try

        b:=Str2CMatrix('[[5i,4],[4i,5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(b);
        a:=cmatrixdet(b, 2);
        Result:=Result and doc_test_complex(a, C_Complex(0,9), 0.0001);

    finally

    end;
end;


function _test_matdet_d_5(_spoil_scenario: Integer):Boolean;
var
    a: Complex;
    b: TCMatrix;

begin
    Result:=True;
    try

        b:=Str2CMatrix('[[9,1],[2,1]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(b);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(b);
        a:=cmatrixdet(b);
        Result:=Result and doc_test_complex(a, 7, 0.0001);

    finally

    end;
end;


function _test_matdet_t_0(_spoil_scenario: Integer):Boolean;
var
    a: Double;
    b: TMatrix;

begin
    Result:=True;
    try

        b:=Str2Matrix('[[3,4],[-4,3]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(b);
        a:=rmatrixdet(b, 2);
        Result:=Result and doc_test_real(a, 25, 0.0001);

    finally

    end;
end;


function _test_matdet_t_1(_spoil_scenario: Integer):Boolean;
var
    a: Double;
    b: TMatrix;
    p: TIVector;

begin
    Result:=True;
    try

        b:=Str2Matrix('[[1,2],[2,5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(b);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(b);
        p:=Str2IVector('[1,1]');
        if _spoil_scenario=7 then
            spoil_vector_by_adding_element(p);
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(p);
        a:=rmatrixludet(b, p);
        Result:=Result and doc_test_real(a, -5, 0.0001);

    finally

    end;
end;


function _test_matdet_t_2(_spoil_scenario: Integer):Boolean;
var
    a: Double;
    b: TMatrix;
    p: TIVector;

begin
    Result:=True;
    try

        b:=Str2Matrix('[[5,4],[4,5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(b);
        p:=Str2IVector('[0,1]');
        if _spoil_scenario=5 then
            spoil_vector_by_deleting_element(p);
        a:=rmatrixludet(b, p, 2);
        Result:=Result and doc_test_real(a, 25, 0.0001);

    finally

    end;
end;


function _test_matdet_t_3(_spoil_scenario: Integer):Boolean;
var
    a: Complex;
    b: TCMatrix;

begin
    Result:=True;
    try

        b:=Str2CMatrix('[[5i,4],[-4,5i]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(b);
        a:=cmatrixdet(b, 2);
        Result:=Result and doc_test_complex(a, -9, 0.0001);

    finally

    end;
end;


function _test_matdet_t_4(_spoil_scenario: Integer):Boolean;
var
    a: Complex;
    b: TCMatrix;
    p: TIVector;

begin
    Result:=True;
    try

        b:=Str2CMatrix('[[1,2],[2,5i]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_adding_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_adding_col(b);
        if _spoil_scenario=5 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=6 then
            spoil_matrix_by_deleting_col(b);
        p:=Str2IVector('[1,1]');
        if _spoil_scenario=7 then
            spoil_vector_by_adding_element(p);
        if _spoil_scenario=8 then
            spoil_vector_by_deleting_element(p);
        a:=cmatrixludet(b, p);
        Result:=Result and doc_test_complex(a, C_Complex(0,-5), 0.0001);

    finally

    end;
end;


function _test_matdet_t_5(_spoil_scenario: Integer):Boolean;
var
    a: Complex;
    b: TCMatrix;
    p: TIVector;

begin
    Result:=True;
    try

        b:=Str2CMatrix('[[5,4i],[4,5]]');
        if _spoil_scenario=0 then
            spoil_matrix_by_value(b, C_Complex(NaN));
        if _spoil_scenario=1 then
            spoil_matrix_by_value(b, C_Complex(Infinity));
        if _spoil_scenario=2 then
            spoil_matrix_by_value(b, C_Complex(NegInfinity));
        if _spoil_scenario=3 then
            spoil_matrix_by_deleting_row(b);
        if _spoil_scenario=4 then
            spoil_matrix_by_deleting_col(b);
        p:=Str2IVector('[0,1]');
        if _spoil_scenario=5 then
            spoil_vector_by_deleting_element(p);
        a:=cmatrixludet(b, p, 2);
        Result:=Result and doc_test_complex(a, 25, 0.0001);

    finally

    end;
end;


function _test_solvesks_d_1(_spoil_scenario: Integer):Boolean;
var
    n: TALGLIBInteger;
    bandwidth: TALGLIBInteger;
    s: Tsparsematrix;
    b: TVector;
    rep: Tsparsesolverreport;
    x: TVector;
    isuppertriangle: Boolean;

begin
    Result:=True;
    try
        s:=nil;

        //
        // This example demonstrates creation/initialization of the sparse matrix
        // in the SKS (Skyline) storage format and solution using SKS-based direct
        // solver.
        //
        // First, we have to create matrix and initialize it. Matrix is created
        // in the SKS format, using fixed bandwidth initialization function.
        // Several points should be noted:
        //
        // 1. SKS sparse storage format also allows variable bandwidth matrices;
        //    we just do not want to overcomplicate this example.
        //
        // 2. SKS format requires you to specify matrix geometry prior to
        //    initialization of its elements with sparseset(). If you specified
        //    bandwidth=1, you can not change your mind afterwards and call
        //    sparseset() for non-existent elements.
        // 
        // 3. Because SKS solver need just one triangle of SPD matrix, we can
        //    omit initialization of the lower triangle of our matrix.
        //
        n:=4;
        bandwidth:=1;
        sparsecreatesksband(n, n, bandwidth, s);
        sparseset(s, 0, 0, 2.0);
        sparseset(s, 0, 1, 1.0);
        sparseset(s, 1, 1, 3.0);
        sparseset(s, 1, 2, 1.0);
        sparseset(s, 2, 2, 3.0);
        sparseset(s, 2, 3, 1.0);
        sparseset(s, 3, 3, 2.0);

        //
        // Now we have symmetric positive definite 4x4 system width bandwidth=1:
        //
        //     [ 2 1     ]   [ x0]]   [  4 ]
        //     [ 1 3 1   ]   [ x1 ]   [ 10 ]
        //     [   1 3 1 ] * [ x2 ] = [ 15 ]
        //     [     1 2 ]   [ x3 ]   [ 11 ]
        //
        // After successful creation we can call SKS solver.
        //
        b:=Str2Vector('[4,10,15,11]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(b);
        isuppertriangle:=true;
        sparsesolvesks(s, n, isuppertriangle, b, rep, x);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[1.0000, 2.0000, 3.0000, 4.0000]'), 0.00005);

    finally
        FreeAndNil(s);

    end;
end;


function _test_lincg_d_1(_spoil_scenario: Integer):Boolean;
var
    a: Tsparsematrix;
    b: TVector;
    s: Tlincgstate;
    rep: Tlincgreport;
    x: TVector;

begin
    Result:=True;
    try
        a:=nil;
        s:=nil;

        //
        // This example illustrates solution of sparse linear systems with
        // conjugate gradient method.
        // 
        // Suppose that we have linear system A*x=b with sparse symmetric
        // positive definite A (represented by sparsematrix object)
        //         [ 5 1       ]
        //         [ 1 7 2     ]
        //     A = [   2 8 1   ]
        //         [     1 4 1 ]
        //         [       1 4 ]
        // and right part b
        //     [  7 ]
        //     [ 17 ]
        // b = [ 14 ]
        //     [ 10 ]
        //     [  6 ]
        // and we want to solve this system using sparse linear CG. In order
        // to do so, we have to create left part (sparsematrix object) and
        // right part (dense array).
        //
        // Initially, sparse matrix is created in the Hash-Table format,
        // which allows easy initialization, but do not allow matrix to be
        // used in the linear solvers. So after construction you should convert
        // sparse matrix to CRS format (one suited for linear operations).
        //
        // It is important to note that in our example we initialize full
        // matrix A, both lower and upper triangles. However, it is symmetric
        // and sparse solver needs just one half of the matrix. So you may
        // save about half of the space by filling only one of the triangles.
        //
        sparsecreate(5, 5, a);
        sparseset(a, 0, 0, 5.0);
        sparseset(a, 0, 1, 1.0);
        sparseset(a, 1, 0, 1.0);
        sparseset(a, 1, 1, 7.0);
        sparseset(a, 1, 2, 2.0);
        sparseset(a, 2, 1, 2.0);
        sparseset(a, 2, 2, 8.0);
        sparseset(a, 2, 3, 1.0);
        sparseset(a, 3, 2, 1.0);
        sparseset(a, 3, 3, 4.0);
        sparseset(a, 3, 4, 1.0);
        sparseset(a, 4, 3, 1.0);
        sparseset(a, 4, 4, 4.0);

        //
        // Now our matrix is fully initialized, but we have to do one more
        // step - convert it from Hash-Table format to CRS format (see
        // documentation on sparse matrices for more information about these
        // formats).
        //
        // If you omit this call, ALGLIB will generate exception on the first
        // attempt to use A in linear operations. 
        //
        sparseconverttocrs(a);

        //
        // Initialization of the right part
        //
        b:=Str2Vector('[7,17,14,10,6]');
        if _spoil_scenario=0 then
            spoil_vector_by_value(b, Double(NaN));
        if _spoil_scenario=1 then
            spoil_vector_by_value(b, Double(Infinity));
        if _spoil_scenario=2 then
            spoil_vector_by_value(b, Double(NegInfinity));
        if _spoil_scenario=3 then
            spoil_vector_by_deleting_element(b);

        //
        // Now we have to create linear solver object and to use it for the
        // solution of the linear system.
        //
        // NOTE: lincgsolvesparse() accepts additional parameter which tells
        //       what triangle of the symmetric matrix should be used - upper
        //       or lower. Because we've filled both parts of the matrix, we
        //       can use any part - upper or lower.
        //
        lincgcreate(5, s);
        lincgsolvesparse(s, a, true, b);
        lincgresults(s, x, rep);

        Result:=Result and doc_test_int(rep.terminationtype, 1);
        Result:=Result and doc_test_real_vector(x, Str2Vector('[1.000,2.000,1.000,2.000,1.000]'), 0.005);

    finally
        FreeAndNil(a);
        FreeAndNil(s);

    end;
end;


var
    _TotalResult, _TestResult: Boolean;
    _spoil_scenario: Integer;
begin
    ExitCode:=0;
    _TotalResult:=True;
    Randomize();
    WriteLn('Delphi interface tests. Please wait...');
    x_alloc_counter_activate();
    WriteLn('Allocation counter: activated');
    try
            //
            // TEST nneighbor_d_1
            //      Nearest neighbor search, KNN queries
            //
            WriteLn('0/151');
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nneighbor_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nneighbor_d_1                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nneighbor_t_2
            //      Subsequent queries; buffered functions must use previously allocated storage (if large enough), so buffer may contain some info from previous call
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nneighbor_t_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nneighbor_t_2                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nneighbor_d_2
            //      Serialization of KD-trees
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nneighbor_d_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nneighbor_d_2                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST odesolver_d1
            //      Solving y'=-y with ODE solver
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 13-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_odesolver_d1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('odesolver_d1                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST sparse_d_1
            //      Basic operations with sparse matrices
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 1-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_sparse_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('sparse_d_1                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST sparse_d_crs
            //      Advanced topic: creation in the CRS format.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 2-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_sparse_d_crs(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('sparse_d_crs                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST ablas_d_gemm
            //      Matrix multiplication (single-threaded)
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_ablas_d_gemm(_spoil_scenario);
            except
                on E: Exception do _TestResult:=False;
            end;
            if not _TestResult then
                WriteLn('ablas_d_gemm                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST ablas_d_syrk
            //      Symmetric rank-K update (single-threaded)
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_ablas_d_syrk(_spoil_scenario);
            except
                on E: Exception do _TestResult:=False;
            end;
            if not _TestResult then
                WriteLn('ablas_d_syrk                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST ablas_t_complex
            //      Basis test for complex matrix functions (correctness and presence of SMP support)
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_ablas_t_complex(_spoil_scenario);
            except
                on E: Exception do _TestResult:=False;
            end;
            if not _TestResult then
                WriteLn('ablas_t_complex                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_d_r1
            //      Real matrix inverse
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matinv_d_r1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matinv_d_r1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_d_c1
            //      Complex matrix inverse
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matinv_d_c1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matinv_d_c1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_d_spd1
            //      SPD matrix inverse
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matinv_d_spd1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matinv_d_spd1                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_d_hpd1
            //      HPD matrix inverse
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matinv_d_hpd1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matinv_d_hpd1                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_t_r1
            //      Real matrix inverse: singular matrix
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_matinv_t_r1(_spoil_scenario);
            except
                on E: Exception do _TestResult:=False;
            end;
            if not _TestResult then
                WriteLn('matinv_t_r1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_t_c1
            //      Complex matrix inverse: singular matrix
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_matinv_t_c1(_spoil_scenario);
            except
                on E: Exception do _TestResult:=False;
            end;
            if not _TestResult then
                WriteLn('matinv_t_c1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_e_spd1
            //      Attempt to use SPD function on nonsymmetrix matrix
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_matinv_e_spd1(_spoil_scenario);
                _TestResult:=False;
            except
                on E: Exception do _TestResult:=_TestResult and True;
            end;
            if not _TestResult then
                WriteLn('matinv_e_spd1                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matinv_e_hpd1
            //      Attempt to use SPD function on nonsymmetrix matrix
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_matinv_e_hpd1(_spoil_scenario);
                _TestResult:=False;
            except
                on E: Exception do _TestResult:=_TestResult and True;
            end;
            if not _TestResult then
                WriteLn('matinv_e_hpd1                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlbfgs_d_1
            //      Nonlinear optimization by L-BFGS
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 15-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlbfgs_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlbfgs_d_1                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlbfgs_d_2
            //      Nonlinear optimization with additional settings and restarts
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 21-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlbfgs_d_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlbfgs_d_2                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlbfgs_numdiff
            //      Nonlinear optimization by L-BFGS with numerical differentiation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 15-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlbfgs_numdiff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlbfgs_numdiff                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST linlsqr_d_1
            //      Solution of sparse linear systems with CG
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 4-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_linlsqr_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('linlsqr_d_1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minbleic_d_1
            //      Nonlinear optimization with bound constraints
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 20-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minbleic_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minbleic_d_1                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minbleic_d_2
            //      Nonlinear optimization with linear inequality constraints
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 22-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minbleic_d_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minbleic_d_2                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minbleic_numdiff
            //      Nonlinear optimization with bound constraints and numerical differentiation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 23-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minbleic_numdiff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minbleic_numdiff                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minqp_d_u1
            //      Unconstrained dense quadratic programming
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 17-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minqp_d_u1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minqp_d_u1                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minqp_d_bc1
            //      Bound constrained dense quadratic programming
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 21-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minqp_d_bc1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minqp_d_bc1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minqp_d_lc1
            //      Linearly constrained dense quadratic programming
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 16-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minqp_d_lc1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minqp_d_lc1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minqp_d_u2
            //      Unconstrained sparse quadratic programming
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minqp_d_u2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minqp_d_u2                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minqp_d_nonconvex
            //      Nonconvex quadratic programming
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 21-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minqp_d_nonconvex(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minqp_d_nonconvex                FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlp_basic
            //      Basic linear programming example
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 15-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlp_basic(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlp_basic                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minnlc_d_inequality
            //      Nonlinearly constrained optimization (inequality constraints)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minnlc_d_inequality(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minnlc_d_inequality              FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minnlc_d_equality
            //      Nonlinearly constrained optimization (equality constraints)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minnlc_d_equality(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minnlc_d_equality                FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minnlc_d_mixed
            //      Nonlinearly constrained optimization with mixed equality/inequality constraints
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minnlc_d_mixed(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minnlc_d_mixed                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minbc_d_1
            //      Nonlinear optimization with box constraints
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 20-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minbc_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minbc_d_1                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minbc_numdiff
            //      Nonlinear optimization with bound constraints and numerical differentiation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 23-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minbc_numdiff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minbc_numdiff                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minns_d_unconstrained
            //      Nonsmooth unconstrained optimization
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 15-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minns_d_unconstrained(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minns_d_unconstrained            FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minns_d_diff
            //      Nonsmooth unconstrained optimization with numerical differentiation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 18-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minns_d_diff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minns_d_diff                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minns_d_bc
            //      Nonsmooth box constrained optimization
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 17-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minns_d_bc(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minns_d_bc                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minns_d_nlc
            //      Nonsmooth nonlinearly constrained optimization
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 15-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minns_d_nlc(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minns_d_nlc                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST mincg_d_1
            //      Nonlinear optimization by CG
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 15-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_mincg_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('mincg_d_1                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST mincg_d_2
            //      Nonlinear optimization with additional settings and restarts
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 21-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_mincg_d_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('mincg_d_2                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST mincg_numdiff
            //      Nonlinear optimization by CG with numerical differentiation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 18-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_mincg_numdiff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('mincg_numdiff                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlm_d_v
            //      Nonlinear least squares optimization using function vector only
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlm_d_v(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlm_d_v                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlm_d_vj
            //      Nonlinear least squares optimization using function vector and Jacobian
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlm_d_vj(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlm_d_vj                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlm_d_fgh
            //      Nonlinear Hessian-based optimization for general functions
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlm_d_fgh(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlm_d_fgh                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlm_d_vb
            //      Bound constrained nonlinear least squares optimization
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 13-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlm_d_vb(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlm_d_vb                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlm_d_restarts
            //      Efficient restarts of LM optimizer
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlm_d_restarts(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlm_d_restarts                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlm_t_1
            //      Nonlinear least squares optimization, FJ scheme (obsolete, but supported)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlm_t_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlm_t_1                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST minlm_t_2
            //      Nonlinear least squares optimization, FGJ scheme (obsolete, but supported)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_minlm_t_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('minlm_t_2                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST basestat_d_base
            //      Basic functionality (moments, adev, median, percentile)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_basestat_d_base(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('basestat_d_base                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST basestat_d_c2
            //      Correlation (covariance) between two random variables
            //
            WriteLn('50/151');
            _TestResult:=True;
            for _spoil_scenario:=-1 to 10-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_basestat_d_c2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('basestat_d_c2                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST basestat_d_cm
            //      Correlation (covariance) between components of random vector
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_basestat_d_cm(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('basestat_d_cm                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST basestat_d_cm2
            //      Correlation (covariance) between two random vectors
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_basestat_d_cm2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('basestat_d_cm2                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST basestat_t_base
            //      Tests ability to detect errors in inputs
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 34-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_basestat_t_base(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('basestat_t_base                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST basestat_t_covcorr
            //      Tests ability to detect errors in inputs
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 126-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_basestat_t_covcorr(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('basestat_t_covcorr               FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST ssa_d_basic
            //      Simple SSA analysis demo
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_ssa_d_basic(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('ssa_d_basic                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST ssa_d_forecast
            //      Simple SSA forecasting demo
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_ssa_d_forecast(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('ssa_d_forecast                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST ssa_d_realtime
            //      Real-time SSA algorithm with fast incremental updates
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_ssa_d_realtime(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('ssa_d_realtime                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST linreg_d_basic
            //      Linear regression used to build the very basic model and unpack coefficients
            //
            _TestResult:=True;
            try
                _spoil_scenario:=0;
                _TestResult:=_TestResult and _test_linreg_d_basic(_spoil_scenario);
            except
                on E: Exception do _TestResult:=False;
            end;
            if not _TestResult then
                WriteLn('linreg_d_basic                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST filters_d_sma
            //      SMA(k) filter
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_filters_d_sma(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('filters_d_sma                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST filters_d_ema
            //      EMA(alpha) filter
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_filters_d_ema(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('filters_d_ema                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST filters_d_lrma
            //      LRMA(k) filter
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_filters_d_lrma(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('filters_d_lrma                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST mcpd_simple1
            //      Simple unconstrained MCPD model (no entry/exit states)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_mcpd_simple1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('mcpd_simple1                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST mcpd_simple2
            //      Simple MCPD model (no entry/exit states) with equality constraints
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_mcpd_simple2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('mcpd_simple2                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_regr
            //      Regression problem with one output (2=>1)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_regr(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_regr                          FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_regr_n
            //      Regression problem with multiple outputs (2=>2)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_regr_n(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_regr_n                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_cls2
            //      Binary classification problem
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_cls2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_cls2                          FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_cls3
            //      Multiclass classification problem
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_cls3(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_cls3                          FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_trainerobject
            //      Advanced example on trainer object
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_trainerobject(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_trainerobject                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_crossvalidation
            //      Cross-validation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_crossvalidation(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_crossvalidation               FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_ensembles_es
            //      Early stopping ensembles
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_ensembles_es(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_ensembles_es                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST nn_parallel
            //      Parallel training
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_nn_parallel(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('nn_parallel                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST clst_ahc
            //      Simple hierarchical clusterization with Euclidean distance function
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_clst_ahc(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('clst_ahc                         FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST clst_kmeans
            //      Simple k-means clusterization
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_clst_kmeans(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('clst_kmeans                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST clst_linkage
            //      Clusterization with different linkage types
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_clst_linkage(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('clst_linkage                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST clst_distance
            //      Clusterization with different metric types
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_clst_distance(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('clst_distance                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST clst_kclusters
            //      Obtaining K top clusters from clusterization tree
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_clst_kclusters(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('clst_kclusters                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST randomforest_cls
            //      Simple classification with random forests
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_randomforest_cls(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('randomforest_cls                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST randomforest_reg
            //      Simple classification with decision forest
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_randomforest_reg(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('randomforest_reg                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST knn_cls
            //      Simple classification with KNN model
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_knn_cls(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('knn_cls                          FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST knn_reg
            //      Simple classification with KNN model
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_knn_reg(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('knn_reg                          FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST autogk_d1
            //      Integrating f=exp(x) by adaptive integrator
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_autogk_d1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('autogk_d1                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST fft_complex_d1
            //      Complex FFT: simple example
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_fft_complex_d1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('fft_complex_d1                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST fft_complex_d2
            //      Complex FFT: advanced example
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_fft_complex_d2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('fft_complex_d2                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST fft_real_d1
            //      Real FFT: simple example
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_fft_real_d1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('fft_real_d1                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST fft_real_d2
            //      Real FFT: advanced example
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_fft_real_d2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('fft_real_d2                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST fft_complex_e1
            //      error detection in backward FFT
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_fft_complex_e1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('fft_complex_e1                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST idw_d_mstab
            //      Simple model built with IDW-MSTAB algorithm
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_idw_d_mstab(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('idw_d_mstab                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST idw_d_serialize
            //      IDW model serialization/unserialization
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_idw_d_serialize(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('idw_d_serialize                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline1d_d_linear
            //      Piecewise linear spline interpolation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline1d_d_linear(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline1d_d_linear                FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline1d_d_cubic
            //      Cubic spline interpolation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 10-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline1d_d_cubic(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline1d_d_cubic                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline1d_d_monotone
            //      Monotone interpolation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 10-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline1d_d_monotone(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline1d_d_monotone              FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline1d_d_griddiff
            //      Differentiation on the grid using cubic splines
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 10-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline1d_d_griddiff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline1d_d_griddiff              FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline1d_d_convdiff
            //      Resampling using cubic splines
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 11-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline1d_d_convdiff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline1d_d_convdiff              FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST parametric_rdp
            //      Parametric Ramer-Douglas-Peucker approximation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_parametric_rdp(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('parametric_rdp                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline3d_trilinear
            //      Trilinear spline interpolation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 22-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline3d_trilinear(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline3d_trilinear               FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline3d_vector
            //      Vector-valued trilinear spline interpolation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 22-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline3d_vector(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline3d_vector                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_d_calcdiff
            //      Interpolation and differentiation using barycentric representation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_d_calcdiff(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_d_calcdiff                FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_d_conv
            //      Conversion between power basis and barycentric representation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_d_conv(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_d_conv                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_d_spec
            //      Polynomial interpolation on special grids (equidistant, Chebyshev I/II)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 11-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_d_spec(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_d_spec                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_1
            //      Polynomial interpolation, full list of parameters.
            //
            WriteLn('100/151');
            _TestResult:=True;
            for _spoil_scenario:=-1 to 10-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_1                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_2
            //      Polynomial interpolation, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_2                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_3
            //      Polynomial interpolation, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_3(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_3                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_4
            //      Polynomial interpolation, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_4(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_4                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_5
            //      Polynomial interpolation, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_5(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_5                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_6
            //      Polynomial interpolation, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_6(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_6                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_7
            //      Polynomial interpolation, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_7(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_7                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_8
            //      Polynomial interpolation: y=x^2-x, equidistant grid, barycentric form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_8(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_8                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_9
            //      Polynomial interpolation: y=x^2-x, Chebyshev grid (first kind), barycentric form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 11-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_9(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_9                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_10
            //      Polynomial interpolation: y=x^2-x, Chebyshev grid (second kind), barycentric form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 11-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_10(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_10                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_11
            //      Polynomial interpolation: y=x^2-x, equidistant grid
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_11(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_11                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_12
            //      Polynomial interpolation: y=x^2-x, Chebyshev grid (first kind)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 11-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_12(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_12                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST polint_t_13
            //      Polynomial interpolation: y=x^2-x, Chebyshev grid (second kind)
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 11-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_polint_t_13(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('polint_t_13                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_nlf
            //      Nonlinear fitting using function value only
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 24-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_nlf(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_nlf                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_nlfg
            //      Nonlinear fitting using gradient
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 21-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_nlfg(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_nlfg                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_nlfgh
            //      Nonlinear fitting using gradient and Hessian
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 21-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_nlfgh(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_nlfgh                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_nlfb
            //      Bound contstrained nonlinear fitting using function value only
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 23-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_nlfb(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_nlfb                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_nlscale
            //      Nonlinear fitting with custom scaling and bound constraints
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 27-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_nlscale(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_nlscale                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_lin
            //      Unconstrained (general) linear least squares fitting with and without weights
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 13-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_lin(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_lin                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_linc
            //      Constrained (general) linear least squares fitting with and without weights
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 20-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_linc(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_linc                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_pol
            //      Unconstrained polynomial fitting
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 20-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_pol(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_pol                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_polc
            //      Constrained polynomial fitting
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 29-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_polc(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_polc                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_d_spline
            //      Unconstrained fitting by penalized regression spline
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 19-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_d_spline(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_d_spline                   FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_t_polfit_1
            //      Polynomial fitting, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 10-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_t_polfit_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_t_polfit_1                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_t_polfit_2
            //      Polynomial fitting, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 14-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_t_polfit_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_t_polfit_2                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_t_polfit_3
            //      Polynomial fitting, full list of parameters.
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 23-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_t_polfit_3(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_t_polfit_3                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_t_4pl
            //      4-parameter logistic fitting
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 8-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_t_4pl(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_t_4pl                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lsfit_t_5pl
            //      5-parameter logistic fitting
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 8-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lsfit_t_5pl(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lsfit_t_5pl                      FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline2d_bilinear
            //      Bilinear spline interpolation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 16-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline2d_bilinear(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline2d_bilinear                FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline2d_bicubic
            //      Bilinear spline interpolation
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 16-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline2d_bicubic(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline2d_bicubic                 FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline2d_fit_blocklls
            //      Fitting bicubic spline to irregular data
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline2d_fit_blocklls(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline2d_fit_blocklls            FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline2d_unpack
            //      Unpacking bilinear spline
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline2d_unpack(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline2d_unpack                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline2d_copytrans
            //      Copy and transform
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 16-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline2d_copytrans(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline2d_copytrans               FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST spline2d_vector
            //      Copy and transform
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 12-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_spline2d_vector(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('spline2d_vector                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST rbf_d_hrbf
            //      Simple model built with HRBF algorithm
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_rbf_d_hrbf(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('rbf_d_hrbf                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST rbf_d_vector
            //      Working with vector functions
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_rbf_d_vector(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('rbf_d_vector                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST rbf_d_polterm
            //      RBF models - working with polynomial term
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_rbf_d_polterm(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('rbf_d_polterm                    FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST rbf_d_serialize
            //      Serialization/unserialization
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 3-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_rbf_d_serialize(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('rbf_d_serialize                  FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_d_1
            //      Determinant calculation, real matrix, short form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_d_1                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_d_2
            //      Determinant calculation, real matrix, full form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_d_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_d_2                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_d_3
            //      Determinant calculation, complex matrix, short form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_d_3(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_d_3                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_d_4
            //      Determinant calculation, complex matrix, full form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_d_4(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_d_4                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_d_5
            //      Determinant calculation, complex matrix with zero imaginary part, short form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 7-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_d_5(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_d_5                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_t_0
            //      Determinant calculation, real matrix, full form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_t_0(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_t_0                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_t_1
            //      Determinant calculation, real matrix, LU, short form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_t_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_t_1                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_t_2
            //      Determinant calculation, real matrix, LU, full form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_t_2(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_t_2                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_t_3
            //      Determinant calculation, complex matrix, full form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 5-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_t_3(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_t_3                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_t_4
            //      Determinant calculation, complex matrix, LU, short form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 9-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_t_4(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_t_4                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST matdet_t_5
            //      Determinant calculation, complex matrix, LU, full form
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 6-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_matdet_t_5(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('matdet_t_5                       FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST solvesks_d_1
            //      Solving positive definite sparse system using Skyline (SKS) solver
            //
            _TestResult:=True;
            for _spoil_scenario:=-1 to 4-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_solvesks_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('solvesks_d_1                     FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            //
            // TEST lincg_d_1
            //      Solution of sparse linear systems with CG
            //
            WriteLn('150/151');
            _TestResult:=True;
            for _spoil_scenario:=-1 to 4-1 do
            begin
                try
                    _TestResult:=_TestResult and _test_lincg_d_1(_spoil_scenario);
                    _TestResult:=_TestResult and (_spoil_scenario=-1);
                except
                    on E: Exception do _TestResult:=_TestResult and (_spoil_scenario<>-1);
                end;
            end;
            if not _TestResult then
                WriteLn('lincg_d_1                        FAILED');
            _TotalResult:=_TotalResult and _TestResult;


            WriteLn('151/151');
        if not _TotalResult then
            ExitCode:=1;
    except
        WriteLn('Unhandled exception was raised!');
        ExitCode:=1;
        Exit;
    end;
    x_free_disposed_items();
    if x_alloc_counter()>0 then
    begin
        ExitCode:=1;
        WriteLn('Allocation counter check: FAILED');
        WriteLn(x_alloc_counter());
    end
    else
        WriteLn('Allocation counter check: OK');
end.
