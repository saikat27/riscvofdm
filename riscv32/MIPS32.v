module pipe_RISC32 (clk1, clk2);

input clk1, clk2; // Two-phase clock

reg [31:0] PC, IF_ID_IR, IF_ID_NPC;
reg [31:0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;
reg [6:0] ID_EX_type, EX_MEM_type, MEM_WB_type;
reg [31:0] EX_MEM_IR, EX_MEM_ALUOut, EX_MEM_B;
reg EX_MEM_cond;
reg [31:0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD;
reg [31:0] Reg [0:31]; // Register bank (32 x 32)
reg [31:0] Mem [0:1023]; // 1024 x 32 memory
parameter 

ADD=3'b000, SUB=3'b001, AND=3'b111, OR=3'b110, SLT=3'b010, //rr type

ADDI=3'b000, SLTI=3'b010, //register immediate type

LW=3'b010, // load
SW=3'b010, // store

BEQZ=3'b000, //Branch

HLT=3'b111;


parameter 	RR_ALU=7'b0110011, 
		RM_ALU=7'b0010011, 
		LOAD=7'b0000011,	
		STORE=7'b0100011,
		BRANCH=7'b1100011,
		HALT=7'b1111111;

reg HALTED;
// Set after HLT instruction is completed (in WB stage)
reg TAKEN_BRANCH;
// Required to disable instructions after branch

always @(posedge clk1) begin // IF Stage
if (HALTED == 0)
begin
if ((EX_MEM_IR[6:0] == BRANCH) && (EX_MEM_cond == 1))
begin
IF_ID_IR <= #2 Mem[EX_MEM_ALUOut];
TAKEN_BRANCH <= #2 1'b1;
IF_ID_NPC <= #2 EX_MEM_ALUOut + 1;
PC <= #2 EX_MEM_ALUOut + 1;
end
else
begin
IF_ID_IR <= #2 Mem[PC];
IF_ID_NPC <= #2 PC + 1;
PC <= #2 PC + 1;
end
end
end

always @(posedge clk2) begin // ID Stage
    if (HALTED == 0) begin    
        //decoding rs1 and rs2
//        if (IF_ID_IR[19:15] == 5'b00000) 
//            ID_EX_A <= 0;
//        else 
        ID_EX_A <= #2 Reg[IF_ID_IR[19:15]]; // "rs1"
        
//        if (IF_ID_IR[24:20] == 5'b00000) 
//            ID_EX_B <= 0;
//        else 
        ID_EX_B <= #2 Reg[IF_ID_IR[24:20]]; // "rt OR rs2"
        
        ID_EX_NPC <= #2 IF_ID_NPC;
        ID_EX_IR <= #2 IF_ID_IR;
        
        //ID_EX_Imm <= #2 {{20{IF_ID_IR[31]}}, {IF_ID_IR[31:20]}}; //sign extension of 12 bit offset for addi slti lw
        
        if(IF_ID_IR[6:0] == STORE) //if STORE
            ID_EX_Imm <= #2 {{20{IF_ID_IR[31]}}, {IF_ID_IR[31:25]}, {IF_ID_IR[11:7]}};        
        else
            ID_EX_Imm <= #2 {{20{IF_ID_IR[31]}}, {IF_ID_IR[31:20]}};
        
        ID_EX_type=IF_ID_IR[6:0];
//        case (IF_ID_IR[6:0])  // decoding instruction types
//        ADD,SUB,AND,OR,SLT: ID_EX_type <= #2 RR_ALU;
//        ADDI,SLTI: ID_EX_type <= #2 RM_ALU;
//        LW: ID_EX_type <= #2 LOAD;
//        SW: ID_EX_type <= #2 STORE;
//        BEQZ: ID_EX_type <= #2 BRANCH;
//        HLT: ID_EX_type <= #2 HALT;
//        default: ID_EX_type <= #2 HALT;
//        // Invalid opcode
//        endcase
        
    end
end

always @(posedge clk1) // EX Stage
if (HALTED == 0)
begin
EX_MEM_type <= #2 ID_EX_type;
EX_MEM_IR <= #2 ID_EX_IR;
TAKEN_BRANCH <= #2 0;

case (ID_EX_type)
    RR_ALU: begin
        case (ID_EX_IR[14:12]) // "funct3"
        ADD: EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_B;
        SUB: EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_B;
        AND: EX_MEM_ALUOut <= #2 ID_EX_A & ID_EX_B;
        OR: EX_MEM_ALUOut <= #2 ID_EX_A | ID_EX_B;
        SLT: EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_B;
        default: EX_MEM_ALUOut <= #2 32'hxxxxxxxx;
        endcase
        end
    
    RM_ALU: begin
    case (ID_EX_IR[14:12]) // "opcode"
    ADDI: EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;
    SLTI: EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_Imm;
    default: EX_MEM_ALUOut <= #2 32'hxxxxxxxx;
    endcase
    end

    LOAD, STORE:
    begin
    EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;
    EX_MEM_B <= #2 ID_EX_B;
    end

    BRANCH: begin
    EX_MEM_ALUOut <= #2 ID_EX_NPC + ID_EX_Imm;
    EX_MEM_cond <= #2 (ID_EX_A == 0);
    end
endcase
end


always @(posedge clk2) // MEM Stage
    if (HALTED == 0)
    begin
    MEM_WB_type <= EX_MEM_type;
    MEM_WB_IR <= #2 EX_MEM_IR;
    case (EX_MEM_type)
    RR_ALU, RM_ALU: MEM_WB_ALUOut <= #2 EX_MEM_ALUOut;
    LOAD: MEM_WB_LMD <= #2 Mem[EX_MEM_ALUOut];
    STORE: if (TAKEN_BRANCH == 0) // Disable write
    Mem[EX_MEM_ALUOut] <= #2 EX_MEM_B;
    endcase
end

always @(posedge clk1) // WB Stage
begin
if (TAKEN_BRANCH == 0) // Disable write if branch taken
case (MEM_WB_type)
RR_ALU: Reg[MEM_WB_IR[11:7]] <= #2 MEM_WB_ALUOut; // "rd"
RM_ALU: Reg[MEM_WB_IR[11:7]] <= #2 MEM_WB_ALUOut; // "rd"
LOAD: Reg[MEM_WB_IR[11:7]] <= #2 MEM_WB_LMD; // "rd"
HALT: HALTED <= #2 1'b1;
endcase
end
endmodule