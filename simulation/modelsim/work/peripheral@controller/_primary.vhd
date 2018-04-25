library verilog;
use verilog.vl_types.all;
entity peripheralController is
    port(
        FAST_CLK        : in     vl_logic;
        USB_CLK         : in     vl_logic;
        ENA             : in     vl_logic;
        BUT             : in     vl_logic;
        REC             : out    vl_logic;
        MODE            : in     vl_logic_vector(1 downto 0);
        LED             : out    vl_logic;
        D_OUT           : out    vl_logic_vector(7 downto 0);
        D_IN            : in     vl_logic_vector(7 downto 0);
        WR              : out    vl_logic;
        RXF             : in     vl_logic;
        TXE             : in     vl_logic;
        RD              : out    vl_logic;
        OE              : out    vl_logic
    );
end peripheralController;
