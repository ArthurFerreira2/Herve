#define PUTCHAR 0xe000000

void _start() {

	char* putchar;
	putchar = (char*)PUTCHAR;
	*putchar = 'H';
	*putchar = 'e';
	*putchar = 'l';
	*putchar = 'l';
	*putchar = 'o';
	*putchar = '\n';


}
