	.global	_pausecpu
_pausecpu:
	cond	NEX	// CPU will sleep until the next interrupt.
	mr	r7	// Might be lost, so repeat
	mr	r7

