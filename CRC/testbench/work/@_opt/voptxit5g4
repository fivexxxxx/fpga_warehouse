library verilog;
use verilog.vl_types.all;
entity mean_filter is
    generic(
        N               : integer := 10;
        DATA_WIDTH      : integer := 24;
        DATA_DEPTH      : vl_notype;
        RAM_DEPTH       : vl_notype
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_in         : in     vl_logic_vector;
        data_out        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_DEPTH : constant is 3;
    attribute mti_svvh_generic_type of RAM_DEPTH : constant is 3;
end mean_filter;
