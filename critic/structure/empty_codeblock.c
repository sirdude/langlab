#include <critic.h>

struct critmod;

int init() {
	critmod.name = "empty_codeblock";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Code blocks should do something useful.";
	critmod.good = "{ x = 5; }";
	critmod.bad = "{}";
}

int is_empty_node(struct *node) {
	XXX
}

int violates (struct *node, struct *wholefile) {
	if (node.type != function) {
		return 0;
	}

	if (is_empty_node(node)) {
		return 1;
	}

	return 0;
}
