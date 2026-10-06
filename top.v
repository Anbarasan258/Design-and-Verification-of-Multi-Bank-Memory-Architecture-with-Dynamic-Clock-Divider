module top(clk,reset,wr_valid,rd_valid,wr_enable,rd_enable,deep_sleep,wr_addr,rd_addr,data_in,wr_ready,wr_done,rd_ready,rd_done,data_out);
  input clk,reset,wr_valid,rd_valid,wr_enable,rd_enable,deep_sleep;
  input [13:0] wr_addr,rd_addr;
  input [15:0] data_in;
  output reg wr_ready,wr_done,rd_ready,rd_done;
  output reg [15:0] data_out;
  wire [15:0] output_data;
  wire clk_out;
  clock_divider dut1(.clk(clk),.reset(reset),.write_address(wr_addr[13:12]),.clk_div_out(clk_out));
  ram_bank_top dut2(.clk(clk_out),.reset(reset),.dp_sp(deep_sleep),.wr_ram_bank_sel(wr_addr[13:12]),.rd_ram_bank_sel(rd_addr[13:12]),.wr_addr(wr_addr[11:0]),.rd_addr(rd_addr[11:0]),.wr_enable(wr_enable),.rd_enable(rd_enable),.wr_data_in(data_in),.rd_data_out(output_data));
  
  always@(posedge clk_out)
    begin
      if(reset || deep_sleep)
        begin
        wr_ready <= 1'b0;
        wr_done <= 1'b0;
        data_out <= 16'd0; 
        end
      else
        begin
          if(wr_enable && wr_valid)
            begin
              wr_ready <= 1'b1;
              wr_done <= 1'b0;
            end
         else if(wr_ready)
            begin
              wr_ready <= 1'b0;
              wr_done <= 1'b1;
            end
          else
            begin
            wr_done <= 1'b0;
            wr_ready <= 1'b0;
            end
        end
    end
  always@(posedge clk_out)
  begin
    if(reset || deep_sleep)
      begin
        rd_ready <= 1'b0;
        rd_done <= 1'b0;
        data_out <=16'd0;
      end
      else
        begin
          if(rd_enable && rd_valid)
            begin
              rd_ready <= 1'b1;
              rd_done <= 1'b0;
            end
          else if(rd_ready)
            begin
            rd_ready <= 1'b0;
              rd_done <= 1'b1;
              data_out <= output_data;
            end
          else
            begin
            rd_done <= 1'b0;
            rd_ready <= 1'b0;
            end
        end
  end
endmodule
