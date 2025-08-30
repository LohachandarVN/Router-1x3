`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 00:01:21
// Design Name: 
// Module Name: router_top_tb
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


/*module router_top_tb();
    reg clock, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid;
    reg [7:0] data_in;
    wire [7:0] data_out_0, data_out_1, data_out_2;
    wire valid_out_0, valid_out_1, valid_out_2, error, busy;
    integer i;
    
    router_top router(clock, 
                      resetn,
                      read_enb_0, 
                      read_enb_1, 
                      read_enb_2, 
                      data_in, 
                      pkt_valid, 
                      data_out_0, 
                      data_out_1, 
                      data_out_2, 
                      valid_out_0, 
                      valid_out_1, 
                      valid_out_2, 
                      error, 
                      busy);
                      
    task initialize();
        {clock, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid, data_in} = 'b0;
    endtask
    
    always #5  clock = ~clock;
    
    task reset();
    begin
        @(negedge clock)
            resetn = 1'b0;
        @(negedge clock)
            resetn = 1'b1;
    end 
    endtask
    
    task pkt_gen_14;
        reg[7:0] payload_data, parity, header;
        reg[5:0] payload_len;
        reg[1:0] addr;
        begin
            @(negedge clock);
            wait(~busy)
            
            @(negedge clock);
            payload_len = 6'd14;
            addr = 2'b01;
            header = {payload_len, addr};
            parity = 1'b0;
            data_in = header;
            pkt_valid = 1'b1;
            parity = parity ^ header;
            @(negedge clock);
            wait(~busy)
            for(i=0;i<payload_len;i=i+1) begin
                @(negedge clock);
                wait(~busy)
               // payload_data = {$random}%256;
                payload_data = i;
                data_in = payload_data;
                parity = parity ^ payload_data;
            end
            @(negedge clock);
            wait(~busy)
            pkt_valid = 1'b0;
            data_in = parity;
        end
    endtask
    
    task pkt_gen_16;
        reg[7:0] payload_data, parity, header;
        reg[5:0] payload_len;
        reg[1:0] addr;
        begin
            @(negedge clock);
            wait(~busy)
            
            @(negedge clock);
            payload_len = 6'd16;
            addr = 2'b01;
            header = {payload_len, addr};
            parity = 1'b0;
            data_in = header;
            pkt_valid = 1'b1;
            parity = parity ^ header;
            @(negedge clock);
            wait(~busy)
            for(i=0;i<payload_len;i=i+1) begin
                @(negedge clock);
                wait(~busy)
               // payload_data = {$random}%256;
                payload_data = i;
                data_in = payload_data;
                parity = parity ^ payload_data;
            end
            @(negedge clock);
            wait(~busy)
            pkt_valid = 1'b0;
            data_in = parity;
        end
    endtask
    
    initial begin
        initialize();
        reset();
        fork
            pkt_gen_16();
            wait(valid_out_1)
            @(negedge clock)
            read_enb_1 = 1'b1;
        join
        #25 $finish;
    end
        
endmodule*/



module router_top_tb();
    reg clock;
    reg resetn;
    reg read_enb_0;
    reg read_enb_1;
    reg read_enb_2;
    reg[7:0] data_in;
    reg pkt_valid;
    wire[7:0] data_out_0;
    wire[7:0] data_out_1;
    wire[7:0] data_out_2;
    wire valid_out_0;
    wire valid_out_1;
    wire valid_out_2;
    wire error;
    wire busy;
    integer i;
    router_top dut(.clock(clock),
                   .resetn(resetn),
                   .read_enb_0(read_enb_0),
                   .read_enb_1(read_enb_1),
                   .read_enb_2(read_enb_2),
                   .data_in(data_in),
                   .pkt_valid(pkt_valid),
                   .data_out_0(data_out_0),
                   .data_out_1(data_out_1),
                   .data_out_2(data_out_2),
                   .valid_out_0(valid_out_0),
                   .valid_out_1(valid_out_1),
                   .valid_out_2(valid_out_2),
                   .error(error),
                   .busy(busy)
                   );
                   
    always
        begin
            clock = 0;
            #5;
            clock = 1;
            #5;
        end
    
    task reset();
        begin
            @(negedge clock)
            resetn = 1'b0;
            @(negedge clock)
            resetn = 1'b1;
        end
    endtask
    
    task initialise();
        begin
            read_enb_0 = 1'b0;
            read_enb_1 = 1'b0;
            read_enb_2 = 1'b0;
            data_in = 8'b0000_0000;
            pkt_valid = 1'b0;
        end
    endtask
    
    /*task pkt_gen_14;
        reg[7:0] payload_data, parity, header;
        reg[5:0] payload_len;
        reg[1:0] addr;
        begin
            @(negedge clock);
            wait(~busy)
            
            @(negedge clock);
            payload_len = 6'd14;
            addr = 2'b00;
            header = {payload_len, addr};
            parity = 1'b0;
            data_in = header;
            pkt_valid = 1'b1;
            parity = parity ^ header;
            @(negedge clock);
            wait(~busy)
            for(i=0;i<payload_len;i=i+1) begin
                @(negedge clock);
                wait(~busy)
                payload_data = {$random}%256;
                data_in = payload_data;
                parity = parity ^ payload_data;
            end
            @(negedge clock);
            wait(~busy)
            pkt_valid = 1'b0;
            data_in = parity;
        end
    endtask*/
    
    /*task pkt_gen_10;
        reg[7:0] payload_data, parity, header;
        reg[5:0] payload_len;
        reg[1:0] addr;
        begin
            @(negedge clock);
            wait(~busy)
            
            @(negedge clock);
            payload_len = 6'd10;
            addr = 2'b01;
            header = {payload_len, addr};
            parity = 1'b0;
            data_in = header;
            pkt_valid = 1'b1;
            parity = parity ^ header;
            @(negedge clock);
            wait(~busy)
            for(i=0;i<payload_len;i=i+1) begin
                @(negedge clock);
                wait(~busy)
                payload_data = {$random}%256;
                data_in = payload_data;
                parity = parity ^ payload_data;
            end
            @(negedge clock);
            wait(~busy)
            pkt_valid = 1'b0;
            data_in = parity;
        end
    endtask*/
    
    task pkt_gen_16();
        reg[7:0] payload_data, parity, header;
        reg[5:0] payload_len;
        reg[1:0] addr;
        begin
            @(negedge clock);
            wait(~busy)
            
            @(negedge clock);
            payload_len = 6'd16;
            addr = 2'b10;
            header = {payload_len, addr};
            parity = 1'b0;
            data_in = header;
            pkt_valid = 1'b1;
            parity = parity ^ header;
            @(negedge clock);
            wait(~busy)
            for(i=0;i<payload_len;i=i+1) begin
                @(negedge clock);
                wait(~busy)
                payload_data = {$random}%256;
                data_in = payload_data;
                parity = parity ^ payload_data;
            end
            @(negedge clock);
            wait(~busy)
            pkt_valid = 1'b0;
            data_in = parity;
        end
    endtask
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
    initial begin
        initialise();
        reset();
    
       /* @(negedge clock);
        pkt_gen_14();
        wait(valid_out_0);
        read_enb_0 = 1'b1;
        #200;
        read_enb_0 = 1'b0;*/
    
        /*@(negedge clock);
        pkt_gen_10();
        wait(valid_out_1);
        read_enb_1 = 1'b1;
        #200;
        read_enb_1 = 1'b0;*/
        
        @(negedge clock);
        fork
            pkt_gen_16();
            begin
                wait(valid_out_2);
                repeat(2) @(negedge clock);
                read_enb_2 = 1'b1;
                wait(~valid_out_2);
                read_enb_2 = 1'b0;
            end
        join
        #25;
        $finish;
    end

endmodule
