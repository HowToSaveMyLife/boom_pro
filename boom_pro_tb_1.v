`timescale 100ns/100ns
module boom_pro_tb_1;
    reg sw7 = 0;
    reg start = 0;
    reg clk = 0;
    reg btn6 = 0;
    reg [6:0] sw_input;
    wire buzzer;
    wire [7:0] row;
    wire [7:0] red;
    wire [7:0] green;
    wire [1:0] seg_cat;
    wire [7:0] seg;
    wire [6:0] led;

    boom_pro
        boom_dut (
            .sw7 (sw7 ),
            .start (start ),
            .clk (clk ),
            .btn6 (btn6 ),
            .sw_input (sw_input ),
            .buzzer (buzzer ),
            .row (row ),
            .red (red ),
            .green (green ),
            .seg_cat (seg_cat ),
            .seg (seg ),
            .led  ( led)
        );

    initial begin
        begin
            btn6=0;
            sw_input=0;
            start=0;
            sw7=0;
            #10000000
             sw7=1;
            #5000000

             start=1;
            #3000
             start=0;
            #3000
             start=1;
            #1500
             start=0;
            #4000000

             start=1;
            #3000
             start=0;
            #3000
             start=1;
            #1500
             start=0;
            #2000
             start=1;
            #60000
             start=0;

            #80000000

             sw7=0;
            #30000
             sw7=1;
            #4000000
             start=1;
            #60000
             start=0;
            #300000000
             $finish;
        end
    end

    always
        #5  clk = ! clk ;

endmodule