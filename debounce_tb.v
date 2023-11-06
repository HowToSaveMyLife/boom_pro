module debounce_tb;
    localparam  times = 5000;
    reg btn = 0;
    reg clk = 0;
    wire btn_pulse;

    debounce
        #(
            .times (
                times )
        )
        debounce_dut (
            .btn (btn ),
            .clk (clk ),
            .btn_pulse  ( btn_pulse)
        );

    initial begin
        begin
            btn=1;
            #60000
             btn=0;
            #5000
             btn=1;
            #60000

             $finish;
        end
    end

    always
        #5  clk = ! clk ;

endmodule
