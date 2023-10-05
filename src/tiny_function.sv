module tiny_top (
	result_o
);

	output wire [52-1:0] result_o;
	function automatic [52 - 1:0] sv2v_cast_14681;
		input reg [52 - 1:0] inp;
		sv2v_cast_14681 = inp;
	endfunction

	assign result_o = sv2v_cast_14681(2 ** (52 - 1));
endmodule