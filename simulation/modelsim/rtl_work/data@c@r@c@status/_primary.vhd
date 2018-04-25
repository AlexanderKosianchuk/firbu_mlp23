library verilog;
use verilog.vl_types.all;
entity dataCRCStatus is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        COMPLT          : out    vl_logic;
        ERROR           : out    vl_logic;
        INPUTSERIALSTATUS: in     vl_logic
    );
end dataCRCStatus;
