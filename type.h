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

struct type* type_create(type_t,struct type*, struct param_list*);

struct param_list* param_list_create(char*, struct type*, struct param_list*);
