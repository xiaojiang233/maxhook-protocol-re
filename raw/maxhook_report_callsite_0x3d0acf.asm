
E:\MCLDownload\Game\.minecraft\native\MaxHook.dll:	file format coff-x86-64

Disassembly of section .text:

0000000180010000 <.text>:
1803d0850: 29 c1                       	sub	ecx, eax
1803d0852: d3 c2                       	rol	edx, cl
1803d0854: f7 da                       	neg	edx
1803d0856: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803d0859: d3 ca                       	ror	edx, cl
1803d085b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803d0861: 4c 63 c2                    	movsxd	r8, edx
1803d0864: 47 8b 0c 87                 	mov	r9d, dword ptr [r15 + 4*r8]
1803d0868: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803d086f: 89 c1                       	mov	ecx, eax
1803d0871: 41 d3 c9                    	ror	r9d, cl
1803d0874: 41 0f c9                    	bswap	r9d
1803d0877: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803d087c: 44 29 c2                    	sub	edx, r8d
1803d087f: 89 d1                       	mov	ecx, edx
1803d0881: 41 d3 c1                    	rol	r9d, cl
1803d0884: 89 c1                       	mov	ecx, eax
1803d0886: 41 d3 c9                    	ror	r9d, cl
1803d0889: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803d088d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803d0894: 41 d3 c9                    	ror	r9d, cl
1803d0897: 89 d1                       	mov	ecx, edx
1803d0899: 41 d3 c1                    	rol	r9d, cl
1803d089c: 41 d3 c1                    	rol	r9d, cl
1803d089f: 49 63 c1                    	movsxd	rax, r9d
1803d08a2: 4c 89 c1                    	mov	rcx, r8
1803d08a5: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d08a9: 48 83 c7 e8                 	add	rdi, -0x18
1803d08ad: 48 83 ff e8                 	cmp	rdi, -0x18
1803d08b1: 75 8d                       	jne	0x1803d0840 <.text+0x3c0840>
1803d08b3: b8 4d 9a b0 c3              	mov	eax, 0xc3b09a4d
1803d08b8: 33 05 b2 47 3e 00           	xor	eax, dword ptr [rip + 0x3e47b2] # 0x1807b5070
1803d08be: 05 2a 2a 6d d5              	add	eax, 0xd56d2a2a
1803d08c3: 48 98                       	cdqe
1803d08c5: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d08c9: 48 8d 34 c5 b0 05 00 00     	lea	rsi, [8*rax + 0x5b0]
1803d08d1: 48 01 ee                    	add	rsi, rbp
1803d08d4: bf 18 00 00 00              	mov	edi, 0x18
1803d08d9: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803d08e0: 48 63 05 61 bb 3f 00        	movsxd	rax, dword ptr [rip + 0x3fbb61] # 0x1807cc448
1803d08e7: 41 8b 14 84                 	mov	edx, dword ptr [r12 + 4*rax]
1803d08eb: b9 0f 00 00 00              	mov	ecx, 0xf
1803d08f0: 29 c1                       	sub	ecx, eax
1803d08f2: d3 c2                       	rol	edx, cl
1803d08f4: f7 da                       	neg	edx
1803d08f6: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803d08f9: d3 ca                       	ror	edx, cl
1803d08fb: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803d0901: 4c 63 c2                    	movsxd	r8, edx
1803d0904: 47 8b 0c 87                 	mov	r9d, dword ptr [r15 + 4*r8]
1803d0908: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803d090f: 89 c1                       	mov	ecx, eax
1803d0911: 41 d3 c9                    	ror	r9d, cl
1803d0914: 41 0f c9                    	bswap	r9d
1803d0917: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803d091c: 44 29 c2                    	sub	edx, r8d
1803d091f: 89 d1                       	mov	ecx, edx
1803d0921: 41 d3 c1                    	rol	r9d, cl
1803d0924: 89 c1                       	mov	ecx, eax
1803d0926: 41 d3 c9                    	ror	r9d, cl
1803d0929: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803d092d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803d0934: 41 d3 c9                    	ror	r9d, cl
1803d0937: 89 d1                       	mov	ecx, edx
1803d0939: 41 d3 c1                    	rol	r9d, cl
1803d093c: 41 d3 c1                    	rol	r9d, cl
1803d093f: 49 63 c1                    	movsxd	rax, r9d
1803d0942: 4c 89 c1                    	mov	rcx, r8
1803d0945: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d0949: 48 83 c7 e8                 	add	rdi, -0x18
1803d094d: 48 83 ff e8                 	cmp	rdi, -0x18
1803d0951: 75 8d                       	jne	0x1803d08e0 <.text+0x3c08e0>
1803d0953: b8 c8 e8 2c 58              	mov	eax, 0x582ce8c8
1803d0958: 33 05 1e 47 3e 00           	xor	eax, dword ptr [rip + 0x3e471e] # 0x1807b507c
1803d095e: 05 2a 1a 99 92              	add	eax, 0x92991a2a
1803d0963: 48 98                       	cdqe
1803d0965: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d0969: 48 8d 34 c5 80 05 00 00     	lea	rsi, [8*rax + 0x580]
1803d0971: 48 01 ee                    	add	rsi, rbp
1803d0974: bf 18 00 00 00              	mov	edi, 0x18
1803d0979: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803d0980: 48 63 05 69 ba 3f 00        	movsxd	rax, dword ptr [rip + 0x3fba69] # 0x1807cc3f0
1803d0987: 41 8b 14 84                 	mov	edx, dword ptr [r12 + 4*rax]
1803d098b: b9 0f 00 00 00              	mov	ecx, 0xf
1803d0990: 29 c1                       	sub	ecx, eax
1803d0992: d3 c2                       	rol	edx, cl
1803d0994: f7 da                       	neg	edx
1803d0996: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803d0999: d3 ca                       	ror	edx, cl
1803d099b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803d09a1: 4c 63 c2                    	movsxd	r8, edx
1803d09a4: 47 8b 0c 87                 	mov	r9d, dword ptr [r15 + 4*r8]
1803d09a8: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803d09af: 89 c1                       	mov	ecx, eax
1803d09b1: 41 d3 c9                    	ror	r9d, cl
1803d09b4: 41 0f c9                    	bswap	r9d
1803d09b7: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803d09bc: 44 29 c2                    	sub	edx, r8d
1803d09bf: 89 d1                       	mov	ecx, edx
1803d09c1: 41 d3 c1                    	rol	r9d, cl
1803d09c4: 89 c1                       	mov	ecx, eax
1803d09c6: 41 d3 c9                    	ror	r9d, cl
1803d09c9: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803d09cd: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803d09d4: 41 d3 c9                    	ror	r9d, cl
1803d09d7: 89 d1                       	mov	ecx, edx
1803d09d9: 41 d3 c1                    	rol	r9d, cl
1803d09dc: 41 d3 c1                    	rol	r9d, cl
1803d09df: 49 63 c1                    	movsxd	rax, r9d
1803d09e2: 4c 89 c1                    	mov	rcx, r8
1803d09e5: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d09e9: 48 83 c7 e8                 	add	rdi, -0x18
1803d09ed: 48 83 ff e8                 	cmp	rdi, -0x18
1803d09f1: 75 8d                       	jne	0x1803d0980 <.text+0x3c0980>
1803d09f3: 48 63 05 a2 b8 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb8a2] # 0x1807cc29c
1803d09fa: 41 8b 14 84                 	mov	edx, dword ptr [r12 + 4*rax]
1803d09fe: b9 06 00 00 00              	mov	ecx, 0x6
1803d0a03: 29 c1                       	sub	ecx, eax
1803d0a05: d3 c2                       	rol	edx, cl
1803d0a07: 8d 88 46 e6 d2 24           	lea	ecx, [rax + 0x24d2e646]
1803d0a0d: d3 ca                       	ror	edx, cl
1803d0a0f: f7 d2                       	not	edx
1803d0a11: d3 ca                       	ror	edx, cl
1803d0a13: 48 63 ca                    	movsxd	rcx, edx
1803d0a16: 41 8b 04 8f                 	mov	eax, dword ptr [r15 + 4*rcx]
1803d0a1a: 0f c8                       	bswap	eax
1803d0a1c: 81 c1 d7 49 f7 95           	add	ecx, 0x95f749d7
1803d0a22: d3 c8                       	ror	eax, cl
1803d0a24: d3 c8                       	ror	eax, cl
1803d0a26: 35 d7 49 f7 95              	xor	eax, 0x95f749d7
1803d0a2b: 48 98                       	cdqe
1803d0a2d: 48 8d b5 b0 05 00 00        	lea	rsi, [rbp + 0x5b0]
1803d0a34: 48 89 f1                    	mov	rcx, rsi
1803d0a37: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d0a3b: 48 63 15 da b9 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fb9da] # 0x1807cc41c
1803d0a42: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803d0a46: b8 02 ad b9 e6              	mov	eax, 0xe6b9ad02
1803d0a4b: 29 d0                       	sub	eax, edx
1803d0a4d: 89 c1                       	mov	ecx, eax
1803d0a4f: 41 d3 c0                    	rol	r8d, cl
1803d0a52: 8d 4a 02                    	lea	ecx, [rdx + 0x2]
1803d0a55: 41 d3 c8                    	ror	r8d, cl
1803d0a58: 89 c1                       	mov	ecx, eax
1803d0a5a: 41 d3 c0                    	rol	r8d, cl
1803d0a5d: 41 0f c8                    	bswap	r8d
1803d0a60: 49 63 c8                    	movsxd	rcx, r8d
1803d0a63: b8 01 63 73 b6              	mov	eax, 0xb6736301
1803d0a68: 41 33 04 8f                 	xor	eax, dword ptr [r15 + 4*rcx]
1803d0a6c: 0f c8                       	bswap	eax
1803d0a6e: 81 c1 01 63 73 b6           	add	ecx, 0xb6736301
1803d0a74: d3 c8                       	ror	eax, cl
1803d0a76: f7 d0                       	not	eax
1803d0a78: 0f c8                       	bswap	eax
1803d0a7a: f7 d8                       	neg	eax
1803d0a7c: d3 c8                       	ror	eax, cl
1803d0a7e: 35 01 63 73 b6              	xor	eax, 0xb6736301
1803d0a83: 48 98                       	cdqe
1803d0a85: 48 89 f1                    	mov	rcx, rsi
1803d0a88: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d0a8c: 48 8d 8d 80 05 00 00        	lea	rcx, [rbp + 0x580]
1803d0a93: 48 89 c2                    	mov	rdx, rax
1803d0a96: e8 35 94 c4 ff              	call	0x180019ed0 <.text+0x9ed0>
1803d0a9b: 48 8b 85 e8 05 00 00        	mov	rax, qword ptr [rbp + 0x5e8]
1803d0aa2: 48 8d 50 08                 	lea	rdx, [rax + 0x8]
1803d0aa6: b8 da 69 dc 05              	mov	eax, 0x5dc69da
1803d0aab: 33 05 a7 44 3e 00           	xor	eax, dword ptr [rip + 0x3e44a7] # 0x1807b4f58
1803d0ab1: 05 28 4d 7e 03              	add	eax, 0x37e4d28
1803d0ab6: 89 44 24 20                 	mov	dword ptr [rsp + 0x20], eax
1803d0aba: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803d0ac1: 4c 8d 85 80 05 00 00        	lea	r8, [rbp + 0x580]
1803d0ac8: 4c 8d 8d 20 01 00 00        	lea	r9, [rbp + 0x120]
1803d0acf: e8 9c 1c f6 ff              	call	0x180332770 <.text+0x322770>
1803d0ad4: 48 63 15 49 b9 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fb949] # 0x1807cc424
1803d0adb: 48 8d 1d 1e c2 28 00        	lea	rbx, [rip + 0x28c21e]   # 0x18065cd00
1803d0ae2: 8b 04 93                    	mov	eax, dword ptr [rbx + 4*rdx]
1803d0ae5: b9 13 00 00 00              	mov	ecx, 0x13
1803d0aea: 29 d1                       	sub	ecx, edx
1803d0aec: d3 c0                       	rol	eax, cl
1803d0aee: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d0af3: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d0af8: 29 c1                       	sub	ecx, eax
1803d0afa: 48 63 c9                    	movsxd	rcx, ecx
1803d0afd: 31 d2                       	xor	edx, edx
1803d0aff: 4c 8d 2d ca 2f 3f 00        	lea	r13, [rip + 0x3f2fca]   # 0x1807c3ad0
1803d0b06: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803d0b0b: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d0b10: 29 c1                       	sub	ecx, eax
1803d0b12: d3 ca                       	ror	edx, cl
1803d0b14: d3 ca                       	ror	edx, cl
1803d0b16: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d0b1c: d3 ca                       	ror	edx, cl
1803d0b1e: 45 31 f6                    	xor	r14d, r14d
