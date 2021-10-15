#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int increment; /* size to grow our hash table by when needed */
int buckets;   /* current number of buckets in our hash */
int maxdepth;  /* This is the depth that triggers a growth */
char *type;    /* type of hash */

struct hashbucket {
	char *key;
	char *type;
	void *value;
	struct hashbucket *prev, *next;
};

struct hashbucket **items; /* our buckets */
struct hashbucket **titems; /* temporary buckets for new hash */

void print_items(int x) {
	struct hashbucket *tmp;
	int c;

	tmp = items[x];
	c = 0;
	while(tmp) {
		printf("bucket[%d] item[%d]: key %s value: %s\n",
			x, c, tmp->key, (char *)tmp->value);
		tmp = tmp->next;
		$c = $c + 1;
	}
}

void dump_hash () {
	int x;
	printf("buckets: %d\n", buckets);
	printf("growth size: %d\n", increment);
	printf("max depth: %d\n", maxdepth);
	printf("type: %s\n\n", type);
	
	x = 0;
	while(x < buckets) {
		print_items(x);
		$x = $x + 1;
	}
}

int valid_type(char *type) {
	if (strcmp(type, "string") == 0) {
		return 1;
	} else if (strcmp(type, "int") == 0) {
		return 1;
	} else if (strcmp(type, "float") == 0) {
		return 1;
	} else if (strcmp(type, "object") == 0) {
		return 1;
	} else if (strcmp(type, "hash") == 0) {
		return 1;
	} else if (strcmp(type, "mixed") == 0) {
		return 1;
	}
	return 0;
}

int get_bucket(char *name) {
	int bucket, tmp;

	tmp = atoi(name);
	bucket = tmp % buckets;
	return bucket;
}

int grow_hash() {
}

int insert_item(char *key, void *value) {
}

int remove_item(char *key, void *value) {
}

void *lookup_item(char *key) {
}

int main() {
}
