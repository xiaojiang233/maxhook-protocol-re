
E:\MCLDownload\Game\.minecraft\native\MaxHook.dll:	file format coff-x86-64

Disassembly of section .text:

0000000180010000 <.text>:
180332770: 55                          	push	rbp
180332771: 41 57                       	push	r15
180332773: 41 56                       	push	r14
180332775: 41 55                       	push	r13
180332777: 41 54                       	push	r12
180332779: 56                          	push	rsi
18033277a: 57                          	push	rdi
18033277b: 53                          	push	rbx
18033277c: 48 81 ec 68 01 00 00        	sub	rsp, 0x168
180332783: 48 8d ac 24 80 00 00 00     	lea	rbp, [rsp + 0x80]
18033278b: 48 c7 85 e0 00 00 00 fe ff ff ff    	mov	qword ptr [rbp + 0xe0], -0x2
180332796: 4c 89 c3                    	mov	rbx, r8
180332799: 48 89 d6                    	mov	rsi, rdx
18033279c: 48 89 cf                    	mov	rdi, rcx
18033279f: 48 63 05 d2 53 49 00        	movsxd	rax, dword ptr [rip + 0x4953d2] # 0x1807c7b78
1803327a6: 4c 8d 35 e3 67 32 00        	lea	r14, [rip + 0x3267e3]   # 0x180658f90
1803327ad: b9 26 5e 4a 39              	mov	ecx, 0x394a5e26
1803327b2: 41 33 0c 86                 	xor	ecx, dword ptr [r14 + 4*rax]
1803327b6: 0f c9                       	bswap	ecx
1803327b8: 48 63 c9                    	movsxd	rcx, ecx
1803327bb: 4c 8d 2d 0e 13 49 00        	lea	r13, [rip + 0x49130e]   # 0x1807c3ad0
1803327c2: 41 8b 44 8d 00              	mov	eax, dword ptr [r13 + 4*rcx]
1803327c7: 81 c1 5a 89 ec ac           	add	ecx, 0xacec895a
1803327cd: d3 c8                       	ror	eax, cl
1803327cf: ff c0                       	inc	eax
1803327d1: d3 c8                       	ror	eax, cl
1803327d3: 35 ac ec 89 5a              	xor	eax, 0x5a89ecac
1803327d8: 0f c8                       	bswap	eax
1803327da: 48 98                       	cdqe
1803327dc: 4c 8d 25 8d b4 48 00        	lea	r12, [rip + 0x48b48d]   # 0x1807bdc70
1803327e3: 4c 89 8d a8 00 00 00        	mov	qword ptr [rbp + 0xa8], r9
1803327ea: 4c 89 c9                    	mov	rcx, r9
1803327ed: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803327f1: 48 63 0d 10 54 49 00        	movsxd	rcx, dword ptr [rip + 0x495410] # 0x1807c7c08
1803327f8: ba 69 ea 92 9a              	mov	edx, 0x9a92ea69
1803327fd: 41 33 14 8e                 	xor	edx, dword ptr [r14 + 4*rcx]
180332801: 0f ca                       	bswap	edx
180332803: 89 d1                       	mov	ecx, edx
180332805: f7 d9                       	neg	ecx
180332807: 48 63 c9                    	movsxd	rcx, ecx
18033280a: 45 8b 44 8d 00              	mov	r8d, dword ptr [r13 + 4*rcx]
18033280f: 41 0f c8                    	bswap	r8d
180332812: b9 06 00 00 00              	mov	ecx, 0x6
180332817: 29 d1                       	sub	ecx, edx
180332819: 41 d3 c8                    	ror	r8d, cl
18033281c: 83 c2 06                    	add	edx, 0x6
18033281f: 89 d1                       	mov	ecx, edx
180332821: 41 d3 c0                    	rol	r8d, cl
180332824: 49 89 c7                    	mov	r15, rax
180332827: 41 81 f0 d9 22 94 b4        	xor	r8d, 0xb49422d9
18033282e: 41 0f c8                    	bswap	r8d
180332831: 49 63 c0                    	movsxd	rax, r8d
180332834: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332838: 89 c0                       	mov	eax, eax
18033283a: 49 39 c7                    	cmp	r15, rax
18033283d: 76 4e                       	jbe	0x18033288d <.text+0x32288d>
18033283f: 48 63 05 f2 52 49 00        	movsxd	rax, dword ptr [rip + 0x4952f2] # 0x1807c7b38
180332846: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
18033284a: f7 d2                       	not	edx
18033284c: b9 16 00 00 00              	mov	ecx, 0x16
180332851: 29 c1                       	sub	ecx, eax
180332853: d3 c2                       	rol	edx, cl
180332855: 8d 48 16                    	lea	ecx, [rax + 0x16]
180332858: d3 ca                       	ror	edx, cl
18033285a: b9 5a 48 0b c3              	mov	ecx, 0xc30b485a
18033285f: 29 d1                       	sub	ecx, edx
180332861: f7 da                       	neg	edx
180332863: 48 63 c2                    	movsxd	rax, edx
180332866: 31 d2                       	xor	edx, edx
180332868: 41 2b 54 85 00              	sub	edx, dword ptr [r13 + 4*rax]
18033286d: d3 ca                       	ror	edx, cl
18033286f: 81 f2 5a 48 0b c3           	xor	edx, 0xc30b485a
180332875: d3 ca                       	ror	edx, cl
180332877: f7 d2                       	not	edx
180332879: 0f ca                       	bswap	edx
18033287b: 48 63 c2                    	movsxd	rax, edx
18033287e: 48 89 f9                    	mov	rcx, rdi
180332881: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332885: 48 89 f8                    	mov	rax, rdi
180332888: e9 97 0d 00 00              	jmp	0x180333624 <.text+0x323624>
18033288d: 48 89 bd d8 00 00 00        	mov	qword ptr [rbp + 0xd8], rdi
180332894: 48 63 05 a1 52 49 00        	movsxd	rax, dword ptr [rip + 0x4952a1] # 0x1807c7b3c
18033289b: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
18033289f: 8d 88 49 de 49 f4           	lea	ecx, [rax - 0xbb621b7]
1803328a5: d3 ca                       	ror	edx, cl
1803328a7: 0f ca                       	bswap	edx
1803328a9: d3 ca                       	ror	edx, cl
1803328ab: b9 09 00 00 00              	mov	ecx, 0x9
1803328b0: 29 c1                       	sub	ecx, eax
1803328b2: d3 c2                       	rol	edx, cl
1803328b4: 48 63 ca                    	movsxd	rcx, edx
1803328b7: 41 8b 44 8d 00              	mov	eax, dword ptr [r13 + 4*rcx]
1803328bc: f7 d0                       	not	eax
1803328be: 0f c8                       	bswap	eax
1803328c0: 81 c1 71 af b1 1e           	add	ecx, 0x1eb1af71
1803328c6: d3 c8                       	ror	eax, cl
1803328c8: d3 c8                       	ror	eax, cl
1803328ca: d3 c8                       	ror	eax, cl
1803328cc: f7 d0                       	not	eax
1803328ce: 48 98                       	cdqe
1803328d0: 4c 8d 7d b8                 	lea	r15, [rbp - 0x48]
1803328d4: 4c 89 f9                    	mov	rcx, r15
1803328d7: 48 89 f2                    	mov	rdx, rsi
1803328da: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803328de: 48 63 05 a3 52 49 00        	movsxd	rax, dword ptr [rip + 0x4952a3] # 0x1807c7b88
1803328e5: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803328e9: 8d 88 f8 4e fe a4           	lea	ecx, [rax - 0x5b01b108]
1803328ef: d3 ca                       	ror	edx, cl
1803328f1: d3 ca                       	ror	edx, cl
1803328f3: 0f ca                       	bswap	edx
1803328f5: d3 ca                       	ror	edx, cl
1803328f7: 48 63 c2                    	movsxd	rax, edx
1803328fa: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803328ff: 0f ca                       	bswap	edx
180332901: f7 da                       	neg	edx
180332903: 8d 88 6b 47 f6 9e           	lea	ecx, [rax - 0x6109b895]
180332909: d3 ca                       	ror	edx, cl
18033290b: 0f ca                       	bswap	edx
18033290d: d3 ca                       	ror	edx, cl
18033290f: 0f ca                       	bswap	edx
180332911: f7 da                       	neg	edx
180332913: b9 0b 00 00 00              	mov	ecx, 0xb
180332918: 29 c1                       	sub	ecx, eax
18033291a: d3 c2                       	rol	edx, cl
18033291c: 48 63 c2                    	movsxd	rax, edx
18033291f: 4c 89 f9                    	mov	rcx, r15
180332922: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332926: 84 c0                       	test	al, al
180332928: 74 75                       	je	0x18033299f <.text+0x32299f>
18033292a: 48 63 05 4f 52 49 00        	movsxd	rax, dword ptr [rip + 0x49524f] # 0x1807c7b80
180332931: 49 63 04 86                 	movsxd	rax, dword ptr [r14 + 4*rax]
180332935: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
18033293a: 0f ca                       	bswap	edx
18033293c: ff ca                       	dec	edx
18033293e: 8d 48 0c                    	lea	ecx, [rax + 0xc]
180332941: d3 ca                       	ror	edx, cl
180332943: f7 d2                       	not	edx
180332945: 0f ca                       	bswap	edx
180332947: ff ca                       	dec	edx
180332949: 48 63 c2                    	movsxd	rax, edx
18033294c: 48 8d 4d b8                 	lea	rcx, [rbp - 0x48]
180332950: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332954: 48 63 15 35 52 49 00        	movsxd	rdx, dword ptr [rip + 0x495235] # 0x1807c7b90
18033295b: 45 8b 04 96                 	mov	r8d, dword ptr [r14 + 4*rdx]
18033295f: 8d 4a 01                    	lea	ecx, [rdx + 0x1]
180332962: 41 d3 c8                    	ror	r8d, cl
180332965: b9 01 00 00 00              	mov	ecx, 0x1
18033296a: 29 d1                       	sub	ecx, edx
18033296c: 41 d3 c0                    	rol	r8d, cl
18033296f: 49 63 d0                    	movsxd	rdx, r8d
180332972: 45 8b 44 95 00              	mov	r8d, dword ptr [r13 + 4*rdx]
180332977: 41 0f c8                    	bswap	r8d
18033297a: b9 02 f5 25 7a              	mov	ecx, 0x7a25f502
18033297f: 29 d1                       	sub	ecx, edx
180332981: 41 d3 c0                    	rol	r8d, cl
180332984: 41 f7 d8                    	neg	r8d
180332987: 41 d3 c0                    	rol	r8d, cl
18033298a: 41 d3 c0                    	rol	r8d, cl
18033298d: 48 8d 48 08                 	lea	rcx, [rax + 0x8]
180332991: 41 f7 d8                    	neg	r8d
180332994: 49 63 c0                    	movsxd	rax, r8d
180332997: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
18033299b: 84 c0                       	test	al, al
18033299d: 74 58                       	je	0x1803329f7 <.text+0x3229f7>
18033299f: 48 63 05 9e 51 49 00        	movsxd	rax, dword ptr [rip + 0x49519e] # 0x1807c7b44
1803329a6: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803329aa: f7 d2                       	not	edx
1803329ac: b9 16 00 00 00              	mov	ecx, 0x16
1803329b1: 29 c1                       	sub	ecx, eax
1803329b3: d3 c2                       	rol	edx, cl
1803329b5: 8d 48 16                    	lea	ecx, [rax + 0x16]
1803329b8: d3 ca                       	ror	edx, cl
1803329ba: b9 5a 48 0b c3              	mov	ecx, 0xc30b485a
1803329bf: 29 d1                       	sub	ecx, edx
1803329c1: f7 da                       	neg	edx
1803329c3: 48 63 c2                    	movsxd	rax, edx
1803329c6: 31 d2                       	xor	edx, edx
1803329c8: 41 2b 54 85 00              	sub	edx, dword ptr [r13 + 4*rax]
1803329cd: d3 ca                       	ror	edx, cl
1803329cf: 81 f2 5a 48 0b c3           	xor	edx, 0xc30b485a
1803329d5: d3 ca                       	ror	edx, cl
1803329d7: f7 d2                       	not	edx
1803329d9: 0f ca                       	bswap	edx
1803329db: 48 63 c2                    	movsxd	rax, edx
1803329de: 48 8b b5 d8 00 00 00        	mov	rsi, qword ptr [rbp + 0xd8]
1803329e5: 48 89 f1                    	mov	rcx, rsi
1803329e8: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803329ec: 8b 05 9e da 47 00           	mov	eax, dword ptr [rip + 0x47da9e] # 0x1807b0490
1803329f2: e9 ca 0b 00 00              	jmp	0x1803335c1 <.text+0x3235c1>
1803329f7: 48 8d 4d 28                 	lea	rcx, [rbp + 0x28]
1803329fb: 48 89 da                    	mov	rdx, rbx
1803329fe: e8 bd d3 ff ff              	call	0x18032fdc0 <.text+0x31fdc0>
180332a03: 48 8b b5 d8 00 00 00        	mov	rsi, qword ptr [rbp + 0xd8]
180332a0a: 48 63 05 83 51 49 00        	movsxd	rax, dword ptr [rip + 0x495183] # 0x1807c7b94
180332a11: 4c 8d 35 78 65 32 00        	lea	r14, [rip + 0x326578]   # 0x180658f90
180332a18: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
180332a1c: b9 03 00 00 00              	mov	ecx, 0x3
180332a21: 29 c1                       	sub	ecx, eax
180332a23: d3 c2                       	rol	edx, cl
180332a25: 81 f2 e9 0d 0d e9           	xor	edx, 0xe90d0de9
180332a2b: 0f ca                       	bswap	edx
180332a2d: 48 63 ca                    	movsxd	rcx, edx
180332a30: 4c 8d 2d 99 10 49 00        	lea	r13, [rip + 0x491099]   # 0x1807c3ad0
180332a37: 41 8b 44 8d 00              	mov	eax, dword ptr [r13 + 4*rcx]
180332a3c: 0f c8                       	bswap	eax
180332a3e: 81 c1 d2 b3 92 bf           	add	ecx, 0xbf92b3d2
180332a44: d3 c8                       	ror	eax, cl
180332a46: 35 2d 4c 6d 40              	xor	eax, 0x406d4c2d
180332a4b: d3 c8                       	ror	eax, cl
180332a4d: f7 d8                       	neg	eax
180332a4f: 48 98                       	cdqe
180332a51: 48 89 d9                    	mov	rcx, rbx
180332a54: 4c 8d 25 15 b2 48 00        	lea	r12, [rip + 0x48b215]   # 0x1807bdc70
180332a5b: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332a5f: 84 c0                       	test	al, al
180332a61: 0f 85 94 00 00 00           	jne	0x180332afb <.text+0x322afb>
180332a67: 48 63 05 0e 51 49 00        	movsxd	rax, dword ptr [rip + 0x49510e] # 0x1807c7b7c
180332a6e: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
180332a72: 8d 48 01                    	lea	ecx, [rax + 0x1]
180332a75: d3 ca                       	ror	edx, cl
180332a77: b9 01 00 00 00              	mov	ecx, 0x1
180332a7c: 29 c1                       	sub	ecx, eax
180332a7e: d3 c2                       	rol	edx, cl
180332a80: 48 63 c2                    	movsxd	rax, edx
180332a83: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
180332a88: 0f ca                       	bswap	edx
180332a8a: b9 02 f5 25 7a              	mov	ecx, 0x7a25f502
180332a8f: 29 c1                       	sub	ecx, eax
180332a91: d3 c2                       	rol	edx, cl
180332a93: f7 da                       	neg	edx
180332a95: d3 c2                       	rol	edx, cl
180332a97: d3 c2                       	rol	edx, cl
180332a99: f7 da                       	neg	edx
180332a9b: 48 63 c2                    	movsxd	rax, edx
180332a9e: 48 8d 4d 28                 	lea	rcx, [rbp + 0x28]
180332aa2: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332aa6: 84 c0                       	test	al, al
180332aa8: 74 51                       	je	0x180332afb <.text+0x322afb>
180332aaa: 48 63 05 b7 50 49 00        	movsxd	rax, dword ptr [rip + 0x4950b7] # 0x1807c7b68
180332ab1: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
180332ab5: f7 d2                       	not	edx
180332ab7: b9 16 00 00 00              	mov	ecx, 0x16
180332abc: 29 c1                       	sub	ecx, eax
180332abe: d3 c2                       	rol	edx, cl
180332ac0: 8d 48 16                    	lea	ecx, [rax + 0x16]
180332ac3: d3 ca                       	ror	edx, cl
180332ac5: b9 5a 48 0b c3              	mov	ecx, 0xc30b485a
180332aca: 29 d1                       	sub	ecx, edx
180332acc: f7 da                       	neg	edx
180332ace: 48 63 c2                    	movsxd	rax, edx
180332ad1: 31 d2                       	xor	edx, edx
180332ad3: 41 2b 54 85 00              	sub	edx, dword ptr [r13 + 4*rax]
180332ad8: d3 ca                       	ror	edx, cl
180332ada: 81 f2 5a 48 0b c3           	xor	edx, 0xc30b485a
180332ae0: d3 ca                       	ror	edx, cl
180332ae2: f7 d2                       	not	edx
180332ae4: 0f ca                       	bswap	edx
180332ae6: 48 63 c2                    	movsxd	rax, edx
180332ae9: 48 89 f1                    	mov	rcx, rsi
180332aec: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332af0: 8b 05 9e d9 47 00           	mov	eax, dword ptr [rip + 0x47d99e] # 0x1807b0494
180332af6: e9 89 0a 00 00              	jmp	0x180333584 <.text+0x323584>
180332afb: 48 63 05 82 50 49 00        	movsxd	rax, dword ptr [rip + 0x495082] # 0x1807c7b84
180332b02: 49 63 04 86                 	movsxd	rax, dword ptr [r14 + 4*rax]
180332b06: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
180332b0b: 0f ca                       	bswap	edx
180332b0d: ff ca                       	dec	edx
180332b0f: 8d 48 0c                    	lea	ecx, [rax + 0xc]
180332b12: d3 ca                       	ror	edx, cl
180332b14: f7 d2                       	not	edx
180332b16: 0f ca                       	bswap	edx
180332b18: ff ca                       	dec	edx
180332b1a: 48 63 c2                    	movsxd	rax, edx
180332b1d: 48 8d 4d b8                 	lea	rcx, [rbp - 0x48]
180332b21: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332b25: 48 8d 50 28                 	lea	rdx, [rax + 0x28]
180332b29: 48 8d 4d 08                 	lea	rcx, [rbp + 0x8]
180332b2d: 4c 8d 45 28                 	lea	r8, [rbp + 0x28]
180332b31: e8 0a ed ff ff              	call	0x180331840 <.text+0x321840>
180332b36: 48 63 05 5b 50 49 00        	movsxd	rax, dword ptr [rip + 0x49505b] # 0x1807c7b98
180332b3d: 4c 8d 35 4c 64 32 00        	lea	r14, [rip + 0x32644c]   # 0x180658f90
180332b44: 49 63 04 86                 	movsxd	rax, dword ptr [r14 + 4*rax]
180332b48: 48 8d 3d 81 0f 49 00        	lea	rdi, [rip + 0x490f81]   # 0x1807c3ad0
180332b4f: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
180332b52: 0f ca                       	bswap	edx
180332b54: ff ca                       	dec	edx
180332b56: 8d 48 0c                    	lea	ecx, [rax + 0xc]
180332b59: d3 ca                       	ror	edx, cl
180332b5b: f7 d2                       	not	edx
180332b5d: 0f ca                       	bswap	edx
180332b5f: ff ca                       	dec	edx
180332b61: 48 63 c2                    	movsxd	rax, edx
180332b64: 48 8d 4d b8                 	lea	rcx, [rbp - 0x48]
180332b68: 4c 8d 25 01 b1 48 00        	lea	r12, [rip + 0x48b101]   # 0x1807bdc70
180332b6f: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332b73: b9 5b 3c 78 e9              	mov	ecx, 0xe9783c5b
180332b78: 33 0d f2 d8 47 00           	xor	ecx, dword ptr [rip + 0x47d8f2] # 0x1807b0470
180332b7e: 81 c1 93 2c 2d 66           	add	ecx, 0x662d2c93
180332b84: ba 17 13 df e2              	mov	edx, 0xe2df1317
180332b89: 33 15 f9 d8 47 00           	xor	edx, dword ptr [rip + 0x47d8f9] # 0x1807b0488
180332b8f: 81 c2 d7 11 d2 0f           	add	edx, 0xfd211d7
180332b95: 41 bd 2e de 97 e8           	mov	r13d, 0xe897de2e
180332b9b: 44 33 2d ea d8 47 00        	xor	r13d, dword ptr [rip + 0x47d8ea] # 0x1807b048c
180332ba2: 41 81 c5 d4 12 2a d4        	add	r13d, 0xd42a12d4
180332ba9: 39 08                       	cmp	dword ptr [rax], ecx
180332bab: 44 0f 44 ea                 	cmove	r13d, edx
180332baf: ba 8a eb fd 99              	mov	edx, 0x99fdeb8a
180332bb4: 33 15 92 d8 47 00           	xor	edx, dword ptr [rip + 0x47d892] # 0x1807b044c
180332bba: b8 13 2f 03 c1              	mov	eax, 0xc1032f13
180332bbf: 33 05 8b d8 47 00           	xor	eax, dword ptr [rip + 0x47d88b] # 0x1807b0450
180332bc5: 48 63 0d 58 4f 49 00        	movsxd	rcx, dword ptr [rip + 0x494f58] # 0x1807c7b24
180332bcc: 41 b8 49 97 13 cd           	mov	r8d, 0xcd139749
180332bd2: 45 33 04 8e                 	xor	r8d, dword ptr [r14 + 4*rcx]
180332bd6: 41 8d 48 01                 	lea	ecx, [r8 + 0x1]
180332bda: 48 63 c9                    	movsxd	rcx, ecx
180332bdd: 41 b9 7e 90 a8 d9           	mov	r9d, 0xd9a8907e
180332be3: 44 33 0c 8f                 	xor	r9d, dword ptr [rdi + 4*rcx]
180332be7: 81 c2 2a f1 cb 16           	add	edx, 0x16cbf12a
180332bed: 41 0f c9                    	bswap	r9d
180332bf0: b9 18 00 00 00              	mov	ecx, 0x18
180332bf5: 44 29 c1                    	sub	ecx, r8d
180332bf8: 41 d3 c1                    	rol	r9d, cl
180332bfb: 05 f7 61 2b 4f              	add	eax, 0x4f2b61f7
180332c00: 41 81 f1 d9 a8 90 7e        	xor	r9d, 0x7e90a8d9
180332c07: 41 ff c9                    	dec	r9d
180332c0a: 4d 63 d1                    	movsxd	r10, r9d
180332c0d: 89 44 24 20                 	mov	dword ptr [rsp + 0x20], eax
180332c11: 31 db                       	xor	ebx, ebx
180332c13: 31 c9                       	xor	ecx, ecx
180332c15: 45 31 c0                    	xor	r8d, r8d
180332c18: 45 31 c9                    	xor	r9d, r9d
180332c1b: 43 ff 14 d4                 	call	qword ptr [r12 + 8*r10]
180332c1f: 48 89 85 c0 00 00 00        	mov	qword ptr [rbp + 0xc0], rax
180332c26: 48 85 c0                    	test	rax, rax
180332c29: 0f 84 1f 07 00 00           	je	0x18033334e <.text+0x32334e>
180332c2f: 48 63 05 56 4f 49 00        	movsxd	rax, dword ptr [rip + 0x494f56] # 0x1807c7b8c
180332c36: 49 63 04 86                 	movsxd	rax, dword ptr [r14 + 4*rax]
180332c3a: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
180332c3d: 0f ca                       	bswap	edx
180332c3f: ff ca                       	dec	edx
180332c41: 8d 48 0c                    	lea	ecx, [rax + 0xc]
180332c44: d3 ca                       	ror	edx, cl
180332c46: f7 d2                       	not	edx
180332c48: 0f ca                       	bswap	edx
180332c4a: ff ca                       	dec	edx
180332c4c: 48 63 c2                    	movsxd	rax, edx
180332c4f: 48 8d 4d b8                 	lea	rcx, [rbp - 0x48]
180332c53: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332c57: b9 37 9c e5 8b              	mov	ecx, 0x8be59c37
180332c5c: 33 0d 16 d8 47 00           	xor	ecx, dword ptr [rip + 0x47d816] # 0x1807b0478
180332c62: 81 c1 93 88 2c 29           	add	ecx, 0x292c8893
180332c68: 39 08                       	cmp	dword ptr [rax], ecx
180332c6a: 0f 85 ae 00 00 00           	jne	0x180332d1e <.text+0x322d1e>
180332c70: b8 ea 19 65 f6              	mov	eax, 0xf66519ea
180332c75: 33 05 21 d8 47 00           	xor	eax, dword ptr [rip + 0x47d821] # 0x1807b049c
180332c7b: 05 2e 3b c0 70              	add	eax, 0x70c03b2e
180332c80: 89 45 70                    	mov	dword ptr [rbp + 0x70], eax
180332c83: 48 8b 85 c0 00 00 00        	mov	rax, qword ptr [rbp + 0xc0]
180332c8a: ba 5a dd 87 25              	mov	edx, 0x2587dd5a
180332c8f: 33 15 c7 d7 47 00           	xor	edx, dword ptr [rip + 0x47d7c7] # 0x1807b045c
180332c95: 41 b9 7e 6c c0 76           	mov	r9d, 0x76c06c7e
180332c9b: 44 33 0d be d7 47 00        	xor	r9d, dword ptr [rip + 0x47d7be] # 0x1807b0460
180332ca2: 48 63 0d 87 4e 49 00        	movsxd	rcx, dword ptr [rip + 0x494e87] # 0x1807c7b30
180332ca9: 45 8b 04 8e                 	mov	r8d, dword ptr [r14 + 4*rcx]
180332cad: 41 0f c8                    	bswap	r8d
180332cb0: 81 c1 e9 61 7f 2f           	add	ecx, 0x2f7f61e9
180332cb6: 41 d3 c8                    	ror	r8d, cl
180332cb9: 41 d3 c8                    	ror	r8d, cl
180332cbc: 44 89 c1                    	mov	ecx, r8d
180332cbf: f7 d1                       	not	ecx
180332cc1: 48 63 c9                    	movsxd	rcx, ecx
180332cc4: 44 8b 1c 8f                 	mov	r11d, dword ptr [rdi + 4*rcx]
180332cc8: 41 0f cb                    	bswap	r11d
180332ccb: 41 ba c1 40 e2 ce           	mov	r10d, 0xcee240c1
180332cd1: 45 29 c2                    	sub	r10d, r8d
180332cd4: 44 89 d1                    	mov	ecx, r10d
180332cd7: 41 d3 cb                    	ror	r11d, cl
180332cda: 41 81 c0 c3 40 e2 ce        	add	r8d, 0xcee240c3
180332ce1: 44 89 c1                    	mov	ecx, r8d
180332ce4: 41 d3 c3                    	rol	r11d, cl
180332ce7: 44 89 d1                    	mov	ecx, r10d
180332cea: 41 d3 cb                    	ror	r11d, cl
180332ced: 44 89 c1                    	mov	ecx, r8d
180332cf0: 41 d3 c3                    	rol	r11d, cl
180332cf3: 81 c2 8b 17 56 1b           	add	edx, 0x1b56178b
180332cf9: 41 81 c1 2f d3 d0 8c        	add	r9d, 0x8cd0d32f
180332d00: 41 81 f3 c2 40 e2 ce        	xor	r11d, 0xcee240c2
180332d07: 44 89 d1                    	mov	ecx, r10d
180332d0a: 41 d3 cb                    	ror	r11d, cl
180332d0d: 41 d3 cb                    	ror	r11d, cl
180332d10: 4d 63 d3                    	movsxd	r10, r11d
180332d13: 4c 8d 45 70                 	lea	r8, [rbp + 0x70]
180332d17: 48 89 c1                    	mov	rcx, rax
180332d1a: 43 ff 14 d4                 	call	qword ptr [r12 + 8*r10]
180332d1e: b8 9e f1 af e3              	mov	eax, 0xe3aff19e
180332d23: 33 05 7f d7 47 00           	xor	eax, dword ptr [rip + 0x47d77f] # 0x1807b04a8
180332d29: 05 9a f7 37 5a              	add	eax, 0x5a37f79a
180332d2e: 89 45 70                    	mov	dword ptr [rbp + 0x70], eax
180332d31: 48 63 05 2c 4e 49 00        	movsxd	rax, dword ptr [rip + 0x494e2c] # 0x1807c7b64
180332d38: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
180332d3c: 8d 48 16                    	lea	ecx, [rax + 0x16]
180332d3f: d3 ca                       	ror	edx, cl
180332d41: b9 16 00 00 00              	mov	ecx, 0x16
180332d46: 29 c1                       	sub	ecx, eax
180332d48: d3 c2                       	rol	edx, cl
180332d4a: 48 63 c2                    	movsxd	rax, edx
180332d4d: 41 b8 c6 fa 8f 90           	mov	r8d, 0x908ffac6
180332d53: 44 33 04 87                 	xor	r8d, dword ptr [rdi + 4*rax]
180332d57: 41 0f c8                    	bswap	r8d
180332d5a: ba 90 8f fa c6              	mov	edx, 0xc6fa8f90
180332d5f: 29 c2                       	sub	edx, eax
180332d61: 89 d1                       	mov	ecx, edx
180332d63: 41 d3 c0                    	rol	r8d, cl
180332d66: 41 b9 fe ff ff ff           	mov	r9d, 0xfffffffe
180332d6c: 45 29 c1                    	sub	r9d, r8d
180332d6f: 83 f0 10                    	xor	eax, 0x10
180332d72: 89 c1                       	mov	ecx, eax
180332d74: 41 d3 c9                    	ror	r9d, cl
180332d77: 89 d1                       	mov	ecx, edx
180332d79: 41 d3 c1                    	rol	r9d, cl
180332d7c: 49 63 c1                    	movsxd	rax, r9d
180332d7f: 48 8d 4d 70                 	lea	rcx, [rbp + 0x70]
180332d83: 48 8d 95 50 01 00 00        	lea	rdx, [rbp + 0x150]
180332d8a: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332d8e: ba fe 25 21 4e              	mov	edx, 0x4e2125fe
180332d93: 33 15 d3 d6 47 00           	xor	edx, dword ptr [rip + 0x47d6d3] # 0x1807b046c
180332d99: 81 c2 79 25 7d 96           	add	edx, 0x967d2579
180332d9f: 0f af 10                    	imul	edx, dword ptr [rax]
180332da2: 48 8b 85 c0 00 00 00        	mov	rax, qword ptr [rbp + 0xc0]
180332da9: 48 63 0d 78 4d 49 00        	movsxd	rcx, dword ptr [rip + 0x494d78] # 0x1807c7b28
180332db0: 49 63 0c 8e                 	movsxd	rcx, dword ptr [r14 + 4*rcx]
180332db4: 49 89 c8                    	mov	r8, rcx
180332db7: 49 81 f0 43 f3 f3 38        	xor	r8, 0x38f3f343
180332dbe: 45 31 c9                    	xor	r9d, r9d
180332dc1: 46 2b 0c 87                 	sub	r9d, dword ptr [rdi + 4*r8]
180332dc5: 83 f1 13                    	xor	ecx, 0x13
180332dc8: 41 d3 c9                    	ror	r9d, cl
180332dcb: 41 0f c9                    	bswap	r9d
180332dce: b9 10 00 00 00              	mov	ecx, 0x10
180332dd3: 44 29 c1                    	sub	ecx, r8d
180332dd6: 41 d3 c1                    	rol	r9d, cl
180332dd9: 31 db                       	xor	ebx, ebx
180332ddb: 41 81 f1 ef cd fe ad        	xor	r9d, 0xadfecdef
180332de2: 41 ff c1                    	inc	r9d
180332de5: 4d 63 d1                    	movsxd	r10, r9d
180332de8: 89 54 24 20                 	mov	dword ptr [rsp + 0x20], edx
180332dec: 48 89 c1                    	mov	rcx, rax
180332def: 41 89 d0                    	mov	r8d, edx
180332df2: 41 89 d1                    	mov	r9d, edx
180332df5: 43 ff 14 d4                 	call	qword ptr [r12 + 8*r10]
180332df9: 48 63 05 e4 4d 49 00        	movsxd	rax, dword ptr [rip + 0x494de4] # 0x1807c7be4
180332e00: 49 63 04 86                 	movsxd	rax, dword ptr [r14 + 4*rax]
180332e04: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
180332e07: 0f ca                       	bswap	edx
180332e09: ff ca                       	dec	edx
180332e0b: 8d 48 0c                    	lea	ecx, [rax + 0xc]
180332e0e: d3 ca                       	ror	edx, cl
180332e10: f7 d2                       	not	edx
180332e12: 0f ca                       	bswap	edx
180332e14: ff ca                       	dec	edx
180332e16: 48 63 c2                    	movsxd	rax, edx
180332e19: 4c 89 f9                    	mov	rcx, r15
180332e1c: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332e20: 0f b7 40 04                 	movzx	eax, word ptr [rax + 0x4]
180332e24: 66 89 85 b0 00 00 00        	mov	word ptr [rbp + 0xb0], ax
180332e2b: 48 63 05 96 4d 49 00        	movsxd	rax, dword ptr [rip + 0x494d96] # 0x1807c7bc8
180332e32: 49 63 04 86                 	movsxd	rax, dword ptr [r14 + 4*rax]
180332e36: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
180332e39: 0f ca                       	bswap	edx
180332e3b: ff ca                       	dec	edx
180332e3d: 8d 48 0c                    	lea	ecx, [rax + 0xc]
180332e40: d3 ca                       	ror	edx, cl
180332e42: f7 d2                       	not	edx
180332e44: 0f ca                       	bswap	edx
180332e46: ff ca                       	dec	edx
180332e48: 48 63 c2                    	movsxd	rax, edx
180332e4b: 4c 89 f9                    	mov	rcx, r15
180332e4e: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332e52: 48 83 c0 08                 	add	rax, 0x8
180332e56: 48 63 15 3f 4d 49 00        	movsxd	rdx, dword ptr [rip + 0x494d3f] # 0x1807c7b9c
180332e5d: 45 8b 04 96                 	mov	r8d, dword ptr [r14 + 4*rdx]
180332e61: 41 f7 d0                    	not	r8d
180332e64: 41 0f c8                    	bswap	r8d
180332e67: 41 f7 d8                    	neg	r8d
180332e6a: b9 1e 00 00 00              	mov	ecx, 0x1e
180332e6f: 29 d1                       	sub	ecx, edx
180332e71: 41 d3 c0                    	rol	r8d, cl
180332e74: 49 63 d0                    	movsxd	rdx, r8d
180332e77: 44 8b 04 97                 	mov	r8d, dword ptr [rdi + 4*rdx]
180332e7b: 41 f7 d0                    	not	r8d
180332e7e: b9 cf 66 5b 32              	mov	ecx, 0x325b66cf
180332e83: 29 d1                       	sub	ecx, edx
180332e85: 41 d3 c0                    	rol	r8d, cl
180332e88: 41 d3 c0                    	rol	r8d, cl
180332e8b: 4c 89 e6                    	mov	rsi, r12
180332e8e: 41 bc 1e 00 00 00           	mov	r12d, 0x1e
180332e94: 41 bf cf 66 5b 32           	mov	r15d, 0x325b66cf
180332e9a: 41 f7 d8                    	neg	r8d
180332e9d: 49 63 d0                    	movsxd	rdx, r8d
180332ea0: 48 89 c1                    	mov	rcx, rax
180332ea3: ff 14 d6                    	call	qword ptr [rsi + 8*rdx]
180332ea6: 48 8b 95 c0 00 00 00        	mov	rdx, qword ptr [rbp + 0xc0]
180332ead: 41 b9 a3 eb 23 25           	mov	r9d, 0x2523eba3
180332eb3: 44 33 0d 9e d5 47 00        	xor	r9d, dword ptr [rip + 0x47d59e] # 0x1807b0458
180332eba: 4c 63 05 df db 55 00        	movsxd	r8, dword ptr [rip + 0x55dbdf] # 0x180890aa0
180332ec1: 47 8b 14 86                 	mov	r10d, dword ptr [r14 + 4*r8]
180332ec5: b9 17 00 00 00              	mov	ecx, 0x17
180332eca: 44 29 c1                    	sub	ecx, r8d
180332ecd: 41 d3 c2                    	rol	r10d, cl
180332ed0: 41 81 f2 0a 2a bc 17        	xor	r10d, 0x17bc2a0a
180332ed7: 41 0f ca                    	bswap	r10d
180332eda: 41 8d 48 17                 	lea	ecx, [r8 + 0x17]
180332ede: 41 d3 ca                    	ror	r10d, cl
180332ee1: 4d 63 c2                    	movsxd	r8, r10d
180332ee4: 46 8b 1c 87                 	mov	r11d, dword ptr [rdi + 4*r8]
180332ee8: 41 ba c2 cc db cb           	mov	r10d, 0xcbdbccc2
180332eee: 45 29 c2                    	sub	r10d, r8d
180332ef1: 44 89 d1                    	mov	ecx, r10d
180332ef4: 41 d3 c3                    	rol	r11d, cl
180332ef7: 41 83 c0 02                 	add	r8d, 0x2
180332efb: 44 89 c1                    	mov	ecx, r8d
180332efe: 41 d3 cb                    	ror	r11d, cl
180332f01: 41 ff cb                    	dec	r11d
180332f04: 41 0f cb                    	bswap	r11d
180332f07: 44 89 d1                    	mov	ecx, r10d
180332f0a: 41 d3 c3                    	rol	r11d, cl
180332f0d: 41 81 c1 2d 29 98 55        	add	r9d, 0x5598292d
180332f14: 41 81 f3 3d 33 24 34        	xor	r11d, 0x3424333d
180332f1b: 4d 63 d3                    	movsxd	r10, r11d
180332f1e: 48 89 d1                    	mov	rcx, rdx
180332f21: 48 89 c2                    	mov	rdx, rax
180332f24: 44 0f b7 85 b0 00 00 00     	movzx	r8d, word ptr [rbp + 0xb0]
180332f2c: 42 ff 14 d6                 	call	qword ptr [rsi + 8*r10]
180332f30: 48 89 85 a0 00 00 00        	mov	qword ptr [rbp + 0xa0], rax
180332f37: 48 85 c0                    	test	rax, rax
180332f3a: 0f 84 5e 04 00 00           	je	0x18033339e <.text+0x32339e>
180332f40: 48 63 05 65 4c 49 00        	movsxd	rax, dword ptr [rip + 0x494c65] # 0x1807c7bac
180332f47: 48 8d 3d 42 60 32 00        	lea	rdi, [rip + 0x326042]   # 0x180658f90
180332f4e: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
180332f51: f7 d2                       	not	edx
180332f53: 0f ca                       	bswap	edx
180332f55: f7 da                       	neg	edx
180332f57: 41 29 c4                    	sub	r12d, eax
180332f5a: 44 89 e1                    	mov	ecx, r12d
180332f5d: d3 c2                       	rol	edx, cl
180332f5f: 48 63 c2                    	movsxd	rax, edx
180332f62: 4c 8d 05 67 0b 49 00        	lea	r8, [rip + 0x490b67]    # 0x1807c3ad0
180332f69: 41 8b 14 80                 	mov	edx, dword ptr [r8 + 4*rax]
180332f6d: f7 d2                       	not	edx
180332f6f: 41 29 c7                    	sub	r15d, eax
180332f72: 44 89 f9                    	mov	ecx, r15d
180332f75: d3 c2                       	rol	edx, cl
180332f77: 4d 89 c7                    	mov	r15, r8
180332f7a: d3 c2                       	rol	edx, cl
180332f7c: f7 da                       	neg	edx
180332f7e: 48 63 c2                    	movsxd	rax, edx
180332f81: 48 8d 4d 08                 	lea	rcx, [rbp + 0x8]
180332f85: 4c 8d 25 e4 ac 48 00        	lea	r12, [rip + 0x48ace4]   # 0x1807bdc70
180332f8c: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332f90: 48 63 15 95 4b 49 00        	movsxd	rdx, dword ptr [rip + 0x494b95] # 0x1807c7b2c
180332f97: 44 8b 04 97                 	mov	r8d, dword ptr [rdi + 4*rdx]
180332f9b: b9 0d 00 00 00              	mov	ecx, 0xd
180332fa0: 29 d1                       	sub	ecx, edx
180332fa2: 41 d3 c0                    	rol	r8d, cl
180332fa5: 41 0f c8                    	bswap	r8d
180332fa8: 4d 63 c0                    	movsxd	r8, r8d
180332fab: 41 b9 2f d6 23 45           	mov	r9d, 0x4523d62f
180332fb1: 47 33 0c 87                 	xor	r9d, dword ptr [r15 + 4*r8]
180332fb5: 41 8d 90 2f d6 23 45        	lea	edx, [r8 + 0x4523d62f]
180332fbc: 89 d1                       	mov	ecx, edx
180332fbe: 41 d3 c9                    	ror	r9d, cl
180332fc1: 48 89 c3                    	mov	rbx, rax
180332fc4: b9 0f 00 00 00              	mov	ecx, 0xf
180332fc9: 44 29 c1                    	sub	ecx, r8d
180332fcc: 41 d3 c1                    	rol	r9d, cl
180332fcf: 89 d1                       	mov	ecx, edx
180332fd1: 41 d3 c9                    	ror	r9d, cl
180332fd4: 41 f7 d9                    	neg	r9d
180332fd7: 41 81 f1 d0 29 dc ba        	xor	r9d, 0xbadc29d0
180332fde: 41 0f c9                    	bswap	r9d
180332fe1: 49 63 c1                    	movsxd	rax, r9d
180332fe4: 4c 8d 75 70                 	lea	r14, [rbp + 0x70]
180332fe8: 4c 89 f1                    	mov	rcx, r14
180332feb: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180332fef: 48 63 0d ca 4b 49 00        	movsxd	rcx, dword ptr [rip + 0x494bca] # 0x1807c7bc0
180332ff6: b8 40 3a e7 b6              	mov	eax, 0xb6e73a40
180332ffb: 33 04 8f                    	xor	eax, dword ptr [rdi + 4*rcx]
180332ffe: d3 c8                       	ror	eax, cl
180333000: d3 c8                       	ror	eax, cl
180333002: 89 c1                       	mov	ecx, eax
180333004: 81 f1 40 3a e7 b6           	xor	ecx, 0xb6e73a40
18033300a: 48 63 d1                    	movsxd	rdx, ecx
18033300d: 45 8b 04 97                 	mov	r8d, dword ptr [r15 + 4*rdx]
180333011: 41 f7 d0                    	not	r8d
180333014: 83 c0 09                    	add	eax, 0x9
180333017: 89 c1                       	mov	ecx, eax
180333019: 41 d3 c8                    	ror	r8d, cl
18033301c: 41 81 f0 f6 4c 11 ef        	xor	r8d, 0xef114cf6
180333023: b9 09 b3 ee 10              	mov	ecx, 0x10eeb309
180333028: 29 d1                       	sub	ecx, edx
18033302a: 41 d3 c0                    	rol	r8d, cl
18033302d: 41 d3 c0                    	rol	r8d, cl
180333030: 41 f7 d8                    	neg	r8d
180333033: 41 0f c8                    	bswap	r8d
180333036: 49 63 c0                    	movsxd	rax, r8d
180333039: 4c 89 f1                    	mov	rcx, r14
18033303c: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333040: 48 8b 95 a0 00 00 00        	mov	rdx, qword ptr [rbp + 0xa0]
180333047: 48 63 0d ce 4a 49 00        	movsxd	rcx, dword ptr [rip + 0x494ace] # 0x1807c7b1c
18033304e: 44 8b 04 8f                 	mov	r8d, dword ptr [rdi + 4*rcx]
180333052: 41 8d 48 ff                 	lea	ecx, [r8 - 0x1]
180333056: 48 63 c9                    	movsxd	rcx, ecx
180333059: 41 b9 8b 02 d1 82           	mov	r9d, 0x82d1028b
18033305f: 45 33 0c 8f                 	xor	r9d, dword ptr [r15 + 4*rcx]
180333063: 41 8d 48 0a                 	lea	ecx, [r8 + 0xa]
180333067: 41 d3 c9                    	ror	r9d, cl
18033306a: 41 0f c9                    	bswap	r9d
18033306d: 41 f7 d9                    	neg	r9d
180333070: b9 0c 00 00 00              	mov	ecx, 0xc
180333075: 44 29 c1                    	sub	ecx, r8d
180333078: 41 d3 c1                    	rol	r9d, cl
18033307b: 41 81 f1 74 fd 2e 7d        	xor	r9d, 0x7d2efd74
180333082: 41 0f c9                    	bswap	r9d
180333085: 4d 63 d1                    	movsxd	r10, r9d
180333088: 44 89 6c 24 30              	mov	dword ptr [rsp + 0x30], r13d
18033308d: 0f 57 c0                    	xorps	xmm0, xmm0
180333090: 0f 11 44 24 20              	movups	xmmword ptr [rsp + 0x20], xmm0
180333095: 45 31 f6                    	xor	r14d, r14d
180333098: 48 89 d1                    	mov	rcx, rdx
18033309b: 48 89 c2                    	mov	rdx, rax
18033309e: 49 89 d8                    	mov	r8, rbx
1803330a1: 45 31 c9                    	xor	r9d, r9d
1803330a4: 43 ff 14 d4                 	call	qword ptr [r12 + 8*r10]
1803330a8: 48 89 85 d0 00 00 00        	mov	qword ptr [rbp + 0xd0], rax
1803330af: 48 85 c0                    	test	rax, rax
1803330b2: 48 8b b5 d8 00 00 00        	mov	rsi, qword ptr [rbp + 0xd8]
1803330b9: 0f 84 4a 03 00 00           	je	0x180333409 <.text+0x323409>
1803330bf: 48 63 05 de 4a 49 00        	movsxd	rax, dword ptr [rip + 0x494ade] # 0x1807c7ba4
1803330c6: bb 26 5e 4a 39              	mov	ebx, 0x394a5e26
1803330cb: 4c 8d 2d be 5e 32 00        	lea	r13, [rip + 0x325ebe]   # 0x180658f90
1803330d2: 41 8b 44 85 00              	mov	eax, dword ptr [r13 + 4*rax]
1803330d7: 31 d8                       	xor	eax, ebx
1803330d9: 0f c8                       	bswap	eax
1803330db: 48 63 c8                    	movsxd	rcx, eax
1803330de: 41 8b 04 8f                 	mov	eax, dword ptr [r15 + 4*rcx]
1803330e2: 81 c1 5a 89 ec ac           	add	ecx, 0xacec895a
1803330e8: d3 c8                       	ror	eax, cl
1803330ea: ff c0                       	inc	eax
1803330ec: d3 c8                       	ror	eax, cl
1803330ee: 35 ac ec 89 5a              	xor	eax, 0x5a89ecac
1803330f3: 0f c8                       	bswap	eax
1803330f5: 48 98                       	cdqe
1803330f7: 4c 89 ff                    	mov	rdi, r15
1803330fa: 4c 8b bd a8 00 00 00        	mov	r15, qword ptr [rbp + 0xa8]
180333101: 4c 89 f9                    	mov	rcx, r15
180333104: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333108: 48 63 0d 99 4a 49 00        	movsxd	rcx, dword ptr [rip + 0x494a99] # 0x1807c7ba8
18033310f: 41 33 5c 8d 00              	xor	ebx, dword ptr [r13 + 4*rcx]
180333114: 0f cb                       	bswap	ebx
180333116: 48 63 cb                    	movsxd	rcx, ebx
180333119: 8b 14 8f                    	mov	edx, dword ptr [rdi + 4*rcx]
18033311c: 81 c1 5a 89 ec ac           	add	ecx, 0xacec895a
180333122: d3 ca                       	ror	edx, cl
180333124: ff c2                       	inc	edx
180333126: d3 ca                       	ror	edx, cl
180333128: 48 89 85 b0 00 00 00        	mov	qword ptr [rbp + 0xb0], rax
18033312f: 81 f2 ac ec 89 5a           	xor	edx, 0x5a89ecac
180333135: 0f ca                       	bswap	edx
180333137: 48 63 c2                    	movsxd	rax, edx
18033313a: 4c 89 f9                    	mov	rcx, r15
18033313d: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333141: 4c 63 05 70 4a 49 00        	movsxd	r8, dword ptr [rip + 0x494a70] # 0x1807c7bb8
180333148: 43 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*r8]
18033314d: b9 51 24 14 04              	mov	ecx, 0x4142451
180333152: 44 29 c1                    	sub	ecx, r8d
180333155: d3 c2                       	rol	edx, cl
180333157: d3 c2                       	rol	edx, cl
180333159: 41 8d 48 11                 	lea	ecx, [r8 + 0x11]
18033315d: d3 ca                       	ror	edx, cl
18033315f: 89 d1                       	mov	ecx, edx
180333161: f7 d9                       	neg	ecx
180333163: 48 63 c9                    	movsxd	rcx, ecx
180333166: 44 8b 04 8f                 	mov	r8d, dword ptr [rdi + 4*rcx]
18033316a: 41 0f c8                    	bswap	r8d
18033316d: 81 c2 d2 e8 d9 50           	add	edx, 0x50d9e8d2
180333173: 89 d1                       	mov	ecx, edx
180333175: 41 d3 c0                    	rol	r8d, cl
180333178: 41 f7 d0                    	not	r8d
18033317b: 41 d3 c0                    	rol	r8d, cl
18033317e: 48 89 45 68                 	mov	qword ptr [rbp + 0x68], rax
180333182: 41 f7 d0                    	not	r8d
180333185: 41 d3 c0                    	rol	r8d, cl
180333188: 49 63 c0                    	movsxd	rax, r8d
18033318b: 4c 89 f9                    	mov	rcx, r15
18033318e: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333192: 48 8b 8d d0 00 00 00        	mov	rcx, qword ptr [rbp + 0xd0]
180333199: 48 89 8d a8 00 00 00        	mov	qword ptr [rbp + 0xa8], rcx
1803331a0: 49 89 ff                    	mov	r15, rdi
1803331a3: bf a2 8e 3d 8d              	mov	edi, 0x8d3d8ea2
1803331a8: 33 3d 8a d2 47 00           	xor	edi, dword ptr [rip + 0x47d28a] # 0x1807b0438
1803331ae: 49 89 c4                    	mov	r12, rax
1803331b1: 48 b8 12 09 49 68 9f bc e5 9d       	movabs	rax, -0x621a436097b6f6ee
1803331bb: 48 33 05 7e d2 47 00        	xor	rax, qword ptr [rip + 0x47d27e] # 0x1807b0440
1803331c2: 81 c7 4f 7e 06 85           	add	edi, 0x85067e4f
1803331c8: 48 bb e5 25 03 be 57 e9 7e 20       	movabs	rbx, 0x207ee957be0325e5
1803331d2: 48 01 c3                    	add	rbx, rax
1803331d5: 48 63 05 38 49 49 00        	movsxd	rax, dword ptr [rip + 0x494938] # 0x1807c7b14
1803331dc: 41 8b 44 85 00              	mov	eax, dword ptr [r13 + 4*rax]
1803331e1: ff c8                       	dec	eax
1803331e3: 48 98                       	cdqe
1803331e5: 41 8b 04 87                 	mov	eax, dword ptr [r15 + 4*rax]
1803331e9: 0f c8                       	bswap	eax
1803331eb: f7 d8                       	neg	eax
1803331ed: 35 4f 92 23 f9              	xor	eax, 0xf923924f
1803331f2: 48 98                       	cdqe
1803331f4: 4c 8d 35 55 cb 55 00        	lea	r14, [rip + 0x55cb55]   # 0x18088fd50
1803331fb: 48 8d 15 2d 79 48 00        	lea	rdx, [rip + 0x48792d]   # 0x1807bab2f
180333202: 4c 89 f1                    	mov	rcx, r14
180333205: 4c 8d 05 64 aa 48 00        	lea	r8, [rip + 0x48aa64]    # 0x1807bdc70
18033320c: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
180333210: 48 63 05 01 49 49 00        	movsxd	rax, dword ptr [rip + 0x494901] # 0x1807c7b18
180333217: b9 7d 45 a5 c0              	mov	ecx, 0xc0a5457d
18033321c: 41 33 4c 85 00              	xor	ecx, dword ptr [r13 + 4*rax]
180333221: 0f c9                       	bswap	ecx
180333223: 48 63 c1                    	movsxd	rax, ecx
180333226: ba e3 80 da 0f              	mov	edx, 0xfda80e3
18033322b: 41 33 14 87                 	xor	edx, dword ptr [r15 + 4*rax]
18033322f: 83 c2 fe                    	add	edx, -0x2
180333232: b9 03 00 00 00              	mov	ecx, 0x3
180333237: 29 c1                       	sub	ecx, eax
180333239: d3 c2                       	rol	edx, cl
18033323b: 48 63 c2                    	movsxd	rax, edx
18033323e: 48 89 5c 24 30              	mov	qword ptr [rsp + 0x30], rbx
180333243: 48 8b 8d b0 00 00 00        	mov	rcx, qword ptr [rbp + 0xb0]
18033324a: 89 4c 24 28                 	mov	dword ptr [rsp + 0x28], ecx
18033324e: 48 8b 4d 68                 	mov	rcx, qword ptr [rbp + 0x68]
180333252: 89 4c 24 20                 	mov	dword ptr [rsp + 0x20], ecx
180333256: 48 8b 8d a8 00 00 00        	mov	rcx, qword ptr [rbp + 0xa8]
18033325d: 4c 89 f2                    	mov	rdx, r14
180333260: 41 89 f8                    	mov	r8d, edi
180333263: 4d 89 e1                    	mov	r9, r12
180333266: 4c 8d 25 03 aa 48 00        	lea	r12, [rip + 0x48aa03]   # 0x1807bdc70
18033326d: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333271: b9 3c ce 34 90              	mov	ecx, 0x9034ce3c
180333276: 33 0d e8 d1 47 00           	xor	ecx, dword ptr [rip + 0x47d1e8] # 0x1807b0464
18033327c: 81 c1 26 3d dd 05           	add	ecx, 0x5dd3d26
180333282: 39 c8                       	cmp	eax, ecx
180333284: 4d 89 fd                    	mov	r13, r15
180333287: 4c 8d 35 02 5d 32 00        	lea	r14, [rip + 0x325d02]   # 0x180658f90
18033328e: 74 6d                       	je	0x1803332fd <.text+0x3232fd>
180333290: 48 8b 85 d0 00 00 00        	mov	rax, qword ptr [rbp + 0xd0]
180333297: 48 63 0d be 48 49 00        	movsxd	rcx, dword ptr [rip + 0x4948be] # 0x1807c7b5c
18033329e: 4d 63 04 8e                 	movsxd	r8, dword ptr [r14 + 4*rcx]
1803332a2: 49 81 f0 b9 19 10 88        	xor	r8, -0x77efe647
1803332a9: 47 8b 4c 85 00              	mov	r9d, dword ptr [r13 + 4*r8]
1803332ae: 41 0f c9                    	bswap	r9d
1803332b1: ba 3a 66 13 37              	mov	edx, 0x3713663a
1803332b6: 44 29 c2                    	sub	edx, r8d
1803332b9: 89 d1                       	mov	ecx, edx
1803332bb: 41 d3 c1                    	rol	r9d, cl
1803332be: 41 f7 d1                    	not	r9d
1803332c1: 41 8d 48 1a                 	lea	ecx, [r8 + 0x1a]
1803332c5: 41 d3 c9                    	ror	r9d, cl
1803332c8: 89 d1                       	mov	ecx, edx
1803332ca: 41 d3 c1                    	rol	r9d, cl
1803332cd: 41 f7 d1                    	not	r9d
1803332d0: 41 0f c9                    	bswap	r9d
1803332d3: 41 f7 d9                    	neg	r9d
1803332d6: 4d 63 c1                    	movsxd	r8, r9d
1803332d9: 31 ff                       	xor	edi, edi
1803332db: 48 89 c1                    	mov	rcx, rax
1803332de: 31 d2                       	xor	edx, edx
1803332e0: 43 ff 14 c4                 	call	qword ptr [r12 + 8*r8]
1803332e4: b9 79 9d c6 04              	mov	ecx, 0x4c69d79
1803332e9: 33 0d 85 d1 47 00           	xor	ecx, dword ptr [rip + 0x47d185] # 0x1807b0474
1803332ef: 81 c1 40 e8 4c 52           	add	ecx, 0x524ce840
1803332f5: 39 c8                       	cmp	eax, ecx
1803332f7: 0f 85 3b 03 00 00           	jne	0x180333638 <.text+0x323638>
1803332fd: 48 63 05 48 48 49 00        	movsxd	rax, dword ptr [rip + 0x494848] # 0x1807c7b4c
180333304: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
180333308: f7 d2                       	not	edx
18033330a: b9 16 00 00 00              	mov	ecx, 0x16
18033330f: 29 c1                       	sub	ecx, eax
180333311: d3 c2                       	rol	edx, cl
180333313: 8d 48 16                    	lea	ecx, [rax + 0x16]
180333316: d3 ca                       	ror	edx, cl
180333318: b9 5a 48 0b c3              	mov	ecx, 0xc30b485a
18033331d: 29 d1                       	sub	ecx, edx
18033331f: f7 da                       	neg	edx
180333321: 48 63 c2                    	movsxd	rax, edx
180333324: 31 d2                       	xor	edx, edx
180333326: 41 2b 54 85 00              	sub	edx, dword ptr [r13 + 4*rax]
18033332b: d3 ca                       	ror	edx, cl
18033332d: 81 f2 5a 48 0b c3           	xor	edx, 0xc30b485a
180333333: d3 ca                       	ror	edx, cl
180333335: f7 d2                       	not	edx
180333337: 0f ca                       	bswap	edx
180333339: 48 63 c2                    	movsxd	rax, edx
18033333c: 48 89 f1                    	mov	rcx, rsi
18033333f: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333343: 8b 05 67 d1 47 00           	mov	eax, dword ptr [rip + 0x47d167] # 0x1807b04b0
180333349: e9 15 01 00 00              	jmp	0x180333463 <.text+0x323463>
18033334e: 48 63 05 0b 48 49 00        	movsxd	rax, dword ptr [rip + 0x49480b] # 0x1807c7b60
180333355: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
180333359: f7 d2                       	not	edx
18033335b: b9 16 00 00 00              	mov	ecx, 0x16
180333360: 29 c1                       	sub	ecx, eax
180333362: d3 c2                       	rol	edx, cl
180333364: 8d 48 16                    	lea	ecx, [rax + 0x16]
180333367: d3 ca                       	ror	edx, cl
180333369: b9 5a 48 0b c3              	mov	ecx, 0xc30b485a
18033336e: 29 d1                       	sub	ecx, edx
180333370: f7 da                       	neg	edx
180333372: 48 63 c2                    	movsxd	rax, edx
180333375: 2b 1c 87                    	sub	ebx, dword ptr [rdi + 4*rax]
180333378: d3 cb                       	ror	ebx, cl
18033337a: 81 f3 5a 48 0b c3           	xor	ebx, 0xc30b485a
180333380: d3 cb                       	ror	ebx, cl
180333382: f7 d3                       	not	ebx
180333384: 0f cb                       	bswap	ebx
180333386: 48 63 c3                    	movsxd	rax, ebx
180333389: 48 89 f1                    	mov	rcx, rsi
18033338c: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333390: 8b 05 02 d1 47 00           	mov	eax, dword ptr [rip + 0x47d102] # 0x1807b0498
180333396: 49 89 fd                    	mov	r13, rdi
180333399: e9 5d 01 00 00              	jmp	0x1803334fb <.text+0x3234fb>
18033339e: 48 63 05 9b 47 49 00        	movsxd	rax, dword ptr [rip + 0x49479b] # 0x1807c7b40
1803333a5: 4c 8d 35 e4 5b 32 00        	lea	r14, [rip + 0x325be4]   # 0x180658f90
1803333ac: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803333b0: f7 d2                       	not	edx
1803333b2: b9 16 00 00 00              	mov	ecx, 0x16
1803333b7: 29 c1                       	sub	ecx, eax
1803333b9: d3 c2                       	rol	edx, cl
1803333bb: 8d 48 16                    	lea	ecx, [rax + 0x16]
1803333be: d3 ca                       	ror	edx, cl
1803333c0: b9 5a 48 0b c3              	mov	ecx, 0xc30b485a
1803333c5: 29 d1                       	sub	ecx, edx
1803333c7: f7 da                       	neg	edx
1803333c9: 48 63 c2                    	movsxd	rax, edx
1803333cc: 4c 8d 2d fd 06 49 00        	lea	r13, [rip + 0x4906fd]   # 0x1807c3ad0
1803333d3: 41 2b 5c 85 00              	sub	ebx, dword ptr [r13 + 4*rax]
1803333d8: d3 cb                       	ror	ebx, cl
1803333da: 81 f3 5a 48 0b c3           	xor	ebx, 0xc30b485a
1803333e0: d3 cb                       	ror	ebx, cl
1803333e2: f7 d3                       	not	ebx
1803333e4: 0f cb                       	bswap	ebx
1803333e6: 48 63 c3                    	movsxd	rax, ebx
1803333e9: 48 8b b5 d8 00 00 00        	mov	rsi, qword ptr [rbp + 0xd8]
1803333f0: 48 89 f1                    	mov	rcx, rsi
1803333f3: 4c 8d 25 76 a8 48 00        	lea	r12, [rip + 0x48a876]   # 0x1807bdc70
1803333fa: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803333fe: 8b 05 9c d0 47 00           	mov	eax, dword ptr [rip + 0x47d09c] # 0x1807b04a0
180333404: e9 a6 00 00 00              	jmp	0x1803334af <.text+0x3234af>
180333409: 48 63 05 48 47 49 00        	movsxd	rax, dword ptr [rip + 0x494748] # 0x1807c7b58
180333410: 48 8d 3d 79 5b 32 00        	lea	rdi, [rip + 0x325b79]   # 0x180658f90
180333417: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
18033341a: f7 d2                       	not	edx
18033341c: b9 16 00 00 00              	mov	ecx, 0x16
180333421: 29 c1                       	sub	ecx, eax
180333423: d3 c2                       	rol	edx, cl
180333425: 8d 48 16                    	lea	ecx, [rax + 0x16]
180333428: d3 ca                       	ror	edx, cl
18033342a: b9 5a 48 0b c3              	mov	ecx, 0xc30b485a
18033342f: 29 d1                       	sub	ecx, edx
180333431: f7 da                       	neg	edx
180333433: 48 63 c2                    	movsxd	rax, edx
180333436: 45 2b 34 87                 	sub	r14d, dword ptr [r15 + 4*rax]
18033343a: 41 d3 ce                    	ror	r14d, cl
18033343d: 41 81 f6 5a 48 0b c3        	xor	r14d, 0xc30b485a
180333444: 41 d3 ce                    	ror	r14d, cl
180333447: 41 f7 d6                    	not	r14d
18033344a: 41 0f ce                    	bswap	r14d
18033344d: 49 63 c6                    	movsxd	rax, r14d
180333450: 48 89 f1                    	mov	rcx, rsi
180333453: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333457: 8b 05 4f d0 47 00           	mov	eax, dword ptr [rip + 0x47d04f] # 0x1807b04ac
18033345d: 4d 89 fd                    	mov	r13, r15
180333460: 49 89 fe                    	mov	r14, rdi
180333463: 48 63 0d 6e 47 49 00        	movsxd	rcx, dword ptr [rip + 0x49476e] # 0x1807c7bd8
18033346a: b8 61 41 7c f0              	mov	eax, 0xf07c4161
18033346f: 41 33 04 8e                 	xor	eax, dword ptr [r14 + 4*rcx]
180333473: ff c1                       	inc	ecx
180333475: d3 c8                       	ror	eax, cl
180333477: 8d 48 ff                    	lea	ecx, [rax - 0x1]
18033347a: 48 63 c9                    	movsxd	rcx, ecx
18033347d: 41 8b 54 8d 00              	mov	edx, dword ptr [r13 + 4*rcx]
180333482: 8d 88 d2 56 27 06           	lea	ecx, [rax + 0x62756d2]
180333488: d3 ca                       	ror	edx, cl
18033348a: d3 ca                       	ror	edx, cl
18033348c: 81 f2 2c a9 d8 f9           	xor	edx, 0xf9d8a92c
180333492: 0f ca                       	bswap	edx
180333494: d3 ca                       	ror	edx, cl
180333496: b9 14 00 00 00              	mov	ecx, 0x14
18033349b: 29 c1                       	sub	ecx, eax
18033349d: d3 c2                       	rol	edx, cl
18033349f: 0f ca                       	bswap	edx
1803334a1: 48 63 c2                    	movsxd	rax, edx
1803334a4: 48 8d 8d d0 00 00 00        	lea	rcx, [rbp + 0xd0]
1803334ab: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803334af: 48 63 0d 26 47 49 00        	movsxd	rcx, dword ptr [rip + 0x494726] # 0x1807c7bdc
1803334b6: b8 61 41 7c f0              	mov	eax, 0xf07c4161
1803334bb: 41 33 04 8e                 	xor	eax, dword ptr [r14 + 4*rcx]
1803334bf: ff c1                       	inc	ecx
1803334c1: d3 c8                       	ror	eax, cl
1803334c3: 8d 48 ff                    	lea	ecx, [rax - 0x1]
1803334c6: 48 63 c9                    	movsxd	rcx, ecx
1803334c9: 41 8b 54 8d 00              	mov	edx, dword ptr [r13 + 4*rcx]
1803334ce: 8d 88 d2 56 27 06           	lea	ecx, [rax + 0x62756d2]
1803334d4: d3 ca                       	ror	edx, cl
1803334d6: d3 ca                       	ror	edx, cl
1803334d8: 81 f2 2c a9 d8 f9           	xor	edx, 0xf9d8a92c
1803334de: 0f ca                       	bswap	edx
1803334e0: d3 ca                       	ror	edx, cl
1803334e2: b9 14 00 00 00              	mov	ecx, 0x14
1803334e7: 29 c1                       	sub	ecx, eax
1803334e9: d3 c2                       	rol	edx, cl
1803334eb: 0f ca                       	bswap	edx
1803334ed: 48 63 c2                    	movsxd	rax, edx
1803334f0: 48 8d 8d a0 00 00 00        	lea	rcx, [rbp + 0xa0]
1803334f7: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803334fb: 48 63 0d b2 46 49 00        	movsxd	rcx, dword ptr [rip + 0x4946b2] # 0x1807c7bb4
180333502: b8 61 41 7c f0              	mov	eax, 0xf07c4161
180333507: 41 33 04 8e                 	xor	eax, dword ptr [r14 + 4*rcx]
18033350b: ff c1                       	inc	ecx
18033350d: d3 c8                       	ror	eax, cl
18033350f: 8d 48 ff                    	lea	ecx, [rax - 0x1]
180333512: 48 63 c9                    	movsxd	rcx, ecx
180333515: 41 8b 54 8d 00              	mov	edx, dword ptr [r13 + 4*rcx]
18033351a: 8d 88 d2 56 27 06           	lea	ecx, [rax + 0x62756d2]
180333520: d3 ca                       	ror	edx, cl
180333522: d3 ca                       	ror	edx, cl
180333524: 81 f2 2c a9 d8 f9           	xor	edx, 0xf9d8a92c
18033352a: 0f ca                       	bswap	edx
18033352c: d3 ca                       	ror	edx, cl
18033352e: b9 14 00 00 00              	mov	ecx, 0x14
180333533: 29 c1                       	sub	ecx, eax
180333535: d3 c2                       	rol	edx, cl
180333537: 0f ca                       	bswap	edx
180333539: 48 63 c2                    	movsxd	rax, edx
18033353c: 48 8d 8d c0 00 00 00        	lea	rcx, [rbp + 0xc0]
180333543: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333547: 48 63 05 7e 46 49 00        	movsxd	rax, dword ptr [rip + 0x49467e] # 0x1807c7bcc
18033354e: 31 d2                       	xor	edx, edx
180333550: 41 2b 14 86                 	sub	edx, dword ptr [r14 + 4*rax]
180333554: 8d 48 01                    	lea	ecx, [rax + 0x1]
180333557: d3 ca                       	ror	edx, cl
180333559: 48 63 c2                    	movsxd	rax, edx
18033355c: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
180333561: 0f ca                       	bswap	edx
180333563: b9 2f b8 6f 36              	mov	ecx, 0x366fb82f
180333568: 29 c1                       	sub	ecx, eax
18033356a: d3 c2                       	rol	edx, cl
18033356c: f7 d2                       	not	edx
18033356e: d3 c2                       	rol	edx, cl
180333570: d3 c2                       	rol	edx, cl
180333572: 83 c0 0f                    	add	eax, 0xf
180333575: 89 c1                       	mov	ecx, eax
180333577: d3 ca                       	ror	edx, cl
180333579: 48 63 c2                    	movsxd	rax, edx
18033357c: 48 8d 4d 08                 	lea	rcx, [rbp + 0x8]
180333580: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333584: 48 63 05 25 46 49 00        	movsxd	rax, dword ptr [rip + 0x494625] # 0x1807c7bb0
18033358b: 31 d2                       	xor	edx, edx
18033358d: 41 2b 14 86                 	sub	edx, dword ptr [r14 + 4*rax]
180333591: 8d 48 01                    	lea	ecx, [rax + 0x1]
180333594: d3 ca                       	ror	edx, cl
180333596: 48 63 c2                    	movsxd	rax, edx
180333599: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
18033359e: 0f ca                       	bswap	edx
1803335a0: b9 2f b8 6f 36              	mov	ecx, 0x366fb82f
1803335a5: 29 c1                       	sub	ecx, eax
1803335a7: d3 c2                       	rol	edx, cl
1803335a9: f7 d2                       	not	edx
1803335ab: d3 c2                       	rol	edx, cl
1803335ad: d3 c2                       	rol	edx, cl
1803335af: 83 c0 0f                    	add	eax, 0xf
1803335b2: 89 c1                       	mov	ecx, eax
1803335b4: d3 ca                       	ror	edx, cl
1803335b6: 48 63 c2                    	movsxd	rax, edx
1803335b9: 48 8d 4d 28                 	lea	rcx, [rbp + 0x28]
1803335bd: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803335c1: 48 63 05 0c 46 49 00        	movsxd	rax, dword ptr [rip + 0x49460c] # 0x1807c7bd4
1803335c8: ba 4f 66 4a 4c              	mov	edx, 0x4c4a664f
1803335cd: 41 33 14 86                 	xor	edx, dword ptr [r14 + 4*rax]
1803335d1: b9 10 00 00 00              	mov	ecx, 0x10
1803335d6: 29 c1                       	sub	ecx, eax
1803335d8: d3 c2                       	rol	edx, cl
1803335da: 81 f2 b0 99 b5 b3           	xor	edx, 0xb3b599b0
1803335e0: 48 63 c2                    	movsxd	rax, edx
1803335e3: 45 8b 44 85 00              	mov	r8d, dword ptr [r13 + 4*rax]
1803335e8: ba 55 fa d5 fd              	mov	edx, 0xfdd5fa55
1803335ed: 29 c2                       	sub	edx, eax
1803335ef: 89 d1                       	mov	ecx, edx
1803335f1: 41 d3 c0                    	rol	r8d, cl
1803335f4: 41 d3 c0                    	rol	r8d, cl
1803335f7: 05 55 fa d5 fd              	add	eax, 0xfdd5fa55
1803335fc: 89 c1                       	mov	ecx, eax
1803335fe: 41 d3 c8                    	ror	r8d, cl
180333601: 41 d3 c8                    	ror	r8d, cl
180333604: 89 d1                       	mov	ecx, edx
180333606: 41 d3 c0                    	rol	r8d, cl
180333609: 41 f7 d0                    	not	r8d
18033360c: 41 d3 c0                    	rol	r8d, cl
18033360f: 41 81 f0 55 fa d5 fd        	xor	r8d, 0xfdd5fa55
180333616: 49 63 c0                    	movsxd	rax, r8d
180333619: 48 8d 4d b8                 	lea	rcx, [rbp - 0x48]
18033361d: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
180333621: 48 89 f0                    	mov	rax, rsi
180333624: 48 81 c4 68 01 00 00        	add	rsp, 0x168
18033362b: 5b                          	pop	rbx
18033362c: 5f                          	pop	rdi
18033362d: 5e                          	pop	rsi
18033362e: 41 5c                       	pop	r12
180333630: 41 5d                       	pop	r13
180333632: 41 5e                       	pop	r14
180333634: 41 5f                       	pop	r15
180333636: 5d                          	pop	rbp
180333637: c3                          	ret
180333638: b8 5a f6 e4 4e              	mov	eax, 0x4ee4f65a
18033363d: 33 05 75 ce 47 00           	xor	eax, dword ptr [rip + 0x47ce75] # 0x1807b04b8
180333643: 05 a1 20 e5 9f              	add	eax, 0x9fe520a1
180333648: 89 85 b8 00 00 00           	mov	dword ptr [rbp + 0xb8], eax
18033364e: b8 a1 78 eb de              	mov	eax, 0xdeeb78a1
180333653: 33 05 4b ce 47 00           	xor	eax, dword ptr [rip + 0x47ce4b] # 0x1807b04a4
180333659: 05 e5 a9 34 b1              	add	eax, 0xb134a9e5
18033365e: 89 85 9c 00 00 00           	mov	dword ptr [rbp + 0x9c], eax
180333664: 48 8b 85 d0 00 00 00        	mov	rax, qword ptr [rbp + 0xd0]
18033366b: ba 6f 07 05 e0              	mov	edx, 0xe005076f
180333670: 33 15 d2 cd 47 00           	xor	edx, dword ptr [rip + 0x47cdd2] # 0x1807b0448
180333676: 48 63 0d a3 44 49 00        	movsxd	rcx, dword ptr [rip + 0x4944a3] # 0x1807c7b20
18033367d: 41 2b 3c 8e                 	sub	edi, dword ptr [r14 + 4*rcx]
180333681: 0f cf                       	bswap	edi
180333683: 4c 63 d7                    	movsxd	r10, edi
180333686: 47 8b 4c 95 00              	mov	r9d, dword ptr [r13 + 4*r10]
18033368b: 45 8d 82 3c 38 68 98        	lea	r8d, [r10 - 0x6797c7c4]
180333692: 44 89 c1                    	mov	ecx, r8d
180333695: 41 d3 c9                    	ror	r9d, cl
180333698: 41 d3 c9                    	ror	r9d, cl
18033369b: b9 3c 38 68 98              	mov	ecx, 0x9868383c
1803336a0: 44 29 d1                    	sub	ecx, r10d
1803336a3: 41 d3 c1                    	rol	r9d, cl
1803336a6: 41 d3 c1                    	rol	r9d, cl
1803336a9: 41 81 f1 3c 38 68 98        	xor	r9d, 0x9868383c
1803336b0: 44 89 c1                    	mov	ecx, r8d
1803336b3: 41 d3 c9                    	ror	r9d, cl
1803336b6: 81 c2 40 10 c7 68           	add	edx, 0x68c71040
1803336bc: 41 81 f1 c3 c7 97 67        	xor	r9d, 0x6797c7c3
1803336c3: 41 ff c1                    	inc	r9d
1803336c6: 4d 63 d1                    	movsxd	r10, r9d
1803336c9: 48 8d 8d 9c 00 00 00        	lea	rcx, [rbp + 0x9c]
1803336d0: 48 89 4c 24 20              	mov	qword ptr [rsp + 0x20], rcx
1803336d5: 48 c7 44 24 28 00 00 00 00  	mov	qword ptr [rsp + 0x28], 0x0
1803336de: 4c 8d 8d b8 00 00 00        	lea	r9, [rbp + 0xb8]
1803336e5: 48 89 c1                    	mov	rcx, rax
1803336e8: 45 31 c0                    	xor	r8d, r8d
1803336eb: 43 ff 14 d4                 	call	qword ptr [r12 + 8*r10]
1803336ef: b9 28 3e af dd              	mov	ecx, 0xddaf3e28
1803336f4: 33 0d 6e cd 47 00           	xor	ecx, dword ptr [rip + 0x47cd6e] # 0x1807b0468
1803336fa: 81 c1 c7 db 61 a0           	add	ecx, 0xa061dbc7
