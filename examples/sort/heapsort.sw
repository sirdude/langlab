int *quicksort(int *in) {
see mergesort slightly modify it....
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
values = quicksort(values);
print_values(values);
