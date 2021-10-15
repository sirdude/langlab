int *bubble(int *in) {
   int done, x, maxx, tmp;

   done = 0;
   maxx = sizeof(in);
   while (!done) {
      done = 1;
      x = 0;
      while (x < maxx) {
         if (in[x] > in[x + 1]) {
            tmp = in[x];
            in[x] = in[x + 1];
            in[x + 1] = tmp;
            done = 0;
      }
      maxx = maxx - 1;
   }

   return in;
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
values = bubblesort(values);
print_values(values);
