library verilog;
use verilog.vl_types.all;
entity FIRBU_AM is
    port(
        EXT_CLK         : in     vl_logic;
        EXT_USB_CLK     : in     vl_logic;
        SD_CLK          : out    vl_logic;
        SD_CMD          : inout  vl_logic;
        SD_DAT          : inout  vl_logic_vector(3 downto 0);
        ADC_CLK1        : out    vl_logic;
        ADC_CLK2        : out    vl_logic;
        ADC_INPUT1      : in     vl_logic_vector(7 downto 0);
        ADC_INPUT2      : in     vl_logic_vector(7 downto 0);
        LED             : out    vl_logic;
        BUT             : in     vl_logic;
        D               : inout  vl_logic_vector(7 downto 0);
        RXF             : in     vl_logic;
        TXE             : in     vl_logic;
        WR              : out    vl_logic;
        RD              : out    vl_logic;
        SIWU            : out    vl_logic;
        OE              : out    vl_logic
    );
end FIRBU_AM;
