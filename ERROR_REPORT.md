# QEMU Cortex-M7 Test Failure

## Steps Performed
1. Built the firmware for `qemu-cortex-m7-test` using `scons -j$(nproc)`.
2. Ran the image with `qemu-system-arm -M mps2-an500 -kernel rtthread.bin -nographic -serial mon:stdio` as documented.
3. Observed that QEMU executed but no output was produced on the console.
4. Tried variations including additional QEMU options (`-cpu cortex-m7`, `-semihosting`, debug flags) and captured logs. No RT-Thread banner or `Hello RT-Thread` message appeared.
5. Verified that build artifacts were generated correctly and checked UART initialization code in `board.c`.

## Unresolved Issues
- QEMU runs without errors but produces no serial output. Debugging with GDB shows execution reaches `rt_hw_console_output`.
- UART registers at `0x40004008` and `0x40004010` remain zero even after attempting to enable the clock and reset in `board.c`.
- Enabling all bits in hypothetical PPC registers at `0x4008F07C` or `0x5008F07C` had no visible effect; the locations either read back zero or are unmapped.
- The exact peripheral protection setup for this QEMU machine could not be determined, leaving the UART inaccessible.
- Lacking documentation for the minimal BSP's hardware mapping makes it difficult to confirm the correct peripheral addresses.
- Time constraints prevented deeper debugging of RT-Thread startup sequence and QEMU device settings.

As a result, the RT-Thread boot message could not be displayed and the underlying cause remains unresolved.
