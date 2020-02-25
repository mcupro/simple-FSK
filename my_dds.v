

/*
my_dds my_dds(
.clk( ) ,
.rst( ) ,
.clr ( ) ,
.cnt( ) ,
.step( )  ,
.sin( )  ,
.cos( )  ,
); 
*/
module my_dds(
input clk ,rst,clr ,
input [15:0]  cnt,
input [7:0]   step ,
output   [11:0]  sin ,cos 
);

reg local_rst = 0  ;
always@(posedge clk)  local_rst <= rst |  clr ; 
reg [8:0]  degree = 0 , sin_degree=0,cos_degree=0,nxt_degree =0 ;

always @(posedge clk) sin_degree<=degree;
always @(posedge clk) cos_degree<=degree + 90 ;
always @* nxt_degree=degree + step ;
reg [15:0] c =0 ;  
wire c_of = (cnt==0) || ( c>=cnt ) ;
always @(posedge clk) if (local_rst) c <= 0 ; else if ( c_of ) c <= 0;  else c <= c + 1 ;
always @(posedge clk) if (local_rst ) degree <= 0; else  if ( c==0 )
begin if (nxt_degree>=360) degree <=0;else  degree <= nxt_degree ; end 

 sin_lut_table sin_lut_table(	 .clk(clk ),  	 .addr(sin_degree ) , 	 .q(sin )	); 
 sin_lut_table cos_lut_table(	 .clk(clk ),  	 .addr(cos_degree ) , 	 .q(cos )	); 

endmodule 



