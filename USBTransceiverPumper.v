module USBTransceiverPumper(
CLK,
ENA,
RADDR_START,
RCLK_USBBUFF,
RADDR_USBBUFF,
Q_USBBUFF,
WR_USBTRANS,
D_USBTRANS,
COMPLT);

input  wire       CLK, ENA;
input  wire [7:0] RADDR_START;
output wire       RCLK_USBBUFF;
output reg  [7:0] RADDR_USBBUFF;
input  wire [7:0] Q_USBBUFF;
output reg        WR_USBTRANS;
output reg  [7:0] D_USBTRANS;
output reg        COMPLT;

assign RCLK_USBBUFF = ENA ? !CLK : 1'b0;

always @ (negedge ENA or negedge RCLK_USBBUFF)
begin
	if(!ENA)
	begin
		RADDR_USBBUFF <= RADDR_START;
	end
	else
	begin
		RADDR_USBBUFF <= RADDR_USBBUFF + 8'd1;
	end
end


reg [8:0] counter;
always @ (negedge ENA or negedge CLK)
begin
	if(!ENA)
	begin
		counter <= 9'd0;
	end
	else
	begin
		counter  <= counter + 9'd1;
	end
end

always @ (posedge CLK)
begin
	if(counter[0])
	begin
		D_USBTRANS[7:1] <= Q_USBBUFF[7:1];
		D_USBTRANS[0]   <= 1'b1;
	end
	else
	begin
		D_USBTRANS[7:1] <= Q_USBBUFF[7:1];
		D_USBTRANS[0]   <= 1'b0;
	end
end

always @ (posedge CLK)
begin
	if((counter >= 9'd2) && (counter <= 9'd129))
	begin
		WR_USBTRANS <= 1'b0;
	end
	else
	begin
		WR_USBTRANS <= 1'b1;
	end
end

always @ (counter)
begin
	if(counter <= 9'd130)
	begin
		COMPLT <= 1'b0;
	end
	else
	begin
		COMPLT <= 1'b1;
	end
end

endmodule