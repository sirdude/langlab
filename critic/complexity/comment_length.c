#include <critic.h>

struct critmod;

int init() {
	critmod.name = "comment_length";
	critmod.criticality = 3;
	critmod.package = "complexity";
	critmod.info = "Comment blocks that span more than 10 lines.  " +
		"Consider refactoring this code to a function so you can " +
		"comment it out with one line.  If this comment is " +
		"describing what a function or variable does, it should " +
		"use the built-in commenting features of our language.";

	critmod.good = "int dostuff() {\n";
	critmod.good += "   a = 5;\n";
	critmod.good += "   b = 5;\n";
	critmod.good += "   c = 5;\n";
	critmod.good += "   d = 5;\n";
	critmod.good += "   e = 5;\n";
	critmod.good += "   f = 5;\n";
	critmod.good += "   g = 5;\n";
	critmod.good += "   h = 6;\n";
	critmod.good += "   i = 5;\n";
	critmod.good += "   j = 5;\n";
	critmod.good += "   k = 5;\n";
	critmod.good += "}\n";
	critmod.good += "\n";
	critmod.good += "# do_stuff();\n";

	critmod.bad = "int dostuff() {\n";
	critmod.bad += "#   a = 5;\n";
	critmod.bad += "#   b = 5;\n";
	critmod.bad += "#   c = 5;\n";
	critmod.bad += "#   d = 5;\n";
	critmod.bad += "#   e = 5;\n";
	critmod.bad += "#   f = 5;\n";
	critmod.bad += "#   g = 5;\n";
	critmod.bad += "#   h = 6;\n";
	critmod.bad += "#   i = 5;\n";
	critmod.bad += "#   j = 5;\n";
	critmod.bad += "#   k = 5;\n";
	critmod.bad += "# }\n";
	critmod.bad += "\n";
	critmod.bad += "do_stuff();\n";
}

int getline_count(struct *node) {
/* XXX */
}

int violates (struct *node, struct *wholefile) {
	if (node.type != comment) {
		return 0;
	}

	if (getline_count(node) > 10) {
		return 1;
	}

	return 0;
}
