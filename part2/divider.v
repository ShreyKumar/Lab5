module divider (CLOCK_50, SW, KEY, HEX0);

    input CLOCK_50;
    input [1:0] SW;
    input KEY;
    wire [31:0] rate_out;
    wire [3:0] display_data;
    wire d_enable;

    asign d_enable = (rate_out == 8'h0000000) ? 1 : 0;

    ratedivider u0 (
        .clock(CLOCK_50),
        .selector(SW),
        .reset_n(KEY[0]),
        .q(rate_out)
    );

    displaycounter u1 (
        .clock(CLOCK_50),
        .reset_n(KEY[0]),
        .enable(d_enable),
        .q(display)
    );

    sevenseg u2 (
        .Data(display_data),
        .Display(HEX0)
    );

endmodule




module ratedivider (clock, selector, reset_n, q);

    input clock;
    input [1:0] selector;
    input reset_n;
    output reg [31:0] q;
    reg [31:0] rate;


    always @ *
    begin
        case(selector[1:0])
            2'b00: rate <= 1'd1;
            2'b01: rate <= 8'd50000000;
            2'b10: rate <= 9'd100000000;
            2'b11: rate <= 9'd200000000;
            default: rate <= 1'd1;
        endcase
    end

    always @(posedge clock)
    begin
        if (reset n = 1'b0)
            q <= rate;
        else
            begin
                if (q == 0)
                    q <= rate;
                else
                    q <= q - 1'b1;
            end
endmodule


module displaycounter (clock, reset_n, enable, q);

    input clock;
    input reset_n;
    input enable;
    output reg [3:0] q;

    always @(posedge clock)
    begin
        if (reset n = 1'b0)
            q <= 0;
        else if (enable == 1'b1)
            begin
                if (q == 4'b1111)
                    q <= 0;
                else
                    q <= q + 1'b1;
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
