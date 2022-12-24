module DE0_led_slider(
	input [3:0] number,
	output [13:0] fnd_on
);
	fnd original(
		.number(number),
		.fnd(fnd_on[6:0])
	);

	fnd invert(
		.number(~number),
		.fnd(fnd_on[13:7])
	);
endmodule
