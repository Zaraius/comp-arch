`include "fsm.sv"
`include "pwm.sv"

// Fade top level module

module top #(
    parameter PWM_INTERVAL = 1200       // CLK frequency is 12MHz, so 1,200 cycles is 100us
)(
    input logic     clk, 
    output logic    LED,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    logic [$clog2(PWM_INTERVAL)-1:0] r_pwm_value;
    logic [$clog2(PWM_INTERVAL)-1:0] g_pwm_value;
    logic [$clog2(PWM_INTERVAL)-1:0] b_pwm_value;
    logic r_pwm_out;
    logic g_pwm_out;
    logic b_pwm_out;

    fsm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u1 (
        .clk            (clk), 
        .r_pwm_value      (r_pwm_value),
        .g_pwm_value      (g_pwm_value),
        .b_pwm_value      (b_pwm_value)
    );

    pwm #(
        .PWM_INTERVAL(PWM_INTERVAL)
    ) pwm_red (
        .clk(clk),
        .pwm_value(r_pwm_value),
        .pwm_out(r_pwm_out)
    );

    pwm #(
        .PWM_INTERVAL(PWM_INTERVAL)
    ) pwm_green (
        .clk(clk),
        .pwm_value(g_pwm_value),
        .pwm_out(g_pwm_out)
    );

    pwm #(
        .PWM_INTERVAL(PWM_INTERVAL)
    ) pwm_blue (
        .clk(clk),
        .pwm_value(b_pwm_value),
        .pwm_out(b_pwm_out)
    );

    assign RGB_R = ~r_pwm_out;
    assign RGB_B = ~b_pwm_out;
    assign RGB_G = ~g_pwm_out;

endmodule