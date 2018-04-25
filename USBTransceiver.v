module USBTransceiver(
CLK, 
RST,
ENA,
RCLK_USBBUFF,
RADDR_USBBUFF,
Q_USBBUFF,
BUFFREADY_USBTRANS,
TXE,
WR_USBTRANS,
D_USBTRANS);

input  wire        CLK, RST, ENA;
output wire        RCLK_USBBUFF;
output wire [7:0]  RADDR_USBBUFF;
input  wire [7:0]  Q_USBBUFF;
input  wire        BUFFREADY_USBTRANS;
input  wire        TXE;
output wire        WR_USBTRANS;
output wire [7:0]  D_USBTRANS;

reg        ENA_PUMP;
reg  [7:0] RADDR_START;
wire       COMPLT_PUMP;

localparam 
startRaddr1 = 8'd0,
startRaddr2 = 8'd126;

USBTransceiverPumper USBTransceiverPumperUnit(
CLK,
ENA_PUMP,
RADDR_START,
RCLK_USBBUFF,
RADDR_USBBUFF,
Q_USBBUFF,
WR_USBTRANS,
D_USBTRANS,
COMPLT_PUMP);

localparam 
waitBuff1     = 11,
checkTXE11    = 12,
transBlock11  = 13,

waitBuff2     = 21,
checkTXE21    = 22,
transBlock21  = 23;

reg [23:0] state/* synthesis syn_encoding = "safe, one-hot" */;
reg [23:0] nextState/* synthesis syn_encoding = "safe, one-hot" */;

always @ (posedge RST or posedge CLK)
begin
	if(RST)
	begin
		state <= waitBuff1;
	end
	else
	begin
		state <= nextState;
	end
end

always @ (RST or state or COMPLT_PUMP or TXE or BUFFREADY_USBTRANS)
begin
	if(RST)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr1;
		nextState   <= waitBuff1;
	end
	else
	begin
	
case (state)
waitBuff1:
begin
	if(BUFFREADY_USBTRANS == 1'b0)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr1;
		nextState   <= waitBuff1;
	end
	else if(BUFFREADY_USBTRANS == 1'b1)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr1;
		nextState   <= checkTXE11;
	end
	else
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr1;
		nextState   <= waitBuff1;
	end
end
//=================
checkTXE11:
begin
	if(TXE)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr1;
		nextState   <= checkTXE11;
	end
	else if(!TXE)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr1;
		nextState   <= transBlock11;
	end
	else
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr1;
		nextState   <= checkTXE11;
	end
end
//=================
transBlock11:
begin
	if(!COMPLT_PUMP)
	begin
		ENA_PUMP    <= 1'b1;
		RADDR_START <= startRaddr1;
		nextState   <= transBlock11;
	end
	else if(COMPLT_PUMP)
	begin
		ENA_PUMP    <= 1'b1;
		RADDR_START <= startRaddr1;
		nextState   <= waitBuff2;
	end
	else
	begin
		ENA_PUMP    <= 1'b1;
		RADDR_START <= startRaddr1;
		nextState   <= transBlock11;
	end	
end
//=================
waitBuff2:
begin
	if(BUFFREADY_USBTRANS == 1'b1)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr2;
		nextState   <= waitBuff2;
	end
	else if(BUFFREADY_USBTRANS == 1'b0)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr2;
		nextState   <= checkTXE21;
	end
	else
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr2;
		nextState   <= waitBuff2;
	end
end
//=================
checkTXE21:
begin
	if(TXE)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr2;
		nextState   <= checkTXE21;
	end
	else if(!TXE)
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr2;
		nextState   <= transBlock21;
	end
	else
	begin
		ENA_PUMP    <= 1'b0;
		RADDR_START <= startRaddr2;
		nextState   <= checkTXE21;
	end
end
//=================
transBlock21:
begin
	if(!COMPLT_PUMP)
	begin
		ENA_PUMP    <= 1'b1;
		RADDR_START <= startRaddr2;
		nextState   <= transBlock21;
	end
	else if(COMPLT_PUMP)
	begin
		ENA_PUMP    <= 1'b1;
		RADDR_START <= startRaddr2;
		nextState   <= waitBuff1;
	end
	else
	begin
		ENA_PUMP    <= 1'b1;
		RADDR_START <= startRaddr2;
		nextState   <= transBlock21;
	end	
end

//=================
endcase
	
	end
end


endmodule