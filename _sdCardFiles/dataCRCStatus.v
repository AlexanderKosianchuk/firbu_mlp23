`include "timescale.v"

module dataCRCStatus(
CLK, 
RST,
ENA,  
COMPLT,
ERROR,
INPUTSERIALSTATUS);

localparam statusWidth = 4;
reg [statusWidth:0] statusReaderReg;

input tri CLK, RST, ENA;
output reg COMPLT, ERROR;
input tri INPUTSERIALSTATUS;

reg [4:0] i;

integer Nwr = 10;

always @ (posedge CLK)
begin
if(RST)
begin
	i <= 0;
	COMPLT <= 1'b0;
	ERROR <= 1'b0;
end
else
begin

if(ENA)
begin
	if(i <= statusWidth)
	begin
		statusReaderReg [statusWidth - i] = INPUTSERIALSTATUS;
		i = i + 1;
	end
	else
	begin
		if(i <= (statusWidth + Nwr))
		begin
			if((statusReaderReg[statusWidth] == 1'b0) && 
				(statusReaderReg [0] == 1'b1))
			begin
				if(statusReaderReg [statusWidth - 1 : 1] == 3'b010)
				begin
					COMPLT <= 1'b1;
					ERROR <= 1'b0;
					$display("%d Getting response complete", $time);
					$display("%b",statusReaderReg);
				end
				else
				begin
					COMPLT <= 1'b1;
					ERROR <= 1'b1;
					$display("%d Getting response complete. Satus error detected", $time);
					$display("%b",statusReaderReg);
				end
			end
			else
			begin
				statusReaderReg <= statusReaderReg << 1;
				statusReaderReg [0] <= INPUTSERIALSTATUS;
				i = i + 1;
			end
		end
		else
		begin
			COMPLT <= 1'b1;
			ERROR <= 1'b1;
			$display("%d No response", $time);
		end
end
		 
end //if(enable)

else
begin
	i <= 0;
	COMPLT <= 1'b0;
	ERROR <= 1'b0;
end 

end //else RST
	
end //always

endmodule

//`include "timescale.v"
//
//module dataCRCStatus(
//CLK, 
//RST,
//ENA,  
//COMPLT,
//STATUS,
//INPUTBUS);
//
//parameter statusWidth = 3;
//
//input tri CLK, RST, ENA;
//input tri [3:0] INPUTBUS;
//output reg STATUS; // 1 - err, 0 - ok
//output reg COMPLT;
//
//reg [statusWidth:0] statusReaderReg;
//
//integer i;
//integer Nwr = 250;
//
//always @ (posedge CLK, posedge RST)
//begin
//	if(RST)
//	begin
//		STATUS = 1'b0;
//		COMPLT = 1'b0;
//		i = 0;
//	end
//	else
//	begin
//		if(ENA)
//		begin
//			if(i <= statusWidth)
//			begin
//				statusReaderReg[statusWidth - i] = INPUTBUS[0];
//				i = i + 1;
//			end
//			else
//			begin
//				if(i <= (statusWidth + Nwr)) //time limit
//				begin
//					if(statusReaderReg[statusWidth:0] == 4'b00101)
//					begin
//						COMPLT = 1'b1;
//						STATUS = 1'b0;
//						$display("%d Getting status complete", $time);
//						$display("%b", statusReaderReg);
//					end
//					else
//					begin
//						statusReaderReg = statusReaderReg << 1;
//						statusReaderReg[0] = INPUTBUS[0];
//						i = i + 1;
//					end
//				end
//				else
//				begin
//					COMPLT = 1'b1;
//					STATUS = 1'b1;
//					$display("%d Response error", $time);
//				end
//			end
//		end //if(enable)
//		else
//		begin
//			STATUS = 1'b0;
//			COMPLT = 1'b0;
//			i = 0;
//		end
//	end //else 
//end //always
//
//endmodule
