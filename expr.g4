grammar expr;

@header {
package parser;
}

program: exprsolo EOF;

decl: typedecl | vardecl | funcdecl;

typedecl: 'type' typeid '=' type;

fielddecl:
	fieldid += ID ':' fieldtype += typeid (
		',' fieldid += ID ':' fieldtype += typeid
	)*;

vardecl:
	'var' ID (':' vartype = typeid)? ':=' exprsolo # VarDecl;

funcdecl:
	'function' ID '(' funcfield = fielddecl? ')' (
		':' functype = typeid
	)? '=' exprsolo;

lvalue: ID (lvalsub += lvalues)*;

lvalues: subscript | fieldexpr;

subscript: '[' exprsolo ']';

fieldexpr: '.' ID;

expr:
	INT														# Integer
	| STRING												# StringDecl
	| '(' expr_list ')'										# Parenthesis
	| '-' exprsolo											# MinusAffector
	| lvalue (':=' lavalueexpr = exprsolo)?					# Affect
	| ID '(' exprlist = expr_list? ')'						# FunctionCall
	| typeid '[' exprsolo ']' 'of' exprsolo					# ListDecl
	| typeid '{' fieldcreate '}'							# List
	| 'if' exprsolo 'then' exprsolo							# IfThen
	| 'if' exprsolo 'then' exprsolo 'else' exprsolo			# IfThenElse
	| 'while' exprsolo 'do' exprsolo						# While
	| 'for' ID ':=' exprsolo 'to' exprsolo 'do' exprsolo	# For
	| 'break'												# Break
	| 'let' decl_list 'in' expr_list? 'end'					# Let
	| prints												# PrintStr
	| freturn												# ReturnF
	| printi												# PrintInt
	| flush													# FlushF
	| getchar												# GetCharF
	| ord													# OrdF
	| chr													# CharF
	| size													# SizeF
	| substring												# SubstringF
	| concat												# ConcatenateF
	| not													# NotF
	| exit													# ExitF;

exprsolo: orexpr (':=' affexpr = exprsolo)? # Affect2;

orexpr: andexpr ('|' expror = exprsolo)? # Or;
andexpr: boolexpr ('&' exprand = exprsolo)? # And;
boolexpr:
	minusexpr (
		('=' | '<>' | '<=' | '>=' | '<' | '>') exprbool = exprsolo
	)?;

minusexpr: addexpr ('-' exprminus = exprsolo)? # Moins;
addexpr: divexpr ('+' exprplus = exprsolo)? # Plus;
divexpr: multexpr ('/' exprdiv = exprsolo)? # Div;
multexpr: expr ('*' exprmult = exprsolo)? # Mult;

expr_list:
	exprlist += exprsolo (sep = (',' | ';') exprlist += exprsolo)* # ExprList;

fieldcreate:
	fieldid += ID '=' fieldex += exprsolo (
		'.' fieldid += ID '=' fieldex += exprsolo
	)* # Field_Create;

decl_list: decl+ # DeclList;

freturn: 'return' '(' expr_list ')';

prints: 'print' '(' (exprsolo) ')';

printi: 'printi' '(' (exprsolo) ')';

flush: 'flush' '(' ')';

getchar: 'getchar' '(' ')';

ord: 'ord' '(' (ordel = STRING | oerdel = ID) ')';

chr: 'chr' '(' (chrel = INT | chrel = ID) ')';

size: 'size' '(' (sizeel = STRING | sizeel = ID) ')';

substring:
	'substring' '(' (sstrel = STRING | ID) ',' (
		sstrind = INT
		| sstrind = ID
	) ',' (sstrlen = INT | sstrlen = ID) ')';

concat:
	'concat' '(' (catel1 = STRING | catel1 = ID) ',' (
		catel2 = STRING
		| catel2 = ID
	) ')';

not: 'not' '(' (notel = INT | notel = ID) ')';

exit: 'exit' '(' (exitel = INT | exitel = ID) ')';

type:
	typeid
	| '{' tyfield = typefields? '}'
	| 'array' 'of' typeid;

typefields:
	tyfield += typefield (',' tyfield += typefields)* # Type_Fields;

typefield: ID ':' typeid # Type_Field;

typeid: 'int' | 'string' | ID;

STRING: '"' .*? '"';

//BINOP: ( '+' | '-' | '*' | '/'  '=' | '<>' | '<' | '>' | '<=' | '>=' | '&' | '|' );

USEDWORDS:
	'array'
	| 'break'
	| 'do'
	| 'else'
	| 'end'
	| 'for'
	| 'function'
	| 'if'
	| 'in'
	| 'let'
	| 'nil'
	| 'of'
	| 'then'
	| 'to'
	| 'type'
	| 'var'
	| 'while';

INT: ('0' ..'9')+;

SYMBS: ('!' | '?' | '-' | '_' | '.' | ':' | ';' | ',');

ID: ('a' ..'z' | 'A' ..'Z') (
		'a' ..'z'
		| 'A' ..'Z'
		| '0' ..'9'
		| '_'
	)*;

WS: (' ' | '\n' | '/*' .*? '*/' | '\t')+ -> skip;