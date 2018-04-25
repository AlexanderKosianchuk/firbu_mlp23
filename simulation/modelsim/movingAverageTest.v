module movingAverageTest();
  
reg CLK;
reg ENA;

wire WCLK_SW;
wire WENA_SW;
wire [11:0] WADDR_SW;
wire [7:0] INPUT_SW;

wire [1:0] BUFREADY;

reg [7:0] INPUT_ADC1;
reg [7:0] INPUT_ADC2;

wire CLK_ADC1;
wire CLK_ADC2;

  
initial
begin
CLK = 1'b1;
ENA = 1'b1;
forever #250 CLK = ~CLK; 
end

always @(posedge CLK_ADC1)
begin
  INPUT_ADC1 = $random; 
end  

always @(posedge CLK_ADC2)
begin
  INPUT_ADC2 = $random; 
end  
  
  
movingAverage   movingAverageUnit(
CLK,
ENA,

WCLK_SW,
WENA_SW,
WADDR_SW,
INPUT_SW,

BUFREADY,

INPUT_ADC1,
INPUT_ADC2,

CLK_ADC1,
CLK_ADC2);

endmodule
