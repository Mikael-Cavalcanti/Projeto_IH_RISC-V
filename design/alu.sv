`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
            4'b0000:        // AND 0
                    ALUResult = SrcA & SrcB;
            4'b0001:        // OR 1
                    ALUResult = SrcA | SrcB;
            4'b0010:        // ADD 2
                    ALUResult = SrcA + SrcB;
            4'b0011: // SLLI 3 
                    ALUResult = SrcA << SrcB;
            4'b0100: // SRLI 4
                    ALUResult = SrcA >> SrcB;
            4'b0101:          //SUB 5
                    ALUResult = SrcA - SrcB;
            4'b0110: // SRAI 6 *
                    ALUResult = $signed(SrcA) >>> SrcB[4:0];
            4'b0111: // SLT  && SLTI 7
                    ALUResult = (SrcA < SrcB) ? 1 : 0; 
            4'b1000:        // Equal 8
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b1001: // Not Equal 9
                    ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b1010: // Less 10
                    ALUResult = (SrcA < SrcB) ? 1 : 0;
            4'b1011: // Greater or equal 11
                    ALUResult = (SrcA >= SrcB) ? 1 : 0;
            4'b1100: // xor 12
                   ALUResult = SrcA ^ SrcB;
           4'b1101: // LUI 13
                   ALUResult = SrcB;
           
            default:
                    ALUResult = 0;
            endcase
        end
endmodule
