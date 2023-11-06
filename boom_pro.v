module boom_pro(sw7,start,clk,led,seg,sw_input,row,seg_cat,btn6,buzzer,green,red);
    input sw7,start,clk,btn6;       //分别为游戏开关，开始按键，时钟(1Mhz)，确认密码按键
    input [6:0] sw_input;           //密码输入的7位拨码开关
    output buzzer;                  //蜂鸣器
    output [7:0] row,red,green;     //扫描行信号，红色列信号，绿色列信号
    output [7:0] seg_cat;           //数码管的扫描信号
    output [7:0] seg;               //8位数码管
    output reg [6:0] led;           //显示密码的7位led

    reg [1:0] ps_input_times;       //输入密码错误的次数
    reg success;                    //游戏是否成功，为1表明游戏成功，0表示游戏失败
    reg [6:0] password;             //保存的密码
    reg [1:0] game_state;           //游戏状态，0~3，0为游戏未开始，1为倒计时5s，2为拆弹时的倒计时，3为游戏结束动画与音乐结算
    reg [4:0] countdown_times;      //倒计时的时间，最多到30
    reg [4:0] user_defined_cdtime;  //玩家自己设定时间，最多到30
    reg btn6_before;                //记录玩家上一个确认键的状态，用于结合btn_pulse用于判断用户松开按键的动作

    wire [4:0] leave_times;         //剩余的时间
    wire [1:0] music_state;         //音乐播放的状态，0为不播放，1为正在播放，2为播放完成
    wire [1:0] countdown_state;     //记录倒计时的状态，0为未开始或拆弹倒计时结束，1为正在倒计时5s，2为倒计时5s与拆弹倒计时的过渡，3为拆弹倒计时
    wire [6:0] changing_pw;         //随时钟变化的伪随机数，在按下开始时将密码赋给password
    wire btn6_pulse;                //确认件消抖后的信号
    wire start_pulse;               //开始键消抖后的信号

    initial begin
        btn6_before<=0;
        user_defined_cdtime<=0;
        ps_input_times<=0;
        led<=0;
        success<=0;
        game_state<=0;
        password<=0;
        countdown_times<=0;
        user_defined_cdtime<=0;
    end

    always @(posedge clk) begin
        if (!sw7) begin
            //关闭游戏，初始化
            btn6_before<=0;
            user_defined_cdtime<=0;
            ps_input_times<=0;
            led<=0;
            success<=0;
            game_state<=0;
            password<=0;
            countdown_times<=0;
            user_defined_cdtime<=0;
        end
        else begin
            //游戏开关打开
            if (game_state==0) begin
                //游戏未开始

                //若按下开始按钮，开始游戏，生成密码
                if (start_pulse) begin
                    success<=0;
                    btn6_before<=0;
                    game_state<=1;
                    countdown_times<=5;
                    password<=changing_pw;
                end

                //若此时将sw6设为1，则进行自定义倒计时，倒计时的时间为sw4:sw0的二进制编码
                //设定时间超过30视为30s
                if (sw_input[6]==1) begin
                    if (sw_input[4:0]>30) begin
                        user_defined_cdtime<=30;
                    end
                    else begin
                        user_defined_cdtime<=sw_input[4:0];
                    end
                end
                //不自定义时间，设定时间为20s
                else begin
                    user_defined_cdtime<=20;
                end

            end
            else if (game_state==1) begin
                //5s倒计时，数字在数码管显示，led不变，炸弹动画显示(不变)
                led<=password;

                //5s倒计时结束，进入下一状态
                if (countdown_state==2&&leave_times==0) begin
                    countdown_times<=user_defined_cdtime;
                    game_state<=2;
                    led<=0;
                end
            end
            else if (game_state==2) begin
                //20s倒计时，数字在数码管显示，led显示密码输入，炸弹动画随时间变化
                led<=sw_input;

                //输入次数的判定，以及倒计时结束时游戏结束
                //输入两次错误的密码，游戏结束
                if (ps_input_times<2) begin

                    //当玩家松开确认键之后，才算为一次密码输入
                    //否则若玩家按住按键不松，会判断为多次输入密码，与预期功能不符
                    if (btn6_pulse==1&&btn6_before==0) begin

                        //输入密码正确，游戏成功
                        //输入密码错误，记录输入次数的寄存器加一
                        if (sw_input==password) begin
                            game_state<=3;
                            success<=1;
                            led<=0;
                        end
                        else begin
                            ps_input_times<=ps_input_times+1;
                        end
                    end

                    //倒计时结束，游戏失败
                    if (countdown_state==0&&leave_times==0) begin
                        game_state<=3;
                        success<=0;
                        led<=0;
                    end
                end
                else begin
                    game_state<=3;
                    success<=0;
                    led<=0;
                end
                btn6_before<=btn6_pulse;
            end
            else if (game_state==3) begin
                //播放音乐与显示动画
                //若音乐播放完，game_state为0
                if (music_state==2) begin
                    game_state<=0;
                    success<=0;
                    password<=0;
                    countdown_times<=0;
                    ps_input_times<=0;
                end
            end
        end
    end

    //消抖模块
    debounce debounce1(
                 .btn(start),
                 .clk(clk),
                 .btn_pulse(start_pulse));

    debounce debounce2(
                 .btn(btn6),
                 .clk(clk),
                 .btn_pulse(btn6_pulse));

    //随机数模块
    rand rand1(
             .clk(clk),
             .out(changing_pw));

    //数码管显示模块
    disp disp1(
             .clk(clk),
             .sw7(sw7),
             .leave_times(leave_times),
             .user_defined_cdtime(user_defined_cdtime),
             .game_state (game_state),
             .seg_cat(seg_cat),
             .seg_led(seg));

    //倒计时模块
    countdown countdown1(
                  .clk(clk),
                  .sw7(sw7),
                  .game_state(game_state),
                  .countdown_times(countdown_times),
                  .leave_times(leave_times),
                  .countdown_state(countdown_state));

    //音乐模块
    music music1(
              .clk(clk),
              .success(success),
              .game_state(game_state),
              .leave_times(leave_times),
              .buzzer(buzzer),
              .music_state(music_state));

    //动画模块
    cartoon cartoon1(
                .game_state(game_state),
                .success(success),
                .clk(clk),
                .sw7(sw7),
                .leave_times(leave_times),
                .green(green),
                .red(red),
                .row(row)
            );
endmodule
