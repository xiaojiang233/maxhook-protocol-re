
.\target\MaxHook.runtime-unpacked.dll:	file format coff-x86-64

Disassembly of section .text:

0000000180010000 <.text>:
180324610: e9 ec e9 1f 01              	jmp	0x181523001
180324615: 50                          	pushq	%rax
180324616: fc                          	cld
180324617: 39 42 9e                    	cmpl	%eax, -0x62(%rdx)
18032461a: 96                          	xchgl	%esi, %eax
18032461b: 0a 77 36                    	orb	0x36(%rdi), %dh
18032461e: 1e                          	<unknown>
18032461f: ea                          	<unknown>
180324620: e6 33                       	outb	%al, $0x33
180324622: f0                          	lock
180324623: f9                          	stc
180324624: e2 ad                       	loop	0x1803245d3 <.text+0x3145d3>
180324626: bd 77 d5 95 ae              	movl	$0xae95d577, %ebp       # imm = 0xAE95D577
18032462b: 35 68 9c 65 14              	xorl	$0x14659c68, %eax       # imm = 0x14659C68
180324630: 20 cd                       	andb	%cl, %ch
180324632: e0 5a                       	loopne	0x18032468e <.text+0x31468e>
180324634: ee                          	outb	%al, %dx
180324635: 1d 20 06 a7 6d              	sbbl	$0x6da70620, %eax       # imm = 0x6DA70620
18032463a: 6a 79                       	pushq	$0x79
18032463c: a9 91 76 3d 5b              	testl	$0x5b3d7691, %eax       # imm = 0x5B3D7691
180324641: 03 7f 29                    	addl	0x29(%rdi), %edi
180324644: 8b 1d 12 5e 0f b8           	movl	-0x47f0a1ee(%rip), %ebx # 0x13841a45c
18032464a: 49 bb 1f 23 f7 76 65 91 b9 c5       	movabsq	$-0x3a466e9a8908dce1, %r11 # imm = 0xC5B9916576F7231F
180324654: b8 37 bf 12 91              	movl	$0x9112bf37, %eax       # imm = 0x9112BF37
180324659: 4a 8f 5a 6a                 	<unknown>
18032465d: c5 77 c6                    	<unknown>
180324660: 1e                          	<unknown>
180324661: 8c 44 db a9                 	movw	%es, -0x57(%rbx,%rbx,8)
180324665: c0 16 1e                    	rclb	$0x1e, (%rsi)
180324668: aa                          	stosb	%al, %es:(%rdi)
180324669: da 0d ae a6 58 6c           	fimull	0x6c58a6ae(%rip)        # 0x1ec8aed1d
18032466f: 57                          	pushq	%rdi
180324670: 9a                          	<unknown>
180324671: 9f                          	lahf
180324672: f6 ee                       	imulb	%dh
180324674: 51                          	pushq	%rcx
180324675: 29 f7                       	subl	%esi, %edi
180324677: a0 9e 57 df 0e 52 c2 76 2f  	movabsb	0x2f76c2520edf579e, %al
180324680: 76 60                       	jbe	0x1803246e2 <.text+0x3146e2>
180324682: 18 80 1f 60 05 21           	sbbb	%al, 0x2105601f(%rax)
180324688: 3e e3 2c                    	jrcxz	0x1803246b7 <.text+0x3146b7>
18032468b: 52                          	pushq	%rdx
18032468c: ef                          	outl	%eax, %dx
18032468d: 83 ef 60                    	subl	$0x60, %edi
180324690: 53                          	pushq	%rbx
180324691: 18 da                       	sbbb	%bl, %dl
180324693: e2 36                       	loop	0x1803246cb <.text+0x3146cb>
180324695: e2 ac                       	loop	0x180324643 <.text+0x314643>
180324697: 13 ca                       	adcl	%edx, %ecx
180324699: 71 b2                       	jno	0x18032464d <.text+0x31464d>
18032469b: 4e 47 b4 8b                 	movb	$-0x75, %r12b
18032469f: 7f a5                       	jg	0x180324646 <.text+0x314646>
1803246a1: 10 e6                       	adcb	%ah, %dh
1803246a3: 0c fe                       	orb	$-0x2, %al
1803246a5: 32 d5                       	xorb	%ch, %dl
1803246a7: 71 05                       	jno	0x1803246ae <.text+0x3146ae>
1803246a9: 38 2d c8 28 b1 58           	cmpb	%ch, 0x58b128c8(%rip)   # 0x1d8e36f77
1803246af: 6f                          	outsl	(%rsi), %dx
1803246b0: 63 cd                       	movslq	%ebp, %ecx
1803246b2: a2 64 5f cb f1 d2 f6 b0 0a  	movabsb	%al, 0xab0f6d2f1cb5f64
1803246bb: aa                          	stosb	%al, %es:(%rdi)
1803246bc: 59                          	popq	%rcx
1803246bd: d4                          	<unknown>
1803246be: a1 6f 92 77 c3 59 17 49 b4  	movabsl	-0x4bb6e8a63c886d91, %eax
1803246c7: 53                          	pushq	%rbx
1803246c8: b5 6a                       	movb	$0x6a, %ch
1803246ca: b8 3b b3 bb c4              	movl	$0xc4bbb33b, %eax       # imm = 0xC4BBB33B
1803246cf: 70 ca                       	jo	0x18032469b <.text+0x31469b>
1803246d1: 33 24 17                    	xorl	(%rdi,%rdx), %esp
1803246d4: ab                          	stosl	%eax, %es:(%rdi)
1803246d5: 8b b2 0e 47 8d a0           	movl	-0x5f72b8f2(%rdx), %esi
1803246db: c6 fb                       	<unknown>
1803246dd: b4 f3                       	movb	$-0xd, %ah
1803246df: 3a e8                       	cmpb	%al, %ch
1803246e1: 94                          	xchgl	%esp, %eax
1803246e2: fc                          	cld
1803246e3: a5                          	movsl	(%rsi), %es:(%rdi)
1803246e4: b4 c9                       	movb	$-0x37, %ah
1803246e6: 82                          	<unknown>
1803246e7: 81 d9 b8 45 66 76           	sbbl	$0x766645b8, %ecx       # imm = 0x766645B8
1803246ed: 12 50 f4                    	adcb	-0xc(%rax), %dl
1803246f0: 77 47                       	ja	0x180324739 <.text+0x314739>
1803246f2: f7 2e                       	imull	(%rsi)
1803246f4: 0c a3                       	orb	$-0x5d, %al
1803246f6: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803246f7: 82                          	<unknown>
1803246f8: 8f c6                       	popq	%rsi
1803246fa: 10 9e 52 d6 e6 4d           	adcb	%bl, 0x4de6d652(%rsi)
180324700: 12 54 7f 64                 	adcb	0x64(%rdi,%rdi,2), %dl
180324704: b3 0c                       	movb	$0xc, %bl
180324706: 29 23                       	subl	%esp, (%rbx)
180324708: f9                          	stc
180324709: fd                          	std
18032470a: 1f                          	<unknown>
18032470b: 77 0e                       	ja	0x18032471b <.text+0x31471b>
18032470d: 8d b1 76 f4 2c f9           	leal	-0x6d30b8a(%rcx), %esi
180324713: 29 56 50                    	subl	%edx, 0x50(%rsi)
180324716: 76 bb                       	jbe	0x1803246d3 <.text+0x3146d3>
180324718: dd 34 a7                    	fnsave	(%rdi,%riz,4)
18032471b: f1                          	<unknown>
18032471c: cf                          	iretl
18032471d: 4a ed                       	inl	%dx, %eax
18032471f: 3d 19 d9 f4 9f              	cmpl	$0x9ff4d919, %eax       # imm = 0x9FF4D919
180324724: e6 43                       	outb	%al, $0x43
180324726: dd ba 50 1b 86 88           	fnstsw	-0x7779e4b0(%rdx)
18032472c: 4c d4                       	<unknown>
18032472e: 6f                          	outsl	(%rsi), %dx
18032472f: b7 91                       	movb	$-0x6f, %bh
180324731: 0d 58 9a 50 01              	orl	$0x1509a58, %eax        # imm = 0x1509A58
180324736: 5d                          	popq	%rbp
180324737: 80 a9 02 04 00 3b 11        	subb	$0x11, 0x3b000402(%rcx)
18032473e: ad                          	lodsl	(%rsi), %eax
18032473f: 63 cc                       	movslq	%esp, %ecx
180324741: f4                          	hlt
180324742: 54                          	pushq	%rsp
180324743: 9a                          	<unknown>
180324744: 12 03                       	adcb	(%rbx), %al
180324746: 12 88 a6 61 af 68           	adcb	0x68af61a6(%rax), %cl
18032474c: b0 b3                       	movb	$-0x4d, %al
18032474e: 4a cb                       	lretq
180324750: 3a 14 db                    	cmpb	(%rbx,%rbx,8), %dl
180324753: ec                          	inb	%dx, %al
180324754: 84 67 e3                    	testb	%ah, -0x1d(%rdi)
180324757: 52                          	pushq	%rdx
180324758: 45 0f 0d 4c e1 a9           	prefetchw	-0x57(%r9,%riz,8)
18032475e: 63 36                       	movslq	(%rsi), %esi
180324760: 0b dd                       	orl	%ebp, %ebx
180324762: ae                          	scasb	%es:(%rdi), %al
180324763: 0c 73                       	orb	$0x73, %al
180324765: c1 58 05 44                 	rcrl	$0x44, 0x5(%rax)
180324769: 45 39 7c 0a 16              	cmpl	%r15d, 0x16(%r10,%rcx)
18032476e: 30 c4                       	xorb	%al, %ah
180324770: e0 5b                       	loopne	0x1803247cd <.text+0x3147cd>
180324772: 9e                          	sahf
180324773: 01 51 b8                    	addl	%edx, -0x48(%rcx)
180324776: e1 d8                       	loope	0x180324750 <.text+0x314750>
180324778: 24 3a                       	andb	$0x3a, %al
18032477a: c1 7e e5 31                 	sarl	$0x31, -0x1b(%rsi)
18032477e: 97                          	xchgl	%edi, %eax
18032477f: ea                          	<unknown>
180324780: 3e e7 94                    	outl	%eax, $0x94
180324783: 16                          	<unknown>
180324784: 41 3b ec                    	cmpl	%r12d, %ebp
180324787: 8f 8b e7                    	<unknown>
18032478a: 83 c2 f7                    	addl	$-0x9, %edx
18032478d: 15 6a de ce 6c              	adcl	$0x6ccede6a, %eax       # imm = 0x6CCEDE6A
180324792: 82                          	<unknown>
180324793: f7 91 45 f1 05 99           	notl	-0x66fa0ebb(%rcx)
180324799: 5e                          	popq	%rsi
18032479a: a4                          	movsb	(%rsi), %es:(%rdi)
18032479b: a0 34 80 56 c9 15 4d 9c 6c  	movabsb	0x6c9c4d15c9568034, %al
1803247a4: f0                          	lock
1803247a5: bb a3 8c 86 93              	movl	$0x93868ca3, %ebx       # imm = 0x93868CA3
1803247aa: f7 4b 7b                    	<unknown>
1803247ad: ae                          	scasb	%es:(%rdi), %al
1803247ae: 68 17 cc a4 e1              	pushq	$-0x1e5b33e9            # imm = 0xE1A4CC17
1803247b3: 03 0d 0d 57 06 56           	addl	0x5606570d(%rip), %ecx  # 0x1d6389ec6
1803247b9: c6 e7                       	<unknown>
1803247bb: 8d fe                       	<unknown>
1803247bd: 1c a1                       	sbbb	$-0x5f, %al
1803247bf: c0 ca d6                    	rorb	$0xd6, %dl
1803247c2: a4                          	movsb	(%rsi), %es:(%rdi)
1803247c3: 31 2a                       	xorl	%ebp, (%rdx)
1803247c5: 07                          	<unknown>
1803247c6: d0 ac 71 b9 b2 26 c1        	shrb	-0x3ed94d47(%rcx,%rsi,2)
1803247cd: 15 3f 8f 73 40              	adcl	$0x40738f3f, %eax       # imm = 0x40738F3F
1803247d2: cb                          	lretl
1803247d3: 82                          	<unknown>
1803247d4: fd                          	std
1803247d5: 14 27                       	adcb	$0x27, %al
1803247d7: d0 fb                       	sarb	%bl
1803247d9: 49 b4 dd                    	movb	$-0x23, %r12b
1803247dc: c6 a0 4f 34 95 f2           	<unknown>
1803247e2: 90                          	nop
1803247e3: fd                          	std
1803247e4: fe 19                       	<unknown>
1803247e6: 01 bd 45 5e 93 c2           	addl	%edi, -0x3d6ca1bb(%rbp)
1803247ec: 38 4c 2f 4e                 	cmpb	%cl, 0x4e(%rdi,%rbp)
1803247f0: 79 ca                       	jns	0x1803247bc <.text+0x3147bc>
1803247f2: 84 b1 9a 23 8f 92           	testb	%dh, -0x6d70dc66(%rcx)
1803247f8: a6                          	cmpsb	%es:(%rdi), (%rsi)
1803247f9: 9c                          	pushfq
1803247fa: dd de                       	fstp	%st(6)
1803247fc: ea                          	<unknown>
1803247fd: 05 08 83 1c 3b              	addl	$0x3b1c8308, %eax       # imm = 0x3B1C8308
180324802: 46 68 1c ef 97 26           	pushq	$0x2697ef1c             # imm = 0x2697EF1C
180324808: 71 99                       	jno	0x1803247a3 <.text+0x3147a3>
18032480a: 06                          	<unknown>
18032480b: a2 f3 34 a8 f8 09 f4 f9 4b  	movabsb	%al, 0x4bf9f409f8a834f3
180324814: d6                          	<unknown>
180324815: 5f                          	popq	%rdi
180324816: 8e 3f                       	<unknown>
180324818: a0 71 89 2d 68 bd 99 a3 55  	movabsb	0x55a399bd682d8971, %al
180324821: c7 18                       	<unknown>
180324823: fc                          	cld
180324824: 47 8f f3 da                 	<unknown>
180324828: b5 00                       	movb	$0x0, %ch
18032482a: 73 cb                       	jae	0x1803247f7 <.text+0x3147f7>
18032482c: e8 66 99 08 c2              	callq	0x1423ae197
180324831: 4f 44 e7 bb                 	outl	%eax, $0xbb
180324835: 8f be b9                    	<unknown>
180324838: 17                          	<unknown>
180324839: cb                          	lretl
18032483a: ed                          	inl	%dx, %eax
18032483b: 3d 75 4e 27 c4              	cmpl	$0xc4274e75, %eax       # imm = 0xC4274E75
180324840: 90                          	nop
180324841: fe 00                       	incb	(%rax)
180324843: 7f 0e                       	jg	0x180324853 <.text+0x314853>
180324845: 1d d2 a1 01 8c              	sbbl	$0x8c01a1d2, %eax       # imm = 0x8C01A1D2
18032484a: e9 13 fb 6e a6              	jmp	0x126a14362
18032484f: 7d ba                       	jge	0x18032480b <.text+0x31480b>
180324851: e8 28 2b a5 03              	callq	0x183d7737e
180324856: 09 4d e2                    	orl	%ecx, -0x1e(%rbp)
180324859: b4 2b                       	movb	$0x2b, %ah
18032485b: 6f                          	outsl	(%rsi), %dx
18032485c: aa                          	stosb	%al, %es:(%rdi)
18032485d: ab                          	stosl	%eax, %es:(%rdi)
18032485e: 23 99 68 7c 0d dd           	andl	-0x22f28398(%rcx), %ebx
180324864: 89 03                       	movl	%eax, (%rbx)
180324866: a0 30 c8 d0 43 17 54 7f d6  	movabsb	-0x2980abe8bc2f37d0, %al
18032486f: 9d                          	popfq
180324870: da 14 d3                    	ficoml	(%rbx,%rdx,8)
180324873: be 52 74 08 db              	movl	$0xdb087452, %esi       # imm = 0xDB087452
180324878: 38 f2                       	cmpb	%dh, %dl
18032487a: 35 d3 c2 7b 70              	xorl	$0x707bc2d3, %eax       # imm = 0x707BC2D3
18032487f: 5a                          	popq	%rdx
180324880: 68 55 78 ee 78              	pushq	$0x78ee7855             # imm = 0x78EE7855
180324885: 25 be 9e a7 6e              	andl	$0x6ea79ebe, %eax       # imm = 0x6EA79EBE
18032488a: 1a 9d 70 d4 e4 83           	sbbb	-0x7c1b2b90(%rbp), %bl
180324890: 72 c3                       	jb	0x180324855 <.text+0x314855>
180324892: 4f d9 2a                    	fldcw	(%r10)
180324895: 5c                          	popq	%rsp
180324896: e3 1d                       	jrcxz	0x1803248b5 <.text+0x3148b5>
180324898: 63 14 e6                    	movslq	(%rsi,%riz,8), %edx
18032489b: 94                          	xchgl	%esp, %eax
18032489c: 80 a2 c9 a1 da 7f 44        	andb	$0x44, 0x7fdaa1c9(%rdx)
1803248a3: e7 2e                       	outl	%eax, $0x2e
1803248a5: 22 b4 16 83 12 24 a2        	andb	-0x5ddbed7d(%rsi,%rdx), %dh
1803248ac: 2e 1c 33                    	sbbb	$0x33, %al
1803248af: 71 25                       	jno	0x1803248d6 <.text+0x3148d6>
1803248b1: 71 b9                       	jno	0x18032486c <.text+0x31486c>
1803248b3: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803248b4: 42 90                       	nop
1803248b6: df 23                       	fbld	(%rbx)
1803248b8: 5b                          	popq	%rbx
1803248b9: a9 f0 99 66 3f              	testl	$0x3f6699f0, %eax       # imm = 0x3F6699F0
1803248be: ae                          	scasb	%es:(%rdi), %al
1803248bf: 99                          	cltd
1803248c0: f6 8e 90 9f 2c e0           	<unknown>
1803248c6: d3 0a                       	rorl	%cl, (%rdx)
1803248c8: 94                          	xchgl	%esp, %eax
1803248c9: 0b 08                       	orl	(%rax), %ecx
1803248cb: d7                          	xlatb
1803248cc: 3d 93 d4 2c 55              	cmpl	$0x552cd493, %eax       # imm = 0x552CD493
1803248d1: 8c 70 72                    	<unknown>
1803248d4: f5                          	cmc
1803248d5: 2e 06                       	<unknown>
1803248d7: af                          	scasl	%es:(%rdi), %eax
1803248d8: ec                          	inb	%dx, %al
1803248d9: ab                          	stosl	%eax, %es:(%rdi)
1803248da: df 62 d3                    	fbld	-0x2d(%rdx)
1803248dd: 67 6a a5                    	addr32		pushq	$-0x5b
1803248e0: 12 ba dd 8e 13 3a           	adcb	0x3a138edd(%rdx), %bh
1803248e6: df 0f                       	fisttps	(%rdi)
1803248e8: 93                          	xchgl	%ebx, %eax
1803248e9: 9b                          	wait
1803248ea: 3c 74                       	cmpb	$0x74, %al
1803248ec: 17                          	<unknown>
1803248ed: cc                          	int3
1803248ee: 44 4f c2 27 01              	retq	$0x127                  # imm = 0x127
1803248f3: 6a c5                       	pushq	$-0x3b
1803248f5: 92                          	xchgl	%edx, %eax
1803248f6: 52                          	pushq	%rdx
1803248f7: 9f                          	lahf
1803248f8: 87 3a                       	xchgl	%edi, (%rdx)
1803248fa: a1 ba f1 76 53 f4 86 93 90  	movabsl	-0x6f6c790bac890e46, %eax
180324903: 94                          	xchgl	%esp, %eax
180324904: ba 67 29 06 4e              	movl	$0x4e062967, %edx       # imm = 0x4E062967
180324909: 6c                          	insb	%dx, %es:(%rdi)
18032490a: a1 5b 71 74 ee f4 f6 21 b4  	movabsl	-0x4bde090b118b8ea5, %eax
180324913: 91                          	xchgl	%ecx, %eax
180324914: cb                          	lretl
180324915: f9                          	stc
180324916: b5 fa                       	movb	$-0x6, %ch
180324918: bb f9 62 1a d4              	movl	$0xd41a62f9, %ebx       # imm = 0xD41A62F9
18032491d: cf                          	iretl
18032491e: 81 90 79 be 74 d6 62 d3 c0 17       	adcl	$0x17c0d362, -0x298b4187(%rax) # imm = 0x17C0D362
180324928: c5 99 00                    	<unknown>
18032492b: f4                          	hlt
18032492c: 13 7e fd                    	adcl	-0x3(%rsi), %edi
18032492f: 78 73                       	js	0x1803249a4 <.text+0x3149a4>
180324931: 8e 66 7a                    	movw	0x7a(%rsi), %fs
180324934: 5e                          	popq	%rsi
180324935: f0                          	lock
180324936: 93                          	xchgl	%ebx, %eax
180324937: f2 8f a7 83                 	<unknown>
18032493b: dd aa 77 09 8f 19           	<unknown>
180324941: f1                          	<unknown>
180324942: 61                          	<unknown>
180324943: 62 07 2b 0f 1f              	<unknown>
180324948: 5d                          	popq	%rbp
180324949: d8 19                       	fcomps	(%rcx)
18032494b: 3c be                       	cmpb	$-0x42, %al
18032494d: ec                          	inb	%dx, %al
18032494e: 48 af                       	scasq	%es:(%rdi), %rax
180324950: b3 82                       	movb	$-0x7e, %bl
180324952: a2 08 ca 22 5b 3b 2a 10 b2  	movabsb	%al, -0x4defd5c4a4dd35f8
18032495b: b8 af 38 a1 0f              	movl	$0xfa138af, %eax        # imm = 0xFA138AF
180324960: e6 9a                       	outb	%al, $0x9a
180324962: 0c 68                       	orb	$0x68, %al
180324964: 02 17                       	addb	(%rdi), %dl
180324966: 3e a4                       	movsb	%ds:(%rsi), %es:(%rdi)
180324968: 98                          	cwtl
180324969: c5 8f a5                    	<unknown>
18032496c: 42 a8 82                    	testb	$-0x7e, %al
18032496f: 5b                          	popq	%rbx
180324970: a5                          	movsl	(%rsi), %es:(%rdi)
180324971: a8 2c                       	testb	$0x2c, %al
180324973: 1d 51 89 c4 2e              	sbbl	$0x2ec48951, %eax       # imm = 0x2EC48951
180324978: 1a 53 72                    	sbbb	0x72(%rbx), %dl
18032497b: 16                          	<unknown>
18032497c: 40 de 48 48                 	fimuls	0x48(%rax)
180324980: 0c bf                       	orb	$-0x41, %al
180324982: 4e 4d 0f 02 1c 66           	larq	(%r14,%riz,2), %r11
180324988: 94                          	xchgl	%esp, %eax
180324989: 2f                          	<unknown>
18032498a: 17                          	<unknown>
18032498b: 58                          	popq	%rax
18032498c: 5d                          	popq	%rbp
18032498d: 5c                          	popq	%rsp
18032498e: bd dd 8f e7 b4              	movl	$0xb4e78fdd, %ebp       # imm = 0xB4E78FDD
180324993: 56                          	pushq	%rsi
180324994: 52                          	pushq	%rdx
180324995: 76 72                       	jbe	0x180324a09 <.text+0x314a09>
180324997: b9 a7 30 2b 6d              	movl	$0x6d2b30a7, %ecx       # imm = 0x6D2B30A7
18032499c: 87 c0                       	xchgl	%eax, %eax
18032499e: 4d 22 77 d9                 	andb	-0x27(%r15), %r14b
1803249a2: 37                          	<unknown>
1803249a3: f2 4a 07                    	<unknown>
1803249a6: 4e b2 ee                    	movb	$-0x12, %dl
1803249a9: c3                          	retq
1803249aa: c7 7d 0b                    	<unknown>
1803249ad: 80 0c 6e 35                 	orb	$0x35, (%rsi,%rbp,2)
1803249b1: 3b e5                       	cmpl	%ebp, %esp
1803249b3: 30 91 17 d4 cf 01           	xorb	%dl, 0x1cfd417(%rcx)
1803249b9: 77 18                       	ja	0x1803249d3 <.text+0x3149d3>
1803249bb: f8                          	clc
1803249bc: 3a 63 14                    	cmpb	0x14(%rbx), %ah
1803249bf: 7f 0a                       	jg	0x1803249cb <.text+0x3149cb>
1803249c1: 75 c4                       	jne	0x180324987 <.text+0x314987>
1803249c3: e3 fc                       	jrcxz	0x1803249c1 <.text+0x3149c1>
1803249c5: 4c b5 d8                    	movb	$-0x28, %bpl
1803249c8: f2                          	xacquire
1803249c9: 97                          	xchgl	%edi, %eax
1803249ca: 5e                          	popq	%rsi
1803249cb: fc                          	cld
1803249cc: dd ad 0a 51 4d d3           	<unknown>
1803249d2: 92                          	xchgl	%edx, %eax
1803249d3: a1 e0 33 b9 2c 0e 23 46 5d  	movabsl	0x5d46230e2cb933e0, %eax
1803249dc: 63 ec                       	movslq	%esp, %ebp
1803249de: 96                          	xchgl	%esi, %eax
1803249df: a5                          	movsl	(%rsi), %es:(%rdi)
1803249e0: 73 98                       	jae	0x18032497a <.text+0x31497a>
1803249e2: b5 02                       	movb	$0x2, %ch
1803249e4: dc e9                       	fsubr	%st, %st(1)
1803249e6: 21 ac ea fa 94 56 fa        	andl	%ebp, -0x5a96b06(%rdx,%rbp,8)
1803249ed: b6 36                       	movb	$0x36, %dh
1803249ef: 76 11                       	jbe	0x180324a02 <.text+0x314a02>
1803249f1: 79 dc                       	jns	0x1803249cf <.text+0x3149cf>
1803249f3: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803249f4: 47 40 21 9f b2 e6 67 d8     	andl	%ebx, -0x2798194e(%rdi)
1803249fc: ab                          	stosl	%eax, %es:(%rdi)
1803249fd: 26 a2 44 1a 08 9c da 36 eb 63       	movabsb	%al, %es:0x63eb36da9c081a44
180324a07: f3 02 7f 7d                 	rep		addb	0x7d(%rdi), %bh
180324a0b: 5b                          	popq	%rbx
180324a0c: a3 35 a4 dd 38 5b 89 8c 95  	movabsl	%eax, -0x6a7376a4c7225bcb
180324a15: 5e                          	popq	%rsi
180324a16: 9f                          	lahf
180324a17: 86 b6 8c 1c 9d 59           	xchgb	%dh, 0x599d1c8c(%rsi)
180324a1d: 78 54                       	js	0x180324a73 <.text+0x314a73>
180324a1f: 0a e6                       	orb	%dh, %ah
180324a21: 60                          	<unknown>
180324a22: db a7 4a bf 9e ae           	<unknown>
180324a28: f1                          	<unknown>
180324a29: f8                          	clc
180324a2a: 3f                          	<unknown>
180324a2b: f5                          	cmc
180324a2c: 64 3d 26 e5 0e 42           	cmpl	$0x420ee526, %eax       # imm = 0x420EE526
180324a32: e5 97                       	inl	$0x97, %eax
180324a34: ba e0 8b d3 74              	movl	$0x74d38be0, %edx       # imm = 0x74D38BE0
180324a39: c6 11                       	<unknown>
180324a3b: 63 05 09 b9 66 dd           	movslq	-0x229946f7(%rip), %eax # 0x15d99034a
180324a41: 1a c9                       	sbbb	%cl, %cl
180324a43: 76 fd                       	jbe	0x180324a42 <.text+0x314a42>
180324a45: 20 7e 50                    	andb	%bh, 0x50(%rsi)
180324a48: 84 65 21                    	testb	%ah, 0x21(%rbp)
180324a4b: d7                          	xlatb
180324a4c: 51                          	pushq	%rcx
180324a4d: a3 5a ca b3 61 f9 c7 a3 42  	movabsl	%eax, 0x42a3c7f961b3ca5a
180324a56: e1 a3                       	loope	0x1803249fb <.text+0x3149fb>
180324a58: cd 12                       	int	$0x12
180324a5a: 3a 31                       	cmpb	(%rcx), %dh
180324a5c: 4a a1 96 ac 7d 52 59 32 c8 73       	movabsq	0x73c83259527dac96, %rax
180324a66: bb 19 ce 35 9b              	movl	$0x9b35ce19, %ebx       # imm = 0x9B35CE19
180324a6b: 8e 66 fe                    	movw	-0x2(%rsi), %fs
180324a6e: 66 bf 4c c7                 	movw	$0xc74c, %di            # imm = 0xC74C
180324a72: 85 e0                       	testl	%esp, %eax
180324a74: 15 14 3c 9a 7c              	adcl	$0x7c9a3c14, %eax       # imm = 0x7C9A3C14
180324a79: 41 67 98                    	addr32		cwtl
180324a7c: 95                          	xchgl	%ebp, %eax
180324a7d: b7 02                       	movb	$0x2, %bh
180324a7f: 28 36                       	subb	%dh, (%rsi)
180324a81: e3 1d                       	jrcxz	0x180324aa0 <.text+0x314aa0>
180324a83: f6 cf                       	<unknown>
180324a85: c5 06 17                    	<unknown>
180324a88: 22 0d ea 8f 8d 1e           	andb	0x1e8d8fea(%rip), %cl   # 0x19ebfda78
180324a8e: 7e b5                       	jle	0x180324a45 <.text+0x314a45>
180324a90: 70 cd                       	jo	0x180324a5f <.text+0x314a5f>
180324a92: 77 58                       	ja	0x180324aec <.text+0x314aec>
180324a94: 2d 3c ee 78 a5              	subl	$0xa578ee3c, %eax       # imm = 0xA578EE3C
180324a99: dd cf                       	<unknown>
180324a9b: a9 42 7a 34 2d              	testl	$0x2d347a42, %eax       # imm = 0x2D347A42
180324aa0: 42 1a 2a                    	sbbb	(%rdx), %bpl
180324aa3: 6c                          	insb	%dx, %es:(%rdi)
180324aa4: 4e 5a                       	popq	%rdx
180324aa6: a4                          	movsb	(%rsi), %es:(%rdi)
180324aa7: 95                          	xchgl	%ebp, %eax
180324aa8: 99                          	cltd
180324aa9: cb                          	lretl
180324aaa: ed                          	inl	%dx, %eax
180324aab: cf                          	iretl
180324aac: f6 45 ba 27                 	testb	$0x27, -0x46(%rbp)
180324ab0: 71 ba                       	jno	0x180324a6c <.text+0x314a6c>
180324ab2: 6b 12 0c                    	imull	$0xc, (%rdx), %edx
180324ab5: fc                          	cld
180324ab6: e2 5d                       	loop	0x180324b15 <.text+0x314b15>
180324ab8: 18 ae 6b 5b 56 62           	sbbb	%ch, 0x62565b6b(%rsi)
180324abe: d8 e3                       	fsub	%st(3), %st
180324ac0: d7                          	xlatb
180324ac1: 82                          	<unknown>
180324ac2: e4 5d                       	inb	$0x5d, %al
180324ac4: 3a a2 4c b5 ba 42           	cmpb	0x42bab54c(%rdx), %ah
180324aca: af                          	scasl	%es:(%rdi), %eax
180324acb: 98                          	cwtl
180324acc: 57                          	pushq	%rdi
180324acd: 7e 72                       	jle	0x180324b41 <.text+0x314b41>
180324acf: 1f                          	<unknown>
180324ad0: e6 0a                       	outb	%al, $0xa
180324ad2: cd cf                       	int	$0xcf
180324ad4: f9                          	stc
180324ad5: 76 d9                       	jbe	0x180324ab0 <.text+0x314ab0>
180324ad7: 94                          	xchgl	%esp, %eax
180324ad8: a7                          	cmpsl	%es:(%rdi), (%rsi)
180324ad9: ee                          	outb	%al, %dx
180324ada: e3 b7                       	jrcxz	0x180324a93 <.text+0x314a93>
180324adc: 88 93 b1 c0 89 3b           	movb	%dl, 0x3b89c0b1(%rbx)
180324ae2: 48 4a 05 8f 64 ba 45        	addq	$0x45ba648f, %rax       # imm = 0x45BA648F
180324ae9: 99                          	cltd
180324aea: a4                          	movsb	(%rsi), %es:(%rdi)
180324aeb: ed                          	inl	%dx, %eax
180324aec: 2f                          	<unknown>
180324aed: 59                          	popq	%rcx
180324aee: 9d                          	popfq
180324aef: 8f 1b 34                    	<unknown>
180324af2: 3b 6c 0c 9e                 	cmpl	-0x62(%rsp,%rcx), %ebp
180324af6: 0b b6 7d be 5f 9f           	orl	-0x60a04183(%rsi), %esi
180324afc: 83 f6 fa                    	xorl	$-0x6, %esi
180324aff: e6 28                       	outb	%al, $0x28
180324b01: 20 ae f6 6c f6 35           	andb	%ch, 0x35f66cf6(%rsi)
180324b07: 3c 7b                       	cmpb	$0x7b, %al
180324b09: 50                          	pushq	%rax
180324b0a: 07                          	<unknown>
180324b0b: f2 a1 6c a3 17 bd 17 23 50 90       	repne		movabsl	-0x6fafdce842e85c94, %eax
180324b15: 53                          	pushq	%rbx
180324b16: fe 9f 96 b2 0e 2b           	<unknown>
180324b1c: 1b 91 f1 a1 ae 97           	sbbl	-0x68515e0f(%rcx), %edx
180324b22: d8 b4 9f 15 26 cc 1b        	fdivs	0x1bcc2615(%rdi,%rbx,4)
180324b29: d3 27                       	shll	%cl, (%rdi)
180324b2b: 08 ab 8c 0d b1 e3           	orb	%ch, -0x1c4ef274(%rbx)
180324b31: a7                          	cmpsl	%es:(%rdi), (%rsi)
180324b32: 89 56 2e                    	movl	%edx, 0x2e(%rsi)
180324b35: 04 eb                       	addb	$-0x15, %al
180324b37: 5d                          	popq	%rbp
180324b38: ca 0c b8                    	lretl	$-0x47f4                # imm = 0xB80C
180324b3b: 0d 38 54 b9 ce              	orl	$0xceb95438, %eax       # imm = 0xCEB95438
180324b40: 4a 4f 42 f6 f0              	divb	%al
180324b45: ca 85 2d                    	lretl	$0x2d85                 # imm = 0x2D85
180324b48: 80 94 06 27 b1 b7 07 35     	adcb	$0x35, 0x7b7b127(%rsi,%rax)
180324b50: 37                          	<unknown>
180324b51: 98                          	cwtl
180324b52: ec                          	inb	%dx, %al
180324b53: cc                          	int3
180324b54: a5                          	movsl	(%rsi), %es:(%rdi)
180324b55: 56                          	pushq	%rsi
180324b56: f5                          	cmc
180324b57: 05 a1 5a ba 43              	addl	$0x43ba5aa1, %eax       # imm = 0x43BA5AA1
180324b5c: d0 d0                       	rclb	%al
180324b5e: 7e e8                       	jle	0x180324b48 <.text+0x314b48>
180324b60: 39 89 6d 69 01 73           	cmpl	%ecx, 0x7301696d(%rcx)
180324b66: 51                          	pushq	%rcx
180324b67: 9c                          	pushfq
180324b68: 18 16                       	sbbb	%dl, (%rsi)
180324b6a: 4c 4a 94                    	xchgq	%rsp, %rax
180324b6d: a6                          	cmpsb	%es:(%rdi), (%rsi)
180324b6e: 23 57 7e                    	andl	0x7e(%rdi), %edx
180324b71: 2e d5 f5 f0                 	<unknown>
180324b75: ed                          	inl	%dx, %eax
180324b76: 9e                          	sahf
180324b77: 68 eb 47 5f ea              	pushq	$-0x15a0b815            # imm = 0xEA5F47EB
180324b7c: 18 e6                       	sbbb	%ah, %dh
180324b7e: 8f 85 94 a8 3c 8c           	popq	-0x73c3576c(%rbp)
180324b84: d5 3a d7                    	xlatb
180324b87: a0 93 a0 77 bb 72 a9 a9 42  	movabsb	0x42a9a972bb77a093, %al
180324b90: fc                          	cld
180324b91: e3 f8                       	jrcxz	0x180324b8b <.text+0x314b8b>
180324b93: 9a                          	<unknown>
180324b94: e2 92                       	loop	0x180324b28 <.text+0x314b28>
180324b96: 52                          	pushq	%rdx
180324b97: 65 bd e9 31 94 c0           	movl	$0xc09431e9, %ebp       # imm = 0xC09431E9
180324b9d: 17                          	<unknown>
180324b9e: c0 f9 a8                    	sarb	$0xa8, %cl
180324ba1: 1c 79                       	sbbb	$0x79, %al
180324ba3: 47 c9                       	leave
180324ba5: ef                          	outl	%eax, %dx
180324ba6: c7 36                       	<unknown>
180324ba8: 6c                          	insb	%dx, %es:(%rdi)
180324ba9: 44 e2 42                    	loop	0x180324bee <.text+0x314bee>
180324bac: c9                          	leave
180324bad: 83 2b 5e                    	subl	$0x5e, (%rbx)
180324bb0: 74 06                       	je	0x180324bb8 <.text+0x314bb8>
180324bb2: 3d d5 b6 2a ed              	cmpl	$0xed2ab6d5, %eax       # imm = 0xED2AB6D5
180324bb7: 03 28                       	addl	(%rax), %ebp
180324bb9: 34 50                       	xorb	$0x50, %al
180324bbb: 2d 35 ad 1e dc              	subl	$0xdc1ead35, %eax       # imm = 0xDC1EAD35
180324bc0: f2 f8                       	repne		clc
180324bc2: f8                          	clc
180324bc3: fa                          	cli
180324bc4: af                          	scasl	%es:(%rdi), %eax
180324bc5: ca ec f5                    	lretl	$-0xa14                 # imm = 0xF5EC
180324bc8: 89 b4 e8 3d 1e 33 12        	movl	%esi, 0x12331e3d(%rax,%rbp,8)
180324bcf: d1 ea                       	shrl	%edx
180324bd1: 82                          	<unknown>
180324bd2: 2e f3 fd                    	rep		std
180324bd5: 54                          	pushq	%rsp
180324bd6: b5 50                       	movb	$0x50, %ch
180324bd8: 2f                          	<unknown>
180324bd9: 39 66 fd                    	cmpl	%esp, -0x3(%rsi)
180324bdc: 9a                          	<unknown>
180324bdd: 8c 71 00                    	<unknown>
180324be0: e6 78                       	outb	%al, $0x78
180324be2: e5 55                       	inl	$0x55, %eax
180324be4: e6 c2                       	outb	%al, $0xc2
180324be6: 4c 6f                       	outsl	(%rsi), %dx
180324be8: 74 76                       	je	0x180324c60 <.text+0x314c60>
180324bea: 1c 0c                       	sbbb	$0xc, %al
180324bec: b6 d7                       	movb	$-0x29, %dh
180324bee: 40 f9                       	stc
180324bf0: 8e fe                       	<unknown>
180324bf2: 94                          	xchgl	%esp, %eax
180324bf3: 69 b6 a7 0c cf b1 fa ee 46 ee       	imull	$0xee46eefa, -0x4e30f359(%rsi), %esi # imm = 0xEE46EEFA
180324bfd: 4d 8a 2b                    	movb	(%r11), %r13b
180324c00: 64 bf ba ef d2 4e           	movl	$0x4ed2efba, %edi       # imm = 0x4ED2EFBA
180324c06: 89 0d f3 e6 88 7f           	movl	%ecx, 0x7f88e6f3(%rip)  # 0x1ffbb32ff
180324c0c: e1 76                       	loope	0x180324c84 <.text+0x314c84>
180324c0e: f2 79 ef                    	repne		jns	0x180324c00 <.text+0x314c00>
180324c11: 1f                          	<unknown>
180324c12: 62 26 61 e8 7f              	<unknown>
180324c17: b9 9a 66 5b 1b              	movl	$0x1b5b669a, %ecx       # imm = 0x1B5B669A
180324c1c: 24 b8                       	andb	$-0x48, %al
180324c1e: 85 b8 3a c9 9f 45           	testl	%edi, 0x459fc93a(%rax)
180324c24: b6 31                       	movb	$0x31, %dh
180324c26: 71 d8                       	jno	0x180324c00 <.text+0x314c00>
180324c28: 17                          	<unknown>
180324c29: 35 c7 38 a5 37              	xorl	$0x37a538c7, %eax       # imm = 0x37A538C7
180324c2e: f9                          	stc
180324c2f: 84 fe                       	testb	%bh, %dh
180324c31: 36 a8 2f                    	testb	$0x2f, %al
180324c34: bd 2f a0 9f 2a              	movl	$0x2a9fa02f, %ebp       # imm = 0x2A9FA02F
180324c39: fe 71 e4                    	<unknown>
180324c3c: 71 37                       	jno	0x180324c75 <.text+0x314c75>
180324c3e: 7d 9f                       	jge	0x180324bdf <.text+0x314bdf>
180324c40: 63 dc                       	movslq	%esp, %ebx
180324c42: e6 33                       	outb	%al, $0x33
180324c44: 07                          	<unknown>
180324c45: 4c 97                       	xchgq	%rdi, %rax
180324c47: 0a 8d ea 56 44 34           	orb	0x344456ea(%rbp), %cl
180324c4d: 51                          	pushq	%rcx
180324c4e: 40 52                       	pushq	%rdx
180324c50: b2 a4                       	movb	$-0x5c, %dl
180324c52: e3 15                       	jrcxz	0x180324c69 <.text+0x314c69>
180324c54: 32 c7                       	xorb	%bh, %al
180324c56: 9d                          	popfq
180324c57: e6 c9                       	outb	%al, $0xc9
180324c59: 29 08                       	subl	%ecx, (%rax)
180324c5b: 6e                          	outsb	(%rsi), %dx
180324c5c: 37                          	<unknown>
180324c5d: d3 18                       	rcrl	%cl, (%rax)
180324c5f: f0                          	lock
180324c60: da 99 0a 0a 27 7c           	ficompl	0x7c270a0a(%rcx)
180324c66: d6                          	<unknown>
180324c67: 74 28                       	je	0x180324c91 <.text+0x314c91>
180324c69: 9e                          	sahf
180324c6a: 6c                          	insb	%dx, %es:(%rdi)
180324c6b: e6 74                       	outb	%al, $0x74
180324c6d: 45 ae                       	scasb	%es:(%rdi), %al
180324c6f: 2e 9e                       	sahf
180324c71: 73 8b                       	jae	0x180324bfe <.text+0x314bfe>
180324c73: b2 8b                       	movb	$-0x75, %dl
180324c75: 20 64 c3 c1                 	andb	%ah, -0x3f(%rbx,%rax,8)
180324c79: b2 c1                       	movb	$-0x3f, %dl
180324c7b: 20 a1 b2 db 0c ad           	andb	%ah, -0x52f3244e(%rcx)
180324c81: c4 eb 3f                    	<unknown>
180324c84: 8a 44 01 eb                 	movb	-0x15(%rcx,%rax), %al
180324c88: 01 51 8d                    	addl	%edx, -0x73(%rcx)
180324c8b: a7                          	cmpsl	%es:(%rdi), (%rsi)
180324c8c: c2 8f 1a                    	retq	$0x1a8f                 # imm = 0x1A8F
180324c8f: 5a                          	popq	%rdx
180324c90: ec                          	inb	%dx, %al
180324c91: 6d                          	insl	%dx, %es:(%rdi)
180324c92: 2e 75 4f                    	jne	0x180324ce4 <.text+0x314ce4>
180324c95: c8 1c 82 7e                 	enter	$-0x7de4, $0x7e         # imm = 0x821C
180324c99: c7 91 c0 b9 20 f0           	<unknown>
180324c9f: a4                          	movsb	(%rsi), %es:(%rdi)
180324ca0: 60                          	<unknown>
180324ca1: 3a 9c 72 bd 7b 1a e4        	cmpb	-0x1be58443(%rdx,%rsi,2), %bl
180324ca8: ec                          	inb	%dx, %al
180324ca9: d1 fd                       	sarl	%ebp
180324cab: 1f                          	<unknown>
180324cac: 1f                          	<unknown>
180324cad: e1 6f                       	loope	0x180324d1e <.text+0x314d1e>
180324caf: 21 7d e7                    	andl	%edi, -0x19(%rbp)
180324cb2: 70 c0                       	jo	0x180324c74 <.text+0x314c74>
180324cb4: e5 6e                       	inl	$0x6e, %eax
180324cb6: 3d 9a c4 e6 98              	cmpl	$0x98e6c49a, %eax       # imm = 0x98E6C49A
180324cbb: 31 4d a9                    	xorl	%ecx, -0x57(%rbp)
180324cbe: b4 55                       	movb	$0x55, %ah
180324cc0: 7d 10                       	jge	0x180324cd2 <.text+0x314cd2>
180324cc2: b6 48                       	movb	$0x48, %dh
180324cc4: be d2 6e b2 21              	movl	$0x21b26ed2, %esi       # imm = 0x21B26ED2
180324cc9: be 94 23 51 df              	movl	$0xdf512394, %esi       # imm = 0xDF512394
180324cce: 5e                          	popq	%rsi
180324ccf: 3b f7                       	cmpl	%edi, %esi
180324cd1: a6                          	cmpsb	%es:(%rdi), (%rsi)
180324cd2: d7                          	xlatb
180324cd3: 4b 85 ad c4 89 b2 87        	testq	%rbp, -0x784d763c(%r13)
180324cda: 4f 33 56 7a                 	xorq	0x7a(%r14), %r10
180324cde: 2a ed                       	subb	%ch, %ch
180324ce0: ca 2a 0a                    	lretl	$0xa2a                  # imm = 0xA2A
180324ce3: bb a1 2f ee 7d              	movl	$0x7dee2fa1, %ebx       # imm = 0x7DEE2FA1
180324ce8: ad                          	lodsl	(%rsi), %eax
180324ce9: 1d ce 0f 2b 7f              	sbbl	$0x7f2b0fce, %eax       # imm = 0x7F2B0FCE
180324cee: 7e 1d                       	jle	0x180324d0d <.text+0x314d0d>
180324cf0: c8 61 9d 83                 	enter	$-0x629f, $-0x7d        # imm = 0x9D61
180324cf4: b2 4c                       	movb	$0x4c, %dl
180324cf6: 29 6f d0                    	subl	%ebp, -0x30(%rdi)
180324cf9: 7a 52                       	jp	0x180324d4d <.text+0x314d4d>
180324cfb: 71 43                       	jno	0x180324d40 <.text+0x314d40>
180324cfd: cf                          	iretl
180324cfe: 17                          	<unknown>
180324cff: 2d d8 75 6e a4              	subl	$0xa46e75d8, %eax       # imm = 0xA46E75D8
180324d04: 0c 4b                       	orb	$0x4b, %al
180324d06: 98                          	cwtl
180324d07: 86 13                       	xchgb	%dl, (%rbx)
180324d09: 5c                          	popq	%rsp
180324d0a: 37                          	<unknown>
180324d0b: 80 2f 93                    	subb	$-0x6d, (%rdi)
180324d0e: 0c 4c                       	orb	$0x4c, %al
180324d10: 74 60                       	je	0x180324d72 <.text+0x314d72>
180324d12: f3 48 7c c6                 	rep		jl	0x180324cdc <.text+0x314cdc>
180324d16: 43 56                       	pushq	%r14
180324d18: 6a 4a                       	pushq	$0x4a
180324d1a: 18 51 c2                    	sbbb	%dl, -0x3e(%rcx)
180324d1d: 62 b9 ae 85 4a              	<unknown>
180324d22: 63 40 fd                    	movslq	-0x3(%rax), %eax
180324d25: c6 af df 92 0f 9a           	<unknown>
180324d2b: 50                          	pushq	%rax
180324d2c: f9                          	stc
180324d2d: e9 ca ad f4 6a              	jmp	0x1eb26fafc
180324d32: 9e                          	sahf
180324d33: aa                          	stosb	%al, %es:(%rdi)
180324d34: dd fa                       	<unknown>
180324d36: 62 07 a6 1c a9              	<unknown>
180324d3b: 12 cb                       	adcb	%bl, %cl
180324d3d: de a1 b2 db 1d 24           	fisubs	0x241ddbb2(%rcx)
180324d43: 8e fd                       	<unknown>
180324d45: 47 8d 14 a9                 	leal	(%r9,%r13,4), %r10d
180324d49: 2f                          	<unknown>
180324d4a: 96                          	xchgl	%esi, %eax
180324d4b: 4d ee                       	outb	%al, %dx
180324d4d: 0b a2 e2 94 d7 30           	orl	0x30d794e2(%rdx), %esp
180324d53: 48 1b 3b                    	sbbq	(%rbx), %rdi
180324d56: 19 4d aa                    	sbbl	%ecx, -0x56(%rbp)
180324d59: 8d d3                       	<unknown>
180324d5b: b1 59                       	movb	$0x59, %cl
180324d5d: 75 7b                       	jne	0x180324dda <.text+0x314dda>
180324d5f: d7                          	xlatb
180324d60: 1d d8 d2 25 a0              	sbbl	$0xa025d2d8, %eax       # imm = 0xA025D2D8
180324d65: f7 3a                       	idivl	(%rdx)
180324d67: a5                          	movsl	(%rsi), %es:(%rdi)
180324d68: cb                          	lretl
180324d69: 58                          	popq	%rax
180324d6a: 7e 38                       	jle	0x180324da4 <.text+0x314da4>
180324d6c: 5b                          	popq	%rbx
180324d6d: 07                          	<unknown>
180324d6e: 02 7b 22                    	addb	0x22(%rbx), %bh
180324d71: ea                          	<unknown>
180324d72: 5d                          	popq	%rbp
180324d73: 11 6a 8a                    	adcl	%ebp, -0x76(%rdx)
180324d76: 2f                          	<unknown>
180324d77: 81 73 fc 54 60 59 ea        	xorl	$0xea596054, -0x4(%rbx) # imm = 0xEA596054
180324d7e: ae                          	scasb	%es:(%rdi), %al
180324d7f: 21 8e 9d e1 08 e4           	andl	%ecx, -0x1bf71e63(%rsi)
180324d85: 3c 43                       	cmpb	$0x43, %al
180324d87: c4 9a b8                    	<unknown>
180324d8a: ef                          	outl	%eax, %dx
180324d8b: e7 c3                       	outl	%eax, $0xc3
180324d8d: 4d df 5c 41 73              	fistps	0x73(%r9,%rax,2)
180324d92: be 2e 16 a2 0a              	movl	$0xaa2162e, %esi        # imm = 0xAA2162E
180324d97: 38 9e 39 62 da 02           	cmpb	%bl, 0x2da6239(%rsi)
180324d9d: 14 df                       	adcb	$-0x21, %al
180324d9f: f6 9c d8 77 89 45 d5        	negb	-0x2aba7689(%rax,%rbx,8)
180324da6: 9b                          	wait
180324da7: ab                          	stosl	%eax, %es:(%rdi)
180324da8: 9a                          	<unknown>
180324da9: a2 b1 c3 eb 60 77 06 85 dd  	movabsb	%al, -0x227af9889f143c4f
180324db2: 0d 60 21 7f 37              	orl	$0x377f2160, %eax       # imm = 0x377F2160
180324db7: a0 a7 25 03 dd c2 20 69 16  	movabsb	0x166920c2dd0325a7, %al
180324dc0: 01 8e dc 41 3d b9           	addl	%ecx, -0x46c2be24(%rsi)
180324dc6: d9 a3 01 c0 94 aa           	fldenv	-0x556b3fff(%rbx)
180324dcc: d7                          	xlatb
180324dcd: 81 bf a8 31 6c 0d ab cb d9 70       	cmpl	$0x70d9cbab, 0xd6c31a8(%rdi) # imm = 0x70D9CBAB
180324dd7: 10 34 ec                    	adcb	%dh, (%rsp,%rbp,8)
180324dda: 73 f4                       	jae	0x180324dd0 <.text+0x314dd0>
180324ddc: 36 1e                       	<unknown>
180324dde: da 64 8f 12                 	fisubl	0x12(%rdi,%rcx,4)
180324de2: aa                          	stosb	%al, %es:(%rdi)
180324de3: fb                          	sti
180324de4: ed                          	inl	%dx, %eax
180324de5: ad                          	lodsl	(%rsi), %eax
180324de6: e5 4e                       	inl	$0x4e, %eax
180324de8: 1a 99 68 a5 62 28           	sbbb	0x2862a568(%rcx), %bl
180324dee: 14 14                       	adcb	$0x14, %al
180324df0: 94                          	xchgl	%esp, %eax
180324df1: 88 8e d7 a0 38 c9           	movb	%cl, -0x36c75f29(%rsi)
180324df7: df 7c a1 3f                 	fistpll	0x3f(%rcx,%riz,4)
180324dfb: 48 19 e5                    	sbbq	%rsp, %rbp
180324dfe: 7a b9                       	jp	0x180324db9 <.text+0x314db9>
180324e00: 9e                          	sahf
180324e01: 96                          	xchgl	%esi, %eax
180324e02: 1a af a2 52 c5 e3           	sbbb	-0x1c3aad5e(%rdi), %ch
180324e08: 2b a4 6d 3f 88 e2 96        	subl	-0x691d77c1(%rbp,%rbp,2), %esp
180324e0f: ea                          	<unknown>
180324e10: e0 7f                       	loopne	0x180324e91 <.text+0x314e91>
180324e12: d4                          	<unknown>
180324e13: 4e 19 6d 58                 	sbbq	%r13, 0x58(%rbp)
180324e17: 8c 06                       	movw	%es, (%rsi)
180324e19: 5e                          	popq	%rsi
180324e1a: 91                          	xchgl	%ecx, %eax
180324e1b: 29 4c 34 ed                 	subl	%ecx, -0x13(%rsp,%rsi)
180324e1f: 30 f8                       	xorb	%bh, %al
180324e21: 84 5c f4 4e                 	testb	%bl, 0x4e(%rsp,%rsi,8)
180324e25: 46 a8 56                    	testb	$0x56, %al
180324e28: 73 4b                       	jae	0x180324e75 <.text+0x314e75>
180324e2a: 95                          	xchgl	%ebp, %eax
180324e2b: 1c c0                       	sbbb	$-0x40, %al
180324e2d: 06                          	<unknown>
180324e2e: 6a 07                       	pushq	$0x7
180324e30: 46 3a 71 a5                 	cmpb	-0x5b(%rcx), %r14b
180324e34: 74 b6                       	je	0x180324dec <.text+0x314dec>
180324e36: 15 12 32 cf 1b              	adcl	$0x1bcf3212, %eax       # imm = 0x1BCF3212
180324e3b: 9e                          	sahf
180324e3c: 7f 72                       	jg	0x180324eb0 <.text+0x314eb0>
180324e3e: fb                          	sti
180324e3f: c9                          	leave
180324e40: 33 88 75 a1 13 9d           	xorl	-0x62ec5e8b(%rax), %ecx
180324e46: 67 57                       	addr32		pushq	%rdi
180324e48: 9c                          	pushfq
180324e49: 05 93 d4 ec e0              	addl	$0xe0ecd493, %eax       # imm = 0xE0ECD493
180324e4e: b2 b6                       	movb	$-0x4a, %dl
180324e50: 0c 5b                       	orb	$0x5b, %al
180324e52: 90                          	nop
180324e53: ad                          	lodsl	(%rsi), %eax
180324e54: b2 df                       	movb	$-0x21, %dl
180324e56: 17                          	<unknown>
180324e57: 68 59 84 ab b6              	pushq	$-0x49547ba7            # imm = 0xB6AB8459
180324e5c: 85 f1                       	testl	%esi, %ecx
180324e5e: e1 b5                       	loope	0x180324e15 <.text+0x314e15>
180324e60: 3e 60                       	<unknown>
180324e62: 5d                          	popq	%rbp
180324e63: 98                          	cwtl
180324e64: c6 8a 4a aa 01 08           	<unknown>
180324e6a: 44 c7 fb                    	<unknown>
180324e6d: 42 5d                       	popq	%rbp
180324e6f: fa                          	cli
180324e70: df 4f f4                    	fisttps	-0xc(%rdi)
180324e73: 11 51 a9                    	adcl	%edx, -0x57(%rcx)
180324e76: 8d 36                       	leal	(%rsi), %esi
180324e78: 2a a7 5b 4e 45 18           	subb	0x18454e5b(%rdi), %ah
180324e7e: 9d                          	popfq
180324e7f: 29 02                       	subl	%eax, (%rdx)
180324e81: 18 08                       	sbbb	%cl, (%rax)
180324e83: b4 a6                       	movb	$-0x5a, %ah
180324e85: b4 80                       	movb	$-0x80, %ah
180324e87: c4 60 e1                    	<unknown>
180324e8a: 41 e8 d8 97 8f ef           	callq	0x16fc1e668
180324e90: 0d 46 9f 80 0d              	orl	$0xd809f46, %eax        # imm = 0xD809F46
180324e95: c1 ca 36                    	rorl	$0x36, %edx
180324e98: 62 38 1e dc                 	<unknown>
180324e9c: 77 ab                       	ja	0x180324e49 <.text+0x314e49>
180324e9e: db bb 15 16 b2 78           	fstpt	0x78b21615(%rbx)
180324ea4: 6a ab                       	pushq	$-0x55
180324ea6: 34 1f                       	xorb	$0x1f, %al
180324ea8: 19 ea                       	sbbl	%ebp, %edx
180324eaa: b4 f6                       	movb	$-0xa, %ah
180324eac: 00 35 ab 27 39 42           	addb	%dh, 0x423927ab(%rip)   # 0x1c26b765d
180324eb2: 6a 81                       	pushq	$-0x7f
180324eb4: ac                          	lodsb	(%rsi), %al
180324eb5: 9a                          	<unknown>
180324eb6: 3e 5b                       	popq	%rbx
180324eb8: 68 f1 54 f2 1a              	pushq	$0x1af254f1             # imm = 0x1AF254F1
180324ebd: ce                          	<unknown>
180324ebe: a7                          	cmpsl	%es:(%rdi), (%rsi)
180324ebf: 90                          	nop
180324ec0: 00 6c 95 f3                 	addb	%ch, -0xd(%rbp,%rdx,4)
180324ec4: e1 f7                       	loope	0x180324ebd <.text+0x314ebd>
180324ec6: 87 82 af 58 0d e7           	xchgl	%eax, -0x18f2a751(%rdx)
180324ecc: 3d 3c 31 aa 7b              	cmpl	$0x7baa313c, %eax       # imm = 0x7BAA313C
180324ed1: d7                          	xlatb
180324ed2: d4                          	<unknown>
180324ed3: 85 fd                       	testl	%edi, %ebp
180324ed5: 5a                          	popq	%rdx
180324ed6: 1c ee                       	sbbb	$-0x12, %al
180324ed8: a2 19 73 58 ea c5 4b 96 64  	movabsb	%al, 0x64964bc5ea587319
180324ee1: 99                          	cltd
180324ee2: 46 ae                       	scasb	%es:(%rdi), %al
180324ee4: e1 8f                       	loope	0x180324e75 <.text+0x314e75>
180324ee6: d6                          	<unknown>
180324ee7: 41 7b 84                    	jnp	0x180324e6e <.text+0x314e6e>
180324eea: 94                          	xchgl	%esp, %eax
180324eeb: 8b 0d 3f 9e bc 71           	movl	0x71bc9e3f(%rip), %ecx  # 0x1f1eeed30
180324ef1: 11 81 f0 6b 19 d6           	adcl	%eax, -0x29e69410(%rcx)
180324ef7: 5a                          	popq	%rdx
180324ef8: 03 65 a6                    	addl	-0x5a(%rbp), %esp
180324efb: 0b 25 6b 17 48 f2           	orl	-0xdb7e895(%rip), %esp  # 0x1727a666c
180324f01: b9 08 7c 6a 16              	movl	$0x166a7c08, %ecx       # imm = 0x166A7C08
180324f06: 75 aa                       	jne	0x180324eb2 <.text+0x314eb2>
180324f08: 41 62 cc 37 49 ec           	<unknown>
180324f0e: ce                          	<unknown>
180324f0f: e1 79                       	loope	0x180324f8a <.text+0x314f8a>
180324f11: 4c 0c 93                    	orb	$-0x6d, %al
180324f14: e2 26                       	loop	0x180324f3c <.text+0x314f3c>
180324f16: 2a 92 1b 86 bf 88           	subb	-0x774079e5(%rdx), %dl
180324f1c: f3 dd 9e 5b 35 d9 b0        	rep		fstpl	-0x4f26caa5(%rsi)
180324f23: 40 e5 46                    	inl	$0x46, %eax
180324f26: 24 86                       	andb	$-0x7a, %al
180324f28: e0 47                       	loopne	0x180324f71 <.text+0x314f71>
180324f2a: 3a 0d 85 ef 7a 7c           	cmpb	0x7c7aef85(%rip), %cl   # 0x1fcad3eb5
180324f30: 55                          	pushq	%rbp
180324f31: b8 7f b1 62 02              	movl	$0x262b17f, %eax        # imm = 0x262B17F
180324f36: bf 51 c3 52 c6              	movl	$0xc652c351, %edi       # imm = 0xC652C351
180324f3b: 79 e1                       	jns	0x180324f1e <.text+0x314f1e>
180324f3d: b1 05                       	movb	$0x5, %cl
180324f3f: fc                          	cld
180324f40: fc                          	cld
180324f41: 1d 53 98 13 d3              	sbbl	$0xd3139853, %eax       # imm = 0xD3139853
180324f46: 44 85 f6                    	testl	%r14d, %esi
180324f49: 9e                          	sahf
180324f4a: c1 3a 12                    	sarl	$0x12, (%rdx)
180324f4d: 98                          	cwtl
180324f4e: f9                          	stc
180324f4f: d5 f1 ef 44 9f 3c           	pxor	0x3c(%r31,%r19,4), %mm0
180324f55: 0a 86 76 f7 31 d9           	orb	-0x26ce088a(%rsi), %al
180324f5b: dd a3 7c aa 5d 94           	frstor	-0x6ba25584(%rbx)
180324f61: 73 9e                       	jae	0x180324f01 <.text+0x314f01>
180324f63: 6d                          	insl	%dx, %es:(%rdi)
180324f64: b6 7a                       	movb	$0x7a, %dh
180324f66: f7 64 39 7d                 	mull	0x7d(%rcx,%rdi)
180324f6a: c2 8b 2c                    	retq	$0x2c8b                 # imm = 0x2C8B
180324f6d: 65 dc e9                    	fsubr	%st, %st(1)
180324f70: 81 f4 cb 32 e1 41           	xorl	$0x41e132cb, %esp       # imm = 0x41E132CB
180324f76: c6 91 56 db 43 bf           	<unknown>
180324f7c: 1c bf                       	sbbb	$-0x41, %al
180324f7e: 7e ce                       	jle	0x180324f4e <.text+0x314f4e>
180324f80: 5c                          	popq	%rsp
180324f81: ad                          	lodsl	(%rsi), %eax
180324f82: 52                          	pushq	%rdx
180324f83: 9b                          	wait
180324f84: 5f                          	popq	%rdi
180324f85: 1a cd                       	sbbb	%ch, %cl
180324f87: 95                          	xchgl	%ebp, %eax
180324f88: be 4a 60 1e ae              	movl	$0xae1e604a, %esi       # imm = 0xAE1E604A
180324f8d: 18 01                       	sbbb	%al, (%rcx)
180324f8f: 65 aa                       	stosb	%al, %es:(%rdi)
180324f91: 10 49 81                    	adcb	%cl, -0x7f(%rcx)
180324f94: 61                          	<unknown>
180324f95: d8 9e 19 21 08 7d           	fcomps	0x7d082119(%rsi)
180324f9b: b4 93                       	movb	$-0x6d, %ah
180324f9d: 4b 18 89 32 93 a5 cb        	sbbb	%cl, -0x345a6cce(%r9)
180324fa4: eb 93                       	jmp	0x180324f39 <.text+0x314f39>
180324fa6: a6                          	cmpsb	%es:(%rdi), (%rsi)
180324fa7: a2 a4 b0 5a 78 ba 64 44 5a  	movabsb	%al, 0x5a4464ba785ab0a4
180324fb0: 9c                          	pushfq
180324fb1: e3 86                       	jrcxz	0x180324f39 <.text+0x314f39>
180324fb3: c8 c2 d3 3e                 	enter	$-0x2c3e, $0x3e         # imm = 0xD3C2
180324fb7: ac                          	lodsb	(%rsi), %al
180324fb8: 55                          	pushq	%rbp
180324fb9: 93                          	xchgl	%ebx, %eax
180324fba: 53                          	pushq	%rbx
180324fbb: af                          	scasl	%es:(%rdi), %eax
180324fbc: 84 52 56                    	testb	%dl, 0x56(%rdx)
180324fbf: 21 62 ef                    	andl	%esp, -0x11(%rdx)
180324fc2: ec                          	inb	%dx, %al
180324fc3: 28 00                       	subb	%al, (%rax)
180324fc5: 7c a2                       	jl	0x180324f69 <.text+0x314f69>
180324fc7: 92                          	xchgl	%edx, %eax
180324fc8: cf                          	iretl
180324fc9: 29 9d 7b d8 96 fa           	subl	%ebx, -0x5692785(%rbp)
180324fcf: ca f1 3e                    	lretl	$0x3ef1                 # imm = 0x3EF1
180324fd2: e6 9e                       	outb	%al, $0x9e
180324fd4: 39 26                       	cmpl	%esp, (%rsi)
180324fd6: 04 7a                       	addb	$0x7a, %al
180324fd8: 8e 5f 99                    	movw	-0x67(%rdi), %ds
180324fdb: 91                          	xchgl	%ecx, %eax
180324fdc: 7f 59                       	jg	0x180325037 <.text+0x315037>
180324fde: 32 97 20 03 5b 1b           	xorb	0x1b5b0320(%rdi), %dl
180324fe4: 34 b1                       	xorb	$-0x4f, %al
180324fe6: eb 2a                       	jmp	0x180325012 <.text+0x315012>
180324fe8: 0c e4                       	orb	$-0x1c, %al
180324fea: ba 60 e5 8e 4c              	movl	$0x4c8ee560, %edx       # imm = 0x4C8EE560
180324fef: f1                          	<unknown>
180324ff0: 3e b6 3e                    	movb	$0x3e, %dh
180324ff3: 86 ca                       	xchgb	%dl, %cl
180324ff5: de 2d 55 27 af bc           	fisubrs	-0x4350d8ab(%rip)       # 0x13ce17750
180324ffb: e9 0e f8 dc 44              	jmp	0x1c50f480e
180325000: 43 08 69 1c                 	orb	%bpl, 0x1c(%r9)
180325004: d2 61 a8                    	shlb	%cl, -0x58(%rcx)
180325007: cc                          	int3
180325008: d9 16                       	fsts	(%rsi)
18032500a: c9                          	leave
18032500b: ea                          	<unknown>
18032500c: 88 53 be                    	movb	%dl, -0x42(%rbx)
18032500f: 2e 8c d1                    	movl	%ss, %ecx
180325012: 31 b2 49 47 2c 04           	xorl	%esi, 0x42c4749(%rdx)
180325018: 53                          	pushq	%rbx
180325019: ab                          	stosl	%eax, %es:(%rdi)
18032501a: 95                          	xchgl	%ebp, %eax
18032501b: c0 7d ea 99                 	sarb	$0x99, -0x16(%rbp)
18032501f: 5c                          	popq	%rsp
180325020: 64 01 7b 44                 	addl	%edi, %fs:0x44(%rbx)
180325024: e5 33                       	inl	$0x33, %eax
180325026: 61                          	<unknown>
180325027: 17                          	<unknown>
180325028: 89 cf                       	movl	%ecx, %edi
18032502a: 54                          	pushq	%rsp
18032502b: 3f                          	<unknown>
18032502c: 39 b0 88 cd b4 90           	cmpl	%esi, -0x6f4b3278(%rax)
180325032: 25 5f d4 2f 4c              	andl	$0x4c2fd45f, %eax       # imm = 0x4C2FD45F
180325037: 48 9e                       	sahf
180325039: 52                          	pushq	%rdx
18032503a: 38 44 dd 9a                 	cmpb	%al, -0x66(%rbp,%rbx,8)
18032503e: d3 44 95 0a                 	roll	%cl, 0xa(%rbp,%rdx,4)
180325042: 26 23 c9                    	andl	%ecx, %ecx
180325045: 06                          	<unknown>
180325046: 18 6a 53                    	sbbb	%ch, 0x53(%rdx)
180325049: 03 9f 6d b0 b1 52           	addl	0x52b1b06d(%rdi), %ebx
18032504f: 6b 02 95                    	imull	$-0x6b, (%rdx), %eax
180325052: e2 9d                       	loop	0x180324ff1 <.text+0x314ff1>
180325054: 78 02                       	js	0x180325058 <.text+0x315058>
180325056: e5 cb                       	inl	$0xcb, %eax
180325058: e7 6e                       	outl	%eax, $0x6e
18032505a: 5a                          	popq	%rdx
18032505b: 2d 40 33 e1 aa              	subl	$0xaae13340, %eax       # imm = 0xAAE13340
180325060: 8f 84 1f 21 fd 94 98        	popq	-0x676b02df(%rdi,%rbx)
180325067: a9 2e 0c 1f 5e              	testl	$0x5e1f0c2e, %eax       # imm = 0x5E1F0C2E
18032506c: a7                          	cmpsl	%es:(%rdi), (%rsi)
18032506d: 2a 0b                       	subb	(%rbx), %cl
18032506f: 0d fb f7 5d 81              	orl	$0x815df7fb, %eax       # imm = 0x815DF7FB
180325074: ee                          	outb	%al, %dx
180325075: b4 fc                       	movb	$-0x4, %ah
180325077: 69 0f 48 7c e2 49           	imull	$0x49e27c48, (%rdi), %ecx # imm = 0x49E27C48
18032507d: e5 43                       	inl	$0x43, %eax
18032507f: af                          	scasl	%es:(%rdi), %eax
180325080: 24 6d                       	andb	$0x6d, %al
180325082: 15 53 71 1d 97              	adcl	$0x971d7153, %eax       # imm = 0x971D7153
180325087: 6f                          	outsl	(%rsi), %dx
180325088: 54                          	pushq	%rsp
180325089: 85 ad 2b a5 ec 7f           	testl	%ebp, 0x7feca52b(%rbp)
18032508f: 50                          	pushq	%rax
180325090: 58                          	popq	%rax
180325091: ef                          	outl	%eax, %dx
180325092: 18 6b c6                    	sbbb	%ch, -0x3a(%rbx)
180325095: ad                          	lodsl	(%rsi), %eax
180325096: 0a ee                       	orb	%dh, %ch
180325098: bd 21 8d 81 36              	movl	$0x36818d21, %ebp       # imm = 0x36818D21
18032509d: 52                          	pushq	%rdx
18032509e: 60                          	<unknown>
18032509f: cb                          	lretl
1803250a0: 62 ed 5a d7 52 60 4f        	<unknown>
1803250a7: 2e 84 91 30 53 d9 7b        	testb	%dl, %cs:0x7bd95330(%rcx)
1803250ae: 61                          	<unknown>
1803250af: 78 75                       	js	0x180325126 <.text+0x315126>
1803250b1: 2b 1d 96 54 3b 52           	subl	0x523b5496(%rip), %ebx  # 0x1d26da54d
1803250b7: 30 7c 3a c7                 	xorb	%bh, -0x39(%rdx,%rdi)
1803250bb: 5d                          	popq	%rbp
1803250bc: 69 70 16 19 56 cf c6        	imull	$0xc6cf5619, 0x16(%rax), %esi # imm = 0xC6CF5619
1803250c3: e6 d4                       	outb	%al, $0xd4
1803250c5: 5c                          	popq	%rsp
1803250c6: 81 c5 c2 75 1e 54           	addl	$0x541e75c2, %ebp       # imm = 0x541E75C2
1803250cc: 3a 02                       	cmpb	(%rdx), %al
1803250ce: fd                          	std
1803250cf: f6 38                       	idivb	(%rax)
1803250d1: 3a 87 c0 3c ae c6           	cmpb	-0x3951c340(%rdi), %al
1803250d7: ed                          	inl	%dx, %eax
1803250d8: 2a a6 54 7c 88 9f           	subb	-0x607783ac(%rsi), %ah
1803250de: 39 ac 47 16 84 d5 3e        	cmpl	%ebp, 0x3ed58416(%rdi,%rax,2)
1803250e5: 82                          	<unknown>
1803250e6: 07                          	<unknown>
1803250e7: 60                          	<unknown>
1803250e8: bc e0 1f 53 3b              	movl	$0x3b531fe0, %esp       # imm = 0x3B531FE0
1803250ed: 64 b8 f6 1b 7f 09           	movl	$0x97f1bf6, %eax        # imm = 0x97F1BF6
1803250f3: a9 68 27 06 ec              	testl	$0xec062768, %eax       # imm = 0xEC062768
1803250f8: 2a 95 c1 91 21 10           	subb	0x102191c1(%rbp), %dl
1803250fe: 4c 2a a8 af 20 ed 80        	subb	-0x7f12df51(%rax), %r13b
180325105: 44 fd                       	std
180325107: e9 16 6b 1e cc              	jmp	0x14c50bc22
18032510c: 7f f4                       	jg	0x180325102 <.text+0x315102>
18032510e: d9 7c c7 43                 	fnstcw	0x43(%rdi,%rax,8)
180325112: 76 d1                       	jbe	0x1803250e5 <.text+0x3150e5>
180325114: 15 6a 24 46 1b              	adcl	$0x1b46246a, %eax       # imm = 0x1B46246A
180325119: 29 b3 a1 dc bd 21           	subl	%esi, 0x21bddca1(%rbx)
18032511f: 15 79 43 1f 60              	adcl	$0x601f4379, %eax       # imm = 0x601F4379
180325124: 0d 72 20 03 b4              	orl	$0xb4032072, %eax       # imm = 0xB4032072
180325129: 71 47                       	jno	0x180325172 <.text+0x315172>
18032512b: 7d 41                       	jge	0x18032516e <.text+0x31516e>
18032512d: da 5c 81 e2                 	ficompl	-0x1e(%rcx,%rax,4)
180325131: e7 11                       	outl	%eax, $0x11
180325133: 4c a0 49 04 a9 51 ab 2b e7 8f       	movabsb	-0x7018d454ae56fbb7, %al
18032513d: 07                          	<unknown>
18032513e: 12 d6                       	adcb	%dh, %dl
180325140: 15 ce 20 ba 46              	adcl	$0x46ba20ce, %eax       # imm = 0x46BA20CE
180325145: 52                          	pushq	%rdx
180325146: 14 bf                       	adcb	$-0x41, %al
180325148: 3f                          	<unknown>
180325149: f5                          	cmc
18032514a: d9 54 41 a7                 	fsts	-0x59(%rcx,%rax,2)
18032514e: 4a ab                       	stosq	%rax, %es:(%rdi)
180325150: a3 c5 fe e5 22 57 e5 f8 06  	movabsl	%eax, 0x6f8e55722e5fec5
180325159: fe f9                       	<unknown>
18032515b: 8b b9 98 8e 6b 7c           	movl	0x7c6b8e98(%rcx), %edi
180325161: 0c e8                       	orb	$-0x18, %al
180325163: 55                          	pushq	%rbp
180325164: e2 9d                       	loop	0x180325103 <.text+0x315103>
180325166: 32 4f de                    	xorb	-0x22(%rdi), %cl
180325169: 3e f7 eb                    	imull	%ebx
18032516c: dd e6                       	fucom	%st(6)
18032516e: b0 c9                       	movb	$-0x37, %al
180325170: 10 50 e8                    	adcb	%dl, -0x18(%rax)
180325173: bf e9 f0 6c c0              	movl	$0xc06cf0e9, %edi       # imm = 0xC06CF0E9
180325178: 26 32 e4                    	xorb	%ah, %ah
18032517b: 5b                          	popq	%rbx
18032517c: 87 74 04 88                 	xchgl	%esi, -0x78(%rsp,%rax)
180325180: 25 50 9e 46 7f              	andl	$0x7f469e50, %eax       # imm = 0x7F469E50
180325185: 1f                          	<unknown>
180325186: c8 70 33 e6                 	enter	$0x3370, $-0x1a         # imm = 0x3370
18032518a: ae                          	scasb	%es:(%rdi), %al
18032518b: dc d8                       	<unknown>
18032518d: b6 f6                       	movb	$-0xa, %dh
18032518f: f5                          	cmc
180325190: 5e                          	popq	%rsi
180325191: e5 ac                       	inl	$0xac, %eax
180325193: 3f                          	<unknown>
180325194: 7f 4f                       	jg	0x1803251e5 <.text+0x3151e5>
180325196: b8 c9 3f 12 f9              	movl	$0xf9123fc9, %eax       # imm = 0xF9123FC9
18032519b: ed                          	inl	%dx, %eax
18032519c: a9 12 01 d3 27              	testl	$0x27d30112, %eax       # imm = 0x27D30112
1803251a1: d5 a8 88 5b 4c ed 0c        	js	0x18d1f9e03
1803251a8: 7d 5c                       	jge	0x180325206 <.text+0x315206>
1803251aa: 56                          	pushq	%rsi
1803251ab: 9e                          	sahf
1803251ac: 36 15 18 63 b7 07           	adcl	$0x7b76318, %eax        # imm = 0x7B76318
1803251b2: 79 8e                       	jns	0x180325142 <.text+0x315142>
1803251b4: e6 69                       	outb	%al, $0x69
1803251b6: 3b 54 d3 cc                 	cmpl	-0x34(%rbx,%rdx,8), %edx
1803251ba: a1 3d 11 0f b1 33 0b cd 21  	movabsl	0x21cd0b33b10f113d, %eax
1803251c3: ee                          	outb	%al, %dx
1803251c4: 65 24 62                    	andb	$0x62, %al
1803251c7: ac                          	lodsb	(%rsi), %al
1803251c8: 60                          	<unknown>
1803251c9: ae                          	scasb	%es:(%rdi), %al
1803251ca: 7e d0                       	jle	0x18032519c <.text+0x31519c>
1803251cc: 9e                          	sahf
1803251cd: e2 3a                       	loop	0x180325209 <.text+0x315209>
1803251cf: 16                          	<unknown>
1803251d0: 52                          	pushq	%rdx
1803251d1: 78 99                       	js	0x18032516c <.text+0x31516c>
1803251d3: 01 9e 34 a5 16 de           	addl	%ebx, -0x21e95acc(%rsi)
1803251d9: c5 89 79                    	<unknown>
1803251dc: a4                          	movsb	(%rsi), %es:(%rdi)
1803251dd: 13 42 a5                    	adcl	-0x5b(%rdx), %eax
1803251e0: dc 89 f0 94 ad 5a           	fmull	0x5aad94f0(%rcx)
1803251e6: 14 18                       	adcb	$0x18, %al
1803251e8: 1d 32 88 46 b5              	sbbl	$0xb5468832, %eax       # imm = 0xB5468832
1803251ed: a3 18 ea a8 66 92 e4 31 99  	movabsl	%eax, -0x66ce1b6d995715e8
1803251f6: ec                          	inb	%dx, %al
1803251f7: aa                          	stosb	%al, %es:(%rdi)
1803251f8: 22 49 5e                    	andb	0x5e(%rcx), %cl
1803251fb: 2c 89                       	subb	$-0x77, %al
1803251fd: 53                          	pushq	%rbx
1803251fe: 2a d6                       	subb	%dh, %dl
180325200: 4c c7 cd                    	<unknown>
180325203: 50                          	pushq	%rax
180325204: 01 81 b8 69 64 b5           	addl	%eax, -0x4a9b9648(%rcx)
18032520a: b6 42                       	movb	$0x42, %dh
18032520c: 5a                          	popq	%rdx
18032520d: 64 30 ae fc f7 2c ec        	xorb	%ch, %fs:-0x13d30804(%rsi)
180325214: 03 d6                       	addl	%esi, %edx
180325216: 01 34 03                    	addl	%esi, (%rbx,%rax)
180325219: 27                          	<unknown>
18032521a: 9d                          	popfq
18032521b: cb                          	lretl
18032521c: 92                          	xchgl	%edx, %eax
18032521d: 47 4f 4b 32 ac fa 09 48 9f 74       	xorb	0x749f4809(%r10,%r15,8), %bpl
180325227: 10 3b                       	adcb	%bh, (%rbx)
180325229: 9b                          	wait
18032522a: 88 cc                       	movb	%cl, %ah
18032522c: 2e d7                       	xlatb
18032522e: f4                          	hlt
18032522f: dd c3                       	ffree	%st(3)
180325231: 48 1f                       	<unknown>
180325233: 53                          	pushq	%rbx
180325234: 6f                          	outsl	(%rsi), %dx
180325235: 57                          	pushq	%rdi
180325236: 74 44                       	je	0x18032527c <.text+0x31527c>
180325238: cc                          	int3
180325239: 06                          	<unknown>
18032523a: b8 c4 c1 6e 7d              	movl	$0x7d6ec1c4, %eax       # imm = 0x7D6EC1C4
18032523f: 20 98 4f 88 45 5d           	andb	%bl, 0x5d45884f(%rax)
180325245: ec                          	inb	%dx, %al
180325246: 59                          	popq	%rcx
180325247: d1 3c bf                    	sarl	(%rdi,%rdi,4)
18032524a: 97                          	xchgl	%edi, %eax
18032524b: de 69 a0                    	fisubrs	-0x60(%rcx)
18032524e: 5e                          	popq	%rsi
18032524f: 6c                          	insb	%dx, %es:(%rdi)
180325250: 38 f9                       	cmpb	%bh, %cl
180325252: fa                          	cli
180325253: 0a d0                       	orb	%al, %dl
180325255: 78 a4                       	js	0x1803251fb <.text+0x3151fb>
180325257: 56                          	pushq	%rsi
180325258: db 0f                       	fisttpl	(%rdi)
18032525a: ad                          	lodsl	(%rsi), %eax
18032525b: c9                          	leave
18032525c: 8a 74 97 07                 	movb	0x7(%rdi,%rdx,4), %dh
180325260: 6b 07 d7                    	imull	$-0x29, (%rdi), %eax
180325263: 43 89 fc                    	movl	%edi, %r12d
180325266: 50                          	pushq	%rax
180325267: 5c                          	popq	%rsp
180325268: da 1e                       	ficompl	(%rsi)
18032526a: 94                          	xchgl	%esp, %eax
18032526b: 23 0d 14 aa 40 b4           	andl	-0x4bbf55ec(%rip), %ecx # 0x13472fc85
180325271: 91                          	xchgl	%ecx, %eax
180325272: ed                          	inl	%dx, %eax
180325273: 95                          	xchgl	%ebp, %eax
180325274: 8a 95 f1 7c 4c 61           	movb	0x614c7cf1(%rbp), %dl
18032527a: 17                          	<unknown>
18032527b: 14 c4                       	adcb	$-0x3c, %al
18032527d: fa                          	cli
18032527e: 56                          	pushq	%rsi
18032527f: b4 79                       	movb	$0x79, %ah
180325281: 59                          	popq	%rcx
180325282: ac                          	lodsb	(%rsi), %al
180325283: 91                          	xchgl	%ecx, %eax
180325284: 4f cd 60                    	int	$0x60
180325287: b7 a7                       	movb	$-0x59, %bh
180325289: 41 ee                       	outb	%al, %dx
18032528b: 0c 1d                       	orb	$0x1d, %al
18032528d: 26 8a db                    	movb	%bl, %bl
180325290: 7a 5b                       	jp	0x1803252ed <.text+0x3152ed>
180325292: 0b 62 9f                    	orl	-0x61(%rdx), %esp
180325295: 5f                          	popq	%rdi
180325296: 32 6d c3                    	xorb	-0x3d(%rbp), %ch
180325299: 2e b6 b8                    	movb	$-0x48, %dh
18032529c: 94                          	xchgl	%esp, %eax
18032529d: 49 f3 7a 3f                 	rep		jp	0x1803252e0 <.text+0x3152e0>
1803252a1: ec                          	inb	%dx, %al
1803252a2: f6 b3 d5 a0 d9 58           	divb	0x58d9a0d5(%rbx)
1803252a8: ae                          	scasb	%es:(%rdi), %al
1803252a9: 6a 73                       	pushq	$0x73
1803252ab: 86 9c b5 03 c0 90 f8        	xchgb	%bl, -0x76f3ffd(%rbp,%rsi,4)
1803252b2: ce                          	<unknown>
1803252b3: be d9 d3 05 82              	movl	$0x8205d3d9, %esi       # imm = 0x8205D3D9
1803252b8: e6 6a                       	outb	%al, $0x6a
1803252ba: e3 7b                       	jrcxz	0x180325337 <.text+0x315337>
1803252bc: bf e1 7a 8c af              	movl	$0xaf8c7ae1, %edi       # imm = 0xAF8C7AE1
1803252c1: ee                          	outb	%al, %dx
1803252c2: bf 99 0b 7a 6c              	movl	$0x6c7a0b99, %edi       # imm = 0x6C7A0B99
1803252c7: 36 a4                       	movsb	%ss:(%rsi), %es:(%rdi)
1803252c9: 0b db                       	orl	%ebx, %ebx
1803252cb: f2 50                       	repne		pushq	%rax
1803252cd: ef                          	outl	%eax, %dx
1803252ce: 6e                          	outsb	(%rsi), %dx
1803252cf: 9a                          	<unknown>
1803252d0: f8                          	clc
1803252d1: b8 70 c3 f5 f6              	movl	$0xf6f5c370, %eax       # imm = 0xF6F5C370
1803252d6: 69 5c e7 fd e0 d9 85 96     	imull	$0x9685d9e0, -0x3(%rdi,%riz,8), %ebx # imm = 0x9685D9E0
1803252de: fe 83 bd b4 f4 37           	incb	0x37f4b4bd(%rbx)
1803252e4: 0f 12 fd                    	movhlps	%xmm5, %xmm7            # xmm7 = xmm5[1],xmm7[1]
1803252e7: 7c 8c                       	jl	0x180325275 <.text+0x315275>
1803252e9: c2 39 5f                    	retq	$0x5f39                 # imm = 0x5F39
1803252ec: ce                          	<unknown>
1803252ed: 1a 7d 17                    	sbbb	0x17(%rbp), %bh
1803252f0: 1f                          	<unknown>
1803252f1: 13 3e                       	adcl	(%rsi), %edi
1803252f3: 37                          	<unknown>
1803252f4: 82                          	<unknown>
1803252f5: be 6e 06 f2 89              	movl	$0x89f2066e, %esi       # imm = 0x89F2066E
1803252fa: 45 44 46 ea                 	<unknown>
1803252fe: b7 ac                       	movb	$-0x54, %bh
180325300: aa                          	stosb	%al, %es:(%rdi)
180325301: a7                          	cmpsl	%es:(%rdi), (%rsi)
180325302: bb b6 93 7c 53              	movl	$0x537c93b6, %ebx       # imm = 0x537C93B6
180325307: 9c                          	pushfq
180325308: c8 f0 34 5a                 	enter	$0x34f0, $0x5a          # imm = 0x34F0
18032530c: ef                          	outl	%eax, %dx
18032530d: b4 92                       	movb	$-0x6e, %ah
18032530f: 46 de 88 90 f4 ac 3b        	fimuls	0x3bacf490(%rax)
180325316: 52                          	pushq	%rdx
180325317: fa                          	cli
180325318: c2 00 dd                    	retq	$-0x2300                # imm = 0xDD00
18032531b: 6d                          	insl	%dx, %es:(%rdi)
18032531c: f1                          	<unknown>
18032531d: 85 6d a7                    	testl	%ebp, -0x59(%rbp)
180325320: 92                          	xchgl	%edx, %eax
180325321: 45 85 7a 3a                 	testl	%r15d, 0x3a(%r10)
180325325: 4d fc                       	cld
180325327: ae                          	scasb	%es:(%rdi), %al
180325328: eb ef                       	jmp	0x180325319 <.text+0x315319>
18032532a: e9 d6 93 79 6b              	jmp	0x1ebabe705
18032532f: 2f                          	<unknown>
180325330: d5 9d e7 20                 	movntq	%mm4, (%r24)
180325334: c4 98 fd                    	<unknown>
180325337: 12 22                       	adcb	(%rdx), %ah
180325339: dc 79 96                    	fdivrl	-0x6a(%rcx)
18032533c: 7a 65                       	jp	0x1803253a3 <.text+0x3153a3>
18032533e: 64 c7 3c 22                 	<unknown>
180325342: 38 68 c0                    	cmpb	%ch, -0x40(%rax)
180325345: db be 07 bc 87 51           	fstpt	0x5187bc07(%rsi)
18032534b: 11 2e                       	adcl	%ebp, (%rsi)
18032534d: 5a                          	popq	%rdx
18032534e: f6 38                       	idivb	(%rax)
180325350: af                          	scasl	%es:(%rdi), %eax
180325351: 1f                          	<unknown>
180325352: 01 80 e2 a3 76 75           	addl	%eax, 0x7576a3e2(%rax)
180325358: cc                          	int3
180325359: c6 13                       	<unknown>
18032535b: ab                          	stosl	%eax, %es:(%rdi)
18032535c: 31 91 ee 63 fc 02           	xorl	%edx, 0x2fc63ee(%rcx)
180325362: 76 3e                       	jbe	0x1803253a2 <.text+0x3153a2>
180325364: 39 74 eb 9b                 	cmpl	%esi, -0x65(%rbx,%rbp,8)
180325368: 19 f2                       	sbbl	%esi, %edx
18032536a: f7 d2                       	notl	%edx
18032536c: 01 c9                       	addl	%ecx, %ecx
18032536e: 10 a3 7b 25 37 ba           	adcb	%ah, -0x45c8da85(%rbx)
180325374: 83 09 c3                    	orl	$-0x3d, (%rcx)
180325377: 14 5e                       	adcb	$0x5e, %al
180325379: d3 d7                       	rcll	%cl, %edi
18032537b: 12 f9                       	adcb	%cl, %bh
18032537d: 2b be 23 c7 bd e1           	subl	-0x1e4238dd(%rsi), %edi
180325383: 6d                          	insl	%dx, %es:(%rdi)
180325384: ea                          	<unknown>
180325385: f2 70 83                    	repne		jo	0x18032530b <.text+0x31530b>
180325388: e6 1f                       	outb	%al, $0x1f
18032538a: a7                          	cmpsl	%es:(%rdi), (%rsi)
18032538b: 52                          	pushq	%rdx
18032538c: 04 9e                       	addb	$-0x62, %al
18032538e: 6c                          	insb	%dx, %es:(%rdi)
18032538f: ab                          	stosl	%eax, %es:(%rdi)
180325390: ee                          	outb	%al, %dx
180325391: d2 0c 6d 43 c5 e4 c3        	rorb	%cl, -0x3c1b3abd(,%rbp,2)
180325398: 73 11                       	jae	0x1803253ab <.text+0x3153ab>
18032539a: 9d                          	popfq
18032539b: 29 48 d0                    	subl	%ecx, -0x30(%rax)
18032539e: 04 8a                       	addb	$-0x76, %al
1803253a0: b2 9d                       	movb	$-0x63, %dl
1803253a2: a8 ab                       	testb	$-0x55, %al
1803253a4: 94                          	xchgl	%esp, %eax
1803253a5: c4 ce c0                    	<unknown>
1803253a8: ca 3a da                    	lretl	$-0x25c6                # imm = 0xDA3A
1803253ab: 54                          	pushq	%rsp
1803253ac: 6d                          	insl	%dx, %es:(%rdi)
1803253ad: 2c 19                       	subb	$0x19, %al
1803253af: b7 6a                       	movb	$0x6a, %bh
1803253b1: 41 1e                       	<unknown>
1803253b3: 81 b2 0d ef 3e 8e e8 29 f7 42       	xorl	$0x42f729e8, -0x71c110f3(%rdx) # imm = 0x42F729E8
1803253bd: 2e 3b c1                    	cmpl	%ecx, %eax
1803253c0: 1e                          	<unknown>
1803253c1: 30 08                       	xorb	%cl, (%rax)
1803253c3: d3 70 e3                    	<unknown>
1803253c6: 5c                          	popq	%rsp
1803253c7: ce                          	<unknown>
1803253c8: 7f 9b                       	jg	0x180325365 <.text+0x315365>
1803253ca: 38 e9                       	cmpb	%ch, %cl
1803253cc: a9 c9 a5 8c 85              	testl	$0x858ca5c9, %eax       # imm = 0x858CA5C9
1803253d1: da c9                       	fcmove	%st(1), %st
1803253d3: 85 8b 58 10 18 a5           	testl	%ecx, -0x5ae7efa8(%rbx)
1803253d9: f2 9e                       	repne		sahf
1803253db: 3f                          	<unknown>
1803253dc: f6 93 7c 86 fb f7           	notb	-0x8047984(%rbx)
1803253e2: f7 7b 42                    	idivl	0x42(%rbx)
1803253e5: b3 38                       	movb	$0x38, %bl
1803253e7: ec                          	inb	%dx, %al
1803253e8: 14 8a                       	adcb	$-0x76, %al
1803253ea: d2 a9 82 ce d5 ba           	shrb	%cl, -0x452a317e(%rcx)
1803253f0: a8 1f                       	testb	$0x1f, %al
1803253f2: 98                          	cwtl
1803253f3: 7d fd                       	jge	0x1803253f2 <.text+0x3153f2>
1803253f5: d6                          	<unknown>
1803253f6: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803253f7: 25 50 52 54 2f              	andl	$0x2f545250, %eax       # imm = 0x2F545250
1803253fc: 39 da                       	cmpl	%ebx, %edx
1803253fe: 55                          	pushq	%rbp
1803253ff: 75 50                       	jne	0x180325451 <.text+0x315451>
180325401: 18 f8                       	sbbb	%bh, %al
180325403: c6 09                       	<unknown>
180325405: 7a fb                       	jp	0x180325402 <.text+0x315402>
180325407: 43 44 59                    	popq	%rcx
18032540a: a7                          	cmpsl	%es:(%rdi), (%rsi)
18032540b: ab                          	stosl	%eax, %es:(%rdi)
18032540c: b5 68                       	movb	$0x68, %ch
18032540e: 1e                          	<unknown>
18032540f: 61                          	<unknown>
180325410: 0f ed 11                    	paddsw	(%rcx), %mm2
180325413: c9                          	leave
180325414: 2a cd                       	subb	%ch, %cl
180325416: 3f                          	<unknown>
180325417: 2d d6 5c a9 23              	subl	$0x23a95cd6, %eax       # imm = 0x23A95CD6
18032541c: fd                          	std
18032541d: 4c 60                       	<unknown>
18032541f: 6b 51 2e 86                 	imull	$-0x7a, 0x2e(%rcx), %edx
180325423: 95                          	xchgl	%ebp, %eax
180325424: b7 50                       	movb	$0x50, %bh
180325426: 1c a6                       	sbbb	$-0x5a, %al
180325428: 2f                          	<unknown>
180325429: 76 7a                       	jbe	0x1803254a5 <.text+0x3154a5>
18032542b: bd 64 52 11 e7              	movl	$0xe7115264, %ebp       # imm = 0xE7115264
180325430: 49 9c                       	pushfq
180325432: c8 cd 10 f9                 	enter	$0x10cd, $-0x7          # imm = 0x10CD
180325436: 2f                          	<unknown>
180325437: ba 30 7a a5 bc              	movl	$0xbca57a30, %edx       # imm = 0xBCA57A30
18032543c: 63 50 5e                    	movslq	0x5e(%rax), %edx
18032543f: c4 96 e0                    	<unknown>
180325442: 82                          	<unknown>
180325443: b0 d9                       	movb	$-0x27, %al
180325445: 95                          	xchgl	%ebp, %eax
180325446: ae                          	scasb	%es:(%rdi), %al
180325447: df f9                       	<unknown>
180325449: d2 c0                       	rolb	%cl, %al
18032544b: d8 94 09 f9 28 c9 fa        	fcoms	-0x536d707(%rcx,%rcx)
180325452: bf 39 b4 8d 7a              	movl	$0x7a8db439, %edi       # imm = 0x7A8DB439
180325457: 49 22 c3                    	andb	%r11b, %al
18032545a: a6                          	cmpsb	%es:(%rdi), (%rsi)
18032545b: d7                          	xlatb
18032545c: 93                          	xchgl	%ebx, %eax
18032545d: c9                          	leave
18032545e: 85 1e                       	testl	%ebx, (%rsi)
180325460: 6d                          	insl	%dx, %es:(%rdi)
180325461: d0 ca                       	rorb	%dl
180325463: 23 ad 44 f5 6c 02           	andl	0x26cf544(%rbp), %ebp
180325469: 86 3b                       	xchgb	%bh, (%rbx)
18032546b: 36 35 59 25 68 1c           	xorl	$0x1c682559, %eax       # imm = 0x1C682559
180325471: 3a 18                       	cmpb	(%rax), %bl
180325473: 47 1f                       	<unknown>
180325475: 09 09                       	orl	%ecx, (%rcx)
180325477: fe 02                       	incb	(%rdx)
180325479: 31 7b c1                    	xorl	%edi, -0x3f(%rbx)
18032547c: 90                          	nop
18032547d: 8c f1                       	<unknown>
18032547f: 63 97 03 fd c8 85           	movslq	-0x7a3702fd(%rdi), %edx
180325485: 0d 9a e1 53 7b              	orl	$0x7b53e19a, %eax       # imm = 0x7B53E19A
18032548a: b1 69                       	movb	$0x69, %cl
18032548c: 1f                          	<unknown>
18032548d: 34 1b                       	xorb	$0x1b, %al
18032548f: a3 d0 59 ab 36 f2 22 0a 9a  	movabsl	%eax, -0x65f5dd0dc954a630
180325498: 5b                          	popq	%rbx
180325499: 1b f8                       	sbbl	%eax, %edi
18032549b: e4 b4                       	inb	$0xb4, %al
18032549d: 82                          	<unknown>
18032549e: 36 3d 30 cc 57 dc           	cmpl	$0xdc57cc30, %eax       # imm = 0xDC57CC30
1803254a4: 3f                          	<unknown>
1803254a5: 03 80 01 5d 7f 27           	addl	0x277f5d01(%rax), %eax
1803254ab: 3a c3                       	cmpb	%bl, %al
1803254ad: b2 ef                       	movb	$-0x11, %dl
1803254af: 79 da                       	jns	0x18032548b <.text+0x31548b>
1803254b1: a5                          	movsl	(%rsi), %es:(%rdi)
1803254b2: 4e 4f 05 91 0a c0 82        	addq	$-0x7d3ff56f, %rax      # imm = 0x82C00A91
1803254b9: f6 77 ef                    	divb	-0x11(%rdi)
1803254bc: cd 2b                       	int	$0x2b
1803254be: 68 0b 00 28 64              	pushq	$0x6428000b             # imm = 0x6428000B
1803254c3: 39 f0                       	cmpl	%esi, %eax
1803254c5: 2f                          	<unknown>
1803254c6: 52                          	pushq	%rdx
1803254c7: c1 a7 b8 50 a2 11 af        	shll	$0xaf, 0x11a250b8(%rdi)
1803254ce: 9c                          	pushfq
1803254cf: f7 2a                       	imull	(%rdx)
1803254d1: 6e                          	outsb	(%rsi), %dx
1803254d2: 40 5f                       	popq	%rdi
1803254d4: d6                          	<unknown>
1803254d5: 7a 81                       	jp	0x180325458 <.text+0x315458>
1803254d7: 1f                          	<unknown>
1803254d8: 38 66 6a                    	cmpb	%ah, 0x6a(%rsi)
1803254db: 44 85 1a                    	testl	%r11d, (%rdx)
1803254de: 48 1c 56                    	sbbb	$0x56, %al
1803254e1: 57                          	pushq	%rdi
1803254e2: a0 f9 b8 8e 59 ac 05 90 95  	movabsb	-0x6a6ffa53a6714707, %al
1803254eb: 13 ae 16 06 73 61           	adcl	0x61730616(%rsi), %ebp
1803254f1: f4                          	hlt
1803254f2: d7                          	xlatb
1803254f3: 6a 68                       	pushq	$0x68
1803254f5: c0 b3 b6 c0 e4 52           	<unknown>
1803254fb: c0 2b 69                    	shrb	$0x69, (%rbx)
1803254fe: f8                          	clc
1803254ff: 7d e3                       	jge	0x1803254e4 <.text+0x3154e4>
180325501: 51                          	pushq	%rcx
180325502: 4f 64 fd                    	std
180325505: 0e                          	<unknown>
180325506: a4                          	movsb	(%rsi), %es:(%rdi)
180325507: 69 f5 42 06 61 56           	imull	$0x56610642, %ebp, %esi # imm = 0x56610642
18032550d: 20 bd 1e aa a4 04           	andb	%bh, 0x4a4aa1e(%rbp)
180325513: 99                          	cltd
180325514: 86 6f 33                    	xchgb	%ch, 0x33(%rdi)
180325517: 6a 48                       	pushq	$0x48
180325519: 73 81                       	jae	0x18032549c <.text+0x31549c>
18032551b: a0 9a 51 94 85 4c d3 ae f8  	movabsb	-0x7512cb37a6bae66, %al
180325524: 1d 4d d8 ba 22              	sbbl	$0x22bad84d, %eax       # imm = 0x22BAD84D
180325529: 3a 2f                       	cmpb	(%rdi), %ch
18032552b: 72 80                       	jb	0x1803254ad <.text+0x3154ad>
18032552d: 7f db                       	jg	0x18032550a <.text+0x31550a>
18032552f: 67 61                       	<unknown>
180325531: cf                          	iretl
180325532: 76 d2                       	jbe	0x180325506 <.text+0x315506>
180325534: cd 75                       	int	$0x75
180325536: fd                          	std
180325537: 06                          	<unknown>
180325538: f2 e6 6a                    	repne		outb	%al, $0x6a
18032553b: d9 67 b0                    	fldenv	-0x50(%rdi)
18032553e: 06                          	<unknown>
18032553f: 45 fa                       	cli
180325541: 46 b9 40 07 3e ac           	movl	$0xac3e0740, %ecx       # imm = 0xAC3E0740
180325547: 37                          	<unknown>
180325548: 12 c2                       	adcb	%dl, %al
18032554a: 68 ab 26 17 95              	pushq	$-0x6ae8d955            # imm = 0x951726AB
18032554f: 5b                          	popq	%rbx
180325550: 2f                          	<unknown>
180325551: 23 69 fe                    	andl	-0x2(%rcx), %ebp
180325554: 16                          	<unknown>
180325555: 21 e8                       	andl	%ebp, %eax
180325557: 43 5a                       	popq	%r10
180325559: 80 ce 4a                    	orb	$0x4a, %dh
18032555c: cb                          	lretl
18032555d: f3 08 df                    	rep		orb	%bl, %bh
180325560: 4f 45 bd 96 61 fc 12        	movl	$0x12fc6196, %r13d      # imm = 0x12FC6196
180325567: ac                          	lodsb	(%rsi), %al
180325568: 4e e4 bf                    	inb	$0xbf, %al
18032556b: 6c                          	insb	%dx, %es:(%rdi)
18032556c: 77 28                       	ja	0x180325596 <.text+0x315596>
18032556e: 77 b1                       	ja	0x180325521 <.text+0x315521>
180325570: 56                          	pushq	%rsi
180325571: 82                          	<unknown>
180325572: d2 04 35 16 66 de 70        	rolb	%cl, 0x70de6616(,%rsi)
180325579: e4 3a                       	inb	$0x3a, %al
18032557b: e7 65                       	outl	%eax, $0x65
18032557d: 81 1c a3 09 5a 6a 21        	sbbl	$0x216a5a09, (%rbx,%riz,4) # imm = 0x216A5A09
180325584: 4c 66 cd 2a                 	int	$0x2a
180325588: a7                          	cmpsl	%es:(%rdi), (%rsi)
180325589: 02 94 04 5d d6 07 48        	addb	0x4807d65d(%rsp,%rax), %dl
180325590: f0                          	lock
180325591: 7a 46                       	jp	0x1803255d9 <.text+0x3155d9>
180325593: 75 ba                       	jne	0x18032554f <.text+0x31554f>
180325595: 18 dc                       	sbbb	%bl, %ah
180325597: a2 ad 9f 0e d7 e4 6c 0b 9f  	movabsb	%al, -0x60f4931b28f16053
1803255a0: c9                          	leave
1803255a1: f7 7f dd                    	idivl	-0x23(%rdi)
1803255a4: 53                          	pushq	%rbx
1803255a5: 1d b0 bc ea 6e              	sbbl	$0x6eeabcb0, %eax       # imm = 0x6EEABCB0
1803255aa: 90                          	nop
1803255ab: 72 74                       	jb	0x180325621 <.text+0x315621>
1803255ad: 78 ef                       	js	0x18032559e <.text+0x31559e>
1803255af: 1f                          	<unknown>
1803255b0: a9 0d d7 2e 05              	testl	$0x52ed70d, %eax        # imm = 0x52ED70D
1803255b5: 74 01                       	je	0x1803255b8 <.text+0x3155b8>
1803255b7: f9                          	stc
1803255b8: c7 22                       	<unknown>
1803255ba: e9 0e 11 25 ec              	jmp	0x16c5766cd
1803255bf: d1 8f 4a b5 cb 62           	rorl	0x62cbb54a(%rdi)
1803255c5: 72 0d                       	jb	0x1803255d4 <.text+0x3155d4>
1803255c7: 04 52                       	addb	$0x52, %al
1803255c9: c7 63 15                    	<unknown>
1803255cc: 92                          	xchgl	%edx, %eax
1803255cd: 32 33                       	xorb	(%rbx), %dh
1803255cf: 1f                          	<unknown>
1803255d0: 5a                          	popq	%rdx
1803255d1: 48 23 3c 69                 	andq	(%rcx,%rbp,2), %rdi
1803255d5: f9                          	stc
1803255d6: 17                          	<unknown>
1803255d7: d2 a6 b0 c3 48 90           	shlb	%cl, -0x6fb73c50(%rsi)
1803255dd: 6c                          	insb	%dx, %es:(%rdi)
1803255de: 80 1b 8b                    	sbbb	$-0x75, (%rbx)
1803255e1: 98                          	cwtl
1803255e2: e9 59 92 43 f7              	jmp	0x17775e840
1803255e7: cf                          	iretl
1803255e8: f6 74 b6 9a                 	divb	-0x66(%rsi,%rsi,4)
1803255ec: 9c                          	pushfq
1803255ed: d5 5b 1e                    	<unknown>
1803255f0: 4c 85 6b 94                 	testq	%r13, -0x6c(%rbx)
1803255f4: 0d c1 5f 90 0b              	orl	$0xb905fc1, %eax        # imm = 0xB905FC1
1803255f9: 5f                          	popq	%rdi
1803255fa: 8b 7d d2                    	movl	-0x2e(%rbp), %edi
1803255fd: cb                          	lretl
1803255fe: 3e c8 3a 02 ac              	enter	$0x23a, $-0x54          # imm = 0x23A
180325603: d5 b5 0c                    	<unknown>
180325606: 2a 56 9f                    	subb	-0x61(%rsi), %dl
180325609: 2e d7                       	xlatb
18032560b: 4d c3                       	retq
18032560d: 09 8c 6a 25 65 27 c6        	orl	%ecx, -0x39d89adb(%rdx,%rbp,2)
180325614: 4c 64 fe 8b a7 59 2e 58     	decb	%fs:0x582e59a7(%rbx)
18032561c: 2b 1f                       	subl	(%rdi), %ebx
18032561e: ca bc 16                    	lretl	$0x16bc                 # imm = 0x16BC
180325621: dc 26                       	fsubl	(%rsi)
180325623: 50                          	pushq	%rax
180325624: 5d                          	popq	%rbp
180325625: a5                          	movsl	(%rsi), %es:(%rdi)
180325626: 34 62                       	xorb	$0x62, %al
180325628: bd c8 8e 4d c2              	movl	$0xc24d8ec8, %ebp       # imm = 0xC24D8EC8
18032562d: 53                          	pushq	%rbx
18032562e: 8b a0 32 3b 13 b2           	movl	-0x4decc4ce(%rax), %esp
180325634: c9                          	leave
180325635: 11 4a 93                    	adcl	%ecx, -0x6d(%rdx)
180325638: 5e                          	popq	%rsi
180325639: 9f                          	lahf
18032563a: 29 54 60 74                 	subl	%edx, 0x74(%rax,%riz,2)
18032563e: 90                          	nop
18032563f: 8d 5e 2d                    	leal	0x2d(%rsi), %ebx
180325642: 7d 70                       	jge	0x1803256b4 <.text+0x3156b4>
180325644: 1a fe                       	sbbb	%dh, %bh
180325646: 22 ab 18 d5 ab 33           	andb	0x33abd518(%rbx), %ch
18032564c: 38 0c b1                    	cmpb	%cl, (%rcx,%rsi,4)
18032564f: a2 1d f2 70 29 c5 6c 45 b0  	movabsb	%al, -0x4fba933ad68f0de3
180325658: 0f 68 82 f2 f3 30 0d        	punpckhbw	0xd30f3f2(%rdx), %mm0 # mm0 = mm0[4],mem[4],mm0[5],mem[5],mm0[6],mem[6],mm0[7],mem[7]
18032565f: e9 42 de e0 dd              	jmp	0x15e1334a6
180325664: cb                          	lretl
180325665: f3 c2 2b 0b                 	rep		retq	$0xb2b          # imm = 0xB2B
180325669: 61                          	<unknown>
18032566a: f0                          	lock
18032566b: 75 da                       	jne	0x180325647 <.text+0x315647>
18032566d: 56                          	pushq	%rsi
18032566e: 37                          	<unknown>
18032566f: 6b 5a b5 33                 	imull	$0x33, -0x4b(%rdx), %ebx
180325673: 79 b5                       	jns	0x18032562a <.text+0x31562a>
180325675: 3a e8                       	cmpb	%al, %ch
180325677: 54                          	pushq	%rsp
180325678: d7                          	xlatb
180325679: 26 11 82 1c a2 ea 71        	adcl	%eax, %es:0x71eaa21c(%rdx)
180325680: 61                          	<unknown>
180325681: 11 c7                       	adcl	%eax, %edi
180325683: f7 8d 45 c6 2f e8           	<unknown>
180325689: 1a f8                       	sbbb	%al, %bh
18032568b: 84 5c 6d 72                 	testb	%bl, 0x72(%rbp,%rbp,2)
18032568f: b4 72                       	movb	$0x72, %ah
180325691: 90                          	nop
180325692: 4a aa                       	stosb	%al, %es:(%rdi)
180325694: e6 66                       	outb	%al, $0x66
180325696: 21 65 94                    	andl	%esp, -0x6c(%rbp)
180325699: 31 29                       	xorl	%ebp, (%rcx)
18032569b: 2e 7d d5                    	jge	0x180325673 <.text+0x315673>
18032569e: 67 fd                       	addr32		std
1803256a0: 5f                          	popq	%rdi
1803256a1: c7 df                       	<unknown>
1803256a3: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803256a4: 0a 9f 78 a8 3c 72           	orb	0x723ca878(%rdi), %bl
1803256aa: 1f                          	<unknown>
1803256ab: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803256ac: 94                          	xchgl	%esp, %eax
1803256ad: e9 e8 6d 45 a2              	jmp	0x12277c49a
1803256b2: d0 62 43                    	shlb	0x43(%rdx)
1803256b5: b3 ca                       	movb	$-0x36, %bl
1803256b7: 5e                          	popq	%rsi
1803256b8: 34 45                       	xorb	$0x45, %al
1803256ba: f2 5f                       	repne		popq	%rdi
1803256bc: 3f                          	<unknown>
1803256bd: cd c8                       	int	$0xc8
1803256bf: 5b                          	popq	%rbx
1803256c0: 4f 94                       	xchgq	%r12, %rax
1803256c2: b2 aa                       	movb	$-0x56, %dl
1803256c4: 4d 51                       	pushq	%r9
1803256c6: 7f e8                       	jg	0x1803256b0 <.text+0x3156b0>
1803256c8: 02 07                       	addb	(%rdi), %al
1803256ca: 90                          	nop
1803256cb: f2 71 47                    	repne		jno	0x180325715 <.text+0x315715>
1803256ce: 10 f9                       	adcb	%bh, %cl
1803256d0: ab                          	stosl	%eax, %es:(%rdi)
1803256d1: 38 14 0a                    	cmpb	%dl, (%rdx,%rcx)
1803256d4: e2 2c                       	loop	0x180325702 <.text+0x315702>
1803256d6: 21 a2 4d f0 6e 0a           	andl	%esp, 0xa6ef04d(%rdx)
1803256dc: 79 65                       	jns	0x180325743 <.text+0x315743>
1803256de: 2b 68 de                    	subl	-0x22(%rax), %ebp
1803256e1: 90                          	nop
1803256e2: a5                          	movsl	(%rsi), %es:(%rdi)
1803256e3: fe 52 a8                    	<unknown>
1803256e6: c5 f7 ea                    	<unknown>
1803256e9: 05 85 c9 22 ee              	addl	$0xee22c985, %eax       # imm = 0xEE22C985
1803256ee: 60                          	<unknown>
1803256ef: f8                          	clc
1803256f0: f3 73 64                    	rep		jae	0x180325757 <.text+0x315757>
1803256f3: c7 ba d9 cf b0 67           	<unknown>
1803256f9: aa                          	stosb	%al, %es:(%rdi)
1803256fa: 25 ea 9b 19 47              	andl	$0x47199bea, %eax       # imm = 0x47199BEA
1803256ff: 30 e0                       	xorb	%ah, %al
180325701: d3 de                       	rcrl	%cl, %esi
180325703: 6f                          	outsl	(%rsi), %dx
180325704: 76 00                       	jbe	0x180325706 <.text+0x315706>
180325706: ad                          	lodsl	(%rsi), %eax
180325707: 8a ab bb c8 65 b3           	movb	-0x4c9a3745(%rbx), %ch
18032570d: 96                          	xchgl	%esi, %eax
18032570e: 47 b2 39                    	movb	$0x39, %r10b
180325711: 1c d6                       	sbbb	$-0x2a, %al
180325713: 4c b5 d2                    	movb	$-0x2e, %bpl
180325716: 93                          	xchgl	%ebx, %eax
180325717: 6a 27                       	pushq	$0x27
180325719: e6 fb                       	outb	%al, $0xfb
18032571b: 8a 01                       	movb	(%rcx), %al
18032571d: dc 32                       	fdivl	(%rdx)
18032571f: d6                          	<unknown>
180325720: 08 32                       	orb	%dh, (%rdx)
180325722: 75 16                       	jne	0x18032573a <.text+0x31573a>
180325724: dd d2                       	fst	%st(2)
180325726: bf 86 36 87 c1              	movl	$0xc1873686, %edi       # imm = 0xC1873686
18032572b: 5d                          	popq	%rbp
18032572c: 4e 0a cb                    	orb	%bl, %r9b
18032572f: f9                          	stc
180325730: 83 76 50 a1                 	xorl	$-0x5f, 0x50(%rsi)
180325734: 24 89                       	andb	$-0x77, %al
180325736: de 1a                       	ficomps	(%rdx)
180325738: e8 4d 88 ad c2              	callq	0x142dfdf8a
18032573d: ac                          	lodsb	(%rsi), %al
18032573e: ac                          	lodsb	(%rsi), %al
18032573f: 25 43 c6 86 fc              	andl	$0xfc86c643, %eax       # imm = 0xFC86C643
180325744: 4c ca df 8a                 	lretq	$-0x7521                # imm = 0x8ADF
180325748: 7c a1                       	jl	0x1803256eb <.text+0x3156eb>
18032574a: d0 23                       	shlb	(%rbx)
18032574c: 75 44                       	jne	0x180325792 <.text+0x315792>
18032574e: ae                          	scasb	%es:(%rdi), %al
18032574f: a4                          	movsb	(%rsi), %es:(%rdi)
180325750: e5 5b                       	inl	$0x5b, %eax
180325752: ba a9 6f f8 7f              	movl	$0x7ff86fa9, %edx       # imm = 0x7FF86FA9
180325757: 7c 19                       	jl	0x180325772 <.text+0x315772>
180325759: e0 fe                       	loopne	0x180325759 <.text+0x315759>
18032575b: 3f                          	<unknown>
18032575c: 66 92                       	xchgw	%dx, %ax
18032575e: a9 65 3d 97 6b              	testl	$0x6b973d65, %eax       # imm = 0x6B973D65
180325763: e7 03                       	outl	%eax, $0x3
180325765: 3e 20 09                    	andb	%cl, %ds:(%rcx)
180325768: a5                          	movsl	(%rsi), %es:(%rdi)
180325769: 9e                          	sahf
18032576a: 5a                          	popq	%rdx
18032576b: 3e 4e 38 9d 8f 9c 23 da     	cmpb	%r11b, %ds:-0x25dc6371(%rbp)
180325773: 45 3f                       	<unknown>
180325775: 59                          	popq	%rcx
180325776: 3c be                       	cmpb	$-0x42, %al
180325778: 1b a4 f2 0c 31 f7 d8        	sbbl	-0x2708cef4(%rdx,%rsi,8), %esp
18032577f: 7d 81                       	jge	0x180325702 <.text+0x315702>
180325781: 60                          	<unknown>
180325782: d8 10                       	fcoms	(%rax)
180325784: 5f                          	popq	%rdi
180325785: 9f                          	lahf
180325786: e8 1b d5 8f 58              	callq	0x1d8c22ca6
18032578b: 9a                          	<unknown>
18032578c: 03 2f                       	addl	(%rdi), %ebp
18032578e: de e9                       	fsubrp	%st, %st(1)
180325790: 4e 09 ec                    	orq	%r13, %rsp
180325793: bb 05 9f b3 b8              	movl	$0xb8b39f05, %ebx       # imm = 0xB8B39F05
180325798: 16                          	<unknown>
180325799: b4 84                       	movb	$-0x7c, %ah
18032579b: 2a a0 13 16 82 38           	subb	0x38821613(%rax), %ah
1803257a1: e0 fe                       	loopne	0x1803257a1 <.text+0x3157a1>
1803257a3: ce                          	<unknown>
1803257a4: 84 b7 87 ba a9 54           	testb	%dh, 0x54a9ba87(%rdi)
1803257aa: 29 3e                       	subl	%edi, (%rsi)
1803257ac: 5c                          	popq	%rsp
1803257ad: da 3a                       	fidivrl	(%rdx)
1803257af: ea                          	<unknown>
1803257b0: ab                          	stosl	%eax, %es:(%rdi)
1803257b1: 91                          	xchgl	%ecx, %eax
1803257b2: bd 51 79 23 4a              	movl	$0x4a237951, %ebp       # imm = 0x4A237951
1803257b7: b2 76                       	movb	$0x76, %dl
1803257b9: 18 af d3 d6 58 26           	sbbb	%ch, 0x2658d6d3(%rdi)
1803257bf: e6 59                       	outb	%al, $0x59
1803257c1: 54                          	pushq	%rsp
1803257c2: ee                          	outb	%al, %dx
1803257c3: 6c                          	insb	%dx, %es:(%rdi)
1803257c4: 68 03 6d 20 af              	pushq	$-0x50df92fd            # imm = 0xAF206D03
1803257c9: 88 96 f7 35 e4 8c           	movb	%dl, -0x731bca09(%rsi)
1803257cf: b5 12                       	movb	$0x12, %ch
1803257d1: 65 a9 00 07 62 83           	testl	$0x83620700, %eax       # imm = 0x83620700
1803257d7: 67 a2 89 14 1c b3           	movb	%al, 0xb31c1489
1803257dd: f2 63 05 25 51 77 c0        	repne		movslq	-0x3f88aedb(%rip), %eax # 0x140a9a909
1803257e4: cd 9e                       	int	$0x9e
1803257e6: 8f 11 f1                    	<unknown>
1803257e9: 18 f2                       	sbbb	%dh, %dl
1803257eb: 24 92                       	andb	$-0x6e, %al
1803257ed: 36 40 cd 76                 	int	$0x76
1803257f1: c3                          	retq
1803257f2: b8 87 6a e0 c4              	movl	$0xc4e06a87, %eax       # imm = 0xC4E06A87
1803257f7: e4 1e                       	inb	$0x1e, %al
1803257f9: 34 f7                       	xorb	$-0x9, %al
1803257fb: 7e 2d                       	jle	0x18032582a <.text+0x31582a>
1803257fd: 54                          	pushq	%rsp
1803257fe: 93                          	xchgl	%ebx, %eax
1803257ff: c8 8e 47 2b                 	enter	$0x478e, $0x2b          # imm = 0x478E
180325803: 92                          	xchgl	%edx, %eax
180325804: 11 28                       	adcl	%ebp, (%rax)
180325806: 14 a6                       	adcb	$-0x5a, %al
180325808: d3 a4 6d f6 37 b2 d0        	shll	%cl, -0x2f4dc80a(%rbp,%rbp,2)
18032580f: 13 dc                       	adcl	%esp, %ebx
180325811: bf ec 65 89 43              	movl	$0x438965ec, %edi       # imm = 0x438965EC
180325816: 1a 08                       	sbbb	(%rax), %cl
180325818: 51                          	pushq	%rcx
180325819: ca 14 b3                    	lretl	$-0x4cec                # imm = 0xB314
18032581c: 38 4d ab                    	cmpb	%cl, -0x55(%rbp)
18032581f: 49 2f                       	<unknown>
180325821: c3                          	retq
180325822: 09 07                       	orl	%eax, (%rdi)
180325824: a6                          	cmpsb	%es:(%rdi), (%rsi)
180325825: 5c                          	popq	%rsp
180325826: a9 74 5c ab 82              	testl	$0x82ab5c74, %eax       # imm = 0x82AB5C74
18032582b: f3 0c 35                    	rep		orb	$0x35, %al
18032582e: 95                          	xchgl	%ebp, %eax
18032582f: 32 91 53 e7 ab 04           	xorb	0x4abe753(%rcx), %dl
180325835: 19 f2                       	sbbl	%esi, %edx
180325837: 00 8d a3 bd 48 84           	addb	%cl, -0x7bb7425d(%rbp)
18032583d: 1d 59 4a 4c c2              	sbbl	$0xc24c4a59, %eax       # imm = 0xC24C4A59
180325842: 64 be 59 91 e2 b7           	movl	$0xb7e29159, %esi       # imm = 0xB7E29159
180325848: 11 ea                       	adcl	%ebp, %edx
18032584a: 72 4e                       	jb	0x18032589a <.text+0x31589a>
18032584c: d3 f5                       	<unknown>
18032584e: c5 df 5a 04 3e              	vcvtsd2ss	(%rsi,%rdi), %xmm4, %xmm0
180325853: 44 e0 ef                    	loopne	0x180325845 <.text+0x315845>
180325856: e9 db 9e d6 bc              	jmp	0x13d08f736
18032585b: 6d                          	insl	%dx, %es:(%rdi)
18032585c: 8f ef 1a                    	<unknown>
18032585f: a6                          	cmpsb	%es:(%rdi), (%rsi)
180325860: 36 18 0e                    	sbbb	%cl, %ss:(%rsi)
180325863: c1 f8 c5                    	sarl	$0xc5, %eax
180325866: 9f                          	lahf
180325867: b7 12                       	movb	$0x12, %bh
180325869: 3f                          	<unknown>
18032586a: 4f b4 7b                    	movb	$0x7b, %r12b
18032586d: b2 5f                       	movb	$0x5f, %dl
18032586f: be ad 7d 5e 3f              	movl	$0x3f5e7dad, %esi       # imm = 0x3F5E7DAD
180325874: eb 08                       	jmp	0x18032587e <.text+0x31587e>
180325876: be b4 24 df 22              	movl	$0x22df24b4, %esi       # imm = 0x22DF24B4
18032587b: 99                          	cltd
18032587c: 51                          	pushq	%rcx
18032587d: f0                          	lock
18032587e: e7 ce                       	outl	%eax, $0xce
180325880: 9e                          	sahf
180325881: 0d fc cb 4c 22              	orl	$0x224ccbfc, %eax       # imm = 0x224CCBFC
180325886: f8                          	clc
180325887: 31 b5 b2 f7 53 95           	xorl	%esi, -0x6aac084e(%rbp)
18032588d: 15 a1 52 20 68              	adcl	$0x682052a1, %eax       # imm = 0x682052A1
180325892: 18 47 d1                    	sbbb	%al, -0x2f(%rdi)
180325895: 43 31 81 c5 c2 0a da        	xorl	%eax, -0x25f53d3b(%r9)
18032589c: f0                          	lock
18032589d: c2 35 5b                    	retq	$0x5b35                 # imm = 0x5B35
1803258a0: 6d                          	insl	%dx, %es:(%rdi)
1803258a1: 5d                          	popq	%rbp
1803258a2: 66 93                       	xchgw	%bx, %ax
1803258a4: eb c5                       	jmp	0x18032586b <.text+0x31586b>
1803258a6: d3 17                       	rcll	%cl, (%rdi)
1803258a8: 0e                          	<unknown>
1803258a9: 4e a9 f2 f4 f1 a3           	testq	$-0x5c0e0b0e, %rax      # imm = 0xA3F1F4F2
1803258af: 44 a2 d4 82 b2 dc 3b 00 98 2c       	movabsb	%al, 0x2c98003bdcb282d4
1803258b9: 65 f8                       	clc
1803258bb: 9b                          	wait
1803258bc: 6e                          	outsb	(%rsi), %dx
1803258bd: 5d                          	popq	%rbp
1803258be: 27                          	<unknown>
1803258bf: 00 20                       	addb	%ah, (%rax)
1803258c1: 99                          	cltd
1803258c2: c0 81 e1 a1 d6 92 ba        	rolb	$0xba, -0x6d295e1f(%rcx)
1803258c9: 55                          	pushq	%rbp
1803258ca: 27                          	<unknown>
1803258cb: 9b                          	wait
1803258cc: 01 29                       	addl	%ebp, (%rcx)
1803258ce: 93                          	xchgl	%ebx, %eax
1803258cf: 4b 3e d9 41 80              	flds	%ds:-0x80(%rcx)
1803258d4: 7b 07                       	jnp	0x1803258dd <.text+0x3158dd>
1803258d6: 72 7a                       	jb	0x180325952 <.text+0x315952>
1803258d8: 16                          	<unknown>
1803258d9: 70 e9                       	jo	0x1803258c4 <.text+0x3158c4>
1803258db: 49 fa                       	cli
1803258dd: db f9                       	<unknown>
1803258df: 9d                          	popfq
1803258e0: ca 8b e8                    	lretl	$-0x1775                # imm = 0xE88B
1803258e3: 6c                          	insb	%dx, %es:(%rdi)
1803258e4: 39 64 83 5a                 	cmpl	%esp, 0x5a(%rbx,%rax,4)
1803258e8: 6d                          	insl	%dx, %es:(%rdi)
1803258e9: 8a 14 e2                    	movb	(%rdx,%riz,8), %dl
1803258ec: e6 84                       	outb	%al, $0x84
1803258ee: 1a f1                       	sbbb	%cl, %dh
1803258f0: 2d 6a 21 ad 02              	subl	$0x2ad216a, %eax        # imm = 0x2AD216A
1803258f5: a4                          	movsb	(%rsi), %es:(%rdi)
1803258f6: 33 45 95                    	xorl	-0x6b(%rbp), %eax
1803258f9: 52                          	pushq	%rdx
1803258fa: 59                          	popq	%rcx
1803258fb: ac                          	lodsb	(%rsi), %al
1803258fc: 95                          	xchgl	%ebp, %eax
1803258fd: db 60 99                    	<unknown>
180325900: b7 17                       	movb	$0x17, %bh
180325902: 36 be cd 0d 15 1a           	movl	$0x1a150dcd, %esi       # imm = 0x1A150DCD
180325908: c4 be 81                    	<unknown>
18032590b: 42 30 d5                    	xorb	%dl, %bpl
18032590e: b1 40                       	movb	$0x40, %cl
180325910: a7                          	cmpsl	%es:(%rdi), (%rsi)
180325911: 63 e9                       	movslq	%ecx, %ebp
180325913: f5                          	cmc
180325914: a0 1c 80 b7 f5 a4 9e b1 ba  	movabsb	-0x454e615b0a487fe4, %al
18032591d: 9e                          	sahf
18032591e: 27                          	<unknown>
18032591f: 41 7e e8                    	jle	0x18032590a <.text+0x31590a>
180325922: d6                          	<unknown>
180325923: 85 8b 5b 14 1b bc           	testl	%ecx, -0x43e4eba5(%rbx)
180325929: ab                          	stosl	%eax, %es:(%rdi)
18032592a: 72 62                       	jb	0x18032598e <.text+0x31598e>
18032592c: 47 af                       	scasl	%es:(%rdi), %eax
18032592e: 51                          	pushq	%rcx
18032592f: 00 1b                       	addb	%bl, (%rbx)
180325931: ea                          	<unknown>
180325932: bd 52 61 de fe              	movl	$0xfede6152, %ebp       # imm = 0xFEDE6152
180325937: 65 14 ef                    	adcb	$-0x11, %al
18032593a: 56                          	pushq	%rsi
18032593b: 45 01 b6 c0 76 72 c8        	addl	%r14d, -0x378d8940(%r14)
180325942: 1d 0e 1b e9 a3              	sbbl	$0xa3e91b0e, %eax       # imm = 0xA3E91B0E
180325947: 96                          	xchgl	%esi, %eax
180325948: 92                          	xchgl	%edx, %eax
180325949: 98                          	cwtl
18032594a: 7b 48                       	jnp	0x180325994 <.text+0x315994>
18032594c: 3c 86                       	cmpb	$-0x7a, %al
18032594e: 0b f7                       	orl	%edi, %esi
180325950: c2 fe 2e                    	retq	$0x2efe                 # imm = 0x2EFE
180325953: 58                          	popq	%rax
180325954: e2 88                       	loop	0x1803258de <.text+0x3158de>
180325956: 19 45 82                    	sbbl	%eax, -0x7e(%rbp)
180325959: 5e                          	popq	%rsi
18032595a: 0e                          	<unknown>
18032595b: 63 aa e6 20 59 10           	movslq	0x105920e6(%rdx), %ebp
180325961: 8e ab 8d 2e 8f 61           	movw	0x618f2e8d(%rbx), %gs
180325967: fc                          	cld
180325968: bd 5d 28 5e 04              	movl	$0x45e285d, %ebp        # imm = 0x45E285D
18032596d: 14 31                       	adcb	$0x31, %al
18032596f: 8c 9a f4 6d a6 de           	movw	%ds, -0x2159920c(%rdx)
180325975: b1 1d                       	movb	$0x1d, %cl
180325977: 4b 57                       	pushq	%r15
180325979: a3 a3 c1 1d 98 2e 64 22 10  	movabsl	%eax, 0x1022642e981dc1a3
180325982: 7e 9a                       	jle	0x18032591e <.text+0x31591e>
180325984: bb 74 35 6f 86              	movl	$0x866f3574, %ebx       # imm = 0x866F3574
180325989: 77 12                       	ja	0x18032599d <.text+0x31599d>
18032598b: 94                          	xchgl	%esp, %eax
18032598c: 92                          	xchgl	%edx, %eax
18032598d: f9                          	stc
18032598e: bf fc 7e 4a c0              	movl	$0xc04a7efc, %edi       # imm = 0xC04A7EFC
180325993: ae                          	scasb	%es:(%rdi), %al
180325994: 96                          	xchgl	%esi, %eax
180325995: 1b e5                       	sbbl	%ebp, %esp
180325997: a0 54 4e 28 17 78 dd e3 f5  	movabsb	-0xa1c2287e8d7b1ac, %al
1803259a0: 56                          	pushq	%rsi
1803259a1: 66 ef                       	outw	%ax, %dx
1803259a3: 63 a5 11 5f ce cf           	movslq	-0x3031a0ef(%rbp), %esp
1803259a9: e9 3f ee a6 bf              	jmp	0x13fd947ed
1803259ae: b2 c9                       	movb	$-0x37, %dl
1803259b0: 25 9e f4 25 59              	andl	$0x5925f49e, %eax       # imm = 0x5925F49E
1803259b5: 09 6d 0a                    	orl	%ebp, 0xa(%rbp)
1803259b8: c0 83 d3 a3 03 da 91        	rolb	$0x91, -0x25fc5c2d(%rbx)
1803259bf: e4 09                       	inb	$0x9, %al
1803259c1: c9                          	leave
1803259c2: 6b 4b 24 03                 	imull	$0x3, 0x24(%rbx), %ecx
1803259c6: 31 5d 71                    	xorl	%ebx, 0x71(%rbp)
1803259c9: 70 3a                       	jo	0x180325a05 <.text+0x315a05>
1803259cb: e5 a8                       	inl	$0xa8, %eax
1803259cd: 9a                          	<unknown>
1803259ce: 45 bc 46 75 8f 48           	movl	$0x488f7546, %r12d      # imm = 0x488F7546
1803259d4: fe d4                       	<unknown>
1803259d6: 8b 85 49 94 92 4f           	movl	0x4f929449(%rbp), %eax
1803259dc: 0f 7d                       	<unknown>
1803259de: 3e dd 12                    	fstl	%ds:(%rdx)
1803259e1: 32 17                       	xorb	(%rdi), %dl
1803259e3: ba be 70 4e f9              	movl	$0xf94e70be, %edx       # imm = 0xF94E70BE
1803259e8: 10 dd                       	adcb	%bl, %ch
1803259ea: 9b                          	wait
1803259eb: 4c c4 a6 86 15              	<unknown>
1803259f0: 95                          	xchgl	%ebp, %eax
1803259f1: 02 c9                       	addb	%cl, %cl
1803259f3: cb                          	lretl
1803259f4: 72 1b                       	jb	0x180325a11 <.text+0x315a11>
1803259f6: ef                          	outl	%eax, %dx
1803259f7: 7c ca                       	jl	0x1803259c3 <.text+0x3159c3>
1803259f9: ef                          	outl	%eax, %dx
1803259fa: f0                          	lock
1803259fb: 9b                          	wait
1803259fc: b0 b6                       	movb	$-0x4a, %al
1803259fe: 50                          	pushq	%rax
1803259ff: 20 97 b1 5d 03 f2           	andb	%dl, -0xdfca24f(%rdi)
180325a05: 1c 21                       	sbbb	$0x21, %al
180325a07: e9 64 ef 04 a3              	jmp	0x123374970
180325a0c: 0d a5 54 b8 86              	orl	$0x86b854a5, %eax       # imm = 0x86B854A5
180325a11: 62 52 0e 67 74 a2 52 1e 4d ed       	<unknown>
180325a1b: bc 13 bb ec 0b              	movl	$0xbecbb13, %esp        # imm = 0xBECBB13
180325a20: 61                          	<unknown>
180325a21: b4 ac                       	movb	$-0x54, %ah
180325a23: 66 91                       	xchgw	%cx, %ax
180325a25: b7 97                       	movb	$-0x69, %bh
180325a27: 47 09 83 9e e8 8b 62        	orl	%r8d, 0x628be89e(%r11)
180325a2e: 1f                          	<unknown>
180325a2f: 4e 93                       	xchgq	%rbx, %rax
180325a31: 73 f6                       	jae	0x180325a29 <.text+0x315a29>
180325a33: 56                          	pushq	%rsi
180325a34: 03 75 56                    	addl	0x56(%rbp), %esi
180325a37: bf 1d b9 70 71              	movl	$0x7170b91d, %edi       # imm = 0x7170B91D
180325a3c: 62 d5 d7 ca 39              	<unknown>
180325a41: 66 44 9a                    	<unknown>
180325a44: f1                          	<unknown>
180325a45: 67 f5                       	addr32		cmc
180325a47: d1 f2                       	<unknown>
180325a49: 4c 56                       	pushq	%rsi
180325a4b: c1 a6 cf 6f b8 8f b0        	shll	$0xb0, -0x70479031(%rsi)
180325a52: ac                          	lodsb	(%rsi), %al
180325a53: 8e 07                       	movw	(%rdi), %es
180325a55: 84 a8 b0 74 5f 0e           	testb	%ch, 0xe5f74b0(%rax)
180325a5b: 9e                          	sahf
180325a5c: 23 8b 13 1c 11 64           	andl	0x64111c13(%rbx), %ecx
180325a62: 15 70 b6 f3 cf              	adcl	$0xcff3b670, %eax       # imm = 0xCFF3B670
180325a67: 39 1e                       	cmpl	%ebx, (%rsi)
180325a69: 26 2b f0                    	subl	%eax, %esi
180325a6c: a0 03 ab aa 83 4b 78 a1 d4  	movabsb	-0x2b5e87b47c5554fd, %al
180325a75: 86 1f                       	xchgb	%bl, (%rdi)
180325a77: a1 16 e2 b7 e4 d8 56 b5 d0  	movabsl	-0x2f4aa9271b481dea, %eax
180325a80: ea                          	<unknown>
180325a81: 9c                          	pushfq
180325a82: f8                          	clc
180325a83: b4 ed                       	movb	$-0x13, %ah
180325a85: 83 d1 e2                    	adcl	$-0x1e, %ecx
180325a88: 8d 08                       	leal	(%rax), %ecx
180325a8a: 5f                          	popq	%rdi
180325a8b: 28 bd 8b b9 49 e1           	subb	%bh, -0x1eb64675(%rbp)
180325a91: ba 26 c0 8a 33              	movl	$0x338ac026, %edx       # imm = 0x338AC026
180325a96: 16                          	<unknown>
180325a97: c7 08                       	<unknown>
180325a99: b5 f5                       	movb	$-0xb, %ch
180325a9b: 7d 6a                       	jge	0x180325b07 <.text+0x315b07>
180325a9d: dc 63 66                    	fsubl	0x66(%rbx)
180325aa0: 21 fa                       	andl	%edi, %edx
180325aa2: 91                          	xchgl	%ecx, %eax
180325aa3: 86 72 fb                    	xchgb	%dh, -0x5(%rdx)
180325aa6: 2c ce                       	subb	$-0x32, %al
180325aa8: 29 f4                       	subl	%esi, %esp
180325aaa: 3d 71 ba ac 22              	cmpl	$0x22acba71, %eax       # imm = 0x22ACBA71
180325aaf: c7 e1                       	<unknown>
180325ab1: 59                          	popq	%rcx
180325ab2: a2 02 3c df 7d e8 5c ca 0d  	movabsb	%al, 0xdca5ce87ddf3c02
180325abb: d2 3b                       	sarb	%cl, (%rbx)
180325abd: 15 c0 ba f2 12              	adcl	$0x12f2bac0, %eax       # imm = 0x12F2BAC0
180325ac2: 58                          	popq	%rax
180325ac3: fe b5 5a 39 10 6a           	<unknown>
180325ac9: 3e ea                       	<unknown>
180325acb: 44 66 60                    	<unknown>
180325ace: 62 be e9 0d 1a              	<unknown>
180325ad3: e3 49                       	jrcxz	0x180325b1e <.text+0x315b1e>
180325ad5: 1f                          	<unknown>
180325ad6: 12 77 80                    	adcb	-0x80(%rdi), %dh
180325ad9: 4a 27                       	<unknown>
180325adb: 02 d9                       	addb	%cl, %bl
180325add: 74 6c                       	je	0x180325b4b <.text+0x315b4b>
180325adf: 76 7a                       	jbe	0x180325b5b <.text+0x315b5b>
180325ae1: 3a 65 8b                    	cmpb	-0x75(%rbp), %ah
180325ae4: e5 4a                       	inl	$0x4a, %eax
180325ae6: 83 96 e8 6c 77 1f 85        	adcl	$-0x7b, 0x1f776ce8(%rsi)
180325aed: 0f 44 03                    	cmovel	(%rbx), %eax
180325af0: 2f                          	<unknown>
180325af1: 25 7b 27 a6 78              	andl	$0x78a6277b, %eax       # imm = 0x78A6277B
180325af6: af                          	scasl	%es:(%rdi), %eax
180325af7: 3b 04 94                    	cmpl	(%rsp,%rdx,4), %eax
180325afa: 97                          	xchgl	%edi, %eax
180325afb: e9 c5 40 b9 51              	jmp	0x1d1eb9bc5
180325b00: a9 ec 65 ec 84              	testl	$0x84ec65ec, %eax       # imm = 0x84EC65EC
180325b05: 6d                          	insl	%dx, %es:(%rdi)
180325b06: 22 69 4a                    	andb	0x4a(%rcx), %ch
180325b09: 30 a9 50 7b 2c d7           	xorb	%ch, -0x28d384b0(%rcx)
180325b0f: 2e 10 3d 6b ec c0 33        	adcb	%bh, %cs:0x33c0ec6b(%rip)
180325b16: bd 93 a0 76 95              	movl	$0x9576a093, %ebp       # imm = 0x9576A093
180325b1b: c1 e5 f5                    	shll	$0xf5, %ebp
180325b1e: 32 72 97                    	xorb	-0x69(%rdx), %dh
180325b21: b5 b2                       	movb	$-0x4e, %ch
180325b23: f6 ee                       	imulb	%dh
180325b25: 44 c0 ae f8 b6 e9 83 bf     	shrb	$0xbf, -0x7c164908(%rsi)
180325b2d: 85 c2                       	testl	%eax, %edx
180325b2f: 71 f4                       	jno	0x180325b25 <.text+0x315b25>
180325b31: 36 21 95 24 49 28 73        	andl	%edx, %ss:0x73284924(%rbp)
180325b38: 83 ab aa 34 dd 5d 22        	subl	$0x22, 0x5ddd34aa(%rbx)
180325b3f: dc 1d 1f 86 50 49           	fcompl	0x4950861f(%rip)        # 0x1c982e164
180325b45: c2 cc eb                    	retq	$-0x1434                # imm = 0xEBCC
180325b48: 7a 8a                       	jp	0x180325ad4 <.text+0x315ad4>
180325b4a: 28 27                       	subb	%ah, (%rdi)
180325b4c: 33 f2                       	xorl	%edx, %esi
180325b4e: af                          	scasl	%es:(%rdi), %eax
180325b4f: a3 95 56 1e 76 97 14 4e cd  	movabsl	%eax, -0x32b1eb6889e1a96b
180325b58: 8d a0 f0 83 93 90           	leal	-0x6f6c7c10(%rax), %esp
180325b5e: 17                          	<unknown>
180325b5f: 76 ac                       	jbe	0x180325b0d <.text+0x315b0d>
180325b61: db ec                       	fucomi	%st(4), %st
180325b63: d2 b2 ad db d7 9f           	<unknown>
180325b69: 46 5f                       	popq	%rdi
180325b6b: 11 21                       	adcl	%esp, (%rcx)
180325b6d: e5 37                       	inl	$0x37, %eax
180325b6f: 71 16                       	jno	0x180325b87 <.text+0x315b87>
180325b71: 18 5f c7                    	sbbb	%bl, -0x39(%rdi)
180325b74: c1 3e 0c                    	sarl	$0xc, (%rsi)
180325b77: b3 e7                       	movb	$-0x19, %bl
180325b79: a5                          	movsl	(%rsi), %es:(%rdi)
180325b7a: 48 ed                       	inl	%dx, %eax
180325b7c: 2b ea                       	subl	%edx, %ebp
180325b7e: bc b0 bd 72 45              	movl	$0x4572bdb0, %esp       # imm = 0x4572BDB0
180325b83: da f6                       	<unknown>
180325b85: 61                          	<unknown>
180325b86: 84 38                       	testb	%bh, (%rax)
180325b88: 37                          	<unknown>
180325b89: d0 0b                       	rorb	(%rbx)
180325b8b: 05 d5 11 34 4b              	addl	$0x4b3411d5, %eax       # imm = 0x4B3411D5
180325b90: 67 69 79 73 4a 51 b8 c7     	imull	$0xc7b8514a, 0x73(%ecx), %edi # imm = 0xC7B8514A
180325b98: e3 03                       	jrcxz	0x180325b9d <.text+0x315b9d>
180325b9a: 5a                          	popq	%rdx
180325b9b: b8 e6 3e b4 c4              	movl	$0xc4b43ee6, %eax       # imm = 0xC4B43EE6
180325ba0: cd 0c                       	int	$0xc
180325ba2: 17                          	<unknown>
180325ba3: 7a f3                       	jp	0x180325b98 <.text+0x315b98>
180325ba5: 7d 75                       	jge	0x180325c1c <.text+0x315c1c>
180325ba7: 21 29                       	andl	%ebp, (%rcx)
180325ba9: dd 7f 4c                    	fnstsw	0x4c(%rdi)
180325bac: 22 e8                       	andb	%al, %ch
180325bae: f1                          	<unknown>
180325baf: f0                          	lock
180325bb0: 61                          	<unknown>
180325bb1: d1 35 66 65 1e f0           	<unknown>
180325bb7: d2 5b 94                    	rcrb	%cl, -0x6c(%rbx)
180325bba: 0a de                       	orb	%dh, %bl
180325bbc: f9                          	stc
180325bbd: 38 8d f0 71 8b f7           	cmpb	%cl, -0x8748e10(%rbp)
180325bc3: 03 b2 c4 ab aa 28           	addl	0x28aaabc4(%rdx), %esi
180325bc9: 64 89 ca                    	movl	%ecx, %edx
180325bcc: 86 d2                       	xchgb	%dl, %dl
180325bce: 7f 3e                       	jg	0x180325c0e <.text+0x315c0e>
180325bd0: 88 69 b4                    	movb	%ch, -0x4c(%rcx)
180325bd3: e4 4a                       	inb	$0x4a, %al
180325bd5: 9d                          	popfq
180325bd6: 6c                          	insb	%dx, %es:(%rdi)
180325bd7: e9 e3 6a 20 d5              	jmp	0x15552c6bf
180325bdc: a9 94 73 9c 34              	testl	$0x349c7394, %eax       # imm = 0x349C7394
180325be1: d5 df ae 37                 	xsaveopt64	(%r31)
180325be5: f7 14 26                    	notl	(%rsi,%riz)
180325be8: d8 58 56                    	fcomps	0x56(%rax)
180325beb: 20 7d 12                    	andb	%bh, 0x12(%rbp)
180325bee: b0 5a                       	movb	$0x5a, %al
180325bf0: 01 ae 9b 1c 65 d7           	addl	%ebp, -0x289ae365(%rsi)
180325bf6: 0c fd                       	orb	$-0x3, %al
180325bf8: c5 d7 7d 9f 50 22 13 48     	vhsubps	0x48132250(%rdi), %ymm5, %ymm3
180325c00: ae                          	scasb	%es:(%rdi), %al
180325c01: 91                          	xchgl	%ecx, %eax
180325c02: db 69 3a                    	fldt	0x3a(%rcx)
180325c05: 72 f3                       	jb	0x180325bfa <.text+0x315bfa>
180325c07: 18 2c 99                    	sbbb	%ch, (%rcx,%rbx,4)
180325c0a: c0 d9 52                    	rcrb	$0x52, %cl
180325c0d: 6e                          	outsb	(%rsi), %dx
180325c0e: 63 75 cd                    	movslq	-0x33(%rbp), %esi
180325c11: 05 ae aa b2 64              	addl	$0x64b2aaae, %eax       # imm = 0x64B2AAAE
180325c16: 4a 8c 49 f0                 	movw	%cs, -0x10(%rcx)
180325c1a: 71 3f                       	jno	0x180325c5b <.text+0x315c5b>
180325c1c: e0 eb                       	loopne	0x180325c09 <.text+0x315c09>
180325c1e: b9 ad 8a b5 0c              	movl	$0xcb58aad, %ecx        # imm = 0xCB58AAD
180325c23: 66 65 d2 78 d5              	sarb	%cl, %gs:-0x2b(%rax)
180325c28: 0f 47 37                    	cmoval	(%rdi), %esi
180325c2b: 5a                          	popq	%rdx
180325c2c: 7f dd                       	jg	0x180325c0b <.text+0x315c0b>
180325c2e: ed                          	inl	%dx, %eax
180325c2f: 39 32                       	cmpl	%esi, (%rdx)
180325c31: dd 19                       	fstpl	(%rcx)
180325c33: 92                          	xchgl	%edx, %eax
180325c34: ee                          	outb	%al, %dx
180325c35: 49 ac                       	lodsb	(%rsi), %al
180325c37: 2a 2b                       	subb	(%rbx), %ch
180325c39: f2 26 21 8e 7d dc 7d 38     	repne		andl	%ecx, %es:0x387ddc7d(%rsi)
180325c41: 31 69 98                    	xorl	%ebp, -0x68(%rcx)
180325c44: 7a 3d                       	jp	0x180325c83 <.text+0x315c83>
180325c46: 36 e2 b3                    	loop	0x180325bfc <.text+0x315bfc>
180325c49: 11 30                       	adcl	%esi, (%rax)
180325c4b: 90                          	nop
180325c4c: 2d fb 34 36 39              	subl	$0x393634fb, %eax       # imm = 0x393634FB
180325c51: 8d 1c 69                    	leal	(%rcx,%rbp,2), %ebx
180325c54: 09 98 2a 99 c9 80           	orl	%ebx, -0x7f3666d6(%rax)
180325c5a: 85 71 02                    	testl	%esi, 0x2(%rcx)
180325c5d: ce                          	<unknown>
180325c5e: b3 bd                       	movb	$-0x43, %bl
180325c60: 6e                          	outsb	(%rsi), %dx
180325c61: 19 61 d6                    	sbbl	%esp, -0x2a(%rcx)
180325c64: 33 05 55 7d 6c a4           	xorl	-0x5b9382ab(%rip), %eax # 0x1249ed9bf
180325c6a: 5e                          	popq	%rsi
180325c6b: 5e                          	popq	%rsi
180325c6c: 9b                          	wait
180325c6d: 17                          	<unknown>
180325c6e: 52                          	pushq	%rdx
180325c6f: dc 00                       	faddl	(%rax)
180325c71: fd                          	std
180325c72: ac                          	lodsb	(%rsi), %al
180325c73: d5 fc 05                    	syscall
180325c76: 28 1a                       	subb	%bl, (%rdx)
180325c78: c5 04 dc                    	<unknown>
180325c7b: c3                          	retq
180325c7c: 54                          	pushq	%rsp
180325c7d: dd 32                       	fnsave	(%rdx)
180325c7f: e6 f6                       	outb	%al, $0xf6
180325c81: 1a f1                       	sbbb	%cl, %dh
180325c83: cd 8b                       	int	$0x8b
180325c85: 58                          	popq	%rax
180325c86: 48 39 21                    	cmpq	%rsp, (%rcx)
180325c89: 2a 81 df 80 32 91           	subb	-0x6ecd7f21(%rcx), %al
180325c8f: 83 da 05                    	sbbl	$0x5, %edx
180325c92: 2d d4 35 4a 2f              	subl	$0x2f4a35d4, %eax       # imm = 0x2F4A35D4
180325c97: db bd 04 cb 2d 3b           	fstpt	0x3b2dcb04(%rbp)
180325c9d: 8d d5                       	<unknown>
180325c9f: 3d 74 38 fe 0f              	cmpl	$0xffe3874, %eax        # imm = 0xFFE3874
180325ca4: 0c c0                       	orb	$-0x40, %al
180325ca6: dd eb                       	fucomp	%st(3)
180325ca8: 65 1d 76 89 8b dc           	sbbl	$0xdc8b8976, %eax       # imm = 0xDC8B8976
180325cae: dc 30                       	fdivl	(%rax)
180325cb0: 94                          	xchgl	%esp, %eax
180325cb1: 74 5f                       	je	0x180325d12 <.text+0x315d12>
180325cb3: b0 7c                       	movb	$0x7c, %al
180325cb5: d2 1b                       	rcrb	%cl, (%rbx)
180325cb7: d6                          	<unknown>
180325cb8: 6b 16 bd                    	imull	$-0x43, (%rsi), %edx
180325cbb: 12 f4                       	adcb	%ah, %dh
180325cbd: b6 16                       	movb	$0x16, %dh
180325cbf: fd                          	std
180325cc0: 2f                          	<unknown>
180325cc1: a1 4b cc db ce c5 78 48 15  	movabsl	0x154878c5cedbcc4b, %eax
180325cca: 08 53 57                    	orb	%dl, 0x57(%rbx)
180325ccd: 85 5c 34 ee                 	testl	%ebx, -0x12(%rsp,%rsi)
180325cd1: 50                          	pushq	%rax
180325cd2: 0e                          	<unknown>
180325cd3: c1 70 82                    	<unknown>
180325cd6: 78 29                       	js	0x180325d01 <.text+0x315d01>
180325cd8: 86 72 6b                    	xchgb	%dh, 0x6b(%rdx)
180325cdb: a8 0c                       	testb	$0xc, %al
180325cdd: 1c 26                       	sbbb	$0x26, %al
180325cdf: aa                          	stosb	%al, %es:(%rdi)
180325ce0: 65 08 7d 41                 	orb	%bh, %gs:0x41(%rbp)
180325ce4: 6b b5 41 ea 7f ad d6        	imull	$-0x2a, -0x528015bf(%rbp), %esi
180325ceb: ae                          	scasb	%es:(%rdi), %al
180325cec: 23 6a 54                    	andl	0x54(%rdx), %ebp
180325cef: f4                          	hlt
180325cf0: 0e                          	<unknown>
180325cf1: 13 38                       	adcl	(%rax), %edi
180325cf3: ce                          	<unknown>
180325cf4: be 8a f5 f8 36              	movl	$0x36f8f58a, %esi       # imm = 0x36F8F58A
180325cf9: 7f 01                       	jg	0x180325cfc <.text+0x315cfc>
180325cfb: f2 fb                       	repne		sti
180325cfd: dc 22                       	fsubl	(%rdx)
180325cff: 91                          	xchgl	%ecx, %eax
180325d00: 09 02                       	orl	%eax, (%rdx)
180325d02: 0e                          	<unknown>
180325d03: d4                          	<unknown>
180325d04: 8a 26                       	movb	(%rsi), %ah
180325d06: 9c                          	pushfq
180325d07: 4f cf                       	iretq
180325d09: 8b a5 7d 15 6d cd           	movl	-0x3292ea83(%rbp), %esp
180325d0f: 0c 78                       	orb	$0x78, %al
180325d11: f1                          	<unknown>
180325d12: 38 3f                       	cmpb	%bh, (%rdi)
180325d14: 26 dc 3a                    	fdivrl	%es:(%rdx)
180325d17: 87 38                       	xchgl	%edi, (%rax)
180325d19: 92                          	xchgl	%edx, %eax
180325d1a: c7 a0 76 ac cc e7           	<unknown>
180325d20: 72 20                       	jb	0x180325d42 <.text+0x315d42>
180325d22: 02 ab 68 66 29 cf           	addb	-0x30d69998(%rbx), %ch
180325d28: 88 aa 11 5d ea ef           	movb	%ch, -0x1015a2ef(%rdx)
180325d2e: a5                          	movsl	(%rsi), %es:(%rdi)
180325d2f: 9f                          	lahf
180325d30: 67 9b                       	addr32		wait
180325d32: d8 a6 6b 8f 67 fa           	fsubs	-0x5987095(%rsi)
180325d38: 7e 4b                       	jle	0x180325d85 <.text+0x315d85>
180325d3a: da bd f1 9e 13 dd           	fidivrl	-0x22ec610f(%rbp)
180325d40: 64 ae                       	scasb	%es:(%rdi), %al
180325d42: 4c f5                       	cmc
180325d44: e8 a5 21 6a 61              	callq	0x1e19c7eee
180325d49: 8c df                       	movl	%ds, %edi
180325d4b: 45 85 53 4e                 	testl	%r10d, 0x4e(%r11)
180325d4f: 2f                          	<unknown>
180325d50: 39 bd 03 22 09 9f           	cmpl	%edi, -0x60f6ddfd(%rbp)
180325d56: 1a 9c 56 18 75 81 1e        	sbbb	0x1e817518(%rsi,%rdx,2), %bl
180325d5d: 40 9f                       	lahf
180325d5f: 4c 6a ec                    	pushq	$-0x14
180325d62: 9b                          	wait
180325d63: df c5                       	ffreep	%st(5)
180325d65: 76 f2                       	jbe	0x180325d59 <.text+0x315d59>
180325d67: 79 7b                       	jns	0x180325de4 <.text+0x315de4>
180325d69: 22 e6                       	andb	%dh, %ah
180325d6b: f4                          	hlt
180325d6c: 1f                          	<unknown>
180325d6d: 3f                          	<unknown>
180325d6e: 61                          	<unknown>
180325d6f: dc fd                       	fdivr	%st, %st(5)
180325d71: 59                          	popq	%rcx
180325d72: 2a f4                       	subb	%ah, %dh
180325d74: 40 0d 40 7b dd be           	orl	$0xbedd7b40, %eax       # imm = 0xBEDD7B40
180325d7a: 7a a5                       	jp	0x180325d21 <.text+0x315d21>
180325d7c: 2e 3c 94                    	cmpb	$-0x6c, %al
180325d7f: d4                          	<unknown>
180325d80: 83 6d bd 8f                 	subl	$-0x71, -0x43(%rbp)
180325d84: ce                          	<unknown>
180325d85: 3b ac a5 65 d0 c4 fb        	cmpl	-0x43b2f9b(%rbp,%riz,4), %ebp
180325d8c: 64 43 2e 98                 	cwtl
180325d90: 9d                          	popfq
180325d91: ed                          	inl	%dx, %eax
180325d92: 24 c2                       	andb	$-0x3e, %al
180325d94: 55                          	pushq	%rbp
180325d95: 2f                          	<unknown>
180325d96: 42 5a                       	popq	%rdx
180325d98: 05 b7 06 c6 a1              	addl	$0xa1c606b7, %eax       # imm = 0xA1C606B7
180325d9d: 0c fe                       	orb	$-0x2, %al
180325d9f: 27                          	<unknown>
180325da0: b1 0d                       	movb	$0xd, %cl
180325da2: 47 4c 70 a8                 	jo	0x180325d4e <.text+0x315d4e>
180325da6: 16                          	<unknown>
180325da7: 7f 23                       	jg	0x180325dcc <.text+0x315dcc>
180325da9: f1                          	<unknown>
180325daa: 6f                          	outsl	(%rsi), %dx
180325dab: 3d 70 1f 82 39              	cmpl	$0x39821f70, %eax       # imm = 0x39821F70
180325db0: af                          	scasl	%es:(%rdi), %eax
180325db1: 63 61 32                    	movslq	0x32(%rcx), %esp
180325db4: e2 63                       	loop	0x180325e19 <.text+0x315e19>
180325db6: 49 70 c7                    	jo	0x180325d80 <.text+0x315d80>
180325db9: d4                          	<unknown>
180325dba: 18 34 33                    	sbbb	%dh, (%rbx,%rsi)
180325dbd: 44 5f                       	popq	%rdi
180325dbf: 0f bd 76 19                 	bsrl	0x19(%rsi), %esi
180325dc3: c5 da a8                    	<unknown>
180325dc6: ad                          	lodsl	(%rsi), %eax
180325dc7: e2 8d                       	loop	0x180325d56 <.text+0x315d56>
180325dc9: 37                          	<unknown>
180325dca: 1e                          	<unknown>
180325dcb: 8f 76 03                    	<unknown>
180325dce: 4c 7c aa                    	jl	0x180325d7b <.text+0x315d7b>
180325dd1: 55                          	pushq	%rbp
180325dd2: 49 8c 5e f5                 	movw	%ds, -0xb(%r14)
180325dd6: f1                          	<unknown>
180325dd7: 13 f9                       	adcl	%ecx, %edi
180325dd9: 6f                          	outsl	(%rsi), %dx
180325dda: 5b                          	popq	%rbx
180325ddb: 10 9c b7 3a ba 8e fe        	adcb	%bl, -0x17145c6(%rdi,%rsi,4)
180325de2: fa                          	cli
180325de3: b6 ae                       	movb	$-0x52, %dh
180325de5: ef                          	outl	%eax, %dx
180325de6: 5b                          	popq	%rbx
180325de7: 46 8d 59 a2                 	leal	-0x5e(%rcx), %r11d
180325deb: b0 3b                       	movb	$0x3b, %al
180325ded: d5 e7 99 0c e1              	setns	(%r9,%r28,8)
180325df2: d4                          	<unknown>
180325df3: 53                          	pushq	%rbx
180325df4: 9a                          	<unknown>
180325df5: 94                          	xchgl	%esp, %eax
180325df6: 48 d8 db                    	fcomp	%st(3)
180325df9: b5 34                       	movb	$0x34, %ch
180325dfb: 93                          	xchgl	%ebx, %eax
180325dfc: 11 ce                       	adcl	%ecx, %esi
180325dfe: 29 ce                       	subl	%ecx, %esi
180325e00: 69 2d 7c 5f 08 b8 dd d0 e4 22       	imull	$0x22e4d0dd, -0x47f7a084(%rip), %ebp # imm = 0x22E4D0DD
                                                                        # 0x1383abd86
180325e0a: d5 68 85 55 e8              	testq	%r18, -0x18(%rbp)
180325e0f: 72 84                       	jb	0x180325d95 <.text+0x315d95>
180325e11: 93                          	xchgl	%ebx, %eax
180325e12: c1 28 0d                    	shrl	$0xd, (%rax)
180325e15: e2 a5                       	loop	0x180325dbc <.text+0x315dbc>
180325e17: 92                          	xchgl	%edx, %eax
180325e18: 1c 09                       	sbbb	$0x9, %al
180325e1a: 9b                          	wait
180325e1b: e7 ce                       	outl	%eax, $0xce
180325e1d: 3e af                       	scasl	%es:(%rdi), %eax
180325e1f: 09 5f 6f                    	orl	%ebx, 0x6f(%rdi)
180325e22: f9                          	stc
180325e23: da cd                       	fcmove	%st(5), %st
180325e25: 29 61 48                    	subl	%esp, 0x48(%rcx)
180325e28: b4 d9                       	movb	$-0x27, %ah
180325e2a: 8a 52 d4                    	movb	-0x2c(%rdx), %dl
180325e2d: 00 e3                       	addb	%ah, %bl
180325e2f: 9f                          	lahf
180325e30: 02 34 ae                    	addb	(%rsi,%rbp,4), %dh
180325e33: d6                          	<unknown>
180325e34: 8d 0a                       	leal	(%rdx), %ecx
180325e36: 6c                          	insb	%dx, %es:(%rdi)
180325e37: 03 1e                       	addl	(%rsi), %ebx
180325e39: bd fc dc 3a 47              	movl	$0x473adcfc, %ebp       # imm = 0x473ADCFC
180325e3e: a4                          	movsb	(%rsi), %es:(%rdi)
180325e3f: bf 3e 73 17 94              	movl	$0x9417733e, %edi       # imm = 0x9417733E
180325e44: 50                          	pushq	%rax
180325e45: a9 d7 b6 02 cf              	testl	$0xcf02b6d7, %eax       # imm = 0xCF02B6D7
180325e4a: e3 20                       	jrcxz	0x180325e6c <.text+0x315e6c>
180325e4c: 04 9b                       	addb	$-0x65, %al
180325e4e: 5b                          	popq	%rbx
180325e4f: e9 39 92 13 ae              	jmp	0x12e45f08d
180325e54: f3 fd                       	rep		std
180325e56: c3                          	retq
180325e57: 3b 45 0b                    	cmpl	0xb(%rbp), %eax
180325e5a: 58                          	popq	%rax
180325e5b: c1 1d 65 a1 5e 26 7f        	rcrl	$0x7f, 0x265ea165(%rip) # 0x1a690ffc7
180325e62: dd a8 b3 56 65 81           	<unknown>
180325e68: af                          	scasl	%es:(%rdi), %eax
180325e69: 97                          	xchgl	%edi, %eax
180325e6a: d4                          	<unknown>
180325e6b: fc                          	cld
180325e6c: 55                          	pushq	%rbp
180325e6d: 1d 07 54 ea 5b              	sbbl	$0x5bea5407, %eax       # imm = 0x5BEA5407
180325e72: 60                          	<unknown>
180325e73: 77 9b                       	ja	0x180325e10 <.text+0x315e10>
180325e75: 43 97                       	xchgl	%r15d, %eax
180325e77: 44 79 51                    	jns	0x180325ecb <.text+0x315ecb>
180325e7a: 14 de                       	adcb	$-0x22, %al
180325e7c: 49 6d                       	insl	%dx, %es:(%rdi)
180325e7e: 61                          	<unknown>
180325e7f: 67 04 2f                    	addr32		addb	$0x2f, %al
180325e82: 69 d5 cc 00 9b 52           	imull	$0x529b00cc, %ebp, %edx # imm = 0x529B00CC
180325e88: 84 57 9f                    	testb	%dl, -0x61(%rdi)
180325e8b: b7 24                       	movb	$0x24, %bh
180325e8d: c0 0e aa                    	rorb	$0xaa, (%rsi)
180325e90: 66 d9 f9                    	fyl2xp1
180325e93: d3 38                       	sarl	%cl, (%rax)
180325e95: ab                          	stosl	%eax, %es:(%rdi)
180325e96: 88 b7 be 54 05 c6           	movb	%dh, -0x39faab42(%rdi)
180325e9c: b7 48                       	movb	$0x48, %bh
180325e9e: 51                          	pushq	%rcx
180325e9f: f9                          	stc
180325ea0: 7c 09                       	jl	0x180325eab <.text+0x315eab>
180325ea2: 29 76 bb                    	subl	%esi, -0x45(%rsi)
180325ea5: 15 06 64 d1 b4              	adcl	$0xb4d16406, %eax       # imm = 0xB4D16406
180325eaa: 51                          	pushq	%rcx
180325eab: f6 6a d5                    	imulb	-0x2b(%rdx)
180325eae: 44 18 90 06 18 41 33        	sbbb	%r10b, 0x33411806(%rax)
180325eb5: 29 c1                       	subl	%eax, %ecx
180325eb7: ad                          	lodsl	(%rsi), %eax
180325eb8: c7 c8                       	<unknown>
180325eba: d5 5f 10 22                 	adcb	%r28b, (%r26)
180325ebe: 4c 22 b4 8f ed 16 d2 5d     	andb	0x5dd216ed(%rdi,%rcx,4), %r14b
180325ec6: 8b fe                       	movl	%esi, %edi
180325ec8: 3f                          	<unknown>
180325ec9: 6c                          	insb	%dx, %es:(%rdi)
180325eca: 48 58                       	popq	%rax
180325ecc: c3                          	retq
180325ecd: 10 a4 42 68 68 69 14        	adcb	%ah, 0x14696868(%rdx,%rax,2)
180325ed4: 1d 3b 29 1f dc              	sbbl	$0xdc1f293b, %eax       # imm = 0xDC1F293B
180325ed9: dc 55 7b                    	fcoml	0x7b(%rbp)
180325edc: e7 2c                       	outl	%eax, $0x2c
180325ede: f2 6a 19                    	repne		pushq	$0x19
180325ee1: 80 da 5b                    	sbbb	$0x5b, %dl
180325ee4: 4b 0e                       	<unknown>
180325ee6: d9 d1                       	<unknown>
180325ee8: 06                          	<unknown>
180325ee9: 94                          	xchgl	%esp, %eax
180325eea: 7a 14                       	jp	0x180325f00 <.text+0x315f00>
180325eec: 79 a5                       	jns	0x180325e93 <.text+0x315e93>
180325eee: b7 4e                       	movb	$0x4e, %bh
180325ef0: 77 7f                       	ja	0x180325f71 <.text+0x315f71>
180325ef2: c6 6f c5                    	<unknown>
180325ef5: ee                          	outb	%al, %dx
180325ef6: ea                          	<unknown>
180325ef7: 2a 16                       	subb	(%rsi), %dl
180325ef9: 39 96 8d b0 32 80           	cmpl	%edx, -0x7fcd4f73(%rsi)
180325eff: f7 cf                       	<unknown>
180325f01: 72 3a                       	jb	0x180325f3d <.text+0x315f3d>
180325f03: 52                          	pushq	%rdx
180325f04: 95                          	xchgl	%ebp, %eax
180325f05: 11 eb                       	adcl	%ebp, %ebx
180325f07: 5b                          	popq	%rbx
180325f08: c7 3c 08                    	<unknown>
180325f0b: 50                          	pushq	%rax
180325f0c: 50                          	pushq	%rax
180325f0d: 57                          	pushq	%rdi
180325f0e: b8 c0 0c e0 de              	movl	$0xdee00cc0, %eax       # imm = 0xDEE00CC0
180325f13: 3a 53 7c                    	cmpb	0x7c(%rbx), %dl
180325f16: c0 f8 67                    	sarb	$0x67, %al
180325f19: 6b bf f7 b4 3f be d8        	imull	$-0x28, -0x41c04b09(%rdi), %edi
180325f20: c2 fa 40                    	retq	$0x40fa                 # imm = 0x40FA
180325f23: 84 b0 06 4c 24 0b           	testb	%dh, 0xb244c06(%rax)
180325f29: 0c 0e                       	orb	$0xe, %al
180325f2b: e4 d9                       	inb	$0xd9, %al
180325f2d: ee                          	outb	%al, %dx
180325f2e: cf                          	iretl
180325f2f: 83 9c 6b 53 8b 23 0b ba     	sbbl	$-0x46, 0xb238b53(%rbx,%rbp,2)
180325f37: d7                          	xlatb
180325f38: a9 b3 de 06 51              	testl	$0x5106deb3, %eax       # imm = 0x5106DEB3
180325f3d: 4f 0f d5 92 1b 9f 13 db     	pmullw	-0x24ec60e5(%r10), %mm2
180325f45: df c7                       	ffreep	%st(7)
180325f47: d6                          	<unknown>
180325f48: 31 5d db                    	xorl	%ebx, -0x25(%rbp)
180325f4b: 88 27                       	movb	%ah, (%rdi)
180325f4d: cd 35                       	int	$0x35
180325f4f: b2 fd                       	movb	$-0x3, %dl
180325f51: 53                          	pushq	%rbx
180325f52: 82                          	<unknown>
180325f53: f6 0b                       	<unknown>
180325f55: 6c                          	insb	%dx, %es:(%rdi)
180325f56: 4e 79 04                    	jns	0x180325f5d <.text+0x315f5d>
180325f59: 7e 84                       	jle	0x180325edf <.text+0x315edf>
180325f5b: 6f                          	outsl	(%rsi), %dx
180325f5c: c8 28 3f 01                 	enter	$0x3f28, $0x1           # imm = 0x3F28
180325f60: 2a 4f 06                    	subb	0x6(%rdi), %cl
180325f63: 06                          	<unknown>
180325f64: dd 6e 49                    	<unknown>
180325f67: 49 ae                       	scasb	%es:(%rdi), %al
180325f69: 0b 34 5d a8 5d 2b 41        	orl	0x412b5da8(,%rbx,2), %esi
180325f70: 52                          	pushq	%rdx
180325f71: 8a f8                       	movb	%al, %bh
180325f73: b8 7d 0d 6a 0d              	movl	$0xd6a0d7d, %eax        # imm = 0xD6A0D7D
180325f78: c8 fa 96 aa                 	enter	$-0x6906, $-0x56        # imm = 0x96FA
180325f7c: 8d 80 01 fe 4b 72           	leal	0x724bfe01(%rax), %eax
180325f82: 05 42 08 f5 a2              	addl	$0xa2f50842, %eax       # imm = 0xA2F50842
180325f87: 78 ab                       	js	0x180325f34 <.text+0x315f34>
180325f89: b5 76                       	movb	$0x76, %ch
180325f8b: 55                          	pushq	%rbp
180325f8c: fd                          	std
180325f8d: e9 eb 94 1d 9d              	jmp	0x11d4ff47d
180325f92: a2 41 18 06 cc e3 da b5 e9  	movabsb	%al, -0x164a251c33f9e7bf
180325f9b: 7e aa                       	jle	0x180325f47 <.text+0x315f47>
180325f9d: 60                          	<unknown>
180325f9e: d8 1b                       	fcomps	(%rbx)
180325fa0: d6                          	<unknown>
180325fa1: 96                          	xchgl	%esi, %eax
180325fa2: b0 f7                       	movb	$-0x9, %al
180325fa4: 8d 69 b7                    	leal	-0x49(%rcx), %ebp
180325fa7: 05 7b ba 50 fe              	addl	$0xfe50ba7b, %eax       # imm = 0xFE50BA7B
180325fac: c0 86 f8 7e 4f 5a 0e        	rolb	$0xe, 0x5a4f7ef8(%rsi)
180325fb3: 75 c1                       	jne	0x180325f76 <.text+0x315f76>
180325fb5: c3                          	retq
180325fb6: 28 16                       	subb	%dl, (%rsi)
180325fb8: f3 4a c5 1b b1              	<unknown>
180325fbd: 8b 15 94 dd 2a 07           	movl	0x72add94(%rip), %edx   # 0x1875d3d57
180325fc3: 0d 22 6a 49 ad              	orl	$0xad496a22, %eax       # imm = 0xAD496A22
180325fc8: cf                          	iretl
180325fc9: e1 4e                       	loope	0x180326019 <.text+0x316019>
180325fcb: 7a 70                       	jp	0x18032603d <.text+0x31603d>
180325fcd: 72 b6                       	jb	0x180325f85 <.text+0x315f85>
180325fcf: b0 50                       	movb	$0x50, %al
180325fd1: fa                          	cli
180325fd2: 8c eb                       	movl	%gs, %ebx
180325fd4: c9                          	leave
180325fd5: 55                          	pushq	%rbp
180325fd6: 64 6b b8 f6 5d 6b 40 1d     	imull	$0x1d, %fs:0x406b5df6(%rax), %edi
180325fde: 1e                          	<unknown>
180325fdf: fe 1a                       	<unknown>
180325fe1: 63 bc 2a 0d 26 bf f2        	movslq	-0xd40d9f3(%rdx,%rbp), %edi
180325fe8: 63 06                       	movslq	(%rsi), %eax
180325fea: 34 e5                       	xorb	$-0x1b, %al
180325fec: c7 1a                       	<unknown>
180325fee: cd 62                       	int	$0x62
180325ff0: 04 6e                       	addb	$0x6e, %al
180325ff2: 91                          	xchgl	%ecx, %eax
180325ff3: 39 67 5d                    	cmpl	%esp, 0x5d(%rdi)
180325ff6: 03 85 43 06 61 15           	addl	0x15610643(%rbp), %eax
180325ffc: 00 b3 c7 cc ef eb           	addb	%dh, -0x14103339(%rbx)
180326002: 1e                          	<unknown>
180326003: 5f                          	popq	%rdi
180326004: ea                          	<unknown>
180326005: 90                          	nop
180326006: 35 11 13 48 3c              	xorl	$0x3c481311, %eax       # imm = 0x3C481311
18032600b: 64 d6                       	<unknown>
18032600d: a3 61 05 50 77 1b 0c 31 d6  	movabsl	%eax, -0x29cef3e488affa9f
180326016: 88 93 8c 8c 5f 3b           	movb	%dl, 0x3b5f8c8c(%rbx)
18032601c: 70 1c                       	jo	0x18032603a <.text+0x31603a>
18032601e: 1d 60 6e 77 81              	sbbl	$0x81776e60, %eax       # imm = 0x81776E60
180326023: 1e                          	<unknown>
180326024: 56                          	pushq	%rsi
180326025: bd 5f df a1 3a              	movl	$0x3aa1df5f, %ebp       # imm = 0x3AA1DF5F
18032602a: 89 40 92                    	movl	%eax, -0x6e(%rax)
18032602d: d3 7e 54                    	sarl	%cl, 0x54(%rsi)
180326030: f1                          	<unknown>
180326031: ad                          	lodsl	(%rsi), %eax
180326032: f2 1f                       	<unknown>
180326034: 23 94 fa 0f 6c d1 dd        	andl	-0x222e93f1(%rdx,%rdi,8), %edx
18032603b: fd                          	std
18032603c: 6d                          	insl	%dx, %es:(%rdi)
18032603d: c3                          	retq
18032603e: cc                          	int3
18032603f: 65 ce                       	<unknown>
180326041: 71 d5                       	jno	0x180326018 <.text+0x316018>
180326043: ec                          	inb	%dx, %al
180326044: 66 79 9a                    	jns	0x180325fe1 <.text+0x315fe1>
180326047: ed                          	inl	%dx, %eax
180326048: 86 7f 74                    	xchgb	%bh, 0x74(%rdi)
18032604b: f3 ee                       	rep		outb	%al, %dx
18032604d: 88 98 5f 22 af 64           	movb	%bl, 0x64af225f(%rax)
180326053: eb 18                       	jmp	0x18032606d <.text+0x31606d>
180326055: 49 db 2a                    	fldt	(%r10)
180326058: 2e 3f                       	<unknown>
18032605a: 06                          	<unknown>
18032605b: 5a                          	popq	%rdx
18032605c: a8 bf                       	testb	$-0x41, %al
18032605e: 6c                          	insb	%dx, %es:(%rdi)
18032605f: 05 a8 cf 88 28              	addl	$0x2888cfa8, %eax       # imm = 0x2888CFA8
180326064: f4                          	hlt
180326065: 16                          	<unknown>
180326066: 1b 1d 1a c5 11 8d           	sbbl	-0x72ee3ae6(%rip), %ebx # 0x10d442586
18032606c: 99                          	cltd
18032606d: a4                          	movsb	(%rsi), %es:(%rdi)
18032606e: cc                          	int3
18032606f: ec                          	inb	%dx, %al
180326070: e3 d6                       	jrcxz	0x180326048 <.text+0x316048>
180326072: 8b f2                       	movl	%edx, %esi
180326074: 63 0f                       	movslq	(%rdi), %ecx
180326076: 34 75                       	xorb	$0x75, %al
180326078: d6                          	<unknown>
180326079: 85 c6                       	testl	%eax, %esi
18032607b: cc                          	int3
18032607c: 70 97                       	jo	0x180326015 <.text+0x316015>
18032607e: c7 af 14 e6 0a 82           	<unknown>
180326084: f4                          	hlt
180326085: ad                          	lodsl	(%rsi), %eax
180326086: da 3c d9                    	fidivrl	(%rcx,%rbx,8)
180326089: a9 b3 8d 69 9c              	testl	$0x9c698db3, %eax       # imm = 0x9C698DB3
18032608e: d9 0c 8c                    	<unknown>
180326091: dc 3f                       	fdivrl	(%rdi)
180326093: 67 35 f0 d6 50 56           	addr32		xorl	$0x5650d6f0, %eax # imm = 0x5650D6F0
180326099: 91                          	xchgl	%ecx, %eax
18032609a: 50                          	pushq	%rax
18032609b: 70 bf                       	jo	0x18032605c <.text+0x31605c>
18032609d: cc                          	int3
18032609e: 9b                          	wait
18032609f: 26 1d 2c d2 c1 93           	sbbl	$0x93c1d22c, %eax       # imm = 0x93C1D22C
1803260a5: 25 58 48 fe 4e              	andl	$0x4efe4858, %eax       # imm = 0x4EFE4858
1803260aa: 37                          	<unknown>
1803260ab: 69 85 36 33 7f a7 0b e4 17 fe       	imull	$0xfe17e40b, -0x5880ccca(%rbp), %eax # imm = 0xFE17E40B
1803260b5: 6e                          	outsb	(%rsi), %dx
1803260b6: b7 a8                       	movb	$-0x58, %bh
1803260b8: 26 86 0e                    	xchgb	%cl, %es:(%rsi)
1803260bb: f0                          	lock
1803260bc: 40 96                       	xchgl	%esi, %eax
1803260be: 18 a0 08 55 81 dd           	sbbb	%ah, -0x227eaaf8(%rax)
1803260c4: 70 51                       	jo	0x180326117 <.text+0x316117>
1803260c6: 26 2b fe                    	subl	%esi, %edi
1803260c9: 64 5c                       	popq	%rsp
1803260cb: a7                          	cmpsl	%es:(%rdi), (%rsi)
1803260cc: 0c 8a                       	orb	$-0x76, %al
1803260ce: 99                          	cltd
1803260cf: fe 53 da                    	<unknown>
1803260d2: e4 d0                       	inb	$0xd0, %al
1803260d4: 25 d5 75 9b bf              	andl	$0xbf9b75d5, %eax       # imm = 0xBF9B75D5
1803260d9: 8b 7e 21                    	movl	0x21(%rsi), %edi
1803260dc: 1c f7                       	sbbb	$-0x9, %al
1803260de: 3b b0 bb e2 61 eb           	cmpl	-0x149e1d45(%rax), %esi
1803260e4: 93                          	xchgl	%ebx, %eax
1803260e5: 48 56                       	pushq	%rsi
1803260e7: b3 30                       	movb	$0x30, %bl
1803260e9: c0 03 cc                    	rolb	$0xcc, (%rbx)
1803260ec: 4e 0e                       	<unknown>
1803260ee: d5 5f a7                    	cmpsq	%es:(%rdi), (%rsi)
1803260f1: 72 77                       	jb	0x18032616a <.text+0x31616a>
1803260f3: 15 f8 2b 6d a6              	adcl	$0xa66d2bf8, %eax       # imm = 0xA66D2BF8
1803260f8: eb 64                       	jmp	0x18032615e <.text+0x31615e>
1803260fa: 06                          	<unknown>
1803260fb: 06                          	<unknown>
1803260fc: f2 8c 10                    	repne		movw	%ss, (%rax)
1803260ff: 9f                          	lahf
180326100: a3 01 a1 44 03 fe 1a 32 96  	movabsl	%eax, -0x69cde501fcbb5eff
180326109: 35 7b 69 80 53              	xorl	$0x5380697b, %eax       # imm = 0x5380697B
18032610e: fd                          	std
18032610f: 39 25 9d d3 06 aa           	cmpl	%esp, -0x55f92c63(%rip) # 0x12a3934b2
180326115: 0a 1e                       	orb	(%rsi), %bl
180326117: d9 00                       	flds	(%rax)
180326119: 2f                          	<unknown>
18032611a: 6f                          	outsl	(%rsi), %dx
18032611b: 7c 9f                       	jl	0x1803260bc <.text+0x3160bc>
18032611d: ce                          	<unknown>
18032611e: f7 94 8a 8f 2b 46 ce        	notl	-0x31b9d471(%rdx,%rcx,4)
180326125: 7d f4                       	jge	0x18032611b <.text+0x31611b>
180326127: 1d 56 fc a0 64              	sbbl	$0x64a0fc56, %eax       # imm = 0x64A0FC56
18032612c: 06                          	<unknown>
18032612d: a5                          	movsl	(%rsi), %es:(%rdi)
18032612e: 7c 0d                       	jl	0x18032613d <.text+0x31613d>
180326130: a8 2c                       	testb	$0x2c, %al
180326132: 33 e6                       	xorl	%esi, %esp
180326134: f0                          	lock
180326135: 64 8b 32                    	movl	%fs:(%rdx), %esi
180326138: 90                          	nop
180326139: 9f                          	lahf
18032613a: e6 69                       	outb	%al, $0x69
18032613c: 38 dc                       	cmpb	%bl, %ah
18032613e: 39 cd                       	cmpl	%ecx, %ebp
180326140: a5                          	movsl	(%rsi), %es:(%rdi)
180326141: 95                          	xchgl	%ebp, %eax
180326142: ca 65 8d                    	lretl	$-0x729b                # imm = 0x8D65
180326145: 71 ce                       	jno	0x180326115 <.text+0x316115>
180326147: 40 7a 0f                    	jp	0x180326159 <.text+0x316159>
18032614a: c6 a1 57 65 1b 31           	<unknown>
180326150: b1 fa                       	movb	$-0x6, %cl
180326152: ce                          	<unknown>
180326153: 71 7d                       	jno	0x1803261d2 <.text+0x3161d2>
180326155: c9                          	leave
180326156: b9 bb 4f be 25              	movl	$0x25be4fbb, %ecx       # imm = 0x25BE4FBB
18032615b: 13 53 7e                    	adcl	0x7e(%rbx), %edx
18032615e: 32 8f 16 ba a7 7a           	xorb	0x7aa7ba16(%rdi), %cl
180326164: 6f                          	outsl	(%rsi), %dx
180326165: 5a                          	popq	%rdx
180326166: e1 5c                       	loope	0x1803261c4 <.text+0x3161c4>
180326168: 45 25 29 54 be 91           	andl	$0x91be5429, %eax       # imm = 0x91BE5429
18032616e: 79 4e                       	jns	0x1803261be <.text+0x3161be>
180326170: 9c                          	pushfq
180326171: a8 5f                       	testb	$0x5f, %al
180326173: b0 4b                       	movb	$0x4b, %al
180326175: d7                          	xlatb
180326176: 0f 41 e8                    	cmovnol	%eax, %ebp
180326179: 65 0e                       	<unknown>
18032617b: 1e                          	<unknown>
18032617c: e8 45 3f bb b2              	callq	0x132eda0c6
180326181: a5                          	movsl	(%rsi), %es:(%rdi)
180326182: 6a d9                       	pushq	$-0x27
180326184: 19 49 51                    	sbbl	%ecx, 0x51(%rcx)
180326187: 6b f4 32                    	imull	$0x32, %esp, %esi
18032618a: 8b 5f 2b                    	movl	0x2b(%rdi), %ebx
18032618d: 15 dc 6f a3 49              	adcl	$0x49a36fdc, %eax       # imm = 0x49A36FDC
180326192: 41 90                       	xchgl	%r8d, %eax
180326194: 15 9b 16 f0 c1              	adcl	$0xc1f0169b, %eax       # imm = 0xC1F0169B
180326199: b8 95 0b 9b 7c              	movl	$0x7c9b0b95, %eax       # imm = 0x7C9B0B95
18032619e: ad                          	lodsl	(%rsi), %eax
18032619f: e3 9a                       	jrcxz	0x18032613b <.text+0x31613b>
1803261a1: e8 e1 f2 a4 7e              	callq	0x1fed75487
1803261a6: 35 d6 3c a3 72              	xorl	$0x72a33cd6, %eax       # imm = 0x72A33CD6
1803261ab: bd b5 fc 96 d7              	movl	$0xd796fcb5, %ebp       # imm = 0xD796FCB5
1803261b0: bd 02 53 44 5e              	movl	$0x5e445302, %ebp       # imm = 0x5E445302
1803261b5: bd 4b 12 4d 0c              	movl	$0xc4d124b, %ebp        # imm = 0xC4D124B
1803261ba: 28 35 0f 1f 40 00           	subb	%dh, 0x401f0f(%rip)     # 0x1807280cf
