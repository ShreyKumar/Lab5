module morse (KEY, SW, CLOCK_50, LEDR);

    input [1:0] KEY;
    input [2:0] SW;
    input CLOCK_50;
    output [1:0] LEDR;

    wire lut_out, ratedivider_out, shifter_enable;

    assign shifter_enable = (ratedivider_out == 0) ? 1 : 0;

    lut u0 (
        .lettercode(SW[2:0]),
        .morsecode(lut_out);
    );

    ratedivider u1 (
        .clock(CLOCK_50),
        .period(4),
        .reset_n(KEY[0]),
        .q(ratedivider_out)
    );

    shifter u2 (
        .clock(CLOCK_50),
        .load(KEY[1]),
        .enable(shifter_enable),
        .reset(KEY[0]),
        .data(lut_out),
        .out(LEDR[0])
    );

endmodule


module lut(lettercode, morsecode);

    input [2:0] lettercode;
    output [15:0] morsecode;

    always @(*)
    begin
        case(lettercode)
            3'b000: morsecode = 16'b1010100000000000;
            3'b001: morsecode = 16'b1110000000000000;
            3'b010: morsecode = 16'b1010111000000000;
            3'b011: morsecode = 16'b1010101110000000;
            3'b100: morsecode = 16'b1011101110000000;
            3'b101: morsecode = 16'b1110101011100000;
            3'b110: morsecode = 16'b1110101011100000;
            3'b111: morsecode = 16'b1110101110111000;
            default: morsecode = 16'b0000000000000000;
        endcase
    end

endmodule


module shifter(clock, enable, load, reset, data, out);

    input clock, enable, load, reset;
    input [15:0] data;
    output out;
    reg state [15:0];

    // async load and reset
    always @(posedge clock, posedge load, posedge reset)
    begin
        if (load)
            state = data;
        else if (reset)
            state = 0;
        else if (enable == 1'b1)
            state = {state[14:0], 0};
    end

    assign out = state[15];

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
