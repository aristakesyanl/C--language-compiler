typedef enum{
	EXPR_ADD,
	EXPR_SUB,
	EXPR_MUL,
	EXPR_DIV,
	EXPR_VAL,
	EXPR_ASSIGN,
	EXPR_INC,
	EXPR_DEC,
	EXPR_NAME,
	EXPR_CALL,
	EXPR_SUBSCRIPT,
	EXPR_LS,
	EXPR_GR,
	EXPR_MOD,
	EXPR_EQ,
	EXPR_NOT_EQ,
	EXPR_AND,
	EXPR_OR,
	EXPR_NOT,
	EXPR_ARG
}expr_t;

typedef enum{
	STMT_DECL,
	STMT_EXPR,
	STMT_IF_ELSE,
	STMT_FOR,
	STMT_WHILE,
	STMT_BLOCK,
	STMT_RETURN,
	STMT_BREAK,
	STMT_CONTINUE
}stmt_t;

typedef enum{
	TYPE_VOID,
	TYPE_INTEGER,
	TYPE_DOUBLE,
	TYPE_BOOL,
	TYPE_CHAR,
	TYPE_ARRAY,
	TYPE_STRING,
	TYPE_FUNCTION,
	TYPE_CLASS
}type_t;

struct expr{
	expr_t type;
	struct expr* left;
	struct expr* right;
	int val;
	char* name;
	double dval;
};

struct decl{
	char* name;
	struct type* type;
	struct expr* value;
	struct stmt* code;
	struct decl* next;
};

struct stmt{
	stmt_t type;
	struct decl* decl;
	struct expr* init_expr;
	struct expr* expr;
	struct expr* next_expr;
	struct stmt* body;
	struct stmt* else_body;
	struct stmt* next;
};

struct type{
	type_t type;
	struct type* subtype;
	struct param_list* param;
};

struct param_list{
	char* name;
	struct type* type;
	struct param_list* next;
};

struct expr* expr_create(expr_t , struct expr*, struct expr*);
struct expr* expr_val(int );
struct expr* expr_dval(double);
struct expr* expr_name(char*);
struct expr* expr_subscript(char*);
int expr_eval(struct expr*);
void expr_print(struct expr*);
struct decl* decl_create(char*,struct type*, struct expr*, struct stmt*, struct decl* );
void decl_print(struct decl*);
struct stmt* stmt_create(stmt_t, struct decl*, struct expr*, struct expr*, struct expr*, struct stmt*, struct stmt*, struct stmt*);
void stmt_print(struct stmt*);
struct type* type_create(type_t,struct type*, struct param_list*);
struct param_list* param_list_create(char*, struct type*, struct param_list*);
