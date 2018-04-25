module movingAverage(
CLK,
RST,
ENA,

INPUT_ADC1,
INPUT_ADC2,

CLK_ADC1,
CLK_ADC2,

DATA_DBUFF,
WADDR_DBUFF,
WCLK_DBUFF,
WREN_DBUFF,

DATA_IN_USBBUFF,
WADDR_USBBUFF,
WCLK_USBBUFF,
WENA_USBBUFF,
BUFFREADY_USBTRANS,

BLOCKS_DIGITIZED);

input wire CLK, RST, ENA;
input [7:0] INPUT_ADC1;
input [7:0] INPUT_ADC2;

output reg CLK_ADC1;
output reg CLK_ADC2;

output wire [7:0]  DATA_DBUFF;
output wire [14:0] WADDR_DBUFF;
output wire	       WCLK_DBUFF;
output wire	       WREN_DBUFF;

output wire [7:0]  DATA_IN_USBBUFF;
output wire [7:0]  WADDR_USBBUFF;
output wire        WCLK_USBBUFF;
output wire        WENA_USBBUFF;
output wire        BUFFREADY_USBTRANS;

output reg  [31:0] BLOCKS_DIGITIZED;

reg CLK_DIGITIZER;
//wire CLK_DIGITIZER;
//assign CLK_DIGITIZER = CLK;

reg [7:0]   AVG;
reg [7:0]   AVG1;
reg [7:0]   AVG2;


always @ (posedge RST or negedge WADDR_DBUFF[8])
begin
	if(RST)
	begin
		BLOCKS_DIGITIZED <= 32'd0;
	end
	else
	begin
		BLOCKS_DIGITIZED <= BLOCKS_DIGITIZED + 32'd1;
	end
end

sectorToWriteDigitizer sectorToWriteDigitizerUnit(
CLK_DIGITIZER,
RST,
ENA,

DATA_DBUFF,
WADDR_DBUFF,
WCLK_DBUFF,
WREN_DBUFF,

AVG);

USBdigitizer USBdigitizerUnit(
CLK_DIGITIZER,
RST,
ENA,

DATA_IN_USBBUFF,
WADDR_USBBUFF,
WCLK_USBBUFF,
WENA_USBBUFF,
BUFFREADY_USBTRANS,

AVG);

reg ENA_COUNTER;
reg [2:0] counter;

localparam glitchTime = 2;
reg [3:0] muteCountersTimer;

always @ (negedge ENA or posedge CLK)
begin
	if(!ENA)
	begin
		muteCountersTimer <= 0;
		ENA_COUNTER <= 1'b0;
	end
	else
	begin
		if(muteCountersTimer < glitchTime)
		begin
			ENA_COUNTER <= 1'b0;
			muteCountersTimer <= muteCountersTimer + 1;
		end
		else
		begin
			muteCountersTimer <= muteCountersTimer;
			ENA_COUNTER <= 1'b1;
		end
	end
end

//reg [1:0] count2; 
//
//always @ (negedge CLK)
//begin
//	if(ENA_COUNTER)
//	begin
//		count2 <= count2 + 2'b1;
//	end
//	else
//	begin
//		count2 <= 2'b0;
//	end
//end
//
//reg signed [31:0] count1; 
//
//always @ (negedge count2[1])
//begin
//	if(ENA_COUNTER)
//	begin
//		count1 <= count1 + 32'b1;
//	end
//	else
//	begin
//		count1 <= 32'b0;
//	end
//end
//
//always @ (posedge CLK)
//begin
//	case(count2)
//2'b00:
//begin
//	AVG <= count1[7:0];
//end
//2'b01:
//begin
//	AVG <= count1[15:8];
//end
//2'b10:
//begin
//	AVG <= count1[23:16];
//end
//2'b11:
//begin
//	AVG <= count1[31:24];
//end	
//	
//	endcase
//end

//assign CLK_ADC1 = CLK;
//
//always @ (negedge CLK)
//begin
//	AVG <= INPUT_ADC1;
//end

//===============================================


always @ (negedge CLK)
begin
	if(ENA_COUNTER)
	begin
		counter <= counter + 3'b001;
	end
	else
	begin
		counter <= 3'b000;
	end
end

reg [255:0] initialReg1;
reg [15:0]  sum1;
reg [255:0] initialReg2;
reg [15:0]  sum2;

always @ (posedge CLK)
begin

if(counter == 3'b000)
begin
CLK_DIGITIZER <= 1'b1;

CLK_ADC1 <= 1'b1;
CLK_ADC2 <= 1'b0;

sum1 <= sum1;
initialReg1 <= initialReg1;
AVG1 <= AVG1;

sum2 <= sum2;
initialReg2 <= initialReg2;
AVG2 <= AVG2;

AVG <= AVG;

end
else if(counter == 3'b001)
begin

CLK_DIGITIZER <= 1'b1;

CLK_ADC1 <= 1'b1;
CLK_ADC2 <= 1'b0;
 
initialReg1 [7:0] <= INPUT_ADC1[7:0];
initialReg1 [15:8] <= 8'h00;

sum1 [15:0] <= initialReg1 [15:0] +
initialReg1 [31:16] +
initialReg1 [47:32] +
initialReg1 [63:48] +
initialReg1 [79:64] +
initialReg1 [95:80] +
initialReg1 [111:96] +
initialReg1 [127:112] +
initialReg1 [143:128] +
initialReg1 [159:144] +
initialReg1 [175:160] +
initialReg1 [191:176] +
initialReg1 [207:192] +
initialReg1 [223:208] +
initialReg1 [239:224] +
initialReg1 [255:240];

AVG1 <= AVG1;

sum2 <= sum2;
initialReg2 <= initialReg2;
AVG2 <= AVG2;

AVG <= AVG;

end
else if(counter == 3'b010)
begin

CLK_DIGITIZER <= 1'b0;

CLK_ADC1 <= 1'b1;
CLK_ADC2 <= 1'b0;

sum1 <= sum1;
initialReg1 <= initialReg1 << 256'h10;
//dividing on 2^4 ekvivalent to right shift to 4
AVG1 <= sum1 >> 8'h04;

sum2 <= sum2;
initialReg2 <= initialReg2;
AVG2 <= AVG2;

AVG <= AVG;

end
else if(counter == 3'b011)
begin

CLK_DIGITIZER <= 1'b0;

CLK_ADC1 <= 1'b0;
CLK_ADC2 <= 1'b1;

initialReg1 <= initialReg1;
sum1 <= sum1;
AVG1 <= AVG1;


sum2 <= sum2;
initialReg2 <= initialReg2;
AVG2 <= AVG2;

AVG <= AVG1;

end
else if(counter == 3'b100)
begin

CLK_DIGITIZER <= 1'b1;

CLK_ADC1 <= 1'b0;
CLK_ADC2 <= 1'b1;

initialReg1 <= initialReg1;
AVG1 <= AVG1;
sum1 <= sum1;

initialReg2 <= initialReg2;
AVG2 <= AVG2;
sum2 <= sum2;

AVG <= AVG;

end
else if(counter == 3'b101)
begin

CLK_DIGITIZER <= 1'b1;

CLK_ADC1 <= 1'b0;
CLK_ADC2 <= 1'b1;

initialReg1 <= initialReg1;
AVG1 <= AVG1;
sum1 <= sum1;

initialReg2 [7:0] <= INPUT_ADC2[7:0];
initialReg2 [15:8] <= 8'h00;

sum2 [15:0] <= initialReg2 [15:0] +
initialReg2 [31:16] +
initialReg2 [47:32] +
initialReg2 [63:48] +
initialReg2 [79:64] +
initialReg2 [95:80] +
initialReg2 [111:96] +
initialReg2 [127:112] +
initialReg2 [143:128] +
initialReg2 [159:144] +
initialReg2 [175:160] +
initialReg2 [191:176] +
initialReg2 [207:192] +
initialReg2 [223:208] +
initialReg2 [239:224] +
initialReg2 [255:240];
AVG2 <= AVG2;

AVG <= AVG;
end
else if(counter == 3'b110)
begin

CLK_DIGITIZER <= 1'b0;

CLK_ADC1 <= 1'b0;
CLK_ADC2 <= 1'b1;

initialReg1 <= initialReg1;
sum1 <= sum1;
AVG1 <= AVG1;

sum2 <= sum2;
initialReg2 <= initialReg2 << 256'h10;
//dividing on 2^4 ekvivalent to right shift to 4
AVG2 <= sum2 >> 8'h04;

AVG <= AVG;

end
else if(counter == 3'b111)
begin

CLK_DIGITIZER <= 1'b0;

CLK_ADC1 <= 1'b1;
CLK_ADC2 <= 1'b0;

initialReg1 <= initialReg1;
sum1 <= sum1;
AVG1 <= AVG1;

initialReg2 <= initialReg2;
sum2 <= sum2;

AVG <= AVG2;

end
else
begin

CLK_DIGITIZER <= CLK_DIGITIZER;

CLK_ADC1 <= CLK_ADC1;
CLK_ADC2 <= CLK_ADC2;

initialReg1 <= initialReg1;
sum1 <= sum1;
AVG1 <= AVG1;

initialReg2 <= initialReg2;
sum2 <= sum2;
AVG2 <= AVG2;

AVG <= AVG;

end

end

endmodule

/*
reg [31:0] i;

always @(CLK)
begin
  
if(CLK)
begin
  sum <= 16'b0;      
end
else
begin
    
for (i = 0; i < 16; i = i + 1)
begin
	
case(i)
32'h0:
begin
	sum <= sum + initialReg [7:0];
end
32'h1:
begin
	sum <= sum + initialReg [15:8];
end
32'h2:
begin
	sum <= sum + initialReg [23:16];
end
32'h3:
begin
	sum <= sum + initialReg [31:24];
end
32'h4:
begin
	sum <= sum + initialReg [39:32];
end
32'h5:
begin
	sum <= sum + initialReg [47:40];
end
32'h6:
begin
	sum <= sum + initialReg [55:48];
end
32'h7:
begin
	sum <= sum + initialReg [63:56];
end
32'h8:
begin
	sum <= sum + initialReg [71:64];
end
32'h9:
begin
	sum <= sum + initialReg [79:72];
end
32'hA:
begin
	sum <= sum + initialReg [87:80];
end
32'hB:
begin
	sum <= sum + initialReg [95:88];
end
32'hC:
begin
	sum <= sum + initialReg [103:96];
end
32'hD:
begin
	sum <= sum + initialReg [111:104];
end
32'hE:
begin
	sum <= sum + initialReg [119:112];
end
32'hF:
begin
	sum <= sum + initialReg [127:120];
end
endcase
		
end

end

	sum [15:0] <= initialReg [7:0] + initialReg [15:8] + initialReg [23:16] + 
			initialReg [31:24] + initialReg [39:32] + initialReg [47:40] + 
			initialReg [55:48] + initialReg [63:56] + initialReg [71:64] +
			initialReg [79:72] + initialReg [87:80] + initialReg [95:88] + 
			initialReg [103:96] + initialReg [111:104] + initialReg [119:112] + 
			initialReg [127:120];
end
*/