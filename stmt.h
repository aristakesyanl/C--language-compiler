#include"expr.h"
#include"decl.h"
typedef enum{
	STMT_DECL,
	STMT_EXPR,
	STMT_IF_ELSE,
	STMT_FOR,
	STMT_WHILE,
	STMT_BLOCK,
	STMT_RETURN
}stmt_t;

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

struct stmt* stmt_create(stmt_t, struct decl*, struct expr*, struct expr*, struct expr*, struct stmt*, struct stmt*, struct stmt*);
