/* Our hash implementation is basically an array of buckets
   Each bucket is a linked list 
   To lookup an item in the hash you first find the bucket and then
   search the linked list for the item you need.
*/

int increment; /* size to grow our hash table by when needed */
int buckets; /* current number of buckets in our hash */
int maxdepth; /* This is the depth that triggers an expansion of the 
	hash table */
string type; /* Type of hash. */
object *items; /* our buckets */
object *titems; /* temporary buckets for new hash. */

int valid_type(string input_type) {
	switch(input_type) {
		case "string":
		case "int":
		case "float":
		case "object":
		case "hash":
		case "mixed":
			return 1;
			break;
		default:
			return 0;
			break;
	}
}

int get_bucket(string name) {
	int bucket;
	int tmp;

	tmp = (int)name;

	bucket = tmp % buckets;
	return bucket;
}

int grow_hash() {
	int c;

	c = 0;
	while (c<buckets) {
		/* XXX Do the work here... */

		c = c + 1;
	}
}

int insert_item(string key, mixed *value) {
	int bucket, depth, tmp;
	object next, temp;

	tmp = (int)key;
	bucket = tmp % buckets;

	next = clone_object("bucketitem.c");

	if (!next) {
		return 0;
	}

	next->set_key(key);
	next->set_value(value);

	if (!items[bucket]) {
		items[bucket] = next;

		return 1;
	} else {
		depth = 0;
		temp = items[bucket];

		while (temp->query_next()) {
			depth = depth + 1;
			temp = temp->query_next();
		}

		temp->set_next(next);

		if (depth > maxdepth) {
			grow_hash();
		}

		return 1;
	}

	return 0;
}

int remove_item(string key, mixed *value) {
	int bucket, tmp;
	object current, next;

	tmp = (int)key;
	bucket = tmp % buckets;
	current = items[bucket];

	if (!current) {
		return 0;
	}

	if (current->query_key() == key) {
		items[bucket] = current->query_next();
		current->destruct();
		return 1;
	}

	while(current) { 
		next = current->next;
		if (next && (next->query_key() == key)) {
			current->set_next(next->query_next());
			next->destruct();
			return 1;
		}
		current = next;	
	}

	return 0;
}

mixed *lookup_item(string key) {
	int bucket, tmp;
	object bucketitems;

	tmp = (int)key;
	bucket = tmp % buckets;
	bucketitems = items[bucket];

	while(bucketitems) {
		if (bucketitems->query_key() == key) {
			return bucketitems->query_value();
		}
		bucketitems = bucketitems->query_next();
	}

	return nil;
}

int main(string input_type) {
	increment = 100;
	maxdepth = 10;
	buckets = increment;

	if (valid_type(input_type)) {
		type = input_type;
	} else {
		write("Invalid type: " + input_type + "\n");
	}
}
