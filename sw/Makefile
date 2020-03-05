all: test.gb

clean:
	rm -f *.gb

%.gb : %.o
	rgblink -mtest.map -o $@ $<

%.o : %.asm
	rgbasm -o $@ $<
