`default_nettype none

module tt_um_freq_hcohensa #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);



wire reset = ~rst_n;

    wire [6:0] led_out;
    assign uo_out[6:0] = led_out;
    assign uo_out[7] = 1'b0;

    assign uio_oe = 8'b11111111;
    assign uio_out = data_output; // Assuming data_output is properly assigned in your design

    wire pulse_output;
    wire [7:0] data_output;
    wire pll_clk_out; // Declare pll_clk_out

    PLL pll_inst (
        .clk_in(clk),
        .pll_clk_out(pll_clk_out)  // Connect PLL output to a wire
    );

    // Instantiate Encoder and Decoder modules with corrected port sizes
    FrequencyEncoder encoder_inst (
        .data_input(ui_in[0]),  // Assuming only the LSB is used
        .enable(pll_clk_out),
        .clk(clk),
        .pulse_output(pulse_output)
    );

    FrequencyDecoder decoder_inst (
        .pulse_input(uio_in[0]),  // Assuming only the LSB is used
        .enable(pll_clk_out),
        .clk(clk),
        .data_output(data_output)
    );

endmodule