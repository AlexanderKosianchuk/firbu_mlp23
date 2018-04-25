library verilog;
use verilog.vl_types.all;
entity parallelToWideBusDataWriter is
    generic(
        blockSize       : integer := 4095;
        CRCWidth        : integer := 15;
        busWidth        : integer := 3
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        COMPLT          : out    vl_logic;
        INPUTDATA       : in     vl_logic_vector;
        OUTPUTBUS       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of blockSize : constant is 1;
    attribute mti_svvh_generic_type of CRCWidth : constant is 1;
    attribute mti_svvh_generic_type of busWidth : constant is 1;
end parallelToWideBusDataWriter;
