#include <critic.h>
/* Not sure on this one...  If we depend on editor displaying code correctly we can ignore these limits ??? hard to say at this point */

struct critmod;

int init() {
	critmod.name = "whitespace_at_endofline";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Lines should not have trailing spaces or tabs.";
}

int violates (struct *node, struct *wholefile) {
	if (XXX) {
		return 1;
	}

	return 0;
}
