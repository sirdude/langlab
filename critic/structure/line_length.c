#include <critic.h>
/* Not sure on this one...  If we depend on editor displaying code correctly we can ignore these limits ??? hard to say at this point */

struct critmod;

int init() {
	critmod.name = "line_length";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Lines should be < 80 chars so they are readable.";
	critmod.good = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n";
	critmod.bad = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" +
		"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n";
}

int violates (struct *node, struct *wholefile) {
	if (XXX) {
		return 1;
	}

	return 0;
}
