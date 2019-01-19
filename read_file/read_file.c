#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>

int usage() {
	printf("Usage: read_file filename\n\n");

	printf("Reads in a file and creates a datastructure of the ");
	printf("symbols with extra\ninformation.  ");
	printf("Then it writes two new files, the first recreates the\n");
	printf("original file.  ");
	printf("The second prints out the internal datastructure.\n\n");

	return 1;
}

int read_config(char *filename) {
	FILE *infile;

	if (!(infile = fopen("<",filename))) {
		printf("Unable to open %s\n", filename);
		return 0;
	}

	/* XXX do the work here */

	fclose(infile);

	return 1;
}

int main() {
	read_config("read_file.conf");

	return 1;
}
