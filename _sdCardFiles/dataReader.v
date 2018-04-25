module dataReader(
CLK,
RST,
ENA,
DATA,
WENA,
WADDR,  
INPUT,
CRCERROR,
NORESPERROR,
COMPLT);

input  tri       CLK;
input  tri       RST;
input  tri       ENA;
output reg [3:0] DATA;
output reg       WENA;
output reg [9:0] WADDR;
input  tri [3:0] INPUT;
output reg       CRCERROR;
output reg       NORESPERROR;
output reg       COMPLT;

localparam dataSize = 1042; //1 + 1 + 1024 + 16 + 1
localparam blockSize = 1024; //1 + 1024 + 1
localparam noRespLimit = 25000;

//========================================
reg beginReading;
reg [6:0] noRespCounter;

always @ (INPUT [0] or RST or ENA)
begin
if(RST)
begin
	beginReading <= 1'b0;
	noRespCounter <= 1'b0;
	NORESPERROR <= 1'b0;
end
else
begin

if(ENA)
begin

	if(beginReading == 0)
	begin
		if(INPUT [0] == 0)
		begin
			beginReading <= 1'b1;
		end
		else
		begin
			if (noRespCounter < noRespLimit)
			begin
				beginReading <= 1'b0;
				noRespCounter <= noRespCounter + 1;
			end
			else
			begin
				NORESPERROR <= 1'b1;
			end
		end
	end

end
else
begin
	beginReading <= 1'b0;
	noRespCounter <= 1'b0;
	NORESPERROR <= 1'b0;
end
end

end

//========================================

reg [12:0] i;

always @ (negedge CLK)
begin
if(RST)
begin
	i <= 0;
end
else
begin
	if(beginReading)
	begin
		i <= i + 1'b1;
	end
	else
	begin
		i <= 0;
	end
end

end

always @ (negedge CLK)
begin
if(RST)
begin
	WADDR <= 0;
end
else
begin
	if(beginReading) //not start bit
	begin
			if((i <= (blockSize) && (i > 1))) //not start bit
			begin
			 WADDR <= WADDR + 1;
			end
			else
			begin
			 WADDR <= 0;
			end
	end
	else
	begin
		WADDR <= 0;
	end
end

end

always @ (posedge RST or posedge CLK)
begin
if(RST)
begin
	COMPLT <= 1'b0;
	DATA <= {8{1'b0}};
	WENA <= 1'b0;
end
else
begin
//-
if(ENA)
begin
//--------------------------

if(beginReading)
begin//if(beginReading)
if(i <= dataSize)
begin
	if(i <= (blockSize))
	begin
	  WENA <= 1'b1;
		DATA <= INPUT;
	end
	else
	begin
		DATA <= {8{1'b0}};
		WENA <= 1'b0;
		//CRC CHECK
	end
end
else
begin
  WENA <= 1'b0;
	COMPLT <= 1'b1;
end
	
end//if(beginReading)
else
begin
	COMPLT <= 1'b0;
	DATA <= {8{1'b0}};
	WENA <= 1'b0;
end

//--------------------------
end
else
begin
	COMPLT <= 1'b0;
	DATA <= {8{1'b0}};
	WENA <= 1'b0;
end
//-
end

end

//tri [8:0] RADDR_SU;
//tri [7:0] REG_SU;
//
//sector sectorUnit2(
//RST,
//CLK,
//DATA,
//RADDR_SU,
//WADDR,
//WENA,
//REG_SU);

endmodule