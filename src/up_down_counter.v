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

    reg [3:0] count;
    wire enable = ui_in[0];      // Using first input bit as enable
    wire up_down = ui_in[1];     // Second input bit as up/down control
    wire set = ui_in[2];         // Third input bit as set control
    wire [3:0] set_value = ui_in[6:3];  // Bits 6:3 for set value

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000; // Reset count to 0
        end else if (set) begin
            count <= set_value; // Load set_value if set is high
        end else if (enable) begin
            if (up_down && count < 4'b1111) begin
                count <= count + 1; // Count up, prevent overflow
            end else if (!up_down && count > 4'b0000) begin
                count <= count - 1; // Count down, prevent underflow
            end
        end
    end

    assign uo_out = {4'b0000, count}; // Output count on lower 4 bits
    assign uio_out = 8'b00000000;     // Explicitly assign unused IO outputs to 0
    assign uio_oe = 8'b00000000;      // Explicitly assign unused IO enables to 0

endmodule
