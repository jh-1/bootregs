Bootregs
========

Bootregs reports the values of specific registers passed to a boot sector
when a PC starts up. In the normal use case these values will be as set up by
the BIOS before it starts the first piece of user-written code.

Each BIOS will be different. This code helps a boot sector writer to survey the
choices different BIOSes make. Comparing the results from different machines
helps to show what parameters code in a boot sector can expect and which it
cannot rely on.

For some sample results see

  http://aodfaq.wikispaces.com/machine+characteristics

Some of the relevant information that this program reports is follows.

* Flags register: DF (direction flag), IF (interrupt-enable flag)
* Start address: usually 0:7c00 but may be 07c0:0 or other
* Stack top: where the initial stack sits
* Data segment registers
* BIOS boot drive id in DL (may not be valid)


Prerequisites
=============

* Nasm assembler
  - May be built in to Unix or installable as a package
  - For Windows or DOS see http://www.nasm.us/

* A program to write the assembled code to a boot sector
  - For Unix use dd
  - For Windows use http://www.chrysocome.net/dd or similar
  - For DOS use http://codewiki.wikispaces.com/jsys.nasm or similar


Installation
============

* Follow the instructions at the top of bootregs.nasm to assemble the
  code and to write it to a floppy disk but be very careful when using
  dd to ensure that you do not overwrite any boot sector that you
  do not intend to.


Running the program
===================

Once the program has been written to a floppy boot sector use it to boot a
PC. The results will be printed on screen.


See also
========

https://github.com/jh-1/bootregs
