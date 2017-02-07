/*
  Yiheng
  chi14@purdue.edu

  control unit source code
*/

// interface include
`include "control_unit_if.vh"

// include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

module control_unit (
  control_unit_if.cu cuif
);
  // type import
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  // instruction type tests
  logic itype_r, itype_i, itype_j, itype_h;

  // casted instructions
  r_t rti;
  i_t iti;
  j_t jti;


  // cast input instruction
  assign rti = r_t'(cuif.instr);
  assign iti = i_t'(cuif.instr);
  assign jti = j_t'(cuif.instr);

  // assign truth values to tests
  always_comb begin
    if (rti.opcode == RTYPE) itype_r = 1'b1;
    else itype_r = 1'b0;
    if (iti.opcode >= BEQ && iti.opcode <= SC) itype_i = 1'b1;
    else itype_i = 1'b0;
    if (jti.opcode == J || jti.opcode == JAL) itype_j = 1'b1;
    else itype_j = 1'b0;
    if (iti.opcode == HALT) itype_h = 1'b1;
    else itype_h = 1'b0;
  end

  always_comb begin
    casez(1)

      itype_r: begin

        cuif.RegDst = RD;
        cuif.ALUSrc = 1'b0;
        cuif.MemtoReg = ALUO;
        cuif.RegWEN = 1'b1;
        cuif.dWENi = 1'b0;
        cuif.dRENi = 1'b0;
        cuif.ExtOp = SHAMEXT;
        cuif.opfunc = OTHERR;
        cuif.halt = 1'b0;

        if (rti.funct == JR) begin
          cuif.opfunc = OJR;
          cuif.RegWEN = 1'b0;
        end

        if (rti.funct == SLL || rti.funct == SRL)
          cuif.ALUSrc = 1'b1;

        casez(rti.funct)
          ADDU: cuif.ALUOp = ALU_ADD;
          ADD:  cuif.ALUOp = ALU_ADD;
          AND:  cuif.ALUOp = ALU_AND;
          NOR:  cuif.ALUOp = ALU_NOR;
          OR:   cuif.ALUOp = ALU_OR;
          SLT:  cuif.ALUOp = ALU_SLT;
          SLTU: cuif.ALUOp = ALU_SLTU;
          SUBU: cuif.ALUOp = ALU_SUB;
          SUB:  cuif.ALUOp = ALU_SUB;
          XOR:  cuif.ALUOp = ALU_XOR;
          SLL:  cuif.ALUOp = ALU_SLL;
          SRL:  cuif.ALUOp = ALU_SRL;
          default: cuif.ALUOp = ALU_AND;
        endcase

      end //itype_r

      itype_i: begin

        cuif.RegDst = RT;
        cuif.ALUSrc = 1'b1;
        cuif.MemtoReg = ALUO;
        cuif.RegWEN = 1'b1;
        cuif.dWENi = 1'b0;
        cuif.dRENi = 1'b0;
        cuif.ExtOp = SIGNEXT;
        cuif.opfunc = OTHERI;
        cuif.halt = 1'b0;

        if (iti.opcode == BEQ || iti.opcode == BNE) begin
          cuif.RegWEN = 1'b0;
          cuif.ALUSrc = 1'b0;
          if (iti.opcode == BEQ) cuif.opfunc = OBEQ;
          else cuif.opfunc = OBNE;
        end

        if (iti.opcode == LUI) begin
          cuif.MemtoReg = PORTB;
          cuif.ExtOp = LUIEXT;
        end

        if (iti.opcode == LW) begin
          cuif.MemtoReg = DLOAD;
          cuif.dRENi = 1'b1;
        end

        if (iti.opcode == SW) begin
          cuif.RegWEN = 1'b0;
          cuif.dWENi = 1'b1;
        end

        if (iti.opcode == ANDI || iti.opcode == ORI || iti.opcode == XORI)
          cuif.ExtOp = ZEROEXT;

        casez(iti.opcode)
          ADDIU: cuif.ALUOp = ALU_ADD;
          ADDI:  cuif.ALUOp = ALU_ADD;
          ANDI:  cuif.ALUOp = ALU_AND;
          ORI:   cuif.ALUOp = ALU_OR;
          SLTI:  cuif.ALUOp = ALU_SLT;
          SLTIU: cuif.ALUOp = ALU_SLTU;
          XORI:  cuif.ALUOp = ALU_XOR;
          BEQ:   cuif.ALUOp = ALU_SUB;
          BNE:   cuif.ALUOp = ALU_SUB;
          LW:    cuif.ALUOp = ALU_ADD;
          SW:    cuif.ALUOp = ALU_ADD;
          default: cuif.ALUOp = ALU_AND;
        endcase

      end //itype_i

      itype_j: begin

        cuif.RegDst = R31;
        cuif.ALUSrc = 1'b0;
        cuif.MemtoReg = NPC;
        cuif.RegWEN = 1'b1;
        cuif.dWENi = 1'b0;
        cuif.dRENi = 1'b0;
        cuif.ALUOp = ALU_AND;
        cuif.ExtOp = ZEROEXT;
        cuif.halt = 1'b0;

        if (jti.opcode == J) begin
          cuif.opfunc = OJ;
          cuif.RegWEN = 1'b0;
        end else begin
          cuif.opfunc = OJAL;
        end

      end //itype_j

      itype_h: begin

        cuif.RegDst = R31;
        cuif.ALUSrc = 1'b0;
        cuif.MemtoReg = NPC;
        cuif.RegWEN = 1'b0;
        cuif.dWENi = 1'b0;
        cuif.dRENi = 1'b0;
        cuif.ALUOp = ALU_AND;
        cuif.ExtOp = ZEROEXT;
        cuif.opfunc = OTHERI;
        cuif.halt = 1'b1;

        //if (cuif.instr == 32'b1) cuif.halt = 1'b1;

      end //itype_h

      default: begin

        cuif.RegDst = R31;
        cuif.ALUSrc = 1'b0;
        cuif.MemtoReg = NPC;
        cuif.RegWEN = 1'b0;
        cuif.dWENi = 1'b0;
        cuif.dRENi = 1'b0;
        cuif.ALUOp = ALU_AND;
        cuif.ExtOp = ZEROEXT;
        cuif.opfunc = OTHERI;
        cuif.halt = 1'b0;

     end //default
    endcase
  end //always_comb

endmodule
