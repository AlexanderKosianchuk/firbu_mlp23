library verilog;
use verilog.vl_types.all;
entity USBTransceiver is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        RCLK_USBBUFF    : out    vl_logic;
        RADDR_USBBUFF   : out    vl_logic_vector(7 downto 0);
        Q_USBBUFF       : in     vl_logic_vector(7 downto 0);
        BUFFREADY_USBTRANS: in     vl_logic;
        TXE             : in     vl_logic;
        WR_USBTRANS     : out    vl_logic;
        D_USBTRANS      : out    vl_logic_vector(7 downto 0)
    );
end USBTransceiver;
