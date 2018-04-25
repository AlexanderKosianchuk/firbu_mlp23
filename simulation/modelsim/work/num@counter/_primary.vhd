library verilog;
use verilog.vl_types.all;
entity numCounter is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        DEF_NUM         : in     vl_logic_vector(31 downto 0);
        NUM             : out    vl_logic_vector(31 downto 0)
    );
end numCounter;
