
.\target\MaxHook.runtime-unpacked.dll:	file format coff-x86-64

Disassembly of section .text:

0000000180010000 <.text>:
18033ef60: e9 90 b9 39 01              	jmp	0x1816da8f5
18033ef65: 50                          	pushq	%rax
18033ef66: d8 55 e5                    	fcoms	-0x1b(%rbp)
18033ef69: af                          	scasl	%es:(%rdi), %eax
18033ef6a: 94                          	xchgl	%esp, %eax
18033ef6b: 2e 76 e8                    	jbe	0x18033ef56 <.text+0x32ef56>
18033ef6e: 5d                          	popq	%rbp
18033ef6f: 3b bb e2 e7 a0 14           	cmpl	0x14a0e7e2(%rbx), %edi
18033ef75: 68 9b ae 23 0c              	pushq	$0xc23ae9b              # imm = 0xC23AE9B
18033ef7a: fe e1                       	<unknown>
18033ef7c: 75 11                       	jne	0x18033ef8f <.text+0x32ef8f>
18033ef7e: 58                          	popq	%rax
18033ef7f: f0                          	lock
18033ef80: d8 38                       	fdivrs	(%rax)
18033ef82: 27                          	<unknown>
18033ef83: 59                          	popq	%rcx
18033ef84: 20 a9 61 09 d1 ed           	andb	%ch, -0x122ef69f(%rcx)
18033ef8a: fd                          	std
18033ef8b: 8d 5c 0e 9c                 	leal	-0x64(%rsi,%rcx), %ebx
18033ef8f: 33 90 93 63 29 e7           	xorl	-0x18d69c6d(%rax), %edx
18033ef95: 78 05                       	js	0x18033ef9c <.text+0x32ef9c>
18033ef97: 8a cd                       	movb	%ch, %cl
18033ef99: 37                          	<unknown>
18033ef9a: cb                          	lretl
18033ef9b: 0a 68 e4                    	orb	-0x1c(%rax), %ch
18033ef9e: ef                          	outl	%eax, %dx
18033ef9f: ad                          	lodsl	(%rsi), %eax
18033efa0: f9                          	stc
18033efa1: 00 5a d9                    	addb	%bl, -0x27(%rdx)
18033efa4: 50                          	pushq	%rax
18033efa5: f9                          	stc
18033efa6: 53                          	pushq	%rbx
18033efa7: 44 ca bc b0                 	lretl	$-0x4f44                # imm = 0xB0BC
18033efab: 9d                          	popfq
18033efac: 7c bc                       	jl	0x18033ef6a <.text+0x32ef6a>
18033efae: 00 52 4d                    	addb	%dl, 0x4d(%rdx)
18033efb1: 33 48 c9                    	xorl	-0x37(%rax), %ecx
18033efb4: 99                          	cltd
18033efb5: 61                          	<unknown>
18033efb6: a9 c6 d3 32 62              	testl	$0x6232d3c6, %eax       # imm = 0x6232D3C6
18033efbb: 8c 3b                       	<unknown>
18033efbd: 35 40 10 5d 2f              	xorl	$0x2f5d1040, %eax       # imm = 0x2F5D1040
18033efc2: b4 85                       	movb	$-0x7b, %ah
18033efc4: f7 47 f7 01 ab 79 f7        	testl	$0xf779ab01, -0x9(%rdi) # imm = 0xF779AB01
18033efcb: 43 45 b4 f2                 	movb	$-0xe, %r12b
18033efcf: f2 da 94 af 34 08 75 f5     	repne		ficoml	-0xa8af7cc(%rdi,%rbp,4)
18033efd7: cd 23                       	int	$0x23
18033efd9: 49 ea                       	<unknown>
18033efdb: 8c b5 f0 2c f7 56           	<unknown>
18033efe1: 50                          	pushq	%rax
18033efe2: 38 3d cd 07 d8 12           	cmpb	%bh, 0x12d807cd(%rip)   # 0x1930bf7b5
18033efe8: a1 2c c3 41 23 d0 3d aa 79  	movabsl	0x79aa3dd02341c32c, %eax
18033eff1: f4                          	hlt
18033eff2: 2a 38                       	subb	(%rax), %bh
18033eff4: f0                          	lock
18033eff5: 53                          	pushq	%rbx
18033eff6: 78 90                       	js	0x18033ef88 <.text+0x32ef88>
18033eff8: f2 be 96 48 88 1f           	repne		movl	$0x1f884896, %esi # imm = 0x1F884896
18033effe: 47 88 4a 6b                 	movb	%r9b, 0x6b(%r10)
18033f002: e5 35                       	inl	$0x35, %eax
18033f004: e7 5f                       	outl	%eax, $0x5f
18033f006: 10 8f 0f 25 4a f4           	adcb	%cl, -0xbb5daf1(%rdi)
18033f00c: 21 92 09 ab 38 52           	andl	%edx, 0x5238ab09(%rdx)
18033f012: 8f 77 83                    	<unknown>
18033f015: a8 fd                       	testb	$-0x3, %al
18033f017: 65 8d cd                    	<unknown>
18033f01a: f1                          	<unknown>
18033f01b: 13 bb 0d d4 2a 66           	adcl	0x662ad40d(%rbx), %edi
18033f021: f6 03 06                    	testb	$0x6, (%rbx)
18033f024: 30 33                       	xorb	%dh, (%rbx)
18033f026: cd b2                       	int	$0xb2
18033f028: bb eb 65 6b 0e              	movl	$0xe6b65eb, %ebx        # imm = 0xE6B65EB
18033f02d: 6a 75                       	pushq	$0x75
18033f02f: 08 e8                       	orb	%ch, %al
18033f031: 48 7b 03                    	jnp	0x18033f037 <.text+0x32f037>
18033f034: 59                          	popq	%rcx
18033f035: 0d d7 d4 00 93              	orl	$0x9300d4d7, %eax       # imm = 0x9300D4D7
18033f03a: c5 bb 16                    	<unknown>
18033f03d: 0f 47 e1                    	cmoval	%ecx, %esp
18033f040: f5                          	cmc
18033f041: df 94 fd 10 b4 7c 54        	fists	0x547cb410(%rbp,%rdi,8)
18033f048: 74 d8                       	je	0x18033f022 <.text+0x32f022>
18033f04a: 04 fb                       	addb	$-0x5, %al
18033f04c: 4f c3                       	retq
18033f04e: 81 0a c7 28 99 7c           	orl	$0x7c9928c7, (%rdx)     # imm = 0x7C9928C7
18033f054: 8e e9                       	movl	%ecx, %gs
18033f056: 48 d3 5e 37                 	rcrq	%cl, 0x37(%rsi)
18033f05a: 93                          	xchgl	%ebx, %eax
18033f05b: 0c 9e                       	orb	$-0x62, %al
18033f05d: fb                          	sti
18033f05e: d9 2c 4e                    	fldcw	(%rsi,%rcx,2)
18033f061: b0 dc                       	movb	$-0x24, %al
18033f063: 9a                          	<unknown>
18033f064: f5                          	cmc
18033f065: b4 0c                       	movb	$0xc, %ah
18033f067: c7 50 56                    	<unknown>
18033f06a: 21 e2                       	andl	%esp, %edx
18033f06c: 09 84 cf 83 6c d4 5e        	orl	%eax, 0x5ed46c83(%rdi,%rcx,8)
18033f073: cd ec                       	int	$0xec
18033f075: 12 c4                       	adcb	%ah, %al
18033f077: bf 4b ab 3d 25              	movl	$0x253dab4b, %edi       # imm = 0x253DAB4B
18033f07c: f9                          	stc
18033f07d: 6e                          	outsb	(%rsi), %dx
18033f07e: a8 c8                       	testb	$-0x38, %al
18033f080: c0 87 a6 fe c6 5b c1        	rolb	$0xc1, 0x5bc6fea6(%rdi)
18033f087: 57                          	pushq	%rdi
18033f088: 8a ef                       	movb	%bh, %ch
18033f08a: f0                          	lock
18033f08b: dc 88 75 bb e5 3e           	fmull	0x3ee5bb75(%rax)
18033f091: ae                          	scasb	%es:(%rdi), %al
18033f092: ea                          	<unknown>
18033f093: fc                          	cld
18033f094: df 5d 3d                    	fistps	0x3d(%rbp)
18033f097: 46 1b 0e                    	sbbl	(%rsi), %r9d
18033f09a: 23 38                       	andl	(%rax), %edi
18033f09c: 7b 1b                       	jnp	0x18033f0b9 <.text+0x32f0b9>
18033f09e: 3c 74                       	cmpb	$0x74, %al
18033f0a0: fa                          	cli
18033f0a1: f4                          	hlt
18033f0a2: 6e                          	outsb	(%rsi), %dx
18033f0a3: df ac b7 54 26 1b 1d        	fildll	0x1d1b2654(%rdi,%rsi,4)
18033f0aa: 7a 0d                       	jp	0x18033f0b9 <.text+0x32f0b9>
18033f0ac: 60                          	<unknown>
18033f0ad: 81 c4 3e f5 a6 00           	addl	$0xa6f53e, %esp         # imm = 0xA6F53E
18033f0b3: b2 4e                       	movb	$0x4e, %dl
18033f0b5: e9 de 0b 3e 7f              	jmp	0x1ff71fc98
18033f0ba: d3 45 c4                    	roll	%cl, -0x3c(%rbp)
18033f0bd: 34 d3                       	xorb	$-0x2d, %al
18033f0bf: ed                          	inl	%dx, %eax
18033f0c0: dc 2c e3                    	fsubrl	(%rbx,%riz,8)
18033f0c3: a9 3d c0 d4 c4              	testl	$0xc4d4c03d, %eax       # imm = 0xC4D4C03D
18033f0c8: 74 ec                       	je	0x18033f0b6 <.text+0x32f0b6>
18033f0ca: a4                          	movsb	(%rsi), %es:(%rdi)
18033f0cb: a0 4d be b3 74 3b 02 06 bf  	movabsb	-0x40f9fdc48b4c41b3, %al
18033f0d4: 8f 5c 94                    	<unknown>
18033f0d7: 6e                          	outsb	(%rsi), %dx
18033f0d8: 5f                          	popq	%rdi
18033f0d9: 80 c6 c3                    	addb	$-0x3d, %dh
18033f0dc: 9e                          	sahf
18033f0dd: 30 f1                       	xorb	%dh, %cl
18033f0df: 2d d6 97 05 70              	subl	$0x700597d6, %eax       # imm = 0x700597D6
18033f0e4: 04 1a                       	addb	$0x1a, %al
18033f0e6: c6 f0                       	<unknown>
18033f0e8: 8d 8c 00 38 63 cd 17        	leal	0x17cd6338(%rax,%rax), %ecx
18033f0ef: 20 56 5f                    	andb	%dl, 0x5f(%rsi)
18033f0f2: 56                          	pushq	%rsi
18033f0f3: e0 60                       	loopne	0x18033f155 <.text+0x32f155>
18033f0f5: cf                          	iretl
18033f0f6: a0 b5 dc 5d 9c 09 43 d3 7a  	movabsb	0x7ad343099c5ddcb5, %al
18033f0ff: d0 35 3a 45 04 71           	<unknown>
18033f105: a8 84                       	testb	$-0x7c, %al
18033f107: a5                          	movsl	(%rsi), %es:(%rdi)
18033f108: b4 a0                       	movb	$-0x60, %ah
18033f10a: a9 5b 85 74 10              	testl	$0x1074855b, %eax       # imm = 0x1074855B
18033f10f: fa                          	cli
18033f110: e2 ce                       	loop	0x18033f0e0 <.text+0x32f0e0>
18033f112: 20 18                       	andb	%bl, (%rax)
18033f114: 92                          	xchgl	%edx, %eax
18033f115: 2a 1a                       	subb	(%rdx), %bl
18033f117: ce                          	<unknown>
18033f118: cb                          	lretl
18033f119: 6a 31                       	pushq	$0x31
18033f11b: e2 d5                       	loop	0x18033f0f2 <.text+0x32f0f2>
18033f11d: d8 cd                       	fmul	%st(5), %st
18033f11f: de 32                       	fidivs	(%rdx)
18033f121: ca 1e d1                    	lretl	$-0x2ee2                # imm = 0xD11E
18033f124: 46 76 6a                    	jbe	0x18033f191 <.text+0x32f191>
18033f127: 4c c2 b8 d1                 	retq	$-0x2e48                # imm = 0xD1B8
18033f12b: 9f                          	lahf
18033f12c: b6 1b                       	movb	$0x1b, %dh
18033f12e: 66 2a e1                    	subb	%cl, %ah
18033f131: de ed                       	fsubrp	%st, %st(5)
18033f133: 2e 47 7b 6a                 	jnp	0x18033f1a1 <.text+0x32f1a1>
18033f137: 52                          	pushq	%rdx
18033f138: 95                          	xchgl	%ebp, %eax
18033f139: 56                          	pushq	%rsi
18033f13a: a0 d0 37 8f af 6c 72 fe 65  	movabsb	0x65fe726caf8f37d0, %al
18033f143: cf                          	iretl
18033f144: 02 09                       	addb	(%rcx), %cl
18033f146: 84 0f                       	testb	%cl, (%rdi)
18033f148: 32 aa de 43 c3 1c           	xorb	0x1cc343de(%rdx), %ch
18033f14e: 93                          	xchgl	%ebx, %eax
18033f14f: c2 bd 76                    	retq	$0x76bd                 # imm = 0x76BD
18033f152: ac                          	lodsb	(%rsi), %al
18033f153: 47 56                       	pushq	%r14
18033f155: f5                          	cmc
18033f156: aa                          	stosb	%al, %es:(%rdi)
18033f157: 30 4f e4                    	xorb	%cl, -0x1c(%rdi)
18033f15a: 99                          	cltd
18033f15b: 8f 6e 48                    	<unknown>
18033f15e: 68 17 e1 3e e7              	pushq	$-0x18c11ee9            # imm = 0xE73EE117
18033f163: 63 f2                       	movslq	%edx, %esi
18033f165: bf 0d f1 12 10              	movl	$0x1012f10d, %edi       # imm = 0x1012F10D
18033f16a: 87 83 98 1a a0 3d           	xchgl	%eax, 0x3da01a98(%rbx)
18033f170: 1b 7c cb a8                 	sbbl	-0x58(%rbx,%rcx,8), %edi
18033f174: 83 3d c0 49 81 bd 6a        	cmpl	$0x6a, -0x427eb640(%rip) # 0x13db53b3b
18033f17b: 39 84 ef 11 7a 2a ba        	cmpl	%eax, -0x45d585ef(%rdi,%rbp,8)
18033f182: 1e                          	<unknown>
18033f183: 68 24 56 9c 90              	pushq	$-0x6f63a9dc            # imm = 0x909C5624
18033f188: 1b 3d f6 3c 2b 73           	sbbl	0x732b3cf6(%rip), %edi  # 0x1f35f2e84
18033f18e: 7f 42                       	jg	0x18033f1d2 <.text+0x32f1d2>
18033f190: c7 25 89 06 4a 97           	<unknown>
18033f196: 3a b1 90 fd d2 5a           	cmpb	0x5ad2fd90(%rcx), %dh
18033f19c: 43 b5 7d                    	movb	$0x7d, %r13b
18033f19f: 93                          	xchgl	%ebx, %eax
18033f1a0: 3d 40 80 33 a1              	cmpl	$0xa1338040, %eax       # imm = 0xA1338040
18033f1a5: be ee 30 6d 7e              	movl	$0x7e6d30ee, %esi       # imm = 0x7E6D30EE
18033f1aa: a6                          	cmpsb	%es:(%rdi), (%rsi)
18033f1ab: 04 bd                       	addb	$-0x43, %al
18033f1ad: 6a a3                       	pushq	$-0x5d
18033f1af: bd fb 46 61 84              	movl	$0x846146fb, %ebp       # imm = 0x846146FB
18033f1b4: ad                          	lodsl	(%rsi), %eax
18033f1b5: 97                          	xchgl	%edi, %eax
18033f1b6: b4 e7                       	movb	$-0x19, %ah
18033f1b8: da d4                       	fcmovbe	%st(4), %st
18033f1ba: ad                          	lodsl	(%rsi), %eax
18033f1bb: 29 b4 54 72 7c f4 0e        	subl	%esi, 0xef47c72(%rsp,%rdx,2)
18033f1c2: 5e                          	popq	%rsi
18033f1c3: 9c                          	pushfq
18033f1c4: 0c a3                       	orb	$-0x5d, %al
18033f1c6: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033f1c7: e0 dd                       	loopne	0x18033f1a6 <.text+0x32f1a6>
18033f1c9: fc                          	cld
18033f1ca: d4                          	<unknown>
18033f1cb: 32 d8                       	xorb	%al, %bl
18033f1cd: 31 4f 5a                    	xorl	%ecx, 0x5a(%rdi)
18033f1d0: de 35 f4 d1 80 4a           	fidivs	0x4a80d1f4(%rip)        # 0x1cab4c3ca
18033f1d6: bd b6 b2 d4 de              	movl	$0xded4b2b6, %ebp       # imm = 0xDED4B2B6
18033f1db: 07                          	<unknown>
18033f1dc: b4 6b                       	movb	$0x6b, %ah
18033f1de: 6e                          	outsb	(%rsi), %dx
18033f1df: 2b ad 84 7b 01 24           	subl	0x24017b84(%rbp), %ebp
18033f1e5: e8 07 3b 80 c2              	callq	0x142b42cf1
18033f1ea: 3f                          	<unknown>
18033f1eb: 0e                          	<unknown>
18033f1ec: 7a a7                       	jp	0x18033f195 <.text+0x32f195>
18033f1ee: 4d 8b 29                    	movq	(%r9), %r13
18033f1f1: 0e                          	<unknown>
18033f1f2: 56                          	pushq	%rsi
18033f1f3: 44 bb 5a 7d 90 61           	movl	$0x61907d5a, %ebx       # imm = 0x61907D5A
18033f1f9: 27                          	<unknown>
18033f1fa: f9                          	stc
18033f1fb: a4                          	movsb	(%rsi), %es:(%rdi)
18033f1fc: dd ba 4e 5f 23 24           	fnstsw	0x24235f4e(%rdx)
18033f202: 9f                          	lahf
18033f203: d5 6d ac                    	lodsb	(%rsi), %al
18033f206: 55                          	pushq	%rbp
18033f207: 2c 49                       	subb	$0x49, %al
18033f209: af                          	scasl	%es:(%rdi), %eax
18033f20a: 4d 4c ae                    	scasb	%es:(%rdi), %al
18033f20d: fa                          	cli
18033f20e: b6 aa                       	movb	$-0x56, %dh
18033f210: 89 fb                       	movl	%edi, %ebx
18033f212: 69 86 22 30 c2 e6 2b a7 55 63       	imull	$0x6355a72b, -0x193dcfde(%rsi), %eax # imm = 0x6355A72B
18033f21c: d9 5f fe                    	fstps	-0x2(%rdi)
18033f21f: ae                          	scasb	%es:(%rdi), %al
18033f220: cc                          	int3
18033f221: cd 75                       	int	$0x75
18033f223: 69 ab 5e 48 7b c1 2e 72 51 dd       	imull	$0xdd51722e, -0x3e84b7a2(%rbx), %ebp # imm = 0xDD51722E
18033f22d: 72 8a                       	jb	0x18033f1b9 <.text+0x32f1b9>
18033f22f: a4                          	movsb	(%rsi), %es:(%rdi)
18033f230: e9 81 27 4f a4              	jmp	0x1248319b6
18033f235: 26 fa                       	cli
18033f237: 34 c7                       	xorb	$-0x39, %al
18033f239: 61                          	<unknown>
18033f23a: fb                          	sti
18033f23b: 90                          	nop
18033f23c: 1c 1c                       	sbbb	$0x1c, %al
18033f23e: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033f23f: b4 18                       	movb	$0x18, %ah
18033f241: 98                          	cwtl
18033f242: 0b e0                       	orl	%eax, %esp
18033f244: d3 78 91                    	sarl	%cl, -0x6f(%rax)
18033f247: e9 c8 a4 80 ee              	jmp	0x16eb49714
18033f24c: e9 7d 1d 75 3f              	jmp	0x1bfa90fce
18033f251: 95                          	xchgl	%ebp, %eax
18033f252: 1c 58                       	sbbb	$0x58, %al
18033f254: 97                          	xchgl	%edi, %eax
18033f255: 32 0b                       	xorb	(%rbx), %cl
18033f257: 2c f8                       	subb	$-0x8, %al
18033f259: 3a 45 61                    	cmpb	0x61(%rbp), %al
18033f25c: d9 71 4d                    	fnstenv	0x4d(%rcx)
18033f25f: 37                          	<unknown>
18033f260: a4                          	movsb	(%rsi), %es:(%rdi)
18033f261: 6a c0                       	pushq	$-0x40
18033f263: 7c 36                       	jl	0x18033f29b <.text+0x32f29b>
18033f265: 5b                          	popq	%rbx
18033f266: fc                          	cld
18033f267: eb 9c                       	jmp	0x18033f205 <.text+0x32f205>
18033f269: 75 18                       	jne	0x18033f283 <.text+0x32f283>
18033f26b: 6d                          	insl	%dx, %es:(%rdi)
18033f26c: 3b 5a 16                    	cmpl	0x16(%rdx), %ebx
18033f26f: 33 b2 76 44 e3 db           	xorl	-0x241cbb8a(%rdx), %esi
18033f275: 53                          	pushq	%rbx
18033f276: 82                          	<unknown>
18033f277: 49 82                       	<unknown>
18033f279: a8 4c                       	testb	$0x4c, %al
18033f27b: b9 24 a8 2e a9              	movl	$0xa92ea824, %ecx       # imm = 0xA92EA824
18033f280: 84 6c fa 15                 	testb	%ch, 0x15(%rdx,%rdi,8)
18033f284: 24 9f                       	andb	$-0x61, %al
18033f286: 7e f8                       	jle	0x18033f280 <.text+0x32f280>
18033f288: ea                          	<unknown>
18033f289: 18 fc                       	sbbb	%bh, %ah
18033f28b: d9 8e 18 e2 74 ef           	<unknown>
18033f291: 82                          	<unknown>
18033f292: cf                          	iretl
18033f293: 16                          	<unknown>
18033f294: fd                          	std
18033f295: cd 9e                       	int	$0x9e
18033f297: a8 96                       	testb	$-0x6a, %al
18033f299: 52                          	pushq	%rdx
18033f29a: 00 63 0b                    	addb	%ah, 0xb(%rbx)
18033f29d: 72 0f                       	jb	0x18033f2ae <.text+0x32f2ae>
18033f29f: 91                          	xchgl	%ecx, %eax
18033f2a0: 97                          	xchgl	%edi, %eax
18033f2a1: bf f5 e3 e0 cf              	movl	$0xcfe0e3f5, %edi       # imm = 0xCFE0E3F5
18033f2a6: 74 9c                       	je	0x18033f244 <.text+0x32f244>
18033f2a8: 84 a9 33 e1 4a 21           	testb	%ch, 0x214ae133(%rcx)
18033f2ae: 9a                          	<unknown>
18033f2af: bc e0 bb cd ca              	movl	$0xcacdbbe0, %esp       # imm = 0xCACDBBE0
18033f2b4: d5 ac 9b d4                 	setnp	%spl
18033f2b8: 07                          	<unknown>
18033f2b9: be 03 54 ae f5              	movl	$0xf5ae5403, %esi       # imm = 0xF5AE5403
18033f2be: ee                          	outb	%al, %dx
18033f2bf: 77 26                       	ja	0x18033f2e7 <.text+0x32f2e7>
18033f2c1: df 7f 6e                    	fistpll	0x6e(%rdi)
18033f2c4: 65 55                       	pushq	%rbp
18033f2c6: 4e ab                       	stosq	%rax, %es:(%rdi)
18033f2c8: 9d                          	popfq
18033f2c9: 76 0e                       	jbe	0x18033f2d9 <.text+0x32f2d9>
18033f2cb: bd 72 9e 91 2f              	movl	$0x2f919e72, %ebp       # imm = 0x2F919E72
18033f2d0: 68 37 16 dd 1a              	pushq	$0x1add1637             # imm = 0x1ADD1637
18033f2d5: 8f 60 b2                    	<unknown>
18033f2d8: f6 c4 ee                    	testb	$-0x12, %ah
18033f2db: ee                          	outb	%al, %dx
18033f2dc: 80 c6 8e                    	addb	$-0x72, %dh
18033f2df: f2 89 cb                    	repne		movl	%ecx, %ebx
18033f2e2: 8f 27 7d                    	<unknown>
18033f2e5: d7                          	xlatb
18033f2e6: c1 bb b8 4c 98 51 fa        	sarl	$0xfa, 0x51984cb8(%rbx)
18033f2ed: 69 ce 03 bf e0 95           	imull	$0x95e0bf03, %esi, %ecx # imm = 0x95E0BF03
18033f2f3: 9c                          	pushfq
18033f2f4: df 91 57 e5 80 9e           	fists	-0x617f1aa9(%rcx)
18033f2fa: 67 1b d0                    	addr32		sbbl	%eax, %edx
18033f2fd: 75 28                       	jne	0x18033f327 <.text+0x32f327>
18033f2ff: af                          	scasl	%es:(%rdi), %eax
18033f300: cf                          	iretl
18033f301: de 00                       	fiadds	(%rax)
18033f303: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033f304: 24 00                       	andb	$0x0, %al
18033f306: e5 fa                       	inl	$0xfa, %eax
18033f308: f7 06 87 65 03 67           	testl	$0x67036587, (%rsi)     # imm = 0x67036587
18033f30e: 02 8d 82 71 df b3           	addb	-0x4c208e7e(%rbp), %cl
18033f314: de 00                       	fiadds	(%rax)
18033f316: d7                          	xlatb
18033f317: 7c 39                       	jl	0x18033f352 <.text+0x32f352>
18033f319: e8 77 e9 72 9f              	callq	0x11fa6dc95
18033f31e: 16                          	<unknown>
18033f31f: 99                          	cltd
18033f320: 5e                          	popq	%rsi
18033f321: 0a 52 db                    	orb	-0x25(%rdx), %dl
18033f324: 8b 0d 1e 12 56 18           	movl	0x1856121e(%rip), %ecx  # 0x1988a0548
18033f32a: cc                          	int3
18033f32b: 77 0b                       	ja	0x18033f338 <.text+0x32f338>
18033f32d: 04 2f                       	addb	$0x2f, %al
18033f32f: 9b                          	wait
18033f330: d2 40 34                    	rolb	%cl, 0x34(%rax)
18033f333: 70 25                       	jo	0x18033f35a <.text+0x32f35a>
18033f335: 52                          	pushq	%rdx
18033f336: 6d                          	insl	%dx, %es:(%rdi)
18033f337: d5 61 8c 31                 	<unknown>
18033f33b: da 1d 5f 97 55 37           	ficompl	0x3755975f(%rip)        # 0x1b7898aa0
18033f341: 99                          	cltd
18033f342: c6 e0                       	<unknown>
18033f344: ce                          	<unknown>
18033f345: ac                          	lodsb	(%rsi), %al
18033f346: e3 e1                       	jrcxz	0x18033f329 <.text+0x32f329>
18033f348: ee                          	outb	%al, %dx
18033f349: 3b 4f d6                    	cmpl	-0x2a(%rdi), %ecx
18033f34c: f0                          	lock
18033f34d: 09 d0                       	orl	%edx, %eax
18033f34f: 2e ae                       	scasb	%es:(%rdi), %al
18033f351: 62 c6 4c 48 d8              	<unknown>
18033f356: 95                          	xchgl	%ebp, %eax
18033f357: 9a                          	<unknown>
18033f358: 90                          	nop
18033f359: e4 15                       	inb	$0x15, %al
18033f35b: 13 36                       	adcl	(%rsi), %esi
18033f35d: ad                          	lodsl	(%rsi), %eax
18033f35e: 14 12                       	adcb	$0x12, %al
18033f360: c8 58 1b 43                 	enter	$0x1b58, $0x43          # imm = 0x1B58
18033f364: 4a eb 31                    	jmp	0x18033f398 <.text+0x32f398>
18033f367: 25 e3 13 3c 22              	andl	$0x223c13e3, %eax       # imm = 0x223C13E3
18033f36c: 78 8b                       	js	0x18033f2f9 <.text+0x32f2f9>
18033f36e: 25 d0 f2 d0 b1              	andl	$0xb1d0f2d0, %eax       # imm = 0xB1D0F2D0
18033f373: d2 7a 5d                    	sarb	%cl, 0x5d(%rdx)
18033f376: ca 7b a0                    	lretl	$-0x5f85                # imm = 0xA07B
18033f379: f8                          	clc
18033f37a: 1e                          	<unknown>
18033f37b: 42 79 e6                    	jns	0x18033f364 <.text+0x32f364>
18033f37e: 13 9d 47 27 d7 91           	adcl	-0x6e28d8b9(%rbp), %ebx
18033f384: 80 ef 1c                    	subb	$0x1c, %bh
18033f387: f4                          	hlt
18033f388: ae                          	scasb	%es:(%rdi), %al
18033f389: d8 52 b8                    	fcoms	-0x48(%rdx)
18033f38c: b8 81 63 94 66              	movl	$0x66946381, %eax       # imm = 0x66946381
18033f391: 8c 5b 45                    	movw	%ds, 0x45(%rbx)
18033f394: bb 11 33 40 9f              	movl	$0x9f403311, %ebx       # imm = 0x9F403311
18033f399: a9 cc 68 cb 8e              	testl	$0x8ecb68cc, %eax       # imm = 0x8ECB68CC
18033f39e: aa                          	stosb	%al, %es:(%rdi)
18033f39f: 6c                          	insb	%dx, %es:(%rdi)
18033f3a0: 88 32                       	movb	%dh, (%rdx)
18033f3a2: 1a 03                       	sbbb	(%rbx), %al
18033f3a4: c8 72 61 8b                 	enter	$0x6172, $-0x75         # imm = 0x6172
18033f3a8: 63 20                       	movslq	(%rax), %esp
18033f3aa: e6 58                       	outb	%al, $0x58
18033f3ac: 9d                          	popfq
18033f3ad: 98                          	cwtl
18033f3ae: 5b                          	popq	%rbx
18033f3af: 82                          	<unknown>
18033f3b0: 78 06                       	js	0x18033f3b8 <.text+0x32f3b8>
18033f3b2: 6a 4f                       	pushq	$0x4f
18033f3b4: 9b                          	wait
18033f3b5: 32 57 8d                    	xorb	-0x73(%rdi), %dl
18033f3b8: 60                          	<unknown>
18033f3b9: af                          	scasl	%es:(%rdi), %eax
18033f3ba: a2 80 64 0f 76 03 fb 5f 57  	movabsb	%al, 0x575ffb03760f6480
18033f3c3: d1 6f 26                    	shrl	0x26(%rdi)
18033f3c6: 80 32 ec                    	xorb	$-0x14, (%rdx)
18033f3c9: 6c                          	insb	%dx, %es:(%rdi)
18033f3ca: 59                          	popq	%rcx
18033f3cb: af                          	scasl	%es:(%rdi), %eax
18033f3cc: 1f                          	<unknown>
18033f3cd: 5c                          	popq	%rsp
18033f3ce: 16                          	<unknown>
18033f3cf: cb                          	lretl
18033f3d0: 1c ee                       	sbbb	$-0x12, %al
18033f3d2: 3a ae fe d6 a0 52           	cmpb	0x52a0d6fe(%rsi), %ch
18033f3d8: b9 5d 50 f7 7b              	movl	$0x7bf7505d, %ecx       # imm = 0x7BF7505D
18033f3dd: 83 f1 01                    	xorl	$0x1, %ecx
18033f3e0: 6e                          	outsb	(%rsi), %dx
18033f3e1: 13 69 94                    	adcl	-0x6c(%rcx), %ebp
18033f3e4: 65 89 77 e2                 	movl	%esi, %gs:-0x1e(%rdi)
18033f3e8: a9 23 ba cf f1              	testl	$0xf1cfba23, %eax       # imm = 0xF1CFBA23
18033f3ed: 64 6e                       	outsb	%fs:(%rsi), %dx
18033f3ef: 1e                          	<unknown>
18033f3f0: f8                          	clc
18033f3f1: 25 03 a4 50 6e              	andl	$0x6e50a403, %eax       # imm = 0x6E50A403
18033f3f6: f3 1f                       	<unknown>
18033f3f8: e2 0d                       	loop	0x18033f407 <.text+0x32f407>
18033f3fa: 88 b8 46 08 53 81           	movb	%bh, -0x7eacf7ba(%rax)
18033f400: 3f                          	<unknown>
18033f401: f6 35 58 09 bc 88           	divb	-0x7743f6a8(%rip)       # 0x108effd5f
18033f407: e4 e5                       	inb	$0xe5, %al
18033f409: 4b f1                       	<unknown>
18033f40b: 4b 24 9f                    	andb	$-0x61, %al
18033f40e: fe 2a                       	<unknown>
18033f410: e2 4a                       	loop	0x18033f45c <.text+0x32f45c>
18033f412: a9 47 55 73 b0              	testl	$0xb0735547, %eax       # imm = 0xB0735547
18033f417: 4f 58                       	popq	%r8
18033f419: d3 f2                       	<unknown>
18033f41b: 24 81                       	andb	$-0x7f, %al
18033f41d: a9 9c 7c 88 2c              	testl	$0x2c887c9c, %eax       # imm = 0x2C887C9C
18033f422: 84 12                       	testb	%dl, (%rdx)
18033f424: 6c                          	insb	%dx, %es:(%rdi)
18033f425: 5a                          	popq	%rdx
18033f426: 6a ee                       	pushq	$-0x12
18033f428: b8 c1 08 16 80              	movl	$0x801608c1, %eax       # imm = 0x801608C1
18033f42d: 1c 9f                       	sbbb	$-0x61, %al
18033f42f: da de                       	fcmovu	%st(6), %st
18033f431: 9d                          	popfq
18033f432: 45 4e ad                    	lodsq	(%rsi), %rax
18033f435: d4                          	<unknown>
18033f436: a3 d2 42 3e 5d a4 2e b6 2e  	movabsl	%eax, 0x2eb62ea45d3e42d2
18033f43f: 8b 89 be c9 2b 35           	movl	0x352bc9be(%rcx), %ecx
18033f445: b1 3f                       	movb	$0x3f, %cl
18033f447: 5b                          	popq	%rbx
18033f448: 9a                          	<unknown>
18033f449: 51                          	pushq	%rcx
18033f44a: 81 02 25 7a 55 d2           	addl	$0xd2557a25, (%rdx)     # imm = 0xD2557A25
18033f450: 16                          	<unknown>
18033f451: 9e                          	sahf
18033f452: b3 1e                       	movb	$0x1e, %bl
18033f454: e0 4e                       	loopne	0x18033f4a4 <.text+0x32f4a4>
18033f456: fb                          	sti
18033f457: 70 86                       	jo	0x18033f3df <.text+0x32f3df>
18033f459: 9c                          	pushfq
18033f45a: 99                          	cltd
18033f45b: df b0 ef b7 0e 60           	fbstp	0x600eb7ef(%rax)
18033f461: 6d                          	insl	%dx, %es:(%rdi)
18033f462: ce                          	<unknown>
18033f463: 8b a3 0f e3 3b 86           	movl	-0x79c41cf1(%rbx), %esp
18033f469: d1 03                       	roll	(%rbx)
18033f46b: 0f fd c5                    	paddw	%mm5, %mm0
18033f46e: 14 27                       	adcb	$0x27, %al
18033f470: 4d 7f 20                    	jg	0x18033f493 <.text+0x32f493>
18033f473: fb                          	sti
18033f474: 50                          	pushq	%rax
18033f475: 06                          	<unknown>
18033f476: 68 93 8b 9e 74              	pushq	$0x749e8b93             # imm = 0x749E8B93
18033f47b: 57                          	pushq	%rdi
18033f47c: bd 3d 58 01 67              	movl	$0x6701583d, %ebp       # imm = 0x6701583D
18033f481: d4                          	<unknown>
18033f482: e1 d6                       	loope	0x18033f45a <.text+0x32f45a>
18033f484: dc a4 05 0b 05 33 a2        	fsubl	-0x5dccfaf5(%rbp,%rax)
18033f48b: ed                          	inl	%dx, %eax
18033f48c: f3 fb                       	rep		sti
18033f48e: 82                          	<unknown>
18033f48f: 9d                          	popfq
18033f490: 97                          	xchgl	%edi, %eax
18033f491: 71 37                       	jno	0x18033f4ca <.text+0x32f4ca>
18033f493: 72 d5                       	jb	0x18033f46a <.text+0x32f46a>
18033f495: 97                          	xchgl	%edi, %eax
18033f496: 19 82 03 f4 6e 0d           	sbbl	%eax, 0xd6ef403(%rdx)
18033f49c: a6                          	cmpsb	%es:(%rdi), (%rsi)
18033f49d: ec                          	inb	%dx, %al
18033f49e: 30 67 45                    	xorb	%ah, 0x45(%rdi)
18033f4a1: f0                          	lock
18033f4a2: fe 6b b4                    	<unknown>
18033f4a5: 16                          	<unknown>
18033f4a6: 97                          	xchgl	%edi, %eax
18033f4a7: 5b                          	popq	%rbx
18033f4a8: 2e a2 49 6b 0f 2e 2c 77 fe a7       	movabsb	%al, %cs:-0x580188d3d1f094b7
18033f4b2: 8e 07                       	movw	(%rdi), %es
18033f4b4: cc                          	int3
18033f4b5: b8 04 ba 46 70              	movl	$0x7046ba04, %eax       # imm = 0x7046BA04
18033f4ba: 4f a8 d3                    	testb	$-0x2d, %al
18033f4bd: 75 a3                       	jne	0x18033f462 <.text+0x32f462>
18033f4bf: 03 42 9e                    	addl	-0x62(%rdx), %eax
18033f4c2: 85 9e 97 f4 90 0c           	testl	%ebx, 0xc90f497(%rsi)
18033f4c8: e4 16                       	inb	$0x16, %al
18033f4ca: 09 24 e7                    	orl	%esp, (%rdi,%riz,8)
18033f4cd: 0d bf 01 e0 3f              	orl	$0x3fe001bf, %eax       # imm = 0x3FE001BF
18033f4d2: 66 da 3e                    	fidivrl	(%rsi)
18033f4d5: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033f4d6: 53                          	pushq	%rbx
18033f4d7: 80 ce ee                    	orb	$-0x12, %dh
18033f4da: 6d                          	insl	%dx, %es:(%rdi)
18033f4db: 0c 25                       	orb	$0x25, %al
18033f4dd: b8 94 a1 f3 b7              	movl	$0xb7f3a194, %eax       # imm = 0xB7F3A194
18033f4e2: 08 d2                       	orb	%dl, %dl
18033f4e4: 46 4a b9 d4 7f f1 cd 5f de 6e 23    	movabsq	$0x236ede5fcdf17fd4, %rcx # imm = 0x236EDE5FCDF17FD4
18033f4ef: 52                          	pushq	%rdx
18033f4f0: 91                          	xchgl	%ecx, %eax
18033f4f1: 48 ee                       	outb	%al, %dx
18033f4f3: 97                          	xchgl	%edi, %eax
18033f4f4: c3                          	retq
18033f4f5: 09 dd                       	orl	%ebx, %ebp
18033f4f7: bd 44 a4 10 93              	movl	$0x9310a444, %ebp       # imm = 0x9310A444
18033f4fc: c3                          	retq
18033f4fd: 5f                          	popq	%rdi
18033f4fe: 1f                          	<unknown>
18033f4ff: 8c b8 bb 9c ca d4           	<unknown>
18033f505: a0 e3 1f 0e 29 68 9c 30 d6  	movabsb	-0x29cf6397d6f1e01d, %al
18033f50e: 09 cd                       	orl	%ecx, %ebp
18033f510: d2 54 e2 3e                 	rclb	%cl, 0x3e(%rdx,%riz,8)
18033f514: b4 98                       	movb	$-0x68, %ah
18033f516: 23 61 91                    	andl	-0x6f(%rcx), %esp
18033f519: 86 e0                       	xchgb	%al, %ah
18033f51b: a3 25 f1 ba 07 42 8f 38 ec  	movabsl	%eax, -0x13c770bdf8450edb
18033f524: fa                          	cli
18033f525: 02 d8                       	addb	%al, %bl
18033f527: 4e 49 35 d2 08 48 4b        	xorq	$0x4b4808d2, %rax       # imm = 0x4B4808D2
18033f52e: 66 28 76 35                 	subb	%dh, 0x35(%rsi)
18033f532: d7                          	xlatb
18033f533: 9c                          	pushfq
18033f534: b7 c9                       	movb	$-0x37, %bh
18033f536: 3f                          	<unknown>
18033f537: ac                          	lodsb	(%rsi), %al
18033f538: 02 49 a8                    	addb	-0x58(%rcx), %cl
18033f53b: fc                          	cld
18033f53c: 62 6e b6 7f ae              	<unknown>
18033f541: 68 26 20 0a e9              	pushq	$-0x16f5dfda            # imm = 0xE90A2026
18033f546: f4                          	hlt
18033f547: 04 b6                       	addb	$-0x4a, %al
18033f549: 44 a4                       	movsb	(%rsi), %es:(%rdi)
18033f54b: 2e 35 9f ed ee 88           	xorl	$0x88eeed9f, %eax       # imm = 0x88EEED9F
18033f551: 04 a7                       	addb	$-0x59, %al
18033f553: 4b ee                       	outb	%al, %dx
18033f555: 86 72 a1                    	xchgb	%dh, -0x5f(%rdx)
18033f558: 20 5d c2                    	andb	%bl, -0x3e(%rbp)
18033f55b: 64 cf                       	iretl
18033f55d: 06                          	<unknown>
18033f55e: 5f                          	popq	%rdi
18033f55f: b2 94                       	movb	$-0x6c, %dl
18033f561: 29 60 16                    	subl	%esp, 0x16(%rax)
18033f564: d5 02 03 ae a5 4b 63 23     	addl	0x23634ba5(%rsi), %ebp
18033f56c: 3e 69 0c cf 66 f4 3a b8     	imull	$0xb83af466, %ds:(%rdi,%rcx,8), %ecx # imm = 0xB83AF466
18033f574: b3 df                       	movb	$-0x21, %bl
18033f576: 76 0d                       	jbe	0x18033f585 <.text+0x32f585>
18033f578: b3 c5                       	movb	$-0x3b, %bl
18033f57a: bf 91 27 a8 b7              	movl	$0xb7a82791, %edi       # imm = 0xB7A82791
18033f57f: ce                          	<unknown>
18033f580: ed                          	inl	%dx, %eax
18033f581: 3c c8                       	cmpb	$-0x38, %al
18033f583: 49 23 31                    	andq	(%r9), %rsi
18033f586: 69 22 4b 0c 0b 71           	imull	$0x710b0c4b, (%rdx), %esp # imm = 0x710B0C4B
18033f58c: 0f 46 73 69                 	cmovbel	0x69(%rbx), %esi
18033f590: 74 a4                       	je	0x18033f536 <.text+0x32f536>
18033f592: 57                          	pushq	%rdi
18033f593: 4c b9 3f cc e8 bd ea df 44 e4       	movabsq	$-0x1bbb2015421733c1, %rcx # imm = 0xE444DFEABDE8CC3F
18033f59d: 11 0e                       	adcl	%ecx, (%rsi)
18033f59f: 58                          	popq	%rax
18033f5a0: 1c 1a                       	sbbb	$0x1a, %al
18033f5a2: 2e f5                       	cmc
18033f5a4: a4                          	movsb	(%rsi), %es:(%rdi)
18033f5a5: 37                          	<unknown>
18033f5a6: 10 86 d6 f3 f2 77           	adcb	%al, 0x77f2f3d6(%rsi)
18033f5ac: cf                          	iretl
18033f5ad: 30 03                       	xorb	%al, (%rbx)
18033f5af: 17                          	<unknown>
18033f5b0: 7d 34                       	jge	0x18033f5e6 <.text+0x32f5e6>
18033f5b2: f0                          	lock
18033f5b3: f7 42 72 fe b7 9a e2        	testl	$0xe29ab7fe, 0x72(%rdx) # imm = 0xE29AB7FE
18033f5ba: 9f                          	lahf
18033f5bb: e2 6b                       	loop	0x18033f628 <.text+0x32f628>
18033f5bd: a5                          	movsl	(%rsi), %es:(%rdi)
18033f5be: 74 1c                       	je	0x18033f5dc <.text+0x32f5dc>
18033f5c0: 5f                          	popq	%rdi
18033f5c1: c6 e0                       	<unknown>
18033f5c3: 0e                          	<unknown>
18033f5c4: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033f5c5: 9e                          	sahf
18033f5c6: f8                          	clc
18033f5c7: 56                          	pushq	%rsi
18033f5c8: a0 0c c8 66 ce ca 8c 39 9e  	movabsb	-0x61c67335319937f4, %al
18033f5d1: cb                          	lretl
18033f5d2: c8 bd a0 36                 	enter	$-0x5f43, $0x36         # imm = 0xA0BD
18033f5d6: e5 93                       	inl	$0x93, %eax
18033f5d8: b4 e7                       	movb	$-0x19, %ah
18033f5da: 3f                          	<unknown>
18033f5db: 95                          	xchgl	%ebp, %eax
18033f5dc: 40 74 6c                    	je	0x18033f64b <.text+0x32f64b>
18033f5df: b9 d3 4c 7d 96              	movl	$0x967d4cd3, %ecx       # imm = 0x967D4CD3
18033f5e4: be db ec 26 fb              	movl	$0xfb26ecdb, %esi       # imm = 0xFB26ECDB
18033f5e9: 75 33                       	jne	0x18033f61e <.text+0x32f61e>
18033f5eb: f9                          	stc
18033f5ec: f7 8a f4 41 17 01           	<unknown>
18033f5f2: 93                          	xchgl	%ebx, %eax
18033f5f3: c6 cb                       	<unknown>
18033f5f5: f9                          	stc
18033f5f6: 64 55                       	pushq	%rbp
18033f5f8: df fd                       	<unknown>
18033f5fa: dc 78 48                    	fdivrl	0x48(%rax)
18033f5fd: 82                          	<unknown>
18033f5fe: 50                          	pushq	%rax
18033f5ff: 4d ec                       	inb	%dx, %al
18033f601: 0a aa ca ef eb 6a           	orb	0x6aebefca(%rdx), %ch
18033f607: 16                          	<unknown>
18033f608: f5                          	cmc
18033f609: 69 98 f0 2e 2b d9 ca 6d d0 26       	imull	$0x26d06dca, -0x26d4d110(%rax), %ebx # imm = 0x26D06DCA
18033f613: 8c 9e 2a de b2 6c           	movw	%ds, 0x6cb2de2a(%rsi)
18033f619: 92                          	xchgl	%edx, %eax
18033f61a: 81 6a 19 78 f6 3f df        	subl	$0xdf3ff678, 0x19(%rdx) # imm = 0xDF3FF678
18033f621: ab                          	stosl	%eax, %es:(%rdi)
18033f622: 3b 3e                       	cmpl	(%rsi), %edi
18033f624: 1d f2 79 1d 0a              	sbbl	$0xa1d79f2, %eax        # imm = 0xA1D79F2
18033f629: ee                          	outb	%al, %dx
18033f62a: f9                          	stc
18033f62b: d2 93 23 9b 7b 5c           	rclb	%cl, 0x5c7b9b23(%rbx)
18033f631: b1 1a                       	movb	$0x1a, %cl
18033f633: 0e                          	<unknown>
18033f634: fc                          	cld
18033f635: 25 76 e3 7a ad              	andl	$0xad7ae376, %eax       # imm = 0xAD7AE376
18033f63a: 9b                          	wait
18033f63b: 67 15 e7 99 7b 8a           	addr32		adcl	$0x8a7b99e7, %eax # imm = 0x8A7B99E7
18033f641: 04 ee                       	addb	$-0x12, %al
18033f643: f4                          	hlt
18033f644: 2a 60 6b                    	subb	0x6b(%rax), %ah
18033f647: 9f                          	lahf
18033f648: 49 6d                       	insl	%dx, %es:(%rdi)
18033f64a: 65 3d 6e e0 32 4e           	cmpl	$0x4e32e06e, %eax       # imm = 0x4E32E06E
18033f650: 11 2a                       	adcl	%ebp, (%rdx)
18033f652: 17                          	<unknown>
18033f653: 58                          	popq	%rax
18033f654: a8 c0                       	testb	$-0x40, %al
18033f656: 29 c7                       	subl	%eax, %edi
18033f658: 68 16 6f ae bf              	pushq	$-0x405190ea            # imm = 0xBFAE6F16
18033f65d: d2 dc                       	rcrb	%cl, %ah
18033f65f: cb                          	lretl
18033f660: 6f                          	outsl	(%rsi), %dx
18033f661: b5 6a                       	movb	$0x6a, %ch
18033f663: 5f                          	popq	%rdi
18033f664: 3c 7c                       	cmpb	$0x7c, %al
18033f666: 48 b0 fa                    	movb	$-0x6, %al
18033f669: e3 43                       	jrcxz	0x18033f6ae <.text+0x32f6ae>
18033f66b: 84 db                       	testb	%bl, %bl
18033f66d: b3 24                       	movb	$0x24, %bl
18033f66f: a0 a3 45 1a a9 4a d5 20 46  	movabsb	0x4620d54aa91a45a3, %al
18033f678: 0e                          	<unknown>
18033f679: 15 81 20 e4 fb              	adcl	$0xfbe42081, %eax       # imm = 0xFBE42081
18033f67e: 01 9d db 7c 4d 71           	addl	%ebx, 0x714d7cdb(%rbp)
18033f684: 45 45 1c f3                 	sbbb	$-0xd, %al
18033f688: 42 8f 93 78                 	<unknown>
18033f68c: 69 10 52 a5 b6 98           	imull	$0x98b6a552, (%rax), %edx # imm = 0x98B6A552
18033f692: 15 fa af 81 16              	adcl	$0x1681affa, %eax       # imm = 0x1681AFFA
18033f697: 2f                          	<unknown>
18033f698: 5c                          	popq	%rsp
18033f699: 20 73 0b                    	andb	%dh, 0xb(%rbx)
18033f69c: 71 e2                       	jno	0x18033f680 <.text+0x32f680>
18033f69e: bb a4 4f 8b c3              	movl	$0xc38b4fa4, %ebx       # imm = 0xC38B4FA4
18033f6a3: 4c 50                       	pushq	%rax
18033f6a5: 21 1b                       	andl	%ebx, (%rbx)
18033f6a7: fc                          	cld
18033f6a8: b8 50 97 78 42              	movl	$0x42789750, %eax       # imm = 0x42789750
18033f6ad: 64 41 8a 61 74              	movb	%fs:0x74(%r9), %spl
18033f6b2: aa                          	stosb	%al, %es:(%rdi)
18033f6b3: e5 a1                       	inl	$0xa1, %eax
18033f6b5: f3 b0 f4                    	rep		movb	$-0xc, %al
18033f6b8: fe da                       	<unknown>
18033f6ba: 04 0a                       	addb	$0xa, %al
18033f6bc: 34 4d                       	xorb	$0x4d, %al
18033f6be: 19 7d dd                    	sbbl	%edi, -0x23(%rbp)
18033f6c1: 87 a8 9a 38 18 5f           	xchgl	%ebp, 0x5f18389a(%rax)
18033f6c7: 34 5d                       	xorb	$0x5d, %al
18033f6c9: 73 b6                       	jae	0x18033f681 <.text+0x32f681>
18033f6cb: 92                          	xchgl	%edx, %eax
18033f6cc: 12 31                       	adcb	(%rcx), %dh
18033f6ce: 99                          	cltd
18033f6cf: b9 8f a9 93 b3              	movl	$0xb393a98f, %ecx       # imm = 0xB393A98F
18033f6d4: e1 7b                       	loope	0x18033f751 <.text+0x32f751>
18033f6d6: 1e                          	<unknown>
18033f6d7: cf                          	iretl
18033f6d8: 79 65                       	jns	0x18033f73f <.text+0x32f73f>
18033f6da: 1e                          	<unknown>
18033f6db: 04 04                       	addb	$0x4, %al
18033f6dd: e0 59                       	loopne	0x18033f738 <.text+0x32f738>
18033f6df: 32 cb                       	xorb	%bl, %cl
18033f6e1: 9e                          	sahf
18033f6e2: 72 ab                       	jb	0x18033f68f <.text+0x32f68f>
18033f6e4: f7 58 aa                    	negl	-0x56(%rax)
18033f6e7: 9e                          	sahf
18033f6e8: 72 72                       	jb	0x18033f75c <.text+0x32f75c>
18033f6ea: 31 36                       	xorl	%esi, (%rsi)
18033f6ec: 09 6e 42                    	orl	%ebp, 0x42(%rsi)
18033f6ef: 12 a1 91 ce 27 bc           	adcb	-0x43d8316f(%rcx), %ah
18033f6f5: fb                          	sti
18033f6f6: dd 07                       	fldl	(%rdi)
18033f6f8: 21 33                       	andl	%esi, (%rbx)
18033f6fa: 8c d7                       	movl	%ss, %edi
18033f6fc: 0f fc 50 70                 	paddb	0x70(%rax), %mm2
18033f700: 79 8e                       	jns	0x18033f690 <.text+0x32f690>
18033f702: b5 21                       	movb	$0x21, %ch
18033f704: d1 08                       	rorl	(%rax)
18033f706: da 20                       	fisubl	(%rax)
18033f708: 61                          	<unknown>
18033f709: ef                          	outl	%eax, %dx
18033f70a: b3 1a                       	movb	$0x1a, %bl
18033f70c: 80 ef 64                    	subb	$0x64, %bh
18033f70f: 96                          	xchgl	%esi, %eax
18033f710: 1c 94                       	sbbb	$-0x6c, %al
18033f712: fb                          	sti
18033f713: 7c b4                       	jl	0x18033f6c9 <.text+0x32f6c9>
18033f715: 08 5f c6                    	orb	%bl, -0x3a(%rdi)
18033f718: 86 73 13                    	xchgb	%dh, 0x13(%rbx)
18033f71b: 1f                          	<unknown>
18033f71c: b5 32                       	movb	$0x32, %ch
18033f71e: 79 1b                       	jns	0x18033f73b <.text+0x32f73b>
18033f720: b2 fe                       	movb	$-0x2, %dl
18033f722: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033f723: 64 c7 6e b3                 	<unknown>
18033f727: 8d 55 97                    	leal	-0x69(%rbp), %edx
18033f72a: 7a b5                       	jp	0x18033f6e1 <.text+0x32f6e1>
18033f72c: 03 03                       	addl	(%rbx), %eax
18033f72e: 6a 00                       	pushq	$0x0
18033f730: af                          	scasl	%es:(%rdi), %eax
18033f731: e4 20                       	inb	$0x20, %al
18033f733: 4e b2 ae                    	movb	$-0x52, %dl
18033f736: 9f                          	lahf
18033f737: 06                          	<unknown>
18033f738: 06                          	<unknown>
18033f739: 8e a9 11 c4 63 8f           	movw	-0x709c3bef(%rcx), %gs
18033f73f: ab                          	stosl	%eax, %es:(%rdi)
18033f740: cc                          	int3
18033f741: 48 e2 9e                    	loop	0x18033f6e2 <.text+0x32f6e2>
18033f744: 7f 1f                       	jg	0x18033f765 <.text+0x32f765>
18033f746: 82                          	<unknown>
18033f747: 8d b0 6f a4 db 53           	leal	0x53dba46f(%rax), %esi
18033f74d: aa                          	stosb	%al, %es:(%rdi)
18033f74e: 80 84 41 52 ca 7e 82 41     	addb	$0x41, -0x7d8135ae(%rcx,%rax,2)
18033f756: ee                          	outb	%al, %dx
18033f757: eb 61                       	jmp	0x18033f7ba <.text+0x32f7ba>
18033f759: 8b 5f b3                    	movl	-0x4d(%rdi), %ebx
18033f75c: 54                          	pushq	%rsp
18033f75d: e4 33                       	inb	$0x33, %al
18033f75f: 2c df                       	subb	$-0x21, %al
18033f761: f6 e9                       	imulb	%cl
18033f763: a5                          	movsl	(%rsi), %es:(%rdi)
18033f764: a5                          	movsl	(%rsi), %es:(%rdi)
18033f765: 7b 0a                       	jnp	0x18033f771 <.text+0x32f771>
18033f767: f8                          	clc
18033f768: 5f                          	popq	%rdi
18033f769: 8d 85 b0 90 26 d6           	leal	-0x29d96f50(%rbp), %eax
18033f76f: 5e                          	popq	%rsi
18033f770: d9 f5                       	fprem1
18033f772: 63 9c 0e b7 aa 7d 21        	movslq	0x217daab7(%rsi,%rcx), %ebx
18033f779: 66 b2 64                    	movb	$0x64, %dl
18033f77c: bf 6a aa 54 ab              	movl	$0xab54aa6a, %edi       # imm = 0xAB54AA6A
18033f781: 20 d9                       	andb	%bl, %cl
18033f783: 0d c3 69 65 d8              	orl	$0xd86569c3, %eax       # imm = 0xD86569C3
18033f788: b8 f7 35 31 7f              	movl	$0x7f3135f7, %eax       # imm = 0x7F3135F7
18033f78d: 9d                          	popfq
18033f78e: 35 4e 4c 8f ea              	xorl	$0xea8f4c4e, %eax       # imm = 0xEA8F4C4E
18033f793: f7 17                       	notl	(%rdi)
18033f795: f5                          	cmc
18033f796: ab                          	stosl	%eax, %es:(%rdi)
18033f797: 55                          	pushq	%rbp
18033f798: 56                          	pushq	%rsi
18033f799: 70 b6                       	jo	0x18033f751 <.text+0x32f751>
18033f79b: 48 11 57 16                 	adcq	%rdx, 0x16(%rdi)
18033f79f: 76 e4                       	jbe	0x18033f785 <.text+0x32f785>
18033f7a1: 32 61 94                    	xorb	-0x6c(%rcx), %ah
18033f7a4: 2a 40 6c                    	subb	0x6c(%rax), %al
18033f7a7: c4 f9 c4                    	<unknown>
18033f7aa: 7b 35                       	jnp	0x18033f7e1 <.text+0x32f7e1>
18033f7ac: 15 73 bd 20 f5              	adcl	$0xf520bd73, %eax       # imm = 0xF520BD73
18033f7b1: 5d                          	popq	%rbp
18033f7b2: 3b f4                       	cmpl	%esp, %esi
18033f7b4: 45 ee                       	outb	%al, %dx
18033f7b6: a4                          	movsb	(%rsi), %es:(%rdi)
18033f7b7: 32 ac 9d 69 38 7a 43        	xorb	0x437a3869(%rbp,%rbx,4), %ch
18033f7be: 9a                          	<unknown>
18033f7bf: fd                          	std
18033f7c0: 5e                          	popq	%rsi
18033f7c1: a2 09 cf 77 86 53 ed a4 77  	movabsb	%al, 0x77a4ed538677cf09
18033f7ca: 7d d6                       	jge	0x18033f7a2 <.text+0x32f7a2>
18033f7cc: 57                          	pushq	%rdi
18033f7cd: 3b 80 18 d9 c3 6d           	cmpl	0x6dc3d918(%rax), %eax
18033f7d3: 99                          	cltd
18033f7d4: fd                          	std
18033f7d5: 1f                          	<unknown>
18033f7d6: cf                          	iretl
18033f7d7: 69 c0 80 db d8 10           	imull	$0x10d8db80, %eax, %eax # imm = 0x10D8DB80
18033f7dd: 02 73 31                    	addb	0x31(%rbx), %dh
18033f7e0: b0 35                       	movb	$0x35, %al
18033f7e2: fa                          	cli
18033f7e3: 56                          	pushq	%rsi
18033f7e4: aa                          	stosb	%al, %es:(%rdi)
18033f7e5: cb                          	lretl
18033f7e6: 90                          	nop
18033f7e7: 9d                          	popfq
18033f7e8: 38 56 62                    	cmpb	%dl, 0x62(%rsi)
18033f7eb: dd 06                       	fldl	(%rsi)
18033f7ed: 52                          	pushq	%rdx
18033f7ee: ab                          	stosl	%eax, %es:(%rdi)
18033f7ef: 74 f4                       	je	0x18033f7e5 <.text+0x32f7e5>
18033f7f1: 5e                          	popq	%rsi
18033f7f2: 40 73 51                    	jae	0x18033f846 <.text+0x32f846>
18033f7f5: bf 37 b6 93 ac              	movl	$0xac93b637, %edi       # imm = 0xAC93B637
18033f7fa: f5                          	cmc
18033f7fb: 2a 8c 31 61 e8 72 af        	subb	-0x508d179f(%rcx,%rsi), %cl
18033f802: 44 cc                       	int3
18033f804: e1 f6                       	loope	0x18033f7fc <.text+0x32f7fc>
18033f806: 9d                          	popfq
18033f807: d6                          	<unknown>
18033f808: 8b da                       	movl	%edx, %ebx
18033f80a: 7a db                       	jp	0x18033f7e7 <.text+0x32f7e7>
18033f80c: e4 0a                       	inb	$0xa, %al
18033f80e: a8 a0                       	testb	$-0x60, %al
18033f810: 3d be c1 86 25              	cmpl	$0x2586c1be, %eax       # imm = 0x2586C1BE
18033f815: 4f 60                       	<unknown>
18033f817: f4                          	hlt
18033f818: 83 e7 70                    	andl	$0x70, %edi
18033f81b: 77 90                       	ja	0x18033f7ad <.text+0x32f7ad>
18033f81d: 0b a8 6e 13 ad e7           	orl	-0x1852ec92(%rax), %ebp
18033f823: 0f 97 79 46                 	seta	0x46(%rcx)
18033f827: e6 bb                       	outb	%al, $0xbb
18033f829: 38 4c c1 1a                 	cmpb	%cl, 0x1a(%rcx,%rax,8)
18033f82d: 37                          	<unknown>
18033f82e: a0 13 c7 79 81 6a 9d b5 4e  	movabsb	0x4eb59d6a8179c713, %al
18033f837: 37                          	<unknown>
18033f838: 8c 10                       	movw	%ss, (%rax)
18033f83a: 0a f5                       	orb	%ch, %dh
18033f83c: 87 5f aa                    	xchgl	%ebx, -0x56(%rdi)
18033f83f: e9 70 e7 c4 4b              	jmp	0x1cbf8dfb4
18033f844: 1d 6d 5a fd 29              	sbbl	$0x29fd5a6d, %eax       # imm = 0x29FD5A6D
18033f849: 1d fb 0d 48 a2              	sbbl	$0xa2480dfb, %eax       # imm = 0xA2480DFB
18033f84e: c5 9a 28                    	<unknown>
18033f851: e0 51                       	loopne	0x18033f8a4 <.text+0x32f8a4>
18033f853: c7 c1 1a f8 cb 31           	movl	$0x31cbf81a, %ecx       # imm = 0x31CBF81A
18033f859: 2c 53                       	subb	$0x53, %al
18033f85b: b7 e1                       	movb	$-0x1f, %bh
18033f85d: ae                          	scasb	%es:(%rdi), %al
18033f85e: 06                          	<unknown>
18033f85f: fd                          	std
18033f860: 1d cf 35 c3 5f              	sbbl	$0x5fc335cf, %eax       # imm = 0x5FC335CF
18033f865: 2c 36                       	subb	$0x36, %al
18033f867: 6d                          	insl	%dx, %es:(%rdi)
18033f868: 09 85 8d 46 f1 28           	orl	%eax, 0x28f1468d(%rbp)
18033f86e: be 41 95 9e 9a              	movl	$0x9a9e9541, %esi       # imm = 0x9A9E9541
18033f873: c7 35 c6 c3 47 0d           	<unknown>
18033f879: 20 0d c7 5e 40 4a           	andb	%cl, 0x4a405ec7(%rip)   # 0x1ca745746
18033f87f: 6c                          	insb	%dx, %es:(%rdi)
18033f880: a1 d2 73 21 f8 68 e0 76 dd  	movabsl	-0x22891f9707de8c2e, %eax
18033f889: fe f8                       	<unknown>
18033f88b: eb 08                       	jmp	0x18033f895 <.text+0x32f895>
18033f88d: b7 b3                       	movb	$-0x4d, %bh
18033f88f: 32 9a c1 2e 9c 4a           	xorb	0x4a9c2ec1(%rdx), %bl
18033f895: 9b                          	wait
18033f896: 42 da 95 61 6a a0 b1        	ficoml	-0x4e5f959f(%rbp)
18033f89d: 89 dc                       	movl	%ebx, %esp
18033f89f: 49 a7                       	cmpsq	%es:(%rdi), (%rsi)
18033f8a1: e2 3a                       	loop	0x18033f8dd <.text+0x32f8dd>
18033f8a3: e9 3c 48 cd a3              	jmp	0x1240140e4
18033f8a8: a5                          	movsl	(%rsi), %es:(%rdi)
18033f8a9: bf 32 a8 a8 83              	movl	$0x83a8a832, %edi       # imm = 0x83A8A832
18033f8ae: f7 a4 98 83 d8 c4 22        	mull	0x22c4d883(%rax,%rbx,4)
18033f8b5: c7 18                       	<unknown>
18033f8b7: 32 53 5e                    	xorb	0x5e(%rbx), %dl
18033f8ba: 37                          	<unknown>
18033f8bb: ee                          	outb	%al, %dx
18033f8bc: e5 27                       	inl	$0x27, %eax
18033f8be: b4 ed                       	movb	$-0x13, %ah
18033f8c0: 47 39 92 73 37 92 5a        	cmpl	%r10d, 0x5a923773(%r10)
18033f8c7: ef                          	outl	%eax, %dx
18033f8c8: 59                          	popq	%rcx
18033f8c9: 40 6f                       	outsl	(%rsi), %dx
18033f8cb: 64 23 14 bc                 	andl	%fs:(%rsp,%rdi,4), %edx
18033f8cf: 3b c2                       	cmpl	%edx, %eax
18033f8d1: e7 32                       	outl	%eax, $0x32
18033f8d3: 00 71 5c                    	addb	%dh, 0x5c(%rcx)
18033f8d6: a3 56 cb e1 ac 1d 98 d4 8d  	movabsl	%eax, -0x722b67e2531e34aa
18033f8df: 3e e7 81                    	outl	%eax, $0x81
18033f8e2: 5b                          	popq	%rbx
18033f8e3: aa                          	stosb	%al, %es:(%rdi)
18033f8e4: 14 3f                       	adcb	$0x3f, %al
18033f8e6: d1 b2 4b ad 93 bc           	<unknown>
18033f8ec: 27                          	<unknown>
18033f8ed: f4                          	hlt
18033f8ee: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033f8ef: fe 73 24                    	<unknown>
18033f8f2: 90                          	nop
18033f8f3: ae                          	scasb	%es:(%rdi), %al
18033f8f4: 53                          	pushq	%rbx
18033f8f5: cd f0                       	int	$0xf0
18033f8f7: c5 a9 13 1d 1e f1 89 8e     	<unknown>
18033f8ff: 27                          	<unknown>
18033f900: 3e 99                       	cltd
18033f902: aa                          	stosb	%al, %es:(%rdi)
18033f903: ed                          	inl	%dx, %eax
18033f904: da 65 de                    	fisubl	-0x22(%rbp)
18033f907: b8 48 f0 1c b1              	movl	$0xb11cf048, %eax       # imm = 0xB11CF048
18033f90c: 4e b4 f8                    	movb	$-0x8, %spl
18033f90f: 39 22                       	cmpl	%esp, (%rdx)
18033f911: 11 8f 02 7b 63 02           	adcl	%ecx, 0x2637b02(%rdi)
18033f917: a3 d7 35 c5 85 91 50 cf 89  	movabsl	%eax, -0x7630af6e7a3aca29
18033f920: 12 94 80 60 a5 6c 8b        	adcb	-0x74935aa0(%rax,%rax,4), %dl
18033f927: ee                          	outb	%al, %dx
18033f928: 82                          	<unknown>
18033f929: a0 3b 57 ac da 53 f7 4c 1c  	movabsb	0x1c4cf753daac573b, %al
18033f932: d2 2e                       	shrb	%cl, (%rsi)
18033f934: 35 9d 20 9a 6b              	xorl	$0x6b9a209d, %eax       # imm = 0x6B9A209D
18033f939: 48 66 45 3a 28              	cmpb	(%r8), %r13b
18033f93e: fc                          	cld
18033f93f: c6 0c ea                    	<unknown>
18033f942: 0f f6 3e                    	psadbw	(%rsi), %mm7
18033f945: 8e 52 ee                    	movw	-0x12(%rdx), %ss
18033f948: 34 b4                       	xorb	$-0x4c, %al
18033f94a: b0 eb                       	movb	$-0x15, %al
18033f94c: 19 28                       	sbbl	%ebp, (%rax)
18033f94e: 95                          	xchgl	%ebp, %eax
18033f94f: 82                          	<unknown>
18033f950: 64 42 45 75 56              	jne	0x18033f9ab <.text+0x32f9ab>
18033f955: 9c                          	pushfq
18033f956: e2 cb                       	loop	0x18033f923 <.text+0x32f923>
18033f958: 90                          	nop
18033f959: ab                          	stosl	%eax, %es:(%rdi)
18033f95a: c4 83 8d 76                 	<unknown>
18033f95e: 85 a9 42 3b 71 57           	testl	%ebp, 0x57713b42(%rcx)
18033f964: 37                          	<unknown>
18033f965: 5c                          	popq	%rsp
18033f966: bd 9d c4 48 52              	movl	$0x5248c49d, %ebp       # imm = 0x5248C49D
18033f96b: bb cd 07 dc 81              	movl	$0x81dc07cd, %ebx       # imm = 0x81DC07CD
18033f970: bd 4e 55 76 a3              	movl	$0xa376554e, %ebp       # imm = 0xA376554E
18033f975: 5d                          	popq	%rbp
18033f976: d1 9f 6f 86 90 f9           	rcrl	-0x66f7991(%rdi)
18033f97c: 69 7d b7 ba 86 94 6a        	imull	$0x6a9486ba, -0x49(%rbp), %edi # imm = 0x6A9486BA
18033f983: f7 77 1a                    	divl	0x1a(%rdi)
18033f986: 08 04 2c                    	orb	%al, (%rsp,%rbp)
18033f989: ae                          	scasb	%es:(%rdi), %al
18033f98a: 93                          	xchgl	%ebx, %eax
18033f98b: 16                          	<unknown>
18033f98c: 87 c4                       	xchgl	%esp, %eax
18033f98e: 1f                          	<unknown>
18033f98f: 8f 33 86                    	<unknown>
18033f992: 7a 8d                       	jp	0x18033f921 <.text+0x32f921>
18033f994: e8 55 eb 75 f0              	callq	0x170a9e4ee
18033f999: c0 02 93                    	rolb	$0x93, (%rdx)
18033f99c: a2 da 71 c9 8d 86 7e fb 98  	movabsb	%al, -0x6704817972368e26
18033f9a5: 92                          	xchgl	%edx, %eax
18033f9a6: c6 7b 29                    	<unknown>
18033f9a9: 9b                          	wait
18033f9aa: 3c 42                       	cmpb	$0x42, %al
18033f9ac: 1a 39                       	sbbb	(%rcx), %bh
18033f9ae: 2b ae 54 77 77 14           	subl	0x14777754(%rsi), %ebp
18033f9b4: e7 69                       	outl	%eax, $0x69
18033f9b6: 8e 6b 5f                    	movw	0x5f(%rbx), %gs
18033f9b9: 79 2c                       	jns	0x18033f9e7 <.text+0x32f9e7>
18033f9bb: b7 c0                       	movb	$-0x40, %bh
18033f9bd: 7b 15                       	jnp	0x18033f9d4 <.text+0x32f9d4>
18033f9bf: 90                          	nop
18033f9c0: 83 15 9f fe a5 e9 ee        	adcl	$-0x12, -0x165a0161(%rip) # 0x169d9f866
18033f9c7: 69 38 b6 ec 18 d7           	imull	$0xd718ecb6, (%rax), %edi # imm = 0xD718ECB6
18033f9cd: 82                          	<unknown>
18033f9ce: ed                          	inl	%dx, %eax
18033f9cf: 96                          	xchgl	%esi, %eax
18033f9d0: b7 1b                       	movb	$0x1b, %bh
18033f9d2: 44 32 e1                    	xorb	%cl, %r12b
18033f9d5: dd 9c ee df 72 05 17        	fstpl	0x170572df(%rsi,%rbp,8)
18033f9dc: da 1f                       	ficompl	(%rdi)
18033f9de: 94                          	xchgl	%esp, %eax
18033f9df: e2 b8                       	loop	0x18033f999 <.text+0x32f999>
18033f9e1: 57                          	pushq	%rdi
18033f9e2: c8 d6 4e 28                 	enter	$0x4ed6, $0x28          # imm = 0x4ED6
18033f9e6: 84 c2                       	testb	%al, %dl
18033f9e8: 8c 2b                       	movw	%gs, (%rbx)
18033f9ea: fb                          	sti
18033f9eb: 60                          	<unknown>
18033f9ec: c9                          	leave
18033f9ed: 67 41 55                    	addr32		pushq	%r13
18033f9f0: 17                          	<unknown>
18033f9f1: 52                          	pushq	%rdx
18033f9f2: 67 a7                       	cmpsl	%es:(%edi), (%esi)
18033f9f4: 6f                          	outsl	(%rsi), %dx
18033f9f5: 70 c7                       	jo	0x18033f9be <.text+0x32f9be>
18033f9f7: 4f 01 c4                    	addq	%r8, %r12
18033f9fa: f3 b1 1a                    	rep		movb	$0x1a, %cl
18033f9fd: 43 c6 dc                    	<unknown>
18033fa00: 3b f5                       	cmpl	%ebp, %esi
18033fa02: 37                          	<unknown>
18033fa03: 8e 19                       	movw	(%rcx), %ds
18033fa05: d3 2c c2                    	shrl	%cl, (%rdx,%rax,8)
18033fa08: 4d e9 88 ed 14 5d           	jmp	0x1dd48e796
18033fa0e: 2b 64 e8 2b                 	subl	0x2b(%rax,%rbp,8), %esp
18033fa12: 43 26 0f 3f                 	<unknown>
18033fa16: 8b 99 5d 8b b3 2d           	movl	0x2db38b5d(%rcx), %ebx
18033fa1c: 19 ce                       	sbbl	%ecx, %esi
18033fa1e: 44 3a b4 b9 fa ad 50 a8     	cmpb	-0x57af5206(%rcx,%rdi,4), %r14b
18033fa26: cc                          	int3
18033fa27: e3 4d                       	jrcxz	0x18033fa76 <.text+0x32fa76>
18033fa29: 16                          	<unknown>
18033fa2a: a0 f7 e4 3b c4 0e a9 5b cd  	movabsb	-0x32a456f13bc41b09, %al
18033fa33: e2 64                       	loop	0x18033fa99 <.text+0x32fa99>
18033fa35: 35 17 85 39 0c              	xorl	$0xc398517, %eax        # imm = 0xC398517
18033fa3a: 7e 76                       	jle	0x18033fab2 <.text+0x32fab2>
18033fa3c: 9f                          	lahf
18033fa3d: 3a 71 87                    	cmpb	-0x79(%rcx), %dh
18033fa40: 95                          	xchgl	%ebp, %eax
18033fa41: 39 49 86                    	cmpl	%ecx, -0x7a(%rcx)
18033fa44: 1e                          	<unknown>
18033fa45: 00 2c 4e                    	addb	%ch, (%rsi,%rcx,2)
18033fa48: 92                          	xchgl	%edx, %eax
18033fa49: 2f                          	<unknown>
18033fa4a: be 35 dd 33 1c              	movl	$0x1c33dd35, %esi       # imm = 0x1C33DD35
18033fa4f: 8b 0e                       	movl	(%rsi), %ecx
18033fa51: 4a 0a 21                    	orb	(%rcx), %spl
18033fa54: 35 e4 80 64 df              	xorl	$0xdf6480e4, %eax       # imm = 0xDF6480E4
18033fa59: b7 95                       	movb	$-0x6b, %bh
18033fa5b: 4d fb                       	sti
18033fa5d: 4c f2 26 a6                 	repne		cmpsb	%es:(%rdi), %es:(%rsi)
18033fa61: fb                          	sti
18033fa62: 94                          	xchgl	%esp, %eax
18033fa63: 30 4a 76                    	xorb	%cl, 0x76(%rdx)
18033fa66: 4e 93                       	xchgq	%rbx, %rax
18033fa68: 5c                          	popq	%rsp
18033fa69: b5 e2                       	movb	$-0x1e, %ch
18033fa6b: bd f9 32 7a 6d              	movl	$0x6d7a32f9, %ebp       # imm = 0x6D7A32F9
18033fa70: b4 26                       	movb	$0x26, %ah
18033fa72: 2d 28 9c 3a 7a              	subl	$0x7a3a9c28, %eax       # imm = 0x7A3A9C28
18033fa77: 30 ae 78 4e 4d f8           	xorb	%ch, -0x7b2b188(%rsi)
18033fa7d: 4b fd                       	std
18033fa7f: d3 24 f4                    	shll	%cl, (%rsp,%rsi,8)
18033fa82: cc                          	int3
18033fa83: 7e 19                       	jle	0x18033fa9e <.text+0x32fa9e>
18033fa85: 90                          	nop
18033fa86: 3f                          	<unknown>
18033fa87: d3 b3 90 95 7f 0e           	<unknown>
18033fa8d: 22 fe                       	andb	%dh, %bh
18033fa8f: 2c 10                       	subb	$0x10, %al
18033fa91: 38 56 9d                    	cmpb	%dl, -0x63(%rsi)
18033fa94: 95                          	xchgl	%ebp, %eax
18033fa95: f2 0e                       	<unknown>
18033fa97: 17                          	<unknown>
18033fa98: 44 e1 5a                    	loope	0x18033faf5 <.text+0x32faf5>
18033fa9b: 7d a2                       	jge	0x18033fa3f <.text+0x32fa3f>
18033fa9d: 42 5a                       	popq	%rdx
18033fa9f: 1a 2e                       	sbbb	(%rsi), %ch
18033faa1: 32 88 5e 57 7a 6a           	xorb	0x6a7a575e(%rax), %cl
18033faa7: 64 1d 65 34 a2 47           	sbbl	$0x47a23465, %eax       # imm = 0x47A23465
18033faad: a6                          	cmpsb	%es:(%rdi), (%rsi)
18033faae: 5e                          	popq	%rsi
18033faaf: 72 18                       	jb	0x18033fac9 <.text+0x32fac9>
18033fab1: 69 39 a2 29 92 42           	imull	$0x429229a2, (%rcx), %edi # imm = 0x429229A2
18033fab7: 7a 67                       	jp	0x18033fb20 <.text+0x32fb20>
18033fab9: 5d                          	popq	%rbp
18033faba: 5e                          	popq	%rsi
18033fabb: 4f 40 78 29                 	js	0x18033fae8 <.text+0x32fae8>
18033fabf: 6f                          	outsl	(%rsi), %dx
18033fac0: fd                          	std
18033fac1: fc                          	cld
18033fac2: 6c                          	insb	%dx, %es:(%rdi)
18033fac3: 6f                          	outsl	(%rsi), %dx
18033fac4: f7 be fa 10 f8 b8           	idivl	-0x4707ef06(%rsi)
18033faca: fc                          	cld
18033facb: fb                          	sti
18033facc: 89 de                       	movl	%ebx, %esi
18033face: fe bd 94 87 59 65           	<unknown>
18033fad4: e8 33 58 98 a5              	callq	0x125cc530c
18033fad9: 63 2b                       	movslq	(%rbx), %ebp
18033fadb: d0 e1                       	shlb	%cl
18033fadd: df ae fb 9c ca a0           	fildll	-0x5f356305(%rsi)
18033fae3: 3d 0b 75 8e 0a              	cmpl	$0xa8e750b, %eax        # imm = 0xA8E750B
18033fae8: e2 09                       	loop	0x18033faf3 <.text+0x32faf3>
18033faea: 69 71 d8 66 b4 eb 15        	imull	$0x15ebb466, -0x28(%rcx), %esi # imm = 0x15EBB466
18033faf1: 07                          	<unknown>
18033faf2: 7a 73                       	jp	0x18033fb67 <.text+0x32fb67>
18033faf4: 68 2d 2f 10 c7              	pushq	$-0x38efd0d3            # imm = 0xC7102F2D
18033faf9: 61                          	<unknown>
18033fafa: eb dc                       	jmp	0x18033fad8 <.text+0x32fad8>
18033fafc: 44 68 c2 08 ae c0           	pushq	$-0x3f51f73e            # imm = 0xC0AE08C2
18033fb02: 51                          	pushq	%rcx
18033fb03: 7c 3e                       	jl	0x18033fb43 <.text+0x32fb43>
18033fb05: e7 84                       	outl	%eax, $0x84
18033fb07: 2c f8                       	subb	$-0x8, %al
18033fb09: 0d 53 3d 83 16              	orl	$0x16833d53, %eax       # imm = 0x16833D53
18033fb0e: c7 0c 3e                    	<unknown>
18033fb11: b4 ec                       	movb	$-0x14, %ah
18033fb13: 3a 0f                       	cmpb	(%rdi), %cl
18033fb15: 56                          	pushq	%rsi
18033fb16: 3c 8a                       	cmpb	$-0x76, %al
18033fb18: b9 5e 00 8b 63              	movl	$0x638b005e, %ecx       # imm = 0x638B005E
18033fb1d: c9                          	leave
18033fb1e: 12 e7                       	adcb	%bh, %ah
18033fb20: 8b 75 52                    	movl	0x52(%rbp), %esi
18033fb23: 31 15 97 cc ca 12           	xorl	%edx, 0x12cacc97(%rip)  # 0x192fec7c0
18033fb29: 39 cc                       	cmpl	%ecx, %esp
18033fb2b: 00 e8                       	addb	%ch, %al
18033fb2d: dd 8e dc 1c f9 91           	fisttpll	-0x6e06e324(%rsi)
18033fb33: 10 78 96                    	adcb	%bh, -0x6a(%rax)
18033fb36: d8 6d 0d                    	fsubrs	0xd(%rbp)
18033fb39: b8 94 76 0d a7              	movl	$0xa70d7694, %eax       # imm = 0xA70D7694
18033fb3e: 8f 56 f0                    	<unknown>
18033fb41: 67 12 2f                    	adcb	(%edi), %ch
18033fb44: f8                          	clc
18033fb45: 82                          	<unknown>
18033fb46: aa                          	stosb	%al, %es:(%rdi)
18033fb47: db 2d d2 f5 3f c2           	fldt	-0x3dc00a2e(%rip)       # 0x14273f11f
18033fb4d: 25 56 99 f0 ce              	andl	$0xcef09956, %eax       # imm = 0xCEF09956
18033fb52: 58                          	popq	%rax
18033fb53: ce                          	<unknown>
18033fb54: 61                          	<unknown>
18033fb55: 96                          	xchgl	%esi, %eax
18033fb56: b9 78 87 cb ee              	movl	$0xeecb8778, %ecx       # imm = 0xEECB8778
18033fb5b: 7b a7                       	jnp	0x18033fb04 <.text+0x32fb04>
18033fb5d: e2 fd                       	loop	0x18033fb5c <.text+0x32fb5c>
18033fb5f: 09 32                       	orl	%esi, (%rdx)
18033fb61: 0d 97 c6 88 ba              	orl	$0xba88c697, %eax       # imm = 0xBA88C697
18033fb66: 5f                          	popq	%rdi
18033fb67: 81 a6 93 14 e5 f4 3b 26 e8 84       	andl	$0x84e8263b, -0xb1aeb6d(%rsi) # imm = 0x84E8263B
18033fb71: 49 c7 f8 6b 43 6a 60        	xbegin	0x1e09e3ee3
18033fb78: fc                          	cld
18033fb79: e5 e2                       	inl	$0xe2, %eax
18033fb7b: 04 a2                       	addb	$-0x5e, %al
18033fb7d: b6 fc                       	movb	$-0x4, %dh
18033fb7f: b1 36                       	movb	$0x36, %cl
18033fb81: 04 05                       	addb	$0x5, %al
18033fb83: 7a 59                       	jp	0x18033fbde <.text+0x32fbde>
18033fb85: 65 df 19                    	fistps	%gs:(%rcx)
18033fb88: 2d f9 40 93 6a              	subl	$0x6a9340f9, %eax       # imm = 0x6A9340F9
18033fb8d: 0e                          	<unknown>
18033fb8e: 58                          	popq	%rax
18033fb8f: 7f cb                       	jg	0x18033fb5c <.text+0x32fb5c>
18033fb91: c7 2e                       	<unknown>
18033fb93: be 5b 5e 2a 93              	movl	$0x932a5e5b, %esi       # imm = 0x932A5E5B
18033fb98: 79 1a                       	jns	0x18033fbb4 <.text+0x32fbb4>
18033fb9a: e3 2e                       	jrcxz	0x18033fbca <.text+0x32fbca>
18033fb9c: c7 90 fd b0 5e b1           	<unknown>
18033fba2: 0a 4e de                    	orb	-0x22(%rsi), %cl
18033fba5: 2f                          	<unknown>
18033fba6: b2 00                       	movb	$0x0, %dl
18033fba8: 64 34 d2                    	xorb	$-0x2e, %al
18033fbab: 06                          	<unknown>
18033fbac: 29 f0                       	subl	%esi, %eax
18033fbae: 36 b3 de                    	movb	$-0x22, %bl
18033fbb1: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033fbb2: 73 c8                       	jae	0x18033fb7c <.text+0x32fb7c>
18033fbb4: c8 92 f6 af                 	enter	$-0x96e, $-0x51         # imm = 0xF692
18033fbb8: fe bc e6 79 76 dd f0        	<unknown>
18033fbbf: 42 b9 7d 09 b8 17           	movl	$0x17b8097d, %ecx       # imm = 0x17B8097D
18033fbc5: 11 a0 75 1d b6 47           	adcl	%esp, 0x47b61d75(%rax)
18033fbcb: 54                          	pushq	%rsp
18033fbcc: 71 d2                       	jno	0x18033fba0 <.text+0x32fba0>
18033fbce: d0 ea                       	shrb	%dl
18033fbd0: ca 83 00                    	lretl	$0x83
18033fbd3: 34 cb                       	xorb	$-0x35, %al
18033fbd5: 86 67 e8                    	xchgb	%ah, -0x18(%rdi)
18033fbd8: cc                          	int3
18033fbd9: d7                          	xlatb
18033fbda: 39 cd                       	cmpl	%ecx, %ebp
18033fbdc: da 5c ab 2c                 	ficompl	0x2c(%rbx,%rbp,4)
18033fbe0: e8 d5 d3 8e 9c              	callq	0x11cc2cfba
18033fbe5: b3 85                       	movb	$-0x7b, %bl
18033fbe7: 12 40 f4                    	adcb	-0xc(%rax), %al
18033fbea: eb e0                       	jmp	0x18033fbcc <.text+0x32fbcc>
18033fbec: 55                          	pushq	%rbp
18033fbed: fd                          	std
18033fbee: 8c ab 57 4b 1c 22           	movw	%gs, 0x221c4b57(%rbx)
18033fbf4: d5 72 c0 4a 81 84           	rorb	$0x84, -0x7f(%r18)
18033fbfa: 92                          	xchgl	%edx, %eax
18033fbfb: 3f                          	<unknown>
18033fbfc: 8f 14 af                    	<unknown>
18033fbff: 5c                          	popq	%rsp
18033fc00: 60                          	<unknown>
18033fc01: 53                          	pushq	%rbx
18033fc02: 1e                          	<unknown>
18033fc03: 8c 9d b4 96 59 b3           	movw	%ds, -0x4ca6694c(%rbp)
18033fc09: 90                          	nop
18033fc0a: 88 ed                       	movb	%ch, %ch
18033fc0c: 6f                          	outsl	(%rsi), %dx
18033fc0d: a8 03                       	testb	$0x3, %al
18033fc0f: d6                          	<unknown>
18033fc10: 49 d5 81 2c 0a              	cvttps2pi	(%r10), %mm1
18033fc15: 8e c5                       	movl	%ebp, %es
18033fc17: 54                          	pushq	%rsp
18033fc18: 96                          	xchgl	%esi, %eax
18033fc19: cd 68                       	int	$0x68
18033fc1b: c9                          	leave
18033fc1c: f1                          	<unknown>
18033fc1d: ae                          	scasb	%es:(%rdi), %al
18033fc1e: 0a e6                       	orb	%dh, %ah
18033fc20: 49 90                       	xchgq	%r8, %rax
18033fc22: da ac 06 db 7e 96 c1        	fisubrl	-0x3e698125(%rsi,%rax)
18033fc29: 55                          	pushq	%rbp
18033fc2a: 52                          	pushq	%rdx
18033fc2b: 67 32 12                    	xorb	(%edx), %dl
18033fc2e: 6b 75 0c e4                 	imull	$-0x1c, 0xc(%rbp), %esi
18033fc32: 99                          	cltd
18033fc33: e9 e1 7f 84 2b              	jmp	0x1abb87c19
18033fc38: 21 6b de                    	andl	%ebp, -0x22(%rbx)
18033fc3b: 6a 09                       	pushq	$0x9
18033fc3d: d5 c7 fc 15 e8 65 cb d0     	paddb	-0x2f349a18(%rip), %mm2 # 0x150ff622d
18033fc45: 17                          	<unknown>
18033fc46: 3f                          	<unknown>
18033fc47: 7a c5                       	jp	0x18033fc0e <.text+0x32fc0e>
18033fc49: 2d f7 2e 2b ee              	subl	$0xee2b2ef7, %eax       # imm = 0xEE2B2EF7
18033fc4e: 83 e4 db                    	andl	$-0x25, %esp
18033fc51: dd d1                       	fst	%st(1)
18033fc53: 14 c5                       	adcb	$-0x3b, %al
18033fc55: c9                          	leave
18033fc56: e9 7c 62 0e 69              	jmp	0x1e9425ed7
18033fc5b: 73 42                       	jae	0x18033fc9f <.text+0x32fc9f>
18033fc5d: 1d 18 dc 10 a4              	sbbl	$0xa410dc18, %eax       # imm = 0xA410DC18
18033fc62: 24 62                       	andb	$0x62, %al
18033fc64: ee                          	outb	%al, %dx
18033fc65: a6                          	cmpsb	%es:(%rdi), (%rsi)
18033fc66: e7 e7                       	outl	%eax, $0xe7
18033fc68: ac                          	lodsb	(%rsi), %al
18033fc69: 56                          	pushq	%rsi
18033fc6a: 3e 2a 20                    	subb	%ds:(%rax), %ah
18033fc6d: 2c af                       	subb	$-0x51, %al
18033fc6f: 8e b8 a5 8c 84 39           	<unknown>
18033fc75: b7 92                       	movb	$-0x6e, %bh
18033fc77: f2 d6                       	<unknown>
18033fc79: 60                          	<unknown>
18033fc7a: 9d                          	popfq
18033fc7b: 76 cb                       	jbe	0x18033fc48 <.text+0x32fc48>
18033fc7d: 1c 70                       	sbbb	$0x70, %al
18033fc7f: 8f 44 98 70                 	popq	0x70(%rax,%rbx,4)
18033fc83: 42 4e 64 f3 d0 4f a5        	rep		rorb	%fs:-0x5b(%rdi)
18033fc8a: d0 b5 05 8d 82 ce           	<unknown>
18033fc90: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033fc91: 61                          	<unknown>
18033fc92: 36 c6 08                    	<unknown>
18033fc95: 8a 5e 31                    	movb	0x31(%rsi), %bl
18033fc98: 7f 9b                       	jg	0x18033fc35 <.text+0x32fc35>
18033fc9a: 98                          	cwtl
18033fc9b: b5 3a                       	movb	$0x3a, %ch
18033fc9d: a3 ba cc c1 70 6b 6e a7 61  	movabsl	%eax, 0x61a76e6b70c1ccba
18033fca6: 37                          	<unknown>
18033fca7: fe 48 8a                    	decb	-0x76(%rax)
18033fcaa: 3e e4 f2                    	inb	$0xf2, %al
18033fcad: 98                          	cwtl
18033fcae: 2b 1b                       	subl	(%rbx), %ebx
18033fcb0: 69 7f 68 00 a9 7f fd        	imull	$0xfd7fa900, 0x68(%rdi), %edi # imm = 0xFD7FA900
18033fcb7: 4e 32 53 0d                 	xorb	0xd(%rbx), %r10b
18033fcbb: 9c                          	pushfq
18033fcbc: 47 a2 c0 4c 8a d6 f2 a0 da 70       	movabsb	%al, 0x70daa0f2d68a4cc0
18033fcc6: 59                          	popq	%rcx
18033fcc7: 4c aa                       	stosb	%al, %es:(%rdi)
18033fcc9: 5a                          	popq	%rdx
18033fcca: 46 0b e2                    	orl	%edx, %r12d
18033fccd: 52                          	pushq	%rdx
18033fcce: 4e 7d 05                    	jge	0x18033fcd6 <.text+0x32fcd6>
18033fcd1: 30 0c 79                    	xorb	%cl, (%rcx,%rdi,2)
18033fcd4: f9                          	stc
18033fcd5: 34 a4                       	xorb	$-0x5c, %al
18033fcd7: 59                          	popq	%rcx
18033fcd8: 70 da                       	jo	0x18033fcb4 <.text+0x32fcb4>
18033fcda: 5a                          	popq	%rdx
18033fcdb: 43 71 b6                    	jno	0x18033fc94 <.text+0x32fc94>
18033fcde: 93                          	xchgl	%ebx, %eax
18033fcdf: b7 c9                       	movb	$-0x37, %bh
18033fce1: 0a ec                       	orb	%ah, %ch
18033fce3: 6b 58 d8 c7                 	imull	$-0x39, -0x28(%rax), %ebx
18033fce7: 45 ba 86 92 de 6e           	movl	$0x6ede9286, %r10d      # imm = 0x6EDE9286
18033fced: e9 e1 58 d1 d1              	jmp	0x1520555d3
18033fcf2: 07                          	<unknown>
18033fcf3: 41 58                       	popq	%r8
18033fcf5: 2f                          	<unknown>
18033fcf6: 83 9b 98 71 1a f0 d6        	sbbl	$-0x2a, -0xfe58e68(%rbx)
18033fcfd: f5                          	cmc
18033fcfe: f7 5f b4                    	negl	-0x4c(%rdi)
18033fd01: 52                          	pushq	%rdx
18033fd02: ca d5 96                    	lretl	$-0x692b                # imm = 0x96D5
18033fd05: 9a                          	<unknown>
18033fd06: 4c 3c b9                    	cmpb	$-0x47, %al
18033fd09: c3                          	retq
18033fd0a: 85 a8 25 65 c3 e6           	testl	%ebp, -0x193c9adb(%rax)
18033fd10: 7e 1f                       	jle	0x18033fd31 <.text+0x32fd31>
18033fd12: d4                          	<unknown>
18033fd13: d0 69 c8                    	shrb	-0x38(%rcx)
18033fd16: 95                          	xchgl	%ebp, %eax
18033fd17: b4 34                       	movb	$0x34, %ah
18033fd19: 31 df                       	xorl	%ebx, %edi
18033fd1b: 06                          	<unknown>
18033fd1c: a3 79 c1 9e 2b e1 68 e6 05  	movabsl	%eax, 0x5e668e12b9ec179
18033fd25: c8 47 d3 1a                 	enter	$-0x2cb9, $0x1a         # imm = 0xD347
18033fd29: 48 c6 3e                    	<unknown>
18033fd2c: e9 99 0a 6c 7a              	jmp	0x1faa007ca
18033fd31: b3 13                       	movb	$0x13, %bl
18033fd33: e0 b9                       	loopne	0x18033fcee <.text+0x32fcee>
18033fd35: be 27 85 4d ac              	movl	$0xac4d8527, %esi       # imm = 0xAC4D8527
18033fd3a: f7 7f 5b                    	idivl	0x5b(%rdi)
18033fd3d: ba b0 a7 fd fc              	movl	$0xfcfda7b0, %edx       # imm = 0xFCFDA7B0
18033fd42: 35 fa d9 93 88              	xorl	$0x8893d9fa, %eax       # imm = 0x8893D9FA
18033fd47: 14 4b                       	adcb	$0x4b, %al
18033fd49: 68 49 2a 84 07              	pushq	$0x7842a49              # imm = 0x7842A49
18033fd4e: ea                          	<unknown>
18033fd4f: b0 07                       	movb	$0x7, %al
18033fd51: df 02                       	filds	(%rdx)
18033fd53: 38 a1 1a 9c 95 cb           	cmpb	%ah, -0x346a63e6(%rcx)
18033fd59: 82                          	<unknown>
18033fd5a: b4 a3                       	movb	$-0x5d, %ah
18033fd5c: 9e                          	sahf
18033fd5d: 4d 1b 89 8c 8a ea 17        	sbbq	0x17ea8a8c(%r9), %r9
18033fd64: 47 b6 09                    	movb	$0x9, %r14b
18033fd67: 3e e8 c1 aa d0 79           	callq	0x1fa04a82e
18033fd6d: 0c 8d                       	orb	$-0x73, %al
18033fd6f: e1 ab                       	loope	0x18033fd1c <.text+0x32fd1c>
18033fd71: e4 9b                       	inb	$0x9b, %al
18033fd73: f7 84 8f 56 f7 5f 2a af 7e dd 7d    	testl	$0x7ddd7eaf, 0x2a5ff756(%rdi,%rcx,4) # imm = 0x7DDD7EAF
18033fd7e: 2d 39 c1 7e f9              	subl	$0xf97ec139, %eax       # imm = 0xF97EC139
18033fd83: c1 cb 85                    	rorl	$0x85, %ebx
18033fd86: 15 eb 96 d0 1d              	adcl	$0x1dd096eb, %eax       # imm = 0x1DD096EB
18033fd8b: 8c 1c 06                    	movw	%ds, (%rsi,%rax)
18033fd8e: ea                          	<unknown>
18033fd8f: e1 81                       	loope	0x18033fd12 <.text+0x32fd12>
18033fd91: 8e b7 e8 b5 a7 9b           	<unknown>
18033fd97: d7                          	xlatb
18033fd98: 1d 6c d2 35 7f              	sbbl	$0x7f35d26c, %eax       # imm = 0x7F35D26C
18033fd9d: 6b 2b 19                    	imull	$0x19, (%rbx), %ebp
18033fda0: 53                          	pushq	%rbx
18033fda1: e9 10 3b c9 cb              	jmp	0x14bfd38b6
18033fda6: ee                          	outb	%al, %dx
18033fda7: ed                          	inl	%dx, %eax
18033fda8: 1f                          	<unknown>
18033fda9: 64 f3 ef                    	rep		outl	%eax, %dx
18033fdac: a0 7d c0 98 11 b0 60 b9 f0  	movabsb	-0xf469f4fee673f83, %al
18033fdb5: 3f                          	<unknown>
18033fdb6: 73 8f                       	jae	0x18033fd47 <.text+0x32fd47>
18033fdb8: a3 0a b8 d2 96 f0 e4 5f 53  	movabsl	%eax, 0x535fe4f096d2b80a
18033fdc1: 61                          	<unknown>
18033fdc2: 1b 93 33 30 9e f3           	sbbl	-0xc61cfcd(%rbx), %edx
18033fdc8: 3f                          	<unknown>
18033fdc9: 4f f0 3f                    	<unknown>
18033fdcc: fe f1                       	<unknown>
18033fdce: fb                          	sti
18033fdcf: c7 02 af d1 52 d1           	movl	$0xd152d1af, (%rdx)     # imm = 0xD152D1AF
18033fdd5: 3a 14 08                    	cmpb	(%rax,%rcx), %dl
18033fdd8: 61                          	<unknown>
18033fdd9: 73 5e                       	jae	0x18033fe39 <.text+0x32fe39>
18033fddb: 99                          	cltd
18033fddc: 4d 46 56                    	pushq	%rsi
18033fddf: 61                          	<unknown>
18033fde0: 51                          	pushq	%rcx
18033fde1: fc                          	cld
18033fde2: 24 1a                       	andb	$0x1a, %al
18033fde4: 05 d5 24 ed 6e              	addl	$0x6eed24d5, %eax       # imm = 0x6EED24D5
18033fde9: 86 3d 1d c7 3c d3           	xchgb	%bh, -0x2cc338e3(%rip)  # 0x15370c50c
18033fdef: d4                          	<unknown>
18033fdf0: 1a 6a 14                    	sbbb	0x14(%rdx), %ch
18033fdf3: cf                          	iretl
18033fdf4: fe 09                       	decb	(%rcx)
18033fdf6: a8 6e                       	testb	$0x6e, %al
18033fdf8: 12 51 a8                    	adcb	-0x58(%rcx), %dl
18033fdfb: f7 d9                       	negl	%ecx
18033fdfd: 12 1f                       	adcb	(%rdi), %bl
18033fdff: c6 3a                       	<unknown>
18033fe01: 2f                          	<unknown>
18033fe02: 80 2e ad                    	subb	$-0x53, (%rsi)
18033fe05: 9b                          	wait
18033fe06: d4                          	<unknown>
18033fe07: 6e                          	outsb	(%rsi), %dx
18033fe08: 03 76 21                    	addl	0x21(%rsi), %esi
18033fe0b: fc                          	cld
18033fe0c: 1c ca                       	sbbb	$-0x36, %al
18033fe0e: 0a 03                       	orb	(%rbx), %al
18033fe10: 69 9a 00 cc 94 95 5c 56 22 96       	imull	$0x9622565c, -0x6a6b3400(%rdx), %ebx # imm = 0x9622565C
18033fe1a: cd 2b                       	int	$0x2b
18033fe1c: 95                          	xchgl	%ebp, %eax
18033fe1d: f4                          	hlt
18033fe1e: 78 51                       	js	0x18033fe71 <.text+0x32fe71>
18033fe20: b5 8f                       	movb	$-0x71, %ch
18033fe22: 42 e8 f6 aa f0 b7           	callq	0x13824a91e
18033fe28: 3a d9                       	cmpb	%cl, %bl
18033fe2a: 69 18 40 af 53 a6           	imull	$0xa653af40, (%rax), %ebx # imm = 0xA653AF40
18033fe30: 33 ee                       	xorl	%esi, %ebp
18033fe32: ad                          	lodsl	(%rsi), %eax
18033fe33: 96                          	xchgl	%esi, %eax
18033fe34: ab                          	stosl	%eax, %es:(%rdi)
18033fe35: 40 21 6f 00                 	andl	%ebp, (%rdi)
18033fe39: 94                          	xchgl	%esp, %eax
18033fe3a: 7c e9                       	jl	0x18033fe25 <.text+0x32fe25>
18033fe3c: 1e                          	<unknown>
18033fe3d: e7 cd                       	outl	%eax, $0xcd
18033fe3f: 9f                          	lahf
18033fe40: 45 0b 8f da 67 1c 84        	orl	-0x7be39826(%r15), %r9d
18033fe47: 92                          	xchgl	%edx, %eax
18033fe48: 0e                          	<unknown>
18033fe49: a8 13                       	testb	$0x13, %al
18033fe4b: e8 5c 54 b5 a5              	callq	0x125e952ac
18033fe50: 58                          	popq	%rax
18033fe51: 5c                          	popq	%rsp
18033fe52: 35 25 f5 bd a1              	xorl	$0xa1bdf525, %eax       # imm = 0xA1BDF525
18033fe57: d4                          	<unknown>
18033fe58: 6f                          	outsl	(%rsi), %dx
18033fe59: de 59 78                    	ficomps	0x78(%rcx)
18033fe5c: 3a 9f bf a2 d5 60           	cmpb	0x60d5a2bf(%rdi), %bl
18033fe62: e8 88 8a b0 69              	callq	0x1e9e488ef
18033fe67: 19 ae be c3 72 ce           	sbbl	%ebp, -0x318d3c42(%rsi)
18033fe6d: f9                          	stc
18033fe6e: 7c b3                       	jl	0x18033fe23 <.text+0x32fe23>
18033fe70: ad                          	lodsl	(%rsi), %eax
18033fe71: da b1 7a 07 7c bb           	fidivl	-0x4483f886(%rcx)
18033fe77: 49 38 d7                    	cmpb	%dl, %r15b
18033fe7a: f3 32 17                    	rep		xorb	(%rdi), %dl
18033fe7d: 7e 48                       	jle	0x18033fec7 <.text+0x32fec7>
18033fe7f: 8f 64 8b                    	<unknown>
18033fe82: e5 f1                       	inl	$0xf1, %eax
18033fe84: 7c a0                       	jl	0x18033fe26 <.text+0x32fe26>
18033fe86: 99                          	cltd
18033fe87: 91                          	xchgl	%ecx, %eax
18033fe88: 69 16 08 18 57 3f           	imull	$0x3f571808, (%rsi), %edx # imm = 0x3F571808
18033fe8e: f9                          	stc
18033fe8f: 3c b9                       	cmpb	$-0x47, %al
18033fe91: 9d                          	popfq
18033fe92: c0 11 5f                    	rclb	$0x5f, (%rcx)
18033fe95: 7f dd                       	jg	0x18033fe74 <.text+0x32fe74>
18033fe97: 34 a3                       	xorb	$-0x5d, %al
18033fe99: ab                          	stosl	%eax, %es:(%rdi)
18033fe9a: f1                          	<unknown>
18033fe9b: ed                          	inl	%dx, %eax
18033fe9c: c2 81 2f                    	retq	$0x2f81                 # imm = 0x2F81
18033fe9f: d1 ad 94 0d cd 24           	shrl	0x24cd0d94(%rbp)
18033fea5: 8e 4a 4e                    	movw	0x4e(%rdx), %cs
18033fea8: a7                          	cmpsl	%es:(%rdi), (%rsi)
18033fea9: e3 c2                       	jrcxz	0x18033fe6d <.text+0x32fe6d>
18033feab: 66 4c 5d                    	popq	%rbp
18033feae: 14 cd                       	adcb	$-0x33, %al
18033feb0: c7 d6                       	<unknown>
18033feb2: 01 f9                       	addl	%edi, %ecx
18033feb4: 1a 81 85 6a db 44           	sbbb	0x44db6a85(%rcx), %al
18033feba: 45 68 c8 47 3f b6           	pushq	$-0x49c0b838            # imm = 0xB63F47C8
18033fec0: ec                          	inb	%dx, %al
18033fec1: bc a8 be 90 b1              	movl	$0xb190bea8, %esp       # imm = 0xB190BEA8
18033fec6: c7 4c dd f8                 	<unknown>
18033feca: 84 97 c4 a6 bd 7b           	testb	%dl, 0x7bbda6c4(%rdi)
18033fed0: ed                          	inl	%dx, %eax
18033fed1: ea                          	<unknown>
18033fed2: ec                          	inb	%dx, %al
18033fed3: d9 e4                       	ftst
18033fed5: 0a 8f e9 2f 86 bb           	orb	-0x4479d017(%rdi), %cl
18033fedb: 2b f6                       	subl	%esi, %esi
18033fedd: 2c 60                       	subb	$0x60, %al
18033fedf: 42 ce                       	<unknown>
18033fee1: 67 22 62 41                 	andb	0x41(%edx), %ah
18033fee5: 26 61                       	<unknown>
18033fee7: d7                          	xlatb
18033fee8: cd 4b                       	int	$0x4b
18033feea: 8a 73 96                    	movb	-0x6a(%rbx), %dh
18033feed: 59                          	popq	%rcx
18033feee: 4f 7c 60                    	jl	0x18033ff51 <.text+0x32ff51>
18033fef1: ed                          	inl	%dx, %eax
18033fef2: 66 2c 74                    	subb	$0x74, %al
18033fef5: 71 0d                       	jno	0x18033ff04 <.text+0x32ff04>
18033fef7: b5 2b                       	movb	$0x2b, %ch
18033fef9: 0b 93 13 bd 86 01           	orl	0x186bd13(%rbx), %edx
18033feff: 41 cb                       	lretl
18033ff01: b6 86                       	movb	$-0x7a, %dh
18033ff03: 72 d7                       	jb	0x18033fedc <.text+0x32fedc>
18033ff05: 64 07                       	<unknown>
18033ff07: 81 aa 2d 38 f5 27 e7 4a 64 85       	subl	$0x85644ae7, 0x27f5382d(%rdx) # imm = 0x85644AE7
18033ff11: 5a                          	popq	%rdx
18033ff12: 6a a2                       	pushq	$-0x5e
18033ff14: 0c 72                       	orb	$0x72, %al
18033ff16: e6 9d                       	outb	%al, $0x9d
18033ff18: 65 a2 4d 0d d1 14 44 35 30 ea       	movabsb	%al, %gs:-0x15cfcabbeb2ef2b3
18033ff22: b9 e7 cc 57 3b              	movl	$0x3b57cce7, %ecx       # imm = 0x3B57CCE7
18033ff27: 44 50                       	pushq	%rax
18033ff29: 97                          	xchgl	%edi, %eax
18033ff2a: 8d 5a 7d                    	leal	0x7d(%rdx), %ebx
18033ff2d: 50                          	pushq	%rax
18033ff2e: 4b 7d 96                    	jge	0x18033fec7 <.text+0x32fec7>
18033ff31: 1f                          	<unknown>
18033ff32: dc 01                       	faddl	(%rcx)
18033ff34: 91                          	xchgl	%ecx, %eax
18033ff35: 16                          	<unknown>
18033ff36: b5 94                       	movb	$-0x6c, %ch
18033ff38: 34 52                       	xorb	$0x52, %al
18033ff3a: 7b c2                       	jnp	0x18033fefe <.text+0x32fefe>
18033ff3c: 19 48 2d                    	sbbl	%ecx, 0x2d(%rax)
18033ff3f: f7 ca                       	<unknown>
18033ff41: fd                          	std
18033ff42: 25 d5 c2 5f ec              	andl	$0xec5fc2d5, %eax       # imm = 0xEC5FC2D5
18033ff47: 7d d9                       	jge	0x18033ff22 <.text+0x32ff22>
18033ff49: 67 4b e6 48                 	addr32		outb	%al, $0x48
18033ff4d: 91                          	xchgl	%ecx, %eax
18033ff4e: c7 bc 99 8c 59 9f 06        	<unknown>
18033ff55: c4 af 25                    	<unknown>
18033ff58: d8 50 6f                    	fcoms	0x6f(%rax)
18033ff5b: 5c                          	popq	%rsp
18033ff5c: d4                          	<unknown>
18033ff5d: bf 7e be 38 cb              	movl	$0xcb38be7e, %edi       # imm = 0xCB38BE7E
18033ff62: 6b e4 3b                    	imull	$0x3b, %esp, %esp
18033ff65: 39 d1                       	cmpl	%edx, %ecx
18033ff67: 82                          	<unknown>
18033ff68: 80 c0 6a                    	addb	$0x6a, %al
18033ff6b: b1 26                       	movb	$0x26, %cl
18033ff6d: ee                          	outb	%al, %dx
18033ff6e: 1e                          	<unknown>
18033ff6f: c7 27                       	<unknown>
18033ff71: a9 09 a5 7f 74              	testl	$0x747fa509, %eax       # imm = 0x747FA509
18033ff76: a2 6b e4 9b c8 f1 6b 3a 8d  	movabsb	%al, -0x72c5940e37641b95
18033ff7f: 9d                          	popfq
18033ff80: f8                          	clc
18033ff81: a8 09                       	testb	$0x9, %al
18033ff83: 6d                          	insl	%dx, %es:(%rdi)
18033ff84: 29 22                       	subl	%esp, (%rdx)
18033ff86: f6 4d 2a                    	<unknown>
18033ff89: 49 db 92 2a c9 38 cb        	fistl	-0x34c736d6(%r10)
18033ff90: 9c                          	pushfq
18033ff91: 32 93 46 f7 99 04           	xorb	0x499f746(%rbx), %dl
18033ff97: 58                          	popq	%rax
18033ff98: 8b e8                       	movl	%eax, %ebp
18033ff9a: 47 d1 70 2e                 	<unknown>
18033ff9e: 58                          	popq	%rax
18033ff9f: ef                          	outl	%eax, %dx
18033ffa0: f7 f7                       	divl	%edi
18033ffa2: 0b 57 a6                    	orl	-0x5a(%rdi), %edx
18033ffa5: c8 c3 a1 47                 	enter	$-0x5e3d, $0x47         # imm = 0xA1C3
18033ffa9: fa                          	cli
18033ffaa: 79 df                       	jns	0x18033ff8b <.text+0x32ff8b>
18033ffac: 0e                          	<unknown>
18033ffad: 83 1b 6b                    	sbbl	$0x6b, (%rbx)
18033ffb0: ed                          	inl	%dx, %eax
18033ffb1: 6e                          	outsb	(%rsi), %dx
18033ffb2: f3 d8 cd                    	rep		fmul	%st(5), %st
18033ffb5: 55                          	pushq	%rbp
18033ffb6: 99                          	cltd
18033ffb7: 09 05 e2 d7 03 b9           	orl	%eax, -0x46fc281e(%rip) # 0x13937d79f
18033ffbd: 65 b9 a8 89 4a 09           	movl	$0x94a89a8, %ecx        # imm = 0x94A89A8
18033ffc3: 30 da                       	xorb	%bl, %dl
18033ffc5: 05 fe 23 a8 d2              	addl	$0xd2a823fe, %eax       # imm = 0xD2A823FE
18033ffca: a2 36 d1 fc 73 30 b9 3e bf  	movabsb	%al, -0x40c146cf8c032eca
18033ffd3: 97                          	xchgl	%edi, %eax
18033ffd4: 3f                          	<unknown>
18033ffd5: 8c 08                       	movw	%cs, (%rax)
18033ffd7: ba d3 28 53 83              	movl	$0x835328d3, %edx       # imm = 0x835328D3
18033ffdc: 31 2f                       	xorl	%ebp, (%rdi)
18033ffde: db eb                       	fucomi	%st(3), %st
18033ffe0: 3d fc f3 96 11              	cmpl	$0x1196f3fc, %eax       # imm = 0x1196F3FC
18033ffe5: de c8                       	fmulp	%st, %st(0)
18033ffe7: dd ab 37 a5 2c 9f           	<unknown>
18033ffed: 0b b4 94 d4 4e a4 d1        	orl	-0x2e5bb12c(%rsp,%rdx,4), %esi
18033fff4: 75 53                       	jne	0x180340049 <.text+0x330049>
18033fff6: 63 74 d8 b8                 	movslq	-0x48(%rax,%rbx,8), %esi
18033fffa: 93                          	xchgl	%ebx, %eax
18033fffb: 9e                          	sahf
18033fffc: 15 7b 69 f9 b0              	adcl	$0xb0f9697b, %eax       # imm = 0xB0F9697B
180340001: 21 09                       	andl	%ecx, (%rcx)
180340003: c9                          	leave
180340004: d3 dc                       	rcrl	%cl, %esp
180340006: ee                          	outb	%al, %dx
180340007: 61                          	<unknown>
180340008: a9 17 85 5a 19              	testl	$0x195a8517, %eax       # imm = 0x195A8517
18034000d: 6a 65                       	pushq	$0x65
18034000f: 66 66 13 98 23 75 25 c5     	adcw	-0x3ada8add(%rax), %bx
180340017: 62 b9 8f f1 07              	<unknown>
18034001c: 0e                          	<unknown>
18034001d: bc 09 47 0e 4c              	movl	$0x4c0e4709, %esp       # imm = 0x4C0E4709
180340022: 69 b6 37 42 70 e4 6c dc 93 5c       	imull	$0x5c93dc6c, -0x1b8fbdc9(%rsi), %esi # imm = 0x5C93DC6C
18034002c: d4                          	<unknown>
18034002d: 3b 0d c6 2e 28 ce           	cmpl	-0x31d7d13a(%rip), %ecx # 0x14e5c2ef9
180340033: f7 33                       	divl	(%rbx)
180340035: db 7c 7e 55                 	fstpt	0x55(%rsi,%rdi,2)
180340039: 80 dc f7                    	sbbb	$-0x9, %ah
18034003c: 10 67 37                    	adcb	%ah, 0x37(%rdi)
18034003f: f2 bc f0 d3 5e 36           	repne		movl	$0x365ed3f0, %esp # imm = 0x365ED3F0
180340045: 48 29 0b                    	subq	%rcx, (%rbx)
180340048: 61                          	<unknown>
180340049: c7 d8                       	<unknown>
18034004b: 9f                          	lahf
18034004c: b9 20 ba e0 bd              	movl	$0xbde0ba20, %ecx       # imm = 0xBDE0BA20
180340051: 88 3b                       	movb	%bh, (%rbx)
180340053: 87 bb 6c 3f fe 9b           	xchgl	%edi, -0x6401c094(%rbx)
180340059: 98                          	cwtl
18034005a: 9b                          	wait
18034005b: 3a 1c c9                    	cmpb	(%rcx,%rcx,8), %bl
18034005e: cd f8                       	int	$0xf8
180340060: 2a 2b                       	subb	(%rbx), %ch
180340062: 69 38 8b 75 e6 01           	imull	$0x1e6758b, (%rax), %edi # imm = 0x1E6758B
180340068: e7 4f                       	outl	%eax, $0x4f
18034006a: 5b                          	popq	%rbx
18034006b: 0c 0f                       	orb	$0xf, %al
18034006d: 6e                          	outsb	(%rsi), %dx
18034006e: 11 4c 2d ef                 	adcl	%ecx, -0x11(%rbp,%rbp)
180340072: a1 cc 51 e1 00 83 cd 52 a8  	movabsl	-0x57ad327cff1eae34, %eax
18034007b: dc 1c ce                    	fcompl	(%rsi,%rcx,8)
18034007e: a7                          	cmpsl	%es:(%rdi), (%rsi)
18034007f: 19 e5                       	sbbl	%esp, %ebp
180340081: 2b 48 48                    	subl	0x48(%rax), %ecx
180340084: 19 2c 08                    	sbbl	%ebp, (%rax,%rcx)
180340087: f3 3b 9e 3d a0 94 18        	rep		cmpl	0x1894a03d(%rsi), %ebx
18034008e: f9                          	stc
18034008f: 8a 20                       	movb	(%rax), %ah
180340091: ad                          	lodsl	(%rsi), %eax
180340092: 85 4d c5                    	testl	%ecx, -0x3b(%rbp)
180340095: 2b 82 45 31 0d 72           	subl	0x720d3145(%rdx), %eax
18034009b: 91                          	xchgl	%ecx, %eax
18034009c: e0 54                       	loopne	0x1803400f2 <.text+0x3300f2>
18034009e: 19 39                       	sbbl	%edi, (%rcx)
1803400a0: 91                          	xchgl	%ecx, %eax
1803400a1: f6 71 26                    	divb	0x26(%rcx)
1803400a4: c3                          	retq
1803400a5: e8 ca 60 9e 8d              	callq	0x10dd26174
1803400aa: 09 8a 68 3b 85 d6           	orl	%ecx, -0x297ac498(%rdx)
1803400b0: 2f                          	<unknown>
1803400b1: 73 64                       	jae	0x180340117 <.text+0x330117>
1803400b3: 03 34 47                    	addl	(%rdi,%rax,2), %esi
1803400b6: 35 64 8f 15 9e              	xorl	$0x9e158f64, %eax       # imm = 0x9E158F64
1803400bb: c7 ef                       	<unknown>
1803400bd: 2f                          	<unknown>
1803400be: bf 8f 54 87 64              	movl	$0x6487548f, %edi       # imm = 0x6487548F
1803400c3: 29 8c ba ba ac 40 a1        	subl	%ecx, -0x5ebf5346(%rdx,%rdi,4)
1803400ca: 62 83 d6 e3 36              	<unknown>
1803400cf: 35 0f c0 a7 cc              	xorl	$0xcca7c00f, %eax       # imm = 0xCCA7C00F
1803400d4: 40 04 7f                    	addb	$0x7f, %al
1803400d7: e2 4a                       	loop	0x180340123 <.text+0x330123>
1803400d9: ad                          	lodsl	(%rsi), %eax
1803400da: c0 24 d0 d9                 	shlb	$0xd9, (%rax,%rdx,8)
1803400de: c4 8f e4                    	<unknown>
1803400e1: 94                          	xchgl	%esp, %eax
1803400e2: f4                          	hlt
1803400e3: 71 a4                       	jno	0x180340089 <.text+0x330089>
1803400e5: bd c2 6b 33 2f              	movl	$0x2f336bc2, %ebp       # imm = 0x2F336BC2
1803400ea: 3a 33                       	cmpb	(%rbx), %dh
1803400ec: f6 6d 64                    	imulb	0x64(%rbp)
1803400ef: d7                          	xlatb
1803400f0: cf                          	iretl
1803400f1: 30 12                       	xorb	%dl, (%rdx)
1803400f3: 35 d6 6e 72 45              	xorl	$0x45726ed6, %eax       # imm = 0x45726ED6
1803400f8: f8                          	clc
1803400f9: f3 33 df                    	rep		xorl	%edi, %ebx
1803400fc: a2 a8 c3 a0 49 c4 29 7f 5a  	movabsb	%al, 0x5a7f29c449a0c3a8
180340105: f3 b7 ab                    	rep		movb	$-0x55, %bh
180340108: 68 19 67 85 9b              	pushq	$-0x647a98e7            # imm = 0x9B856719
18034010d: 9d                          	popfq
18034010e: 24 86                       	andb	$-0x7a, %al
180340110: 80 6f 67 42                 	subb	$0x42, 0x67(%rdi)
180340114: 03 b1 fe db e4 ae           	addl	-0x511b2402(%rcx), %esi
18034011a: 56                          	pushq	%rsi
18034011b: 61                          	<unknown>
18034011c: d1 40 9b                    	roll	-0x65(%rax)
18034011f: 88 9c 78 e2 ec 62 bb        	movb	%bl, -0x449d131e(%rax,%rdi,2)
180340126: 9e                          	sahf
180340127: c7 bd cb 5d bc dc           	<unknown>
18034012d: 09 bc 4d e1 bd e5 d8        	orl	%edi, -0x271a421f(%rbp,%rcx,2)
180340134: bd 08 ba d8 b3              	movl	$0xb3d8ba08, %ebp       # imm = 0xB3D8BA08
180340139: 09 f7                       	orl	%esi, %edi
18034013b: 3a 49 66                    	cmpb	0x66(%rcx), %cl
18034013e: 98                          	cwtl
18034013f: ac                          	lodsb	(%rsi), %al
180340140: f3 f5                       	rep		cmc
180340142: 77 d4                       	ja	0x180340118 <.text+0x330118>
180340144: 16                          	<unknown>
180340145: f1                          	<unknown>
180340146: ea                          	<unknown>
180340147: c4 48 c4                    	<unknown>
18034014a: af                          	scasl	%es:(%rdi), %eax
18034014b: 07                          	<unknown>
18034014c: 0f 4e ec                    	cmovlel	%esp, %ebp
18034014f: 1f                          	<unknown>
180340150: ba 08 de b8 d2              	movl	$0xd2b8de08, %edx       # imm = 0xD2B8DE08
180340155: 09 fd                       	orl	%edi, %ebp
180340157: 24 86                       	andb	$-0x7a, %al
180340159: 62 bd db dd 28 45 03        	<unknown>
180340160: b4 4a                       	movb	$0x4a, %ah
180340162: 88 33                       	movb	%dh, (%rbx)
180340164: ba 55 2a 57 f8              	movl	$0xf8572a55, %edx       # imm = 0xF8572A55
180340169: 26 2c 19                    	subb	$0x19, %al
18034016c: 65 db cb                    	fcmovne	%st(3), %st
18034016f: f1                          	<unknown>
180340170: 73 0b                       	jae	0x18034017d <.text+0x33017d>
180340172: fb                          	sti
180340173: 3b 38                       	cmpl	(%rax), %edi
180340175: 45 ac                       	lodsb	(%rsi), %al
180340177: 07                          	<unknown>
180340178: c1 e2 d2                    	shll	$0xd2, %edx
18034017b: fe 00                       	incb	(%rax)
18034017d: db d0                       	fcmovnbe	%st(0), %st
18034017f: 83 19 7f                    	sbbl	$0x7f, (%rcx)
180340182: aa                          	stosb	%al, %es:(%rdi)
180340183: f6 32                       	divb	(%rdx)
180340185: 75 62                       	jne	0x1803401e9 <.text+0x3301e9>
180340187: 0d b2 8f cb 39              	orl	$0x39cb8fb2, %eax       # imm = 0x39CB8FB2
18034018c: c4 d5 d0                    	<unknown>
18034018f: ba f1 8d a3 61              	movl	$0x61a38df1, %edx       # imm = 0x61A38DF1
180340194: fc                          	cld
180340195: df dc                       	<unknown>
180340197: ae                          	scasb	%es:(%rdi), %al
180340198: 45 12 96 33 78 dc c4        	adcb	-0x3b2387cd(%r14), %r10b
18034019f: 2e c1 1a 9d                 	rcrl	$0x9d, %cs:(%rdx)
1803401a3: 01 04 fd 7c c7 e9 61        	addl	%eax, 0x61e9c77c(,%rdi,8)
1803401aa: 7e 9e                       	jle	0x18034014a <.text+0x33014a>
1803401ac: 43 d0 c6                    	rolb	%r14b
1803401af: 98                          	cwtl
1803401b0: 35 78 35 81 ca              	xorl	$0xca813578, %eax       # imm = 0xCA813578
1803401b5: 23 15 0b 18 41 0f           	andl	0xf41180b(%rip), %edx   # 0x18f7519c6
1803401bb: 2d 5c 56 36 a6              	subl	$0xa636565c, %eax       # imm = 0xA636565C
1803401c0: 83 7a 95 b0                 	cmpl	$-0x50, -0x6b(%rdx)
1803401c4: e5 fc                       	inl	$0xfc, %eax
1803401c6: 1e                          	<unknown>
1803401c7: 9b                          	wait
1803401c8: 22 96 c2 7b a5 69           	andb	0x69a57bc2(%rsi), %dl
1803401ce: 81 b9 d6 c5 ed 01 df d3 2f c7       	cmpl	$0xc72fd3df, 0x1edc5d6(%rcx) # imm = 0xC72FD3DF
1803401d8: 26 9d                       	popfq
1803401da: 74 62                       	je	0x18034023e <.text+0x33023e>
1803401dc: 6e                          	outsb	(%rsi), %dx
1803401dd: bb 99 40 ce 95              	movl	$0x95ce4099, %ebx       # imm = 0x95CE4099
1803401e2: 67 90                       	addr32		nop
1803401e4: 54                          	pushq	%rsp
1803401e5: 47 c5 ca f6                 	<unknown>
1803401e9: 6f                          	outsl	(%rsi), %dx
1803401ea: 85 53 db                    	testl	%edx, -0x25(%rbx)
1803401ed: 43 49 f8                    	clc
1803401f0: 90                          	nop
1803401f1: dd bf 26 0b 1a 5c           	fnstsw	0x5c1a0b26(%rdi)
1803401f7: b0 5a                       	movb	$0x5a, %al
1803401f9: 98                          	cwtl
1803401fa: 82                          	<unknown>
1803401fb: 1a 94 2c 13 fb 8f b4        	sbbb	-0x4b7004ed(%rsp,%rbp), %dl
180340202: 92                          	xchgl	%edx, %eax
180340203: c8 46 a1 e4                 	enter	$-0x5eba, $-0x1c        # imm = 0xA146
180340207: 75 5c                       	jne	0x180340265 <.text+0x330265>
180340209: a7                          	cmpsl	%es:(%rdi), (%rsi)
18034020a: 55                          	pushq	%rbp
18034020b: 78 71                       	js	0x18034027e <.text+0x33027e>
18034020d: d9 3b                       	fnstcw	(%rbx)
18034020f: 59                          	popq	%rcx
180340210: bc d4 7e eb 93              	movl	$0x93eb7ed4, %esp       # imm = 0x93EB7ED4
180340215: 2d 26 29 37 58              	subl	$0x58372926, %eax       # imm = 0x58372926
18034021a: 07                          	<unknown>
18034021b: dc dc                       	<unknown>
18034021d: 78 b6                       	js	0x1803401d5 <.text+0x3301d5>
18034021f: 78 f4                       	js	0x180340215 <.text+0x330215>
180340221: 65 92                       	xchgl	%edx, %eax
180340223: 21 7a 5b                    	andl	%edi, 0x5b(%rdx)
180340226: cb                          	lretl
180340227: 89 eb                       	movl	%ebp, %ebx
180340229: 0f dd 5a e9                 	paddusw	-0x17(%rdx), %mm3
18034022d: a2 3d c3 6f 5d 83 48 fb 0b  	movabsb	%al, 0xbfb48835d6fc33d
180340236: c3                          	retq
180340237: 7c 45                       	jl	0x18034027e <.text+0x33027e>
180340239: 92                          	xchgl	%edx, %eax
18034023a: 12 8b 10 bd c6 18           	adcb	0x18c6bd10(%rbx), %cl
180340240: e1 86                       	loope	0x1803401c8 <.text+0x3301c8>
180340242: 11 af 95 de 18 67           	adcl	%ebp, 0x6718de95(%rdi)
180340248: 07                          	<unknown>
180340249: 68 9b 47 38 62              	pushq	$0x6238479b             # imm = 0x6238479B
18034024e: b6 49                       	movb	$0x49, %dh
180340250: 7a a0                       	jp	0x1803401f2 <.text+0x3301f2>
180340252: 22 4e c6                    	andb	-0x3a(%rsi), %cl
180340255: 33 bb 60 7e cb 2b           	xorl	0x2bcb7e60(%rbx), %edi
18034025b: 24 be                       	andb	$-0x42, %al
18034025d: a5                          	movsl	(%rsi), %es:(%rdi)
18034025e: 18 34 fe                    	sbbb	%dh, (%rsi,%rdi,8)
180340261: 63 f3                       	movslq	%ebx, %esi
180340263: 44 84 d4                    	testb	%r10b, %spl
180340266: b8 d6 a4 fb 00              	movl	$0xfba4d6, %eax         # imm = 0xFBA4D6
18034026b: 79 97                       	jns	0x180340204 <.text+0x330204>
18034026d: 69 03 aa 7e 14 8e           	imull	$0x8e147eaa, (%rbx), %eax # imm = 0x8E147EAA
180340273: 62 da f3 dc 70 68 aa        	<unknown>
18034027a: f6 4d a7                    	<unknown>
18034027d: 46 d1 af 1d be 49 9f        	shrl	-0x60b641e3(%rdi)
180340284: 6f                          	outsl	(%rsi), %dx
180340285: 24 85                       	andb	$-0x7b, %al
180340287: 37                          	<unknown>
180340288: eb 91                       	jmp	0x18034021b <.text+0x33021b>
18034028a: 36 c8 bd bb df              	enter	$-0x4443, $-0x21        # imm = 0xBBBD
18034028f: 9e                          	sahf
180340290: 1f                          	<unknown>
180340291: f3 30 9f 90 b2 c6 42        	rep		xorb	%bl, 0x42c6b290(%rdi)
180340298: 05 c3 a8 cc 46              	addl	$0x46cca8c3, %eax       # imm = 0x46CCA8C3
18034029d: 71 11                       	jno	0x1803402b0 <.text+0x3302b0>
18034029f: f4                          	hlt
1803402a0: 40 91                       	xchgl	%ecx, %eax
1803402a2: 71 77                       	jno	0x18034031b <.text+0x33031b>
1803402a4: 00 bf 7d ce a4 d9           	addb	%bh, -0x265b3183(%rdi)
1803402aa: dd cc                       	<unknown>
1803402ac: 84 db                       	testb	%bl, %bl
1803402ae: 33 7f 5d                    	xorl	0x5d(%rdi), %edi
1803402b1: d4                          	<unknown>
1803402b2: 39 27                       	cmpl	%esp, (%rdi)
1803402b4: 10 4c 92 e1                 	adcb	%cl, -0x1f(%rdx,%rdx,4)
1803402b8: 1d 0d 07 5f d3              	sbbl	$0xd35f070d, %eax       # imm = 0xD35F070D
1803402bd: c1 aa 4d b7 fc 5b 0f        	shrl	$0xf, 0x5bfcb74d(%rdx)
1803402c4: c1 1d 79 35 c1 11 54        	rcrl	$0x54, 0x11c13579(%rip) # 0x191f53844
1803402cb: 7a 4f                       	jp	0x18034031c <.text+0x33031c>
1803402cd: a8 53                       	testb	$0x53, %al
1803402cf: 38 d0                       	cmpb	%dl, %al
1803402d1: eb d4                       	jmp	0x1803402a7 <.text+0x3302a7>
1803402d3: ca 1c 33                    	lretl	$0x331c                 # imm = 0x331C
1803402d6: b3 4e                       	movb	$0x4e, %bl
1803402d8: e7 b1                       	outl	%eax, $0xb1
1803402da: 42 39 93 0f b5 a4 1c        	cmpl	%edx, 0x1ca4b50f(%rbx)
1803402e1: bd 4f 4d 72 fa              	movl	$0xfa724d4f, %ebp       # imm = 0xFA724D4F
1803402e6: e2 c9                       	loop	0x1803402b1 <.text+0x3302b1>
1803402e8: 72 22                       	jb	0x18034030c <.text+0x33030c>
1803402ea: b7 0c                       	movb	$0xc, %bh
1803402ec: c5 4c b4                    	<unknown>
1803402ef: f4                          	hlt
1803402f0: 43 60                       	<unknown>
1803402f2: 9c                          	pushfq
1803402f3: 34 db                       	xorb	$-0x25, %al
1803402f5: 40 8b 62 13                 	movl	0x13(%rdx), %esp
1803402f9: 52                          	pushq	%rdx
1803402fa: 3a ae e6 a9 47 9c           	cmpb	-0x63b8561a(%rsi), %ch
180340300: 90                          	nop
180340301: 55                          	pushq	%rbp
180340302: 97                          	xchgl	%edi, %eax
180340303: be a3 a4 aa b7              	movl	$0xb7aaa4a3, %esi       # imm = 0xB7AAA4A3
180340308: 34 0d                       	xorb	$0xd, %al
18034030a: 2d 40 cf 98 59              	subl	$0x5998cf40, %eax       # imm = 0x5998CF40
18034030f: e0 e7                       	loopne	0x1803402f8 <.text+0x3302f8>
180340311: 6a 1e                       	pushq	$0x1e
180340313: b1 20                       	movb	$0x20, %cl
180340315: e5 3d                       	inl	$0x3d, %eax
180340317: 7e 85                       	jle	0x18034029e <.text+0x33029e>
180340319: 35 fe 1c 46 bf              	xorl	$0xbf461cfe, %eax       # imm = 0xBF461CFE
18034031e: 26 ab                       	stosl	%eax, %es:(%rdi)
180340320: a1 a2 73 98 4e c4 0c fa c1  	movabsl	-0x3e05f33bb1678c5e, %eax
180340329: fc                          	cld
18034032a: 88 7a 21                    	movb	%bh, 0x21(%rdx)
18034032d: a1 b1 1e 8d 94 1e 63 2c 9c  	movabsl	-0x63d39ce16b72e14f, %eax
180340336: 3c eb                       	cmpb	$-0x15, %al
180340338: 53                          	pushq	%rbx
180340339: 3d 15 1a d4 bd              	cmpl	$0xbdd41a15, %eax       # imm = 0xBDD41A15
18034033e: d8 d7                       	fcom	%st(7)
180340340: d6                          	<unknown>
180340341: 3b d3                       	cmpl	%ebx, %edx
180340343: ab                          	stosl	%eax, %es:(%rdi)
180340344: b3 7e                       	movb	$0x7e, %bl
180340346: f0                          	lock
180340347: 12 5f d8                    	adcb	-0x28(%rdi), %bl
18034034a: e5 58                       	inl	$0x58, %eax
18034034c: 0e                          	<unknown>
18034034d: 58                          	popq	%rax
18034034e: c6 57 1a                    	<unknown>
180340351: 16                          	<unknown>
180340352: df 49 60                    	fisttps	0x60(%rcx)
180340355: 80 1c dc 98                 	sbbb	$-0x68, (%rsp,%rbx,8)
180340359: 42 4c 76 2d                 	jbe	0x18034038a <.text+0x33038a>
18034035d: 3d 39 1f 2d cd              	cmpl	$0xcd2d1f39, %eax       # imm = 0xCD2D1F39
180340362: 2a c8                       	subb	%al, %cl
180340364: d3 e4                       	shll	%cl, %esp
180340366: a6                          	cmpsb	%es:(%rdi), (%rsi)
180340367: 0e                          	<unknown>
180340368: 2c 98                       	subb	$-0x68, %al
18034036a: 82                          	<unknown>
18034036b: 34 3d                       	xorb	$0x3d, %al
18034036d: ba 7b 59 4c 6f              	movl	$0x6f4c597b, %edx       # imm = 0x6F4C597B
180340372: 52                          	pushq	%rdx
180340373: 18 dc                       	sbbb	%bl, %ah
180340375: 46 7f 5b                    	jg	0x1803403d3 <.text+0x3303d3>
180340378: f2                          	xacquire
180340379: 95                          	xchgl	%ebp, %eax
18034037a: 73 87                       	jae	0x180340303 <.text+0x330303>
18034037c: e9 87 03 bc 11              	jmp	0x191f00708
180340381: 20 62 3f                    	andb	%ah, 0x3f(%rdx)
180340384: 11 29                       	adcl	%ebp, (%rcx)
180340386: 86 02                       	xchgb	%al, (%rdx)
180340388: 65 14 0b                    	adcb	$0xb, %al
18034038b: a4                          	movsb	(%rsi), %es:(%rdi)
18034038c: 38 9a 77 ad 5f c6           	cmpb	%bl, -0x39a05289(%rdx)
180340392: d1 d2                       	rcll	%edx
180340394: b1 74                       	movb	$0x74, %cl
180340396: cf                          	iretl
180340397: 97                          	xchgl	%edi, %eax
180340398: b7 56                       	movb	$0x56, %bh
18034039a: c0 6b 83 f0                 	shrb	$0xf0, -0x7d(%rbx)
18034039e: 87 43 35                    	xchgl	%eax, 0x35(%rbx)
1803403a1: 6d                          	insl	%dx, %es:(%rdi)
1803403a2: 36 aa                       	stosb	%al, %es:(%rdi)
1803403a4: 87 5d 91                    	xchgl	%ebx, -0x6f(%rbp)
1803403a7: e4 67                       	inb	$0x67, %al
1803403a9: b4 0c                       	movb	$0xc, %ah
1803403ab: 55                          	pushq	%rbp
1803403ac: f1                          	<unknown>
1803403ad: 49 27                       	<unknown>
1803403af: d3 ae be fc 96 ba           	shrl	%cl, -0x45690342(%rsi)
1803403b5: 52                          	pushq	%rdx
1803403b6: 74 95                       	je	0x18034034d <.text+0x33034d>
1803403b8: 5b                          	popq	%rbx
1803403b9: 58                          	popq	%rax
1803403ba: c0 ed a3                    	shrb	$0xa3, %ch
1803403bd: b3 03                       	movb	$0x3, %bl
1803403bf: bc 5c 0c 2c 19              	movl	$0x192c0c5c, %esp       # imm = 0x192C0C5C
1803403c4: f7 9c f6 00 d5 79 77        	negl	0x7779d500(%rsi,%rsi,8)
1803403cb: 65 36 07                    	<unknown>
1803403ce: b6 43                       	movb	$0x43, %dh
1803403d0: 72 07                       	jb	0x1803403d9 <.text+0x3303d9>
1803403d2: 78 10                       	js	0x1803403e4 <.text+0x3303e4>
1803403d4: 6c                          	insb	%dx, %es:(%rdi)
1803403d5: d3 d7                       	rcll	%cl, %edi
1803403d7: 36 16                       	<unknown>
1803403d9: b9 84 51 be 07              	movl	$0x7be5184, %ecx        # imm = 0x7BE5184
1803403de: 60                          	<unknown>
1803403df: 42 2b 0c 72                 	subl	(%rdx,%r14,2), %ecx
1803403e3: ae                          	scasb	%es:(%rdi), %al
1803403e4: 77 77                       	ja	0x18034045d <.text+0x33045d>
1803403e6: 72 24                       	jb	0x18034040c <.text+0x33040c>
1803403e8: 44 ed                       	inl	%dx, %eax
1803403ea: 13 a5 cc 26 6f 62           	adcl	0x626f26cc(%rbp), %esp
1803403f0: db d6                       	fcmovnbe	%st(6), %st
1803403f2: 1f                          	<unknown>
1803403f3: 86 d8                       	xchgb	%al, %bl
1803403f5: 36 7f 41                    	jg	0x180340439 <.text+0x330439>
1803403f8: b0 03                       	movb	$0x3, %al
1803403fa: 8b 2a                       	movl	(%rdx), %ebp
1803403fc: 20 8b f5 09 80 2b           	andb	%cl, 0x2b8009f5(%rbx)
180340402: 56                          	pushq	%rsi
180340403: 48 0c 6b                    	orb	$0x6b, %al
180340406: a4                          	movsb	(%rsi), %es:(%rdi)
180340407: 48 a4                       	movsb	(%rsi), %es:(%rdi)
180340409: 53                          	pushq	%rbx
18034040a: 50                          	pushq	%rax
18034040b: 96                          	xchgl	%esi, %eax
18034040c: d1 f1                       	<unknown>
18034040e: af                          	scasl	%es:(%rdi), %eax
18034040f: f1                          	<unknown>
180340410: 85 79 e3                    	testl	%edi, -0x1d(%rcx)
180340413: 43 b4 fa                    	movb	$-0x6, %r12b
180340416: cc                          	int3
180340417: 5d                          	popq	%rbp
180340418: bf c9 db a3 00              	movl	$0xa3dbc9, %edi         # imm = 0xA3DBC9
18034041d: 9c                          	pushfq
18034041e: c5 5a 44                    	<unknown>
180340421: 69 21 88 19 a8 00           	imull	$0xa81988, (%rcx), %esp # imm = 0xA81988
180340427: fa                          	cli
180340428: 34 47                       	xorb	$0x47, %al
18034042a: 0e                          	<unknown>
18034042b: 8a da                       	movb	%dl, %bl
18034042d: 18 aa 27 bb ae 5e           	sbbb	%ch, 0x5eaebb27(%rdx)
180340433: 5b                          	popq	%rbx
180340434: fb                          	sti
180340435: a2 75 37 a7 d8 37 50 41 3a  	movabsb	%al, 0x3a415037d8a73775
18034043e: 2e 8b 96 47 d1 71 a7        	movl	%cs:-0x588e2eb9(%rsi), %edx
180340445: d2 e2                       	shlb	%cl, %dl
180340447: e4 77                       	inb	$0x77, %al
180340449: 61                          	<unknown>
18034044a: d1 8a 18 d7 4f 32           	rorl	0x324fd718(%rdx)
180340450: 15 00 0b 06 b8              	adcl	$0xb8060b00, %eax       # imm = 0xB8060B00
180340455: c2 eb 3d                    	retq	$0x3deb                 # imm = 0x3DEB
180340458: 02 59 ee                    	addb	-0x12(%rcx), %bl
18034045b: a7                          	cmpsl	%es:(%rdi), (%rsi)
18034045c: 82                          	<unknown>
18034045d: 0b 03                       	orl	(%rbx), %eax
18034045f: 9b                          	wait
180340460: 08 7e 1a                    	orb	%bh, 0x1a(%rsi)
180340463: 1b d0                       	sbbl	%eax, %edx
180340465: 86 bd 18 bc 5b bf           	xchgb	%bh, -0x40a443e8(%rbp)
18034046b: 27                          	<unknown>
18034046c: 36 8b c2                    	movl	%edx, %eax
18034046f: 3e dd 3f                    	fnstsw	%ds:(%rdi)
180340472: fb                          	sti
180340473: e4 b1                       	inb	$0xb1, %al
180340475: 0e                          	<unknown>
180340476: f3 60                       	<unknown>
180340478: 81 2a 07 74 21 38           	subl	$0x38217407, (%rdx)     # imm = 0x38217407
18034047e: 96                          	xchgl	%esi, %eax
18034047f: 60                          	<unknown>
180340480: ed                          	inl	%dx, %eax
180340481: e2 1d                       	loop	0x1803404a0 <.text+0x3304a0>
180340483: 23 e5                       	andl	%ebp, %esp
180340485: 63 82 1f bc 89 b0           	movslq	-0x4f7643e1(%rdx), %eax
18034048b: a0 61 4e 47 e7 e1 29 26 3e  	movabsb	0x3e2629e1e7474e61, %al
180340494: 67 01 ae 0c c7 5a 20        	addl	%ebp, 0x205ac70c(%esi)
18034049b: 48 2b 11                    	subq	(%rcx), %rdx
18034049e: e2 b3                       	loop	0x180340453 <.text+0x330453>
1803404a0: bd 32 0c 80 e1              	movl	$0xe1800c32, %ebp       # imm = 0xE1800C32
1803404a5: 63 1e                       	movslq	(%rsi), %ebx
1803404a7: 46 9a                       	<unknown>
1803404a9: cc                          	int3
1803404aa: cb                          	lretl
1803404ab: 1f                          	<unknown>
1803404ac: e5 66                       	inl	$0x66, %eax
1803404ae: dc 56 bf                    	fcoml	-0x41(%rsi)
1803404b1: 37                          	<unknown>
1803404b2: 25 9c 8b 12 b1              	andl	$0xb1128b9c, %eax       # imm = 0xB1128B9C
1803404b7: 76 66                       	jbe	0x18034051f <.text+0x33051f>
1803404b9: ba 51 4a e3 ab              	movl	$0xabe34a51, %edx       # imm = 0xABE34A51
1803404be: cd 8c                       	int	$0x8c
1803404c0: 9c                          	pushfq
1803404c1: ce                          	<unknown>
1803404c2: 9e                          	sahf
1803404c3: 7f 12                       	jg	0x1803404d7 <.text+0x3304d7>
1803404c5: 0c 0c                       	orb	$0xc, %al
1803404c7: 6f                          	outsl	(%rsi), %dx
1803404c8: 0d db 3e 4b a4              	orl	$0xa44b3edb, %eax       # imm = 0xA44B3EDB
1803404cd: c0 b8 6d 17 ea 73 a7        	sarb	$0xa7, 0x73ea176d(%rax)
1803404d4: 00 d0                       	addb	%dl, %al
1803404d6: 14 27                       	adcb	$0x27, %al
1803404d8: 9c                          	pushfq
1803404d9: 44 21 14 85 69 e6 eb 2c     	andl	%r10d, 0x2cebe669(,%rax,4)
1803404e1: 01 22                       	addl	%esp, (%rdx)
1803404e3: b0 40                       	movb	$0x40, %al
1803404e5: c5 44 f4                    	<unknown>
1803404e8: e1 c6                       	loope	0x1803404b0 <.text+0x3304b0>
1803404ea: 46 a6                       	cmpsb	%es:(%rdi), (%rsi)
1803404ec: 42 95                       	xchgl	%ebp, %eax
1803404ee: f7 b7 6e de 0c b2           	divl	-0x4df32192(%rdi)
1803404f4: af                          	scasl	%es:(%rdi), %eax
1803404f5: af                          	scasl	%es:(%rdi), %eax
1803404f6: d2 bd 8e a4 b7 d5           	sarb	%cl, -0x2a485b72(%rbp)
1803404fc: 34 8a                       	xorb	$-0x76, %al
1803404fe: 8f 74 98                    	<unknown>
180340501: a2 0b 62 97 bd 7f 00 98 ba  	movabsb	%al, -0x4567ff8042689df5
18034050a: 0b 81 d2 0a 80 ae           	orl	-0x517ff52e(%rcx), %eax
180340510: 74 5b                       	je	0x18034056d <.text+0x33056d>
180340512: 2b a4 35 54 a7 27 22        	subl	0x2227a754(%rbp,%rsi), %esp
180340519: 8e 70 1a                    	<unknown>
18034051c: f4                          	hlt
18034051d: 2d a1 fb f4 99              	subl	$0x99f4fba1, %eax       # imm = 0x99F4FBA1
180340522: 7c 34                       	jl	0x180340558 <.text+0x330558>
180340524: 87 bf 2c 4b 15 aa           	xchgl	%edi, -0x55eab4d4(%rdi)
18034052a: 8e c8                       	movl	%eax, %cs
18034052c: ae                          	scasb	%es:(%rdi), %al
18034052d: d4                          	<unknown>
18034052e: ee                          	outb	%al, %dx
18034052f: 15 45 71 2c e2              	adcl	$0xe22c7145, %eax       # imm = 0xE22C7145
180340534: 3a ea                       	cmpb	%dl, %ch
180340536: 4e c3                       	retq
180340538: a9 c2 72 5e 70              	testl	$0x705e72c2, %eax       # imm = 0x705E72C2
18034053d: 6f                          	outsl	(%rsi), %dx
18034053e: 7c d1                       	jl	0x180340511 <.text+0x330511>
180340540: f9                          	stc
180340541: 4f 77 78                    	ja	0x1803405bc <.text+0x3305bc>
180340544: 2c 81                       	subb	$-0x7f, %al
180340546: 1b 97 ca 67 7c d9           	sbbl	-0x26839836(%rdi), %edx
18034054c: 81 9f b6 01 4e 7a 0a 49 45 08       	sbbl	$0x845490a, 0x7a4e01b6(%rdi) # imm = 0x845490A
180340556: a4                          	movsb	(%rsi), %es:(%rdi)
180340557: 7c fe                       	jl	0x180340557 <.text+0x330557>
180340559: 3f                          	<unknown>
18034055a: 6a 04                       	pushq	$0x4
18034055c: f3 11 83 5f 3b 1c c2        	rep		adcl	%eax, -0x3de3c4a1(%rbx)
180340563: 8b 24 fb                    	movl	(%rbx,%rdi,8), %esp
180340566: 4e 45 58                    	popq	%r8
180340569: ec                          	inb	%dx, %al
18034056a: 1b df                       	sbbl	%edi, %ebx
18034056c: be 4d 76 6b 3d              	movl	$0x3d6b764d, %esi       # imm = 0x3D6B764D
180340571: 23 6c ed d9                 	andl	-0x27(%rbp,%rbp,8), %ebp
180340575: ce                          	<unknown>
180340576: 40 70 d9                    	jo	0x180340552 <.text+0x330552>
180340579: 82                          	<unknown>
18034057a: d7                          	xlatb
18034057b: fe 44 3b 19                 	incb	0x19(%rbx,%rdi)
18034057f: 5e                          	popq	%rsi
180340580: 47 68 83 51 50 c9           	pushq	$-0x36afae7d            # imm = 0xC9505183
180340586: b5 a8                       	movb	$-0x58, %ch
180340588: 4b a6                       	cmpsb	%es:(%rdi), (%rsi)
18034058a: 86 f8                       	xchgb	%al, %bh
18034058c: 59                          	popq	%rcx
18034058d: 2f                          	<unknown>
18034058e: a0 d9 25 ef d0 38 55 3f e7  	movabsb	-0x18c0aac72f10da27, %al
180340597: f2 6f                       	repne		outsl	(%rsi), %dx
180340599: 1a e9                       	sbbb	%cl, %ch
18034059b: f4                          	hlt
18034059c: d5 c8 42 bf e2 87 94 cc     	cmovbq	-0x336b781e(%rdi), %r23
1803405a4: 9b                          	wait
1803405a5: 60                          	<unknown>
1803405a6: f8                          	clc
1803405a7: 8d fd                       	<unknown>
1803405a9: 79 6f                       	jns	0x18034061a <.text+0x33061a>
1803405ab: 78 70                       	js	0x18034061d <.text+0x33061d>
1803405ad: 68 cc cd cd f4              	pushq	$-0xb323234             # imm = 0xF4CDCDCC
1803405b2: 2e 27                       	<unknown>
1803405b4: a4                          	movsb	(%rsi), %es:(%rdi)
1803405b5: e0 bf                       	loopne	0x180340576 <.text+0x330576>
1803405b7: 3f                          	<unknown>
1803405b8: 21 7e 2a                    	andl	%edi, 0x2a(%rsi)
1803405bb: bc 78 81 9f a9              	movl	$0xa99f8178, %esp       # imm = 0xA99F8178
1803405c0: 1f                          	<unknown>
1803405c1: ed                          	inl	%dx, %eax
1803405c2: 0c 0b                       	orb	$0xb, %al
1803405c4: 65 3e b6 61                 	movb	$0x61, %dh
1803405c8: 60                          	<unknown>
1803405c9: de bd f3 ea be 59           	fidivrs	0x59beeaf3(%rbp)
1803405cf: d6                          	<unknown>
1803405d0: a6                          	cmpsb	%es:(%rdi), (%rsi)
1803405d1: cb                          	lretl
1803405d2: ac                          	lodsb	(%rsi), %al
1803405d3: c0 67 bc 64                 	shlb	$0x64, -0x44(%rdi)
1803405d7: 3a 92 d8 89 bc 10           	cmpb	0x10bc89d8(%rdx), %dl
1803405dd: 23 a7 ca 4c a2 d2           	andl	-0x2d5db336(%rdi), %esp
1803405e3: 26 e6 67                    	outb	%al, $0x67
1803405e6: cb                          	lretl
1803405e7: aa                          	stosb	%al, %es:(%rdi)
1803405e8: 81 4b e4 44 f6 00 16        	orl	$0x1600f644, -0x1c(%rbx) # imm = 0x1600F644
1803405ef: e2 5b                       	loop	0x18034064c <.text+0x33064c>
1803405f1: d5 38 eb 0c                 	jmp	0x180340601 <.text+0x330601>
1803405f5: 96                          	xchgl	%esi, %eax
1803405f6: f9                          	stc
1803405f7: e4 f0                       	inb	$0xf0, %al
1803405f9: ae                          	scasb	%es:(%rdi), %al
1803405fa: e6 4f                       	outb	%al, $0x4f
1803405fc: 2a e4                       	subb	%ah, %ah
1803405fe: 51                          	pushq	%rcx
1803405ff: d8 66 70                    	fsubs	0x70(%rsi)
180340602: b4 af                       	movb	$-0x51, %ah
180340604: 6a 2a                       	pushq	$0x2a
180340606: 7c 54                       	jl	0x18034065c <.text+0x33065c>
180340608: f4                          	hlt
180340609: 76 68                       	jbe	0x180340673 <.text+0x330673>
18034060b: b6 8a                       	movb	$-0x76, %dh
18034060d: 5d                          	popq	%rbp
18034060e: eb 8f                       	jmp	0x18034059f <.text+0x33059f>
180340610: 73 43                       	jae	0x180340655 <.text+0x330655>
180340612: 81 9b 91 f7 b3 59 95 7b 30 43       	sbbl	$0x43307b95, 0x59b3f791(%rbx) # imm = 0x43307B95
18034061c: 6f                          	outsl	(%rsi), %dx
18034061d: 9b                          	wait
18034061e: f8                          	clc
18034061f: dd 89 b3 3e e2 e5           	fisttpll	-0x1a1dc14d(%rcx)
180340625: bc bc c9 67 ed              	movl	$0xed67c9bc, %esp       # imm = 0xED67C9BC
18034062a: 6b 79 2b eb                 	imull	$-0x15, 0x2b(%rcx), %edi
18034062e: f1                          	<unknown>
18034062f: d6                          	<unknown>
180340630: 42 6a 8b                    	pushq	$-0x75
180340633: 2c ca                       	subb	$-0x36, %al
180340635: b2 c5                       	movb	$-0x3b, %dl
180340637: 4d 24 25                    	andb	$0x25, %al
18034063a: d2 22                       	shlb	%cl, (%rdx)
18034063c: 40 58                       	popq	%rax
18034063e: 00 c5                       	addb	%al, %ch
180340640: 66 6b b5 8b 11 2d ed fe     	imulw	$-0x2, -0x12d2ee75(%rbp), %si
180340648: 02 23                       	addb	(%rbx), %ah
18034064a: 92                          	xchgl	%edx, %eax
18034064b: 29 ce                       	subl	%ecx, %esi
18034064d: 9c                          	pushfq
18034064e: 63 79 69                    	movslq	0x69(%rcx), %edi
180340651: 24 9b                       	andb	$-0x65, %al
180340653: 07                          	<unknown>
180340654: ca 9b 28                    	lretl	$0x289b                 # imm = 0x289B
180340657: b2 4f                       	movb	$0x4f, %dl
180340659: 17                          	<unknown>
18034065a: d1 99 be ba 84 6a           	rcrl	0x6a84babe(%rcx)
180340660: 9d                          	popfq
180340661: 5d                          	popq	%rbp
180340662: a1 2d 91 ef 3f e1 49 5c eb  	movabsl	-0x14a3b61ec0106ed3, %eax
18034066b: 48 4a df 33                 	fbstp	(%rbx)
18034066f: 9a                          	<unknown>
180340670: 68 52 cc a2 fb              	pushq	$-0x45d33ae             # imm = 0xFBA2CC52
180340675: 79 37                       	jns	0x1803406ae <.text+0x3306ae>
180340677: 39 21                       	cmpl	%esp, (%rcx)
180340679: 86 b3 61 88 94 8c           	xchgb	%dh, -0x736b779f(%rbx)
18034067f: 90                          	nop
180340680: bb b9 f9 4f af              	movl	$0xaf4ff9b9, %ebx       # imm = 0xAF4FF9B9
180340685: f2 e1 a5                    	repne		loope	0x18034062d <.text+0x33062d>
180340688: 55                          	pushq	%rbp
180340689: 8c ea                       	movl	%gs, %edx
18034068b: 7b 8b                       	jnp	0x180340618 <.text+0x330618>
18034068d: d5 ce bd 7c 7f 94           	bsrq	-0x6c(%rdi,%r15,2), %r31
180340693: fe e8                       	<unknown>
180340695: b6 05                       	movb	$0x5, %dh
180340697: 61                          	<unknown>
180340698: 49 46 a5                    	movsl	(%rsi), %es:(%rdi)
18034069b: 5a                          	popq	%rdx
18034069c: 67 08 b3 b9 14 7e 9c        	orb	%dh, -0x6381eb47(%ebx)
1803406a3: cd e4                       	int	$0xe4
1803406a5: 59                          	popq	%rcx
1803406a6: fd                          	std
1803406a7: 8c e2                       	movl	%fs, %edx
1803406a9: 9f                          	lahf
1803406aa: 7d 03                       	jge	0x1803406af <.text+0x3306af>
1803406ac: 4b fd                       	std
1803406ae: 8b c9                       	movl	%ecx, %ecx
1803406b0: 55                          	pushq	%rbp
1803406b1: 44 b4 14                    	movb	$0x14, %spl
1803406b4: 0a 12                       	orb	(%rdx), %dl
1803406b6: f3 46 47 2f                 	<unknown>
1803406ba: af                          	scasl	%es:(%rdi), %eax
1803406bb: c5 4c 20                    	<unknown>
1803406be: 79 89                       	jns	0x180340649 <.text+0x330649>
1803406c0: 86 a7 99 ed 52 fb           	xchgb	%ah, -0x4ad1267(%rdi)
1803406c6: 67 a1 9e 97 a9 fc           	movl	0xfca9979e, %eax
1803406cc: d5 c3 68 9f 0e d9 80 c4     	punpckhbw	-0x3b7f26f2(%r15), %mm3 # mm3 = mm3[4],mem[4],mm3[5],mem[5],mm3[6],mem[6],mm3[7],mem[7]
1803406d4: 99                          	cltd
1803406d5: 2f                          	<unknown>
1803406d6: 41 5a                       	popq	%r10
1803406d8: 7a ac                       	jp	0x180340686 <.text+0x330686>
1803406da: ae                          	scasb	%es:(%rdi), %al
1803406db: 98                          	cwtl
1803406dc: a8 21                       	testb	$0x21, %al
1803406de: 22 04 ab                    	andb	(%rbx,%rbp,4), %al
1803406e1: 14 f7                       	adcb	$-0x9, %al
1803406e3: 96                          	xchgl	%esi, %eax
1803406e4: 7c e8                       	jl	0x1803406ce <.text+0x3306ce>
1803406e6: e3 da                       	jrcxz	0x1803406c2 <.text+0x3306c2>
1803406e8: 29 ec                       	subl	%ebp, %esp
1803406ea: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803406eb: 5e                          	popq	%rsi
1803406ec: ca c7 01                    	lretl	$0x1c7                  # imm = 0x1C7
1803406ef: f8                          	clc
1803406f0: 18 53 d2                    	sbbb	%dl, -0x2e(%rbx)
1803406f3: de 8d f0 90 87 27           	fimuls	0x278790f0(%rbp)
1803406f9: c3                          	retq
1803406fa: d2 c2                       	rolb	%cl, %dl
1803406fc: 94                          	xchgl	%esp, %eax
1803406fd: a0 92 22 cb d0 f2 08 cc cf  	movabsb	-0x3033f70d2f34dd6e, %al
180340706: 27                          	<unknown>
180340707: 47 4d c8 7b 4c 2c           	enter	$0x4c7b, $0x2c          # imm = 0x4C7B
18034070d: ad                          	lodsl	(%rsi), %eax
18034070e: 6f                          	outsl	(%rsi), %dx
18034070f: ea                          	<unknown>
180340710: 1e                          	<unknown>
180340711: 09 b8 49 68 22 71           	orl	%edi, 0x71226849(%rax)
180340717: 1a 5b 66                    	sbbb	0x66(%rbx), %bl
18034071a: 3c 3e                       	cmpb	$0x3e, %al
18034071c: 36 7b e0                    	jnp	0x1803406ff <.text+0x3306ff>
18034071f: d8 b8 36 ce 59 5c           	fdivrs	0x5c59ce36(%rax)
180340725: 3e a3 51 29 8e 98 52 a5 27 e2       	movabsl	%eax, %ds:-0x1dd85aad6771d6af
18034072f: 9d                          	popfq
180340730: 1b 5b 15                    	sbbl	0x15(%rbx), %ebx
180340733: b7 f5                       	movb	$-0xb, %bh
180340735: fc                          	cld
180340736: cb                          	lretl
180340737: d6                          	<unknown>
180340738: e7 fa                       	outl	%eax, $0xfa
18034073a: d5 43 68 eb 03 df cf        	pushq	$-0x3020fc15            # imm = 0xCFDF03EB
180340741: 07                          	<unknown>
180340742: 2f                          	<unknown>
180340743: 32 4f 36                    	xorb	0x36(%rdi), %cl
180340746: 27                          	<unknown>
180340747: 50                          	pushq	%rax
180340748: 1f                          	<unknown>
180340749: 4a 6c                       	insb	%dx, %es:(%rdi)
18034074b: 93                          	xchgl	%ebx, %eax
18034074c: ba a2 8b d3 ad              	movl	$0xadd38ba2, %edx       # imm = 0xADD38BA2
180340751: 07                          	<unknown>
180340752: 3f                          	<unknown>
180340753: 6a 64                       	pushq	$0x64
180340755: fd                          	std
180340756: 11 38                       	adcl	%edi, (%rax)
180340758: 17                          	<unknown>
180340759: 2a a3 61 39 ef 17           	subb	0x17ef3961(%rbx), %ah
18034075f: 72 ae                       	jb	0x18034070f <.text+0x33070f>
180340761: 95                          	xchgl	%ebp, %eax
180340762: 40 4b d8 ad d0 39 e2 1a     	fsubrs	0x1ae239d0(%r13)
18034076a: 74 ec                       	je	0x180340758 <.text+0x330758>
18034076c: 86 66 ad                    	xchgb	%ah, -0x53(%rsi)
18034076f: a3 c2 b5 4c b6 43 cd 01 6f  	movabsl	%eax, 0x6f01cd43b64cb5c2
180340778: 82                          	<unknown>
180340779: da 9d c3 34 fe db           	ficompl	-0x2401cb3d(%rbp)
18034077f: 53                          	pushq	%rbx
180340780: bf 40 e6 97 ec              	movl	$0xec97e640, %edi       # imm = 0xEC97E640
180340785: de b9 9c 36 9a b2           	fidivrs	-0x4d65c964(%rcx)
18034078b: 26 40 de 3e                 	fidivrs	%es:(%rsi)
18034078f: 02 83 51 ef be 3e           	addb	0x3ebeef51(%rbx), %al
180340795: d1 29                       	shrl	(%rcx)
180340797: 0a 59 d5                    	orb	-0x2b(%rcx), %bl
18034079a: b8 79 f1 e0 26              	movl	$0x26e0f179, %eax       # imm = 0x26E0F179
18034079f: 05 88 45 bc cc              	addl	$0xccbc4588, %eax       # imm = 0xCCBC4588
1803407a4: b2 82                       	movb	$-0x7e, %dl
1803407a6: e1 e4                       	loope	0x18034078c <.text+0x33078c>
1803407a8: fa                          	cli
1803407a9: e6 50                       	outb	%al, $0x50
1803407ab: 16                          	<unknown>
1803407ac: f9                          	stc
1803407ad: e7 87                       	outl	%eax, $0x87
1803407af: 65 b7 eb                    	movb	$-0x15, %bh
1803407b2: a5                          	movsl	(%rsi), %es:(%rdi)
1803407b3: 45 cd 61                    	int	$0x61
1803407b6: d1 fc                       	sarl	%esp
1803407b8: 1c 7d                       	sbbb	$0x7d, %al
1803407ba: 95                          	xchgl	%ebp, %eax
1803407bb: 03 34 c3                    	addl	(%rbx,%rax,8), %esi
1803407be: 82                          	<unknown>
1803407bf: f3 75 27                    	rep		jne	0x1803407e9 <.text+0x3307e9>
1803407c2: 16                          	<unknown>
1803407c3: 40 88 20                    	movb	%spl, (%rax)
1803407c6: 53                          	pushq	%rbx
1803407c7: 28 6e 32                    	subb	%ch, 0x32(%rsi)
1803407ca: 0d 0b de 44 e4              	orl	$0xe444de0b, %eax       # imm = 0xE444DE0B
1803407cf: 39 6f 42                    	cmpl	%ebp, 0x42(%rdi)
1803407d2: b0 5f                       	movb	$0x5f, %al
1803407d4: 3b d9                       	cmpl	%ecx, %ebx
1803407d6: a8 6a                       	testb	$0x6a, %al
1803407d8: 22 da                       	andb	%dl, %bl
1803407da: ec                          	inb	%dx, %al
1803407db: 01 cf                       	addl	%ecx, %edi
1803407dd: b4 ae                       	movb	$-0x52, %ah
1803407df: 3b 95 70 38 93 7a           	cmpl	0x7a933870(%rbp), %edx
1803407e5: 6b 78 14 79                 	imull	$0x79, 0x14(%rax), %edi
1803407e9: 47 4c c2 d0 63              	retq	$0x63d0                 # imm = 0x63D0
1803407ee: 1d f6 ca 72 e4              	sbbl	$0xe472caf6, %eax       # imm = 0xE472CAF6
1803407f3: ed                          	inl	%dx, %eax
1803407f4: 27                          	<unknown>
1803407f5: 2c 54                       	subb	$0x54, %al
1803407f7: 05 23 dd f6 09              	addl	$0x9f6dd23, %eax        # imm = 0x9F6DD23
1803407fc: 76 30                       	jbe	0x18034082e <.text+0x33082e>
1803407fe: b9 91 40 57 ce              	movl	$0xce574091, %ecx       # imm = 0xCE574091
180340803: 43 82                       	<unknown>
180340805: a9 e7 72 4c 1c              	testl	$0x1c4c72e7, %eax       # imm = 0x1C4C72E7
18034080a: 4e cd f4                    	int	$0xf4
18034080d: e9 ba 17 62 cf              	jmp	0x14f961fcc
180340812: ba 2f 02 0f e1              	movl	$0xe10f022f, %edx       # imm = 0xE10F022F
180340817: b3 d7                       	movb	$-0x29, %bl
180340819: ad                          	lodsl	(%rsi), %eax
18034081a: a6                          	cmpsb	%es:(%rdi), (%rsi)
18034081b: 39 94 d3 82 80 97 e6        	cmpl	%edx, -0x19687f7e(%rbx,%rdx,8)
180340822: 08 16                       	orb	%dl, (%rsi)
180340824: 1b ba af 14 6e 29           	sbbl	0x296e14af(%rdx), %edi
18034082a: 5e                          	popq	%rsi
18034082b: 4a d4                       	<unknown>
18034082d: b8 d7 28 d8 49              	movl	$0x49d828d7, %eax       # imm = 0x49D828D7
180340832: 5c                          	popq	%rsp
180340833: 59                          	popq	%rcx
180340834: 4c 9b                       	wait
180340836: 68 ed 11 05 3b              	pushq	$0x3b0511ed             # imm = 0x3B0511ED
18034083b: 8a 32                       	movb	(%rdx), %dh
18034083d: 64 54                       	pushq	%rsp
18034083f: 4e 6e                       	outsb	(%rsi), %dx
180340841: c1 46 dc 47                 	roll	$0x47, -0x24(%rsi)
180340845: 9d                          	popfq
180340846: 59                          	popq	%rcx
180340847: e4 65                       	inb	$0x65, %al
180340849: c6 53 f8                    	<unknown>
18034084c: a6                          	cmpsb	%es:(%rdi), (%rsi)
18034084d: 30 d9                       	xorb	%bl, %cl
18034084f: a2 60 a5 29 ef 84 5d 39 76  	movabsb	%al, 0x76395d84ef29a560
180340858: df ed                       	fucompi	%st(5), %st
18034085a: f2 49 30 45 34              	repne		xorb	%al, 0x34(%r13)
18034085f: fe fa                       	<unknown>
180340861: 92                          	xchgl	%edx, %eax
180340862: cd 31                       	int	$0x31
180340864: 57                          	pushq	%rdi
180340865: 49 01 c4                    	addq	%rax, %r12
180340868: 68 83 f2 8c 19              	pushq	$0x198cf283             # imm = 0x198CF283
18034086d: 02 42 66                    	addb	0x66(%rdx), %al
180340870: e5 ec                       	inl	$0xec, %eax
180340872: 30 a7 ab 76 5f f6           	xorb	%ah, -0x9a08955(%rdi)
180340878: 77 3a                       	ja	0x1803408b4 <.text+0x3308b4>
18034087a: 2e 7d e2                    	jge	0x18034085f <.text+0x33085f>
18034087d: 2c d9                       	subb	$-0x27, %al
18034087f: d4                          	<unknown>
180340880: 1a 29                       	sbbb	(%rcx), %ch
180340882: 7c 82                       	jl	0x180340806 <.text+0x330806>
180340884: f1                          	<unknown>
180340885: d7                          	xlatb
180340886: f8                          	clc
180340887: 94                          	xchgl	%esp, %eax
180340888: c5 06 73                    	<unknown>
18034088b: 79 e0                       	jns	0x18034086d <.text+0x33086d>
18034088d: 7d 87                       	jge	0x180340816 <.text+0x330816>
18034088f: 88 29                       	movb	%ch, (%rcx)
180340891: f4                          	hlt
180340892: c0 90 52 51 cc c5 19        	rclb	$0x19, -0x3a33aeae(%rax)
180340899: 53                          	pushq	%rbx
18034089a: 96                          	xchgl	%esi, %eax
18034089b: 69 9c a0 fe ad 97 cb 43 f1 25 57    	imull	$0x5725f143, -0x34685202(%rax,%riz,4), %ebx # imm = 0x5725F143
1803408a6: 6e                          	outsb	(%rsi), %dx
1803408a7: 75 44                       	jne	0x1803408ed <.text+0x3308ed>
1803408a9: fd                          	std
1803408aa: 18 1a                       	sbbb	%bl, (%rdx)
1803408ac: 77 3c                       	ja	0x1803408ea <.text+0x3308ea>
1803408ae: 55                          	pushq	%rbp
1803408af: 28 e4                       	subb	%ah, %ah
1803408b1: cd 5e                       	int	$0x5e
1803408b3: ad                          	lodsl	(%rsi), %eax
1803408b4: 26 c8 f6 c5 f8              	enter	$-0x3a0a, $-0x8         # imm = 0xC5F6
1803408b9: a8 28                       	testb	$0x28, %al
1803408bb: 0c e0                       	orb	$-0x20, %al
1803408bd: e8 f8 ce 86 59              	callq	0x1d9bad7ba
1803408c2: d8 3b                       	fdivrs	(%rbx)
1803408c4: 91                          	xchgl	%ecx, %eax
1803408c5: f4                          	hlt
1803408c6: 5d                          	popq	%rbp
1803408c7: a9 8e 30 b8 48              	testl	$0x48b8308e, %eax       # imm = 0x48B8308E
1803408cc: eb b4                       	jmp	0x180340882 <.text+0x330882>
1803408ce: 35 d7 68 d0 b6              	xorl	$0xb6d068d7, %eax       # imm = 0xB6D068D7
1803408d3: 77 40                       	ja	0x180340915 <.text+0x330915>
1803408d5: 02 c7                       	addb	%bh, %al
1803408d7: 0f 10 f5                    	movups	%xmm5, %xmm6
1803408da: 1c 16                       	sbbb	$0x16, %al
1803408dc: 97                          	xchgl	%edi, %eax
1803408dd: f1                          	<unknown>
1803408de: 02 39                       	addb	(%rcx), %bh
1803408e0: 9b                          	wait
1803408e1: de f9                       	fdivrp	%st, %st(1)
1803408e3: 59                          	popq	%rcx
1803408e4: 53                          	pushq	%rbx
1803408e5: d6                          	<unknown>
1803408e6: 35 8b 6e 66 21              	xorl	$0x21666e8b, %eax       # imm = 0x21666E8B
1803408eb: 6e                          	outsb	(%rsi), %dx
1803408ec: 5d                          	popq	%rbp
1803408ed: c6 90 23 24 0b 85           	<unknown>
1803408f3: 9c                          	pushfq
1803408f4: 76 f8                       	jbe	0x1803408ee <.text+0x3308ee>
1803408f6: 23 64 62 fe                 	andl	-0x2(%rdx,%riz,2), %esp
1803408fa: d2 27                       	shlb	%cl, (%rdi)
1803408fc: 1d 2c 2c d2 40              	sbbl	$0x40d22c2c, %eax       # imm = 0x40D22C2C
180340901: e7 63                       	outl	%eax, $0x63
180340903: 14 c7                       	adcb	$-0x39, %al
180340905: fd                          	std
180340906: b8 57 60 b9 74              	movl	$0x74b96057, %eax       # imm = 0x74B96057
18034090b: e1 82                       	loope	0x18034088f <.text+0x33088f>
18034090d: 5f                          	popq	%rdi
18034090e: f7 15 8d 43 ec a1           	notl	-0x5e13bc73(%rip)       # 0x122204ca1
180340914: 64 2c fc                    	subb	$-0x4, %al
180340917: 55                          	pushq	%rbp
180340918: 45 8c 45 08                 	movw	%es, 0x8(%r13)
18034091c: 49 5d                       	popq	%r13
18034091e: e6 35                       	outb	%al, $0x35
180340920: c0 18 2e                    	rcrb	$0x2e, (%rax)
180340923: 58                          	popq	%rax
180340924: 09 9b 24 7e 05 d2           	orl	%ebx, -0x2dfa81dc(%rbx)
18034092a: cc                          	int3
18034092b: 28 7a 89                    	subb	%bh, -0x77(%rdx)
18034092e: fb                          	sti
18034092f: 29 34 56                    	subl	%esi, (%rsi,%rdx,2)
180340932: 3b a8 1a 09 a0 6f           	cmpl	0x6fa0091a(%rax), %ebp
180340938: 6a 59                       	pushq	$0x59
18034093a: f6 fb                       	idivb	%bl
18034093c: 7a f5                       	jp	0x180340933 <.text+0x330933>
18034093e: 28 91 ad 12 17 89           	subb	%dl, -0x76e8ed53(%rcx)
180340944: b5 05                       	movb	$0x5, %ch
180340946: 17                          	<unknown>
180340947: 27                          	<unknown>
180340948: 32 aa 99 06 d5 da           	xorb	-0x252af967(%rdx), %ch
18034094e: b9 c2 b3 e0 ba              	movl	$0xbae0b3c2, %ecx       # imm = 0xBAE0B3C2
180340953: c6 5e b6                    	<unknown>
180340956: 65 60                       	<unknown>
180340958: b2 d3                       	movb	$-0x2d, %dl
18034095a: 83 8c 5c 2f 9b 30 a7 30     	orl	$0x30, -0x58cf64d1(%rsp,%rbx,2)
180340962: 74 23                       	je	0x180340987 <.text+0x330987>
180340964: de 8f 4c 1a 75 fa           	fimuls	-0x58ae5b4(%rdi)
18034096a: da 7f 5a                    	fidivrl	0x5a(%rdi)
18034096d: c6 f0                       	<unknown>
18034096f: 97                          	xchgl	%edi, %eax
180340970: b2 59                       	movb	$0x59, %dl
180340972: f8                          	clc
180340973: 10 7a d8                    	adcb	%bh, -0x28(%rdx)
180340976: 0b a8 7b 1d cf 1f           	orl	0x1fcf1d7b(%rax), %ebp
18034097c: de 7a 99                    	fidivrs	-0x67(%rdx)
18034097f: f0                          	lock
180340980: 15 64 fb 63 f1              	adcl	$0xf163fb64, %eax       # imm = 0xF163FB64
180340985: f0                          	lock
180340986: 35 27 8b 1a 8b              	xorl	$0x8b1a8b27, %eax       # imm = 0x8B1A8B27
18034098b: da 54 a5 e6                 	ficoml	-0x1a(%rbp,%riz,4)
18034098f: 50                          	pushq	%rax
180340990: cf                          	iretl
180340991: c2 03 b2                    	retq	$-0x4dfd                # imm = 0xB203
180340994: 86 26                       	xchgb	%ah, (%rsi)
180340996: 2a fa                       	subb	%dl, %bh
180340998: 5c                          	popq	%rsp
180340999: cf                          	iretl
18034099a: 84 ca                       	testb	%cl, %dl
18034099c: 90                          	nop
18034099d: dd 59 ec                    	fstpl	-0x14(%rcx)
1803409a0: ea                          	<unknown>
1803409a1: 8d a1 e0 a9 45 39           	leal	0x3945a9e0(%rcx), %esp
1803409a7: 15 eb 20 f6 8e              	adcl	$0x8ef620eb, %eax       # imm = 0x8EF620EB
1803409ac: 16                          	<unknown>
1803409ad: 19 80 66 47 7e a0           	sbbl	%eax, -0x5f81b89a(%rax)
1803409b3: 6a ab                       	pushq	$-0x55
1803409b5: 79 41                       	jns	0x1803409f8 <.text+0x3309f8>
1803409b7: 1e                          	<unknown>
1803409b8: 2a 6d 4c                    	subb	0x4c(%rbp), %ch
1803409bb: 2d ec e0 31 91              	subl	$0x9131e0ec, %eax       # imm = 0x9131E0EC
1803409c0: 48 69 19 82 2d 56 85        	imulq	$-0x7aa9d27e, (%rcx), %rbx # imm = 0x85562D82
1803409c7: 07                          	<unknown>
1803409c8: 4a ce                       	<unknown>
1803409ca: ad                          	lodsl	(%rsi), %eax
1803409cb: c0 3d 48 a7 29 49 e1        	sarb	$0xe1, 0x4929a748(%rip) # 0x1c95db11a
1803409d2: 21 68 2e                    	andl	%ebp, 0x2e(%rax)
1803409d5: c6 60 b3                    	<unknown>
1803409d8: b4 94                       	movb	$-0x6c, %ah
1803409da: 81 ea 4d ed 35 75           	subl	$0x7535ed4d, %edx       # imm = 0x7535ED4D
1803409e0: 7e 44                       	jle	0x180340a26 <.text+0x330a26>
1803409e2: 8b 37                       	movl	(%rdi), %esi
1803409e4: 81 92 e8 46 c2 ca ec b6 60 0e       	adcl	$0xe60b6ec, -0x353db918(%rdx) # imm = 0xE60B6EC
1803409ee: 9d                          	popfq
1803409ef: b3 6e                       	movb	$0x6e, %bl
1803409f1: 2c 1a                       	subb	$0x1a, %al
1803409f3: 7a b3                       	jp	0x1803409a8 <.text+0x3309a8>
1803409f5: 6a 56                       	pushq	$0x56
1803409f7: 62 de 14 c9 f8              	<unknown>
1803409fc: 1c 09                       	sbbb	$0x9, %al
1803409fe: c9                          	leave
1803409ff: d3 36                       	<unknown>
180340a01: 47 da 9b f2 f9 99 55        	ficompl	0x5599f9f2(%r11)
180340a08: 41 e6 26                    	outb	%al, $0x26
180340a0b: 66 ef                       	outw	%ax, %dx
180340a0d: 24 b6                       	andb	$-0x4a, %al
180340a0f: 5a                          	popq	%rdx
180340a10: 4f d2 d7                    	rclb	%cl, %r15b
180340a13: e6 d7                       	outb	%al, $0xd7
180340a15: 84 cc                       	testb	%cl, %ah
180340a17: 8c d8                       	movl	%ds, %eax
180340a19: a7                          	cmpsl	%es:(%rdi), (%rsi)
180340a1a: 97                          	xchgl	%edi, %eax
180340a1b: 6a 2e                       	pushq	$0x2e
180340a1d: 9a                          	<unknown>
180340a1e: fd                          	std
180340a1f: 72 47                       	jb	0x180340a68 <.text+0x330a68>
180340a21: dd 96 31 64 12 3c           	fstl	0x3c126431(%rsi)
180340a27: a7                          	cmpsl	%es:(%rdi), (%rsi)
180340a28: ee                          	outb	%al, %dx
180340a29: 58                          	popq	%rax
180340a2a: e2 39                       	loop	0x180340a65 <.text+0x330a65>
180340a2c: ef                          	outl	%eax, %dx
180340a2d: 6c                          	insb	%dx, %es:(%rdi)
180340a2e: 93                          	xchgl	%ebx, %eax
180340a2f: fb                          	sti
180340a30: 5b                          	popq	%rbx
180340a31: 68 8f dc 3d 97              	pushq	$-0x68c22371            # imm = 0x973DDC8F
180340a36: 7c a7                       	jl	0x1803409df <.text+0x3309df>
180340a38: ba 62 35 80 52              	movl	$0x52803562, %edx       # imm = 0x52803562
180340a3d: 3b 39                       	cmpl	(%rcx), %edi
180340a3f: 24 63                       	andb	$0x63, %al
180340a41: 03 3d 7e 61 4f 55           	addl	0x554f617e(%rip), %edi  # 0x1d5836bc5
180340a47: 7a 1e                       	jp	0x180340a67 <.text+0x330a67>
180340a49: 6e                          	outsb	(%rsi), %dx
180340a4a: dc 36                       	fdivl	(%rsi)
180340a4c: f3 54                       	rep		pushq	%rsp
180340a4e: b9 ab 45 cd 0f              	movl	$0xfcd45ab, %ecx        # imm = 0xFCD45AB
180340a53: 0f 93 c4                    	setae	%ah
180340a56: 4d 71 ae                    	jno	0x180340a07 <.text+0x330a07>
180340a59: e9 e3 db 9e e9              	jmp	0x169d2e641
180340a5e: 01 94 44 a9 91 14 1d        	addl	%edx, 0x1d1491a9(%rsp,%rax,2)
180340a65: e6 e1                       	outb	%al, $0xe1
180340a67: cd 43                       	int	$0x43
180340a69: e0 e0                       	loopne	0x180340a4b <.text+0x330a4b>
180340a6b: 95                          	xchgl	%ebp, %eax
180340a6c: 64 33 d9                    	xorl	%ecx, %ebx
180340a6f: 84 4c 1f f3                 	testb	%cl, -0xd(%rdi,%rbx)
180340a73: 82                          	<unknown>
180340a74: 97                          	xchgl	%edi, %eax
180340a75: 0e                          	<unknown>
180340a76: a5                          	movsl	(%rsi), %es:(%rdi)
180340a77: 51                          	pushq	%rcx
180340a78: 46 31 53 c0                 	xorl	%r10d, -0x40(%rbx)
180340a7c: 06                          	<unknown>
180340a7d: 1e                          	<unknown>
180340a7e: 33 54 ec 0f                 	xorl	0xf(%rsp,%rbp,8), %edx
180340a82: 86 d3                       	xchgb	%bl, %dl
180340a84: 1a 83 c2 b4 34 a5           	sbbb	-0x5acb4b3e(%rbx), %al
180340a8a: db e0                       	<unknown>
180340a8c: d2 43 3f                    	rolb	%cl, 0x3f(%rbx)
180340a8f: cf                          	iretl
180340a90: 55                          	pushq	%rbp
180340a91: 76 94                       	jbe	0x180340a27 <.text+0x330a27>
180340a93: 85 87 2e aa cc 3f           	testl	%eax, 0x3fccaa2e(%rdi)
180340a99: ae                          	scasb	%es:(%rdi), %al
180340a9a: 14 c6                       	adcb	$-0x3a, %al
180340a9c: 29 ed                       	subl	%ebp, %ebp
180340a9e: d3 f5                       	<unknown>
180340aa0: 46 83 8a a9 3e e6 a5 c2     	orl	$-0x3e, -0x5a19c157(%rdx)
180340aa8: eb 07                       	jmp	0x180340ab1 <.text+0x330ab1>
180340aaa: cb                          	lretl
180340aab: 42 65 f3 79 c1              	rep		jns	0x180340a71 <.text+0x330a71>
180340ab0: fc                          	cld
180340ab1: 8c 6c 35 62                 	movw	%gs, 0x62(%rbp,%rsi)
180340ab5: 5f                          	popq	%rdi
180340ab6: 67 ae                       	scasb	%es:(%edi), %al
180340ab8: b8 2f df 09 63              	movl	$0x6309df2f, %eax       # imm = 0x6309DF2F
180340abd: 4c 44 aa                    	stosb	%al, %es:(%rdi)
180340ac0: 87 d5                       	xchgl	%ebp, %edx
180340ac2: 93                          	xchgl	%ebx, %eax
180340ac3: b2 d1                       	movb	$-0x2f, %dl
180340ac5: 6c                          	insb	%dx, %es:(%rdi)
180340ac6: e5 1a                       	inl	$0x1a, %eax
180340ac8: 71 52                       	jno	0x180340b1c <.text+0x330b1c>
180340aca: 2e 14 24                    	adcb	$0x24, %al
180340acd: 6b 43 d4 91                 	imull	$-0x6f, -0x2c(%rbx), %eax
180340ad1: 08 e7                       	orb	%ah, %bh
180340ad3: b6 7a                       	movb	$0x7a, %dh
180340ad5: e9 68 e9 75 d6              	jmp	0x156a9f442
180340ada: e3 38                       	jrcxz	0x180340b14 <.text+0x330b14>
180340adc: 9f                          	lahf
180340add: ad                          	lodsl	(%rsi), %eax
180340ade: 85 ca                       	testl	%ecx, %edx
180340ae0: 01 cd                       	addl	%ecx, %ebp
180340ae2: ef                          	outl	%eax, %dx
180340ae3: 8b 0c 12                    	movl	(%rdx,%rdx), %ecx
180340ae6: 72 de                       	jb	0x180340ac6 <.text+0x330ac6>
180340ae8: 82                          	<unknown>
180340ae9: 76 5c                       	jbe	0x180340b47 <.text+0x330b47>
180340aeb: 69 b6 55 58 dc cd 90 6a cf 28       	imull	$0x28cf6a90, -0x3223a7ab(%rsi), %esi # imm = 0x28CF6A90
180340af5: 79 04                       	jns	0x180340afb <.text+0x330afb>
180340af7: 0b 98 bf 8d 00 88           	orl	-0x77ff7241(%rax), %ebx
180340afd: ac                          	lodsb	(%rsi), %al
180340afe: 68 e3 e0 4e 5f              	pushq	$0x5f4ee0e3             # imm = 0x5F4EE0E3
180340b03: a1 25 c6 b5 fc f9 5c a6 d6  	movabsl	-0x2959a306034a39db, %eax
180340b0c: c8 dc 69 79                 	enter	$0x69dc, $0x79          # imm = 0x69DC
180340b10: da f1                       	<unknown>
180340b12: 90                          	nop
180340b13: f3 e7 49                    	rep		outl	%eax, $0x49
180340b16: 3e 7d f1                    	jge	0x180340b0a <.text+0x330b0a>
180340b19: 7d cc                       	jge	0x180340ae7 <.text+0x330ae7>
180340b1b: a1 9d dc 1f ac 56 81 e0 7b  	movabsl	0x7be08156ac1fdc9d, %eax
180340b24: 7b b1                       	jnp	0x180340ad7 <.text+0x330ad7>
180340b26: 47 bf 5a b3 e3 70           	movl	$0x70e3b35a, %r15d      # imm = 0x70E3B35A
180340b2c: 75 ef                       	jne	0x180340b1d <.text+0x330b1d>
180340b2e: 2b 4e b2                    	subl	-0x4e(%rsi), %ecx
180340b31: 05 63 0e d4 fa              	addl	$0xfad40e63, %eax       # imm = 0xFAD40E63
180340b36: 3a 74 77 12                 	cmpb	0x12(%rdi,%rsi,2), %dh
180340b3a: ed                          	inl	%dx, %eax
180340b3b: 29 73 71                    	subl	%esi, 0x71(%rbx)
180340b3e: 23 7e 8f                    	andl	-0x71(%rsi), %edi
180340b41: 34 a1                       	xorb	$-0x5f, %al
180340b43: 30 42 fa                    	xorb	%al, -0x6(%rdx)
180340b46: 2a f1                       	subb	%cl, %dh
180340b48: 81 4a 43 07 0b cf 7e        	orl	$0x7ecf0b07, 0x43(%rdx) # imm = 0x7ECF0B07
180340b4f: d9 89 ad 9b ca fc           	<unknown>
180340b55: 00 6c 83 35                 	addb	%ch, 0x35(%rbx,%rax,4)
180340b59: d0 3b                       	sarb	(%rbx)
180340b5b: e2 05                       	loop	0x180340b62 <.text+0x330b62>
180340b5d: 90                          	nop
180340b5e: 25 f8 82 a3 6a              	andl	$0x6aa382f8, %eax       # imm = 0x6AA382F8
180340b63: 97                          	xchgl	%edi, %eax
180340b64: 5b                          	popq	%rbx
180340b65: 12 38                       	adcb	(%rax), %bh
180340b67: 09 69 20                    	orl	%ebp, 0x20(%rcx)
180340b6a: 45 5b                       	popq	%r11
180340b6c: cc                          	int3
180340b6d: a8 23                       	testb	$0x23, %al
180340b6f: b4 b3                       	movb	$-0x4d, %ah
180340b71: 55                          	pushq	%rbp
180340b72: e5 7c                       	inl	$0x7c, %eax
180340b74: 1c c2                       	sbbb	$-0x3e, %al
180340b76: c6 a1 8d c3 d9 fe           	<unknown>
180340b7c: bb 6e a4 6c 3c              	movl	$0x3c6ca46e, %ebx       # imm = 0x3C6CA46E
180340b81: 1e                          	<unknown>
180340b82: 20 b2 fb b6 19 b2           	andb	%dh, -0x4de64905(%rdx)
180340b88: 39 88 ac ef 53 4c           	cmpl	%ecx, 0x4c53efac(%rax)
180340b8e: 97                          	xchgl	%edi, %eax
180340b8f: f2 74 12                    	repne		je	0x180340ba4 <.text+0x330ba4>
180340b92: c5 57 3a                    	<unknown>
180340b95: d4                          	<unknown>
180340b96: 3e 67 a5                    	movsl	%ds:(%esi), %es:(%edi)
180340b99: 73 52                       	jae	0x180340bed <.text+0x330bed>
180340b9b: c4 f4 a9                    	<unknown>
180340b9e: 27                          	<unknown>
180340b9f: 15 b1 1c 3a d3              	adcl	$0xd33a1cb1, %eax       # imm = 0xD33A1CB1
180340ba4: 5e                          	popq	%rsi
180340ba5: 9c                          	pushfq
180340ba6: d2 59 41                    	rcrb	%cl, 0x41(%rcx)
180340ba9: 16                          	<unknown>
180340baa: 13 00                       	adcl	(%rax), %eax
180340bac: 74 21                       	je	0x180340bcf <.text+0x330bcf>
180340bae: 10 bc 23 72 42 8c 6b        	adcb	%bh, 0x6b8c4272(%rbx,%riz)
180340bb5: 8e f4                       	<unknown>
180340bb7: b4 b8                       	movb	$-0x48, %ah
180340bb9: 93                          	xchgl	%ebx, %eax
180340bba: 16                          	<unknown>
180340bbb: 0c eb                       	orb	$-0x15, %al
180340bbd: 82                          	<unknown>
180340bbe: 8c 0a                       	movw	%cs, (%rdx)
180340bc0: 72 2d                       	jb	0x180340bef <.text+0x330bef>
180340bc2: 15 af 55 2a de              	adcl	$0xde2a55af, %eax       # imm = 0xDE2A55AF
180340bc7: 5a                          	popq	%rdx
180340bc8: 63 ea                       	movslq	%edx, %ebp
180340bca: 36 25 99 69 b1 c7           	andl	$0xc7b16999, %eax       # imm = 0xC7B16999
180340bd0: 4b 77 23                    	ja	0x180340bf6 <.text+0x330bf6>
180340bd3: a4                          	movsb	(%rsi), %es:(%rdi)
180340bd4: d4                          	<unknown>
180340bd5: a0 39 2f c3 4c bf 17 81 d6  	movabsb	-0x297ee840b33cd0c7, %al
180340bde: bd 85 e3 fe 3e              	movl	$0x3efee385, %ebp       # imm = 0x3EFEE385
180340be3: 4f ef                       	outl	%eax, %dx
180340be5: 28 61 38                    	subb	%ah, 0x38(%rcx)
180340be8: e9 f2 c4 ec 87              	jmp	0x10820d0df
180340bed: d4                          	<unknown>
180340bee: 7d 60                       	jge	0x180340c50 <.text+0x330c50>
180340bf0: 5a                          	popq	%rdx
180340bf1: 79 14                       	jns	0x180340c07 <.text+0x330c07>
180340bf3: 5d                          	popq	%rbp
180340bf4: bd 36 01 2e bd              	movl	$0xbd2e0136, %ebp       # imm = 0xBD2E0136
180340bf9: 42 0c e7                    	orb	$-0x19, %al
180340bfc: 18 a2 d7 93 8f 62           	sbbb	%ah, 0x628f93d7(%rdx)
180340c02: bf b6 4c c6 da              	movl	$0xdac64cb6, %edi       # imm = 0xDAC64CB6
180340c07: 15 22 6a 8a 7d              	adcl	$0x7d8a6a22, %eax       # imm = 0x7D8A6A22
180340c0c: 6b 84 c2 eb 20 ae 4e 65     	imull	$0x65, 0x4eae20eb(%rdx,%rax,8), %eax
180340c14: ec                          	inb	%dx, %al
180340c15: 58                          	popq	%rax
180340c16: 8e 6d 2f                    	movw	0x2f(%rbp), %gs
180340c19: 4a cf                       	iretq
180340c1b: d7                          	xlatb
180340c1c: 87 5b fc                    	xchgl	%ebx, -0x4(%rbx)
180340c1f: 67 66 81 01 ba c8           	addw	$0xc8ba, (%ecx)         # imm = 0xC8BA
180340c25: d5 f0 d6                    	<unknown>
180340c28: a0 6a bf e5 fc 20 9f 3d 3b  	movabsb	0x3b3d9f20fce5bf6a, %al
180340c31: cb                          	lretl
180340c32: 42 9c                       	pushfq
180340c34: 2f                          	<unknown>
180340c35: 96                          	xchgl	%esi, %eax
180340c36: 40 62 9e d9 d8 01 4c c4 66  	<unknown>
180340c3f: be c6 ea 76 b0              	movl	$0xb076eac6, %esi       # imm = 0xB076EAC6
180340c44: 19 89 30 7e fd ca           	sbbl	%ecx, -0x350281d0(%rcx)
180340c4a: a1 86 66 a8 93 bc dc 15 c4  	movabsl	-0x3bea23436c57997a, %eax
180340c53: e6 68                       	outb	%al, $0x68
180340c55: 52                          	pushq	%rdx
180340c56: b4 99                       	movb	$-0x67, %ah
180340c58: 0d 67 1c c9 ac              	orl	$0xacc91c67, %eax       # imm = 0xACC91C67
180340c5d: 29 05 a8 9c a8 6b           	subl	%eax, 0x6ba89ca8(%rip)  # 0x1ebdca90b
180340c63: 25 9e 09 dc 31              	andl	$0x31dc099e, %eax       # imm = 0x31DC099E
180340c68: ce                          	<unknown>
180340c69: c4 d8 cd                    	<unknown>
180340c6c: 40 b1 73                    	movb	$0x73, %cl
180340c6f: f8                          	clc
180340c70: 8b a8 8e e2 5c 61           	movl	0x615ce28e(%rax), %ebp
180340c76: 2b 3d 9a f6 d8 ab           	subl	-0x54270966(%rip), %edi # 0x12c0d0316
180340c7c: 26 23 6d aa                 	andl	%es:-0x56(%rbp), %ebp
180340c80: 3d 5b a5 5c 23              	cmpl	$0x235ca55b, %eax       # imm = 0x235CA55B
180340c85: d2 28                       	shrb	%cl, (%rax)
180340c87: 5e                          	popq	%rsi
180340c88: 8f e4 c7                    	<unknown>
180340c8b: 28 d9                       	subb	%bl, %cl
180340c8d: 84 89 f0 13 b3 23           	testb	%cl, 0x23b313f0(%rcx)
180340c93: 55                          	pushq	%rbp
180340c94: 98                          	cwtl
180340c95: 45 25 8e 54 cf e8           	andl	$0xe8cf548e, %eax       # imm = 0xE8CF548E
180340c9b: e4 08                       	inb	$0x8, %al
180340c9d: 3e cd 78                    	int	$0x78
180340ca0: ef                          	outl	%eax, %dx
180340ca1: 1a b1 7c f6 e4 3c           	sbbb	0x3ce4f67c(%rcx), %dh
180340ca7: ee                          	outb	%al, %dx
180340ca8: 2d e3 d2 e0 1d              	subl	$0x1de0d2e3, %eax       # imm = 0x1DE0D2E3
180340cad: c3                          	retq
180340cae: 61                          	<unknown>
180340caf: 43 c4 16 ef                 	<unknown>
180340cb3: e2 47                       	loop	0x180340cfc <.text+0x330cfc>
180340cb5: f9                          	stc
180340cb6: 69 15 09 14 f2 74 af dd 7b 1f       	imull	$0x1f7bddaf, 0x74f21409(%rip), %edx # imm = 0x1F7BDDAF
                                                                        # 0x1f52620c9
180340cc0: 76 fd                       	jbe	0x180340cbf <.text+0x330cbf>
180340cc2: 18 7e e5                    	sbbb	%bh, -0x1b(%rsi)
180340cc5: 11 fd                       	adcl	%edi, %ebp
180340cc7: 7d 15                       	jge	0x180340cde <.text+0x330cde>
180340cc9: 8e 01                       	movw	(%rcx), %es
180340ccb: cc                          	int3
180340ccc: ee                          	outb	%al, %dx
180340ccd: 66 cd 18                    	int	$0x18
180340cd0: b9 0e 1c d7 3a              	movl	$0x3ad71c0e, %ecx       # imm = 0x3AD71C0E
180340cd5: 13 a1 8f d7 a0 2b           	adcl	0x2ba0d78f(%rcx), %esp
180340cdb: 93                          	xchgl	%ebx, %eax
180340cdc: be b9 e5 ad de              	movl	$0xdeade5b9, %esi       # imm = 0xDEADE5B9
180340ce1: da c4                       	fcmovb	%st(4), %st
180340ce3: 07                          	<unknown>
180340ce4: 09 99 58 28 80 c3           	orl	%ebx, -0x3c7fd7a8(%rcx)
180340cea: 6c                          	insb	%dx, %es:(%rdi)
180340ceb: c1 d4 b3                    	rcll	$0xb3, %esp
180340cee: 93                          	xchgl	%ebx, %eax
180340cef: 89 2e                       	movl	%ebp, (%rsi)
180340cf1: bb 21 f0 34 bb              	movl	$0xbb34f021, %ebx       # imm = 0xBB34F021
180340cf6: bb 11 89 88 81              	movl	$0x81888911, %ebx       # imm = 0x81888911
180340cfb: ee                          	outb	%al, %dx
180340cfc: ec                          	inb	%dx, %al
180340cfd: 1b ea                       	sbbl	%edx, %ebp
180340cff: 0b f6                       	orl	%esi, %esi
180340d01: 33 21                       	xorl	(%rcx), %esp
180340d03: 62 fe 80 8c 7c              	<unknown>
180340d08: 78 27                       	js	0x180340d31 <.text+0x330d31>
180340d0a: 70 cc                       	jo	0x180340cd8 <.text+0x330cd8>
180340d0c: ef                          	outl	%eax, %dx
180340d0d: f0                          	lock
180340d0e: 19 3e                       	sbbl	%edi, (%rsi)
180340d10: 3c 9f                       	cmpb	$-0x61, %al
180340d12: b4 c9                       	movb	$-0x37, %ah
180340d14: 1f                          	<unknown>
180340d15: 4e 7d 1a                    	jge	0x180340d32 <.text+0x330d32>
180340d18: 32 4a c3                    	xorb	-0x3d(%rdx), %cl
180340d1b: 4e 73 50                    	jae	0x180340d6e <.text+0x330d6e>
180340d1e: 57                          	pushq	%rdi
180340d1f: ef                          	outl	%eax, %dx
180340d20: cd 16                       	int	$0x16
180340d22: 71 ac                       	jno	0x180340cd0 <.text+0x330cd0>
180340d24: b5 b5                       	movb	$-0x4b, %ch
180340d26: 9e                          	sahf
180340d27: 18 05 53 58 10 04           	sbbb	%al, 0x4105853(%rip)    # 0x184446580
180340d2d: 81 48 20 5e 1b 76 df        	orl	$0xdf761b5e, 0x20(%rax) # imm = 0xDF761B5E
180340d34: 4d 50                       	pushq	%r8
180340d36: 6a 8c                       	pushq	$-0x74
180340d38: 68 98 60 c3 ab              	pushq	$-0x543c9f68            # imm = 0xABC36098
180340d3d: f1                          	<unknown>
180340d3e: 76 fc                       	jbe	0x180340d3c <.text+0x330d3c>
180340d40: b7 2e                       	movb	$0x2e, %bh
180340d42: d7                          	xlatb
180340d43: ca fc 88                    	lretl	$-0x7704                # imm = 0x88FC
180340d46: 1c 01                       	sbbb	$0x1, %al
180340d48: 04 d5                       	addb	$-0x2b, %al
180340d4a: 42 e0 82                    	loopne	0x180340ccf <.text+0x330ccf>
180340d4d: c3                          	retq
180340d4e: 0f 40 91 6e ad 0f 3f        	cmovol	0x3f0fad6e(%rcx), %edx
180340d55: ee                          	outb	%al, %dx
180340d56: dc 63 a9                    	fsubl	-0x57(%rbx)
180340d59: f5                          	cmc
180340d5a: b5 66                       	movb	$0x66, %ch
180340d5c: c6 f4                       	<unknown>
180340d5e: d9 84 85 5b 36 7b ce        	flds	-0x3184c9a5(%rbp,%rax,4)
180340d65: df 76 56                    	fbstp	0x56(%rsi)
180340d68: 49 08 11                    	orb	%dl, (%r9)
180340d6b: 98                          	cwtl
180340d6c: 3d 52 44 d9 a7              	cmpl	$0xa7d94452, %eax       # imm = 0xA7D94452
180340d71: 11 08                       	adcl	%ecx, (%rax)
180340d73: 62 8c ba 42 92              	<unknown>
180340d78: 58                          	popq	%rax
180340d79: ba 50 64 bc 32              	movl	$0x32bc6450, %edx       # imm = 0x32BC6450
180340d7e: d1 87 18 bc 51 f6           	roll	-0x9ae43e8(%rdi)
180340d84: 57                          	pushq	%rdi
180340d85: 54                          	pushq	%rsp
180340d86: 8c 8f a3 15 0b 64           	movw	%cs, 0x640b15a3(%rdi)
180340d8c: 54                          	pushq	%rsp
180340d8d: e9 80 ad 63 44              	jmp	0x1c497bb12
180340d92: f7 4f 64                    	<unknown>
180340d95: 02 a5 9f 58 0d 15           	addb	0x150d589f(%rbp), %ah
180340d9b: 42 60                       	<unknown>
180340d9d: 1b c3                       	sbbl	%ebx, %eax
180340d9f: e4 86                       	inb	$0x86, %al
180340da1: 71 4e                       	jno	0x180340df1 <.text+0x330df1>
180340da3: 28 b3 7f c9 2f 5b           	subb	%dh, 0x5b2fc97f(%rbx)
180340da9: f6 2d 6c e7 62 6f           	imulb	0x6f62e76c(%rip)        # 0x1ef96f51b
180340daf: 2d 53 b4 f4 f3              	subl	$0xf3f4b453, %eax       # imm = 0xF3F4B453
180340db4: e5 a4                       	inl	$0xa4, %eax
180340db6: 78 df                       	js	0x180340d97 <.text+0x330d97>
180340db8: 21 2a                       	andl	%ebp, (%rdx)
180340dba: 14 97                       	adcb	$-0x69, %al
180340dbc: 4c 1b b5 e4 df be 3e        	sbbq	0x3ebedfe4(%rbp), %r14
180340dc3: d9 41 71                    	flds	0x71(%rcx)
180340dc6: 61                          	<unknown>
180340dc7: 49 9b                       	wait
180340dc9: a5                          	movsl	(%rsi), %es:(%rdi)
180340dca: f6 be 2e 60 07 42           	idivb	0x4207602e(%rsi)
180340dd0: a7                          	cmpsl	%es:(%rdi), (%rsi)
180340dd1: db d6                       	fcmovnbe	%st(6), %st
180340dd3: 6a 57                       	pushq	$0x57
180340dd5: f1                          	<unknown>
180340dd6: 15 d4 5d 3c de              	adcl	$0xde3c5dd4, %eax       # imm = 0xDE3C5DD4
180340ddb: 8c d6                       	movl	%ss, %esi
180340ddd: 06                          	<unknown>
180340dde: d2 06                       	rolb	%cl, (%rsi)
180340de0: e5 1a                       	inl	$0x1a, %eax
180340de2: 2d f6 d2 3d 30              	subl	$0x303dd2f6, %eax       # imm = 0x303DD2F6
180340de7: 52                          	pushq	%rdx
180340de8: 06                          	<unknown>
180340de9: 9b                          	wait
180340dea: 10 4e 14                    	adcb	%cl, 0x14(%rsi)
180340ded: 7d 42                       	jge	0x180340e31 <.text+0x330e31>
180340def: 73 00                       	jae	0x180340df1 <.text+0x330df1>
180340df1: 05 88 8e 01 a5              	addl	$0xa5018e88, %eax       # imm = 0xA5018E88
180340df6: f7 a9 58 f9 ca 09           	imull	0x9caf958(%rcx)
180340dfc: 4d e6 ec                    	outb	%al, $0xec
180340dff: ce                          	<unknown>
180340e00: 73 aa                       	jae	0x180340dac <.text+0x330dac>
180340e02: f1                          	<unknown>
180340e03: 95                          	xchgl	%ebp, %eax
180340e04: 09 ce                       	orl	%ecx, %esi
180340e06: 06                          	<unknown>
180340e07: 44 fd                       	std
180340e09: 92                          	xchgl	%edx, %eax
180340e0a: 0d 3a 24 eb ca              	orl	$0xcaeb243a, %eax       # imm = 0xCAEB243A
180340e0f: 38 4c 72 a2                 	cmpb	%cl, -0x5e(%rdx,%rsi,2)
180340e13: 4c 65 de f9                 	fdivrp	%st, %st(1)
180340e17: 15 b4 5a 9f 8d              	adcl	$0x8d9f5ab4, %eax       # imm = 0x8D9F5AB4
180340e1c: 63 f9                       	movslq	%ecx, %edi
180340e1e: ac                          	lodsb	(%rsi), %al
180340e1f: 36 ed                       	inl	%dx, %eax
180340e21: d5 79 dc ba 33 5b bd ea     	fdivrl	-0x1542a4cd(%r26)
180340e29: b7 10                       	movb	$0x10, %bh
180340e2b: 00 d5                       	addb	%dl, %ch
180340e2d: 46 3e b7 d2                 	movb	$-0x2e, %bh
180340e31: f8                          	clc
180340e32: 0a ed                       	orb	%ch, %ch
180340e34: 26 55                       	pushq	%rbp
180340e36: 0a 64 02 8a                 	orb	-0x76(%rdx,%rax), %ah
180340e3a: b7 00                       	movb	$0x0, %bh
180340e3c: fb                          	sti
180340e3d: 76 a1                       	jbe	0x180340de0 <.text+0x330de0>
180340e3f: e1 c4                       	loope	0x180340e05 <.text+0x330e05>
180340e41: 48 99                       	cqto
180340e43: 45 e3 55                    	jrcxz	0x180340e9b <.text+0x330e9b>
180340e46: 79 9e                       	jns	0x180340de6 <.text+0x330de6>
180340e48: 91                          	xchgl	%ecx, %eax
180340e49: e6 22                       	outb	%al, $0x22
180340e4b: 7c 4b                       	jl	0x180340e98 <.text+0x330e98>
180340e4d: 74 1c                       	je	0x180340e6b <.text+0x330e6b>
180340e4f: d5 03 aa                    	stosb	%al, %es:(%rdi)
180340e52: 81 19 15 d1 44 88           	sbbl	$0x8844d115, (%rcx)     # imm = 0x8844D115
180340e58: 1e                          	<unknown>
180340e59: fb                          	sti
180340e5a: 66 7c 93                    	jl	0x180340df0 <.text+0x330df0>
180340e5d: ce                          	<unknown>
180340e5e: 43 ba 22 fd 62 9f           	movl	$0x9f62fd22, %r10d      # imm = 0x9F62FD22
180340e64: e4 04                       	inb	$0x4, %al
180340e66: c5 71 40                    	<unknown>
180340e69: ab                          	stosl	%eax, %es:(%rdi)
180340e6a: 44 bc 26 46 d3 ca           	movl	$0xcad34626, %esp       # imm = 0xCAD34626
180340e70: f9                          	stc
180340e71: 4b 66 f7 6f f3              	imulw	-0xd(%rdi)
180340e76: fd                          	std
180340e77: 8f 02                       	popq	(%rdx)
180340e79: af                          	scasl	%es:(%rdi), %eax
180340e7a: 3d ef 50 cd 8c              	cmpl	$0x8ccd50ef, %eax       # imm = 0x8CCD50EF
180340e7f: fc                          	cld
180340e80: 8e ee                       	movl	%esi, %gs
180340e82: 99                          	cltd
180340e83: 94                          	xchgl	%esp, %eax
180340e84: 13 5b 6a                    	adcl	0x6a(%rbx), %ebx
180340e87: ba 2c da 82 1e              	movl	$0x1e82da2c, %edx       # imm = 0x1E82DA2C
180340e8c: 06                          	<unknown>
180340e8d: 93                          	xchgl	%ebx, %eax
180340e8e: 01 4c e1 c1                 	addl	%ecx, -0x3f(%rcx,%riz,8)
180340e92: 1d 77 51 63 f4              	sbbl	$0xf4635177, %eax       # imm = 0xF4635177
180340e97: 39 77 45                    	cmpl	%esi, 0x45(%rdi)
180340e9a: b5 9f                       	movb	$-0x61, %ch
180340e9c: 2e c0 b5 2b d7 30 60        	<unknown>
180340ea3: 11 e4                       	adcl	%esp, %esp
180340ea5: d4                          	<unknown>
180340ea6: cc                          	int3
180340ea7: 0f 13 1c fb                 	movlps	%xmm3, (%rbx,%rdi,8)
180340eab: dd cf                       	<unknown>
180340ead: 39 12                       	cmpl	%edx, (%rdx)
180340eaf: 01 33                       	addl	%esi, (%rbx)
180340eb1: 8d b4 f8 b8 c6 48 e8        	leal	-0x17b73948(%rax,%rdi,8), %esi
180340eb8: 1a f8                       	sbbb	%al, %bh
180340eba: 94                          	xchgl	%esp, %eax
180340ebb: 37                          	<unknown>
180340ebc: f6 32                       	divb	(%rdx)
180340ebe: 84 0b                       	testb	%cl, (%rbx)
180340ec0: 5c                          	popq	%rsp
180340ec1: 0f 5b 22                    	cvtdq2ps	(%rdx), %xmm4
180340ec4: d9 7c c2 1e                 	fnstcw	0x1e(%rdx,%rax,8)
180340ec8: 11 9a 6f 9f 44 86           	adcl	%ebx, -0x79bb6091(%rdx)
180340ece: 2f                          	<unknown>
180340ecf: e0 ec                       	loopne	0x180340ebd <.text+0x330ebd>
180340ed1: 9f                          	lahf
180340ed2: 37                          	<unknown>
180340ed3: 78 e4                       	js	0x180340eb9 <.text+0x330eb9>
180340ed5: 22 b1 f2 06 a5 46           	andb	0x46a506f2(%rcx), %dh
180340edb: 88 e7                       	movb	%ah, %bh
180340edd: a0 f5 d4 93 a0 7d 76 b7 34  	movabsb	0x34b7767da093d4f5, %al
180340ee6: fe ec                       	<unknown>
180340ee8: 0d b7 e5 d6 57              	orl	$0x57d6e5b7, %eax       # imm = 0x57D6E5B7
180340eed: ba 3f 53 27 3b              	movl	$0x3b27533f, %edx       # imm = 0x3B27533F
180340ef2: ba 7f b3 d5 4c              	movl	$0x4cd5b37f, %edx       # imm = 0x4CD5B37F
180340ef7: e1 9b                       	loope	0x180340e94 <.text+0x330e94>
180340ef9: c7 5b f7                    	<unknown>
180340efc: 93                          	xchgl	%ebx, %eax
180340efd: c8 70 5c f0                 	enter	$0x5c70, $-0x10         # imm = 0x5C70
180340f01: 6d                          	insl	%dx, %es:(%rdi)
180340f02: 7b d4                       	jnp	0x180340ed8 <.text+0x330ed8>
180340f04: ab                          	stosl	%eax, %es:(%rdi)
180340f05: a6                          	cmpsb	%es:(%rdi), (%rsi)
180340f06: 5e                          	popq	%rsi
180340f07: 45 56                       	pushq	%r14
180340f09: a3 32 6b 10 78 08 ef a3 8b  	movabsl	%eax, -0x745c10f787ef94ce
180340f12: 08 ac 8d 9f 29 bc 31        	orb	%ch, 0x31bc299f(%rbp,%rcx,4)
180340f19: eb 16                       	jmp	0x180340f31 <.text+0x330f31>
180340f1b: 70 e0                       	jo	0x180340efd <.text+0x330efd>
180340f1d: 69 80 fe 2f 32 a6 f2 d4 46 8c       	imull	$0x8c46d4f2, -0x59cdd002(%rax), %eax # imm = 0x8C46D4F2
180340f27: 5f                          	popq	%rdi
180340f28: a7                          	cmpsl	%es:(%rdi), (%rsi)
180340f29: 20 5e ba                    	andb	%bl, -0x46(%rsi)
180340f2c: b5 e1                       	movb	$-0x1f, %ch
180340f2e: 8f 9b 17                    	<unknown>
180340f31: a4                          	movsb	(%rsi), %es:(%rdi)
180340f32: 98                          	cwtl
180340f33: 9e                          	sahf
180340f34: 6d                          	insl	%dx, %es:(%rdi)
180340f35: 58                          	popq	%rax
180340f36: b8 c5 23 fb 86              	movl	$0x86fb23c5, %eax       # imm = 0x86FB23C5
180340f3b: fc                          	cld
180340f3c: e8 9e 6f 31 1e              	callq	0x19e657edf
180340f41: 74 c5                       	je	0x180340f08 <.text+0x330f08>
180340f43: e6 55                       	outb	%al, $0x55
180340f45: b0 b1                       	movb	$-0x4f, %al
180340f47: f2 16                       	<unknown>
180340f49: 39 f1                       	cmpl	%esi, %ecx
180340f4b: 52                          	pushq	%rdx
180340f4c: bb 16 07 4f b0              	movl	$0xb04f0716, %ebx       # imm = 0xB04F0716
180340f51: aa                          	stosb	%al, %es:(%rdi)
180340f52: 29 d3                       	subl	%edx, %ebx
180340f54: 43 d9 8d 71 91 27 ab        	<unknown>
180340f5b: 70 a1                       	jo	0x180340efe <.text+0x330efe>
180340f5d: 1b 87 95 a6 c3 62           	sbbl	0x62c3a695(%rdi), %eax
180340f63: 3d 94 1a 48 c9              	cmpl	$0xc9481a94, %eax       # imm = 0xC9481A94
180340f68: 0e                          	<unknown>
180340f69: b4 f0                       	movb	$-0x10, %ah
180340f6b: 31 3f                       	xorl	%edi, (%rdi)
180340f6d: ce                          	<unknown>
180340f6e: 9d                          	popfq
180340f6f: 77 3d                       	ja	0x180340fae <.text+0x330fae>
180340f71: 54                          	pushq	%rsp
180340f72: 23 a6 c1 29 b1 3c           	andl	0x3cb129c1(%rsi), %esp
180340f78: 72 6e                       	jb	0x180340fe8 <.text+0x330fe8>
180340f7a: 6e                          	outsb	(%rsi), %dx
180340f7b: 44 e0 59                    	loopne	0x180340fd7 <.text+0x330fd7>
180340f7e: 98                          	cwtl
180340f7f: 98                          	cwtl
180340f80: 46 98                       	cwtl
180340f82: 82                          	<unknown>
180340f83: c1 36                       	<unknown>
180340f85: ec                          	inb	%dx, %al
180340f86: 78 be                       	js	0x180340f46 <.text+0x330f46>
180340f88: 32 26                       	xorb	(%rsi), %ah
180340f8a: 28 19                       	subb	%bl, (%rcx)
180340f8c: 77 98                       	ja	0x180340f26 <.text+0x330f26>
180340f8e: 77 c9                       	ja	0x180340f59 <.text+0x330f59>
180340f90: 2c e5                       	subb	$-0x1b, %al
180340f92: 1a fc                       	sbbb	%ah, %bh
180340f94: d7                          	xlatb
180340f95: c6 fe                       	<unknown>
180340f97: 6c                          	insb	%dx, %es:(%rdi)
180340f98: bd da 66 b9 af              	movl	$0xafb966da, %ebp       # imm = 0xAFB966DA
180340f9d: 1f                          	<unknown>
180340f9e: 83 04 53 5c                 	addl	$0x5c, (%rbx,%rdx,2)
180340fa2: 47 e3 42                    	jrcxz	0x180340fe7 <.text+0x330fe7>
180340fa5: 45 d1 ae 51 89 49 38        	shrl	0x38498951(%r14)
180340fac: 7d 7c                       	jge	0x18034102a <.text+0x33102a>
180340fae: 08 13                       	orb	%dl, (%rbx)
180340fb0: 1e                          	<unknown>
180340fb1: ef                          	outl	%eax, %dx
180340fb2: 7b 03                       	jnp	0x180340fb7 <.text+0x330fb7>
180340fb4: e1 14                       	loope	0x180340fca <.text+0x330fca>
180340fb6: 0d ab 36 02 14              	orl	$0x140236ab, %eax       # imm = 0x140236AB
180340fbb: 42 60                       	<unknown>
180340fbd: b8 1e ac 77 a4              	movl	$0xa477ac1e, %eax       # imm = 0xA477AC1E
180340fc2: dd 63 84                    	frstor	-0x7c(%rbx)
180340fc5: 18 57 78                    	sbbb	%dl, 0x78(%rdi)
180340fc8: fc                          	cld
180340fc9: a1 1e 52 9d 7b b5 51 27 5c  	movabsl	0x5c2751b57b9d521e, %eax
180340fd2: 9a                          	<unknown>
180340fd3: c3                          	retq
180340fd4: 7b 13                       	jnp	0x180340fe9 <.text+0x330fe9>
180340fd6: a9 30 f9 54 14              	testl	$0x1454f930, %eax       # imm = 0x1454F930
180340fdb: dd 95 bd 08 de 60           	fstl	0x60de08bd(%rbp)
180340fe1: ef                          	outl	%eax, %dx
180340fe2: ac                          	lodsb	(%rsi), %al
180340fe3: 9e                          	sahf
180340fe4: 78 dc                       	js	0x180340fc2 <.text+0x330fc2>
180340fe6: 75 f1                       	jne	0x180340fd9 <.text+0x330fd9>
180340fe8: 7e 15                       	jle	0x180340fff <.text+0x330fff>
180340fea: 64 2b bd 92 6d 1c 4d        	subl	%fs:0x4d1c6d92(%rbp), %edi
180340ff1: 33 e4                       	xorl	%esp, %esp
180340ff3: 84 66 a0                    	testb	%ah, -0x60(%rsi)
180340ff6: 8b e4                       	movl	%esp, %esp
180340ff8: a5                          	movsl	(%rsi), %es:(%rdi)
180340ff9: 34 85                       	xorb	$-0x7b, %al
180340ffb: 9f                          	lahf
180340ffc: 75 27                       	jne	0x180341025 <.text+0x331025>
180340ffe: d7                          	xlatb
180340fff: 65 0b 6d 16                 	orl	%gs:0x16(%rbp), %ebp
180341003: 94                          	xchgl	%esp, %eax
180341004: f5                          	cmc
180341005: 6b 53 a0 52                 	imull	$0x52, -0x60(%rbx), %edx
180341009: c0 5a 9d 8f                 	rcrb	$0x8f, -0x63(%rdx)
18034100d: bc d1 5a 13 2e              	movl	$0x2e135ad1, %esp       # imm = 0x2E135AD1
180341012: d1 b3 4f 69 02 18           	<unknown>
180341018: f8                          	clc
180341019: 86 ed                       	xchgb	%ch, %ch
18034101b: 41 fc                       	cld
18034101d: 54                          	pushq	%rsp
18034101e: ad                          	lodsl	(%rsi), %eax
18034101f: 3f                          	<unknown>
180341020: f6 a5 b2 4b 31 f5           	mulb	-0xaceb44e(%rbp)
180341026: 02 c4                       	addb	%ah, %al
180341028: ce                          	<unknown>
180341029: 8e d1                       	movl	%ecx, %ss
18034102b: 9c                          	pushfq
18034102c: 64 44 6f                    	outsl	%fs:(%rsi), %dx
18034102f: 31 8c 1a 81 ab 99 81        	xorl	%ecx, -0x7e66547f(%rdx,%rbx)
180341036: 05 07 75 63 6c              	addl	$0x6c637507, %eax       # imm = 0x6C637507
18034103b: 43 e7 59                    	outl	%eax, $0x59
18034103e: c1 79 6a 65                 	sarl	$0x65, 0x6a(%rcx)
180341042: 64 35 cc 0d 2d 38           	xorl	$0x382d0dcc, %eax       # imm = 0x382D0DCC
180341048: 9c                          	pushfq
180341049: d2 fc                       	sarb	%cl, %ah
18034104b: 16                          	<unknown>
18034104c: f0                          	lock
18034104d: 87 cb                       	xchgl	%ebx, %ecx
18034104f: 0b 68 e9                    	orl	-0x17(%rax), %ebp
180341052: e7 4b                       	outl	%eax, $0x4b
180341054: d0 00                       	rolb	(%rax)
180341056: 5d                          	popq	%rbp
180341057: 97                          	xchgl	%edi, %eax
180341058: 1a 51 e2                    	sbbb	-0x1e(%rcx), %dl
18034105b: 0f 9b 38                    	setnp	(%rax)
18034105e: 74 1d                       	je	0x18034107d <.text+0x33107d>
180341060: a9 a3 97 d0 2b              	testl	$0x2bd097a3, %eax       # imm = 0x2BD097A3
180341065: 46 b1 ab                    	movb	$-0x55, %cl
180341068: 82                          	<unknown>
180341069: 12 8f ac 90 5e e9           	adcb	-0x16a16f54(%rdi), %cl
18034106f: a3 f7 83 e7 d1 54 fc 57 8c  	movabsl	%eax, -0x73a803ab2e187c09
180341078: 3b 23                       	cmpl	(%rbx), %esp
18034107a: 68 bd 9e f8 44              	pushq	$0x44f89ebd             # imm = 0x44F89EBD
18034107f: fd                          	std
180341080: 05 91 4e 7a 15              	addl	$0x157a4e91, %eax       # imm = 0x157A4E91
180341085: 77 b6                       	ja	0x18034103d <.text+0x33103d>
180341087: 37                          	<unknown>
180341088: 12 27                       	adcb	(%rdi), %ah
18034108a: 7b fd                       	jnp	0x180341089 <.text+0x331089>
18034108c: 4c ba c9 4a 7f 0c d9 5a 8b 91       	movabsq	$-0x6e74a526f380b537, %rdx # imm = 0x918B5AD90C7F4AC9
180341096: 14 d0                       	adcb	$-0x30, %al
180341098: e6 61                       	outb	%al, $0x61
18034109a: 9a                          	<unknown>
18034109b: 54                          	pushq	%rsp
18034109c: 54                          	pushq	%rsp
18034109d: ae                          	scasb	%es:(%rdi), %al
18034109e: 76 26                       	jbe	0x1803410c6 <.text+0x3310c6>
1803410a0: 01 9d 93 a0 82 2d           	addl	%ebx, 0x2d82a093(%rbp)
1803410a6: 1c 52                       	sbbb	$0x52, %al
1803410a8: cd 97                       	int	$0x97
1803410aa: 17                          	<unknown>
1803410ab: ce                          	<unknown>
1803410ac: b8 75 a7 1b 79              	movl	$0x791ba775, %eax       # imm = 0x791BA775
1803410b1: 8b 86 e6 66 33 30           	movl	0x303366e6(%rsi), %eax
1803410b7: 4a 19 e6                    	sbbq	%rsp, %rsi
1803410ba: da c0                       	fcmovb	%st(0), %st
1803410bc: 69 5c 55 ef 9b 53 25 5e     	imull	$0x5e25539b, -0x11(%rbp,%rdx,2), %ebx # imm = 0x5E25539B
1803410c4: 3e 08 41 4f                 	orb	%al, %ds:0x4f(%rcx)
1803410c8: 4a 89 99 43 78 0a a4        	movq	%rbx, -0x5bf587bd(%rcx)
1803410cf: 86 a9 42 13 1f d1           	xchgb	%ch, -0x2ee0ecbe(%rcx)
1803410d5: 7a 25                       	jp	0x1803410fc <.text+0x3310fc>
1803410d7: 81 a5 77 99 fc 52 18 9b 77 cf       	andl	$0xcf779b18, 0x52fc9977(%rbp) # imm = 0xCF779B18
1803410e1: b5 68                       	movb	$0x68, %ch
1803410e3: df 75 b7                    	fbstp	-0x49(%rbp)
1803410e6: 94                          	xchgl	%esp, %eax
1803410e7: 00 2f                       	addb	%ch, (%rdi)
1803410e9: ac                          	lodsb	(%rsi), %al
1803410ea: d3 46 ba                    	roll	%cl, -0x46(%rsi)
1803410ed: 38 4d 32                    	cmpb	%cl, 0x32(%rbp)
1803410f0: 79 f8                       	jns	0x1803410ea <.text+0x3310ea>
1803410f2: cc                          	int3
1803410f3: b5 c9                       	movb	$-0x37, %ch
1803410f5: 16                          	<unknown>
1803410f6: 99                          	cltd
1803410f7: 58                          	popq	%rax
1803410f8: 04 8d                       	addb	$-0x73, %al
1803410fa: c9                          	leave
1803410fb: b3 68                       	movb	$0x68, %bl
1803410fd: 6d                          	insl	%dx, %es:(%rdi)
1803410fe: be 42 7a 14 2a              	movl	$0x2a147a42, %esi       # imm = 0x2A147A42
180341103: 6d                          	insl	%dx, %es:(%rdi)
180341104: ef                          	outl	%eax, %dx
180341105: 86 86 95 33 89 f4           	xchgb	%al, -0xb76cc6b(%rsi)
18034110b: ee                          	outb	%al, %dx
18034110c: 5a                          	popq	%rdx
18034110d: f6 3f                       	idivb	(%rdi)
18034110f: 97                          	xchgl	%edi, %eax
180341110: c3                          	retq
180341111: 4d af                       	scasq	%es:(%rdi), %rax
180341113: 4e 8a 1b                    	movb	(%rbx), %r11b
180341116: c6 a1 cf 3a 05 f7           	<unknown>
18034111c: 42 cf                       	iretl
18034111e: 4f f7 b2 b2 ae 83 c5        	divq	-0x3a7c514e(%r10)
180341125: b3 57                       	movb	$0x57, %bl
180341127: eb 6b                       	jmp	0x180341194 <.text+0x331194>
180341129: 50                          	pushq	%rax
18034112a: 80 9b 84 17 32 d7 0c        	sbbb	$0xc, -0x28cde87c(%rbx)
180341131: 0a 65 d9                    	orb	-0x27(%rbp), %ah
180341134: 0a fe                       	orb	%dh, %bh
180341136: 82                          	<unknown>
180341137: d5 3f 25 e5 e1 2c a1        	andq	$-0x5ed31e1b, %rax      # imm = 0xA12CE1E5
18034113e: e6 33                       	outb	%al, $0x33
180341140: fa                          	cli
180341141: 6f                          	outsl	(%rsi), %dx
180341142: 95                          	xchgl	%ebp, %eax
180341143: 3a 06                       	cmpb	(%rsi), %al
180341145: 77 ed                       	ja	0x180341134 <.text+0x331134>
180341147: 5a                          	popq	%rdx
180341148: c2 6e f7                    	retq	$-0x892                 # imm = 0xF76E
18034114b: f6 fe                       	idivb	%dh
18034114d: b9 cc 67 bf f0              	movl	$0xf0bf67cc, %ecx       # imm = 0xF0BF67CC
180341152: c3                          	retq
180341153: 0d 00 4f eb dc              	orl	$0xdceb4f00, %eax       # imm = 0xDCEB4F00
180341158: cd e0                       	int	$0xe0
18034115a: 75 d5                       	jne	0x180341131 <.text+0x331131>
18034115c: 2c d2                       	subb	$-0x2e, %al
18034115e: d8 65 15                    	fsubs	0x15(%rbp)
180341161: 03 39                       	addl	(%rcx), %edi
180341163: ce                          	<unknown>
180341164: ac                          	lodsb	(%rsi), %al
180341165: fb                          	sti
180341166: 2f                          	<unknown>
180341167: 2c 58                       	subb	$0x58, %al
180341169: 30 fe                       	xorb	%bh, %dh
18034116b: 1c c0                       	sbbb	$-0x40, %al
18034116d: 40 46 7d 82                 	jge	0x1803410f3 <.text+0x3310f3>
180341171: 31 98 31 fa 4d e0           	xorl	%ebx, -0x1fb205cf(%rax)
180341177: 56                          	pushq	%rsi
180341178: d2 b8 56 44 c1 45           	sarb	%cl, 0x45c14456(%rax)
18034117e: 24 e8                       	andb	$-0x18, %al
180341180: 05 c5 32 5e 0c              	addl	$0xc5e32c5, %eax        # imm = 0xC5E32C5
180341185: ab                          	stosl	%eax, %es:(%rdi)
180341186: e7 96                       	outl	%eax, $0x96
180341188: 24 52                       	andb	$0x52, %al
18034118a: f2 20 e7                    	repne		andb	%ah, %bh
18034118d: 46 01 b5 8b 77 a2 ca        	addl	%r14d, -0x355d8875(%rbp)
180341194: e7 04                       	outl	%eax, $0x4
180341196: 62 5c ac 5f c8 b8 d3 ce c7 7e       	<unknown>
1803411a0: aa                          	stosb	%al, %es:(%rdi)
1803411a1: 14 c4                       	adcb	$-0x3c, %al
1803411a3: bf ce f0 76 08              	movl	$0x876f0ce, %edi        # imm = 0x876F0CE
1803411a8: 09 13                       	orl	%edx, (%rbx)
1803411aa: 17                          	<unknown>
1803411ab: 88 b3 d7 0b 9f 4b           	movb	%dh, 0x4b9f0bd7(%rbx)
1803411b1: c0 9f 25 52 48 c8 ce        	rcrb	$0xce, -0x37b7addb(%rdi)
1803411b8: 7d 17                       	jge	0x1803411d1 <.text+0x3311d1>
1803411ba: e1 7e                       	loope	0x18034123a <.text+0x33123a>
1803411bc: a3 4b fb 50 28 61 bf 18 1d  	movabsl	%eax, 0x1d18bf612850fb4b
1803411c5: 3b 9a 89 b0 26 d7           	cmpl	-0x28d94f77(%rdx), %ebx
1803411cb: e4 ba                       	inb	$0xba, %al
1803411cd: e6 08                       	outb	%al, $0x8
1803411cf: 4b be 1a 86 9e e8 0e a6 77 ab       	movabsq	$-0x548859f1176179e6, %r14 # imm = 0xAB77A60EE89E861A
1803411d9: 71 14                       	jno	0x1803411ef <.text+0x3311ef>
1803411db: 88 78 61                    	movb	%bh, 0x61(%rax)
1803411de: 86 08                       	xchgb	%cl, (%rax)
1803411e0: 80 c7 07                    	addb	$0x7, %bh
1803411e3: ba 95 37 8a a4              	movl	$0xa48a3795, %edx       # imm = 0xA48A3795
1803411e8: ed                          	inl	%dx, %eax
1803411e9: dd 52 bd                    	fstl	-0x43(%rdx)
1803411ec: 75 9f                       	jne	0x18034118d <.text+0x33118d>
1803411ee: 4a 36 df 11                 	fists	%ss:(%rcx)
1803411f2: f9                          	stc
1803411f3: 76 65                       	jbe	0x18034125a <.text+0x33125a>
1803411f5: 5f                          	popq	%rdi
1803411f6: 47 86 10                    	xchgb	%r10b, (%r8)
1803411f9: 9b                          	wait
1803411fa: 3f                          	<unknown>
1803411fb: 18 24 40                    	sbbb	%ah, (%rax,%rax,2)
1803411fe: 2a d9                       	subb	%cl, %bl
180341200: 03 4c b2 11                 	addl	0x11(%rdx,%rsi,4), %ecx
180341204: 81 51 32 72 e1 64 25        	adcl	$0x2564e172, 0x32(%rcx) # imm = 0x2564E172
18034120b: 44 2d a1 d4 c8 7d           	subl	$0x7dc8d4a1, %eax       # imm = 0x7DC8D4A1
180341211: 4f 18 ea                    	sbbb	%r13b, %r10b
180341214: 49 f4                       	hlt
180341216: 01 f1                       	addl	%esi, %ecx
180341218: d4                          	<unknown>
180341219: cd 7f                       	int	$0x7f
18034121b: ba e7 cb 32 1d              	movl	$0x1d32cbe7, %edx       # imm = 0x1D32CBE7
180341220: c9                          	leave
180341221: c9                          	leave
180341222: 72 fb                       	jb	0x18034121f <.text+0x33121f>
180341224: d2 87 93 51 d5 99           	rolb	%cl, -0x662aae6d(%rdi)
18034122a: eb a9                       	jmp	0x1803411d5 <.text+0x3311d5>
18034122c: cb                          	lretl
18034122d: d0 98 04 76 8f 06           	rcrb	0x68f7604(%rax)
180341233: 2a 63 84                    	subb	-0x7c(%rbx), %ah
180341236: b0 ce                       	movb	$-0x32, %al
180341238: 7d 8c                       	jge	0x1803411c6 <.text+0x3311c6>
18034123a: ef                          	outl	%eax, %dx
18034123b: ac                          	lodsb	(%rsi), %al
18034123c: a5                          	movsl	(%rsi), %es:(%rdi)
18034123d: 70 81                       	jo	0x1803411c0 <.text+0x3311c0>
18034123f: 48 0f 56 07                 	orps	(%rdi), %xmm0
180341243: e4 93                       	inb	$0x93, %al
180341245: ce                          	<unknown>
180341246: 99                          	cltd
180341247: 79 d8                       	jns	0x180341221 <.text+0x331221>
180341249: e4 64                       	inb	$0x64, %al
18034124b: 5e                          	popq	%rsi
18034124c: 5f                          	popq	%rdi
18034124d: 30 ec                       	xorb	%ch, %ah
18034124f: 33 9f bd d6 65 6e           	xorl	0x6e65d6bd(%rdi), %ebx
180341255: 87 c6                       	xchgl	%esi, %eax
180341257: 13 fd                       	adcl	%ebp, %edi
180341259: 25 6c 35 19 4a              	andl	$0x4a19356c, %eax       # imm = 0x4A19356C
18034125e: d8 d6                       	fcom	%st(6)
180341260: 9e                          	sahf
180341261: ad                          	lodsl	(%rsi), %eax
180341262: 91                          	xchgl	%ecx, %eax
180341263: c3                          	retq
180341264: e4 a9                       	inb	$0xa9, %al
180341266: 8b ce                       	movl	%esi, %ecx
180341268: 6c                          	insb	%dx, %es:(%rdi)
180341269: 35 ad 08 7b 3a              	xorl	$0x3a7b08ad, %eax       # imm = 0x3A7B08AD
18034126e: b9 f4 99 5b 7c              	movl	$0x7c5b99f4, %ecx       # imm = 0x7C5B99F4
180341273: 4e 01 77 dd                 	addq	%r14, -0x23(%rdi)
180341277: 99                          	cltd
180341278: 4a 5d                       	popq	%rbp
18034127a: 53                          	pushq	%rbx
18034127b: 9e                          	sahf
18034127c: 18 dc                       	sbbb	%bl, %ah
18034127e: db d8                       	fcmovnu	%st(0), %st
180341280: 53                          	pushq	%rbx
180341281: f0                          	lock
180341282: 63 18                       	movslq	(%rax), %ebx
180341284: 00 5d 21                    	addb	%bl, 0x21(%rbp)
180341287: 23 0d 40 61 cf 01           	andl	0x1cf6140(%rip), %ecx   # 0x1820373cd
18034128d: a1 cb 95 b7 8a 58 b7 69 5c  	movabsl	0x5c69b7588ab795cb, %eax
180341296: 48 87 4a d4                 	xchgq	%rcx, -0x2c(%rdx)
18034129a: 14 be                       	adcb	$-0x42, %al
18034129c: d8 e9                       	fsubr	%st(1), %st
18034129e: 09 08                       	orl	%ecx, (%rax)
1803412a0: 29 01                       	subl	%eax, (%rcx)
1803412a2: 85 3d eb 33 06 d9           	testl	%edi, -0x26f9cc15(%rip) # 0x1593a4693
1803412a8: 52                          	pushq	%rdx
1803412a9: 4c 47 88 82 fc ce 61 69     	movb	%r8b, 0x6961cefc(%r10)
1803412b1: 3c 12                       	cmpb	$0x12, %al
1803412b3: c9                          	leave
1803412b4: 0b 3d ef 59 e9 b7           	orl	-0x4816a611(%rip), %edi # 0x1381d6ca9
1803412ba: 47 0a 01                    	orb	(%r9), %r8b
1803412bd: 83 12 48                    	adcl	$0x48, (%rdx)
1803412c0: 15 3f cd 95 40              	adcl	$0x4095cd3f, %eax       # imm = 0x4095CD3F
1803412c5: da 59 56                    	ficompl	0x56(%rcx)
1803412c8: 45 62 40 3c 15              	<unknown>
1803412cd: 3f                          	<unknown>
1803412ce: 5c                          	popq	%rsp
1803412cf: d1 a4 3f 17 2c d7 20        	shll	0x20d72c17(%rdi,%rdi)
1803412d6: ba 21 2c e3 e1              	movl	$0xe1e32c21, %edx       # imm = 0xE1E32C21
1803412db: b2 d4                       	movb	$-0x2c, %dl
1803412dd: 0f c4 f0 41                 	pinsrw	$0x41, %eax, %mm6
1803412e1: 92                          	xchgl	%edx, %eax
1803412e2: 8d 3e                       	leal	(%rsi), %edi
1803412e4: d4                          	<unknown>
1803412e5: 32 50 3a                    	xorb	0x3a(%rax), %dl
1803412e8: ce                          	<unknown>
1803412e9: e9 30 80 66 3f              	jmp	0x1bf9a931e
1803412ee: 43 35 3a 46 d1 84           	xorl	$0x84d1463a, %eax       # imm = 0x84D1463A
1803412f4: 72 28                       	jb	0x18034131e <.text+0x33131e>
1803412f6: b0 92                       	movb	$-0x6e, %al
1803412f8: 75 1b                       	jne	0x180341315 <.text+0x331315>
1803412fa: fe 76 34                    	<unknown>
1803412fd: 5e                          	popq	%rsi
1803412fe: d2 60 ea                    	shlb	%cl, -0x16(%rax)
180341301: 30 26                       	xorb	%ah, (%rsi)
180341303: 93                          	xchgl	%ebx, %eax
180341304: fe 50 17                    	<unknown>
180341307: 46 03 05 c6 ce 44 61        	addl	0x6144cec6(%rip), %r8d  # 0x1e178e1d4
18034130e: 8b e8                       	movl	%eax, %ebp
180341310: b2 9c                       	movb	$-0x64, %dl
180341312: b7 a1                       	movb	$-0x5f, %bh
180341314: 92                          	xchgl	%edx, %eax
180341315: f0                          	lock
180341316: 17                          	<unknown>
180341317: 20 e9                       	andb	%ch, %cl
180341319: cb                          	lretl
18034131a: 89 db                       	movl	%ebx, %ebx
18034131c: 9c                          	pushfq
18034131d: b8 04 f9 b7 5a              	movl	$0x5ab7f904, %eax       # imm = 0x5AB7F904
180341322: 66 f1                       	<unknown>
180341324: 38 45 ac                    	cmpb	%al, -0x54(%rbp)
180341327: 59                          	popq	%rcx
180341328: c0 2f 96                    	shrb	$0x96, (%rdi)
18034132b: 27                          	<unknown>
18034132c: ab                          	stosl	%eax, %es:(%rdi)
18034132d: b1 ea                       	movb	$-0x16, %cl
18034132f: 93                          	xchgl	%ebx, %eax
180341330: f8                          	clc
180341331: e2 a3                       	loop	0x1803412d6 <.text+0x3312d6>
180341333: b6 38                       	movb	$0x38, %dh
180341335: 4f 7b 7b                    	jnp	0x1803413b3 <.text+0x3313b3>
180341338: 19 d5                       	sbbl	%edx, %ebp
18034133a: dc 2a                       	fsubrl	(%rdx)
18034133c: 84 74 13 37                 	testb	%dh, 0x37(%rbx,%rdx)
180341340: a1 dd 89 23 55 47 62 c7 73  	movabsl	0x73c76247552389dd, %eax
180341349: 37                          	<unknown>
18034134a: 02 e5                       	addb	%ch, %ah
18034134c: 9d                          	popfq
18034134d: c6 2c e9                    	<unknown>
180341350: 26 56                       	pushq	%rsi
180341352: bb 7b e3 58 ec              	movl	$0xec58e37b, %ebx       # imm = 0xEC58E37B
180341357: 74 67                       	je	0x1803413c0 <.text+0x3313c0>
180341359: c2 1e 2c                    	retq	$0x2c1e                 # imm = 0x2C1E
18034135c: d0 63 a4                    	shlb	-0x5c(%rbx)
18034135f: 6b 0d ae 44 a7 34 89        	imull	$-0x77, 0x34a744ae(%rip), %ecx # 0x1b4db5814
180341366: 74 cc                       	je	0x180341334 <.text+0x331334>
180341368: 2a 28                       	subb	(%rax), %ch
18034136a: 45 65 3f                    	<unknown>
18034136d: 0d 72 2a 05 81              	orl	$0x81052a72, %eax       # imm = 0x81052A72
180341372: 5e                          	popq	%rsi
180341373: 40 49 e7 90                 	outl	%eax, $0x90
180341377: d3 a2 b4 a9 b3 44           	shll	%cl, 0x44b3a9b4(%rdx)
18034137d: c8 74 53 9c                 	enter	$0x5374, $-0x64         # imm = 0x5374
180341381: 39 41 93                    	cmpl	%eax, -0x6d(%rcx)
180341384: a3 d1 38 c6 79 34 da a2 46  	movabsl	%eax, 0x46a2da3479c638d1
18034138d: 69 4e 42 76 f3 55 6e        	imull	$0x6e55f376, 0x42(%rsi), %ecx # imm = 0x6E55F376
180341394: e1 56                       	loope	0x1803413ec <.text+0x3313ec>
180341396: dc 61 68                    	fsubl	0x68(%rcx)
180341399: c6 d1                       	<unknown>
18034139b: 40 33 2f                    	xorl	(%rdi), %ebp
18034139e: 72 58                       	jb	0x1803413f8 <.text+0x3313f8>
1803413a0: e8 1e 5b 28 b9              	callq	0x1395c6ec3
1803413a5: 9e                          	sahf
1803413a6: a8 32                       	testb	$0x32, %al
1803413a8: ef                          	outl	%eax, %dx
1803413a9: 2a 4e 43                    	subb	0x43(%rsi), %cl
1803413ac: 81 03 f9 0f 57 85           	addl	$0x85570ff9, (%rbx)     # imm = 0x85570FF9
1803413b2: 16                          	<unknown>
1803413b3: ca 25 29                    	lretl	$0x2925                 # imm = 0x2925
1803413b6: 1c 89                       	sbbb	$-0x77, %al
1803413b8: d7                          	xlatb
1803413b9: f1                          	<unknown>
1803413ba: 91                          	xchgl	%ecx, %eax
1803413bb: 16                          	<unknown>
1803413bc: 79 f9                       	jns	0x1803413b7 <.text+0x3313b7>
1803413be: a1 88 61 2e b4 94 d9 43 2a  	movabsl	0x2a43d994b42e6188, %eax
1803413c7: a3 a0 b9 10 b8 0c b9 82 be  	movabsl	%eax, -0x417d46f347ef4660
1803413d0: da ed                       	<unknown>
1803413d2: 13 67 de                    	adcl	-0x22(%rdi), %esp
1803413d5: 61                          	<unknown>
1803413d6: d5 8d bd f6                 	bsrq	%r14, %r14
1803413da: d0 32                       	<unknown>
1803413dc: 97                          	xchgl	%edi, %eax
1803413dd: 61                          	<unknown>
1803413de: 95                          	xchgl	%ebp, %eax
1803413df: eb 48                       	jmp	0x180341429 <.text+0x331429>
1803413e1: 4f 58                       	popq	%r8
1803413e3: 71 0c                       	jno	0x1803413f1 <.text+0x3313f1>
1803413e5: 4b 8b 3e                    	movq	(%r14), %rdi
1803413e8: 37                          	<unknown>
1803413e9: a4                          	movsb	(%rsi), %es:(%rdi)
1803413ea: 94                          	xchgl	%esp, %eax
1803413eb: 27                          	<unknown>
1803413ec: 63 f8                       	movslq	%eax, %edi
1803413ee: 23 20                       	andl	(%rax), %esp
1803413f0: aa                          	stosb	%al, %es:(%rdi)
1803413f1: 7a 7d                       	jp	0x180341470 <.text+0x331470>
1803413f3: 9a                          	<unknown>
1803413f4: 88 2a                       	movb	%ch, (%rdx)
1803413f6: 7f ca                       	jg	0x1803413c2 <.text+0x3313c2>
1803413f8: 2a 48 a4                    	subb	-0x5c(%rax), %cl
1803413fb: 0d 3b b3 ee 4c              	orl	$0x4ceeb33b, %eax       # imm = 0x4CEEB33B
180341400: a8 b2                       	testb	$-0x4e, %al
180341402: e8 c2 24 8b 2e              	callq	0x1aebf38c9
180341407: 5d                          	popq	%rbp
180341408: a5                          	movsl	(%rsi), %es:(%rdi)
180341409: f1                          	<unknown>
18034140a: 57                          	pushq	%rdi
18034140b: 8d 90 aa b9 1e 46           	leal	0x461eb9aa(%rax), %edx
180341411: 55                          	pushq	%rbp
180341412: ea                          	<unknown>
180341413: 60                          	<unknown>
180341414: 6e                          	outsb	(%rsi), %dx
180341415: 01 38                       	addl	%edi, (%rax)
180341417: 44 4b 52                    	pushq	%r10
18034141a: 05 ae 7c e2 e7              	addl	$0xe7e27cae, %eax       # imm = 0xE7E27CAE
18034141f: d5 6d c1 cc 73              	rorq	$0x73, %r12
180341424: 4c 9a                       	<unknown>
180341426: 08 d6                       	orb	%dl, %dh
180341428: 32 d1                       	xorb	%cl, %dl
18034142a: c7 92 2c c5 65 16           	<unknown>
180341430: aa                          	stosb	%al, %es:(%rdi)
180341431: d0 47 f4                    	rolb	-0xc(%rdi)
180341434: d3 b3 6a a6 d6 a1           	<unknown>
18034143a: 16                          	<unknown>
18034143b: 8e 27                       	movw	(%rdi), %fs
18034143d: 34 f8                       	xorb	$-0x8, %al
18034143f: fe bd 70 4f 44 f2           	<unknown>
180341445: 9e                          	sahf
180341446: f6 49 9d                    	<unknown>
180341449: 38 14 4c                    	cmpb	%dl, (%rsp,%rcx,2)
18034144c: 00 89 74 22 40 84           	addb	%cl, -0x7bbfdd8c(%rcx)
180341452: df 0a                       	fisttps	(%rdx)
180341454: 99                          	cltd
180341455: 3a 9b fc 62 9e 15           	cmpb	0x159e62fc(%rbx), %bl
18034145b: 3a 28                       	cmpb	(%rax), %ch
18034145d: f4                          	hlt
18034145e: 1d 00 c3 90 55              	sbbl	$0x5590c300, %eax       # imm = 0x5590C300
180341463: a1 74 d9 53 2e d3 f3 ab ed  	movabsl	-0x12540c2cd1ac268c, %eax
18034146c: 9c                          	pushfq
18034146d: b6 41                       	movb	$0x41, %dh
18034146f: 83 6d bd f6                 	subl	$-0xa, -0x43(%rbp)
180341473: 3f                          	<unknown>
180341474: 31 3a                       	xorl	%edi, (%rdx)
180341476: 00 b9 51 a7 4a b2           	addb	%bh, -0x4db558af(%rcx)
18034147c: 53                          	pushq	%rbx
18034147d: e3 ca                       	jrcxz	0x180341449 <.text+0x331449>
18034147f: 0d 55 11 8e cb              	orl	$0xcb8e1155, %eax       # imm = 0xCB8E1155
180341484: 73 dd                       	jae	0x180341463 <.text+0x331463>
180341486: f1                          	<unknown>
180341487: 78 9f                       	js	0x180341428 <.text+0x331428>
180341489: 26 1b 6e 6c                 	sbbl	%es:0x6c(%rsi), %ebp
18034148d: c5 c1 dc a4 1b ac ea 97 44  	vpaddusb	0x4497eaac(%rbx,%rbx), %xmm7, %xmm4
180341496: 8f f0 ea                    	<unknown>
180341499: 8c 7d 31                    	<unknown>
18034149c: d2 99 f3 ba 02 00           	rcrb	%cl, 0x2baf3(%rcx)
1803414a2: 42 59                       	popq	%rcx
1803414a4: 83 41 3a a9                 	addl	$-0x57, 0x3a(%rcx)
1803414a8: e7 4d                       	outl	%eax, $0x4d
1803414aa: 57                          	pushq	%rdi
1803414ab: 89 53 1e                    	movl	%edx, 0x1e(%rbx)
1803414ae: 99                          	cltd
1803414af: 76 b2                       	jbe	0x180341463 <.text+0x331463>
1803414b1: f7 55 04                    	notl	0x4(%rbp)
1803414b4: 2e 07                       	<unknown>
1803414b6: 94                          	xchgl	%esp, %eax
1803414b7: d3 ed                       	shrl	%cl, %ebp
1803414b9: ba 9b 65 dc 1e              	movl	$0x1edc659b, %edx       # imm = 0x1EDC659B
1803414be: e0 32                       	loopne	0x1803414f2 <.text+0x3314f2>
1803414c0: 17                          	<unknown>
1803414c1: c6 26                       	<unknown>
1803414c3: 1b cf                       	sbbl	%edi, %ecx
1803414c5: 7f 51                       	jg	0x180341518 <.text+0x331518>
1803414c7: 88 4f 4d                    	movb	%cl, 0x4d(%rdi)
1803414ca: 1f                          	<unknown>
1803414cb: c0 aa 2f 53 5f af 14        	shrb	$0x14, -0x50a0acd1(%rdx)
1803414d2: e8 5a 86 81 e9              	callq	0x169b59b31
1803414d7: 71 07                       	jno	0x1803414e0 <.text+0x3314e0>
1803414d9: 2a 2c 44                    	subb	(%rsp,%rax,2), %ch
1803414dc: 96                          	xchgl	%esi, %eax
1803414dd: 36 72 e3                    	jb	0x1803414c3 <.text+0x3314c3>
1803414e0: ad                          	lodsl	(%rsi), %eax
1803414e1: 79 2f                       	jns	0x180341512 <.text+0x331512>
1803414e3: 35 00 6e 7d 12              	xorl	$0x127d6e00, %eax       # imm = 0x127D6E00
1803414e8: 04 a0                       	addb	$-0x60, %al
1803414ea: f1                          	<unknown>
1803414eb: 79 01                       	jns	0x1803414ee <.text+0x3314ee>
1803414ed: ef                          	outl	%eax, %dx
1803414ee: c9                          	leave
1803414ef: 4a 25 8e 97 6b 72           	andq	$0x726b978e, %rax       # imm = 0x726B978E
1803414f5: 08 99 94 98 10 6b           	orb	%bl, 0x6b109894(%rcx)
1803414fb: fd                          	std
1803414fc: 7a c2                       	jp	0x1803414c0 <.text+0x3314c0>
1803414fe: 2f                          	<unknown>
1803414ff: fe 1b                       	<unknown>
180341501: 0e                          	<unknown>
180341502: c6 42 36 ed                 	movb	$-0x13, 0x36(%rdx)
180341506: ba 28 ca 92 d4              	movl	$0xd492ca28, %edx       # imm = 0xD492CA28
18034150b: 36 d7                       	xlatb
18034150d: 96                          	xchgl	%esi, %eax
18034150e: eb e2                       	jmp	0x1803414f2 <.text+0x3314f2>
180341510: bf 26 00 35 3d              	movl	$0x3d350026, %edi       # imm = 0x3D350026
180341515: 35 34 19 69 9c              	xorl	$0x9c691934, %eax       # imm = 0x9C691934
18034151a: 72 e3                       	jb	0x1803414ff <.text+0x3314ff>
18034151c: 8b f3                       	movl	%ebx, %esi
18034151e: 23 6f cd                    	andl	-0x33(%rdi), %ebp
180341521: 5f                          	popq	%rdi
180341522: a2 1e 9e 4e 91 c7 5c 32 89  	movabsb	%al, -0x76cda3386eb161e2
18034152b: 4b 50                       	pushq	%r8
18034152d: d3 3d 5e 14 a1 69           	sarl	%cl, 0x69a1145e(%rip)   # 0x1e9d52991
180341533: 01 76 86                    	addl	%esi, -0x7a(%rsi)
180341536: 77 21                       	ja	0x180341559 <.text+0x331559>
180341538: fd                          	std
180341539: 95                          	xchgl	%ebp, %eax
18034153a: 45 2f                       	<unknown>
18034153c: db 35 0d 9a 56 e6           	<unknown>
180341542: 64 2c 6b                    	subb	$0x6b, %al
180341545: 0d c2 b4 77 2e              	orl	$0x2e77b4c2, %eax       # imm = 0x2E77B4C2
18034154a: d3 36                       	<unknown>
18034154c: cd e2                       	int	$0xe2
18034154e: e7 d0                       	outl	%eax, $0xd0
180341550: 12 aa 47 c6 20 7c           	adcb	0x7c20c647(%rdx), %ch
180341556: 58                          	popq	%rax
180341557: b2 ea                       	movb	$-0x16, %dl
180341559: a6                          	cmpsb	%es:(%rdi), (%rsi)
18034155a: 18 33                       	sbbb	%dh, (%rbx)
18034155c: 73 8d                       	jae	0x1803414eb <.text+0x3314eb>
18034155e: a3 dd 00 bb aa 2b ca 3e ef  	movabsl	%eax, -0x10c135d45544ff23
180341567: c6 35 20 6c 51 b5           	<unknown>
18034156d: 10 fc                       	adcb	%bh, %ah
18034156f: 73 5e                       	jae	0x1803415cf <.text+0x3315cf>
180341571: a3 7a f7 d7 df 97 d8 9f 65  	movabsl	%eax, 0x659fd897dfd7f77a
18034157a: 06                          	<unknown>
18034157b: d1 0f                       	rorl	(%rdi)
18034157d: 21 88 7f 34 41 ae           	andl	%ecx, -0x51becb81(%rax)
180341583: 19 96 a3 79 4c b9           	sbbl	%edx, -0x46b3865d(%rsi)
180341589: ba 6e be 49 4d              	movl	$0x4d49be6e, %edx       # imm = 0x4D49BE6E
18034158e: 35 ba b0 a4 65              	xorl	$0x65a4b0ba, %eax       # imm = 0x65A4B0BA
180341593: 1c 59                       	sbbb	$0x59, %al
180341595: 62 a7 af ad e4              	<unknown>
18034159a: 62 a2 fb 51 27 7e 39        	<unknown>
1803415a1: cd 2b                       	int	$0x2b
1803415a3: 8d f4                       	<unknown>
1803415a5: 21 e1                       	andl	%esp, %ecx
1803415a7: 35 66 55 51 42              	xorl	$0x42515566, %eax       # imm = 0x42515566
1803415ac: d2 7f 96                    	sarb	%cl, -0x6a(%rdi)
1803415af: fb                          	sti
1803415b0: 55                          	pushq	%rbp
1803415b1: ad                          	lodsl	(%rsi), %eax
1803415b2: 2d 73 e4 d3 8f              	subl	$0x8fd3e473, %eax       # imm = 0x8FD3E473
1803415b7: c3                          	retq
1803415b8: b2 c0                       	movb	$-0x40, %dl
1803415ba: 74 14                       	je	0x1803415d0 <.text+0x3315d0>
1803415bc: 13 fe                       	adcl	%esi, %edi
1803415be: 66 14 05                    	adcb	$0x5, %al
1803415c1: 45 11 a2 80 a4 22 eb        	adcl	%r12d, -0x14dd5b80(%r10)
1803415c8: 29 ba 14 42 f8 f3           	subl	%edi, -0xc07bdec(%rdx)
1803415ce: 0d c2 41 d7 6c              	orl	$0x6cd741c2, %eax       # imm = 0x6CD741C2
1803415d3: e6 d3                       	outb	%al, $0xd3
1803415d5: 22 53 a8                    	andb	-0x58(%rbx), %dl
1803415d8: d9 7d 0f                    	fnstcw	0xf(%rbp)
1803415db: 03 de                       	addl	%esi, %ebx
1803415dd: 1b 16                       	sbbl	(%rsi), %edx
1803415df: 57                          	pushq	%rdi
1803415e0: 60                          	<unknown>
1803415e1: 46 4d e9 cd 71 e9 60        	jmp	0x1e11d87b5
1803415e8: 54                          	pushq	%rsp
1803415e9: 54                          	pushq	%rsp
1803415ea: 4a 37                       	<unknown>
1803415ec: 73 fe                       	jae	0x1803415ec <.text+0x3315ec>
1803415ee: 02 fa                       	addb	%dl, %bh
1803415f0: 09 b8 5c 3c d9 7c           	orl	%edi, 0x7cd93c5c(%rax)
1803415f6: 4b fd                       	std
1803415f8: 74 a9                       	je	0x1803415a3 <.text+0x3315a3>
1803415fa: 98                          	cwtl
1803415fb: ec                          	inb	%dx, %al
1803415fc: 34 41                       	xorb	$0x41, %al
1803415fe: ee                          	outb	%al, %dx
1803415ff: b2 5c                       	movb	$0x5c, %dl
180341601: 1b eb                       	sbbl	%ebx, %ebp
180341603: 9d                          	popfq
180341604: 9a                          	<unknown>
180341605: d9 5a f1                    	fstps	-0xf(%rdx)
180341608: d0 88 11 85 23 6f           	rorb	0x6f238511(%rax)
18034160e: db cc                       	fcmovne	%st(4), %st
180341610: ea                          	<unknown>
180341611: ad                          	lodsl	(%rsi), %eax
180341612: 31 45 b2                    	xorl	%eax, -0x4e(%rbp)
180341615: 69 24 9f 38 a3 38 b7        	imull	$0xb738a338, (%rdi,%rbx,4), %esp # imm = 0xB738A338
18034161c: 6d                          	insl	%dx, %es:(%rdi)
18034161d: 6e                          	outsb	(%rsi), %dx
18034161e: 06                          	<unknown>
18034161f: c9                          	leave
180341620: f6 c8                       	<unknown>
180341622: f7 db                       	negl	%ebx
180341624: 3e a8 d3                    	testb	$-0x2d, %al
180341627: 7d 24                       	jge	0x18034164d <.text+0x33164d>
180341629: 82                          	<unknown>
18034162a: ef                          	outl	%eax, %dx
18034162b: 94                          	xchgl	%esp, %eax
18034162c: 83 7a 11 7b                 	cmpl	$0x7b, 0x11(%rdx)
180341630: 8a 7b 35                    	movb	0x35(%rbx), %bh
180341633: 55                          	pushq	%rbp
180341634: 4b aa                       	stosb	%al, %es:(%rdi)
180341636: a5                          	movsl	(%rsi), %es:(%rdi)
180341637: 47 04 8c                    	addb	$-0x74, %al
18034163a: e6 4a                       	outb	%al, $0x4a
18034163c: a7                          	cmpsl	%es:(%rdi), (%rsi)
18034163d: 0f 1d                       	<unknown>
18034163f: fa                          	cli
180341640: 00 29                       	addb	%ch, (%rcx)
180341642: 05 cf 9f 96 c8              	addl	$0xc8969fcf, %eax       # imm = 0xC8969FCF
180341647: e7 26                       	outl	%eax, $0x26
180341649: c2 7c cd                    	retq	$-0x3284                # imm = 0xCD7C
18034164c: 89 93 53 33 98 a9           	movl	%edx, -0x5667ccad(%rbx)
180341652: 43 03 7a da                 	addl	-0x26(%r10), %edi
180341656: cf                          	iretl
180341657: 07                          	<unknown>
180341658: ed                          	inl	%dx, %eax
180341659: ee                          	outb	%al, %dx
18034165a: 70 0c                       	jo	0x180341668 <.text+0x331668>
18034165c: cf                          	iretl
18034165d: 04 77                       	addb	$0x77, %al
18034165f: 1b bf 2b e2 35 ce           	sbbl	-0x31ca1dd5(%rdi), %edi
180341665: 0c c0                       	orb	$-0x40, %al
180341667: c1 3e 2e                    	sarl	$0x2e, (%rsi)
18034166a: e9 60 33 77 18              	jmp	0x198ab49cf
18034166f: b1 3e                       	movb	$0x3e, %cl
180341671: b5 fc                       	movb	$-0x4, %ch
180341673: bd da 77 74 58              	movl	$0x587477da, %ebp       # imm = 0x587477DA
180341678: e1 a4                       	loope	0x18034161e <.text+0x33161e>
18034167a: 7c d3                       	jl	0x18034164f <.text+0x33164f>
18034167c: 1f                          	<unknown>
18034167d: 0d eb 39 d9 97              	orl	$0x97d939eb, %eax       # imm = 0x97D939EB
180341682: d4                          	<unknown>
180341683: e7 63                       	outl	%eax, $0x63
180341685: 15 17 62 a9 1c              	adcl	$0x1ca96217, %eax       # imm = 0x1CA96217
18034168a: 40 76 f1                    	jbe	0x18034167e <.text+0x33167e>
18034168d: f5                          	cmc
18034168e: f5                          	cmc
18034168f: 13 0a                       	adcl	(%rdx), %ecx
180341691: e7 27                       	outl	%eax, $0x27
180341693: 57                          	pushq	%rdi
180341694: dc 08                       	fmull	(%rax)
180341696: 5e                          	popq	%rsi
180341697: df ac fd 9e 72 bb 38        	fildll	0x38bb729e(%rbp,%rdi,8)
18034169e: 99                          	cltd
18034169f: 9e                          	sahf
1803416a0: 97                          	xchgl	%edi, %eax
1803416a1: 06                          	<unknown>
1803416a2: e9 1d 41 41 d9              	jmp	0x1597557c4
1803416a7: b9 e6 d4 d1 1d              	movl	$0x1dd1d4e6, %ecx       # imm = 0x1DD1D4E6
1803416ac: 21 ef                       	andl	%ebp, %edi
1803416ae: 58                          	popq	%rax
1803416af: cc                          	int3
1803416b0: 08 74 10 38                 	orb	%dh, 0x38(%rax,%rdx)
1803416b4: e8 4a 6a 87 84              	callq	0x104bb8103
1803416b9: 0d 18 a9 b0 33              	orl	$0x33b0a918, %eax       # imm = 0x33B0A918
1803416be: 7b f7                       	jnp	0x1803416b7 <.text+0x3316b7>
1803416c0: 27                          	<unknown>
1803416c1: 81 1c 68 54 45 98 dc        	sbbl	$0xdc984554, (%rax,%rbp,2) # imm = 0xDC984554
1803416c8: 9f                          	lahf
1803416c9: 3f                          	<unknown>
1803416ca: 24 2c                       	andb	$0x2c, %al
1803416cc: 72 29                       	jb	0x1803416f7 <.text+0x3316f7>
1803416ce: 29 31                       	subl	%esi, (%rcx)
1803416d0: 09 fc                       	orl	%edi, %esp
1803416d2: cf                          	iretl
1803416d3: 9f                          	lahf
1803416d4: 0b d9                       	orl	%ecx, %ebx
1803416d6: ec                          	inb	%dx, %al
1803416d7: c1 9d 4d 09 b5 2a 89        	rcrl	$0x89, 0x2ab5094d(%rbp)
1803416de: d7                          	xlatb
1803416df: 7e c2                       	jle	0x1803416a3 <.text+0x3316a3>
1803416e1: 6f                          	outsl	(%rsi), %dx
1803416e2: a2 f9 15 24 e3 5a c4 c0 58  	movabsb	%al, 0x58c0c45ae32415f9
1803416eb: 53                          	pushq	%rbx
1803416ec: 4b 14 6a                    	adcb	$0x6a, %al
1803416ef: 89 cd                       	movl	%ecx, %ebp
1803416f1: f3 5e                       	rep		popq	%rsi
1803416f3: 06                          	<unknown>
1803416f4: cc                          	int3
1803416f5: 92                          	xchgl	%edx, %eax
1803416f6: 59                          	popq	%rcx
1803416f7: fc                          	cld
1803416f8: 0a 21                       	orb	(%rcx), %ah
1803416fa: 44 bf e5 a4 c7 f3           	movl	$0xf3c7a4e5, %edi       # imm = 0xF3C7A4E5
180341700: 62 06 fd 01 26              	<unknown>
180341705: 6b 4c 26 7b cf              	imull	$-0x31, 0x7b(%rsi,%riz), %ecx
18034170a: eb a4                       	jmp	0x1803416b0 <.text+0x3316b0>
18034170c: cb                          	lretl
18034170d: 7a bd                       	jp	0x1803416cc <.text+0x3316cc>
18034170f: 66 0f aa                    	rsm
180341712: 08 99 03 96 da 15           	orb	%bl, 0x15da9603(%rcx)
180341718: 4c be 63 4a cc d9 44 ab da 01       	movabsq	$0x1daab44d9cc4a63, %rsi # imm = 0x1DAAB44D9CC4A63
180341722: 1c 2c                       	sbbb	$0x2c, %al
180341724: 43 52                       	pushq	%r10
180341726: 9b                          	wait
180341727: a0 d0 ec e6 1a c9 fc 90 40  	movabsb	0x4090fcc91ae6ecd0, %al
180341730: 9c                          	pushfq
180341731: 03 5e f1                    	addl	-0xf(%rsi), %ebx
180341734: 33 35 24 b8 7f c6           	xorl	-0x398047dc(%rip), %esi # 0x146b3cf5e
18034173a: c4 47 56 54                 	<unknown>
18034173e: 13 13                       	adcl	(%rbx), %edx
180341740: b8 4a 51 53 84              	movl	$0x8453514a, %eax       # imm = 0x8453514A
180341745: 25 c9 94 e8 d4              	andl	$0xd4e894c9, %eax       # imm = 0xD4E894C9
18034174a: 91                          	xchgl	%ecx, %eax
18034174b: 42 d5 48 fe 33              	<unknown>
180341750: e9 b8 c3 84 7f              	jmp	0x1ffb8db0d
180341755: 09 fb                       	orl	%edi, %ebx
180341757: b3 6a                       	movb	$0x6a, %bl
180341759: 35 be a2 4a 4f              	xorl	$0x4f4aa2be, %eax       # imm = 0x4F4AA2BE
18034175e: c7 60 04                    	<unknown>
180341761: 5e                          	popq	%rsi
180341762: 00 7e d4                    	addb	%bh, -0x2c(%rsi)
180341765: eb 93                       	jmp	0x1803416fa <.text+0x3316fa>
180341767: 6f                          	outsl	(%rsi), %dx
180341768: 4a 39 0b                    	cmpq	%rcx, (%rbx)
18034176b: 39 e9                       	cmpl	%ebp, %ecx
18034176d: 2f                          	<unknown>
18034176e: f0                          	lock
18034176f: da 87 ae 34 ec 1b           	fiaddl	0x1bec34ae(%rdi)
180341775: f8                          	clc
180341776: 0b de                       	orl	%esi, %ebx
180341778: 44 e1 8d                    	loope	0x180341708 <.text+0x331708>
18034177b: a6                          	cmpsb	%es:(%rdi), (%rsi)
18034177c: 98                          	cwtl
18034177d: 04 95                       	addb	$-0x6b, %al
18034177f: 55                          	pushq	%rbp
180341780: ac                          	lodsb	(%rsi), %al
180341781: 7c 9e                       	jl	0x180341721 <.text+0x331721>
180341783: 5a                          	popq	%rdx
180341784: 6b c4 a8                    	imull	$-0x58, %esp, %eax
180341787: 30 ea                       	xorb	%ch, %dl
180341789: 95                          	xchgl	%ebp, %eax
18034178a: 6d                          	insl	%dx, %es:(%rdi)
18034178b: da a0 ee 83 a8 73           	fisubl	0x73a883ee(%rax)
180341791: 78 9b                       	js	0x18034172e <.text+0x33172e>
180341793: 11 ec                       	adcl	%ebp, %esp
180341795: 35 20 dd 87 d7              	xorl	$0xd787dd20, %eax       # imm = 0xD787DD20
18034179a: d1 95 7a 9f bb 38           	rcll	0x38bb9f7a(%rbp)
1803417a0: 68 44 25 b2 27              	pushq	$0x27b22544             # imm = 0x27B22544
1803417a5: 5d                          	popq	%rbp
1803417a6: dd 54 1e 37                 	fstl	0x37(%rsi,%rbx)
1803417aa: eb 2f                       	jmp	0x1803417db <.text+0x3317db>
1803417ac: 2c 5d                       	subb	$0x5d, %al
1803417ae: 45 8d 30                    	leal	(%r8), %r14d
1803417b1: 27                          	<unknown>
1803417b2: 43 7e 58                    	jle	0x18034180d <.text+0x33180d>
1803417b5: e9 28 ae 4c 7e              	jmp	0x1fe80c5e2
1803417ba: 8a 45 66                    	movb	0x66(%rbp), %al
1803417bd: 00 ed                       	addb	%ch, %ch
1803417bf: 5c                          	popq	%rsp
1803417c0: 86 7b f1                    	xchgb	%bh, -0xf(%rbx)
1803417c3: f0                          	lock
1803417c4: 3c 9e                       	cmpb	$-0x62, %al
1803417c6: 2f                          	<unknown>
1803417c7: e8 97 e4 d4 8e              	callq	0x10f08fc63
1803417cc: 2d 9b c6 45 d5              	subl	$0xd545c69b, %eax       # imm = 0xD545C69B
1803417d1: 15 c7 fd 5b 39              	adcl	$0x395bfdc7, %eax       # imm = 0x395BFDC7
1803417d6: bb c8 7a ba ce              	movl	$0xceba7ac8, %ebx       # imm = 0xCEBA7AC8
1803417db: 8e d8                       	movl	%eax, %ds
1803417dd: 11 60 1c                    	adcl	%esp, 0x1c(%rax)
1803417e0: aa                          	stosb	%al, %es:(%rdi)
1803417e1: a5                          	movsl	(%rsi), %es:(%rdi)
1803417e2: 94                          	xchgl	%esp, %eax
1803417e3: 39 55 7f                    	cmpl	%edx, 0x7f(%rbp)
1803417e6: 65 8d d9                    	<unknown>
1803417e9: 23 83 f2 68 a7 8f           	andl	-0x7058970e(%rbx), %eax
1803417ef: 60                          	<unknown>
1803417f0: 8e 4b 04                    	movw	0x4(%rbx), %cs
1803417f3: 31 a9 fa 0b 99 a7           	xorl	%ebp, -0x5866f406(%rcx)
1803417f9: 66 90                       	nop
1803417fb: 69 32 cc 6b 79 f1           	imull	$0xf1796bcc, (%rdx), %esi # imm = 0xF1796BCC
180341801: 51                          	pushq	%rcx
180341802: a6                          	cmpsb	%es:(%rdi), (%rsi)
180341803: e9 a3 36 7c 86              	jmp	0x106b04eab
180341808: 4f ec                       	inb	%dx, %al
18034180a: f6 e6                       	mulb	%dh
18034180c: 24 ea                       	andb	$-0x16, %al
18034180e: d1 56 6b                    	rcll	0x6b(%rsi)
180341811: de 4d d8                    	fimuls	-0x28(%rbp)
180341814: 79 3e                       	jns	0x180341854 <.text+0x331854>
180341816: b5 6d                       	movb	$0x6d, %ch
180341818: 7b 49                       	jnp	0x180341863 <.text+0x331863>
18034181a: 0b 13                       	orl	(%rbx), %edx
18034181c: ba 0e 9a 1f da              	movl	$0xda1f9a0e, %edx       # imm = 0xDA1F9A0E
180341821: 50                          	pushq	%rax
180341822: 9a                          	<unknown>
180341823: 5a                          	popq	%rdx
180341824: dc 32                       	fdivl	(%rdx)
180341826: 11 d6                       	adcl	%edx, %esi
180341828: 52                          	pushq	%rdx
180341829: 38 05 15 fa 7f 09           	cmpb	%al, 0x97ffa15(%rip)    # 0x189b41244
18034182f: 55                          	pushq	%rbp
180341830: 44 91                       	xchgl	%ecx, %eax
180341832: 3b 7d fd                    	cmpl	-0x3(%rbp), %edi
180341835: 17                          	<unknown>
180341836: 3b e1                       	cmpl	%ecx, %esp
180341838: 7c 5b                       	jl	0x180341895 <.text+0x331895>
18034183a: 6b 87 7d 17 0b 1b 72        	imull	$0x72, 0x1b0b177d(%rdi), %eax
180341841: 2d 97 42 d8 58              	subl	$0x58d84297, %eax       # imm = 0x58D84297
180341846: 7a 67                       	jp	0x1803418af <.text+0x3318af>
180341848: bf 50 4f 8d 7d              	movl	$0x7d8d4f50, %edi       # imm = 0x7D8D4F50
18034184d: a9 9a ba 70 65              	testl	$0x6570ba9a, %eax       # imm = 0x6570BA9A
180341852: f9                          	stc
180341853: a6                          	cmpsb	%es:(%rdi), (%rsi)
180341854: c9                          	leave
180341855: 86 e7                       	xchgb	%bh, %ah
180341857: 88 d2                       	movb	%dl, %dl
180341859: f9                          	stc
18034185a: 60                          	<unknown>
18034185b: 46 ba bd 88 1b 14           	movl	$0x141b88bd, %edx       # imm = 0x141B88BD
180341861: b4 d5                       	movb	$-0x2b, %ah
180341863: a8 a8                       	testb	$-0x58, %al
180341865: 3f                          	<unknown>
180341866: 3b b8 4b 2a 41 6e           	cmpl	0x6e412a4b(%rax), %edi
18034186c: 8a a5 2d 10 67 80           	movb	-0x7f98efd3(%rbp), %ah
180341872: 31 f2                       	xorl	%esi, %edx
180341874: 22 aa 49 74 94 90           	andb	-0x6f6b8bb7(%rdx), %ch
18034187a: 18 f4                       	sbbb	%dh, %ah
18034187c: ef                          	outl	%eax, %dx
18034187d: 49 12 af 3b 35 15 5e        	adcb	0x5e15353b(%r15), %bpl
180341884: 2c cc                       	subb	$-0x34, %al
180341886: 45 22 e4                    	andb	%r12b, %r12b
180341889: cd 84                       	int	$0x84
18034188b: 59                          	popq	%rcx
18034188c: 81 3e e4 6e b4 09           	cmpl	$0x9b46ee4, (%rsi)      # imm = 0x9B46EE4
180341892: 06                          	<unknown>
180341893: 95                          	xchgl	%ebp, %eax
180341894: 31 5f 4c                    	xorl	%ebx, 0x4c(%rdi)
180341897: fa                          	cli
180341898: c7 29                       	<unknown>
18034189a: a6                          	cmpsb	%es:(%rdi), (%rsi)
18034189b: b0 6f                       	movb	$0x6f, %al
18034189d: ea                          	<unknown>
18034189e: 5e                          	popq	%rsi
18034189f: ac                          	lodsb	(%rsi), %al
1803418a0: 93                          	xchgl	%ebx, %eax
1803418a1: b9 9d 50 5e a7              	movl	$0xa75e509d, %ecx       # imm = 0xA75E509D
1803418a6: 70 66                       	jo	0x18034190e <.text+0x33190e>
1803418a8: f1                          	<unknown>
1803418a9: 99                          	cltd
1803418aa: aa                          	stosb	%al, %es:(%rdi)
1803418ab: b9 bc a7 a1 99              	movl	$0x99a1a7bc, %ecx       # imm = 0x99A1A7BC
1803418b0: 6b c7 76                    	imull	$0x76, %edi, %eax
1803418b3: bb ab 7d bf f9              	movl	$0xf9bf7dab, %ebx       # imm = 0xF9BF7DAB
1803418b8: c1 56 6d a8                 	rcll	$0xa8, 0x6d(%rsi)
1803418bc: eb 71                       	jmp	0x18034192f <.text+0x33192f>
1803418be: 1e                          	<unknown>
1803418bf: 22 83 ec 72 4e 70           	andb	0x704e72ec(%rbx), %al
1803418c5: e2 01                       	loop	0x1803418c8 <.text+0x3318c8>
1803418c7: 0a b7 af ec 8a 1c           	orb	0x1c8aecaf(%rdi), %dh
1803418cd: d7                          	xlatb
1803418ce: 32 45 01                    	xorb	0x1(%rbp), %al
1803418d1: 8f 26 62                    	<unknown>
1803418d4: 6d                          	insl	%dx, %es:(%rdi)
1803418d5: 83 15 c5 63 7b b7 e4        	adcl	$-0x1c, -0x48849c3b(%rip) # 0x137af7ca1
1803418dc: c7 08                       	<unknown>
1803418de: 02 1e                       	addb	(%rsi), %bl
1803418e0: cc                          	int3
1803418e1: 53                          	pushq	%rbx
1803418e2: 5a                          	popq	%rdx
1803418e3: 2e 84 e8                    	testb	%ch, %al
1803418e6: eb 66                       	jmp	0x18034194e <.text+0x33194e>
1803418e8: 4d a3 52 74 e9 fe 2f 3b c4 c5       	movabsq	%rax, -0x3a3bc4d001168bae
1803418f2: 1b 26                       	sbbl	(%rsi), %esp
1803418f4: 9c                          	pushfq
1803418f5: 59                          	popq	%rcx
1803418f6: 68 e6 0f d5 eb              	pushq	$-0x142af01a            # imm = 0xEBD50FE6
1803418fb: c3                          	retq
1803418fc: 64 df 18                    	fistps	%fs:(%rax)
1803418ff: db a3 55 0b 52 d5           	<unknown>
180341905: 0a 0e                       	orb	(%rsi), %cl
180341907: 2d b2 1d 36 27              	subl	$0x27361db2, %eax       # imm = 0x27361DB2
18034190c: 4b 34 35                    	xorb	$0x35, %al
18034190f: 99                          	cltd
180341910: e9 cb 9f bc 31              	jmp	0x1b1f0b8e0
180341915: 0f ea 90 57 6f 6b 7e        	pminsw	0x7e6b6f57(%rax), %mm2
18034191c: 4d b4 8a                    	movb	$-0x76, %r12b
18034191f: e8 89 75 aa fd              	callq	0x17dde8ead
180341924: 29 08                       	subl	%ecx, (%rax)
180341926: 10 bb d0 d3 b8 a2           	adcb	%bh, -0x5d472c30(%rbx)
18034192c: 4b 6f                       	outsl	(%rsi), %dx
18034192e: 59                          	popq	%rcx
18034192f: d7                          	xlatb
180341930: 40 07                       	<unknown>
180341932: c4 42 de 78                 	<unknown>
180341936: 97                          	xchgl	%edi, %eax
180341937: c2 ee 74                    	retq	$0x74ee                 # imm = 0x74EE
18034193a: bf ab 24 c1 78              	movl	$0x78c124ab, %edi       # imm = 0x78C124AB
18034193f: 5c                          	popq	%rsp
180341940: 5c                          	popq	%rsp
180341941: 49 e5 7e                    	inl	$0x7e, %eax
180341944: e9 be 28 49 38              	jmp	0x1b87d4207
180341949: bc 5d a7 61 4c              	movl	$0x4c61a75d, %esp       # imm = 0x4C61A75D
18034194e: e1 9b                       	loope	0x1803418eb <.text+0x3318eb>
180341950: bc 51 7b 6c dc              	movl	$0xdc6c7b51, %esp       # imm = 0xDC6C7B51
180341955: 05 87 95 d9 ef              	addl	$0xefd99587, %eax       # imm = 0xEFD99587
18034195a: 3b b0 58 99 cd 7c           	cmpl	0x7ccd9958(%rax), %esi
180341960: 76 6c                       	jbe	0x1803419ce <.text+0x3319ce>
180341962: 60                          	<unknown>
180341963: 7c 61                       	jl	0x1803419c6 <.text+0x3319c6>
180341965: 5d                          	popq	%rbp
180341966: 3f                          	<unknown>
180341967: 11 40 08                    	adcl	%eax, 0x8(%rax)
18034196a: 73 e4                       	jae	0x180341950 <.text+0x331950>
18034196c: f9                          	stc
18034196d: a9 59 08 11 5b              	testl	$0x5b110859, %eax       # imm = 0x5B110859
180341972: d0 cb                       	rorb	%bl
180341974: 88 a1 ca 6a 3c da           	movb	%ah, -0x25c39536(%rcx)
18034197a: 0f 54 c0                    	andps	%xmm0, %xmm0
18034197d: ec                          	inb	%dx, %al
18034197e: 8d 2a                       	leal	(%rdx), %ebp
180341980: 2e c5 fe 8d                 	<unknown>
180341984: 7b 3c                       	jnp	0x1803419c2 <.text+0x3319c2>
180341986: 23 e4                       	andl	%esp, %esp
180341988: 9e                          	sahf
180341989: 90                          	nop
18034198a: 05 e3 ef b8 44              	addl	$0x44b8efe3, %eax       # imm = 0x44B8EFE3
18034198f: ea                          	<unknown>
180341990: 51                          	pushq	%rcx
180341991: a8 1a                       	testb	$0x1a, %al
180341993: 45 70 e6                    	jo	0x18034197c <.text+0x33197c>
180341996: de 45 cf                    	fiadds	-0x31(%rbp)
180341999: 9f                          	lahf
18034199a: d9 51 a6                    	fsts	-0x5a(%rcx)
18034199d: 26 ce                       	<unknown>
18034199f: c1 33                       	<unknown>
1803419a1: a1 d9 cb 30 81 54 91 10 6c  	movabsl	0x6c1091548130cbd9, %eax
1803419aa: d1 d7                       	rcll	%edi
1803419ac: a3 c5 2c 25 d0 6a bd a3 e3  	movabsl	%eax, -0x1c5c42952fdad33b
1803419b5: 1d 72 a2 24 ea              	sbbl	$0xea24a272, %eax       # imm = 0xEA24A272
1803419ba: 31 aa 58 18 a5 21           	xorl	%ebp, 0x21a51858(%rdx)
1803419c0: f1                          	<unknown>
1803419c1: c5 89 32                    	<unknown>
1803419c4: 9f                          	lahf
1803419c5: 30 17                       	xorb	%dl, (%rdi)
1803419c7: 37                          	<unknown>
1803419c8: 66 00 4a 3d                 	addb	%cl, 0x3d(%rdx)
1803419cc: 6d                          	insl	%dx, %es:(%rdi)
1803419cd: 4f 0b 25 e4 a1 b4 16        	orq	0x16b4a1e4(%rip), %r12  # 0x196e8bbb8
1803419d4: a1 b2 99 45 69 b2 50 56 32  	movabsl	0x325650b2694599b2, %eax
1803419dd: 6b 46 14 cf                 	imull	$-0x31, 0x14(%rsi), %eax
1803419e1: 3a 94 2a 7b 94 c5 f3        	cmpb	-0xc3a6b85(%rdx,%rbp), %dl
1803419e8: 86 c3                       	xchgb	%bl, %al
1803419ea: 28 a4 c9 70 f8 8e 9d        	subb	%ah, -0x62710790(%rcx,%rcx,8)
1803419f1: 75 25                       	jne	0x180341a18 <.text+0x331a18>
1803419f3: f6 19                       	negb	(%rcx)
1803419f5: f1                          	<unknown>
1803419f6: 3d 4c 49 99 62              	cmpl	$0x6299494c, %eax       # imm = 0x6299494C
1803419fb: f5                          	cmc
1803419fc: ac                          	lodsb	(%rsi), %al
1803419fd: 31 54 71 e5                 	xorl	%edx, -0x1b(%rcx,%rsi,2)
180341a01: 53                          	pushq	%rbx
180341a02: a9 8c 49 10 a8              	testl	$0xa810498c, %eax       # imm = 0xA810498C
180341a07: e5 63                       	inl	$0x63, %eax
180341a09: f8                          	clc
180341a0a: 32 57 7d                    	xorb	0x7d(%rdi), %dl
180341a0d: 61                          	<unknown>
180341a0e: 8e 08                       	movw	(%rax), %cs
180341a10: 2d b3 45 37 0e              	subl	$0xe3745b3, %eax        # imm = 0xE3745B3
180341a15: 0e                          	<unknown>
180341a16: b1 0a                       	movb	$0xa, %cl
180341a18: 3d 5d e1 c2 f9              	cmpl	$0xf9c2e15d, %eax       # imm = 0xF9C2E15D
180341a1d: f3 7c 36                    	rep		jl	0x180341a56 <.text+0x331a56>
180341a20: 42 f7 42 ab c5 2b da 44     	testl	$0x44da2bc5, -0x55(%rdx) # imm = 0x44DA2BC5
180341a28: 00 00                       	addb	%al, (%rax)
180341a2a: cf                          	iretl
180341a2b: 4a 01 0b                    	addq	%rcx, (%rbx)
180341a2e: cb                          	lretl
180341a2f: f4                          	hlt
180341a30: 25 48 34 85 20              	andl	$0x20853448, %eax       # imm = 0x20853448
180341a35: 28 42 d3                    	subb	%al, -0x2d(%rdx)
180341a38: 90                          	nop
180341a39: e7 d8                       	outl	%eax, $0xd8
180341a3b: 60                          	<unknown>
180341a3c: a1 c1 8d dc f6 59 24 78 a2  	movabsl	-0x5d87dba60923723f, %eax
180341a45: 37                          	<unknown>
180341a46: 83 b1 8e 61 fe e1 ad        	xorl	$-0x53, -0x1e019e72(%rcx)
180341a4d: 21 5a 80                    	andl	%ebx, -0x80(%rdx)
180341a50: d2 47 b8                    	rolb	%cl, -0x48(%rdi)
180341a53: 57                          	pushq	%rdi
180341a54: 0c f3                       	orb	$-0xd, %al
180341a56: 46 b8 0e eb 27 1d           	movl	$0x1d27eb0e, %eax       # imm = 0x1D27EB0E
180341a5c: 8c 47 0b                    	movw	%es, 0xb(%rdi)
180341a5f: 7f fc                       	jg	0x180341a5d <.text+0x331a5d>
180341a61: b1 2d                       	movb	$0x2d, %cl
180341a63: 52                          	pushq	%rdx
180341a64: c5 04 4a 72 ec              	<unknown>
180341a69: 62 61 05 6c 7a bc 0a 67 1b f9 07    	<unknown>
180341a74: 46 3c 98                    	cmpb	$-0x68, %al
180341a77: e1 8d                       	loope	0x180341a06 <.text+0x331a06>
180341a79: af                          	scasl	%es:(%rdi), %eax
180341a7a: 8b 21                       	movl	(%rcx), %esp
180341a7c: 4c 76 d9                    	jbe	0x180341a58 <.text+0x331a58>
180341a7f: bd eb 37 ef 73              	movl	$0x73ef37eb, %ebp       # imm = 0x73EF37EB
180341a84: d6                          	<unknown>
180341a85: 3f                          	<unknown>
180341a86: ae                          	scasb	%es:(%rdi), %al
180341a87: 77 a3                       	ja	0x180341a2c <.text+0x331a2c>
180341a89: 2b da                       	subl	%edx, %ebx
180341a8b: f4                          	hlt
180341a8c: a4                          	movsb	(%rsi), %es:(%rdi)
180341a8d: 45 dc d7                    	<unknown>
180341a90: ed                          	inl	%dx, %eax
180341a91: 94                          	xchgl	%esp, %eax
180341a92: 39 8f 6f 9e 27 a7           	cmpl	%ecx, -0x58d86191(%rdi)
180341a98: 7a 55                       	jp	0x180341aef <.text+0x331aef>
180341a9a: 50                          	pushq	%rax
180341a9b: 16                          	<unknown>
180341a9c: 05 8d 4c fd 8b              	addl	$0x8bfd4c8d, %eax       # imm = 0x8BFD4C8D
180341aa1: 68 d6 57 1a d9              	pushq	$-0x26e5a82a            # imm = 0xD91A57D6
180341aa6: 39 59 20                    	cmpl	%ebx, 0x20(%rcx)
180341aa9: 4f 80 ac 56 94 44 bf f2 3b  	subb	$0x3b, -0xd40bb6c(%r14,%r10,2)
180341ab2: a1 df 02 87 80 9b 1a 88 ca  	movabsl	-0x3577e5647f78fd21, %eax
180341abb: 99                          	cltd
180341abc: a5                          	movsl	(%rsi), %es:(%rdi)
180341abd: 87 be 08 3a 1c d8           	xchgl	%edi, -0x27e3c5f8(%rsi)
180341ac3: fc                          	cld
180341ac4: b0 de                       	movb	$-0x22, %al
180341ac6: 21 76 50                    	andl	%esi, 0x50(%rsi)
180341ac9: 87 fd                       	xchgl	%ebp, %edi
180341acb: 14 c5                       	adcb	$-0x3b, %al
180341acd: b5 11                       	movb	$0x11, %ch
180341acf: 3e 34 7a                    	xorb	$0x7a, %al
180341ad2: 6a c6                       	pushq	$-0x3a
180341ad4: 99                          	cltd
180341ad5: 11 61 60                    	adcl	%esp, 0x60(%rcx)
180341ad8: 4f ec                       	inb	%dx, %al
180341ada: a0 e3 cc 22 e4 e9 00 5b 08  	movabsb	0x85b00e9e422cce3, %al
180341ae3: 2e ef                       	outl	%eax, %dx
180341ae5: 75 b9                       	jne	0x180341aa0 <.text+0x331aa0>
180341ae7: 91                          	xchgl	%ecx, %eax
180341ae8: 52                          	pushq	%rdx
180341ae9: 2d 53 35 ad 49              	subl	$0x49ad3553, %eax       # imm = 0x49AD3553
180341aee: c3                          	retq
180341aef: 72 07                       	jb	0x180341af8 <.text+0x331af8>
180341af1: 86 ba 9c 16 85 02           	xchgb	%bh, 0x285169c(%rdx)
180341af7: aa                          	stosb	%al, %es:(%rdi)
180341af8: ef                          	outl	%eax, %dx
180341af9: 3f                          	<unknown>
180341afa: c1 e6 03                    	shll	$0x3, %esi
180341afd: e1 25                       	loope	0x180341b24 <.text+0x331b24>
180341aff: 4a 66 c9                    	leave
180341b02: 43 36 20 05 dd 70 b2 78     	andb	%al, %ss:0x78b270dd(%rip)
180341b0a: 50                          	pushq	%rax
180341b0b: bc ec 4f a5 d4              	movl	$0xd4a54fec, %esp       # imm = 0xD4A54FEC
180341b10: 5c                          	popq	%rsp
180341b11: f9                          	stc
180341b12: 5f                          	popq	%rdi
180341b13: 9d                          	popfq
180341b14: a5                          	movsl	(%rsi), %es:(%rdi)
180341b15: bd f4 07 b4 2d              	movl	$0x2db407f4, %ebp       # imm = 0x2DB407F4
180341b1a: d4                          	<unknown>
180341b1b: 10 d7                       	adcb	%dl, %bh
180341b1d: 88 94 0f a8 68 da 7c        	movb	%dl, 0x7cda68a8(%rdi,%rcx)
180341b24: e2 2f                       	loop	0x180341b55 <.text+0x331b55>
180341b26: 81 24 a3 d1 39 13 55        	andl	$0x551339d1, (%rbx,%riz,4) # imm = 0x551339D1
180341b2d: 09 b5 42 e5 0c 1d           	orl	%esi, 0x1d0ce542(%rbp)
180341b33: 74 7d                       	je	0x180341bb2 <.text+0x331bb2>
180341b35: e8 6b 5b 25 f7              	callq	0x1775976a5
180341b3a: 8b cf                       	movl	%edi, %ecx
180341b3c: 32 82 84 8f d3 b5           	xorb	-0x4a2c707c(%rdx), %al
180341b42: 78 40                       	js	0x180341b84 <.text+0x331b84>
180341b44: d1 cd                       	rorl	%ebp
180341b46: 3a ac 05 ea 2e d2 3e        	cmpb	0x3ed22eea(%rbp,%rax), %ch
180341b4d: 31 8a 27 ec d7 13           	xorl	%ecx, 0x13d7ec27(%rdx)
180341b53: 32 31                       	xorb	(%rcx), %dh
180341b55: a2 1c b2 88 04 3e 6a b3 ed  	movabsb	%al, -0x124c95c1fb774de4
180341b5e: cc                          	int3
180341b5f: 38 92 c5 66 3e 3d           	cmpb	%dl, 0x3d3e66c5(%rdx)
180341b65: fb                          	sti
180341b66: 3d 24 1a dc 3f              	cmpl	$0x3fdc1a24, %eax       # imm = 0x3FDC1A24
180341b6b: b8 db fa ba 7d              	movl	$0x7dbafadb, %eax       # imm = 0x7DBAFADB
180341b70: 16                          	<unknown>
180341b71: f9                          	stc
180341b72: 60                          	<unknown>
180341b73: 04 43                       	addb	$0x43, %al
180341b75: 12 76 0b                    	adcb	0xb(%rsi), %dh
180341b78: f4                          	hlt
180341b79: 9a                          	<unknown>
180341b7a: ca 1d c2                    	lretl	$-0x3de3                # imm = 0xC21D
180341b7d: 08 92 1d cf 73 10           	orb	%dl, 0x1073cf1d(%rdx)
180341b83: 30 e6                       	xorb	%ah, %dh
180341b85: ee                          	outb	%al, %dx
180341b86: aa                          	stosb	%al, %es:(%rdi)
180341b87: de 4f 73                    	fimuls	0x73(%rdi)
180341b8a: 5c                          	popq	%rsp
180341b8b: 96                          	xchgl	%esi, %eax
180341b8c: 4e df 17                    	fists	(%rdi)
180341b8f: 0e                          	<unknown>
180341b90: 84 ea                       	testb	%ch, %dl
180341b92: 8f 13 40                    	<unknown>
180341b95: af                          	scasl	%es:(%rdi), %eax
180341b96: b8 cc b7 af 88              	movl	$0x88afb7cc, %eax       # imm = 0x88AFB7CC
180341b9b: 67 bd 82 cc b5 f6           	addr32		movl	$0xf6b5cc82, %ebp # imm = 0xF6B5CC82
180341ba1: f1                          	<unknown>
180341ba2: 24 5f                       	andb	$0x5f, %al
180341ba4: bd c9 7a 41 80              	movl	$0x80417ac9, %ebp       # imm = 0x80417AC9
180341ba9: 3a d2                       	cmpb	%dl, %dl
180341bab: 2d 3d 2f e6 1e              	subl	$0x1ee62f3d, %eax       # imm = 0x1EE62F3D
180341bb0: d4                          	<unknown>
180341bb1: 19 ea                       	sbbl	%ebp, %edx
180341bb3: 73 c0                       	jae	0x180341b75 <.text+0x331b75>
180341bb5: 5c                          	popq	%rsp
180341bb6: 30 f5                       	xorb	%dh, %ch
180341bb8: 47 3a 25 10 b9 3b 24        	cmpb	0x243bb910(%rip), %r12b # 0x1a46fd4cf
180341bbf: fb                          	sti
180341bc0: 1f                          	<unknown>
180341bc1: 68 13 60 a1 b4              	pushq	$-0x4b5e9fed            # imm = 0xB4A16013
180341bc6: a4                          	movsb	(%rsi), %es:(%rdi)
180341bc7: 5c                          	popq	%rsp
180341bc8: 19 35 51 1a 37 e9           	sbbl	%esi, -0x16c8e5af(%rip) # 0x1696b361f
180341bce: 87 40 23                    	xchgl	%eax, 0x23(%rax)
180341bd1: 8c c4                       	movl	%es, %esp
180341bd3: ea                          	<unknown>
180341bd4: 16                          	<unknown>
180341bd5: 21 1b                       	andl	%ebx, (%rbx)
180341bd7: 68 e9 5d 26 24              	pushq	$0x24265de9             # imm = 0x24265DE9
180341bdc: 3a 02                       	cmpb	(%rdx), %al
180341bde: 15 41 ab ac 35              	adcl	$0x35acab41, %eax       # imm = 0x35ACAB41
180341be3: e3 0d                       	jrcxz	0x180341bf2 <.text+0x331bf2>
180341be5: b4 6a                       	movb	$0x6a, %ah
180341be7: 02 0d c4 e8 17 20           	addb	0x2017e8c4(%rip), %cl   # 0x1a04c04b1
180341bed: 4d 80 f1 84                 	xorb	$-0x7c, %r9b
180341bf1: ab                          	stosl	%eax, %es:(%rdi)
180341bf2: 15 31 ee 94 da              	adcl	$0xda94ee31, %eax       # imm = 0xDA94EE31
180341bf7: d4                          	<unknown>
180341bf8: 2b c2                       	subl	%edx, %eax
180341bfa: d5 e6 49 98 72 1e 52 ac     	cmovnsl	-0x53ade18e(%rax), %r27d
180341c02: 77 1b                       	ja	0x180341c1f <.text+0x331c1f>
180341c04: 96                          	xchgl	%esi, %eax
180341c05: 11 d4                       	adcl	%edx, %esp
180341c07: e4 0d                       	inb	$0xd, %al
180341c09: 13 58 bb                    	adcl	-0x45(%rax), %ebx
180341c0c: 5e                          	popq	%rsi
180341c0d: 2c f1                       	subb	$-0xf, %al
180341c0f: e7 cc                       	outl	%eax, $0xcc
180341c11: e8 36 b6 d1 c8              	callq	0x14905d24c
180341c16: 8b 2e                       	movl	(%rsi), %ebp
180341c18: eb 55                       	jmp	0x180341c6f <.text+0x331c6f>
180341c1a: ef                          	outl	%eax, %dx
180341c1b: 36 7f 65                    	jg	0x180341c83 <.text+0x331c83>
180341c1e: 4e dd 14 16                 	fstl	(%rsi,%r10)
180341c22: bb b3 da 7c f5              	movl	$0xf57cdab3, %ebx       # imm = 0xF57CDAB3
180341c27: 09 c8                       	orl	%ecx, %eax
180341c29: 94                          	xchgl	%esp, %eax
180341c2a: dd 49 0f                    	fisttpll	0xf(%rcx)
180341c2d: a4                          	movsb	(%rsi), %es:(%rdi)
180341c2e: 9b                          	wait
180341c2f: a3 60 e7 c2 ad 43 1f b9 d3  	movabsl	%eax, -0x2c46e0bc523d18a0
180341c38: 14 c3                       	adcb	$-0x3d, %al
180341c3a: f8                          	clc
180341c3b: 24 83                       	andb	$-0x7d, %al
180341c3d: fd                          	std
180341c3e: af                          	scasl	%es:(%rdi), %eax
180341c3f: 4d e3 a7                    	jrcxz	0x180341be9 <.text+0x331be9>
180341c42: 4f df 01                    	filds	(%r9)
180341c45: 8d b5 6f cc 69 de           	leal	-0x21963391(%rbp), %esi
180341c4b: e9 07 36 98 55              	jmp	0x1d5cc5257
180341c50: 56                          	pushq	%rsi
180341c51: 2a 38                       	subb	(%rax), %bh
180341c53: 0e                          	<unknown>
180341c54: 1b 90 f8 75 27 aa           	sbbl	-0x55d88a08(%rax), %edx
180341c5a: 46 11 cc                    	adcl	%r9d, %esp
180341c5d: 9e                          	sahf
180341c5e: 17                          	<unknown>
180341c5f: 8e 21                       	movw	(%rcx), %fs
180341c61: ca 89 48                    	lretl	$0x4889                 # imm = 0x4889
180341c64: 34 b6                       	xorb	$-0x4a, %al
180341c66: 36 99                       	cltd
180341c68: d4                          	<unknown>
180341c69: aa                          	stosb	%al, %es:(%rdi)
180341c6a: ab                          	stosl	%eax, %es:(%rdi)
180341c6b: 70 15                       	jo	0x180341c82 <.text+0x331c82>
180341c6d: f8                          	clc
180341c6e: 8d c1                       	<unknown>
180341c70: 5c                          	popq	%rsp
180341c71: c1 da ad                    	rcrl	$0xad, %edx
180341c74: 8b 64 08 75                 	movl	0x75(%rax,%rcx), %esp
180341c78: 85 5f 76                    	testl	%ebx, 0x76(%rdi)
180341c7b: 24 02                       	andb	$0x2, %al
180341c7d: 25 ba 1b 53 fc              	andl	$0xfc531bba, %eax       # imm = 0xFC531BBA
180341c82: bf bb ca 6b 25              	movl	$0x256bcabb, %edi       # imm = 0x256BCABB
180341c87: c4 9b 0f                    	<unknown>
180341c8a: 82                          	<unknown>
180341c8b: b1 50                       	movb	$0x50, %cl
180341c8d: 1c fc                       	sbbb	$-0x4, %al
180341c8f: 89 da                       	movl	%ebx, %edx
180341c91: d7                          	xlatb
180341c92: 71 a4                       	jno	0x180341c38 <.text+0x331c38>
180341c94: 2d e8 93 e1 53              	subl	$0x53e193e8, %eax       # imm = 0x53E193E8
180341c99: de db                       	<unknown>
180341c9b: 53                          	pushq	%rbx
180341c9c: bc d7 cc eb b3              	movl	$0xb3ebccd7, %esp       # imm = 0xB3EBCCD7
180341ca1: bb 86 a1 7b e1              	movl	$0xe17ba186, %ebx       # imm = 0xE17BA186
180341ca6: 99                          	cltd
180341ca7: 58                          	popq	%rax
180341ca8: 54                          	pushq	%rsp
180341ca9: 31 d9                       	xorl	%ebx, %ecx
180341cab: 94                          	xchgl	%esp, %eax
180341cac: d7                          	xlatb
180341cad: 00 e7                       	addb	%ah, %bh
180341caf: e0 e3                       	loopne	0x180341c94 <.text+0x331c94>
180341cb1: 65 3a b0 81 2a f5 4a        	cmpb	%gs:0x4af52a81(%rax), %dh
180341cb8: fb                          	sti
180341cb9: 0f b5 24 7d 3a bd 65 bb     	lgsl	-0x449a42c6(,%rdi,2), %esp
180341cc1: 80 cb 48                    	orb	$0x48, %bl
180341cc4: 52                          	pushq	%rdx
180341cc5: d2 72 dd                    	<unknown>
180341cc8: 32 de                       	xorb	%dh, %bl
180341cca: 54                          	pushq	%rsp
180341ccb: 63 6a 01                    	movslq	0x1(%rdx), %ebp
180341cce: 30 e1                       	xorb	%ah, %cl
180341cd0: 92                          	xchgl	%edx, %eax
180341cd1: bb 37 e8 4a f7              	movl	$0xf74ae837, %ebx       # imm = 0xF74AE837
180341cd6: c8 e3 11 86                 	enter	$0x11e3, $-0x7a         # imm = 0x11E3
180341cda: 50                          	pushq	%rax
180341cdb: 18 97 ef 8c 32 19           	sbbb	%dl, 0x19328cef(%rdi)
180341ce1: 37                          	<unknown>
180341ce2: 99                          	cltd
180341ce3: df ad 6d a9 85 b9           	fildll	-0x467a5693(%rbp)
180341ce9: 4b 64 e1 a6                 	loope	0x180341c93 <.text+0x331c93>
180341ced: f7 a3 15 1f ce db           	mull	-0x2431e0eb(%rbx)
180341cf3: 6d                          	insl	%dx, %es:(%rdi)
180341cf4: fc                          	cld
180341cf5: f5                          	cmc
180341cf6: 8e eb                       	movl	%ebx, %gs
180341cf8: c8 c9 37 45                 	enter	$0x37c9, $0x45          # imm = 0x37C9
180341cfc: 04 d2                       	addb	$-0x2e, %al
180341cfe: 22 62 28                    	andb	0x28(%rdx), %ah
180341d01: 11 aa 36 3a b5 ae           	adcl	%ebp, -0x514ac5ca(%rdx)
180341d07: 5f                          	popq	%rdi
180341d08: 08 90 7e 0f 54 36           	orb	%dl, 0x36540f7e(%rax)
180341d0e: 2c 2b                       	subb	$0x2b, %al
180341d10: 01 93 e9 1f d5 66           	addl	%edx, 0x66d51fe9(%rbx)
180341d16: 6a 38                       	pushq	$0x38
180341d18: 2f                          	<unknown>
180341d19: 78 f3                       	js	0x180341d0e <.text+0x331d0e>
180341d1b: c4 79 ca                    	<unknown>
180341d1e: 9d                          	popfq
180341d1f: 19 c6                       	sbbl	%eax, %esi
180341d21: 9b                          	wait
180341d22: c8 a5 2b b6                 	enter	$0x2ba5, $-0x4a         # imm = 0x2BA5
180341d26: b3 0e                       	movb	$0xe, %bl
180341d28: b5 be                       	movb	$-0x42, %ch
180341d2a: 54                          	pushq	%rsp
180341d2b: 7f a4                       	jg	0x180341cd1 <.text+0x331cd1>
180341d2d: 1d 7a 55 64 f4              	sbbl	$0xf464557a, %eax       # imm = 0xF464557A
180341d32: 05 9b f8 d7 70              	addl	$0x70d7f89b, %eax       # imm = 0x70D7F89B
180341d37: eb ad                       	jmp	0x180341ce6 <.text+0x331ce6>
180341d39: 83 da 79                    	sbbl	$0x79, %edx
180341d3c: db 60 8b                    	<unknown>
180341d3f: 6a 67                       	pushq	$0x67
180341d41: 3c fd                       	cmpb	$-0x3, %al
180341d43: 87 d0                       	xchgl	%eax, %edx
180341d45: 17                          	<unknown>
180341d46: 96                          	xchgl	%esi, %eax
180341d47: 3c 85                       	cmpb	$-0x7b, %al
180341d49: 43 22 cb                    	andb	%r11b, %cl
180341d4c: e6 d6                       	outb	%al, $0xd6
180341d4e: a3 c7 78 b5 42 0c bb 34 d7  	movabsl	%eax, -0x28cb44f3bd4a8739
180341d57: 7b 85                       	jnp	0x180341cde <.text+0x331cde>
180341d59: 6f                          	outsl	(%rsi), %dx
180341d5a: b0 ae                       	movb	$-0x52, %al
180341d5c: 3b e4                       	cmpl	%esp, %esp
180341d5e: 87 10                       	xchgl	%edx, (%rax)
180341d60: 46 3f                       	<unknown>
180341d62: b1 55                       	movb	$0x55, %cl
180341d64: bc 63 96 f1 68              	movl	$0x68f19663, %esp       # imm = 0x68F19663
180341d69: dd 97 3e a2 d1 52           	fstl	0x52d1a23e(%rdi)
180341d6f: c6 09                       	<unknown>
180341d71: 50                          	pushq	%rax
180341d72: 50                          	pushq	%rax
180341d73: e8 9e b0 82 c8              	callq	0x148b6ce16
180341d78: 2d c6 6a f6 7d              	subl	$0x7df66ac6, %eax       # imm = 0x7DF66AC6
180341d7d: 20 73 68                    	andb	%dh, 0x68(%rbx)
180341d80: 11 74 c1 af                 	adcl	%esi, -0x51(%rcx,%rax,8)
180341d84: e3 39                       	jrcxz	0x180341dbf <.text+0x331dbf>
180341d86: 59                          	popq	%rcx
180341d87: b5 54                       	movb	$0x54, %ch
180341d89: 1a d0                       	sbbb	%al, %dl
180341d8b: 40 e4 02                    	inb	$0x2, %al
180341d8e: 16                          	<unknown>
180341d8f: 07                          	<unknown>
180341d90: 65 12 20                    	adcb	%gs:(%rax), %ah
180341d93: d5 f0 f5 b4 25 85 70 7c 1c  	pmaddwd	0x1c7c7085(%r21,%r20), %mm6
180341d9c: 24 0c                       	andb	$0xc, %al
180341d9e: 02 0c f0                    	addb	(%rax,%rsi,8), %cl
180341da1: c4 9d 97                    	<unknown>
180341da4: 34 be                       	xorb	$-0x42, %al
180341da6: 31 b5 a8 10 ec 53           	xorl	%esi, 0x53ec10a8(%rbp)
180341dac: 49 dc 05 bd 10 c5 2e        	faddl	0x2ec510bd(%rip)        # 0x1aef92e70
180341db3: 9c                          	pushfq
180341db4: a1 32 f1 50 b6 f4 de 2c 96  	movabsl	-0x69d3210b49af0ece, %eax
180341dbd: c8 5f e4 a9                 	enter	$-0x1ba1, $-0x57        # imm = 0xE45F
180341dc1: fe 6c 81 68                 	<unknown>
180341dc5: d1 2d 30 6e 0b 48           	shrl	0x480b6e30(%rip)        # 0x1c83f8bfb
180341dcb: fc                          	cld
180341dcc: 3d 8d 3e 3a 38              	cmpl	$0x383a3e8d, %eax       # imm = 0x383A3E8D
180341dd1: fd                          	std
180341dd2: 08 a3 19 12 23 e0           	orb	%ah, -0x1fdcede7(%rbx)
180341dd8: d8 83 f1 f2 09 a8           	fadds	-0x57f60d0f(%rbx)
180341dde: e7 17                       	outl	%eax, $0x17
180341de0: 50                          	pushq	%rax
180341de1: 96                          	xchgl	%esi, %eax
180341de2: 6e                          	outsb	(%rsi), %dx
180341de3: 95                          	xchgl	%ebp, %eax
180341de4: a1 b9 63 b4 67 6e af a5 67  	movabsl	0x67a5af6e67b463b9, %eax
180341ded: f0                          	lock
180341dee: 7a da                       	jp	0x180341dca <.text+0x331dca>
180341df0: 5c                          	popq	%rsp
180341df1: b3 a0                       	movb	$-0x60, %bl
180341df3: e1 f2                       	loope	0x180341de7 <.text+0x331de7>
180341df5: 67 55                       	addr32		pushq	%rbp
180341df7: 57                          	pushq	%rdi
180341df8: 10 6b f1                    	adcb	%ch, -0xf(%rbx)
180341dfb: 23 8b 97 a7 15 4c           	andl	0x4c15a797(%rbx), %ecx
180341e01: 4d 08 37                    	orb	%r14b, (%r15)
180341e04: bf ab d6 7d dd              	movl	$0xdd7dd6ab, %edi       # imm = 0xDD7DD6AB
180341e09: 03 62 24                    	addl	0x24(%rdx), %esp
180341e0c: e1 50                       	loope	0x180341e5e <.text+0x331e5e>
180341e0e: 72 6f                       	jb	0x180341e7f <.text+0x331e7f>
180341e10: 98                          	cwtl
180341e11: 56                          	pushq	%rsi
180341e12: 77 cf                       	ja	0x180341de3 <.text+0x331de3>
180341e14: d7                          	xlatb
180341e15: a0 b6 c7 a1 3c 18 d7 8e fb  	movabsb	-0x47128e7c35e384a, %al
180341e1e: c4 30 f9                    	<unknown>
180341e21: 20 4e c4                    	andb	%cl, -0x3c(%rsi)
180341e24: f1                          	<unknown>
180341e25: d6                          	<unknown>
180341e26: 9f                          	lahf
180341e27: b3 a6                       	movb	$-0x5a, %bl
180341e29: d4                          	<unknown>
180341e2a: 24 3e                       	andb	$0x3e, %al
180341e2c: ac                          	lodsb	(%rsi), %al
180341e2d: 87 02                       	xchgl	%eax, (%rdx)
180341e2f: 80 2f 68                    	subb	$0x68, (%rdi)
180341e32: 2b 82 cd 93 80 6f           	subl	0x6f8093cd(%rdx), %eax
180341e38: 75 98                       	jne	0x180341dd2 <.text+0x331dd2>
180341e3a: fe 05 cd 27 32 73           	incb	0x733227cd(%rip)        # 0x1f366460d
180341e40: e4 e8                       	inb	$0xe8, %al
180341e42: 05 15 cc ed 51              	addl	$0x51edcc15, %eax       # imm = 0x51EDCC15
180341e47: 53                          	pushq	%rbx
180341e48: f7 5e a4                    	negl	-0x5c(%rsi)
180341e4b: 67 02 c9                    	addr32		addb	%cl, %cl
180341e4e: 33 e2                       	xorl	%edx, %esp
180341e50: 18 4f 38                    	sbbb	%cl, 0x38(%rdi)
180341e53: d0 e3                       	shlb	%bl
180341e55: 77 89                       	ja	0x180341de0 <.text+0x331de0>
180341e57: 3a fd                       	cmpb	%ch, %bh
180341e59: ec                          	inb	%dx, %al
180341e5a: fb                          	sti
180341e5b: 32 96 a4 c5 6f 33           	xorb	0x336fc5a4(%rsi), %dl
180341e61: 2e bc 38 40 66 4d           	movl	$0x4d664038, %esp       # imm = 0x4D664038
180341e67: bd eb 44 c7 a9              	movl	$0xa9c744eb, %ebp       # imm = 0xA9C744EB
180341e6c: e9 b6 71 1c b7              	jmp	0x137509027
180341e71: 48 71 aa                    	jno	0x180341e1e <.text+0x331e1e>
180341e74: e3 99                       	jrcxz	0x180341e0f <.text+0x331e0f>
180341e76: 1e                          	<unknown>
180341e77: 37                          	<unknown>
180341e78: e1 ba                       	loope	0x180341e34 <.text+0x331e34>
180341e7a: 85 64 27 29                 	testl	%esp, 0x29(%rdi,%riz)
180341e7e: c5 a5 ef 3c f7              	vpxor	(%rdi,%rsi,8), %ymm11, %ymm7
180341e83: 18 47 27                    	sbbb	%al, 0x27(%rdi)
180341e86: ef                          	outl	%eax, %dx
180341e87: 95                          	xchgl	%ebp, %eax
180341e88: 36 22 40 81                 	andb	%ss:-0x7f(%rax), %al
180341e8c: 1b 14 8e                    	sbbl	(%rsi,%rcx,4), %edx
180341e8f: 3e 42 59                    	popq	%rcx
180341e92: a4                          	movsb	(%rsi), %es:(%rdi)
180341e93: 48 63 05 ee 66 48 00        	movslq	0x4866ee(%rip), %rax    # 0x1807c8588
180341e9a: 48 8d 0d df 73 31 00        	leaq	0x3173df(%rip), %rcx    # 0x180659280
180341ea1: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
180341ea4: f7 d2                       	notl	%edx
180341ea6: b9 05 00 00 00              	movl	$0x5, %ecx
180341eab: 29 c1                       	subl	%eax, %ecx
180341ead: d3 c2                       	roll	%cl, %edx
180341eaf: 48 63 ca                    	movslq	%edx, %rcx
180341eb2: 31 c0                       	xorl	%eax, %eax
180341eb4: 48 8d 15 15 1c 48 00        	leaq	0x481c15(%rip), %rdx    # 0x1807c3ad0
180341ebb: 2b 04 8a                    	subl	(%rdx,%rcx,4), %eax
180341ebe: 81 c1 b3 c0 3a 39           	addl	$0x393ac0b3, %ecx       # imm = 0x393AC0B3
180341ec4: d3 c8                       	rorl	%cl, %eax
180341ec6: 35 39 3a c0 b3              	xorl	$0xb3c03a39, %eax       # imm = 0xB3C03A39
180341ecb: d3 c8                       	rorl	%cl, %eax
180341ecd: 35 4c 3f c5 c6              	xorl	$0xc6c53f4c, %eax       # imm = 0xC6C53F4C
180341ed2: 48 98                       	cltq
180341ed4: 48 8d 8d b0 01 00 00        	leaq	0x1b0(%rbp), %rcx
180341edb: 48 8d 15 8e bd 47 00        	leaq	0x47bd8e(%rip), %rdx    # 0x1807bdc70
180341ee2: ff 14 c2                    	callq	*(%rdx,%rax,8)
180341ee5: 8b 85 a0 0c 00 00           	movl	0xca0(%rbp), %eax
180341eeb: 48 81 c4 58 0d 00 00        	addq	$0xd58, %rsp            # imm = 0xD58
180341ef2: 5b                          	popq	%rbx
180341ef3: 5f                          	popq	%rdi
180341ef4: 5e                          	popq	%rsi
180341ef5: 41 5c                       	popq	%r12
180341ef7: 41 5d                       	popq	%r13
180341ef9: 41 5e                       	popq	%r14
180341efb: 41 5f                       	popq	%r15
180341efd: 5d                          	popq	%rbp
180341efe: c3                          	retq
180341eff: 48 8b 85 58 0b 00 00        	movq	0xb58(%rbp), %rax
180341f06: 48 b9 ba 9a 74 10 5f 35 6c fc       	movabsq	$-0x393caa0ef8b6546, %rcx # imm = 0xFC6C355F10749ABA
180341f10: 48 33 0d d1 ea 46 00        	xorq	0x46ead1(%rip), %rcx    # 0x1807b09e8
180341f17: 48 ba eb 1e e5 60 84 9a 61 44       	movabsq	$0x44619a8460e51eeb, %rdx # imm = 0x44619A8460E51EEB
180341f21: 48 01 ca                    	addq	%rcx, %rdx
180341f24: 48 39 d0                    	cmpq	%rdx, %rax
180341f27: 0f 84 70 f3 ff ff           	je	0x18034129d <.text+0x33129d>
180341f2d: 48 39 85 60 0b 00 00        	cmpq	%rax, 0xb60(%rbp)
180341f34: 0f 86 63 f3 ff ff           	jbe	0x18034129d <.text+0x33129d>
180341f3a: 48 63 05 9f 61 48 00        	movslq	0x48619f(%rip), %rax    # 0x1807c80e0
180341f41: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180341f44: b9 02 00 00 00              	movl	$0x2, %ecx
180341f49: 29 c1                       	subl	%eax, %ecx
180341f4b: d3 c2                       	roll	%cl, %edx
180341f4d: 0f ca                       	bswapl	%edx
180341f4f: f7 da                       	negl	%edx
180341f51: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180341f57: 48 63 c2                    	movslq	%edx, %rax
180341f5a: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180341f5d: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180341f63: d3 ca                       	rorl	%cl, %edx
180341f65: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180341f6b: d3 ca                       	rorl	%cl, %edx
180341f6d: b9 12 00 00 00              	movl	$0x12, %ecx
180341f72: 29 c1                       	subl	%eax, %ecx
180341f74: d3 c2                       	roll	%cl, %edx
180341f76: 41 be 02 00 00 00           	movl	$0x2, %r14d
180341f7c: be 12 00 00 00              	movl	$0x12, %esi
180341f81: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180341f87: 48 63 c2                    	movslq	%edx, %rax
180341f8a: 48 8d 8d 20 05 00 00        	leaq	0x520(%rbp), %rcx
180341f91: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180341f96: 48 b9 23 af 7b 4c 04 ae ae 66       	movabsq	$0x66aeae044c7baf23, %rcx # imm = 0x66AEAE044C7BAF23
180341fa0: 48 33 0d 31 ea 46 00        	xorq	0x46ea31(%rip), %rcx    # 0x1807b09d8
180341fa7: 48 ba bc 90 70 a9 03 f8 77 df       	movabsq	$-0x208807fc568f6f44, %rdx # imm = 0xDF77F803A97090BC
180341fb1: 48 01 ca                    	addq	%rcx, %rdx
180341fb4: 48 39 d0                    	cmpq	%rdx, %rax
180341fb7: 0f 85 e0 f2 ff ff           	jne	0x18034129d <.text+0x33129d>
180341fbd: 48 63 05 74 61 48 00        	movslq	0x486174(%rip), %rax    # 0x1807c8138
180341fc4: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180341fc7: 41 29 c6                    	subl	%eax, %r14d
180341fca: 44 89 f1                    	movl	%r14d, %ecx
180341fcd: d3 c2                       	roll	%cl, %edx
180341fcf: 0f ca                       	bswapl	%edx
180341fd1: f7 da                       	negl	%edx
180341fd3: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180341fd9: 48 63 c2                    	movslq	%edx, %rax
180341fdc: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180341fdf: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180341fe5: d3 ca                       	rorl	%cl, %edx
180341fe7: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180341fed: d3 ca                       	rorl	%cl, %edx
180341fef: 29 c6                       	subl	%eax, %esi
180341ff1: 89 f1                       	movl	%esi, %ecx
180341ff3: d3 c2                       	roll	%cl, %edx
180341ff5: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180341ffb: 48 63 c2                    	movslq	%edx, %rax
180341ffe: 48 8d 8d e0 01 00 00        	leaq	0x1e0(%rbp), %rcx
180342005: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034200a: 48 b9 a1 73 64 97 80 12 3e aa       	movabsq	$-0x55c1ed7f689b8c5f, %rcx # imm = 0xAA3E1280976473A1
180342014: 48 33 0d c5 e9 46 00        	xorq	0x46e9c5(%rip), %rcx    # 0x1807b09e0
18034201b: 48 ba 7b 02 82 ee b1 4b 2d 45       	movabsq	$0x452d4bb1ee82027b, %rdx # imm = 0x452D4BB1EE82027B
180342025: 48 01 ca                    	addq	%rcx, %rdx
180342028: 48 39 d0                    	cmpq	%rdx, %rax
18034202b: 0f 84 20 f0 ff ff           	je	0x180341051 <.text+0x331051>
180342031: e9 67 f2 ff ff              	jmp	0x18034129d <.text+0x33129d>
180342036: 48 63 05 5b 61 48 00        	movslq	0x48615b(%rip), %rax    # 0x1807c8198
18034203d: 48 8d 3d 3c 72 31 00        	leaq	0x31723c(%rip), %rdi    # 0x180659280
180342044: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180342047: ff c2                       	incl	%edx
180342049: 81 f2 53 04 4d c1           	xorl	$0xc14d0453, %edx       # imm = 0xC14D0453
18034204f: 8d 42 01                    	leal	0x1(%rdx), %eax
180342052: 48 98                       	cltq
180342054: 41 8b 04 86                 	movl	(%r14,%rax,4), %eax
180342058: 8d 8a fe 11 ba 74           	leal	0x74ba11fe(%rdx), %ecx
18034205e: d3 c8                       	rorl	%cl, %eax
180342060: d3 c8                       	rorl	%cl, %eax
180342062: 35 02 ee 45 8b              	xorl	$0x8b45ee02, %eax       # imm = 0x8B45EE02
180342067: d3 c8                       	rorl	%cl, %eax
180342069: 48 8b 8d 98 0c 00 00        	movq	0xc98(%rbp), %rcx
180342070: 48 8d b1 89 02 00 00        	leaq	0x289(%rcx), %rsi
180342077: b9 fc 11 ba 74              	movl	$0x74ba11fc, %ecx       # imm = 0x74BA11FC
18034207c: 29 d1                       	subl	%edx, %ecx
18034207e: d3 c0                       	roll	%cl, %eax
180342080: d3 c0                       	roll	%cl, %eax
180342082: d3 c0                       	roll	%cl, %eax
180342084: 48 98                       	cltq
180342086: 48 89 f1                    	movq	%rsi, %rcx
180342089: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034208e: 48 63 0d 13 61 48 00        	movslq	0x486113(%rip), %rcx    # 0x1807c81a8
180342095: 8b 14 8f                    	movl	(%rdi,%rcx,4), %edx
180342098: 81 c1 78 60 76 e5           	addl	$0xe5766078, %ecx       # imm = 0xE5766078
18034209e: d3 ca                       	rorl	%cl, %edx
1803420a0: f7 d2                       	notl	%edx
1803420a2: d3 ca                       	rorl	%cl, %edx
1803420a4: 81 f2 78 60 76 e5           	xorl	$0xe5766078, %edx       # imm = 0xE5766078
1803420aa: 4c 63 d2                    	movslq	%edx, %r10
1803420ad: 41 b9 99 4b e7 08           	movl	$0x8e74b99, %r9d        # imm = 0x8E74B99
1803420b3: 47 33 0c 96                 	xorl	(%r14,%r10,4), %r9d
1803420b7: 41 8d 92 66 b4 18 f7        	leal	-0x8e74b9a(%r10), %edx
1803420be: 89 d1                       	movl	%edx, %ecx
1803420c0: 41 d3 c9                    	rorl	%cl, %r9d
1803420c3: 41 b8 66 b4 18 f7           	movl	$0xf718b466, %r8d       # imm = 0xF718B466
1803420c9: 45 29 d0                    	subl	%r10d, %r8d
1803420cc: 44 89 c1                    	movl	%r8d, %ecx
1803420cf: 41 d3 c1                    	roll	%cl, %r9d
1803420d2: 89 d1                       	movl	%edx, %ecx
1803420d4: 41 d3 c9                    	rorl	%cl, %r9d
1803420d7: 41 d3 c9                    	rorl	%cl, %r9d
1803420da: 44 89 c1                    	movl	%r8d, %ecx
1803420dd: 41 d3 c1                    	roll	%cl, %r9d
1803420e0: 49 89 c6                    	movq	%rax, %r14
1803420e3: 41 f7 d9                    	negl	%r9d
1803420e6: 49 63 c1                    	movslq	%r9d, %rax
1803420e9: 48 89 f1                    	movq	%rsi, %rcx
1803420ec: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803420f1: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
1803420f8: 48 89 c2                    	movq	%rax, %rdx
1803420fb: 4d 89 f0                    	movq	%r14, %r8
1803420fe: e8 3d ac 16 00              	callq	0x1804acd40 <.text+0x49cd40>
180342103: 48 63 15 c2 60 48 00        	movslq	0x4860c2(%rip), %rdx    # 0x1807c81cc
18034210a: 48 8d 3d 6f 71 31 00        	leaq	0x31716f(%rip), %rdi    # 0x180659280
180342111: 8b 04 97                    	movl	(%rdi,%rdx,4), %eax
180342114: b9 0b 00 00 00              	movl	$0xb, %ecx
180342119: 29 d1                       	subl	%edx, %ecx
18034211b: d3 c0                       	roll	%cl, %eax
18034211d: f7 d0                       	notl	%eax
18034211f: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180342122: d3 c8                       	rorl	%cl, %eax
180342124: 89 c1                       	movl	%eax, %ecx
180342126: f7 d1                       	notl	%ecx
180342128: 48 63 c9                    	movslq	%ecx, %rcx
18034212b: 48 8d 1d 9e 19 48 00        	leaq	0x48199e(%rip), %rbx    # 0x1807c3ad0
180342132: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
180342136: 41 0f c8                    	bswapl	%r8d
180342139: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
18034213e: 29 c2                       	subl	%eax, %edx
180342140: 89 d1                       	movl	%edx, %ecx
180342142: 41 d3 c8                    	rorl	%cl, %r8d
180342145: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
18034214a: 89 c1                       	movl	%eax, %ecx
18034214c: 41 d3 c0                    	roll	%cl, %r8d
18034214f: 89 d1                       	movl	%edx, %ecx
180342151: 41 d3 c8                    	rorl	%cl, %r8d
180342154: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
18034215b: 41 ff c0                    	incl	%r8d
18034215e: 89 c1                       	movl	%eax, %ecx
180342160: 41 d3 c0                    	roll	%cl, %r8d
180342163: 41 f7 d0                    	notl	%r8d
180342166: 49 63 c0                    	movslq	%r8d, %rax
180342169: 48 8d 8d e0 06 00 00        	leaq	0x6e0(%rbp), %rcx
180342170: 4c 8d b5 a0 0b 00 00        	leaq	0xba0(%rbp), %r14
180342177: 4c 89 f2                    	movq	%r14, %rdx
18034217a: 4c 8d 2d ef ba 47 00        	leaq	0x47baef(%rip), %r13    # 0x1807bdc70
180342181: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342186: 48 63 05 17 60 48 00        	movslq	0x486017(%rip), %rax    # 0x1807c81a4
18034218d: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180342190: b9 0a 00 00 00              	movl	$0xa, %ecx
180342195: 29 c1                       	subl	%eax, %ecx
180342197: d3 c2                       	roll	%cl, %edx
180342199: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
18034219f: d3 ca                       	rorl	%cl, %edx
1803421a1: d3 ca                       	rorl	%cl, %edx
1803421a3: d3 ca                       	rorl	%cl, %edx
1803421a5: 48 63 c2                    	movslq	%edx, %rax
1803421a8: 31 d2                       	xorl	%edx, %edx
1803421aa: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
1803421ad: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803421b3: d3 ca                       	rorl	%cl, %edx
1803421b5: d3 ca                       	rorl	%cl, %edx
1803421b7: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803421bd: d3 ca                       	rorl	%cl, %edx
1803421bf: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803421c4: 29 c1                       	subl	%eax, %ecx
1803421c6: d3 c2                       	roll	%cl, %edx
1803421c8: d3 c2                       	roll	%cl, %edx
1803421ca: 48 63 c2                    	movslq	%edx, %rax
1803421cd: 4c 89 f1                    	movq	%r14, %rcx
1803421d0: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803421d5: e8 86 48 fc ff              	callq	0x180306a60 <.text+0x2f6a60>
1803421da: 48 8d 8d 00 07 00 00        	leaq	0x700(%rbp), %rcx
1803421e1: 48 89 c2                    	movq	%rax, %rdx
1803421e4: e8 77 22 d6 ff              	callq	0x1800a4460 <.text+0x94460>
1803421e9: 48 63 05 d0 5f 48 00        	movslq	0x485fd0(%rip), %rax    # 0x1807c81c0
1803421f0: 48 8d 3d 89 70 31 00        	leaq	0x317089(%rip), %rdi    # 0x180659280
1803421f7: 8b 04 87                    	movl	(%rdi,%rax,4), %eax
1803421fa: ff c0                       	incl	%eax
1803421fc: 35 53 04 4d c1              	xorl	$0xc14d0453, %eax       # imm = 0xC14D0453
180342201: 8d 48 01                    	leal	0x1(%rax), %ecx
180342204: 48 63 c9                    	movslq	%ecx, %rcx
180342207: 48 8d 1d c2 18 48 00        	leaq	0x4818c2(%rip), %rbx    # 0x1807c3ad0
18034220e: 8b 14 8b                    	movl	(%rbx,%rcx,4), %edx
180342211: 8d 88 fe 11 ba 74           	leal	0x74ba11fe(%rax), %ecx
180342217: d3 ca                       	rorl	%cl, %edx
180342219: d3 ca                       	rorl	%cl, %edx
18034221b: 81 f2 02 ee 45 8b           	xorl	$0x8b45ee02, %edx       # imm = 0x8B45EE02
180342221: d3 ca                       	rorl	%cl, %edx
180342223: b9 fc 11 ba 74              	movl	$0x74ba11fc, %ecx       # imm = 0x74BA11FC
180342228: 29 c1                       	subl	%eax, %ecx
18034222a: d3 c2                       	roll	%cl, %edx
18034222c: d3 c2                       	roll	%cl, %edx
18034222e: d3 c2                       	roll	%cl, %edx
180342230: 48 63 c2                    	movslq	%edx, %rax
180342233: 48 89 f1                    	movq	%rsi, %rcx
180342236: 4c 8d 2d 33 ba 47 00        	leaq	0x47ba33(%rip), %r13    # 0x1807bdc70
18034223d: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342242: 48 63 0d 4b 5f 48 00        	movslq	0x485f4b(%rip), %rcx    # 0x1807c8194
180342249: 8b 14 8f                    	movl	(%rdi,%rcx,4), %edx
18034224c: 81 c1 78 60 76 e5           	addl	$0xe5766078, %ecx       # imm = 0xE5766078
180342252: d3 ca                       	rorl	%cl, %edx
180342254: f7 d2                       	notl	%edx
180342256: d3 ca                       	rorl	%cl, %edx
180342258: 81 f2 78 60 76 e5           	xorl	$0xe5766078, %edx       # imm = 0xE5766078
18034225e: 4c 63 d2                    	movslq	%edx, %r10
180342261: 41 b9 99 4b e7 08           	movl	$0x8e74b99, %r9d        # imm = 0x8E74B99
180342267: 46 33 0c 93                 	xorl	(%rbx,%r10,4), %r9d
18034226b: 41 8d 92 66 b4 18 f7        	leal	-0x8e74b9a(%r10), %edx
180342272: 89 d1                       	movl	%edx, %ecx
180342274: 41 d3 c9                    	rorl	%cl, %r9d
180342277: 41 b8 66 b4 18 f7           	movl	$0xf718b466, %r8d       # imm = 0xF718B466
18034227d: 45 29 d0                    	subl	%r10d, %r8d
180342280: 44 89 c1                    	movl	%r8d, %ecx
180342283: 41 d3 c1                    	roll	%cl, %r9d
180342286: 89 d1                       	movl	%edx, %ecx
180342288: 41 d3 c9                    	rorl	%cl, %r9d
18034228b: 41 d3 c9                    	rorl	%cl, %r9d
18034228e: 44 89 c1                    	movl	%r8d, %ecx
180342291: 41 d3 c1                    	roll	%cl, %r9d
180342294: 49 89 c6                    	movq	%rax, %r14
180342297: 41 f7 d9                    	negl	%r9d
18034229a: 49 63 c1                    	movslq	%r9d, %rax
18034229d: 48 89 f1                    	movq	%rsi, %rcx
1803422a0: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803422a5: 48 ba 51 d8 54 f8 45 a0 cc 39       	movabsq	$0x39cca045f854d851, %rdx # imm = 0x39CCA045F854D851
1803422af: 48 33 15 e2 e6 46 00        	xorq	0x46e6e2(%rip), %rdx    # 0x1807b0998
1803422b6: 48 63 0d 73 50 47 00        	movslq	0x475073(%rip), %rcx    # 0x1807b7330
1803422bd: 4c 8d 05 64 5d 31 00        	leaq	0x315d64(%rip), %r8     # 0x180658028
1803422c4: 41 8b 0c 88                 	movl	(%r8,%rcx,4), %ecx
1803422c8: 0f c9                       	bswapl	%ecx
1803422ca: ff c9                       	decl	%ecx
1803422cc: 0f c9                       	bswapl	%ecx
1803422ce: 48 63 c9                    	movslq	%ecx, %rcx
1803422d1: 4c 8d 05 a8 46 47 00        	leaq	0x4746a8(%rip), %r8     # 0x1807b6980
1803422d8: 45 8b 04 88                 	movl	(%r8,%rcx,4), %r8d
1803422dc: 81 c1 b8 aa 3b 79           	addl	$0x793baab8, %ecx       # imm = 0x793BAAB8
1803422e2: 41 d3 c8                    	rorl	%cl, %r8d
1803422e5: 49 ba 48 d6 b4 cb 32 f6 a3 b6       	movabsq	$-0x495c09cd344b29b8, %r10 # imm = 0xB6A3F632CBB4D648
1803422ef: 41 f7 d8                    	negl	%r8d
1803422f2: 41 0f c8                    	bswapl	%r8d
1803422f5: 41 d3 c8                    	rorl	%cl, %r8d
1803422f8: 49 01 d2                    	addq	%rdx, %r10
1803422fb: 49 63 c8                    	movslq	%r8d, %rcx
1803422fe: 48 8d 15 cb 3a 47 00        	leaq	0x473acb(%rip), %rdx    # 0x1807b5dd0
180342305: 4c 8b 0c ca                 	movq	(%rdx,%rcx,8), %r9
180342309: 4c 89 54 24 20              	movq	%r10, 0x20(%rsp)
18034230e: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
180342315: 48 89 c2                    	movq	%rax, %rdx
180342318: 4d 89 f0                    	movq	%r14, %r8
18034231b: e8 30 36 0f 00              	callq	0x180435950 <.text+0x425950>
180342320: 48 63 15 a1 5e 48 00        	movslq	0x485ea1(%rip), %rdx    # 0x1807c81c8
180342327: 48 8d 35 52 6f 31 00        	leaq	0x316f52(%rip), %rsi    # 0x180659280
18034232e: 8b 04 96                    	movl	(%rsi,%rdx,4), %eax
180342331: b9 0b 00 00 00              	movl	$0xb, %ecx
180342336: 29 d1                       	subl	%edx, %ecx
180342338: d3 c0                       	roll	%cl, %eax
18034233a: f7 d0                       	notl	%eax
18034233c: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
18034233f: d3 c8                       	rorl	%cl, %eax
180342341: 89 c1                       	movl	%eax, %ecx
180342343: f7 d1                       	notl	%ecx
180342345: 48 63 c9                    	movslq	%ecx, %rcx
180342348: 48 8d 3d 81 17 48 00        	leaq	0x481781(%rip), %rdi    # 0x1807c3ad0
18034234f: 44 8b 04 8f                 	movl	(%rdi,%rcx,4), %r8d
180342353: 41 0f c8                    	bswapl	%r8d
180342356: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
18034235b: 29 c2                       	subl	%eax, %edx
18034235d: 89 d1                       	movl	%edx, %ecx
18034235f: 41 d3 c8                    	rorl	%cl, %r8d
180342362: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180342367: 89 c1                       	movl	%eax, %ecx
180342369: 41 d3 c0                    	roll	%cl, %r8d
18034236c: 89 d1                       	movl	%edx, %ecx
18034236e: 41 d3 c8                    	rorl	%cl, %r8d
180342371: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180342378: 41 ff c0                    	incl	%r8d
18034237b: 89 c1                       	movl	%eax, %ecx
18034237d: 41 d3 c0                    	roll	%cl, %r8d
180342380: 41 f7 d0                    	notl	%r8d
180342383: 49 63 c0                    	movslq	%r8d, %rax
180342386: 48 8d 8d 90 01 00 00        	leaq	0x190(%rbp), %rcx
18034238d: 4c 8d ad a0 0b 00 00        	leaq	0xba0(%rbp), %r13
180342394: 4c 89 ea                    	movq	%r13, %rdx
180342397: 48 8d 1d d2 b8 47 00        	leaq	0x47b8d2(%rip), %rbx    # 0x1807bdc70
18034239e: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803423a1: 48 63 05 0c 5e 48 00        	movslq	0x485e0c(%rip), %rax    # 0x1807c81b4
1803423a8: 8b 14 86                    	movl	(%rsi,%rax,4), %edx
1803423ab: b9 0a 00 00 00              	movl	$0xa, %ecx
1803423b0: 29 c1                       	subl	%eax, %ecx
1803423b2: d3 c2                       	roll	%cl, %edx
1803423b4: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803423ba: d3 ca                       	rorl	%cl, %edx
1803423bc: d3 ca                       	rorl	%cl, %edx
1803423be: d3 ca                       	rorl	%cl, %edx
1803423c0: 48 63 c2                    	movslq	%edx, %rax
1803423c3: 31 d2                       	xorl	%edx, %edx
1803423c5: 2b 14 87                    	subl	(%rdi,%rax,4), %edx
1803423c8: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803423ce: d3 ca                       	rorl	%cl, %edx
1803423d0: d3 ca                       	rorl	%cl, %edx
1803423d2: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803423d8: d3 ca                       	rorl	%cl, %edx
1803423da: 45 31 f6                    	xorl	%r14d, %r14d
1803423dd: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803423e2: 29 c1                       	subl	%eax, %ecx
1803423e4: d3 c2                       	roll	%cl, %edx
1803423e6: d3 c2                       	roll	%cl, %edx
1803423e8: 48 63 c2                    	movslq	%edx, %rax
1803423eb: 4c 89 e9                    	movq	%r13, %rcx
1803423ee: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803423f1: 48 63 05 80 5e 48 00        	movslq	0x485e80(%rip), %rax    # 0x1807c8278
1803423f8: 31 c9                       	xorl	%ecx, %ecx
1803423fa: 2b 0c 86                    	subl	(%rsi,%rax,4), %ecx
1803423fd: 0f c9                       	bswapl	%ecx
1803423ff: f7 d9                       	negl	%ecx
180342401: 81 f1 64 a7 63 90           	xorl	$0x9063a764, %ecx       # imm = 0x9063A764
180342407: 4c 63 c1                    	movslq	%ecx, %r8
18034240a: 46 8b 0c 87                 	movl	(%rdi,%r8,4), %r9d
18034240e: 41 8d 80 cb e2 dc a2        	leal	-0x5d231d35(%r8), %eax
180342415: 89 c1                       	movl	%eax, %ecx
180342417: 41 d3 c9                    	rorl	%cl, %r9d
18034241a: 41 ff c9                    	decl	%r9d
18034241d: 41 81 f1 cb e2 dc a2        	xorl	$0xa2dce2cb, %r9d       # imm = 0xA2DCE2CB
180342424: ba cb e2 dc a2              	movl	$0xa2dce2cb, %edx       # imm = 0xA2DCE2CB
180342429: 44 29 c2                    	subl	%r8d, %edx
18034242c: 89 d1                       	movl	%edx, %ecx
18034242e: 41 d3 c1                    	roll	%cl, %r9d
180342431: 89 c1                       	movl	%eax, %ecx
180342433: 41 d3 c9                    	rorl	%cl, %r9d
180342436: 89 d1                       	movl	%edx, %ecx
180342438: 41 d3 c1                    	roll	%cl, %r9d
18034243b: 41 d3 c1                    	roll	%cl, %r9d
18034243e: 49 63 c1                    	movslq	%r9d, %rax
180342441: 4c 8d ad a0 09 00 00        	leaq	0x9a0(%rbp), %r13
180342448: 4c 89 e9                    	movq	%r13, %rcx
18034244b: ff 14 c3                    	callq	*(%rbx,%rax,8)
18034244e: 48 63 05 63 5d 48 00        	movslq	0x485d63(%rip), %rax    # 0x1807c81b8
180342455: ba 2e eb e1 14              	movl	$0x14e1eb2e, %edx       # imm = 0x14E1EB2E
18034245a: 33 14 86                    	xorl	(%rsi,%rax,4), %edx
18034245d: 8d 48 0e                    	leal	0xe(%rax), %ecx
180342460: d3 ca                       	rorl	%cl, %edx
180342462: 48 63 c2                    	movslq	%edx, %rax
180342465: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180342469: 41 f7 d0                    	notl	%r8d
18034246c: ba 8d 1e df aa              	movl	$0xaadf1e8d, %edx       # imm = 0xAADF1E8D
180342471: 29 c2                       	subl	%eax, %edx
180342473: 89 d1                       	movl	%edx, %ecx
180342475: 41 d3 c0                    	roll	%cl, %r8d
180342478: 05 8d 1e df aa              	addl	$0xaadf1e8d, %eax       # imm = 0xAADF1E8D
18034247d: 89 c1                       	movl	%eax, %ecx
18034247f: 41 d3 c8                    	rorl	%cl, %r8d
180342482: 89 d1                       	movl	%edx, %ecx
180342484: 41 d3 c0                    	roll	%cl, %r8d
180342487: 41 d3 c0                    	roll	%cl, %r8d
18034248a: 41 f7 d0                    	notl	%r8d
18034248d: 41 d3 c0                    	roll	%cl, %r8d
180342490: 89 c1                       	movl	%eax, %ecx
180342492: 41 d3 c8                    	rorl	%cl, %r8d
180342495: 49 63 c0                    	movslq	%r8d, %rax
180342498: 4c 89 e9                    	movq	%r13, %rcx
18034249b: ff 14 c3                    	callq	*(%rbx,%rax,8)
18034249e: 48 89 85 20 06 00 00        	movq	%rax, 0x620(%rbp)
1803424a5: 8b 0d 6d e0 54 00           	movl	0x54e06d(%rip), %ecx    # 0x180890518
1803424ab: 83 c1 18                    	addl	$0x18, %ecx
1803424ae: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
1803424b3: d3 c8                       	rorl	%cl, %eax
1803424b5: 48 98                       	cltq
1803424b7: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803424ba: b9 07 00 00 00              	movl	$0x7, %ecx
1803424bf: 29 c1                       	subl	%eax, %ecx
1803424c1: d3 c2                       	roll	%cl, %edx
1803424c3: 0f ca                       	bswapl	%edx
1803424c5: 48 63 c2                    	movslq	%edx, %rax
1803424c8: 48 8b 04 c3                 	movq	(%rbx,%rax,8), %rax
1803424cc: c6 85 b1 0c 00 00 01        	movb	$0x1, 0xcb1(%rbp)
1803424d3: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
1803424da: 48 89 8d 58 0a 00 00        	movq	%rcx, 0xa58(%rbp)
1803424e1: 48 8d b5 80 08 00 00        	leaq	0x880(%rbp), %rsi
1803424e8: 48 8d 95 20 06 00 00        	leaq	0x620(%rbp), %rdx
1803424ef: 48 89 f1                    	movq	%rsi, %rcx
1803424f2: ff d0                       	callq	*%rax
1803424f4: 48 c7 85 90 08 00 00 00 00 00 00    	movq	$0x0, 0x890(%rbp)
1803424ff: 48 63 15 72 d5 54 00        	movslq	0x54d572(%rip), %rdx    # 0x18088fa78
180342506: 48 8d 05 1b 5b 31 00        	leaq	0x315b1b(%rip), %rax    # 0x180658028
18034250d: 44 2b 34 90                 	subl	(%rax,%rdx,4), %r14d
180342511: b8 4a 44 3a 89              	movl	$0x893a444a, %eax       # imm = 0x893A444A
180342516: 29 d0                       	subl	%edx, %eax
180342518: 89 c1                       	movl	%eax, %ecx
18034251a: 41 d3 c6                    	roll	%cl, %r14d
18034251d: 8d 4a 0a                    	leal	0xa(%rdx), %ecx
180342520: 41 d3 ce                    	rorl	%cl, %r14d
180342523: 89 c1                       	movl	%eax, %ecx
180342525: 41 d3 c6                    	roll	%cl, %r14d
180342528: 49 63 ce                    	movslq	%r14d, %rcx
18034252b: b8 61 76 2b 9a              	movl	$0x9a2b7661, %eax       # imm = 0x9A2B7661
180342530: 48 8d 15 49 44 47 00        	leaq	0x474449(%rip), %rdx    # 0x1807b6980
180342537: 33 04 8a                    	xorl	(%rdx,%rcx,4), %eax
18034253a: 0f c8                       	bswapl	%eax
18034253c: ff c1                       	incl	%ecx
18034253e: d3 c8                       	rorl	%cl, %eax
180342540: 4c 8d 85 98 08 00 00        	leaq	0x898(%rbp), %r8
180342547: f7 d8                       	negl	%eax
180342549: 48 98                       	cltq
18034254b: 48 8d 0d 7e 38 47 00        	leaq	0x47387e(%rip), %rcx    # 0x1807b5dd0
180342552: 48 8b 14 c1                 	movq	(%rcx,%rax,8), %rdx
180342556: 4c 89 c1                    	movq	%r8, %rcx
180342559: e8 32 91 ff ff              	callq	0x18033b690 <.text+0x32b690>
18034255e: 48 89 b5 90 02 00 00        	movq	%rsi, 0x290(%rbp)
180342565: 48 b8 86 35 99 e8 3b 15 78 14       	movabsq	$0x1478153be8993586, %rax # imm = 0x1478153BE8993586
18034256f: 48 33 05 12 e5 46 00        	xorq	0x46e512(%rip), %rax    # 0x1807b0a88
180342576: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
18034257a: 48 8d 04 c5 80 08 00 00     	leaq	0x880(,%rax,8), %rax
180342582: 48 01 e8                    	addq	%rbp, %rax
180342585: 48 b9 98 92 46 79 5f 98 91 d4       	movabsq	$-0x2b6e67a086b96d68, %rcx # imm = 0xD491985F79469298
18034258f: 48 01 c1                    	addq	%rax, %rcx
180342592: 48 89 8d 98 02 00 00        	movq	%rcx, 0x298(%rbp)
180342599: c6 85 b2 0c 00 00 01        	movb	$0x1, 0xcb2(%rbp)
1803425a0: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
1803425a7: 48 89 8d 60 0a 00 00        	movq	%rcx, 0xa60(%rbp)
1803425ae: 48 8d 95 90 02 00 00        	leaq	0x290(%rbp), %rdx
1803425b5: e8 66 dc fc ff              	callq	0x180310220 <.text+0x300220>
1803425ba: 48 63 05 bb 5c 48 00        	movslq	0x485cbb(%rip), %rax    # 0x1807c827c
1803425c1: 31 d2                       	xorl	%edx, %edx
1803425c3: 48 8d 3d b6 6c 31 00        	leaq	0x316cb6(%rip), %rdi    # 0x180659280
1803425ca: 2b 14 87                    	subl	(%rdi,%rax,4), %edx
1803425cd: b9 07 8e 67 5e              	movl	$0x5e678e07, %ecx       # imm = 0x5E678E07
1803425d2: 29 c1                       	subl	%eax, %ecx
1803425d4: d3 c2                       	roll	%cl, %edx
1803425d6: d3 c2                       	roll	%cl, %edx
1803425d8: 0f ca                       	bswapl	%edx
1803425da: 48 63 c2                    	movslq	%edx, %rax
1803425dd: 48 8d 1d ec 14 48 00        	leaq	0x4814ec(%rip), %rbx    # 0x1807c3ad0
1803425e4: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
1803425e7: ff ca                       	decl	%edx
1803425e9: b9 0b 00 00 00              	movl	$0xb, %ecx
1803425ee: 29 c1                       	subl	%eax, %ecx
1803425f0: d3 c2                       	roll	%cl, %edx
1803425f2: 81 f2 d4 47 64 9d           	xorl	$0x9d6447d4, %edx       # imm = 0x9D6447D4
1803425f8: 83 c0 0b                    	addl	$0xb, %eax
1803425fb: 89 c1                       	movl	%eax, %ecx
1803425fd: d3 ca                       	rorl	%cl, %edx
1803425ff: 48 8d b5 b8 0b 00 00        	leaq	0xbb8(%rbp), %rsi
180342606: 81 f2 62 9b b8 2b           	xorl	$0x2bb89b62, %edx       # imm = 0x2BB89B62
18034260c: 0f ca                       	bswapl	%edx
18034260e: 48 63 c2                    	movslq	%edx, %rax
180342611: 4c 8d b5 00 06 00 00        	leaq	0x600(%rbp), %r14
180342618: 4c 89 f1                    	movq	%r14, %rcx
18034261b: 4c 8d 2d 4e b6 47 00        	leaq	0x47b64e(%rip), %r13    # 0x1807bdc70
180342622: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342627: 48 63 05 6e 5b 48 00        	movslq	0x485b6e(%rip), %rax    # 0x1807c819c
18034262e: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180342631: 8d 48 12                    	leal	0x12(%rax), %ecx
180342634: d3 ca                       	rorl	%cl, %edx
180342636: f7 d2                       	notl	%edx
180342638: 48 63 c2                    	movslq	%edx, %rax
18034263b: 8b 04 83                    	movl	(%rbx,%rax,4), %eax
18034263e: f7 d0                       	notl	%eax
180342640: 0f c8                       	bswapl	%eax
180342642: 48 98                       	cltq
180342644: 4c 89 f1                    	movq	%r14, %rcx
180342647: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034264c: 48 89 85 40 06 00 00        	movq	%rax, 0x640(%rbp)
180342653: 8b 0d bf de 54 00           	movl	0x54debf(%rip), %ecx    # 0x180890518
180342659: 83 c1 18                    	addl	$0x18, %ecx
18034265c: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
180342661: d3 c8                       	rorl	%cl, %eax
180342663: 48 98                       	cltq
180342665: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180342668: b9 07 00 00 00              	movl	$0x7, %ecx
18034266d: 29 c1                       	subl	%eax, %ecx
18034266f: d3 c2                       	roll	%cl, %edx
180342671: 0f ca                       	bswapl	%edx
180342673: 48 63 c2                    	movslq	%edx, %rax
180342676: 49 8b 44 c5 00              	movq	(%r13,%rax,8), %rax
18034267b: c6 85 c0 0c 00 00 01        	movb	$0x1, 0xcc0(%rbp)
180342682: c6 85 bf 0c 00 00 00        	movb	$0x0, 0xcbf(%rbp)
180342689: 48 8d 8d f0 0a 00 00        	leaq	0xaf0(%rbp), %rcx
180342690: 48 89 8d c0 0a 00 00        	movq	%rcx, 0xac0(%rbp)
180342697: 48 89 b5 b8 0a 00 00        	movq	%rsi, 0xab8(%rbp)
18034269e: 48 8d 95 40 06 00 00        	leaq	0x640(%rbp), %rdx
1803426a5: ff d0                       	callq	*%rax
1803426a7: 48 c7 85 00 0b 00 00 00 00 00 00    	movq	$0x0, 0xb00(%rbp)
1803426b2: 48 8d 8d 08 0b 00 00        	leaq	0xb08(%rbp), %rcx
1803426b9: c6 85 c0 0c 00 00 01        	movb	$0x1, 0xcc0(%rbp)
1803426c0: c6 85 bf 0c 00 00 00        	movb	$0x0, 0xcbf(%rbp)
1803426c7: 48 89 8d c0 0a 00 00        	movq	%rcx, 0xac0(%rbp)
1803426ce: 48 89 b5 b8 0a 00 00        	movq	%rsi, 0xab8(%rbp)
1803426d5: 48 8d 95 e0 06 00 00        	leaq	0x6e0(%rbp), %rdx
1803426dc: e8 bf 9e ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
1803426e1: 48 8d 85 f0 0a 00 00        	leaq	0xaf0(%rbp), %rax
1803426e8: 48 89 85 a0 02 00 00        	movq	%rax, 0x2a0(%rbp)
1803426ef: 48 b8 56 15 f9 5e 9c 04 a8 1d       	movabsq	$0x1da8049c5ef91556, %rax # imm = 0x1DA8049C5EF91556
1803426f9: 48 33 05 a0 e3 46 00        	xorq	0x46e3a0(%rip), %rax    # 0x1807b0aa0
180342700: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342704: 48 8d 04 c5 f0 0a 00 00     	leaq	0xaf0(,%rax,8), %rax
18034270c: 48 01 e8                    	addq	%rbp, %rax
18034270f: 48 b9 30 c2 9d 20 09 ae 08 02       	movabsq	$0x208ae09209dc230, %rcx # imm = 0x208AE09209DC230
180342719: 48 01 c1                    	addq	%rax, %rcx
18034271c: 48 89 8d a8 02 00 00        	movq	%rcx, 0x2a8(%rbp)
180342723: c6 85 b3 0c 00 00 01        	movb	$0x1, 0xcb3(%rbp)
18034272a: 48 89 b5 68 0a 00 00        	movq	%rsi, 0xa68(%rbp)
180342731: 48 8d 95 a0 02 00 00        	leaq	0x2a0(%rbp), %rdx
180342738: 48 89 f1                    	movq	%rsi, %rcx
18034273b: e8 e0 da fc ff              	callq	0x180310220 <.text+0x300220>
180342740: 48 63 15 25 5b 48 00        	movslq	0x485b25(%rip), %rdx    # 0x1807c826c
180342747: 48 8d 3d 32 6b 31 00        	leaq	0x316b32(%rip), %rdi    # 0x180659280
18034274e: 8b 04 97                    	movl	(%rdi,%rdx,4), %eax
180342751: 8d 4a 18                    	leal	0x18(%rdx), %ecx
180342754: d3 c8                       	rorl	%cl, %eax
180342756: 0f c8                       	bswapl	%eax
180342758: b9 18 00 00 00              	movl	$0x18, %ecx
18034275d: 29 d1                       	subl	%edx, %ecx
18034275f: d3 c0                       	roll	%cl, %eax
180342761: 89 c1                       	movl	%eax, %ecx
180342763: f7 d1                       	notl	%ecx
180342765: 48 63 c9                    	movslq	%ecx, %rcx
180342768: ba cb cb 25 63              	movl	$0x6325cbcb, %edx       # imm = 0x6325CBCB
18034276d: 48 8d 1d 5c 13 48 00        	leaq	0x48135c(%rip), %rbx    # 0x1807c3ad0
180342774: 33 14 8b                    	xorl	(%rbx,%rcx,4), %edx
180342777: 0f ca                       	bswapl	%edx
180342779: f7 da                       	negl	%edx
18034277b: 83 c0 04                    	addl	$0x4, %eax
18034277e: 89 c1                       	movl	%eax, %ecx
180342780: d3 c2                       	roll	%cl, %edx
180342782: 48 8d b5 d0 0b 00 00        	leaq	0xbd0(%rbp), %rsi
180342789: ff c2                       	incl	%edx
18034278b: 48 63 c2                    	movslq	%edx, %rax
18034278e: 4c 8d b5 60 09 00 00        	leaq	0x960(%rbp), %r14
180342795: 4c 89 f1                    	movq	%r14, %rcx
180342798: 4c 8d 2d d1 b4 47 00        	leaq	0x47b4d1(%rip), %r13    # 0x1807bdc70
18034279f: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803427a4: 48 63 0d 05 5a 48 00        	movslq	0x485a05(%rip), %rcx    # 0x1807c81b0
1803427ab: b8 e5 6c 5a 59              	movl	$0x595a6ce5, %eax       # imm = 0x595A6CE5
1803427b0: 33 04 8f                    	xorl	(%rdi,%rcx,4), %eax
1803427b3: ff c0                       	incl	%eax
1803427b5: 83 c1 1a                    	addl	$0x1a, %ecx
1803427b8: d3 c8                       	rorl	%cl, %eax
1803427ba: 89 c1                       	movl	%eax, %ecx
1803427bc: f7 d1                       	notl	%ecx
1803427be: 48 63 d1                    	movslq	%ecx, %rdx
1803427c1: 8b 14 93                    	movl	(%rbx,%rdx,4), %edx
1803427c4: ff ca                       	decl	%edx
1803427c6: d3 ca                       	rorl	%cl, %edx
1803427c8: f7 da                       	negl	%edx
1803427ca: ff c0                       	incl	%eax
1803427cc: 89 c1                       	movl	%eax, %ecx
1803427ce: d3 c2                       	roll	%cl, %edx
1803427d0: f7 da                       	negl	%edx
1803427d2: 81 f2 df 30 83 80           	xorl	$0x808330df, %edx       # imm = 0x808330DF
1803427d8: 0f ca                       	bswapl	%edx
1803427da: 48 63 c2                    	movslq	%edx, %rax
1803427dd: 4c 89 f1                    	movq	%r14, %rcx
1803427e0: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803427e5: 48 89 85 60 06 00 00        	movq	%rax, 0x660(%rbp)
1803427ec: 8b 0d 26 dd 54 00           	movl	0x54dd26(%rip), %ecx    # 0x180890518
1803427f2: 83 c1 18                    	addl	$0x18, %ecx
1803427f5: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
1803427fa: d3 c8                       	rorl	%cl, %eax
1803427fc: 48 98                       	cltq
1803427fe: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180342801: b9 07 00 00 00              	movl	$0x7, %ecx
180342806: 29 c1                       	subl	%eax, %ecx
180342808: d3 c2                       	roll	%cl, %edx
18034280a: 0f ca                       	bswapl	%edx
18034280c: 48 63 c2                    	movslq	%edx, %rax
18034280f: 49 8b 44 c5 00              	movq	(%r13,%rax,8), %rax
180342814: c6 85 c2 0c 00 00 01        	movb	$0x1, 0xcc2(%rbp)
18034281b: c6 85 c1 0c 00 00 00        	movb	$0x0, 0xcc1(%rbp)
180342822: 48 8d 8d 50 0c 00 00        	leaq	0xc50(%rbp), %rcx
180342829: 48 89 8d d0 0a 00 00        	movq	%rcx, 0xad0(%rbp)
180342830: 48 89 b5 c8 0a 00 00        	movq	%rsi, 0xac8(%rbp)
180342837: 48 8d 95 60 06 00 00        	leaq	0x660(%rbp), %rdx
18034283e: ff d0                       	callq	*%rax
180342840: 48 c7 85 60 0c 00 00 00 00 00 00    	movq	$0x0, 0xc60(%rbp)
18034284b: 48 8d 8d 68 0c 00 00        	leaq	0xc68(%rbp), %rcx
180342852: c6 85 c2 0c 00 00 01        	movb	$0x1, 0xcc2(%rbp)
180342859: c6 85 c1 0c 00 00 00        	movb	$0x0, 0xcc1(%rbp)
180342860: 48 89 8d d0 0a 00 00        	movq	%rcx, 0xad0(%rbp)
180342867: 48 89 b5 c8 0a 00 00        	movq	%rsi, 0xac8(%rbp)
18034286e: 48 8d 95 f0 09 00 00        	leaq	0x9f0(%rbp), %rdx
180342875: e8 26 9d ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
18034287a: 48 8d 85 50 0c 00 00        	leaq	0xc50(%rbp), %rax
180342881: 48 89 85 b0 02 00 00        	movq	%rax, 0x2b0(%rbp)
180342888: 48 b8 78 c6 8f 28 81 71 39 1e       	movabsq	$0x1e397181288fc678, %rax # imm = 0x1E397181288FC678
180342892: 48 33 05 17 e2 46 00        	xorq	0x46e217(%rip), %rax    # 0x1807b0ab0
180342899: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
18034289d: 48 8d 04 c5 50 0c 00 00     	leaq	0xc50(,%rax,8), %rax
1803428a5: 48 01 e8                    	addq	%rbp, %rax
1803428a8: 48 b9 30 93 a5 b6 d8 34 e1 7b       	movabsq	$0x7be134d8b6a59330, %rcx # imm = 0x7BE134D8B6A59330
1803428b2: 48 01 c1                    	addq	%rax, %rcx
1803428b5: 48 89 8d b8 02 00 00        	movq	%rcx, 0x2b8(%rbp)
1803428bc: c6 85 b4 0c 00 00 01        	movb	$0x1, 0xcb4(%rbp)
1803428c3: 48 89 b5 70 0a 00 00        	movq	%rsi, 0xa70(%rbp)
1803428ca: 48 8d 95 b0 02 00 00        	leaq	0x2b0(%rbp), %rdx
1803428d1: 48 89 f1                    	movq	%rsi, %rcx
1803428d4: e8 47 d9 fc ff              	callq	0x180310220 <.text+0x300220>
1803428d9: 48 63 05 90 59 48 00        	movslq	0x485990(%rip), %rax    # 0x1807c8270
1803428e0: ba ce c0 9b d2              	movl	$0xd29bc0ce, %edx       # imm = 0xD29BC0CE
1803428e5: 48 8d 3d 94 69 31 00        	leaq	0x316994(%rip), %rdi    # 0x180659280
1803428ec: 33 14 87                    	xorl	(%rdi,%rax,4), %edx
1803428ef: 8d 48 0e                    	leal	0xe(%rax), %ecx
1803428f2: d3 ca                       	rorl	%cl, %edx
1803428f4: f7 d2                       	notl	%edx
1803428f6: 0f ca                       	bswapl	%edx
1803428f8: 48 63 c2                    	movslq	%edx, %rax
1803428fb: 48 8d 1d ce 11 48 00        	leaq	0x4811ce(%rip), %rbx    # 0x1807c3ad0
180342902: 44 8b 04 83                 	movl	(%rbx,%rax,4), %r8d
180342906: 41 ff c8                    	decl	%r8d
180342909: 41 81 f0 8d 36 29 db        	xorl	$0xdb29368d, %r8d       # imm = 0xDB29368D
180342910: ba 8d 36 29 db              	movl	$0xdb29368d, %edx       # imm = 0xDB29368D
180342915: 29 c2                       	subl	%eax, %edx
180342917: 89 d1                       	movl	%edx, %ecx
180342919: 41 d3 c0                    	roll	%cl, %r8d
18034291c: 41 d3 c0                    	roll	%cl, %r8d
18034291f: 83 c0 0d                    	addl	$0xd, %eax
180342922: 89 c1                       	movl	%eax, %ecx
180342924: 41 d3 c8                    	rorl	%cl, %r8d
180342927: 48 8d b5 e8 0b 00 00        	leaq	0xbe8(%rbp), %rsi
18034292e: 41 f7 d0                    	notl	%r8d
180342931: 89 d1                       	movl	%edx, %ecx
180342933: 41 d3 c0                    	roll	%cl, %r8d
180342936: 49 63 c0                    	movslq	%r8d, %rax
180342939: 4c 8d b5 40 04 00 00        	leaq	0x440(%rbp), %r14
180342940: 4c 89 f1                    	movq	%r14, %rcx
180342943: 4c 8d 2d 26 b3 47 00        	leaq	0x47b326(%rip), %r13    # 0x1807bdc70
18034294a: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034294f: 48 63 0d 66 58 48 00        	movslq	0x485866(%rip), %rcx    # 0x1807c81bc
180342956: b8 e5 6c 5a 59              	movl	$0x595a6ce5, %eax       # imm = 0x595A6CE5
18034295b: 33 04 8f                    	xorl	(%rdi,%rcx,4), %eax
18034295e: ff c0                       	incl	%eax
180342960: 83 c1 1a                    	addl	$0x1a, %ecx
180342963: d3 c8                       	rorl	%cl, %eax
180342965: 89 c1                       	movl	%eax, %ecx
180342967: f7 d1                       	notl	%ecx
180342969: 48 63 d1                    	movslq	%ecx, %rdx
18034296c: 8b 14 93                    	movl	(%rbx,%rdx,4), %edx
18034296f: ff ca                       	decl	%edx
180342971: d3 ca                       	rorl	%cl, %edx
180342973: f7 da                       	negl	%edx
180342975: ff c0                       	incl	%eax
180342977: 89 c1                       	movl	%eax, %ecx
180342979: d3 c2                       	roll	%cl, %edx
18034297b: f7 da                       	negl	%edx
18034297d: 81 f2 df 30 83 80           	xorl	$0x808330df, %edx       # imm = 0x808330DF
180342983: 0f ca                       	bswapl	%edx
180342985: 48 63 c2                    	movslq	%edx, %rax
180342988: 4c 89 f1                    	movq	%r14, %rcx
18034298b: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342990: 48 89 85 b0 07 00 00        	movq	%rax, 0x7b0(%rbp)
180342997: 8b 0d 7b db 54 00           	movl	0x54db7b(%rip), %ecx    # 0x180890518
18034299d: 83 c1 18                    	addl	$0x18, %ecx
1803429a0: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
1803429a5: d3 c8                       	rorl	%cl, %eax
1803429a7: 48 98                       	cltq
1803429a9: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
1803429ac: b9 07 00 00 00              	movl	$0x7, %ecx
1803429b1: 29 c1                       	subl	%eax, %ecx
1803429b3: d3 c2                       	roll	%cl, %edx
1803429b5: 0f ca                       	bswapl	%edx
1803429b7: 48 63 c2                    	movslq	%edx, %rax
1803429ba: 49 8b 44 c5 00              	movq	(%r13,%rax,8), %rax
1803429bf: c6 85 c4 0c 00 00 01        	movb	$0x1, 0xcc4(%rbp)
1803429c6: c6 85 c3 0c 00 00 00        	movb	$0x0, 0xcc3(%rbp)
1803429cd: 48 8d 8d 70 0b 00 00        	leaq	0xb70(%rbp), %rcx
1803429d4: 48 89 8d e0 0a 00 00        	movq	%rcx, 0xae0(%rbp)
1803429db: 48 89 b5 d8 0a 00 00        	movq	%rsi, 0xad8(%rbp)
1803429e2: 48 8d 95 b0 07 00 00        	leaq	0x7b0(%rbp), %rdx
1803429e9: ff d0                       	callq	*%rax
1803429eb: 48 c7 85 80 0b 00 00 00 00 00 00    	movq	$0x0, 0xb80(%rbp)
1803429f6: 48 8d 8d 88 0b 00 00        	leaq	0xb88(%rbp), %rcx
1803429fd: c6 85 c4 0c 00 00 01        	movb	$0x1, 0xcc4(%rbp)
180342a04: c6 85 c3 0c 00 00 00        	movb	$0x0, 0xcc3(%rbp)
180342a0b: 48 89 8d e0 0a 00 00        	movq	%rcx, 0xae0(%rbp)
180342a12: 48 89 b5 d8 0a 00 00        	movq	%rsi, 0xad8(%rbp)
180342a19: 48 8d 95 00 07 00 00        	leaq	0x700(%rbp), %rdx
180342a20: e8 7b 9b ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
180342a25: 48 8d 85 70 0b 00 00        	leaq	0xb70(%rbp), %rax
180342a2c: 48 89 85 c0 02 00 00        	movq	%rax, 0x2c0(%rbp)
180342a33: 48 b8 bf 5d 3a 82 4f bf ad 1f       	movabsq	$0x1fadbf4f823a5dbf, %rax # imm = 0x1FADBF4F823A5DBF
180342a3d: 48 33 05 34 e0 46 00        	xorq	0x46e034(%rip), %rax    # 0x1807b0a78
180342a44: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342a48: 48 8d 04 c5 70 0b 00 00     	leaq	0xb70(,%rax,8), %rax
180342a50: 48 01 e8                    	addq	%rbp, %rax
180342a53: 48 b9 70 70 79 fc 9a 39 51 b7       	movabsq	$-0x48aec66503868f90, %rcx # imm = 0xB751399AFC797070
180342a5d: 48 01 c1                    	addq	%rax, %rcx
180342a60: 48 89 8d c8 02 00 00        	movq	%rcx, 0x2c8(%rbp)
180342a67: c6 85 b5 0c 00 00 01        	movb	$0x1, 0xcb5(%rbp)
180342a6e: 48 89 b5 78 0a 00 00        	movq	%rsi, 0xa78(%rbp)
180342a75: 48 8d 95 c0 02 00 00        	leaq	0x2c0(%rbp), %rdx
180342a7c: 48 89 f1                    	movq	%rsi, %rcx
180342a7f: e8 9c d7 fc ff              	callq	0x180310220 <.text+0x300220>
180342a84: 48 63 05 f5 57 48 00        	movslq	0x4857f5(%rip), %rax    # 0x1807c8280
180342a8b: 48 8d 3d ee 67 31 00        	leaq	0x3167ee(%rip), %rdi    # 0x180659280
180342a92: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180342a95: ff c2                       	incl	%edx
180342a97: 81 f2 76 70 19 f6           	xorl	$0xf6197076, %edx       # imm = 0xF6197076
180342a9d: b9 16 00 00 00              	movl	$0x16, %ecx
180342aa2: 29 c1                       	subl	%eax, %ecx
180342aa4: d3 c2                       	roll	%cl, %edx
180342aa6: 48 63 c2                    	movslq	%edx, %rax
180342aa9: 48 8d 1d 20 10 48 00        	leaq	0x481020(%rip), %rbx    # 0x1807c3ad0
180342ab0: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180342ab3: 8d 88 3d 50 34 49           	leal	0x4934503d(%rax), %ecx
180342ab9: d3 ca                       	rorl	%cl, %edx
180342abb: ff c2                       	incl	%edx
180342abd: d3 ca                       	rorl	%cl, %edx
180342abf: 0f ca                       	bswapl	%edx
180342ac1: b9 1d 00 00 00              	movl	$0x1d, %ecx
180342ac6: 29 c1                       	subl	%eax, %ecx
180342ac8: d3 c2                       	roll	%cl, %edx
180342aca: ff c2                       	incl	%edx
180342acc: 48 63 c2                    	movslq	%edx, %rax
180342acf: 48 8d b5 60 04 00 00        	leaq	0x460(%rbp), %rsi
180342ad6: 48 89 f1                    	movq	%rsi, %rcx
180342ad9: 4c 8d 35 90 b1 47 00        	leaq	0x47b190(%rip), %r14    # 0x1807bdc70
180342ae0: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180342ae4: 48 63 05 d9 56 48 00        	movslq	0x4856d9(%rip), %rax    # 0x1807c81c4
180342aeb: 8b 04 87                    	movl	(%rdi,%rax,4), %eax
180342aee: 8d 48 01                    	leal	0x1(%rax), %ecx
180342af1: 48 63 c9                    	movslq	%ecx, %rcx
180342af4: ba 69 dd 03 06              	movl	$0x603dd69, %edx        # imm = 0x603DD69
180342af9: 33 14 8b                    	xorl	(%rbx,%rcx,4), %edx
180342afc: ff ca                       	decl	%edx
180342afe: 0f ca                       	bswapl	%edx
180342b00: b9 08 00 00 00              	movl	$0x8, %ecx
180342b05: 29 c1                       	subl	%eax, %ecx
180342b07: d3 c2                       	roll	%cl, %edx
180342b09: 0f ca                       	bswapl	%edx
180342b0b: 48 63 c2                    	movslq	%edx, %rax
180342b0e: 48 89 f1                    	movq	%rsi, %rcx
180342b11: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180342b15: 48 89 85 d0 07 00 00        	movq	%rax, 0x7d0(%rbp)
180342b1c: 8b 0d f6 d9 54 00           	movl	0x54d9f6(%rip), %ecx    # 0x180890518
180342b22: 83 c1 18                    	addl	$0x18, %ecx
180342b25: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
180342b2a: d3 c8                       	rorl	%cl, %eax
180342b2c: 48 98                       	cltq
180342b2e: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180342b31: b9 07 00 00 00              	movl	$0x7, %ecx
180342b36: 29 c1                       	subl	%eax, %ecx
180342b38: d3 c2                       	roll	%cl, %edx
180342b3a: 0f ca                       	bswapl	%edx
180342b3c: 48 63 c2                    	movslq	%edx, %rax
180342b3f: 49 8b 04 c6                 	movq	(%r14,%rax,8), %rax
180342b43: c6 85 c6 0c 00 00 01        	movb	$0x1, 0xcc6(%rbp)
180342b4a: c6 85 c5 0c 00 00 00        	movb	$0x0, 0xcc5(%rbp)
180342b51: 48 8d 8d 20 0b 00 00        	leaq	0xb20(%rbp), %rcx
180342b58: 48 89 8d e8 0a 00 00        	movq	%rcx, 0xae8(%rbp)
180342b5f: 48 8d 95 d0 07 00 00        	leaq	0x7d0(%rbp), %rdx
180342b66: ff d0                       	callq	*%rax
180342b68: 48 c7 85 30 0b 00 00 00 00 00 00    	movq	$0x0, 0xb30(%rbp)
180342b73: 48 8d 8d 38 0b 00 00        	leaq	0xb38(%rbp), %rcx
180342b7a: c6 85 c6 0c 00 00 01        	movb	$0x1, 0xcc6(%rbp)
180342b81: c6 85 c5 0c 00 00 00        	movb	$0x0, 0xcc5(%rbp)
180342b88: 48 89 8d e8 0a 00 00        	movq	%rcx, 0xae8(%rbp)
180342b8f: 48 8d 95 90 01 00 00        	leaq	0x190(%rbp), %rdx
180342b96: e8 05 9a ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
180342b9b: 48 8d 85 20 0b 00 00        	leaq	0xb20(%rbp), %rax
180342ba2: 48 89 85 d0 02 00 00        	movq	%rax, 0x2d0(%rbp)
180342ba9: 48 b8 c9 9d 29 61 02 56 75 1e       	movabsq	$0x1e75560261299dc9, %rax # imm = 0x1E75560261299DC9
180342bb3: 48 33 05 d6 de 46 00        	xorq	0x46ded6(%rip), %rax    # 0x1807b0a90
180342bba: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342bbe: 48 8d 04 c5 20 0b 00 00     	leaq	0xb20(,%rax,8), %rax
180342bc6: 48 01 e8                    	addq	%rbp, %rax
180342bc9: 48 b9 78 07 9b 4b ce fe 8d 82       	movabsq	$-0x7d720131b464f888, %rcx # imm = 0x828DFECE4B9B0778
180342bd3: 48 01 c1                    	addq	%rax, %rcx
180342bd6: 48 89 8d d8 02 00 00        	movq	%rcx, 0x2d8(%rbp)
180342bdd: c6 85 b6 0c 00 00 01        	movb	$0x1, 0xcb6(%rbp)
180342be4: 48 8d 95 d0 02 00 00        	leaq	0x2d0(%rbp), %rdx
180342beb: 48 8d 8d 00 0c 00 00        	leaq	0xc00(%rbp), %rcx
180342bf2: e8 29 d6 fc ff              	callq	0x180310220 <.text+0x300220>
180342bf7: 48 8d 85 a0 0b 00 00        	leaq	0xba0(%rbp), %rax
180342bfe: 48 89 85 80 02 00 00        	movq	%rax, 0x280(%rbp)
180342c05: 48 b8 48 d6 f8 95 ea cf 99 0d       	movabsq	$0xd99cfea95f8d648, %rax # imm = 0xD99CFEA95F8D648
180342c0f: 48 33 05 aa de 46 00        	xorq	0x46deaa(%rip), %rax    # 0x1807b0ac0
180342c16: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342c1a: 48 8d 04 c5 a0 0b 00 00     	leaq	0xba0(,%rax,8), %rax
180342c22: 48 01 e8                    	addq	%rbp, %rax
180342c25: 48 b9 38 1a 52 39 53 a8 1e 29       	movabsq	$0x291ea85339521a38, %rcx # imm = 0x291EA85339521A38
180342c2f: 48 01 c1                    	addq	%rax, %rcx
180342c32: 48 89 8d 88 02 00 00        	movq	%rcx, 0x288(%rbp)
180342c39: 44 0f b6 0d 50 dd 46 00     	movzbl	0x46dd50(%rip), %r9d    # 0x1807b0991
180342c41: 41 80 f1 a8                 	xorb	$-0x58, %r9b
180342c45: 41 80 c1 92                 	addb	$-0x6e, %r9b
180342c49: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180342c50: 48 8d 95 80 02 00 00        	leaq	0x280(%rbp), %rdx
180342c57: 41 b0 01                    	movb	$0x1, %r8b
180342c5a: e8 11 d7 fc ff              	callq	0x180310370 <.text+0x300370>
180342c5f: b8 76 7b 8f 72              	movl	$0x728f7b76, %eax       # imm = 0x728F7B76
180342c64: 33 05 3e de 46 00           	xorl	0x46de3e(%rip), %eax    # 0x1807b0aa8
180342c6a: 05 36 cb 47 9d              	addl	$0x9d47cb36, %eax       # imm = 0x9D47CB36
180342c6f: 48 98                       	cltq
180342c71: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342c75: 48 8d 34 c5 a0 0b 00 00     	leaq	0xba0(,%rax,8), %rsi
180342c7d: 48 01 ee                    	addq	%rbp, %rsi
180342c80: 41 be 60 00 00 00           	movl	$0x60, %r14d
180342c86: 4c 8d 2d e3 af 47 00        	leaq	0x47afe3(%rip), %r13    # 0x1807bdc70
180342c8d: 48 8d 1d 3c 0e 48 00        	leaq	0x480e3c(%rip), %rbx    # 0x1807c3ad0
180342c94: 48 8d 3d e5 65 31 00        	leaq	0x3165e5(%rip), %rdi    # 0x180659280
180342c9b: 0f 1f 44 00 00              	nopl	(%rax,%rax)
180342ca0: 48 63 05 95 56 48 00        	movslq	0x485695(%rip), %rax    # 0x1807c833c
180342ca7: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180342cab: 41 8d 40 01                 	leal	0x1(%r8), %eax
180342caf: 48 98                       	cltq
180342cb1: 44 8b 0c 83                 	movl	(%rbx,%rax,4), %r9d
180342cb5: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180342cbc: 89 c1                       	movl	%eax, %ecx
180342cbe: 41 d3 c9                    	rorl	%cl, %r9d
180342cc1: 41 0f c9                    	bswapl	%r9d
180342cc4: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180342cc9: 44 29 c2                    	subl	%r8d, %edx
180342ccc: 89 d1                       	movl	%edx, %ecx
180342cce: 41 d3 c1                    	roll	%cl, %r9d
180342cd1: 89 c1                       	movl	%eax, %ecx
180342cd3: 41 d3 c9                    	rorl	%cl, %r9d
180342cd6: 4e 8d 04 36                 	leaq	(%rsi,%r14), %r8
180342cda: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180342ce1: 41 d3 c9                    	rorl	%cl, %r9d
180342ce4: 89 d1                       	movl	%edx, %ecx
180342ce6: 41 d3 c1                    	roll	%cl, %r9d
180342ce9: 41 d3 c1                    	roll	%cl, %r9d
180342cec: 49 63 c1                    	movslq	%r9d, %rax
180342cef: 4c 89 c1                    	movq	%r8, %rcx
180342cf2: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342cf7: 49 83 c6 e8                 	addq	$-0x18, %r14
180342cfb: 49 83 fe e8                 	cmpq	$-0x18, %r14
180342cff: 75 9f                       	jne	0x180342ca0 <.text+0x332ca0>
180342d01: b8 a9 a4 44 a4              	movl	$0xa444a4a9, %eax       # imm = 0xA444A4A9
180342d06: 33 05 c4 dd 46 00           	xorl	0x46ddc4(%rip), %eax    # 0x1807b0ad0
180342d0c: 05 da c5 c5 61              	addl	$0x61c5c5da, %eax       # imm = 0x61C5C5DA
180342d11: 48 98                       	cltq
180342d13: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342d17: 48 8d 34 c5 20 0b 00 00     	leaq	0xb20(,%rax,8), %rsi
180342d1f: 48 01 ee                    	addq	%rbp, %rsi
180342d22: 41 be 18 00 00 00           	movl	$0x18, %r14d
180342d28: 0f 1f 84 00 00 00 00 00     	nopl	(%rax,%rax)
180342d30: 48 63 05 d5 55 48 00        	movslq	0x4855d5(%rip), %rax    # 0x1807c830c
180342d37: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180342d3b: 41 8d 40 01                 	leal	0x1(%r8), %eax
180342d3f: 48 98                       	cltq
180342d41: 44 8b 0c 83                 	movl	(%rbx,%rax,4), %r9d
180342d45: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180342d4c: 89 c1                       	movl	%eax, %ecx
180342d4e: 41 d3 c9                    	rorl	%cl, %r9d
180342d51: 41 0f c9                    	bswapl	%r9d
180342d54: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180342d59: 44 29 c2                    	subl	%r8d, %edx
180342d5c: 89 d1                       	movl	%edx, %ecx
180342d5e: 41 d3 c1                    	roll	%cl, %r9d
180342d61: 89 c1                       	movl	%eax, %ecx
180342d63: 41 d3 c9                    	rorl	%cl, %r9d
180342d66: 4e 8d 04 36                 	leaq	(%rsi,%r14), %r8
180342d6a: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180342d71: 41 d3 c9                    	rorl	%cl, %r9d
180342d74: 89 d1                       	movl	%edx, %ecx
180342d76: 41 d3 c1                    	roll	%cl, %r9d
180342d79: 41 d3 c1                    	roll	%cl, %r9d
180342d7c: 49 63 c1                    	movslq	%r9d, %rax
180342d7f: 4c 89 c1                    	movq	%r8, %rcx
180342d82: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342d87: 49 83 c6 e8                 	addq	$-0x18, %r14
180342d8b: 49 83 fe e8                 	cmpq	$-0x18, %r14
180342d8f: 75 9f                       	jne	0x180342d30 <.text+0x332d30>
180342d91: b8 de b1 45 c5              	movl	$0xc545b1de, %eax       # imm = 0xC545B1DE
180342d96: 33 05 fc dc 46 00           	xorl	0x46dcfc(%rip), %eax    # 0x1807b0a98
180342d9c: 05 a4 cb 7e 65              	addl	$0x657ecba4, %eax       # imm = 0x657ECBA4
180342da1: 48 98                       	cltq
180342da3: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342da7: 48 8d 34 c5 70 0b 00 00     	leaq	0xb70(,%rax,8), %rsi
180342daf: 48 01 ee                    	addq	%rbp, %rsi
180342db2: 41 be 18 00 00 00           	movl	$0x18, %r14d
180342db8: 0f 1f 84 00 00 00 00 00     	nopl	(%rax,%rax)
180342dc0: 48 63 05 3d 55 48 00        	movslq	0x48553d(%rip), %rax    # 0x1807c8304
180342dc7: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180342dcb: 41 8d 40 01                 	leal	0x1(%r8), %eax
180342dcf: 48 98                       	cltq
180342dd1: 44 8b 0c 83                 	movl	(%rbx,%rax,4), %r9d
180342dd5: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180342ddc: 89 c1                       	movl	%eax, %ecx
180342dde: 41 d3 c9                    	rorl	%cl, %r9d
180342de1: 41 0f c9                    	bswapl	%r9d
180342de4: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180342de9: 44 29 c2                    	subl	%r8d, %edx
180342dec: 89 d1                       	movl	%edx, %ecx
180342dee: 41 d3 c1                    	roll	%cl, %r9d
180342df1: 89 c1                       	movl	%eax, %ecx
180342df3: 41 d3 c9                    	rorl	%cl, %r9d
180342df6: 4e 8d 04 36                 	leaq	(%rsi,%r14), %r8
180342dfa: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180342e01: 41 d3 c9                    	rorl	%cl, %r9d
180342e04: 89 d1                       	movl	%edx, %ecx
180342e06: 41 d3 c1                    	roll	%cl, %r9d
180342e09: 41 d3 c1                    	roll	%cl, %r9d
180342e0c: 49 63 c1                    	movslq	%r9d, %rax
180342e0f: 4c 89 c1                    	movq	%r8, %rcx
180342e12: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342e17: 49 83 c6 e8                 	addq	$-0x18, %r14
180342e1b: 49 83 fe e8                 	cmpq	$-0x18, %r14
180342e1f: 75 9f                       	jne	0x180342dc0 <.text+0x332dc0>
180342e21: b8 31 6f 60 71              	movl	$0x71606f31, %eax       # imm = 0x71606F31
180342e26: 33 05 8c dc 46 00           	xorl	0x46dc8c(%rip), %eax    # 0x1807b0ab8
180342e2c: 05 ac e5 64 95              	addl	$0x9564e5ac, %eax       # imm = 0x9564E5AC
180342e31: 48 98                       	cltq
180342e33: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342e37: 48 8d 34 c5 50 0c 00 00     	leaq	0xc50(,%rax,8), %rsi
180342e3f: 48 01 ee                    	addq	%rbp, %rsi
180342e42: 41 be 18 00 00 00           	movl	$0x18, %r14d
180342e48: 0f 1f 84 00 00 00 00 00     	nopl	(%rax,%rax)
180342e50: 48 63 05 d5 54 48 00        	movslq	0x4854d5(%rip), %rax    # 0x1807c832c
180342e57: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180342e5b: 41 8d 40 01                 	leal	0x1(%r8), %eax
180342e5f: 48 98                       	cltq
180342e61: 44 8b 0c 83                 	movl	(%rbx,%rax,4), %r9d
180342e65: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180342e6c: 89 c1                       	movl	%eax, %ecx
180342e6e: 41 d3 c9                    	rorl	%cl, %r9d
180342e71: 41 0f c9                    	bswapl	%r9d
180342e74: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180342e79: 44 29 c2                    	subl	%r8d, %edx
180342e7c: 89 d1                       	movl	%edx, %ecx
180342e7e: 41 d3 c1                    	roll	%cl, %r9d
180342e81: 89 c1                       	movl	%eax, %ecx
180342e83: 41 d3 c9                    	rorl	%cl, %r9d
180342e86: 4e 8d 04 36                 	leaq	(%rsi,%r14), %r8
180342e8a: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180342e91: 41 d3 c9                    	rorl	%cl, %r9d
180342e94: 89 d1                       	movl	%edx, %ecx
180342e96: 41 d3 c1                    	roll	%cl, %r9d
180342e99: 41 d3 c1                    	roll	%cl, %r9d
180342e9c: 49 63 c1                    	movslq	%r9d, %rax
180342e9f: 4c 89 c1                    	movq	%r8, %rcx
180342ea2: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342ea7: 49 83 c6 e8                 	addq	$-0x18, %r14
180342eab: 49 83 fe e8                 	cmpq	$-0x18, %r14
180342eaf: 75 9f                       	jne	0x180342e50 <.text+0x332e50>
180342eb1: b8 27 69 59 e9              	movl	$0xe9596927, %eax       # imm = 0xE9596927
180342eb6: 33 05 24 dc 46 00           	xorl	0x46dc24(%rip), %eax    # 0x1807b0ae0
180342ebc: 05 92 d2 f2 64              	addl	$0x64f2d292, %eax       # imm = 0x64F2D292
180342ec1: 48 98                       	cltq
180342ec3: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342ec7: 48 8d 34 c5 f0 0a 00 00     	leaq	0xaf0(,%rax,8), %rsi
180342ecf: 48 01 ee                    	addq	%rbp, %rsi
180342ed2: 41 be 18 00 00 00           	movl	$0x18, %r14d
180342ed8: 0f 1f 84 00 00 00 00 00     	nopl	(%rax,%rax)
180342ee0: 48 63 05 21 54 48 00        	movslq	0x485421(%rip), %rax    # 0x1807c8308
180342ee7: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180342eeb: 41 8d 40 01                 	leal	0x1(%r8), %eax
180342eef: 48 98                       	cltq
180342ef1: 44 8b 0c 83                 	movl	(%rbx,%rax,4), %r9d
180342ef5: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180342efc: 89 c1                       	movl	%eax, %ecx
180342efe: 41 d3 c9                    	rorl	%cl, %r9d
180342f01: 41 0f c9                    	bswapl	%r9d
180342f04: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180342f09: 44 29 c2                    	subl	%r8d, %edx
180342f0c: 89 d1                       	movl	%edx, %ecx
180342f0e: 41 d3 c1                    	roll	%cl, %r9d
180342f11: 89 c1                       	movl	%eax, %ecx
180342f13: 41 d3 c9                    	rorl	%cl, %r9d
180342f16: 4e 8d 04 36                 	leaq	(%rsi,%r14), %r8
180342f1a: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180342f21: 41 d3 c9                    	rorl	%cl, %r9d
180342f24: 89 d1                       	movl	%edx, %ecx
180342f26: 41 d3 c1                    	roll	%cl, %r9d
180342f29: 41 d3 c1                    	roll	%cl, %r9d
180342f2c: 49 63 c1                    	movslq	%r9d, %rax
180342f2f: 4c 89 c1                    	movq	%r8, %rcx
180342f32: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342f37: 49 83 c6 e8                 	addq	$-0x18, %r14
180342f3b: 49 83 fe e8                 	cmpq	$-0x18, %r14
180342f3f: 75 9f                       	jne	0x180342ee0 <.text+0x332ee0>
180342f41: b8 a3 47 db e1              	movl	$0xe1db47a3, %eax       # imm = 0xE1DB47A3
180342f46: 33 05 88 db 46 00           	xorl	0x46db88(%rip), %eax    # 0x1807b0ad4
180342f4c: 05 ea e7 92 2f              	addl	$0x2f92e7ea, %eax       # imm = 0x2F92E7EA
180342f51: 48 98                       	cltq
180342f53: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180342f57: 48 8d 34 c5 80 08 00 00     	leaq	0x880(,%rax,8), %rsi
180342f5f: 48 01 ee                    	addq	%rbp, %rsi
180342f62: 41 be 18 00 00 00           	movl	$0x18, %r14d
180342f68: 0f 1f 84 00 00 00 00 00     	nopl	(%rax,%rax)
180342f70: 48 63 05 99 53 48 00        	movslq	0x485399(%rip), %rax    # 0x1807c8310
180342f77: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180342f7b: 41 8d 40 01                 	leal	0x1(%r8), %eax
180342f7f: 48 98                       	cltq
180342f81: 44 8b 0c 83                 	movl	(%rbx,%rax,4), %r9d
180342f85: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180342f8c: 89 c1                       	movl	%eax, %ecx
180342f8e: 41 d3 c9                    	rorl	%cl, %r9d
180342f91: 41 0f c9                    	bswapl	%r9d
180342f94: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180342f99: 44 29 c2                    	subl	%r8d, %edx
180342f9c: 89 d1                       	movl	%edx, %ecx
180342f9e: 41 d3 c1                    	roll	%cl, %r9d
180342fa1: 89 c1                       	movl	%eax, %ecx
180342fa3: 41 d3 c9                    	rorl	%cl, %r9d
180342fa6: 4e 8d 04 36                 	leaq	(%rsi,%r14), %r8
180342faa: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180342fb1: 41 d3 c9                    	rorl	%cl, %r9d
180342fb4: 89 d1                       	movl	%edx, %ecx
180342fb6: 41 d3 c1                    	roll	%cl, %r9d
180342fb9: 41 d3 c1                    	roll	%cl, %r9d
180342fbc: 49 63 c1                    	movslq	%r9d, %rax
180342fbf: 4c 89 c1                    	movq	%r8, %rcx
180342fc2: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180342fc7: 49 83 c6 e8                 	addq	$-0x18, %r14
180342fcb: 49 83 fe e8                 	cmpq	$-0x18, %r14
180342fcf: 75 9f                       	jne	0x180342f70 <.text+0x332f70>
180342fd1: 80 bd c7 0c 00 00 00        	cmpb	$0x0, 0xcc7(%rbp)
180342fd8: 0f 84 cc 01 00 00           	je	0x1803431aa <.text+0x3331aa>
180342fde: 48 8d 85 f0 09 00 00        	leaq	0x9f0(%rbp), %rax
180342fe5: 48 89 44 24 20              	movq	%rax, 0x20(%rsp)
180342fea: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
180342ff1: 48 8d 95 80 06 00 00        	leaq	0x680(%rbp), %rdx
180342ff8: 4c 8d 85 00 07 00 00        	leaq	0x700(%rbp), %r8
180342fff: 4c 8d 8d e0 06 00 00        	leaq	0x6e0(%rbp), %r9
180343006: e8 95 c8 fd ff              	callq	0x18031f8a0 <.text+0x30f8a0>
18034300b: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
180343012: 48 8d 95 c0 04 00 00        	leaq	0x4c0(%rbp), %rdx
180343019: 4c 8d 85 80 08 00 00        	leaq	0x880(%rbp), %r8
180343020: e8 1b d0 fd ff              	callq	0x180320040 <.text+0x310040>
180343025: 48 63 15 ac 51 48 00        	movslq	0x4851ac(%rip), %rdx    # 0x1807c81d8
18034302c: 48 8d 35 4d 62 31 00        	leaq	0x31624d(%rip), %rsi    # 0x180659280
180343033: 8b 04 96                    	movl	(%rsi,%rdx,4), %eax
180343036: b9 0b 00 00 00              	movl	$0xb, %ecx
18034303b: 29 d1                       	subl	%edx, %ecx
18034303d: d3 c0                       	roll	%cl, %eax
18034303f: f7 d0                       	notl	%eax
180343041: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180343044: d3 c8                       	rorl	%cl, %eax
180343046: 89 c1                       	movl	%eax, %ecx
180343048: f7 d1                       	notl	%ecx
18034304a: 48 63 c9                    	movslq	%ecx, %rcx
18034304d: 48 8d 3d 7c 0a 48 00        	leaq	0x480a7c(%rip), %rdi    # 0x1807c3ad0
180343054: 44 8b 04 8f                 	movl	(%rdi,%rcx,4), %r8d
180343058: 41 0f c8                    	bswapl	%r8d
18034305b: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180343060: 29 c2                       	subl	%eax, %edx
180343062: 89 d1                       	movl	%edx, %ecx
180343064: 41 d3 c8                    	rorl	%cl, %r8d
180343067: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
18034306c: 89 c1                       	movl	%eax, %ecx
18034306e: 41 d3 c0                    	roll	%cl, %r8d
180343071: 89 d1                       	movl	%edx, %ecx
180343073: 41 d3 c8                    	rorl	%cl, %r8d
180343076: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
18034307d: 41 ff c0                    	incl	%r8d
180343080: 89 c1                       	movl	%eax, %ecx
180343082: 41 d3 c0                    	roll	%cl, %r8d
180343085: 41 f7 d0                    	notl	%r8d
180343088: 49 63 c0                    	movslq	%r8d, %rax
18034308b: 48 8d 8d 40 05 00 00        	leaq	0x540(%rbp), %rcx
180343092: 48 8d 95 a0 0b 00 00        	leaq	0xba0(%rbp), %rdx
180343099: 4c 8d 2d d0 ab 47 00        	leaq	0x47abd0(%rip), %r13    # 0x1807bdc70
1803430a0: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803430a5: 48 63 05 84 52 48 00        	movslq	0x485284(%rip), %rax    # 0x1807c8330
1803430ac: 8b 14 86                    	movl	(%rsi,%rax,4), %edx
1803430af: 48 89 f3                    	movq	%rsi, %rbx
1803430b2: b9 0a 00 00 00              	movl	$0xa, %ecx
1803430b7: 29 c1                       	subl	%eax, %ecx
1803430b9: d3 c2                       	roll	%cl, %edx
1803430bb: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803430c1: d3 ca                       	rorl	%cl, %edx
1803430c3: d3 ca                       	rorl	%cl, %edx
1803430c5: d3 ca                       	rorl	%cl, %edx
1803430c7: be 0a 00 00 00              	movl	$0xa, %esi
1803430cc: 48 63 c2                    	movslq	%edx, %rax
1803430cf: 45 31 f6                    	xorl	%r14d, %r14d
1803430d2: 31 d2                       	xorl	%edx, %edx
1803430d4: 2b 14 87                    	subl	(%rdi,%rax,4), %edx
1803430d7: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803430dd: d3 ca                       	rorl	%cl, %edx
1803430df: d3 ca                       	rorl	%cl, %edx
1803430e1: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803430e7: d3 ca                       	rorl	%cl, %edx
1803430e9: bf d0 45 48 92              	movl	$0x924845d0, %edi       # imm = 0x924845D0
1803430ee: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803430f3: 29 c1                       	subl	%eax, %ecx
1803430f5: d3 c2                       	roll	%cl, %edx
1803430f7: d3 c2                       	roll	%cl, %edx
1803430f9: 48 63 c2                    	movslq	%edx, %rax
1803430fc: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
180343103: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180343108: 48 63 05 25 52 48 00        	movslq	0x485225(%rip), %rax    # 0x1807c8334
18034310f: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180343112: 29 c6                       	subl	%eax, %esi
180343114: 89 f1                       	movl	%esi, %ecx
180343116: d3 c2                       	roll	%cl, %edx
180343118: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
18034311e: d3 ca                       	rorl	%cl, %edx
180343120: d3 ca                       	rorl	%cl, %edx
180343122: d3 ca                       	rorl	%cl, %edx
180343124: 48 63 c2                    	movslq	%edx, %rax
180343127: 31 d2                       	xorl	%edx, %edx
180343129: 48 8d 35 a0 09 48 00        	leaq	0x4809a0(%rip), %rsi    # 0x1807c3ad0
180343130: 2b 14 86                    	subl	(%rsi,%rax,4), %edx
180343133: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180343139: d3 ca                       	rorl	%cl, %edx
18034313b: d3 ca                       	rorl	%cl, %edx
18034313d: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180343143: d3 ca                       	rorl	%cl, %edx
180343145: 29 c7                       	subl	%eax, %edi
180343147: 89 f9                       	movl	%edi, %ecx
180343149: d3 c2                       	roll	%cl, %edx
18034314b: d3 c2                       	roll	%cl, %edx
18034314d: 48 63 c2                    	movslq	%edx, %rax
180343150: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
180343157: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034315c: 48 63 05 b9 51 48 00        	movslq	0x4851b9(%rip), %rax    # 0x1807c831c
180343163: 44 2b 34 83                 	subl	(%rbx,%rax,4), %r14d
180343167: 8d 48 13                    	leal	0x13(%rax), %ecx
18034316a: 41 d3 ce                    	rorl	%cl, %r14d
18034316d: 49 63 ce                    	movslq	%r14d, %rcx
180343170: 49 89 f6                    	movq	%rsi, %r14
180343173: 8b 04 8e                    	movl	(%rsi,%rcx,4), %eax
180343176: 0f c8                       	bswapl	%eax
180343178: 81 c1 d2 b3 92 bf           	addl	$0xbf92b3d2, %ecx       # imm = 0xBF92B3D2
18034317e: d3 c8                       	rorl	%cl, %eax
180343180: 35 2d 4c 6d 40              	xorl	$0x406d4c2d, %eax       # imm = 0x406D4C2D
180343185: d3 c8                       	rorl	%cl, %eax
180343187: f7 d8                       	negl	%eax
180343189: 48 98                       	cltq
18034318b: 48 8d 8d 40 05 00 00        	leaq	0x540(%rbp), %rcx
180343192: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180343197: 84 c0                       	testb	%al, %al
180343199: 0f 84 11 02 00 00           	je	0x1803433b0 <.text+0x3333b0>
18034319f: 8b 05 af d9 46 00           	movl	0x46d9af(%rip), %eax    # 0x1807b0b54
1803431a5: e9 f0 01 00 00              	jmp	0x18034339a <.text+0x33339a>
1803431aa: 48 8b 85 60 0b 00 00        	movq	0xb60(%rbp), %rax
1803431b1: 48 8b 8d 58 0b 00 00        	movq	0xb58(%rbp), %rcx
1803431b8: 48 89 44 24 40              	movq	%rax, 0x40(%rsp)
1803431bd: 48 89 4c 24 38              	movq	%rcx, 0x38(%rsp)
1803431c2: 48 8d 85 f0 09 00 00        	leaq	0x9f0(%rbp), %rax
1803431c9: 48 89 44 24 30              	movq	%rax, 0x30(%rsp)
1803431ce: 48 8d 85 e0 06 00 00        	leaq	0x6e0(%rbp), %rax
1803431d5: 48 89 44 24 28              	movq	%rax, 0x28(%rsp)
1803431da: 48 8d 85 00 07 00 00        	leaq	0x700(%rbp), %rax
1803431e1: 48 89 44 24 20              	movq	%rax, 0x20(%rsp)
1803431e6: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
1803431ed: 48 8d 95 a0 04 00 00        	leaq	0x4a0(%rbp), %rdx
1803431f4: 4c 8d 85 a0 06 00 00        	leaq	0x6a0(%rbp), %r8
1803431fb: 4c 8d 8d c0 06 00 00        	leaq	0x6c0(%rbp), %r9
180343202: e8 89 af fd ff              	callq	0x18031e190 <.text+0x30e190>
180343207: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
18034320e: 48 8d 95 00 05 00 00        	leaq	0x500(%rbp), %rdx
180343215: 4c 8d 85 80 08 00 00        	leaq	0x880(%rbp), %r8
18034321c: e8 1f ce fd ff              	callq	0x180320040 <.text+0x310040>
180343221: 48 63 15 bc 4f 48 00        	movslq	0x484fbc(%rip), %rdx    # 0x1807c81e4
180343228: 48 8d 3d 51 60 31 00        	leaq	0x316051(%rip), %rdi    # 0x180659280
18034322f: 8b 04 97                    	movl	(%rdi,%rdx,4), %eax
180343232: b9 0b 00 00 00              	movl	$0xb, %ecx
180343237: 29 d1                       	subl	%edx, %ecx
180343239: d3 c0                       	roll	%cl, %eax
18034323b: f7 d0                       	notl	%eax
18034323d: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180343240: d3 c8                       	rorl	%cl, %eax
180343242: 89 c1                       	movl	%eax, %ecx
180343244: f7 d1                       	notl	%ecx
180343246: 48 63 c9                    	movslq	%ecx, %rcx
180343249: 48 8d 1d 80 08 48 00        	leaq	0x480880(%rip), %rbx    # 0x1807c3ad0
180343250: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
180343254: 41 0f c8                    	bswapl	%r8d
180343257: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
18034325c: 29 c2                       	subl	%eax, %edx
18034325e: 89 d1                       	movl	%edx, %ecx
180343260: 41 d3 c8                    	rorl	%cl, %r8d
180343263: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180343268: 89 c1                       	movl	%eax, %ecx
18034326a: 41 d3 c0                    	roll	%cl, %r8d
18034326d: 89 d1                       	movl	%edx, %ecx
18034326f: 41 d3 c8                    	rorl	%cl, %r8d
180343272: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180343279: 41 ff c0                    	incl	%r8d
18034327c: 89 c1                       	movl	%eax, %ecx
18034327e: 41 d3 c0                    	roll	%cl, %r8d
180343281: 41 f7 d0                    	notl	%r8d
180343284: 49 63 c0                    	movslq	%r8d, %rax
180343287: 48 8d 8d 60 05 00 00        	leaq	0x560(%rbp), %rcx
18034328e: 48 8d 95 a0 0b 00 00        	leaq	0xba0(%rbp), %rdx
180343295: 4c 8d 2d d4 a9 47 00        	leaq	0x47a9d4(%rip), %r13    # 0x1807bdc70
18034329c: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803432a1: 48 63 05 78 50 48 00        	movslq	0x485078(%rip), %rax    # 0x1807c8320
1803432a8: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803432ab: b9 0a 00 00 00              	movl	$0xa, %ecx
1803432b0: 29 c1                       	subl	%eax, %ecx
1803432b2: d3 c2                       	roll	%cl, %edx
1803432b4: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803432ba: d3 ca                       	rorl	%cl, %edx
1803432bc: d3 ca                       	rorl	%cl, %edx
1803432be: d3 ca                       	rorl	%cl, %edx
1803432c0: be 0a 00 00 00              	movl	$0xa, %esi
1803432c5: 48 63 c2                    	movslq	%edx, %rax
1803432c8: 45 31 e4                    	xorl	%r12d, %r12d
1803432cb: 31 d2                       	xorl	%edx, %edx
1803432cd: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
1803432d0: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803432d6: d3 ca                       	rorl	%cl, %edx
1803432d8: d3 ca                       	rorl	%cl, %edx
1803432da: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803432e0: d3 ca                       	rorl	%cl, %edx
1803432e2: 41 be d0 45 48 92           	movl	$0x924845d0, %r14d      # imm = 0x924845D0
1803432e8: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803432ed: 29 c1                       	subl	%eax, %ecx
1803432ef: d3 c2                       	roll	%cl, %edx
1803432f1: d3 c2                       	roll	%cl, %edx
1803432f3: 48 63 c2                    	movslq	%edx, %rax
1803432f6: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
1803432fd: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180343302: 48 63 05 1b 50 48 00        	movslq	0x48501b(%rip), %rax    # 0x1807c8324
180343309: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
18034330c: 29 c6                       	subl	%eax, %esi
18034330e: 89 f1                       	movl	%esi, %ecx
180343310: d3 c2                       	roll	%cl, %edx
180343312: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180343318: d3 ca                       	rorl	%cl, %edx
18034331a: d3 ca                       	rorl	%cl, %edx
18034331c: d3 ca                       	rorl	%cl, %edx
18034331e: 48 63 c2                    	movslq	%edx, %rax
180343321: 31 d2                       	xorl	%edx, %edx
180343323: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
180343326: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
18034332c: d3 ca                       	rorl	%cl, %edx
18034332e: d3 ca                       	rorl	%cl, %edx
180343330: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180343336: d3 ca                       	rorl	%cl, %edx
180343338: 41 29 c6                    	subl	%eax, %r14d
18034333b: 44 89 f1                    	movl	%r14d, %ecx
18034333e: d3 c2                       	roll	%cl, %edx
180343340: 49 89 de                    	movq	%rbx, %r14
180343343: d3 c2                       	roll	%cl, %edx
180343345: 48 63 c2                    	movslq	%edx, %rax
180343348: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
18034334f: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180343354: 48 63 05 bd 4f 48 00        	movslq	0x484fbd(%rip), %rax    # 0x1807c8318
18034335b: 44 2b 24 87                 	subl	(%rdi,%rax,4), %r12d
18034335f: 8d 48 13                    	leal	0x13(%rax), %ecx
180343362: 41 d3 cc                    	rorl	%cl, %r12d
180343365: 49 63 cc                    	movslq	%r12d, %rcx
180343368: 8b 04 8b                    	movl	(%rbx,%rcx,4), %eax
18034336b: 0f c8                       	bswapl	%eax
18034336d: 81 c1 d2 b3 92 bf           	addl	$0xbf92b3d2, %ecx       # imm = 0xBF92B3D2
180343373: d3 c8                       	rorl	%cl, %eax
180343375: 35 2d 4c 6d 40              	xorl	$0x406d4c2d, %eax       # imm = 0x406D4C2D
18034337a: d3 c8                       	rorl	%cl, %eax
18034337c: f7 d8                       	negl	%eax
18034337e: 48 98                       	cltq
180343380: 48 8d 8d 60 05 00 00        	leaq	0x560(%rbp), %rcx
180343387: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034338c: 84 c0                       	testb	%al, %al
18034338e: 0f 84 78 02 00 00           	je	0x18034360c <.text+0x33360c>
180343394: 8b 05 b6 d7 46 00           	movl	0x46d7b6(%rip), %eax    # 0x1807b0b50
18034339a: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
1803433a4: 48 8d 1d d5 5e 31 00        	leaq	0x315ed5(%rip), %rbx    # 0x180659280
1803433ab: e9 6b 3b 00 00              	jmp	0x180346f1b <.text+0x336f1b>
1803433b0: 48 8d 8d e0 02 00 00        	leaq	0x2e0(%rbp), %rcx
1803433b7: 48 8d 95 80 06 00 00        	leaq	0x680(%rbp), %rdx
1803433be: e8 3d 93 00 00              	callq	0x18034c700 <.text+0x33c700>
1803433c3: 48 63 05 9a 4e 48 00        	movslq	0x484e9a(%rip), %rax    # 0x1807c8264
1803433ca: 4c 8d 35 af 5e 31 00        	leaq	0x315eaf(%rip), %r14    # 0x180659280
1803433d1: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803433d5: b9 10 00 00 00              	movl	$0x10, %ecx
1803433da: 29 c1                       	subl	%eax, %ecx
1803433dc: d3 c2                       	roll	%cl, %edx
1803433de: 8d 4a 1b                    	leal	0x1b(%rdx), %ecx
1803433e1: b8 1b 00 00 00              	movl	$0x1b, %eax
1803433e6: 29 d0                       	subl	%edx, %eax
1803433e8: f7 da                       	negl	%edx
1803433ea: 48 63 d2                    	movslq	%edx, %rdx
1803433ed: 48 8d 1d dc 06 48 00        	leaq	0x4806dc(%rip), %rbx    # 0x1807c3ad0
1803433f4: 8b 14 93                    	movl	(%rbx,%rdx,4), %edx
1803433f7: d3 c2                       	roll	%cl, %edx
1803433f9: ff ca                       	decl	%edx
1803433fb: 89 c1                       	movl	%eax, %ecx
1803433fd: d3 ca                       	rorl	%cl, %edx
1803433ff: f7 d2                       	notl	%edx
180343401: 0f ca                       	bswapl	%edx
180343403: 48 63 c2                    	movslq	%edx, %rax
180343406: 48 8d b5 a0 0b 00 00        	leaq	0xba0(%rbp), %rsi
18034340d: 48 89 f1                    	movq	%rsi, %rcx
180343410: 48 8d 3d 59 a8 47 00        	leaq	0x47a859(%rip), %rdi    # 0x1807bdc70
180343417: ff 14 c7                    	callq	*(%rdi,%rax,8)
18034341a: 48 63 0d 17 4f 48 00        	movslq	0x484f17(%rip), %rcx    # 0x1807c8338
180343421: b8 e5 6c 5a 59              	movl	$0x595a6ce5, %eax       # imm = 0x595A6CE5
180343426: 41 33 04 8e                 	xorl	(%r14,%rcx,4), %eax
18034342a: ff c0                       	incl	%eax
18034342c: 83 c1 1a                    	addl	$0x1a, %ecx
18034342f: d3 c8                       	rorl	%cl, %eax
180343431: 89 c1                       	movl	%eax, %ecx
180343433: f7 d1                       	notl	%ecx
180343435: 48 63 d1                    	movslq	%ecx, %rdx
180343438: 8b 14 93                    	movl	(%rbx,%rdx,4), %edx
18034343b: ff ca                       	decl	%edx
18034343d: d3 ca                       	rorl	%cl, %edx
18034343f: f7 da                       	negl	%edx
180343441: ff c0                       	incl	%eax
180343443: 89 c1                       	movl	%eax, %ecx
180343445: d3 c2                       	roll	%cl, %edx
180343447: f7 da                       	negl	%edx
180343449: 81 f2 df 30 83 80           	xorl	$0x808330df, %edx       # imm = 0x808330DF
18034344f: 0f ca                       	bswapl	%edx
180343451: 48 63 c2                    	movslq	%edx, %rax
180343454: 48 89 f1                    	movq	%rsi, %rcx
180343457: ff 14 c7                    	callq	*(%rdi,%rax,8)
18034345a: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343461: 48 89 c2                    	movq	%rax, %rdx
180343464: e8 17 27 fd ff              	callq	0x180315b80 <.text+0x305b80>
180343469: 48 63 15 70 4d 48 00        	movslq	0x484d70(%rip), %rdx    # 0x1807c81e0
180343470: 45 31 c0                    	xorl	%r8d, %r8d
180343473: 48 8d 0d 06 5e 31 00        	leaq	0x315e06(%rip), %rcx    # 0x180659280
18034347a: 44 2b 04 91                 	subl	(%rcx,%rdx,4), %r8d
18034347e: b9 08 00 00 00              	movl	$0x8, %ecx
180343483: 29 d1                       	subl	%edx, %ecx
180343485: 41 d3 c0                    	roll	%cl, %r8d
180343488: 41 f7 d0                    	notl	%r8d
18034348b: 8d 4a 08                    	leal	0x8(%rdx), %ecx
18034348e: 41 d3 c8                    	rorl	%cl, %r8d
180343491: 49 63 d0                    	movslq	%r8d, %rdx
180343494: 48 8d 0d 35 06 48 00        	leaq	0x480635(%rip), %rcx    # 0x1807c3ad0
18034349b: 44 8b 0c 91                 	movl	(%rcx,%rdx,4), %r9d
18034349f: 41 b8 38 93 c9 34           	movl	$0x34c99338, %r8d       # imm = 0x34C99338
1803434a5: 41 29 d0                    	subl	%edx, %r8d
1803434a8: 44 89 c1                    	movl	%r8d, %ecx
1803434ab: 41 d3 c1                    	roll	%cl, %r9d
1803434ae: 41 81 f1 38 93 c9 34        	xorl	$0x34c99338, %r9d       # imm = 0x34C99338
1803434b5: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
1803434bb: 89 d1                       	movl	%edx, %ecx
1803434bd: 41 d3 c9                    	rorl	%cl, %r9d
1803434c0: 41 d3 c9                    	rorl	%cl, %r9d
1803434c3: 44 89 c1                    	movl	%r8d, %ecx
1803434c6: 41 d3 c1                    	roll	%cl, %r9d
1803434c9: 41 d3 c1                    	roll	%cl, %r9d
1803434cc: 4d 63 c1                    	movslq	%r9d, %r8
1803434cf: 48 8d 95 e0 02 00 00        	leaq	0x2e0(%rbp), %rdx
1803434d6: 48 89 c1                    	movq	%rax, %rcx
1803434d9: 48 8d 05 90 a7 47 00        	leaq	0x47a790(%rip), %rax    # 0x1807bdc70
1803434e0: 42 ff 14 c0                 	callq	*(%rax,%r8,8)
1803434e4: 48 8d 8d f0 02 00 00        	leaq	0x2f0(%rbp), %rcx
1803434eb: 48 8d 95 40 05 00 00        	leaq	0x540(%rbp), %rdx
1803434f2: e8 09 92 00 00              	callq	0x18034c700 <.text+0x33c700>
1803434f7: 48 63 0d 6a 4d 48 00        	movslq	0x484d6a(%rip), %rcx    # 0x1807c8268
1803434fe: 4c 8d 35 7b 5d 31 00        	leaq	0x315d7b(%rip), %r14    # 0x180659280
180343505: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
180343509: ff c8                       	decl	%eax
18034350b: 83 c1 1e                    	addl	$0x1e, %ecx
18034350e: d3 c8                       	rorl	%cl, %eax
180343510: 0f c8                       	bswapl	%eax
180343512: 48 63 c8                    	movslq	%eax, %rcx
180343515: 48 8d 1d b4 05 48 00        	leaq	0x4805b4(%rip), %rbx    # 0x1807c3ad0
18034351c: 8b 14 8b                    	movl	(%rbx,%rcx,4), %edx
18034351f: f7 d2                       	notl	%edx
180343521: 0f ca                       	bswapl	%edx
180343523: 89 c1                       	movl	%eax, %ecx
180343525: d3 ca                       	rorl	%cl, %edx
180343527: 81 f2 40 3d ae 34           	xorl	$0x34ae3d40, %edx       # imm = 0x34AE3D40
18034352d: 48 63 c2                    	movslq	%edx, %rax
180343530: 48 89 f1                    	movq	%rsi, %rcx
180343533: 48 8d 3d 36 a7 47 00        	leaq	0x47a736(%rip), %rdi    # 0x1807bdc70
18034353a: ff 14 c7                    	callq	*(%rdi,%rax,8)
18034353d: 48 63 0d d0 4d 48 00        	movslq	0x484dd0(%rip), %rcx    # 0x1807c8314
180343544: b8 e5 6c 5a 59              	movl	$0x595a6ce5, %eax       # imm = 0x595A6CE5
180343549: 41 33 04 8e                 	xorl	(%r14,%rcx,4), %eax
18034354d: ff c0                       	incl	%eax
18034354f: 83 c1 1a                    	addl	$0x1a, %ecx
180343552: d3 c8                       	rorl	%cl, %eax
180343554: 89 c1                       	movl	%eax, %ecx
180343556: f7 d1                       	notl	%ecx
180343558: 48 63 d1                    	movslq	%ecx, %rdx
18034355b: 8b 14 93                    	movl	(%rbx,%rdx,4), %edx
18034355e: ff ca                       	decl	%edx
180343560: d3 ca                       	rorl	%cl, %edx
180343562: f7 da                       	negl	%edx
180343564: ff c0                       	incl	%eax
180343566: 89 c1                       	movl	%eax, %ecx
180343568: d3 c2                       	roll	%cl, %edx
18034356a: f7 da                       	negl	%edx
18034356c: 81 f2 df 30 83 80           	xorl	$0x808330df, %edx       # imm = 0x808330DF
180343572: 0f ca                       	bswapl	%edx
180343574: 48 63 c2                    	movslq	%edx, %rax
180343577: 48 89 f1                    	movq	%rsi, %rcx
18034357a: ff 14 c7                    	callq	*(%rdi,%rax,8)
18034357d: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343584: 48 89 c2                    	movq	%rax, %rdx
180343587: e8 f4 25 fd ff              	callq	0x180315b80 <.text+0x305b80>
18034358c: 48 63 15 49 4c 48 00        	movslq	0x484c49(%rip), %rdx    # 0x1807c81dc
180343593: 45 31 c0                    	xorl	%r8d, %r8d
180343596: 48 8d 0d e3 5c 31 00        	leaq	0x315ce3(%rip), %rcx    # 0x180659280
18034359d: 44 2b 04 91                 	subl	(%rcx,%rdx,4), %r8d
1803435a1: b9 08 00 00 00              	movl	$0x8, %ecx
1803435a6: 29 d1                       	subl	%edx, %ecx
1803435a8: 41 d3 c0                    	roll	%cl, %r8d
1803435ab: 41 f7 d0                    	notl	%r8d
1803435ae: 8d 4a 08                    	leal	0x8(%rdx), %ecx
1803435b1: 41 d3 c8                    	rorl	%cl, %r8d
1803435b4: 49 63 d0                    	movslq	%r8d, %rdx
1803435b7: 48 8d 0d 12 05 48 00        	leaq	0x480512(%rip), %rcx    # 0x1807c3ad0
1803435be: 44 8b 0c 91                 	movl	(%rcx,%rdx,4), %r9d
1803435c2: 41 b8 38 93 c9 34           	movl	$0x34c99338, %r8d       # imm = 0x34C99338
1803435c8: 41 29 d0                    	subl	%edx, %r8d
1803435cb: 44 89 c1                    	movl	%r8d, %ecx
1803435ce: 41 d3 c1                    	roll	%cl, %r9d
1803435d1: 41 81 f1 38 93 c9 34        	xorl	$0x34c99338, %r9d       # imm = 0x34C99338
1803435d8: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
1803435de: 89 d1                       	movl	%edx, %ecx
1803435e0: 41 d3 c9                    	rorl	%cl, %r9d
1803435e3: 41 d3 c9                    	rorl	%cl, %r9d
1803435e6: 44 89 c1                    	movl	%r8d, %ecx
1803435e9: 41 d3 c1                    	roll	%cl, %r9d
1803435ec: 41 d3 c1                    	roll	%cl, %r9d
1803435ef: 4d 63 c1                    	movslq	%r9d, %r8
1803435f2: 48 8d 95 f0 02 00 00        	leaq	0x2f0(%rbp), %rdx
1803435f9: 48 89 c1                    	movq	%rax, %rcx
1803435fc: 48 8d 05 6d a6 47 00        	leaq	0x47a66d(%rip), %rax    # 0x1807bdc70
180343603: 42 ff 14 c0                 	callq	*(%rax,%r8,8)
180343607: e9 bd 07 00 00              	jmp	0x180343dc9 <.text+0x333dc9>
18034360c: 48 8d 8d 00 03 00 00        	leaq	0x300(%rbp), %rcx
180343613: 48 8d 95 a0 04 00 00        	leaq	0x4a0(%rbp), %rdx
18034361a: e8 e1 90 00 00              	callq	0x18034c700 <.text+0x33c700>
18034361f: 48 63 05 4e 4c 48 00        	movslq	0x484c4e(%rip), %rax    # 0x1807c8274
180343626: 4c 8d 35 53 5c 31 00        	leaq	0x315c53(%rip), %r14    # 0x180659280
18034362d: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180343631: b9 3a 54 6b 4c              	movl	$0x4c6b543a, %ecx       # imm = 0x4C6B543A
180343636: 29 c1                       	subl	%eax, %ecx
180343638: d3 c2                       	roll	%cl, %edx
18034363a: d3 c2                       	roll	%cl, %edx
18034363c: d3 c2                       	roll	%cl, %edx
18034363e: d3 c2                       	roll	%cl, %edx
180343640: 48 63 c2                    	movslq	%edx, %rax
180343643: 48 8d 1d 86 04 48 00        	leaq	0x480486(%rip), %rbx    # 0x1807c3ad0
18034364a: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
18034364d: 8d 48 1a                    	leal	0x1a(%rax), %ecx
180343650: d3 ca                       	rorl	%cl, %edx
180343652: b9 1a 00 00 00              	movl	$0x1a, %ecx
180343657: 29 c1                       	subl	%eax, %ecx
180343659: d3 c2                       	roll	%cl, %edx
18034365b: ff c2                       	incl	%edx
18034365d: 48 63 c2                    	movslq	%edx, %rax
180343660: 48 8d b5 a0 0b 00 00        	leaq	0xba0(%rbp), %rsi
180343667: 48 89 f1                    	movq	%rsi, %rcx
18034366a: 48 8d 3d ff a5 47 00        	leaq	0x47a5ff(%rip), %rdi    # 0x1807bdc70
180343671: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343674: 48 63 05 ad 4c 48 00        	movslq	0x484cad(%rip), %rax    # 0x1807c8328
18034367b: 31 c9                       	xorl	%ecx, %ecx
18034367d: 41 2b 0c 86                 	subl	(%r14,%rax,4), %ecx
180343681: 0f c9                       	bswapl	%ecx
180343683: 48 63 c9                    	movslq	%ecx, %rcx
180343686: 8b 04 8b                    	movl	(%rbx,%rcx,4), %eax
180343689: f7 d0                       	notl	%eax
18034368b: 81 c1 a7 fa b6 ae           	addl	$0xaeb6faa7, %ecx       # imm = 0xAEB6FAA7
180343691: d3 c8                       	rorl	%cl, %eax
180343693: d3 c8                       	rorl	%cl, %eax
180343695: 35 58 05 49 51              	xorl	$0x51490558, %eax       # imm = 0x51490558
18034369a: ff c0                       	incl	%eax
18034369c: d3 c8                       	rorl	%cl, %eax
18034369e: d3 c8                       	rorl	%cl, %eax
1803436a0: 0f c8                       	bswapl	%eax
1803436a2: 48 98                       	cltq
1803436a4: 48 89 f1                    	movq	%rsi, %rcx
1803436a7: ff 14 c7                    	callq	*(%rdi,%rax,8)
1803436aa: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
1803436b1: 48 89 c2                    	movq	%rax, %rdx
1803436b4: e8 c7 24 fd ff              	callq	0x180315b80 <.text+0x305b80>
1803436b9: 48 63 15 14 4b 48 00        	movslq	0x484b14(%rip), %rdx    # 0x1807c81d4
1803436c0: 48 8d 0d b9 5b 31 00        	leaq	0x315bb9(%rip), %rcx    # 0x180659280
1803436c7: 45 31 c0                    	xorl	%r8d, %r8d
1803436ca: 44 2b 04 91                 	subl	(%rcx,%rdx,4), %r8d
1803436ce: b9 08 00 00 00              	movl	$0x8, %ecx
1803436d3: 29 d1                       	subl	%edx, %ecx
1803436d5: 41 d3 c0                    	roll	%cl, %r8d
1803436d8: 41 f7 d0                    	notl	%r8d
1803436db: 8d 4a 08                    	leal	0x8(%rdx), %ecx
1803436de: 41 d3 c8                    	rorl	%cl, %r8d
1803436e1: 49 63 d0                    	movslq	%r8d, %rdx
1803436e4: 48 8d 0d e5 03 48 00        	leaq	0x4803e5(%rip), %rcx    # 0x1807c3ad0
1803436eb: 44 8b 0c 91                 	movl	(%rcx,%rdx,4), %r9d
1803436ef: 41 b8 38 93 c9 34           	movl	$0x34c99338, %r8d       # imm = 0x34C99338
1803436f5: 41 29 d0                    	subl	%edx, %r8d
1803436f8: 44 89 c1                    	movl	%r8d, %ecx
1803436fb: 41 d3 c1                    	roll	%cl, %r9d
1803436fe: 41 81 f1 38 93 c9 34        	xorl	$0x34c99338, %r9d       # imm = 0x34C99338
180343705: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
18034370b: 89 d1                       	movl	%edx, %ecx
18034370d: 41 d3 c9                    	rorl	%cl, %r9d
180343710: 41 d3 c9                    	rorl	%cl, %r9d
180343713: 44 89 c1                    	movl	%r8d, %ecx
180343716: 41 d3 c1                    	roll	%cl, %r9d
180343719: 41 d3 c1                    	roll	%cl, %r9d
18034371c: 4d 63 c1                    	movslq	%r9d, %r8
18034371f: 48 8d 95 00 03 00 00        	leaq	0x300(%rbp), %rdx
180343726: 48 89 c1                    	movq	%rax, %rcx
180343729: 48 8d 05 40 a5 47 00        	leaq	0x47a540(%rip), %rax    # 0x1807bdc70
180343730: 42 ff 14 c0                 	callq	*(%rax,%r8,8)
180343734: 48 8d 8d 10 03 00 00        	leaq	0x310(%rbp), %rcx
18034373b: 48 8d 95 a0 06 00 00        	leaq	0x6a0(%rbp), %rdx
180343742: e8 b9 8f 00 00              	callq	0x18034c700 <.text+0x33c700>
180343747: 48 63 05 76 4e 48 00        	movslq	0x484e76(%rip), %rax    # 0x1807c85c4
18034374e: 4c 8d 35 2b 5b 31 00        	leaq	0x315b2b(%rip), %r14    # 0x180659280
180343755: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180343759: f7 d2                       	notl	%edx
18034375b: 0f ca                       	bswapl	%edx
18034375d: f7 da                       	negl	%edx
18034375f: 8d 48 0d                    	leal	0xd(%rax), %ecx
180343762: d3 ca                       	rorl	%cl, %edx
180343764: 48 63 ca                    	movslq	%edx, %rcx
180343767: 48 8d 1d 62 03 48 00        	leaq	0x480362(%rip), %rbx    # 0x1807c3ad0
18034376e: 8b 04 8b                    	movl	(%rbx,%rcx,4), %eax
180343771: f7 d0                       	notl	%eax
180343773: 81 c1 46 34 49 58           	addl	$0x58493446, %ecx       # imm = 0x58493446
180343779: d3 c8                       	rorl	%cl, %eax
18034377b: d3 c8                       	rorl	%cl, %eax
18034377d: 35 58 49 34 46              	xorl	$0x46344958, %eax       # imm = 0x46344958
180343782: 0f c8                       	bswapl	%eax
180343784: f7 d8                       	negl	%eax
180343786: 35 46 34 49 58              	xorl	$0x58493446, %eax       # imm = 0x58493446
18034378b: 0f c8                       	bswapl	%eax
18034378d: 48 98                       	cltq
18034378f: 48 89 f1                    	movq	%rsi, %rcx
180343792: 48 8d 3d d7 a4 47 00        	leaq	0x47a4d7(%rip), %rdi    # 0x1807bdc70
180343799: ff 14 c7                    	callq	*(%rdi,%rax,8)
18034379c: 48 63 0d 9d 4b 48 00        	movslq	0x484b9d(%rip), %rcx    # 0x1807c8340
1803437a3: b8 e5 6c 5a 59              	movl	$0x595a6ce5, %eax       # imm = 0x595A6CE5
1803437a8: 41 33 04 8e                 	xorl	(%r14,%rcx,4), %eax
1803437ac: ff c0                       	incl	%eax
1803437ae: 83 c1 1a                    	addl	$0x1a, %ecx
1803437b1: d3 c8                       	rorl	%cl, %eax
1803437b3: 89 c1                       	movl	%eax, %ecx
1803437b5: f7 d1                       	notl	%ecx
1803437b7: 48 63 d1                    	movslq	%ecx, %rdx
1803437ba: 8b 14 93                    	movl	(%rbx,%rdx,4), %edx
1803437bd: ff ca                       	decl	%edx
1803437bf: d3 ca                       	rorl	%cl, %edx
1803437c1: f7 da                       	negl	%edx
1803437c3: ff c0                       	incl	%eax
1803437c5: 89 c1                       	movl	%eax, %ecx
1803437c7: d3 c2                       	roll	%cl, %edx
1803437c9: f7 da                       	negl	%edx
1803437cb: 81 f2 df 30 83 80           	xorl	$0x808330df, %edx       # imm = 0x808330DF
1803437d1: 0f ca                       	bswapl	%edx
1803437d3: 48 63 c2                    	movslq	%edx, %rax
1803437d6: 48 89 f1                    	movq	%rsi, %rcx
1803437d9: ff 14 c7                    	callq	*(%rdi,%rax,8)
1803437dc: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
1803437e3: 48 89 c2                    	movq	%rax, %rdx
1803437e6: e8 95 23 fd ff              	callq	0x180315b80 <.text+0x305b80>
1803437eb: 48 63 15 fe 49 48 00        	movslq	0x4849fe(%rip), %rdx    # 0x1807c81f0
1803437f2: 45 31 c0                    	xorl	%r8d, %r8d
1803437f5: 48 8d 0d 84 5a 31 00        	leaq	0x315a84(%rip), %rcx    # 0x180659280
1803437fc: 44 2b 04 91                 	subl	(%rcx,%rdx,4), %r8d
180343800: b9 08 00 00 00              	movl	$0x8, %ecx
180343805: 29 d1                       	subl	%edx, %ecx
180343807: 41 d3 c0                    	roll	%cl, %r8d
18034380a: 41 f7 d0                    	notl	%r8d
18034380d: 8d 4a 08                    	leal	0x8(%rdx), %ecx
180343810: 41 d3 c8                    	rorl	%cl, %r8d
180343813: 49 63 d0                    	movslq	%r8d, %rdx
180343816: 48 8d 0d b3 02 48 00        	leaq	0x4802b3(%rip), %rcx    # 0x1807c3ad0
18034381d: 44 8b 0c 91                 	movl	(%rcx,%rdx,4), %r9d
180343821: 41 b8 38 93 c9 34           	movl	$0x34c99338, %r8d       # imm = 0x34C99338
180343827: 41 29 d0                    	subl	%edx, %r8d
18034382a: 44 89 c1                    	movl	%r8d, %ecx
18034382d: 41 d3 c1                    	roll	%cl, %r9d
180343830: 31 f6                       	xorl	%esi, %esi
180343832: 41 81 f1 38 93 c9 34        	xorl	$0x34c99338, %r9d       # imm = 0x34C99338
180343839: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
18034383f: 89 d1                       	movl	%edx, %ecx
180343841: 41 d3 c9                    	rorl	%cl, %r9d
180343844: 41 d3 c9                    	rorl	%cl, %r9d
180343847: 44 89 c1                    	movl	%r8d, %ecx
18034384a: 41 d3 c1                    	roll	%cl, %r9d
18034384d: 41 d3 c1                    	roll	%cl, %r9d
180343850: 4d 63 c1                    	movslq	%r9d, %r8
180343853: 48 8d 95 10 03 00 00        	leaq	0x310(%rbp), %rdx
18034385a: 48 89 c1                    	movq	%rax, %rcx
18034385d: 48 8d 05 0c a4 47 00        	leaq	0x47a40c(%rip), %rax    # 0x1807bdc70
180343864: 42 ff 14 c0                 	callq	*(%rax,%r8,8)
180343868: 48 8d 8d 20 03 00 00        	leaq	0x320(%rbp), %rcx
18034386f: 48 8d 95 c0 06 00 00        	leaq	0x6c0(%rbp), %rdx
180343876: e8 85 8e 00 00              	callq	0x18034c700 <.text+0x33c700>
18034387b: 48 63 05 46 4d 48 00        	movslq	0x484d46(%rip), %rax    # 0x1807c85c8
180343882: 4c 8d 35 f7 59 31 00        	leaq	0x3159f7(%rip), %r14    # 0x180659280
180343889: 41 2b 34 86                 	subl	(%r14,%rax,4), %esi
18034388d: 8d 48 0c                    	leal	0xc(%rax), %ecx
180343890: d3 ce                       	rorl	%cl, %esi
180343892: 48 63 c6                    	movslq	%esi, %rax
180343895: ba 8d 67 ef d9              	movl	$0xd9ef678d, %edx       # imm = 0xD9EF678D
18034389a: 48 8d 1d 2f 02 48 00        	leaq	0x48022f(%rip), %rbx    # 0x1807c3ad0
1803438a1: 44 8b 04 83                 	movl	(%rbx,%rax,4), %r8d
1803438a5: 41 31 d0                    	xorl	%edx, %r8d
1803438a8: 29 c2                       	subl	%eax, %edx
1803438aa: 89 d1                       	movl	%edx, %ecx
1803438ac: 41 d3 c0                    	roll	%cl, %r8d
1803438af: 41 f7 d8                    	negl	%r8d
1803438b2: 41 81 f0 d9 ef 67 8d        	xorl	$0x8d67efd9, %r8d       # imm = 0x8D67EFD9
1803438b9: 41 0f c8                    	bswapl	%r8d
1803438bc: 83 c0 0d                    	addl	$0xd, %eax
1803438bf: 89 c1                       	movl	%eax, %ecx
1803438c1: 41 d3 c8                    	rorl	%cl, %r8d
1803438c4: 41 81 f0 8d 67 ef d9        	xorl	$0xd9ef678d, %r8d       # imm = 0xD9EF678D
1803438cb: 89 d1                       	movl	%edx, %ecx
1803438cd: 41 d3 c0                    	roll	%cl, %r8d
1803438d0: 49 63 c0                    	movslq	%r8d, %rax
1803438d3: 48 8d b5 a0 0b 00 00        	leaq	0xba0(%rbp), %rsi
1803438da: 48 89 f1                    	movq	%rsi, %rcx
1803438dd: 48 8d 3d 8c a3 47 00        	leaq	0x47a38c(%rip), %rdi    # 0x1807bdc70
1803438e4: ff 14 c7                    	callq	*(%rdi,%rax,8)
1803438e7: 48 63 05 7a 4a 48 00        	movslq	0x484a7a(%rip), %rax    # 0x1807c8368
1803438ee: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803438f2: f7 d2                       	notl	%edx
1803438f4: b9 10 00 00 00              	movl	$0x10, %ecx
1803438f9: 29 c1                       	subl	%eax, %ecx
1803438fb: d3 c2                       	roll	%cl, %edx
1803438fd: 83 f0 10                    	xorl	$0x10, %eax
180343900: 89 c1                       	movl	%eax, %ecx
180343902: d3 ca                       	rorl	%cl, %edx
180343904: 81 f2 30 47 68 df           	xorl	$0xdf684730, %edx       # imm = 0xDF684730
18034390a: 48 63 c2                    	movslq	%edx, %rax
18034390d: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180343910: f7 d2                       	notl	%edx
180343912: b9 12 00 00 00              	movl	$0x12, %ecx
180343917: 29 c1                       	subl	%eax, %ecx
180343919: d3 c2                       	roll	%cl, %edx
18034391b: 81 f2 2d f5 66 ab           	xorl	$0xab66f52d, %edx       # imm = 0xAB66F52D
180343921: 48 63 c2                    	movslq	%edx, %rax
180343924: 48 89 f1                    	movq	%rsi, %rcx
180343927: ff 14 c7                    	callq	*(%rdi,%rax,8)
18034392a: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343931: 48 89 c2                    	movq	%rax, %rdx
180343934: e8 47 22 fd ff              	callq	0x180315b80 <.text+0x305b80>
180343939: 48 63 15 c4 48 48 00        	movslq	0x4848c4(%rip), %rdx    # 0x1807c8204
180343940: 45 31 c0                    	xorl	%r8d, %r8d
180343943: 4c 8d 2d 36 59 31 00        	leaq	0x315936(%rip), %r13    # 0x180659280
18034394a: 45 2b 44 95 00              	subl	(%r13,%rdx,4), %r8d
18034394f: b9 08 00 00 00              	movl	$0x8, %ecx
180343954: 29 d1                       	subl	%edx, %ecx
180343956: 41 d3 c0                    	roll	%cl, %r8d
180343959: 41 f7 d0                    	notl	%r8d
18034395c: 8d 4a 08                    	leal	0x8(%rdx), %ecx
18034395f: 41 d3 c8                    	rorl	%cl, %r8d
180343962: 49 63 d0                    	movslq	%r8d, %rdx
180343965: 48 8d 1d 64 01 48 00        	leaq	0x480164(%rip), %rbx    # 0x1807c3ad0
18034396c: 44 8b 0c 93                 	movl	(%rbx,%rdx,4), %r9d
180343970: 41 b8 38 93 c9 34           	movl	$0x34c99338, %r8d       # imm = 0x34C99338
180343976: 41 29 d0                    	subl	%edx, %r8d
180343979: 44 89 c1                    	movl	%r8d, %ecx
18034397c: 41 d3 c1                    	roll	%cl, %r9d
18034397f: be 38 93 c9 34              	movl	$0x34c99338, %esi       # imm = 0x34C99338
180343984: 41 81 f1 38 93 c9 34        	xorl	$0x34c99338, %r9d       # imm = 0x34C99338
18034398b: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
180343991: 89 d1                       	movl	%edx, %ecx
180343993: 41 d3 c9                    	rorl	%cl, %r9d
180343996: 41 d3 c9                    	rorl	%cl, %r9d
180343999: 44 89 c1                    	movl	%r8d, %ecx
18034399c: 41 d3 c1                    	roll	%cl, %r9d
18034399f: 41 d3 c1                    	roll	%cl, %r9d
1803439a2: 4d 63 c1                    	movslq	%r9d, %r8
1803439a5: 48 8d 95 20 03 00 00        	leaq	0x320(%rbp), %rdx
1803439ac: 48 89 c1                    	movq	%rax, %rcx
1803439af: 48 8d 3d ba a2 47 00        	leaq	0x47a2ba(%rip), %rdi    # 0x1807bdc70
1803439b6: 42 ff 14 c7                 	callq	*(%rdi,%r8,8)
1803439ba: 48 63 05 27 48 48 00        	movslq	0x484827(%rip), %rax    # 0x1807c81e8
1803439c1: 41 8b 54 85 00              	movl	(%r13,%rax,4), %edx
1803439c6: ff c2                       	incl	%edx
1803439c8: b9 0e 00 00 00              	movl	$0xe, %ecx
1803439cd: 29 c1                       	subl	%eax, %ecx
1803439cf: d3 c2                       	roll	%cl, %edx
1803439d1: b9 13 c2 31 7e              	movl	$0x7e31c213, %ecx       # imm = 0x7E31C213
1803439d6: 29 d1                       	subl	%edx, %ecx
1803439d8: f7 d2                       	notl	%edx
1803439da: 48 63 c2                    	movslq	%edx, %rax
1803439dd: 8b 04 83                    	movl	(%rbx,%rax,4), %eax
1803439e0: 41 be 13 c2 31 7e           	movl	$0x7e31c213, %r14d      # imm = 0x7E31C213
1803439e6: d3 c8                       	rorl	%cl, %eax
1803439e8: 35 eb 3d ce 81              	xorl	$0x81ce3deb, %eax       # imm = 0x81CE3DEB
1803439ed: ff c0                       	incl	%eax
1803439ef: 35 14 c2 31 7e              	xorl	$0x7e31c214, %eax       # imm = 0x7E31C214
1803439f4: 0f c8                       	bswapl	%eax
1803439f6: d3 c8                       	rorl	%cl, %eax
1803439f8: 48 98                       	cltq
1803439fa: 48 8d 8d 30 03 00 00        	leaq	0x330(%rbp), %rcx
180343a01: 48 8d 95 58 0b 00 00        	leaq	0xb58(%rbp), %rdx
180343a08: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343a0b: 48 63 05 be 4b 48 00        	movslq	0x484bbe(%rip), %rax    # 0x1807c85d0
180343a12: ba ae 3c 8a 23              	movl	$0x238a3cae, %edx       # imm = 0x238A3CAE
180343a17: 41 33 54 85 00              	xorl	(%r13,%rax,4), %edx
180343a1c: b9 0e 00 00 00              	movl	$0xe, %ecx
180343a21: 29 c1                       	subl	%eax, %ecx
180343a23: d3 c2                       	roll	%cl, %edx
180343a25: 48 63 c2                    	movslq	%edx, %rax
180343a28: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180343a2b: 0f ca                       	bswapl	%edx
180343a2d: 8d 48 0c                    	leal	0xc(%rax), %ecx
180343a30: d3 ca                       	rorl	%cl, %edx
180343a32: 81 f2 6c 00 8e 74           	xorl	$0x748e006c, %edx       # imm = 0x748E006C
180343a38: b9 0c 00 00 00              	movl	$0xc, %ecx
180343a3d: 29 c1                       	subl	%eax, %ecx
180343a3f: d3 c2                       	roll	%cl, %edx
180343a41: f7 da                       	negl	%edx
180343a43: 81 f2 6c 00 8e 74           	xorl	$0x748e006c, %edx       # imm = 0x748E006C
180343a49: 48 63 c2                    	movslq	%edx, %rax
180343a4c: 4c 8d a5 a0 0b 00 00        	leaq	0xba0(%rbp), %r12
180343a53: 4c 89 e1                    	movq	%r12, %rcx
180343a56: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343a59: 48 63 05 04 49 48 00        	movslq	0x484904(%rip), %rax    # 0x1807c8364
180343a60: 41 8b 54 85 00              	movl	(%r13,%rax,4), %edx
180343a65: b9 19 00 00 00              	movl	$0x19, %ecx
180343a6a: 29 c1                       	subl	%eax, %ecx
180343a6c: d3 c2                       	roll	%cl, %edx
180343a6e: 81 f2 66 e2 e7 ac           	xorl	$0xace7e266, %edx       # imm = 0xACE7E266
180343a74: 8d 48 19                    	leal	0x19(%rax), %ecx
180343a77: d3 ca                       	rorl	%cl, %edx
180343a79: 48 63 c2                    	movslq	%edx, %rax
180343a7c: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180343a7f: ff c2                       	incl	%edx
180343a81: b9 0b 00 00 00              	movl	$0xb, %ecx
180343a86: 29 c1                       	subl	%eax, %ecx
180343a88: d3 c2                       	roll	%cl, %edx
180343a8a: f7 da                       	negl	%edx
180343a8c: 81 f2 ab 97 2f 84           	xorl	$0x842f97ab, %edx       # imm = 0x842F97AB
180343a92: 0f ca                       	bswapl	%edx
180343a94: 48 63 c2                    	movslq	%edx, %rax
180343a97: 4c 89 e1                    	movq	%r12, %rcx
180343a9a: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343a9d: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343aa4: 48 89 c2                    	movq	%rax, %rdx
180343aa7: e8 d4 20 fd ff              	callq	0x180315b80 <.text+0x305b80>
180343aac: 48 63 15 39 47 48 00        	movslq	0x484739(%rip), %rdx    # 0x1807c81ec
180343ab3: 45 31 c0                    	xorl	%r8d, %r8d
180343ab6: 4c 8d 25 c3 57 31 00        	leaq	0x3157c3(%rip), %r12    # 0x180659280
180343abd: 45 2b 04 94                 	subl	(%r12,%rdx,4), %r8d
180343ac1: b9 08 00 00 00              	movl	$0x8, %ecx
180343ac6: 29 d1                       	subl	%edx, %ecx
180343ac8: 41 d3 c0                    	roll	%cl, %r8d
180343acb: 41 f7 d0                    	notl	%r8d
180343ace: 8d 4a 08                    	leal	0x8(%rdx), %ecx
180343ad1: 41 d3 c8                    	rorl	%cl, %r8d
180343ad4: 49 63 d0                    	movslq	%r8d, %rdx
180343ad7: 48 8d 1d f2 ff 47 00        	leaq	0x47fff2(%rip), %rbx    # 0x1807c3ad0
180343ade: 44 8b 04 93                 	movl	(%rbx,%rdx,4), %r8d
180343ae2: 29 d6                       	subl	%edx, %esi
180343ae4: 89 f1                       	movl	%esi, %ecx
180343ae6: 41 d3 c0                    	roll	%cl, %r8d
180343ae9: 41 81 f0 38 93 c9 34        	xorl	$0x34c99338, %r8d       # imm = 0x34C99338
180343af0: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
180343af6: 89 d1                       	movl	%edx, %ecx
180343af8: 41 d3 c8                    	rorl	%cl, %r8d
180343afb: 41 d3 c8                    	rorl	%cl, %r8d
180343afe: 89 f1                       	movl	%esi, %ecx
180343b00: 41 d3 c0                    	roll	%cl, %r8d
180343b03: 41 d3 c0                    	roll	%cl, %r8d
180343b06: 4d 63 c0                    	movslq	%r8d, %r8
180343b09: 48 8d 95 30 03 00 00        	leaq	0x330(%rbp), %rdx
180343b10: 48 89 c1                    	movq	%rax, %rcx
180343b13: 48 8d 3d 56 a1 47 00        	leaq	0x47a156(%rip), %rdi    # 0x1807bdc70
180343b1a: 42 ff 14 c7                 	callq	*(%rdi,%r8,8)
180343b1e: 48 63 05 cf 46 48 00        	movslq	0x4846cf(%rip), %rax    # 0x1807c81f4
180343b25: 41 8b 14 84                 	movl	(%r12,%rax,4), %edx
180343b29: ff c2                       	incl	%edx
180343b2b: b9 0e 00 00 00              	movl	$0xe, %ecx
180343b30: 29 c1                       	subl	%eax, %ecx
180343b32: d3 c2                       	roll	%cl, %edx
180343b34: 41 29 d6                    	subl	%edx, %r14d
180343b37: f7 d2                       	notl	%edx
180343b39: 48 63 c2                    	movslq	%edx, %rax
180343b3c: 8b 04 83                    	movl	(%rbx,%rax,4), %eax
180343b3f: 44 89 f1                    	movl	%r14d, %ecx
180343b42: d3 c8                       	rorl	%cl, %eax
180343b44: 35 eb 3d ce 81              	xorl	$0x81ce3deb, %eax       # imm = 0x81CE3DEB
180343b49: ff c0                       	incl	%eax
180343b4b: 35 14 c2 31 7e              	xorl	$0x7e31c214, %eax       # imm = 0x7E31C214
180343b50: 0f c8                       	bswapl	%eax
180343b52: d3 c8                       	rorl	%cl, %eax
180343b54: 48 98                       	cltq
180343b56: 48 8d 8d 40 03 00 00        	leaq	0x340(%rbp), %rcx
180343b5d: 48 8d 95 60 0b 00 00        	leaq	0xb60(%rbp), %rdx
180343b64: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343b67: 48 63 05 4a 4a 48 00        	movslq	0x484a4a(%rip), %rax    # 0x1807c85b8
180343b6e: 31 d2                       	xorl	%edx, %edx
180343b70: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180343b74: 8d 88 b0 1a 7c 90           	leal	-0x6f83e550(%rax), %ecx
180343b7a: d3 ca                       	rorl	%cl, %edx
180343b7c: d3 ca                       	rorl	%cl, %edx
180343b7e: b9 10 00 00 00              	movl	$0x10, %ecx
180343b83: 29 c1                       	subl	%eax, %ecx
180343b85: d3 c2                       	roll	%cl, %edx
180343b87: 48 63 c2                    	movslq	%edx, %rax
180343b8a: ba 8a ed 5b fb              	movl	$0xfb5bed8a, %edx       # imm = 0xFB5BED8A
180343b8f: 33 14 83                    	xorl	(%rbx,%rax,4), %edx
180343b92: b9 15 00 00 00              	movl	$0x15, %ecx
180343b97: 29 c1                       	subl	%eax, %ecx
180343b99: d3 c2                       	roll	%cl, %edx
180343b9b: b8 fe ff ff ff              	movl	$0xfffffffe, %eax       # imm = 0xFFFFFFFE
180343ba0: 29 d0                       	subl	%edx, %eax
180343ba2: 48 98                       	cltq
180343ba4: 48 8d b5 a0 0b 00 00        	leaq	0xba0(%rbp), %rsi
180343bab: 48 89 f1                    	movq	%rsi, %rcx
180343bae: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343bb1: 48 63 0d 94 47 48 00        	movslq	0x484794(%rip), %rcx    # 0x1807c834c
180343bb8: b8 16 45 e8 29              	movl	$0x29e84516, %eax       # imm = 0x29E84516
180343bbd: 41 33 04 8c                 	xorl	(%r12,%rcx,4), %eax
180343bc1: 8d 48 01                    	leal	0x1(%rax), %ecx
180343bc4: 48 63 c9                    	movslq	%ecx, %rcx
180343bc7: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
180343bcb: ba 89 70 08 f8              	movl	$0xf8087089, %edx       # imm = 0xF8087089
180343bd0: 29 c2                       	subl	%eax, %edx
180343bd2: 89 d1                       	movl	%edx, %ecx
180343bd4: 41 d3 c0                    	roll	%cl, %r8d
180343bd7: 41 f7 d0                    	notl	%r8d
180343bda: 41 0f c8                    	bswapl	%r8d
180343bdd: 05 8b 70 08 f8              	addl	$0xf808708b, %eax       # imm = 0xF808708B
180343be2: 89 c1                       	movl	%eax, %ecx
180343be4: 41 d3 c8                    	rorl	%cl, %r8d
180343be7: 89 d1                       	movl	%edx, %ecx
180343be9: 41 d3 c0                    	roll	%cl, %r8d
180343bec: 89 c1                       	movl	%eax, %ecx
180343bee: 41 d3 c8                    	rorl	%cl, %r8d
180343bf1: 49 63 c0                    	movslq	%r8d, %rax
180343bf4: 48 89 f1                    	movq	%rsi, %rcx
180343bf7: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343bfa: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343c01: 48 89 c2                    	movq	%rax, %rdx
180343c04: e8 77 1f fd ff              	callq	0x180315b80 <.text+0x305b80>
180343c09: 48 63 15 f0 45 48 00        	movslq	0x4845f0(%rip), %rdx    # 0x1807c8200
180343c10: 45 31 c0                    	xorl	%r8d, %r8d
180343c13: 48 8d 0d 66 56 31 00        	leaq	0x315666(%rip), %rcx    # 0x180659280
180343c1a: 44 2b 04 91                 	subl	(%rcx,%rdx,4), %r8d
180343c1e: b9 08 00 00 00              	movl	$0x8, %ecx
180343c23: 29 d1                       	subl	%edx, %ecx
180343c25: 41 d3 c0                    	roll	%cl, %r8d
180343c28: 45 31 f6                    	xorl	%r14d, %r14d
180343c2b: 41 f7 d0                    	notl	%r8d
180343c2e: 8d 4a 08                    	leal	0x8(%rdx), %ecx
180343c31: 41 d3 c8                    	rorl	%cl, %r8d
180343c34: 49 63 d0                    	movslq	%r8d, %rdx
180343c37: 48 8d 0d 92 fe 47 00        	leaq	0x47fe92(%rip), %rcx    # 0x1807c3ad0
180343c3e: 44 8b 0c 91                 	movl	(%rcx,%rdx,4), %r9d
180343c42: 41 b8 38 93 c9 34           	movl	$0x34c99338, %r8d       # imm = 0x34C99338
180343c48: 41 29 d0                    	subl	%edx, %r8d
180343c4b: 44 89 c1                    	movl	%r8d, %ecx
180343c4e: 41 d3 c1                    	roll	%cl, %r9d
180343c51: be 08 00 00 00              	movl	$0x8, %esi
180343c56: 41 81 f1 38 93 c9 34        	xorl	$0x34c99338, %r9d       # imm = 0x34C99338
180343c5d: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
180343c63: 89 d1                       	movl	%edx, %ecx
180343c65: 41 d3 c9                    	rorl	%cl, %r9d
180343c68: 41 d3 c9                    	rorl	%cl, %r9d
180343c6b: 44 89 c1                    	movl	%r8d, %ecx
180343c6e: 41 d3 c1                    	roll	%cl, %r9d
180343c71: 41 d3 c1                    	roll	%cl, %r9d
180343c74: 4d 63 c1                    	movslq	%r9d, %r8
180343c77: 48 8d 95 40 03 00 00        	leaq	0x340(%rbp), %rdx
180343c7e: 48 89 c1                    	movq	%rax, %rcx
180343c81: 48 8d 05 e8 9f 47 00        	leaq	0x479fe8(%rip), %rax    # 0x1807bdc70
180343c88: 42 ff 14 c0                 	callq	*(%rax,%r8,8)
180343c8c: 48 8d 8d 50 03 00 00        	leaq	0x350(%rbp), %rcx
180343c93: 48 8d 95 60 05 00 00        	leaq	0x560(%rbp), %rdx
180343c9a: e8 61 8a 00 00              	callq	0x18034c700 <.text+0x33c700>
180343c9f: 48 63 05 36 49 48 00        	movslq	0x484936(%rip), %rax    # 0x1807c85dc
180343ca6: 4c 8d 25 d3 55 31 00        	leaq	0x3155d3(%rip), %r12    # 0x180659280
180343cad: 45 2b 34 84                 	subl	(%r12,%rax,4), %r14d
180343cb1: 29 c6                       	subl	%eax, %esi
180343cb3: 89 f1                       	movl	%esi, %ecx
180343cb5: 41 d3 c6                    	roll	%cl, %r14d
180343cb8: 49 63 c6                    	movslq	%r14d, %rax
180343cbb: 48 8d 1d 0e fe 47 00        	leaq	0x47fe0e(%rip), %rbx    # 0x1807c3ad0
180343cc2: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180343cc5: b9 08 df d6 75              	movl	$0x75d6df08, %ecx       # imm = 0x75D6DF08
180343cca: 29 c1                       	subl	%eax, %ecx
180343ccc: d3 c2                       	roll	%cl, %edx
180343cce: d3 c2                       	roll	%cl, %edx
180343cd0: f7 da                       	negl	%edx
180343cd2: 83 c0 08                    	addl	$0x8, %eax
180343cd5: 89 c1                       	movl	%eax, %ecx
180343cd7: d3 ca                       	rorl	%cl, %edx
180343cd9: 48 63 c2                    	movslq	%edx, %rax
180343cdc: 48 8d b5 a0 0b 00 00        	leaq	0xba0(%rbp), %rsi
180343ce3: 48 89 f1                    	movq	%rsi, %rcx
180343ce6: 48 8d 3d 83 9f 47 00        	leaq	0x479f83(%rip), %rdi    # 0x1807bdc70
180343ced: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343cf0: 48 63 05 79 46 48 00        	movslq	0x484679(%rip), %rax    # 0x1807c8370
180343cf7: 41 8b 14 84                 	movl	(%r12,%rax,4), %edx
180343cfb: f7 d2                       	notl	%edx
180343cfd: b9 0b 00 00 00              	movl	$0xb, %ecx
180343d02: 29 c1                       	subl	%eax, %ecx
180343d04: d3 c2                       	roll	%cl, %edx
180343d06: 81 f2 b9 66 45 eb           	xorl	$0xeb4566b9, %edx       # imm = 0xEB4566B9
180343d0c: 0f ca                       	bswapl	%edx
180343d0e: 48 63 ca                    	movslq	%edx, %rcx
180343d11: b8 01 63 73 b6              	movl	$0xb6736301, %eax       # imm = 0xB6736301
180343d16: 33 04 8b                    	xorl	(%rbx,%rcx,4), %eax
180343d19: 0f c8                       	bswapl	%eax
180343d1b: 81 c1 01 63 73 b6           	addl	$0xb6736301, %ecx       # imm = 0xB6736301
180343d21: d3 c8                       	rorl	%cl, %eax
180343d23: f7 d0                       	notl	%eax
180343d25: 0f c8                       	bswapl	%eax
180343d27: f7 d8                       	negl	%eax
180343d29: d3 c8                       	rorl	%cl, %eax
180343d2b: 35 01 63 73 b6              	xorl	$0xb6736301, %eax       # imm = 0xB6736301
180343d30: 48 98                       	cltq
180343d32: 48 89 f1                    	movq	%rsi, %rcx
180343d35: ff 14 c7                    	callq	*(%rdi,%rax,8)
180343d38: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343d3f: 48 89 c2                    	movq	%rax, %rdx
180343d42: e8 39 1e fd ff              	callq	0x180315b80 <.text+0x305b80>
180343d47: 48 63 15 aa 44 48 00        	movslq	0x4844aa(%rip), %rdx    # 0x1807c81f8
180343d4e: 45 31 c0                    	xorl	%r8d, %r8d
180343d51: 48 8d 0d 28 55 31 00        	leaq	0x315528(%rip), %rcx    # 0x180659280
180343d58: 44 2b 04 91                 	subl	(%rcx,%rdx,4), %r8d
180343d5c: b9 08 00 00 00              	movl	$0x8, %ecx
180343d61: 29 d1                       	subl	%edx, %ecx
180343d63: 41 d3 c0                    	roll	%cl, %r8d
180343d66: 41 f7 d0                    	notl	%r8d
180343d69: 8d 4a 08                    	leal	0x8(%rdx), %ecx
180343d6c: 41 d3 c8                    	rorl	%cl, %r8d
180343d6f: 49 63 d0                    	movslq	%r8d, %rdx
180343d72: 48 8d 0d 57 fd 47 00        	leaq	0x47fd57(%rip), %rcx    # 0x1807c3ad0
180343d79: 44 8b 0c 91                 	movl	(%rcx,%rdx,4), %r9d
180343d7d: 41 b8 38 93 c9 34           	movl	$0x34c99338, %r8d       # imm = 0x34C99338
180343d83: 41 29 d0                    	subl	%edx, %r8d
180343d86: 44 89 c1                    	movl	%r8d, %ecx
180343d89: 41 d3 c1                    	roll	%cl, %r9d
180343d8c: 41 81 f1 38 93 c9 34        	xorl	$0x34c99338, %r9d       # imm = 0x34C99338
180343d93: 81 c2 38 93 c9 34           	addl	$0x34c99338, %edx       # imm = 0x34C99338
180343d99: 89 d1                       	movl	%edx, %ecx
180343d9b: 41 d3 c9                    	rorl	%cl, %r9d
180343d9e: 41 d3 c9                    	rorl	%cl, %r9d
180343da1: 44 89 c1                    	movl	%r8d, %ecx
180343da4: 41 d3 c1                    	roll	%cl, %r9d
180343da7: 41 d3 c1                    	roll	%cl, %r9d
180343daa: 4d 63 c1                    	movslq	%r9d, %r8
180343dad: 48 8d 95 50 03 00 00        	leaq	0x350(%rbp), %rdx
180343db4: 48 89 c1                    	movq	%rax, %rcx
180343db7: 48 8d 05 b2 9e 47 00        	leaq	0x479eb2(%rip), %rax    # 0x1807bdc70
180343dbe: 42 ff 14 c0                 	callq	*(%rax,%r8,8)
180343dc2: 4c 8d a5 20 05 00 00        	leaq	0x520(%rbp), %r12
180343dc9: 48 8d 8d 00 02 00 00        	leaq	0x200(%rbp), %rcx
180343dd0: 4c 89 e2                    	movq	%r12, %rdx
180343dd3: e8 88 06 d6 ff              	callq	0x1800a4460 <.text+0x94460>
180343dd8: 80 bd c7 0c 00 00 00        	cmpb	$0x0, 0xcc7(%rbp)
180343ddf: 48 8d 85 e0 04 00 00        	leaq	0x4e0(%rbp), %rax
180343de6: 4c 0f 45 f8                 	cmovneq	%rax, %r15
180343dea: 48 8d 8d 80 05 00 00        	leaq	0x580(%rbp), %rcx
180343df1: 4c 89 fa                    	movq	%r15, %rdx
180343df4: e8 67 06 d6 ff              	callq	0x1800a4460 <.text+0x94460>
180343df9: 41 b8 3d db cb ee           	movl	$0xeecbdb3d, %r8d       # imm = 0xEECBDB3D
180343dff: 44 33 05 a6 cb 46 00        	xorl	0x46cba6(%rip), %r8d    # 0x1807b09ac
180343e06: 41 81 c0 be 75 0a ad        	addl	$0xad0a75be, %r8d       # imm = 0xAD0A75BE
180343e0d: 44 0f b6 0d 9b cb 46 00     	movzbl	0x46cb9b(%rip), %r9d    # 0x1807b09b0
180343e15: 41 80 f1 a3                 	xorb	$-0x5d, %r9b
180343e19: 41 80 c1 df                 	addb	$-0x21, %r9b
180343e1d: b8 82 81 c0 81              	movl	$0x81c08182, %eax       # imm = 0x81C08182
180343e22: 33 05 8c cb 46 00           	xorl	0x46cb8c(%rip), %eax    # 0x1807b09b4
180343e28: 05 9d 59 88 07              	addl	$0x788599d, %eax        # imm = 0x788599D
180343e2d: 89 44 24 28                 	movl	%eax, 0x28(%rsp)
180343e31: c6 44 24 20 00              	movb	$0x0, 0x20(%rsp)
180343e36: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343e3d: 48 8d 95 a0 0b 00 00        	leaq	0xba0(%rbp), %rdx
180343e44: e8 57 6a fd ff              	callq	0x18031a8a0 <.text+0x30a8a0>
180343e49: 48 63 15 ac 43 48 00        	movslq	0x4843ac(%rip), %rdx    # 0x1807c81fc
180343e50: 4c 8d 3d 29 54 31 00        	leaq	0x315429(%rip), %r15    # 0x180659280
180343e57: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180343e5b: b9 0b 00 00 00              	movl	$0xb, %ecx
180343e60: 29 d1                       	subl	%edx, %ecx
180343e62: d3 c0                       	roll	%cl, %eax
180343e64: f7 d0                       	notl	%eax
180343e66: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180343e69: d3 c8                       	rorl	%cl, %eax
180343e6b: 89 c1                       	movl	%eax, %ecx
180343e6d: f7 d1                       	notl	%ecx
180343e6f: 48 63 c9                    	movslq	%ecx, %rcx
180343e72: 48 8d 1d 57 fc 47 00        	leaq	0x47fc57(%rip), %rbx    # 0x1807c3ad0
180343e79: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
180343e7d: 41 0f c8                    	bswapl	%r8d
180343e80: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180343e85: 29 c2                       	subl	%eax, %edx
180343e87: 89 d1                       	movl	%edx, %ecx
180343e89: 41 d3 c8                    	rorl	%cl, %r8d
180343e8c: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180343e91: 89 c1                       	movl	%eax, %ecx
180343e93: 41 d3 c0                    	roll	%cl, %r8d
180343e96: 89 d1                       	movl	%edx, %ecx
180343e98: 41 d3 c8                    	rorl	%cl, %r8d
180343e9b: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180343ea2: 41 ff c0                    	incl	%r8d
180343ea5: 89 c1                       	movl	%eax, %ecx
180343ea7: 41 d3 c0                    	roll	%cl, %r8d
180343eaa: 41 f7 d0                    	notl	%r8d
180343ead: 49 63 c0                    	movslq	%r8d, %rax
180343eb0: 48 8d b5 20 02 00 00        	leaq	0x220(%rbp), %rsi
180343eb7: 48 8d bd a0 0b 00 00        	leaq	0xba0(%rbp), %rdi
180343ebe: 48 89 f1                    	movq	%rsi, %rcx
180343ec1: 48 89 fa                    	movq	%rdi, %rdx
180343ec4: 4c 8d 35 a5 9d 47 00        	leaq	0x479da5(%rip), %r14    # 0x1807bdc70
180343ecb: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180343ecf: 48 63 05 6e 44 48 00        	movslq	0x48446e(%rip), %rax    # 0x1807c8344
180343ed6: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180343eda: b9 0a 00 00 00              	movl	$0xa, %ecx
180343edf: 29 c1                       	subl	%eax, %ecx
180343ee1: d3 c2                       	roll	%cl, %edx
180343ee3: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180343ee9: d3 ca                       	rorl	%cl, %edx
180343eeb: d3 ca                       	rorl	%cl, %edx
180343eed: d3 ca                       	rorl	%cl, %edx
180343eef: 48 63 c2                    	movslq	%edx, %rax
180343ef2: 31 d2                       	xorl	%edx, %edx
180343ef4: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
180343ef7: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180343efd: d3 ca                       	rorl	%cl, %edx
180343eff: d3 ca                       	rorl	%cl, %edx
180343f01: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180343f07: d3 ca                       	rorl	%cl, %edx
180343f09: 31 db                       	xorl	%ebx, %ebx
180343f0b: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180343f10: 29 c1                       	subl	%eax, %ecx
180343f12: d3 c2                       	roll	%cl, %edx
180343f14: d3 c2                       	roll	%cl, %edx
180343f16: 48 63 c2                    	movslq	%edx, %rax
180343f19: 48 89 f9                    	movq	%rdi, %rcx
180343f1c: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180343f20: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343f27: e8 04 7d fd ff              	callq	0x18031bc30 <.text+0x30bc30>
180343f2c: 48 63 05 1d 44 48 00        	movslq	0x48441d(%rip), %rax    # 0x1807c8350
180343f33: 4c 8d 3d 46 53 31 00        	leaq	0x315346(%rip), %r15    # 0x180659280
180343f3a: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180343f3e: f7 d2                       	notl	%edx
180343f40: 8d 88 fa 59 48 ef           	leal	-0x10b7a606(%rax), %ecx
180343f46: d3 ca                       	rorl	%cl, %edx
180343f48: d3 ca                       	rorl	%cl, %edx
180343f4a: d3 ca                       	rorl	%cl, %edx
180343f4c: 48 63 c2                    	movslq	%edx, %rax
180343f4f: 48 8d 3d 7a fb 47 00        	leaq	0x47fb7a(%rip), %rdi    # 0x1807c3ad0
180343f56: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180343f59: b9 89 92 20 64              	movl	$0x64209289, %ecx       # imm = 0x64209289
180343f5e: 29 c1                       	subl	%eax, %ecx
180343f60: d3 c2                       	roll	%cl, %edx
180343f62: d3 c2                       	roll	%cl, %edx
180343f64: 81 f2 89 92 20 64           	xorl	$0x64209289, %edx       # imm = 0x64209289
180343f6a: 0f ca                       	bswapl	%edx
180343f6c: 48 63 c2                    	movslq	%edx, %rax
180343f6f: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180343f76: 4c 8d 35 f3 9c 47 00        	leaq	0x479cf3(%rip), %r14    # 0x1807bdc70
180343f7d: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180343f81: 48 63 05 4c 46 48 00        	movslq	0x48464c(%rip), %rax    # 0x1807c85d4
180343f88: ba 87 60 b5 ef              	movl	$0xefb56087, %edx       # imm = 0xEFB56087
180343f8d: 41 33 14 87                 	xorl	(%r15,%rax,4), %edx
180343f91: b9 18 00 00 00              	movl	$0x18, %ecx
180343f96: 29 c1                       	subl	%eax, %ecx
180343f98: d3 c2                       	roll	%cl, %edx
180343f9a: 8d 48 18                    	leal	0x18(%rax), %ecx
180343f9d: d3 ca                       	rorl	%cl, %edx
180343f9f: 48 63 c2                    	movslq	%edx, %rax
180343fa2: ba 6a 11 7b 25              	movl	$0x257b116a, %edx       # imm = 0x257B116A
180343fa7: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180343fab: 41 31 d0                    	xorl	%edx, %r8d
180343fae: 41 0f c8                    	bswapl	%r8d
180343fb1: 29 c2                       	subl	%eax, %edx
180343fb3: 89 d1                       	movl	%edx, %ecx
180343fb5: 41 d3 c0                    	roll	%cl, %r8d
180343fb8: 05 6a 11 7b 25              	addl	$0x257b116a, %eax       # imm = 0x257B116A
180343fbd: 89 c1                       	movl	%eax, %ecx
180343fbf: 41 d3 c8                    	rorl	%cl, %r8d
180343fc2: 41 d3 c8                    	rorl	%cl, %r8d
180343fc5: 89 d1                       	movl	%edx, %ecx
180343fc7: 41 d3 c0                    	roll	%cl, %r8d
180343fca: 49 63 c0                    	movslq	%r8d, %rax
180343fcd: 4c 8d a5 80 08 00 00        	leaq	0x880(%rbp), %r12
180343fd4: 4c 89 e1                    	movq	%r12, %rcx
180343fd7: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180343fdb: 48 63 05 96 43 48 00        	movslq	0x484396(%rip), %rax    # 0x1807c8378
180343fe2: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180343fe6: 8d 48 1d                    	leal	0x1d(%rax), %ecx
180343fe9: d3 ca                       	rorl	%cl, %edx
180343feb: b9 26 0a 79 50              	movl	$0x50790a26, %ecx       # imm = 0x50790A26
180343ff0: 29 d1                       	subl	%edx, %ecx
180343ff2: f7 d2                       	notl	%edx
180343ff4: 48 63 c2                    	movslq	%edx, %rax
180343ff7: ba d8 f5 86 af              	movl	$0xaf86f5d8, %edx       # imm = 0xAF86F5D8
180343ffc: 33 14 87                    	xorl	(%rdi,%rax,4), %edx
180343fff: d3 ca                       	rorl	%cl, %edx
180344001: d3 ca                       	rorl	%cl, %edx
180344003: ff c2                       	incl	%edx
180344005: 48 63 c2                    	movslq	%edx, %rax
180344008: 4c 89 e1                    	movq	%r12, %rcx
18034400b: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
18034400f: 48 63 0d f2 41 48 00        	movslq	0x4841f2(%rip), %rcx    # 0x1807c8208
180344016: 41 8b 14 8f                 	movl	(%r15,%rcx,4), %edx
18034401a: 81 c1 b3 3a c7 db           	addl	$0xdbc73ab3, %ecx       # imm = 0xDBC73AB3
180344020: d3 ca                       	rorl	%cl, %edx
180344022: d3 ca                       	rorl	%cl, %edx
180344024: 81 f2 db c7 3a b3           	xorl	$0xb33ac7db, %edx       # imm = 0xB33AC7DB
18034402a: 0f ca                       	bswapl	%edx
18034402c: 48 63 d2                    	movslq	%edx, %rdx
18034402f: 2b 1c 97                    	subl	(%rdi,%rdx,4), %ebx
180344032: 0f cb                       	bswapl	%ebx
180344034: b9 11 39 22 28              	movl	$0x28223911, %ecx       # imm = 0x28223911
180344039: 29 d1                       	subl	%edx, %ecx
18034403b: d3 c3                       	roll	%cl, %ebx
18034403d: d3 c3                       	roll	%cl, %ebx
18034403f: 4c 63 c3                    	movslq	%ebx, %r8
180344042: 48 8d 7d 50                 	leaq	0x50(%rbp), %rdi
180344046: 48 89 f9                    	movq	%rdi, %rcx
180344049: 48 89 c2                    	movq	%rax, %rdx
18034404c: 43 ff 14 c6                 	callq	*(%r14,%r8,8)
180344050: 48 89 74 24 20              	movq	%rsi, 0x20(%rsp)
180344055: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
18034405c: 48 8d 95 00 02 00 00        	leaq	0x200(%rbp), %rdx
180344063: 4c 8d 85 80 05 00 00        	leaq	0x580(%rbp), %r8
18034406a: 49 89 f9                    	movq	%rdi, %r9
18034406d: e8 9e 05 fe ff              	callq	0x180324610 <.text+0x314610>
180344072: 48 8d 8d 20 02 00 00        	leaq	0x220(%rbp), %rcx
180344079: e8 f2 78 fd ff              	callq	0x18031b970 <.text+0x30b970>
18034407e: 48 63 05 d3 42 48 00        	movslq	0x4842d3(%rip), %rax    # 0x1807c8358
180344085: 48 8d 1d f4 51 31 00        	leaq	0x3151f4(%rip), %rbx    # 0x180659280
18034408c: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
18034408f: b9 fb 45 97 34              	movl	$0x349745fb, %ecx       # imm = 0x349745FB
180344094: 29 c1                       	subl	%eax, %ecx
180344096: d3 c2                       	roll	%cl, %edx
180344098: d3 c2                       	roll	%cl, %edx
18034409a: 8d 48 1b                    	leal	0x1b(%rax), %ecx
18034409d: d3 ca                       	rorl	%cl, %edx
18034409f: 0f ca                       	bswapl	%edx
1803440a1: 48 63 c2                    	movslq	%edx, %rax
1803440a4: 4c 8d 35 25 fa 47 00        	leaq	0x47fa25(%rip), %r14    # 0x1807c3ad0
1803440ab: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803440af: 89 c1                       	movl	%eax, %ecx
1803440b1: f7 d1                       	notl	%ecx
1803440b3: d3 c2                       	roll	%cl, %edx
1803440b5: 81 f2 df 64 05 19           	xorl	$0x190564df, %edx       # imm = 0x190564DF
1803440bb: ff c8                       	decl	%eax
1803440bd: 89 c1                       	movl	%eax, %ecx
1803440bf: d3 ca                       	rorl	%cl, %edx
1803440c1: b8 01 00 00 00              	movl	$0x1, %eax
1803440c6: 29 d0                       	subl	%edx, %eax
1803440c8: 35 19 05 64 df              	xorl	$0xdf640519, %eax       # imm = 0xDF640519
1803440cd: 0f c8                       	bswapl	%eax
1803440cf: 48 98                       	cltq
1803440d1: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
1803440d8: 4c 8d 2d 91 9b 47 00        	leaq	0x479b91(%rip), %r13    # 0x1807bdc70
1803440df: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803440e4: 84 c0                       	testb	%al, %al
1803440e6: 0f 84 a1 2c 00 00           	je	0x180346d8d <.text+0x336d8d>
1803440ec: 48 63 05 f1 44 48 00        	movslq	0x4844f1(%rip), %rax    # 0x1807c85e4
1803440f3: 31 c9                       	xorl	%ecx, %ecx
1803440f5: 2b 0c 83                    	subl	(%rbx,%rax,4), %ecx
1803440f8: 0f c9                       	bswapl	%ecx
1803440fa: 48 63 c1                    	movslq	%ecx, %rax
1803440fd: ba eb bc ca 06              	movl	$0x6cabceb, %edx        # imm = 0x6CABCEB
180344102: 41 33 14 86                 	xorl	(%r14,%rax,4), %edx
180344106: 31 ff                       	xorl	%edi, %edi
180344108: b9 0b 00 00 00              	movl	$0xb, %ecx
18034410d: 29 c1                       	subl	%eax, %ecx
18034410f: d3 c2                       	roll	%cl, %edx
180344111: f7 da                       	negl	%edx
180344113: 0f ca                       	bswapl	%edx
180344115: f7 da                       	negl	%edx
180344117: 81 f2 eb bc ca 06           	xorl	$0x6cabceb, %edx        # imm = 0x6CABCEB
18034411d: 48 63 c2                    	movslq	%edx, %rax
180344120: 48 8d b5 40 04 00 00        	leaq	0x440(%rbp), %rsi
180344127: 48 89 f1                    	movq	%rsi, %rcx
18034412a: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034412f: 48 63 05 1e 42 48 00        	movslq	0x48421e(%rip), %rax    # 0x1807c8354
180344136: ba 2e eb e1 14              	movl	$0x14e1eb2e, %edx       # imm = 0x14E1EB2E
18034413b: 33 14 83                    	xorl	(%rbx,%rax,4), %edx
18034413e: 8d 48 0e                    	leal	0xe(%rax), %ecx
180344141: d3 ca                       	rorl	%cl, %edx
180344143: 48 63 c2                    	movslq	%edx, %rax
180344146: 45 8b 04 86                 	movl	(%r14,%rax,4), %r8d
18034414a: 41 f7 d0                    	notl	%r8d
18034414d: ba 8d 1e df aa              	movl	$0xaadf1e8d, %edx       # imm = 0xAADF1E8D
180344152: 29 c2                       	subl	%eax, %edx
180344154: 89 d1                       	movl	%edx, %ecx
180344156: 41 d3 c0                    	roll	%cl, %r8d
180344159: 05 8d 1e df aa              	addl	$0xaadf1e8d, %eax       # imm = 0xAADF1E8D
18034415e: 89 c1                       	movl	%eax, %ecx
180344160: 41 d3 c8                    	rorl	%cl, %r8d
180344163: 89 d1                       	movl	%edx, %ecx
180344165: 41 d3 c0                    	roll	%cl, %r8d
180344168: 41 d3 c0                    	roll	%cl, %r8d
18034416b: 41 f7 d0                    	notl	%r8d
18034416e: 41 d3 c0                    	roll	%cl, %r8d
180344171: 89 c1                       	movl	%eax, %ecx
180344173: 41 d3 c8                    	rorl	%cl, %r8d
180344176: 49 63 c0                    	movslq	%r8d, %rax
180344179: 48 89 f1                    	movq	%rsi, %rcx
18034417c: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180344181: 48 89 85 b0 07 00 00        	movq	%rax, 0x7b0(%rbp)
180344188: 8b 0d 8a c3 54 00           	movl	0x54c38a(%rip), %ecx    # 0x180890518
18034418e: 83 c1 18                    	addl	$0x18, %ecx
180344191: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
180344196: d3 c8                       	rorl	%cl, %eax
180344198: 48 98                       	cltq
18034419a: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
18034419e: b9 07 00 00 00              	movl	$0x7, %ecx
1803441a3: 29 c1                       	subl	%eax, %ecx
1803441a5: d3 c2                       	roll	%cl, %edx
1803441a7: 0f ca                       	bswapl	%edx
1803441a9: 48 63 c2                    	movslq	%edx, %rax
1803441ac: 49 8b 44 c5 00              	movq	(%r13,%rax,8), %rax
1803441b1: c6 85 ab 0c 00 00 01        	movb	$0x1, 0xcab(%rbp)
1803441b8: 4c 89 a5 30 0a 00 00        	movq	%r12, 0xa30(%rbp)
1803441bf: 48 8d b5 f0 0a 00 00        	leaq	0xaf0(%rbp), %rsi
1803441c6: 48 8d 95 b0 07 00 00        	leaq	0x7b0(%rbp), %rdx
1803441cd: 48 89 f1                    	movq	%rsi, %rcx
1803441d0: ff d0                       	callq	*%rax
1803441d2: 48 c7 85 00 0b 00 00 00 00 00 00    	movq	$0x0, 0xb00(%rbp)
1803441dd: 48 63 15 98 b8 54 00        	movslq	0x54b898(%rip), %rdx    # 0x18088fa7c
1803441e4: 48 8d 05 3d 3e 31 00        	leaq	0x313e3d(%rip), %rax    # 0x180658028
1803441eb: 2b 3c 90                    	subl	(%rax,%rdx,4), %edi
1803441ee: b8 4a 44 3a 89              	movl	$0x893a444a, %eax       # imm = 0x893A444A
1803441f3: 29 d0                       	subl	%edx, %eax
1803441f5: 89 c1                       	movl	%eax, %ecx
1803441f7: d3 c7                       	roll	%cl, %edi
1803441f9: 8d 4a 0a                    	leal	0xa(%rdx), %ecx
1803441fc: d3 cf                       	rorl	%cl, %edi
1803441fe: 89 c1                       	movl	%eax, %ecx
180344200: d3 c7                       	roll	%cl, %edi
180344202: 48 63 cf                    	movslq	%edi, %rcx
180344205: b8 61 76 2b 9a              	movl	$0x9a2b7661, %eax       # imm = 0x9A2B7661
18034420a: 48 8d 15 6f 27 47 00        	leaq	0x47276f(%rip), %rdx    # 0x1807b6980
180344211: 33 04 8a                    	xorl	(%rdx,%rcx,4), %eax
180344214: 0f c8                       	bswapl	%eax
180344216: ff c1                       	incl	%ecx
180344218: d3 c8                       	rorl	%cl, %eax
18034421a: 48 8d 8d 08 0b 00 00        	leaq	0xb08(%rbp), %rcx
180344221: f7 d8                       	negl	%eax
180344223: 48 98                       	cltq
180344225: 48 8d 15 a4 1b 47 00        	leaq	0x471ba4(%rip), %rdx    # 0x1807b5dd0
18034422c: 48 8b 14 c2                 	movq	(%rdx,%rax,8), %rdx
180344230: e8 5b 74 ff ff              	callq	0x18033b690 <.text+0x32b690>
180344235: 48 89 b5 70 03 00 00        	movq	%rsi, 0x370(%rbp)
18034423c: 48 b8 43 89 f1 49 cd 54 68 1e       	movabsq	$0x1e6854cd49f18943, %rax # imm = 0x1E6854CD49F18943
180344246: 48 33 05 9b c8 46 00        	xorq	0x46c89b(%rip), %rax    # 0x1807b0ae8
18034424d: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344251: 48 8d 04 c5 f0 0a 00 00     	leaq	0xaf0(,%rax,8), %rax
180344259: 48 01 e8                    	addq	%rbp, %rax
18034425c: 48 b9 10 a6 f2 34 20 42 ad c6       	movabsq	$-0x3952bddfcb0d59f0, %rcx # imm = 0xC6AD422034F2A610
180344266: 48 01 c1                    	addq	%rax, %rcx
180344269: 48 89 8d 78 03 00 00        	movq	%rcx, 0x378(%rbp)
180344270: c6 85 ac 0c 00 00 01        	movb	$0x1, 0xcac(%rbp)
180344277: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
18034427e: 48 89 8d 38 0a 00 00        	movq	%rcx, 0xa38(%rbp)
180344285: 48 8d 95 70 03 00 00        	leaq	0x370(%rbp), %rdx
18034428c: e8 8f bf fc ff              	callq	0x180310220 <.text+0x300220>
180344291: 48 8d bd 50 0c 00 00        	leaq	0xc50(%rbp), %rdi
180344298: 4c 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %r14
18034429f: 48 63 05 26 43 48 00        	movslq	0x484326(%rip), %rax    # 0x1807c85cc
1803442a6: 45 31 c0                    	xorl	%r8d, %r8d
1803442a9: 48 8d 1d d0 4f 31 00        	leaq	0x314fd0(%rip), %rbx    # 0x180659280
1803442b0: 44 2b 04 83                 	subl	(%rbx,%rax,4), %r8d
1803442b4: 31 d2                       	xorl	%edx, %edx
1803442b6: b9 1e 00 00 00              	movl	$0x1e, %ecx
1803442bb: 29 c1                       	subl	%eax, %ecx
1803442bd: 41 d3 c0                    	roll	%cl, %r8d
1803442c0: 8d 48 1e                    	leal	0x1e(%rax), %ecx
1803442c3: 41 d3 c8                    	rorl	%cl, %r8d
1803442c6: 41 81 f0 de 08 ec 91        	xorl	$0x91ec08de, %r8d       # imm = 0x91EC08DE
1803442cd: 49 63 c0                    	movslq	%r8d, %rax
1803442d0: 4c 8d 3d f9 f7 47 00        	leaq	0x47f7f9(%rip), %r15    # 0x1807c3ad0
1803442d7: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
1803442db: 81 f2 d5 7d 96 40           	xorl	$0x40967dd5, %edx       # imm = 0x40967DD5
1803442e1: b9 0a 00 00 00              	movl	$0xa, %ecx
1803442e6: 29 c1                       	subl	%eax, %ecx
1803442e8: d3 c2                       	roll	%cl, %edx
1803442ea: f7 d2                       	notl	%edx
1803442ec: 83 c0 0a                    	addl	$0xa, %eax
1803442ef: 89 c1                       	movl	%eax, %ecx
1803442f1: d3 ca                       	rorl	%cl, %edx
1803442f3: 48 63 c2                    	movslq	%edx, %rax
1803442f6: 48 8d b5 60 04 00 00        	leaq	0x460(%rbp), %rsi
1803442fd: 48 89 f1                    	movq	%rsi, %rcx
180344300: 4c 8d 2d 69 99 47 00        	leaq	0x479969(%rip), %r13    # 0x1807bdc70
180344307: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034430c: 48 63 15 69 40 48 00        	movslq	0x484069(%rip), %rdx    # 0x1807c837c
180344313: 8b 04 93                    	movl	(%rbx,%rdx,4), %eax
180344316: 0f c8                       	bswapl	%eax
180344318: b9 18 00 00 00              	movl	$0x18, %ecx
18034431d: 29 d1                       	subl	%edx, %ecx
18034431f: d3 c0                       	roll	%cl, %eax
180344321: 8d 48 01                    	leal	0x1(%rax), %ecx
180344324: 48 63 c9                    	movslq	%ecx, %rcx
180344327: 41 8b 14 8f                 	movl	(%r15,%rcx,4), %edx
18034432b: 8d 88 19 a9 71 bd           	leal	-0x428e56e7(%rax), %ecx
180344331: d3 ca                       	rorl	%cl, %edx
180344333: f7 da                       	negl	%edx
180344335: d3 ca                       	rorl	%cl, %edx
180344337: d3 ca                       	rorl	%cl, %edx
180344339: b9 17 00 00 00              	movl	$0x17, %ecx
18034433e: 29 c1                       	subl	%eax, %ecx
180344340: d3 c2                       	roll	%cl, %edx
180344342: 0f ca                       	bswapl	%edx
180344344: 48 63 c2                    	movslq	%edx, %rax
180344347: 48 89 f1                    	movq	%rsi, %rcx
18034434a: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034434f: 48 89 85 d0 07 00 00        	movq	%rax, 0x7d0(%rbp)
180344356: 8b 0d bc c1 54 00           	movl	0x54c1bc(%rip), %ecx    # 0x180890518
18034435c: 83 c1 18                    	addl	$0x18, %ecx
18034435f: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
180344364: d3 c8                       	rorl	%cl, %eax
180344366: 48 98                       	cltq
180344368: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
18034436c: b9 07 00 00 00              	movl	$0x7, %ecx
180344371: 29 c1                       	subl	%eax, %ecx
180344373: d3 c2                       	roll	%cl, %edx
180344375: 0f ca                       	bswapl	%edx
180344377: 48 63 c2                    	movslq	%edx, %rax
18034437a: 49 8b 44 c5 00              	movq	(%r13,%rax,8), %rax
18034437f: c6 85 b8 0c 00 00 01        	movb	$0x1, 0xcb8(%rbp)
180344386: c6 85 b7 0c 00 00 00        	movb	$0x0, 0xcb7(%rbp)
18034438d: 48 89 bd 88 0a 00 00        	movq	%rdi, 0xa88(%rbp)
180344394: 48 8d b5 98 08 00 00        	leaq	0x898(%rbp), %rsi
18034439b: 48 89 b5 80 0a 00 00        	movq	%rsi, 0xa80(%rbp)
1803443a2: 48 8d 95 d0 07 00 00        	leaq	0x7d0(%rbp), %rdx
1803443a9: 48 89 f9                    	movq	%rdi, %rcx
1803443ac: ff d0                       	callq	*%rax
1803443ae: 48 c7 85 60 0c 00 00 00 00 00 00    	movq	$0x0, 0xc60(%rbp)
1803443b9: 48 63 05 88 3f 48 00        	movslq	0x483f88(%rip), %rax    # 0x1807c8348
1803443c0: 48 8d 0d b9 4e 31 00        	leaq	0x314eb9(%rip), %rcx    # 0x180659280
1803443c7: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803443ca: b9 1b 00 00 00              	movl	$0x1b, %ecx
1803443cf: 29 c1                       	subl	%eax, %ecx
1803443d1: d3 c2                       	roll	%cl, %edx
1803443d3: 8d 48 1b                    	leal	0x1b(%rax), %ecx
1803443d6: d3 ca                       	rorl	%cl, %edx
1803443d8: 48 63 c2                    	movslq	%edx, %rax
1803443db: 48 8d 0d ee f6 47 00        	leaq	0x47f6ee(%rip), %rcx    # 0x1807c3ad0
1803443e2: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803443e5: f7 d2                       	notl	%edx
1803443e7: 0f ca                       	bswapl	%edx
1803443e9: f7 da                       	negl	%edx
1803443eb: 8d 48 03                    	leal	0x3(%rax), %ecx
1803443ee: d3 ca                       	rorl	%cl, %edx
1803443f0: f7 d2                       	notl	%edx
1803443f2: b9 03 00 00 00              	movl	$0x3, %ecx
1803443f7: 29 c1                       	subl	%eax, %ecx
1803443f9: d3 c2                       	roll	%cl, %edx
1803443fb: 48 63 c2                    	movslq	%edx, %rax
1803443fe: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
180344405: 48 8d 15 64 98 47 00        	leaq	0x479864(%rip), %rdx    # 0x1807bdc70
18034440c: ff 14 c2                    	callq	*(%rdx,%rax,8)
18034440f: c6 85 b8 0c 00 00 01        	movb	$0x1, 0xcb8(%rbp)
180344416: c6 85 b7 0c 00 00 00        	movb	$0x0, 0xcb7(%rbp)
18034441d: 48 8d 8d 68 0c 00 00        	leaq	0xc68(%rbp), %rcx
180344424: 48 89 8d 88 0a 00 00        	movq	%rcx, 0xa88(%rbp)
18034442b: 48 89 b5 80 0a 00 00        	movq	%rsi, 0xa80(%rbp)
180344432: 48 89 c2                    	movq	%rax, %rdx
180344435: e8 66 81 ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
18034443a: 48 8d 85 50 0c 00 00        	leaq	0xc50(%rbp), %rax
180344441: 48 89 85 80 03 00 00        	movq	%rax, 0x380(%rbp)
180344448: 48 b8 4c 47 1c d3 6e ed 4a 1f       	movabsq	$0x1f4aed6ed31c474c, %rax # imm = 0x1F4AED6ED31C474C
180344452: 48 33 05 b7 c6 46 00        	xorq	0x46c6b7(%rip), %rax    # 0x1807b0b10
180344459: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
18034445d: 48 8d 04 c5 50 0c 00 00     	leaq	0xc50(,%rax,8), %rax
180344465: 48 01 e8                    	addq	%rbp, %rax
180344468: 48 b9 d0 b0 f1 b5 76 76 2e 5d       	movabsq	$0x5d2e7676b5f1b0d0, %rcx # imm = 0x5D2E7676B5F1B0D0
180344472: 48 01 c1                    	addq	%rax, %rcx
180344475: 48 89 8d 88 03 00 00        	movq	%rcx, 0x388(%rbp)
18034447c: c6 85 ad 0c 00 00 01        	movb	$0x1, 0xcad(%rbp)
180344483: 48 89 b5 40 0a 00 00        	movq	%rsi, 0xa40(%rbp)
18034448a: 48 8d 95 80 03 00 00        	leaq	0x380(%rbp), %rdx
180344491: 48 89 f1                    	movq	%rsi, %rcx
180344494: e8 87 bd fc ff              	callq	0x180310220 <.text+0x300220>
180344499: 48 63 05 1c 41 48 00        	movslq	0x48411c(%rip), %rax    # 0x1807c85bc
1803444a0: 4c 8d 2d d9 4d 31 00        	leaq	0x314dd9(%rip), %r13    # 0x180659280
1803444a7: 41 8b 54 85 00              	movl	(%r13,%rax,4), %edx
1803444ac: b9 07 00 00 00              	movl	$0x7, %ecx
1803444b1: 29 c1                       	subl	%eax, %ecx
1803444b3: d3 c2                       	roll	%cl, %edx
1803444b5: f7 d2                       	notl	%edx
1803444b7: 0f ca                       	bswapl	%edx
1803444b9: 8d 48 07                    	leal	0x7(%rax), %ecx
1803444bc: d3 ca                       	rorl	%cl, %edx
1803444be: 48 63 c2                    	movslq	%edx, %rax
1803444c1: 4c 8d 3d 08 f6 47 00        	leaq	0x47f608(%rip), %r15    # 0x1807c3ad0
1803444c8: 45 8b 04 87                 	movl	(%r15,%rax,4), %r8d
1803444cc: ba b1 8c b6 39              	movl	$0x39b68cb1, %edx       # imm = 0x39B68CB1
1803444d1: 29 c2                       	subl	%eax, %edx
1803444d3: 89 d1                       	movl	%edx, %ecx
1803444d5: 41 d3 c0                    	roll	%cl, %r8d
1803444d8: 83 c0 11                    	addl	$0x11, %eax
1803444db: 89 c1                       	movl	%eax, %ecx
1803444dd: 41 d3 c8                    	rorl	%cl, %r8d
1803444e0: 89 d1                       	movl	%edx, %ecx
1803444e2: 41 d3 c0                    	roll	%cl, %r8d
1803444e5: 41 f7 d0                    	notl	%r8d
1803444e8: 41 0f c8                    	bswapl	%r8d
1803444eb: 41 d3 c0                    	roll	%cl, %r8d
1803444ee: 48 8d b5 b0 08 00 00        	leaq	0x8b0(%rbp), %rsi
1803444f5: bf 07 00 00 00              	movl	$0x7, %edi
1803444fa: 41 f7 d0                    	notl	%r8d
1803444fd: 41 d3 c0                    	roll	%cl, %r8d
180344500: 49 63 c0                    	movslq	%r8d, %rax
180344503: 48 8d 9d 20 06 00 00        	leaq	0x620(%rbp), %rbx
18034450a: 48 89 d9                    	movq	%rbx, %rcx
18034450d: 4c 8d 25 5c 97 47 00        	leaq	0x47975c(%rip), %r12    # 0x1807bdc70
180344514: 41 ff 14 c4                 	callq	*(%r12,%rax,8)
180344518: 48 63 05 4d 3e 48 00        	movslq	0x483e4d(%rip), %rax    # 0x1807c836c
18034451f: 31 c9                       	xorl	%ecx, %ecx
180344521: 41 2b 4c 85 00              	subl	(%r13,%rax,4), %ecx
180344526: 0f c9                       	bswapl	%ecx
180344528: 48 63 d1                    	movslq	%ecx, %rdx
18034452b: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
18034452f: 0f c8                       	bswapl	%eax
180344531: 8d 8a 59 44 c6 45           	leal	0x45c64459(%rdx), %ecx
180344537: d3 c8                       	rorl	%cl, %eax
180344539: f7 d8                       	negl	%eax
18034453b: d3 c8                       	rorl	%cl, %eax
18034453d: f7 d8                       	negl	%eax
18034453f: d3 c8                       	rorl	%cl, %eax
180344541: b9 19 00 00 00              	movl	$0x19, %ecx
180344546: 29 d1                       	subl	%edx, %ecx
180344548: d3 c0                       	roll	%cl, %eax
18034454a: 35 59 44 c6 45              	xorl	$0x45c64459, %eax       # imm = 0x45C64459
18034454f: 48 98                       	cltq
180344551: 48 89 d9                    	movq	%rbx, %rcx
180344554: 41 ff 14 c4                 	callq	*(%r12,%rax,8)
180344558: 48 89 85 c0 03 00 00        	movq	%rax, 0x3c0(%rbp)
18034455f: 8b 0d b3 bf 54 00           	movl	0x54bfb3(%rip), %ecx    # 0x180890518
180344565: 83 c1 18                    	addl	$0x18, %ecx
180344568: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
18034456d: d3 c8                       	rorl	%cl, %eax
18034456f: 48 98                       	cltq
180344571: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180344575: 29 c7                       	subl	%eax, %edi
180344577: 89 f9                       	movl	%edi, %ecx
180344579: d3 c2                       	roll	%cl, %edx
18034457b: 0f ca                       	bswapl	%edx
18034457d: 48 63 c2                    	movslq	%edx, %rax
180344580: 49 8b 04 c4                 	movq	(%r12,%rax,8), %rax
180344584: c6 85 ba 0c 00 00 01        	movb	$0x1, 0xcba(%rbp)
18034458b: c6 85 b9 0c 00 00 00        	movb	$0x0, 0xcb9(%rbp)
180344592: 4c 89 b5 98 0a 00 00        	movq	%r14, 0xa98(%rbp)
180344599: 48 89 b5 90 0a 00 00        	movq	%rsi, 0xa90(%rbp)
1803445a0: 48 8d 95 c0 03 00 00        	leaq	0x3c0(%rbp), %rdx
1803445a7: 4c 89 f1                    	movq	%r14, %rcx
1803445aa: ff d0                       	callq	*%rax
1803445ac: 48 c7 85 80 0b 00 00 00 00 00 00    	movq	$0x0, 0xb80(%rbp)
1803445b7: 48 63 05 9e 3d 48 00        	movslq	0x483d9e(%rip), %rax    # 0x1807c835c
1803445be: 48 8d 0d bb 4c 31 00        	leaq	0x314cbb(%rip), %rcx    # 0x180659280
1803445c5: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803445c8: b9 1b 00 00 00              	movl	$0x1b, %ecx
1803445cd: 29 c1                       	subl	%eax, %ecx
1803445cf: d3 c2                       	roll	%cl, %edx
1803445d1: 8d 48 1b                    	leal	0x1b(%rax), %ecx
1803445d4: d3 ca                       	rorl	%cl, %edx
1803445d6: 48 63 c2                    	movslq	%edx, %rax
1803445d9: 48 8d 0d f0 f4 47 00        	leaq	0x47f4f0(%rip), %rcx    # 0x1807c3ad0
1803445e0: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803445e3: f7 d2                       	notl	%edx
1803445e5: 0f ca                       	bswapl	%edx
1803445e7: f7 da                       	negl	%edx
1803445e9: 8d 48 03                    	leal	0x3(%rax), %ecx
1803445ec: d3 ca                       	rorl	%cl, %edx
1803445ee: f7 d2                       	notl	%edx
1803445f0: b9 03 00 00 00              	movl	$0x3, %ecx
1803445f5: 29 c1                       	subl	%eax, %ecx
1803445f7: d3 c2                       	roll	%cl, %edx
1803445f9: 48 63 c2                    	movslq	%edx, %rax
1803445fc: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
180344603: 48 8d 15 66 96 47 00        	leaq	0x479666(%rip), %rdx    # 0x1807bdc70
18034460a: ff 14 c2                    	callq	*(%rdx,%rax,8)
18034460d: 48 8d 50 20                 	leaq	0x20(%rax), %rdx
180344611: c6 85 ba 0c 00 00 01        	movb	$0x1, 0xcba(%rbp)
180344618: c6 85 b9 0c 00 00 00        	movb	$0x0, 0xcb9(%rbp)
18034461f: 48 8d 8d 88 0b 00 00        	leaq	0xb88(%rbp), %rcx
180344626: 48 89 8d 98 0a 00 00        	movq	%rcx, 0xa98(%rbp)
18034462d: 48 89 b5 90 0a 00 00        	movq	%rsi, 0xa90(%rbp)
180344634: e8 67 7f ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
180344639: 48 8d 85 70 0b 00 00        	leaq	0xb70(%rbp), %rax
180344640: 48 89 85 90 03 00 00        	movq	%rax, 0x390(%rbp)
180344647: 48 b8 ef 58 35 96 62 29 89 0c       	movabsq	$0xc892962963558ef, %rax # imm = 0xC892962963558EF
180344651: 48 33 05 c0 c4 46 00        	xorq	0x46c4c0(%rip), %rax    # 0x1807b0b18
180344658: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
18034465c: 48 8d 04 c5 70 0b 00 00     	leaq	0xb70(,%rax,8), %rax
180344664: 48 01 e8                    	addq	%rbp, %rax
180344667: 48 b9 78 db a5 8d 8f 11 6a 0e       	movabsq	$0xe6a118f8da5db78, %rcx # imm = 0xE6A118F8DA5DB78
180344671: 48 01 c1                    	addq	%rax, %rcx
180344674: 48 89 8d 98 03 00 00        	movq	%rcx, 0x398(%rbp)
18034467b: c6 85 ae 0c 00 00 01        	movb	$0x1, 0xcae(%rbp)
180344682: 48 89 b5 48 0a 00 00        	movq	%rsi, 0xa48(%rbp)
180344689: 48 8d 95 90 03 00 00        	leaq	0x390(%rbp), %rdx
180344690: 48 89 f1                    	movq	%rsi, %rcx
180344693: e8 88 bb fc ff              	callq	0x180310220 <.text+0x300220>
180344698: 4c 8d bd 20 0b 00 00        	leaq	0xb20(%rbp), %r15
18034469f: 48 63 05 1a 3f 48 00        	movslq	0x483f1a(%rip), %rax    # 0x1807c85c0
1803446a6: 48 8d 1d d3 4b 31 00        	leaq	0x314bd3(%rip), %rbx    # 0x180659280
1803446ad: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
1803446b0: 8d 88 9f f2 a0 d1           	leal	-0x2e5f0d61(%rax), %ecx
1803446b6: d3 ca                       	rorl	%cl, %edx
1803446b8: d3 ca                       	rorl	%cl, %edx
1803446ba: d3 ca                       	rorl	%cl, %edx
1803446bc: d3 ca                       	rorl	%cl, %edx
1803446be: 4c 63 ca                    	movslq	%edx, %r9
1803446c1: b8 08 7c 06 42              	movl	$0x42067c08, %eax       # imm = 0x42067C08
1803446c6: 4c 8d 35 03 f4 47 00        	leaq	0x47f403(%rip), %r14    # 0x1807c3ad0
1803446cd: 47 8b 04 8e                 	movl	(%r14,%r9,4), %r8d
1803446d1: 41 31 c0                    	xorl	%eax, %r8d
1803446d4: 41 8d 91 08 7c 06 42        	leal	0x42067c08(%r9), %edx
1803446db: 89 d1                       	movl	%edx, %ecx
1803446dd: 41 d3 c8                    	rorl	%cl, %r8d
1803446e0: 48 8d b5 c8 08 00 00        	leaq	0x8c8(%rbp), %rsi
1803446e7: 41 f7 d0                    	notl	%r8d
1803446ea: 44 29 c8                    	subl	%r9d, %eax
1803446ed: 89 c1                       	movl	%eax, %ecx
1803446ef: 41 d3 c0                    	roll	%cl, %r8d
1803446f2: 89 d1                       	movl	%edx, %ecx
1803446f4: 41 d3 c8                    	rorl	%cl, %r8d
1803446f7: 89 c1                       	movl	%eax, %ecx
1803446f9: 41 d3 c0                    	roll	%cl, %r8d
1803446fc: 89 d1                       	movl	%edx, %ecx
1803446fe: 41 d3 c8                    	rorl	%cl, %r8d
180344701: 41 d3 c8                    	rorl	%cl, %r8d
180344704: 49 63 c0                    	movslq	%r8d, %rax
180344707: 48 8d bd 40 06 00 00        	leaq	0x640(%rbp), %rdi
18034470e: 48 89 f9                    	movq	%rdi, %rcx
180344711: 4c 8d 25 58 95 47 00        	leaq	0x479558(%rip), %r12    # 0x1807bdc70
180344718: 41 ff 14 c4                 	callq	*(%r12,%rax,8)
18034471c: 48 63 05 3d 3c 48 00        	movslq	0x483c3d(%rip), %rax    # 0x1807c8360
180344723: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180344726: 8d 48 12                    	leal	0x12(%rax), %ecx
180344729: d3 ca                       	rorl	%cl, %edx
18034472b: f7 d2                       	notl	%edx
18034472d: 48 63 c2                    	movslq	%edx, %rax
180344730: 41 8b 04 86                 	movl	(%r14,%rax,4), %eax
180344734: f7 d0                       	notl	%eax
180344736: 0f c8                       	bswapl	%eax
180344738: 48 98                       	cltq
18034473a: 48 89 f9                    	movq	%rdi, %rcx
18034473d: 41 ff 14 c4                 	callq	*(%r12,%rax,8)
180344741: 48 89 85 e0 03 00 00        	movq	%rax, 0x3e0(%rbp)
180344748: 8b 0d ca bd 54 00           	movl	0x54bdca(%rip), %ecx    # 0x180890518
18034474e: 83 c1 18                    	addl	$0x18, %ecx
180344751: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
180344756: d3 c8                       	rorl	%cl, %eax
180344758: 48 98                       	cltq
18034475a: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
18034475e: b9 07 00 00 00              	movl	$0x7, %ecx
180344763: 29 c1                       	subl	%eax, %ecx
180344765: d3 c2                       	roll	%cl, %edx
180344767: 0f ca                       	bswapl	%edx
180344769: 48 63 c2                    	movslq	%edx, %rax
18034476c: 49 8b 04 c4                 	movq	(%r12,%rax,8), %rax
180344770: c6 85 bc 0c 00 00 01        	movb	$0x1, 0xcbc(%rbp)
180344777: c6 85 bb 0c 00 00 00        	movb	$0x0, 0xcbb(%rbp)
18034477e: 4c 89 bd a8 0a 00 00        	movq	%r15, 0xaa8(%rbp)
180344785: 48 89 b5 a0 0a 00 00        	movq	%rsi, 0xaa0(%rbp)
18034478c: 48 8d 95 e0 03 00 00        	leaq	0x3e0(%rbp), %rdx
180344793: 4c 89 f9                    	movq	%r15, %rcx
180344796: ff d0                       	callq	*%rax
180344798: 48 c7 85 30 0b 00 00 00 00 00 00    	movq	$0x0, 0xb30(%rbp)
1803447a3: 48 63 05 ca 3b 48 00        	movslq	0x483bca(%rip), %rax    # 0x1807c8374
1803447aa: 48 8d 0d cf 4a 31 00        	leaq	0x314acf(%rip), %rcx    # 0x180659280
1803447b1: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803447b4: b9 1b 00 00 00              	movl	$0x1b, %ecx
1803447b9: 29 c1                       	subl	%eax, %ecx
1803447bb: d3 c2                       	roll	%cl, %edx
1803447bd: 8d 48 1b                    	leal	0x1b(%rax), %ecx
1803447c0: d3 ca                       	rorl	%cl, %edx
1803447c2: 48 63 c2                    	movslq	%edx, %rax
1803447c5: 48 8d 0d 04 f3 47 00        	leaq	0x47f304(%rip), %rcx    # 0x1807c3ad0
1803447cc: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803447cf: f7 d2                       	notl	%edx
1803447d1: 0f ca                       	bswapl	%edx
1803447d3: f7 da                       	negl	%edx
1803447d5: 8d 48 03                    	leal	0x3(%rax), %ecx
1803447d8: d3 ca                       	rorl	%cl, %edx
1803447da: f7 d2                       	notl	%edx
1803447dc: b9 03 00 00 00              	movl	$0x3, %ecx
1803447e1: 29 c1                       	subl	%eax, %ecx
1803447e3: d3 c2                       	roll	%cl, %edx
1803447e5: 48 63 c2                    	movslq	%edx, %rax
1803447e8: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
1803447ef: 48 8d 15 7a 94 47 00        	leaq	0x47947a(%rip), %rdx    # 0x1807bdc70
1803447f6: ff 14 c2                    	callq	*(%rdx,%rax,8)
1803447f9: 48 8d 50 40                 	leaq	0x40(%rax), %rdx
1803447fd: c6 85 bc 0c 00 00 01        	movb	$0x1, 0xcbc(%rbp)
180344804: c6 85 bb 0c 00 00 00        	movb	$0x0, 0xcbb(%rbp)
18034480b: 48 8d 8d 38 0b 00 00        	leaq	0xb38(%rbp), %rcx
180344812: 48 89 8d a8 0a 00 00        	movq	%rcx, 0xaa8(%rbp)
180344819: 48 89 b5 a0 0a 00 00        	movq	%rsi, 0xaa0(%rbp)
180344820: e8 7b 7d ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
180344825: 48 8d 85 20 0b 00 00        	leaq	0xb20(%rbp), %rax
18034482c: 48 89 85 a0 03 00 00        	movq	%rax, 0x3a0(%rbp)
180344833: 48 b8 c3 3c 3b 33 56 ff 7c 15       	movabsq	$0x157cff56333b3cc3, %rax # imm = 0x157CFF56333B3CC3
18034483d: 48 33 05 ac c2 46 00        	xorq	0x46c2ac(%rip), %rax    # 0x1807b0af0
180344844: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344848: 48 8d 04 c5 20 0b 00 00     	leaq	0xb20(,%rax,8), %rax
180344850: 48 01 e8                    	addq	%rbp, %rax
180344853: 48 b9 b8 1e 79 ac 12 6a 84 2c       	movabsq	$0x2c846a12ac791eb8, %rcx # imm = 0x2C846A12AC791EB8
18034485d: 48 01 c1                    	addq	%rax, %rcx
180344860: 48 89 8d a8 03 00 00        	movq	%rcx, 0x3a8(%rbp)
180344867: c6 85 af 0c 00 00 01        	movb	$0x1, 0xcaf(%rbp)
18034486e: 48 89 b5 50 0a 00 00        	movq	%rsi, 0xa50(%rbp)
180344875: 48 8d 95 a0 03 00 00        	leaq	0x3a0(%rbp), %rdx
18034487c: 48 89 f1                    	movq	%rsi, %rcx
18034487f: e8 9c b9 fc ff              	callq	0x180310220 <.text+0x300220>
180344884: 48 63 05 29 3d 48 00        	movslq	0x483d29(%rip), %rax    # 0x1807c85b4
18034488b: 48 8d 3d ee 49 31 00        	leaq	0x3149ee(%rip), %rdi    # 0x180659280
180344892: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180344895: b9 4b 03 2d 2f              	movl	$0x2f2d034b, %ecx       # imm = 0x2F2D034B
18034489a: 29 c1                       	subl	%eax, %ecx
18034489c: d3 c2                       	roll	%cl, %edx
18034489e: d3 c2                       	roll	%cl, %edx
1803448a0: d3 c2                       	roll	%cl, %edx
1803448a2: 8d 48 0b                    	leal	0xb(%rax), %ecx
1803448a5: d3 ca                       	rorl	%cl, %edx
1803448a7: 48 63 c2                    	movslq	%edx, %rax
1803448aa: 48 8d 1d 1f f2 47 00        	leaq	0x47f21f(%rip), %rbx    # 0x1807c3ad0
1803448b1: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
1803448b4: b9 74 10 54 03              	movl	$0x3541074, %ecx        # imm = 0x3541074
1803448b9: 29 c1                       	subl	%eax, %ecx
1803448bb: d3 c2                       	roll	%cl, %edx
1803448bd: d3 c2                       	roll	%cl, %edx
1803448bf: 81 f2 74 10 54 03           	xorl	$0x3541074, %edx        # imm = 0x3541074
1803448c5: 0f ca                       	bswapl	%edx
1803448c7: d3 c2                       	roll	%cl, %edx
1803448c9: f7 da                       	negl	%edx
1803448cb: 81 f2 74 10 54 03           	xorl	$0x3541074, %edx        # imm = 0x3541074
1803448d1: d3 c2                       	roll	%cl, %edx
1803448d3: 48 63 c2                    	movslq	%edx, %rax
1803448d6: 48 8d b5 60 06 00 00        	leaq	0x660(%rbp), %rsi
1803448dd: 48 89 f1                    	movq	%rsi, %rcx
1803448e0: 4c 8d 35 89 93 47 00        	leaq	0x479389(%rip), %r14    # 0x1807bdc70
1803448e7: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
1803448eb: 48 63 15 9e 3a 48 00        	movslq	0x483a9e(%rip), %rdx    # 0x1807c8390
1803448f2: 8b 04 97                    	movl	(%rdi,%rdx,4), %eax
1803448f5: 0f c8                       	bswapl	%eax
1803448f7: b9 18 00 00 00              	movl	$0x18, %ecx
1803448fc: 29 d1                       	subl	%edx, %ecx
1803448fe: d3 c0                       	roll	%cl, %eax
180344900: 8d 48 01                    	leal	0x1(%rax), %ecx
180344903: 48 63 c9                    	movslq	%ecx, %rcx
180344906: 8b 14 8b                    	movl	(%rbx,%rcx,4), %edx
180344909: 8d 88 19 a9 71 bd           	leal	-0x428e56e7(%rax), %ecx
18034490f: d3 ca                       	rorl	%cl, %edx
180344911: f7 da                       	negl	%edx
180344913: d3 ca                       	rorl	%cl, %edx
180344915: d3 ca                       	rorl	%cl, %edx
180344917: b9 17 00 00 00              	movl	$0x17, %ecx
18034491c: 29 c1                       	subl	%eax, %ecx
18034491e: d3 c2                       	roll	%cl, %edx
180344920: 0f ca                       	bswapl	%edx
180344922: 48 63 c2                    	movslq	%edx, %rax
180344925: 48 89 f1                    	movq	%rsi, %rcx
180344928: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
18034492c: 48 89 85 00 04 00 00        	movq	%rax, 0x400(%rbp)
180344933: 8b 0d df bb 54 00           	movl	0x54bbdf(%rip), %ecx    # 0x180890518
180344939: 83 c1 18                    	addl	$0x18, %ecx
18034493c: b8 05 00 00 c0              	movl	$0xc0000005, %eax       # imm = 0xC0000005
180344941: d3 c8                       	rorl	%cl, %eax
180344943: 48 98                       	cltq
180344945: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180344948: b9 07 00 00 00              	movl	$0x7, %ecx
18034494d: 29 c1                       	subl	%eax, %ecx
18034494f: d3 c2                       	roll	%cl, %edx
180344951: 0f ca                       	bswapl	%edx
180344953: 48 63 c2                    	movslq	%edx, %rax
180344956: 49 8b 04 c6                 	movq	(%r14,%rax,8), %rax
18034495a: c6 85 be 0c 00 00 01        	movb	$0x1, 0xcbe(%rbp)
180344961: c6 85 bd 0c 00 00 00        	movb	$0x0, 0xcbd(%rbp)
180344968: 48 8d 8d a0 09 00 00        	leaq	0x9a0(%rbp), %rcx
18034496f: 48 89 8d b0 0a 00 00        	movq	%rcx, 0xab0(%rbp)
180344976: 48 8d 95 00 04 00 00        	leaq	0x400(%rbp), %rdx
18034497d: ff d0                       	callq	*%rax
18034497f: 48 c7 85 b0 09 00 00 00 00 00 00    	movq	$0x0, 0x9b0(%rbp)
18034498a: 48 63 05 fb 39 48 00        	movslq	0x4839fb(%rip), %rax    # 0x1807c838c
180344991: 48 8d 0d e8 48 31 00        	leaq	0x3148e8(%rip), %rcx    # 0x180659280
180344998: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
18034499b: b9 1b 00 00 00              	movl	$0x1b, %ecx
1803449a0: 29 c1                       	subl	%eax, %ecx
1803449a2: d3 c2                       	roll	%cl, %edx
1803449a4: 8d 48 1b                    	leal	0x1b(%rax), %ecx
1803449a7: d3 ca                       	rorl	%cl, %edx
1803449a9: 48 8d b5 b8 09 00 00        	leaq	0x9b8(%rbp), %rsi
1803449b0: 48 63 c2                    	movslq	%edx, %rax
1803449b3: 48 8d 0d 16 f1 47 00        	leaq	0x47f116(%rip), %rcx    # 0x1807c3ad0
1803449ba: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803449bd: f7 d2                       	notl	%edx
1803449bf: 0f ca                       	bswapl	%edx
1803449c1: f7 da                       	negl	%edx
1803449c3: 8d 48 03                    	leal	0x3(%rax), %ecx
1803449c6: d3 ca                       	rorl	%cl, %edx
1803449c8: f7 d2                       	notl	%edx
1803449ca: b9 03 00 00 00              	movl	$0x3, %ecx
1803449cf: 29 c1                       	subl	%eax, %ecx
1803449d1: d3 c2                       	roll	%cl, %edx
1803449d3: 48 63 c2                    	movslq	%edx, %rax
1803449d6: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
1803449dd: 48 8d 15 8c 92 47 00        	leaq	0x47928c(%rip), %rdx    # 0x1807bdc70
1803449e4: ff 14 c2                    	callq	*(%rdx,%rax,8)
1803449e7: 48 8d 50 60                 	leaq	0x60(%rax), %rdx
1803449eb: c6 85 be 0c 00 00 01        	movb	$0x1, 0xcbe(%rbp)
1803449f2: c6 85 bd 0c 00 00 00        	movb	$0x0, 0xcbd(%rbp)
1803449f9: 48 89 b5 b0 0a 00 00        	movq	%rsi, 0xab0(%rbp)
180344a00: 48 89 f1                    	movq	%rsi, %rcx
180344a03: e8 98 7b ff ff              	callq	0x18033c5a0 <.text+0x32c5a0>
180344a08: 48 8d 85 a0 09 00 00        	leaq	0x9a0(%rbp), %rax
180344a0f: 48 89 85 b0 03 00 00        	movq	%rax, 0x3b0(%rbp)
180344a16: 48 b8 35 c2 d6 29 f9 22 89 0c       	movabsq	$0xc8922f929d6c235, %rax # imm = 0xC8922F929D6C235
180344a20: 48 33 05 d1 c0 46 00        	xorq	0x46c0d1(%rip), %rax    # 0x1807b0af8
180344a27: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344a2b: 48 8d 04 c5 a0 09 00 00     	leaq	0x9a0(,%rax,8), %rax
180344a33: 48 01 e8                    	addq	%rbp, %rax
180344a36: 48 b9 c8 41 68 9d 2c 8d f4 4f       	movabsq	$0x4ff48d2c9d6841c8, %rcx # imm = 0x4FF48D2C9D6841C8
180344a40: 48 01 c1                    	addq	%rax, %rcx
180344a43: 48 89 8d b8 03 00 00        	movq	%rcx, 0x3b8(%rbp)
180344a4a: c6 85 b0 0c 00 00 01        	movb	$0x1, 0xcb0(%rbp)
180344a51: 48 8d 95 b0 03 00 00        	leaq	0x3b0(%rbp), %rdx
180344a58: 48 8d 8d e0 08 00 00        	leaq	0x8e0(%rbp), %rcx
180344a5f: e8 bc b7 fc ff              	callq	0x180310220 <.text+0x300220>
180344a64: 48 8d 85 80 08 00 00        	leaq	0x880(%rbp), %rax
180344a6b: 48 89 85 60 03 00 00        	movq	%rax, 0x360(%rbp)
180344a72: 48 b8 3a 25 de de bb 31 97 0c       	movabsq	$0xc9731bbdede253a, %rax # imm = 0xC9731BBDEDE253A
180344a7c: 48 33 05 9d c0 46 00        	xorq	0x46c09d(%rip), %rax    # 0x1807b0b20
180344a83: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344a87: 48 8d 04 c5 80 08 00 00     	leaq	0x880(,%rax,8), %rax
180344a8f: 48 01 e8                    	addq	%rbp, %rax
180344a92: 48 b9 90 cc 20 86 9e 11 62 1e       	movabsq	$0x1e62119e8620cc90, %rcx # imm = 0x1E62119E8620CC90
180344a9c: 48 01 c1                    	addq	%rax, %rcx
180344a9f: 48 89 8d 68 03 00 00        	movq	%rcx, 0x368(%rbp)
180344aa6: 44 0f b6 0d e4 be 46 00     	movzbl	0x46bee4(%rip), %r9d    # 0x1807b0992
180344aae: 41 80 f1 9c                 	xorb	$-0x64, %r9b
180344ab2: 41 80 c1 19                 	addb	$0x19, %r9b
180344ab6: 48 8d 8d 60 09 00 00        	leaq	0x960(%rbp), %rcx
180344abd: 48 8d 95 60 03 00 00        	leaq	0x360(%rbp), %rdx
180344ac4: 41 b0 01                    	movb	$0x1, %r8b
180344ac7: e8 a4 b8 fc ff              	callq	0x180310370 <.text+0x300370>
180344acc: 41 b8 2d cb 10 07           	movl	$0x710cb2d, %r8d        # imm = 0x710CB2D
180344ad2: 44 33 05 c7 be 46 00        	xorl	0x46bec7(%rip), %r8d    # 0x1807b09a0
180344ad9: 41 81 c0 0d c6 25 34        	addl	$0x3425c60d, %r8d       # imm = 0x3425C60D
180344ae0: 44 0f b6 0d bc be 46 00     	movzbl	0x46bebc(%rip), %r9d    # 0x1807b09a4
180344ae8: 41 80 f1 31                 	xorb	$0x31, %r9b
180344aec: 41 80 c1 68                 	addb	$0x68, %r9b
180344af0: b8 7a 4f a4 e3              	movl	$0xe3a44f7a, %eax       # imm = 0xE3A44F7A
180344af5: 33 05 ad be 46 00           	xorl	0x46bead(%rip), %eax    # 0x1807b09a8
180344afb: 05 4f 78 e6 85              	addl	$0x85e6784f, %eax       # imm = 0x85E6784F
180344b00: 89 44 24 28                 	movl	%eax, 0x28(%rsp)
180344b04: c6 44 24 20 00              	movb	$0x0, 0x20(%rsp)
180344b09: 48 8d 8d 60 09 00 00        	leaq	0x960(%rbp), %rcx
180344b10: 48 8d 95 00 06 00 00        	leaq	0x600(%rbp), %rdx
180344b17: e8 84 5d fd ff              	callq	0x18031a8a0 <.text+0x30a8a0>
180344b1c: 48 63 15 e9 36 48 00        	movslq	0x4836e9(%rip), %rdx    # 0x1807c820c
180344b23: 4c 8d 3d 56 47 31 00        	leaq	0x314756(%rip), %r15    # 0x180659280
180344b2a: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180344b2e: b9 0b 00 00 00              	movl	$0xb, %ecx
180344b33: 29 d1                       	subl	%edx, %ecx
180344b35: d3 c0                       	roll	%cl, %eax
180344b37: f7 d0                       	notl	%eax
180344b39: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180344b3c: d3 c8                       	rorl	%cl, %eax
180344b3e: 89 c1                       	movl	%eax, %ecx
180344b40: f7 d1                       	notl	%ecx
180344b42: 48 63 c9                    	movslq	%ecx, %rcx
180344b45: 4c 8d 35 84 ef 47 00        	leaq	0x47ef84(%rip), %r14    # 0x1807c3ad0
180344b4c: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180344b50: 41 0f c8                    	bswapl	%r8d
180344b53: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180344b58: 29 c2                       	subl	%eax, %edx
180344b5a: 89 d1                       	movl	%edx, %ecx
180344b5c: 41 d3 c8                    	rorl	%cl, %r8d
180344b5f: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180344b64: 89 c1                       	movl	%eax, %ecx
180344b66: 41 d3 c0                    	roll	%cl, %r8d
180344b69: 89 d1                       	movl	%edx, %ecx
180344b6b: 41 d3 c8                    	rorl	%cl, %r8d
180344b6e: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180344b75: 41 ff c0                    	incl	%r8d
180344b78: 89 c1                       	movl	%eax, %ecx
180344b7a: 41 d3 c0                    	roll	%cl, %r8d
180344b7d: 41 f7 d0                    	notl	%r8d
180344b80: 49 63 c0                    	movslq	%r8d, %rax
180344b83: 48 8d 8d 40 02 00 00        	leaq	0x240(%rbp), %rcx
180344b8a: 48 8d b5 00 06 00 00        	leaq	0x600(%rbp), %rsi
180344b91: 48 89 f2                    	movq	%rsi, %rdx
180344b94: 48 8d 1d d5 90 47 00        	leaq	0x4790d5(%rip), %rbx    # 0x1807bdc70
180344b9b: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344b9e: 48 63 05 fb 37 48 00        	movslq	0x4837fb(%rip), %rax    # 0x1807c83a0
180344ba5: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180344ba9: b9 0a 00 00 00              	movl	$0xa, %ecx
180344bae: 29 c1                       	subl	%eax, %ecx
180344bb0: d3 c2                       	roll	%cl, %edx
180344bb2: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180344bb8: d3 ca                       	rorl	%cl, %edx
180344bba: d3 ca                       	rorl	%cl, %edx
180344bbc: d3 ca                       	rorl	%cl, %edx
180344bbe: 48 63 c2                    	movslq	%edx, %rax
180344bc1: 31 d2                       	xorl	%edx, %edx
180344bc3: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180344bc7: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180344bcd: d3 ca                       	rorl	%cl, %edx
180344bcf: d3 ca                       	rorl	%cl, %edx
180344bd1: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180344bd7: d3 ca                       	rorl	%cl, %edx
180344bd9: 31 ff                       	xorl	%edi, %edi
180344bdb: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180344be0: 29 c1                       	subl	%eax, %ecx
180344be2: d3 c2                       	roll	%cl, %edx
180344be4: d3 c2                       	roll	%cl, %edx
180344be6: 48 63 c2                    	movslq	%edx, %rax
180344be9: 48 89 f1                    	movq	%rsi, %rcx
180344bec: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344bef: 48 63 05 9e 37 48 00        	movslq	0x48379e(%rip), %rax    # 0x1807c8394
180344bf6: 31 d2                       	xorl	%edx, %edx
180344bf8: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
180344bfc: b9 37 a3 35 1f              	movl	$0x1f35a337, %ecx       # imm = 0x1F35A337
180344c01: 29 c1                       	subl	%eax, %ecx
180344c03: d3 c2                       	roll	%cl, %edx
180344c05: 0f ca                       	bswapl	%edx
180344c07: d3 c2                       	roll	%cl, %edx
180344c09: 48 63 c2                    	movslq	%edx, %rax
180344c0c: 41 2b 3c 86                 	subl	(%r14,%rax,4), %edi
180344c10: b9 05 00 00 00              	movl	$0x5, %ecx
180344c15: 29 c1                       	subl	%eax, %ecx
180344c17: d3 c7                       	roll	%cl, %edi
180344c19: 81 f7 1a 0d 76 ac           	xorl	$0xac760d1a, %edi       # imm = 0xAC760D1A
180344c1f: ff c7                       	incl	%edi
180344c21: 83 c0 05                    	addl	$0x5, %eax
180344c24: 89 c1                       	movl	%eax, %ecx
180344c26: d3 cf                       	rorl	%cl, %edi
180344c28: f7 d7                       	notl	%edi
180344c2a: 0f cf                       	bswapl	%edi
180344c2c: f7 df                       	negl	%edi
180344c2e: 48 63 c7                    	movslq	%edi, %rax
180344c31: 48 8d 8d 60 09 00 00        	leaq	0x960(%rbp), %rcx
180344c38: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344c3b: b8 07 0d b1 cb              	movl	$0xcbb10d07, %eax       # imm = 0xCBB10D07
180344c40: 33 05 ba be 46 00           	xorl	0x46beba(%rip), %eax    # 0x1807b0b00
180344c46: 05 3b 7a 40 ad              	addl	$0xad407a3b, %eax       # imm = 0xAD407A3B
180344c4b: 48 98                       	cltq
180344c4d: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344c51: 48 8d 34 c5 80 08 00 00     	leaq	0x880(,%rax,8), %rsi
180344c59: 48 01 ee                    	addq	%rbp, %rsi
180344c5c: bf 60 00 00 00              	movl	$0x60, %edi
180344c61: 48 63 05 34 37 48 00        	movslq	0x483734(%rip), %rax    # 0x1807c839c
180344c68: 45 8b 04 87                 	movl	(%r15,%rax,4), %r8d
180344c6c: 41 8d 40 01                 	leal	0x1(%r8), %eax
180344c70: 48 98                       	cltq
180344c72: 45 8b 0c 86                 	movl	(%r14,%rax,4), %r9d
180344c76: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180344c7d: 89 c1                       	movl	%eax, %ecx
180344c7f: 41 d3 c9                    	rorl	%cl, %r9d
180344c82: 41 0f c9                    	bswapl	%r9d
180344c85: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180344c8a: 44 29 c2                    	subl	%r8d, %edx
180344c8d: 89 d1                       	movl	%edx, %ecx
180344c8f: 41 d3 c1                    	roll	%cl, %r9d
180344c92: 89 c1                       	movl	%eax, %ecx
180344c94: 41 d3 c9                    	rorl	%cl, %r9d
180344c97: 4c 8d 04 3e                 	leaq	(%rsi,%rdi), %r8
180344c9b: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180344ca2: 41 d3 c9                    	rorl	%cl, %r9d
180344ca5: 89 d1                       	movl	%edx, %ecx
180344ca7: 41 d3 c1                    	roll	%cl, %r9d
180344caa: 41 d3 c1                    	roll	%cl, %r9d
180344cad: 49 63 c1                    	movslq	%r9d, %rax
180344cb0: 4c 89 c1                    	movq	%r8, %rcx
180344cb3: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344cb6: 48 83 c7 e8                 	addq	$-0x18, %rdi
180344cba: 48 83 ff e8                 	cmpq	$-0x18, %rdi
180344cbe: 75 a1                       	jne	0x180344c61 <.text+0x334c61>
180344cc0: b8 2f f8 20 2d              	movl	$0x2d20f82f, %eax       # imm = 0x2D20F82F
180344cc5: 33 05 3d be 46 00           	xorl	0x46be3d(%rip), %eax    # 0x1807b0b08
180344ccb: 05 ac 81 b9 04              	addl	$0x4b981ac, %eax        # imm = 0x4B981AC
180344cd0: 48 98                       	cltq
180344cd2: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344cd6: 48 8d 34 c5 a0 09 00 00     	leaq	0x9a0(,%rax,8), %rsi
180344cde: 48 01 ee                    	addq	%rbp, %rsi
180344ce1: bf 18 00 00 00              	movl	$0x18, %edi
180344ce6: 48 63 05 ab 36 48 00        	movslq	0x4836ab(%rip), %rax    # 0x1807c8398
180344ced: 45 8b 04 87                 	movl	(%r15,%rax,4), %r8d
180344cf1: 41 8d 40 01                 	leal	0x1(%r8), %eax
180344cf5: 48 98                       	cltq
180344cf7: 45 8b 0c 86                 	movl	(%r14,%rax,4), %r9d
180344cfb: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180344d02: 89 c1                       	movl	%eax, %ecx
180344d04: 41 d3 c9                    	rorl	%cl, %r9d
180344d07: 41 0f c9                    	bswapl	%r9d
180344d0a: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180344d0f: 44 29 c2                    	subl	%r8d, %edx
180344d12: 89 d1                       	movl	%edx, %ecx
180344d14: 41 d3 c1                    	roll	%cl, %r9d
180344d17: 89 c1                       	movl	%eax, %ecx
180344d19: 41 d3 c9                    	rorl	%cl, %r9d
180344d1c: 4c 8d 04 3e                 	leaq	(%rsi,%rdi), %r8
180344d20: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180344d27: 41 d3 c9                    	rorl	%cl, %r9d
180344d2a: 89 d1                       	movl	%edx, %ecx
180344d2c: 41 d3 c1                    	roll	%cl, %r9d
180344d2f: 41 d3 c1                    	roll	%cl, %r9d
180344d32: 49 63 c1                    	movslq	%r9d, %rax
180344d35: 4c 89 c1                    	movq	%r8, %rcx
180344d38: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344d3b: 48 83 c7 e8                 	addq	$-0x18, %rdi
180344d3f: 48 83 ff e8                 	cmpq	$-0x18, %rdi
180344d43: 75 a1                       	jne	0x180344ce6 <.text+0x334ce6>
180344d45: b8 fe b9 8f 19              	movl	$0x198fb9fe, %eax       # imm = 0x198FB9FE
180344d4a: 33 05 e0 bd 46 00           	xorl	0x46bde0(%rip), %eax    # 0x1807b0b30
180344d50: 05 77 fd ef 31              	addl	$0x31effd77, %eax       # imm = 0x31EFFD77
180344d55: 48 98                       	cltq
180344d57: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344d5b: 48 8d 34 c5 20 0b 00 00     	leaq	0xb20(,%rax,8), %rsi
180344d63: 48 01 ee                    	addq	%rbp, %rsi
180344d66: bf 18 00 00 00              	movl	$0x18, %edi
180344d6b: 48 63 05 3a 36 48 00        	movslq	0x48363a(%rip), %rax    # 0x1807c83ac
180344d72: 45 8b 04 87                 	movl	(%r15,%rax,4), %r8d
180344d76: 41 8d 40 01                 	leal	0x1(%r8), %eax
180344d7a: 48 98                       	cltq
180344d7c: 45 8b 0c 86                 	movl	(%r14,%rax,4), %r9d
180344d80: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180344d87: 89 c1                       	movl	%eax, %ecx
180344d89: 41 d3 c9                    	rorl	%cl, %r9d
180344d8c: 41 0f c9                    	bswapl	%r9d
180344d8f: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180344d94: 44 29 c2                    	subl	%r8d, %edx
180344d97: 89 d1                       	movl	%edx, %ecx
180344d99: 41 d3 c1                    	roll	%cl, %r9d
180344d9c: 89 c1                       	movl	%eax, %ecx
180344d9e: 41 d3 c9                    	rorl	%cl, %r9d
180344da1: 4c 8d 04 3e                 	leaq	(%rsi,%rdi), %r8
180344da5: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180344dac: 41 d3 c9                    	rorl	%cl, %r9d
180344daf: 89 d1                       	movl	%edx, %ecx
180344db1: 41 d3 c1                    	roll	%cl, %r9d
180344db4: 41 d3 c1                    	roll	%cl, %r9d
180344db7: 49 63 c1                    	movslq	%r9d, %rax
180344dba: 4c 89 c1                    	movq	%r8, %rcx
180344dbd: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344dc0: 48 83 c7 e8                 	addq	$-0x18, %rdi
180344dc4: 48 83 ff e8                 	cmpq	$-0x18, %rdi
180344dc8: 75 a1                       	jne	0x180344d6b <.text+0x334d6b>
180344dca: b8 4e 8d 5d ea              	movl	$0xea5d8d4e, %eax       # imm = 0xEA5D8D4E
180344dcf: 33 05 5f bd 46 00           	xorl	0x46bd5f(%rip), %eax    # 0x1807b0b34
180344dd5: 05 b6 6a 64 4d              	addl	$0x4d646ab6, %eax       # imm = 0x4D646AB6
180344dda: 48 98                       	cltq
180344ddc: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344de0: 48 8d 34 c5 70 0b 00 00     	leaq	0xb70(,%rax,8), %rsi
180344de8: 48 01 ee                    	addq	%rbp, %rsi
180344deb: bf 18 00 00 00              	movl	$0x18, %edi
180344df0: 48 63 05 ad 35 48 00        	movslq	0x4835ad(%rip), %rax    # 0x1807c83a4
180344df7: 45 8b 04 87                 	movl	(%r15,%rax,4), %r8d
180344dfb: 41 8d 40 01                 	leal	0x1(%r8), %eax
180344dff: 48 98                       	cltq
180344e01: 45 8b 0c 86                 	movl	(%r14,%rax,4), %r9d
180344e05: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180344e0c: 89 c1                       	movl	%eax, %ecx
180344e0e: 41 d3 c9                    	rorl	%cl, %r9d
180344e11: 41 0f c9                    	bswapl	%r9d
180344e14: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180344e19: 44 29 c2                    	subl	%r8d, %edx
180344e1c: 89 d1                       	movl	%edx, %ecx
180344e1e: 41 d3 c1                    	roll	%cl, %r9d
180344e21: 89 c1                       	movl	%eax, %ecx
180344e23: 41 d3 c9                    	rorl	%cl, %r9d
180344e26: 4c 8d 04 3e                 	leaq	(%rsi,%rdi), %r8
180344e2a: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180344e31: 41 d3 c9                    	rorl	%cl, %r9d
180344e34: 89 d1                       	movl	%edx, %ecx
180344e36: 41 d3 c1                    	roll	%cl, %r9d
180344e39: 41 d3 c1                    	roll	%cl, %r9d
180344e3c: 49 63 c1                    	movslq	%r9d, %rax
180344e3f: 4c 89 c1                    	movq	%r8, %rcx
180344e42: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344e45: 48 83 c7 e8                 	addq	$-0x18, %rdi
180344e49: 48 83 ff e8                 	cmpq	$-0x18, %rdi
180344e4d: 75 a1                       	jne	0x180344df0 <.text+0x334df0>
180344e4f: b8 30 19 b7 42              	movl	$0x42b71930, %eax       # imm = 0x42B71930
180344e54: 33 05 ea bc 46 00           	xorl	0x46bcea(%rip), %eax    # 0x1807b0b44
180344e5a: 05 cd 7c 6e 17              	addl	$0x176e7ccd, %eax       # imm = 0x176E7CCD
180344e5f: 48 98                       	cltq
180344e61: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344e65: 48 8d 34 c5 50 0c 00 00     	leaq	0xc50(,%rax,8), %rsi
180344e6d: 48 01 ee                    	addq	%rbp, %rsi
180344e70: bf 18 00 00 00              	movl	$0x18, %edi
180344e75: 48 63 05 2c 35 48 00        	movslq	0x48352c(%rip), %rax    # 0x1807c83a8
180344e7c: 45 8b 04 87                 	movl	(%r15,%rax,4), %r8d
180344e80: 41 8d 40 01                 	leal	0x1(%r8), %eax
180344e84: 48 98                       	cltq
180344e86: 45 8b 0c 86                 	movl	(%r14,%rax,4), %r9d
180344e8a: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180344e91: 89 c1                       	movl	%eax, %ecx
180344e93: 41 d3 c9                    	rorl	%cl, %r9d
180344e96: 41 0f c9                    	bswapl	%r9d
180344e99: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180344e9e: 44 29 c2                    	subl	%r8d, %edx
180344ea1: 89 d1                       	movl	%edx, %ecx
180344ea3: 41 d3 c1                    	roll	%cl, %r9d
180344ea6: 89 c1                       	movl	%eax, %ecx
180344ea8: 41 d3 c9                    	rorl	%cl, %r9d
180344eab: 4c 8d 04 3e                 	leaq	(%rsi,%rdi), %r8
180344eaf: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180344eb6: 41 d3 c9                    	rorl	%cl, %r9d
180344eb9: 89 d1                       	movl	%edx, %ecx
180344ebb: 41 d3 c1                    	roll	%cl, %r9d
180344ebe: 41 d3 c1                    	roll	%cl, %r9d
180344ec1: 49 63 c1                    	movslq	%r9d, %rax
180344ec4: 4c 89 c1                    	movq	%r8, %rcx
180344ec7: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344eca: 48 83 c7 e8                 	addq	$-0x18, %rdi
180344ece: 48 83 ff e8                 	cmpq	$-0x18, %rdi
180344ed2: 75 a1                       	jne	0x180344e75 <.text+0x334e75>
180344ed4: b8 c2 64 07 a5              	movl	$0xa50764c2, %eax       # imm = 0xA50764C2
180344ed9: 33 05 59 bc 46 00           	xorl	0x46bc59(%rip), %eax    # 0x1807b0b38
180344edf: 05 a2 96 7f 95              	addl	$0x957f96a2, %eax       # imm = 0x957F96A2
180344ee4: 48 98                       	cltq
180344ee6: 48 8d 04 40                 	leaq	(%rax,%rax,2), %rax
180344eea: 48 8d 34 c5 f0 0a 00 00     	leaq	0xaf0(,%rax,8), %rsi
180344ef2: 48 01 ee                    	addq	%rbp, %rsi
180344ef5: bf 18 00 00 00              	movl	$0x18, %edi
180344efa: 48 63 05 af 34 48 00        	movslq	0x4834af(%rip), %rax    # 0x1807c83b0
180344f01: 45 8b 04 87                 	movl	(%r15,%rax,4), %r8d
180344f05: 41 8d 40 01                 	leal	0x1(%r8), %eax
180344f09: 48 98                       	cltq
180344f0b: 45 8b 0c 86                 	movl	(%r14,%rax,4), %r9d
180344f0f: 41 8d 80 eb 5a e6 ac        	leal	-0x5319a515(%r8), %eax
180344f16: 89 c1                       	movl	%eax, %ecx
180344f18: 41 d3 c9                    	rorl	%cl, %r9d
180344f1b: 41 0f c9                    	bswapl	%r9d
180344f1e: ba e9 5a e6 ac              	movl	$0xace65ae9, %edx       # imm = 0xACE65AE9
180344f23: 44 29 c2                    	subl	%r8d, %edx
180344f26: 89 d1                       	movl	%edx, %ecx
180344f28: 41 d3 c1                    	roll	%cl, %r9d
180344f2b: 89 c1                       	movl	%eax, %ecx
180344f2d: 41 d3 c9                    	rorl	%cl, %r9d
180344f30: 4c 8d 04 3e                 	leaq	(%rsi,%rdi), %r8
180344f34: 41 81 f1 ea 5a e6 ac        	xorl	$0xace65aea, %r9d       # imm = 0xACE65AEA
180344f3b: 41 d3 c9                    	rorl	%cl, %r9d
180344f3e: 89 d1                       	movl	%edx, %ecx
180344f40: 41 d3 c1                    	roll	%cl, %r9d
180344f43: 41 d3 c1                    	roll	%cl, %r9d
180344f46: 49 63 c1                    	movslq	%r9d, %rax
180344f49: 4c 89 c1                    	movq	%r8, %rcx
180344f4c: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344f4f: 48 83 c7 e8                 	addq	$-0x18, %rdi
180344f53: 48 83 ff e8                 	cmpq	$-0x18, %rdi
180344f57: 75 a1                       	jne	0x180344efa <.text+0x334efa>
180344f59: 48 63 05 78 36 48 00        	movslq	0x483678(%rip), %rax    # 0x1807c85d8
180344f60: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180344f64: 0f ca                       	bswapl	%edx
180344f66: f7 da                       	negl	%edx
180344f68: 81 f2 1a 8e 1c e0           	xorl	$0xe01c8e1a, %edx       # imm = 0xE01C8E1A
180344f6e: 8d 48 1a                    	leal	0x1a(%rax), %ecx
180344f71: d3 ca                       	rorl	%cl, %edx
180344f73: 4c 63 c2                    	movslq	%edx, %r8
180344f76: 47 8b 0c 86                 	movl	(%r14,%r8,4), %r9d
180344f7a: 41 8d 80 f8 ce 54 1a        	leal	0x1a54cef8(%r8), %eax
180344f81: 89 c1                       	movl	%eax, %ecx
180344f83: 41 d3 c9                    	rorl	%cl, %r9d
180344f86: ba f8 ce 54 1a              	movl	$0x1a54cef8, %edx       # imm = 0x1A54CEF8
180344f8b: 44 29 c2                    	subl	%r8d, %edx
180344f8e: 89 d1                       	movl	%edx, %ecx
180344f90: 41 d3 c1                    	roll	%cl, %r9d
180344f93: 89 c1                       	movl	%eax, %ecx
180344f95: 41 d3 c9                    	rorl	%cl, %r9d
180344f98: 89 d1                       	movl	%edx, %ecx
180344f9a: 41 d3 c1                    	roll	%cl, %r9d
180344f9d: 49 63 c1                    	movslq	%r9d, %rax
180344fa0: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
180344fa7: 48 89 f1                    	movq	%rsi, %rcx
180344faa: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344fad: 48 63 05 d4 33 48 00        	movslq	0x4833d4(%rip), %rax    # 0x1807c8388
180344fb4: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180344fb8: b9 19 00 00 00              	movl	$0x19, %ecx
180344fbd: 29 c1                       	subl	%eax, %ecx
180344fbf: d3 c2                       	roll	%cl, %edx
180344fc1: 8d 48 19                    	leal	0x19(%rax), %ecx
180344fc4: d3 ca                       	rorl	%cl, %edx
180344fc6: 81 f2 46 e9 05 84           	xorl	$0x8405e946, %edx       # imm = 0x8405E946
180344fcc: 48 63 c2                    	movslq	%edx, %rax
180344fcf: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180344fd3: b9 16 00 00 00              	movl	$0x16, %ecx
180344fd8: 29 c1                       	subl	%eax, %ecx
180344fda: d3 c2                       	roll	%cl, %edx
180344fdc: f7 da                       	negl	%edx
180344fde: 81 f2 e9 f6 2c 27           	xorl	$0x272cf6e9, %edx       # imm = 0x272CF6E9
180344fe4: 0f ca                       	bswapl	%edx
180344fe6: 83 c0 16                    	addl	$0x16, %eax
180344fe9: 89 c1                       	movl	%eax, %ecx
180344feb: d3 ca                       	rorl	%cl, %edx
180344fed: 81 f2 e9 f6 2c 27           	xorl	$0x272cf6e9, %edx       # imm = 0x272CF6E9
180344ff3: 48 63 c2                    	movslq	%edx, %rax
180344ff6: 48 89 f1                    	movq	%rsi, %rcx
180344ff9: ff 14 c3                    	callq	*(%rbx,%rax,8)
180344ffc: 48 8d 8d f0 0a 00 00        	leaq	0xaf0(%rbp), %rcx
180345003: 48 89 c2                    	movq	%rax, %rdx
180345006: e8 c5 4e cd ff              	callq	0x180019ed0 <.text+0x9ed0>
18034500b: 48 8b 85 98 0c 00 00        	movq	0xc98(%rbp), %rax
180345012: 48 8d 50 08                 	leaq	0x8(%rax), %rdx
180345016: b8 5b 60 b5 11              	movl	$0x11b5605b, %eax       # imm = 0x11B5605B
18034501b: 33 05 73 b9 46 00           	xorl	0x46b973(%rip), %eax    # 0x1807b0994
180345021: 05 29 b6 15 e6              	addl	$0xe615b629, %eax       # imm = 0xE615B629
180345026: 89 44 24 20                 	movl	%eax, 0x20(%rsp)
18034502a: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
180345031: 4c 8d 85 f0 0a 00 00        	leaq	0xaf0(%rbp), %r8
180345038: 4c 8d 8d 40 02 00 00        	leaq	0x240(%rbp), %r9
18034503f: e8 2c d7 fe ff              	callq	0x180332770 <.text+0x322770>
180345044: 48 63 05 75 33 48 00        	movslq	0x483375(%rip), %rax    # 0x1807c83c0
18034504b: 4c 8d 3d 2e 42 31 00        	leaq	0x31422e(%rip), %r15    # 0x180659280
180345052: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180345056: b9 0a 00 00 00              	movl	$0xa, %ecx
18034505b: 29 c1                       	subl	%eax, %ecx
18034505d: d3 c2                       	roll	%cl, %edx
18034505f: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180345065: d3 ca                       	rorl	%cl, %edx
180345067: d3 ca                       	rorl	%cl, %edx
180345069: d3 ca                       	rorl	%cl, %edx
18034506b: 48 63 c2                    	movslq	%edx, %rax
18034506e: 31 d2                       	xorl	%edx, %edx
180345070: 4c 8d 35 59 ea 47 00        	leaq	0x47ea59(%rip), %r14    # 0x1807c3ad0
180345077: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
18034507b: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180345081: d3 ca                       	rorl	%cl, %edx
180345083: d3 ca                       	rorl	%cl, %edx
180345085: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
18034508b: d3 ca                       	rorl	%cl, %edx
18034508d: 31 f6                       	xorl	%esi, %esi
18034508f: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180345094: 29 c1                       	subl	%eax, %ecx
180345096: d3 c2                       	roll	%cl, %edx
180345098: d3 c2                       	roll	%cl, %edx
18034509a: 48 63 c2                    	movslq	%edx, %rax
18034509d: 48 8d 8d f0 0a 00 00        	leaq	0xaf0(%rbp), %rcx
1803450a4: 4c 8d 2d c5 8b 47 00        	leaq	0x478bc5(%rip), %r13    # 0x1807bdc70
1803450ab: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803450b0: 48 63 05 c9 32 48 00        	movslq	0x4832c9(%rip), %rax    # 0x1807c8380
1803450b7: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803450bb: 8d 48 02                    	leal	0x2(%rax), %ecx
1803450be: d3 ca                       	rorl	%cl, %edx
1803450c0: b9 1d a8 63 e3              	movl	$0xe363a81d, %ecx       # imm = 0xE363A81D
1803450c5: 29 d1                       	subl	%edx, %ecx
1803450c7: f7 da                       	negl	%edx
1803450c9: 48 63 c2                    	movslq	%edx, %rax
1803450cc: 41 2b 34 86                 	subl	(%r14,%rax,4), %esi
1803450d0: 0f ce                       	bswapl	%esi
1803450d2: d3 ce                       	rorl	%cl, %esi
1803450d4: d3 ce                       	rorl	%cl, %esi
1803450d6: 48 63 c6                    	movslq	%esi, %rax
1803450d9: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
1803450e0: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803450e5: 84 c0                       	testb	%al, %al
1803450e7: 0f 84 b5 1c 00 00           	je	0x180346da2 <.text+0x336da2>
1803450ed: 48 63 05 c0 32 48 00        	movslq	0x4832c0(%rip), %rax    # 0x1807c83b4
1803450f4: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803450f8: 8d 88 79 3c 18 05           	leal	0x5183c79(%rax), %ecx
1803450fe: d3 ca                       	rorl	%cl, %edx
180345100: 81 f2 79 3c 18 05           	xorl	$0x5183c79, %edx        # imm = 0x5183C79
180345106: 0f ca                       	bswapl	%edx
180345108: d3 ca                       	rorl	%cl, %edx
18034510a: 48 63 c2                    	movslq	%edx, %rax
18034510d: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345111: 0f ca                       	bswapl	%edx
180345113: f7 da                       	negl	%edx
180345115: b9 f4 f0 4b 86              	movl	$0x864bf0f4, %ecx       # imm = 0x864BF0F4
18034511a: 29 c1                       	subl	%eax, %ecx
18034511c: d3 c2                       	roll	%cl, %edx
18034511e: be f4 f0 4b 86              	movl	$0x864bf0f4, %esi       # imm = 0x864BF0F4
180345123: f7 da                       	negl	%edx
180345125: 0f ca                       	bswapl	%edx
180345127: d3 c2                       	roll	%cl, %edx
180345129: 48 63 c2                    	movslq	%edx, %rax
18034512c: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
180345133: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180345138: b9 08 f7 66 3e              	movl	$0x3e66f708, %ecx       # imm = 0x3E66F708
18034513d: 33 0d cd b8 46 00           	xorl	0x46b8cd(%rip), %ecx    # 0x1807b0a10
180345143: 81 c1 a2 57 f3 56           	addl	$0x56f357a2, %ecx       # imm = 0x56F357A2
180345149: 39 08                       	cmpl	%ecx, (%rax)
18034514b: 0f 85 51 1c 00 00           	jne	0x180346da2 <.text+0x336da2>
180345151: 48 63 0d bc 30 48 00        	movslq	0x4830bc(%rip), %rcx    # 0x1807c8214
180345158: 31 c0                       	xorl	%eax, %eax
18034515a: 41 2b 04 8f                 	subl	(%r15,%rcx,4), %eax
18034515e: 83 c1 13                    	addl	$0x13, %ecx
180345161: d3 c8                       	rorl	%cl, %eax
180345163: 35 8c d9 34 11              	xorl	$0x1134d98c, %eax       # imm = 0x1134D98C
180345168: 8d 48 01                    	leal	0x1(%rax), %ecx
18034516b: 48 63 c9                    	movslq	%ecx, %rcx
18034516e: ba cc 37 fb 2d              	movl	$0x2dfb37cc, %edx       # imm = 0x2DFB37CC
180345173: 41 33 14 8e                 	xorl	(%r14,%rcx,4), %edx
180345177: 05 cd 37 fb 2d              	addl	$0x2dfb37cd, %eax       # imm = 0x2DFB37CD
18034517c: 89 c1                       	movl	%eax, %ecx
18034517e: d3 ca                       	rorl	%cl, %edx
180345180: 31 db                       	xorl	%ebx, %ebx
180345182: 0f ca                       	bswapl	%edx
180345184: f7 da                       	negl	%edx
180345186: d3 ca                       	rorl	%cl, %edx
180345188: d3 ca                       	rorl	%cl, %edx
18034518a: 48 63 c2                    	movslq	%edx, %rax
18034518d: 48 8d 7d d0                 	leaq	-0x30(%rbp), %rdi
180345191: 48 89 f9                    	movq	%rdi, %rcx
180345194: 31 d2                       	xorl	%edx, %edx
180345196: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034519b: 48 63 05 e2 31 48 00        	movslq	0x4831e2(%rip), %rax    # 0x1807c8384
1803451a2: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803451a6: 8d 88 79 3c 18 05           	leal	0x5183c79(%rax), %ecx
1803451ac: d3 ca                       	rorl	%cl, %edx
1803451ae: 81 f2 79 3c 18 05           	xorl	$0x5183c79, %edx        # imm = 0x5183C79
1803451b4: 0f ca                       	bswapl	%edx
1803451b6: d3 ca                       	rorl	%cl, %edx
1803451b8: 48 63 c2                    	movslq	%edx, %rax
1803451bb: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803451bf: 0f ca                       	bswapl	%edx
1803451c1: f7 da                       	negl	%edx
1803451c3: 29 c6                       	subl	%eax, %esi
1803451c5: 89 f1                       	movl	%esi, %ecx
1803451c7: d3 c2                       	roll	%cl, %edx
1803451c9: f7 da                       	negl	%edx
1803451cb: 0f ca                       	bswapl	%edx
1803451cd: d3 c2                       	roll	%cl, %edx
1803451cf: 48 63 c2                    	movslq	%edx, %rax
1803451d2: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
1803451d9: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803451de: 48 8d 50 08                 	leaq	0x8(%rax), %rdx
1803451e2: c6 44 24 28 00              	movb	$0x0, 0x28(%rsp)
1803451e7: c6 44 24 20 00              	movb	$0x0, 0x20(%rsp)
1803451ec: 48 8d 8d a0 07 00 00        	leaq	0x7a0(%rbp), %rcx
1803451f3: 49 89 f8                    	movq	%rdi, %r8
1803451f6: 41 b1 01                    	movb	$0x1, %r9b
1803451f9: e8 12 82 ff ff              	callq	0x18033d410 <.text+0x32d410>
1803451fe: 48 63 05 e3 33 48 00        	movslq	0x4833e3(%rip), %rax    # 0x1807c85e8
180345205: 4c 8d 35 74 40 31 00        	leaq	0x314074(%rip), %r14    # 0x180659280
18034520c: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345210: b9 0a 00 00 00              	movl	$0xa, %ecx
180345215: 29 c1                       	subl	%eax, %ecx
180345217: d3 c2                       	roll	%cl, %edx
180345219: 81 f2 aa 86 3c 13           	xorl	$0x133c86aa, %edx       # imm = 0x133C86AA
18034521f: 0f ca                       	bswapl	%edx
180345221: 8d 48 0a                    	leal	0xa(%rax), %ecx
180345224: d3 ca                       	rorl	%cl, %edx
180345226: 48 63 ca                    	movslq	%edx, %rcx
180345229: b8 f2 61 37 34              	movl	$0x343761f2, %eax       # imm = 0x343761F2
18034522e: 48 8d 3d 9b e8 47 00        	leaq	0x47e89b(%rip), %rdi    # 0x1807c3ad0
180345235: 33 04 8f                    	xorl	(%rdi,%rcx,4), %eax
180345238: 0f c8                       	bswapl	%eax
18034523a: f7 d8                       	negl	%eax
18034523c: 83 c1 0b                    	addl	$0xb, %ecx
18034523f: d3 c8                       	rorl	%cl, %eax
180345241: 0f c8                       	bswapl	%eax
180345243: 48 98                       	cltq
180345245: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
18034524c: 48 89 f1                    	movq	%rsi, %rcx
18034524f: 4c 8d 3d 1a 8a 47 00        	leaq	0x478a1a(%rip), %r15    # 0x1807bdc70
180345256: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
18034525a: 48 63 15 57 31 48 00        	movslq	0x483157(%rip), %rdx    # 0x1807c83b8
180345261: 45 8b 04 96                 	movl	(%r14,%rdx,4), %r8d
180345265: b8 b2 6d f7 8e              	movl	$0x8ef76db2, %eax       # imm = 0x8EF76DB2
18034526a: 29 d0                       	subl	%edx, %eax
18034526c: 89 c1                       	movl	%eax, %ecx
18034526e: 41 d3 c0                    	roll	%cl, %r8d
180345271: 8d 8a b2 6d f7 8e           	leal	-0x7108924e(%rdx), %ecx
180345277: 41 d3 c8                    	rorl	%cl, %r8d
18034527a: 41 d3 c8                    	rorl	%cl, %r8d
18034527d: 89 c1                       	movl	%eax, %ecx
18034527f: 41 d3 c0                    	roll	%cl, %r8d
180345282: 49 63 c0                    	movslq	%r8d, %rax
180345285: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180345288: ff ca                       	decl	%edx
18034528a: b9 71 df 66 fc              	movl	$0xfc66df71, %ecx       # imm = 0xFC66DF71
18034528f: 29 c1                       	subl	%eax, %ecx
180345291: d3 c2                       	roll	%cl, %edx
180345293: 0f ca                       	bswapl	%edx
180345295: d3 c2                       	roll	%cl, %edx
180345297: 0f ca                       	bswapl	%edx
180345299: f7 da                       	negl	%edx
18034529b: 0f ca                       	bswapl	%edx
18034529d: 48 63 c2                    	movslq	%edx, %rax
1803452a0: 48 89 f1                    	movq	%rsi, %rcx
1803452a3: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803452a7: 48 63 0d 62 2f 48 00        	movslq	0x482f62(%rip), %rcx    # 0x1807c8210
1803452ae: 41 8b 14 8e                 	movl	(%r14,%rcx,4), %edx
1803452b2: 81 c1 b3 3a c7 db           	addl	$0xdbc73ab3, %ecx       # imm = 0xDBC73AB3
1803452b8: d3 ca                       	rorl	%cl, %edx
1803452ba: d3 ca                       	rorl	%cl, %edx
1803452bc: 81 f2 db c7 3a b3           	xorl	$0xb33ac7db, %edx       # imm = 0xB33AC7DB
1803452c2: 0f ca                       	bswapl	%edx
1803452c4: 48 63 d2                    	movslq	%edx, %rdx
1803452c7: 2b 1c 97                    	subl	(%rdi,%rdx,4), %ebx
1803452ca: 0f cb                       	bswapl	%ebx
1803452cc: b9 11 39 22 28              	movl	$0x28223911, %ecx       # imm = 0x28223911
1803452d1: 29 d1                       	subl	%edx, %ecx
1803452d3: d3 c3                       	roll	%cl, %ebx
1803452d5: d3 c3                       	roll	%cl, %ebx
1803452d7: 4c 63 c3                    	movslq	%ebx, %r8
1803452da: 48 8d 75 60                 	leaq	0x60(%rbp), %rsi
1803452de: 48 89 f1                    	movq	%rsi, %rcx
1803452e1: 48 89 c2                    	movq	%rax, %rdx
1803452e4: 43 ff 14 c7                 	callq	*(%r15,%r8,8)
1803452e8: 48 8d 8d f0 0a 00 00        	leaq	0xaf0(%rbp), %rcx
1803452ef: 48 8d 95 a0 07 00 00        	leaq	0x7a0(%rbp), %rdx
1803452f6: 4c 8d 85 80 05 00 00        	leaq	0x580(%rbp), %r8
1803452fd: 49 89 f1                    	movq	%rsi, %r9
180345300: e8 4b 19 fe ff              	callq	0x180326c50 <.text+0x316c50>
180345305: 48 63 05 b0 30 48 00        	movslq	0x4830b0(%rip), %rax    # 0x1807c83bc
18034530c: 48 8d 1d 6d 3f 31 00        	leaq	0x313f6d(%rip), %rbx    # 0x180659280
180345313: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180345316: 0f ca                       	bswapl	%edx
180345318: 8d 48 13                    	leal	0x13(%rax), %ecx
18034531b: d3 ca                       	rorl	%cl, %edx
18034531d: f7 da                       	negl	%edx
18034531f: b9 13 00 00 00              	movl	$0x13, %ecx
180345324: 29 c1                       	subl	%eax, %ecx
180345326: d3 c2                       	roll	%cl, %edx
180345328: 48 63 c2                    	movslq	%edx, %rax
18034532b: 4c 8d 35 9e e7 47 00        	leaq	0x47e79e(%rip), %r14    # 0x1807c3ad0
180345332: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345336: 0f ca                       	bswapl	%edx
180345338: b9 ed 26 23 dc              	movl	$0xdc2326ed, %ecx       # imm = 0xDC2326ED
18034533d: 29 c1                       	subl	%eax, %ecx
18034533f: d3 c2                       	roll	%cl, %edx
180345341: f7 da                       	negl	%edx
180345343: d3 c2                       	roll	%cl, %edx
180345345: f7 d2                       	notl	%edx
180345347: 0f ca                       	bswapl	%edx
180345349: 48 63 c2                    	movslq	%edx, %rax
18034534c: 48 8d 8d f0 0a 00 00        	leaq	0xaf0(%rbp), %rcx
180345353: 4c 8d 2d 16 89 47 00        	leaq	0x478916(%rip), %r13    # 0x1807bdc70
18034535a: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034535f: 84 c0                       	testb	%al, %al
180345361: 0f 84 50 1a 00 00           	je	0x180346db7 <.text+0x336db7>
180345367: 48 63 05 e2 30 48 00        	movslq	0x4830e2(%rip), %rax    # 0x1807c8450
18034536e: 48 63 04 83                 	movslq	(%rbx,%rax,4), %rax
180345372: 48 35 3f 39 87 8f           	xorq	$-0x7078c6c1, %rax      # imm = 0x8F87393F
180345378: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
18034537c: 0f ca                       	bswapl	%edx
18034537e: 8d 48 03                    	leal	0x3(%rax), %ecx
180345381: d3 ca                       	rorl	%cl, %edx
180345383: f7 d2                       	notl	%edx
180345385: b9 83 1f a2 5d              	movl	$0x5da21f83, %ecx       # imm = 0x5DA21F83
18034538a: 29 c1                       	subl	%eax, %ecx
18034538c: d3 c2                       	roll	%cl, %edx
18034538e: f7 d2                       	notl	%edx
180345390: d3 c2                       	roll	%cl, %edx
180345392: bf 83 1f a2 5d              	movl	$0x5da21f83, %edi       # imm = 0x5DA21F83
180345397: f7 da                       	negl	%edx
180345399: 0f ca                       	bswapl	%edx
18034539b: 48 63 c2                    	movslq	%edx, %rax
18034539e: 48 8d b5 f0 0a 00 00        	leaq	0xaf0(%rbp), %rsi
1803453a5: 48 89 f1                    	movq	%rsi, %rcx
1803453a8: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803453ad: 4c 63 05 7c 2e 48 00        	movslq	0x482e7c(%rip), %r8     # 0x1807c8230
1803453b4: 42 8b 14 83                 	movl	(%rbx,%r8,4), %edx
1803453b8: b9 0b 00 00 00              	movl	$0xb, %ecx
1803453bd: 44 29 c1                    	subl	%r8d, %ecx
1803453c0: d3 c2                       	roll	%cl, %edx
1803453c2: f7 d2                       	notl	%edx
1803453c4: 41 8d 48 0b                 	leal	0xb(%r8), %ecx
1803453c8: d3 ca                       	rorl	%cl, %edx
1803453ca: 89 d1                       	movl	%edx, %ecx
1803453cc: f7 d1                       	notl	%ecx
1803453ce: 48 63 c9                    	movslq	%ecx, %rcx
1803453d1: 45 8b 0c 8e                 	movl	(%r14,%rcx,4), %r9d
1803453d5: 41 0f c9                    	bswapl	%r9d
1803453d8: 41 b8 27 57 c4 2e           	movl	$0x2ec45727, %r8d       # imm = 0x2EC45727
1803453de: 41 29 d0                    	subl	%edx, %r8d
1803453e1: 44 89 c1                    	movl	%r8d, %ecx
1803453e4: 41 d3 c9                    	rorl	%cl, %r9d
1803453e7: 81 c2 29 57 c4 2e           	addl	$0x2ec45729, %edx       # imm = 0x2EC45729
1803453ed: 89 d1                       	movl	%edx, %ecx
1803453ef: 41 d3 c1                    	roll	%cl, %r9d
1803453f2: 44 89 c1                    	movl	%r8d, %ecx
1803453f5: 41 d3 c9                    	rorl	%cl, %r9d
1803453f8: 41 81 f1 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r9d       # imm = 0xD13BA8D7
1803453ff: 41 ff c1                    	incl	%r9d
180345402: 89 d1                       	movl	%edx, %ecx
180345404: 41 d3 c1                    	roll	%cl, %r9d
180345407: 41 f7 d1                    	notl	%r9d
18034540a: 4d 63 c1                    	movslq	%r9d, %r8
18034540d: 48 8d 8d a0 05 00 00        	leaq	0x5a0(%rbp), %rcx
180345414: 48 89 c2                    	movq	%rax, %rdx
180345417: 43 ff 54 c5 00              	callq	*(%r13,%r8,8)
18034541c: 48 63 05 d5 2f 48 00        	movslq	0x482fd5(%rip), %rax    # 0x1807c83f8
180345423: 48 63 04 83                 	movslq	(%rbx,%rax,4), %rax
180345427: 48 35 3f 39 87 8f           	xorq	$-0x7078c6c1, %rax      # imm = 0x8F87393F
18034542d: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345431: 0f ca                       	bswapl	%edx
180345433: 8d 48 03                    	leal	0x3(%rax), %ecx
180345436: d3 ca                       	rorl	%cl, %edx
180345438: f7 d2                       	notl	%edx
18034543a: 29 c7                       	subl	%eax, %edi
18034543c: 89 f9                       	movl	%edi, %ecx
18034543e: d3 c2                       	roll	%cl, %edx
180345440: f7 d2                       	notl	%edx
180345442: d3 c2                       	roll	%cl, %edx
180345444: f7 da                       	negl	%edx
180345446: 0f ca                       	bswapl	%edx
180345448: 48 63 c2                    	movslq	%edx, %rax
18034544b: 48 89 f1                    	movq	%rsi, %rcx
18034544e: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180345453: 48 89 c1                    	movq	%rax, %rcx
180345456: e8 15 65 fd ff              	callq	0x18031b970 <.text+0x30b970>
18034545b: 48 63 0d ca 2d 48 00        	movslq	0x482dca(%rip), %rcx    # 0x1807c822c
180345462: 31 c0                       	xorl	%eax, %eax
180345464: 48 8d 15 15 3e 31 00        	leaq	0x313e15(%rip), %rdx    # 0x180659280
18034546b: 2b 04 8a                    	subl	(%rdx,%rcx,4), %eax
18034546e: 83 c1 13                    	addl	$0x13, %ecx
180345471: d3 c8                       	rorl	%cl, %eax
180345473: 35 8c d9 34 11              	xorl	$0x1134d98c, %eax       # imm = 0x1134D98C
180345478: 8d 48 01                    	leal	0x1(%rax), %ecx
18034547b: 48 63 c9                    	movslq	%ecx, %rcx
18034547e: ba cc 37 fb 2d              	movl	$0x2dfb37cc, %edx       # imm = 0x2DFB37CC
180345483: 4c 8d 05 46 e6 47 00        	leaq	0x47e646(%rip), %r8     # 0x1807c3ad0
18034548a: 41 33 14 88                 	xorl	(%r8,%rcx,4), %edx
18034548e: 05 cd 37 fb 2d              	addl	$0x2dfb37cd, %eax       # imm = 0x2DFB37CD
180345493: 89 c1                       	movl	%eax, %ecx
180345495: d3 ca                       	rorl	%cl, %edx
180345497: 0f ca                       	bswapl	%edx
180345499: f7 da                       	negl	%edx
18034549b: d3 ca                       	rorl	%cl, %edx
18034549d: d3 ca                       	rorl	%cl, %edx
18034549f: 48 63 c2                    	movslq	%edx, %rax
1803454a2: 48 8d 75 10                 	leaq	0x10(%rbp), %rsi
1803454a6: 48 89 f1                    	movq	%rsi, %rcx
1803454a9: 31 d2                       	xorl	%edx, %edx
1803454ab: 4c 8d 05 be 87 47 00        	leaq	0x4787be(%rip), %r8     # 0x1807bdc70
1803454b2: 41 ff 14 c0                 	callq	*(%r8,%rax,8)
1803454b6: c6 44 24 28 00              	movb	$0x0, 0x28(%rsp)
1803454bb: c6 44 24 20 00              	movb	$0x0, 0x20(%rsp)
1803454c0: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
1803454c7: 48 8d 95 a0 05 00 00        	leaq	0x5a0(%rbp), %rdx
1803454ce: 49 89 f0                    	movq	%rsi, %r8
1803454d1: 41 b1 01                    	movb	$0x1, %r9b
1803454d4: e8 e7 8b ff ff              	callq	0x18033e0c0 <.text+0x32e0c0>
1803454d9: 48 8d 8d a0 05 00 00        	leaq	0x5a0(%rbp), %rcx
1803454e0: e8 8b 64 fd ff              	callq	0x18031b970 <.text+0x30b970>
1803454e5: 48 63 05 00 31 48 00        	movslq	0x483100(%rip), %rax    # 0x1807c85ec
1803454ec: 4c 8d 35 8d 3d 31 00        	leaq	0x313d8d(%rip), %r14    # 0x180659280
1803454f3: 49 63 04 86                 	movslq	(%r14,%rax,4), %rax
1803454f7: 48 35 98 e5 ee ee           	xorq	$-0x11111a68, %rax      # imm = 0xEEEEE598
1803454fd: 48 8d 1d cc e5 47 00        	leaq	0x47e5cc(%rip), %rbx    # 0x1807c3ad0
180345504: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180345507: b9 12 00 00 00              	movl	$0x12, %ecx
18034550c: 29 c1                       	subl	%eax, %ecx
18034550e: d3 c2                       	roll	%cl, %edx
180345510: 81 f2 0f d7 6a d2           	xorl	$0xd26ad70f, %edx       # imm = 0xD26AD70F
180345516: 0f ca                       	bswapl	%edx
180345518: 8d 88 d2 6a d7 0f           	leal	0xfd76ad2(%rax), %ecx
18034551e: d3 ca                       	rorl	%cl, %edx
180345520: 81 f2 d2 6a d7 0f           	xorl	$0xfd76ad2, %edx        # imm = 0xFD76AD2
180345526: d3 ca                       	rorl	%cl, %edx
180345528: 0f ca                       	bswapl	%edx
18034552a: f7 da                       	negl	%edx
18034552c: 48 63 c2                    	movslq	%edx, %rax
18034552f: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
180345536: 48 89 f1                    	movq	%rsi, %rcx
180345539: 48 8d 3d 30 87 47 00        	leaq	0x478730(%rip), %rdi    # 0x1807bdc70
180345540: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345543: 48 63 05 52 2f 48 00        	movslq	0x482f52(%rip), %rax    # 0x1807c849c
18034554a: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
18034554e: 8d 48 12                    	leal	0x12(%rax), %ecx
180345551: d3 ca                       	rorl	%cl, %edx
180345553: f7 d2                       	notl	%edx
180345555: 48 63 c2                    	movslq	%edx, %rax
180345558: 8b 04 83                    	movl	(%rbx,%rax,4), %eax
18034555b: f7 d0                       	notl	%eax
18034555d: 0f c8                       	bswapl	%eax
18034555f: 48 98                       	cltq
180345561: 48 89 f1                    	movq	%rsi, %rcx
180345564: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345567: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
18034556e: 48 89 c2                    	movq	%rax, %rdx
180345571: e8 0a 06 fd ff              	callq	0x180315b80 <.text+0x305b80>
180345576: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
18034557d: 48 89 c1                    	movq	%rax, %rcx
180345580: e8 5b 49 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
180345585: 48 63 15 9c 2c 48 00        	movslq	0x482c9c(%rip), %rdx    # 0x1807c8228
18034558c: 4c 8d 3d ed 3c 31 00        	leaq	0x313ced(%rip), %r15    # 0x180659280
180345593: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180345597: b9 0b 00 00 00              	movl	$0xb, %ecx
18034559c: 29 d1                       	subl	%edx, %ecx
18034559e: d3 c0                       	roll	%cl, %eax
1803455a0: f7 d0                       	notl	%eax
1803455a2: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
1803455a5: d3 c8                       	rorl	%cl, %eax
1803455a7: 89 c1                       	movl	%eax, %ecx
1803455a9: f7 d1                       	notl	%ecx
1803455ab: 48 63 c9                    	movslq	%ecx, %rcx
1803455ae: 4c 8d 35 1b e5 47 00        	leaq	0x47e51b(%rip), %r14    # 0x1807c3ad0
1803455b5: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
1803455b9: 41 0f c8                    	bswapl	%r8d
1803455bc: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
1803455c1: 29 c2                       	subl	%eax, %edx
1803455c3: 89 d1                       	movl	%edx, %ecx
1803455c5: 41 d3 c8                    	rorl	%cl, %r8d
1803455c8: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
1803455cd: 89 c1                       	movl	%eax, %ecx
1803455cf: 41 d3 c0                    	roll	%cl, %r8d
1803455d2: 89 d1                       	movl	%edx, %ecx
1803455d4: 41 d3 c8                    	rorl	%cl, %r8d
1803455d7: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
1803455de: 41 ff c0                    	incl	%r8d
1803455e1: 89 c1                       	movl	%eax, %ecx
1803455e3: 41 d3 c0                    	roll	%cl, %r8d
1803455e6: 41 f7 d0                    	notl	%r8d
1803455e9: 49 63 c0                    	movslq	%r8d, %rax
1803455ec: 48 8d 8d c0 05 00 00        	leaq	0x5c0(%rbp), %rcx
1803455f3: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
1803455fa: 48 89 f2                    	movq	%rsi, %rdx
1803455fd: 48 8d 1d 6c 86 47 00        	leaq	0x47866c(%rip), %rbx    # 0x1807bdc70
180345604: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345607: 48 63 05 2e 2e 48 00        	movslq	0x482e2e(%rip), %rax    # 0x1807c843c
18034560e: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180345612: b9 0a 00 00 00              	movl	$0xa, %ecx
180345617: 29 c1                       	subl	%eax, %ecx
180345619: d3 c2                       	roll	%cl, %edx
18034561b: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180345621: d3 ca                       	rorl	%cl, %edx
180345623: d3 ca                       	rorl	%cl, %edx
180345625: d3 ca                       	rorl	%cl, %edx
180345627: 48 63 c2                    	movslq	%edx, %rax
18034562a: 31 d2                       	xorl	%edx, %edx
18034562c: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180345630: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180345636: d3 ca                       	rorl	%cl, %edx
180345638: d3 ca                       	rorl	%cl, %edx
18034563a: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180345640: d3 ca                       	rorl	%cl, %edx
180345642: 31 ff                       	xorl	%edi, %edi
180345644: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180345649: 29 c1                       	subl	%eax, %ecx
18034564b: d3 c2                       	roll	%cl, %edx
18034564d: d3 c2                       	roll	%cl, %edx
18034564f: 48 63 c2                    	movslq	%edx, %rax
180345652: 48 89 f1                    	movq	%rsi, %rcx
180345655: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345658: 48 63 05 51 2f 48 00        	movslq	0x482f51(%rip), %rax    # 0x1807c85b0
18034565f: 41 2b 3c 87                 	subl	(%r15,%rax,4), %edi
180345663: 8d 48 0d                    	leal	0xd(%rax), %ecx
180345666: d3 cf                       	rorl	%cl, %edi
180345668: 0f cf                       	bswapl	%edi
18034566a: 89 f8                       	movl	%edi, %eax
18034566c: f7 d8                       	negl	%eax
18034566e: 48 98                       	cltq
180345670: ba af e9 ea cd              	movl	$0xcdeae9af, %edx       # imm = 0xCDEAE9AF
180345675: 41 33 14 86                 	xorl	(%r14,%rax,4), %edx
180345679: 0f ca                       	bswapl	%edx
18034567b: 8d 4f 0f                    	leal	0xf(%rdi), %ecx
18034567e: d3 c2                       	roll	%cl, %edx
180345680: 81 f2 62 03 03 62           	xorl	$0x62030362, %edx       # imm = 0x62030362
180345686: b9 0f 00 00 00              	movl	$0xf, %ecx
18034568b: 29 f9                       	subl	%edi, %ecx
18034568d: d3 ca                       	rorl	%cl, %edx
18034568f: 48 63 c2                    	movslq	%edx, %rax
180345692: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
180345699: 48 89 f1                    	movq	%rsi, %rcx
18034569c: ff 14 c3                    	callq	*(%rbx,%rax,8)
18034569f: 48 63 05 3e 2d 48 00        	movslq	0x482d3e(%rip), %rax    # 0x1807c83e4
1803456a6: 41 8b 04 87                 	movl	(%r15,%rax,4), %eax
1803456aa: 8d 48 01                    	leal	0x1(%rax), %ecx
1803456ad: 48 63 c9                    	movslq	%ecx, %rcx
1803456b0: ba 69 dd 03 06              	movl	$0x603dd69, %edx        # imm = 0x603DD69
1803456b5: 41 33 14 8e                 	xorl	(%r14,%rcx,4), %edx
1803456b9: ff ca                       	decl	%edx
1803456bb: 0f ca                       	bswapl	%edx
1803456bd: b9 08 00 00 00              	movl	$0x8, %ecx
1803456c2: 29 c1                       	subl	%eax, %ecx
1803456c4: d3 c2                       	roll	%cl, %edx
1803456c6: 0f ca                       	bswapl	%edx
1803456c8: 48 63 c2                    	movslq	%edx, %rax
1803456cb: 48 89 f1                    	movq	%rsi, %rcx
1803456ce: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803456d1: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
1803456d8: 48 89 c2                    	movq	%rax, %rdx
1803456db: e8 a0 04 fd ff              	callq	0x180315b80 <.text+0x305b80>
1803456e0: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
1803456e7: 48 89 c1                    	movq	%rax, %rcx
1803456ea: e8 f1 47 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
1803456ef: 48 63 15 22 2b 48 00        	movslq	0x482b22(%rip), %rdx    # 0x1807c8218
1803456f6: 4c 8d 3d 83 3b 31 00        	leaq	0x313b83(%rip), %r15    # 0x180659280
1803456fd: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180345701: b9 0b 00 00 00              	movl	$0xb, %ecx
180345706: 29 d1                       	subl	%edx, %ecx
180345708: d3 c0                       	roll	%cl, %eax
18034570a: f7 d0                       	notl	%eax
18034570c: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
18034570f: d3 c8                       	rorl	%cl, %eax
180345711: 89 c1                       	movl	%eax, %ecx
180345713: f7 d1                       	notl	%ecx
180345715: 48 63 c9                    	movslq	%ecx, %rcx
180345718: 4c 8d 35 b1 e3 47 00        	leaq	0x47e3b1(%rip), %r14    # 0x1807c3ad0
18034571f: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180345723: 41 0f c8                    	bswapl	%r8d
180345726: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
18034572b: 29 c2                       	subl	%eax, %edx
18034572d: 89 d1                       	movl	%edx, %ecx
18034572f: 41 d3 c8                    	rorl	%cl, %r8d
180345732: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180345737: 89 c1                       	movl	%eax, %ecx
180345739: 41 d3 c0                    	roll	%cl, %r8d
18034573c: 89 d1                       	movl	%edx, %ecx
18034573e: 41 d3 c8                    	rorl	%cl, %r8d
180345741: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180345748: 41 ff c0                    	incl	%r8d
18034574b: 89 c1                       	movl	%eax, %ecx
18034574d: 41 d3 c0                    	roll	%cl, %r8d
180345750: be 0b 00 00 00              	movl	$0xb, %esi
180345755: 41 f7 d0                    	notl	%r8d
180345758: 49 63 c0                    	movslq	%r8d, %rax
18034575b: 48 8d 8d 60 02 00 00        	leaq	0x260(%rbp), %rcx
180345762: 48 8d bd 50 0c 00 00        	leaq	0xc50(%rbp), %rdi
180345769: 48 89 fa                    	movq	%rdi, %rdx
18034576c: 48 8d 1d fd 84 47 00        	leaq	0x4784fd(%rip), %rbx    # 0x1807bdc70
180345773: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345776: 48 63 05 9b 2c 48 00        	movslq	0x482c9b(%rip), %rax    # 0x1807c8418
18034577d: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180345781: b9 0a 00 00 00              	movl	$0xa, %ecx
180345786: 29 c1                       	subl	%eax, %ecx
180345788: d3 c2                       	roll	%cl, %edx
18034578a: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180345790: d3 ca                       	rorl	%cl, %edx
180345792: d3 ca                       	rorl	%cl, %edx
180345794: d3 ca                       	rorl	%cl, %edx
180345796: 48 63 c2                    	movslq	%edx, %rax
180345799: 31 d2                       	xorl	%edx, %edx
18034579b: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
18034579f: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803457a5: d3 ca                       	rorl	%cl, %edx
1803457a7: d3 ca                       	rorl	%cl, %edx
1803457a9: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803457af: d3 ca                       	rorl	%cl, %edx
1803457b1: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803457b6: 29 c1                       	subl	%eax, %ecx
1803457b8: d3 c2                       	roll	%cl, %edx
1803457ba: d3 c2                       	roll	%cl, %edx
1803457bc: 48 63 c2                    	movslq	%edx, %rax
1803457bf: 48 89 f9                    	movq	%rdi, %rcx
1803457c2: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803457c5: 48 63 05 14 2e 48 00        	movslq	0x482e14(%rip), %rax    # 0x1807c85e0
1803457cc: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803457d0: 29 c6                       	subl	%eax, %esi
1803457d2: 89 f1                       	movl	%esi, %ecx
1803457d4: d3 c2                       	roll	%cl, %edx
1803457d6: 8d 4a 0c                    	leal	0xc(%rdx), %ecx
1803457d9: b8 ec d1 f0 1d              	movl	$0x1df0d1ec, %eax       # imm = 0x1DF0D1EC
1803457de: 29 d0                       	subl	%edx, %eax
1803457e0: f7 da                       	negl	%edx
1803457e2: 48 63 d2                    	movslq	%edx, %rdx
1803457e5: 41 8b 14 96                 	movl	(%r14,%rdx,4), %edx
1803457e9: ff ca                       	decl	%edx
1803457eb: d3 c2                       	roll	%cl, %edx
1803457ed: 89 c1                       	movl	%eax, %ecx
1803457ef: d3 ca                       	rorl	%cl, %edx
1803457f1: f7 d2                       	notl	%edx
1803457f3: d3 ca                       	rorl	%cl, %edx
1803457f5: 48 63 c2                    	movslq	%edx, %rax
1803457f8: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
1803457ff: 48 89 f1                    	movq	%rsi, %rcx
180345802: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345805: 48 63 05 5c 2c 48 00        	movslq	0x482c5c(%rip), %rax    # 0x1807c8468
18034580c: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180345810: 8d 48 12                    	leal	0x12(%rax), %ecx
180345813: d3 ca                       	rorl	%cl, %edx
180345815: f7 d2                       	notl	%edx
180345817: 48 63 c2                    	movslq	%edx, %rax
18034581a: 41 8b 04 86                 	movl	(%r14,%rax,4), %eax
18034581e: f7 d0                       	notl	%eax
180345820: 0f c8                       	bswapl	%eax
180345822: 48 98                       	cltq
180345824: 48 89 f1                    	movq	%rsi, %rcx
180345827: ff 14 c3                    	callq	*(%rbx,%rax,8)
18034582a: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180345831: 48 89 c2                    	movq	%rax, %rdx
180345834: e8 47 03 fd ff              	callq	0x180315b80 <.text+0x305b80>
180345839: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
180345840: 48 89 c1                    	movq	%rax, %rcx
180345843: e8 98 46 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
180345848: 48 63 15 cd 29 48 00        	movslq	0x4829cd(%rip), %rdx    # 0x1807c821c
18034584f: 4c 8d 35 2a 3a 31 00        	leaq	0x313a2a(%rip), %r14    # 0x180659280
180345856: 41 8b 04 96                 	movl	(%r14,%rdx,4), %eax
18034585a: b9 0b 00 00 00              	movl	$0xb, %ecx
18034585f: 29 d1                       	subl	%edx, %ecx
180345861: d3 c0                       	roll	%cl, %eax
180345863: f7 d0                       	notl	%eax
180345865: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180345868: d3 c8                       	rorl	%cl, %eax
18034586a: 89 c1                       	movl	%eax, %ecx
18034586c: f7 d1                       	notl	%ecx
18034586e: 48 63 c9                    	movslq	%ecx, %rcx
180345871: 48 8d 1d 58 e2 47 00        	leaq	0x47e258(%rip), %rbx    # 0x1807c3ad0
180345878: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
18034587c: 41 0f c8                    	bswapl	%r8d
18034587f: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180345884: 29 c2                       	subl	%eax, %edx
180345886: 89 d1                       	movl	%edx, %ecx
180345888: 41 d3 c8                    	rorl	%cl, %r8d
18034588b: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180345890: 89 c1                       	movl	%eax, %ecx
180345892: 41 d3 c0                    	roll	%cl, %r8d
180345895: 89 d1                       	movl	%edx, %ecx
180345897: 41 d3 c8                    	rorl	%cl, %r8d
18034589a: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
1803458a1: 41 ff c0                    	incl	%r8d
1803458a4: 89 c1                       	movl	%eax, %ecx
1803458a6: 41 d3 c0                    	roll	%cl, %r8d
1803458a9: 41 f7 d0                    	notl	%r8d
1803458ac: 49 63 c0                    	movslq	%r8d, %rax
1803458af: 48 8d 8d 10 0a 00 00        	leaq	0xa10(%rbp), %rcx
1803458b6: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
1803458bd: 48 89 f2                    	movq	%rsi, %rdx
1803458c0: 48 8d 3d a9 83 47 00        	leaq	0x4783a9(%rip), %rdi    # 0x1807bdc70
1803458c7: ff 14 c7                    	callq	*(%rdi,%rax,8)
1803458ca: 48 63 05 73 2b 48 00        	movslq	0x482b73(%rip), %rax    # 0x1807c8444
1803458d1: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803458d5: b9 0a 00 00 00              	movl	$0xa, %ecx
1803458da: 29 c1                       	subl	%eax, %ecx
1803458dc: d3 c2                       	roll	%cl, %edx
1803458de: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803458e4: d3 ca                       	rorl	%cl, %edx
1803458e6: d3 ca                       	rorl	%cl, %edx
1803458e8: d3 ca                       	rorl	%cl, %edx
1803458ea: 48 63 c2                    	movslq	%edx, %rax
1803458ed: 31 d2                       	xorl	%edx, %edx
1803458ef: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
1803458f2: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803458f8: d3 ca                       	rorl	%cl, %edx
1803458fa: d3 ca                       	rorl	%cl, %edx
1803458fc: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180345902: d3 ca                       	rorl	%cl, %edx
180345904: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180345909: 29 c1                       	subl	%eax, %ecx
18034590b: d3 c2                       	roll	%cl, %edx
18034590d: d3 c2                       	roll	%cl, %edx
18034590f: 48 63 c2                    	movslq	%edx, %rax
180345912: 48 89 f1                    	movq	%rsi, %rcx
180345915: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345918: 48 63 05 d9 2c 48 00        	movslq	0x482cd9(%rip), %rax    # 0x1807c85f8
18034591f: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345923: ff ca                       	decl	%edx
180345925: b9 19 00 00 00              	movl	$0x19, %ecx
18034592a: 29 c1                       	subl	%eax, %ecx
18034592c: d3 c2                       	roll	%cl, %edx
18034592e: 81 f2 b9 00 0f c9           	xorl	$0xc90f00b9, %edx       # imm = 0xC90F00B9
180345934: 48 63 d2                    	movslq	%edx, %rdx
180345937: 8b 04 93                    	movl	(%rbx,%rdx,4), %eax
18034593a: 0f c8                       	bswapl	%eax
18034593c: 8d 4a 02                    	leal	0x2(%rdx), %ecx
18034593f: d3 c8                       	rorl	%cl, %eax
180345941: b9 c2 9d d7 a3              	movl	$0xa3d79dc2, %ecx       # imm = 0xA3D79DC2
180345946: 29 d1                       	subl	%edx, %ecx
180345948: d3 c0                       	roll	%cl, %eax
18034594a: d3 c0                       	roll	%cl, %eax
18034594c: f7 d8                       	negl	%eax
18034594e: 35 a3 d7 9d c2              	xorl	$0xc29dd7a3, %eax       # imm = 0xC29DD7A3
180345953: 0f c8                       	bswapl	%eax
180345955: d3 c0                       	roll	%cl, %eax
180345957: 48 98                       	cltq
180345959: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
180345960: 48 89 f1                    	movq	%rsi, %rcx
180345963: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345966: 48 63 05 9b 2a 48 00        	movslq	0x482a9b(%rip), %rax    # 0x1807c8408
18034596d: 41 8b 04 86                 	movl	(%r14,%rax,4), %eax
180345971: 8d 48 01                    	leal	0x1(%rax), %ecx
180345974: 48 63 c9                    	movslq	%ecx, %rcx
180345977: ba 69 dd 03 06              	movl	$0x603dd69, %edx        # imm = 0x603DD69
18034597c: 33 14 8b                    	xorl	(%rbx,%rcx,4), %edx
18034597f: ff ca                       	decl	%edx
180345981: 0f ca                       	bswapl	%edx
180345983: b9 08 00 00 00              	movl	$0x8, %ecx
180345988: 29 c1                       	subl	%eax, %ecx
18034598a: d3 c2                       	roll	%cl, %edx
18034598c: 0f ca                       	bswapl	%edx
18034598e: 48 63 c2                    	movslq	%edx, %rax
180345991: 48 89 f1                    	movq	%rsi, %rcx
180345994: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345997: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
18034599e: 48 89 c2                    	movq	%rax, %rdx
1803459a1: e8 da 01 fd ff              	callq	0x180315b80 <.text+0x305b80>
1803459a6: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
1803459ad: 48 89 c1                    	movq	%rax, %rcx
1803459b0: e8 2b 45 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
1803459b5: 48 63 15 64 28 48 00        	movslq	0x482864(%rip), %rdx    # 0x1807c8220
1803459bc: 4c 8d 35 bd 38 31 00        	leaq	0x3138bd(%rip), %r14    # 0x180659280
1803459c3: 41 8b 04 96                 	movl	(%r14,%rdx,4), %eax
1803459c7: b9 0b 00 00 00              	movl	$0xb, %ecx
1803459cc: 29 d1                       	subl	%edx, %ecx
1803459ce: d3 c0                       	roll	%cl, %eax
1803459d0: f7 d0                       	notl	%eax
1803459d2: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
1803459d5: d3 c8                       	rorl	%cl, %eax
1803459d7: 89 c1                       	movl	%eax, %ecx
1803459d9: f7 d1                       	notl	%ecx
1803459db: 48 63 c9                    	movslq	%ecx, %rcx
1803459de: 48 8d 1d eb e0 47 00        	leaq	0x47e0eb(%rip), %rbx    # 0x1807c3ad0
1803459e5: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
1803459e9: 41 0f c8                    	bswapl	%r8d
1803459ec: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
1803459f1: 29 c2                       	subl	%eax, %edx
1803459f3: 89 d1                       	movl	%edx, %ecx
1803459f5: 41 d3 c8                    	rorl	%cl, %r8d
1803459f8: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
1803459fd: 89 c1                       	movl	%eax, %ecx
1803459ff: 41 d3 c0                    	roll	%cl, %r8d
180345a02: 89 d1                       	movl	%edx, %ecx
180345a04: 41 d3 c8                    	rorl	%cl, %r8d
180345a07: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180345a0e: 41 ff c0                    	incl	%r8d
180345a11: 89 c1                       	movl	%eax, %ecx
180345a13: 41 d3 c0                    	roll	%cl, %r8d
180345a16: 41 f7 d0                    	notl	%r8d
180345a19: 49 63 c0                    	movslq	%r8d, %rax
180345a1c: 48 8d 8d 00 09 00 00        	leaq	0x900(%rbp), %rcx
180345a23: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
180345a2a: 48 89 f2                    	movq	%rsi, %rdx
180345a2d: 48 8d 3d 3c 82 47 00        	leaq	0x47823c(%rip), %rdi    # 0x1807bdc70
180345a34: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345a37: 48 63 05 5a 2a 48 00        	movslq	0x482a5a(%rip), %rax    # 0x1807c8498
180345a3e: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345a42: b9 0a 00 00 00              	movl	$0xa, %ecx
180345a47: 29 c1                       	subl	%eax, %ecx
180345a49: d3 c2                       	roll	%cl, %edx
180345a4b: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180345a51: d3 ca                       	rorl	%cl, %edx
180345a53: d3 ca                       	rorl	%cl, %edx
180345a55: d3 ca                       	rorl	%cl, %edx
180345a57: 48 63 c2                    	movslq	%edx, %rax
180345a5a: 31 d2                       	xorl	%edx, %edx
180345a5c: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
180345a5f: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180345a65: d3 ca                       	rorl	%cl, %edx
180345a67: d3 ca                       	rorl	%cl, %edx
180345a69: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180345a6f: d3 ca                       	rorl	%cl, %edx
180345a71: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180345a76: 29 c1                       	subl	%eax, %ecx
180345a78: d3 c2                       	roll	%cl, %edx
180345a7a: d3 c2                       	roll	%cl, %edx
180345a7c: 48 63 c2                    	movslq	%edx, %rax
180345a7f: 48 89 f1                    	movq	%rsi, %rcx
180345a82: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345a85: 48 63 05 7c 2b 48 00        	movslq	0x482b7c(%rip), %rax    # 0x1807c8608
180345a8c: 41 8b 04 86                 	movl	(%r14,%rax,4), %eax
180345a90: f7 d0                       	notl	%eax
180345a92: 0f c8                       	bswapl	%eax
180345a94: 48 98                       	cltq
180345a96: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180345a99: 8d 88 34 91 19 a0           	leal	-0x5fe66ecc(%rax), %ecx
180345a9f: d3 ca                       	rorl	%cl, %edx
180345aa1: f7 d2                       	notl	%edx
180345aa3: d3 ca                       	rorl	%cl, %edx
180345aa5: f7 d2                       	notl	%edx
180345aa7: b9 34 91 19 a0              	movl	$0xa0199134, %ecx       # imm = 0xA0199134
180345aac: 29 c1                       	subl	%eax, %ecx
180345aae: d3 c2                       	roll	%cl, %edx
180345ab0: d3 c2                       	roll	%cl, %edx
180345ab2: 48 63 c2                    	movslq	%edx, %rax
180345ab5: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
180345abc: 48 89 f1                    	movq	%rsi, %rcx
180345abf: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345ac2: 48 63 0d 77 29 48 00        	movslq	0x482977(%rip), %rcx    # 0x1807c8440
180345ac9: b8 e5 6c 5a 59              	movl	$0x595a6ce5, %eax       # imm = 0x595A6CE5
180345ace: 41 33 04 8e                 	xorl	(%r14,%rcx,4), %eax
180345ad2: ff c0                       	incl	%eax
180345ad4: 83 c1 1a                    	addl	$0x1a, %ecx
180345ad7: d3 c8                       	rorl	%cl, %eax
180345ad9: 89 c1                       	movl	%eax, %ecx
180345adb: f7 d1                       	notl	%ecx
180345add: 48 63 d1                    	movslq	%ecx, %rdx
180345ae0: 8b 14 93                    	movl	(%rbx,%rdx,4), %edx
180345ae3: ff ca                       	decl	%edx
180345ae5: d3 ca                       	rorl	%cl, %edx
180345ae7: f7 da                       	negl	%edx
180345ae9: ff c0                       	incl	%eax
180345aeb: 89 c1                       	movl	%eax, %ecx
180345aed: d3 c2                       	roll	%cl, %edx
180345aef: f7 da                       	negl	%edx
180345af1: 81 f2 df 30 83 80           	xorl	$0x808330df, %edx       # imm = 0x808330DF
180345af7: 0f ca                       	bswapl	%edx
180345af9: 48 63 c2                    	movslq	%edx, %rax
180345afc: 48 89 f1                    	movq	%rsi, %rcx
180345aff: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345b02: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180345b09: 48 89 c2                    	movq	%rax, %rdx
180345b0c: e8 6f 00 fd ff              	callq	0x180315b80 <.text+0x305b80>
180345b11: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
180345b18: 48 89 c1                    	movq	%rax, %rcx
180345b1b: e8 c0 43 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
180345b20: 48 63 15 fd 26 48 00        	movslq	0x4826fd(%rip), %rdx    # 0x1807c8224
180345b27: 4c 8d 3d 52 37 31 00        	leaq	0x313752(%rip), %r15    # 0x180659280
180345b2e: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180345b32: b9 0b 00 00 00              	movl	$0xb, %ecx
180345b37: 29 d1                       	subl	%edx, %ecx
180345b39: d3 c0                       	roll	%cl, %eax
180345b3b: f7 d0                       	notl	%eax
180345b3d: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180345b40: d3 c8                       	rorl	%cl, %eax
180345b42: 89 c1                       	movl	%eax, %ecx
180345b44: f7 d1                       	notl	%ecx
180345b46: 48 63 c9                    	movslq	%ecx, %rcx
180345b49: 4c 8d 35 80 df 47 00        	leaq	0x47df80(%rip), %r14    # 0x1807c3ad0
180345b50: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180345b54: 41 0f c8                    	bswapl	%r8d
180345b57: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180345b5c: 29 c2                       	subl	%eax, %edx
180345b5e: 89 d1                       	movl	%edx, %ecx
180345b60: 41 d3 c8                    	rorl	%cl, %r8d
180345b63: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180345b68: 89 c1                       	movl	%eax, %ecx
180345b6a: 41 d3 c0                    	roll	%cl, %r8d
180345b6d: 89 d1                       	movl	%edx, %ecx
180345b6f: 41 d3 c8                    	rorl	%cl, %r8d
180345b72: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180345b79: 41 ff c0                    	incl	%r8d
180345b7c: 89 c1                       	movl	%eax, %ecx
180345b7e: 41 d3 c0                    	roll	%cl, %r8d
180345b81: 41 f7 d0                    	notl	%r8d
180345b84: 49 63 c0                    	movslq	%r8d, %rax
180345b87: 48 8d 8d d0 09 00 00        	leaq	0x9d0(%rbp), %rcx
180345b8e: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
180345b95: 48 89 f2                    	movq	%rsi, %rdx
180345b98: 48 8d 1d d1 80 47 00        	leaq	0x4780d1(%rip), %rbx    # 0x1807bdc70
180345b9f: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345ba2: 48 63 05 2f 28 48 00        	movslq	0x48282f(%rip), %rax    # 0x1807c83d8
180345ba9: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180345bad: b9 0a 00 00 00              	movl	$0xa, %ecx
180345bb2: 29 c1                       	subl	%eax, %ecx
180345bb4: d3 c2                       	roll	%cl, %edx
180345bb6: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180345bbc: d3 ca                       	rorl	%cl, %edx
180345bbe: d3 ca                       	rorl	%cl, %edx
180345bc0: d3 ca                       	rorl	%cl, %edx
180345bc2: 48 63 c2                    	movslq	%edx, %rax
180345bc5: 31 d2                       	xorl	%edx, %edx
180345bc7: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180345bcb: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180345bd1: d3 ca                       	rorl	%cl, %edx
180345bd3: d3 ca                       	rorl	%cl, %edx
180345bd5: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180345bdb: d3 ca                       	rorl	%cl, %edx
180345bdd: 31 ff                       	xorl	%edi, %edi
180345bdf: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180345be4: 29 c1                       	subl	%eax, %ecx
180345be6: d3 c2                       	roll	%cl, %edx
180345be8: d3 c2                       	roll	%cl, %edx
180345bea: 48 63 c2                    	movslq	%edx, %rax
180345bed: 48 89 f1                    	movq	%rsi, %rcx
180345bf0: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345bf3: 48 63 05 02 2a 48 00        	movslq	0x482a02(%rip), %rax    # 0x1807c85fc
180345bfa: 41 2b 3c 87                 	subl	(%r15,%rax,4), %edi
180345bfe: 81 f7 ed 65 de 3b           	xorl	$0x3bde65ed, %edi       # imm = 0x3BDE65ED
180345c04: 48 63 c7                    	movslq	%edi, %rax
180345c07: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345c0b: b9 85 42 25 90              	movl	$0x90254285, %ecx       # imm = 0x90254285
180345c10: 29 c1                       	subl	%eax, %ecx
180345c12: d3 c2                       	roll	%cl, %edx
180345c14: ff ca                       	decl	%edx
180345c16: d3 c2                       	roll	%cl, %edx
180345c18: d3 c2                       	roll	%cl, %edx
180345c1a: ff ca                       	decl	%edx
180345c1c: 0f ca                       	bswapl	%edx
180345c1e: 48 63 c2                    	movslq	%edx, %rax
180345c21: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
180345c28: 48 89 f1                    	movq	%rsi, %rcx
180345c2b: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345c2e: 48 63 0d df 27 48 00        	movslq	0x4827df(%rip), %rcx    # 0x1807c8414
180345c35: b8 e5 6c 5a 59              	movl	$0x595a6ce5, %eax       # imm = 0x595A6CE5
180345c3a: 41 33 04 8f                 	xorl	(%r15,%rcx,4), %eax
180345c3e: ff c0                       	incl	%eax
180345c40: 83 c1 1a                    	addl	$0x1a, %ecx
180345c43: d3 c8                       	rorl	%cl, %eax
180345c45: 89 c1                       	movl	%eax, %ecx
180345c47: f7 d1                       	notl	%ecx
180345c49: 48 63 d1                    	movslq	%ecx, %rdx
180345c4c: 41 8b 14 96                 	movl	(%r14,%rdx,4), %edx
180345c50: ff ca                       	decl	%edx
180345c52: d3 ca                       	rorl	%cl, %edx
180345c54: f7 da                       	negl	%edx
180345c56: ff c0                       	incl	%eax
180345c58: 89 c1                       	movl	%eax, %ecx
180345c5a: d3 c2                       	roll	%cl, %edx
180345c5c: f7 da                       	negl	%edx
180345c5e: 81 f2 df 30 83 80           	xorl	$0x808330df, %edx       # imm = 0x808330DF
180345c64: 0f ca                       	bswapl	%edx
180345c66: 48 63 c2                    	movslq	%edx, %rax
180345c69: 48 89 f1                    	movq	%rsi, %rcx
180345c6c: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345c6f: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180345c76: 48 89 c2                    	movq	%rax, %rdx
180345c79: e8 02 ff fc ff              	callq	0x180315b80 <.text+0x305b80>
180345c7e: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
180345c85: 48 89 c1                    	movq	%rax, %rcx
180345c88: e8 53 42 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
180345c8d: 48 63 15 ac 25 48 00        	movslq	0x4825ac(%rip), %rdx    # 0x1807c8240
180345c94: 4c 8d 3d e5 35 31 00        	leaq	0x3135e5(%rip), %r15    # 0x180659280
180345c9b: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180345c9f: b9 0b 00 00 00              	movl	$0xb, %ecx
180345ca4: 29 d1                       	subl	%edx, %ecx
180345ca6: d3 c0                       	roll	%cl, %eax
180345ca8: f7 d0                       	notl	%eax
180345caa: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180345cad: d3 c8                       	rorl	%cl, %eax
180345caf: 89 c1                       	movl	%eax, %ecx
180345cb1: f7 d1                       	notl	%ecx
180345cb3: 48 63 c9                    	movslq	%ecx, %rcx
180345cb6: 4c 8d 35 13 de 47 00        	leaq	0x47de13(%rip), %r14    # 0x1807c3ad0
180345cbd: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180345cc1: 41 0f c8                    	bswapl	%r8d
180345cc4: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180345cc9: 29 c2                       	subl	%eax, %edx
180345ccb: 89 d1                       	movl	%edx, %ecx
180345ccd: 41 d3 c8                    	rorl	%cl, %r8d
180345cd0: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180345cd5: 89 c1                       	movl	%eax, %ecx
180345cd7: 41 d3 c0                    	roll	%cl, %r8d
180345cda: 89 d1                       	movl	%edx, %ecx
180345cdc: 41 d3 c8                    	rorl	%cl, %r8d
180345cdf: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180345ce6: 41 ff c0                    	incl	%r8d
180345ce9: 89 c1                       	movl	%eax, %ecx
180345ceb: 41 d3 c0                    	roll	%cl, %r8d
180345cee: 41 f7 d0                    	notl	%r8d
180345cf1: 49 63 c0                    	movslq	%r8d, %rax
180345cf4: 48 8d 8d 20 09 00 00        	leaq	0x920(%rbp), %rcx
180345cfb: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
180345d02: 48 89 f2                    	movq	%rsi, %rdx
180345d05: 48 8d 1d 64 7f 47 00        	leaq	0x477f64(%rip), %rbx    # 0x1807bdc70
180345d0c: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345d0f: 48 63 05 de 26 48 00        	movslq	0x4826de(%rip), %rax    # 0x1807c83f4
180345d16: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180345d1a: b9 0a 00 00 00              	movl	$0xa, %ecx
180345d1f: 29 c1                       	subl	%eax, %ecx
180345d21: d3 c2                       	roll	%cl, %edx
180345d23: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180345d29: d3 ca                       	rorl	%cl, %edx
180345d2b: d3 ca                       	rorl	%cl, %edx
180345d2d: d3 ca                       	rorl	%cl, %edx
180345d2f: 48 63 c2                    	movslq	%edx, %rax
180345d32: 31 d2                       	xorl	%edx, %edx
180345d34: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180345d38: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180345d3e: d3 ca                       	rorl	%cl, %edx
180345d40: d3 ca                       	rorl	%cl, %edx
180345d42: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180345d48: d3 ca                       	rorl	%cl, %edx
180345d4a: 31 ff                       	xorl	%edi, %edi
180345d4c: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180345d51: 29 c1                       	subl	%eax, %ecx
180345d53: d3 c2                       	roll	%cl, %edx
180345d55: d3 c2                       	roll	%cl, %edx
180345d57: 48 63 c2                    	movslq	%edx, %rax
180345d5a: 48 89 f1                    	movq	%rsi, %rcx
180345d5d: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345d60: 48 63 05 89 28 48 00        	movslq	0x482889(%rip), %rax    # 0x1807c85f0
180345d67: 31 d2                       	xorl	%edx, %edx
180345d69: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
180345d6d: 8d 48 14                    	leal	0x14(%rax), %ecx
180345d70: d3 ca                       	rorl	%cl, %edx
180345d72: 0f ca                       	bswapl	%edx
180345d74: 89 d0                       	movl	%edx, %eax
180345d76: f7 d8                       	negl	%eax
180345d78: 48 98                       	cltq
180345d7a: b9 eb da 5f 37              	movl	$0x375fdaeb, %ecx       # imm = 0x375FDAEB
180345d7f: 41 8b 04 86                 	movl	(%r14,%rax,4), %eax
180345d83: 31 c8                       	xorl	%ecx, %eax
180345d85: 29 d1                       	subl	%edx, %ecx
180345d87: d3 c8                       	rorl	%cl, %eax
180345d89: d3 c8                       	rorl	%cl, %eax
180345d8b: 35 eb da 5f 37              	xorl	$0x375fdaeb, %eax       # imm = 0x375FDAEB
180345d90: d3 c8                       	rorl	%cl, %eax
180345d92: d3 c8                       	rorl	%cl, %eax
180345d94: 48 98                       	cltq
180345d96: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
180345d9d: 48 89 f1                    	movq	%rsi, %rcx
180345da0: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345da3: 48 63 15 32 26 48 00        	movslq	0x482632(%rip), %rdx    # 0x1807c83dc
180345daa: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180345dae: f7 d0                       	notl	%eax
180345db0: b9 0b 68 da 97              	movl	$0x97da680b, %ecx       # imm = 0x97DA680B
180345db5: 29 d1                       	subl	%edx, %ecx
180345db7: d3 c0                       	roll	%cl, %eax
180345db9: d3 c0                       	roll	%cl, %eax
180345dbb: b9 05 00 00 00              	movl	$0x5, %ecx
180345dc0: 29 c1                       	subl	%eax, %ecx
180345dc2: f7 d0                       	notl	%eax
180345dc4: 48 98                       	cltq
180345dc6: 41 2b 3c 86                 	subl	(%r14,%rax,4), %edi
180345dca: 0f cf                       	bswapl	%edi
180345dcc: ff cf                       	decl	%edi
180345dce: 81 f7 55 9f 21 e6           	xorl	$0xe6219f55, %edi       # imm = 0xE6219F55
180345dd4: 0f cf                       	bswapl	%edi
180345dd6: d3 cf                       	rorl	%cl, %edi
180345dd8: 0f cf                       	bswapl	%edi
180345dda: 48 63 c7                    	movslq	%edi, %rax
180345ddd: 48 89 f1                    	movq	%rsi, %rcx
180345de0: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345de3: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180345dea: 48 89 c2                    	movq	%rax, %rdx
180345ded: e8 8e fd fc ff              	callq	0x180315b80 <.text+0x305b80>
180345df2: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
180345df9: 48 89 c1                    	movq	%rax, %rcx
180345dfc: e8 df 40 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
180345e01: 48 63 15 2c 24 48 00        	movslq	0x48242c(%rip), %rdx    # 0x1807c8234
180345e08: 4c 8d 35 71 34 31 00        	leaq	0x313471(%rip), %r14    # 0x180659280
180345e0f: 41 8b 04 96                 	movl	(%r14,%rdx,4), %eax
180345e13: b9 0b 00 00 00              	movl	$0xb, %ecx
180345e18: 29 d1                       	subl	%edx, %ecx
180345e1a: d3 c0                       	roll	%cl, %eax
180345e1c: f7 d0                       	notl	%eax
180345e1e: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180345e21: d3 c8                       	rorl	%cl, %eax
180345e23: 89 c1                       	movl	%eax, %ecx
180345e25: f7 d1                       	notl	%ecx
180345e27: 48 63 c9                    	movslq	%ecx, %rcx
180345e2a: 48 8d 1d 9f dc 47 00        	leaq	0x47dc9f(%rip), %rbx    # 0x1807c3ad0
180345e31: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
180345e35: 41 0f c8                    	bswapl	%r8d
180345e38: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180345e3d: 29 c2                       	subl	%eax, %edx
180345e3f: 89 d1                       	movl	%edx, %ecx
180345e41: 41 d3 c8                    	rorl	%cl, %r8d
180345e44: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180345e49: 89 c1                       	movl	%eax, %ecx
180345e4b: 41 d3 c0                    	roll	%cl, %r8d
180345e4e: 89 d1                       	movl	%edx, %ecx
180345e50: 41 d3 c8                    	rorl	%cl, %r8d
180345e53: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180345e5a: 41 ff c0                    	incl	%r8d
180345e5d: 89 c1                       	movl	%eax, %ecx
180345e5f: 41 d3 c0                    	roll	%cl, %r8d
180345e62: 41 f7 d0                    	notl	%r8d
180345e65: 49 63 c0                    	movslq	%r8d, %rax
180345e68: 48 8d 8d 40 09 00 00        	leaq	0x940(%rbp), %rcx
180345e6f: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
180345e76: 48 89 f2                    	movq	%rsi, %rdx
180345e79: 48 8d 3d f0 7d 47 00        	leaq	0x477df0(%rip), %rdi    # 0x1807bdc70
180345e80: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345e83: 48 63 05 02 26 48 00        	movslq	0x482602(%rip), %rax    # 0x1807c848c
180345e8a: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180345e8e: b9 0a 00 00 00              	movl	$0xa, %ecx
180345e93: 29 c1                       	subl	%eax, %ecx
180345e95: d3 c2                       	roll	%cl, %edx
180345e97: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180345e9d: d3 ca                       	rorl	%cl, %edx
180345e9f: d3 ca                       	rorl	%cl, %edx
180345ea1: d3 ca                       	rorl	%cl, %edx
180345ea3: 48 63 c2                    	movslq	%edx, %rax
180345ea6: 31 d2                       	xorl	%edx, %edx
180345ea8: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
180345eab: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180345eb1: d3 ca                       	rorl	%cl, %edx
180345eb3: d3 ca                       	rorl	%cl, %edx
180345eb5: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180345ebb: d3 ca                       	rorl	%cl, %edx
180345ebd: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180345ec2: 29 c1                       	subl	%eax, %ecx
180345ec4: d3 c2                       	roll	%cl, %edx
180345ec6: d3 c2                       	roll	%cl, %edx
180345ec8: 48 63 c2                    	movslq	%edx, %rax
180345ecb: 48 89 f1                    	movq	%rsi, %rcx
180345ece: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345ed1: 48 63 0d 40 27 48 00        	movslq	0x482740(%rip), %rcx    # 0x1807c8618
180345ed8: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
180345edc: 0f c8                       	bswapl	%eax
180345ede: d3 c8                       	rorl	%cl, %eax
180345ee0: 48 98                       	cltq
180345ee2: ba 1d 0b 3b e7              	movl	$0xe73b0b1d, %edx       # imm = 0xE73B0B1D
180345ee7: 33 14 83                    	xorl	(%rbx,%rax,4), %edx
180345eea: ff c2                       	incl	%edx
180345eec: 81 f2 1d 0b 3b e7           	xorl	$0xe73b0b1d, %edx       # imm = 0xE73B0B1D
180345ef2: 8d 48 02                    	leal	0x2(%rax), %ecx
180345ef5: d3 ca                       	rorl	%cl, %edx
180345ef7: 0f ca                       	bswapl	%edx
180345ef9: f7 da                       	negl	%edx
180345efb: b9 02 00 00 00              	movl	$0x2, %ecx
180345f00: 29 c1                       	subl	%eax, %ecx
180345f02: d3 c2                       	roll	%cl, %edx
180345f04: 48 63 c2                    	movslq	%edx, %rax
180345f07: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
180345f0e: 48 89 f1                    	movq	%rsi, %rcx
180345f11: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345f14: 48 63 05 b9 24 48 00        	movslq	0x4824b9(%rip), %rax    # 0x1807c83d4
180345f1b: 49 63 04 86                 	movslq	(%r14,%rax,4), %rax
180345f1f: 41 b8 ff 88 13 a8           	movl	$0xa81388ff, %r8d       # imm = 0xA81388FF
180345f25: 44 33 04 83                 	xorl	(%rbx,%rax,4), %r8d
180345f29: 41 ff c0                    	incl	%r8d
180345f2c: 89 c1                       	movl	%eax, %ecx
180345f2e: 41 d3 c8                    	rorl	%cl, %r8d
180345f31: ba 00 77 ec 57              	movl	$0x57ec7700, %edx       # imm = 0x57EC7700
180345f36: 29 c2                       	subl	%eax, %edx
180345f38: 89 d1                       	movl	%edx, %ecx
180345f3a: 41 d3 c0                    	roll	%cl, %r8d
180345f3d: 89 c1                       	movl	%eax, %ecx
180345f3f: 41 d3 c8                    	rorl	%cl, %r8d
180345f42: 41 81 f0 ff 88 13 a8        	xorl	$0xa81388ff, %r8d       # imm = 0xA81388FF
180345f49: 89 d1                       	movl	%edx, %ecx
180345f4b: 41 d3 c0                    	roll	%cl, %r8d
180345f4e: 49 63 c0                    	movslq	%r8d, %rax
180345f51: 48 89 f1                    	movq	%rsi, %rcx
180345f54: ff 14 c7                    	callq	*(%rdi,%rax,8)
180345f57: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180345f5e: 48 89 c2                    	movq	%rax, %rdx
180345f61: e8 1a fc fc ff              	callq	0x180315b80 <.text+0x305b80>
180345f66: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
180345f6d: 48 89 c1                    	movq	%rax, %rcx
180345f70: e8 6b 3f fe ff              	callq	0x180329ee0 <.text+0x319ee0>
180345f75: 48 63 15 bc 22 48 00        	movslq	0x4822bc(%rip), %rdx    # 0x1807c8238
180345f7c: 4c 8d 3d fd 32 31 00        	leaq	0x3132fd(%rip), %r15    # 0x180659280
180345f83: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180345f87: b9 0b 00 00 00              	movl	$0xb, %ecx
180345f8c: 29 d1                       	subl	%edx, %ecx
180345f8e: d3 c0                       	roll	%cl, %eax
180345f90: f7 d0                       	notl	%eax
180345f92: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180345f95: d3 c8                       	rorl	%cl, %eax
180345f97: 89 c1                       	movl	%eax, %ecx
180345f99: f7 d1                       	notl	%ecx
180345f9b: 48 63 c9                    	movslq	%ecx, %rcx
180345f9e: 4c 8d 35 2b db 47 00        	leaq	0x47db2b(%rip), %r14    # 0x1807c3ad0
180345fa5: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180345fa9: 41 0f c8                    	bswapl	%r8d
180345fac: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180345fb1: 29 c2                       	subl	%eax, %edx
180345fb3: 89 d1                       	movl	%edx, %ecx
180345fb5: 41 d3 c8                    	rorl	%cl, %r8d
180345fb8: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
180345fbd: 89 c1                       	movl	%eax, %ecx
180345fbf: 41 d3 c0                    	roll	%cl, %r8d
180345fc2: 89 d1                       	movl	%edx, %ecx
180345fc4: 41 d3 c8                    	rorl	%cl, %r8d
180345fc7: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180345fce: 41 ff c0                    	incl	%r8d
180345fd1: 89 c1                       	movl	%eax, %ecx
180345fd3: 41 d3 c0                    	roll	%cl, %r8d
180345fd6: be 0b 00 00 00              	movl	$0xb, %esi
180345fdb: 41 f7 d0                    	notl	%r8d
180345fde: 49 63 c0                    	movslq	%r8d, %rax
180345fe1: 48 8d 8d 20 07 00 00        	leaq	0x720(%rbp), %rcx
180345fe8: 48 8d bd 50 0c 00 00        	leaq	0xc50(%rbp), %rdi
180345fef: 48 89 fa                    	movq	%rdi, %rdx
180345ff2: 48 8d 1d 77 7c 47 00        	leaq	0x477c77(%rip), %rbx    # 0x1807bdc70
180345ff9: ff 14 c3                    	callq	*(%rbx,%rax,8)
180345ffc: 48 63 05 6d 24 48 00        	movslq	0x48246d(%rip), %rax    # 0x1807c8470
180346003: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346007: b9 0a 00 00 00              	movl	$0xa, %ecx
18034600c: 29 c1                       	subl	%eax, %ecx
18034600e: d3 c2                       	roll	%cl, %edx
180346010: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180346016: d3 ca                       	rorl	%cl, %edx
180346018: d3 ca                       	rorl	%cl, %edx
18034601a: d3 ca                       	rorl	%cl, %edx
18034601c: 48 63 c2                    	movslq	%edx, %rax
18034601f: 31 d2                       	xorl	%edx, %edx
180346021: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180346025: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
18034602b: d3 ca                       	rorl	%cl, %edx
18034602d: d3 ca                       	rorl	%cl, %edx
18034602f: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180346035: d3 ca                       	rorl	%cl, %edx
180346037: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
18034603c: 29 c1                       	subl	%eax, %ecx
18034603e: d3 c2                       	roll	%cl, %edx
180346040: d3 c2                       	roll	%cl, %edx
180346042: 48 63 c2                    	movslq	%edx, %rax
180346045: 48 89 f9                    	movq	%rdi, %rcx
180346048: ff 14 c3                    	callq	*(%rbx,%rax,8)
18034604b: 48 63 05 ca 25 48 00        	movslq	0x4825ca(%rip), %rax    # 0x1807c861c
180346052: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346056: b9 4e 72 84 53              	movl	$0x5384724e, %ecx       # imm = 0x5384724E
18034605b: 29 c1                       	subl	%eax, %ecx
18034605d: d3 c2                       	roll	%cl, %edx
18034605f: d3 c2                       	roll	%cl, %edx
180346061: 0f ca                       	bswapl	%edx
180346063: d3 c2                       	roll	%cl, %edx
180346065: 48 63 c2                    	movslq	%edx, %rax
180346068: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
18034606c: b9 02 a0 b5 a7              	movl	$0xa7b5a002, %ecx       # imm = 0xA7B5A002
180346071: 29 c1                       	subl	%eax, %ecx
180346073: d3 c2                       	roll	%cl, %edx
180346075: 0f ca                       	bswapl	%edx
180346077: d3 c2                       	roll	%cl, %edx
180346079: 0f ca                       	bswapl	%edx
18034607b: 05 02 a0 b5 a7              	addl	$0xa7b5a002, %eax       # imm = 0xA7B5A002
180346080: 89 c1                       	movl	%eax, %ecx
180346082: d3 ca                       	rorl	%cl, %edx
180346084: d3 ca                       	rorl	%cl, %edx
180346086: 48 63 c2                    	movslq	%edx, %rax
180346089: 48 8d bd 70 0b 00 00        	leaq	0xb70(%rbp), %rdi
180346090: 48 89 f9                    	movq	%rdi, %rcx
180346093: ff 14 c3                    	callq	*(%rbx,%rax,8)
180346096: 48 63 05 87 23 48 00        	movslq	0x482387(%rip), %rax    # 0x1807c8424
18034609d: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803460a1: b9 19 00 00 00              	movl	$0x19, %ecx
1803460a6: 29 c1                       	subl	%eax, %ecx
1803460a8: d3 c2                       	roll	%cl, %edx
1803460aa: 81 f2 66 e2 e7 ac           	xorl	$0xace7e266, %edx       # imm = 0xACE7E266
1803460b0: 8d 48 19                    	leal	0x19(%rax), %ecx
1803460b3: d3 ca                       	rorl	%cl, %edx
1803460b5: 48 63 c2                    	movslq	%edx, %rax
1803460b8: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803460bc: ff c2                       	incl	%edx
1803460be: 29 c6                       	subl	%eax, %esi
1803460c0: 89 f1                       	movl	%esi, %ecx
1803460c2: d3 c2                       	roll	%cl, %edx
1803460c4: f7 da                       	negl	%edx
1803460c6: 81 f2 ab 97 2f 84           	xorl	$0x842f97ab, %edx       # imm = 0x842F97AB
1803460cc: 0f ca                       	bswapl	%edx
1803460ce: 48 63 c2                    	movslq	%edx, %rax
1803460d1: 48 89 f9                    	movq	%rdi, %rcx
1803460d4: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803460d7: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
1803460de: 48 89 c2                    	movq	%rax, %rdx
1803460e1: e8 9a fa fc ff              	callq	0x180315b80 <.text+0x305b80>
1803460e6: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
1803460ed: 48 89 c1                    	movq	%rax, %rcx
1803460f0: e8 eb 3d fe ff              	callq	0x180329ee0 <.text+0x319ee0>
1803460f5: 48 63 15 4c 21 48 00        	movslq	0x48214c(%rip), %rdx    # 0x1807c8248
1803460fc: 4c 8d 3d 7d 31 31 00        	leaq	0x31317d(%rip), %r15    # 0x180659280
180346103: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180346107: b9 0b 00 00 00              	movl	$0xb, %ecx
18034610c: 29 d1                       	subl	%edx, %ecx
18034610e: d3 c0                       	roll	%cl, %eax
180346110: f7 d0                       	notl	%eax
180346112: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180346115: d3 c8                       	rorl	%cl, %eax
180346117: 89 c1                       	movl	%eax, %ecx
180346119: f7 d1                       	notl	%ecx
18034611b: 48 63 c9                    	movslq	%ecx, %rcx
18034611e: 4c 8d 35 ab d9 47 00        	leaq	0x47d9ab(%rip), %r14    # 0x1807c3ad0
180346125: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180346129: 41 0f c8                    	bswapl	%r8d
18034612c: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180346131: 29 c2                       	subl	%eax, %edx
180346133: 89 d1                       	movl	%edx, %ecx
180346135: 41 d3 c8                    	rorl	%cl, %r8d
180346138: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
18034613d: 89 c1                       	movl	%eax, %ecx
18034613f: 41 d3 c0                    	roll	%cl, %r8d
180346142: 89 d1                       	movl	%edx, %ecx
180346144: 41 d3 c8                    	rorl	%cl, %r8d
180346147: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
18034614e: 41 ff c0                    	incl	%r8d
180346151: 89 c1                       	movl	%eax, %ecx
180346153: 41 d3 c0                    	roll	%cl, %r8d
180346156: 41 f7 d0                    	notl	%r8d
180346159: 49 63 c0                    	movslq	%r8d, %rax
18034615c: 48 8d 8d 40 07 00 00        	leaq	0x740(%rbp), %rcx
180346163: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
18034616a: 48 89 f2                    	movq	%rsi, %rdx
18034616d: 48 8d 1d fc 7a 47 00        	leaq	0x477afc(%rip), %rbx    # 0x1807bdc70
180346174: ff 14 c3                    	callq	*(%rbx,%rax,8)
180346177: 48 63 05 ca 22 48 00        	movslq	0x4822ca(%rip), %rax    # 0x1807c8448
18034617e: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346182: b9 0a 00 00 00              	movl	$0xa, %ecx
180346187: 29 c1                       	subl	%eax, %ecx
180346189: d3 c2                       	roll	%cl, %edx
18034618b: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180346191: d3 ca                       	rorl	%cl, %edx
180346193: d3 ca                       	rorl	%cl, %edx
180346195: d3 ca                       	rorl	%cl, %edx
180346197: 48 63 d2                    	movslq	%edx, %rdx
18034619a: 31 c0                       	xorl	%eax, %eax
18034619c: 41 2b 04 96                 	subl	(%r14,%rdx,4), %eax
1803461a0: 8d 8a d0 45 48 92           	leal	-0x6db7ba30(%rdx), %ecx
1803461a6: d3 c8                       	rorl	%cl, %eax
1803461a8: d3 c8                       	rorl	%cl, %eax
1803461aa: 35 2f ba b7 6d              	xorl	$0x6db7ba2f, %eax       # imm = 0x6DB7BA2F
1803461af: d3 c8                       	rorl	%cl, %eax
1803461b1: bf 0a 00 00 00              	movl	$0xa, %edi
1803461b6: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803461bb: 29 d1                       	subl	%edx, %ecx
1803461bd: d3 c0                       	roll	%cl, %eax
1803461bf: d3 c0                       	roll	%cl, %eax
1803461c1: 48 98                       	cltq
1803461c3: 48 89 f1                    	movq	%rsi, %rcx
1803461c6: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803461c9: 48 63 05 24 24 48 00        	movslq	0x482424(%rip), %rax    # 0x1807c85f4
1803461d0: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803461d4: 29 c7                       	subl	%eax, %edi
1803461d6: 89 f9                       	movl	%edi, %ecx
1803461d8: d3 c2                       	roll	%cl, %edx
1803461da: 8d 48 0a                    	leal	0xa(%rax), %ecx
1803461dd: d3 ca                       	rorl	%cl, %edx
1803461df: 48 63 c2                    	movslq	%edx, %rax
1803461e2: 49 63 04 86                 	movslq	(%r14,%rax,4), %rax
1803461e6: 48 35 08 3e 3e 08           	xorq	$0x83e3e08, %rax        # imm = 0x83E3E08
1803461ec: 48 8d b5 70 0b 00 00        	leaq	0xb70(%rbp), %rsi
1803461f3: 48 89 f1                    	movq	%rsi, %rcx
1803461f6: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803461f9: 48 63 05 60 22 48 00        	movslq	0x482260(%rip), %rax    # 0x1807c8460
180346200: 49 63 04 87                 	movslq	(%r15,%rax,4), %rax
180346204: 41 b8 ff 88 13 a8           	movl	$0xa81388ff, %r8d       # imm = 0xA81388FF
18034620a: 45 33 04 86                 	xorl	(%r14,%rax,4), %r8d
18034620e: 41 ff c0                    	incl	%r8d
180346211: 89 c1                       	movl	%eax, %ecx
180346213: 41 d3 c8                    	rorl	%cl, %r8d
180346216: ba 00 77 ec 57              	movl	$0x57ec7700, %edx       # imm = 0x57EC7700
18034621b: 29 c2                       	subl	%eax, %edx
18034621d: 89 d1                       	movl	%edx, %ecx
18034621f: 41 d3 c0                    	roll	%cl, %r8d
180346222: 89 c1                       	movl	%eax, %ecx
180346224: 41 d3 c8                    	rorl	%cl, %r8d
180346227: 41 81 f0 ff 88 13 a8        	xorl	$0xa81388ff, %r8d       # imm = 0xA81388FF
18034622e: 89 d1                       	movl	%edx, %ecx
180346230: 41 d3 c0                    	roll	%cl, %r8d
180346233: 49 63 c0                    	movslq	%r8d, %rax
180346236: 48 89 f1                    	movq	%rsi, %rcx
180346239: ff 14 c3                    	callq	*(%rbx,%rax,8)
18034623c: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180346243: 48 89 c2                    	movq	%rax, %rdx
180346246: e8 35 f9 fc ff              	callq	0x180315b80 <.text+0x305b80>
18034624b: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
180346252: 48 89 c1                    	movq	%rax, %rcx
180346255: e8 86 3c fe ff              	callq	0x180329ee0 <.text+0x319ee0>
18034625a: 48 63 15 db 1f 48 00        	movslq	0x481fdb(%rip), %rdx    # 0x1807c823c
180346261: 4c 8d 25 18 30 31 00        	leaq	0x313018(%rip), %r12    # 0x180659280
180346268: 41 8b 04 94                 	movl	(%r12,%rdx,4), %eax
18034626c: b9 0b 00 00 00              	movl	$0xb, %ecx
180346271: 29 d1                       	subl	%edx, %ecx
180346273: d3 c0                       	roll	%cl, %eax
180346275: f7 d0                       	notl	%eax
180346277: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
18034627a: d3 c8                       	rorl	%cl, %eax
18034627c: 89 c1                       	movl	%eax, %ecx
18034627e: f7 d1                       	notl	%ecx
180346280: 48 63 c9                    	movslq	%ecx, %rcx
180346283: 4c 8d 3d 46 d8 47 00        	leaq	0x47d846(%rip), %r15    # 0x1807c3ad0
18034628a: 45 8b 04 8f                 	movl	(%r15,%rcx,4), %r8d
18034628e: 41 0f c8                    	bswapl	%r8d
180346291: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180346296: 29 c2                       	subl	%eax, %edx
180346298: 89 d1                       	movl	%edx, %ecx
18034629a: 41 d3 c8                    	rorl	%cl, %r8d
18034629d: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
1803462a2: 89 c1                       	movl	%eax, %ecx
1803462a4: 41 d3 c0                    	roll	%cl, %r8d
1803462a7: 89 d1                       	movl	%edx, %ecx
1803462a9: 41 d3 c8                    	rorl	%cl, %r8d
1803462ac: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
1803462b3: 41 ff c0                    	incl	%r8d
1803462b6: 89 c1                       	movl	%eax, %ecx
1803462b8: 41 d3 c0                    	roll	%cl, %r8d
1803462bb: be 0b 00 00 00              	movl	$0xb, %esi
1803462c0: 41 f7 d0                    	notl	%r8d
1803462c3: 49 63 c0                    	movslq	%r8d, %rax
1803462c6: 48 8d 8d 60 07 00 00        	leaq	0x760(%rbp), %rcx
1803462cd: 48 8d bd 50 0c 00 00        	leaq	0xc50(%rbp), %rdi
1803462d4: 48 89 fa                    	movq	%rdi, %rdx
1803462d7: 4c 8d 35 92 79 47 00        	leaq	0x477992(%rip), %r14    # 0x1807bdc70
1803462de: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
1803462e2: 48 63 05 23 21 48 00        	movslq	0x482123(%rip), %rax    # 0x1807c840c
1803462e9: 41 8b 14 84                 	movl	(%r12,%rax,4), %edx
1803462ed: b9 0a 00 00 00              	movl	$0xa, %ecx
1803462f2: 29 c1                       	subl	%eax, %ecx
1803462f4: d3 c2                       	roll	%cl, %edx
1803462f6: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803462fc: d3 ca                       	rorl	%cl, %edx
1803462fe: d3 ca                       	rorl	%cl, %edx
180346300: d3 ca                       	rorl	%cl, %edx
180346302: 48 63 c2                    	movslq	%edx, %rax
180346305: 31 d2                       	xorl	%edx, %edx
180346307: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
18034630b: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180346311: d3 ca                       	rorl	%cl, %edx
180346313: d3 ca                       	rorl	%cl, %edx
180346315: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
18034631b: d3 ca                       	rorl	%cl, %edx
18034631d: 31 db                       	xorl	%ebx, %ebx
18034631f: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180346324: 29 c1                       	subl	%eax, %ecx
180346326: d3 c2                       	roll	%cl, %edx
180346328: d3 c2                       	roll	%cl, %edx
18034632a: 48 63 c2                    	movslq	%edx, %rax
18034632d: 48 89 f9                    	movq	%rdi, %rcx
180346330: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180346334: 48 63 05 c5 22 48 00        	movslq	0x4822c5(%rip), %rax    # 0x1807c8600
18034633b: 41 2b 1c 84                 	subl	(%r12,%rax,4), %ebx
18034633f: 81 f3 47 59 11 f7           	xorl	$0xf7115947, %ebx       # imm = 0xF7115947
180346345: ff c3                       	incl	%ebx
180346347: b9 18 00 00 00              	movl	$0x18, %ecx
18034634c: 29 c1                       	subl	%eax, %ecx
18034634e: d3 c3                       	roll	%cl, %ebx
180346350: 48 63 c3                    	movslq	%ebx, %rax
180346353: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346357: 8d 88 09 d5 aa 1f           	leal	0x1faad509(%rax), %ecx
18034635d: d3 ca                       	rorl	%cl, %edx
18034635f: d3 ca                       	rorl	%cl, %edx
180346361: b9 09 00 00 00              	movl	$0x9, %ecx
180346366: 29 c1                       	subl	%eax, %ecx
180346368: d3 c2                       	roll	%cl, %edx
18034636a: f7 da                       	negl	%edx
18034636c: 81 f2 1f aa d5 09           	xorl	$0x9d5aa1f, %edx        # imm = 0x9D5AA1F
180346372: 0f ca                       	bswapl	%edx
180346374: 48 63 c2                    	movslq	%edx, %rax
180346377: 48 8d bd 70 0b 00 00        	leaq	0xb70(%rbp), %rdi
18034637e: 48 89 f9                    	movq	%rdi, %rcx
180346381: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
180346385: 48 63 05 70 20 48 00        	movslq	0x482070(%rip), %rax    # 0x1807c83fc
18034638c: 41 8b 14 84                 	movl	(%r12,%rax,4), %edx
180346390: b9 19 00 00 00              	movl	$0x19, %ecx
180346395: 29 c1                       	subl	%eax, %ecx
180346397: d3 c2                       	roll	%cl, %edx
180346399: 81 f2 66 e2 e7 ac           	xorl	$0xace7e266, %edx       # imm = 0xACE7E266
18034639f: 8d 48 19                    	leal	0x19(%rax), %ecx
1803463a2: d3 ca                       	rorl	%cl, %edx
1803463a4: 48 63 c2                    	movslq	%edx, %rax
1803463a7: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803463ab: ff c2                       	incl	%edx
1803463ad: 29 c6                       	subl	%eax, %esi
1803463af: 89 f1                       	movl	%esi, %ecx
1803463b1: d3 c2                       	roll	%cl, %edx
1803463b3: f7 da                       	negl	%edx
1803463b5: 81 f2 ab 97 2f 84           	xorl	$0x842f97ab, %edx       # imm = 0x842F97AB
1803463bb: 0f ca                       	bswapl	%edx
1803463bd: 48 63 c2                    	movslq	%edx, %rax
1803463c0: 48 89 f9                    	movq	%rdi, %rcx
1803463c3: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
1803463c7: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
1803463ce: 48 89 c2                    	movq	%rax, %rdx
1803463d1: e8 aa f7 fc ff              	callq	0x180315b80 <.text+0x305b80>
1803463d6: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
1803463dd: 48 89 c1                    	movq	%rax, %rcx
1803463e0: e8 fb 3a fe ff              	callq	0x180329ee0 <.text+0x319ee0>
1803463e5: 48 63 15 58 1e 48 00        	movslq	0x481e58(%rip), %rdx    # 0x1807c8244
1803463ec: 4c 8d 3d 8d 2e 31 00        	leaq	0x312e8d(%rip), %r15    # 0x180659280
1803463f3: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
1803463f7: b9 0b 00 00 00              	movl	$0xb, %ecx
1803463fc: 29 d1                       	subl	%edx, %ecx
1803463fe: d3 c0                       	roll	%cl, %eax
180346400: f7 d0                       	notl	%eax
180346402: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180346405: d3 c8                       	rorl	%cl, %eax
180346407: 89 c1                       	movl	%eax, %ecx
180346409: f7 d1                       	notl	%ecx
18034640b: 48 63 c9                    	movslq	%ecx, %rcx
18034640e: 4c 8d 35 bb d6 47 00        	leaq	0x47d6bb(%rip), %r14    # 0x1807c3ad0
180346415: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180346419: 41 0f c8                    	bswapl	%r8d
18034641c: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180346421: 29 c2                       	subl	%eax, %edx
180346423: 89 d1                       	movl	%edx, %ecx
180346425: 41 d3 c8                    	rorl	%cl, %r8d
180346428: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
18034642d: 89 c1                       	movl	%eax, %ecx
18034642f: 41 d3 c0                    	roll	%cl, %r8d
180346432: 89 d1                       	movl	%edx, %ecx
180346434: 41 d3 c8                    	rorl	%cl, %r8d
180346437: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
18034643e: 41 ff c0                    	incl	%r8d
180346441: 89 c1                       	movl	%eax, %ecx
180346443: 41 d3 c0                    	roll	%cl, %r8d
180346446: 41 f7 d0                    	notl	%r8d
180346449: 49 63 c0                    	movslq	%r8d, %rax
18034644c: 48 8d 8d e0 05 00 00        	leaq	0x5e0(%rbp), %rcx
180346453: 48 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %rsi
18034645a: 48 89 f2                    	movq	%rsi, %rdx
18034645d: 48 8d 1d 0c 78 47 00        	leaq	0x47780c(%rip), %rbx    # 0x1807bdc70
180346464: ff 14 c3                    	callq	*(%rbx,%rax,8)
180346467: 48 63 05 5e 1f 48 00        	movslq	0x481f5e(%rip), %rax    # 0x1807c83cc
18034646e: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346472: b9 0a 00 00 00              	movl	$0xa, %ecx
180346477: 29 c1                       	subl	%eax, %ecx
180346479: d3 c2                       	roll	%cl, %edx
18034647b: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180346481: d3 ca                       	rorl	%cl, %edx
180346483: d3 ca                       	rorl	%cl, %edx
180346485: d3 ca                       	rorl	%cl, %edx
180346487: 48 63 c2                    	movslq	%edx, %rax
18034648a: 31 d2                       	xorl	%edx, %edx
18034648c: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180346490: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180346496: d3 ca                       	rorl	%cl, %edx
180346498: d3 ca                       	rorl	%cl, %edx
18034649a: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803464a0: d3 ca                       	rorl	%cl, %edx
1803464a2: 31 ff                       	xorl	%edi, %edi
1803464a4: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803464a9: 29 c1                       	subl	%eax, %ecx
1803464ab: d3 c2                       	roll	%cl, %edx
1803464ad: d3 c2                       	roll	%cl, %edx
1803464af: 48 63 c2                    	movslq	%edx, %rax
1803464b2: 48 89 f1                    	movq	%rsi, %rcx
1803464b5: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803464b8: 48 63 0d ad a7 54 00        	movslq	0x54a7ad(%rip), %rcx    # 0x180890c6c
1803464bf: b8 cb 7d 3f fb              	movl	$0xfb3f7dcb, %eax       # imm = 0xFB3F7DCB
1803464c4: 41 33 04 8f                 	xorl	(%r15,%rcx,4), %eax
1803464c8: 83 c1 14                    	addl	$0x14, %ecx
1803464cb: d3 c8                       	rorl	%cl, %eax
1803464cd: 89 c1                       	movl	%eax, %ecx
1803464cf: f7 d1                       	notl	%ecx
1803464d1: 48 63 c9                    	movslq	%ecx, %rcx
1803464d4: ba 05 ac 4d 00              	movl	$0x4dac05, %edx         # imm = 0x4DAC05
1803464d9: 41 33 14 8e                 	xorl	(%r14,%rcx,4), %edx
1803464dd: 0f ca                       	bswapl	%edx
1803464df: f7 da                       	negl	%edx
1803464e1: 83 c0 1b                    	addl	$0x1b, %eax
1803464e4: 89 c1                       	movl	%eax, %ecx
1803464e6: d3 c2                       	roll	%cl, %edx
1803464e8: f7 d2                       	notl	%edx
1803464ea: 48 63 c2                    	movslq	%edx, %rax
1803464ed: 48 89 f1                    	movq	%rsi, %rcx
1803464f0: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803464f3: 48 63 05 26 1f 48 00        	movslq	0x481f26(%rip), %rax    # 0x1807c8420
1803464fa: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803464fe: 8d 48 0d                    	leal	0xd(%rax), %ecx
180346501: d3 ca                       	rorl	%cl, %edx
180346503: b9 0d 00 00 00              	movl	$0xd, %ecx
180346508: 29 c1                       	subl	%eax, %ecx
18034650a: d3 c2                       	roll	%cl, %edx
18034650c: 48 63 ca                    	movslq	%edx, %rcx
18034650f: 41 2b 3c 8e                 	subl	(%r14,%rcx,4), %edi
180346513: 81 c1 f6 14 43 53           	addl	$0x534314f6, %ecx       # imm = 0x534314F6
180346519: d3 cf                       	rorl	%cl, %edi
18034651b: d3 cf                       	rorl	%cl, %edi
18034651d: 81 f7 f6 14 43 53           	xorl	$0x534314f6, %edi       # imm = 0x534314F6
180346523: d3 cf                       	rorl	%cl, %edi
180346525: d3 cf                       	rorl	%cl, %edi
180346527: 48 63 c7                    	movslq	%edi, %rax
18034652a: 48 89 f1                    	movq	%rsi, %rcx
18034652d: ff 14 c3                    	callq	*(%rbx,%rax,8)
180346530: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180346537: 48 89 c2                    	movq	%rax, %rdx
18034653a: e8 41 f6 fc ff              	callq	0x180315b80 <.text+0x305b80>
18034653f: 48 89 c1                    	movq	%rax, %rcx
180346542: e8 f9 9a 00 00              	callq	0x180350040 <.text+0x340040>
180346547: 48 89 c6                    	movq	%rax, %rsi
18034654a: 48 63 05 bf 20 48 00        	movslq	0x4820bf(%rip), %rax    # 0x1807c8610
180346551: 31 d2                       	xorl	%edx, %edx
180346553: 4c 8d 3d 26 2d 31 00        	leaq	0x312d26(%rip), %r15    # 0x180659280
18034655a: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
18034655e: b9 e2 15 a1 62              	movl	$0x62a115e2, %ecx       # imm = 0x62A115E2
180346563: 29 c1                       	subl	%eax, %ecx
180346565: d3 c2                       	roll	%cl, %edx
180346567: d3 c2                       	roll	%cl, %edx
180346569: 8d 48 02                    	leal	0x2(%rax), %ecx
18034656c: d3 ca                       	rorl	%cl, %edx
18034656e: 48 63 d2                    	movslq	%edx, %rdx
180346571: 4c 8d 35 58 d5 47 00        	leaq	0x47d558(%rip), %r14    # 0x1807c3ad0
180346578: 45 8b 04 96                 	movl	(%r14,%rdx,4), %r8d
18034657c: 8d 82 ab c8 9e f7           	leal	-0x8613755(%rdx), %eax
180346582: 89 c1                       	movl	%eax, %ecx
180346584: 41 d3 c8                    	rorl	%cl, %r8d
180346587: 41 81 f0 ab c8 9e f7        	xorl	$0xf79ec8ab, %r8d       # imm = 0xF79EC8AB
18034658e: 41 d3 c8                    	rorl	%cl, %r8d
180346591: 41 f7 d8                    	negl	%r8d
180346594: b9 0b 00 00 00              	movl	$0xb, %ecx
180346599: 29 d1                       	subl	%edx, %ecx
18034659b: 41 d3 c0                    	roll	%cl, %r8d
18034659e: 89 c1                       	movl	%eax, %ecx
1803465a0: 41 d3 c8                    	rorl	%cl, %r8d
1803465a3: 41 ff c0                    	incl	%r8d
1803465a6: 49 63 c0                    	movslq	%r8d, %rax
1803465a9: 48 8d bd 70 0b 00 00        	leaq	0xb70(%rbp), %rdi
1803465b0: 48 89 f9                    	movq	%rdi, %rcx
1803465b3: 48 8d 1d b6 76 47 00        	leaq	0x4776b6(%rip), %rbx    # 0x1807bdc70
1803465ba: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803465bd: 48 63 05 24 1e 48 00        	movslq	0x481e24(%rip), %rax    # 0x1807c83e8
1803465c4: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803465c8: 8d 48 19                    	leal	0x19(%rax), %ecx
1803465cb: d3 ca                       	rorl	%cl, %edx
1803465cd: b9 39 e4 67 44              	movl	$0x4467e439, %ecx       # imm = 0x4467E439
1803465d2: 29 c1                       	subl	%eax, %ecx
1803465d4: d3 c2                       	roll	%cl, %edx
1803465d6: f7 d2                       	notl	%edx
1803465d8: d3 c2                       	roll	%cl, %edx
1803465da: 48 63 ca                    	movslq	%edx, %rcx
1803465dd: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
1803465e1: 81 c1 72 60 bb d8           	addl	$0xd8bb6072, %ecx       # imm = 0xD8BB6072
1803465e7: d3 c8                       	rorl	%cl, %eax
1803465e9: ff c0                       	incl	%eax
1803465eb: 0f c8                       	bswapl	%eax
1803465ed: d3 c8                       	rorl	%cl, %eax
1803465ef: f7 d8                       	negl	%eax
1803465f1: 48 98                       	cltq
1803465f3: 48 89 f9                    	movq	%rdi, %rcx
1803465f6: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803465f9: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180346600: 48 89 c2                    	movq	%rax, %rdx
180346603: e8 78 f5 fc ff              	callq	0x180315b80 <.text+0x305b80>
180346608: 48 8d 95 50 0c 00 00        	leaq	0xc50(%rbp), %rdx
18034660f: 48 89 c1                    	movq	%rax, %rcx
180346612: e8 c9 38 fe ff              	callq	0x180329ee0 <.text+0x319ee0>
180346617: 48 63 15 32 1c 48 00        	movslq	0x481c32(%rip), %rdx    # 0x1807c8250
18034661e: 4c 8d 3d 5b 2c 31 00        	leaq	0x312c5b(%rip), %r15    # 0x180659280
180346625: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180346629: b9 0b 00 00 00              	movl	$0xb, %ecx
18034662e: 29 d1                       	subl	%edx, %ecx
180346630: d3 c0                       	roll	%cl, %eax
180346632: f7 d0                       	notl	%eax
180346634: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180346637: d3 c8                       	rorl	%cl, %eax
180346639: 89 c1                       	movl	%eax, %ecx
18034663b: f7 d1                       	notl	%ecx
18034663d: 48 63 c9                    	movslq	%ecx, %rcx
180346640: 48 8d 1d 89 d4 47 00        	leaq	0x47d489(%rip), %rbx    # 0x1807c3ad0
180346647: 44 8b 04 8b                 	movl	(%rbx,%rcx,4), %r8d
18034664b: 41 0f c8                    	bswapl	%r8d
18034664e: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
180346653: 29 c2                       	subl	%eax, %edx
180346655: 89 d1                       	movl	%edx, %ecx
180346657: 41 d3 c8                    	rorl	%cl, %r8d
18034665a: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
18034665f: 89 c1                       	movl	%eax, %ecx
180346661: 41 d3 c0                    	roll	%cl, %r8d
180346664: 89 d1                       	movl	%edx, %ecx
180346666: 41 d3 c8                    	rorl	%cl, %r8d
180346669: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
180346670: 41 ff c0                    	incl	%r8d
180346673: 89 c1                       	movl	%eax, %ecx
180346675: 41 d3 c0                    	roll	%cl, %r8d
180346678: 41 f7 d0                    	notl	%r8d
18034667b: 49 63 c0                    	movslq	%r8d, %rax
18034667e: 48 8d 8d 80 07 00 00        	leaq	0x780(%rbp), %rcx
180346685: 48 8d bd 50 0c 00 00        	leaq	0xc50(%rbp), %rdi
18034668c: 48 89 fa                    	movq	%rdi, %rdx
18034668f: 4c 8d 35 da 75 47 00        	leaq	0x4775da(%rip), %r14    # 0x1807bdc70
180346696: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
18034669a: 48 63 05 3f 1d 48 00        	movslq	0x481d3f(%rip), %rax    # 0x1807c83e0
1803466a1: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803466a5: b9 0a 00 00 00              	movl	$0xa, %ecx
1803466aa: 29 c1                       	subl	%eax, %ecx
1803466ac: d3 c2                       	roll	%cl, %edx
1803466ae: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803466b4: d3 ca                       	rorl	%cl, %edx
1803466b6: d3 ca                       	rorl	%cl, %edx
1803466b8: d3 ca                       	rorl	%cl, %edx
1803466ba: 48 63 c2                    	movslq	%edx, %rax
1803466bd: 31 d2                       	xorl	%edx, %edx
1803466bf: 2b 14 83                    	subl	(%rbx,%rax,4), %edx
1803466c2: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803466c8: d3 ca                       	rorl	%cl, %edx
1803466ca: d3 ca                       	rorl	%cl, %edx
1803466cc: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803466d2: d3 ca                       	rorl	%cl, %edx
1803466d4: 31 db                       	xorl	%ebx, %ebx
1803466d6: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803466db: 29 c1                       	subl	%eax, %ecx
1803466dd: d3 c2                       	roll	%cl, %edx
1803466df: d3 c2                       	roll	%cl, %edx
1803466e1: 48 63 c2                    	movslq	%edx, %rax
1803466e4: 48 89 f9                    	movq	%rdi, %rcx
1803466e7: 41 ff 14 c6                 	callq	*(%r14,%rax,8)
1803466eb: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
1803466f2: e8 39 55 fd ff              	callq	0x18031bc30 <.text+0x30bc30>
1803466f7: 48 63 05 ee 1c 48 00        	movslq	0x481cee(%rip), %rax    # 0x1807c83ec
1803466fe: 4c 8d 3d 7b 2b 31 00        	leaq	0x312b7b(%rip), %r15    # 0x180659280
180346705: 41 2b 1c 87                 	subl	(%r15,%rax,4), %ebx
180346709: 8d 48 13                    	leal	0x13(%rax), %ecx
18034670c: d3 cb                       	rorl	%cl, %ebx
18034670e: 48 63 cb                    	movslq	%ebx, %rcx
180346711: 4c 8d 35 b8 d3 47 00        	leaq	0x47d3b8(%rip), %r14    # 0x1807c3ad0
180346718: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
18034671c: 0f c8                       	bswapl	%eax
18034671e: 81 c1 d2 b3 92 bf           	addl	$0xbf92b3d2, %ecx       # imm = 0xBF92B3D2
180346724: d3 c8                       	rorl	%cl, %eax
180346726: 35 2d 4c 6d 40              	xorl	$0x406d4c2d, %eax       # imm = 0x406D4C2D
18034672b: d3 c8                       	rorl	%cl, %eax
18034672d: f7 d8                       	negl	%eax
18034672f: 48 98                       	cltq
180346731: 48 8d 8d 10 0a 00 00        	leaq	0xa10(%rbp), %rcx
180346738: 4c 8d 2d 31 75 47 00        	leaq	0x477531(%rip), %r13    # 0x1807bdc70
18034673f: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346744: 84 c0                       	testb	%al, %al
180346746: 0f 85 d4 05 00 00           	jne	0x180346d20 <.text+0x336d20>
18034674c: 48 63 05 c9 1c 48 00        	movslq	0x481cc9(%rip), %rax    # 0x1807c841c
180346753: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346757: b9 02 00 00 00              	movl	$0x2, %ecx
18034675c: 29 c1                       	subl	%eax, %ecx
18034675e: d3 c2                       	roll	%cl, %edx
180346760: 0f ca                       	bswapl	%edx
180346762: f7 da                       	negl	%edx
180346764: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
18034676a: 48 63 c2                    	movslq	%edx, %rax
18034676d: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346771: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346777: d3 ca                       	rorl	%cl, %edx
180346779: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
18034677f: d3 ca                       	rorl	%cl, %edx
180346781: b9 12 00 00 00              	movl	$0x12, %ecx
180346786: 29 c1                       	subl	%eax, %ecx
180346788: d3 c2                       	roll	%cl, %edx
18034678a: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346790: 48 63 c2                    	movslq	%edx, %rax
180346793: 48 8d 8d 10 0a 00 00        	leaq	0xa10(%rbp), %rcx
18034679a: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034679f: 48 b9 29 7f c3 01 7f 5f 41 72       	movabsq	$0x72415f7f01c37f29, %rcx # imm = 0x72415F7F01C37F29
1803467a9: 48 33 0d 50 a2 46 00        	xorq	0x46a250(%rip), %rcx    # 0x1807b0a00
1803467b0: 48 ba 20 09 a9 19 fb ee 9e 39       	movabsq	$0x399eeefb19a90920, %rdx # imm = 0x399EEEFB19A90920
1803467ba: 48 01 ca                    	addq	%rcx, %rdx
1803467bd: 48 39 d0                    	cmpq	%rdx, %rax
1803467c0: 0f 87 5a 05 00 00           	ja	0x180346d20 <.text+0x336d20>
1803467c6: 48 63 05 af 1c 48 00        	movslq	0x481caf(%rip), %rax    # 0x1807c847c
1803467cd: 31 d2                       	xorl	%edx, %edx
1803467cf: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
1803467d3: 8d 48 13                    	leal	0x13(%rax), %ecx
1803467d6: d3 ca                       	rorl	%cl, %edx
1803467d8: 48 63 ca                    	movslq	%edx, %rcx
1803467db: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
1803467df: 0f c8                       	bswapl	%eax
1803467e1: 81 c1 d2 b3 92 bf           	addl	$0xbf92b3d2, %ecx       # imm = 0xBF92B3D2
1803467e7: d3 c8                       	rorl	%cl, %eax
1803467e9: 35 2d 4c 6d 40              	xorl	$0x406d4c2d, %eax       # imm = 0x406D4C2D
1803467ee: d3 c8                       	rorl	%cl, %eax
1803467f0: f7 d8                       	negl	%eax
1803467f2: 48 98                       	cltq
1803467f4: 48 8d 8d 00 09 00 00        	leaq	0x900(%rbp), %rcx
1803467fb: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346800: 84 c0                       	testb	%al, %al
180346802: 0f 85 18 05 00 00           	jne	0x180346d20 <.text+0x336d20>
180346808: 48 63 05 71 1c 48 00        	movslq	0x481c71(%rip), %rax    # 0x1807c8480
18034680f: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346813: b9 02 00 00 00              	movl	$0x2, %ecx
180346818: 29 c1                       	subl	%eax, %ecx
18034681a: d3 c2                       	roll	%cl, %edx
18034681c: 0f ca                       	bswapl	%edx
18034681e: f7 da                       	negl	%edx
180346820: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180346826: 48 63 c2                    	movslq	%edx, %rax
180346829: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
18034682d: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346833: d3 ca                       	rorl	%cl, %edx
180346835: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
18034683b: d3 ca                       	rorl	%cl, %edx
18034683d: b9 12 00 00 00              	movl	$0x12, %ecx
180346842: 29 c1                       	subl	%eax, %ecx
180346844: d3 c2                       	roll	%cl, %edx
180346846: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
18034684c: 48 63 c2                    	movslq	%edx, %rax
18034684f: 48 8d 8d 00 09 00 00        	leaq	0x900(%rbp), %rcx
180346856: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034685b: 48 b9 15 c6 1c dd fe 7b ba ef       	movabsq	$-0x1045840122e339eb, %rcx # imm = 0xEFBA7BFEDD1CC615
180346865: 48 33 0d cc a1 46 00        	xorq	0x46a1cc(%rip), %rcx    # 0x1807b0a38
18034686c: 48 ba 56 d8 7c 5e 4a e4 22 87       	movabsq	$-0x78dd1bb5a18327aa, %rdx # imm = 0x8722E44A5E7CD856
180346876: 48 01 ca                    	addq	%rcx, %rdx
180346879: 48 39 d0                    	cmpq	%rdx, %rax
18034687c: 0f 87 9e 04 00 00           	ja	0x180346d20 <.text+0x336d20>
180346882: 48 63 05 fb 1b 48 00        	movslq	0x481bfb(%rip), %rax    # 0x1807c8484
180346889: 31 d2                       	xorl	%edx, %edx
18034688b: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
18034688f: 8d 48 13                    	leal	0x13(%rax), %ecx
180346892: d3 ca                       	rorl	%cl, %edx
180346894: 48 63 ca                    	movslq	%edx, %rcx
180346897: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
18034689b: 0f c8                       	bswapl	%eax
18034689d: 81 c1 d2 b3 92 bf           	addl	$0xbf92b3d2, %ecx       # imm = 0xBF92B3D2
1803468a3: d3 c8                       	rorl	%cl, %eax
1803468a5: 35 2d 4c 6d 40              	xorl	$0x406d4c2d, %eax       # imm = 0x406D4C2D
1803468aa: d3 c8                       	rorl	%cl, %eax
1803468ac: f7 d8                       	negl	%eax
1803468ae: 48 98                       	cltq
1803468b0: 48 8d 8d d0 09 00 00        	leaq	0x9d0(%rbp), %rcx
1803468b7: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803468bc: 84 c0                       	testb	%al, %al
1803468be: 0f 85 5c 04 00 00           	jne	0x180346d20 <.text+0x336d20>
1803468c4: 48 63 05 45 1b 48 00        	movslq	0x481b45(%rip), %rax    # 0x1807c8410
1803468cb: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
1803468cf: b9 02 00 00 00              	movl	$0x2, %ecx
1803468d4: 29 c1                       	subl	%eax, %ecx
1803468d6: d3 c2                       	roll	%cl, %edx
1803468d8: 0f ca                       	bswapl	%edx
1803468da: f7 da                       	negl	%edx
1803468dc: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
1803468e2: 48 63 c2                    	movslq	%edx, %rax
1803468e5: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803468e9: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
1803468ef: d3 ca                       	rorl	%cl, %edx
1803468f1: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
1803468f7: d3 ca                       	rorl	%cl, %edx
1803468f9: b9 12 00 00 00              	movl	$0x12, %ecx
1803468fe: 29 c1                       	subl	%eax, %ecx
180346900: d3 c2                       	roll	%cl, %edx
180346902: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346908: 48 63 c2                    	movslq	%edx, %rax
18034690b: 48 8d 8d d0 09 00 00        	leaq	0x9d0(%rbp), %rcx
180346912: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346917: 48 b9 11 ed b5 fb db 42 41 3d       	movabsq	$0x3d4142dbfbb5ed11, %rcx # imm = 0x3D4142DBFBB5ED11
180346921: 48 33 0d f0 a0 46 00        	xorq	0x46a0f0(%rip), %rcx    # 0x1807b0a18
180346928: 48 ba a1 31 db cf db d2 47 ef       	movabsq	$-0x10b82d243024ce5f, %rdx # imm = 0xEF47D2DBCFDB31A1
180346932: 48 01 ca                    	addq	%rcx, %rdx
180346935: 48 39 d0                    	cmpq	%rdx, %rax
180346938: 0f 87 e2 03 00 00           	ja	0x180346d20 <.text+0x336d20>
18034693e: 48 63 05 e3 1a 48 00        	movslq	0x481ae3(%rip), %rax    # 0x1807c8428
180346945: 31 d2                       	xorl	%edx, %edx
180346947: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
18034694b: 8d 48 13                    	leal	0x13(%rax), %ecx
18034694e: d3 ca                       	rorl	%cl, %edx
180346950: 48 63 ca                    	movslq	%edx, %rcx
180346953: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
180346957: 0f c8                       	bswapl	%eax
180346959: 81 c1 d2 b3 92 bf           	addl	$0xbf92b3d2, %ecx       # imm = 0xBF92B3D2
18034695f: d3 c8                       	rorl	%cl, %eax
180346961: 35 2d 4c 6d 40              	xorl	$0x406d4c2d, %eax       # imm = 0x406D4C2D
180346966: d3 c8                       	rorl	%cl, %eax
180346968: f7 d8                       	negl	%eax
18034696a: 48 98                       	cltq
18034696c: 48 8d 8d 20 09 00 00        	leaq	0x920(%rbp), %rcx
180346973: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346978: 84 c0                       	testb	%al, %al
18034697a: 0f 85 a0 03 00 00           	jne	0x180346d20 <.text+0x336d20>
180346980: 48 63 05 d5 1a 48 00        	movslq	0x481ad5(%rip), %rax    # 0x1807c845c
180346987: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
18034698b: b9 02 00 00 00              	movl	$0x2, %ecx
180346990: 29 c1                       	subl	%eax, %ecx
180346992: d3 c2                       	roll	%cl, %edx
180346994: 0f ca                       	bswapl	%edx
180346996: f7 da                       	negl	%edx
180346998: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
18034699e: 48 63 c2                    	movslq	%edx, %rax
1803469a1: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
1803469a5: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
1803469ab: d3 ca                       	rorl	%cl, %edx
1803469ad: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
1803469b3: d3 ca                       	rorl	%cl, %edx
1803469b5: b9 12 00 00 00              	movl	$0x12, %ecx
1803469ba: 29 c1                       	subl	%eax, %ecx
1803469bc: d3 c2                       	roll	%cl, %edx
1803469be: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
1803469c4: 48 63 c2                    	movslq	%edx, %rax
1803469c7: 48 8d 8d 20 09 00 00        	leaq	0x920(%rbp), %rcx
1803469ce: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
1803469d3: 48 b9 b6 b4 0b 43 fc e5 b8 7b       	movabsq	$0x7bb8e5fc430bb4b6, %rcx # imm = 0x7BB8E5FC430BB4B6
1803469dd: 48 33 0d 5c a0 46 00        	xorq	0x46a05c(%rip), %rcx    # 0x1807b0a40
1803469e4: 48 ba a7 ac 4d bb b6 90 c1 32       	movabsq	$0x32c190b6bb4daca7, %rdx # imm = 0x32C190B6BB4DACA7
1803469ee: 48 01 ca                    	addq	%rcx, %rdx
1803469f1: 48 39 d0                    	cmpq	%rdx, %rax
1803469f4: 0f 87 26 03 00 00           	ja	0x180346d20 <.text+0x336d20>
1803469fa: 48 63 05 ff 19 48 00        	movslq	0x4819ff(%rip), %rax    # 0x1807c8400
180346a01: 31 d2                       	xorl	%edx, %edx
180346a03: 41 2b 14 87                 	subl	(%r15,%rax,4), %edx
180346a07: 8d 48 13                    	leal	0x13(%rax), %ecx
180346a0a: d3 ca                       	rorl	%cl, %edx
180346a0c: 48 63 ca                    	movslq	%edx, %rcx
180346a0f: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
180346a13: 0f c8                       	bswapl	%eax
180346a15: 81 c1 d2 b3 92 bf           	addl	$0xbf92b3d2, %ecx       # imm = 0xBF92B3D2
180346a1b: d3 c8                       	rorl	%cl, %eax
180346a1d: 35 2d 4c 6d 40              	xorl	$0x406d4c2d, %eax       # imm = 0x406D4C2D
180346a22: d3 c8                       	rorl	%cl, %eax
180346a24: f7 d8                       	negl	%eax
180346a26: 48 98                       	cltq
180346a28: 48 8d 8d 40 09 00 00        	leaq	0x940(%rbp), %rcx
180346a2f: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346a34: 84 c0                       	testb	%al, %al
180346a36: 0f 85 e4 02 00 00           	jne	0x180346d20 <.text+0x336d20>
180346a3c: 48 63 05 ad 19 48 00        	movslq	0x4819ad(%rip), %rax    # 0x1807c83f0
180346a43: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346a47: b9 02 00 00 00              	movl	$0x2, %ecx
180346a4c: 29 c1                       	subl	%eax, %ecx
180346a4e: d3 c2                       	roll	%cl, %edx
180346a50: 0f ca                       	bswapl	%edx
180346a52: f7 da                       	negl	%edx
180346a54: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180346a5a: 48 63 c2                    	movslq	%edx, %rax
180346a5d: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346a61: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346a67: d3 ca                       	rorl	%cl, %edx
180346a69: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180346a6f: d3 ca                       	rorl	%cl, %edx
180346a71: b9 12 00 00 00              	movl	$0x12, %ecx
180346a76: 29 c1                       	subl	%eax, %ecx
180346a78: d3 c2                       	roll	%cl, %edx
180346a7a: bb 02 00 00 00              	movl	$0x2, %ebx
180346a7f: bf 12 00 00 00              	movl	$0x12, %edi
180346a84: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346a8a: 48 63 c2                    	movslq	%edx, %rax
180346a8d: 48 8d 8d 40 09 00 00        	leaq	0x940(%rbp), %rcx
180346a94: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346a99: 48 b9 c7 a1 0a b5 c2 e4 5c 52       	movabsq	$0x525ce4c2b50aa1c7, %rcx # imm = 0x525CE4C2B50AA1C7
180346aa3: 48 33 0d 86 9f 46 00        	xorq	0x469f86(%rip), %rcx    # 0x1807b0a30
180346aaa: 48 ba 50 5b 6a 21 22 94 bd c9       	movabsq	$-0x36426bddde95a4b0, %rdx # imm = 0xC9BD9422216A5B50
180346ab4: 48 01 ca                    	addq	%rcx, %rdx
180346ab7: 48 39 d0                    	cmpq	%rdx, %rax
180346aba: 0f 85 60 02 00 00           	jne	0x180346d20 <.text+0x336d20>
180346ac0: 48 63 05 09 19 48 00        	movslq	0x481909(%rip), %rax    # 0x1807c83d0
180346ac7: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346acb: 29 c3                       	subl	%eax, %ebx
180346acd: 89 d9                       	movl	%ebx, %ecx
180346acf: d3 c2                       	roll	%cl, %edx
180346ad1: 0f ca                       	bswapl	%edx
180346ad3: f7 da                       	negl	%edx
180346ad5: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180346adb: 48 63 c2                    	movslq	%edx, %rax
180346ade: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346ae2: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346ae8: d3 ca                       	rorl	%cl, %edx
180346aea: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180346af0: d3 ca                       	rorl	%cl, %edx
180346af2: 29 c7                       	subl	%eax, %edi
180346af4: 89 f9                       	movl	%edi, %ecx
180346af6: d3 c2                       	roll	%cl, %edx
180346af8: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346afe: 48 63 c2                    	movslq	%edx, %rax
180346b01: 48 8d 8d 20 07 00 00        	leaq	0x720(%rbp), %rcx
180346b08: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346b0d: 48 b9 bf 86 15 fd e0 a5 41 93       	movabsq	$-0x6cbe5a1f02ea7941, %rcx # imm = 0x9341A5E0FD1586BF
180346b17: 48 33 0d ea 9e 46 00        	xorq	0x469eea(%rip), %rcx    # 0x1807b0a08
180346b1e: 48 ba ff 9b e5 be a6 13 35 99       	movabsq	$-0x66caec59411a6401, %rdx # imm = 0x993513A6BEE59BFF
180346b28: 48 01 ca                    	addq	%rcx, %rdx
180346b2b: 48 39 d0                    	cmpq	%rdx, %rax
180346b2e: 0f 85 ec 01 00 00           	jne	0x180346d20 <.text+0x336d20>
180346b34: 48 63 05 59 19 48 00        	movslq	0x481959(%rip), %rax    # 0x1807c8494
180346b3b: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346b3f: b9 02 00 00 00              	movl	$0x2, %ecx
180346b44: 29 c1                       	subl	%eax, %ecx
180346b46: d3 c2                       	roll	%cl, %edx
180346b48: 0f ca                       	bswapl	%edx
180346b4a: f7 da                       	negl	%edx
180346b4c: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180346b52: 48 63 c2                    	movslq	%edx, %rax
180346b55: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346b59: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346b5f: d3 ca                       	rorl	%cl, %edx
180346b61: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180346b67: d3 ca                       	rorl	%cl, %edx
180346b69: b9 12 00 00 00              	movl	$0x12, %ecx
180346b6e: 29 c1                       	subl	%eax, %ecx
180346b70: d3 c2                       	roll	%cl, %edx
180346b72: bb 02 00 00 00              	movl	$0x2, %ebx
180346b77: bf 12 00 00 00              	movl	$0x12, %edi
180346b7c: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346b82: 48 63 c2                    	movslq	%edx, %rax
180346b85: 48 8d 8d 40 07 00 00        	leaq	0x740(%rbp), %rcx
180346b8c: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346b91: 48 b9 db 19 a9 49 62 f0 08 f7       	movabsq	$-0x8f70f9db656e625, %rcx # imm = 0xF708F06249A919DB
180346b9b: 48 33 0d 7e 9e 46 00        	xorq	0x469e7e(%rip), %rcx    # 0x1807b0a20
180346ba2: 48 ba 7c 9c 88 f8 81 ae b8 70       	movabsq	$0x70b8ae81f8889c7c, %rdx # imm = 0x70B8AE81F8889C7C
180346bac: 48 01 ca                    	addq	%rcx, %rdx
180346baf: 48 39 d0                    	cmpq	%rdx, %rax
180346bb2: 0f 85 68 01 00 00           	jne	0x180346d20 <.text+0x336d20>
180346bb8: 48 63 05 99 18 48 00        	movslq	0x481899(%rip), %rax    # 0x1807c8458
180346bbf: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346bc3: 29 c3                       	subl	%eax, %ebx
180346bc5: 89 d9                       	movl	%ebx, %ecx
180346bc7: d3 c2                       	roll	%cl, %edx
180346bc9: 0f ca                       	bswapl	%edx
180346bcb: f7 da                       	negl	%edx
180346bcd: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180346bd3: 48 63 c2                    	movslq	%edx, %rax
180346bd6: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346bda: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346be0: d3 ca                       	rorl	%cl, %edx
180346be2: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180346be8: d3 ca                       	rorl	%cl, %edx
180346bea: 29 c7                       	subl	%eax, %edi
180346bec: 89 f9                       	movl	%edi, %ecx
180346bee: d3 c2                       	roll	%cl, %edx
180346bf0: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346bf6: 48 63 c2                    	movslq	%edx, %rax
180346bf9: 48 8d 8d 60 07 00 00        	leaq	0x760(%rbp), %rcx
180346c00: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346c05: 48 b9 a8 c8 a3 5c 9c 62 de 62       	movabsq	$0x62de629c5ca3c8a8, %rcx # imm = 0x62DE629C5CA3C8A8
180346c0f: 48 33 0d e2 9d 46 00        	xorq	0x469de2(%rip), %rcx    # 0x1807b09f8
180346c16: 48 ba 83 7e 9f 8a 60 0a ff e9       	movabsq	$-0x1600f59f7560817d, %rdx # imm = 0xE9FF0A608A9F7E83
180346c20: 48 01 ca                    	addq	%rcx, %rdx
180346c23: 48 39 d0                    	cmpq	%rdx, %rax
180346c26: 0f 85 f4 00 00 00           	jne	0x180346d20 <.text+0x336d20>
180346c2c: 48 63 05 39 18 48 00        	movslq	0x481839(%rip), %rax    # 0x1807c846c
180346c33: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346c37: b9 02 00 00 00              	movl	$0x2, %ecx
180346c3c: 29 c1                       	subl	%eax, %ecx
180346c3e: d3 c2                       	roll	%cl, %edx
180346c40: 0f ca                       	bswapl	%edx
180346c42: f7 da                       	negl	%edx
180346c44: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180346c4a: 48 63 c2                    	movslq	%edx, %rax
180346c4d: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346c51: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346c57: d3 ca                       	rorl	%cl, %edx
180346c59: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180346c5f: d3 ca                       	rorl	%cl, %edx
180346c61: b9 12 00 00 00              	movl	$0x12, %ecx
180346c66: 29 c1                       	subl	%eax, %ecx
180346c68: d3 c2                       	roll	%cl, %edx
180346c6a: bb 02 00 00 00              	movl	$0x2, %ebx
180346c6f: bf 12 00 00 00              	movl	$0x12, %edi
180346c74: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346c7a: 48 63 c2                    	movslq	%edx, %rax
180346c7d: 48 8d 8d e0 05 00 00        	leaq	0x5e0(%rbp), %rcx
180346c84: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346c89: 48 b9 73 a3 0b ae ba 8c 0e b5       	movabsq	$-0x4af1734551f45c8d, %rcx # imm = 0xB50E8CBAAE0BA373
180346c93: 48 33 0d 56 9d 46 00        	xorq	0x469d56(%rip), %rcx    # 0x1807b09f0
180346c9a: 48 ba 61 9f a2 0b 2a e3 b9 77       	movabsq	$0x77b9e32a0ba29f61, %rdx # imm = 0x77B9E32A0BA29F61
180346ca4: 48 01 ca                    	addq	%rcx, %rdx
180346ca7: 48 39 d0                    	cmpq	%rdx, %rax
180346caa: 75 74                       	jne	0x180346d20 <.text+0x336d20>
180346cac: 48 63 05 d5 17 48 00        	movslq	0x4817d5(%rip), %rax    # 0x1807c8488
180346cb3: 41 8b 14 87                 	movl	(%r15,%rax,4), %edx
180346cb7: 29 c3                       	subl	%eax, %ebx
180346cb9: 89 d9                       	movl	%ebx, %ecx
180346cbb: d3 c2                       	roll	%cl, %edx
180346cbd: 0f ca                       	bswapl	%edx
180346cbf: f7 da                       	negl	%edx
180346cc1: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180346cc7: 48 63 c2                    	movslq	%edx, %rax
180346cca: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346cce: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180346cd4: d3 ca                       	rorl	%cl, %edx
180346cd6: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180346cdc: d3 ca                       	rorl	%cl, %edx
180346cde: 29 c7                       	subl	%eax, %edi
180346ce0: 89 f9                       	movl	%edi, %ecx
180346ce2: d3 c2                       	roll	%cl, %edx
180346ce4: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180346cea: 48 63 c2                    	movslq	%edx, %rax
180346ced: 48 8d 8d 80 07 00 00        	leaq	0x780(%rbp), %rcx
180346cf4: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346cf9: 48 b9 1f 9f e5 ae 01 b6 bb c2       	movabsq	$-0x3d4449fe511a60e1, %rcx # imm = 0xC2BBB601AEE59F1F
180346d03: 48 33 0d 1e 9d 46 00        	xorq	0x469d1e(%rip), %rcx    # 0x1807b0a28
180346d0a: 48 ba a7 90 b3 30 83 aa df 16       	movabsq	$0x16dfaa8330b390a7, %rdx # imm = 0x16DFAA8330B390A7
180346d14: 48 01 ca                    	addq	%rcx, %rdx
180346d17: 48 39 d0                    	cmpq	%rdx, %rax
180346d1a: 0f 86 54 02 00 00           	jbe	0x180346f74 <.text+0x336f74>
180346d20: 8b 05 3a 9e 46 00           	movl	0x469e3a(%rip), %eax    # 0x1807b0b60
180346d26: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
180346d30: 48 63 05 a1 17 48 00        	movslq	0x4817a1(%rip), %rax    # 0x1807c84d8
180346d37: 45 31 c0                    	xorl	%r8d, %r8d
180346d3a: 48 8d 1d 3f 25 31 00        	leaq	0x31253f(%rip), %rbx    # 0x180659280
180346d41: 44 2b 04 83                 	subl	(%rbx,%rax,4), %r8d
180346d45: b9 37 a3 35 1f              	movl	$0x1f35a337, %ecx       # imm = 0x1F35A337
180346d4a: 29 c1                       	subl	%eax, %ecx
180346d4c: 41 d3 c0                    	roll	%cl, %r8d
180346d4f: 31 d2                       	xorl	%edx, %edx
180346d51: 41 0f c8                    	bswapl	%r8d
180346d54: 41 d3 c0                    	roll	%cl, %r8d
180346d57: 49 63 c0                    	movslq	%r8d, %rax
180346d5a: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180346d5e: b9 05 00 00 00              	movl	$0x5, %ecx
180346d63: 29 c1                       	subl	%eax, %ecx
180346d65: d3 c2                       	roll	%cl, %edx
180346d67: 81 f2 1a 0d 76 ac           	xorl	$0xac760d1a, %edx       # imm = 0xAC760D1A
180346d6d: ff c2                       	incl	%edx
180346d6f: 83 c0 05                    	addl	$0x5, %eax
180346d72: 89 c1                       	movl	%eax, %ecx
180346d74: d3 ca                       	rorl	%cl, %edx
180346d76: f7 d2                       	notl	%edx
180346d78: 0f ca                       	bswapl	%edx
180346d7a: f7 da                       	negl	%edx
180346d7c: 48 63 c2                    	movslq	%edx, %rax
180346d7f: 48 8d 8d 40 0c 00 00        	leaq	0xc40(%rbp), %rcx
180346d86: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346d8b: eb 3a                       	jmp	0x180346dc7 <.text+0x336dc7>
180346d8d: 8b 05 c5 9d 46 00           	movl	0x469dc5(%rip), %eax    # 0x1807b0b58
180346d93: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
180346d9d: e9 25 01 00 00              	jmp	0x180346ec7 <.text+0x336ec7>
180346da2: 8b 05 b4 9d 46 00           	movl	0x469db4(%rip), %eax    # 0x1807b0b5c
180346da8: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
180346db2: e9 be 00 00 00              	jmp	0x180346e75 <.text+0x336e75>
180346db7: 8b 05 ab 9d 46 00           	movl	0x469dab(%rip), %eax    # 0x1807b0b68
180346dbd: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
180346dc7: 48 63 05 4a 17 48 00        	movslq	0x48174a(%rip), %rax    # 0x1807c8518
180346dce: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180346dd1: f7 d2                       	notl	%edx
180346dd3: 8d 48 12                    	leal	0x12(%rax), %ecx
180346dd6: d3 ca                       	rorl	%cl, %edx
180346dd8: 4c 63 ca                    	movslq	%edx, %r9
180346ddb: 47 8b 04 8e                 	movl	(%r14,%r9,4), %r8d
180346ddf: 41 8d 81 30 1d 42 31        	leal	0x31421d30(%r9), %eax
180346de6: 89 c1                       	movl	%eax, %ecx
180346de8: 41 d3 c8                    	rorl	%cl, %r8d
180346deb: 41 0f c8                    	bswapl	%r8d
180346dee: ba 30 1d 42 31              	movl	$0x31421d30, %edx       # imm = 0x31421D30
180346df3: 44 29 ca                    	subl	%r9d, %edx
180346df6: 89 d1                       	movl	%edx, %ecx
180346df8: 41 d3 c0                    	roll	%cl, %r8d
180346dfb: 89 c1                       	movl	%eax, %ecx
180346dfd: 41 d3 c8                    	rorl	%cl, %r8d
180346e00: 41 f7 d0                    	notl	%r8d
180346e03: 41 d3 c8                    	rorl	%cl, %r8d
180346e06: 41 81 f0 30 1d 42 31        	xorl	$0x31421d30, %r8d       # imm = 0x31421D30
180346e0d: 89 d1                       	movl	%edx, %ecx
180346e0f: 41 d3 c0                    	roll	%cl, %r8d
180346e12: 49 63 c0                    	movslq	%r8d, %rax
180346e15: 48 8d 8d f0 0a 00 00        	leaq	0xaf0(%rbp), %rcx
180346e1c: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346e21: 48 63 05 90 16 48 00        	movslq	0x481690(%rip), %rax    # 0x1807c84b8
180346e28: 45 31 c0                    	xorl	%r8d, %r8d
180346e2b: 44 2b 04 83                 	subl	(%rbx,%rax,4), %r8d
180346e2f: b9 37 a3 35 1f              	movl	$0x1f35a337, %ecx       # imm = 0x1F35A337
180346e34: 29 c1                       	subl	%eax, %ecx
180346e36: 41 d3 c0                    	roll	%cl, %r8d
180346e39: 31 d2                       	xorl	%edx, %edx
180346e3b: 41 0f c8                    	bswapl	%r8d
180346e3e: 41 d3 c0                    	roll	%cl, %r8d
180346e41: 49 63 c0                    	movslq	%r8d, %rax
180346e44: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180346e48: b9 05 00 00 00              	movl	$0x5, %ecx
180346e4d: 29 c1                       	subl	%eax, %ecx
180346e4f: d3 c2                       	roll	%cl, %edx
180346e51: 81 f2 1a 0d 76 ac           	xorl	$0xac760d1a, %edx       # imm = 0xAC760D1A
180346e57: ff c2                       	incl	%edx
180346e59: 83 c0 05                    	addl	$0x5, %eax
180346e5c: 89 c1                       	movl	%eax, %ecx
180346e5e: d3 ca                       	rorl	%cl, %edx
180346e60: f7 d2                       	notl	%edx
180346e62: 0f ca                       	bswapl	%edx
180346e64: f7 da                       	negl	%edx
180346e66: 48 63 c2                    	movslq	%edx, %rax
180346e69: 48 8d 8d a0 07 00 00        	leaq	0x7a0(%rbp), %rcx
180346e70: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346e75: 48 63 15 70 16 48 00        	movslq	0x481670(%rip), %rdx    # 0x1807c84ec
180346e7c: 48 8d 1d fd 23 31 00        	leaq	0x3123fd(%rip), %rbx    # 0x180659280
180346e83: 44 8b 04 93                 	movl	(%rbx,%rdx,4), %r8d
180346e87: b8 26 83 43 60              	movl	$0x60438326, %eax       # imm = 0x60438326
180346e8c: 29 d0                       	subl	%edx, %eax
180346e8e: 89 c1                       	movl	%eax, %ecx
180346e90: 41 d3 c0                    	roll	%cl, %r8d
180346e93: 8d 8a 26 83 43 60           	leal	0x60438326(%rdx), %ecx
180346e99: 41 d3 c8                    	rorl	%cl, %r8d
180346e9c: 41 d3 c8                    	rorl	%cl, %r8d
180346e9f: 89 c1                       	movl	%eax, %ecx
180346ea1: 41 d3 c0                    	roll	%cl, %r8d
180346ea4: 49 63 c8                    	movslq	%r8d, %rcx
180346ea7: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
180346eab: 81 c1 3a f5 03 0d           	addl	$0xd03f53a, %ecx        # imm = 0xD03F53A
180346eb1: d3 c8                       	rorl	%cl, %eax
180346eb3: 0f c8                       	bswapl	%eax
180346eb5: d3 c8                       	rorl	%cl, %eax
180346eb7: 0f c8                       	bswapl	%eax
180346eb9: 48 98                       	cltq
180346ebb: 48 8d 8d 80 08 00 00        	leaq	0x880(%rbp), %rcx
180346ec2: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346ec7: 48 63 05 2e 16 48 00        	movslq	0x48162e(%rip), %rax    # 0x1807c84fc
180346ece: 8b 14 83                    	movl	(%rbx,%rax,4), %edx
180346ed1: 8d 48 14                    	leal	0x14(%rax), %ecx
180346ed4: d3 ca                       	rorl	%cl, %edx
180346ed6: ff c2                       	incl	%edx
180346ed8: b9 14 00 00 00              	movl	$0x14, %ecx
180346edd: 29 c1                       	subl	%eax, %ecx
180346edf: d3 c2                       	roll	%cl, %edx
180346ee1: 48 63 c2                    	movslq	%edx, %rax
180346ee4: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346ee8: b9 17 00 00 00              	movl	$0x17, %ecx
180346eed: 29 c1                       	subl	%eax, %ecx
180346eef: d3 c2                       	roll	%cl, %edx
180346ef1: 05 d7 34 f9 0b              	addl	$0xbf934d7, %eax        # imm = 0xBF934D7
180346ef6: 89 c1                       	movl	%eax, %ecx
180346ef8: d3 ca                       	rorl	%cl, %edx
180346efa: 81 f2 d7 34 f9 0b           	xorl	$0xbf934d7, %edx        # imm = 0xBF934D7
180346f00: ff c2                       	incl	%edx
180346f02: d3 ca                       	rorl	%cl, %edx
180346f04: f7 da                       	negl	%edx
180346f06: 81 f2 d7 34 f9 0b           	xorl	$0xbf934d7, %edx        # imm = 0xBF934D7
180346f0c: 48 63 c2                    	movslq	%edx, %rax
180346f0f: 48 8d 8d a0 0b 00 00        	leaq	0xba0(%rbp), %rcx
180346f16: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346f1b: 48 63 05 3e 16 48 00        	movslq	0x48163e(%rip), %rax    # 0x1807c8560
180346f22: 45 31 c0                    	xorl	%r8d, %r8d
180346f25: 44 2b 04 83                 	subl	(%rbx,%rax,4), %r8d
180346f29: b9 37 a3 35 1f              	movl	$0x1f35a337, %ecx       # imm = 0x1F35A337
180346f2e: 29 c1                       	subl	%eax, %ecx
180346f30: 41 d3 c0                    	roll	%cl, %r8d
180346f33: 31 d2                       	xorl	%edx, %edx
180346f35: 41 0f c8                    	bswapl	%r8d
180346f38: 41 d3 c0                    	roll	%cl, %r8d
180346f3b: 49 63 c0                    	movslq	%r8d, %rax
180346f3e: 41 2b 14 86                 	subl	(%r14,%rax,4), %edx
180346f42: b9 05 00 00 00              	movl	$0x5, %ecx
180346f47: 29 c1                       	subl	%eax, %ecx
180346f49: d3 c2                       	roll	%cl, %edx
180346f4b: 81 f2 1a 0d 76 ac           	xorl	$0xac760d1a, %edx       # imm = 0xAC760D1A
180346f51: ff c2                       	incl	%edx
180346f53: 83 c0 05                    	addl	$0x5, %eax
180346f56: 89 c1                       	movl	%eax, %ecx
180346f58: d3 ca                       	rorl	%cl, %edx
180346f5a: f7 d2                       	notl	%edx
180346f5c: 0f ca                       	bswapl	%edx
180346f5e: f7 da                       	negl	%edx
180346f60: 48 63 c2                    	movslq	%edx, %rax
180346f63: 48 8d 8d 30 0c 00 00        	leaq	0xc30(%rbp), %rcx
180346f6a: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180346f6f: e9 44 a3 ff ff              	jmp	0x1803412b8 <.text+0x3312b8>
180346f74: 48 8d 8d 88 04 00 00        	leaq	0x488(%rbp), %rcx
180346f7b: 48 8d 95 c0 05 00 00        	leaq	0x5c0(%rbp), %rdx
180346f82: e8 c9 62 16 00              	callq	0x1804ad250 <.text+0x49d250>
180346f87: 48 63 05 3a 14 48 00        	movslq	0x48143a(%rip), %rax    # 0x1807c83c8
180346f8e: 4c 8d 35 eb 22 31 00        	leaq	0x3122eb(%rip), %r14    # 0x180659280
180346f95: 41 8b 14 86                 	movl	(%r14,%rax,4), %edx
180346f99: 0f ca                       	bswapl	%edx
180346f9b: 8d 88 b2 7c 96 f0           	leal	-0xf69834e(%rax), %ecx
180346fa1: d3 ca                       	rorl	%cl, %edx
180346fa3: d3 ca                       	rorl	%cl, %edx
180346fa5: d3 ca                       	rorl	%cl, %edx
180346fa7: 48 63 c2                    	movslq	%edx, %rax
180346faa: 31 d2                       	xorl	%edx, %edx
180346fac: 48 8d 3d 1d cb 47 00        	leaq	0x47cb1d(%rip), %rdi    # 0x1807c3ad0
180346fb3: 2b 14 87                    	subl	(%rdi,%rax,4), %edx
180346fb6: 81 f2 8b c2 17 e7           	xorl	$0xe717c28b, %edx       # imm = 0xE717C28B
180346fbc: 0f ca                       	bswapl	%edx
180346fbe: b9 8b c2 17 e7              	movl	$0xe717c28b, %ecx       # imm = 0xE717C28B
180346fc3: 29 c1                       	subl	%eax, %ecx
180346fc5: d3 c2                       	roll	%cl, %edx
180346fc7: d3 c2                       	roll	%cl, %edx
180346fc9: 81 f2 8b c2 17 e7           	xorl	$0xe717c28b, %edx       # imm = 0xE717C28B
180346fcf: 48 63 c2                    	movslq	%edx, %rax
180346fd2: 48 8d 8d 88 04 00 00        	leaq	0x488(%rbp), %rcx
180346fd9: 48 8d 1d 90 6c 47 00        	leaq	0x476c90(%rip), %rbx    # 0x1807bdc70
180346fe0: ff 14 c3                    	callq	*(%rbx,%rax,8)
180346fe3: 48 63 0d 1a 14 48 00        	movslq	0x48141a(%rip), %rcx    # 0x1807c8404
180346fea: 45 8b 04 8e                 	movl	(%r14,%rcx,4), %r8d
180346fee: 41 ff c0                    	incl	%r8d
180346ff1: 41 81 f0 53 04 4d c1        	xorl	$0xc14d0453, %r8d       # imm = 0xC14D0453
180346ff8: 41 8d 48 01                 	leal	0x1(%r8), %ecx
180346ffc: 48 63 c9                    	movslq	%ecx, %rcx
180346fff: 8b 14 8f                    	movl	(%rdi,%rcx,4), %edx
180347002: 41 8d 88 fe 11 ba 74        	leal	0x74ba11fe(%r8), %ecx
180347009: d3 ca                       	rorl	%cl, %edx
18034700b: d3 ca                       	rorl	%cl, %edx
18034700d: 81 f2 02 ee 45 8b           	xorl	$0x8b45ee02, %edx       # imm = 0x8B45EE02
180347013: d3 ca                       	rorl	%cl, %edx
180347015: 48 89 c7                    	movq	%rax, %rdi
180347018: b9 fc 11 ba 74              	movl	$0x74ba11fc, %ecx       # imm = 0x74BA11FC
18034701d: 44 29 c1                    	subl	%r8d, %ecx
180347020: d3 c2                       	roll	%cl, %edx
180347022: d3 c2                       	roll	%cl, %edx
180347024: d3 c2                       	roll	%cl, %edx
180347026: 48 63 c2                    	movslq	%edx, %rax
180347029: 48 8b 8d 68 0b 00 00        	movq	0xb68(%rbp), %rcx
180347030: ff 14 c3                    	callq	*(%rbx,%rax,8)
180347033: 48 39 c7                    	cmpq	%rax, %rdi
180347036: 0f 85 2c 14 00 00           	jne	0x180348468 <.text+0x338468>
18034703c: 48 63 05 ed 13 48 00        	movslq	0x4813ed(%rip), %rax    # 0x1807c8430
180347043: 4c 8d 2d 36 22 31 00        	leaq	0x312236(%rip), %r13    # 0x180659280
18034704a: 41 8b 54 85 00              	movl	(%r13,%rax,4), %edx
18034704f: 8d 88 78 60 76 e5           	leal	-0x1a899f88(%rax), %ecx
180347055: d3 ca                       	rorl	%cl, %edx
180347057: f7 d2                       	notl	%edx
180347059: d3 ca                       	rorl	%cl, %edx
18034705b: 81 f2 78 60 76 e5           	xorl	$0xe5766078, %edx       # imm = 0xE5766078
180347061: 4c 63 ca                    	movslq	%edx, %r9
180347064: 41 be 99 4b e7 08           	movl	$0x8e74b99, %r14d       # imm = 0x8E74B99
18034706a: 4c 8d 25 5f ca 47 00        	leaq	0x47ca5f(%rip), %r12    # 0x1807c3ad0
180347071: 47 8b 04 8c                 	movl	(%r12,%r9,4), %r8d
180347075: 45 31 f0                    	xorl	%r14d, %r8d
180347078: 41 8d 81 66 b4 18 f7        	leal	-0x8e74b9a(%r9), %eax
18034707f: 89 c1                       	movl	%eax, %ecx
180347081: 41 d3 c8                    	rorl	%cl, %r8d
180347084: ba 66 b4 18 f7              	movl	$0xf718b466, %edx       # imm = 0xF718B466
180347089: 44 29 ca                    	subl	%r9d, %edx
18034708c: 89 d1                       	movl	%edx, %ecx
18034708e: 41 d3 c0                    	roll	%cl, %r8d
180347091: 89 c1                       	movl	%eax, %ecx
180347093: 41 d3 c8                    	rorl	%cl, %r8d
180347096: 41 d3 c8                    	rorl	%cl, %r8d
180347099: 89 d1                       	movl	%edx, %ecx
18034709b: 41 d3 c0                    	roll	%cl, %r8d
18034709e: bb 66 b4 18 f7              	movl	$0xf718b466, %ebx       # imm = 0xF718B466
1803470a3: 41 f7 d8                    	negl	%r8d
1803470a6: 49 63 c0                    	movslq	%r8d, %rax
1803470a9: 48 8b 8d 00 08 00 00        	movq	0x800(%rbp), %rcx
1803470b0: 4c 8d 3d b9 6b 47 00        	leaq	0x476bb9(%rip), %r15    # 0x1807bdc70
1803470b7: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803470bb: 48 63 0d 6a 13 48 00        	movslq	0x48136a(%rip), %rcx    # 0x1807c842c
1803470c2: 41 8b 54 8d 00              	movl	(%r13,%rcx,4), %edx
1803470c7: 83 c1 0d                    	addl	$0xd, %ecx
1803470ca: d3 ca                       	rorl	%cl, %edx
1803470cc: 81 f2 ed ff 22 ce           	xorl	$0xce22ffed, %edx       # imm = 0xCE22FFED
1803470d2: 4c 63 c2                    	movslq	%edx, %r8
1803470d5: 47 8b 0c 84                 	movl	(%r12,%r8,4), %r9d
1803470d9: 41 0f c9                    	bswapl	%r9d
1803470dc: 41 f7 d9                    	negl	%r9d
1803470df: 41 8d 90 29 69 a3 e5        	leal	-0x1a5c96d7(%r8), %edx
1803470e6: 89 d1                       	movl	%edx, %ecx
1803470e8: 41 d3 c9                    	rorl	%cl, %r9d
1803470eb: b9 09 00 00 00              	movl	$0x9, %ecx
1803470f0: 44 29 c1                    	subl	%r8d, %ecx
1803470f3: 41 d3 c1                    	roll	%cl, %r9d
1803470f6: 89 d1                       	movl	%edx, %ecx
1803470f8: 41 d3 c9                    	rorl	%cl, %r9d
1803470fb: 48 89 c7                    	movq	%rax, %rdi
1803470fe: 41 81 f1 29 69 a3 e5        	xorl	$0xe5a36929, %r9d       # imm = 0xE5A36929
180347105: 49 63 c1                    	movslq	%r9d, %rax
180347108: 48 8d 8d 88 04 00 00        	leaq	0x488(%rbp), %rcx
18034710f: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347113: 48 63 0d 32 13 48 00        	movslq	0x481332(%rip), %rcx    # 0x1807c844c
18034711a: 41 8b 54 8d 00              	movl	(%r13,%rcx,4), %edx
18034711f: 81 c1 78 60 76 e5           	addl	$0xe5766078, %ecx       # imm = 0xE5766078
180347125: d3 ca                       	rorl	%cl, %edx
180347127: f7 d2                       	notl	%edx
180347129: d3 ca                       	rorl	%cl, %edx
18034712b: 81 f2 78 60 76 e5           	xorl	$0xe5766078, %edx       # imm = 0xE5766078
180347131: 4c 63 c2                    	movslq	%edx, %r8
180347134: 47 33 34 84                 	xorl	(%r12,%r8,4), %r14d
180347138: 41 8d 90 66 b4 18 f7        	leal	-0x8e74b9a(%r8), %edx
18034713f: 89 d1                       	movl	%edx, %ecx
180347141: 41 d3 ce                    	rorl	%cl, %r14d
180347144: 44 29 c3                    	subl	%r8d, %ebx
180347147: 89 d9                       	movl	%ebx, %ecx
180347149: 41 d3 c6                    	roll	%cl, %r14d
18034714c: 89 d1                       	movl	%edx, %ecx
18034714e: 41 d3 ce                    	rorl	%cl, %r14d
180347151: 41 d3 ce                    	rorl	%cl, %r14d
180347154: 89 d9                       	movl	%ebx, %ecx
180347156: 41 d3 c6                    	roll	%cl, %r14d
180347159: 48 89 c3                    	movq	%rax, %rbx
18034715c: 41 f7 de                    	negl	%r14d
18034715f: 49 63 c6                    	movslq	%r14d, %rax
180347162: 48 8b 8d 68 0b 00 00        	movq	0xb68(%rbp), %rcx
180347169: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
18034716d: 48 63 0d 2c 0f 48 00        	movslq	0x480f2c(%rip), %rcx    # 0x1807c80a0
180347174: 41 8b 54 8d 00              	movl	(%r13,%rcx,4), %edx
180347179: 0f ca                       	bswapl	%edx
18034717b: 81 c1 e9 65 ae 34           	addl	$0x34ae65e9, %ecx       # imm = 0x34AE65E9
180347181: d3 ca                       	rorl	%cl, %edx
180347183: 81 f2 e9 65 ae 34           	xorl	$0x34ae65e9, %edx       # imm = 0x34AE65E9
180347189: d3 ca                       	rorl	%cl, %edx
18034718b: 4c 63 c2                    	movslq	%edx, %r8
18034718e: 47 8b 0c 84                 	movl	(%r12,%r8,4), %r9d
180347192: 41 8d 90 a7 51 1e 2b        	leal	0x2b1e51a7(%r8), %edx
180347199: 89 d1                       	movl	%edx, %ecx
18034719b: 41 d3 c9                    	rorl	%cl, %r9d
18034719e: 41 f7 d9                    	negl	%r9d
1803471a1: 41 d3 c9                    	rorl	%cl, %r9d
1803471a4: 41 f7 d9                    	negl	%r9d
1803471a7: b9 07 00 00 00              	movl	$0x7, %ecx
1803471ac: 44 29 c1                    	subl	%r8d, %ecx
1803471af: 41 d3 c1                    	roll	%cl, %r9d
1803471b2: 89 d1                       	movl	%edx, %ecx
1803471b4: 41 d3 c9                    	rorl	%cl, %r9d
1803471b7: 4d 63 c9                    	movslq	%r9d, %r9
1803471ba: 48 89 c1                    	movq	%rax, %rcx
1803471bd: 48 89 da                    	movq	%rbx, %rdx
1803471c0: 49 89 f8                    	movq	%rdi, %r8
1803471c3: 43 ff 14 cf                 	callq	*(%r15,%r9,8)
1803471c7: 48 8d 8d 70 0b 00 00        	leaq	0xb70(%rbp), %rcx
1803471ce: 48 89 f2                    	movq	%rsi, %rdx
1803471d1: e8 8a 84 fd ff              	callq	0x18031f660 <.text+0x30f660>
1803471d6: 44 0f b6 05 db 97 46 00     	movzbl	0x4697db(%rip), %r8d    # 0x1807b09b9
1803471de: 41 80 f0 4d                 	xorb	$0x4d, %r8b
1803471e2: 41 80 c0 78                 	addb	$0x78, %r8b
1803471e6: 48 8d 8d 50 01 00 00        	leaq	0x150(%rbp), %rcx
1803471ed: 48 8d 95 10 0a 00 00        	leaq	0xa10(%rbp), %rdx
1803471f4: e8 c7 84 fd ff              	callq	0x18031f6c0 <.text+0x30f6c0>
1803471f9: 48 8d 8d 30 01 00 00        	leaq	0x130(%rbp), %rcx
180347200: 48 8d 95 50 01 00 00        	leaq	0x150(%rbp), %rdx
180347207: 4c 8d 85 00 09 00 00        	leaq	0x900(%rbp), %r8
18034720e: e8 bd 6d fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
180347213: 44 0f b6 05 9d 97 46 00     	movzbl	0x46979d(%rip), %r8d    # 0x1807b09b8
18034721b: 41 80 f0 50                 	xorb	$0x50, %r8b
18034721f: 41 80 c0 1b                 	addb	$0x1b, %r8b
180347223: 48 8d 8d 10 01 00 00        	leaq	0x110(%rbp), %rcx
18034722a: 48 8d 95 30 01 00 00        	leaq	0x130(%rbp), %rdx
180347231: e8 5a 6e fd ff              	callq	0x18031e090 <.text+0x30e090>
180347236: 48 8d 8d f0 00 00 00        	leaq	0xf0(%rbp), %rcx
18034723d: 48 8d 95 10 01 00 00        	leaq	0x110(%rbp), %rdx
180347244: 4c 8d 85 c0 05 00 00        	leaq	0x5c0(%rbp), %r8
18034724b: e8 80 6d fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
180347250: 44 0f b6 05 62 97 46 00     	movzbl	0x469762(%rip), %r8d    # 0x1807b09ba
180347258: 41 80 f0 65                 	xorb	$0x65, %r8b
18034725c: 41 80 c0 fd                 	addb	$-0x3, %r8b
180347260: 48 8d 8d d0 00 00 00        	leaq	0xd0(%rbp), %rcx
180347267: 48 8d 95 f0 00 00 00        	leaq	0xf0(%rbp), %rdx
18034726e: e8 1d 6e fd ff              	callq	0x18031e090 <.text+0x30e090>
180347273: 48 8d 8d b0 00 00 00        	leaq	0xb0(%rbp), %rcx
18034727a: 48 8d 95 d0 00 00 00        	leaq	0xd0(%rbp), %rdx
180347281: 4c 8d 85 80 07 00 00        	leaq	0x780(%rbp), %r8
180347288: e8 43 6d fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
18034728d: 44 0f b6 05 26 97 46 00     	movzbl	0x469726(%rip), %r8d    # 0x1807b09bb
180347295: 41 80 f0 7b                 	xorb	$0x7b, %r8b
180347299: 41 80 c0 54                 	addb	$0x54, %r8b
18034729d: 48 8d 8d 90 00 00 00        	leaq	0x90(%rbp), %rcx
1803472a4: 48 8d 95 b0 00 00 00        	leaq	0xb0(%rbp), %rdx
1803472ab: e8 e0 6d fd ff              	callq	0x18031e090 <.text+0x30e090>
1803472b0: 48 8d 8d 00 04 00 00        	leaq	0x400(%rbp), %rcx
1803472b7: 48 8d 95 90 00 00 00        	leaq	0x90(%rbp), %rdx
1803472be: 4c 8d 85 d0 09 00 00        	leaq	0x9d0(%rbp), %r8
1803472c5: e8 06 6d fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
1803472ca: 44 0f b6 05 ea 96 46 00     	movzbl	0x4696ea(%rip), %r8d    # 0x1807b09bc
1803472d2: 41 80 f0 e3                 	xorb	$-0x1d, %r8b
1803472d6: 41 80 c0 0d                 	addb	$0xd, %r8b
1803472da: 48 8d 8d e0 03 00 00        	leaq	0x3e0(%rbp), %rcx
1803472e1: 48 8d 95 00 04 00 00        	leaq	0x400(%rbp), %rdx
1803472e8: e8 a3 6d fd ff              	callq	0x18031e090 <.text+0x30e090>
1803472ed: 48 8d 8d c0 03 00 00        	leaq	0x3c0(%rbp), %rcx
1803472f4: 48 8d 95 e0 03 00 00        	leaq	0x3e0(%rbp), %rdx
1803472fb: 4c 8d 85 20 09 00 00        	leaq	0x920(%rbp), %r8
180347302: e8 c9 6c fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
180347307: 44 0f b6 05 81 96 46 00     	movzbl	0x469681(%rip), %r8d    # 0x1807b0990
18034730f: 41 80 f0 87                 	xorb	$-0x79, %r8b
180347313: 41 80 c0 43                 	addb	$0x43, %r8b
180347317: 48 8d 8d d0 07 00 00        	leaq	0x7d0(%rbp), %rcx
18034731e: 48 8d 95 c0 03 00 00        	leaq	0x3c0(%rbp), %rdx
180347325: e8 66 6d fd ff              	callq	0x18031e090 <.text+0x30e090>
18034732a: 48 8d 8d b0 07 00 00        	leaq	0x7b0(%rbp), %rcx
180347331: 48 8d 95 d0 07 00 00        	leaq	0x7d0(%rbp), %rdx
180347338: 4c 8d 85 40 09 00 00        	leaq	0x940(%rbp), %r8
18034733f: e8 8c 6c fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
180347344: 44 0f b6 05 42 98 46 00     	movzbl	0x469842(%rip), %r8d    # 0x1807b0b8e
18034734c: 41 80 f0 1b                 	xorb	$0x1b, %r8b
180347350: 41 80 c0 e4                 	addb	$-0x1c, %r8b
180347354: 48 8d 8d 60 06 00 00        	leaq	0x660(%rbp), %rcx
18034735b: 48 8d 95 b0 07 00 00        	leaq	0x7b0(%rbp), %rdx
180347362: e8 29 6d fd ff              	callq	0x18031e090 <.text+0x30e090>
180347367: 48 8d 8d 40 06 00 00        	leaq	0x640(%rbp), %rcx
18034736e: 48 8d 95 60 06 00 00        	leaq	0x660(%rbp), %rdx
180347375: 4c 8d 85 20 07 00 00        	leaq	0x720(%rbp), %r8
18034737c: e8 4f 6c fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
180347381: 44 0f b6 05 07 98 46 00     	movzbl	0x469807(%rip), %r8d    # 0x1807b0b90
180347389: 41 80 f0 d1                 	xorb	$-0x2f, %r8b
18034738d: 41 80 c0 8b                 	addb	$-0x75, %r8b
180347391: 48 8d 8d 20 06 00 00        	leaq	0x620(%rbp), %rcx
180347398: 48 8d 95 40 06 00 00        	leaq	0x640(%rbp), %rdx
18034739f: e8 ec 6c fd ff              	callq	0x18031e090 <.text+0x30e090>
1803473a4: 48 8d 8d 60 04 00 00        	leaq	0x460(%rbp), %rcx
1803473ab: 48 8d 95 20 06 00 00        	leaq	0x620(%rbp), %rdx
1803473b2: 4c 8d 85 40 07 00 00        	leaq	0x740(%rbp), %r8
1803473b9: e8 12 6c fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
1803473be: 44 0f b6 05 c6 97 46 00     	movzbl	0x4697c6(%rip), %r8d    # 0x1807b0b8c
1803473c6: 41 80 f0 09                 	xorb	$0x9, %r8b
1803473ca: 41 80 c0 8e                 	addb	$-0x72, %r8b
1803473ce: 48 8d 8d 40 04 00 00        	leaq	0x440(%rbp), %rcx
1803473d5: 48 8d 95 60 04 00 00        	leaq	0x460(%rbp), %rdx
1803473dc: e8 af 6c fd ff              	callq	0x18031e090 <.text+0x30e090>
1803473e1: 48 8d 8d 60 09 00 00        	leaq	0x960(%rbp), %rcx
1803473e8: 48 8d 95 40 04 00 00        	leaq	0x440(%rbp), %rdx
1803473ef: 4c 8d 85 60 07 00 00        	leaq	0x760(%rbp), %r8
1803473f6: e8 d5 6b fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
1803473fb: 44 0f b6 05 8c 97 46 00     	movzbl	0x46978c(%rip), %r8d    # 0x1807b0b8f
180347403: 41 80 f0 ed                 	xorb	$-0x13, %r8b
180347407: 41 80 c0 cf                 	addb	$-0x31, %r8b
18034740b: 48 8d 8d 00 06 00 00        	leaq	0x600(%rbp), %rcx
180347412: 48 8d 95 60 09 00 00        	leaq	0x960(%rbp), %rdx
180347419: e8 72 6c fd ff              	callq	0x18031e090 <.text+0x30e090>
18034741e: 48 8d 8d a0 09 00 00        	leaq	0x9a0(%rbp), %rcx
180347425: 48 8d 95 00 06 00 00        	leaq	0x600(%rbp), %rdx
18034742c: 4c 8d 85 e0 05 00 00        	leaq	0x5e0(%rbp), %r8
180347433: e8 98 6b fd ff              	callq	0x18031dfd0 <.text+0x30dfd0>
180347438: 44 0f b6 05 4d 97 46 00     	movzbl	0x46974d(%rip), %r8d    # 0x1807b0b8d
180347440: 41 80 f0 54                 	xorb	$0x54, %r8b
180347444: 41 80 c0 31                 	addb	$0x31, %r8b
180347448: 48 8d 8d 20 0b 00 00        	leaq	0xb20(%rbp), %rcx
18034744f: 48 8d 95 a0 09 00 00        	leaq	0x9a0(%rbp), %rdx
180347456: e8 35 6c fd ff              	callq	0x18031e090 <.text+0x30e090>
18034745b: 48 8d 8d 50 0c 00 00        	leaq	0xc50(%rbp), %rcx
180347462: 48 8d 95 20 0b 00 00        	leaq	0xb20(%rbp), %rdx
180347469: 4c 8d 85 70 0b 00 00        	leaq	0xb70(%rbp), %r8
180347470: e8 6b 4f fa ff              	callq	0x1802ec3e0 <.text+0x2dc3e0>
180347475: 48 63 15 d0 0d 48 00        	movslq	0x480dd0(%rip), %rdx    # 0x1807c824c
18034747c: 48 8d 3d fd 1d 31 00        	leaq	0x311dfd(%rip), %rdi    # 0x180659280
180347483: 8b 04 97                    	movl	(%rdi,%rdx,4), %eax
180347486: b9 0b 00 00 00              	movl	$0xb, %ecx
18034748b: 29 d1                       	subl	%edx, %ecx
18034748d: d3 c0                       	roll	%cl, %eax
18034748f: f7 d0                       	notl	%eax
180347491: 8d 4a 0b                    	leal	0xb(%rdx), %ecx
180347494: d3 c8                       	rorl	%cl, %eax
180347496: 89 c1                       	movl	%eax, %ecx
180347498: f7 d1                       	notl	%ecx
18034749a: 48 63 c9                    	movslq	%ecx, %rcx
18034749d: 4c 8d 25 2c c6 47 00        	leaq	0x47c62c(%rip), %r12    # 0x1807c3ad0
1803474a4: 45 8b 04 8c                 	movl	(%r12,%rcx,4), %r8d
1803474a8: 41 0f c8                    	bswapl	%r8d
1803474ab: ba 27 57 c4 2e              	movl	$0x2ec45727, %edx       # imm = 0x2EC45727
1803474b0: 29 c2                       	subl	%eax, %edx
1803474b2: 89 d1                       	movl	%edx, %ecx
1803474b4: 41 d3 c8                    	rorl	%cl, %r8d
1803474b7: 05 29 57 c4 2e              	addl	$0x2ec45729, %eax       # imm = 0x2EC45729
1803474bc: 89 c1                       	movl	%eax, %ecx
1803474be: 41 d3 c0                    	roll	%cl, %r8d
1803474c1: 89 d1                       	movl	%edx, %ecx
1803474c3: 41 d3 c8                    	rorl	%cl, %r8d
1803474c6: 41 81 f0 d7 a8 3b d1        	xorl	$0xd13ba8d7, %r8d       # imm = 0xD13BA8D7
1803474cd: 41 ff c0                    	incl	%r8d
1803474d0: 89 c1                       	movl	%eax, %ecx
1803474d2: 41 d3 c0                    	roll	%cl, %r8d
1803474d5: 41 f7 d0                    	notl	%r8d
1803474d8: 49 63 c0                    	movslq	%r8d, %rax
1803474db: 48 8d 8d 70 01 00 00        	leaq	0x170(%rbp), %rcx
1803474e2: 4c 8d b5 50 0c 00 00        	leaq	0xc50(%rbp), %r14
1803474e9: 4c 89 f2                    	movq	%r14, %rdx
1803474ec: 4c 8d 3d 7d 67 47 00        	leaq	0x47677d(%rip), %r15    # 0x1807bdc70
1803474f3: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803474f7: 48 63 05 92 0f 48 00        	movslq	0x480f92(%rip), %rax    # 0x1807c8490
1803474fe: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347501: b9 0a 00 00 00              	movl	$0xa, %ecx
180347506: 29 c1                       	subl	%eax, %ecx
180347508: d3 c2                       	roll	%cl, %edx
18034750a: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347510: d3 ca                       	rorl	%cl, %edx
180347512: d3 ca                       	rorl	%cl, %edx
180347514: d3 ca                       	rorl	%cl, %edx
180347516: bb 0a 00 00 00              	movl	$0xa, %ebx
18034751b: 48 63 c2                    	movslq	%edx, %rax
18034751e: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
180347528: 31 d2                       	xorl	%edx, %edx
18034752a: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
18034752e: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347534: d3 ca                       	rorl	%cl, %edx
180347536: d3 ca                       	rorl	%cl, %edx
180347538: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
18034753e: d3 ca                       	rorl	%cl, %edx
180347540: be d0 45 48 92              	movl	$0x924845d0, %esi       # imm = 0x924845D0
180347545: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
18034754a: 29 c1                       	subl	%eax, %ecx
18034754c: d3 c2                       	roll	%cl, %edx
18034754e: d3 c2                       	roll	%cl, %edx
180347550: 48 63 c2                    	movslq	%edx, %rax
180347553: 4c 89 f1                    	movq	%r14, %rcx
180347556: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
18034755a: 48 63 05 3f 0f 48 00        	movslq	0x480f3f(%rip), %rax    # 0x1807c84a0
180347561: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347564: b9 0a 00 00 00              	movl	$0xa, %ecx
180347569: 29 c1                       	subl	%eax, %ecx
18034756b: d3 c2                       	roll	%cl, %edx
18034756d: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347573: d3 ca                       	rorl	%cl, %edx
180347575: d3 ca                       	rorl	%cl, %edx
180347577: d3 ca                       	rorl	%cl, %edx
180347579: 48 63 c2                    	movslq	%edx, %rax
18034757c: 31 d2                       	xorl	%edx, %edx
18034757e: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347582: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347588: d3 ca                       	rorl	%cl, %edx
18034758a: d3 ca                       	rorl	%cl, %edx
18034758c: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347592: d3 ca                       	rorl	%cl, %edx
180347594: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347599: 29 c1                       	subl	%eax, %ecx
18034759b: d3 c2                       	roll	%cl, %edx
18034759d: d3 c2                       	roll	%cl, %edx
18034759f: 48 63 c2                    	movslq	%edx, %rax
1803475a2: 48 8d 8d 20 0b 00 00        	leaq	0xb20(%rbp), %rcx
1803475a9: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803475ad: 48 63 05 80 0e 48 00        	movslq	0x480e80(%rip), %rax    # 0x1807c8434
1803475b4: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803475b7: b9 0a 00 00 00              	movl	$0xa, %ecx
1803475bc: 29 c1                       	subl	%eax, %ecx
1803475be: d3 c2                       	roll	%cl, %edx
1803475c0: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803475c6: d3 ca                       	rorl	%cl, %edx
1803475c8: d3 ca                       	rorl	%cl, %edx
1803475ca: d3 ca                       	rorl	%cl, %edx
1803475cc: 48 63 c2                    	movslq	%edx, %rax
1803475cf: 31 d2                       	xorl	%edx, %edx
1803475d1: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
1803475d5: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803475db: d3 ca                       	rorl	%cl, %edx
1803475dd: d3 ca                       	rorl	%cl, %edx
1803475df: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803475e5: d3 ca                       	rorl	%cl, %edx
1803475e7: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803475ec: 29 c1                       	subl	%eax, %ecx
1803475ee: d3 c2                       	roll	%cl, %edx
1803475f0: d3 c2                       	roll	%cl, %edx
1803475f2: 48 63 c2                    	movslq	%edx, %rax
1803475f5: 48 8d 8d a0 09 00 00        	leaq	0x9a0(%rbp), %rcx
1803475fc: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347600: 48 63 05 31 0e 48 00        	movslq	0x480e31(%rip), %rax    # 0x1807c8438
180347607: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
18034760a: b9 0a 00 00 00              	movl	$0xa, %ecx
18034760f: 29 c1                       	subl	%eax, %ecx
180347611: d3 c2                       	roll	%cl, %edx
180347613: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347619: d3 ca                       	rorl	%cl, %edx
18034761b: d3 ca                       	rorl	%cl, %edx
18034761d: d3 ca                       	rorl	%cl, %edx
18034761f: 48 63 c2                    	movslq	%edx, %rax
180347622: 31 d2                       	xorl	%edx, %edx
180347624: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347628: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
18034762e: d3 ca                       	rorl	%cl, %edx
180347630: d3 ca                       	rorl	%cl, %edx
180347632: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347638: d3 ca                       	rorl	%cl, %edx
18034763a: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
18034763f: 29 c1                       	subl	%eax, %ecx
180347641: d3 c2                       	roll	%cl, %edx
180347643: d3 c2                       	roll	%cl, %edx
180347645: 48 63 c2                    	movslq	%edx, %rax
180347648: 48 8d 8d 00 06 00 00        	leaq	0x600(%rbp), %rcx
18034764f: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347653: 48 63 05 fa 0d 48 00        	movslq	0x480dfa(%rip), %rax    # 0x1807c8454
18034765a: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
18034765d: b9 0a 00 00 00              	movl	$0xa, %ecx
180347662: 29 c1                       	subl	%eax, %ecx
180347664: d3 c2                       	roll	%cl, %edx
180347666: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
18034766c: d3 ca                       	rorl	%cl, %edx
18034766e: d3 ca                       	rorl	%cl, %edx
180347670: d3 ca                       	rorl	%cl, %edx
180347672: 48 63 c2                    	movslq	%edx, %rax
180347675: 31 d2                       	xorl	%edx, %edx
180347677: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
18034767b: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347681: d3 ca                       	rorl	%cl, %edx
180347683: d3 ca                       	rorl	%cl, %edx
180347685: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
18034768b: d3 ca                       	rorl	%cl, %edx
18034768d: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347692: 29 c1                       	subl	%eax, %ecx
180347694: d3 c2                       	roll	%cl, %edx
180347696: d3 c2                       	roll	%cl, %edx
180347698: 48 63 c2                    	movslq	%edx, %rax
18034769b: 48 8d 8d 60 09 00 00        	leaq	0x960(%rbp), %rcx
1803476a2: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803476a6: 48 63 05 cb 0d 48 00        	movslq	0x480dcb(%rip), %rax    # 0x1807c8478
1803476ad: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803476b0: b9 0a 00 00 00              	movl	$0xa, %ecx
1803476b5: 29 c1                       	subl	%eax, %ecx
1803476b7: d3 c2                       	roll	%cl, %edx
1803476b9: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803476bf: d3 ca                       	rorl	%cl, %edx
1803476c1: d3 ca                       	rorl	%cl, %edx
1803476c3: d3 ca                       	rorl	%cl, %edx
1803476c5: 48 63 c2                    	movslq	%edx, %rax
1803476c8: 31 d2                       	xorl	%edx, %edx
1803476ca: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
1803476ce: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803476d4: d3 ca                       	rorl	%cl, %edx
1803476d6: d3 ca                       	rorl	%cl, %edx
1803476d8: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803476de: d3 ca                       	rorl	%cl, %edx
1803476e0: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803476e5: 29 c1                       	subl	%eax, %ecx
1803476e7: d3 c2                       	roll	%cl, %edx
1803476e9: d3 c2                       	roll	%cl, %edx
1803476eb: 48 63 c2                    	movslq	%edx, %rax
1803476ee: 48 8d 8d 40 04 00 00        	leaq	0x440(%rbp), %rcx
1803476f5: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803476f9: 48 63 05 a4 0d 48 00        	movslq	0x480da4(%rip), %rax    # 0x1807c84a4
180347700: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347703: b9 0a 00 00 00              	movl	$0xa, %ecx
180347708: 29 c1                       	subl	%eax, %ecx
18034770a: d3 c2                       	roll	%cl, %edx
18034770c: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347712: d3 ca                       	rorl	%cl, %edx
180347714: d3 ca                       	rorl	%cl, %edx
180347716: d3 ca                       	rorl	%cl, %edx
180347718: 48 63 c2                    	movslq	%edx, %rax
18034771b: 31 d2                       	xorl	%edx, %edx
18034771d: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347721: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347727: d3 ca                       	rorl	%cl, %edx
180347729: d3 ca                       	rorl	%cl, %edx
18034772b: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347731: d3 ca                       	rorl	%cl, %edx
180347733: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347738: 29 c1                       	subl	%eax, %ecx
18034773a: d3 c2                       	roll	%cl, %edx
18034773c: d3 c2                       	roll	%cl, %edx
18034773e: 48 63 c2                    	movslq	%edx, %rax
180347741: 48 8d 8d 60 04 00 00        	leaq	0x460(%rbp), %rcx
180347748: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
18034774c: 48 63 05 11 0d 48 00        	movslq	0x480d11(%rip), %rax    # 0x1807c8464
180347753: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347756: b9 0a 00 00 00              	movl	$0xa, %ecx
18034775b: 29 c1                       	subl	%eax, %ecx
18034775d: d3 c2                       	roll	%cl, %edx
18034775f: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347765: d3 ca                       	rorl	%cl, %edx
180347767: d3 ca                       	rorl	%cl, %edx
180347769: d3 ca                       	rorl	%cl, %edx
18034776b: 48 63 c2                    	movslq	%edx, %rax
18034776e: 31 d2                       	xorl	%edx, %edx
180347770: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347774: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
18034777a: d3 ca                       	rorl	%cl, %edx
18034777c: d3 ca                       	rorl	%cl, %edx
18034777e: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347784: d3 ca                       	rorl	%cl, %edx
180347786: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
18034778b: 29 c1                       	subl	%eax, %ecx
18034778d: d3 c2                       	roll	%cl, %edx
18034778f: d3 c2                       	roll	%cl, %edx
180347791: 48 63 c2                    	movslq	%edx, %rax
180347794: 48 8d 8d 20 06 00 00        	leaq	0x620(%rbp), %rcx
18034779b: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
18034779f: 48 63 05 ce 0c 48 00        	movslq	0x480cce(%rip), %rax    # 0x1807c8474
1803477a6: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803477a9: b9 0a 00 00 00              	movl	$0xa, %ecx
1803477ae: 29 c1                       	subl	%eax, %ecx
1803477b0: d3 c2                       	roll	%cl, %edx
1803477b2: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803477b8: d3 ca                       	rorl	%cl, %edx
1803477ba: d3 ca                       	rorl	%cl, %edx
1803477bc: d3 ca                       	rorl	%cl, %edx
1803477be: 48 63 c2                    	movslq	%edx, %rax
1803477c1: 31 d2                       	xorl	%edx, %edx
1803477c3: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
1803477c7: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803477cd: d3 ca                       	rorl	%cl, %edx
1803477cf: d3 ca                       	rorl	%cl, %edx
1803477d1: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803477d7: d3 ca                       	rorl	%cl, %edx
1803477d9: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803477de: 29 c1                       	subl	%eax, %ecx
1803477e0: d3 c2                       	roll	%cl, %edx
1803477e2: d3 c2                       	roll	%cl, %edx
1803477e4: 48 63 c2                    	movslq	%edx, %rax
1803477e7: 48 8d 8d 40 06 00 00        	leaq	0x640(%rbp), %rcx
1803477ee: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803477f2: 48 63 05 cb 0b 48 00        	movslq	0x480bcb(%rip), %rax    # 0x1807c83c4
1803477f9: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803477fc: b9 0a 00 00 00              	movl	$0xa, %ecx
180347801: 29 c1                       	subl	%eax, %ecx
180347803: d3 c2                       	roll	%cl, %edx
180347805: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
18034780b: d3 ca                       	rorl	%cl, %edx
18034780d: d3 ca                       	rorl	%cl, %edx
18034780f: d3 ca                       	rorl	%cl, %edx
180347811: 48 63 c2                    	movslq	%edx, %rax
180347814: 31 d2                       	xorl	%edx, %edx
180347816: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
18034781a: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347820: d3 ca                       	rorl	%cl, %edx
180347822: d3 ca                       	rorl	%cl, %edx
180347824: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
18034782a: d3 ca                       	rorl	%cl, %edx
18034782c: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347831: 29 c1                       	subl	%eax, %ecx
180347833: d3 c2                       	roll	%cl, %edx
180347835: d3 c2                       	roll	%cl, %edx
180347837: 48 63 c2                    	movslq	%edx, %rax
18034783a: 48 8d 8d 60 06 00 00        	leaq	0x660(%rbp), %rcx
180347841: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347845: 48 63 05 70 0c 48 00        	movslq	0x480c70(%rip), %rax    # 0x1807c84bc
18034784c: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
18034784f: b9 0a 00 00 00              	movl	$0xa, %ecx
180347854: 29 c1                       	subl	%eax, %ecx
180347856: d3 c2                       	roll	%cl, %edx
180347858: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
18034785e: d3 ca                       	rorl	%cl, %edx
180347860: d3 ca                       	rorl	%cl, %edx
180347862: d3 ca                       	rorl	%cl, %edx
180347864: 48 63 c2                    	movslq	%edx, %rax
180347867: 31 d2                       	xorl	%edx, %edx
180347869: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
18034786d: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347873: d3 ca                       	rorl	%cl, %edx
180347875: d3 ca                       	rorl	%cl, %edx
180347877: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
18034787d: d3 ca                       	rorl	%cl, %edx
18034787f: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347884: 29 c1                       	subl	%eax, %ecx
180347886: d3 c2                       	roll	%cl, %edx
180347888: d3 c2                       	roll	%cl, %edx
18034788a: 48 63 c2                    	movslq	%edx, %rax
18034788d: 48 8d 8d b0 07 00 00        	leaq	0x7b0(%rbp), %rcx
180347894: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347898: 48 63 05 85 0c 48 00        	movslq	0x480c85(%rip), %rax    # 0x1807c8524
18034789f: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803478a2: b9 0a 00 00 00              	movl	$0xa, %ecx
1803478a7: 29 c1                       	subl	%eax, %ecx
1803478a9: d3 c2                       	roll	%cl, %edx
1803478ab: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803478b1: d3 ca                       	rorl	%cl, %edx
1803478b3: d3 ca                       	rorl	%cl, %edx
1803478b5: d3 ca                       	rorl	%cl, %edx
1803478b7: 48 63 c2                    	movslq	%edx, %rax
1803478ba: 31 d2                       	xorl	%edx, %edx
1803478bc: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
1803478c0: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803478c6: d3 ca                       	rorl	%cl, %edx
1803478c8: d3 ca                       	rorl	%cl, %edx
1803478ca: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803478d0: d3 ca                       	rorl	%cl, %edx
1803478d2: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803478d7: 29 c1                       	subl	%eax, %ecx
1803478d9: d3 c2                       	roll	%cl, %edx
1803478db: d3 c2                       	roll	%cl, %edx
1803478dd: 48 63 c2                    	movslq	%edx, %rax
1803478e0: 48 8d 8d d0 07 00 00        	leaq	0x7d0(%rbp), %rcx
1803478e7: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803478eb: 48 63 05 3a 0c 48 00        	movslq	0x480c3a(%rip), %rax    # 0x1807c852c
1803478f2: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803478f5: b9 0a 00 00 00              	movl	$0xa, %ecx
1803478fa: 29 c1                       	subl	%eax, %ecx
1803478fc: d3 c2                       	roll	%cl, %edx
1803478fe: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347904: d3 ca                       	rorl	%cl, %edx
180347906: d3 ca                       	rorl	%cl, %edx
180347908: d3 ca                       	rorl	%cl, %edx
18034790a: 48 63 c2                    	movslq	%edx, %rax
18034790d: 31 d2                       	xorl	%edx, %edx
18034790f: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347913: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347919: d3 ca                       	rorl	%cl, %edx
18034791b: d3 ca                       	rorl	%cl, %edx
18034791d: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347923: d3 ca                       	rorl	%cl, %edx
180347925: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
18034792a: 29 c1                       	subl	%eax, %ecx
18034792c: d3 c2                       	roll	%cl, %edx
18034792e: d3 c2                       	roll	%cl, %edx
180347930: 48 63 c2                    	movslq	%edx, %rax
180347933: 48 8d 8d c0 03 00 00        	leaq	0x3c0(%rbp), %rcx
18034793a: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
18034793e: 48 63 05 8f 0b 48 00        	movslq	0x480b8f(%rip), %rax    # 0x1807c84d4
180347945: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347948: b9 0a 00 00 00              	movl	$0xa, %ecx
18034794d: 29 c1                       	subl	%eax, %ecx
18034794f: d3 c2                       	roll	%cl, %edx
180347951: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347957: d3 ca                       	rorl	%cl, %edx
180347959: d3 ca                       	rorl	%cl, %edx
18034795b: d3 ca                       	rorl	%cl, %edx
18034795d: 48 63 c2                    	movslq	%edx, %rax
180347960: 31 d2                       	xorl	%edx, %edx
180347962: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347966: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
18034796c: d3 ca                       	rorl	%cl, %edx
18034796e: d3 ca                       	rorl	%cl, %edx
180347970: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347976: d3 ca                       	rorl	%cl, %edx
180347978: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
18034797d: 29 c1                       	subl	%eax, %ecx
18034797f: d3 c2                       	roll	%cl, %edx
180347981: d3 c2                       	roll	%cl, %edx
180347983: 48 63 c2                    	movslq	%edx, %rax
180347986: 48 8d 8d e0 03 00 00        	leaq	0x3e0(%rbp), %rcx
18034798d: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347991: 48 63 05 d0 0b 48 00        	movslq	0x480bd0(%rip), %rax    # 0x1807c8568
180347998: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
18034799b: b9 0a 00 00 00              	movl	$0xa, %ecx
1803479a0: 29 c1                       	subl	%eax, %ecx
1803479a2: d3 c2                       	roll	%cl, %edx
1803479a4: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803479aa: d3 ca                       	rorl	%cl, %edx
1803479ac: d3 ca                       	rorl	%cl, %edx
1803479ae: d3 ca                       	rorl	%cl, %edx
1803479b0: 48 63 c2                    	movslq	%edx, %rax
1803479b3: 31 d2                       	xorl	%edx, %edx
1803479b5: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
1803479b9: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
1803479bf: d3 ca                       	rorl	%cl, %edx
1803479c1: d3 ca                       	rorl	%cl, %edx
1803479c3: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
1803479c9: d3 ca                       	rorl	%cl, %edx
1803479cb: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
1803479d0: 29 c1                       	subl	%eax, %ecx
1803479d2: d3 c2                       	roll	%cl, %edx
1803479d4: d3 c2                       	roll	%cl, %edx
1803479d6: 48 63 c2                    	movslq	%edx, %rax
1803479d9: 48 8d 8d 00 04 00 00        	leaq	0x400(%rbp), %rcx
1803479e0: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
1803479e4: 48 63 05 c5 0a 48 00        	movslq	0x480ac5(%rip), %rax    # 0x1807c84b0
1803479eb: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
1803479ee: b9 0a 00 00 00              	movl	$0xa, %ecx
1803479f3: 29 c1                       	subl	%eax, %ecx
1803479f5: d3 c2                       	roll	%cl, %edx
1803479f7: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
1803479fd: d3 ca                       	rorl	%cl, %edx
1803479ff: d3 ca                       	rorl	%cl, %edx
180347a01: d3 ca                       	rorl	%cl, %edx
180347a03: 48 63 c2                    	movslq	%edx, %rax
180347a06: 31 d2                       	xorl	%edx, %edx
180347a08: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347a0c: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347a12: d3 ca                       	rorl	%cl, %edx
180347a14: d3 ca                       	rorl	%cl, %edx
180347a16: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347a1c: d3 ca                       	rorl	%cl, %edx
180347a1e: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347a23: 29 c1                       	subl	%eax, %ecx
180347a25: d3 c2                       	roll	%cl, %edx
180347a27: d3 c2                       	roll	%cl, %edx
180347a29: 48 63 c2                    	movslq	%edx, %rax
180347a2c: 48 8d 8d 90 00 00 00        	leaq	0x90(%rbp), %rcx
180347a33: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347a37: 48 63 05 6e 0a 48 00        	movslq	0x480a6e(%rip), %rax    # 0x1807c84ac
180347a3e: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347a41: b9 0a 00 00 00              	movl	$0xa, %ecx
180347a46: 29 c1                       	subl	%eax, %ecx
180347a48: d3 c2                       	roll	%cl, %edx
180347a4a: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347a50: d3 ca                       	rorl	%cl, %edx
180347a52: d3 ca                       	rorl	%cl, %edx
180347a54: d3 ca                       	rorl	%cl, %edx
180347a56: 48 63 c2                    	movslq	%edx, %rax
180347a59: 31 d2                       	xorl	%edx, %edx
180347a5b: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347a5f: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347a65: d3 ca                       	rorl	%cl, %edx
180347a67: d3 ca                       	rorl	%cl, %edx
180347a69: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347a6f: d3 ca                       	rorl	%cl, %edx
180347a71: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347a76: 29 c1                       	subl	%eax, %ecx
180347a78: d3 c2                       	roll	%cl, %edx
180347a7a: d3 c2                       	roll	%cl, %edx
180347a7c: 48 63 c2                    	movslq	%edx, %rax
180347a7f: 48 8d 8d b0 00 00 00        	leaq	0xb0(%rbp), %rcx
180347a86: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347a8a: 48 63 05 7f 0a 48 00        	movslq	0x480a7f(%rip), %rax    # 0x1807c8510
180347a91: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347a94: b9 0a 00 00 00              	movl	$0xa, %ecx
180347a99: 29 c1                       	subl	%eax, %ecx
180347a9b: d3 c2                       	roll	%cl, %edx
180347a9d: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347aa3: d3 ca                       	rorl	%cl, %edx
180347aa5: d3 ca                       	rorl	%cl, %edx
180347aa7: d3 ca                       	rorl	%cl, %edx
180347aa9: 48 63 c2                    	movslq	%edx, %rax
180347aac: 31 d2                       	xorl	%edx, %edx
180347aae: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347ab2: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347ab8: d3 ca                       	rorl	%cl, %edx
180347aba: d3 ca                       	rorl	%cl, %edx
180347abc: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347ac2: d3 ca                       	rorl	%cl, %edx
180347ac4: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347ac9: 29 c1                       	subl	%eax, %ecx
180347acb: d3 c2                       	roll	%cl, %edx
180347acd: d3 c2                       	roll	%cl, %edx
180347acf: 48 63 c2                    	movslq	%edx, %rax
180347ad2: 48 8d 8d d0 00 00 00        	leaq	0xd0(%rbp), %rcx
180347ad9: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347add: 48 63 05 1c 0a 48 00        	movslq	0x480a1c(%rip), %rax    # 0x1807c8500
180347ae4: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347ae7: b9 0a 00 00 00              	movl	$0xa, %ecx
180347aec: 29 c1                       	subl	%eax, %ecx
180347aee: d3 c2                       	roll	%cl, %edx
180347af0: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347af6: d3 ca                       	rorl	%cl, %edx
180347af8: d3 ca                       	rorl	%cl, %edx
180347afa: d3 ca                       	rorl	%cl, %edx
180347afc: 48 63 c2                    	movslq	%edx, %rax
180347aff: 31 d2                       	xorl	%edx, %edx
180347b01: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347b05: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347b0b: d3 ca                       	rorl	%cl, %edx
180347b0d: d3 ca                       	rorl	%cl, %edx
180347b0f: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347b15: d3 ca                       	rorl	%cl, %edx
180347b17: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347b1c: 29 c1                       	subl	%eax, %ecx
180347b1e: d3 c2                       	roll	%cl, %edx
180347b20: d3 c2                       	roll	%cl, %edx
180347b22: 48 63 c2                    	movslq	%edx, %rax
180347b25: 48 8d 8d f0 00 00 00        	leaq	0xf0(%rbp), %rcx
180347b2c: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347b30: 48 63 05 b1 09 48 00        	movslq	0x4809b1(%rip), %rax    # 0x1807c84e8
180347b37: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347b3a: b9 0a 00 00 00              	movl	$0xa, %ecx
180347b3f: 29 c1                       	subl	%eax, %ecx
180347b41: d3 c2                       	roll	%cl, %edx
180347b43: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347b49: d3 ca                       	rorl	%cl, %edx
180347b4b: d3 ca                       	rorl	%cl, %edx
180347b4d: d3 ca                       	rorl	%cl, %edx
180347b4f: 48 63 c2                    	movslq	%edx, %rax
180347b52: 31 d2                       	xorl	%edx, %edx
180347b54: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347b58: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347b5e: d3 ca                       	rorl	%cl, %edx
180347b60: d3 ca                       	rorl	%cl, %edx
180347b62: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347b68: d3 ca                       	rorl	%cl, %edx
180347b6a: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347b6f: 29 c1                       	subl	%eax, %ecx
180347b71: d3 c2                       	roll	%cl, %edx
180347b73: d3 c2                       	roll	%cl, %edx
180347b75: 48 63 c2                    	movslq	%edx, %rax
180347b78: 48 8d 8d 10 01 00 00        	leaq	0x110(%rbp), %rcx
180347b7f: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347b83: 48 63 05 3a 09 48 00        	movslq	0x48093a(%rip), %rax    # 0x1807c84c4
180347b8a: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347b8d: b9 0a 00 00 00              	movl	$0xa, %ecx
180347b92: 29 c1                       	subl	%eax, %ecx
180347b94: d3 c2                       	roll	%cl, %edx
180347b96: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347b9c: d3 ca                       	rorl	%cl, %edx
180347b9e: d3 ca                       	rorl	%cl, %edx
180347ba0: d3 ca                       	rorl	%cl, %edx
180347ba2: 48 63 c2                    	movslq	%edx, %rax
180347ba5: 31 d2                       	xorl	%edx, %edx
180347ba7: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347bab: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347bb1: d3 ca                       	rorl	%cl, %edx
180347bb3: d3 ca                       	rorl	%cl, %edx
180347bb5: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347bbb: d3 ca                       	rorl	%cl, %edx
180347bbd: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347bc2: 29 c1                       	subl	%eax, %ecx
180347bc4: d3 c2                       	roll	%cl, %edx
180347bc6: d3 c2                       	roll	%cl, %edx
180347bc8: 48 63 c2                    	movslq	%edx, %rax
180347bcb: 48 8d 8d 30 01 00 00        	leaq	0x130(%rbp), %rcx
180347bd2: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347bd6: 48 63 05 9f 09 48 00        	movslq	0x48099f(%rip), %rax    # 0x1807c857c
180347bdd: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347be0: b9 0a 00 00 00              	movl	$0xa, %ecx
180347be5: 29 c1                       	subl	%eax, %ecx
180347be7: d3 c2                       	roll	%cl, %edx
180347be9: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347bef: d3 ca                       	rorl	%cl, %edx
180347bf1: d3 ca                       	rorl	%cl, %edx
180347bf3: d3 ca                       	rorl	%cl, %edx
180347bf5: 48 63 c2                    	movslq	%edx, %rax
180347bf8: 31 d2                       	xorl	%edx, %edx
180347bfa: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347bfe: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347c04: d3 ca                       	rorl	%cl, %edx
180347c06: d3 ca                       	rorl	%cl, %edx
180347c08: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347c0e: d3 ca                       	rorl	%cl, %edx
180347c10: b9 d0 45 48 92              	movl	$0x924845d0, %ecx       # imm = 0x924845D0
180347c15: 29 c1                       	subl	%eax, %ecx
180347c17: d3 c2                       	roll	%cl, %edx
180347c19: d3 c2                       	roll	%cl, %edx
180347c1b: 48 63 c2                    	movslq	%edx, %rax
180347c1e: 48 8d 8d 50 01 00 00        	leaq	0x150(%rbp), %rcx
180347c25: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347c29: 48 63 05 24 09 48 00        	movslq	0x480924(%rip), %rax    # 0x1807c8554
180347c30: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347c33: 29 c3                       	subl	%eax, %ebx
180347c35: 89 d9                       	movl	%ebx, %ecx
180347c37: d3 c2                       	roll	%cl, %edx
180347c39: 8d 88 2a e2 03 e4           	leal	-0x1bfc1dd6(%rax), %ecx
180347c3f: d3 ca                       	rorl	%cl, %edx
180347c41: d3 ca                       	rorl	%cl, %edx
180347c43: d3 ca                       	rorl	%cl, %edx
180347c45: 48 63 c2                    	movslq	%edx, %rax
180347c48: 31 d2                       	xorl	%edx, %edx
180347c4a: 41 2b 14 84                 	subl	(%r12,%rax,4), %edx
180347c4e: 8d 88 d0 45 48 92           	leal	-0x6db7ba30(%rax), %ecx
180347c54: d3 ca                       	rorl	%cl, %edx
180347c56: d3 ca                       	rorl	%cl, %edx
180347c58: 81 f2 2f ba b7 6d           	xorl	$0x6db7ba2f, %edx       # imm = 0x6DB7BA2F
180347c5e: d3 ca                       	rorl	%cl, %edx
180347c60: 29 c6                       	subl	%eax, %esi
180347c62: 89 f1                       	movl	%esi, %ecx
180347c64: d3 c2                       	roll	%cl, %edx
180347c66: d3 c2                       	roll	%cl, %edx
180347c68: 48 63 c2                    	movslq	%edx, %rax
180347c6b: 48 8d 8d 70 0b 00 00        	leaq	0xb70(%rbp), %rcx
180347c72: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347c76: 48 8d 8d 70 0b 00 00        	leaq	0xb70(%rbp), %rcx
180347c7d: 48 8d 95 60 02 00 00        	leaq	0x260(%rbp), %rdx
180347c84: e8 c7 55 16 00              	callq	0x1804ad250 <.text+0x49d250>
180347c89: 48 63 05 38 08 48 00        	movslq	0x480838(%rip), %rax    # 0x1807c84c8
180347c90: 48 8d 0d e9 15 31 00        	leaq	0x3115e9(%rip), %rcx    # 0x180659280
180347c97: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
180347c9a: 0f ca                       	bswapl	%edx
180347c9c: 8d 88 b2 7c 96 f0           	leal	-0xf69834e(%rax), %ecx
180347ca2: d3 ca                       	rorl	%cl, %edx
180347ca4: d3 ca                       	rorl	%cl, %edx
180347ca6: d3 ca                       	rorl	%cl, %edx
180347ca8: 48 63 c2                    	movslq	%edx, %rax
180347cab: 31 d2                       	xorl	%edx, %edx
180347cad: 48 8d 0d 1c be 47 00        	leaq	0x47be1c(%rip), %rcx    # 0x1807c3ad0
180347cb4: 2b 14 81                    	subl	(%rcx,%rax,4), %edx
180347cb7: 81 f2 8b c2 17 e7           	xorl	$0xe717c28b, %edx       # imm = 0xE717C28B
180347cbd: 0f ca                       	bswapl	%edx
180347cbf: b9 8b c2 17 e7              	movl	$0xe717c28b, %ecx       # imm = 0xE717C28B
180347cc4: 29 c1                       	subl	%eax, %ecx
180347cc6: d3 c2                       	roll	%cl, %edx
180347cc8: d3 c2                       	roll	%cl, %edx
180347cca: 81 f2 8b c2 17 e7           	xorl	$0xe717c28b, %edx       # imm = 0xE717C28B
180347cd0: 48 63 c2                    	movslq	%edx, %rax
180347cd3: 48 8d 8d 70 0b 00 00        	leaq	0xb70(%rbp), %rcx
180347cda: 48 8d 15 8f 5f 47 00        	leaq	0x475f8f(%rip), %rdx    # 0x1807bdc70
180347ce1: ff 14 c2                    	callq	*(%rdx,%rax,8)
180347ce4: 48 b9 57 92 d1 fb e6 67 a7 c8       	movabsq	$-0x37589819042e6da9, %rcx # imm = 0xC8A767E6FBD19257
180347cee: 48 33 0d 53 8d 46 00        	xorq	0x468d53(%rip), %rcx    # 0x1807b0a48
180347cf5: 48 ba b6 b0 ce 04 7e a7 20 f3       	movabsq	$-0xcdf5881fb314f4a, %rdx # imm = 0xF320A77E04CEB0B6
180347cff: 48 01 ca                    	addq	%rcx, %rdx
180347d02: 48 39 d0                    	cmpq	%rdx, %rax
180347d05: 0f 85 6f 07 00 00           	jne	0x18034847a <.text+0x33847a>
180347d0b: 48 63 05 ba 07 48 00        	movslq	0x4807ba(%rip), %rax    # 0x1807c84cc
180347d12: 48 8d 3d 67 15 31 00        	leaq	0x311567(%rip), %rdi    # 0x180659280
180347d19: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180347d1c: b9 02 00 00 00              	movl	$0x2, %ecx
180347d21: 29 c1                       	subl	%eax, %ecx
180347d23: d3 c2                       	roll	%cl, %edx
180347d25: 0f ca                       	bswapl	%edx
180347d27: f7 da                       	negl	%edx
180347d29: 81 f2 22 20 de 1b           	xorl	$0x1bde2022, %edx       # imm = 0x1BDE2022
180347d2f: 48 63 c2                    	movslq	%edx, %rax
180347d32: 4c 8d 25 97 bd 47 00        	leaq	0x47bd97(%rip), %r12    # 0x1807c3ad0
180347d39: 41 8b 14 84                 	movl	(%r12,%rax,4), %edx
180347d3d: 8d 88 32 fb ab 4e           	leal	0x4eabfb32(%rax), %ecx
180347d43: d3 ca                       	rorl	%cl, %edx
180347d45: 81 f2 32 fb ab 4e           	xorl	$0x4eabfb32, %edx       # imm = 0x4EABFB32
180347d4b: d3 ca                       	rorl	%cl, %edx
180347d4d: b9 12 00 00 00              	movl	$0x12, %ecx
180347d52: 29 c1                       	subl	%eax, %ecx
180347d54: d3 c2                       	roll	%cl, %edx
180347d56: be 02 00 00 00              	movl	$0x2, %esi
180347d5b: 81 f2 cd 04 54 b1           	xorl	$0xb15404cd, %edx       # imm = 0xB15404CD
180347d61: 48 63 c2                    	movslq	%edx, %rax
180347d64: 4c 8d b5 70 01 00 00        	leaq	0x170(%rbp), %r14
180347d6b: 4c 89 f1                    	movq	%r14, %rcx
180347d6e: 4c 8d 3d fb 5e 47 00        	leaq	0x475efb(%rip), %r15    # 0x1807bdc70
180347d75: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347d79: 48 63 15 8c 07 48 00        	movslq	0x48078c(%rip), %rdx    # 0x1807c850c
180347d80: 44 8b 04 97                 	movl	(%rdi,%rdx,4), %r8d
180347d84: b9 ae 3a 60 a0              	movl	$0xa0603aae, %ecx       # imm = 0xA0603AAE
180347d89: 29 d1                       	subl	%edx, %ecx
180347d8b: 41 d3 c0                    	roll	%cl, %r8d
180347d8e: 41 0f c8                    	bswapl	%r8d
180347d91: 41 d3 c0                    	roll	%cl, %r8d
180347d94: 41 0f c8                    	bswapl	%r8d
180347d97: 49 63 d0                    	movslq	%r8d, %rdx
180347d9a: 45 31 c9                    	xorl	%r9d, %r9d
180347d9d: 45 2b 0c 94                 	subl	(%r12,%rdx,4), %r9d
180347da1: 41 b8 74 05 cc 07           	movl	$0x7cc0574, %r8d        # imm = 0x7CC0574
180347da7: 41 29 d0                    	subl	%edx, %r8d
180347daa: 44 89 c1                    	movl	%r8d, %ecx
180347dad: 41 d3 c1                    	roll	%cl, %r9d
180347db0: 48 89 c3                    	movq	%rax, %rbx
180347db3: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
180347dbd: 83 c2 14                    	addl	$0x14, %edx
180347dc0: 89 d1                       	movl	%edx, %ecx
180347dc2: 41 d3 c9                    	rorl	%cl, %r9d
180347dc5: 44 89 c1                    	movl	%r8d, %ecx
180347dc8: 41 d3 c1                    	roll	%cl, %r9d
180347dcb: 49 63 c1                    	movslq	%r9d, %rax
180347dce: 4c 89 f1                    	movq	%r14, %rcx
180347dd1: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347dd5: 48 63 0d 38 07 48 00        	movslq	0x480738(%rip), %rcx    # 0x1807c8514
180347ddc: 8b 14 8f                    	movl	(%rdi,%rcx,4), %edx
180347ddf: 83 c1 0d                    	addl	$0xd, %ecx
180347de2: d3 ca                       	rorl	%cl, %edx
180347de4: 81 f2 ed ff 22 ce           	xorl	$0xce22ffed, %edx       # imm = 0xCE22FFED
180347dea: 4c 63 c2                    	movslq	%edx, %r8
180347ded: 47 8b 0c 84                 	movl	(%r12,%r8,4), %r9d
180347df1: 41 0f c9                    	bswapl	%r9d
180347df4: 41 f7 d9                    	negl	%r9d
180347df7: 41 8d 90 29 69 a3 e5        	leal	-0x1a5c96d7(%r8), %edx
180347dfe: 89 d1                       	movl	%edx, %ecx
180347e00: 41 d3 c9                    	rorl	%cl, %r9d
180347e03: b9 09 00 00 00              	movl	$0x9, %ecx
180347e08: 44 29 c1                    	subl	%r8d, %ecx
180347e0b: 41 d3 c1                    	roll	%cl, %r9d
180347e0e: 89 d1                       	movl	%edx, %ecx
180347e10: 41 d3 c9                    	rorl	%cl, %r9d
180347e13: 49 89 c6                    	movq	%rax, %r14
180347e16: 41 81 f1 29 69 a3 e5        	xorl	$0xe5a36929, %r9d       # imm = 0xE5A36929
180347e1d: 49 63 c1                    	movslq	%r9d, %rax
180347e20: 48 8d 8d 70 0b 00 00        	leaq	0xb70(%rbp), %rcx
180347e27: 41 ff 14 c7                 	callq	*(%r15,%rax,8)
180347e2b: 48 63 0d da 07 48 00        	movslq	0x4807da(%rip), %rcx    # 0x1807c860c
180347e32: 8b 14 8f                    	movl	(%rdi,%rcx,4), %edx
180347e35: f7 d2                       	notl	%edx
180347e37: 29 ce                       	subl	%ecx, %esi
180347e39: 89 f1                       	movl	%esi, %ecx
180347e3b: d3 c2                       	roll	%cl, %edx
180347e3d: 81 f2 bd 05 bb 41           	xorl	$0x41bb05bd, %edx       # imm = 0x41BB05BD
180347e43: 48 63 d2                    	movslq	%edx, %rdx
180347e46: 45 8b 04 94                 	movl	(%r12,%rdx,4), %r8d
180347e4a: b9 17 48 c5 88              	movl	$0x88c54817, %ecx       # imm = 0x88C54817
180347e4f: 29 d1                       	subl	%edx, %ecx
180347e51: 41 d3 c0                    	roll	%cl, %r8d
180347e54: 41 0f c8                    	bswapl	%r8d
180347e57: 41 d3 c0                    	roll	%cl, %r8d
180347e5a: 41 81 f0 88 c5 48 17        	xorl	$0x1748c588, %r8d       # imm = 0x1748C588
180347e61: 4d 63 d0                    	movslq	%r8d, %r10
180347e64: 48 8d 15 95 f9 30 00        	leaq	0x30f995(%rip), %rdx    # 0x180657800
180347e6b: 48 89 c1                    	movq	%rax, %rcx
180347e6e: 4d 89 f0                    	movq	%r14, %r8
180347e71: 49 89 d9                    	movq	%rbx, %r9
180347e74: 43 ff 14 d7                 	callq	*(%r15,%r10,8)
180347e78: b9 e0 df 0b 67              	movl	$0x670bdfe0, %ecx       # imm = 0x670BDFE0
180347e7d: 33 0d cd 8b 46 00           	xorl	0x468bcd(%rip), %ecx    # 0x1807b0a50
180347e83: 81 c1 c0 7b fc a8           	addl	$0xa8fc7bc0, %ecx       # imm = 0xA8FC7BC0
180347e89: 39 c8                       	cmpl	%ecx, %eax
180347e8b: 0f 85 f2 05 00 00           	jne	0x180348483 <.text+0x338483>
180347e91: 48 63 05 6c 07 48 00        	movslq	0x48076c(%rip), %rax    # 0x1807c8604
180347e98: ba d6 f5 38 77              	movl	$0x7738f5d6, %edx       # imm = 0x7738F5D6
180347e9d: 4c 8d 3d dc 13 31 00        	leaq	0x3113dc(%rip), %r15    # 0x180659280
180347ea4: 41 33 14 87                 	xorl	(%r15,%rax,4), %edx
180347ea8: 8d 88 d6 f5 38 77           	leal	0x7738f5d6(%rax), %ecx
180347eae: d3 ca                       	rorl	%cl, %edx
180347eb0: 81 f2 d6 f5 38 77           	xorl	$0x7738f5d6, %edx       # imm = 0x7738F5D6
180347eb6: d3 ca                       	rorl	%cl, %edx
180347eb8: 48 63 ca                    	movslq	%edx, %rcx
180347ebb: b8 89 a6 2a bd              	movl	$0xbd2aa689, %eax       # imm = 0xBD2AA689
180347ec0: 48 8d 3d 09 bc 47 00        	leaq	0x47bc09(%rip), %rdi    # 0x1807c3ad0
180347ec7: 33 04 8f                    	xorl	(%rdi,%rcx,4), %eax
180347eca: ff c8                       	decl	%eax
180347ecc: 35 76 59 d5 42              	xorl	$0x42d55976, %eax       # imm = 0x42D55976
180347ed1: ff c0                       	incl	%eax
180347ed3: 83 c1 09                    	addl	$0x9, %ecx
180347ed6: d3 c8                       	rorl	%cl, %eax
180347ed8: 48 98                       	cltq
180347eda: 48 8d b5 20 0b 00 00        	leaq	0xb20(%rbp), %rsi
180347ee1: 48 89 f1                    	movq	%rsi, %rcx
180347ee4: 4c 8d 25 85 5d 47 00        	leaq	0x475d85(%rip), %r12    # 0x1807bdc70
180347eeb: 41 ff 14 c4                 	callq	*(%r12,%rax,8)
180347eef: 48 63 15 2a 06 48 00        	movslq	0x48062a(%rip), %rdx    # 0x1807c8520
180347ef6: 41 8b 04 97                 	movl	(%r15,%rdx,4), %eax
180347efa: 0f c8                       	bswapl	%eax
180347efc: b9 18 00 00 00              	movl	$0x18, %ecx
180347f01: 29 d1                       	subl	%edx, %ecx
180347f03: d3 c0                       	roll	%cl, %eax
180347f05: 8d 48 01                    	leal	0x1(%rax), %ecx
180347f08: 48 63 c9                    	movslq	%ecx, %rcx
180347f0b: 8b 14 8f                    	movl	(%rdi,%rcx,4), %edx
180347f0e: 8d 88 19 a9 71 bd           	leal	-0x428e56e7(%rax), %ecx
180347f14: d3 ca                       	rorl	%cl, %edx
180347f16: f7 da                       	negl	%edx
180347f18: d3 ca                       	rorl	%cl, %edx
180347f1a: d3 ca                       	rorl	%cl, %edx
180347f1c: b9 17 00 00 00              	movl	$0x17, %ecx
180347f21: 29 c1                       	subl	%eax, %ecx
180347f23: d3 c2                       	roll	%cl, %edx
180347f25: 41 be 18 00 00 00           	movl	$0x18, %r14d
180347f2b: bb 17 00 00 00              	movl	$0x17, %ebx
180347f30: 0f ca                       	bswapl	%edx
180347f32: 48 63 c2                    	movslq	%edx, %rax
180347f35: 48 89 f1                    	movq	%rsi, %rcx
180347f38: 41 ff 14 c4                 	callq	*(%r12,%rax,8)
180347f3c: 48 63 0d 1d 03 48 00        	movslq	0x48031d(%rip), %rcx    # 0x1807c8260
180347f43: 41 8b 14 8f                 	movl	(%r15,%rcx,4), %edx
180347f47: 81 c1 b3 3a c7 db           	addl	$0xdbc73ab3, %ecx       # imm = 0xDBC73AB3
180347f4d: d3 ca                       	rorl	%cl, %edx
180347f4f: d3 ca                       	rorl	%cl, %edx
180347f51: 81 f2 db c7 3a b3           	xorl	$0xb33ac7db, %edx       # imm = 0xB33AC7DB
180347f57: 0f ca                       	bswapl	%edx
180347f59: 48 63 d2                    	movslq	%edx, %rdx
180347f5c: 45 31 c0                    	xorl	%r8d, %r8d
180347f5f: 44 2b 04 97                 	subl	(%rdi,%rdx,4), %r8d
180347f63: 41 0f c8                    	bswapl	%r8d
180347f66: be 11 39 22 28              	movl	$0x28223911, %esi       # imm = 0x28223911
180347f6b: b9 11 39 22 28              	movl	$0x28223911, %ecx       # imm = 0x28223911
180347f70: 29 d1                       	subl	%edx, %ecx
180347f72: 41 d3 c0                    	roll	%cl, %r8d
180347f75: 41 d3 c0                    	roll	%cl, %r8d
180347f78: 4d 63 c0                    	movslq	%r8d, %r8
180347f7b: 4c 8d 7d 70                 	leaq	0x70(%rbp), %r15
180347f7f: 4c 89 f9                    	movq	%r15, %rcx
180347f82: 48 89 c2                    	movq	%rax, %rdx
180347f85: 43 ff 14 c4                 	callq	*(%r12,%r8,8)
180347f89: 48 8d 85 d0 09 00 00        	leaq	0x9d0(%rbp), %rax
180347f90: 48 89 44 24 28              	movq	%rax, 0x28(%rsp)
180347f95: 48 8d 85 f0 09 00 00        	leaq	0x9f0(%rbp), %rax
180347f9c: 48 89 44 24 20              	movq	%rax, 0x20(%rsp)
180347fa1: 48 8d 8d 50 0c 00 00        	leaq	0xc50(%rbp), %rcx
180347fa8: 4c 8d 8d 10 0a 00 00        	leaq	0xa10(%rbp), %r9
180347faf: 48 8b 95 68 0b 00 00        	movq	0xb68(%rbp), %rdx
180347fb6: 4d 89 f8                    	movq	%r15, %r8
180347fb9: e8 92 52 fd ff              	callq	0x18031d250 <.text+0x30d250>
180347fbe: 0f 10 85 50 0c 00 00        	movups	0xc50(%rbp), %xmm0
180347fc5: 0f 10 8d 60 0c 00 00        	movups	0xc60(%rbp), %xmm1
180347fcc: 0f 29 8d 30 04 00 00        	movaps	%xmm1, 0x430(%rbp)
180347fd3: 0f 29 85 20 04 00 00        	movaps	%xmm0, 0x420(%rbp)
180347fda: 48 63 05 33 06 48 00        	movslq	0x480633(%rip), %rax    # 0x1807c8614
180347fe1: 31 c9                       	xorl	%ecx, %ecx
180347fe3: 48 8d 15 96 12 31 00        	leaq	0x311296(%rip), %rdx    # 0x180659280
180347fea: 2b 0c 82                    	subl	(%rdx,%rax,4), %ecx
180347fed: 81 f1 9e aa 1a 22           	xorl	$0x221aaa9e, %ecx       # imm = 0x221AAA9E
180347ff3: 48 63 c1                    	movslq	%ecx, %rax
180347ff6: 48 8d 3d d3 ba 47 00        	leaq	0x47bad3(%rip), %rdi    # 0x1807c3ad0
180347ffd: 44 8b 04 87                 	movl	(%rdi,%rax,4), %r8d
180348001: 41 0f c8                    	bswapl	%r8d
180348004: ba fb 28 f1 90              	movl	$0x90f128fb, %edx       # imm = 0x90F128FB
180348009: 29 c2                       	subl	%eax, %edx
18034800b: 89 d1                       	movl	%edx, %ecx
18034800d: 41 d3 c0                    	roll	%cl, %r8d
180348010: 41 81 f0 fb 28 f1 90        	xorl	$0x90f128fb, %r8d       # imm = 0x90F128FB
180348017: 05 fb 28 f1 90              	addl	$0x90f128fb, %eax       # imm = 0x90F128FB
18034801c: 89 c1                       	movl	%eax, %ecx
18034801e: 41 d3 c8                    	rorl	%cl, %r8d
180348021: 41 81 f0 fb 28 f1 90        	xorl	$0x90f128fb, %r8d       # imm = 0x90F128FB
180348028: 41 d3 c8                    	rorl	%cl, %r8d
18034802b: 45 31 e4                    	xorl	%r12d, %r12d
18034802e: 41 81 f0 fb 28 f1 90        	xorl	$0x90f128fb, %r8d       # imm = 0x90F128FB
180348035: 89 d1                       	movl	%edx, %ecx
180348037: 41 d3 c0                    	roll	%cl, %r8d
18034803a: 49 63 c0                    	movslq	%r8d, %rax
18034803d: 4c 8d bd 20 0b 00 00        	leaq	0xb20(%rbp), %r15
180348044: 4c 89 f9                    	movq	%r15, %rcx
180348047: 4c 8d 2d 22 5c 47 00        	leaq	0x475c22(%rip), %r13    # 0x1807bdc70
18034804e: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180348053: 48 63 05 ea 04 48 00        	movslq	0x4804ea(%rip), %rax    # 0x1807c8544
18034805a: 48 8d 3d 1f 12 31 00        	leaq	0x31121f(%rip), %rdi    # 0x180659280
180348061: 8b 14 87                    	movl	(%rdi,%rax,4), %edx
180348064: 0f ca                       	bswapl	%edx
180348066: 41 29 c6                    	subl	%eax, %r14d
180348069: 44 89 f1                    	movl	%r14d, %ecx
18034806c: d3 c2                       	roll	%cl, %edx
18034806e: 8d 42 01                    	leal	0x1(%rdx), %eax
180348071: 48 98                       	cltq
180348073: 4c 8d 35 56 ba 47 00        	leaq	0x47ba56(%rip), %r14    # 0x1807c3ad0
18034807a: 41 8b 04 86                 	movl	(%r14,%rax,4), %eax
18034807e: 8d 8a 19 a9 71 bd           	leal	-0x428e56e7(%rdx), %ecx
180348084: d3 c8                       	rorl	%cl, %eax
180348086: f7 d8                       	negl	%eax
180348088: d3 c8                       	rorl	%cl, %eax
18034808a: d3 c8                       	rorl	%cl, %eax
18034808c: 29 d3                       	subl	%edx, %ebx
18034808e: 89 d9                       	movl	%ebx, %ecx
180348090: d3 c0                       	roll	%cl, %eax
180348092: 0f c8                       	bswapl	%eax
180348094: 48 98                       	cltq
180348096: 4c 89 f9                    	movq	%r15, %rcx
180348099: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
18034809e: 48 63 0d b7 01 48 00        	movslq	0x4801b7(%rip), %rcx    # 0x1807c825c
1803480a5: 8b 14 8f                    	movl	(%rdi,%rcx,4), %edx
1803480a8: 81 c1 b3 3a c7 db           	addl	$0xdbc73ab3, %ecx       # imm = 0xDBC73AB3
1803480ae: d3 ca                       	rorl	%cl, %edx
1803480b0: d3 ca                       	rorl	%cl, %edx
1803480b2: 81 f2 db c7 3a b3           	xorl	$0xb33ac7db, %edx       # imm = 0xB33AC7DB
1803480b8: 0f ca                       	bswapl	%edx
1803480ba: 48 63 ca                    	movslq	%edx, %rcx
1803480bd: 31 d2                       	xorl	%edx, %edx
1803480bf: 41 2b 14 8e                 	subl	(%r14,%rcx,4), %edx
1803480c3: 0f ca                       	bswapl	%edx
1803480c5: 29 ce                       	subl	%ecx, %esi
1803480c7: 89 f1                       	movl	%esi, %ecx
1803480c9: d3 c2                       	roll	%cl, %edx
1803480cb: d3 c2                       	roll	%cl, %edx
1803480cd: 4c 63 c2                    	movslq	%edx, %r8
1803480d0: 48 8d b5 80 00 00 00        	leaq	0x80(%rbp), %rsi
1803480d7: 48 89 f1                    	movq	%rsi, %rcx
1803480da: 48 89 c2                    	movq	%rax, %rdx
1803480dd: 43 ff 54 c5 00              	callq	*(%r13,%r8,8)
1803480e2: 48 8d 85 d0 09 00 00        	leaq	0x9d0(%rbp), %rax
1803480e9: 48 89 44 24 28              	movq	%rax, 0x28(%rsp)
1803480ee: 48 8d 85 f0 09 00 00        	leaq	0x9f0(%rbp), %rax
1803480f5: 48 89 44 24 20              	movq	%rax, 0x20(%rsp)
1803480fa: 48 8d 8d 50 0c 00 00        	leaq	0xc50(%rbp), %rcx
180348101: 4c 8d 8d 10 0a 00 00        	leaq	0xa10(%rbp), %r9
180348108: 48 8b 95 68 0b 00 00        	movq	0xb68(%rbp), %rdx
18034810f: 49 89 f0                    	movq	%rsi, %r8
180348112: e8 39 51 fd ff              	callq	0x18031d250 <.text+0x30d250>
180348117: 0f 10 85 50 0c 00 00        	movups	0xc50(%rbp), %xmm0
18034811e: 0f 10 8d 60 0c 00 00        	movups	0xc60(%rbp), %xmm1
180348125: 0f 29 8d 70 08 00 00        	movaps	%xmm1, 0x870(%rbp)
18034812c: 0f 29 85 60 08 00 00        	movaps	%xmm0, 0x860(%rbp)
180348133: 48 63 05 1a 01 48 00        	movslq	0x48011a(%rip), %rax    # 0x1807c8254
18034813a: 31 c9                       	xorl	%ecx, %ecx
18034813c: 4c 8d 3d 3d 11 31 00        	leaq	0x31113d(%rip), %r15    # 0x180659280
180348143: 41 2b 0c 87                 	subl	(%r15,%rax,4), %ecx
180348147: 81 f1 68 a7 ba 0d           	xorl	$0xdbaa768, %ecx        # imm = 0xDBAA768
18034814d: 48 63 c9                    	movslq	%ecx, %rcx
180348150: bf 6d f2 72 cf              	movl	$0xcf72f26d, %edi       # imm = 0xCF72F26D
180348155: 4c 8d 35 74 b9 47 00        	leaq	0x47b974(%rip), %r14    # 0x1807c3ad0
18034815c: 41 8b 04 8e                 	movl	(%r14,%rcx,4), %eax
180348160: 31 f8                       	xorl	%edi, %eax
180348162: 81 c1 92 0d 8d 30           	addl	$0x308d0d92, %ecx       # imm = 0x308D0D92
180348168: d3 c8                       	rorl	%cl, %eax
18034816a: 48 8b 95 98 0c 00 00        	movq	0xc98(%rbp), %rdx
180348171: 48 8d b2 c9 02 00 00        	leaq	0x2c9(%rdx), %rsi
180348178: ff c8                       	decl	%eax
18034817a: d3 c8                       	rorl	%cl, %eax
18034817c: 48 98                       	cltq
18034817e: 48 8d 95 f0 07 00 00        	leaq	0x7f0(%rbp), %rdx
180348185: 48 89 f1                    	movq	%rsi, %rcx
180348188: 48 8d 1d e1 5a 47 00        	leaq	0x475ae1(%rip), %rbx    # 0x1807bdc70
18034818f: ff 14 c3                    	callq	*(%rbx,%rax,8)
180348192: 48 63 05 d7 03 48 00        	movslq	0x4803d7(%rip), %rax    # 0x1807c8570
180348199: 41 8b 04 87                 	movl	(%r15,%rax,4), %eax
18034819d: ff c0                       	incl	%eax
18034819f: 35 53 04 4d c1              	xorl	$0xc14d0453, %eax       # imm = 0xC14D0453
1803481a4: 8d 48 01                    	leal	0x1(%rax), %ecx
1803481a7: 48 63 c9                    	movslq	%ecx, %rcx
1803481aa: 41 8b 14 8e                 	movl	(%r14,%rcx,4), %edx
1803481ae: 8d 88 fe 11 ba 74           	leal	0x74ba11fe(%rax), %ecx
1803481b4: d3 ca                       	rorl	%cl, %edx
1803481b6: d3 ca                       	rorl	%cl, %edx
1803481b8: 81 f2 02 ee 45 8b           	xorl	$0x8b45ee02, %edx       # imm = 0x8B45EE02
1803481be: d3 ca                       	rorl	%cl, %edx
1803481c0: b9 fc 11 ba 74              	movl	$0x74ba11fc, %ecx       # imm = 0x74BA11FC
1803481c5: 29 c1                       	subl	%eax, %ecx
1803481c7: d3 c2                       	roll	%cl, %edx
1803481c9: d3 c2                       	roll	%cl, %edx
1803481cb: d3 c2                       	roll	%cl, %edx
1803481cd: 48 63 c2                    	movslq	%edx, %rax
1803481d0: 48 89 f1                    	movq	%rsi, %rcx
1803481d3: ff 14 c3                    	callq	*(%rbx,%rax,8)
1803481d6: 48 63 0d 7b 00 48 00        	movslq	0x48007b(%rip), %rcx    # 0x1807c8258
1803481dd: 45 2b 24 8f                 	subl	(%r15,%rcx,4), %r12d
1803481e1: 41 81 f4 68 a7 ba 0d        	xorl	$0xdbaa768, %r12d       # imm = 0xDBAA768
1803481e8: 49 63 cc                    	movslq	%r12d, %rcx
1803481eb: 41 33 3c 8e                 	xorl	(%r14,%rcx,4), %edi
1803481ef: 81 c1 92 0d 8d 30           	addl	$0x308d0d92, %ecx       # imm = 0x308D0D92
1803481f5: d3 cf                       	rorl	%cl, %edi
1803481f7: 48 89 c6                    	movq	%rax, %rsi
1803481fa: ff cf                       	decl	%edi
1803481fc: d3 cf                       	rorl	%cl, %edi
1803481fe: 48 63 c7                    	movslq	%edi, %rax
180348201: 48 8d 8d 20 04 00 00        	leaq	0x420(%rbp), %rcx
180348208: 48 8d 95 f8 07 00 00        	leaq	0x7f8(%rbp), %rdx
18034820f: ff 14 c3                    	callq	*(%rbx,%rax,8)
180348212: 48 8b 95 f8 07 00 00        	movq	0x7f8(%rbp), %rdx
180348219: 4c 8b 8d f0 07 00 00        	movq	0x7f0(%rbp), %r9
180348220: 48 8d 8d 50 0c 00 00        	leaq	0xc50(%rbp), %rcx
180348227: 49 89 f0                    	movq	%rsi, %r8
18034822a: e8 91 81 00 00              	callq	0x1803503c0 <.text+0x3403c0>
18034822f: 0f 28 85 60 08 00 00        	movaps	0x860(%rbp), %xmm0
180348236: 0f 28 8d 70 08 00 00        	movaps	0x870(%rbp), %xmm1
18034823d: 48 8b 85 98 0c 00 00        	movq	0xc98(%rbp), %rax
180348244: 0f 11 88 f9 02 00 00        	movups	%xmm1, 0x2f9(%rax)
18034824b: 0f 11 80 e9 02 00 00        	movups	%xmm0, 0x2e9(%rax)
180348252: 48 8b 8d 08 08 00 00        	movq	0x808(%rbp), %rcx
180348259: 48 89 8d 50 0c 00 00        	movq	%rcx, 0xc50(%rbp)
180348260: 8b 05 92 88 54 00           	movl	0x548892(%rip), %eax    # 0x180890af8
180348266: 31 c0                       	xorl	%eax, %eax
180348268: 2b 05 06 c8 47 00           	subl	0x47c806(%rip), %eax    # 0x1807c4a74
18034826e: c1 c0 0f                    	roll	$0xf, %eax
180348271: f7 d8                       	negl	%eax
180348273: c1 c0 1e                    	roll	$0x1e, %eax
180348276: f7 d8                       	negl	%eax
180348278: c1 c0 0f                    	roll	$0xf, %eax
18034827b: f7 d8                       	negl	%eax
18034827d: 48 98                       	cltq
18034827f: 48 8d 15 ea 59 47 00        	leaq	0x4759ea(%rip), %rdx    # 0x1807bdc70
180348286: ff 14 c2                    	callq	*(%rdx,%rax,8)
180348289: 48 8b 85 98 0c 00 00        	movq	0xc98(%rbp), %rax
180348290: 48 8d 48 48                 	leaq	0x48(%rax), %rcx
180348294: 48 8d 95 10 0a 00 00        	leaq	0xa10(%rbp), %rdx
18034829b: e8 20 4d fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
1803482a0: 48 8b 85 98 0c 00 00        	movq	0xc98(%rbp), %rax
1803482a7: 48 8d 48 28                 	leaq	0x28(%rax), %rcx
1803482ab: 48 8d 95 00 09 00 00        	leaq	0x900(%rbp), %rdx
1803482b2: e8 09 4d fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
1803482b7: 48 8b 85 98 0c 00 00        	movq	0xc98(%rbp), %rax
1803482be: 48 8d 88 28 01 00 00        	leaq	0x128(%rax), %rcx
1803482c5: 48 8d 95 80 07 00 00        	leaq	0x780(%rbp), %rdx
1803482cc: e8 ef 4c fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
1803482d1: 48 8d 95 20 09 00 00        	leaq	0x920(%rbp), %rdx
1803482d8: 48 8b 8d 10 08 00 00        	movq	0x810(%rbp), %rcx
1803482df: e8 dc 4c fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
1803482e4: 48 8d 95 40 09 00 00        	leaq	0x940(%rbp), %rdx
1803482eb: 48 8b 8d 18 08 00 00        	movq	0x818(%rbp), %rcx
1803482f2: e8 c9 4c fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
1803482f7: 48 8d 95 20 07 00 00        	leaq	0x720(%rbp), %rdx
1803482fe: 48 8b 8d 20 08 00 00        	movq	0x820(%rbp), %rcx
180348305: e8 b6 4c fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
18034830a: 48 8d 95 40 07 00 00        	leaq	0x740(%rbp), %rdx
180348311: 48 8b 8d 28 08 00 00        	movq	0x828(%rbp), %rcx
180348318: e8 a3 4c fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
18034831d: 48 8b 85 98 0c 00 00        	movq	0xc98(%rbp), %rax
180348324: 48 8d 88 e8 00 00 00        	leaq	0xe8(%rax), %rcx
18034832b: 48 8d 95 60 07 00 00        	leaq	0x760(%rbp), %rdx
180348332: e8 89 4c fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
180348337: 48 8b 85 98 0c 00 00        	movq	0xc98(%rbp), %rax
18034833e: 48 8d 88 08 01 00 00        	leaq	0x108(%rax), %rcx
180348345: 48 8d 95 e0 05 00 00        	leaq	0x5e0(%rbp), %rdx
18034834c: e8 6f 4c fd ff              	callq	0x18031cfc0 <.text+0x30cfc0>
180348351: 80 bd c7 0c 00 00 00        	cmpb	$0x0, 0xcc7(%rbp)
180348358: 0f 85 99 00 00 00           	jne	0x1803483f7 <.text+0x3383f7>
18034835e: 48 8b 8d 48 08 00 00        	movq	0x848(%rbp), %rcx
180348365: e8 06 36 fd ff              	callq	0x18031b970 <.text+0x30b970>
18034836a: 48 8b 8d 50 08 00 00        	movq	0x850(%rbp), %rcx
180348371: e8 fa 35 fd ff              	callq	0x18031b970 <.text+0x30b970>
180348376: 48 8b 8d 58 08 00 00        	movq	0x858(%rbp), %rcx
18034837d: e8 ee 35 fd ff              	callq	0x18031b970 <.text+0x30b970>
180348382: 48 8b 8d 30 08 00 00        	movq	0x830(%rbp), %rcx
180348389: e8 e2 35 fd ff              	callq	0x18031b970 <.text+0x30b970>
18034838e: 48 8b 8d 38 08 00 00        	movq	0x838(%rbp), %rcx
180348395: e8 d6 35 fd ff              	callq	0x18031b970 <.text+0x30b970>
18034839a: 48 8b 8d 40 08 00 00        	movq	0x840(%rbp), %rcx
1803483a1: e8 ca 35 fd ff              	callq	0x18031b970 <.text+0x30b970>
1803483a6: 48 b8 8c 3c 5b bf dc d1 ff 9c       	movabsq	$-0x63002e2340a4c374, %rax # imm = 0x9CFFD1DCBF5B3C8C
1803483b0: 48 33 05 c1 87 46 00        	xorq	0x4687c1(%rip), %rax    # 0x1807b0b78
1803483b7: 48 b9 2a 6f 33 84 b1 1f 8b 0a       	movabsq	$0xa8b1fb184336f2a, %rcx # imm = 0xA8B1FB184336F2A
1803483c1: 48 01 c1                    	addq	%rax, %rcx
1803483c4: 48 8b 95 98 0c 00 00        	movq	0xc98(%rbp), %rdx
1803483cb: 48 89 8a e8 01 00 00        	movq	%rcx, 0x1e8(%rdx)
1803483d2: 48 b8 2c f7 4f 99 15 11 cf 0a       	movabsq	$0xacf1115994ff72c, %rax # imm = 0xACF1115994FF72C
1803483dc: 48 33 05 8d 87 46 00        	xorq	0x46878d(%rip), %rax    # 0x1807b0b70
1803483e3: 48 b9 87 d6 61 53 10 47 52 90       	movabsq	$-0x6fadb8efac9e2979, %rcx # imm = 0x905247105361D687
1803483ed: 48 01 c1                    	addq	%rax, %rcx
1803483f0: 48 89 8a f0 01 00 00        	movq	%rcx, 0x1f0(%rdx)
1803483f7: 48 63 05 6e 01 48 00        	movslq	0x48016e(%rip), %rax    # 0x1807c856c
1803483fe: 48 8d 0d 7b 0e 31 00        	leaq	0x310e7b(%rip), %rcx    # 0x180659280
180348405: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
180348408: 8d 48 17                    	leal	0x17(%rax), %ecx
18034840b: d3 ca                       	rorl	%cl, %edx
18034840d: b9 57 88 51 37              	movl	$0x37518857, %ecx       # imm = 0x37518857
180348412: 29 c1                       	subl	%eax, %ecx
180348414: d3 c2                       	roll	%cl, %edx
180348416: d3 c2                       	roll	%cl, %edx
180348418: 81 f2 57 88 51 37           	xorl	$0x37518857, %edx       # imm = 0x37518857
18034841e: 48 63 c2                    	movslq	%edx, %rax
180348421: 48 8d 0d a8 b6 47 00        	leaq	0x47b6a8(%rip), %rcx    # 0x1807c3ad0
180348428: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
18034842b: b9 18 00 00 00              	movl	$0x18, %ecx
180348430: 29 c1                       	subl	%eax, %ecx
180348432: d3 c2                       	roll	%cl, %edx
180348434: 81 f2 18 ce b6 a8           	xorl	$0xa8b6ce18, %edx       # imm = 0xA8B6CE18
18034843a: 0f ca                       	bswapl	%edx
18034843c: 83 c0 18                    	addl	$0x18, %eax
18034843f: 89 c1                       	movl	%eax, %ecx
180348441: d3 ca                       	rorl	%cl, %edx
180348443: 48 63 c2                    	movslq	%edx, %rax
180348446: 48 8d 8d 50 0c 00 00        	leaq	0xc50(%rbp), %rcx
18034844d: 48 8d 15 1c 58 47 00        	leaq	0x47581c(%rip), %rdx    # 0x1807bdc70
180348454: ff 14 c2                    	callq	*(%rdx,%rax,8)
180348457: b0 01                       	movb	$0x1, %al
180348459: 89 85 a0 0c 00 00           	movl	%eax, 0xca0(%rbp)
18034845f: 48 8d 05 1e 87 46 00        	leaq	0x46871e(%rip), %rax    # 0x1807b0b84
180348466: eb 22                       	jmp	0x18034848a <.text+0x33848a>
180348468: 8b 05 f6 86 46 00           	movl	0x4686f6(%rip), %eax    # 0x1807b0b64
18034846e: c7 85 a0 0c 00 00 00 00 00 00       	movl	$0x0, 0xca0(%rbp)
180348478: eb 6b                       	jmp	0x1803484e5 <.text+0x3384e5>
18034847a: 48 8d 05 eb 86 46 00        	leaq	0x4686eb(%rip), %rax    # 0x1807b0b6c
180348481: eb 07                       	jmp	0x18034848a <.text+0x33848a>
180348483: 48 8d 05 f6 86 46 00        	leaq	0x4686f6(%rip), %rax    # 0x1807b0b80
18034848a: 8b 00                       	movl	(%rax), %eax
18034848c: 48 63 05 21 00 48 00        	movslq	0x480021(%rip), %rax    # 0x1807c84b4
180348493: 48 8d 0d e6 0d 31 00        	leaq	0x310de6(%rip), %rcx    # 0x180659280
18034849a: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
18034849d: b9 0d 00 00 00              	movl	$0xd, %ecx
1803484a2: 29 c1                       	subl	%eax, %ecx
1803484a4: d3 c2                       	roll	%cl, %edx
1803484a6: 8d 48 0d                    	leal	0xd(%rax), %ecx
1803484a9: d3 ca                       	rorl	%cl, %edx
1803484ab: 8d 42 01                    	leal	0x1(%rdx), %eax
1803484ae: 48 98                       	cltq
1803484b0: 41 b8 4c 46 be ef           	movl	$0xefbe464c, %r8d       # imm = 0xEFBE464C
1803484b6: 48 8d 0d 13 b6 47 00        	leaq	0x47b613(%rip), %rcx    # 0x1807c3ad0
1803484bd: 44 33 04 81                 	xorl	(%rcx,%rax,4), %r8d
1803484c1: b9 0b 00 00 00              	movl	$0xb, %ecx
1803484c6: 29 d1                       	subl	%edx, %ecx
1803484c8: 41 d3 c0                    	roll	%cl, %r8d
1803484cb: 41 f7 d8                    	negl	%r8d
1803484ce: 41 0f c8                    	bswapl	%r8d
1803484d1: 49 63 c0                    	movslq	%r8d, %rax
1803484d4: 48 8d 8d 70 0b 00 00        	leaq	0xb70(%rbp), %rcx
1803484db: 48 8d 15 8e 57 47 00        	leaq	0x47578e(%rip), %rdx    # 0x1807bdc70
1803484e2: ff 14 c2                    	callq	*(%rdx,%rax,8)
1803484e5: 48 63 05 f0 ff 47 00        	movslq	0x47fff0(%rip), %rax    # 0x1807c84dc
1803484ec: 48 8d 0d 8d 0d 31 00        	leaq	0x310d8d(%rip), %rcx    # 0x180659280
1803484f3: 8b 14 81                    	movl	(%rcx,%rax,4), %edx
1803484f6: b9 0d 00 00 00              	movl	$0xd, %ecx
1803484fb: 29 c1                       	subl	%eax, %ecx
1803484fd: d3 c2                       	roll	%cl, %edx
1803484ff: 8d 48 0d                    	leal	0xd(%rax), %ecx
180348502: d3 ca                       	rorl	%cl, %edx
180348504: 8d 42 01                    	leal	0x1(%rdx), %eax
180348507: 48 98                       	cltq
180348509: 41 b8 4c 46 be ef           	movl	$0xefbe464c, %r8d       # imm = 0xEFBE464C
18034850f: 4c 8d 35 ba b5 47 00        	leaq	0x47b5ba(%rip), %r14    # 0x1807c3ad0
180348516: 45 33 04 86                 	xorl	(%r14,%rax,4), %r8d
18034851a: b9 0b 00 00 00              	movl	$0xb, %ecx
18034851f: 29 d1                       	subl	%edx, %ecx
180348521: 41 d3 c0                    	roll	%cl, %r8d
180348524: 41 f7 d8                    	negl	%r8d
180348527: 41 0f c8                    	bswapl	%r8d
18034852a: 49 63 c0                    	movslq	%r8d, %rax
18034852d: 48 8d 8d 88 04 00 00        	leaq	0x488(%rbp), %rcx
180348534: 4c 8d 2d 35 57 47 00        	leaq	0x475735(%rip), %r13    # 0x1807bdc70
18034853b: 41 ff 54 c5 00              	callq	*(%r13,%rax,8)
180348540: e9 eb e7 ff ff              	jmp	0x180346d30 <.text+0x336d30>
