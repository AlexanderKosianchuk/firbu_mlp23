`include "timescale.v"
`include "defines.v"

module PeriphUSBTest();
  
reg        CLK;
reg        ENA;
reg        BUT;
wire       REC;
wire [1:0] MODE;
wire       LED;

wire       ENA_DATA_OUT;
wire       ENA_WR;
wire [7:0] D_OUT;
reg  [7:0] D_IN;
wire       WR;
reg        RXF;
wire       RD;

localparam	requestByte  = 8'b0110_1100; 
localparam	confirmByte  = 8'b0110_1101; 
localparam	startRecByte = 8'b0111_0011; 

initial
begin
BUT = 1'b1;
ENA = 1'b1;
CLK = 1'b1;
forever #10 CLK = ~CLK; 
end

initial
begin
  RXF = 1'b1;
  D_IN = requestByte;
  #200 RXF = 1'b0;
  #40 RXF  = 1'b1;
  #200 D_IN = startRecByte;
  #200 RXF = 1'b0;
  #40 RXF = 1'b1;
end

peripheralController peripheralControllerUnit(
CLK,
ENA,
BUT,
REC,
MODE,
LED,

ENA_DATA_OUT,
ENA_WR,
D_OUT,
D_IN,
WR,
RXF,
RD);

endmodule
