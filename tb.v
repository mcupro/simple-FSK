 
`timescale 1ns/1ns 
module tb ;



  initial 
		begin
    	$dumpfile("tb.vcd");
		$dumpvars( 0 , tb );
		$display("hello tb");
		#3600_100;  
		$finish;
		end

reg clk=0;
always #5 clk  =  !clk ; 
 
reg bit_in=0;
wire bit_out;
wire [11:0]sin,cos ; 

reg [15:0]c =0;
wire c_of =  c==(3600-1) ;
always@(posedge clk )c <= ( c_of )? 0: c+1;
always@(posedge clk ) if (c_of )bit_in <=!bit_in ;


FSK_modulator   FSK_modulator (
 .bb_clk(clk),
 .bit_in(bit_in) ,
 .cnt0(  0 ),
 .cnt1( 0  ),
 .step0( 4 ),
 .step1( 9 ),
 .sin(sin) ,
 .cos(cos) 
 );

wire flag_bit = sin[11] ;

FSK_DEmodulator #(.SHORT_VALUE (0) )FSK_DEmodulator (
.bb_clk(clk ),
.bit_out( bit_out )  ,
.v_short( 50) , 
.v_long( 80 ) ,
.flag_bit( flag_bit)   
);




endmodule










 

 