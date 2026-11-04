module decoder (
    input  logic [31:0] instruction,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3,
    output logic [11:0] imm,
    output logic [19:0] imm_uj,
    output logic        fn7_5
);
    localparam logic [6:0] OP_R      = 7'b0110011;
    localparam logic [6:0] OP_I_ALU  = 7'b0010011;
    localparam logic [6:0] OP_LOAD   = 7'b0000011;
    localparam logic [6:0] OP_STORE  = 7'b0100011;
    localparam logic [6:0] OP_BRANCH = 7'b1100011;
    localparam logic [6:0] OP_JAL    = 7'b1101111;
    localparam logic [6:0] OP_JALR   = 7'b1100111;
    localparam logic [6:0] OP_LUI    = 7'b0110111;
    localparam logic [6:0] OP_AUIPC  = 7'b0010111;

    assign opcode = instruction[6:0];

    always_comb begin
        rs1      = 5'd0;
        rs2      = 5'd0;
        rd       = 5'd0;
        imm11_5  = 7'd0;
        fn3      = 3'd0;
        imm      = 12'd0;
        imm_uj   = 20'd0;
        fn7_5    = 1'b0;

        case (opcode)
            OP_R: begin
                rd    = instruction[11:7];
                fn3   = instruction[14:12];
                rs1   = instruction[19:15];
                rs2   = instruction[24:20];
                fn7_5 = instruction[30];
            end
            OP_I_ALU: begin
                rd      = instruction[11:7];
                fn3     = instruction[14:12];
                rs1     = instruction[19:15];
                imm     = instruction[31:20];
                imm11_5 = instruction[31:25];
            end
            OP_LOAD: begin
                rd  = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
            end
            OP_STORE: begin
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {instruction[31:25], instruction[11:7]};
            end
            OP_BRANCH: begin
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {instruction[31], instruction[7],
                       instruction[30:25], instruction[11:8]};
            end
            OP_JAL: begin
                rd     = instruction[11:7];
                imm_uj = {instruction[31], instruction[19:12],
                          instruction[20], instruction[30:21]};
            end
            OP_JALR: begin
                rd  = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
            end
            OP_LUI, OP_AUIPC: begin
                rd     = instruction[11:7];
                imm_uj = instruction[31:12];
            end
            default: begin
                // Unsupported opcode: all decoded fields remain zero.
            end
        endcase
    end
endmodule
