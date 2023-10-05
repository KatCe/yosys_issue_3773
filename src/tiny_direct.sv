module tiny_top (
	result_o
);
  output wire [63:0] result_o;
	assign result_o = 2 ** (52 - 1);
endmodule