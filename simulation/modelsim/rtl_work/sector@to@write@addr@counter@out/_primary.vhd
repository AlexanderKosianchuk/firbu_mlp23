library verilog;
use verilog.vl_types.all;
entity sectorToWriteAddrCounterOut is
    port(
        aclr            : in     vl_logic;
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(12 downto 0)
    );
end sectorToWriteAddrCounterOut;
