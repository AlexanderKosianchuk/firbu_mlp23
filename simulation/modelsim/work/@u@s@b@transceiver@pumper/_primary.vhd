library verilog;
use verilog.vl_types.all;
entity USBTransceiverPumper is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        RADDR_START     : in     vl_logic_vector(7 downto 0);
        RCLK_USBBUFF    : out    vl_logic;
        RADDR_USBBUFF   : out    vl_logic_vector(7 downto 0);
        Q_USBBUFF       : in     vl_logic_vector(7 downto 0);
        WR_USBTRANS     : out    vl_logic;
        D_USBTRANS      : out    vl_logic_vector(7 downto 0);
        COMPLT          : out    vl_logic
    );
end USBTransceiverPumper;
