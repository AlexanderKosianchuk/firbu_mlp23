library verilog;
use verilog.vl_types.all;
entity dataReader is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        DATA            : out    vl_logic_vector(3 downto 0);
        WENA            : out    vl_logic;
        WADDR           : out    vl_logic_vector(9 downto 0);
        INPUT           : in     vl_logic_vector(3 downto 0);
        CRCERROR        : out    vl_logic;
        NORESPERROR     : out    vl_logic;
        COMPLT          : out    vl_logic
    );
end dataReader;
