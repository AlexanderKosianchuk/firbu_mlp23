`include "timescale.v"

module inputBusToSDDatBusPovider (
  CLK, 
  RST, 
  ENA,
  COMPLT,
  INPUTBUS, 
  OUTPUTBUS);
  
  parameter blockSize = 1023; // [1023:0](512bytes  through 4 lines)
  parameter CRCWidth = 15; //[15:0]
  parameter inputBusWidth = 3; //[3:0]
  
  input tri CLK, RST, ENA;
  input tri[inputBusWidth:0] INPUTBUS;
  output reg [3:0] OUTPUTBUS;
  output reg COMPLT;

  reg [11:0] i;
 
  tri [CRCWidth:0] outCRC0;
  tri [CRCWidth:0] outCRC1;
  tri [CRCWidth:0] outCRC2;
  tri [CRCWidth:0] outCRC3;
  
  reg rstCRC;
  reg enaCRC;
  
  reg [inputBusWidth:0] dataLine;
  
always @ (posedge CLK)
begin
if(RST)
begin
	i <= 0;
end
else
begin
	if(ENA)
	begin
		i = i + 1;
	end
	else
	begin
		i <= 0;
	end
end

end

always @(negedge CLK)
begin
	if(RST)
	begin
		COMPLT <= 1'b0;
		rstCRC <= 1'b1;
		OUTPUTBUS <= {4{1'bz}};
	end//if(rst)
	else
	begin
		if(ENA)
		begin
			//start bit
			if(i == 1)
			begin	
				rstCRC <= 1'b0;
				OUTPUTBUS <= {4{1'b0}};
			end
			else if ((i >= 2) && (i <= (blockSize + 1)))
			begin
				enaCRC <= 1'b1;
				OUTPUTBUS <= {4{1'b0}};
				dataLine <= {4{1'b0}};
			end
			
			else if ((i >= (blockSize + 2)) && (i < (blockSize + 3)))
			begin
				enaCRC <= 1'b1;
				OUTPUTBUS <= {4{1'b1}};
				dataLine <= {4{1'b1}};
			end
							
			else if((i >= (blockSize + 3) && (i <= (blockSize + CRCWidth + 3))))
			begin
				enaCRC = 1'b0;
				
				OUTPUTBUS[0] <= outCRC0[blockSize + CRCWidth + 3 - i];
				OUTPUTBUS[1] <= outCRC1[blockSize + CRCWidth + 3 - i];
				OUTPUTBUS[2] <= outCRC2[blockSize + CRCWidth + 3 - i];
				OUTPUTBUS[3] <= outCRC3[blockSize + CRCWidth + 3 - i];
			end
			//end bit
			else if(i == (blockSize + CRCWidth + 4))
			begin
				$display ("DAT0 CRC %b, %h" ,outCRC0,outCRC0);
				
				OUTPUTBUS <= {4{1'b1}};
			
			end
			else if(i >= (blockSize + CRCWidth + 5))
			begin
				COMPLT <= 1'b1;
				OUTPUTBUS <= {4{1'bz}};
				$display("%d data block transfer complete", $time);
			end
			else
			begin
				COMPLT <= 1'b0;
				rstCRC <= 1'b1;
				OUTPUTBUS <= {4{1'bz}};
			end
		end//if(enable)
		else
		begin
			COMPLT <= 1'b0;
			rstCRC <= 1'b1;
			OUTPUTBUS <= {4{1'bz}};
		end
	end//else
end//always
  
serial_crc16 line0(	
CLK,
rstCRC,
enaCRC,
dataLine[0],
outCRC0);

serial_crc16 line1(	
CLK,
rstCRC,
enaCRC,
dataLine[1],
outCRC1);

serial_crc16 line2(	
CLK,
rstCRC,
enaCRC,
dataLine[2],
outCRC2);

serial_crc16 line3(	
CLK,
rstCRC,
enaCRC,
dataLine[3],
outCRC3);

endmodule
