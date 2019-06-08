-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParCH where
import AbsCH
import LexCH
import ErrM

}

-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype {Token}
%name pProgram_internal Program
%token
  '!' { PT _ (TS _ 1) }
  '!=' { PT _ (TS _ 2) }
  '%' { PT _ (TS _ 3) }
  '&' { PT _ (TS _ 4) }
  '&&' { PT _ (TS _ 5) }
  '(' { PT _ (TS _ 6) }
  ')' { PT _ (TS _ 7) }
  '*' { PT _ (TS _ 8) }
  '+' { PT _ (TS _ 9) }
  '++' { PT _ (TS _ 10) }
  ',' { PT _ (TS _ 11) }
  '-' { PT _ (TS _ 12) }
  '--' { PT _ (TS _ 13) }
  '/' { PT _ (TS _ 14) }
  ';' { PT _ (TS _ 15) }
  '<' { PT _ (TS _ 16) }
  '<=' { PT _ (TS _ 17) }
  '=' { PT _ (TS _ 18) }
  '==' { PT _ (TS _ 19) }
  '>' { PT _ (TS _ 20) }
  '>=' { PT _ (TS _ 21) }
  'boolean' { PT _ (TS _ 22) }
  'else' { PT _ (TS _ 23) }
  'false' { PT _ (TS _ 24) }
  'fun' { PT _ (TS _ 25) }
  'if' { PT _ (TS _ 26) }
  'int' { PT _ (TS _ 27) }
  'print' { PT _ (TS _ 28) }
  'return' { PT _ (TS _ 29) }
  'string' { PT _ (TS _ 30) }
  'true' { PT _ (TS _ 31) }
  'void' { PT _ (TS _ 32) }
  'while' { PT _ (TS _ 33) }
  '{' { PT _ (TS _ 34) }
  '||' { PT _ (TS _ 35) }
  '}' { PT _ (TS _ 36) }

  L_ident {PT _ (TV _)}
  L_integ {PT _ (TI _)}
  L_quoted {PT _ (TL _)}

%%

Ident :: {
  (Maybe (Int, Int), Ident)
}
: L_ident {
  (Just (tokenLineCol $1), Ident (prToken $1)) 
}

Integer :: {
  (Maybe (Int, Int), Integer)
}
: L_integ {
  (Just (tokenLineCol $1), read (prToken $1)) 
}

String :: {
  (Maybe (Int, Int), String)
}
: L_quoted {
  (Just (tokenLineCol $1), prToken $1)
}

Program :: {
  (Maybe (Int, Int), Program (Maybe (Int, Int)))
}
: ListStmt {
  (fst $1, AbsCH.Program (fst $1)(reverse (snd $1)))
}

Arg :: {
  (Maybe (Int, Int), Arg (Maybe (Int, Int)))
}
: Type Ident {
  (fst $1, AbsCH.Arg (fst $1)(snd $1)(snd $2)) 
}
| Type '&' Ident {
  (fst $1, AbsCH.RefArg (fst $1)(snd $1)(snd $3)) 
}

ListArg :: {
  (Maybe (Int, Int), [Arg (Maybe (Int, Int))]) 
}
: {
  (Nothing, [])
}
| Arg {
  (fst $1, (:[]) (snd $1)) 
}
| Arg ',' ListArg {
  (fst $1, (:) (snd $1)(snd $3)) 
}

Stmt :: {
  (Maybe (Int, Int), Stmt (Maybe (Int, Int)))
}
: Type Ident '(' ListArg ')' Block {
  (fst $1, AbsCH.FnDef (fst $1)(snd $1)(snd $2)(snd $4)(snd $6)) 
}
| ';' {
  (Just (tokenLineCol $1), AbsCH.Empty (Just (tokenLineCol $1)))
}
| Block {
  (fst $1, AbsCH.BStmt (fst $1)(snd $1)) 
}
| Type ListItem ';' {
  (fst $1, AbsCH.Decl (fst $1)(snd $1)(snd $2)) 
}
| Ident '=' Expr ';' {
  (fst $1, AbsCH.Ass (fst $1)(snd $1)(snd $3)) 
}
| Ident '++' ';' {
  (fst $1, AbsCH.Incr (fst $1)(snd $1)) 
}
| Ident '--' ';' {
  (fst $1, AbsCH.Decr (fst $1)(snd $1)) 
}
| 'return' Expr ';' {
  (Just (tokenLineCol $1), AbsCH.Ret (Just (tokenLineCol $1)) (snd $2)) 
}
| 'return' ';' {
  (Just (tokenLineCol $1), AbsCH.VRet (Just (tokenLineCol $1)))
}
| 'if' '(' Expr ')' Stmt {
  (Just (tokenLineCol $1), AbsCH.Cond (Just (tokenLineCol $1)) (snd $3)(snd $5)) 
}
| 'if' '(' Expr ')' Stmt 'else' Stmt {
  (Just (tokenLineCol $1), AbsCH.CondElse (Just (tokenLineCol $1)) (snd $3)(snd $5)(snd $7)) 
}
| 'while' '(' Expr ')' Stmt {
  (Just (tokenLineCol $1), AbsCH.While (Just (tokenLineCol $1)) (snd $3)(snd $5)) 
}
| 'print' '(' Expr ')' {
  (Just (tokenLineCol $1), AbsCH.Print (Just (tokenLineCol $1)) (snd $3)) 
}
| Expr ';' {
  (fst $1, AbsCH.SExp (fst $1)(snd $1)) 
}

Block :: {
  (Maybe (Int, Int), Block (Maybe (Int, Int)))
}
: '{' ListStmt '}' {
  (Just (tokenLineCol $1), AbsCH.Block (Just (tokenLineCol $1)) (reverse (snd $2)))
}

ListStmt :: {
  (Maybe (Int, Int), [Stmt (Maybe (Int, Int))]) 
}
: {
  (Nothing, [])
}
| ListStmt Stmt {
  (fst $1, flip (:) (snd $1)(snd $2)) 
}

Item :: {
  (Maybe (Int, Int), Item (Maybe (Int, Int)))
}
: Ident {
  (fst $1, AbsCH.NoInit (fst $1)(snd $1)) 
}
| Ident '=' Expr {
  (fst $1, AbsCH.Init (fst $1)(snd $1)(snd $3)) 
}

ListItem :: {
  (Maybe (Int, Int), [Item (Maybe (Int, Int))]) 
}
: Item {
  (fst $1, (:[]) (snd $1)) 
}
| Item ',' ListItem {
  (fst $1, (:) (snd $1)(snd $3)) 
}

Type :: {
  (Maybe (Int, Int), Type (Maybe (Int, Int)))
}
: 'int' {
  (Just (tokenLineCol $1), AbsCH.Int (Just (tokenLineCol $1)))
}
| 'string' {
  (Just (tokenLineCol $1), AbsCH.Str (Just (tokenLineCol $1)))
}
| 'boolean' {
  (Just (tokenLineCol $1), AbsCH.Bool (Just (tokenLineCol $1)))
}
| 'void' {
  (Just (tokenLineCol $1), AbsCH.Void (Just (tokenLineCol $1)))
}
| 'fun' Type '(' ListType ')' {
  (Just (tokenLineCol $1), AbsCH.Fun (Just (tokenLineCol $1)) (snd $2)(snd $4)) 
}

ListType :: {
  (Maybe (Int, Int), [Type (Maybe (Int, Int))]) 
}
: {
  (Nothing, [])
}
| Type {
  (fst $1, (:[]) (snd $1)) 
}
| Type ',' ListType {
  (fst $1, (:) (snd $1)(snd $3)) 
}

Expr7 :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: Ident {
  (fst $1, AbsCH.EVar (fst $1)(snd $1)) 
}
| Integer {
  (fst $1, AbsCH.ELitInt (fst $1)(snd $1)) 
}
| 'true' {
  (Just (tokenLineCol $1), AbsCH.ELitTrue (Just (tokenLineCol $1)))
}
| 'false' {
  (Just (tokenLineCol $1), AbsCH.ELitFalse (Just (tokenLineCol $1)))
}
| Ident '(' ListExpr ')' {
  (fst $1, AbsCH.EApp (fst $1)(snd $1)(snd $3)) 
}
| String {
  (fst $1, AbsCH.EString (fst $1)(snd $1)) 
}
| '(' Expr ')' {
  (Just (tokenLineCol $1), snd $2)
}

Expr6 :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: '-' Expr6 {
  (Just (tokenLineCol $1), AbsCH.Neg (Just (tokenLineCol $1)) (snd $2)) 
}
| '!' Expr6 {
  (Just (tokenLineCol $1), AbsCH.Not (Just (tokenLineCol $1)) (snd $2)) 
}
| Expr7 {
  (fst $1, snd $1)
}

Expr5 :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: '!' Type '(' ListArg ')' Block {
  (Just (tokenLineCol $1), AbsCH.Anon (Just (tokenLineCol $1)) (snd $2)(snd $4)(snd $6)) 
}
| Expr6 {
  (fst $1, snd $1)
}

Expr4 :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: Expr4 MulOp Expr5 {
  (fst $1, AbsCH.EMul (fst $1)(snd $1)(snd $2)(snd $3)) 
}
| Expr5 {
  (fst $1, snd $1)
}

Expr3 :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: Expr3 AddOp Expr4 {
  (fst $1, AbsCH.EAdd (fst $1)(snd $1)(snd $2)(snd $3)) 
}
| Expr4 {
  (fst $1, snd $1)
}

Expr2 :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: Expr2 RelOp Expr3 {
  (fst $1, AbsCH.ERel (fst $1)(snd $1)(snd $2)(snd $3)) 
}
| Expr3 {
  (fst $1, snd $1)
}

Expr1 :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: Expr2 '&&' Expr1 {
  (fst $1, AbsCH.EAnd (fst $1)(snd $1)(snd $3)) 
}
| Expr2 {
  (fst $1, snd $1)
}

Expr :: {
  (Maybe (Int, Int), Expr (Maybe (Int, Int)))
}
: Expr1 '||' Expr {
  (fst $1, AbsCH.EOr (fst $1)(snd $1)(snd $3)) 
}
| Expr1 {
  (fst $1, snd $1)
}

ListExpr :: {
  (Maybe (Int, Int), [Expr (Maybe (Int, Int))]) 
}
: {
  (Nothing, [])
}
| Expr {
  (fst $1, (:[]) (snd $1)) 
}
| Expr ',' ListExpr {
  (fst $1, (:) (snd $1)(snd $3)) 
}

AddOp :: {
  (Maybe (Int, Int), AddOp (Maybe (Int, Int)))
}
: '+' {
  (Just (tokenLineCol $1), AbsCH.Plus (Just (tokenLineCol $1)))
}
| '-' {
  (Just (tokenLineCol $1), AbsCH.Minus (Just (tokenLineCol $1)))
}

MulOp :: {
  (Maybe (Int, Int), MulOp (Maybe (Int, Int)))
}
: '*' {
  (Just (tokenLineCol $1), AbsCH.Times (Just (tokenLineCol $1)))
}
| '/' {
  (Just (tokenLineCol $1), AbsCH.Div (Just (tokenLineCol $1)))
}
| '%' {
  (Just (tokenLineCol $1), AbsCH.Mod (Just (tokenLineCol $1)))
}

RelOp :: {
  (Maybe (Int, Int), RelOp (Maybe (Int, Int)))
}
: '<' {
  (Just (tokenLineCol $1), AbsCH.LTH (Just (tokenLineCol $1)))
}
| '<=' {
  (Just (tokenLineCol $1), AbsCH.LE (Just (tokenLineCol $1)))
}
| '>' {
  (Just (tokenLineCol $1), AbsCH.GTH (Just (tokenLineCol $1)))
}
| '>=' {
  (Just (tokenLineCol $1), AbsCH.GE (Just (tokenLineCol $1)))
}
| '==' {
  (Just (tokenLineCol $1), AbsCH.EQU (Just (tokenLineCol $1)))
}
| '!=' {
  (Just (tokenLineCol $1), AbsCH.NE (Just (tokenLineCol $1)))
}

{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    t:_ -> " before `" ++ id(prToken t) ++ "'"

myLexer = tokens

pProgram = (>>= return . snd) . pProgram_internal
}

