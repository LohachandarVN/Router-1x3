`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lohachandar_V_N
// 
// Create Date: 20.08.2025 14:52:43
// Design Name: 
// Module Name: router_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module router_fifo(
    input clock,resetn,write_enb,soft_reset,read_enb,lfd_state,
    input [7:0]data_in,
    output empty,full,
    output reg[7:0]data_out);
    
    reg [8:0] mem[15:0];
    reg [4:0] rd_ptr,wr_ptr;     //16 depth 2^4 but for full cycle 1111-> 1 0000,.. carry
    
    reg[6:0] count;   // for 9 bit except 2 address bits
    reg temp; //for lfd state --- keeping 1st as header 
    always@(posedge clock) begin
        if(!resetn) temp<=0;
        else temp<=lfd_state;
    end
    
    //write logic
    integer i;
    always@(posedge clock)  begin
    if(!resetn) begin
        for(i=0;i<16;i=i+1) begin
            mem[i]<=0;
            wr_ptr<=0;
        end
    end
    else if(soft_reset) begin
        for(i=0;i<16;i=i+1) begin
                mem[i]<=0;
                wr_ptr<=0;
            end
        end
    else if(write_enb && !full)begin
        mem[wr_ptr[3:0]]<={temp,data_in};
        wr_ptr<=wr_ptr+1;
    end
    end
        
   //read logic
   always@(posedge clock) begin
   if(!resetn) begin
      data_out<=0;
      rd_ptr=0;
    end
    else if(soft_reset) begin
        data_out<=8'bz;
        
    end
    else if(count==0)
         data_out <= 8'bz;
    else if(read_enb && !empty) begin
          data_out <= mem[rd_ptr[3:0]][7:0];
          rd_ptr <= rd_ptr + 1'b1;
   end
   else
      data_out <= 8'bz;
    end
    
    //count logic
       always@(posedge clock) begin
         if(!resetn)
             count <= 7'b000_0000;
         else if(soft_reset)
             count <= 7'b000_0000;
         else if(mem[rd_ptr[3:0]][8] == 1'b1)
             count <= mem[rd_ptr[3:0]][7:2] + 1'b1;
         else if(read_enb && !empty)
             count <= count - 1'b1;
         else
             count <= count;
     end
     
     
     //full and empty logic
     assign full = ((wr_ptr[4] != rd_ptr[4]) && (wr_ptr[3:0] == rd_ptr[3:0])) ? 1'b1 : 1'b0;
     assign empty = (wr_ptr == rd_ptr) ? 1'b1 : 1'b0;
    
endmodule
