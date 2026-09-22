
module top(
    input logic clk, 
    output logic RGB_R, RGB_G, RGB_B
);
    // Creating interval of 1/6seconds since clock is 12MHz
    parameter BLINK_INTERVAL = 2000000;
    logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;

    initial begin

    end

    always_ff @(posedge clk) begin

    end

endmodule
