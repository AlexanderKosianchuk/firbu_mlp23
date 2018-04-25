library verilog;
use verilog.vl_types.all;
entity fileSystemServer is
    port(
        CLK             : in     vl_logic;
        ENA             : in     vl_logic;
        RST             : in     vl_logic;
        COMPLT          : out    vl_logic;
        FILE_BEGINNING_ADDR: in     vl_logic_vector(31 downto 0);
        FAT1_BEGINNING_ADDR: in     vl_logic_vector(31 downto 0);
        FAT2_BEGINNING_ADDR: in     vl_logic_vector(31 downto 0);
        BLOCKS_IN_CLUST : in     vl_logic_vector(31 downto 0);
        STOP_BLOCK_NUM  : in     vl_logic_vector(31 downto 0);
        FILE_SIZE_BYTES : out    vl_logic_vector(31 downto 0);
        FIRST_CLUST_TO_UPDATE_FAT: out    vl_logic_vector(31 downto 0);
        CLUST_NUM_EOF   : out    vl_logic_vector(31 downto 0);
        ADDR_TO_UPDATE_FAT1: out    vl_logic_vector(31 downto 0);
        ADDR_TO_UPDATE_FAT2: out    vl_logic_vector(31 downto 0);
        ADDR_TO_RESUME_WRITTING_FILE: out    vl_logic_vector(31 downto 0)
    );
end fileSystemServer;
