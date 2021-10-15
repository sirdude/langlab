#include <critic.h>

struct critmod;

int init() {
	critmod.name = "var_comment";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Variables should have a comment.";
	critmod.good = "int x \"Our counter\";";
	critmod.bad = "int x;";
}

int has_comment(struct *node) {
/* XXX */
}

int violates (struct *node, struct *wholefile) {
	if (node.type != var) {
		return 0;
	}

	if (!has_comment(node)) {
		return 1;
	}

	return 0;
}
