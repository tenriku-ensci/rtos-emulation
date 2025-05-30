#include <rtthread.h>
#include <stdio.h>

int main(void)
{
    extern int rtthread_startup(void);
    return rtthread_startup();
}
