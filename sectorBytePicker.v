 `include "timescale.v"
`include "defines.v"

module sectorBytePicker(
RST,
CLK,
ENA,
ADDRBEG,
NUM,
INPUT,
ADDR,
RENA,
COMPLT,
Q);
 
input  tri        RST, CLK, ENA;
input  tri [8:0]  ADDRBEG;
input  tri [1:0]  NUM;
input  tri [7:0]  INPUT;
output reg [8:0]  ADDR;
output reg        RENA;
output reg        COMPLT;
output reg [31:0] Q;

localparam maxCounterValue = 8; //because Q[31:0]

localparam
setAddr = 0,
getCircleShiftByte = 1,
setOutput = 2;

reg [2:0] state;
reg [2:0] nextState;

always @(posedge RST or posedge CLK)
begin
if(RST)
begin
end
else
begin
if(ENA)
begin
	
end
end
end

//-------------------------------------------
reg [3:0] i;
always @ (posedge RST or posedge CLK)
begin
if(RST)
begin
	i <= 0;
	COMPLT <= 1'b0;
	RENA <= 1'b0;
end
else
begin
	if(ENA)
	begin
		if(i <= (maxCounterValue + 1))
		begin
			i <= i + 1'b1;
			COMPLT <= 1'b0;
			RENA <= 1'b1;
		end
		else
		begin
			COMPLT <= 1'b1;
			RENA <= 1'b0;
		end
	end
	else
	begin
		i <= 0;
		COMPLT <= 1'b0;
		RENA <= 1'b0;
	end
end

end

//-------------------------------------------
always @ (posedge RST or posedge i[0])
begin

if(RST)
begin
	ADDR <= 0;
end
else
begin
	if(ENA)
	begin
	  if(i <= 1)
	  begin
	    ADDR <= ADDRBEG;
	  end
	  else
	  begin
		  if(i[0] == 1'b1)
		  begin
			 ADDR <= ADDR + 1;
		  end
		end
	end
	else
	begin
		ADDR <= 0;
	end
end

end
//-------------------------------------------
reg [7:0] circleShiftByte;

always @ (posedge i[0])
begin

if(RST)
begin
	circleShiftByte <= 0;
end
else
begin
	if(ENA)
	begin
		if(i[0] == 1'b1)
		begin
			circleShiftByte[7:4] <= INPUT[3:0];
			circleShiftByte[3:0] <= INPUT[7:4];
		end
	end
	else
	begin
		circleShiftByte <= 0;
	end
end

end
//-------------------------------------------
always @ (i[0])
begin

if(RST)
begin
	Q <= 0;
end
else
begin
	if(ENA)
	begin
		if(i[0] == 1'b0)
		begin
			if(!COMPLT)
			begin
			  if(i <= (((NUM + 1) * 2) + 2))
			  begin
				  Q [31:24] <= circleShiftByte;
				end
				else
				begin
				  Q [31:24] <= {8{1'b0}};
				end
			end
		end
		else if(i[0] == 1'b1)
		begin
			if(!COMPLT)
			begin
				Q <= Q >> 4'b1000;
			end
		end
	end
	else
	begin
		Q <= 0;
	end
end

end

endmodule