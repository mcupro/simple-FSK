

/////////////////////////////////////////////////////////////////////
////                                                             ////
////  Universal FIFO Dual Clock, gray e//
// Copyright 2014 Ettus Research LLC
// Copyright 2018 Ettus Research, a National Instruments Company
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//
/*
synchronizer #(.WIDTH (  1  )) synchronizer (  .clk(),    .in(),  .out());
*/

module synchronizer #(
   parameter WIDTH            = 1,
   parameter STAGES           = 2,
   parameter INITIAL_VAL      = 0,
   parameter FALSE_PATH_TO_IN = 1
)(
   input              clk,
   input  [WIDTH-1:0] in,
   output [WIDTH-1:0] out
);
wire rst=0;
   //Q: Why do we have a separate impl and instantiate
   //it with a different instance name based on this
   //arbitrary parameter FALSE_PATH_TO_IN?
   //A: To make constraining these synchronizers easier.
   //We would like to write a single false path constraint
   //for all synchronizers when the input is truly async.
   //However other cases might require constraining the input
   //of this module.
   //To enable this, all clients that hook up async signals to
   //the "in" port can set FALSE_PATH_TO_IN=1 (or use the default)
   //and all clients that want the "in" delay to be constrained can
   //set FALSE_PATH_TO_IN=0.
   //In the XDC we can write the following async constraint:
   //set_false_path -to [get_pins */synchronizer_false_path/stages[0].value_reg[0]/D]
   //and this will take care of all instances of this module with FALSE_PATH_TO_IN==1
  
//  assign out=in;
 
   generate if (FALSE_PATH_TO_IN == 1) begin
      synchronizer_impl #(
        .WIDTH(WIDTH), .STAGES(STAGES), .INITIAL_VAL(INITIAL_VAL)
      ) synchronizer_false_path (
         .clk(clk), .rst(rst), .in(in), .out(out)
      );
   end else begin
      synchronizer_impl #(
        .WIDTH(WIDTH), .STAGES(STAGES), .INITIAL_VAL(INITIAL_VAL)
      ) synchronizer_constrained (
         .clk(clk), .rst(rst), .in(in), .out(out)
      );
   end endgenerate

 
endmodule   //synchronizer





//
// Copyright 2014 Ettus Research LLC
// Copyright 2018 Ettus Research, a National Instruments Company
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//

module synchronizer_impl #(
   parameter WIDTH       = 1,
   parameter STAGES      = 2,
   parameter INITIAL_VAL = 0
)(
   input              clk,
   input              rst,
   input  [WIDTH-1:0] in,
   output [WIDTH-1:0] out
);

   (* ASYNC_REG = "TRUE" *) reg [WIDTH-1:0] value[0:STAGES-1];

   integer k;
   initial begin
     for (k = 0; k < STAGES; k = k + 1) begin
       value[k] = INITIAL_VAL;
     end
   end

   genvar i;
   generate
      for (i=0; i<STAGES; i=i+1) begin: stages
         always @(posedge clk) begin
            if (rst) begin
               value[i] <= INITIAL_VAL;
            end else begin
               if (i == 0) begin
                 value[i] <= in;
               end else begin
                 value[i] <= value[i-1];
               end
            end
         end
      end
   endgenerate

   assign out = value[STAGES-1];

endmodule   //synchronizer_impl
   