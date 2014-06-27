
bootregs.sys: bootregs.nasm
	nasm -f bin -o $@ $^

.PHONY: clean
clean:
	rm -f bootregs.sys
