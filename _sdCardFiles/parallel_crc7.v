//-----------------------------------------------------------------------------
// Copyright (C) 2009 OutputLogic.com 
// This source file may be used and distributed without restriction 
// provided that this copyright statement is not removed from the file 
// and that any derivative work contains the original copyright notice 
// and the associated disclaimer. 
// 
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS 
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED	
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
//-----------------------------------------------------------------------------
// CRC module for data[39:0] ,   crc[6:0]=1+x^3+x^7;
//-----------------------------------------------------------------------------

`include "timescale.v"

module parallel_CRC7(
	input clk,
	input rst,
	input crc_en,
	output reg complt,
	input [39:0] data_in,
	output [6:0] crc_out);

  reg [6:0] lfsr_q,lfsr_c;

  assign crc_out = lfsr_q;

  always @(posedge clk) begin
    lfsr_c[0] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ data_in[0] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[30] ^ data_in[31] ^ data_in[34] ^ data_in[35] ^ data_in[37] ^ data_in[39];
    lfsr_c[1] = lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ data_in[1] ^ data_in[5] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[31] ^ data_in[32] ^ data_in[35] ^ data_in[36] ^ data_in[38];
    lfsr_c[2] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ data_in[2] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[32] ^ data_in[33] ^ data_in[36] ^ data_in[37] ^ data_in[39];
    lfsr_c[3] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[6] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[20] ^ data_in[26] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[38] ^ data_in[39];
    lfsr_c[4] = lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[6] ^ data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[27] ^ data_in[28] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[39];
    lfsr_c[5] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[28] ^ data_in[29] ^ data_in[32] ^ data_in[33] ^ data_in[35] ^ data_in[37];
    lfsr_c[6] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[11] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[29] ^ data_in[30] ^ data_in[33] ^ data_in[34] ^ data_in[36] ^ data_in[38];

  end // always

  always @(posedge clk, posedge rst) begin
    if(rst) begin
      lfsr_q <= {7{1'b0}};
		complt <= 1'b0;
    end
    else 
	 begin
      if(crc_en)
      begin
			if(~complt)
			begin
				lfsr_q <= lfsr_c;
				complt <= 1'b1;
			end
      end
		else
		begin
			lfsr_q <= {7{1'b0}};
			complt <= 1'b0;
		end
    end
  end // always
endmodule // crc