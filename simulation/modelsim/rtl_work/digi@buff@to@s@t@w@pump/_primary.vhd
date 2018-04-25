library verilog;
use verilog.vl_types.all;
entity digiBuffToSTWPump is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        RST             : in     vl_logic;
        BLOCKS_DIGITIZED: in     vl_logic_vector(31 downto 0);
        RADDR_DBUFF     : out    vl_logic_vector(14 downto 0);
        RCLK_DBUFF      : out    vl_logic;
        Q_DBUFF         : in     vl_logic_vector(7 downto 0);
        INPUT_SW_PUMP   : out    vl_logic_vector(7 downto 0);
        WADDR_SW_PUMP   : out    vl_logic_vector(9 downto 0);
        WCLK_SW_PUMP    : out    vl_logic;
        WENA_SW_PUMP    : out    vl_logic;
        BUFREADY_PUMP   : out    vl_logic_vector(1 downto 0);
        BUFWAITING      : in     vl_logic_vector(1 downto 0)
    );
end digiBuffToSTWPump;
