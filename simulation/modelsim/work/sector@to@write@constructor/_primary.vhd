library verilog;
use verilog.vl_types.all;
entity sectorToWriteConstructor is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        FIRST_CLUST_TO_UPDATE_SC: in     vl_logic_vector(31 downto 0);
        CLUST_EOF       : in     vl_logic_vector(31 downto 0);
        WCLK_SW         : out    vl_logic;
        WENA_SW         : out    vl_logic;
        WADDR_SW        : out    vl_logic_vector(10 downto 0);
        INPUT_SW        : out    vl_logic_vector(31 downto 0);
        COMPLT          : out    vl_logic
    );
end sectorToWriteConstructor;
