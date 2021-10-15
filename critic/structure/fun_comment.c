#include <critic.h>

struct critmod;

int init() {
	critmod.name = "fun_comment";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Functions should have a comment.";
	critmod.good = "int do_stuff \"Really cool function\" () " +
		"{ return 1; }";
	critmod.bad = "int do_stuff () { return 1; }";
}

int has_comment(struct *node) {
/* XXX */
}

int violates (struct *node, struct *wholefile) {
	if (node.type != function) {
		return 0;
	}

	if (!has_comment(node)) {
		return 1;
	}

	return 0;
}
