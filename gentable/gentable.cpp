// gentable.cpp: определяет точку входа для консольного приложения.
//

#include "stdafx.h"
#define _USE_MATH_DEFINES 1
#include <math.h>

#define TABLE_LEN 64

int _tmain(int argc, _TCHAR* argv[])
{
	printf("WIDTH = 16;\n");
	printf("DEPTH = %d;\n",TABLE_LEN);
	printf("ADDRESS_RADIX = HEX;\n");
	printf("DATA_RADIX = HEX;\n");
	printf("CONTENT BEGIN\n");

	for(int i=0; i<TABLE_LEN; i++)
	{
		short s = 32767 * sin(2*M_PI/TABLE_LEN*i);
		printf("%04X: %04X;\n",i,(unsigned short)s);
	}

	printf("END\n");

	return 0;
}

