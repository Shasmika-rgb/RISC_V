module imm_generator (
    input  logic [11:0] imm_input,
    input  logic [2:0]  fn3,
    input  logic [6:0]  opcode,
    input  logic [19:0] imm_input_uj,
    output logic [31:0] imm_output
);
    localparam logic [6:0] OP_I_ALU  = 7'b0010011;
    localparam logic [6:0] OP_BRANCH = 7'b1100011;
    localparam logic [6:0] OP_JAL    = 7'b1101111;
    localparam logic [6:0] OP_JALR   = 7'b1100111;
    localparam logic [6:0] OP_LUI    = 7'b0110111;
    localparam logic [6:0] OP_AUIPC  = 7'b0010111;

    always_comb begin
        case (opcode)
            OP_BRANCH:
                imm_output = {{19{imm_input[11]}}, imm_input, 1'b0};
            OP_JAL:
                imm_output = {{11{imm_input_uj[19]}}, imm_input_uj, 1'b0};
            OP_LUI, OP_AUIPC:
                imm_output = {imm_input_uj, 12'b0};
            OP_JALR:
                imm_output = {{20{imm_input[11]}}, imm_input};
            OP_I_ALU: begin
                if ((fn3 == 3'b001) || (fn3 == 3'b101))
                    imm_output = {27'b0, imm_input[4:0]};
                else
                    imm_output = {{20{imm_input[11]}}, imm_input};
            end
            default:
                imm_output = {{20{imm_input[11]}}, imm_input};
        endcase
    end
endmodule
