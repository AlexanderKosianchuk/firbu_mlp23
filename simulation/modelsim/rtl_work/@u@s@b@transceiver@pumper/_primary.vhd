library verilog;
use verilog.vl_types.all;
entity USBTransceiverPumper is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        RADDR_START     : in     vl_logic_vector(10 downto 0);
        RCLK_USBBUFF    : out    vl_logic;
        RADDR_USBBUFF   : out    vl_logic_vector(10 downto 0);
        WR_USBTRANS     : out    vl_logic;
        COMPLT          : out    vl_logic
    );
end USBTransceiverPumper;
