library verilog;
use verilog.vl_types.all;
entity peripheralController is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        BUT             : in     vl_logic;
        REC             : out    vl_logic;
        MODE            : in     vl_logic_vector(1 downto 0);
        LED             : out    vl_logic;
        ENA_DATA_OUT    : out    vl_logic;
        ENA_WR          : out    vl_logic;
        D_OUT           : out    vl_logic_vector(7 downto 0);
        D_IN            : in     vl_logic_vector(7 downto 0);
        WR              : out    vl_logic;
        RXF             : in     vl_logic;
        RD              : out    vl_logic
    );
end peripheralController;
