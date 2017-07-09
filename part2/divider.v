module divider (CLOCK_50, SW, KEY, HEX0);

    input CLOCK_50;
    input [1:0] SW;
    input [1:0] KEY;
    input [6:0] HEX0;
    wire [31:0] ratedivider_out;
    wire [3:0] displaycounter_out;
    wire displaycounter_enable;
    reg [31:0] period;

    assign displaycounter_enable = (ratedivider_out == 0) ? 1 : 0;

    always @ (SW)
    begin
        case(SW[1:0])
            2'b00: period <= 1;
            2'b01: period <= 50000000;
            2'b10: period <= 100000000;
            2'b11: period <= 200000000;
            default: period <= 0;
        endcase
    end

    ratedivider u0 (
        .clock(CLOCK_50),
        .reset_n(KEY[0]),
        .period(period),
        .q(ratedivider_out)
    );

    displaycounter u1 (
        .clock(CLOCK_50),
        .reset_n(KEY[0]),
        .enable(displaycounter_enable),
        .q(displaycounter_out)
    );

    sevenseg u2 (
        .Data(displaycounter_out),
        .Display(HEX0)
    );

endmodule


module ratedivider (clock, period, reset_n, q);

    input clock;
    input reset_n;
    input [31:0] period;
    output reg [31:0] q;

    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= period - 1;
        else
            begin
                if (q == 0)
                    q <= period - 1;
                else
                    q <= q - 1'b1;
        end
    end

endmodule


module displaycounter (clock, reset_n, enable, q);

    input clock;
    input reset_n;
    input enable;
    output reg [3:0] q;

    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else if (enable == 1'b1)
            begin
                if (q == 4'b1111)
                    q <= 0;
                else
                    q <= q + 1'b1;
            end
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
