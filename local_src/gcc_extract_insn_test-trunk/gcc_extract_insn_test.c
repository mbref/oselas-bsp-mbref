/*
 * http://gcc.gnu.org/bugzilla/show_bug.cgi?id=40742
 */

#include <stdio.h>

#define APP_ENTRY_POINT_BASE	((unsigned int)0x300000)
#define APP_ENTRY_POINT_OFFSET	((unsigned int)0x200000)
#define APP_ENTRY_POINT		(APP_ENTRY_POINT_BASE + APP_ENTRY_POINT_OFFSET)

int main()
{
	(*((void(*)())APP_ENTRY_POINT))();
	return 0;
}

