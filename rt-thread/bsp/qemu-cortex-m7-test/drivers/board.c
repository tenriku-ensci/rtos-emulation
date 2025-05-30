#include <rthw.h>
#include <rtthread.h>
#include "board.h"

#define UART0_BASE 0x40004000U
#define UART_DATA     (*(volatile uint32_t *)(UART0_BASE + 0x00))
#define UART_STATE    (*(volatile uint32_t *)(UART0_BASE + 0x04))
#define UART_CTRL     (*(volatile uint32_t *)(UART0_BASE + 0x08))
#define UART_BAUDDIV  (*(volatile uint32_t *)(UART0_BASE + 0x10))
#define UART_TX_FULL  (1U << 0)

#define SAU_CTRL   (*(volatile uint32_t*)0xE000EDD0)

static inline void __ISB(void)
{
    __asm volatile("isb" ::: "memory");
}

static inline void __DSB(void)
{
    __asm volatile("dsb" ::: "memory");
}

#define PPC_BASE           0x4008F000U
#define AHB_PPC0_PRCTRL0   (*(volatile uint32_t*)(PPC_BASE + 0x000))
#define APB_PPC0_PRCTRL    (*(volatile uint32_t*)(PPC_BASE + 0x07C))

#define SCC_BASE           0x4002F000U
#define SCC_PERIPHCLKENSET (*(volatile uint32_t*)(SCC_BASE + 0x044))
#define SCC_PERIPHRSTENCLR (*(volatile uint32_t*)(SCC_BASE + 0x048))

#define SYST_CSR   (*(volatile uint32_t*)0xE000E010)
#define SYST_RVR   (*(volatile uint32_t*)0xE000E014)
#define SYST_CVR   (*(volatile uint32_t*)0xE000E018)

#ifndef SYSTEM_CORE_CLOCK
#define SYSTEM_CORE_CLOCK 100000000
#endif
static uint32_t SystemCoreClock = SYSTEM_CORE_CLOCK;

static void sau_disable_and_secure_all(void)
{
    SAU_CTRL = 0;
    __ISB();
    __DSB();
}

static void ppc_open_all(void)
{
    AHB_PPC0_PRCTRL0 = 0xFFFFFFFFU;
    APB_PPC0_PRCTRL  = 0xFFFFFFFFU;
}

static void uart0_gate_and_reset(void)
{
    SCC_PERIPHCLKENSET = 1U;
    SCC_PERIPHRSTENCLR = 1U;
}

static void uart0_init(void)
{
    UART_BAUDDIV = (25000000 / 115200) - 1; /* 25 MHz PCLK */
    UART_CTRL = 1U; /* TX_EN */
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

    sau_disable_and_secure_all();
    ppc_open_all();
    uart0_gate_and_reset();
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
