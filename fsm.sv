module fsm #(
    parameter PWM_INTERVAL = 1200
)(
    input logic clk, 
    output logic [$clog2(PWM_INTERVAL) - 1:0] r_pwm_value,
    output logic [$clog2(PWM_INTERVAL) - 1:0] g_pwm_value,
    output logic [$clog2(PWM_INTERVAL) - 1:0] b_pwm_value
);

    // 1 second color wheel cycle
    localparam CYCLE_INTERVAL = 12500000;
    localparam PHASE_COUNT_MAX = 200;
    localparam PHASE_MAX = 6;
    localparam PWM_MAX = PWM_INTERVAL - 1;

    // Number of clock cycles between each brightness update
    localparam INC_DEC_INTERVAL = CYCLE_INTERVAL / (PHASE_MAX * PHASE_COUNT_MAX);

    // Amount to change PWM value at each brightness update
    localparam CLK_TO_PWM = PWM_MAX / (PHASE_COUNT_MAX - 1);

    // Counter for timing brightness updates
    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;
    logic time_to_inc_dec = 1'b0;

    // Counter for brightness steps within each phase
    logic [$clog2(PHASE_COUNT_MAX) - 1:0] step_in_phase = 0;

    // Current color-wheel phase
    logic [3:0] phase = 0;

    // Generate an enable every INC_DEC_INTERVAL clock cycles
    always_ff @(posedge clk) begin
        if (count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            time_to_inc_dec <= 1'b1;
        end
        else begin
            count <= count + 1;
            time_to_inc_dec <= 1'b0;
        end
    end


    // Advance the color wheel only when it is time for a brightness update
    always_ff @(posedge clk) begin
        if (time_to_inc_dec) begin
            if (step_in_phase == PHASE_COUNT_MAX - 1) begin
                step_in_phase <= 0;

                if (phase == PHASE_MAX - 1)
                    phase <= 3'd0;
                else
                    phase <= phase + 3'd1;
            end
            else begin
                step_in_phase <= step_in_phase + 1;
            end
        end
    end


    // Convert the current phase and step into RGB PWM values
    always_comb begin
        
        case (phase)
            3'd0: begin
                r_pwm_value = PWM_MAX;
                g_pwm_value = step_in_phase * CLK_TO_PWM; 
                b_pwm_value = 11'd0; 
            end

            3'd1: begin
                r_pwm_value = PWM_MAX - (step_in_phase * CLK_TO_PWM);
                g_pwm_value = PWM_MAX;
                b_pwm_value = 11'd0;
            end

            3'd2: begin
                r_pwm_value = 11'd0;
                g_pwm_value = PWM_MAX;
                b_pwm_value = step_in_phase * CLK_TO_PWM;
            end

            3'd3: begin
                r_pwm_value = 11'd0;
                g_pwm_value = PWM_MAX - (step_in_phase * CLK_TO_PWM);
                b_pwm_value = PWM_MAX;
            end

            3'd4: begin
                r_pwm_value = step_in_phase * CLK_TO_PWM;
                g_pwm_value = 11'd0;
                b_pwm_value = PWM_MAX;
            end

            3'd5: begin
                r_pwm_value = PWM_MAX;
                g_pwm_value = 11'd0;
                b_pwm_value = PWM_MAX - (step_in_phase * CLK_TO_PWM);
            end

            default: begin
                r_pwm_value = 11'd0;
                g_pwm_value = 11'd0;
                b_pwm_value = 11'd0;
            end
        endcase
    end

endmodule