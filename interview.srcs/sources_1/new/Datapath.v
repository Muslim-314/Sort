`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2025 05:34:23
// Design Name: 
// Module Name: Datapath
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

 
module Datapath #(
    parameter N = 8, // data width
    parameter L = 3, // address / counters width
    parameter K = 8 
    
)
(
        input Clock, Resetn, WrInit, 
        input [N -1:0] DataIn,
        input [L -1:0] RAdd,
        input s,
        input  EA, EB, Wr, Li, Lj, Ei, Ej, Csel, Bout, Rd,
        output AgtB, zi, zj,
        
        output [N-1:0]Dataout
    );
    
    reg  [N -1:0] A;
    reg  [N -1:0] B;
    reg  [L-1:0] inner_counter;
    reg  [L-1:0] outer_counter;
    wire [L-1:0] i,j;
    wire [L-1:0] counterMux; 
//    wire [N -1:0] memToA;
//    wire [N -1:0] memToB;
    wire [N -1:0] Mij;
    wire [N -1:0] ABmux;
    
    
    
    always @(posedge Clock or negedge Resetn) begin
        if (!Resetn) begin
            A <= 0;
            B <= 0;
        end else begin
            if (EA)
                A <= Mij;
            if (EB)
                B <= Mij;
        end
    end
    
    assign AgtB = ( A > B );
    assign ABmux= (Bout)? B : A;
     
    //outer counter logic
    always @(posedge Clock or negedge Resetn) begin
    if (!Resetn)
        outer_counter <= {L{1'b0}};                     
    else if (Li)
        outer_counter <= 0;                       
    else if (Ei)
        outer_counter <= outer_counter + 1;      
    end
    
    //inner counter logic
    always @(posedge Clock or negedge Resetn) begin
    if (!Resetn)
        inner_counter <=  {L{1'b0}};                       
    else if (Lj)
        inner_counter <= outer_counter + 1;                 
    else if (Ej)
        inner_counter <= inner_counter + 1;       
    end
    
    assign zi = (outer_counter == K-2);
    assign zj = (inner_counter == K-1);
    assign i  = outer_counter;
    assign j  = inner_counter;
    assign counterMux = (Csel) ? j : i ;
    
    
    memory #(
        .N(8),
        .L(3)
    ) mem_inst (
        .CLK(Clock),
        .WE(Wr | WrInit),
        .ADDRS(s ? counterMux: RAdd),
        .DIN  (s ? ABmux: DataIn ),
        .DOUT(Mij)
    );    
    assign Dataout = (Rd) ? Mij: {N{1'bz}};

    
endmodule





module memory #(
    parameter N = 8,  // data width
    parameter L = 3   // address width
)(
    input wire CLK,                   
    input wire WE,                    // Write enable
    input wire [L-1:0] ADDRS,          // Address input
    input wire [N-1:0] DIN,           // Data input
    output  [N-1:0] DOUT           // Data output
);
 
    reg [N-1:0] mem [0:(1<<L)-1]; //2^L locations

    //Simplified memory content 
//     initial begin
//            mem[0] = 8'd8;
//            mem[1] = 8'd7;
//            mem[2] = 8'd6;
//            mem[3] = 8'd5;
//            mem[4] = 8'd4;
//            mem[5] = 8'd3;
//            mem[6] = 8'd2;
//            mem[7] = 8'd1;
//     end
     
     //given memory content 
     initial begin
            mem[0] = 8'd90;
            mem[1] = 8'd25;
            mem[2] = 8'd60;
            mem[3] = 8'd15;
            mem[4] = 8'd30;
            mem[5] = 8'd75;
            mem[6] = 8'd45;
            mem[7] = 8'd10;
     end
    
    assign DOUT = mem[ADDRS];
    
    always @(posedge CLK) begin
        if (WE)
            mem[ADDRS] <= DIN;        
    end

endmodule
