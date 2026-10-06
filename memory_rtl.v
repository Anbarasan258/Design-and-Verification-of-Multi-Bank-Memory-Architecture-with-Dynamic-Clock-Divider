module memory_rtl(data_in,address,read_en,write_en,clk,reset,data_out);
  integer i;
  input [15:0]data_in;
  input [7:0]address;
  input read_en,write_en,reset,clk;
  output reg [15:0]data_out;
  reg [15:0]mem[255:0];
  
  always@(posedge clk)
    begin
      if(reset)
        begin
          for(i=0;i<256;i=i+1)
            begin
              mem[i]<= 16'b0000000000000000;
            end
          data_out <=16'b0000000000000000;
        end
      else
        begin
          if(!read_en && write_en)
            mem[address]<=data_in;
      
         else if(read_en && !write_en)
           data_out<=mem[address];
         end
    end
endmodule


