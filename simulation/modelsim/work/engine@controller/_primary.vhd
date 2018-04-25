library verilog;
use verilog.vl_types.all;
entity engineController is
    port(
        CLK             : in     vl_logic;
        REC             : in     vl_logic;
        ERROR           : in     vl_logic;
        DIRECTION       : in     vl_logic;
        STRAIGHT_ENGINE : out    vl_logic;
        REVERSE_ENGINE  : out    vl_logic
    );
end engineController;
