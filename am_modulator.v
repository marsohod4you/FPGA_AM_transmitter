
module am_modulator(
	input wire clk,
	input wire [7:0]signal,
	input wire signed [15:0]mod_sin,
	output wire [5:0]out
);

//make signed 16bit signal from input unsigned 8bit signal
reg signed [15:0]ssignal;
always @(posedge clk)
	ssignal <= { signal, 8'h00 } - 16'h8000;

//modulate by multiplying useful signal on modulation freq sinusoida
reg signed [31:0]multiplied;
always @(posedge clk)
	multiplied <= ssignal * mod_sin;

reg signed [15:0]multiplied_th; //top half
always @(posedge clk)
	multiplied_th <= multiplied[31:16];

//add modulation freq carrier to signal
reg signed [15:0]s_after_mod;
always @(posedge clk)
	s_after_mod <= ( (mod_sin>>>1)+multiplied_th );

//make unsigned
reg [15:0]after_mod;
always @(posedge clk)
	after_mod <= s_after_mod + 16'h8000;

assign out = after_mod[15:10];


/*
//add modulation freq carrier to signal
reg signed [31:0]s_after_mod;
always @(posedge clk)
	s_after_mod <= ( $signed( {mod_sin[15], mod_sin[15], mod_sin, 14'h0000} ) + $signed(multiplied>>>1) );

//make unsigned
reg [31:0]after_mod;
always @(posedge clk)
	after_mod <= s_after_mod + 32'h80000000;

assign out = after_mod[31:26];
*/

endmodule
