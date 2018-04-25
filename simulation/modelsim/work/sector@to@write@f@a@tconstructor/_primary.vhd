library verilog;
use verilog.vl_types.all;
entity sectorToWriteFATconstructor is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        WCLK_SW         : out    vl_logic;
        WENA_SW         : out    vl_logic;
        WADDR_SW        : out    vl_logic_vector(7 downto 0);
        INPUT_SW        : out    vl_logic_vector(31 downto 0);
        BUFREADY        : out    vl_logic_vector(1 downto 0);
        BUFWAITING      : in     vl_logic_vector(1 downto 0)
    );
end sectorToWriteFATconstructor;
