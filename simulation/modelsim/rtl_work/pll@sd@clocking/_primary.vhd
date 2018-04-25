library verilog;
use verilog.vl_types.all;
entity pllSdClocking is
    port(
        inclk0          : in     vl_logic;
        c0              : out    vl_logic;
        c1              : out    vl_logic;
        c2              : out    vl_logic
    );
end pllSdClocking;
