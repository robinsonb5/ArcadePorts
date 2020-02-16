	//registers used:
		//r1: yes
		//r2: yes
		//r3: no
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_SendBlock
_SendBlock:
	exg	r6
	stmpdec	r6
	exg	r6
				// allocreg r2
					// (a/p assign)
					// (prepobj r0)
 // reg r2 - no need to prep
					// (objtotemp) flags 102 
// var, auto|reg
		//sizemod based on type 0x3
	.liconst	8
	ldidx	r6
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r1

	//main.c, line 28
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 42 
// reg r2 - don't bother matching
	mt	r2
					// (save temp) isreg
	mr	r1
				//save_temp done

	//main.c, line 28
					// (bitwise/arithmetic) 	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r2
					// (save result) // isreg

	//main.c, line 28
					// (test)
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	and	r1
				// freereg r1

	//main.c, line 28
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l6
		add	r7
l5: # 

	//main.c, line 30
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2a 
// deref 
					// (prepobj tmp)
 // deref
				// var FIXME - deref?// reg 
	.liconst	4
	ldidx	r6
		//sizemod based on type 0x201
	byt
	ldt
//marker 2
	mr	r0
	.liconst	-128
	add	r0
	xor	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // deref
			// const
	.liconst	-4
	exg	r0
	st	r0
	exg	r0

	//main.c, line 30
					// (bitwise/arithmetic) 	//ops: 0, 0, 1
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x3
	.liconst	4
	ldidx	r6
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r0
					// (save result) // Store_reg to type 0xa
					// (prepobj tmp)
 // var, auto|reg
	.liconst	8
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// allocreg r1

	//main.c, line 28
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 42 
// reg r2 - don't bother matching
	mt	r2
					// (save temp) isreg
	mr	r1
				//save_temp done

	//main.c, line 28
					// (bitwise/arithmetic) 	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r2
					// (save result) // isreg

	//main.c, line 28
					// (test)
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	and	r1
				// freereg r1

	//main.c, line 28
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l5
		add	r7
l6: # 
				// freereg r2
	.lipcrel	.functiontail, 6
	add	r7
.functiontail:
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

	//registers used:
		//r1: yes
		//r2: no
		//r3: yes
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_SendFile
_SendFile:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	exg	r6
				// allocreg r3

	//main.c, line 40
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0xa
	.liconst	8
	ldidx	r6
	stdec	r6

	//main.c, line 40
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_file
// extern pe is varadr
	stdec	r6

	//main.c, line 40
					//call
			//pcreltotemp
	.lipcrel	_FileOpen
	add	r7
	.liconst	8
	add	r6

				// allocreg r1

	//main.c, line 40
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//main.c, line 40
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l9
		add	r7
				// allocreg r1

	//main.c, line 42
					//FIXME convert
					// (convert - reducing type 103 to 3
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 2 
// extern
	.liabs	_file, 4
		//sizemod based on type 0x3
	//extern deref
	ldt
					// (save temp) isreg
	mr	r3
				//save_temp done
					//No need to mask - same size

	//main.c, line 44
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l10,0
// static pe is varadr
	stdec	r6

	//main.c, line 44
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//main.c, line 51
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-8
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	1
					// (save temp) store
	st	r0
				//save_temp done

	//main.c, line 53
					// (test)
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	and	r3

	//main.c, line 53
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l22
		add	r7
				// freereg r1
l21: # 

	//main.c, line 55
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_sector_buffer
// extern pe is varadr
	stdec	r6

	//main.c, line 55
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
//extern: comparing 0 with 0
					// (prepobj tmp)
 //extern: comparing 0 with 0
// extern (offset 0)
	.liabs	_file
// extern pe is varadr
	stdec	r6

	//main.c, line 55
					//call
			//pcreltotemp
	.lipcrel	_FileRead
	add	r7
	.liconst	8
	add	r6

				// allocreg r1

	//main.c, line 55
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//main.c, line 55
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l15
		add	r7
				// allocreg r1

	//main.c, line 56
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0

	//main.c, line 57
			//pcreltotemp
	.lipcrel	l7
	add	r7
l15: # 

	//main.c, line 57
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_file
// extern pe is varadr
	stdec	r6

	//main.c, line 57
					//call
			//pcreltotemp
	.lipcrel	_FileNextSector
	add	r7
	.liconst	4
	add	r6


	//main.c, line 59
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	512
	sgn
	cmp	r3

	//main.c, line 59
	cond	SLT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l17
		add	r7

	//main.c, line 61
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	512
					// (save temp) isreg
	mr	r1
				//save_temp done

	//main.c, line 62
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 

// required value found in tmp
	sub	r3
					// (save result) // isreg

	//main.c, line 65
			//pcreltotemp
	.lipcrel	l18
	add	r7
l17: # 

	//main.c, line 66
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
					// (save temp) isreg
	mr	r1
				//save_temp done

	//main.c, line 67
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) isreg
	mr	r3
				//save_temp done
l18: # 

	//main.c, line 69
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r1 - don't bother matching
	mt	r1
	stdec	r6

	//main.c, line 69
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_sector_buffer
// extern pe is varadr
	stdec	r6

	//main.c, line 69
					//call
			//pcreltotemp
	.lipcrel	_SendBlock
	add	r7
	.liconst	8
	add	r6


	//main.c, line 53
					// (test)
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	and	r3

	//main.c, line 53
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l21
		add	r7
				// freereg r1
l22: # 
				// allocreg r1

	//main.c, line 71
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-8
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	st	r0
				//save_temp done

	//main.c, line 78
			//pcreltotemp
	.lipcrel	l19
	add	r7
l9: # 

	//main.c, line 79
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0xa
	.liconst	8
	ldidx	r6
	stdec	r6

	//main.c, line 79
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l20,0
// static pe is varadr
	stdec	r6

	//main.c, line 79
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6


	//main.c, line 80
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0

	//main.c, line 81
			//pcreltotemp
	.lipcrel	l7
	add	r7
l19: # 

	//main.c, line 82
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	1
	mr	r0
l7: # 
				// freereg r1
				// freereg r3
	.lipcrel	.functiontail, 4
	add	r7
	.section	.rodata
l10:
	.byte	79
	.byte	112
	.byte	101
	.byte	110
	.byte	101
	.byte	100
	.byte	32
	.byte	102
	.byte	105
	.byte	108
	.byte	101
	.byte	44
	.byte	32
	.byte	108
	.byte	111
	.byte	97
	.byte	100
	.byte	105
	.byte	110
	.byte	103
	.byte	46
	.byte	46
	.byte	46
	.byte	10
	.byte	0
l20:
	.byte	67
	.byte	97
	.byte	110
	.byte	39
	.byte	116
	.byte	32
	.byte	111
	.byte	112
	.byte	101
	.byte	110
	.byte	32
	.byte	37
	.byte	115
	.byte	10
	.byte	0
	//registers used:
		//r1: yes
		//r2: no
		//r3: no
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_spin
_spin:
	stdec	r6
				// allocreg r1

	//main.c, line 89
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) isreg
	mr	r1
				//save_temp done
l28: # 

	//main.c, line 90
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r1
					// (save result) // isreg

	//main.c, line 90
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	1024
	sgn
	cmp	r1

	//main.c, line 90
	cond	SLT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l28
		add	r7
				// freereg r1
	.lipcrel	.functiontail, 6
	add	r7
	//registers used:
		//r1: yes
		//r2: no
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_main
_main:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	stdec	r6	// shortest way to decrement sp by 4
				// allocreg r5
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	-44
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
				// allocreg r3
				// allocreg r1

	//main.c, line 99
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l31,0
// static pe is varadr
	stdec	r6

	//main.c, line 99
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//main.c, line 100
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 0)
	.liabs	_filename
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done

	//main.c, line 102
					// (bitwise/arithmetic) 	//ops: 0, 0, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	32768
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//main.c, line 102
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//main.c, line 102
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l71
		add	r7
l66: # 

	//main.c, line 102
					// (bitwise/arithmetic) 	//ops: 0, 0, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	32768
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//main.c, line 102
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//main.c, line 102
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l66
		add	r7
l71: # 

	//main.c, line 102
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-48
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	33
					// (save temp) store
	st	r0
				//save_temp done

	//main.c, line 103
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	20
					// (save temp) store
	st	r5
				//save_temp done

	//main.c, line 104
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) isreg
	mr	r3
				//save_temp done

	//main.c, line 105
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r5
				//save_temp done

	//main.c, line 105
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 260 
// deref 
	ld	r5
					// (save temp) isreg
	mr	r4
				//save_temp done

	//main.c, line 105
					// (test)
					// (objtotemp) flags 42 
// reg r4 - don't bother matching
	mt	r4
	and	r4

	//main.c, line 105
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l72
		add	r7
				// freereg r1
l67: # 
				// allocreg r1

	//main.c, line 107
					// (bitwise/arithmetic) 	//ops: 0, 4, 2
					// (objtotemp) flags 82 
					// (prepobj r1)
 // extern (offset 0)
	.liabs	_filename
// extern pe is varadr
	mr	r1
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	add	r1
					// (save result) // isreg

	//main.c, line 107
					//FIXME convert
					// (convert - reducing type 3 to 1
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 42 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done
	.liconst	255
	and	r0
				// freereg r1

	//main.c, line 108
					//call
			//pcreltotemp
	.lipcrel	_spin
	add	r7


	//main.c, line 109
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r4 - don't bother matching
	mt	r4
	stdec	r6

	//main.c, line 109
					//call
			//pcreltotemp
	.lipcrel	_putchar
	add	r7
	.liconst	4
	add	r6


	//main.c, line 110
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	59
	cmp	r4

	//main.c, line 110
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l39
		add	r7
				// allocreg r1

	//main.c, line 112
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	8
	sgn
	cmp	r3

	//main.c, line 112
	cond	GE
					//conditional branch regular			//pcreltotemp
	.lipcrel	l41
		add	r7
				// freereg r1
l68: # 
				// allocreg r1

	//main.c, line 115
					// (bitwise/arithmetic) 	//ops: 0, 4, 2
					// (objtotemp) flags 82 
					// (prepobj r1)
 // extern (offset 0)
	.liabs	_filename
// extern pe is varadr
	mr	r1
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	add	r1
					// (save result) // isreg

	//main.c, line 115
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	32
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done
				// freereg r1

	//main.c, line 115
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r3
					// (save result) // isreg

	//main.c, line 115
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	8
	sgn
	cmp	r3

	//main.c, line 115
	cond	SLT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l68
		add	r7
				// allocreg r1

	//main.c, line 117
			//pcreltotemp
	.lipcrel	l48
	add	r7
l41: # 

	//main.c, line 117
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	8
	sgn
	cmp	r3

	//main.c, line 117
	cond	LE
					//conditional branch regular			//pcreltotemp
	.lipcrel	l48
		add	r7

	//main.c, line 119
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 6)
	.liabs	_filename, 6
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	126
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done

	//main.c, line 120
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 7)
	.liabs	_filename, 7
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	49
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done
l48: # 

	//main.c, line 122
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 8)
	.liabs	_filename, 8
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	82
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done

	//main.c, line 123
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 9)
	.liabs	_filename, 9
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	79
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done

	//main.c, line 124
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 10)
	.liabs	_filename, 10
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	77
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done

	//main.c, line 125
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 11)
	.liabs	_filename, 11
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done

	//main.c, line 126
			//pcreltotemp
	.lipcrel	l72
	add	r7
l39: # 

	//main.c, line 128
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r3
					// (save result) // isreg

	//main.c, line 105
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r5
				//save_temp done

	//main.c, line 105
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 260 
// deref 
	ld	r5
					// (save temp) isreg
	mr	r4
				//save_temp done

	//main.c, line 105
					// (test)
					// (objtotemp) flags 42 
// reg r4 - don't bother matching
	mt	r4
	and	r4

	//main.c, line 105
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l67
		add	r7
				// freereg r1
l72: # 
				// allocreg r1

	//main.c, line 130
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r5
				//save_temp done

	//main.c, line 130
					// (test)
					// (objtotemp) flags 260 
// deref 
	ld	r5

	//main.c, line 130
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l74
		add	r7
				// freereg r1
l69: # 

	//main.c, line 130
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r5
				//save_temp done
				// allocreg r1

	//main.c, line 130
					//FIXME convert
					// (convert - reducing type 503 to 3
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 260 
// deref 
	ld	r5
					// (save temp) isreg
	mr	r1
				//save_temp done
					//No need to mask - same size

	//main.c, line 130
					// (test)
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	and	r1
				// freereg r1

	//main.c, line 130
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l69
		add	r7
l74: # 
				// allocreg r1

	//main.c, line 132
					// (bitwise/arithmetic) 	//ops: 0, 0, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	32768
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//main.c, line 132
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//main.c, line 132
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l75
		add	r7
l70: # 

	//main.c, line 132
					// (bitwise/arithmetic) 	//ops: 0, 0, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	32768
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//main.c, line 132
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//main.c, line 132
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l70
		add	r7
l75: # 
				// freereg r1

	//main.c, line 132
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-48
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	32
					// (save temp) store
	st	r0
				//save_temp done

	//main.c, line 134
					//call
			//pcreltotemp
	.lipcrel	_spin
	add	r7


	//main.c, line 135
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_filename
// extern pe is varadr
	stdec	r6

	//main.c, line 135
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//main.c, line 137
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l55,0
// static pe is varadr
	stdec	r6

	//main.c, line 137
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//main.c, line 138
					//call
			//pcreltotemp
	.lipcrel	_spi_init
	add	r7

				// allocreg r1

	//main.c, line 138
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//main.c, line 138
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l58
		add	r7

	//main.c, line 138
					//call
			//pcreltotemp
	.lipcrel	_FindDrive
	add	r7

				// allocreg r1

	//main.c, line 138
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//main.c, line 138
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l58
		add	r7
				// allocreg r1

	//main.c, line 138
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	1
					// (save temp) isreg
	mr	r1
				//save_temp done

	//main.c, line 138
			//pcreltotemp
	.lipcrel	l59
	add	r7
l58: # 

	//main.c, line 138
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) isreg
	mr	r1
				//save_temp done
l59: # 

	//main.c, line 140
					// (test)
					// (objtotemp) flags 42 
// reg r1 - don't bother matching
	mt	r1
	and	r1

	//main.c, line 140
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l61
		add	r7
				// freereg r1

	//main.c, line 140
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_filename
// extern pe is varadr
	stdec	r6

	//main.c, line 140
					//call
			//pcreltotemp
	.lipcrel	_SendFile
	add	r7
	.liconst	4
	add	r6

				// allocreg r1

	//main.c, line 140
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//main.c, line 140
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l61
		add	r7
				// allocreg r1

	//main.c, line 142
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l63,0
// static pe is varadr
	stdec	r6

	//main.c, line 142
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//main.c, line 145
			//pcreltotemp
	.lipcrel	l64
	add	r7
l61: # 

	//main.c, line 145
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l65,0
// static pe is varadr
	stdec	r6

	//main.c, line 145
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6

l64: # 

	//main.c, line 147
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0
				// freereg r1
				// freereg r3
				// freereg r4
				// freereg r5
	ldinc	r6	// shortest way to add 4 to sp
	.lipcrel	.functiontail, 0
	add	r7
l63:
	.byte	68
	.byte	111
	.byte	110
	.byte	101
	.byte	10
	.byte	0
l31:
	.byte	70
	.byte	101
	.byte	116
	.byte	99
	.byte	104
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	99
	.byte	111
	.byte	110
	.byte	102
	.byte	32
	.byte	115
	.byte	116
	.byte	114
	.byte	105
	.byte	110
	.byte	103
	.byte	10
	.byte	0
l55:
	.byte	73
	.byte	110
	.byte	105
	.byte	116
	.byte	105
	.byte	97
	.byte	108
	.byte	105
	.byte	122
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	83
	.byte	68
	.byte	32
	.byte	99
	.byte	97
	.byte	114
	.byte	100
	.byte	10
	.byte	0
l65:
	.byte	83
	.byte	68
	.byte	32
	.byte	98
	.byte	111
	.byte	111
	.byte	116
	.byte	32
	.byte	102
	.byte	97
	.byte	105
	.byte	108
	.byte	101
	.byte	100
	.byte	10
	.byte	0
	.section	.bss
	.global	_file
	.comm	_file,12
	.global	_filename
	.comm	_filename,16
