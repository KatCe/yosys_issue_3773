
TOP_MODULE=minimized_top
PATH_TO_YOSYS=
PATH_TO_SV2V=

all: generated/yosys_output_minimized_32.sv generated/yosys_output_minimized_64.sv generated/yosys_output_minimized_enum.sv

generated/sv2v_out_minimized_%.v: src/minimized_%.sv | generated
	$(PATH_TO_SV2V)sv2v -E=UnbasedUnsized -DSYNTHESIS -DVERILATOR $< > $@

.PRECIOUS: generated/sv2v_out_minimized_%.v

generated/yosys_output_minimized_%.sv: generated/sv2v_out_minimized_%.v | generated
	TOP_MODULE=$(TOP_MODULE) VERILOG_INPUT=$< VERILOG_OUTPUT=$@ $(PATH_TO_YOSYS)yosys -c yosys.ys.tcl

generated:
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf generated

