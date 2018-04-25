library verilog;
use verilog.vl_types.all;
entity USBdigitizer is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        DATA_IN_USBBUFF : out    vl_logic_vector(7 downto 0);
        WADDR_USBBUFF   : out    vl_logic_vector(7 downto 0);
        WCLK_USBBUFF    : out    vl_logic;
        WENA_USBBUFF    : out    vl_logic;
        BUFFREADY_USBTRANS: out    vl_logic;
        AVG             : in     vl_logic_vector(7 downto 0)
    );
end USBdigitizer;
