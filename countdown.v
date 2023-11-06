module countdown(clk,countdown_times,leave_times,sw7,game_state,countdown_state);
    input clk,sw7;
    input [1:0] game_state;
    input [4:0] countdown_times;
    output reg [4:0] leave_times;
    output reg [1:0] countdown_state;

    reg [19:0] second;          //记录1s的寄存器

    always @(posedge clk) begin
        if (!sw7) begin
            //关闭游戏，初始化
            leave_times<=0;
            countdown_state<=0;
            second<=0;
        end
        else begin

            //倒计时5s部分
            if (game_state==1) begin
                if (countdown_state==0) begin
                    leave_times<=countdown_times;
                    countdown_state<=1;
                end
                else begin
                    if (second==999999) begin
                        if (leave_times>1) begin
                            leave_times<=leave_times-1;
                            second<=0;
                        end
                        else begin
                            countdown_state<=2;
                            leave_times<=0;
                            second<=0;
                        end
                    end
                    else begin
                        second<=second+1;
                    end
                end
            end

            //拆弹倒计时部分
            else if (game_state==2) begin
                if(countdown_state==2) begin
                    leave_times<=countdown_times;
                    countdown_state<=3;
                end

                else begin
                    if (second==999999) begin
                        if (leave_times>1) begin
                            leave_times<=leave_times-1;
                            second<=0;
                        end
                        else begin
                            countdown_state<=0;
                            leave_times<=0;
                            second<=0;
                        end
                    end
                    else begin
                        second<=second+1;
                    end
                end
            end

            //其余状态计时器恢复默认
            else begin
                leave_times<=0;
                countdown_state<=0;
                second<=0;
            end
        end
    end
endmodule