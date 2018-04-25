module fileSystemServer(
CLK,
ENA,
RST,
COMPLT,
FILE_BEGINNING_ADDR,
FAT1_BEGINNING_ADDR,
FAT2_BEGINNING_ADDR,
BLOCKS_IN_CLUST,
STOP_BLOCK_NUM,
FILE_SIZE_BYTES,
FIRST_CLUST_TO_UPDATE_FAT,
CLUST_NUM_EOF,
ADDR_TO_UPDATE_FAT1,
ADDR_TO_UPDATE_FAT2,
ADDR_TO_RESUME_WRITTING_FILE);

input  wire        CLK, ENA, RST;
output reg         COMPLT;
input  wire [31:0] FILE_BEGINNING_ADDR;
input  wire [31:0] FAT1_BEGINNING_ADDR;
input  wire [31:0] FAT2_BEGINNING_ADDR;
input  wire [31:0] BLOCKS_IN_CLUST;

input  wire [31:0] STOP_BLOCK_NUM;

output reg  [31:0] FILE_SIZE_BYTES;
output reg  [31:0] ADDR_TO_RESUME_WRITTING_FILE;
output reg  [31:0] FIRST_CLUST_TO_UPDATE_FAT;
output reg  [31:0] CLUST_NUM_EOF;
output reg  [31:0] ADDR_TO_UPDATE_FAT1;
output reg  [31:0] ADDR_TO_UPDATE_FAT2;


reg [31:0] blocksInFile;
reg [31:0] clustInFile;
reg [31:0] FATpagesInFile;

//=====================================
reg ENA_COUNTER;
reg [15:0] counter;

localparam glitchTime = 2;
reg [3:0] muteCountersTimer;

always @ (posedge CLK)
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

always @ (negedge CLK)
begin
	if(ENA_COUNTER)
	begin
		counter <= counter + 16'b1;
	end
	else
	begin
		counter <= 16'b0;
	end
end
//-----------------------------

always @ (posedge RST or posedge CLK)
begin

if(RST)
begin
	blocksInFile <= 32'd0;
	COMPLT <= 1'b0;
	ADDR_TO_RESUME_WRITTING_FILE <= FILE_BEGINNING_ADDR;
end
else
begin
	if(counter == 16'd0)
	begin
		COMPLT <= 1'b0;
	end
	else if(counter == 16'd1)
	begin
		COMPLT <= 1'b0;
		blocksInFile <= blocksInFile + STOP_BLOCK_NUM;
	end
	else if(counter == 16'd2)
	begin
		COMPLT <= 1'b0;
	
		case(BLOCKS_IN_CLUST)

		32'd1:
		begin
			clustInFile <= blocksInFile;
		end

		32'd2:
		begin
			clustInFile <= blocksInFile >> 32'd1;
		end

		32'd4:
		begin
			clustInFile <= blocksInFile >> 32'd2;
		end

		32'd8:
		begin
			clustInFile <= blocksInFile >> 32'd3;
		end

		32'd16:
		begin
			clustInFile <= blocksInFile >> 32'd4;
		end

		32'd32:
		begin
			clustInFile <= blocksInFile >> 32'd5;
		end

		32'd64:
		begin
			clustInFile <= blocksInFile >> 32'd6;
		end

		32'd128:
		begin
			clustInFile <= blocksInFile >> 32'd7;
		end

		endcase

	end
	else if(counter == 16'd3)
	begin
		COMPLT <= 1'b0;
		FATpagesInFile <= clustInFile >> 32'd7; // because 128 clust in block in FAT32  
	end
	else if(counter == 16'd4)
	begin
		COMPLT <= 1'b0;
		FILE_SIZE_BYTES <= blocksInFile * 32'd512;
	end
	else if(counter == 16'd5)
	begin
		COMPLT <= 1'b0;
		ADDR_TO_RESUME_WRITTING_FILE <= FILE_BEGINNING_ADDR + blocksInFile;
	end
	else if(counter == 16'd6)
	begin
		COMPLT <= 1'b0;
		CLUST_NUM_EOF <= clustInFile + 4; // because clust count begins from 4
	end
	else if(counter == 16'd7)
	begin
		COMPLT <= 1'b0;
		FIRST_CLUST_TO_UPDATE_FAT <= FATpagesInFile  * 32'd128 + 32'd1;
	end
	else if(counter == 16'd8)
	begin
		COMPLT <= 1'b0;
		ADDR_TO_UPDATE_FAT1 <= FAT1_BEGINNING_ADDR + FATpagesInFile;
	end
	else if(counter == 16'd9)
	begin
		COMPLT <= 1'b0;
		ADDR_TO_UPDATE_FAT2 <= FAT2_BEGINNING_ADDR + FATpagesInFile;
	end
	else
	begin
		COMPLT <= 1'b1;	
	end
end
end

endmodule


//
//always @ (posedge RST or posedge CLK)
//begin
//	if(RST)
//	begin
//		blocksInFile <= 32'd0;
//	end
//	else
//	begin
//		blocksInFile <= blocksInFile + STOP_BLOCK_NUM;
//	end
//end
//
//always@(blocksInFile)
//begin
//  if(RST)
//    begin
//      clustInFile <= 32'd0;
//    end
//  else
//    begin
//
//case(BLOCKS_IN_CLUST)
//
//32'd1:
//begin
//	clustInFile <= blocksInFile;
//end
//
//32'd2:
//begin
//	clustInFile <= blocksInFile >> 32'd1;
//end
//
//32'd4:
//begin
//	clustInFile <= blocksInFile >> 32'd2;
//end
//
//32'd8:
//begin
//	clustInFile <= blocksInFile >> 32'd3;
//end
//
//32'd16:
//begin
//	clustInFile <= blocksInFile >> 32'd4;
//end
//
//32'd32:
//begin
//	clustInFile <= blocksInFile >> 32'd5;
//end
//
//32'd64:
//begin
//	clustInFile <= blocksInFile >> 32'd6;
//end
//
//32'd128:
//begin
//	clustInFile <= blocksInFile >> 32'd7;
//end
//
//endcase
//
//    end
//end
//
//always@(clustInFile)
//begin
//  if(RST)
//    begin
//      FATpagesInFile <= 32'd0;
//    end
//  else
//    begin
//      FATpagesInFile <= clustInFile >> 32'd7; // because 128 clust in block in FAT32    
//    end
//end
//
//always @ (FATpagesInFile)
//begin
//
//FILE_SIZE_BYTES <= blocksInFile * 32'd512;
//ADDR_TO_RESUME_WRITTING_FILE <= FILE_BEGINNING_ADDR + blocksInFile;
//CLUST_NUM_EOF <= clustInFile + 4; // because clust count begins from 4
//FIRST_CLUST_TO_UPDATE_FAT <= FATpagesInFile  * 32'd128 + 32'd1;
//ADDR_TO_UPDATE_FAT1 <= FAT1_BEGINNING_ADDR + FATpagesInFile;
//ADDR_TO_UPDATE_FAT2 <= FAT2_BEGINNING_ADDR + FATpagesInFile;
//
//
//end