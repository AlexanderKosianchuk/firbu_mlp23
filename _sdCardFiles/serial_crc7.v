// ==========================================================================
// CRC Generation Unit - Linear Feedback Shift Register implementation
// (c) Kay Gorontzi, GHSi.de, distributed under the terms of LGPL
// https://www.ghsi.de/CRC/index.php?

// https://www.ghsi.de/CRC/index.php?
// =========================================================================

`include "timescale.v"

module serial_CRC7(
CLK, 
RST, 
ENA, 
BITVAL, 
CRC);
 

input CLK; // Current bit valid (Clock)
input RST;   
input ENA; // Init CRC value
input BITVAL; // Next input bit
output reg [6:0] CRC; // Current output CRC value

   
 // We need output registers
wire inv;
   
assign inv = BITVAL ^ CRC[6]; // XOR required?
   
always @(negedge CLK) 
begin
	if (RST) 
	begin
		CRC = {16{1'b0}};
	end
	else 
	begin
		if (ENA)
		begin
				CRC[6] = CRC[5];
				CRC[5] = CRC[4];
				CRC[4] = CRC[3];
				CRC[3] = CRC[2] ^ inv;
				CRC[2] = CRC[1];
				CRC[1] = CRC[0];
				CRC[0] = inv;
		end
	end
end
endmodule

