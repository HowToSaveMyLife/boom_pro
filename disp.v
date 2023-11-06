module disp(clk,sw7,game_state,leave_times,seg_cat,seg_led,user_defined_cdtime);
    input clk;
    input sw7;
    input [4:0] leave_times;
    input [1:0] game_state;
    input [4:0] user_defined_cdtime;
    output reg [7:0] seg_cat;
    output [7:0] seg_led;

    reg [3:0] num [0:1];    //十位与个位的存储器

    initial begin
        seg_cat<=8'b11111111;
    end

    always @(posedge clk) begin
        if (!sw7) begin
            //关闭游戏，数码管不显示
            num[0]<=15;
            num[1]<=15;
            seg_cat<=8'b11111111;
        end
        else begin

            //游戏状态为0，将设定/默认的拆弹时间显示在数码管
            if(game_state==0) begin
                if (seg_cat==8'b11111111) begin
                    seg_cat<=8'b11111110;
                end
                else begin
                    if (user_defined_cdtime>=30) begin
                        num[1]<=3;
                        num[0]<=0;
                    end
                    else if (user_defined_cdtime>=20) begin
                        num[1]<=2;
                        num[0]<=user_defined_cdtime-20;
                    end
                    else if (user_defined_cdtime>=10) begin
                        num[1]<=1;
                        num[0]<=user_defined_cdtime-10;
                    end
                    else begin
                        num[1]<=0;
                        num[0]<=user_defined_cdtime;
                    end

                    if (seg_cat==8'b11111110) begin
                        seg_cat<=8'b11111101;
                    end
                    else if(seg_cat==8'b11111101) begin
                        seg_cat<=8'b11111110;
                    end
                    else begin
                        seg_cat<=8'b11111111;
                    end
                end
            end

            //状态为1或2，数码管显示倒计时剩余的时间
            else if (game_state==1||game_state==2) begin
                if (seg_cat==8'b11111111) begin
                    seg_cat<=8'b11111110;
                end
                else begin
                    if (leave_times-1>=20) begin
                        num[1]<=2;
                        num[0]<=leave_times-21;
                    end
                    else if (leave_times-1>=10) begin
                        num[1]<=1;
                        num[0]<=leave_times-11;
                    end
                    else begin
                        num[1]<=0;
                        num[0]<=leave_times-1;
                    end

                    if (seg_cat==8'b11111110) begin
                        seg_cat<=8'b11111101;
                    end
                    else if(seg_cat==8'b11111101) begin
                        seg_cat<=8'b11111110;
                    end
                    else begin
                        seg_cat<=8'b11111111;
                    end
                end
            end

            else begin
                num[0]<=15;
                num[1]<=15;
                seg_cat<=8'b11111111;
            end
        end
    end


    segment segment1(
                .seg_data(num[seg_cat[0]]),
                .seg_led(seg_led)
            );

endmodule