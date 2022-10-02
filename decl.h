#include"expr.h"
struct decl{
	char* name;
	struct type* type;
	struct expr* value;
	struct stmt* code;
	struct decl* next;
};

struct decl* decl_create(char*,struct type*, struct expr*, struct stmt*, struct decl* );
void decl_print(struct decl*);
