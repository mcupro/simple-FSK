/*
FSK_DEmodulator #(.SHORT_VALUE (0) ) FSK_DEmodulator (
.bb_clk( ),
.bit_out( )  ,
.v_short( ) , 
.v_long( ) ,
.flag_bit( )   
);
*/
 
module FSK_DEmodulator #(parameter SHORT_VALUE = 0 )(
input bb_clk,
output reg  bit_out  ,
input [15:0] v_short , v_long ,
input  flag_bit   
);
 
wire flag_bit_cross;
 
wire [15:0] v_short_w , v_long_w  ;
 
synchronizer #( .WIDTH(16)  )synchronizer_v_short(.clk(bb_clk),.in(v_short),.out(v_short_w)); 
synchronizer #( .WIDTH(16)  )synchronizer_v_long(.clk(bb_clk),.in(v_long),.out(v_long_w)); 
 
edge_det edge_det(.clk(bb_clk),.sig(flag_bit),.pos(),.neg(flag_bit_cross));
 
reg [15:0]  c;always @ (posedge bb_clk)c <= (flag_bit_cross)?0:(c+1);
 
always @ (posedge bb_clk)if (flag_bit_cross) 
begin if(c<v_short_w) bit_out <= SHORT_VALUE;else if (c>v_long_w)bit_out <= ~ SHORT_VALUE ;end   
 
endmodule 
 