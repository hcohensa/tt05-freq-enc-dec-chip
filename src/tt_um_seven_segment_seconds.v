`default_nettype none

module tt_um_seven_segment_seconds #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = ! rst_n;
    wire [6:0] led_out;
    assign uo_out[6:0] = led_out;
    assign uo_out[7] = 1'b0;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;

    // put bottom 8 bits of second counter out on the bidirectional gpio
    assign uio_out = second_counter[7:0];



module TopModule (
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire ena,
    input wire clk,
    input wire rst_n
);
    wire reset = ~rst_n;
    wire [6:0] led_out;
    wire pulse_output;
    wire [7:0] data_output;
    
    PLL pll_inst (
        .clk_in(clk),
        .pll_clk_out()
    );

    FrequencyEncoder encoder_inst (
        .data_input(ui_in),
        .enable(pll_clk_out), // Enable based on PLL output
        .clk(clk),
        .pulse_output(pulse_output)
    );

    FrequencyDecoder decoder_inst (
        .pulse_input(uio_in),
        .enable(pll_clk_out), // Enable based on PLL output
        .clk(clk),
        .data_output(data_output)
    );

    assign uo_out[6:0] = led_out;
    assign uo_out[7] = 1'b0;
    assign uio_oe = 8'b11111111;
    assign uio_out = data_output;
endmodule
