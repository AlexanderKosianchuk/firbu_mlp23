library verilog;
use verilog.vl_types.all;
entity FIRBU_AM is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        CLK             : in     vl_logic;
        SD_CLK          : out    vl_logic;
        SD_CMD          : inout  vl_logic;
        SD_DAT          : inout  vl_logic_vector(3 downto 0);
        CLK_ADC         : out    vl_logic;
        INPUT_ADC       : in     vl_logic_vector(7 downto 0);
        LED_INIT_ERROR  : out    vl_logic_vector(1 downto 0);
        LED             : out    vl_logic
    );
end FIRBU_AM;
