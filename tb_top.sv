`timescale 10ns/10ns
`include "top.sv"

module top_tb;

    parameter PWM_INTERVAL = 1200;

    logic clk = 0;
    logic LED;

    top # (
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u0 (
        .clk            (clk), 
        .LED            (LED)
    );

    initial begin
        $dumpfile("top.vcd");
        $dumpvars(0, top_tb);
        #100000000
        $finish;
    end

    always begin
        #4
        clk = ~clk;
    end

endmodule
