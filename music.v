module music(clk,buzzer,success,music_state,game_state,leave_times);
    input clk,success;
    input [4:0] leave_times;
    input [1:0] game_state;
    output reg buzzer;
    output reg [1:0] music_state;

    reg [10:0] per;
    reg [6:0] cnt0;
    reg [16:0] time_cnt;
    reg [11:0] one_cnt;
    reg di;

    //以下为C大调中各音调对应的频率，带"_"的均为升半调
    localparam
        A2 = 110,
        A2_ = 117,
        B2 = 123,

        C3 = 131,
        C3_ = 139,
        D3 = 147,
        D3_ = 156,
        E3 = 165,
        F3 = 175,
        F3_ = 185,
        G3 = 196,
        G3_ = 208,
        A3 = 220,
        A3_ = 233,
        B3 = 247,

        C4 = 262,
        C4_ = 277,
        D4 = 294,
        D4_ = 311,
        E4 = 330,
        F4 = 349,
        F4_ = 370,
        G4 = 392,
        G4_ = 415,
        A4 = 440,
        A4_ = 466,
        B4 = 494,

        C5 = 522,
        C5_ = 554,
        D5 = 587,
        D5_ = 622,
        E5 = 659,
        F5 = 698,
        F5_ = 740,
        G5 = 784,
        G5_ = 831,
        A5 = 880,
        A5_ = 932,
        B5 = 988,

        C6 = 1047;

    initial begin
        per<=0;
        cnt0<=0;
        time_cnt<=0;
        one_cnt<=0;
        music_state<=0;
        buzzer<=0;
        di<=0;
    end

    always @(posedge clk) begin

        //炸弹倒计时的时候，蜂鸣器随时间变化，滴滴声变得急促
        if (game_state==2) begin

            //响一次“滴”的控制语句
            if (di==1) begin

                //炸弹的滴滴声音调为C5，频率为522hz，时钟频率为1Mhz，所以C5的一个周期中有1M/522个时钟周期
                //但音调需要半个音调周期翻转，所以计数器one_cnt<500000/522≈958
                if (one_cnt<958) begin
                    one_cnt<=one_cnt+1;
                end
                else begin
                    one_cnt<=0;
                    buzzer<=!buzzer;
                end

                //炸弹的响一次“滴”时间为0.125s，1024*121≈125000
                if (per<=1023) begin
                    if (cnt0<121) begin
                        cnt0<=cnt0+1;
                    end
                    else begin
                        cnt0<=0;
                        per<=per+1;
                    end
                end
                else begin
                    buzzer<=0;
                    one_cnt<=0;
                    per<=0;
                    cnt0<=0;
                    di<=0;
                end
            end

            //每两个“滴”之间时间长度的控制语句
            else begin

                //外层计数器每过0.001s加1，当one_cnt ms满足条件时，转换状态，蜂鸣器响一次“滴”
                if (one_cnt<15+leave_times*43) begin

                    //内层计数器为0.001s，当内层计数器计满0.001s，外层计数器加1
                    if(per<999) begin
                        per<=per+1;
                    end
                    else begin
                        per<=0;
                        one_cnt<=one_cnt+1;
                    end
                end
                else begin
                    one_cnt<=0;
                    per<=0;
                    di<=1;
                end
            end
        end

        //在游戏结束时，蜂鸣器响一段音乐
        else if (game_state==3) begin

            //播放音乐前初始化并转换音乐播放状态为1
            if (music_state==0) begin
                music_state<=1;
                one_cnt<=0;
                time_cnt<=0;
                buzzer<=0;
                per<=0;
                cnt0<=0;
            end
            else begin

                //游戏成功的乐谱，播放完成后转换音乐播放状态为2
                if (success==1) begin

                    case (cnt0)
                        0:
                            per=G3;
                        1:
                            per=G3;
                        2:
                            per=G3;
                        3:
                            per=C4;
                        4:
                            per=C4;
                        5:
                            per=E4;
                        6:
                            per=E4;
                        7:
                            per=E4;
                        8:
                            per=G4;
                        9:
                            per=G4;
                        10:
                            per=G4;
                        11:
                            per=C5;
                        12:
                            per=C5;
                        13:
                            per=E5;
                        14:
                            per=E5;
                        15:
                            per=E5;
                        16:
                            per=G5;
                        17:
                            per=G5;
                        18:
                            per=G5;
                        19:
                            per=G5;
                        20:
                            per=G5;
                        21:
                            per=G5;
                        22:
                            per=G5;
                        23:
                            per=G5;
                        24:
                            per=E5;
                        25:
                            per=E5;
                        26:
                            per=E5;
                        27:
                            per=E5;
                        28:
                            per=E5;
                        29:
                            per=E5;
                        30:
                            per=E5;
                        31:
                            per=E5;
                        32:
                            per=G3_;
                        33:
                            per=G3_;
                        34:
                            per=G3_;
                        35:
                            per=C4;
                        36:
                            per=C4;
                        37:
                            per=D4_;
                        38:
                            per=D4_;
                        39:
                            per=D4_;
                        40:
                            per=G4_;
                        41:
                            per=G4_;
                        42:
                            per=G4_;
                        43:
                            per=C5;
                        44:
                            per=C5;
                        45:
                            per=D5_;
                        46:
                            per=D5_;
                        47:
                            per=D5_;
                        48:
                            per=A5_;
                        49:
                            per=A5_;
                        50:
                            per=A5_;
                        51:
                            per=A5_;
                        52:
                            per=A5_;
                        53:
                            per=A5_;
                        54:
                            per=A5_;
                        55:
                            per=A5_;
                        56:
                            per=D5_;
                        57:
                            per=D5_;
                        58:
                            per=D5_;
                        59:
                            per=D5_;
                        60:
                            per=D5_;
                        61:
                            per=D5_;
                        62:
                            per=D5_;
                        63:
                            per=D5_;
                        64:
                            per=A3_;
                        65:
                            per=A3_;
                        66:
                            per=A3_;
                        67:
                            per=D4;
                        68:
                            per=D4;
                        69:
                            per=F4;
                        70:
                            per=F4;
                        71:
                            per=F4;
                        72:
                            per=A4_;
                        73:
                            per=A4_;
                        74:
                            per=A4_;
                        75:
                            per=D5;
                        76:
                            per=D5;
                        77:
                            per=F5;
                        78:
                            per=F5;
                        79:
                            per=F5;
                        80:
                            per=A5_;
                        81:
                            per=A5_;
                        82:
                            per=A5_;
                        83:
                            per=A5_;
                        84:
                            per=A5_;
                        85:
                            per=A5_;
                        86:
                            per=A5_;
                        87:
                            per=A5_;
                        88:
                            per=A5_;
                        89:
                            per=A5_;
                        90:
                            per=A5_;
                        91:
                            per=A5_;
                        92:
                            per=A5_;
                        93:
                            per=A5_;
                        94:
                            per=A5_;
                        95:
                            per=A5_;
                        96:
                            per=C6;
                        97:
                            per=C6;
                        98:
                            per=C6;
                        99:
                            per=C6;
                        100:
                            per=C6;
                        101:
                            per=C6;
                        102:
                            per=C6;
                        103:
                            per=C6;
                        104:
                            per=C6;
                        105:
                            per=C6;
                        106:
                            per=C6;
                        107:
                            per=C6;
                        108:
                            per=C6;
                        109:
                            per=C6;
                        110:
                            per=C6;
                        111:
                            per=C6;
                        default: begin
                            music_state<=2;
                        end
                    endcase
                end

                //游戏失败的乐谱
                else begin

                    case (cnt0)
                        0:
                            per=C5;
                        1:
                            per=C5;
                        2:
                            per=C5;
                        3:
                            per=C5;
                        4:
                            per=C5;
                        5:
                            per=G4;
                        6:
                            per=G4;
                        7:
                            per=G4;
                        8:
                            per=G4;
                        9:
                            per=G4;
                        10:
                            per=E4;
                        11:
                            per=E4;
                        12:
                            per=E4;
                        13:
                            per=E4;
                        14:
                            per=A4;
                        15:
                            per=A4;
                        16:
                            per=B4;
                        17:
                            per=B4;
                        18:
                            per=A4;
                        19:
                            per=A4;
                        20:
                            per=G4_;
                        21:
                            per=G4_;
                        22:
                            per=A4_;
                        23:
                            per=A4_;
                        24:
                            per=G4_;
                        25:
                            per=G4_;
                        26:
                            per=E4;
                        27:
                            per=E4;
                        28:
                            per=D4;
                        29:
                            per=D4;
                        30:
                            per=E4;
                        31:
                            per=E4;
                        32:
                            per=E4;
                        33:
                            per=E4;
                        34:
                            per=E4;
                        35:
                            per=E4;
                        36:
                            per=E4;
                        37:
                            per=E4;
                        default: begin
                            music_state<=2;
                        end
                    endcase
                end

                //外层if结合time_cnt控制每个音调响的时间
                //成功和失败的单个音调时间不同，所以会有time_cnt<=120000-success*60000-1判断句
                //当一个音调时间计满，cnt0加一，进入下一个音调的播放，并将各个计数器归零
                if (time_cnt<=120000-success*60000-1) begin
                    time_cnt<=time_cnt+1;

                    //内层if控制蜂鸣器以某个音调的频率响
                    //音调频率为per，时钟频率为1Mhz，所以一个音调的周期中有1M/per个时钟周期
                    //但音调需要半个音调周期翻转，所以计数器one_cnt<=500000/per，但是除法会占用大量逻辑器件
                    if(one_cnt*per<=500000) begin
                        one_cnt<=one_cnt+1;
                    end
                    else begin
                        one_cnt<=0;
                        buzzer<=!buzzer;
                    end
                end
                else begin
                    buzzer<=0;
                    time_cnt<=0;
                    cnt0<=cnt0+1;
                    one_cnt<=0;
                end
            end
        end
        else begin
            music_state<=0;
            buzzer<=0;
            per<=0;
            cnt0<=0;
            time_cnt<=0;
            one_cnt<=0;
        end
    end
endmodule
