module segment (seg_data,seg_led);

    input [3:0] seg_data;
    output [7:0] seg_led;

    reg [7:0] seg [15:0];

    initial begin
        seg[0] = 8'h3f;//对存储器中第一个数赋值8'b0011_1111,7段显示数字0
        seg[1] = 8'h06;//7段显示数字  1
        seg[2] = 8'h5b;//7段显示数字  2
        seg[3] = 8'h4f;//7段显示数字  3
        seg[4] = 8'h66;//7段显示数字  4
        seg[5] = 8'h6d;//7段显示数字  5
        seg[6] = 8'h7d;//7段显示数字  6
        seg[7] = 8'h07;//7段显示数字  7
        seg[8] = 8'h7f;//7段显示数字  8
        seg[9] = 8'h6f;//7段显示数字  9
        seg[15] = 8'h00;//7段数码管不显示，全灭
    end

    assign seg_led = seg[seg_data];

endmodule