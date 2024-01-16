/*
CEI222: Project Step[2]
*/


%{

#include<stdio.h>
#include<string.h>
#include<stdlib.h>

extern FILE* yyin;   // Declare external lexer variable
char **msgList;
int msgCount = 0;
void yyerror(char *s);
int yylex();
void writeMsg(char msg[]);

%}

%union {
    char *str;
}

%start program
%token
    <str> T_ID 
    T_NUM
    T_LEFT_BR 
    T_RIGHT_BR
    T_LEFT_PR 
    T_RIGHT_PR
    T_LEFT_SB 
    T_RIGHT_SB
    T_IF
    T_ELSE 
    T_WHILE 
    T_RETURN
    T_INT 
    T_VOID
    T_SEMICOLON 
    T_COMMA
    T_PLUS 
    T_MINUS 
    T_MUL 
    T_DIV 
    T_EQUAL
    T_CBI 
    T_CSM 
    T_CBE 
    T_CSE 
    T_CEQ 
    T_CNE

%%

program:
    declaration_list {
        writeMsg("declaration_list\n");
        writeMsg("program\n");
    }
;

declaration_list:
    declaration_list declaration {
        writeMsg("declaration\n");
        writeMsg("declaration_list\n");
    } 
    | declaration {writeMsg("declaration\n");} 
;

declaration:
      var_declaration {writeMsg("var_declaration\n");}
      | fun_declaration {writeMsg("fun_declaration\n");}
;

var_declaration:
    type_specifier T_ID T_SEMICOLON {
        strcat($2,"\n");
        char str[] = "var_decl ID: ";
        strcat(str,$2);
        writeMsg(str);
    }
    | type_specifier T_ID T_LEFT_SB T_NUM T_RIGHT_SB T_SEMICOLON { 
        strcat($2,"\n");
        char str[] = "var_decl array ID: ";
        strcat(str,$2);
        writeMsg(str);
    }
;

type_specifier:
    T_INT {writeMsg("type: INT\n");} | T_VOID {writeMsg("type: VOID\n");}
;

fun_declaration:
    type_specifier T_ID T_LEFT_PR params T_RIGHT_PR compound_stmt{
        writeMsg("compound_stmt\n");
        writeMsg("params\n");
        strcat($2,"\n");
        char str[] = "fun ID: ";
        strcat(str,$2);
        writeMsg(str);
    }
;

params: 
    param_list {writeMsg("param_list\n");} | T_VOID {writeMsg("params(VOID)\n");}
;

param_list:
    param_list T_COMMA param {
        writeMsg("param\n");
        writeMsg("param_list\n");
    }
    | param {writeMsg("param\n");}
;

param:
    type_specifier T_ID {
        strcat($2,"\n");
        char str[] = "param ID: ";
        strcat(str,$2);
        writeMsg(str);
    }
    | type_specifier T_ID T_LEFT_SB T_RIGHT_SB { 
        strcat($2,"\n");
        char str[] = "param array ID: ";
        strcat(str,$2);
        writeMsg(str);
    }
;

compound_stmt:
    T_LEFT_BR local_declarations statement_list T_RIGHT_BR {
        writeMsg("statement_list\n");
        writeMsg("local_declarations\n");
    }
;

local_declarations:
    local_declarations var_declaration {
        writeMsg("var_declaration\n");
        writeMsg("local_declarations\n");
    }
    | /* %empty */ 
;
statement_list:
    statement_list statement {
        writeMsg("statement\n");
        writeMsg("statement_list\n");
    }
    | /* %empty */
;

statement:
    expression_stmt { writeMsg("expression_stmt\n"); }
    | compound_stmt { writeMsg("compound_stmt\n"); }
    | selection_stmt { writeMsg("selection_stmt\n"); }
    | iteration_stmt { writeMsg("iteration_stmt\n"); }
    | return_stmt { writeMsg("return_stmt\n"); }
;

expression_stmt:
    expression T_SEMICOLON { writeMsg("expression\n"); }
    | T_SEMICOLON
;

selection_stmt:
    T_IF T_LEFT_PR expression T_RIGHT_PR statement {
        writeMsg("statement\n");
        writeMsg("expression\n");
    }
    | T_IF T_LEFT_PR expression T_RIGHT_PR statement T_ELSE statement{
        writeMsg("statement\n");
        writeMsg("statement\n");
        writeMsg("expression\n");
    }
;

iteration_stmt:
    T_WHILE T_LEFT_PR expression T_RIGHT_PR {
        writeMsg("expression\n");
    }
;

return_stmt:
    T_RETURN T_SEMICOLON
    | T_RETURN expression T_SEMICOLON { writeMsg("expression\n"); }
;

expression:
    var T_EQUAL expression {
        writeMsg("expression\n");
        writeMsg("var\n");
    }
    | simple_expression { writeMsg("simple_expression\n"); }
;

var:
    T_ID {
        strcat($1,"\n");
        char str[] = "var ID: ";
        strcat(str,$1);
        writeMsg(str);
    }
    | T_ID T_LEFT_SB expression T_RIGHT_SB{
        strcat($1,"\n");
        char str[] = "var array ID: ";
        strcat(str,$1);
        writeMsg(str);
    }
;

simple_expression:
    additive_expression relop additive_expression{
        writeMsg("additive_expression\n");
        writeMsg("relop\n");
        writeMsg("additive_expression\n");
    }
    | additive_expression { writeMsg("additive_expression\n"); }
;

relop:
   T_CBE
   | T_CSE
   | T_CBI
   | T_CSM
   | T_CEQ
   | T_CNE
;

additive_expression:
    additive_expression addop term {
        writeMsg("term\n");
        writeMsg("addop\n");
        writeMsg("additive_expression\n");
    }
    | term { writeMsg("term\n"); }
;

addop:
    T_PLUS
    | T_MINUS
;

term:
    term mulop factor {
        writeMsg("factor\n");
        writeMsg("mulop\n");
        writeMsg("term\n");
    }
    | factor { writeMsg("factor\n"); }
;

mulop:
    T_MUL
    | T_DIV
;

factor:
    T_LEFT_PR expression T_RIGHT_PR { writeMsg("expression\n"); }
    | var { writeMsg("var\n"); }
    | call { writeMsg("call\n"); }
    | T_NUM
;

call:
    T_ID T_LEFT_PR args T_RIGHT_PR { writeMsg("args\n"); }
;

args:
    arg_list { writeMsg("arg_list\n"); }
    | /* %empty */
;

arg_list:
    arg_list T_COMMA expression{
        writeMsg("expression\n");
        writeMsg("arg_list\n");
    }
    | expression { writeMsg("expression\n"); }
;

%%

void writeMsg(char msg[]){
    if(msgList == NULL){
        msgList = malloc(sizeof(*msgList));
    }
    char *p = (char*)calloc(strlen(msg),sizeof(char));
    msgList[msgCount] = strcpy(p,msg);
    msgCount++;
    msgList = realloc(msgList, sizeof(*msgList) * (1 +msgCount));

    if(msgList == NULL){
        printf("msgList array have not been declared (exit)\n");
        exit(0);
    }
}

void yyerror(char *s) {
    printf("%s", s);
}
