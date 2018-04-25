library verilog;
use verilog.vl_types.all;
entity serial_CRC16 is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENA             : in     vl_logic;
        BITVAL          : in     vl_logic;
        CRC             : out    vl_logic_vector(15 downto 0)
    );
end serial_CRC16;
