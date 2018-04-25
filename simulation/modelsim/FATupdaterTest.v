module FATupdeterTest();
  
reg CLK;
reg ENA;

wire WCLK_SW;
wire WENA_SW;
wire [9:0] WADDR_SW;
wire [31:0] INPUT_SW;
wire [12:0] RADDR_SW;
wire RCLK_SW;
wire RENA_SW;
wire [3:0] OUTPUT_SW;

reg [31:0] BEGIN_CLUST_NUM;
reg [31:0] EOF_CLUST_NUM;
  
initial
begin
CLK = 1'b1;
ENA = 1'b0;
BEGIN_CLUST_NUM <= 32'h81;
EOF_CLUST_NUM <= 32'hff;
#10 ENA = 1'b1;
forever #250 CLK = ~CLK; 
end

sectorToWriteFATupdater sectorToWriteFATupdaterUnit(
CLK,
ENA,

WCLK_SW,
WENA_SW,
WADDR_SW,
INPUT_SW,

BEGIN_CLUST_NUM,
EOF_CLUST_NUM,

COMPLT);

sectorToWriteFATpage sectorToWriteFATpageUnit(
INPUT_SW,
ENA,
RADDR_SW,
RCLK_SW,
RENA_SW,
WADDR_SW,
WCLK_SW,
WENA_SW,
OUTPUT_SW);

endmodule
