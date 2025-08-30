`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 13:10:24
// Design Name: 
// Module Name: router_sync
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


module router_sync(
    input [1:0]data_in,
    input detect_add, write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,
    output reg [2:0] write_enb,
    output vld_out_0,vld_out_1,vld_out_2,
    //the o/p that is used inside always block must be declared reg
    output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2
);
   
    
    //detect_add and data_in signals are used to select a FIFO till a packet routing is over for the selected FIFO
    reg[1:0] temp;
    always@(posedge clock) begin
    if(!resetn) temp<=0;
    else if(detect_add)temp<=data_in;
    end
    
    //Signal fifo_full signal is asserted based on full status of FIFO_0 or FIFO_1 or FIFO_2
    always@(*) begin
    case(temp)
        2'b00:fifo_full=full_0;
        2'b01:fifo_full=full_1;
        2'b10:fifo_full=full_2;
        default:fifo_full=0;
     endcase
     end
     
     //The signal vld_out_X is generated based on empty status of the FIFO.
     assign vld_out_0=~empty_0;
     assign vld_out_1=~empty_1;
     assign vld_out_2=~empty_2;
         
     //The write_enb_reg signal is used to generate write_enb signal for the write operation of the selected FIFO.
     always@(*) begin
       if(write_enb_reg) begin
         case(temp)
            2'b00: write_enb={2'b00,write_enb_reg};       //00  1
            2'b01: write_enb={1'b0,write_enb_reg,1'b0};   //01  0
            2'b10: write_enb={write_enb_reg,2'b00};       //10  0
            default:write_enb=3'b000;
         endcase
       end
       else write_enb=3'b000;
     end
     
     /*There are 3 internal reset signals (soft_reset_0, soft_reset_1, soft_reset_2)… goes high if read_enb_X
     is not asserted within 30 clock cycles of vld_out_X being asserted.*/
     
     //for 30 clock cycles we use 5 bit couter
     reg [4:0] count0;
     always@(posedge clock) begin
     if(!resetn) begin
        soft_reset_0<=0;
        count0<=5'b00000;
     end
     else if(vld_out_0 && !read_enb_0) begin
        if(count0==5'd29) begin
               soft_reset_0<=1;
               count0<=0;
        end
        else begin
                soft_reset_0<=0;
                count0<=count0+1'b1;
        end
     end
     else begin
        soft_reset_0<=0;
        count0<=0;
     end
     end
     
     reg [4:0] count1;
          always@(posedge clock) begin
          if(!resetn) begin
             soft_reset_1<=0;
             count1<=5'b00000;
          end
          else if(vld_out_1 && !read_enb_1) begin
             if(count1==5'd29) begin
                    soft_reset_1<=1;
                    count1<=0;
             end
             else begin
                     soft_reset_1<=0;
                     count1<=count1+1'b1;
             end
          end
          else begin
             soft_reset_1<=0;
             count1<=0;
          end
      end
      
      reg [4:0] count2;
           always@(posedge clock) begin
           if(!resetn) begin
              soft_reset_2<=0;
              count2<=5'b00000;
           end
           else if(vld_out_2 && !read_enb_2) begin
              if(count2==5'd29) begin
                     soft_reset_2<=1;
                     count2<=0;
              end
              else begin
                      soft_reset_2<=0;
                      count2<=count2+1'b1;
              end
           end
           else begin
              soft_reset_2<=0;
              count2<=0;
           end
           end

endmodule
