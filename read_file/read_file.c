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
	char *buffer;
	size_t bufsize = 4048;  /* Way bigger than a line should need to be */
	size_t characters;
	int c = 0;

	infile = fopen(filename, "r");

	if (!infile) {
		printf("Unable to open %s\n", filename);
		return 0;
	}

	buffer = (char *)malloc(bufsize * sizeof(char));
	if (buffer == NULL) {
		printf("Error, unable to allocate buffer for reading.\n");
		exit(1);
	}

	while (characters = getline(&buffer, &bufsize, infile) != -1) {
		c = c + 1;
		if (buffer[0] == '#') {
		} else if (strncmp(buffer,"comment,",8) == 0) {
			/* XXX need to fill this in */
		} else if (strncmp(buffer,"string,",7) == 0) {
			/* XXX need to fill this in */
		} else {
			printf("Error, line %d: %s\n", c, buffer);
		}
	}

	fclose(infile);

	return 1;
}

int read_file(char *filename) {
	FILE *infile;

	infile = fopen(filename, "r");

	if (!infile) {
		printf("Unable to open %s\n", filename);
		return 0;
	}

	fclose(infile);

	return 1;
}

int main(int argc, char *argv[]) {
	read_config("read_file.conf");

	if (argc != 2) {
		usage();
		return 0;
	}

	return read_file(argv[1]);
}
