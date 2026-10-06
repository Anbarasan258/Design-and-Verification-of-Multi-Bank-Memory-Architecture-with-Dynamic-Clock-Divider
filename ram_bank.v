module ram_bank(clk,reset,dp_sp,wr_enable,wr_ram_sel,wr_addr,wr_data,rd_enable,rd_ram_sel,rd_addr,rd_data);
  input clk,reset,dp_sp,wr_enable,rd_enable;
  input [7:0] wr_addr,rd_addr;
  input [3:0] wr_ram_sel,rd_ram_sel;
  input [15:0] wr_data;
  output  [15:0] rd_data;
  wire [15:0] ram_out [0:15];
  memory_rtl mem0(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0000))),.write_en((wr_enable && (wr_ram_sel==4'b0000) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[0]));
  
  memory_rtl mem1(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0001))),.write_en((wr_enable && (wr_ram_sel==4'b0001) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[1]));
  
  memory_rtl mem2(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0010))),.write_en((wr_enable && (wr_ram_sel==4'b0010) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[2]));
  
  memory_rtl mem3(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0011))),.write_en((wr_enable && (wr_ram_sel==4'b0011) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[3]));
  
  memory_rtl mem4(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0100))),.write_en((wr_enable && (wr_ram_sel==4'b0100) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[4]));
  
  memory_rtl mem5(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0101))),.write_en((wr_enable && (wr_ram_sel==4'b0101) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[5]));
  
  memory_rtl mem6(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0110))),.write_en((wr_enable && (wr_ram_sel==4'b0110) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[6]));
  
  memory_rtl mem7(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b0111))),.write_en((wr_enable && (wr_ram_sel==4'b0111) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[7]));
  
   memory_rtl mem8(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1000))),.write_en((wr_enable && (wr_ram_sel==4'b1000) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[8]));
  
  memory_rtl mem9(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1001))),.write_en((wr_enable && (wr_ram_sel==4'b1001) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[9]));
  
  memory_rtl mem10(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1010))),.write_en((wr_enable && (wr_ram_sel==4'b1010) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[10]));
  
  memory_rtl mem11(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1011))),.write_en((wr_enable && (wr_ram_sel==4'b1011) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[11]));

 memory_rtl mem12(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1100))),.write_en((wr_enable && (wr_ram_sel==4'b1100) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[12]));
 
 memory_rtl mem13(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1101))),.write_en((wr_enable && (wr_ram_sel==4'b1101) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[13]));
  
  memory_rtl mem14(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1110))),.write_en((wr_enable && (wr_ram_sel==4'b1110) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[14]));
  
 memory_rtl mem15(.data_in(wr_data),.address((wr_enable)?wr_addr:rd_addr),.read_en((rd_enable && (rd_ram_sel==4'b1111))),.write_en((wr_enable && (wr_ram_sel==4'b1111) && !dp_sp)),.clk(clk),.reset(reset),.data_out(ram_out[15]));
  
  assign rd_data = ram_out[rd_ram_sel];
  
endmodule
