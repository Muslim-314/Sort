`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2025 12:05:24
// Design Name: 
// Module Name: Sort
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


module Sort #(
    parameter N = 8,  // Data width
    parameter L = 4,  // Address / counter width
    parameter K = 16   //  length
)(
    input clk,
    input rst,
    input s,
    input [N-1:0] DataIn,
    input [L-1:0] RAdd,
    input Rd,
    input [N-1:0] WrInit,
    output [N-1:0] Dataout,
    output done
);

    // Wires between controller and datapath
    wire EA, EB, Wr, Li, Lj, Ei, Ej, Csel, Bout ;
    wire AgtB, zi, zj;

    // Instantiate Controller FSM
    Controller_FSM controller_inst (
        .Clock(clk),
        .Resetn(rst),
        .s(s),
        .AgtB(AgtB),
        .zi(zi),
        .zj(zj),
        .EA(EA),
        .EB(EB),
        .Wr(Wr),
        .Li(Li),
        .Lj(Lj),
        .Ei(Ei),
        .Ej(Ej),
        .Csel(Csel),
        .Bout(Bout),
        
        
        .done(done)
    );

    // Instantiate Datapath
    Datapath #(
        .N(N),
        .L(L),
        .K(K)
    ) datapath_inst (
        .Clock(clk),
        .Resetn(rst),          // Active-low reset
        .WrInit(WrInit),
        .DataIn(DataIn),
        .RAdd(RAdd),
        .s(s),
        .EA(EA),
        .EB(EB),
        .Wr(Wr),
        .Li(Li),
        .Lj(Lj),
        .Ei(Ei),
        .Ej(Ej),
        .Csel(Csel),
        .Bout(Bout),
        .Rd(Rd),
        .AgtB(AgtB),
        .zi(zi),
        .zj(zj),
        .Dataout(Dataout)
    );

endmodule

