VERILOG ?= GameBoyUlx3s.v pll.v

prog: bin/toplevel.bit
	ujprog $<

flash: bin/toplevel.bit
	ujprog -j flash $<

generate:
	sbt "runMain slabboy.GameBoyUlx3s"

IDCODE ?= 0x21111043 # 12f

bin/toplevel.json: ${VERILOG} pll.v
	mkdir -p bin
	yosys \
		-p "synth_ecp5 -json $@" \
		${VERILOG} 

bin/toplevel.config: bin/toplevel.json
	nextpnr-ecp5 \
		--json $< \
		--textcfg $@ \
		--lpf ulx3s_v20.lpf \
		--25k \
		--package CABGA381

bin/toplevel.bit: bin/toplevel.config
	ecppack --idcode $(IDCODE) --compress $< $@

clean:
	$(RM) -rf bin
