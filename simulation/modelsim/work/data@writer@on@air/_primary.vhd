library verilog;
use verilog.vl_types.all;
entity dataWriterOnAir is
    generic(
        blockSize       : integer := 1024;
        CRCWidth        : integer := 15;
        inputBusWidth   : integer := 7;
        outputBusWidth  : integer := 3
    );
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        CLK_ADC         : out    vl_logic;
        INPUT           : in     vl_logic_vector;
        SD_DAT          : out    vl_logic_vector;
        COMPLT          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of blockSize : constant is 1;
    attribute mti_svvh_generic_type of CRCWidth : constant is 1;
    attribute mti_svvh_generic_type of inputBusWidth : constant is 1;
    attribute mti_svvh_generic_type of outputBusWidth : constant is 1;
end dataWriterOnAir;
