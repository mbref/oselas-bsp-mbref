#include <stdio.h>
#include <stdlib.h>

void print_val(int x)
{
	printf("Got: %d\n", x);
}

int main(int argc, char *argv[])
{
	int loop;
	for (loop = 0; loop < 10; loop++)
		print_val(loop);

	exit(EXIT_SUCCESS);
}
