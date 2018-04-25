library verilog;
use verilog.vl_types.all;
entity muteCounter is
    generic(
        Tm              : vl_notype
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        COMPLT          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Tm : constant is 5;
end muteCounter;
