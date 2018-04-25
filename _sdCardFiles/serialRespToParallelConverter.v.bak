`include "timescale.v"

module serialRespToParallelConverter(
CLK, 
RST,
ENA,  
COMPLT,
ERROR,
NORESP,
CRC_ERROR,
CMDINDEX,
INPUTSERIALCMD, 
OUTPUTPARALLELCMD);

parameter outputParallelRespWidth;

input tri CLK, RST, ENA;
output reg COMPLT, ERROR, NORESP, CRC_ERROR;
input tri INPUTSERIALCMD;
input tri [5:0] CMDINDEX;
output reg [outputParallelRespWidth:0] OUTPUTPARALLELCMD;

reg [7:0] i;
reg [7:0] j;

reg respBegin;

reg rstCRC;
reg enaCRC;
reg dataCRCLine;
tri [6:0]outCRC;

//integer Ncr_min = 2;
integer Ncr_max = 64;

always @ (posedge CLK, posedge RST)
begin
if(RST)
begin
	j <= 0;
	COMPLT <= 1'b0;
	ERROR <= 1'b0;
	NORESP <= 1'b0;
	CRC_ERROR <= 1'b0;
end
else
begin

if(ENA)
begin
	if(j <= (outputParallelRespWidth + Ncr_max))
	begin
		if(respBegin)
		begin
      if(i > outputParallelRespWidth)
			begin
				if((OUTPUTPARALLELCMD[outputParallelRespWidth : outputParallelRespWidth-1] == 2'b00) && 
				(OUTPUTPARALLELCMD [0] == 1) &&
				(OUTPUTPARALLELCMD [outputParallelRespWidth - 2 : outputParallelRespWidth - 7] == CMDINDEX))
				begin
					if(OUTPUTPARALLELCMD [8 : 1] == outCRC)
					begin
						COMPLT <= 1'b1;
						ERROR <= 1'b0;
						NORESP <= 1'b0;
						CRC_ERROR <= 1'b0;
						$display("%d Getting response complete", $time);
						$display("%b",OUTPUTPARALLELCMD);
					end
					else
					begin
						COMPLT <= 1'b1;
						CRC_ERROR <= 1'b1;
						$display("%d CRC error", $time);
					end
				end
				else
				begin
					COMPLT <= 1'b1;
					ERROR <= 1'b1;
					$display("%d Response error", $time);
				end
			end
			end

		j = j + 1;
	end
	else
	begin
		j <= 1'b0;
		COMPLT <= 1'b1;
		NORESP <= 1'b1;
		$display("%d No response", $time);
	end
		 
end //if(enable)

else
begin
	j <= 1'b0;
	COMPLT <= 1'b0;
	ERROR <= 1'b0;
	NORESP <= 1'b0;
	CRC_ERROR <= 1'b0;
end 

end //else RST
	
end //always

always @ (posedge CLK)
begin
	if(RST)
	begin
		i <= 1'b0;
		respBegin <= 1'b0;
		enaCRC <= 1'b0;
		rstCRC <= 1'b1;
		OUTPUTPARALLELCMD	<= {outputParallelRespWidth{1'b0}};
	end
else
begin
	if(ENA)
	begin
	 if(!COMPLT)
	 begin
	   if(respBegin)
	   begin
	     if(i <= (outputParallelRespWidth - 8))
	     begin
	       enaCRC <= 1'b1;
	       rstCRC <= 1'b0;
	     end
	     else
	     begin
	       enaCRC <= 1'b0;
	       rstCRC <= 1'b0;
	     end
	     
	       OUTPUTPARALLELCMD [outputParallelRespWidth - i] = INPUTSERIALCMD;
	       dataCRCLine	<= INPUTSERIALCMD;
	       i <= i + 1;
	   end
	   else
	   begin
	     if(INPUTSERIALCMD == 1'b0)
	     begin
	       enaCRC <= 1'b1;
	       rstCRC <= 1'b0;
	       respBegin <= 1'b1;
	       OUTPUTPARALLELCMD [outputParallelRespWidth - i] = INPUTSERIALCMD;
	       dataCRCLine	<= INPUTSERIALCMD;
	       i <= i + 1;
	     end
	     else
	     begin
	       respBegin <= 1'b0;
	     end
		end
		end
	end
	else
	begin
		i <= 1'b0;
		respBegin <= 1'b0;
		OUTPUTPARALLELCMD	<= {outputParallelRespWidth{1'b0}};
		enaCRC <= 1'b0;
		rstCRC <= 1'b1;
	end
end
end

serial_CRC7 crc7RespChecker(	
CLK,
rstCRC,
enaCRC,
dataCRCLine,
outCRC);

endmodule


