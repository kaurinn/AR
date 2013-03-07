
#include <stdio.h>
#include <time.h>

/*
  
  ###   ####   #   #  ###  #####  #####  #   #  #####  #   #  ####    ###
 #   #  #   #  #   #   #     #    #      #  #     #    #   #  #   #  #   #
 #####  ####   #####   #     #    ###    ###      #    #   #  ####   #####
 #   #  #  #   #   #   #     #    #      #  #     #    #   #  #  #   #   #
 #   #  #   #  #   #  ###    #    #####  #   #    #     ###   #   #  #   #

 u duginim bojama :)

*/

#define CHECK_BIT( a, b ) ( ( a ) & ( 0x80 >> ( b ) ) )

struct timespec ts;

int main( )
{
	unsigned char TextTable[ ] =
	{
		0x44, 0x88, 0xE0, 0x84, 0x4F, 0x84, 0x39, 0x12,
		0x24, 0x51, 0x12, 0x44, 0x20, 0x90, 0x21, 0x04,
		0x44, 0x49, 0x17, 0xC7, 0x91, 0x08, 0x1C, 0x38,
		0x41, 0x1F, 0x1E, 0x7D, 0x12, 0x24, 0x42, 0x09,
		0x02, 0x10, 0x44, 0x48, 0x91, 0x38, 0x79, 0x13,
		0xE4, 0x4F, 0x9F, 0x39, 0x11, 0xE3, 0x9F
	};

	char ClearScreenCodes[ ] = { 27, 91, 50, 74, 27, 91, 49, 59, 49, 72, 0 };

	for( int c = 0; ; ++c )
	{
		ts.tv_nsec = 70000000;
		nanosleep( &ts, NULL );

		printf( "%s", ClearScreenCodes );

		for( int i = 370; i >= 0; --i )
		{
			printf( "\x1b[3%dm%c", ( i / 74 + c ) % 7 + 1, CHECK_BIT( TextTable[ i / 8 ], i % 8 ) ? '#' : ' ' );

			if( ( i - 1 ) % 74 == 0 )
				printf( "\n" );
		}
	}

	return 0;
}
