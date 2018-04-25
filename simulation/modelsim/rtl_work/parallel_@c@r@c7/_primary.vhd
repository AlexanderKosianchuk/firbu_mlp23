library verilog;
use verilog.vl_types.all;
entity parallel_CRC7 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        crc_en          : in     vl_logic;
        complt          : out    vl_logic;
        data_in         : in     vl_logic_vector(39 downto 0);
        crc_out         : out    vl_logic_vector(6 downto 0)
    );
end parallel_CRC7;
