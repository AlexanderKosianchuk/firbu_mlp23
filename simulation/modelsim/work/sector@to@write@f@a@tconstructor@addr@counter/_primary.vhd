library verilog;
use verilog.vl_types.all;
entity sectorToWriteFATconstructorAddrCounter is
    port(
        RST             : in     vl_logic;
        CLK             : in     vl_logic;
        NUM             : out    vl_logic_vector(7 downto 0)
    );
end sectorToWriteFATconstructorAddrCounter;
