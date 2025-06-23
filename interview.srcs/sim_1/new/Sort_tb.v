`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2025 12:50:09
// Design Name: 
// Module Name: Sort_tb
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


module Sort_tb;


    reg clk, rst, s;
    reg [7:0] DataIn;
    reg [2:0] RAdd;
    reg Rd;
    reg [7:0] WrInint;
    wire [7:0] Dataout;
    wire done;

    // Instantiate TopLevel
    Sort uut (
        .clk(clk),
        .rst(rst),
        .s(s),
        .DataIn(DataIn),
        .RAdd(RAdd),
        .Rd(Rd),
        .WrInit(WrInint),
        .Dataout(Dataout),
        .done(done)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Sim singsl
    initial begin
        
        rst = 0;
        s   = 0;
        DataIn = 0;
        RAdd   = 0;
        Rd  = 0;
        WrInint = 0;
        
        
        rst = 1;       
        #10 rst = 0;   
        #10 rst = 1;   

        #10 s = 1;         
        
      

        #100 $finish;      
    end

endmodule

