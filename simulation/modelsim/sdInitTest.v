`include "timescale.v"

module sdInitTest();
  
tri [3:0] iBus; 
reg rst;

tri [3:0] sdBus;
tri sdCmd;
reg sdClk;

tri debugLed;

initial
begin
sdClk = 1'b1;
forever #10 sdClk = ~sdClk; 
end

initial
begin
rst = 1'b1;
#20000 rst = 1'b0; 
end

commandManager commandManagerUnit1( 
.RST(rst),
.SD_CLK(sdClk),
//init
.INIT_ENA(1'b1),
.INIT_COMPLT(),
.INIT_ERROR_NO_RESP(),
.INIT_ERROR_UNAVALIABLEVV(),
//readBlock
.RB_ENA(1'b0),
.RB_COMPLT(),
.RB_CMDERROR(),
.RB_CRCERROR(),
.RB_NORESPERROR(),
.WENA_SR(),
.WADDR_SR(),
.INPUT_SR(),
//writeBlock
.W_READY(),
.W_ERROR(),
.WRITE_TYPE(),
.RADDR_BEGIN(),

.WB_ENA(1'b0),
.WB_COMPLT(),
.RENA_SW(),
.RCLK_SW(),
.RADDR_SW(),
.OUTPUT_SW(),
//readMultBlock
.RMB_ENA(1'b0),
.RMB_READY(),
.RMB_COUNT(),
.RMB_COMPLT(),
//writeMultBlock
.WMB_ENA(1'b0),
.WMB_READY(),
.WMB_COUNT(),
.WMB_NUM(),
.WMB_COMPLT(),
.WMB_STOP_TRSFR(),
.BUFREADY(),// 01 - firstBufReady, 10 - secondBufReady
//W_READY,
//W_ERROR,
//
.ADDR(),
.DATA(),
.SD_CMD(sdCmd),
.SD_DAT(sdBus));

sdModel card (
  .sdClk(sdClk),
  .cmd(sdCmd),
  .dat(sdBus));

	
endmodule