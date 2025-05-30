#include <rthw.h>
#include <rtthread.h>
#include "board.h"

#define UART0_BASE 0x40004000
#define UART_DATA     (*(volatile uint32_t *)(UART0_BASE + 0x00))
#define UART_STATE    (*(volatile uint32_t *)(UART0_BASE + 0x04))
#define UART_CTRL     (*(volatile uint32_t *)(UART0_BASE + 0x08))
#define UART_BAUDDIV  (*(volatile uint32_t *)(UART0_BASE + 0x10))
#define UART_TX_FULL  (1U << 0)

#define SYST_CSR   (*(volatile uint32_t*)0xE000E010)
#define SYST_RVR   (*(volatile uint32_t*)0xE000E014)
#define SYST_CVR   (*(volatile uint32_t*)0xE000E018)

#ifndef SYSTEM_CORE_CLOCK
#define SYSTEM_CORE_CLOCK 100000000
#endif
static uint32_t SystemCoreClock = SYSTEM_CORE_CLOCK;

static void uart0_init(void)
{
    UART_BAUDDIV = (25000000 / 115200);
    UART_CTRL = (1 << 0);
}

void rt_hw_console_output(const char *str)
{
    while (*str)
    {
        if (*str == '\n')
        {
            while (UART_STATE & UART_TX_FULL);
            UART_DATA = '\r';
        }
        while (UART_STATE & UART_TX_FULL);
        UART_DATA = *str++;
    }
}

void SysTick_Handler(void)
{
    rt_interrupt_enter();
    rt_tick_increase();
    rt_interrupt_leave();
}

void rt_hw_board_init(void)
{
#ifdef RT_USING_HEAP
    rt_system_heap_init(HEAP_BEGIN, HEAP_END);
#endif

    uart0_init();

    SYST_RVR = SystemCoreClock / RT_TICK_PER_SECOND - 1;
    SYST_CVR = 0;
    SYST_CSR = 7;

#ifdef RT_USING_CONSOLE
    rt_console_set_device(RT_CONSOLE_DEVICE_NAME);
#endif
#ifdef RT_USING_COMPONENTS_INIT
    rt_components_board_init();
#endif
}
