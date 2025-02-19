<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is a 4-bit up/down counter that increments or decrements based on user input. It operates based on a clock signal (`clk`) and an active-low reset (`rst_n`).

- **Enable (`ui_in[0]`)**: When high, the counter is active.
- **Up/Down (`ui_in[1]`)**: Determines the count direction (1 = up, 0 = down).
- **Set (`ui_in[2]`)**: If high, the counter loads the value from `ui_in[6:3]`.
- **Set Value (`ui_in[6:3]`)**: A 4-bit value that the counter will load when `set` is high.

The counter's value is output on the lower 4 bits of `uo_out[3:0]`.

## How to test

1. **Reset the counter**: Set `ui_in[2] = 0` (set mode disabled), `ui_in[0] = 1` (enable counter), and pulse `rst_n` low. The counter should reset to `0000`.
2. **Count up**: Set `ui_in[1] = 1` (up mode), `ui_in[0] = 1` (enable), and observe the output increasing on `uo_out[3:0]` with each clock cycle.
3. **Count down**: Set `ui_in[1] = 0` (down mode), `ui_in[0] = 1` (enable), and observe the output decreasing on `uo_out[3:0]`.
4. **Load a value**: Set `ui_in[2] = 1` (set mode enabled), and assign a value to `ui_in[6:3]`. The counter should immediately load this value when the clock cycles.

## External hardware

No external hardware is required.
