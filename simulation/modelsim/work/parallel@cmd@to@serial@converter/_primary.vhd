library verilog;
use verilog.vl_types.all;
entity parallelCmdToSerialConverter is
    generic(
        parallelCmdWidth: integer := 37;
        parallelCrcWidth: integer := 6;
        totalCC         : integer := 47
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        COMPLT          : out    vl_logic;
        PARALLELCMD     : in     vl_logic_vector;
        SERIALCMD       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of parallelCmdWidth : constant is 1;
    attribute mti_svvh_generic_type of parallelCrcWidth : constant is 1;
    attribute mti_svvh_generic_type of totalCC : constant is 1;
end parallelCmdToSerialConverter;
