module rand (clk,out);
    input clk;
    output reg [6:0] out;
    reg [31:0] state;

    initial begin
        state<=0;
    end

    //伪随机，输出随时间变化(没有做重置和种子)
    always @(posedge clk) begin
        state <= state * 32'h343fd + 32'h269EC3;
        out=(state >> 16) & 16'h7fff;
    end

endmodule