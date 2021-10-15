#include <critic.h>

struct critmod;
int depth;

int init() {
	critmod.name = "deep_blocks";
	critmod.criticality = 4;
	critmod.package = "complexity";
	critmod.info = "Functions over 5 {} should be refactored.";
	critmod.good = "void f() {{{{{ }}}}}";
	critmod.bad = "void f() {{{{ }}}}";
	depth = 0;
}

int violates (struct *node, struct *wholefile) {
	if (node.type == '{') {
		depth += 1;
	}

	if (node.type == '}') {
		depth -= 1;
	}
	/* do check here XXX */
	if (depth > 5) {
		return 1;
	}

	return 0;
}
