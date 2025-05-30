#ifndef __BOARD_H__
#define __BOARD_H__

#include <rtconfig.h>
#include <stdint.h>

extern unsigned int __bss_end__;

#define HEAP_BEGIN ((void *)&__bss_end__)
#define HEAP_END   ((void *)0x20080000)

void rt_hw_board_init(void);
void rt_hw_console_output(const char *str);

#endif
