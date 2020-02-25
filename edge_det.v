

/*
edge_det edge_det(
.clk(),
.sig(),
.pos(),
.neg()
);
*/
module edge_det(
input clk,sig,
output reg pos,neg);
reg [2:0]r ;
always @ (posedge clk) r[2:0] <= {r[1:0] ,sig};
always @ (posedge clk) pos <= r[2:1]  == 2'b01;
always @ (posedge clk) neg <= r[2:1]  == 2'b10;
endmodule