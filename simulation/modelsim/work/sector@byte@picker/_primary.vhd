library verilog;
use verilog.vl_types.all;
entity sectorBytePicker is
    port(
        RST             : in     vl_logic;
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        ADDRBEG         : in     vl_logic_vector(8 downto 0);
        NUM             : in     vl_logic_vector(1 downto 0);
        INPUT           : in     vl_logic_vector(7 downto 0);
        ADDR            : out    vl_logic_vector(8 downto 0);
        RENA            : out    vl_logic;
        COMPLT          : out    vl_logic;
        Q               : out    vl_logic_vector(31 downto 0)
    );
end sectorBytePicker;
