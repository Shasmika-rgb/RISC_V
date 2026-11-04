module wb_stage (
    input  logic [31:0] mem_out,
    input  logic [31:0] alu_out,
    input  logic [31:0] return_addr,
    input  logic [31:0] imm_out,
    input  logic [31:0] pc_signed_offset,
    input  logic [1:0]  memtoreg,
    input  logic [6:0]  opcode_out_d,
    output logic [31:0] wb_data
);
    localparam logic [6:0] OP_JAL   = 7'b1101111;
    localparam logic [6:0] OP_JALR  = 7'b1100111;
    localparam logic [6:0] OP_LUI   = 7'b0110111;
    localparam logic [6:0] OP_AUIPC = 7'b0010111;

    always_comb begin
        case (memtoreg)
            2'b00: wb_data = alu_out;
            2'b01: wb_data = mem_out;
            2'b10: begin
                case (opcode_out_d)
                    OP_JAL, OP_JALR: wb_data = return_addr;
                    OP_LUI:          wb_data = imm_out;
                    OP_AUIPC:        wb_data = pc_signed_offset;
                    default:         wb_data = alu_out;
                endcase
            end
            2'b11: wb_data = alu_out;
            default: wb_data = alu_out;
        endcase
    end
endmodule
