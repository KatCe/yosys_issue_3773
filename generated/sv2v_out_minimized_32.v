module fpnew_fma (
	clk_i,
	rst_ni,
	use_sign_i,
	sign_i,
	result_o
);
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	function automatic [2:0] sv2v_cast_0BC43;
		input reg [2:0] inp;
		sv2v_cast_0BC43 = inp;
	endfunction
	parameter [2:0] FpFormat = sv2v_cast_0BC43(0);
	input wire clk_i;
	input wire rst_ni;
	input wire use_sign_i;
	input wire sign_i;
	output wire [64:0] result_o;
	localparam [31:0] EXP_BITS = 8;
	localparam [31:0] MAN_BITS = 23;
	reg [31:0] special_result;
	wire [31:0] special_result_q;
	function automatic [7:0] sv2v_cast_3E86D;
		input reg [7:0] inp;
		sv2v_cast_3E86D = inp;
	endfunction
	function automatic [22:0] sv2v_cast_14681;
		input reg [22:0] inp;
		sv2v_cast_14681 = inp;
	endfunction
	function automatic [22:0] sv2v_cast_E62B0;
		input reg [22:0] inp;
		sv2v_cast_E62B0 = inp;
	endfunction
	always @(*) begin : special_cases
		special_result = {1'b0, sv2v_cast_3E86D('1), sv2v_cast_14681(4194304)};
		if (use_sign_i)
			special_result = {sign_i, sv2v_cast_3E86D('1), sv2v_cast_E62B0('0)};
	end
	assign result_o = {1'b1, special_result};
endmodule
module minimized_top (
	clk_i,
	rst_ni,
	use_sign_i,
	sign_i,
	result_o
);
	input wire clk_i;
	input wire rst_ni;
	input wire use_sign_i;
	input wire sign_i;
	output wire [64:0] result_o;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	function automatic [2:0] sv2v_cast_0BC43;
		input reg [2:0] inp;
		sv2v_cast_0BC43 = inp;
	endfunction
	fpnew_fma #(.FpFormat(sv2v_cast_0BC43(1))) fma(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.use_sign_i(use_sign_i),
		.sign_i(sign_i),
		.result_o(result_o)
	);
endmodule
