%{
#include<stdlib.h>
#include<stdio.h>
#include<string.h>

int yylex();

FILE *out;
void yyerror(char *s) {fprintf(out,"ERROR\n");}
int yywrap(void) {
 return 1;
}
%}

%union{
int number;
char *string;
}

%token<string> ID IF ELSE WHILE LPAREN RPAREN ASSIGN SEMICOL PLUS MINUS MULT DIV DAST LBRACE RBRACE LSQ RSQ GE LE LT GT EQ NE AND OR TYPE COMMA RETURN MAIN DQ TR FL MOD
%token<number> NUM 

%%

prog : prog stmt
       | stmt
     ;



fun_def :   TYPE ID LPAREN fun_args RPAREN LBRACE fun_body RBRACE {fprintf(out,"Identifier-%s\n",$2);}
            | TYPE ID LPAREN  RPAREN LBRACE fun_body RBRACE {fprintf(out,"Identifier-%s\n",$2);}
            | TYPE MAIN LPAREN fun_args RPAREN LBRACE fun_body RBRACE {fprintf(out,"Identifier-main\n");}
            ; 

fun_dec : TYPE ID LPAREN fun_args RPAREN SEMICOL {fprintf(out,"Variable- %s ",$1);
          fprintf(out,"Function Declaration: %s \n",$2);}
          ;
                           

fun_call : ID LPAREN call_args RPAREN SEMICOL {fprintf(out,"Var- %s ",$1);fprintf(out,"\nFUN ends\nFUN-CALL\n");}
           | ID LPAREN  RPAREN SEMICOL {fprintf(out,"Var- %s ",$1);fprintf(out,"\nFUN ends\nFUN-CALL\n");}
           | RETURN expr SEMICOL               {fprintf(out," RET\n");}  
           | RETURN LPAREN expr RPAREN SEMICOL  {fprintf(out," RET\n");}
          ;
stmt  :  var_dec  
        | fun_dec 
        | fun_def
        | fun_call
        | if_stmt 
        | while_stmt 
        | statement
        | fun_call
        ;

call_args : 
          | expr {fprintf(out,"FUN-ARG\n");}
          | call_args COMMA expr {fprintf(out,"FUN-ARG\n");}                 
          ;
                     

                   
fun_body : stmt
          | fun_body stmt 
          ;   
        
fun_args : TYPE ID {fprintf(out,"Identifier-main\n");fprintf(out,"function argument: %s\n",$2);}
         | TYPE ID COMMA fun_args {fprintf(out,"function argument: %s\nFunction body\n",$2);}
         ;
var_dec : TYPE ID  SEMICOL {fprintf(out,"local variable %s\n",$2);}
        | TYPE ID ASSIGN expr SEMICOL {fprintf(out,":= \nlocal variable: %s\n",$2);}
        | TYPE ID LSQ expr RSQ SEMICOL {fprintf(out,"local variable: %s\n",$2);}
        | TYPE ID LSQ expr RSQ ASSIGN expr SEMICOL   {fprintf(out,":= \nLocal variable- %s  ",$2);}
        ;    

if_stmt : IF LPAREN expr RPAREN LBRACE fun_body RBRACE {fprintf(out," Identifier-if\n");}
         |IF LPAREN expr RPAREN LBRACE fun_body RBRACE ELSE LBRACE fun_body RBRACE{fprintf(out,"  Identifier-if "); 
         fprintf(out," Identifier-else \n");}
         ;
        
while_stmt : WHILE LPAREN expr RPAREN LBRACE fun_body RBRACE {fprintf(out," Identifier-While\n");}
           ; 

expr : ID                  {fprintf(out," variable- %s  ",$1);}
     | NUM                 {fprintf(out," Const: %d  ",$1);}
     | expr opr expr        
     | LPAREN expr RPAREN 
     | LSQ expr RSQ
     | expr COMMA expr
     | ID expr 
     | TR
     | FL
     ;
     
statement: | ID ASSIGN expr SEMICOL                      {fprintf(out,"Variable: %s  ",$1);}
           | ID LSQ expr RSQ ASSIGN expr SEMICOL         {fprintf(out,"Variable: %s  ",$1);}
           | ID MINUS MINUS SEMICOL                      {fprintf(out,"Variable: %s  ",$1);}    
           | ID PLUS PLUS SEMICOL                        {fprintf(out,"Variable: %s  ",$1);} 
           ;
     

          
opr :   LT {fprintf(out,"< ");}
        |GT {fprintf(out,"> ");}
        |GE {fprintf(out,">= ");}
        |LE {fprintf(out,"<= ");}
        |PLUS {fprintf(out,"+ ");}
        |MINUS {fprintf(out,"- ");}
        |MULT {fprintf(out,"* ");}
        |DIV {fprintf(out,"/ ");}
        |AND  {fprintf(out,"AND ");}
        |OR  {fprintf(out,"OR ");}
        |EQ {fprintf(out,"== ");}
        |NE {fprintf(out,"!= ");} 
        | MOD {fprintf(out,"% ");}
        ;


%%



int main(int argc[],char *argv[]){
extern FILE *yyin,*yyout;
yyin=fopen(argv[1],"r");
yyout=fopen("Lexer.txt","w");
out=fopen("Parser.txt","w");
yyparse();

return 0;
}

