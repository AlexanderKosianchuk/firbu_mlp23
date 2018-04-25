library verilog;
use verilog.vl_types.all;
entity inputBusToSDDatBusPovider is
    generic(
        blockSize       : integer := 1023;
        CRCWidth        : integer := 15;
        inputBusWidth   : integer := 3
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        COMPLT          : out    vl_logic;
        INPUTBUS        : in     vl_logic_vector;
        OUTPUTBUS       : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of blockSize : constant is 1;
    attribute mti_svvh_generic_type of CRCWidth : constant is 1;
    attribute mti_svvh_generic_type of inputBusWidth : constant is 1;
end inputBusToSDDatBusPovider;
