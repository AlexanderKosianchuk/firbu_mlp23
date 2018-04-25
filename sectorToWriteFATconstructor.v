`include "timescale.v"
`include "defines.v"

module sectorToWriteFATconstructor(
CLK,
ENA,

WCLK_SW,
WENA_SW,
WADDR_SW,
INPUT_SW,

BUFREADY,
BUFWAITING);

input  wire CLK, ENA;

output reg          WCLK_SW;
output wire         WENA_SW;
output wire  [7:0]  WADDR_SW;
output wire  [31:0] INPUT_SW;

output reg   [1:0]  BUFREADY;  
input  wire  [1:0]  BUFWAITING;

reg  [31:0] clusterNum;
reg  [7:0]  addrCounter;

assign WENA_SW = ENA;
assign WADDR_SW[7:0] = addrCounter[7:0];

assign INPUT_SW [31:28] = clusterNum [27:24];
assign INPUT_SW [27:24] = clusterNum [31:28];
assign INPUT_SW [23:20] = clusterNum [19:16];
assign INPUT_SW [19:16] = clusterNum [23:20];
assign INPUT_SW [15:12] = clusterNum [11:8];
assign INPUT_SW [11:8]  = clusterNum [15:12];
assign INPUT_SW [7:4]   = clusterNum [3:0];
assign INPUT_SW [3:0]   = clusterNum [7:4];

reg ENA_COUNTER;

localparam glitchTime = 3;
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

always @ (posedge CLK)
begin
	if(ENA_COUNTER)
	begin
		if(BUFWAITING == 2'b01)
		begin
			if(BUFREADY != 2'b01)
			begin
				WCLK_SW <= !WCLK_SW;
			end
		end
		else if(BUFWAITING == 2'b10)
		begin
			if(BUFREADY != 2'b10)
			begin
				WCLK_SW <= !WCLK_SW;
			end
		end		
	end
	else
	begin
		WCLK_SW <= 1'b0;
	end
end

always @ (negedge ENA_COUNTER or negedge WCLK_SW)
begin
	if(!ENA_COUNTER)
	begin
		addrCounter <= 8'h00;
		
	end
	else
	begin
		addrCounter <= addrCounter + 8'h01;
	end          
end

always @ (negedge ENA_COUNTER or negedge WCLK_SW)
begin
	if(!ENA_COUNTER)
	begin
		clusterNum <= 32'h1;
	end
	else
	begin
		clusterNum <= clusterNum + 32'd1;
	end
end

always @(negedge CLK)
begin
  if(ENA)
  begin
    if(addrCounter == 8'd0)//more 511
    begin
		BUFREADY <= 2'b10;
    end
    else if((addrCounter >= 8'd1) && (addrCounter <= 8'd127))//more 511
    begin
		BUFREADY <= 2'b10;
    end
	 else if((addrCounter >= 8'd128) && (addrCounter <= 8'd255))//more 511
    begin
		BUFREADY <= 2'b01;
    end
    else
    begin
		BUFREADY <= 2'b00;
    end
  end
  else
  begin
	 BUFREADY <= 2'b00;
  end
end

   
endmodule