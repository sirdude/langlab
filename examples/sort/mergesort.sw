int *mergesort(int *in) {
   for (i=0; i < size; i = 2i) {
      for (j = 0; j < size -i; j = j + 2i) {
         merge(a[j], i, min(2i, size - j) );
      }
   }
}

void print_values(int *in) {
   int x, maxx;

   x = 0;
   maxx = sizeof(in);
   while (x < maxx) {
      print(in[x] + " ");
      x = x + 1;
   }
}

int *values;

values = ([1, 3, 2, 4, 7, 6, 8, 9, 10]);
values = mergesort(values);
print_values(values);
