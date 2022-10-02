typedef enum{
	EXPR_ADD,
	EXPR_SUB,
	EXPR_MUL,
	EXPR_DIV,
	EXPR_VAL
}expr_t;

struct expr{
	expr_t type;
	struct expr* left;
	struct expr* right;
	int val;
};

struct expr* expr_create(expr_t type, struct expr* left, struct expr* right);
struct expr* expr_val(int val);
int expr_eval(struct expr* e);
void expr_print(struct expr* e);
