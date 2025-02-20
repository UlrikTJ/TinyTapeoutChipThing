# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1  # Enable is unused in the module
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0  # Active-low reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1  # Deactivate reset

    dut._log.info("Test reset behavior")
    assert dut.uo_out.value == 0, "Counter should be reset to 0"

    dut._log.info("Test counting up")
    dut.ui_in.value = 0b00000011  # enable = 1, up_down = 1, set = 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 1, "Counter should increment to 1"

    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 2, "Counter should increment to 2"

    dut._log.info("Test counting down")
    dut.ui_in.value = 0b00000001  # enable = 1, up_down = 0, set = 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 1, "Counter should decrement to 1"

    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, "Counter should decrement to 0"

    dut._log.info("Test set functionality")
    dut.ui_in.value = 0b00010100  # enable = 0, up_down = 0, set = 1, set_value = 5 (0101)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 5, "Counter should be set to 5"

    dut._log.info("Test disable functionality")
    dut.ui_in.value = 0b00000000  # enable = 0, up_down = 0, set = 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 5, "Counter should remain unchanged (disabled)"

    dut._log.info("Test counting up with overflow prevention")
    dut.ui_in.value = 0b00000011  # enable = 1, up_down = 1, set = 0
    for _ in range(15):
        await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 15, "Counter should reach maximum value (15)"

    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 15, "Counter should not overflow (stay at 15)"

    dut._log.info("Test counting down with underflow prevention")
    dut.ui_in.value = 0b00000001  # enable = 1, up_down = 0, set = 0
    for _ in range(15):
        await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, "Counter should reach minimum value (0)"

    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, "Counter should not underflow (stay at 0)"

    dut._log.info("All tests passed")