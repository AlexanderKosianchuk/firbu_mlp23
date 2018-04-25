library verilog;
use verilog.vl_types.all;
entity sd_crc_16 is
    port(
        BITVAL          : in     vl_logic;
        Enable          : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        CRC             : out    vl_logic_vector(15 downto 0)
    );
end sd_crc_16;
