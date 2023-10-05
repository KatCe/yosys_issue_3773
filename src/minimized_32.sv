
// Copyright 2019 ETH Zurich and University of Bologna.
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// SPDX-License-Identifier: SHL-0.51

// Author: Stefan Mach <smach@iis.ee.ethz.ch>

// Author of this minimized test case: Katharina Ceesay-Seitz <kceesay@ethz.ch>


package fpnew_pkg;
  // Encoding for a format
  typedef struct packed {
    int unsigned exp_bits;
    int unsigned man_bits;
  } fp_encoding_t;

  localparam int unsigned NUM_FP_FORMATS = 5; // change me to add formats
  localparam int unsigned FP_FORMAT_BITS = $clog2(NUM_FP_FORMATS);

  // FP formats
  typedef enum logic [FP_FORMAT_BITS-1:0] {
    FP32    = 'd0,
    FP64    = 'd1,
    FP16    = 'd2,
    FP8     = 'd3,
    FP16ALT = 'd4
    // add new formats here
  } fp_format_e;

  // Encodings for supported FP formats
  localparam fp_encoding_t [0:NUM_FP_FORMATS-1] FP_ENCODINGS  = '{
    '{8,  23}, // IEEE binary32 (single)
    '{11, 52}, // IEEE binary64 (double)
    '{5,  10}, // IEEE binary16 (half)
    '{5,  2},  // custom binary8
    '{8,  7}   // custom binary16alt
    // add new formats here
  };

    // Returns the number of mantissa bits for a format
  function automatic int unsigned man_bits(fp_format_e fmt);
    return FP_ENCODINGS[fmt].man_bits;
  endfunction

    // Returns the number of expoent bits for a format
  function automatic int unsigned exp_bits(fp_format_e fmt);
    return FP_ENCODINGS[fmt].exp_bits;
  endfunction
endpackage

module fpnew_fma #(
  parameter fpnew_pkg::fp_format_e   FpFormat    = fpnew_pkg::fp_format_e'(0)
) (
  input logic                      clk_i,
  input logic                      rst_ni,
  input logic                      use_sign_i,
  input logic                      sign_i,
  output logic [64:0]              result_o
);

  // ----------
  // Constants
  // ----------
  localparam int unsigned EXP_BITS = 8;  //fpnew_pkg::exp_bits(FpFormat);
  localparam int unsigned MAN_BITS = 23; //fpnew_pkg::man_bits(FpFormat);


  // ----------------
  // Type definition
  // ----------------
  typedef struct packed {
    logic                sign;
    logic [EXP_BITS-1:0] exponent;
    logic [MAN_BITS-1:0] mantissa;
  } fp_t;

  // ----------------------
  // Special case handling
  // ----------------------
  fp_t                special_result;
  fp_t                special_result_q;

  always_comb begin : special_cases
    // Default assignments
    special_result    = '{sign: 1'b0, exponent: '1, mantissa: 2**(MAN_BITS-1)}; // canonical qNaN

    if (use_sign_i) begin
        // Result is inifinity with sign of the addend (= operand_c)
        special_result    = '{sign: sign_i, exponent: '1, mantissa: '0};
    end
  end

  assign result_o = {1'b1, special_result};

endmodule

module minimized_top(
  input logic                      clk_i,
  input logic                      rst_ni,
  input logic                      use_sign_i,
  input logic                      sign_i,
  output logic [64:0]              result_o);

  fpnew_fma #(
    .FpFormat(fpnew_pkg::fp_format_e'(1))
  ) fma(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .use_sign_i(use_sign_i),
    .sign_i(sign_i),
    .result_o(result_o)
  );

endmodule
