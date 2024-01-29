%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cstring>
    #include "ast.hpp"
    #include "parser.hpp"

    void yyerror(const char *);
%}

/** WRITE ME:
 *  Put any definitions you need here. Add your own regular expressions
 *  below for ALL tokens defined in the manual. You can choose not to use
 *  definitions here.
 */

/* HERE */
%x C_COMMENT

/** The example below is very simple, but it shows almost everything you will
 *  need to do for this first part. The syntax is as follows:
 *
 *  regular_expression      {  c code  }
 *
 * The lexer will try to match each regular expression. When it does it will
 * execute the corresponding C code.
*/

%%

"/%" { BEGIN(C_COMMENT); }
<C_COMMENT>"%/" { BEGIN(INITIAL); }
<C_COMMENT>\n { }
<C_COMMENT>. { }

&& { return OP_AND; }
\/ { return DIVIDE; }
= { return ASSIGN; }
== { return OP_EQ; }
> { return OP_GREATER; }
>= { return OP_GREATEREQ; }
\< { return OP_LESS; }
\<= { return OP_LESSEQ; }
\- { return MINUS; }
! { return OP_NOT; }
!= { return OP_NE; } 
\|\| { return OP_OR; } 
\+ { return PLUS; }
\* { return TIMES; }
& { return ADDRESS; }
\^ { return OP_XOR; }
: { return COLON; }
; { return SEMI; }
, { return COMMA; }
\"[^"\n]*\" { yylval.u_base_charptr = strdup(yytext + 1); yylval.u_base_charptr[strlen(yylval.u_base_charptr) - 1] = '\0'; return QUOTE; }
\'.\' { yylval.u_base_charptr = strdup(yytext + 1); return APOS; }
\| { return BAR; }
\{ { return OPENCURLY; }
\} { return CLOSECURLY; }
\( { return OPENPAREN; }
\) { return CLOSEPAREN; }
\[ { return OPENBRACKET; }
\] { return CLOSEBRACKET; }

null { return N; }
boolean { return KEY_BOOL; }
else { return KEY_ELSE; }
if { return KEY_IF; }
while { return KEY_WHILE; }
var { return KEY_VAR; } 
integer { return KEY_INTEGER; }
procedure { return KEY_PROC; }
char { return KEY_CHAR; }
string { return KEY_CHARARRAY; }
intptr { return KEY_INTPTR; }
charptr { return KEY_CHARPTR; }
return { return KEY_RETURN; }
true { return TRUE; }
false { return FALSE; }

[a-zA-Z][a-zA-Z0-9_]* { yylval.u_base_charptr = strdup(yytext); return IDENT; }
0[0-7]+ { yylval.u_base_int = (int) strtol(yytext, NULL, 8); return DECIMAL; }
0|[1-9][0-9]* { yylval.u_base_int = (int) strtol(yytext, NULL, 10); return DECIMAL; }
0[x|X][0-9A-F]+ { yylval.u_base_int = (int) strtol(yytext, NULL, 16); return DECIMAL; }
[0-1]+b { yylval.u_base_int = (int) strtol(yytext, NULL, 2); return DECIMAL; }

[\*\(\)\.\+\-\|]  { return *yytext; }
[0-9][0-9]*         { return 'n'; }
[ \t\n]             ; /* skip whitespace */

.                   yyerror((char *) "invalid character"); /* [.]* { return USELESS; } */

%%

/** You shall not pass!
 *  You should not  have to do or edit anything past this.
 */

int yywrap(void) {
    return 1;
}
