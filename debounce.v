module debounce(btn,clk,btn_pulse);
    parameter times=5000;
    input btn,clk;
    output reg btn_pulse;

    reg [12:0] N;		    //寄存器对按键信号持续时间进行计数

    //该消抖方法需要初始化，否则会输出未知信号
    initial begin
        btn_pulse<=0;
    end

    always@(posedge clk) begin
        //持续按住按键、松开按键时的消抖
        if (btn_pulse) begin
            //松开按键且按键持续时间大于0，寄存器减一
            if (btn==0&&N>0) begin
                N<=N-1;
            end

            //松开按键但按键松开时间已到达设定值，寄存器保持0不变
            else if(btn==0&&N==0) begin
                N<=0;
                btn_pulse<=0;
            end

            //当有信号输入，持续时间保持5000
            else begin
                N<=5000;
            end
        end

        //不按按键、按下按键时的消抖
        else begin
            //按下按键且按键持续时间小于设定值，寄存器加一
            if (btn&&N<times) begin
                N<=N+1;
            end

            //按下按键但按键持续时间已到达设定值，寄存器保持最大值不变
            else if(btn&&N==times) begin
                N<=N;
                btn_pulse<=1;
            end

            //当无信号输入，持续时间置0
            else begin
                N<=0;
            end
        end
    end
endmodule