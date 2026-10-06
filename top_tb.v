`timescale 1ns/1ps
`include "memory.sv"
`include "ram_bank.sv"
`include "ram_bank_top.sv"
`include "clock_divider.sv"
`timescale 1ns/1ps

module top_tb;
  reg clk, reset;
  reg wr_valid, rd_valid;
  reg wr_enable, rd_enable;
  reg deep_sleep;
  reg [13:0] wr_addr, rd_addr;
  reg [15:0] data_in;
  wire wr_ready, wr_done;
  wire rd_ready, rd_done;
  wire [15:0] data_out;
  reg [13:0] random_addr,random_wr_addr;
  reg [15:0] random_wr_data;
  reg [13:0] check_addr [4:0];
  reg [15:0] check_data [4:0];
  top dut (.clk(clk),.reset(reset),.wr_valid(wr_valid),.rd_valid(rd_valid),.wr_enable(wr_enable),.rd_enable(rd_enable),.deep_sleep(deep_sleep),.wr_addr(wr_addr),.rd_addr(rd_addr),.data_in(data_in),.wr_ready(wr_ready),.wr_done(wr_done),.rd_ready(rd_ready),.rd_done(rd_done),.data_out(data_out) );

  always #0.5 clk = ~clk;

    task reset_task();
    begin
      reset = 1'b1;
      deep_sleep = 1'b0;
      wr_enable = 1'b0;
      rd_enable = 1'b0;
      wr_valid = 1'b0;
      rd_valid = 1'b0;
      wr_addr = 14'd0;
      rd_addr = 14'd0;
      data_in = 16'd0;
      @(negedge clk)
      reset = 1'b0;
    end
  endtask
  
  task write_task();
    begin
      @(posedge dut.clk_out)
      wr_enable = 1'b1;
      wr_valid  = 1'b1;
      wr_addr = random_addr;
      data_in = random_wr_data;
      wait(wr_ready)
      @(negedge dut.clk_out)
      wr_enable = 1'b0;
      wr_valid  = 1'b0;
    end
  endtask
  
   task read_task();
    begin
      @(negedge dut.clk_out)
      rd_enable = 1'b1;
      rd_valid  = 1'b1;
      rd_addr = random_addr;
      wait(rd_ready)
      @(negedge dut.clk_out)
      rd_enable = 1'b0;
      rd_valid  = 1'b0;
    end
  endtask
  
  task read_write();
    begin
      @(posedge dut.clk_out)
      wr_enable = 1'b1;
      rd_enable = 1'b1;
      wr_valid = 1'b1;
      rd_valid = 1'b1;
      rd_addr = random_addr;
      wr_addr = random_wr_addr;
      data_in = random_wr_data;
      wait(rd_ready && wr_ready)
      @(negedge dut.clk_out)
      wr_enable = 1'b0;
      rd_enable = 1'b0;
      wr_valid = 1'b0;
      rd_valid = 1'b0;
    end
  endtask
  
  task deep_slp();
    begin
      @(negedge dut.clk_out)
      deep_sleep = 1'b1;
      wr_enable = 1'b1;
      rd_enable = 1'b1;
      wr_valid = 1'b1;
      rd_valid = 1'b1;
      //wr_addr = $random % 16384;
      //rd_addr = $random % 16384;
      data_in = $random % 65536;
      @(negedge dut.clk_out)
      if(!wr_ready && !rd_ready && !wr_done && !rd_done)
        $display("the deep_sleep operation is working good");
      else
        $display("the deep_sleep operation is not working good");
      deep_sleep = 1'b0;
      wr_enable = 1'b0;
      rd_enable = 1'b0;
    end
  endtask
  
  task read_write_in_same_location();
    begin
      @(negedge dut.clk_out)
      wr_enable = 1'b1;
      rd_enable = 1'b1;
      wr_valid = 1'b1;
      rd_valid = 1'b1;
      rd_addr = random_addr;
      wr_addr = random_addr;
      data_in = random_wr_data;
      wait(rd_ready && wr_ready)
      @(negedge dut.clk_out)
      wr_enable = 1'b0;
      rd_enable = 1'b0;
      wr_valid = 1'b0;
      rd_valid = 1'b0;
    end
  endtask
  
  
  
  initial
    begin
      $dumpfile("top.vcd");
      $dumpvars(0,top_tb);
      clk = 1'b0;
      
      //reset task
      reset_task();
      random_addr = $random % 16384;
      
      //read task to verify the reset is happend properly or not
      read_task();
      wait(rd_done)
      if(dut.data_out == 16'd0)
        $display("the reset is working good");
      else
        $display("the reset is not working");
      
      @(posedge dut.clk_out)
      // continuous write and read operation repeated
      //note:write and right address are same to ensure data is write or not
      repeat(50)
        begin
         random_addr = $random % 16384;
         random_wr_data = $random % 65536;
         write_task();
         wait(wr_done)
         if(wr_done)
           $display("write operation is sucessfull , write address:%d , write data:%d",dut.wr_addr,dut.data_in);
         else
         $display("write operation is failed");
         read_task();
         wait(rd_done)
          if(dut.data_out == dut.data_in)
            $display("the data is written = %d and read correctly = %d,in the address of %d",dut.data_in,dut.data_out,dut.rd_addr);
      else
        $display("error in this ram");
        end

      
      // deep_sleep operation
      deep_slp();
      
      
       //  Simultaneous write and read operation
      // here write address is randomly generated and the read address is the previous one
      random_wr_addr = $random % 16384;
      random_wr_data = $random % 65536;
      read_write();
      wait(wr_done && rd_done)
      if(wr_done && rd_done)
          $display("Simultaneous write and read operation is sucessfull");
      else
        $display("There is an error in Simultaneous write and read operation");
      
      
      //trying to access the same location for both read and write operation
      random_addr = $random % 16384;
      random_wr_data = $random % 65536;
      read_write_in_same_location();
      wait(wr_done && rd_done)
      if(wr_done && rd_done && dut.data_out==16'd0)
        $display("write and read operation at the same loaction is verified");
       else
         $display("you design show error for this write and read operation at the same loaction");
      
      
      // direct test case
      // continuous write operation
      @(negedge dut.clk_out)
      wr_enable = 1'b1;
      wr_valid  = 1'b1;
      wr_addr = 10231;
      data_in = 32710;
      check_addr[0]=10231;
      check_data[0]=32710;
      wait(wr_ready)
      @(posedge dut.clk_out)
      wr_enable = 1'b0;
      wr_valid  = 1'b0;
      #10;
      wr_enable = 1'b1;
      wr_valid  = 1'b1;
      wr_addr = 289;
      data_in = 12045;
      check_addr[1]=289;
      check_data[1]=12045;
      wait(wr_ready)
      @(posedge dut.clk_out)
      wr_enable = 1'b0;
      wr_valid  = 1'b0;
      #10;
      wr_enable = 1'b1;
      wr_valid  = 1'b1;
      wr_addr = 16012;
      data_in = 50123;
      check_addr[2]=16012;
      check_data[2]=50123;
      wait(wr_ready)
      @(posedge dut.clk_out)
      wr_enable = 1'b0;
      wr_valid  = 1'b0;
      #10;
      wr_enable = 1'b1;
      wr_valid  = 1'b1;
      wr_addr = 8743;
      data_in = 4432;
      check_addr[3]=8743;
      check_data[3]=4432;
      wait(wr_ready)
      @(posedge dut.clk_out)
      wr_enable = 1'b0;
      wr_valid  = 1'b0;
      #10;
      wr_enable = 1'b1;
      wr_valid  = 1'b1;
      wr_addr = 511;
      data_in = 15987;
      check_addr[4]=511;
      check_data[4]=15987;
      wait(wr_ready)
      @(posedge dut.clk_out)
      wr_enable = 1'b0;
      wr_valid  = 1'b0;
      #10;
      @(negedge dut.clk_out)
      rd_enable = 1'b1;
      rd_valid  = 1'b1;
      rd_addr = check_addr[0];
      wait(rd_ready)
      @(negedge dut.clk_out)
      rd_enable = 1'b0;
      rd_valid  = 1'b0;
      wait(rd_done)
      if(dut.data_out == check_data[0])
        $display("the data %d in the memory of %d is equal to the data %d in the address of %d reference memory",dut.data_out,dut.rd_addr,check_data[0],check_addr[0]);
      else
        $display("there is an error the data from the memory and reference memory is not matching");
      #10;
      rd_enable = 1'b1;
      rd_valid  = 1'b1;
      rd_addr = check_addr[1];
      wait(rd_ready)
      @(negedge dut.clk_out)
      rd_enable = 1'b0;
      rd_valid  = 1'b0;
       wait(rd_done)
      if(dut.data_out == check_data[1])
        $display("the data %d in the memory of %d is equal to the data %d in the address of %d reference memory",dut.data_out,dut.rd_addr,check_data[1],check_addr[1]);
      else
        $display("there is an error the data from the memory and reference memory is not matching");
      #10;
      rd_enable = 1'b1;
      rd_valid  = 1'b1;
      rd_addr = check_addr[2];
      wait(rd_ready)
      @(negedge dut.clk_out)
      rd_enable = 1'b0;
      rd_valid  = 1'b0;
       wait(rd_done)
      if(dut.data_out == check_data[2])
        $display("the data %d in the memory of %d is equal to the data %d in the address of %d reference memory",dut.data_out,dut.rd_addr,check_data[2],check_addr[2]);
      else
        $display("there is an error the data from the memory and reference memory is not matching");
      #10;
      rd_enable = 1'b1;
      rd_valid  = 1'b1;
      rd_addr = check_addr[3];
      wait(rd_ready)
      @(negedge dut.clk_out)
      rd_enable = 1'b0;
      rd_valid  = 1'b0;
       wait(rd_done)
      if(dut.data_out == check_data[3])
        $display("the data %d in the memory of %d is equal to the data %d in the address of  %d reference memory",dut.data_out,dut.rd_addr,check_data[3],check_addr[3]);
      else
        $display("there is an error the data from the memory and reference memory is not matching");
      #10;
      rd_enable = 1'b1;
      rd_valid  = 1'b1;
      rd_addr = check_addr[4];
      wait(rd_ready)
      @(negedge dut.clk_out)
      rd_enable = 1'b0;
      rd_valid  = 1'b0;
       wait(rd_done)
      if(dut.data_out == check_data[4])
        $display("the data %d in the memory of %d is equal to the data %d in the address of %d reference memory",dut.data_out,dut.rd_addr,check_data[4],check_addr[4]);
      else
        $display("there is an error the data from the memory and reference memory is not matching");
      #10 $finish;
    end
endmodule
