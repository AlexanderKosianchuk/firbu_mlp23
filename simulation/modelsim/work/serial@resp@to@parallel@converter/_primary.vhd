library verilog;
use verilog.vl_types.all;
entity serialRespToParallelConverter is
    generic(
        outputParallelRespWidth: vl_notype
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        COMPLT          : out    vl_logic;
        ERROR           : out    vl_logic;
        NORESP          : out    vl_logic;
        CRC_ERROR       : out    vl_logic;
        CMDINDEX        : in     vl_logic_vector(5 downto 0);
        INPUTSERIALCMD  : in     vl_logic;
        OUTPUTPARALLELCMD: out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of outputParallelRespWidth : constant is 5;
end serialRespToParallelConverter;
