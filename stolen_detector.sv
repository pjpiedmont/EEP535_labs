module stolen_detector(isStolen, isDiscounted, u, p, c, isMarkPresent);
	output logic isStolen;
	output logic isDiscounted;
	input  logic u;
	input  logic p;
	input  logic c;
	input  logic isMarkPresent;
	
	assign isStolen = ~(p | isMarkPresent | (~u & c));
	assign isDiscounted = (p | (u & c));
endmodule

module stolen_detector_testbench();
	logic isStolen;
	logic isDiscounted;
	logic u;
	logic p;
	logic c;
	logic isMarkPresent;
	
	stolen_detector dut(.isStolen, .isDiscounted, .u, .p, .c, .isMarkPresent);
	
	int i;
	initial begin
		for (i = 0; i < 16; i++) begin
			{ u, p, c, isMarkPresent } = i; #10;
		end
	end
endmodule