library verilog;
use verilog.vl_types.all;
entity pathNumCounter is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        BEGIN_TRACK     : in     vl_logic;
        END_TRACK       : in     vl_logic;
        CHANGE_PATH_BUT : in     vl_logic;
        PATH_NUM_SHIFT  : out    vl_logic_vector(11 downto 0);
        DIRECTION       : out    vl_logic
    );
end pathNumCounter;
