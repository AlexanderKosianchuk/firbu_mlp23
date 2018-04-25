module USBdigitizer(
CLK,
RST,
ENA,

DATA_IN_USBBUFF,
WADDR_USBBUFF,
WCLK_USBBUFF,
WENA_USBBUFF,
BUFFREADY_USBTRANS,

AVG);

input  wire        CLK, ENA, RST;
output wire [7:0]  DATA_IN_USBBUFF;
output reg  [7:0]  WADDR_USBBUFF;
output wire        WCLK_USBBUFF;
output wire        WENA_USBBUFF;
output reg         BUFFREADY_USBTRANS;
input  wire [7:0]  AVG;

assign WCLK_USBBUFF    = ENA ? !CLK : 1'b0;
assign WENA_USBBUFF    = ENA;
assign DATA_IN_USBBUFF = ENA ? AVG : {8{1'bz}};

always @ (posedge RST or negedge WCLK_USBBUFF)
begin
	if(RST)
	begin
		WADDR_USBBUFF <= 8'd0;
	end
	else
	begin
		WADDR_USBBUFF <= WADDR_USBBUFF + 8'd1;
	end
end

always @ (WADDR_USBBUFF)
begin
	if(WADDR_USBBUFF <= 8'd127)
	begin
		BUFFREADY_USBTRANS <= 1'b0;
	end
	else if ((WADDR_USBBUFF > 8'd127) && (WADDR_USBBUFF <= 8'd255))
	begin
		BUFFREADY_USBTRANS <= 1'b1;
	end
	else
	begin
		BUFFREADY_USBTRANS <= BUFFREADY_USBTRANS;
	end
end

endmodule