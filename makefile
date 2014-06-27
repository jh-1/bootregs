bootregs: bootregs.nasm
	nasm -f bin bootregs.nasm

.PHONY: clean
clean:
	rm -f bootregs
