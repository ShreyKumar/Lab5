module counter (SW, KEY, HEX0, HEX1);

  input KEY[0], SW[1:0];
  output HEX0[6:0], HEX1[6:0];
  reg Q[7:0];

  inner_counter (
    .enable(SW[1]),
    .clk(KEY[0]),
    .clear_b(SW[0]),
    .q(Q[7:0])

  );

  sevenseg S1 (
    .Data(Q[3:0]),
    .Display(HEX0)
  );

  sevenseg S1 (
    .Data(Q[7:4]),
    .Display(HEX1)
  );

endmodule




module inner_counter (enable, clk, clear_b, q);

  input enable, clk, clear_b;
  output[7:0] reg q;

  tff_async T0 (
    .t(enable),
    .clk(clk),
    .reset(clear_b),
    .q(q[0])
  );

  tff_async T1 (
    .t(enable && (& q[0])),
    .clk(clk),
    .reset(clear_b),
    .q(q[1])
  );

  tff_async T2 (
    .t(enable && (& q[1:0])),
    .clk(clk),
    .reset(clear_b),
    .q(q[2])
  );

  tff_async T3 (
    .t(enable && (& q[2:0])),
    .clk(clk),
    .reset(clear_b),
    .q(q[3])
  );

  tff_async T4 (
    .t(enable && (& q[3:0])),
    .clk(clk),
    .reset(clear_b),
    .q(q[4])
  );

  tff_async T5 (
    .t(enable && (& q[4:0])),
    .clk(clk),
    .reset(clear_b),
    .q(q[5])
  );

  tff_async T6 (
    .t(enable && (& q[5:0])),
    .clk(clk),
    .reset(clear_b),
    .q(q[6])
  );

  tff_async T7 (
    .t(enable && (& q[6:0])),
    .clk(clk),
    .reset(clear_b),
    .q(q[7])
  );

endmodule



module tff_async (t, clk, reset, q);

input t, clk, reset;
output reg q;

always @(posedge clk, negedge reset)
begin
  if(~reset)
    q <= 1'b0;
 else
    q <= q ^ t;
end

endmodule


module sevenseg (Display, Data);
	input[3:0] Data;
	output[6:0] Display;

	assign Display[0] = ~Data[3] & ~Data[2] & ~Data[1] &  Data[0] |
			 ~Data[3] &  Data[2] & ~Data[1] & ~Data[0] |
			  Data[3] &  Data[2] & ~Data[1] &  Data[0] |
			  Data[3] & ~Data[2] &  Data[1] &  Data[0];

	assign Display[1] = ~Data[3] &  Data[2] & ~Data[1] &  Data[0] |
			  Data[3] &  Data[2] & ~Data[1] & ~Data[0] |
			  Data[3] &           Data[1] &  Data[0] |
			           Data[2] &  Data[1] & ~Data[0];

	assign Display[2] =  Data[3] &  Data[2] & ~Data[1] & ~Data[0] |
			 ~Data[3] & ~Data[2] &  Data[1] & ~Data[0] |
			  Data[3] &  Data[2] &  Data[1];


	assign Display[3] = ~Data[3] &  Data[2] & ~Data[1] & ~Data[0] |
			          ~Data[2] & ~Data[1] &  Data[0] |
			           Data[2] &  Data[1] &  Data[0] |
			  Data[3] & ~Data[2] &  Data[1] & ~Data[0];

	assign Display[4] = ~Data[3] &                    Data[0] |
			 ~Data[3] &  Data[2] & ~Data[1]          |
			          ~Data[2] & ~Data[1] &  Data[0];


	assign Display[5] = ~Data[3] & ~Data[2]          &  Data[0] |
			 ~Data[3] & ~Data[2] &  Data[1]          |
			 ~Data[3] &           Data[1] &  Data[0] |
			  Data[3] &  Data[2] & ~Data[1] &  Data[0];

	assign Display[6] = ~Data[3] & ~Data[2]  & ~Data[1]         |
			 ~Data[3] &  Data[2] &  Data[1] &  Data[0] |
			  Data[3] &  Data[2] & ~Data[1] & ~Data[0];

endmodule
