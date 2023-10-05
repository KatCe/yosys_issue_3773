/* Generated by Yosys 0.33+103 (git sha1 11ffd7df4, gcc-7 7.5.0-6ubuntu2 -fPIC -Os) */

module \$paramod\fpnew_fma\FpFormat=3'001 (clk_i, rst_ni, use_sign_i, sign_i, result_o);
  input clk_i;
  wire clk_i;
  output [64:0] result_o;
  wire [64:0] result_o;
  input rst_ni;
  wire rst_ni;
  input sign_i;
  wire sign_i;
  wire [63:0] special_result;
  input use_sign_i;
  wire use_sign_i;
  assign special_result = use_sign_i ? { sign_i, 63'h7ff0000000000000 } : 64'h7ff0000000000000;
  assign result_o = { 1'h1, special_result };
endmodule

module minimized_top(clk_i, rst_ni, use_sign_i, sign_i, result_o);
  input clk_i;
  wire clk_i;
  output [64:0] result_o;
  wire [64:0] result_o;
  input rst_ni;
  wire rst_ni;
  input sign_i;
  wire sign_i;
  input use_sign_i;
  wire use_sign_i;
  \$paramod\fpnew_fma\FpFormat=3'001  fma (
    .clk_i(clk_i),
    .result_o(result_o),
    .rst_ni(rst_ni),
    .sign_i(sign_i),
    .use_sign_i(use_sign_i)
  );
endmodule