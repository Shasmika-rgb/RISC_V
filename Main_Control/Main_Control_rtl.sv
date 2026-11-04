module main_control (
    input  logic [6:0] opcode,
    input  logic [2:0] fn3,
    output logic [1:0] memtoreg,
    output logic       branch,
    output logic       mux_inp,
    output logic       memread,
    output logic       memwrite,
    output logic       alusrc,
    output logic       reg_write,
    output logic [2:0] aluop
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

    always_comb begin
        memtoreg = 2'b00;
        branch   = 1'b0;
        mux_inp  = 1'b0;
        memread  = 1'b0;
        memwrite = 1'b0;
        alusrc   = 1'b0;
        reg_write= 1'b0;
        aluop    = 3'b000;

        case (opcode)
            OP_R: begin
                reg_write = 1'b1;
                aluop = 3'b000;
            end
            OP_I_ALU: begin
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b001;
            end
            OP_LOAD: begin
                memtoreg = 2'b01;
                memread = 1'b1;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b010;
            end
            OP_STORE: begin
                memtoreg = 2'b11;
                memwrite = 1'b1;
                alusrc = 1'b1;
                aluop = 3'b011;
            end
            OP_BRANCH: begin
                branch = 1'b1;
                aluop = 3'b100;
            end
            OP_JAL: begin
                memtoreg = 2'b10;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b110;
            end
            OP_JALR: begin
                memtoreg = 2'b10;
                mux_inp = 1'b1;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b001;
            end
            OP_LUI: begin
                memtoreg = 2'b10;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b110;
            end
            OP_AUIPC: begin
                memtoreg = 2'b10;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b000;
            end
            default: begin
                // All control signals remain inactive.
            end
        endcase
    end
endmodule
