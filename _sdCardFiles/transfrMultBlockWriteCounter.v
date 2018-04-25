module transfrMultBlockWriteCounter(
RST,
CLK,
NUM);

input wire RST, CLK;
output reg [31:0] NUM;

always @ (posedge RST or posedge CLK)
begin
	if(RST)
	begin
		NUM <= 32'h0;
	end
	else
	begin
		NUM <= NUM + 32'h1;
	end
end

endmodule