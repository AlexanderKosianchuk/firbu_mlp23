library verilog;
use verilog.vl_types.all;
entity sectorToWriteFATupdater is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        WCLK_SW         : out    vl_logic;
        WENA_SW         : out    vl_logic;
        WADDR_SW        : out    vl_logic_vector(7 downto 0);
        INPUT_SW        : out    vl_logic_vector(31 downto 0);
        BEGIN_CLUST_NUM : in     vl_logic_vector(31 downto 0);
        EOF_CLUST_NUM   : in     vl_logic_vector(31 downto 0);
        COMPLT          : out    vl_logic
    );
end sectorToWriteFATupdater;
