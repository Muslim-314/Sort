`timescale 1ns / 1ps


module Controller_FSM(
        input Clock, Resetn,
        input s,
        output reg EA, EB,  // register enables
                    Wr,     // Write enable for the memory
                    Li, Lj, // laod signals for the counters
                    Ei, Ej, // when these signal are high there respective counter increments
                    Csel,   // Counter Select 
                    Bout,   // Data select for the memory input
        output reg done,    // goes high when the sorting is complete 
        input AgtB, zi, zj  // flags{A greater then B, outer counter complete, inner ounter complete}
);



    localparam [3:0] 
        IDLE  = 4'b0000, //Reset - IDLE state
        S1    = 4'b0001, // load A from memory[i]
        S2    = 4'b0010, // load B from memory[j]
        S3    = 4'b0011, // only to compare A and B
        INC_I = 4'b0100, // increment the outer counter
        INC_J = 4'b0101, // increment the inner counter
        S4    = 4'b0110, // B to memory[i]
        S5    = 4'b0111, // A to memory[j]
        S6    = 4'b1000, // reload A frrom i
        DONE  = 4'b1001; // sort complete
        
    
    reg [3:0] state, next_state;
    always@(posedge Clock or negedge Resetn)begin
        if(!Resetn)
            state <= IDLE;
        else
            state <= next_state; 
    end

    always@(*) begin
        case(state)
            IDLE: begin
                next_state = s ? S1 : IDLE;
            end
            S1: begin 
                next_state = S2;
            end
            S2: begin
                next_state = S3;
            end
            S3: begin
                if(AgtB) begin
                    next_state = S4;
                end else if(zi & zj) begin
                    next_state = DONE;
                end else if(!zj) begin
                    next_state = INC_J;
                end else if(zj) begin
                    next_state = INC_I;
                end
            end
            INC_I: begin
                next_state = S1;
            end
            INC_J: begin
                next_state = S2;
            end
            S4: begin
                next_state = S5;
            end
            S5: begin
                next_state = S6;
            end
            S6: begin
                if(zi & zj) begin
                    next_state = DONE;
                end else if(!zj) begin
                    next_state = INC_J;
                end else if(zj) begin
                    next_state = INC_I;
                end
            end
            DONE: begin
                next_state = s ? DONE : IDLE ;
            end
            default: next_state = IDLE; 
        endcase
    end
    
    always@(*) begin
        
        EA = 0; EB = 0; Wr = 0; Li = 0; Lj = 0; Ei = 0; Ej = 0; Csel = 0; Bout = 0;  done = 0;

        case(state)
            IDLE: begin
                 Li   = 1'b1; // outer counter loads zer0
                 Lj   = 1'b1; // inner counter loads (outer counter + 1)
            end
            S1: begin
                Csel = 1'b0;
                EA   = 1'b1;
            end
            S2: begin
                Csel = 1'b1;
                EB   = 1'b1;
            end
            S3: begin
                //check conditions only in this state
            end
            INC_I: begin
                Lj   = 1'b1;
                Ei = 1;
            end
            INC_J: begin
                Ej  = 1;
            end
            S4: begin
                Wr = 1;
                Csel = 0;
                Bout = 1;
            end
            S5: begin
                Wr = 1;
                Csel = 1;
                Bout = 0;
            end
            S6: begin
                EA = 1;
                Csel = 0;
            end
            DONE: begin
                done = 1;
            end
        endcase
    end

endmodule