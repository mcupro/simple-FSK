   

/*
FSK_modulator   FSK_modulator (
 .bb_clk(),
 .bit_in() ,
 .cnt0(),
 .cnt1(),
 .step0(),
 .step1(),
 .sin() ,
 .cos()  
);
*/

module FSK_modulator(
input bb_clk,
input bit_in ,
input [15:0] cnt0,cnt1,
input [7:0]  step0,step1,
output reg [11:0]  sin ,cos  
);
 
wire [11:0]  sin_w,cos_w;
always @(posedge bb_clk)sin<=sin_w;
always @(posedge bb_clk)cos<=cos_w;
 
wire [15:0] cnt0_w,cnt1_w ;
wire [7:0 ] step0_w,step1_w ; 
 
synchronizer #( .WIDTH(16)  )synchronizer_cnt0(.clk(bb_clk),.in(cnt0),.out(cnt0_w)); 
synchronizer #( .WIDTH(16)  )synchronizer_cnt1(.clk(bb_clk),.in(cnt1),.out(cnt1_w)); 
synchronizer #( .WIDTH(8)  )synchronizer_step0(.clk(bb_clk),.in(step0),.out(step0_w)); 
synchronizer #( .WIDTH(8)  )synchronizer_step1(.clk(bb_clk),.in(step1),.out(step1_w)); 

reg [15:0] cnt = 0;
reg [7:0] step = 0  ;
 
always@(posedge bb_clk) cnt  <= ( bit_in ) ? cnt1_w  : cnt0_w ;
always@(posedge bb_clk) step <= ( bit_in ) ? step1_w  : step0_w ;
 
my_dds my_dds(.clk( bb_clk ) ,.rst( 1'b0 ) ,.clr ( 1'b0 ) ,.cnt( cnt) ,.step( step)  ,.sin(sin_w )  ,.cos(cos_w )  ); 
 
 
endmodule 
 
 
 
 
 