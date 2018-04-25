library verilog;
use verilog.vl_types.all;
entity sectorToWriteDigitizerAddrCounter is
    port(
        aclr            : in     vl_logic;
        clock           : in     vl_logic;
        sset            : in     vl_logic;
        q               : out    vl_logic_vector(11 downto 0)
    );
end sectorToWriteDigitizerAddrCounter;
