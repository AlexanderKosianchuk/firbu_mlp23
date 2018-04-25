library verilog;
use verilog.vl_types.all;
entity movingAverage is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        INPUT_ADC1      : in     vl_logic_vector(7 downto 0);
        INPUT_ADC2      : in     vl_logic_vector(7 downto 0);
        CLK_ADC1        : out    vl_logic;
        CLK_ADC2        : out    vl_logic;
        DATA_DBUFF      : out    vl_logic_vector(7 downto 0);
        WADDR_DBUFF     : out    vl_logic_vector(14 downto 0);
        WCLK_DBUFF      : out    vl_logic;
        WREN_DBUFF      : out    vl_logic;
        DATA_IN_USBBUFF : out    vl_logic_vector(7 downto 0);
        WADDR_USBBUFF   : out    vl_logic_vector(10 downto 0);
        WCLK_USBBUFF    : out    vl_logic;
        WENA_USBBUFF    : out    vl_logic;
        BUFFREADY_USBTRANS: out    vl_logic;
        BLOCKS_DIGITIZED: out    vl_logic_vector(31 downto 0)
    );
end movingAverage;
