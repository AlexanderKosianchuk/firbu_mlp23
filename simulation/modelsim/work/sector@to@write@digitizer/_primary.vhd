library verilog;
use verilog.vl_types.all;
entity sectorToWriteDigitizer is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        DATA_DBUFF      : out    vl_logic_vector(7 downto 0);
        WADDR_DBUFF     : out    vl_logic_vector(14 downto 0);
        WCLK_DBUFF      : out    vl_logic;
        WREN_DBUFF      : out    vl_logic;
        INPUT           : in     vl_logic_vector(7 downto 0)
    );
end sectorToWriteDigitizer;
