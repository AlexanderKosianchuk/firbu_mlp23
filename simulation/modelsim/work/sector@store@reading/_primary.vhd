library verilog;
use verilog.vl_types.all;
entity sectorStoreReading is
    port(
        aclr            : in     vl_logic;
        clock           : in     vl_logic;
        data            : in     vl_logic_vector(3 downto 0);
        rdaddress       : in     vl_logic_vector(8 downto 0);
        rden            : in     vl_logic;
        wraddress       : in     vl_logic_vector(9 downto 0);
        wren            : in     vl_logic;
        q               : out    vl_logic_vector(7 downto 0)
    );
end sectorStoreReading;
