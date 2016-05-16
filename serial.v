  
module serial(
	input wire reset,
	input wire clk64,	//64MHz
	input wire rx,
	output reg [7:0]rx_byte,
	output reg rbyte_ready
	);

parameter RCONST = 381; //230400bps

reg [1:0]shr;
always @(posedge clk64)
	shr <= {shr[0],rx};
wire rxf; assign rxf = shr[1];
wire rx_edge; assign rx_edge = shr[0]!=shr[1];

reg [15:0]cnt;
wire bit; assign bit = (cnt==RCONST || rx_edge);

reg [3:0]num_bits;
reg [7:0]shift_reg;

always @(posedge clk64 or posedge reset)
begin
	if(reset)
		cnt <= 0;
	else
	begin
		if( bit )
			cnt <= 0;
		else
		if(num_bits<9)
			cnt <= cnt + 1'b1;
	end
end

always @(posedge clk64 or posedge reset)
begin
	if(reset)
	begin
		num_bits <= 0;
		shift_reg <= 0;
	end
	else
	begin
		if(num_bits==9 && shr[0]==1'b0 )
			num_bits <= 0;
		else
		if( bit )
			num_bits <= num_bits + 1'b1;
				
		
		if( cnt == RCONST/2 )
			shift_reg <= {rxf,shift_reg[7:1]};
	end
end

reg [2:0]flag;
always @(posedge clk64 or posedge reset)
	if(reset)
		flag <= 3'b000;
	else
		flag <= {flag[1:0],(num_bits==9)};

always @*
	rbyte_ready = (flag==3'b011);

always @(posedge clk64 or posedge reset)
	if(reset)
		rx_byte <= 0;
	else
	if(flag==3'b001)
		rx_byte <= shift_reg[7:0];

	
endmodule
