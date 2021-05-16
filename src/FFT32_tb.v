module tb_FFT32;
	parameter 					FFT_size		= 32;
	parameter 					IN_width		= 12;
	parameter 					OUT_width		= 16;
	parameter 					cycle			= 10.0;
	integer 					i,j,k,file_id;
    reg signed	[IN_width-1:0]  int_r           [0:FFT_size-1];
    reg signed	[IN_width-1:0]  int_i           [0:FFT_size-1];
    reg signed	[OUT_width-1:0]  out_r           [0:FFT_size-1];
    reg signed	[OUT_width-1:0]  out_i           [0:FFT_size-1];
	reg 						clk, rst_n, in_valid;
	wire 						out_valid;
	reg signed  [IN_width-1:0] 	din_r, din_i;
	wire signed [OUT_width-1:0] dout_r, dout_i;
////////////////////////////////////////////
	always #(cycle/2.0) 
		clk = ~clk;
////////////////////////////////////////////
	FFT32 uut_FFT32(
		.clk(clk),
		.rst_n(rst_n),
		.in_valid(in_valid),
		.din_r(din_r),
		.din_i(din_i),
		.out_valid(out_valid),
		.dout_r(dout_r),
		.dout_i(dout_i)
	);
////////////////////////////////////////////	
	initial begin
	   $display("Loading Data from Memory");
//	   $readmemb("input5.mem",int_r);
	
	
		int_r[0] =  32;
        int_r[1] =  0;
        int_r[2] =  0;
        int_r[3] =  0;
        int_r[4] =  0;
        int_r[5] =  0;
        int_r[6] =  0;
        int_r[7] =  0;
        int_r[8] =  0;
        int_r[9] =  0;
        int_r[10] = 0;
        int_r[11] =  0;
        int_r[12] =  0;
        int_r[13] =  0;
        int_r[14] =  0;
        int_r[15] =  0;
        int_r[16] =  0;
        int_r[17] =  0;
        int_r[18] =  0;
        int_r[19] =  0;
        int_r[20] =  0;
        int_r[21] =  0;
        int_r[22] =  0;
        int_r[23] =  0;
        int_r[24] =  0;
        int_r[25] =  0;
        int_r[26] =  0;
        int_r[27] =  0;
        int_r[28] =  0;
        int_r[29] =  0;
        int_r[30] =  0;
        int_r[31] =  0;
//		int_r[32] = 1;
//		int_r[33] = 1;
//		int_r[34] = 1;
//		int_r[35] = 1;
//		int_r[36] = 1;
//		int_r[37] = 1;
//		int_r[38] = 1;
//		int_r[39] = 1;
//		int_r[40] = 1;
//		int_r[41] = 1;
//		int_r[42] = 1;
//		int_r[43] = 1;
//		int_r[44] = 1;
//		int_r[45] = 1;
//		int_r[46] = 1;
//		int_r[47] = 1;
//		int_r[48] = 1;
//		int_r[49] = 1;
//		int_r[50] = 1;
//		int_r[51] = 1;
//		int_r[52] = 1;
//		int_r[53] = 1;
//		int_r[54] = 1;
//		int_r[55] = 1;
//		int_r[56] = 1;
//		int_r[57] = 1;
//		int_r[58] = 1;
//		int_r[59] = 1;
//		int_r[60] = 1;
//		int_r[61] = 1;
//		int_r[62] = 1;	
//		int_r[63] = 1;
	end
	initial begin
		int_i[0] =    0;
		int_i[1] =    0;
		int_i[2] =    0;
		int_i[3] =    0;
		int_i[4] =    0;
		int_i[5] =    0;
		int_i[6] =    0;
		int_i[7] =    0;
		int_i[8] =    0;
		int_i[9] =    0;
		int_i[10] =   0;
		int_i[11] =   0;
		int_i[12] =   0;
		int_i[13] =   0;
		int_i[14] =   0;
		int_i[15] =   0;
		int_i[16] =   0;
		int_i[17] =   0;
		int_i[18] =   0;
		int_i[19] =   0;
		int_i[20] =   0;
		int_i[21] =   0;
		int_i[22] =   0;
		int_i[23] =   0;
		int_i[24] =   0;
		int_i[25] =   0;
		int_i[26] =   0;
		int_i[27] =   0;
		int_i[28] =   0;
		int_i[29] =   0;
		int_i[30] =   0;
		int_i[31] =   0;
//		int_i[32] =    0;
//		int_i[33] =    0;
//		int_i[34] =    0;
//		int_i[35] =    0;
//		int_i[36] =    0;
//		int_i[37] =    0;
//		int_i[38] =    0;
//		int_i[39] =    0;
//		int_i[40] =    0;
//		int_i[41] =    0;
//		int_i[42] =   0;
//		int_i[43] =   0;
//		int_i[44] =   0;
//		int_i[45] =   0;
//		int_i[46] =   0;
//		int_i[47] =   0;
//		int_i[48] =   0;
//		int_i[49] =   0;
//		int_i[50] =   0;
//		int_i[51] =   0;
//		int_i[52] =   0;
//		int_i[53] =   0;
//		int_i[54] =   0;
//		int_i[55] =   0;
//		int_i[56] =   0;
//		int_i[57] =   0;
//		int_i[58] =   0;
//		int_i[59] =   0;
//		int_i[60] =   0;
//		int_i[61] =   0;
//		int_i[62] =   0;
//		int_i[63] =   0;	
	end
////////////////////////////////////////////
    initial begin
        clk = 0;
        rst_n    = 1;
        in_valid    = 0;
        @(negedge clk);
        @(negedge clk) rst_n   = 0;
        @(negedge clk) rst_n  = 1;
        @(negedge clk);
////////////////////////
    for(j = 0;j < FFT_size;j = j + 1) begin
        @(negedge clk);
        in_valid = 1;
        din_r = int_r[j];
        din_i = int_i[j];
        end
        @(negedge clk) in_valid = 0;
////////////////////////
////////////////////////
    for(j=0;j<FFT_size;j=j+1) begin
        while(!out_valid) begin
        @(negedge clk);
        end
        @(negedge clk);
        out_r[j]=dout_r;
        out_i[j]=dout_i;
        end
       
    file_id= $fopen("output_r.mem","a+");
    $fwrite(file_id,out_r);
    $fclose(file_id);
    
    file_id= $fopen("output_i.mem","a+");
    $fwrite(file_id,out_i);
    $fclose(file_id);
    
    file_id= $fopen("inputs.mem","a+");
    $fwrite(file_id,int_r);
    $fclose(file_id);
    
///////////////////////
///////////////////////
$stop;
end
endmodule
