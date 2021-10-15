#include <critic.h>

struct critmod;

int init() {
	critmod.name = "mixed_whitespace";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Lines should not have a mixture of spaces and tabs for indentation.";
}

int violates (struct *node, struct *wholefile) {
	if (XXX) {
		return 1;
	}

	return 0;
}
