library verilog;
use verilog.vl_types.all;
entity blockCounter is
    port(
        aclr            : in     vl_logic;
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(31 downto 0)
    );
end blockCounter;
