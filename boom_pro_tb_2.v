`timescale 100ns/100ns
module boom_pro_tb_2;
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
            #4000000

             sw_input=7'b1010110;
            #4000000
             start=1;
            #60000
             start=0;
            #30000000
             sw_input=7'b0000000;
            #70000000
             sw_input=7'b1011100;
            #5000000
             btn6=1;
            #60000
             btn6=0;
            #5000
             btn6=1;
            #60000
             btn6=0;

            #15000000
             sw_input=7'b1000101;
            #5000000
             btn6=1;
            #60000
             btn6=0;
            #80000000
             $finish;
        end
    end

    always
        #5  clk = ! clk ;

endmodule