library verilog;
use verilog.vl_types.all;
entity transfrMultBlockWriteCounter is
    port(
        RST             : in     vl_logic;
        CLK             : in     vl_logic;
        NUM             : out    vl_logic_vector(31 downto 0)
    );
end transfrMultBlockWriteCounter;
