VERILOG = StripedIli9320.v slabboy_pll.v

generate :
	sbt "runMain slabboy.StripedIli9320"

SlabBoyTest.v :
	sbt "runMain slabboy.StripedIli9320"

bin/toplevel.json : ${VERILOG}
	mkdir -p bin
	yosys -v3 -p "synth_ice40 -top StripedIli9320 -json bin/toplevel.json" ${VERILOG}

bin/toplevel.asc : ili9320.pcf bin/toplevel.json
	nextpnr-ice40 --freq 25 --hx8k --package tq144:4k --json bin/toplevel.json --pcf ili9320.pcf --asc bin/toplevel.asc --opt-timing --placer heap

bin/toplevel.bin : bin/toplevel.asc
	icepack -s bin/toplevel.asc bin/toplevel.bin

compile : bin/toplevel.bin

time: bin/toplevel.bin
	icetime -tmd hx8k bin/toplevel.asc

prog : bin/toplevel.bin
	stty -F /dev/ttyACM0 raw
	cat bin/toplevel.bin >/dev/ttyACM0

clean :
	rm -rf bin
