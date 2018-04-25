library verilog;
use verilog.vl_types.all;
entity dataWriter is
    generic(
        blockSize       : integer := 1024;
        CRCWidth        : integer := 15;
        busWidth        : integer := 3
    );
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        RENA            : out    vl_logic;
        RCLK            : out    vl_logic;
        RADDR           : out    vl_logic_vector(10 downto 0);
        RADDR_BEGIN     : in     vl_logic_vector(10 downto 0);
        OUTPUT_SW       : in     vl_logic_vector;
        SD_DAT          : out    vl_logic_vector;
        COMPLT          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of blockSize : constant is 1;
    attribute mti_svvh_generic_type of CRCWidth : constant is 1;
    attribute mti_svvh_generic_type of busWidth : constant is 1;
end dataWriter;
