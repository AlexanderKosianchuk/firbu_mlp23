`include "timescale.v"
`include "defines.v"

module FIRBU_AM(
EXT_CLK,
EXT_USB_CLK,

SD_CLK,
SD_CMD,
SD_DAT,

ADC_CLK1,
ADC_CLK2,
ADC_INPUT1,
ADC_INPUT2,

LED,
BUT,

D,
RXF,
TXE,
WR,
RD,
SIWU,
OE);


reg  RST;

input  wire       EXT_CLK/* synthesis altera_chip_pin_lc="@22" */;
input  wire       EXT_USB_CLK/* synthesis altera_chip_pin_lc="@91" */;
output tri        SD_CLK/* synthesis altera_chip_pin_lc="@51" */;
inout  tri        SD_CMD/* synthesis altera_chip_pin_lc="@50" */;
inout  tri  [3:0] SD_DAT/* synthesis altera_chip_pin_lc="@49, @46, @53, @52" */;

output wire       ADC_CLK1/* synthesis altera_chip_pin_lc="@72" */;
output wire       ADC_CLK2;///* synthesis altera_chip_pin_lc="@68" */;
input  wire [7:0] ADC_INPUT1/* synthesis altera_chip_pin_lc="@64, @65, @66, @67, @68, @69, @70, @71" */;
input  wire [7:0] ADC_INPUT2;///* synthesis altera_chip_pin_lc="@55, @58, @59, @60, @64, @65, @66, @67" */;

output wire       LED/* synthesis altera_chip_pin_lc="@73" */;
input  wire       BUT/* synthesis altera_chip_pin_lc="@98" */;

inout  tri  [7:0] D/* synthesis altera_chip_pin_lc="@144, @143, @142, @141, @138, @137, @136, @135" */;
input  wire       RXF/* synthesis altera_chip_pin_lc="@2" */;
input  wire       TXE/* synthesis altera_chip_pin_lc="@1" */;
output wire       WR/* synthesis altera_chip_pin_lc="@3" */;
output wire       RD/* synthesis altera_chip_pin_lc="@4" */;
output wire       SIWU/* synthesis altera_chip_pin_lc="@106" */;
output wire       OE/* synthesis altera_chip_pin_lc="@105" */;

assign SIWU = 1'b1;

//input  wire       EXT_CLK/* synthesis altera_chip_pin_lc="@91" */;
//output tri        SD_CLK/* synthesis altera_chip_pin_lc="@44" */;
//inout  tri        SD_CMD/* synthesis altera_chip_pin_lc="@42" */;
//inout  tri  [3:0] SD_DAT/* synthesis altera_chip_pin_lc="@39, @38, @50, @49" */;
//
//output wire       ADC_CLK1/* synthesis altera_chip_pin_lc="@87" */;
//input  wire [7:0] ADC_INPUT1/* synthesis altera_chip_pin_lc="@76, @77, @79, @80, @83, @84, @85, @86" */;
//
//output wire       LED/* synthesis altera_chip_pin_lc="@73" */;
//input  wire       BUT/* synthesis altera_chip_pin_lc="@74" */;
//
//inout  tri  [7:0] D;///* synthesis altera_chip_pin_lc="@144, @143, @142, @141, @138, @137, @136, @135" */;
///*input*/inout  wire       RXF;///* synthesis altera_chip_pin_lc="@4" */;
//assign RXF = 1'b1;
//input  wire       TXE;///* synthesis altera_chip_pin_lc="@3" */;
//output wire       WR;///* synthesis altera_chip_pin_lc="@2" */;
//output wire       RD;///* synthesis altera_chip_pin_lc="@1" */;


localparam

initMute                          = 0,
initCard                          = 1,
muteAfterInit                     = 2,
writeMasterBootRecord             = 3,
muteAfterWrittingMasterBootRecord = 4, 
writeVolumeID11                   = 5,
muteAfterWrittingVolumeID11       = 6,
writeVolumeID12                   = 7,
muteAfterWrittingVolumeID12       = 8,
writeVolumeID13                   = 9,
muteAfterWrittingVolumeID13       = 10,
writeVolumeID21                   = 12,
muteAfterWrittingVolumeID21       = 13,
writeVolumeID22                   = 14,
muteAfterWrittingVolumeID22       = 15,
writeVolumeID23                   = 16,
muteAfterWrittingVolumeID23       = 17,
writeVolumeID31                   = 18,
muteAfterWrittingVolumeID31       = 19,

writeBufStreamFAT1                = 21,
muteAfterWrittingFAT1BufStream    = 22,
writeBufStreamFAT2                = 23,
muteAfterWrittingFAT2BufStream    = 24,

writeBlockFAT1header              = 31,
muteAfterWrittingFAT1header       = 32,
writeBlockFAT2header              = 33,
muteAfterWrittingFAT2header       = 34,
writeBlockFAT1footer              = 35,
muteAfterWrittingFAT1footer       = 36,
writeBlockFAT2footer              = 37,
muteAfterWrittingFAT2footer       = 38,
writeBlockFileHeader              = 39,
muteAfterWrittingBlockFileHeader  = 40,

waitRECbegin                      = 51,
writeBufStream                    = 52,
shutingDownAfterStopRec           = 53,
waitForCalcingCurAddr             = 54,
constructFATend                   = 55,
writeFAT1Tail                     = 56,
muteAfterWriteFAT1Tail            = 57,
writeFAT2Tail                     = 58,
muteAfterWriteFAT2Tail            = 59,
writeFileUpdatedHeader            = 60,
complete                          = 61;

reg [61:0] state/* synthesis syn_encoding = "safe, one-hot" */;
reg [61:0] nextState/* synthesis syn_encoding = "safe, one-hot" */;

/*reg [31:0] LBABegin;
reg [31:0] numResSectors;
reg [31:0] sectPerFAT;
reg [31:0] rootDir;*/
localparam blocksInClust = 32'd64;

//localparam masterBootRecordAddr = 32'd0;
//localparam volumeID11Addr = 32'd2048;
//localparam volumeID12Addr = volumeID11Addr + 32'd1;
//localparam volumeID13Addr = volumeID11Addr + 32'd2;
//localparam volumeID21Addr = 32'd2054;
//localparam volumeID22Addr = volumeID21Addr + 32'd1;
//localparam volumeID23Addr = volumeID21Addr + 32'd2;
//localparam volumeID31Addr = 32'd2060;
//
//localparam rootDir = 32'd10240;
//localparam FAT1begin = 32'd8332;
//localparam FAT2begin = 32'd9286;
//localparam FAT1end   = FAT2begin - 1;
//localparam FAT2end   = rootDir - 1;

localparam masterBootRecordAddr = 32'd0;
localparam volumeID11Addr = 32'd0;
localparam volumeID12Addr = volumeID11Addr + 32'd1;
localparam volumeID13Addr = volumeID11Addr + 32'd2;
localparam volumeID21Addr = 32'd6;
localparam volumeID22Addr = volumeID21Addr + 32'd1;
localparam volumeID23Addr = volumeID21Addr + 32'd2;
localparam volumeID31Addr = 32'd12;

localparam rootDir = 32'd8192;
localparam FAT1begin = 32'd6284;
localparam FAT2begin = 32'd7238;
localparam FAT1end   = FAT2begin - 1;
localparam FAT2end   = rootDir - 1;

localparam firstFileBegining = rootDir + blocksInClust;

`ifdef sim
localparam FATsize   = 32'd3;
`else
localparam FATsize   = FAT2begin - FAT1begin;
`endif


`ifdef sim
localparam writeBlockCount = 32'd4;
`else
localparam writeBlockCount = 32'd7866290;
`endif

//=====================================
wire CLK;
wire USB_CLK;
wire SLOW_CLK;
wire FAST_CLK;
wire ADC_CLK;
//-----------
pllSdClocking SDTiming(
RST,
EXT_CLK,

SLOW_CLK,
FAST_CLK,
CLK);

pllADC pllADCUnit(
RST,
EXT_USB_CLK,
ADC_CLK,
USB_CLK);

//=====================================

//init
reg           INIT_ENA;
wire          INIT_COMPLT;
wire          INIT_ERROR_NO_RESP;
wire          INIT_ERROR_UNAVALIABLEVV;
//readBlock
reg           RB_ENA;
wire          RB_COMPLT;
wire          RB_CMDERROR;
wire          RB_CRCERROR;
wire          RB_NORESPERROR;
wire          WENA_SR;
wire [9:0]    WADDR_SR;
wire [3:0]    INPUT_SR;      
//writeBlock
wire          W_READY;
wire          W_ERROR;
reg  [1:0]    WRITE_TYPE;

reg           WB_ENA;
wire          WB_COMPLT;
wire          RENA_SW;
wire          RCLK_SW;
wire [10:0]   RADDR_SW;
wire [3:0]    OUTPUT_SW;
//readMultBlock
reg           RMB_ENA;
wire          RMB_READY;
reg  [31:0]   RMB_COUNT;
wire          RMB_COMPLT;
//writeMultBlock
reg           WMB_ENA;
wire          WMB_READY;
reg  [31:0]   WMB_COUNT;
wire [31:0]   WMB_NUM;

wire          WMB_COMPLT;
reg           WMB_STOP_TRSFR;
wire [1:0]    BUFREADY;// 01 - firstBufReady, 10 - secondBufReady
wire [1:0]    BUFWAITING;
//
reg  [31:0]   ADDR;
reg  [4095:0] DATA;


//-----------

commandManager commandManagerUnit( 
RST,
SD_CLK,
//init
INIT_ENA,
INIT_COMPLT,
INIT_ERROR_NO_RESP,
INIT_ERROR_UNAVALIABLEVV,
//readBlock
RB_ENA,
RB_COMPLT,
RB_CMDERROR,
RB_CRCERROR,
RB_NORESPERROR,
WENA_SR,
WADDR_SR,
INPUT_SR,
//writeBlock
W_READY,
W_ERROR,
WRITE_TYPE,

WB_ENA,
WB_COMPLT,
RENA_SW,
RCLK_SW,
RADDR_SW,
OUTPUT_SW,
//readMultBlock
RMB_ENA,
RMB_READY,
RMB_COUNT,
RMB_COMPLT,
//writeMultBlock
WMB_ENA,
WMB_READY,
WMB_COUNT,
WMB_NUM,
WMB_COMPLT,
WMB_STOP_TRSFR,
BUFREADY,
BUFWAITING,
//
ADDR,
DATA,
SD_CMD,
SD_DAT);

//=====================================
localparam off = 2'b11,
on = 2'b00,
f = 2'b10,
write = 2'b01;

//===========================
wire       REC;
reg  [1:0] MODE;
wire       ENA_DATA_OUT;
wire       ENA_PERIPH_WR;
wire       WR_PERIPH;
wire       WR_USBTRANS;
wire [7:0] DATA_OUT;
wire [7:0] D_PERIPH;
wire [7:0] D_USBTRANS;
reg  [7:0] DATA_IN;

wire       ENA_P;
assign ENA_P = ~RST; 

assign D        = OE  ? DATA_OUT    : {8{1'bz}};
assign DATA_OUT = REC ? D_USBTRANS  : D_PERIPH;
assign WR       = REC ? WR_USBTRANS : WR_PERIPH;



//-----------

peripheralController peripheralControllerUnit(
FAST_CLK,
USB_CLK,
ENA_P,
BUT,
REC,
MODE,
LED,

D_PERIPH,
D,
WR_PERIPH,
RXF,
TXE,
RD,
OE);

//=====================================
wire [7:0]  DATA_DBUFF;
wire [14:0] RADDR_DBUFF;
wire	      RCLK_DBUFF;
wire [14:0] WADDR_DBUFF;
wire	      WCLK_DBUFF;
wire	      WREN_DBUFF;
wire [7:0]  Q_DBUFF;
	
digiBuff digiBuffUnit(
DATA_DBUFF,
RST,
RADDR_DBUFF,
RCLK_DBUFF,
WADDR_DBUFF,
WCLK_DBUFF,
WREN_DBUFF,
Q_DBUFF);

//=====================================
wire [7:0]  DATA_IN_USBBUFF;
wire [7:0]  RADDR_USBBUFF;
wire        RCLK_USBBUFF;
wire [7:0]  WADDR_USBBUFF;
wire        WCLK_USBBUFF;
wire        WENA_USBBUFF;
wire [7:0]  Q_USBBUFF;

//-----------	
USBBuff USBBuffUnit(
DATA_IN_USBBUFF,
RST,
RADDR_USBBUFF,
RCLK_USBBUFF,
WADDR_USBBUFF,
WCLK_USBBUFF,
WENA_USBBUFF,
Q_USBBUFF);

//=====================================
reg         ENA_AVG;
wire [31:0] BLOCKS_DIGITIZED; 
wire        BUFFREADY_USBTRANS;
//-----------	
movingAverage movingAverageUnit(
ADC_CLK,
RST,
ENA_AVG,

ADC_INPUT1,
ADC_INPUT2,

ADC_CLK1,
ADC_CLK2,

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

//=====================================
wire   ENA_USBTRANS;
assign ENA_USBTRANS = ENA_AVG;

USBTransceiver USBTransceiverUnit(
USB_CLK, 
RST,
ENA_USBTRANS,
RCLK_USBBUFF,
RADDR_USBBUFF,
Q_USBBUFF,
BUFFREADY_USBTRANS,
TXE,
WR_USBTRANS,
D_USBTRANS);

//=====================================
wire       WCLK_SW_PUMP;
wire       WENA_SW_PUMP;
wire [9:0] WADDR_SW_PUMP;
wire [7:0] INPUT_SW_PUMP;

wire [1:0] BUFREADY_PUMP;
//-----------	
digiBuffToSTWPump digiBuffToSTWPumpUnit(
SD_CLK,
ENA_AVG,
RST,

BLOCKS_DIGITIZED,
RADDR_DBUFF,
RCLK_DBUFF,
Q_DBUFF,

INPUT_SW_PUMP,
WADDR_SW_PUMP,
WCLK_SW_PUMP,
WENA_SW_PUMP,

BUFREADY_PUMP,
BUFWAITING);

//=====================================
reg         ENA_FAT;
wire [1:0]  BUFREADY_FAT;
wire        WCLK_SW_FAT;
wire        WENA_SW_FAT;
wire [7:0]  WADDR_SW_FAT;
wire [31:0] INPUT_SW_FAT;

assign     BUFREADY = ENA_FAT ? BUFREADY_FAT : (ENA_AVG ? BUFREADY_PUMP : 2'bzz);
//-----------	

sectorToWriteFATconstructor sectorToWriteFATconstructorUnit(
SD_CLK,
ENA_FAT,

WCLK_SW_FAT,
WENA_SW_FAT,
WADDR_SW_FAT,
INPUT_SW_FAT,

BUFREADY_FAT,
BUFWAITING);

//=====================================
reg ENA_FILE_SERVER, RST_FILE_SERVER;
wire COMPLT_FILE_SERVER;
reg  [31:0] CUR_NUM_BLOCK_WRITTEN_COUNT;
wire [31:0] CUR_ADDR;
wire [31:0] FILE_SIZE_BYTES;
wire [31:0] FIRST_CLUST_TO_UPDATE_FAT;
wire [31:0] CLUST_NUM_EOF;
wire [31:0] ADDR_TO_UPDATE_FAT1;
wire [31:0] ADDR_TO_UPDATE_FAT2;
//-------
fileSystemServer fileSystemServerUnit(
SD_CLK,
ENA_FILE_SERVER,
RST_FILE_SERVER,
COMPLT_FILE_SERVER,
firstFileBegining,
FAT1begin,
FAT2begin,
blocksInClust,
CUR_NUM_BLOCK_WRITTEN_COUNT,
FILE_SIZE_BYTES,
FIRST_CLUST_TO_UPDATE_FAT,
CLUST_NUM_EOF,
ADDR_TO_UPDATE_FAT1,
ADDR_TO_UPDATE_FAT2,
CUR_ADDR);

//=====================================
reg         ENA_FAT_UPDATER;
wire        WCLK_SW_FAT_UPDATER;
wire        WENA_SW_FAT_UPDATER;
wire [7:0]  WADDR_SW_FAT_UPDATER;
wire [31:0] INPUT_SW_FAT_UPDATER;
//-------
sectorToWriteFATupdater sectorToWriteFATupdaterUnit(
SD_CLK,
ENA_FAT_UPDATER,

WCLK_SW_FAT_UPDATER,
WENA_SW_FAT_UPDATER,
WADDR_SW_FAT_UPDATER,
INPUT_SW_FAT_UPDATER,

FIRST_CLUST_TO_UPDATE_FAT,
CLUST_NUM_EOF,

COMPLT_FAT_UPDATER);

//=====================================
wire	      RENA_SR;
wire [8:0]  RADDR_SR;
wire [7:0]  OUTPUT_SR;
//-----------	
//saving data read from SD, to find FAT, LBA and another
sectorStoreReading sectorStoreReadingUnit(
RST,
SD_CLK,
INPUT_SR,
RADDR_SR,
RENA_SR,
WADDR_SR,
WENA_SR,
OUTPUT_SR);

//=====================================
wire [7:0]  INPUT_SW_SINGLE_BYTE;
wire [10:0] RADDR_SW_SINGLE_BYTE;
wire        RCLK_SW_SINGLE_BYTE;
wire        RENA_SW_SINGLE_BYTE;
wire [9:0]  WADDR_SW_SINGLE_BYTE;
wire        WCLK_SW_SINGLE_BYTE;
wire        WENA_SW_SINGLE_BYTE;
wire [3:0]  OUTPUT_SW_SINGLE_BYTE;
//-----------	
//saving data to write it on SD
sectorToWrite sectorToWriteUnit(
INPUT_SW_SINGLE_BYTE,
RST,
RADDR_SW_SINGLE_BYTE,
RCLK_SW_SINGLE_BYTE,
RENA_SW_SINGLE_BYTE,
WADDR_SW_SINGLE_BYTE,
WCLK_SW_SINGLE_BYTE,
WENA_SW_SINGLE_BYTE,
OUTPUT_SW_SINGLE_BYTE);

//=====================================
wire [31:0] INPUT_SW_QUAD_BYTE;
wire [10:0] RADDR_SW_QUAD_BYTE;
wire        RCLK_SW_QUAD_BYTE;
wire        RENA_SW_QUAD_BYTE;
wire [7:0]  WADDR_SW_QUAD_BYTE;
wire        WCLK_SW_QUAD_BYTE;
wire        WENA_SW_QUAD_BYTE;
wire [3:0]  OUTPUT_SW_QUAD_BYTE;
//-----------	
//saving data to write it on SD
sectorToWriteFATpage sectorToWriteFATpageUnit(
INPUT_SW_QUAD_BYTE,
RST,
RADDR_SW_QUAD_BYTE,
RCLK_SW_QUAD_BYTE,
RENA_SW_QUAD_BYTE,
WADDR_SW_QUAD_BYTE,
WCLK_SW_QUAD_BYTE,
WENA_SW_QUAD_BYTE,
OUTPUT_SW_QUAD_BYTE);

reg useQuadroBuf;

assign WCLK_SW_SINGLE_BYTE    = useQuadroBuf ? 1'd0  : WCLK_SW_PUMP;
assign WENA_SW_SINGLE_BYTE    = useQuadroBuf ? 1'd0  : WENA_SW_PUMP;
assign WADDR_SW_SINGLE_BYTE   = useQuadroBuf ? 10'd0 : WADDR_SW_PUMP;
assign INPUT_SW_SINGLE_BYTE   = useQuadroBuf ? 8'd0  : INPUT_SW_PUMP;
assign RENA_SW_SINGLE_BYTE    = useQuadroBuf ? 1'd0  : RENA_SW;
assign RCLK_SW_SINGLE_BYTE    = useQuadroBuf ? 1'd0  : RCLK_SW;
assign RADDR_SW_SINGLE_BYTE   = useQuadroBuf ? 11'd0 : RADDR_SW;

assign WCLK_SW_QUAD_BYTE      = useQuadroBuf ? (ENA_FAT ? WCLK_SW_FAT : (ENA_FAT_UPDATER ? WCLK_SW_FAT_UPDATER : 1'd0)) : 1'd0;
assign WENA_SW_QUAD_BYTE      = useQuadroBuf ? (ENA_FAT ? WENA_SW_FAT : (ENA_FAT_UPDATER ? WENA_SW_FAT_UPDATER : 1'd0)) : 1'd0;
assign WADDR_SW_QUAD_BYTE     = useQuadroBuf ? (ENA_FAT ? WADDR_SW_FAT : (ENA_FAT_UPDATER ? WADDR_SW_FAT_UPDATER : 8'd0)) : 8'd0;
assign INPUT_SW_QUAD_BYTE     = useQuadroBuf ? (ENA_FAT ? INPUT_SW_FAT : (ENA_FAT_UPDATER ? INPUT_SW_FAT_UPDATER : 32'd0)) : 32'd0;
assign RENA_SW_QUAD_BYTE      = useQuadroBuf ? RENA_SW : 1'd0;
assign RCLK_SW_QUAD_BYTE      = useQuadroBuf ? RCLK_SW : 1'd0;
assign RADDR_SW_QUAD_BYTE     = useQuadroBuf ? RADDR_SW : 11'd0;

assign OUTPUT_SW              = useQuadroBuf ? OUTPUT_SW_QUAD_BYTE : OUTPUT_SW_SINGLE_BYTE;

//=====================================
reg         ENA_BP;
reg  [8:0]  ADDRBEG_BP;
reg  [1:0]  NUM_BP;
wire        COMPLT_BP;
wire [31:0] OUTPUT_BP;
//-----------	
//Getting bytes from sectorStoreReadingUnit
sectorBytePicker sectorBytePickerUnit(
RST,
SD_CLK,
ENA_BP,
ADDRBEG_BP,
NUM_BP,
OUTPUT_SR,
RADDR_SR,
RENA_SR,
COMPLT_BP,
OUTPUT_BP);

//=====================================
reg  ENA_M;
wire COMPLT_M;
//-------
`ifdef sim
defparam muteBetweenAllocationStatesUnit.Tm = 32'd2;
`else
defparam muteBetweenAllocationStatesUnit.Tm = 32'd1010;
`endif
muteCounter muteBetweenAllocationStatesUnit(
SD_CLK,
RST,
ENA_M,
COMPLT_M);

//=====================================
`ifdef sim
localparam bounceTime = 2;
`else
//localparam bounceTime = 1000000;
localparam bounceTime = 100;
`endif

reg  ENA_M_RST;
reg [31:0] RSTcounter;

`ifdef sim
initial
begin
  RST <= 1'b1;
end
`endif

always @(posedge EXT_CLK)
begin
	ENA_M_RST <= 1'b1;
end

always @(posedge EXT_CLK)
begin
	if(ENA_M_RST)
	begin
		if(RSTcounter < bounceTime)
		begin
			if(RSTcounter < 2)
			begin
				RST <= 1'b0;
				RSTcounter <= RSTcounter + 1;
			end
			else
			begin
				RST <= 1'b1;
				RSTcounter <= RSTcounter + 1;
			end
		end
		else
		begin
			RSTcounter <= RSTcounter;
			RST <= 1'b0;
		end
	end
	else
	begin
		RSTcounter <= 0;
		RST <= 1'b1;
	end
end

//=====================================

//in idle state we need to send slow clock to sd 
//after idle complete we can use full speed clock

reg interimSD_CLK;
reg ENA_SD_CLK;

always @(RST or CLK or FAST_CLK or SLOW_CLK)
begin
if(RST)
begin
  ENA_SD_CLK <= 1'b0;
  interimSD_CLK <= 1'bz;
end
else
begin
  
ENA_SD_CLK <= 1'b1;

if((state == initCard) || (state == initMute))  
begin
	interimSD_CLK <= SLOW_CLK;
end  
else
begin
	interimSD_CLK <= FAST_CLK;
end

end
end

assign SD_CLK = ENA_SD_CLK ? interimSD_CLK : 1'bz;

//------------------------------------
 
//FSM

always @(posedge SD_CLK or posedge RST)
begin

if(RST) 
begin
  state <= initMute;
end
else
begin
	state <= nextState;
end

end



always @(RST or state or 
			INIT_COMPLT or WB_COMPLT or RB_COMPLT or WMB_COMPLT or RMB_COMPLT or
			COMPLT_BP or COMPLT_M or COMPLT_FAT_UPDATER or REC or COMPLT_FILE_SERVER)
begin

if (RST) 
begin
	INIT_ENA <= 1'b0;
	RB_ENA   <= 1'b0;
	WB_ENA   <= 1'b0;
	RMB_ENA  <= 1'b0;
	WMB_ENA  <= 1'b0;
	WMB_STOP_TRSFR <= 1'b0;
	
	ENA_M    <= 1'b0;
	
	ENA_BP   <= 1'b0;
	ENA_AVG <= 1'b0;
	ENA_FAT  <= 1'b0;
	
	ENA_FILE_SERVER <= 1'b0;
	RST_FILE_SERVER <= 1'b1;
	ENA_FAT_UPDATER <= 1'b0;

	MODE <= off;
	
	useQuadroBuf <= 1'b1;

	nextState <= initMute;
end
else 
begin

case (state)

//=====================================
initMute:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= initMute;
  end
  else if(COMPLT_M)
  begin    
    nextState <= initCard;
  end
  else
  begin
    nextState <= initMute;
  end
end
//=====================================
initCard:
begin
	if(INIT_COMPLT == 1'b0)
	begin
		INIT_ENA <= 1'b1;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= initCard;
	end
	else if(INIT_COMPLT == 1'b1)
	begin
	  `ifdef doNotSimFAT
    nextState <= waitRECbegin;
    `else
    nextState <= muteAfterInit;
    `endif
	end
	else
	begin
		nextState <= initCard;
	end
end
//=====================================	
muteAfterInit:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterInit;
  end
  else if(COMPLT_M)
  begin
//    `ifdef doNotSimMBR
//    nextState <= writeBufStreamFAT1;
//    `else
//    nextState <= writeMasterBootRecord;
//    `endif
	 //nextState <= writeBufStreamFAT1;
	 nextState <= writeVolumeID11;
  end
  else
  begin
    nextState <= muteAfterInit;
  end
end
//=====================================	
writeMasterBootRecord:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= masterBootRecordAddr;
		
		//FAT header
		DATA <= 4096'hFA33C08ED0BC007C8BF45007501FFBFCBF0006B90001F2A5EA1D060000BEBE07B304803C80740E803C00751C83C610FECB75EFCD188B148B4C028BEE83C610FECB741A803C0074F4BEF806AC3C00740B56BB0700B40ECD105EEBF0EBFEBF0500606A006A00FF760AFF76086A0068007C6A016A10B442B2808BF4CD136161730C33C0CD134F75D9BEF806EBBFBEF806BFFE7D813D55AA75B3BF527C813D464175074747803D547411BF037C813D4E5475404747813D4653753860B408B280CD13BF1A7CFEC68AD632F689154F4F83E13F890D61606A006A00FF760AFF76086A0068007C6A016A10B443B2808BF4CD1361618BF5EA007C00004572726F72210044323130413631352D414346442D343134612D424446312D4643394632413835463037360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000001F21000FFA54E6C10700003F58770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055AA;
		nextState <= writeMasterBootRecord;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingMasterBootRecord;
	end
	else
	begin
		nextState <= writeMasterBootRecord;
	end
end
//=====================================	
muteAfterWrittingMasterBootRecord:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingMasterBootRecord;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeVolumeID11;
  end
  else
  begin
    nextState <= muteAfterWrittingMasterBootRecord;
  end
end
//------------------------------------------------
//=====================================	
writeVolumeID11:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= volumeID11Addr;
		
		//FAT header
		DATA <= 4096'hEB58904D53444F53352E300002408C180200000000F800003F00FF003F00000000587700BA030000000000000200000001000600000000000000000000000000800029C41AAF144E4F204E414D4520202020464154333220202033C98ED1BCF47B8EC18ED9BD007C884E028A5640B441BBAA55CD13721081FB55AA750AF6C1017405FE4602EB2D8A5640B408CD137305B9FFFF8AF1660FB6C640660FB6D180E23FF7E286CDC0ED0641660FB7C966F7E1668946F8837E16007538837E2A007732668B461C6683C00CBB0080B90100E82B00E92C03A0FA7DB47D8BF0AC84C074173CFF7409B40EBB0700CD10EBEEA0FB7DEBE5A0F97DEBE098CD16CD196660807E02000F842000666A0066500653666810000100B4428A56408BF4CD136658665866586658EB33663B46F87203F9EB2A6633D2660FB74E1866F7F1FEC28ACA668BD066C1EA10F7761A86D68A56408AE8C0E4060ACCB80102CD1366610F8275FF81C300026640497594C3424F4F544D47522020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000D0A52656D6F7665206469736B73206F72206F74686572206D656469612EFF0D0A4469736B206572726F72FF0D0A507265737320616E79206B657920746F20726573746172740D0A0000000000ACCBD8000055AA;
		nextState <= writeVolumeID11;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingVolumeID11;
	end
	else
	begin
		nextState <= writeVolumeID11;
	end
end
//=====================================	
muteAfterWrittingVolumeID11:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingVolumeID11;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeVolumeID12;
  end
  else
  begin
    nextState <= muteAfterWrittingVolumeID11;
  end
end
//=====================================
writeVolumeID12:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= volumeID12Addr;
		
		//FAT header
		DATA <= 4096'h525261410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007272416108000000DADC0000000000000000000000000000000055AA;
		nextState <= writeVolumeID12;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingVolumeID12;
	end
	else
	begin
		nextState <= writeVolumeID12;
	end
end
//=====================================	
muteAfterWrittingVolumeID12:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingVolumeID12;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeVolumeID13;
  end
  else
  begin
    nextState <= muteAfterWrittingVolumeID12;
  end
end
//=====================================
writeVolumeID13:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= volumeID13Addr;
		
		//FAT header
		DATA <= 4096'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055AA;
		nextState <= writeVolumeID13;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingVolumeID13;
	end
	else
	begin
		nextState <= writeVolumeID13;
	end
end
//=====================================	
muteAfterWrittingVolumeID13:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingVolumeID13;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeVolumeID21;
  end
  else
  begin
    nextState <= muteAfterWrittingVolumeID13;
  end
end
//------------------------------------------------
//=====================================	
writeVolumeID21:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= volumeID21Addr;
		
		//FAT header
		DATA <= 4096'hEB58904D53444F53352E300002408C180200000000F800003F00FF003F00000000587700BA030000000000000200000001000600000000000000000000000000800029C41AAF144E4F204E414D4520202020464154333220202033C98ED1BCF47B8EC18ED9BD007C884E028A5640B441BBAA55CD13721081FB55AA750AF6C1017405FE4602EB2D8A5640B408CD137305B9FFFF8AF1660FB6C640660FB6D180E23FF7E286CDC0ED0641660FB7C966F7E1668946F8837E16007538837E2A007732668B461C6683C00CBB0080B90100E82B00E92C03A0FA7DB47D8BF0AC84C074173CFF7409B40EBB0700CD10EBEEA0FB7DEBE5A0F97DEBE098CD16CD196660807E02000F842000666A0066500653666810000100B4428A56408BF4CD136658665866586658EB33663B46F87203F9EB2A6633D2660FB74E1866F7F1FEC28ACA668BD066C1EA10F7761A86D68A56408AE8C0E4060ACCB80102CD1366610F8275FF81C300026640497594C3424F4F544D47522020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000D0A52656D6F7665206469736B73206F72206F74686572206D656469612EFF0D0A4469736B206572726F72FF0D0A507265737320616E79206B657920746F20726573746172740D0A0000000000ACCBD8000055AA;
		nextState <= writeVolumeID21;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingVolumeID21;
	end
	else
	begin
		nextState <= writeVolumeID21;
	end
end
//=====================================	
muteAfterWrittingVolumeID21:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingVolumeID21;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeVolumeID22;
  end
  else
  begin
    nextState <= muteAfterWrittingVolumeID21;
  end
end
//=====================================
writeVolumeID22:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= volumeID22Addr;
		
		//FAT header
		DATA <= 4096'h5252614100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000072724161FFFFFFFF02000000000000000000000000000000000055AA;
		nextState <= writeVolumeID22;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingVolumeID22;
	end
	else
	begin
		nextState <= writeVolumeID22;
	end
end
//=====================================	
muteAfterWrittingVolumeID22:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingVolumeID22;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeVolumeID23;
  end
  else
  begin
    nextState <= muteAfterWrittingVolumeID22;
  end
end
//=====================================
writeVolumeID23:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= volumeID23Addr;
		
		//FAT header
		DATA <= 4096'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055AA;
		nextState <= writeVolumeID23;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingVolumeID23;
	end
	else
	begin
		nextState <= writeVolumeID23;
	end
end
//=====================================	
muteAfterWrittingVolumeID23:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingVolumeID23;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeVolumeID31;
  end
  else
  begin
    nextState <= muteAfterWrittingVolumeID23;
  end
end
//=====================================
writeVolumeID31:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= volumeID31Addr;
		
		//FAT header
		DATA <= 4096'h660FB64610668B4E2466F7E16603461C660FB7560E6603C2668946FC66C746F4FFFFFFFF668B462C6683F8020F82C2FC663DF8FFFF0F0F83B8FC66506683E802660FB65E0D8BF366F7E3660346FCBB00828BFBB90100E8A3FC382D741EB10B56BE697DF3A65E741B03F983C7153BFB72E84E75DA6658E8650072BF83C404E971FC002083C4048B75098B7D0F8BC666C1E0108BC76683F8020F8256FC663DF8FFFF0F0F834CFC66506683E802660FB64E0D66F7E1660346FCBB0000068E068180E839FC076658C1EB04011E8180E80E000F83020072D08A5640EA0000002066C1E002E8110026668B016625FFFFFF0F663DF8FFFF0FC3BF007E660FB74E0B6633D266F7F1663B46F4743A668946F46603461C660FB74E0E6603C1660FB75E2883E30F74163A5E100F83C7FB52668BC8668B462466F7E36603C15A528BDFB90100E8B9FB5A8BDAC300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055AA;
		nextState <= writeVolumeID31;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingVolumeID31;
	end
	else
	begin
		nextState <= writeVolumeID31;
	end
end
//=====================================	
muteAfterWrittingVolumeID31:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingVolumeID31;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeBufStreamFAT1;
  end
  else
  begin
    nextState <= muteAfterWrittingVolumeID31;
  end
end
//=====================================	
writeBufStreamFAT1:
begin
	if(WMB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b1;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b1;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
  
		WRITE_TYPE <= 2'b10;
		ADDR <= FAT1begin;
		WMB_COUNT <= FATsize;
	
		nextState <= writeBufStreamFAT1;
	end
	else if(WMB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingFAT1BufStream;
	end
	else
	begin
		nextState <= writeBufStreamFAT1;
	end
end
//=====================================	
muteAfterWrittingFAT1BufStream:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingFAT1BufStream;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeBufStreamFAT2;
  end
  else
  begin
    nextState <= muteAfterWrittingFAT1BufStream;
  end
end
//=====================================	
writeBufStreamFAT2:
begin
	if(WMB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b1;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b1;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
  
		WRITE_TYPE <= 2'b10;
		ADDR <= FAT2begin;
		WMB_COUNT <= FATsize;
	
		nextState <= writeBufStreamFAT2;
	end
	else if(WMB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingFAT2BufStream;
	end
	else
	begin
		nextState <= writeBufStreamFAT2;
	end
end
//=====================================	
muteAfterWrittingFAT2BufStream:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingFAT2BufStream;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeBlockFAT1header;
  end
  else
  begin
    nextState <= muteAfterWrittingFAT2BufStream;
  end
end
//=====================================	
writeBlockFAT1header:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= FAT1begin;
		
		//FAT header
		DATA <= 4096'hF8FFFF0FFFFFFF0FFFFFFF0F0400000005000000060000000700000008000000090000000A0000000B0000000C0000000D0000000E0000000F000000100000001100000012000000130000001400000015000000160000001700000018000000190000001A0000001B0000001C0000001D0000001E0000001F000000200000002100000022000000230000002400000025000000260000002700000028000000290000002A0000002B0000002C0000002D0000002E0000002F000000300000003100000032000000330000003400000035000000360000003700000038000000390000003A0000003B0000003C0000003D0000003E0000003F000000400000004100000042000000430000004400000045000000460000004700000048000000490000004A0000004B0000004C0000004D0000004E0000004F000000500000005100000052000000530000005400000055000000560000005700000058000000590000005A0000005B0000005C0000005D0000005E0000005F000000600000006100000062000000630000006400000065000000660000006700000068000000690000006A0000006B0000006C0000006D0000006E0000006F000000700000007100000072000000730000007400000075000000760000007700000078000000790000007A0000007B0000007C0000007D0000007E0000007F00000080000000;
	
		nextState <= writeBlockFAT1header;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingFAT1header;
	end
	else
	begin
		nextState <= writeBlockFAT1header;
	end
end
//=====================================	
muteAfterWrittingFAT1header:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;

		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingFAT1header;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeBlockFAT2header;
  end
  else
  begin
    nextState <= muteAfterWrittingFAT1header;
  end
end
//=====================================	
writeBlockFAT2header:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
	
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= FAT2begin;
		//FAT header
		DATA <= 4096'hF8FFFF0FFFFFFF0FFFFFFF0F0400000005000000060000000700000008000000090000000A0000000B0000000C0000000D0000000E0000000F000000100000001100000012000000130000001400000015000000160000001700000018000000190000001A0000001B0000001C0000001D0000001E0000001F000000200000002100000022000000230000002400000025000000260000002700000028000000290000002A0000002B0000002C0000002D0000002E0000002F000000300000003100000032000000330000003400000035000000360000003700000038000000390000003A0000003B0000003C0000003D0000003E0000003F000000400000004100000042000000430000004400000045000000460000004700000048000000490000004A0000004B0000004C0000004D0000004E0000004F000000500000005100000052000000530000005400000055000000560000005700000058000000590000005A0000005B0000005C0000005D0000005E0000005F000000600000006100000062000000630000006400000065000000660000006700000068000000690000006A0000006B0000006C0000006D0000006E0000006F000000700000007100000072000000730000007400000075000000760000007700000078000000790000007A0000007B0000007C0000007D0000007E0000007F00000080000000;
	
		nextState <= writeBlockFAT2header;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingFAT2header;
	end
	else
	begin
		nextState <= writeBlockFAT2header;
	end
end
//=====================================	
muteAfterWrittingFAT2header:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingFAT2header;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeBlockFAT1footer;
  end
  else
  begin
    nextState <= muteAfterWrittingFAT2header;
  end
end
//=====================================	
writeBlockFAT1footer:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;					
		ADDR <= FAT1end;
		//FAT footer
		//DATA <=4096'h01E0010002E0010003E0010004E0010005E0010006E0010007E0010008E0010009E001000AE001000BE001000CE001000DE001000EE001000FE0010010E0010011E0010012E0010013E0010014E0010015E0010016E0010017E0010018E0010019E001001AE001001BE001001CE001001DE001001EE001001FE0010020E0010021E00100FFFFFF0F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
		DATA <=4096'h81DC010082DC010083DC010084DC010085DC010086DC010087DC010088DC010089DC01008ADC01008BDC01008CDC01008DDC01008EDC01008FDC010090DC010091DC010092DC010093DC010094DC010095DC010096DC010097DC010098DC010099DC01009ADC01009BDC01009CDC01009DDC01009EDC01009FDC0100A0DC0100A1DC0100A2DC0100A3DC0100A4DC0100A5DC0100A6DC0100A7DC0100A8DC0100A9DC0100AADC0100ABDC0100ACDC0100ADDC0100AEDC0100AFDC0100B0DC0100B1DC0100B2DC0100B3DC0100B4DC0100B5DC0100B6DC0100B7DC0100B8DC0100B9DC0100BADC0100BBDC0100BCDC0100BDDC0100BEDC0100BFDC0100C0DC0100C1DC0100C2DC0100C3DC0100C4DC0100C5DC0100C6DC0100C7DC0100C8DC0100C9DC0100CADC0100CBDC0100CCDC0100CDDC0100CEDC0100CFDC0100D0DC0100D1DC0100D2DC0100D3DC0100D4DC0100D5DC0100D6DC0100D7DC0100D8DC0100D9DC0100DADC0100DBDC0100DCDC0100DDDC0100DEDC0100DFDC0100E0DC0100E1DC0100FFFFFF0F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
		
		nextState <= writeBlockFAT1footer;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingFAT1footer;
	end
	else
	begin
		nextState <= writeBlockFAT1footer;
	end
end
//=====================================	
muteAfterWrittingFAT1footer:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingFAT1footer;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeBlockFAT2footer;
  end
  else
  begin
    nextState <= muteAfterWrittingFAT1footer;
  end
end
//=====================================	
writeBlockFAT2footer:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
						
		WRITE_TYPE <= 2'b00;									
		ADDR <= FAT2end;
		//FAT footer
		DATA <=4096'h81DC010082DC010083DC010084DC010085DC010086DC010087DC010088DC010089DC01008ADC01008BDC01008CDC01008DDC01008EDC01008FDC010090DC010091DC010092DC010093DC010094DC010095DC010096DC010097DC010098DC010099DC01009ADC01009BDC01009CDC01009DDC01009EDC01009FDC0100A0DC0100A1DC0100A2DC0100A3DC0100A4DC0100A5DC0100A6DC0100A7DC0100A8DC0100A9DC0100AADC0100ABDC0100ACDC0100ADDC0100AEDC0100AFDC0100B0DC0100B1DC0100B2DC0100B3DC0100B4DC0100B5DC0100B6DC0100B7DC0100B8DC0100B9DC0100BADC0100BBDC0100BCDC0100BDDC0100BEDC0100BFDC0100C0DC0100C1DC0100C2DC0100C3DC0100C4DC0100C5DC0100C6DC0100C7DC0100C8DC0100C9DC0100CADC0100CBDC0100CCDC0100CDDC0100CEDC0100CFDC0100D0DC0100D1DC0100D2DC0100D3DC0100D4DC0100D5DC0100D6DC0100D7DC0100D8DC0100D9DC0100DADC0100DBDC0100DCDC0100DDDC0100DEDC0100DFDC0100E0DC0100E1DC0100FFFFFF0F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
		
		nextState <= writeBlockFAT2footer;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingFAT2footer;
	end
	else
	begin
		nextState <= writeBlockFAT2footer;
	end
end
//=====================================	
muteAfterWrittingFAT2footer:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWrittingFAT2footer;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeBlockFileHeader;
  end
  else
  begin
    nextState <= muteAfterWrittingFAT2footer;
  end
end
//=====================================	
writeBlockFileHeader:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;

		WRITE_TYPE <= 2'b00;					
		ADDR <= rootDir;
		DATA <= 
		{
		{{{128'hE5_49_4C_45_30_30_30_30__50_43_4D_20_18_68_2E_68,
		128'h53_41_53_41_00_00_00_00__00_00_00_00_00_00_00_00},
		128'h46_49_4C_45_30_30_30_30__50_43_4D_20_18_68_2E_68},
		128'h53_41_53_41_00_00_00_00__00_00_03_00_00_20_6F_EE},
		{3584{1'b0}}};
		
		nextState <= writeBlockFileHeader;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= muteAfterWrittingBlockFileHeader;
	end
	else
	begin
		nextState <= writeBlockFileHeader;
	end
end
//=====================================	
muteAfterWrittingBlockFileHeader:
begin
  if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b0;
		
		nextState <= muteAfterWrittingBlockFileHeader;
  end
  else if(COMPLT_M)
  begin
	 nextState <= waitRECbegin;
  end
  else
  begin
    nextState <= muteAfterWrittingBlockFileHeader;
  end
end
//=====================================
waitRECbegin:
begin
	if(!REC)
	begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= off;
		
		useQuadroBuf <= 1'b0;
		
		nextState <= waitRECbegin;
	end
	else if(REC)
	begin
		nextState <= writeBufStream;
	end
	else
	begin
		nextState <= waitRECbegin;
	end
end
//=====================================	
writeBufStream:
begin
	if(WMB_COMPLT == 1'b0)
	begin	
		if(REC)
		begin
			INIT_ENA <= 1'b0;
			RB_ENA   <= 1'b0;
			WB_ENA   <= 1'b0;
			RMB_ENA  <= 1'b0;
			WMB_ENA  <= 1'b1;
			WMB_STOP_TRSFR <= 1'b0;
			
			ENA_M    <= 1'b0;
			
			ENA_BP   <= 1'b0;
			ENA_AVG <= 1'b1;
			ENA_FAT  <= 1'b0;
			
			ENA_FILE_SERVER <= 1'b0;
			RST_FILE_SERVER <= 1'b0;
			ENA_FAT_UPDATER <= 1'b0;
			
			MODE <= write;
			
			useQuadroBuf <= 1'b0;
	  
			WRITE_TYPE <= 2'b10;
			ADDR <= CUR_ADDR;
			WMB_COUNT <= writeBlockCount;
			
			CUR_NUM_BLOCK_WRITTEN_COUNT <= WMB_NUM;

			nextState <= writeBufStream;
		end
		else if(!REC)
		begin
			nextState <= shutingDownAfterStopRec;
		end
		else
		begin
			nextState <= writeBufStream;
		end
	end
	else if(WMB_COMPLT == 1'b1)
	begin
		nextState <= complete;
	end
	else
	begin
		nextState <= writeBufStream;
	end
end
//=====================================
shutingDownAfterStopRec:
begin
	if(WMB_COMPLT == 1'b0)
	  begin
			INIT_ENA <= 1'b0;
			RB_ENA   <= 1'b0;
			WB_ENA   <= 1'b0;
			RMB_ENA  <= 1'b0;
			WMB_ENA  <= 1'b1;
			WMB_STOP_TRSFR <= 1'b1;
			
			ENA_M    <= 1'b0;
			
			ENA_BP   <= 1'b0;
			ENA_AVG <= 1'b1;
			ENA_FAT  <= 1'b0;
			
			ENA_FILE_SERVER <= 1'b0;
			RST_FILE_SERVER <= 1'b0;	
			ENA_FAT_UPDATER <= 1'b0;		
			
			MODE <= f;
			
			useQuadroBuf <= 1'b0;
	  
			WRITE_TYPE <= 2'b10;
			ADDR <= CUR_ADDR;
			WMB_COUNT <= writeBlockCount;
			
			nextState <= shutingDownAfterStopRec;
	  end
	  else if(WMB_COMPLT == 1'b1)
	  begin
		nextState <= waitForCalcingCurAddr;
	  end
	  else
	  begin
		nextState <= shutingDownAfterStopRec;
	  end
end
//=====================================
waitForCalcingCurAddr:
begin
	if(!COMPLT_FILE_SERVER)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		WMB_STOP_TRSFR <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b1;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= waitForCalcingCurAddr;
  end
  else if(COMPLT_FILE_SERVER)
  begin
	 nextState <= constructFATend;
  end
  else
  begin
    nextState <= waitForCalcingCurAddr;
  end
end
//=====================================
constructFATend:
begin
	if(!COMPLT_FAT_UPDATER)
	begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b1;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		//FIRST_CLUST_TO_UPDATE_FAT <= FIRST_CLUST_TO_UPDATE_FAT;
		//CLUST_NUM_EOF <= CLUST_NUM_EOF;
				
		nextState <= constructFATend;
	end
	else if(COMPLT_FAT_UPDATER)
	begin
		nextState <= writeFAT1Tail;
	end
	else
	begin
		nextState <= constructFATend;
	end
end
//=====================================
writeFAT1Tail:
begin
	if(!WB_COMPLT)
	begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		WRITE_TYPE <= 2'b01;
		ADDR <= ADDR_TO_UPDATE_FAT1;
		
		nextState <= writeFAT1Tail;
	end
	else if(WB_COMPLT)
	begin
		nextState <= muteAfterWriteFAT1Tail;
	end
	else
	begin
		nextState <= writeFAT1Tail;
	end
end
//=====================================
muteAfterWriteFAT1Tail:
begin
	if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWriteFAT1Tail;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeFAT2Tail;
  end
  else
  begin
    nextState <= muteAfterWriteFAT1Tail;
  end
end
//=====================================
writeFAT2Tail:
begin
	if(!WB_COMPLT)
	begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		WRITE_TYPE <= 2'b01;
		ADDR <= ADDR_TO_UPDATE_FAT2;
		
		nextState <= writeFAT2Tail;
	end
	else if(WB_COMPLT)
	begin
		nextState <= muteAfterWriteFAT2Tail;
	end
	else
	begin
		nextState <= writeFAT2Tail;
	end
end
//=====================================
muteAfterWriteFAT2Tail:
begin
	if(!COMPLT_M)
  begin
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b0;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		
		ENA_M    <= 1'b1;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;
		
		nextState <= muteAfterWriteFAT2Tail;
  end
  else if(COMPLT_M)
  begin
	 nextState <= writeFileUpdatedHeader;
  end
  else
  begin
    nextState <= muteAfterWriteFAT2Tail;
  end
end
//=====================================	
writeFileUpdatedHeader:
begin
	if(WB_COMPLT == 1'b0)
	begin		
		INIT_ENA <= 1'b0;
		RB_ENA   <= 1'b0;
		WB_ENA   <= 1'b1;
		RMB_ENA  <= 1'b0;
		WMB_ENA  <= 1'b0;
		
		ENA_M    <= 1'b0;
		
		ENA_BP   <= 1'b0;
		ENA_AVG <= 1'b0;
		ENA_FAT  <= 1'b0;
		
		ENA_FILE_SERVER <= 1'b0;
		RST_FILE_SERVER <= 1'b0;
		ENA_FAT_UPDATER <= 1'b0;
		
		MODE <= f;
		
		useQuadroBuf <= 1'b1;

		WRITE_TYPE <= 2'b00;					
		ADDR <= rootDir;
		DATA <= 
		{128'hE5_49_4C_45_30_30_30_30__50_43_4D_20_18_68_2E_68,
		128'h53_41_53_41_00_00_00_00__00_00_00_00_00_00_00_00,
		128'h46_49_4C_45_30_30_30_30__50_43_4D_20_18_68_2E_68,
		96'h53_41_53_41_00_00_00_00__00_00_03_00,
		FILE_SIZE_BYTES[7:0],FILE_SIZE_BYTES[15:8],FILE_SIZE_BYTES[23:16],FILE_SIZE_BYTES[31:24],
		{3584{1'b0}}};
		
		nextState <= writeFileUpdatedHeader;
	end
	else if(WB_COMPLT == 1'b1)
	begin
		nextState <= complete;
	end
	else
	begin
		nextState <= writeFileUpdatedHeader;
	end
end
//=====================================
complete:
begin
	INIT_ENA <= 1'b0;
	RB_ENA   <= 1'b0;
	WB_ENA   <= 1'b0;
	RMB_ENA  <= 1'b0;
	WMB_ENA  <= 1'b0;
	
	ENA_M    <= 1'b0;
	
	ENA_BP   <= 1'b0;
	ENA_AVG <= 1'b0;
	ENA_FAT  <= 1'b0;
	
	ENA_FILE_SERVER <= 1'b0;
	RST_FILE_SERVER <= 1'b0;
	ENA_FAT_UPDATER <= 1'b0;
	
	MODE <= on;
	
	useQuadroBuf <= 1'b0;
	
	$display ("File management FSM became unavaliable");
	nextState <= complete;
end
//=====================================		 
default: 
begin
	$display ("File management FSM reached undefined state");
end

endcase
end //else RST
end //always

endmodule