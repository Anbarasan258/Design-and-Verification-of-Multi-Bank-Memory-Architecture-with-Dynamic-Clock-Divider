module ram_bank_top(clk,reset,dp_sp,wr_ram_bank_sel,rd_ram_bank_sel,wr_addr,rd_addr,wr_enable,rd_enable,wr_data_in,rd_data_out);
  input clk,reset,dp_sp,wr_enable,rd_enable;
  input [1:0] wr_ram_bank_sel,rd_ram_bank_sel;
  input [11:0] wr_addr,rd_addr;
  input [15:0] wr_data_in;
  output [15:0] rd_data_out;
  wire [15:0] ram_data_out [0:3];
  
  ram_bank ram0(.clk(clk),.reset(reset),.dp_sp(dp_sp),.wr_enable(((wr_enable)&&(wr_ram_bank_sel==2'b00))),.wr_ram_sel(wr_addr[11:8]),.wr_addr(wr_addr[7:0]),.wr_data(wr_data_in),.rd_enable(((rd_enable) && (rd_ram_bank_sel==2'b00))),.rd_ram_sel(rd_addr[11:8]),.rd_addr(rd_addr[7:0]),.rd_data(ram_data_out[0]));
  
  ram_bank ram1(.clk(clk),.reset(reset),.dp_sp(dp_sp),.wr_enable(((wr_enable)&&(wr_ram_bank_sel==2'b01))),.wr_ram_sel(wr_addr[11:8]),.wr_addr(wr_addr[7:0]),.wr_data(wr_data_in),.rd_enable(((rd_enable) && (rd_ram_bank_sel==2'b01))),.rd_ram_sel(rd_addr[11:8]),.rd_addr(rd_addr[7:0]),.rd_data(ram_data_out[1]));
  
  ram_bank ram2(.clk(clk),.reset(reset),.dp_sp(dp_sp),.wr_enable(((wr_enable)&&(wr_ram_bank_sel==2'b10))),.wr_ram_sel(wr_addr[11:8]),.wr_addr(wr_addr[7:0]),.wr_data(wr_data_in),.rd_enable(((rd_enable) && (rd_ram_bank_sel==2'b10))),.rd_ram_sel(rd_addr[11:8]),.rd_addr(rd_addr[7:0]),.rd_data(ram_data_out[2]));
  
  ram_bank ram3(.clk(clk),.reset(reset),.dp_sp(dp_sp),.wr_enable(((wr_enable)&&(wr_ram_bank_sel==2'b11))),.wr_ram_sel(wr_addr[11:8]),.wr_addr(wr_addr[7:0]),.wr_data(wr_data_in),.rd_enable(((rd_enable) && (rd_ram_bank_sel==2'b11))),.rd_ram_sel(rd_addr[11:8]),.rd_addr(rd_addr[7:0]),.rd_data(ram_data_out[3]));
  
  assign rd_data_out = ram_data_out[rd_ram_bank_sel];
endmodule
