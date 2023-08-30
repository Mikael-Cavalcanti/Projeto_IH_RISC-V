`timescale 1ns / 1ps

module datamemory #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic MemRead,  // comes from control unit
    input logic MemWrite,  // Comes from control unit
    input logic [DM_ADDRESS - 1:0] a,  // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W - 1:0] wd,  // Write Data
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction
    output logic [DATA_W - 1:0] rd  // Read Data
);

  logic [31:0] raddress; //endereÃ§o de leitura
  logic [31:0] waddress; //endereÃ§o de escrita
  logic [31:0] Datain; //dado a ser escrito
  logic [31:0] Dataout; 
  logic [ 3:0] Wr; //write enable - identifica se Ã© escrita ou leitura

  Memoria32Data mem32 (
      .raddress(raddress),
      .waddress(waddress),
      .Clk(~clk),
      .Datain(Datain),
      .Dataout(Dataout),
      .Wr(Wr)
  );

  always_ff @(*) begin
    raddress = {{22{1'b0}}, a};
    waddress = {{22{1'b0}}, {a[8:2], {2{1'b0}}}};
    Datain = wd;
    Wr = 4'b0000;

    if (MemRead) begin
      case (Funct3)
        3'b100: begin //lbu
            rd <= {24'b0, Dataout[7:0]};
        end
        3'b010:  //LW
            rd <= Dataout;
        3'b001:  begin//Lh
            rd <= $signed(Dataout[15:0]);
        end
        3'b000:  begin//Lb
            rd <= $signed(Dataout[7:0]);
        end
        default: rd <= Dataout;
      endcase
    end else if (MemWrite) begin
      case (Funct3)
        3'b010: begin  //SW
          Wr <= 4'b1111;
          Datain <= wd;
        end
        3'b000: begin // SB
          Wr <= 4'b0100;
          Datain[7:0] <= wd;
        end
        3'b001: begin //SH
          Wr <= 4'b1100;
          Datain[15:0] <= wd;
        end
        default: begin
          Wr <= 4'b1111;
          Datain <= wd;
        end
      endcase
    end
  end

endmodule
