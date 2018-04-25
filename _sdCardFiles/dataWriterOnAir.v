`include "timescale.v"
`include "defines.v"

module dataWriterOnAir(
CLK,
ENA,
CLK_ADC,
INPUT,
SD_DAT,
COMPLT);

parameter blockSize = 1024; // 
parameter CRCWidth = 15; //[15:0]
parameter inputBusWidth = 7; //[7:0]
parameter outputBusWidth = 3; //[3:0]
  
input  wire                    CLK, ENA;  
output reg                     CLK_ADC;       
input  wire [inputBusWidth:0]  INPUT;
output tri  [outputBusWidth:0] SD_DAT;
output reg                     COMPLT;

reg [inputBusWidth:0] bufData;
reg [outputBusWidth:0] data;
assign SD_DAT = ENA ? (COMPLT ? {4{1'bz}} : data) : {4{1'bz}};

always @ (negedge CLK)
begin
  if(ENA)
  begin
    CLK_ADC <= ~CLK_ADC;
  end
  else
  begin
   CLK_ADC <= 1'b0;
  end
end

always @(posedge CLK)
begin
  if(ENA)
  begin
    bufData <= INPUT;
  end
  else
  begin
    bufData <= 8'h00;
  end
end
 
reg rstCRC;
reg enaCRC;
wire [CRCWidth:0] outCRC0;
wire [CRCWidth:0] outCRC1;
wire [CRCWidth:0] outCRC2;
wire [CRCWidth:0] outCRC3;

reg [outputBusWidth:0] dataCRCLine;

serial_CRC16 lineDW_OA0(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[0],
outCRC0);

serial_CRC16 lineDW_OA1(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[1],
outCRC1);

serial_CRC16 lineDW_OA2(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[2],
outCRC2);

serial_CRC16 lineDW_OA3(	
CLK,
rstCRC,
enaCRC,
dataCRCLine[3],
outCRC3);

wire [12:0] counter;
sectorToWriteAddrCounterOut sectorToWriteAddrCounterOut_OAUnit(
~ENA,
CLK,
counter);

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
      COMPLT <= 1'b0;
      if(counter[0] == 1'b0)
      begin
        dataCRCLine[3:0] <= bufData[7:4];
        data[3:0] <= bufData[7:4];
      end
      else if(counter[0] == 1'b1)
      begin
        dataCRCLine[3:0] <= bufData[3:0];
        data[3:0] <= bufData[3:0];
      end
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