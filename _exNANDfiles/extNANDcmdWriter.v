module extNANDcmdWriter(
CLK,
ENA,
CMD,
CLE,
ALE,
WE1,
IO,
COMPLT);

input  wire        CLK, ENA;
input  wire [55:0] CMD;
output reg         CLE, ALE, WE1;
output tri  [7:0]  IO;
output reg         COMPLT;

reg [7:0] data;
assign IO = ENA ? (COMPLT ? {8{1'bz}} : data) : {8{1'bz}};

/*always @ (negedge ENA or posedge CLK)
begin
  if(!ENA)
  begin
    IO <= {8{1'bz}};
  end
  else
  begin
    IO <= data;
  end
end*/

wire [7:0] i;

exNANDcounterCmdWriter counterCmdTrancfrClockUnit(
~ENA,
CLK,
i);

always @ (negedge CLK)
begin
    
if(ENA)
begin
if(CMD[55:48] == 8'b10010000)
begin

case(i)

8'h00:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1;  data <= {8{1'bz}};
  COMPLT <= 1'b0;
end

8'h01:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= 8'hff;
  COMPLT <= 1'b0;
end

8'h02:
begin
  CLE <= 1'b1; ALE <= 1'b0; WE1 <= 1'b1; data <= CMD[55:48];
  COMPLT <= 1'b0;
end

8'h03:
begin
  CLE <= 1'b1; ALE <= 1'b0; WE1 <= 1'b0; data <= CMD[55:48];
  COMPLT <= 1'b0;
end

8'h04:
begin
  CLE <= 1'b1; ALE <= 1'b0; WE1 <= 1'b1; data <= CMD[55:48];
  COMPLT <= 1'b0;
end

8'h05:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= CMD[47:40];
  COMPLT <= 1'b0;
end

8'h06:
begin
  CLE <= 1'b0; ALE <= 1'b1; WE1 <= 1'b1; data <= CMD[47:40];
  COMPLT <= 1'b0;
end

8'h07:
begin
  CLE <= 1'b0; ALE <= 1'b1; WE1 <= 1'b0; data <= CMD[47:40];
  COMPLT <= 1'b0;
end

8'h08:
begin
  CLE <= 1'b0; ALE <= 1'b1; WE1 <= 1'b1; data <= CMD[47:40];
  COMPLT <= 1'b0;
end

8'h09:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= 8'hff;
  COMPLT <= 1'b1;
end

8'h0a:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= {8{1'bz}};
  COMPLT <= 1'b1;
end

default:
begin
	CLE <= 1'b0;
	WE1 <= 1'bz;
	ALE <= 1'b0;
	data <= {8{1'bz}};	
	COMPLT <= 1'b1;
	$display("FlashPageReader reached undefined state");
end

    endcase

end
else if(CMD[55:48] == 8'hff)
begin

case(i)

8'h00:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1;  data <= {8{1'bz}};
  COMPLT <= 1'b0;
end

8'h01:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= 8'hff;
  COMPLT <= 1'b0;
end

8'h02:
begin
  CLE <= 1'b1; ALE <= 1'b0; WE1 <= 1'b1; data <= 8'hff;
  COMPLT <= 1'b0;
end

8'h03:
begin
  CLE <= 1'b1; ALE <= 1'b0; WE1 <= 1'b0; data <= 8'hff;
  COMPLT <= 1'b0;
end

8'h04:
begin
  CLE <= 1'b1; ALE <= 1'b0; WE1 <= 1'b1; data <= 8'hff;
  COMPLT <= 1'b0;
end

8'h05:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= 8'hff;
  COMPLT <= 1'b0;
end

8'h06:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= 8'hff;
  COMPLT <= 1'b0;
end

8'h07:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= {8{1'bz}};
  COMPLT <= 1'b1;
end

8'h08:
begin
  CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= {8{1'bz}};
  COMPLT <= 1'b1;
end

default:
begin
	CLE <= 1'b0;
	WE1 <= 1'bz;
	ALE <= 1'b0;
	data <= {8{1'bz}};	
	COMPLT <= 1'b1;
	$display("FlashPageReader reached undefined state");
end

    endcase
	 
end

else if(CMD[55:48] == 8'h00)
begin

case(i)
//=======================================0
8'h00:		
begin
	CLE <= 1'b0;	WE1 <= 1'b1;	ALE <= 1'b0;	data <= {8{1'bz}};	
	COMPLT <= 1'b0;
end
//=======================================0
8'h01:		
begin
	CLE <= 1'b0;	WE1 <= 1'b1;	ALE <= 1'b0;	data <= 8'hff;	
	COMPLT <= 1'b0;
end
//=======================================1
8'h02:		
begin	
	CLE <= 1'b1; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[55:48];	
	COMPLT <= 1'b0;
end

//=======================================2
8'h03:		
begin
	CLE <= 1'b1; WE1 <= 1'b0;	ALE <= 1'b0; data <= CMD[55:48];	
	COMPLT <= 1'b0;
end

//=======================================3
8'h04:		
begin
	CLE <= 1'b1; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[55:48];	
	COMPLT <= 1'b0;
end

//=======================================4
8'h05:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[55:48];
	COMPLT <= 1'b0;
end
//=======================================5
8'h06:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b1; data <= CMD[55:48];
	COMPLT <= 1'b0;
end
//=======================================6
8'h07:		
begin
	CLE <= 1'b0; WE1 <= 1'b0;	ALE <= 1'b1; data <= CMD[47:40];	
	COMPLT <= 1'b0;
end
//=======================================7
8'h08:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b1; data <= CMD[47:40];	
	COMPLT <= 1'b0;
end
//=======================================8
8'h09:		
begin
	CLE <= 1'b0; WE1 <= 1'b0;	ALE <= 1'b1; data <= CMD[39:32];	
	COMPLT <= 1'b0;
end
//=======================================9
8'h0a:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b1; data <= CMD[39:32];
	COMPLT <= 1'b0;
end
//=======================================10
8'h0b:		
begin
	CLE <= 1'b0; WE1 <= 1'b0;	ALE <= 1'b1; data <= CMD[31:24];	
	COMPLT <= 1'b0;
end
//=======================================11
8'h0c:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b1; data <= CMD[31:24];	
	COMPLT <= 1'b0;
end
//=======================================12
8'h0d:		
begin
	CLE <= 1'b0; WE1 <= 1'b0;	ALE <= 1'b1; data <= CMD[23:16];	
	COMPLT <= 1'b0;
end
//=======================================13
8'h0e:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b1; data <= CMD[23:16];	
	COMPLT <= 1'b0;
end/*
//=======================================14
8'h0f:		
begin
	CLE <= 1'b0; WE1 <= 1'b0;	ALE <= 1'b1; data <= CMD[15:8];	
	COMPLT <= 1'b0;
end
//=======================================15
8'h10:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b1; data <= CMD[15:8];	
	COMPLT <= 1'b0;
end
//=======================================16
8'h11:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================16
8'h12:		
begin
	CLE <= 1'b1; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================17
8'h13:		
begin
	CLE <= 1'b1; WE1 <= 1'b0;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================18
8'h14:		
begin
	CLE <= 1'b1; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================19
8'h15:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b0; data <= 8'hff;	
	COMPLT <= 1'b1;
end
//=======================================19
8'h16:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b0; data <= 8'hzz;	
	COMPLT <= 1'b1;
end*/
//=======================================16
8'h0f:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================16
8'h10:		
begin
	CLE <= 1'b1; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================17
8'h11:		
begin
	CLE <= 1'b1; WE1 <= 1'b0;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================18
8'h12:		
begin
	CLE <= 1'b1; WE1 <= 1'b1;	ALE <= 1'b0; data <= CMD[7:0];	
	COMPLT <= 1'b0;
end
//=======================================19
8'h13:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b0; data <= 8'hff;	
	COMPLT <= 1'b0;
end
//=======================================19
8'h14:		
begin
	CLE <= 1'b0; WE1 <= 1'b1;	ALE <= 1'b0; data <= 8'hzz;	
	COMPLT <= 1'b1;
end

default:
begin
	CLE <= 1'b0;
	WE1 <= 1'bz;
	ALE <= 1'b0;
	data <= {8{1'bz}};	
	COMPLT <= 1'b1;
	$display("FlashPageReader reached undefined state");
end
		
		endcase

end
  end
  else
  begin
    CLE <= 1'b0; ALE <= 1'b0; WE1 <= 1'b1; data <= {8{1'bz}};
    COMPLT <= 1'b0;
  end

end



endmodule