module test_risc32;
    reg clk1, clk2;
    integer k;
    reg [31:0] PC, IF_ID_IR, IF_ID_NPC;
    reg [31:0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;
    reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;
    reg [31:0] EX_MEM_IR, EX_MEM_ALUOut, EX_MEM_B;
    reg EX_MEM_cond;
    reg [31:0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD;
    reg [31:0] Reg [0:31]; // Register bank (32 x 32)
    reg [31:0] Mem [0:1023]; // 1024 x 32 memory

//    pipe_RISC32 (clk1, clk2) DUT(
//    .clk1(clk1), 
//    .clk2(clk2),
//    .PC(PC), 
//    .IF_ID_IR(IF_ID_IR), 
//    .IF_ID(IF_ID), 
//    .IF_ID_NPC(IF_ID_NPC),
//    .Mem(Mem)
//    );
    pipe_RISC32 DUT (clk1, clk2);

    initial
        begin
        clk1 = 0; clk2 = 0;
        repeat (20) // Generating two-phase clock
        begin
        #5 clk1 = 1; #5 clk1 = 0;
        #5 clk2 = 1; #5 clk2 = 0;
        end
    end
    
    initial
        begin
        $display("Loading Instructions to memory...");
        for (k=0; k<31; k=k+1) begin
            DUT.Mem[k] = 0;
            DUT.Reg[k]=0;
        end
        $display("Register file initialised....");
        $display(".........");
        $display(".........");
        DUT.Mem[0] = 32'h00a00093; // ADDI R1,R0,10	// 000000001010 00000 000 00001 0010011
        DUT.Mem[1] = 32'h01400113; // ADDI R2,R0,20	// 000000010100 00000 000 00010 0010011
        DUT.Mem[2] = 32'h01900193; // ADDI R3,R0,25	// 000000011001 00000 000 00011 0010011
        DUT.Mem[3] = 32'h0073e3b3; // OR R7,R7,R7 -- dummy instr. // 0000000 00111 00111 110 00111 0110011
        DUT.Mem[4] = 32'h0073e3b3; // OR R7,R7,R7 -- dummy instr.
        DUT.Mem[5] = 32'h00208233; // ADD R4,R1,R2	// 0000000 00010 00001 000 00100 0110011
        DUT.Mem[6] = 32'h0073e3b3; // OR R7,R7,R7 -- dummy instr.
        DUT.Mem[7] = 32'h003202b3; // ADD R5,R4,R3	// 0000000 00011 00100 000 00101 0110011
        DUT.Mem[8] = 32'h0000707f; // HLT		// 00000000000000000 111 00000 1111111
        $display("Instructions Loaded....");

        
        DUT.HALTED = 0;
        DUT.PC = 0;
        DUT.TAKEN_BRANCH = 0;
        #280
        for (k=0; k<6; k=k+1) begin
        $display ("R%1d - %2d", k, DUT.Reg[k]);
        end
        end
    
//    initial
//        begin
//        #280    
//        for (k=0; k<10; k=k+1) begin
//        $display ("Mem%1d - %h", k, DUT.Mem[k]);
//        end
//       end
      always@(posedge clk1) begin
        $display("Program Counter:%h", DUT.PC);
        $display("Insrtuction Register:%h",DUT.IF_ID_IR);
      end
      
      always@(posedge clk2) begin
        $display("ALU operand A(rs1):%d, \t\tALU Operand B(rt/rs2):%d, \t\tImmediate Operand:%d, \t\tALU Output:%d", DUT.ID_EX_A, DUT.ID_EX_B,DUT.ID_EX_Imm, DUT.MEM_WB_ALUOut);
      end  
       
    initial
        begin
        $dumpfile ("DUT.vcd");
        $dumpvars (0, test_risc32);
        #300 $finish;
        end
     
endmodule

