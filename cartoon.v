module cartoon (sw7,game_state,clk,green,red,row,leave_times,success);
    input [1:0] game_state;
    input success;
    input clk,sw7;
    input [4:0] leave_times;
    output [7:0] green,red;
    output reg [7:0] row;

    reg [7:0] red_cartoon [7:0];    //红色点阵动画
    reg [7:0] green_cartoon [7:0];  //绿色点阵动画
    reg [7:0] scan [7:0];           //行扫描信号
    reg [2:0] cnt;                  //辅助行扫描信号的循环
    reg [20:0] times;               //结束动画的计时器

    //启动时初始化
    initial begin
        times<=0;
        cnt<=0;
        scan[0]<=8'b11111110;
        scan[1]<=8'b11111101;
        scan[2]<=8'b11111011;
        scan[3]<=8'b11110111;
        scan[4]<=8'b11101111;
        scan[5]<=8'b11011111;
        scan[6]<=8'b10111111;
        scan[7]<=8'b01111111;
    end

    //行信号不断循环
    always @(posedge clk) begin
        cnt=cnt+1;
        row=scan[cnt];
    end


    always @(posedge clk) begin
        if (!sw7) begin
            //未开启游戏，点阵不显示
            times<=0;
            red_cartoon[0]<=8'b00000000;
            red_cartoon[1]<=8'b00000000;
            red_cartoon[2]<=8'b00000000;
            red_cartoon[3]<=8'b00000000;
            red_cartoon[4]<=8'b00000000;
            red_cartoon[5]<=8'b00000000;
            red_cartoon[6]<=8'b00000000;
            red_cartoon[7]<=8'b00000000;
            green_cartoon[0]<=8'b00000000;
            green_cartoon[1]<=8'b00000000;
            green_cartoon[2]<=8'b00000000;
            green_cartoon[3]<=8'b00000000;
            green_cartoon[4]<=8'b00000000;
            green_cartoon[5]<=8'b00000000;
            green_cartoon[6]<=8'b00000000;
            green_cartoon[7]<=8'b00000000;
        end
        else begin 
            if (game_state==0) begin
                //开启游戏，点阵显示炸弹
                red_cartoon[0]<=8'b00011000;
                red_cartoon[1]<=8'b00011000;
                red_cartoon[2]<=8'b00011000;
                red_cartoon[3]<=8'b00011000;
                red_cartoon[4]<=8'b00011000;
                red_cartoon[5]<=8'b00100100;
                red_cartoon[6]<=8'b00100100;
                red_cartoon[7]<=8'b00011000;
                green_cartoon[0]<=8'b00011000;
                green_cartoon[1]<=8'b00011000;
                green_cartoon[2]<=8'b00011000;
                green_cartoon[3]<=8'b00011000;
                green_cartoon[4]<=8'b00000000;
                green_cartoon[5]<=8'b00000000;
                green_cartoon[6]<=8'b00000000;
                green_cartoon[7]<=8'b00000000;
            end
            else if (game_state==1) begin
                //开始游戏后倒计时五秒显示炸弹
                red_cartoon[0]<=8'b00011000;
                red_cartoon[1]<=8'b00011000;
                red_cartoon[2]<=8'b00011000;
                red_cartoon[3]<=8'b00011000;
                red_cartoon[4]<=8'b00011000;
                red_cartoon[5]<=8'b00100100;
                red_cartoon[6]<=8'b00100100;
                red_cartoon[7]<=8'b00011000;
                green_cartoon[0]<=8'b00011000;
                green_cartoon[1]<=8'b00011000;
                green_cartoon[2]<=8'b00011000;
                green_cartoon[3]<=8'b00011000;
                green_cartoon[4]<=8'b00000000;
                green_cartoon[5]<=8'b00000000;
                green_cartoon[6]<=8'b00000000;
                green_cartoon[7]<=8'b00000000;
            end
            else if (game_state==2) begin

                //炸弹燃烧的动画，每五秒少一行引信
                if (leave_times-1>=15) begin
                    red_cartoon[0]<=8'b00011000;
                    red_cartoon[1]<=8'b00011000;
                    red_cartoon[2]<=8'b00011000;
                    red_cartoon[3]<=8'b00011000;
                    red_cartoon[4]<=8'b00011000;
                    red_cartoon[5]<=8'b00100100;
                    red_cartoon[6]<=8'b00100100;
                    red_cartoon[7]<=8'b00011000;
                    green_cartoon[0]<=8'b00011000;
                    green_cartoon[1]<=8'b00011000;
                    green_cartoon[2]<=8'b00011000;
                    green_cartoon[3]<=8'b00011000;
                    green_cartoon[4]<=8'b00000000;
                    green_cartoon[5]<=8'b00000000;
                    green_cartoon[6]<=8'b00000000;
                    green_cartoon[7]<=8'b00000000;
                end
                else if (leave_times-1>=10) begin
                    red_cartoon[0]<=8'b00000000;
                    green_cartoon[0]<=8'b00000000;
                end
                else if(leave_times-1>=5) begin
                    red_cartoon[1]<=8'b00000000;
                    green_cartoon[1]<=8'b00000000;
                end
                else if (leave_times-1>0) begin
                    red_cartoon[2]<=8'b00000000;
                    green_cartoon[2]<=8'b00000000;
                end
                else begin
                    red_cartoon[3]<=8'b00000000;
                    green_cartoon[3]<=8'b00000000;
                end
                times<=0;
            end
            else if(game_state==3) begin

                //结束动画绿色点阵不显示
                green_cartoon[0]<=8'b00000000;
                green_cartoon[1]<=8'b00000000;
                green_cartoon[2]<=8'b00000000;
                green_cartoon[3]<=8'b00000000;
                green_cartoon[4]<=8'b00000000;
                green_cartoon[5]<=8'b00000000;
                green_cartoon[6]<=8'b00000000;
                green_cartoon[7]<=8'b00000000;

                //成功时的点阵动画
                if (success==1) begin
                    times<=times+1;
                    if (times<=100000) begin
                        red_cartoon[0]<=8'b00000000;
                        red_cartoon[1]<=8'b01100110;
                        red_cartoon[2]<=8'b00000000;
                        red_cartoon[3]<=8'b00000000;
                        red_cartoon[4]<=8'b00000000;
                        red_cartoon[5]<=8'b00000000;
                        red_cartoon[6]<=8'b00000000;
                        red_cartoon[7]<=8'b00000000;
                    end
                    else if(times<=200000) begin
                        red_cartoon[2]<=8'b11111111;
                    end
                    else if(times<=300000) begin
                        red_cartoon[3]<=8'b11111111;
                    end
                    else if(times<=400000) begin
                        red_cartoon[1]<=8'b00000000;
                        red_cartoon[4]<=8'b11111111;
                    end
                    else if (times<=500000) begin
                        red_cartoon[2]<=8'b00000000;
                        red_cartoon[5]<=8'b01111110;
                    end
                    else if(times<=600000) begin
                        red_cartoon[3]<=8'b00000000;
                        red_cartoon[6]<=8'b00111100;
                    end
                    else if(times<=700000) begin
                        red_cartoon[4]<=8'b00000000;
                        red_cartoon[7]<=8'b00011000;
                    end
                    else if (times<=800000) begin
                        red_cartoon[5]<=8'b00000000;
                    end
                    else if(times<=900000) begin
                        red_cartoon[6]<=8'b00000000;
                    end
                    else if(times<=1000000) begin
                        red_cartoon[7]<=8'b00000000;
                    end
                    else if(times<=1250000) begin
                        red_cartoon[0]<=8'b00000000;
                        red_cartoon[1]<=8'b01100110;
                        red_cartoon[2]<=8'b11111111;
                        red_cartoon[3]<=8'b11111111;
                        red_cartoon[4]<=8'b11111111;
                        red_cartoon[5]<=8'b01111110;
                        red_cartoon[6]<=8'b00111100;
                        red_cartoon[7]<=8'b00011000;
                    end
                    else if(times<=1500000) begin
                        red_cartoon[0]<=8'b00000000;
                        red_cartoon[1]<=8'b00000000;
                        red_cartoon[2]<=8'b00000000;
                        red_cartoon[3]<=8'b00000000;
                        red_cartoon[4]<=8'b00000000;
                        red_cartoon[5]<=8'b00000000;
                        red_cartoon[6]<=8'b00000000;
                        red_cartoon[7]<=8'b00000000;
                    end
                    else if(times<=1750000) begin
                        red_cartoon[0]<=8'b00000000;
                        red_cartoon[1]<=8'b01100110;
                        red_cartoon[2]<=8'b11111111;
                        red_cartoon[3]<=8'b11111111;
                        red_cartoon[4]<=8'b11111111;
                        red_cartoon[5]<=8'b01111110;
                        red_cartoon[6]<=8'b00111100;
                        red_cartoon[7]<=8'b00011000;
                    end
                    else if(times<=2000000) begin
                        red_cartoon[0]<=8'b00000000;
                        red_cartoon[1]<=8'b00000000;
                        red_cartoon[2]<=8'b00000000;
                        red_cartoon[3]<=8'b00000000;
                        red_cartoon[4]<=8'b00000000;
                        red_cartoon[5]<=8'b00000000;
                        red_cartoon[6]<=8'b00000000;
                        red_cartoon[7]<=8'b00000000;
                    end
                    else begin
                        times<=0;
                    end
                end

                //失败时的动画，“加”和“油”循环显示
                else begin
                    if (times<=500000) begin
                        times<=times+1;
                        red_cartoon[0]<=8'b00000000;
                        red_cartoon[1]<=8'b01000000;
                        red_cartoon[2]<=8'b11110111;
                        red_cartoon[3]<=8'b01010101;
                        red_cartoon[4]<=8'b01010101;
                        red_cartoon[5]<=8'b01010101;
                        red_cartoon[6]<=8'b01010111;
                        red_cartoon[7]<=8'b00000000;
                    end
                    else if(times<=1000000) begin
                        times<=times+1;
                        red_cartoon[0]<=8'b00000000;
                        red_cartoon[1]<=8'b11000100;
                        red_cartoon[2]<=8'b00000100;
                        red_cartoon[3]<=8'b11011111;
                        red_cartoon[4]<=8'b00010101;
                        red_cartoon[5]<=8'b00011111;
                        red_cartoon[6]<=8'b01010101;
                        red_cartoon[7]<=8'b10011111;
                    end
                    else begin
                        times<=0;
                    end
                end
            end
        end
    end

    assign red=red_cartoon[cnt];
    assign green=green_cartoon[cnt];
endmodule