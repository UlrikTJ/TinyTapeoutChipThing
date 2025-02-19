module tt_um_UlrikTJ_up_down_counter (
    input wire clk,            // TinyTapeout's clock
    input wire rst_n,          // Active-low reset
    input wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,  // Dedicated outputs
    input wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out, // IOs: Output path
    output wire [7:0] uio_oe,  // IOs: Enable path
    input wire ena             // Enable signal (unused)
);

    reg [7:0] count;                    // Increase count to 8-bit
    wire enable = ui_in[0];             // Using first input bit as enable
    wire up_down = ui_in[1];            // Second input bit as up/down control
    wire set = ui_in[2];                // Third input bit as set control
    wire [3:0] set_value = ui_in[6:3];  // Bits 6:3 for set value

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 8'b00000000;  // Reset count to 0
        else if (set)
            count <= {4'b0000, set_value};  // Load 4-bit set_value into count's lower bits
        else if (enable) begin
            if (up_down && count < 8'b11111111) 
                count <= count + 1;  // Count up (up to 255)
            else if (!up_down && count > 8'b00000000) 
                count <= count - 1;  // Count down (to 0)
        end
    end

    assign uo_out = count;  // Output full 8-bit count

    assign uio_out = 8'b00000000;     // Explicitly assign unused IO outputs to 0
    assign uio_oe = 8'b00000000;      // Explicitly assign unused IO enables to 0

endmodule
