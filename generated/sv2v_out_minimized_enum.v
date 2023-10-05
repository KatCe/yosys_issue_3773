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
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_exp_bits;
		input reg [2:0] fmt;
		fpnew_pkg_exp_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32];
	endfunction
	localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(FpFormat);
	function automatic [31:0] fpnew_pkg_man_bits;
		input reg [2:0] fmt;
		fpnew_pkg_man_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32];
	endfunction
	localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(FpFormat);
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] special_result;
	wire [((1 + EXP_BITS) + MAN_BITS) - 1:0] special_result_q;
	function automatic [EXP_BITS - 1:0] sv2v_cast_3E86D;
		input reg [EXP_BITS - 1:0] inp;
		sv2v_cast_3E86D = inp;
	endfunction
	function automatic [MAN_BITS - 1:0] sv2v_cast_14681;
		input reg [MAN_BITS - 1:0] inp;
		sv2v_cast_14681 = inp;
	endfunction
	function automatic [MAN_BITS - 1:0] sv2v_cast_E62B0;
		input reg [MAN_BITS - 1:0] inp;
		sv2v_cast_E62B0 = inp;
	endfunction
	always @(*) begin : special_cases
		special_result = {1'b0, sv2v_cast_3E86D('1), sv2v_cast_14681(2 ** (MAN_BITS - 1))};
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
