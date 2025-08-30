`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lohachandar_V_N
// 
// Create Date: 19.08.2025 14:30:41
// Design Name: 
// Module Name: router_fsm
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


module router_fsm(
    input        clock,
    input        resetn,
    input        pkt_valid,
    
    input        parity_done,
    input  [1:0] data_in,
    input        soft_reset_0,
    input        soft_reset_1,
    input        soft_reset_2,
    input        fifo_full,
    input      low_pkt_valid,
    input fifo_empty_0,
    input fifo_empty_1,
    input fifo_empty_2, 
     
    output        busy,
    output       detect_add,
    output       ld_state,
    output       laf_state,
    output       full_state,
    output       write_enb_reg,
    output       rst_int_reg,
    output       lfd_state
  );
  reg [1:0] addr;
  reg [2:0] state,next_state;
  parameter DECODE_ADDRESS=         3'b000,
            LOAD_FIRST_DATA=        3'b001,
            LOAD_DATA=              3'b010,
            LOAD_PARITY=            3'b011,
            FIFO_FULL_STATE=        3'b100,
            LOAD_AFTER_FULL=        3'b101,
            WAIT_TILL_EMPTY=        3'b110,
            CHECK_PARITY_ERROR=     3'b111;
            
   always@(posedge clock) begin
   if(!resetn) state<=DECODE_ADDRESS;
   else if(soft_reset_0 | soft_reset_1 | soft_reset_2) state<=DECODE_ADDRESS;
   else state<=next_state;
   end
   
   always@(posedge clock) begin
   if(!resetn) addr<=0;
   else addr<=data_in;
   end
   
   //case statement for all 8 states
    always @(*) begin
          case (state)
              DECODE_ADDRESS: if((pkt_valid & (data_in[1:0]==0) & fifo_empty_0)|
                                 (pkt_valid & (data_in[1:0]==1) & fifo_empty_1)|
                                 (pkt_valid & (data_in[1:0]==2) & fifo_empty_2)) begin
                                      next_state = LOAD_FIRST_DATA;
                               end
                               else if((pkt_valid & (data_in[1:0]==0) & !fifo_empty_0)|
                                 (pkt_valid & (data_in[1:0]==1) & !fifo_empty_1)|
                                 (pkt_valid & (data_in[1:0]==2) & !fifo_empty_2)) begin
                                     next_state = WAIT_TILL_EMPTY;
                               end
                               else begin
                                  next_state = DECODE_ADDRESS;
                               end
                               
              LOAD_FIRST_DATA: next_state = LOAD_DATA;
              
              LOAD_DATA: if(fifo_full) begin
                              next_state = FIFO_FULL_STATE;
                          end
                          else if(!fifo_full && !pkt_valid) begin
                              next_state = LOAD_PARITY;
                          end
                          else begin
                              next_state = LOAD_DATA;
                          end
           LOAD_PARITY: next_state = CHECK_PARITY_ERROR;
                           
                           FIFO_FULL_STATE: if (!fifo_full) begin
                                               next_state = LOAD_AFTER_FULL;
                                            end
                                            else begin
                                               next_state = FIFO_FULL_STATE;
                                            end
                                            
                           LOAD_AFTER_FULL: if(parity_done) begin
                                               next_state = DECODE_ADDRESS;
                                            end
                                            else if (!parity_done && !low_pkt_valid) begin
                                               next_state = LOAD_DATA;
                                            end
                                            else if (!parity_done && low_pkt_valid) begin
                                               next_state = LOAD_PARITY;
                                            end
                                            else begin
                                               next_state = LOAD_AFTER_FULL;
                                            end
                           WAIT_TILL_EMPTY: if ((fifo_empty_0 && (addr == 0)) || (fifo_empty_1 && (addr == 1)) || (fifo_empty_2 &&(addr == 2))) begin
                                               next_state = LOAD_FIRST_DATA;
                                            end
                                            else begin
                                               next_state = WAIT_TILL_EMPTY;
                                            end
                           CHECK_PARITY_ERROR: 
                                            if (!fifo_full) begin
                                                next_state = DECODE_ADDRESS;
                                            end
                                            else if (fifo_full) begin
                                                next_state = FIFO_FULL_STATE;
                                             end
                                             else begin
                                                next_state = CHECK_PARITY_ERROR;
                                             end
                                       endcase
                                     end
                                     
                                      assign detect_add = (state == DECODE_ADDRESS) ? 1'b1 : 1'b0;
                                      assign lfd_state  = (state == LOAD_FIRST_DATA) ? 1'b1 : 1'b0;
                                      assign busy       = ((state == LOAD_FIRST_DATA)||(state == LOAD_PARITY)||(state == FIFO_FULL_STATE) || (state == LOAD_AFTER_FULL) ||(state == WAIT_TILL_EMPTY) || (state == CHECK_PARITY_ERROR)) ? 1'b1 : 1'b0;
                                      assign ld_state   = (state == LOAD_DATA) ? 1'b1 : 1'b0;
                                      assign write_enb_reg = ((state == LOAD_DATA) || (state == LOAD_PARITY) ||(state == LOAD_AFTER_FULL)) ? 1'b1 : 1'b0;
                                      assign full_state = (state == FIFO_FULL_STATE) ? 1'b1 : 1'b0;
                                      assign laf_state = (state == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
                                      assign rst_int_reg = (state == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
                                                    


            
            
  
endmodule
