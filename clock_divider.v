module clock_divider (clk, reset, write_address, clk_div_out);
  input clk, reset;
  input [1:0]write_address;
  output reg clk_div_out;
   integer  count1, count2_p,count2_n, count3;
  reg clk1,clk2_p,clk2_n,clk3;
  always@(posedge clk)
    begin
      if(reset)
        begin
         count1 <= 0;
         count2_p <= 0;
         count3 <= 0;
  		 clk1 <= 0;
          clk2_p <= 0;
          clk3 <= 0;
        end
      else
       begin
         if(count1 == 0)
           begin
             count1 <=0;
             clk1 <= ~ clk1;
           end
         else
           begin
             count1<=1;
           end
         if(count2_p == 2)
           begin
             count2_p <=0;
             clk2_p <= ~ clk2_p;
           end
         else
           begin
             count2_p<=count2_p+1;
           end
         if(count3 == 1)
           begin
             count3 <=0;
             clk3 <= ~ clk3;
           end
         else
           begin
             count3<=count3+1;
           end
       end
    end
  always@(negedge clk)
    begin
      if(reset)
        begin
          count2_n <= 0;
          clk2_n <= 0;
        end
      else
        begin
          if(count2_n==2)
            begin
              count2_n <=0;
              clk2_n <= ~clk2_n;
            end
          else 
            count2_n <= count2_n + 1;
        end
    end
  always@(*)
    begin
      case(write_address)
        2'b00:clk_div_out = clk;
        2'b01:clk_div_out = clk1;
        2'b10:clk_div_out = (clk2_p | clk2_n);
        2'b11:clk_div_out = clk3;
        default :clk_div_out = clk;
      endcase
    end
endmodule
