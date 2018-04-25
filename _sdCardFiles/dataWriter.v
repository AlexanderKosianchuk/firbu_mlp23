`include "timescale.v"
`include "defines.v"

module dataWriter(
CLK,
ENA,
RENA,
RCLK,
RADDR,
RADDR_BEGIN,
OUTPUT_SW,
SD_DAT,
COMPLT);

parameter blockSize = 1024; // 
parameter CRCWidth = 15; //[15:0]
parameter busWidth = 3; //[3:0]
  
input  wire              CLK, ENA;
output reg               RENA;
output wire              RCLK;
output reg  [10:0]       RADDR;
input  wire [10:0]       RADDR_BEGIN;             
input  wire [busWidth:0] OUTPUT_SW;
output tri  [busWidth:0] SD_DAT;
output reg               COMPLT;

reg [busWidth:0] data;

assign RCLK = CLK;
assign SD_DAT = ENA ? (COMPLT ? {4{1'bz}} : data) : {4{1'bz}};
 
reg rstCRC;
reg enaCRC;
wire [CRCWidth:0] outCRC0;
wire [CRCWidth:0] outCRC1;
wire [CRCWidth:0] outCRC2;
wire [CRCWidth:0] outCRC3;

reg [busWidth:0] dataCRCLine;

serial_CRC16 lineDW0(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[0],
outCRC0);

serial_CRC16 lineDW1(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[1],
outCRC1);

serial_CRC16 lineDW2(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[2],
outCRC2);

serial_CRC16 lineDW3(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[3],
outCRC3);

wire [12:0] counter;
sectorToWriteAddrCounterOut sectorToWriteAddrCounterOutUnit(
~ENA,
CLK,
counter);

/*wire [12:0] counter_N;
sectorToWriteAddrCounterOut sectorToWriteAddrCounterOut1Unit(
~ENA,
~CLK,
counter_N);*/

always @ (CLK)
begin
  if(ENA)
  begin
    if(!COMPLT)
    begin
      RENA <= 1'b1;
    end
    else
    begin
      RENA <= 1'b0;
    end
  end
  else
  begin
    RENA <= 1'b0;
  end
end

always @ (negedge CLK)
begin
  if(ENA)
  begin
    if((counter >= 12'd1) && (counter <= 12'd1025))
    begin
      RADDR <= RADDR + 1'b1;
    end
    else
    begin
      RADDR <= RADDR_BEGIN;
    end
  end
  else
  begin
    RADDR <= RADDR_BEGIN;
  end
end

always @ (negedge CLK)
begin
  if(ENA)
  begin
    if(counter < 12'd001)
    begin
      rstCRC <= 1'b1;
      enaCRC <= 1'b0;
      data <= {4{1'bz}};
      COMPLT <= 1'b0;
    end
    else if(counter == 12'd001)
    begin
      rstCRC <= 1'b1;
      enaCRC <= 1'b0;
      data <= 4'h0;
      COMPLT <= 1'b0;
    end
    else if ((counter >= 12'd2) && (counter < 12'd1026))
    begin
      rstCRC <= 1'b0;
      enaCRC <= 1'b1;
      dataCRCLine[0] <= OUTPUT_SW[0];
      dataCRCLine[1] <= OUTPUT_SW[1];
      dataCRCLine[2] <= OUTPUT_SW[2];
      dataCRCLine[3] <= OUTPUT_SW[3];
      data <= OUTPUT_SW;
      COMPLT <= 1'b0;
    end
    else if ((counter >= 12'd1026) && (counter < 12'd1042))
    begin
      rstCRC <= 1'b0;
      enaCRC <= 1'b0;
      data[0] <= outCRC0[1041 - counter];
      data[1] <= outCRC1[1041 - counter];
      data[2] <= outCRC2[1041 - counter];
      data[3] <= outCRC3[1041 - counter];
      COMPLT <= 1'b0;
    end
    else if (counter == 12'd1042)
    begin
      rstCRC <= 1'b0;
      enaCRC <= 1'b0;
      data <= 4'hf;
      COMPLT <= 1'b0;
    end
    else
    begin
      rstCRC <= 1'b1;
      enaCRC <= 1'b0;
      data <= {4{1'bz}};
      COMPLT <= 1'b1;
    end
  end
  else
  begin
    rstCRC <= 1'b1;
    enaCRC <= 1'b0;
    data <= {4{1'bz}};
    COMPLT <= 1'b0;
  end
end





endmodule
  
  