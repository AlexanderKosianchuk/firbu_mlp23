module numCounter(
CLK,
ENA,
DEF_NUM,
NUM);

input wire CLK, ENA;
input wire [31:0] DEF_NUM;
output reg [31:0] NUM;

always @ (posedge CLK)
begin
	if(ENA)
	begin
		NUM <= NUM + 32'b1;
	end
	else
	begin
		NUM <= DEF_NUM;
	end
end

endmodule