library verilog;
use verilog.vl_types.all;
entity butStartStopController is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        START_BUT       : in     vl_logic;
        STOP_BUT        : in     vl_logic;
        REC             : out    vl_logic
    );
end butStartStopController;
