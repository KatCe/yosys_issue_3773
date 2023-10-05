## Summary

This repository demonstrates the Yosys bug reported in https://github.com/YosysHQ/yosys/issues/3773 .

The problem is that Yosys transforms a function's output into a wrong constant.

## Details

The Makefile feeds 3 input examples into the sv2v tool to perform a SystemVerilog to Verilog conversion and then reads this Verilog file into Yosys and writes out the the file again with write_verilog.

There are 3 input designs for demonstration. `minimized_enum.sv` demonstrates the bug:

`minimized_32.sv` sets the following local parameters:

  ```
  localparam int unsigned EXP_BITS = 8;  //fpnew_pkg::exp_bits(FpFormat);
  localparam int unsigned MAN_BITS = 23; //fpnew_pkg::man_bits(FpFormat);
  ```

`minimized_64.sv` sets the following local parameters:

  ```
  localparam int unsigned EXP_BITS = 11;  //fpnew_pkg::exp_bits(FpFormat);
  localparam int unsigned MAN_BITS = 52; //fpnew_pkg::man_bits(FpFormat);
  ```

`minimized_enum.sv` uses the following function calls to set the local parameters:

  ```
  localparam int unsigned EXP_BITS = fpnew_pkg::exp_bits(FpFormat);
  localparam int unsigned MAN_BITS = fpnew_pkg::man_bits(FpFormat);
  ```

These parameters determine the length of the type `fp_t` and therefore of the signal `special_result`. And they determine the default value assigned to special_result:

    special_result    = '{sign: 1'b0, exponent: '1, mantissa: 2**(MAN_BITS-1)}; // canonical qNaN

The length of the data type is correct in all cases, so the value of MAN_BITS and EXP_BITS could be correctly derived by Yosys.

The value assigned to special_result in the default case is wrong in the output generated from `minimized_enum.sv`. `yosys_output_minimized_enum.sv` contains the wrongly generated code:

Actual output:

    assign special_result = use_sign_i ? { sign_i, 63'h7ff0000000000000 } : 64'h7ff0000000000000;

Expected output:

    assign special_result = use_sign_i ? { sign_i, 63'h7ff0000000000000 } : 64'h7ff8000000000000;

The function call `sv2v_cast_14681(2 ** (MAN_BITS - 1))` was converted into 0 by Yosys.

## Test Setup

sv2v v0.0.11-17-g764a11a (https://github.com/zachjs/sv2v)
Yosys 0.33+103 (git sha1 11ffd7df4, gcc-7 7.5.0-6ubuntu2 -fPIC -Os) (https://github.com/YosysHQ/yosys)
OS: Ubuntu 20.04.6 LTS


