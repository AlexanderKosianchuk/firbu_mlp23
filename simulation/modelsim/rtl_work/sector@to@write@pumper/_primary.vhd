library verilog;
use verilog.vl_types.all;
entity sectorToWritePumper is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        START_RADDR_DBUFF: in     vl_logic_vector(14 downto 0);
        RADDR_DBUFF     : out    vl_logic_vector(14 downto 0);
        RCLK_DBUFF      : out    vl_logic;
        Q_DBUFF         : in     vl_logic_vector(7 downto 0);
        INPUT_SW_PUMP   : out    vl_logic_vector(7 downto 0);
        WADDR_SW_PUMP   : out    vl_logic_vector(9 downto 0);
        WCLK_SW_PUMP    : out    vl_logic;
        WENA_SW_PUMP    : out    vl_logic;
        START_WADDR_SW_PUMP: in     vl_logic_vector(9 downto 0);
        BUFREADY        : in     vl_logic;
        COMPLT_PUMPER   : out    vl_logic
    );
end sectorToWritePumper;
