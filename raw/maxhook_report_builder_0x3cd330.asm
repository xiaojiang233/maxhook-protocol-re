
E:\MCLDownload\Game\.minecraft\native\MaxHook.dll:	file format coff-x86-64

Disassembly of section .text:

0000000180010000 <.text>:
1803cd330: 55                          	push	rbp
1803cd331: 41 57                       	push	r15
1803cd333: 41 56                       	push	r14
1803cd335: 41 55                       	push	r13
1803cd337: 41 54                       	push	r12
1803cd339: 56                          	push	rsi
1803cd33a: 57                          	push	rdi
1803cd33b: 53                          	push	rbx
1803cd33c: 48 81 ec a8 06 00 00        	sub	rsp, 0x6a8
1803cd343: 48 8d ac 24 80 00 00 00     	lea	rbp, [rsp + 0x80]
1803cd34b: 48 c7 85 18 06 00 00 fe ff ff ff    	mov	qword ptr [rbp + 0x618], -0x2
1803cd356: 48 89 95 e0 05 00 00        	mov	qword ptr [rbp + 0x5e0], rdx
1803cd35d: 48 8b 01                    	mov	rax, qword ptr [rcx]
1803cd360: 48 89 85 e8 05 00 00        	mov	qword ptr [rbp + 0x5e8], rax
1803cd367: 48 63 05 76 ee 3f 00        	movsxd	rax, dword ptr [rip + 0x3fee76] # 0x1807cc1e4
1803cd36e: 4c 8d 3d 8b f9 28 00        	lea	r15, [rip + 0x28f98b]   # 0x18065cd00
1803cd375: 41 be d0 32 f8 32           	mov	r14d, 0x32f832d0
1803cd37b: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cd37f: 44 31 f2                    	xor	edx, r14d
1803cd382: ff c2                       	inc	edx
1803cd384: bf 2f cd 07 cd              	mov	edi, 0xcd07cd2f
1803cd389: b9 2f cd 07 cd              	mov	ecx, 0xcd07cd2f
1803cd38e: 29 c1                       	sub	ecx, eax
1803cd390: d3 c2                       	rol	edx, cl
1803cd392: d3 c2                       	rol	edx, cl
1803cd394: 48 63 d2                    	movsxd	rdx, edx
1803cd397: 4c 8d 25 32 67 3f 00        	lea	r12, [rip + 0x3f6732]   # 0x1807c3ad0
1803cd39e: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803cd3a2: 8d 82 03 6e eb ea           	lea	eax, [rdx - 0x151491fd]
1803cd3a8: 89 c1                       	mov	ecx, eax
1803cd3aa: 41 d3 c8                    	ror	r8d, cl
1803cd3ad: 41 d3 c8                    	ror	r8d, cl
1803cd3b0: bb 03 00 00 00              	mov	ebx, 0x3
1803cd3b5: b9 03 00 00 00              	mov	ecx, 0x3
1803cd3ba: 29 d1                       	sub	ecx, edx
1803cd3bc: 41 d3 c0                    	rol	r8d, cl
1803cd3bf: 89 c1                       	mov	ecx, eax
1803cd3c1: 41 d3 c8                    	ror	r8d, cl
1803cd3c4: 41 ff c8                    	dec	r8d
1803cd3c7: 41 0f c8                    	bswap	r8d
1803cd3ca: 41 f7 d8                    	neg	r8d
1803cd3cd: 49 63 c0                    	movsxd	rax, r8d
1803cd3d0: 4c 8d 2d 99 08 3f 00        	lea	r13, [rip + 0x3f0899]   # 0x1807bdc70
1803cd3d7: 48 8d 8d e0 00 00 00        	lea	rcx, [rbp + 0xe0]
1803cd3de: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd3e3: 48 63 05 f2 ed 3f 00        	movsxd	rax, dword ptr [rip + 0x3fedf2] # 0x1807cc1dc
1803cd3ea: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cd3ee: 44 31 f2                    	xor	edx, r14d
1803cd3f1: ff c2                       	inc	edx
1803cd3f3: b9 2f cd 07 cd              	mov	ecx, 0xcd07cd2f
1803cd3f8: 29 c1                       	sub	ecx, eax
1803cd3fa: d3 c2                       	rol	edx, cl
1803cd3fc: d3 c2                       	rol	edx, cl
1803cd3fe: 48 63 d2                    	movsxd	rdx, edx
1803cd401: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803cd405: 8d 82 03 6e eb ea           	lea	eax, [rdx - 0x151491fd]
1803cd40b: 89 c1                       	mov	ecx, eax
1803cd40d: 41 d3 c8                    	ror	r8d, cl
1803cd410: 41 d3 c8                    	ror	r8d, cl
1803cd413: b9 03 00 00 00              	mov	ecx, 0x3
1803cd418: 29 d1                       	sub	ecx, edx
1803cd41a: 41 d3 c0                    	rol	r8d, cl
1803cd41d: 89 c1                       	mov	ecx, eax
1803cd41f: 41 d3 c8                    	ror	r8d, cl
1803cd422: 41 ff c8                    	dec	r8d
1803cd425: 41 0f c8                    	bswap	r8d
1803cd428: 41 f7 d8                    	neg	r8d
1803cd42b: 49 63 c0                    	movsxd	rax, r8d
1803cd42e: 48 8d 8d a0 01 00 00        	lea	rcx, [rbp + 0x1a0]
1803cd435: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd43a: 48 63 05 9f ed 3f 00        	movsxd	rax, dword ptr [rip + 0x3fed9f] # 0x1807cc1e0
1803cd441: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cd445: 44 31 f2                    	xor	edx, r14d
1803cd448: ff c2                       	inc	edx
1803cd44a: b9 2f cd 07 cd              	mov	ecx, 0xcd07cd2f
1803cd44f: 29 c1                       	sub	ecx, eax
1803cd451: d3 c2                       	rol	edx, cl
1803cd453: d3 c2                       	rol	edx, cl
1803cd455: 48 63 d2                    	movsxd	rdx, edx
1803cd458: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803cd45c: 8d 82 03 6e eb ea           	lea	eax, [rdx - 0x151491fd]
1803cd462: 89 c1                       	mov	ecx, eax
1803cd464: 41 d3 c8                    	ror	r8d, cl
1803cd467: 41 d3 c8                    	ror	r8d, cl
1803cd46a: b9 03 00 00 00              	mov	ecx, 0x3
1803cd46f: 29 d1                       	sub	ecx, edx
1803cd471: 41 d3 c0                    	rol	r8d, cl
1803cd474: 89 c1                       	mov	ecx, eax
1803cd476: 41 d3 c8                    	ror	r8d, cl
1803cd479: 41 ff c8                    	dec	r8d
1803cd47c: 41 0f c8                    	bswap	r8d
1803cd47f: 41 f7 d8                    	neg	r8d
1803cd482: 49 63 c0                    	movsxd	rax, r8d
1803cd485: 48 8d 8d c0 01 00 00        	lea	rcx, [rbp + 0x1c0]
1803cd48c: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd491: 48 63 05 98 ed 3f 00        	movsxd	rax, dword ptr [rip + 0x3fed98] # 0x1807cc230
1803cd498: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cd49c: 44 31 f2                    	xor	edx, r14d
1803cd49f: ff c2                       	inc	edx
1803cd4a1: b9 2f cd 07 cd              	mov	ecx, 0xcd07cd2f
1803cd4a6: 29 c1                       	sub	ecx, eax
1803cd4a8: d3 c2                       	rol	edx, cl
1803cd4aa: d3 c2                       	rol	edx, cl
1803cd4ac: 48 63 d2                    	movsxd	rdx, edx
1803cd4af: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803cd4b3: 8d 82 03 6e eb ea           	lea	eax, [rdx - 0x151491fd]
1803cd4b9: 89 c1                       	mov	ecx, eax
1803cd4bb: 41 d3 c8                    	ror	r8d, cl
1803cd4be: 41 d3 c8                    	ror	r8d, cl
1803cd4c1: b9 03 00 00 00              	mov	ecx, 0x3
1803cd4c6: 29 d1                       	sub	ecx, edx
1803cd4c8: 41 d3 c0                    	rol	r8d, cl
1803cd4cb: 89 c1                       	mov	ecx, eax
1803cd4cd: 41 d3 c8                    	ror	r8d, cl
1803cd4d0: 41 ff c8                    	dec	r8d
1803cd4d3: 41 0f c8                    	bswap	r8d
1803cd4d6: 41 f7 d8                    	neg	r8d
1803cd4d9: 49 63 c0                    	movsxd	rax, r8d
1803cd4dc: 48 8d 8d 00 01 00 00        	lea	rcx, [rbp + 0x100]
1803cd4e3: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd4e8: 48 63 05 35 ed 3f 00        	movsxd	rax, dword ptr [rip + 0x3fed35] # 0x1807cc224
1803cd4ef: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cd4f3: 44 31 f2                    	xor	edx, r14d
1803cd4f6: ff c2                       	inc	edx
1803cd4f8: b9 2f cd 07 cd              	mov	ecx, 0xcd07cd2f
1803cd4fd: 29 c1                       	sub	ecx, eax
1803cd4ff: d3 c2                       	rol	edx, cl
1803cd501: d3 c2                       	rol	edx, cl
1803cd503: 48 63 d2                    	movsxd	rdx, edx
1803cd506: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803cd50a: 8d 82 03 6e eb ea           	lea	eax, [rdx - 0x151491fd]
1803cd510: 89 c1                       	mov	ecx, eax
1803cd512: 41 d3 c8                    	ror	r8d, cl
1803cd515: 41 d3 c8                    	ror	r8d, cl
1803cd518: b9 03 00 00 00              	mov	ecx, 0x3
1803cd51d: 29 d1                       	sub	ecx, edx
1803cd51f: 41 d3 c0                    	rol	r8d, cl
1803cd522: 89 c1                       	mov	ecx, eax
1803cd524: 41 d3 c8                    	ror	r8d, cl
1803cd527: 41 ff c8                    	dec	r8d
1803cd52a: 41 0f c8                    	bswap	r8d
1803cd52d: 41 f7 d8                    	neg	r8d
1803cd530: 49 63 c0                    	movsxd	rax, r8d
1803cd533: 48 8d 8d 20 01 00 00        	lea	rcx, [rbp + 0x120]
1803cd53a: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd53f: 48 63 05 e6 ec 3f 00        	movsxd	rax, dword ptr [rip + 0x3fece6] # 0x1807cc22c
1803cd546: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cd54a: 44 31 f2                    	xor	edx, r14d
1803cd54d: ff c2                       	inc	edx
1803cd54f: b9 2f cd 07 cd              	mov	ecx, 0xcd07cd2f
1803cd554: 29 c1                       	sub	ecx, eax
1803cd556: d3 c2                       	rol	edx, cl
1803cd558: d3 c2                       	rol	edx, cl
1803cd55a: 48 63 d2                    	movsxd	rdx, edx
1803cd55d: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803cd561: 8d 82 03 6e eb ea           	lea	eax, [rdx - 0x151491fd]
1803cd567: 89 c1                       	mov	ecx, eax
1803cd569: 41 d3 c8                    	ror	r8d, cl
1803cd56c: 41 d3 c8                    	ror	r8d, cl
1803cd56f: b9 03 00 00 00              	mov	ecx, 0x3
1803cd574: 29 d1                       	sub	ecx, edx
1803cd576: 41 d3 c0                    	rol	r8d, cl
1803cd579: 89 c1                       	mov	ecx, eax
1803cd57b: 41 d3 c8                    	ror	r8d, cl
1803cd57e: 41 ff c8                    	dec	r8d
1803cd581: 41 0f c8                    	bswap	r8d
1803cd584: 41 f7 d8                    	neg	r8d
1803cd587: 49 63 c0                    	movsxd	rax, r8d
1803cd58a: 48 8d b5 40 01 00 00        	lea	rsi, [rbp + 0x140]
1803cd591: 48 89 f1                    	mov	rcx, rsi
1803cd594: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd599: 48 63 05 58 ec 3f 00        	movsxd	rax, dword ptr [rip + 0x3fec58] # 0x1807cc1f8
1803cd5a0: 45 33 34 87                 	xor	r14d, dword ptr [r15 + 4*rax]
1803cd5a4: 41 ff c6                    	inc	r14d
1803cd5a7: 29 c7                       	sub	edi, eax
1803cd5a9: 89 f9                       	mov	ecx, edi
1803cd5ab: 41 d3 c6                    	rol	r14d, cl
1803cd5ae: 41 d3 c6                    	rol	r14d, cl
1803cd5b1: 49 63 d6                    	movsxd	rdx, r14d
1803cd5b4: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803cd5b8: 8d 82 03 6e eb ea           	lea	eax, [rdx - 0x151491fd]
1803cd5be: 89 c1                       	mov	ecx, eax
1803cd5c0: 41 d3 c8                    	ror	r8d, cl
1803cd5c3: 41 d3 c8                    	ror	r8d, cl
1803cd5c6: 29 d3                       	sub	ebx, edx
1803cd5c8: 89 d9                       	mov	ecx, ebx
1803cd5ca: 41 d3 c0                    	rol	r8d, cl
1803cd5cd: 89 c1                       	mov	ecx, eax
1803cd5cf: 41 d3 c8                    	ror	r8d, cl
1803cd5d2: 41 ff c8                    	dec	r8d
1803cd5d5: 41 0f c8                    	bswap	r8d
1803cd5d8: 41 f7 d8                    	neg	r8d
1803cd5db: 49 63 c0                    	movsxd	rax, r8d
1803cd5de: 48 8d bd c0 00 00 00        	lea	rdi, [rbp + 0xc0]
1803cd5e5: 48 89 f9                    	mov	rcx, rdi
1803cd5e8: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd5ed: 48 63 0d 2c ec 3f 00        	movsxd	rcx, dword ptr [rip + 0x3fec2c] # 0x1807cc220
1803cd5f4: 41 8b 04 8f                 	mov	eax, dword ptr [r15 + 4*rcx]
1803cd5f8: 83 c1 1e                    	add	ecx, 0x1e
1803cd5fb: d3 c8                       	ror	eax, cl
1803cd5fd: 89 c1                       	mov	ecx, eax
1803cd5ff: f7 d1                       	not	ecx
1803cd601: 48 63 c9                    	movsxd	rcx, ecx
1803cd604: 41 8b 14 8c                 	mov	edx, dword ptr [r12 + 4*rcx]
1803cd608: b9 1e 00 00 00              	mov	ecx, 0x1e
1803cd60d: 29 c1                       	sub	ecx, eax
1803cd60f: d3 ca                       	ror	edx, cl
1803cd611: 0f ca                       	bswap	edx
1803cd613: f7 da                       	neg	edx
1803cd615: 89 c1                       	mov	ecx, eax
1803cd617: d3 c2                       	rol	edx, cl
1803cd619: f7 da                       	neg	edx
1803cd61b: 0f ca                       	bswap	edx
1803cd61d: d3 c2                       	rol	edx, cl
1803cd61f: f7 d2                       	not	edx
1803cd621: 48 63 c2                    	movsxd	rax, edx
1803cd624: 4c 8d b5 18 04 00 00        	lea	r14, [rbp + 0x418]
1803cd62b: 4c 89 f1                    	mov	rcx, r14
1803cd62e: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd633: 48 8d 85 e0 00 00 00        	lea	rax, [rbp + 0xe0]
1803cd63a: 48 89 85 90 02 00 00        	mov	qword ptr [rbp + 0x290], rax
1803cd641: 8b 0d 0d 35 4c 00           	mov	ecx, dword ptr [rip + 0x4c350d] # 0x180890b54
1803cd647: 83 c1 02                    	add	ecx, 0x2
1803cd64a: b8 a7 f0 ff ff              	mov	eax, 0xfffff0a7
1803cd64f: d3 c8                       	ror	eax, cl
1803cd651: bb a7 f0 ff ff              	mov	ebx, 0xfffff0a7
1803cd656: 89 c1                       	mov	ecx, eax
1803cd658: f7 d9                       	neg	ecx
1803cd65a: 48 63 c9                    	movsxd	rcx, ecx
1803cd65d: 41 8b 14 8c                 	mov	edx, dword ptr [r12 + 4*rcx]
1803cd661: b9 6f 25 b4 1d              	mov	ecx, 0x1db4256f
1803cd666: 29 c1                       	sub	ecx, eax
1803cd668: d3 ca                       	ror	edx, cl
1803cd66a: d3 ca                       	ror	edx, cl
1803cd66c: 41 bf 6f 25 b4 1d           	mov	r15d, 0x1db4256f
1803cd672: f7 d2                       	not	edx
1803cd674: 83 c0 0f                    	add	eax, 0xf
1803cd677: 89 c1                       	mov	ecx, eax
1803cd679: d3 c2                       	rol	edx, cl
1803cd67b: 48 63 c2                    	movsxd	rax, edx
1803cd67e: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cd685: 4c 89 f1                    	mov	rcx, r14
1803cd688: 41 ff 54 c5 00              	call	qword ptr [r13 + 8*rax]
1803cd68d: 48 8d 85 a0 01 00 00        	lea	rax, [rbp + 0x1a0]
1803cd694: 48 89 85 90 02 00 00        	mov	qword ptr [rbp + 0x290], rax
1803cd69b: 8b 0d b3 34 4c 00           	mov	ecx, dword ptr [rip + 0x4c34b3] # 0x180890b54
1803cd6a1: 83 c1 02                    	add	ecx, 0x2
1803cd6a4: d3 cb                       	ror	ebx, cl
1803cd6a6: 89 d8                       	mov	eax, ebx
1803cd6a8: f7 d8                       	neg	eax
1803cd6aa: 48 98                       	cdqe
1803cd6ac: 48 8d 0d 1d 64 3f 00        	lea	rcx, [rip + 0x3f641d]   # 0x1807c3ad0
1803cd6b3: 8b 04 81                    	mov	eax, dword ptr [rcx + 4*rax]
1803cd6b6: 41 29 df                    	sub	r15d, ebx
1803cd6b9: 44 89 f9                    	mov	ecx, r15d
1803cd6bc: d3 c8                       	ror	eax, cl
1803cd6be: d3 c8                       	ror	eax, cl
1803cd6c0: f7 d0                       	not	eax
1803cd6c2: 83 c3 0f                    	add	ebx, 0xf
1803cd6c5: 89 d9                       	mov	ecx, ebx
1803cd6c7: d3 c0                       	rol	eax, cl
1803cd6c9: 48 98                       	cdqe
1803cd6cb: 48 8d 8d 18 04 00 00        	lea	rcx, [rbp + 0x418]
1803cd6d2: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cd6d9: 4c 8d 05 90 05 3f 00        	lea	r8, [rip + 0x3f0590]    # 0x1807bdc70
1803cd6e0: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
1803cd6e4: 48 8d 85 c0 01 00 00        	lea	rax, [rbp + 0x1c0]
1803cd6eb: 48 89 85 90 02 00 00        	mov	qword ptr [rbp + 0x290], rax
1803cd6f2: 8b 0d 5c 34 4c 00           	mov	ecx, dword ptr [rip + 0x4c345c] # 0x180890b54
1803cd6f8: 83 c1 02                    	add	ecx, 0x2
1803cd6fb: b8 a7 f0 ff ff              	mov	eax, 0xfffff0a7
1803cd700: d3 c8                       	ror	eax, cl
1803cd702: bb a7 f0 ff ff              	mov	ebx, 0xfffff0a7
1803cd707: 89 c1                       	mov	ecx, eax
1803cd709: f7 d9                       	neg	ecx
1803cd70b: 48 63 c9                    	movsxd	rcx, ecx
1803cd70e: 48 8d 15 bb 63 3f 00        	lea	rdx, [rip + 0x3f63bb]   # 0x1807c3ad0
1803cd715: 8b 14 8a                    	mov	edx, dword ptr [rdx + 4*rcx]
1803cd718: b9 6f 25 b4 1d              	mov	ecx, 0x1db4256f
1803cd71d: 29 c1                       	sub	ecx, eax
1803cd71f: d3 ca                       	ror	edx, cl
1803cd721: d3 ca                       	ror	edx, cl
1803cd723: 41 be 6f 25 b4 1d           	mov	r14d, 0x1db4256f
1803cd729: f7 d2                       	not	edx
1803cd72b: 83 c0 0f                    	add	eax, 0xf
1803cd72e: 89 c1                       	mov	ecx, eax
1803cd730: d3 c2                       	rol	edx, cl
1803cd732: 48 63 c2                    	movsxd	rax, edx
1803cd735: 48 8d 8d 18 04 00 00        	lea	rcx, [rbp + 0x418]
1803cd73c: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cd743: 4c 8d 05 26 05 3f 00        	lea	r8, [rip + 0x3f0526]    # 0x1807bdc70
1803cd74a: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
1803cd74e: 48 8d 85 00 01 00 00        	lea	rax, [rbp + 0x100]
1803cd755: 48 89 85 90 02 00 00        	mov	qword ptr [rbp + 0x290], rax
1803cd75c: 8b 0d f2 33 4c 00           	mov	ecx, dword ptr [rip + 0x4c33f2] # 0x180890b54
1803cd762: 83 c1 02                    	add	ecx, 0x2
1803cd765: d3 cb                       	ror	ebx, cl
1803cd767: 89 d8                       	mov	eax, ebx
1803cd769: f7 d8                       	neg	eax
1803cd76b: 48 98                       	cdqe
1803cd76d: 48 8d 0d 5c 63 3f 00        	lea	rcx, [rip + 0x3f635c]   # 0x1807c3ad0
1803cd774: 8b 04 81                    	mov	eax, dword ptr [rcx + 4*rax]
1803cd777: 41 29 de                    	sub	r14d, ebx
1803cd77a: 44 89 f1                    	mov	ecx, r14d
1803cd77d: d3 c8                       	ror	eax, cl
1803cd77f: d3 c8                       	ror	eax, cl
1803cd781: f7 d0                       	not	eax
1803cd783: 83 c3 0f                    	add	ebx, 0xf
1803cd786: 89 d9                       	mov	ecx, ebx
1803cd788: d3 c0                       	rol	eax, cl
1803cd78a: 48 98                       	cdqe
1803cd78c: 48 8d 8d 18 04 00 00        	lea	rcx, [rbp + 0x418]
1803cd793: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cd79a: 4c 8d 05 cf 04 3f 00        	lea	r8, [rip + 0x3f04cf]    # 0x1807bdc70
1803cd7a1: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
1803cd7a5: 48 8d 85 20 01 00 00        	lea	rax, [rbp + 0x120]
1803cd7ac: 48 89 85 90 02 00 00        	mov	qword ptr [rbp + 0x290], rax
1803cd7b3: 8b 0d 9b 33 4c 00           	mov	ecx, dword ptr [rip + 0x4c339b] # 0x180890b54
1803cd7b9: 83 c1 02                    	add	ecx, 0x2
1803cd7bc: b8 a7 f0 ff ff              	mov	eax, 0xfffff0a7
1803cd7c1: d3 c8                       	ror	eax, cl
1803cd7c3: bb a7 f0 ff ff              	mov	ebx, 0xfffff0a7
1803cd7c8: 89 c1                       	mov	ecx, eax
1803cd7ca: f7 d9                       	neg	ecx
1803cd7cc: 48 63 c9                    	movsxd	rcx, ecx
1803cd7cf: 48 8d 15 fa 62 3f 00        	lea	rdx, [rip + 0x3f62fa]   # 0x1807c3ad0
1803cd7d6: 8b 14 8a                    	mov	edx, dword ptr [rdx + 4*rcx]
1803cd7d9: b9 6f 25 b4 1d              	mov	ecx, 0x1db4256f
1803cd7de: 29 c1                       	sub	ecx, eax
1803cd7e0: d3 ca                       	ror	edx, cl
1803cd7e2: d3 ca                       	ror	edx, cl
1803cd7e4: 41 be 6f 25 b4 1d           	mov	r14d, 0x1db4256f
1803cd7ea: f7 d2                       	not	edx
1803cd7ec: 83 c0 0f                    	add	eax, 0xf
1803cd7ef: 89 c1                       	mov	ecx, eax
1803cd7f1: d3 c2                       	rol	edx, cl
1803cd7f3: 48 63 c2                    	movsxd	rax, edx
1803cd7f6: 48 8d 8d 18 04 00 00        	lea	rcx, [rbp + 0x418]
1803cd7fd: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cd804: 4c 8d 05 65 04 3f 00        	lea	r8, [rip + 0x3f0465]    # 0x1807bdc70
1803cd80b: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
1803cd80f: 48 89 b5 90 02 00 00        	mov	qword ptr [rbp + 0x290], rsi
1803cd816: 8b 0d 38 33 4c 00           	mov	ecx, dword ptr [rip + 0x4c3338] # 0x180890b54
1803cd81c: 83 c1 02                    	add	ecx, 0x2
1803cd81f: d3 cb                       	ror	ebx, cl
1803cd821: 89 d8                       	mov	eax, ebx
1803cd823: f7 d8                       	neg	eax
1803cd825: 48 98                       	cdqe
1803cd827: 48 8d 0d a2 62 3f 00        	lea	rcx, [rip + 0x3f62a2]   # 0x1807c3ad0
1803cd82e: 8b 04 81                    	mov	eax, dword ptr [rcx + 4*rax]
1803cd831: 41 29 de                    	sub	r14d, ebx
1803cd834: 44 89 f1                    	mov	ecx, r14d
1803cd837: d3 c8                       	ror	eax, cl
1803cd839: d3 c8                       	ror	eax, cl
1803cd83b: f7 d0                       	not	eax
1803cd83d: 83 c3 0f                    	add	ebx, 0xf
1803cd840: 89 d9                       	mov	ecx, ebx
1803cd842: d3 c0                       	rol	eax, cl
1803cd844: 48 98                       	cdqe
1803cd846: 48 8d 8d 18 04 00 00        	lea	rcx, [rbp + 0x418]
1803cd84d: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cd854: 4c 8d 05 15 04 3f 00        	lea	r8, [rip + 0x3f0415]    # 0x1807bdc70
1803cd85b: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
1803cd85f: 48 89 bd 90 02 00 00        	mov	qword ptr [rbp + 0x290], rdi
1803cd866: 8b 0d e8 32 4c 00           	mov	ecx, dword ptr [rip + 0x4c32e8] # 0x180890b54
1803cd86c: 83 c1 02                    	add	ecx, 0x2
1803cd86f: b8 a7 f0 ff ff              	mov	eax, 0xfffff0a7
1803cd874: d3 c8                       	ror	eax, cl
1803cd876: 89 c1                       	mov	ecx, eax
1803cd878: f7 d9                       	neg	ecx
1803cd87a: 48 63 c9                    	movsxd	rcx, ecx
1803cd87d: 48 8d 15 4c 62 3f 00        	lea	rdx, [rip + 0x3f624c]   # 0x1807c3ad0
1803cd884: 8b 14 8a                    	mov	edx, dword ptr [rdx + 4*rcx]
1803cd887: b9 6f 25 b4 1d              	mov	ecx, 0x1db4256f
1803cd88c: 29 c1                       	sub	ecx, eax
1803cd88e: d3 ca                       	ror	edx, cl
1803cd890: d3 ca                       	ror	edx, cl
1803cd892: f7 d2                       	not	edx
1803cd894: 83 c0 0f                    	add	eax, 0xf
1803cd897: 89 c1                       	mov	ecx, eax
1803cd899: d3 c2                       	rol	edx, cl
1803cd89b: 48 63 c2                    	movsxd	rax, edx
1803cd89e: 48 8d 8d 18 04 00 00        	lea	rcx, [rbp + 0x418]
1803cd8a5: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cd8ac: 4c 8d 05 bd 03 3f 00        	lea	r8, [rip + 0x3f03bd]    # 0x1807bdc70
1803cd8b3: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
1803cd8b7: 48 8b 85 e8 05 00 00        	mov	rax, qword ptr [rbp + 0x5e8]
1803cd8be: 48 8d 88 f8 01 00 00        	lea	rcx, [rax + 0x1f8]
1803cd8c5: 48 89 8d 90 02 00 00        	mov	qword ptr [rbp + 0x290], rcx
1803cd8cc: 8b 05 26 32 4c 00           	mov	eax, dword ptr [rip + 0x4c3226] # 0x180890af8
1803cd8d2: 31 c0                       	xor	eax, eax
1803cd8d4: 2b 05 9a 71 3f 00           	sub	eax, dword ptr [rip + 0x3f719a] # 0x1807c4a74
1803cd8da: c1 c0 0f                    	rol	eax, 0xf
1803cd8dd: f7 d8                       	neg	eax
1803cd8df: c1 c0 1e                    	rol	eax, 0x1e
1803cd8e2: f7 d8                       	neg	eax
1803cd8e4: c1 c0 0f                    	rol	eax, 0xf
1803cd8e7: f7 d8                       	neg	eax
1803cd8e9: 48 98                       	cdqe
1803cd8eb: 48 8d 15 7e 03 3f 00        	lea	rdx, [rip + 0x3f037e]   # 0x1807bdc70
1803cd8f2: ff 14 c2                    	call	qword ptr [rdx + 8*rax]
1803cd8f5: 48 63 05 2c e9 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe92c] # 0x1807cc228
1803cd8fc: be 35 b9 e5 b0              	mov	esi, 0xb0e5b935
1803cd901: 48 8d 3d f8 f3 28 00        	lea	rdi, [rip + 0x28f3f8]   # 0x18065cd00
1803cd908: 8b 0c 87                    	mov	ecx, dword ptr [rdi + 4*rax]
1803cd90b: 31 f1                       	xor	ecx, esi
1803cd90d: 8d 41 01                    	lea	eax, [rcx + 0x1]
1803cd910: 48 98                       	cdqe
1803cd912: 4c 8d 2d b7 61 3f 00        	lea	r13, [rip + 0x3f61b7]   # 0x1807c3ad0
1803cd919: 41 8b 44 85 00              	mov	eax, dword ptr [r13 + 4*rax]
1803cd91e: 0f c8                       	bswap	eax
1803cd920: 81 c1 d3 b3 92 bf           	add	ecx, 0xbf92b3d3
1803cd926: d3 c8                       	ror	eax, cl
1803cd928: 35 2d 4c 6d 40              	xor	eax, 0x406d4c2d
1803cd92d: d3 c8                       	ror	eax, cl
1803cd92f: 48 8b 9d e8 05 00 00        	mov	rbx, qword ptr [rbp + 0x5e8]
1803cd936: 48 8d 4b 48                 	lea	rcx, [rbx + 0x48]
1803cd93a: f7 d8                       	neg	eax
1803cd93c: 48 98                       	cdqe
1803cd93e: 4c 8d 25 2b 03 3f 00        	lea	r12, [rip + 0x3f032b]   # 0x1807bdc70
1803cd945: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803cd949: 41 be 31 1d 6a 07           	mov	r14d, 0x76a1d31
1803cd94f: 4c 8d 3d 1a 76 3e 00        	lea	r15, [rip + 0x3e761a]   # 0x1807b4f70
1803cd956: 84 c0                       	test	al, al
1803cd958: 75 41                       	jne	0x1803cd99b <.text+0x3bd99b>
1803cd95a: 48 63 05 a7 e8 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe8a7] # 0x1807cc208
1803cd961: 33 34 87                    	xor	esi, dword ptr [rdi + 4*rax]
1803cd964: 8d 46 01                    	lea	eax, [rsi + 0x1]
1803cd967: 48 98                       	cdqe
1803cd969: 41 8b 44 85 00              	mov	eax, dword ptr [r13 + 4*rax]
1803cd96e: 0f c8                       	bswap	eax
1803cd970: 81 c6 d3 b3 92 bf           	add	esi, 0xbf92b3d3
1803cd976: 89 f1                       	mov	ecx, esi
1803cd978: d3 c8                       	ror	eax, cl
1803cd97a: 35 2d 4c 6d 40              	xor	eax, 0x406d4c2d
1803cd97f: d3 c8                       	ror	eax, cl
1803cd981: 48 8d b3 e8 00 00 00        	lea	rsi, [rbx + 0xe8]
1803cd988: f7 d8                       	neg	eax
1803cd98a: 48 98                       	cdqe
1803cd98c: 48 89 f1                    	mov	rcx, rsi
1803cd98f: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803cd993: 84 c0                       	test	al, al
1803cd995: 0f 84 3e 37 00 00           	je	0x1803d10d9 <.text+0x3c10d9>
1803cd99b: bb 00 04 be 49              	mov	ebx, 0x49be0400
1803cd9a0: 45 33 37                    	xor	r14d, dword ptr [r15]
1803cd9a3: 48 63 05 62 e8 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe862] # 0x1807cc20c
1803cd9aa: 48 8d 35 4f f3 28 00        	lea	rsi, [rip + 0x28f34f]   # 0x18065cd00
1803cd9b1: 8b 14 86                    	mov	edx, dword ptr [rsi + 4*rax]
1803cd9b4: 0f ca                       	bswap	edx
1803cd9b6: 8d 48 08                    	lea	ecx, [rax + 0x8]
1803cd9b9: d3 ca                       	ror	edx, cl
1803cd9bb: 0f ca                       	bswap	edx
1803cd9bd: b9 08 00 00 00              	mov	ecx, 0x8
1803cd9c2: 29 c1                       	sub	ecx, eax
1803cd9c4: d3 c2                       	rol	edx, cl
1803cd9c6: 48 63 c2                    	movsxd	rax, edx
1803cd9c9: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803cd9ce: b9 18 00 00 00              	mov	ecx, 0x18
1803cd9d3: 29 c1                       	sub	ecx, eax
1803cd9d5: d3 c2                       	rol	edx, cl
1803cd9d7: 81 f2 18 ce b6 a8           	xor	edx, 0xa8b6ce18
1803cd9dd: 0f ca                       	bswap	edx
1803cd9df: 83 c0 18                    	add	eax, 0x18
1803cd9e2: 89 c1                       	mov	ecx, eax
1803cd9e4: d3 ca                       	ror	edx, cl
1803cd9e6: 48 63 c2                    	movsxd	rax, edx
1803cd9e9: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cd9f0: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803cd9f4: 45 31 ff                    	xor	r15d, r15d
1803cd9f7: b8 00 00 00 00              	mov	eax, 0x0
1803cd9fc: 41 39 de                    	cmp	r14d, ebx
1803cd9ff: 0f 85 e3 3b 00 00           	jne	0x1803d15e8 <.text+0x3c15e8>
1803cda05: 41 b8 c0 1a 72 fb           	mov	r8d, 0xfb721ac0
1803cda0b: 44 33 05 9a 76 3e 00        	xor	r8d, dword ptr [rip + 0x3e769a] # 0x1807b50ac
1803cda12: 41 81 c0 33 44 ee 60        	add	r8d, 0x60ee4433
1803cda19: 41 b9 fa 68 fa 4a           	mov	r9d, 0x4afa68fa
1803cda1f: 44 33 0d 8a 76 3e 00        	xor	r9d, dword ptr [rip + 0x3e768a] # 0x1807b50b0
1803cda26: 41 81 c1 cb 86 18 d2        	add	r9d, 0xd21886cb
1803cda2d: 8b 05 45 52 4c 00           	mov	eax, dword ptr [rip + 0x4c5245] # 0x180892c78
1803cda33: b8 6e 09 11 d0              	mov	eax, 0xd011096e
1803cda38: 33 05 0e 84 3f 00           	xor	eax, dword ptr [rip + 0x3f840e] # 0x1807c5e4c
1803cda3e: c1 c0 13                    	rol	eax, 0x13
1803cda41: ff c8                       	dec	eax
1803cda43: 0f c8                       	bswap	eax
1803cda45: f7 d8                       	neg	eax
1803cda47: c1 c0 1e                    	rol	eax, 0x1e
1803cda4a: 48 98                       	cdqe
1803cda4c: 48 8d 15 2d 58 4c 00        	lea	rdx, [rip + 0x4c582d]   # 0x180893280
1803cda53: 48 8d 4d 58                 	lea	rcx, [rbp + 0x58]
1803cda57: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803cda5b: 48 63 15 ba e7 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fe7ba] # 0x1807cc21c
1803cda62: be 9c dd 1e 78              	mov	esi, 0x781edd9c
1803cda67: 4c 8d 35 92 f2 28 00        	lea	r14, [rip + 0x28f292]   # 0x18065cd00
1803cda6e: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803cda72: 31 f0                       	xor	eax, esi
1803cda74: 8d 4a 1c                    	lea	ecx, [rdx + 0x1c]
1803cda77: d3 c8                       	ror	eax, cl
1803cda79: b9 1c 00 00 00              	mov	ecx, 0x1c
1803cda7e: 29 d1                       	sub	ecx, edx
1803cda80: d3 c0                       	rol	eax, cl
1803cda82: 89 c1                       	mov	ecx, eax
1803cda84: f7 d1                       	not	ecx
1803cda86: 48 63 c9                    	movsxd	rcx, ecx
1803cda89: 31 d2                       	xor	edx, edx
1803cda8b: 48 8d 3d 3e 60 3f 00        	lea	rdi, [rip + 0x3f603e]   # 0x1807c3ad0
1803cda92: 2b 14 8f                    	sub	edx, dword ptr [rdi + 4*rcx]
1803cda95: 81 f2 8b c2 17 e7           	xor	edx, 0xe717c28b
1803cda9b: 0f ca                       	bswap	edx
1803cda9d: 05 8c c2 17 e7              	add	eax, 0xe717c28c
1803cdaa2: 89 c1                       	mov	ecx, eax
1803cdaa4: d3 c2                       	rol	edx, cl
1803cdaa6: d3 c2                       	rol	edx, cl
1803cdaa8: 81 f2 8b c2 17 e7           	xor	edx, 0xe717c28b
1803cdaae: 48 63 c2                    	movsxd	rax, edx
1803cdab1: 4c 8b bd e0 05 00 00        	mov	r15, qword ptr [rbp + 0x5e0]
1803cdab8: 4c 89 f9                    	mov	rcx, r15
1803cdabb: 48 8d 1d ae 01 3f 00        	lea	rbx, [rip + 0x3f01ae]   # 0x1807bdc70
1803cdac2: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cdac5: 48 63 15 30 e7 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fe730] # 0x1807cc1fc
1803cdacc: 45 8b 04 96                 	mov	r8d, dword ptr [r14 + 4*rdx]
1803cdad0: 8d 4a 0f                    	lea	ecx, [rdx + 0xf]
1803cdad3: 41 d3 c8                    	ror	r8d, cl
1803cdad6: 41 f7 d8                    	neg	r8d
1803cdad9: 41 81 f0 af a6 6d b8        	xor	r8d, 0xb86da6af
1803cdae0: b9 0f 00 00 00              	mov	ecx, 0xf
1803cdae5: 29 d1                       	sub	ecx, edx
1803cdae7: 41 d3 c0                    	rol	r8d, cl
1803cdaea: 49 63 d0                    	movsxd	rdx, r8d
1803cdaed: 44 8b 04 97                 	mov	r8d, dword ptr [rdi + 4*rdx]
1803cdaf1: 8d 4a 04                    	lea	ecx, [rdx + 0x4]
1803cdaf4: 41 d3 c8                    	ror	r8d, cl
1803cdaf7: 48 89 c7                    	mov	rdi, rax
1803cdafa: 41 0f c8                    	bswap	r8d
1803cdafd: b9 04 00 00 00              	mov	ecx, 0x4
1803cdb02: 29 d1                       	sub	ecx, edx
1803cdb04: 41 d3 c0                    	rol	r8d, cl
1803cdb07: 41 0f c8                    	bswap	r8d
1803cdb0a: 49 63 c0                    	movsxd	rax, r8d
1803cdb0d: 4c 89 f9                    	mov	rcx, r15
1803cdb10: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cdb13: 48 ba 42 81 b2 59 cb fe 8a 72       	movabs	rdx, 0x728afecb59b28142
1803cdb1d: 48 33 15 3c 74 3e 00        	xor	rdx, qword ptr [rip + 0x3e743c] # 0x1807b4f60
1803cdb24: 48 63 0d a9 99 3e 00        	movsxd	rcx, dword ptr [rip + 0x3e99a9] # 0x1807b74d4
1803cdb2b: 4c 8d 05 fe a6 28 00        	lea	r8, [rip + 0x28a6fe]    # 0x180658230
1803cdb32: 45 8b 04 88                 	mov	r8d, dword ptr [r8 + 4*rcx]
1803cdb36: 41 d3 c8                    	ror	r8d, cl
1803cdb39: 41 0f c8                    	bswap	r8d
1803cdb3c: 41 f7 d8                    	neg	r8d
1803cdb3f: 41 81 f0 e0 14 91 5e        	xor	r8d, 0x5e9114e0
1803cdb46: 49 63 c8                    	movsxd	rcx, r8d
1803cdb49: 4c 8d 05 30 8e 3e 00        	lea	r8, [rip + 0x3e8e30]    # 0x1807b6980
1803cdb50: 45 8b 04 88                 	mov	r8d, dword ptr [r8 + 4*rcx]
1803cdb54: 81 c1 b8 aa 3b 79           	add	ecx, 0x793baab8
1803cdb5a: 41 d3 c8                    	ror	r8d, cl
1803cdb5d: 49 ba c9 7a b6 22 60 32 d3 c3       	movabs	r10, -0x3c2ccd9fdd498537
1803cdb67: 41 f7 d8                    	neg	r8d
1803cdb6a: 41 0f c8                    	bswap	r8d
1803cdb6d: 41 d3 c8                    	ror	r8d, cl
1803cdb70: 49 01 d2                    	add	r10, rdx
1803cdb73: 49 63 c8                    	movsxd	rcx, r8d
1803cdb76: 48 8d 15 53 82 3e 00        	lea	rdx, [rip + 0x3e8253]   # 0x1807b5dd0
1803cdb7d: 4c 8b 0c ca                 	mov	r9, qword ptr [rdx + 8*rcx]
1803cdb81: 4c 89 54 24 20              	mov	qword ptr [rsp + 0x20], r10
1803cdb86: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cdb8d: 48 89 c2                    	mov	rdx, rax
1803cdb90: 49 89 f8                    	mov	r8, rdi
1803cdb93: e8 b8 7d 06 00              	call	0x180435950 <.text+0x425950>
1803cdb98: 48 63 15 b1 e6 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fe6b1] # 0x1807cc250
1803cdb9f: 48 8d 1d 5a f1 28 00        	lea	rbx, [rip + 0x28f15a]   # 0x18065cd00
1803cdba6: 8b 04 93                    	mov	eax, dword ptr [rbx + 4*rdx]
1803cdba9: 41 b8 30 37 6d 22           	mov	r8d, 0x226d3730
1803cdbaf: 41 29 d0                    	sub	r8d, edx
1803cdbb2: 44 89 c1                    	mov	ecx, r8d
1803cdbb5: d3 c0                       	rol	eax, cl
1803cdbb7: 83 f2 10                    	xor	edx, 0x10
1803cdbba: 89 d1                       	mov	ecx, edx
1803cdbbc: d3 c8                       	ror	eax, cl
1803cdbbe: 44 89 c1                    	mov	ecx, r8d
1803cdbc1: d3 c0                       	rol	eax, cl
1803cdbc3: 89 c1                       	mov	ecx, eax
1803cdbc5: f7 d9                       	neg	ecx
1803cdbc7: 48 63 c9                    	movsxd	rcx, ecx
1803cdbca: 4c 8d 2d ff 5e 3f 00        	lea	r13, [rip + 0x3f5eff]   # 0x1807c3ad0
1803cdbd1: 45 8b 44 8d 00              	mov	r8d, dword ptr [r13 + 4*rcx]
1803cdbd6: 41 0f c8                    	bswap	r8d
1803cdbd9: ba 28 57 c4 2e              	mov	edx, 0x2ec45728
1803cdbde: 29 c2                       	sub	edx, eax
1803cdbe0: 89 d1                       	mov	ecx, edx
1803cdbe2: 41 d3 c8                    	ror	r8d, cl
1803cdbe5: 05 28 57 c4 2e              	add	eax, 0x2ec45728
1803cdbea: 89 c1                       	mov	ecx, eax
1803cdbec: 41 d3 c0                    	rol	r8d, cl
1803cdbef: 89 d1                       	mov	ecx, edx
1803cdbf1: 41 d3 c8                    	ror	r8d, cl
1803cdbf4: 41 81 f0 d7 a8 3b d1        	xor	r8d, 0xd13ba8d7
1803cdbfb: 41 ff c0                    	inc	r8d
1803cdbfe: 89 c1                       	mov	ecx, eax
1803cdc00: 41 d3 c0                    	rol	r8d, cl
1803cdc03: bf 30 37 6d 22              	mov	edi, 0x226d3730
1803cdc08: 41 bc 28 57 c4 2e           	mov	r12d, 0x2ec45728
1803cdc0e: 41 f7 d0                    	not	r8d
1803cdc11: 49 63 c0                    	movsxd	rax, r8d
1803cdc14: 48 8d 8d c0 00 00 00        	lea	rcx, [rbp + 0xc0]
1803cdc1b: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cdc22: 4c 8d 35 47 00 3f 00        	lea	r14, [rip + 0x3f0047]   # 0x1807bdc70
1803cdc29: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cdc2d: 48 63 15 b8 e5 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fe5b8] # 0x1807cc1ec
1803cdc34: 8b 04 93                    	mov	eax, dword ptr [rbx + 4*rdx]
1803cdc37: b9 13 00 00 00              	mov	ecx, 0x13
1803cdc3c: 29 d1                       	sub	ecx, edx
1803cdc3e: d3 c0                       	rol	eax, cl
1803cdc40: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803cdc45: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803cdc4a: 29 c1                       	sub	ecx, eax
1803cdc4c: 48 63 c9                    	movsxd	rcx, ecx
1803cdc4f: 31 d2                       	xor	edx, edx
1803cdc51: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803cdc56: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803cdc5b: 29 c1                       	sub	ecx, eax
1803cdc5d: d3 ca                       	ror	edx, cl
1803cdc5f: d3 ca                       	ror	edx, cl
1803cdc61: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803cdc67: d3 ca                       	ror	edx, cl
1803cdc69: 41 bf ce 45 48 92           	mov	r15d, 0x924845ce
1803cdc6f: 05 d2 45 48 92              	add	eax, 0x924845d2
1803cdc74: 89 c1                       	mov	ecx, eax
1803cdc76: d3 c2                       	rol	edx, cl
1803cdc78: d3 c2                       	rol	edx, cl
1803cdc7a: 48 63 c2                    	movsxd	rax, edx
1803cdc7d: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cdc84: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cdc88: 48 63 05 89 e5 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe589] # 0x1807cc218
1803cdc8f: 33 34 83                    	xor	esi, dword ptr [rbx + 4*rax]
1803cdc92: 8d 48 1c                    	lea	ecx, [rax + 0x1c]
1803cdc95: d3 ce                       	ror	esi, cl
1803cdc97: b9 1c 00 00 00              	mov	ecx, 0x1c
1803cdc9c: 29 c1                       	sub	ecx, eax
1803cdc9e: d3 c6                       	rol	esi, cl
1803cdca0: 89 f0                       	mov	eax, esi
1803cdca2: f7 d0                       	not	eax
1803cdca4: 48 98                       	cdqe
1803cdca6: 31 d2                       	xor	edx, edx
1803cdca8: 41 2b 54 85 00              	sub	edx, dword ptr [r13 + 4*rax]
1803cdcad: 81 f2 8b c2 17 e7           	xor	edx, 0xe717c28b
1803cdcb3: 0f ca                       	bswap	edx
1803cdcb5: 81 c6 8c c2 17 e7           	add	esi, 0xe717c28c
1803cdcbb: 89 f1                       	mov	ecx, esi
1803cdcbd: d3 c2                       	rol	edx, cl
1803cdcbf: d3 c2                       	rol	edx, cl
1803cdcc1: 81 f2 8b c2 17 e7           	xor	edx, 0xe717c28b
1803cdcc7: 48 63 c2                    	movsxd	rax, edx
1803cdcca: 48 8b 9d e0 05 00 00        	mov	rbx, qword ptr [rbp + 0x5e0]
1803cdcd1: 48 89 d9                    	mov	rcx, rbx
1803cdcd4: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cdcd8: 48 63 15 09 e5 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fe509] # 0x1807cc1e8
1803cdcdf: 48 8d 0d 1a f0 28 00        	lea	rcx, [rip + 0x28f01a]   # 0x18065cd00
1803cdce6: 44 8b 04 91                 	mov	r8d, dword ptr [rcx + 4*rdx]
1803cdcea: 8d 4a 0f                    	lea	ecx, [rdx + 0xf]
1803cdced: 41 d3 c8                    	ror	r8d, cl
1803cdcf0: 41 f7 d8                    	neg	r8d
1803cdcf3: 41 81 f0 af a6 6d b8        	xor	r8d, 0xb86da6af
1803cdcfa: b9 0f 00 00 00              	mov	ecx, 0xf
1803cdcff: 29 d1                       	sub	ecx, edx
1803cdd01: 41 d3 c0                    	rol	r8d, cl
1803cdd04: 49 63 d0                    	movsxd	rdx, r8d
1803cdd07: 45 8b 44 95 00              	mov	r8d, dword ptr [r13 + 4*rdx]
1803cdd0c: 8d 4a 04                    	lea	ecx, [rdx + 0x4]
1803cdd0f: 41 d3 c8                    	ror	r8d, cl
1803cdd12: 41 0f c8                    	bswap	r8d
1803cdd15: b9 04 00 00 00              	mov	ecx, 0x4
1803cdd1a: 29 d1                       	sub	ecx, edx
1803cdd1c: 41 d3 c0                    	rol	r8d, cl
1803cdd1f: 48 89 c6                    	mov	rsi, rax
1803cdd22: 41 0f c8                    	bswap	r8d
1803cdd25: 49 63 c0                    	movsxd	rax, r8d
1803cdd28: 48 89 d9                    	mov	rcx, rbx
1803cdd2b: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cdd2f: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cdd36: 48 89 c2                    	mov	rdx, rax
1803cdd39: 49 89 f0                    	mov	r8, rsi
1803cdd3c: e8 6f d0 f4 ff              	call	0x18031adb0 <.text+0x30adb0>
1803cdd41: 48 63 15 10 e5 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fe510] # 0x1807cc258
1803cdd48: 4c 8d 35 b1 ef 28 00        	lea	r14, [rip + 0x28efb1]   # 0x18065cd00
1803cdd4f: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803cdd53: 29 d7                       	sub	edi, edx
1803cdd55: 89 f9                       	mov	ecx, edi
1803cdd57: d3 c0                       	rol	eax, cl
1803cdd59: 83 f2 10                    	xor	edx, 0x10
1803cdd5c: 89 d1                       	mov	ecx, edx
1803cdd5e: d3 c8                       	ror	eax, cl
1803cdd60: 89 f9                       	mov	ecx, edi
1803cdd62: d3 c0                       	rol	eax, cl
1803cdd64: 89 c1                       	mov	ecx, eax
1803cdd66: f7 d9                       	neg	ecx
1803cdd68: 48 63 c9                    	movsxd	rcx, ecx
1803cdd6b: 48 8d 3d 5e 5d 3f 00        	lea	rdi, [rip + 0x3f5d5e]   # 0x1807c3ad0
1803cdd72: 8b 14 8f                    	mov	edx, dword ptr [rdi + 4*rcx]
1803cdd75: 0f ca                       	bswap	edx
1803cdd77: 41 29 c4                    	sub	r12d, eax
1803cdd7a: 44 89 e1                    	mov	ecx, r12d
1803cdd7d: d3 ca                       	ror	edx, cl
1803cdd7f: 05 28 57 c4 2e              	add	eax, 0x2ec45728
1803cdd84: 89 c1                       	mov	ecx, eax
1803cdd86: d3 c2                       	rol	edx, cl
1803cdd88: 44 89 e1                    	mov	ecx, r12d
1803cdd8b: d3 ca                       	ror	edx, cl
1803cdd8d: 81 f2 d7 a8 3b d1           	xor	edx, 0xd13ba8d7
1803cdd93: ff c2                       	inc	edx
1803cdd95: 89 c1                       	mov	ecx, eax
1803cdd97: d3 c2                       	rol	edx, cl
1803cdd99: f7 d2                       	not	edx
1803cdd9b: 48 63 c2                    	movsxd	rax, edx
1803cdd9e: 48 8d 8d c0 01 00 00        	lea	rcx, [rbp + 0x1c0]
1803cdda5: 4c 8d a5 90 02 00 00        	lea	r12, [rbp + 0x290]
1803cddac: 4c 89 e2                    	mov	rdx, r12
1803cddaf: 48 8d 1d ba fe 3e 00        	lea	rbx, [rip + 0x3efeba]   # 0x1807bdc70
1803cddb6: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cddb9: 48 63 15 40 e4 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fe440] # 0x1807cc200
1803cddc0: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803cddc4: b9 13 00 00 00              	mov	ecx, 0x13
1803cddc9: 29 d1                       	sub	ecx, edx
1803cddcb: d3 c0                       	rol	eax, cl
1803cddcd: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803cddd2: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803cddd7: 29 c1                       	sub	ecx, eax
1803cddd9: 48 63 c9                    	movsxd	rcx, ecx
1803cdddc: 31 d2                       	xor	edx, edx
1803cddde: 2b 14 8f                    	sub	edx, dword ptr [rdi + 4*rcx]
1803cdde1: 41 29 c7                    	sub	r15d, eax
1803cdde4: 44 89 f9                    	mov	ecx, r15d
1803cdde7: d3 ca                       	ror	edx, cl
1803cdde9: d3 ca                       	ror	edx, cl
1803cddeb: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803cddf1: d3 ca                       	ror	edx, cl
1803cddf3: 31 f6                       	xor	esi, esi
1803cddf5: 05 d2 45 48 92              	add	eax, 0x924845d2
1803cddfa: 89 c1                       	mov	ecx, eax
1803cddfc: d3 c2                       	rol	edx, cl
1803cddfe: d3 c2                       	rol	edx, cl
1803cde00: 48 63 c2                    	movsxd	rax, edx
1803cde03: 4c 89 e1                    	mov	rcx, r12
1803cde06: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cde09: 48 63 05 68 e4 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe468] # 0x1807cc278
1803cde10: 41 2b 34 86                 	sub	esi, dword ptr [r14 + 4*rax]
1803cde14: 81 f6 93 e6 aa 2d           	xor	esi, 0x2daae693
1803cde1a: 8d 48 13                    	lea	ecx, [rax + 0x13]
1803cde1d: d3 ce                       	ror	esi, cl
1803cde1f: 89 f0                       	mov	eax, esi
1803cde21: f7 d0                       	not	eax
1803cde23: 48 98                       	cdqe
1803cde25: 8b 04 87                    	mov	eax, dword ptr [rdi + 4*rax]
1803cde28: ff c8                       	dec	eax
1803cde2a: 0f c8                       	bswap	eax
1803cde2c: b9 83 fa 80 c0              	mov	ecx, 0xc080fa83
1803cde31: 29 f1                       	sub	ecx, esi
1803cde33: d3 c8                       	ror	eax, cl
1803cde35: d3 c8                       	ror	eax, cl
1803cde37: 35 7b 05 7f 3f              	xor	eax, 0x3f7f057b
1803cde3c: d3 c8                       	ror	eax, cl
1803cde3e: 48 98                       	cdqe
1803cde40: 48 8d b5 80 03 00 00        	lea	rsi, [rbp + 0x380]
1803cde47: 48 89 f1                    	mov	rcx, rsi
1803cde4a: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cde4d: 48 63 05 b0 e3 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe3b0] # 0x1807cc204
1803cde54: 45 8b 04 86                 	mov	r8d, dword ptr [r14 + 4*rax]
1803cde58: 41 0f c8                    	bswap	r8d
1803cde5b: 8d 48 04                    	lea	ecx, [rax + 0x4]
1803cde5e: 41 d3 c8                    	ror	r8d, cl
1803cde61: b9 04 00 00 00              	mov	ecx, 0x4
1803cde66: 29 c1                       	sub	ecx, eax
1803cde68: 41 d3 c0                    	rol	r8d, cl
1803cde6b: 41 8d 80 8e 1e df aa        	lea	eax, [r8 - 0x5520e172]
1803cde72: ba 8c 1e df aa              	mov	edx, 0xaadf1e8c
1803cde77: 44 29 c2                    	sub	edx, r8d
1803cde7a: 44 89 c1                    	mov	ecx, r8d
1803cde7d: f7 d1                       	not	ecx
1803cde7f: 48 63 c9                    	movsxd	rcx, ecx
1803cde82: 44 8b 04 8f                 	mov	r8d, dword ptr [rdi + 4*rcx]
1803cde86: 41 f7 d0                    	not	r8d
1803cde89: 89 c1                       	mov	ecx, eax
1803cde8b: 41 d3 c0                    	rol	r8d, cl
1803cde8e: 89 d1                       	mov	ecx, edx
1803cde90: 41 d3 c8                    	ror	r8d, cl
1803cde93: 89 c1                       	mov	ecx, eax
1803cde95: 41 d3 c0                    	rol	r8d, cl
1803cde98: 41 d3 c0                    	rol	r8d, cl
1803cde9b: 41 f7 d0                    	not	r8d
1803cde9e: 41 d3 c0                    	rol	r8d, cl
1803cdea1: 89 d1                       	mov	ecx, edx
1803cdea3: 41 d3 c8                    	ror	r8d, cl
1803cdea6: 49 63 c0                    	movsxd	rax, r8d
1803cdea9: 48 89 f1                    	mov	rcx, rsi
1803cdeac: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cdeaf: 48 89 85 f8 04 00 00        	mov	qword ptr [rbp + 0x4f8], rax
1803cdeb6: 8b 0d 5c 26 4c 00           	mov	ecx, dword ptr [rip + 0x4c265c] # 0x180890518
1803cdebc: 83 c1 18                    	add	ecx, 0x18
1803cdebf: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803cdec4: d3 c8                       	ror	eax, cl
1803cdec6: 48 98                       	cdqe
1803cdec8: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
1803cdecb: b9 07 00 00 00              	mov	ecx, 0x7
1803cded0: 29 c1                       	sub	ecx, eax
1803cded2: d3 c2                       	rol	edx, cl
1803cded4: 0f ca                       	bswap	edx
1803cded6: 48 63 c2                    	movsxd	rax, edx
1803cded9: 48 8b 04 c3                 	mov	rax, qword ptr [rbx + 8*rax]
1803cdedd: c6 85 fd 05 00 00 01        	mov	byte ptr [rbp + 0x5fd], 0x1
1803cdee4: 4c 89 a5 e8 03 00 00        	mov	qword ptr [rbp + 0x3e8], r12
1803cdeeb: 48 8d b5 10 02 00 00        	lea	rsi, [rbp + 0x210]
1803cdef2: 48 8d 95 f8 04 00 00        	lea	rdx, [rbp + 0x4f8]
1803cdef9: 48 89 f1                    	mov	rcx, rsi
1803cdefc: ff d0                       	call	rax
1803cdefe: 48 c7 85 20 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x220], 0x0
1803cdf09: 48 63 05 44 e3 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe344] # 0x1807cc254
1803cdf10: 48 8d 0d e9 ed 28 00        	lea	rcx, [rip + 0x28ede9]   # 0x18065cd00
1803cdf17: 48 63 04 81                 	movsxd	rax, dword ptr [rcx + 4*rax]
1803cdf1b: 48 35 40 1f e4 dc           	xor	rax, -0x231be0c0
1803cdf21: 48 8d 3d a8 5b 3f 00        	lea	rdi, [rip + 0x3f5ba8]   # 0x1807c3ad0
1803cdf28: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
1803cdf2b: f7 d2                       	not	edx
1803cdf2d: 8d 88 94 64 58 87           	lea	ecx, [rax - 0x78a79b6c]
1803cdf33: d3 ca                       	ror	edx, cl
1803cdf35: d3 ca                       	ror	edx, cl
1803cdf37: f7 da                       	neg	edx
1803cdf39: d3 ca                       	ror	edx, cl
1803cdf3b: 48 8d 8d 28 02 00 00        	lea	rcx, [rbp + 0x228]
1803cdf42: 0f ca                       	bswap	edx
1803cdf44: 48 63 c2                    	movsxd	rax, edx
1803cdf47: 48 8d 15 93 98 28 00        	lea	rdx, [rip + 0x289893]   # 0x1806577e1
1803cdf4e: 48 8d 1d 1b fd 3e 00        	lea	rbx, [rip + 0x3efd1b]   # 0x1807bdc70
1803cdf55: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cdf58: 48 b8 4f dc 4b bc 5c 45 4e 19       	movabs	rax, 0x194e455cbc4bdc4f
1803cdf62: 48 33 05 0f 70 3e 00        	xor	rax, qword ptr [rip + 0x3e700f] # 0x1807b4f78
1803cdf69: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cdf6d: 48 8d 04 c5 10 02 00 00     	lea	rax, [8*rax + 0x210]
1803cdf75: 48 01 e8                    	add	rax, rbp
1803cdf78: 48 b9 50 99 e4 c5 a9 19 b6 31       	movabs	rcx, 0x31b619a9c5e49950
1803cdf82: 48 01 c1                    	add	rcx, rax
1803cdf85: 48 89 b5 80 05 00 00        	mov	qword ptr [rbp + 0x580], rsi
1803cdf8c: 48 89 8d 88 05 00 00        	mov	qword ptr [rbp + 0x588], rcx
1803cdf93: 44 0f b6 0d 55 18 3e 00     	movzx	r9d, byte ptr [rip + 0x3e1855] # 0x1807af7f0
1803cdf9b: 41 80 f1 ea                 	xor	r9b, -0x16
1803cdf9f: 8b 0d 7b 25 4c 00           	mov	ecx, dword ptr [rip + 0x4c257b] # 0x180890520
1803cdfa5: ff c1                       	inc	ecx
1803cdfa7: b8 e2 08 00 00              	mov	eax, 0x8e2
1803cdfac: d3 c8                       	ror	eax, cl
1803cdfae: 48 63 c8                    	movsxd	rcx, eax
1803cdfb1: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803cdfb6: 33 04 8f                    	xor	eax, dword ptr [rdi + 4*rcx]
1803cdfb9: 41 80 c1 83                 	add	r9b, -0x7d
1803cdfbd: ff c8                       	dec	eax
1803cdfbf: 83 c1 0b                    	add	ecx, 0xb
1803cdfc2: d3 c8                       	ror	eax, cl
1803cdfc4: 0f c8                       	bswap	eax
1803cdfc6: 48 98                       	cdqe
1803cdfc8: 48 8b 04 c3                 	mov	rax, qword ptr [rbx + 8*rax]
1803cdfcc: c6 85 fe 05 00 00 01        	mov	byte ptr [rbp + 0x5fe], 0x1
1803cdfd3: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cdfda: 48 89 8d f0 03 00 00        	mov	qword ptr [rbp + 0x3f0], rcx
1803cdfe1: 4c 8d bd 80 05 00 00        	lea	r15, [rbp + 0x580]
1803cdfe8: 4c 89 fa                    	mov	rdx, r15
1803cdfeb: 41 b0 01                    	mov	r8b, 0x1
1803cdfee: ff d0                       	call	rax
1803cdff0: 4c 8b a5 e0 05 00 00        	mov	r12, qword ptr [rbp + 0x5e0]
1803cdff7: 48 c7 85 a0 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x2a0], 0x0
1803ce002: 48 63 05 5f e2 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe25f] # 0x1807cc268
1803ce009: 4c 8d 2d f0 ec 28 00        	lea	r13, [rip + 0x28ecf0]   # 0x18065cd00
1803ce010: 49 63 44 85 00              	movsxd	rax, dword ptr [r13 + 4*rax]
1803ce015: 48 35 95 89 db 80           	xor	rax, -0x7f24766b
1803ce01b: ba e2 a9 4d c5              	mov	edx, 0xc54da9e2
1803ce020: 48 8d 1d a9 5a 3f 00        	lea	rbx, [rip + 0x3f5aa9]   # 0x1807c3ad0
1803ce027: 33 14 83                    	xor	edx, dword ptr [rbx + 4*rax]
1803ce02a: 48 8d b5 a8 02 00 00        	lea	rsi, [rbp + 0x2a8]
1803ce031: 0f ca                       	bswap	edx
1803ce033: 8d 88 c5 4d a9 e2           	lea	ecx, [rax - 0x1d56b23b]
1803ce039: d3 ca                       	ror	edx, cl
1803ce03b: d3 ca                       	ror	edx, cl
1803ce03d: d3 ca                       	ror	edx, cl
1803ce03f: d3 ca                       	ror	edx, cl
1803ce041: 48 63 c2                    	movsxd	rax, edx
1803ce044: 48 8d 7d 70                 	lea	rdi, [rbp + 0x70]
1803ce048: 48 89 f9                    	mov	rcx, rdi
1803ce04b: 4c 8d 35 1e fc 3e 00        	lea	r14, [rip + 0x3efc1e]   # 0x1807bdc70
1803ce052: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce056: 48 63 05 b7 e1 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe1b7] # 0x1807cc214
1803ce05d: ba 5b 16 0a 3c              	mov	edx, 0x3c0a165b
1803ce062: 41 33 54 85 00              	xor	edx, dword ptr [r13 + 4*rax]
1803ce067: b9 1b 00 00 00              	mov	ecx, 0x1b
1803ce06c: 29 c1                       	sub	ecx, eax
1803ce06e: d3 c2                       	rol	edx, cl
1803ce070: 48 63 c2                    	movsxd	rax, edx
1803ce073: 8b 04 83                    	mov	eax, dword ptr [rbx + 4*rax]
1803ce076: f7 d0                       	not	eax
1803ce078: 0f c8                       	bswap	eax
1803ce07a: 48 98                       	cdqe
1803ce07c: 48 89 f9                    	mov	rcx, rdi
1803ce07f: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce083: 48 89 85 00 05 00 00        	mov	qword ptr [rbp + 0x500], rax
1803ce08a: 8b 0d 88 24 4c 00           	mov	ecx, dword ptr [rip + 0x4c2488] # 0x180890518
1803ce090: 83 c1 18                    	add	ecx, 0x18
1803ce093: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803ce098: d3 c8                       	ror	eax, cl
1803ce09a: 48 98                       	cdqe
1803ce09c: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803ce09f: b9 07 00 00 00              	mov	ecx, 0x7
1803ce0a4: 29 c1                       	sub	ecx, eax
1803ce0a6: d3 c2                       	rol	edx, cl
1803ce0a8: 0f ca                       	bswap	edx
1803ce0aa: 48 63 c2                    	movsxd	rax, edx
1803ce0ad: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803ce0b1: c6 85 0d 06 00 00 01        	mov	byte ptr [rbp + 0x60d], 0x1
1803ce0b8: c6 85 0c 06 00 00 00        	mov	byte ptr [rbp + 0x60c], 0x0
1803ce0bf: 4c 89 bd a8 04 00 00        	mov	qword ptr [rbp + 0x4a8], r15
1803ce0c6: 48 89 b5 a0 04 00 00        	mov	qword ptr [rbp + 0x4a0], rsi
1803ce0cd: 48 8d 95 00 05 00 00        	lea	rdx, [rbp + 0x500]
1803ce0d4: 4c 89 f9                    	mov	rcx, r15
1803ce0d7: ff d0                       	call	rax
1803ce0d9: 48 c7 85 90 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x590], 0x0
1803ce0e4: b9 08 00 00 00              	mov	ecx, 0x8
1803ce0e9: 2b 0d cd 2a 4c 00           	sub	ecx, dword ptr [rip + 0x4c2acd] # 0x180890bbc
1803ce0ef: b8 02 00 00 b5              	mov	eax, 0xb5000002
1803ce0f4: d3 c0                       	rol	eax, cl
1803ce0f6: 4c 8d 8d 98 05 00 00        	lea	r9, [rbp + 0x598]
1803ce0fd: 49 8d 54 24 18              	lea	rdx, [r12 + 0x18]
1803ce102: 48 98                       	cdqe
1803ce104: 41 b8 72 a1 71 7e           	mov	r8d, 0x7e71a172
1803ce10a: 48 8d 0d bf 59 3f 00        	lea	rcx, [rip + 0x3f59bf]   # 0x1807c3ad0
1803ce111: 44 33 04 81                 	xor	r8d, dword ptr [rcx + 4*rax]
1803ce115: b9 12 00 00 00              	mov	ecx, 0x12
1803ce11a: 29 c1                       	sub	ecx, eax
1803ce11c: 41 d3 c0                    	rol	r8d, cl
1803ce11f: 41 0f c8                    	bswap	r8d
1803ce122: 41 f7 d8                    	neg	r8d
1803ce125: 49 63 c0                    	movsxd	rax, r8d
1803ce128: 48 8d 0d 41 fb 3e 00        	lea	rcx, [rip + 0x3efb41]   # 0x1807bdc70
1803ce12f: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803ce133: c6 85 0d 06 00 00 01        	mov	byte ptr [rbp + 0x60d], 0x1
1803ce13a: c6 85 0c 06 00 00 00        	mov	byte ptr [rbp + 0x60c], 0x0
1803ce141: 4c 89 8d a8 04 00 00        	mov	qword ptr [rbp + 0x4a8], r9
1803ce148: 48 89 b5 a0 04 00 00        	mov	qword ptr [rbp + 0x4a0], rsi
1803ce14f: 4c 89 c9                    	mov	rcx, r9
1803ce152: ff d0                       	call	rax
1803ce154: 48 c7 85 a8 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x5a8], 0x0
1803ce15f: 48 b8 c8 3e bd 59 e9 27 6b 18       	movabs	rax, 0x186b27e959bd3ec8
1803ce169: 48 33 05 10 6e 3e 00        	xor	rax, qword ptr [rip + 0x3e6e10] # 0x1807b4f80
1803ce170: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803ce174: 48 8d 04 c5 80 05 00 00     	lea	rax, [8*rax + 0x580]
1803ce17c: 48 01 e8                    	add	rax, rbp
1803ce17f: 48 b9 20 40 eb a8 c9 69 93 e9       	movabs	rcx, -0x166c96365714bfe0
1803ce189: 48 01 c1                    	add	rcx, rax
1803ce18c: 48 8d 85 80 05 00 00        	lea	rax, [rbp + 0x580]
1803ce193: 48 89 85 b0 05 00 00        	mov	qword ptr [rbp + 0x5b0], rax
1803ce19a: 48 89 8d b8 05 00 00        	mov	qword ptr [rbp + 0x5b8], rcx
1803ce1a1: 44 0f b6 0d 47 16 3e 00     	movzx	r9d, byte ptr [rip + 0x3e1647] # 0x1807af7f0
1803ce1a9: 41 80 f1 ea                 	xor	r9b, -0x16
1803ce1ad: 8b 0d 6d 23 4c 00           	mov	ecx, dword ptr [rip + 0x4c236d] # 0x180890520
1803ce1b3: ff c1                       	inc	ecx
1803ce1b5: b8 e2 08 00 00              	mov	eax, 0x8e2
1803ce1ba: d3 c8                       	ror	eax, cl
1803ce1bc: 48 63 c8                    	movsxd	rcx, eax
1803ce1bf: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803ce1c4: 48 8d 15 05 59 3f 00        	lea	rdx, [rip + 0x3f5905]   # 0x1807c3ad0
1803ce1cb: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803ce1ce: 41 80 c1 83                 	add	r9b, -0x7d
1803ce1d2: ff c8                       	dec	eax
1803ce1d4: 83 c1 0b                    	add	ecx, 0xb
1803ce1d7: d3 c8                       	ror	eax, cl
1803ce1d9: 0f c8                       	bswap	eax
1803ce1db: 48 98                       	cdqe
1803ce1dd: 48 8d 0d 8c fa 3e 00        	lea	rcx, [rip + 0x3efa8c]   # 0x1807bdc70
1803ce1e4: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803ce1e8: c6 85 ff 05 00 00 01        	mov	byte ptr [rbp + 0x5ff], 0x1
1803ce1ef: 48 89 b5 f8 03 00 00        	mov	qword ptr [rbp + 0x3f8], rsi
1803ce1f6: 4c 8d ad b0 05 00 00        	lea	r13, [rbp + 0x5b0]
1803ce1fd: 48 89 f1                    	mov	rcx, rsi
1803ce200: 4c 89 ea                    	mov	rdx, r13
1803ce203: 41 b0 01                    	mov	r8b, 0x1
1803ce206: ff d0                       	call	rax
1803ce208: 48 c7 85 b8 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x2b8], 0x0
1803ce213: 48 63 05 5a e0 3f 00        	movsxd	rax, dword ptr [rip + 0x3fe05a] # 0x1807cc274
1803ce21a: b9 80 1b 96 21              	mov	ecx, 0x21961b80
1803ce21f: 48 8d 1d da ea 28 00        	lea	rbx, [rip + 0x28eada]   # 0x18065cd00
1803ce226: 33 0c 83                    	xor	ecx, dword ptr [rbx + 4*rax]
1803ce229: ff c9                       	dec	ecx
1803ce22b: 81 f1 80 1b 96 21           	xor	ecx, 0x21961b80
1803ce231: 48 63 c1                    	movsxd	rax, ecx
1803ce234: 4c 8d 3d 95 58 3f 00        	lea	r15, [rip + 0x3f5895]   # 0x1807c3ad0
1803ce23b: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803ce23f: 0f ca                       	bswap	edx
1803ce241: 8d 88 94 d6 0f 02           	lea	ecx, [rax + 0x20fd694]
1803ce247: d3 ca                       	ror	edx, cl
1803ce249: ff c2                       	inc	edx
1803ce24b: d3 ca                       	ror	edx, cl
1803ce24d: b9 94 d6 0f 02              	mov	ecx, 0x20fd694
1803ce252: 29 c1                       	sub	ecx, eax
1803ce254: d3 c2                       	rol	edx, cl
1803ce256: 48 8d b5 c0 02 00 00        	lea	rsi, [rbp + 0x2c0]
1803ce25d: 81 f2 94 d6 0f 02           	xor	edx, 0x20fd694
1803ce263: d3 c2                       	rol	edx, cl
1803ce265: 48 63 c2                    	movsxd	rax, edx
1803ce268: 48 8d bd 80 00 00 00        	lea	rdi, [rbp + 0x80]
1803ce26f: 48 89 f9                    	mov	rcx, rdi
1803ce272: 4c 8d 35 f7 f9 3e 00        	lea	r14, [rip + 0x3ef9f7]   # 0x1807bdc70
1803ce279: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce27d: 48 63 05 6c df 3f 00        	movsxd	rax, dword ptr [rip + 0x3fdf6c] # 0x1807cc1f0
1803ce284: 31 c9                       	xor	ecx, ecx
1803ce286: 2b 0c 83                    	sub	ecx, dword ptr [rbx + 4*rax]
1803ce289: 81 f1 5e d5 36 84           	xor	ecx, 0x8436d55e
1803ce28f: 0f c9                       	bswap	ecx
1803ce291: 89 c8                       	mov	eax, ecx
1803ce293: f7 d8                       	neg	eax
1803ce295: 48 98                       	cdqe
1803ce297: ba 69 dd 03 06              	mov	edx, 0x603dd69
1803ce29c: 41 33 14 87                 	xor	edx, dword ptr [r15 + 4*rax]
1803ce2a0: ff ca                       	dec	edx
1803ce2a2: 0f ca                       	bswap	edx
1803ce2a4: 83 c1 09                    	add	ecx, 0x9
1803ce2a7: d3 c2                       	rol	edx, cl
1803ce2a9: 0f ca                       	bswap	edx
1803ce2ab: 48 63 c2                    	movsxd	rax, edx
1803ce2ae: 48 89 f9                    	mov	rcx, rdi
1803ce2b1: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce2b5: 48 89 85 08 05 00 00        	mov	qword ptr [rbp + 0x508], rax
1803ce2bc: 8b 0d 56 22 4c 00           	mov	ecx, dword ptr [rip + 0x4c2256] # 0x180890518
1803ce2c2: 83 c1 18                    	add	ecx, 0x18
1803ce2c5: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803ce2ca: d3 c8                       	ror	eax, cl
1803ce2cc: 48 98                       	cdqe
1803ce2ce: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803ce2d2: b9 07 00 00 00              	mov	ecx, 0x7
1803ce2d7: 29 c1                       	sub	ecx, eax
1803ce2d9: d3 c2                       	rol	edx, cl
1803ce2db: 0f ca                       	bswap	edx
1803ce2dd: 48 63 c2                    	movsxd	rax, edx
1803ce2e0: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803ce2e4: c6 85 0f 06 00 00 01        	mov	byte ptr [rbp + 0x60f], 0x1
1803ce2eb: c6 85 0e 06 00 00 00        	mov	byte ptr [rbp + 0x60e], 0x0
1803ce2f2: 4c 89 ad b8 04 00 00        	mov	qword ptr [rbp + 0x4b8], r13
1803ce2f9: 48 89 b5 b0 04 00 00        	mov	qword ptr [rbp + 0x4b0], rsi
1803ce300: 48 8d 95 08 05 00 00        	lea	rdx, [rbp + 0x508]
1803ce307: 4c 89 e9                    	mov	rcx, r13
1803ce30a: ff d0                       	call	rax
1803ce30c: 48 c7 85 c0 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x5c0], 0x0
1803ce317: b9 08 00 00 00              	mov	ecx, 0x8
1803ce31c: 2b 0d 9a 28 4c 00           	sub	ecx, dword ptr [rip + 0x4c289a] # 0x180890bbc
1803ce322: b8 02 00 00 b5              	mov	eax, 0xb5000002
1803ce327: d3 c0                       	rol	eax, cl
1803ce329: 4c 8d 8d c8 05 00 00        	lea	r9, [rbp + 0x5c8]
1803ce330: 49 8d 54 24 38              	lea	rdx, [r12 + 0x38]
1803ce335: 48 98                       	cdqe
1803ce337: 41 b8 72 a1 71 7e           	mov	r8d, 0x7e71a172
1803ce33d: 48 8d 0d 8c 57 3f 00        	lea	rcx, [rip + 0x3f578c]   # 0x1807c3ad0
1803ce344: 44 33 04 81                 	xor	r8d, dword ptr [rcx + 4*rax]
1803ce348: b9 12 00 00 00              	mov	ecx, 0x12
1803ce34d: 29 c1                       	sub	ecx, eax
1803ce34f: 41 d3 c0                    	rol	r8d, cl
1803ce352: 41 0f c8                    	bswap	r8d
1803ce355: 41 f7 d8                    	neg	r8d
1803ce358: 49 63 c0                    	movsxd	rax, r8d
1803ce35b: 48 8d 0d 0e f9 3e 00        	lea	rcx, [rip + 0x3ef90e]   # 0x1807bdc70
1803ce362: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803ce366: c6 85 0f 06 00 00 01        	mov	byte ptr [rbp + 0x60f], 0x1
1803ce36d: c6 85 0e 06 00 00 00        	mov	byte ptr [rbp + 0x60e], 0x0
1803ce374: 4c 89 8d b8 04 00 00        	mov	qword ptr [rbp + 0x4b8], r9
1803ce37b: 48 89 b5 b0 04 00 00        	mov	qword ptr [rbp + 0x4b0], rsi
1803ce382: 4c 89 c9                    	mov	rcx, r9
1803ce385: ff d0                       	call	rax
1803ce387: 48 c7 85 d8 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x5d8], 0x0
1803ce392: 48 b8 9f 64 8e 03 97 21 67 0f       	movabs	rax, 0xf672197038e649f
1803ce39c: 48 33 05 e5 6b 3e 00        	xor	rax, qword ptr [rip + 0x3e6be5] # 0x1807b4f88
1803ce3a3: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803ce3a7: 48 8d 04 c5 b0 05 00 00     	lea	rax, [8*rax + 0x5b0]
1803ce3af: 48 01 e8                    	add	rax, rbp
1803ce3b2: 48 b9 f0 7d 00 69 e5 d1 f0 b1       	movabs	rcx, -0x4e0f2e1a96ff8210
1803ce3bc: 48 01 c1                    	add	rcx, rax
1803ce3bf: 48 8d 85 b0 05 00 00        	lea	rax, [rbp + 0x5b0]
1803ce3c6: 48 89 85 10 05 00 00        	mov	qword ptr [rbp + 0x510], rax
1803ce3cd: 48 89 8d 18 05 00 00        	mov	qword ptr [rbp + 0x518], rcx
1803ce3d4: 44 0f b6 0d 14 14 3e 00     	movzx	r9d, byte ptr [rip + 0x3e1414] # 0x1807af7f0
1803ce3dc: 41 80 f1 ea                 	xor	r9b, -0x16
1803ce3e0: 8b 0d 3a 21 4c 00           	mov	ecx, dword ptr [rip + 0x4c213a] # 0x180890520
1803ce3e6: ff c1                       	inc	ecx
1803ce3e8: b8 e2 08 00 00              	mov	eax, 0x8e2
1803ce3ed: d3 c8                       	ror	eax, cl
1803ce3ef: 48 63 c8                    	movsxd	rcx, eax
1803ce3f2: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803ce3f7: 48 8d 15 d2 56 3f 00        	lea	rdx, [rip + 0x3f56d2]   # 0x1807c3ad0
1803ce3fe: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803ce401: 41 80 c1 83                 	add	r9b, -0x7d
1803ce405: ff c8                       	dec	eax
1803ce407: 83 c1 0b                    	add	ecx, 0xb
1803ce40a: d3 c8                       	ror	eax, cl
1803ce40c: 0f c8                       	bswap	eax
1803ce40e: 48 98                       	cdqe
1803ce410: 48 8d 0d 59 f8 3e 00        	lea	rcx, [rip + 0x3ef859]   # 0x1807bdc70
1803ce417: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803ce41b: c6 85 10 06 00 00 01        	mov	byte ptr [rbp + 0x610], 0x1
1803ce422: 48 89 b5 c0 04 00 00        	mov	qword ptr [rbp + 0x4c0], rsi
1803ce429: 48 8d 95 10 05 00 00        	lea	rdx, [rbp + 0x510]
1803ce430: 48 89 f1                    	mov	rcx, rsi
1803ce433: 41 b0 01                    	mov	r8b, 0x1
1803ce436: ff d0                       	call	rax
1803ce438: 48 c7 85 d0 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x2d0], 0x0
1803ce443: 48 63 05 32 de 3f 00        	movsxd	rax, dword ptr [rip + 0x3fde32] # 0x1807cc27c
1803ce44a: 41 b8 53 57 92 c2           	mov	r8d, 0xc2925753
1803ce450: 4c 8d 35 a9 e8 28 00        	lea	r14, [rip + 0x28e8a9]   # 0x18065cd00
1803ce457: 45 33 04 86                 	xor	r8d, dword ptr [r14 + 4*rax]
1803ce45b: 41 ff c0                    	inc	r8d
1803ce45e: b9 0c 00 00 00              	mov	ecx, 0xc
1803ce463: 29 c1                       	sub	ecx, eax
1803ce465: 41 d3 c0                    	rol	r8d, cl
1803ce468: 41 8d 80 6b ad e0 e3        	lea	eax, [r8 - 0x1c1f5295]
1803ce46f: ba 0b 00 00 00              	mov	edx, 0xb
1803ce474: 44 29 c2                    	sub	edx, r8d
1803ce477: 44 89 c1                    	mov	ecx, r8d
1803ce47a: f7 d9                       	neg	ecx
1803ce47c: 48 63 c9                    	movsxd	rcx, ecx
1803ce47f: 48 8d 1d 4a 56 3f 00        	lea	rbx, [rip + 0x3f564a]   # 0x1807c3ad0
1803ce486: 44 8b 04 8b                 	mov	r8d, dword ptr [rbx + 4*rcx]
1803ce48a: 41 0f c8                    	bswap	r8d
1803ce48d: 41 f7 d8                    	neg	r8d
1803ce490: 89 c1                       	mov	ecx, eax
1803ce492: 41 d3 c0                    	rol	r8d, cl
1803ce495: 41 f7 d8                    	neg	r8d
1803ce498: 89 d1                       	mov	ecx, edx
1803ce49a: 41 d3 c8                    	ror	r8d, cl
1803ce49d: 89 c1                       	mov	ecx, eax
1803ce49f: 41 d3 c0                    	rol	r8d, cl
1803ce4a2: 48 8d b5 d8 02 00 00        	lea	rsi, [rbp + 0x2d8]
1803ce4a9: 41 81 f0 94 52 1f 1c        	xor	r8d, 0x1c1f5294
1803ce4b0: 49 63 c0                    	movsxd	rax, r8d
1803ce4b3: 48 8d bd 90 00 00 00        	lea	rdi, [rbp + 0x90]
1803ce4ba: 48 89 f9                    	mov	rcx, rdi
1803ce4bd: 4c 8d 3d ac f7 3e 00        	lea	r15, [rip + 0x3ef7ac]   # 0x1807bdc70
1803ce4c4: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803ce4c8: 48 63 05 25 dd 3f 00        	movsxd	rax, dword ptr [rip + 0x3fdd25] # 0x1807cc1f4
1803ce4cf: 31 d2                       	xor	edx, edx
1803ce4d1: 41 2b 14 86                 	sub	edx, dword ptr [r14 + 4*rax]
1803ce4d5: b9 10 00 00 00              	mov	ecx, 0x10
1803ce4da: 29 c1                       	sub	ecx, eax
1803ce4dc: d3 c2                       	rol	edx, cl
1803ce4de: 48 63 c2                    	movsxd	rax, edx
1803ce4e1: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803ce4e4: 8d 88 18 a9 71 bd           	lea	ecx, [rax - 0x428e56e8]
1803ce4ea: d3 ca                       	ror	edx, cl
1803ce4ec: f7 da                       	neg	edx
1803ce4ee: d3 ca                       	ror	edx, cl
1803ce4f0: d3 ca                       	ror	edx, cl
1803ce4f2: b9 18 00 00 00              	mov	ecx, 0x18
1803ce4f7: 29 c1                       	sub	ecx, eax
1803ce4f9: d3 c2                       	rol	edx, cl
1803ce4fb: 0f ca                       	bswap	edx
1803ce4fd: 48 63 c2                    	movsxd	rax, edx
1803ce500: 48 89 f9                    	mov	rcx, rdi
1803ce503: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803ce507: 48 89 85 e0 01 00 00        	mov	qword ptr [rbp + 0x1e0], rax
1803ce50e: 8b 0d 04 20 4c 00           	mov	ecx, dword ptr [rip + 0x4c2004] # 0x180890518
1803ce514: 83 c1 18                    	add	ecx, 0x18
1803ce517: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803ce51c: d3 c8                       	ror	eax, cl
1803ce51e: 48 98                       	cdqe
1803ce520: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803ce523: b9 07 00 00 00              	mov	ecx, 0x7
1803ce528: 29 c1                       	sub	ecx, eax
1803ce52a: d3 c2                       	rol	edx, cl
1803ce52c: 0f ca                       	bswap	edx
1803ce52e: 48 63 c2                    	movsxd	rax, edx
1803ce531: 49 8b 04 c7                 	mov	rax, qword ptr [r15 + 8*rax]
1803ce535: c6 85 10 06 00 00 01        	mov	byte ptr [rbp + 0x610], 0x1
1803ce53c: 48 89 b5 c0 04 00 00        	mov	qword ptr [rbp + 0x4c0], rsi
1803ce543: 4c 8d bd 10 05 00 00        	lea	r15, [rbp + 0x510]
1803ce54a: 48 8d 95 e0 01 00 00        	lea	rdx, [rbp + 0x1e0]
1803ce551: 4c 89 f9                    	mov	rcx, r15
1803ce554: ff d0                       	call	rax
1803ce556: 48 c7 85 20 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x520], 0x0
1803ce561: 48 63 15 f8 dc 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fdcf8] # 0x1807cc260
1803ce568: 48 8d 05 91 e7 28 00        	lea	rax, [rip + 0x28e791]   # 0x18065cd00
1803ce56f: 8b 04 90                    	mov	eax, dword ptr [rax + 4*rdx]
1803ce572: 8d 4a 04                    	lea	ecx, [rdx + 0x4]
1803ce575: d3 c8                       	ror	eax, cl
1803ce577: f7 d0                       	not	eax
1803ce579: b9 04 00 00 00              	mov	ecx, 0x4
1803ce57e: 29 d1                       	sub	ecx, edx
1803ce580: d3 c0                       	rol	eax, cl
1803ce582: 4c 8d 85 28 05 00 00        	lea	r8, [rbp + 0x528]
1803ce589: 0f c8                       	bswap	eax
1803ce58b: 48 63 c8                    	movsxd	rcx, eax
1803ce58e: 48 8d 1d 3b 55 3f 00        	lea	rbx, [rip + 0x3f553b]   # 0x1807c3ad0
1803ce595: 44 8b 0c 8b                 	mov	r9d, dword ptr [rbx + 4*rcx]
1803ce599: 89 c1                       	mov	ecx, eax
1803ce59b: 41 d3 c9                    	ror	r9d, cl
1803ce59e: 49 8d 94 24 98 00 00 00     	lea	rdx, [r12 + 0x98]
1803ce5a6: bf 04 00 00 00              	mov	edi, 0x4
1803ce5ab: 41 81 f1 1f 1e 00 fc        	xor	r9d, 0xfc001e1f
1803ce5b2: 41 d3 c9                    	ror	r9d, cl
1803ce5b5: 41 0f c9                    	bswap	r9d
1803ce5b8: 41 f7 d9                    	neg	r9d
1803ce5bb: 41 81 f1 1f 1e 00 fc        	xor	r9d, 0xfc001e1f
1803ce5c2: 41 ff c1                    	inc	r9d
1803ce5c5: 49 63 c1                    	movsxd	rax, r9d
1803ce5c8: 4c 89 c1                    	mov	rcx, r8
1803ce5cb: 48 89 95 08 02 00 00        	mov	qword ptr [rbp + 0x208], rdx
1803ce5d2: 4c 8d 35 97 f6 3e 00        	lea	r14, [rip + 0x3ef697]   # 0x1807bdc70
1803ce5d9: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce5dd: 48 b8 18 ba 5d 02 6d d4 a0 16       	movabs	rax, 0x16a0d46d025dba18
1803ce5e7: 48 33 05 a2 69 3e 00        	xor	rax, qword ptr [rip + 0x3e69a2] # 0x1807b4f90
1803ce5ee: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803ce5f2: 48 8d 04 c5 10 05 00 00     	lea	rax, [8*rax + 0x510]
1803ce5fa: 48 01 e8                    	add	rax, rbp
1803ce5fd: 48 b9 18 a1 25 94 d0 c1 f9 7d       	movabs	rcx, 0x7df9c1d09425a118
1803ce607: 48 01 c1                    	add	rcx, rax
1803ce60a: 4c 89 bd 30 04 00 00        	mov	qword ptr [rbp + 0x430], r15
1803ce611: 48 89 8d 38 04 00 00        	mov	qword ptr [rbp + 0x438], rcx
1803ce618: 44 0f b6 0d d0 11 3e 00     	movzx	r9d, byte ptr [rip + 0x3e11d0] # 0x1807af7f0
1803ce620: 41 80 f1 ea                 	xor	r9b, -0x16
1803ce624: 8b 0d f6 1e 4c 00           	mov	ecx, dword ptr [rip + 0x4c1ef6] # 0x180890520
1803ce62a: ff c1                       	inc	ecx
1803ce62c: b8 e2 08 00 00              	mov	eax, 0x8e2
1803ce631: d3 c8                       	ror	eax, cl
1803ce633: 48 63 c8                    	movsxd	rcx, eax
1803ce636: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803ce63b: 33 04 8b                    	xor	eax, dword ptr [rbx + 4*rcx]
1803ce63e: 41 80 c1 83                 	add	r9b, -0x7d
1803ce642: ff c8                       	dec	eax
1803ce644: 83 c1 0b                    	add	ecx, 0xb
1803ce647: d3 c8                       	ror	eax, cl
1803ce649: 0f c8                       	bswap	eax
1803ce64b: 48 98                       	cdqe
1803ce64d: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803ce651: c6 85 11 06 00 00 01        	mov	byte ptr [rbp + 0x611], 0x1
1803ce658: 48 89 b5 c8 04 00 00        	mov	qword ptr [rbp + 0x4c8], rsi
1803ce65f: 48 8d 95 30 04 00 00        	lea	rdx, [rbp + 0x430]
1803ce666: 48 89 f1                    	mov	rcx, rsi
1803ce669: 41 b0 01                    	mov	r8b, 0x1
1803ce66c: ff d0                       	call	rax
1803ce66e: 48 c7 85 e8 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x2e8], 0x0
1803ce679: 48 63 05 ec db 3f 00        	movsxd	rax, dword ptr [rip + 0x3fdbec] # 0x1807cc26c
1803ce680: 4c 8d 3d 79 e6 28 00        	lea	r15, [rip + 0x28e679]   # 0x18065cd00
1803ce687: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803ce68b: 29 c7                       	sub	edi, eax
1803ce68d: 89 f9                       	mov	ecx, edi
1803ce68f: d3 c2                       	rol	edx, cl
1803ce691: 81 f2 44 bf 1e 96           	xor	edx, 0x961ebf44
1803ce697: 48 63 d2                    	movsxd	rdx, edx
1803ce69a: 48 8d 1d 2f 54 3f 00        	lea	rbx, [rip + 0x3f542f]   # 0x1807c3ad0
1803ce6a1: 8b 04 93                    	mov	eax, dword ptr [rbx + 4*rdx]
1803ce6a4: 0f c8                       	bswap	eax
1803ce6a6: 8d 4a 17                    	lea	ecx, [rdx + 0x17]
1803ce6a9: d3 c8                       	ror	eax, cl
1803ce6ab: b9 b7 1a 48 7b              	mov	ecx, 0x7b481ab7
1803ce6b0: 29 d1                       	sub	ecx, edx
1803ce6b2: d3 c0                       	rol	eax, cl
1803ce6b4: f7 d0                       	not	eax
1803ce6b6: d3 c0                       	rol	eax, cl
1803ce6b8: f7 d8                       	neg	eax
1803ce6ba: d3 c0                       	rol	eax, cl
1803ce6bc: 48 8d b5 f0 02 00 00        	lea	rsi, [rbp + 0x2f0]
1803ce6c3: 35 b7 1a 48 7b              	xor	eax, 0x7b481ab7
1803ce6c8: 48 98                       	cdqe
1803ce6ca: 48 8d bd a0 00 00 00        	lea	rdi, [rbp + 0xa0]
1803ce6d1: 48 89 f9                    	mov	rcx, rdi
1803ce6d4: 4c 8d 35 95 f5 3e 00        	lea	r14, [rip + 0x3ef595]   # 0x1807bdc70
1803ce6db: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce6df: 48 63 05 4e db 3f 00        	movsxd	rax, dword ptr [rip + 0x3fdb4e] # 0x1807cc234
1803ce6e6: 31 c9                       	xor	ecx, ecx
1803ce6e8: 41 2b 0c 87                 	sub	ecx, dword ptr [r15 + 4*rax]
1803ce6ec: 81 f1 5e d5 36 84           	xor	ecx, 0x8436d55e
1803ce6f2: 0f c9                       	bswap	ecx
1803ce6f4: 89 c8                       	mov	eax, ecx
1803ce6f6: f7 d8                       	neg	eax
1803ce6f8: 48 98                       	cdqe
1803ce6fa: ba 69 dd 03 06              	mov	edx, 0x603dd69
1803ce6ff: 33 14 83                    	xor	edx, dword ptr [rbx + 4*rax]
1803ce702: ff ca                       	dec	edx
1803ce704: 0f ca                       	bswap	edx
1803ce706: 83 c1 09                    	add	ecx, 0x9
1803ce709: d3 c2                       	rol	edx, cl
1803ce70b: 0f ca                       	bswap	edx
1803ce70d: 48 63 c2                    	movsxd	rax, edx
1803ce710: 48 89 f9                    	mov	rcx, rdi
1803ce713: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce717: 48 89 85 e8 01 00 00        	mov	qword ptr [rbp + 0x1e8], rax
1803ce71e: 8b 0d f4 1d 4c 00           	mov	ecx, dword ptr [rip + 0x4c1df4] # 0x180890518
1803ce724: 83 c1 18                    	add	ecx, 0x18
1803ce727: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803ce72c: d3 c8                       	ror	eax, cl
1803ce72e: 48 98                       	cdqe
1803ce730: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803ce733: b9 07 00 00 00              	mov	ecx, 0x7
1803ce738: 29 c1                       	sub	ecx, eax
1803ce73a: d3 c2                       	rol	edx, cl
1803ce73c: 0f ca                       	bswap	edx
1803ce73e: 48 63 c2                    	movsxd	rax, edx
1803ce741: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803ce745: c6 85 11 06 00 00 01        	mov	byte ptr [rbp + 0x611], 0x1
1803ce74c: 48 89 b5 c8 04 00 00        	mov	qword ptr [rbp + 0x4c8], rsi
1803ce753: 48 8d bd 30 04 00 00        	lea	rdi, [rbp + 0x430]
1803ce75a: 48 8d 95 e8 01 00 00        	lea	rdx, [rbp + 0x1e8]
1803ce761: 48 89 f9                    	mov	rcx, rdi
1803ce764: ff d0                       	call	rax
1803ce766: 48 c7 85 40 04 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x440], 0x0
1803ce771: 48 63 15 e4 da 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fdae4] # 0x1807cc25c
1803ce778: 48 8d 05 81 e5 28 00        	lea	rax, [rip + 0x28e581]   # 0x18065cd00
1803ce77f: 8b 04 90                    	mov	eax, dword ptr [rax + 4*rdx]
1803ce782: 8d 4a 04                    	lea	ecx, [rdx + 0x4]
1803ce785: d3 c8                       	ror	eax, cl
1803ce787: f7 d0                       	not	eax
1803ce789: b9 04 00 00 00              	mov	ecx, 0x4
1803ce78e: 29 d1                       	sub	ecx, edx
1803ce790: d3 c0                       	rol	eax, cl
1803ce792: 0f c8                       	bswap	eax
1803ce794: 48 63 c8                    	movsxd	rcx, eax
1803ce797: 48 8d 1d 32 53 3f 00        	lea	rbx, [rip + 0x3f5332]   # 0x1807c3ad0
1803ce79e: 44 8b 04 8b                 	mov	r8d, dword ptr [rbx + 4*rcx]
1803ce7a2: 89 c1                       	mov	ecx, eax
1803ce7a4: 41 d3 c8                    	ror	r8d, cl
1803ce7a7: 4c 8d 8d 48 04 00 00        	lea	r9, [rbp + 0x448]
1803ce7ae: 49 8d 94 24 a0 00 00 00     	lea	rdx, [r12 + 0xa0]
1803ce7b6: 41 81 f0 1f 1e 00 fc        	xor	r8d, 0xfc001e1f
1803ce7bd: 41 d3 c8                    	ror	r8d, cl
1803ce7c0: 41 0f c8                    	bswap	r8d
1803ce7c3: 41 f7 d8                    	neg	r8d
1803ce7c6: 41 81 f0 1f 1e 00 fc        	xor	r8d, 0xfc001e1f
1803ce7cd: 41 ff c0                    	inc	r8d
1803ce7d0: 49 63 c0                    	movsxd	rax, r8d
1803ce7d3: 4c 89 c9                    	mov	rcx, r9
1803ce7d6: 4c 8d 35 93 f4 3e 00        	lea	r14, [rip + 0x3ef493]   # 0x1807bdc70
1803ce7dd: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce7e1: 48 b8 8e c5 3a 97 6d 04 93 07       	movabs	rax, 0x793046d973ac58e
1803ce7eb: 48 33 05 ae 67 3e 00        	xor	rax, qword ptr [rip + 0x3e67ae] # 0x1807b4fa0
1803ce7f2: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803ce7f6: 48 8d 04 c5 30 04 00 00     	lea	rax, [8*rax + 0x430]
1803ce7fe: 48 01 e8                    	add	rax, rbp
1803ce801: 48 b9 d8 83 b6 e1 0e 18 9c 0f       	movabs	rcx, 0xf9c180ee1b683d8
1803ce80b: 48 01 c1                    	add	rcx, rax
1803ce80e: 48 89 bd 40 05 00 00        	mov	qword ptr [rbp + 0x540], rdi
1803ce815: 48 89 8d 48 05 00 00        	mov	qword ptr [rbp + 0x548], rcx
1803ce81c: 44 0f b6 0d cc 0f 3e 00     	movzx	r9d, byte ptr [rip + 0x3e0fcc] # 0x1807af7f0
1803ce824: 41 80 f1 ea                 	xor	r9b, -0x16
1803ce828: 8b 0d f2 1c 4c 00           	mov	ecx, dword ptr [rip + 0x4c1cf2] # 0x180890520
1803ce82e: ff c1                       	inc	ecx
1803ce830: b8 e2 08 00 00              	mov	eax, 0x8e2
1803ce835: d3 c8                       	ror	eax, cl
1803ce837: 48 63 c8                    	movsxd	rcx, eax
1803ce83a: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803ce83f: 33 04 8b                    	xor	eax, dword ptr [rbx + 4*rcx]
1803ce842: 41 80 c1 83                 	add	r9b, -0x7d
1803ce846: ff c8                       	dec	eax
1803ce848: 83 c1 0b                    	add	ecx, 0xb
1803ce84b: d3 c8                       	ror	eax, cl
1803ce84d: 0f c8                       	bswap	eax
1803ce84f: 48 98                       	cdqe
1803ce851: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803ce855: c6 85 00 06 00 00 01        	mov	byte ptr [rbp + 0x600], 0x1
1803ce85c: 48 89 b5 00 04 00 00        	mov	qword ptr [rbp + 0x400], rsi
1803ce863: 4c 8d ad 40 05 00 00        	lea	r13, [rbp + 0x540]
1803ce86a: 48 89 f1                    	mov	rcx, rsi
1803ce86d: 4c 89 ea                    	mov	rdx, r13
1803ce870: 41 b0 01                    	mov	r8b, 0x1
1803ce873: ff d0                       	call	rax
1803ce875: 48 c7 85 00 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x300], 0x0
1803ce880: 48 63 15 e9 d9 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fd9e9] # 0x1807cc270
1803ce887: 4c 8d 25 72 e4 28 00        	lea	r12, [rip + 0x28e472]   # 0x18065cd00
1803ce88e: 45 8b 04 94                 	mov	r8d, dword ptr [r12 + 4*rdx]
1803ce892: 8d 82 48 61 01 f5           	lea	eax, [rdx - 0xafe9eb8]
1803ce898: 89 c1                       	mov	ecx, eax
1803ce89a: 41 d3 c8                    	ror	r8d, cl
1803ce89d: 41 f7 d0                    	not	r8d
1803ce8a0: b9 08 00 00 00              	mov	ecx, 0x8
1803ce8a5: 29 d1                       	sub	ecx, edx
1803ce8a7: 41 d3 c0                    	rol	r8d, cl
1803ce8aa: 89 c1                       	mov	ecx, eax
1803ce8ac: 41 d3 c8                    	ror	r8d, cl
1803ce8af: 49 63 c8                    	movsxd	rcx, r8d
1803ce8b2: 48 8d 1d 17 52 3f 00        	lea	rbx, [rip + 0x3f5217]   # 0x1807c3ad0
1803ce8b9: 8b 04 8b                    	mov	eax, dword ptr [rbx + 4*rcx]
1803ce8bc: 81 c1 35 de 20 46           	add	ecx, 0x4620de35
1803ce8c2: d3 c8                       	ror	eax, cl
1803ce8c4: 48 8d b5 08 03 00 00        	lea	rsi, [rbp + 0x308]
1803ce8cb: bf 08 00 00 00              	mov	edi, 0x8
1803ce8d0: 35 ca 21 df b9              	xor	eax, 0xb9df21ca
1803ce8d5: d3 c8                       	ror	eax, cl
1803ce8d7: 48 98                       	cdqe
1803ce8d9: 4c 8d bd b0 00 00 00        	lea	r15, [rbp + 0xb0]
1803ce8e0: 4c 89 f9                    	mov	rcx, r15
1803ce8e3: 4c 8d 35 86 f3 3e 00        	lea	r14, [rip + 0x3ef386]   # 0x1807bdc70
1803ce8ea: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce8ee: 48 63 05 43 d9 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd943] # 0x1807cc238
1803ce8f5: ba f9 c0 b1 72              	mov	edx, 0x72b1c0f9
1803ce8fa: 41 33 14 84                 	xor	edx, dword ptr [r12 + 4*rax]
1803ce8fe: 8d 42 01                    	lea	eax, [rdx + 0x1]
1803ce901: 48 98                       	cdqe
1803ce903: 8b 04 83                    	mov	eax, dword ptr [rbx + 4*rax]
1803ce906: 0f c8                       	bswap	eax
1803ce908: 8d 8a 5a 44 c6 45           	lea	ecx, [rdx + 0x45c6445a]
1803ce90e: d3 c8                       	ror	eax, cl
1803ce910: f7 d8                       	neg	eax
1803ce912: d3 c8                       	ror	eax, cl
1803ce914: f7 d8                       	neg	eax
1803ce916: d3 c8                       	ror	eax, cl
1803ce918: b9 18 00 00 00              	mov	ecx, 0x18
1803ce91d: 29 d1                       	sub	ecx, edx
1803ce91f: d3 c0                       	rol	eax, cl
1803ce921: 35 59 44 c6 45              	xor	eax, 0x45c64459
1803ce926: 48 98                       	cdqe
1803ce928: 4c 89 f9                    	mov	rcx, r15
1803ce92b: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ce92f: 48 89 85 f0 01 00 00        	mov	qword ptr [rbp + 0x1f0], rax
1803ce936: 8b 0d dc 1b 4c 00           	mov	ecx, dword ptr [rip + 0x4c1bdc] # 0x180890518
1803ce93c: 83 c1 18                    	add	ecx, 0x18
1803ce93f: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803ce944: d3 c8                       	ror	eax, cl
1803ce946: 48 98                       	cdqe
1803ce948: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803ce94b: b9 07 00 00 00              	mov	ecx, 0x7
1803ce950: 29 c1                       	sub	ecx, eax
1803ce952: d3 c2                       	rol	edx, cl
1803ce954: 0f ca                       	bswap	edx
1803ce956: 48 63 c2                    	movsxd	rax, edx
1803ce959: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803ce95d: c6 85 13 06 00 00 01        	mov	byte ptr [rbp + 0x613], 0x1
1803ce964: c6 85 12 06 00 00 00        	mov	byte ptr [rbp + 0x612], 0x0
1803ce96b: 4c 89 ad d8 04 00 00        	mov	qword ptr [rbp + 0x4d8], r13
1803ce972: 48 89 b5 d0 04 00 00        	mov	qword ptr [rbp + 0x4d0], rsi
1803ce979: 48 8d 95 f0 01 00 00        	lea	rdx, [rbp + 0x1f0]
1803ce980: 4c 89 e9                    	mov	rcx, r13
1803ce983: ff d0                       	call	rax
1803ce985: 48 c7 85 50 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x550], 0x0
1803ce990: 2b 3d 26 22 4c 00           	sub	edi, dword ptr [rip + 0x4c2226] # 0x180890bbc
1803ce996: b8 02 00 00 b5              	mov	eax, 0xb5000002
1803ce99b: 89 f9                       	mov	ecx, edi
1803ce99d: d3 c0                       	rol	eax, cl
1803ce99f: 4c 8d 8d 58 05 00 00        	lea	r9, [rbp + 0x558]
1803ce9a6: 48 8b 8d e0 05 00 00        	mov	rcx, qword ptr [rbp + 0x5e0]
1803ce9ad: 48 8d 51 58                 	lea	rdx, [rcx + 0x58]
1803ce9b1: 48 98                       	cdqe
1803ce9b3: 41 b8 72 a1 71 7e           	mov	r8d, 0x7e71a172
1803ce9b9: 48 8d 0d 10 51 3f 00        	lea	rcx, [rip + 0x3f5110]   # 0x1807c3ad0
1803ce9c0: 44 33 04 81                 	xor	r8d, dword ptr [rcx + 4*rax]
1803ce9c4: b9 12 00 00 00              	mov	ecx, 0x12
1803ce9c9: 29 c1                       	sub	ecx, eax
1803ce9cb: 41 d3 c0                    	rol	r8d, cl
1803ce9ce: 41 0f c8                    	bswap	r8d
1803ce9d1: 41 f7 d8                    	neg	r8d
1803ce9d4: 49 63 c0                    	movsxd	rax, r8d
1803ce9d7: 48 8d 0d 92 f2 3e 00        	lea	rcx, [rip + 0x3ef292]   # 0x1807bdc70
1803ce9de: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803ce9e2: c6 85 13 06 00 00 01        	mov	byte ptr [rbp + 0x613], 0x1
1803ce9e9: c6 85 12 06 00 00 00        	mov	byte ptr [rbp + 0x612], 0x0
1803ce9f0: 4c 89 8d d8 04 00 00        	mov	qword ptr [rbp + 0x4d8], r9
1803ce9f7: 48 89 b5 d0 04 00 00        	mov	qword ptr [rbp + 0x4d0], rsi
1803ce9fe: 4c 89 c9                    	mov	rcx, r9
1803cea01: ff d0                       	call	rax
1803cea03: 48 c7 85 68 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x568], 0x0
1803cea0e: 48 b8 42 36 72 54 40 a6 ff 17       	movabs	rax, 0x17ffa64054723642
1803cea18: 48 33 05 79 65 3e 00        	xor	rax, qword ptr [rip + 0x3e6579] # 0x1807b4f98
1803cea1f: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cea23: 48 8d 04 c5 40 05 00 00     	lea	rax, [8*rax + 0x540]
1803cea2b: 48 01 e8                    	add	rax, rbp
1803cea2e: 48 b9 b0 6c 7b 79 43 f8 ad 72       	movabs	rcx, 0x72adf843797b6cb0
1803cea38: 48 01 c1                    	add	rcx, rax
1803cea3b: 48 8d 85 40 05 00 00        	lea	rax, [rbp + 0x540]
1803cea42: 48 89 85 90 03 00 00        	mov	qword ptr [rbp + 0x390], rax
1803cea49: 48 89 8d 98 03 00 00        	mov	qword ptr [rbp + 0x398], rcx
1803cea50: 44 0f b6 0d 98 0d 3e 00     	movzx	r9d, byte ptr [rip + 0x3e0d98] # 0x1807af7f0
1803cea58: 41 80 f1 ea                 	xor	r9b, -0x16
1803cea5c: 8b 0d be 1a 4c 00           	mov	ecx, dword ptr [rip + 0x4c1abe] # 0x180890520
1803cea62: ff c1                       	inc	ecx
1803cea64: b8 e2 08 00 00              	mov	eax, 0x8e2
1803cea69: d3 c8                       	ror	eax, cl
1803cea6b: 48 63 c8                    	movsxd	rcx, eax
1803cea6e: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803cea73: 48 8d 15 56 50 3f 00        	lea	rdx, [rip + 0x3f5056]   # 0x1807c3ad0
1803cea7a: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803cea7d: 41 80 c1 83                 	add	r9b, -0x7d
1803cea81: ff c8                       	dec	eax
1803cea83: 83 c1 0b                    	add	ecx, 0xb
1803cea86: d3 c8                       	ror	eax, cl
1803cea88: 0f c8                       	bswap	eax
1803cea8a: 48 98                       	cdqe
1803cea8c: 48 8d 0d dd f1 3e 00        	lea	rcx, [rip + 0x3ef1dd]   # 0x1807bdc70
1803cea93: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803cea97: c6 85 01 06 00 00 01        	mov	byte ptr [rbp + 0x601], 0x1
1803cea9e: 48 89 b5 08 04 00 00        	mov	qword ptr [rbp + 0x408], rsi
1803ceaa5: 4c 8d b5 90 03 00 00        	lea	r14, [rbp + 0x390]
1803ceaac: 48 89 f1                    	mov	rcx, rsi
1803ceaaf: 4c 89 f2                    	mov	rdx, r14
1803ceab2: 41 b0 01                    	mov	r8b, 0x1
1803ceab5: ff d0                       	call	rax
1803ceab7: 48 c7 85 18 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x318], 0x0
1803ceac2: 48 63 05 b7 d7 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd7b7] # 0x1807cc280
1803ceac9: b9 56 aa e9 83              	mov	ecx, 0x83e9aa56
1803ceace: 48 8d 1d 2b e2 28 00        	lea	rbx, [rip + 0x28e22b]   # 0x18065cd00
1803cead5: 33 0c 83                    	xor	ecx, dword ptr [rbx + 4*rax]
1803cead8: 0f c9                       	bswap	ecx
1803ceada: 4c 63 c9                    	movsxd	r9, ecx
1803ceadd: 4c 8d 3d ec 4f 3f 00        	lea	r15, [rip + 0x3f4fec]   # 0x1807c3ad0
1803ceae4: 47 8b 04 8f                 	mov	r8d, dword ptr [r15 + 4*r9]
1803ceae8: 41 8d 81 68 f3 59 e1        	lea	eax, [r9 - 0x1ea60c98]
1803ceaef: 89 c1                       	mov	ecx, eax
1803ceaf1: 41 d3 c8                    	ror	r8d, cl
1803ceaf4: 41 f7 d8                    	neg	r8d
1803ceaf7: 41 0f c8                    	bswap	r8d
1803ceafa: ba 68 f3 59 e1              	mov	edx, 0xe159f368
1803ceaff: 44 29 ca                    	sub	edx, r9d
1803ceb02: 89 d1                       	mov	ecx, edx
1803ceb04: 41 d3 c0                    	rol	r8d, cl
1803ceb07: 48 8d b5 20 03 00 00        	lea	rsi, [rbp + 0x320]
1803ceb0e: 41 0f c8                    	bswap	r8d
1803ceb11: 41 f7 d8                    	neg	r8d
1803ceb14: 89 c1                       	mov	ecx, eax
1803ceb16: 41 d3 c8                    	ror	r8d, cl
1803ceb19: 89 d1                       	mov	ecx, edx
1803ceb1b: 41 d3 c0                    	rol	r8d, cl
1803ceb1e: 49 63 c0                    	movsxd	rax, r8d
1803ceb21: 48 8d bd 80 01 00 00        	lea	rdi, [rbp + 0x180]
1803ceb28: 48 89 f9                    	mov	rcx, rdi
1803ceb2b: 4c 8d 25 3e f1 3e 00        	lea	r12, [rip + 0x3ef13e]   # 0x1807bdc70
1803ceb32: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803ceb36: 48 63 05 07 d7 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd707] # 0x1807cc244
1803ceb3d: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803ceb40: f7 d2                       	not	edx
1803ceb42: 0f ca                       	bswap	edx
1803ceb44: f7 da                       	neg	edx
1803ceb46: b9 16 00 00 00              	mov	ecx, 0x16
1803ceb4b: 29 c1                       	sub	ecx, eax
1803ceb4d: d3 c2                       	rol	edx, cl
1803ceb4f: 48 63 ca                    	movsxd	rcx, edx
1803ceb52: 31 c0                       	xor	eax, eax
1803ceb54: 41 2b 04 8f                 	sub	eax, dword ptr [r15 + 4*rcx]
1803ceb58: 0f c8                       	bswap	eax
1803ceb5a: ff c8                       	dec	eax
1803ceb5c: 35 55 9f 21 e6              	xor	eax, 0xe6219f55
1803ceb61: 0f c8                       	bswap	eax
1803ceb63: 83 c1 06                    	add	ecx, 0x6
1803ceb66: d3 c8                       	ror	eax, cl
1803ceb68: 0f c8                       	bswap	eax
1803ceb6a: 48 98                       	cdqe
1803ceb6c: 48 89 f9                    	mov	rcx, rdi
1803ceb6f: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803ceb73: 48 89 85 f8 01 00 00        	mov	qword ptr [rbp + 0x1f8], rax
1803ceb7a: 8b 0d 98 19 4c 00           	mov	ecx, dword ptr [rip + 0x4c1998] # 0x180890518
1803ceb80: 83 c1 18                    	add	ecx, 0x18
1803ceb83: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803ceb88: d3 c8                       	ror	eax, cl
1803ceb8a: 48 98                       	cdqe
1803ceb8c: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803ceb90: b9 07 00 00 00              	mov	ecx, 0x7
1803ceb95: 29 c1                       	sub	ecx, eax
1803ceb97: d3 c2                       	rol	edx, cl
1803ceb99: 0f ca                       	bswap	edx
1803ceb9b: 48 63 c2                    	movsxd	rax, edx
1803ceb9e: 49 8b 04 c4                 	mov	rax, qword ptr [r12 + 8*rax]
1803ceba2: c6 85 15 06 00 00 01        	mov	byte ptr [rbp + 0x615], 0x1
1803ceba9: c6 85 14 06 00 00 00        	mov	byte ptr [rbp + 0x614], 0x0
1803cebb0: 4c 89 b5 e8 04 00 00        	mov	qword ptr [rbp + 0x4e8], r14
1803cebb7: 48 89 b5 e0 04 00 00        	mov	qword ptr [rbp + 0x4e0], rsi
1803cebbe: 48 8d 95 f8 01 00 00        	lea	rdx, [rbp + 0x1f8]
1803cebc5: 4c 89 f1                    	mov	rcx, r14
1803cebc8: ff d0                       	call	rax
1803cebca: 48 c7 85 a0 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x3a0], 0x0
1803cebd5: b9 08 00 00 00              	mov	ecx, 0x8
1803cebda: 2b 0d dc 1f 4c 00           	sub	ecx, dword ptr [rip + 0x4c1fdc] # 0x180890bbc
1803cebe0: b8 02 00 00 b5              	mov	eax, 0xb5000002
1803cebe5: d3 c0                       	rol	eax, cl
1803cebe7: 4c 8d 85 a8 03 00 00        	lea	r8, [rbp + 0x3a8]
1803cebee: 48 98                       	cdqe
1803cebf0: ba 72 a1 71 7e              	mov	edx, 0x7e71a172
1803cebf5: 48 8d 0d d4 4e 3f 00        	lea	rcx, [rip + 0x3f4ed4]   # 0x1807c3ad0
1803cebfc: 33 14 81                    	xor	edx, dword ptr [rcx + 4*rax]
1803cebff: b9 12 00 00 00              	mov	ecx, 0x12
1803cec04: 29 c1                       	sub	ecx, eax
1803cec06: d3 c2                       	rol	edx, cl
1803cec08: 0f ca                       	bswap	edx
1803cec0a: f7 da                       	neg	edx
1803cec0c: 48 63 c2                    	movsxd	rax, edx
1803cec0f: 48 8d 0d 5a f0 3e 00        	lea	rcx, [rip + 0x3ef05a]   # 0x1807bdc70
1803cec16: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803cec1a: c6 85 15 06 00 00 01        	mov	byte ptr [rbp + 0x615], 0x1
1803cec21: c6 85 14 06 00 00 00        	mov	byte ptr [rbp + 0x614], 0x0
1803cec28: 4c 89 85 e8 04 00 00        	mov	qword ptr [rbp + 0x4e8], r8
1803cec2f: 48 89 b5 e0 04 00 00        	mov	qword ptr [rbp + 0x4e0], rsi
1803cec36: 48 8d 95 c0 01 00 00        	lea	rdx, [rbp + 0x1c0]
1803cec3d: 4c 89 c1                    	mov	rcx, r8
1803cec40: ff d0                       	call	rax
1803cec42: 48 c7 85 b8 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x3b8], 0x0
1803cec4d: 48 b8 00 94 10 8c 9f 4a 87 06       	movabs	rax, 0x6874a9f8c109400
1803cec57: 48 33 05 8a 63 3e 00        	xor	rax, qword ptr [rip + 0x3e638a] # 0x1807b4fe8
1803cec5e: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cec62: 48 8d 04 c5 90 03 00 00     	lea	rax, [8*rax + 0x390]
1803cec6a: 48 01 e8                    	add	rax, rbp
1803cec6d: 48 b9 a8 99 05 a2 f9 5b 59 e1       	movabs	rcx, -0x1ea6a4065dfa6658
1803cec77: 48 01 c1                    	add	rcx, rax
1803cec7a: 48 8d 85 90 03 00 00        	lea	rax, [rbp + 0x390]
1803cec81: 48 89 85 50 03 00 00        	mov	qword ptr [rbp + 0x350], rax
1803cec88: 48 89 8d 58 03 00 00        	mov	qword ptr [rbp + 0x358], rcx
1803cec8f: 44 0f b6 0d 59 0b 3e 00     	movzx	r9d, byte ptr [rip + 0x3e0b59] # 0x1807af7f0
1803cec97: 41 80 f1 ea                 	xor	r9b, -0x16
1803cec9b: 8b 0d 7f 18 4c 00           	mov	ecx, dword ptr [rip + 0x4c187f] # 0x180890520
1803ceca1: ff c1                       	inc	ecx
1803ceca3: b8 e2 08 00 00              	mov	eax, 0x8e2
1803ceca8: d3 c8                       	ror	eax, cl
1803cecaa: 48 63 c8                    	movsxd	rcx, eax
1803cecad: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803cecb2: 48 8d 15 17 4e 3f 00        	lea	rdx, [rip + 0x3f4e17]   # 0x1807c3ad0
1803cecb9: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803cecbc: 41 80 c1 83                 	add	r9b, -0x7d
1803cecc0: ff c8                       	dec	eax
1803cecc2: 83 c1 0b                    	add	ecx, 0xb
1803cecc5: d3 c8                       	ror	eax, cl
1803cecc7: 0f c8                       	bswap	eax
1803cecc9: 48 98                       	cdqe
1803ceccb: 48 8d 0d 9e ef 3e 00        	lea	rcx, [rip + 0x3eef9e]   # 0x1807bdc70
1803cecd2: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803cecd6: c6 85 02 06 00 00 01        	mov	byte ptr [rbp + 0x602], 0x1
1803cecdd: 48 89 b5 10 04 00 00        	mov	qword ptr [rbp + 0x410], rsi
1803cece4: 4c 8d a5 50 03 00 00        	lea	r12, [rbp + 0x350]
1803ceceb: 48 89 f1                    	mov	rcx, rsi
1803cecee: 4c 89 e2                    	mov	rdx, r12
1803cecf1: 41 b0 01                    	mov	r8b, 0x1
1803cecf4: ff d0                       	call	rax
1803cecf6: 48 c7 85 30 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x330], 0x0
1803ced01: 48 63 15 5c d5 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fd55c] # 0x1807cc264
1803ced08: 48 8d 1d f1 df 28 00        	lea	rbx, [rip + 0x28dff1]   # 0x18065cd00
1803ced0f: 8b 04 93                    	mov	eax, dword ptr [rbx + 4*rdx]
1803ced12: b9 60 55 60 9a              	mov	ecx, 0x9a605560
1803ced17: 29 d1                       	sub	ecx, edx
1803ced19: d3 c0                       	rol	eax, cl
1803ced1b: d3 c0                       	rol	eax, cl
1803ced1d: d3 c0                       	rol	eax, cl
1803ced1f: 89 c1                       	mov	ecx, eax
1803ced21: 81 f1 60 55 60 9a           	xor	ecx, 0x9a605560
1803ced27: 48 63 c9                    	movsxd	rcx, ecx
1803ced2a: ba 78 65 80 a1              	mov	edx, 0xa1806578
1803ced2f: 4c 8d 3d 9a 4d 3f 00        	lea	r15, [rip + 0x3f4d9a]   # 0x1807c3ad0
1803ced36: 41 33 14 8f                 	xor	edx, dword ptr [r15 + 4*rcx]
1803ced3a: ff c2                       	inc	edx
1803ced3c: 81 f2 5e 7f 9a 87           	xor	edx, 0x879a7f5e
1803ced42: 0f ca                       	bswap	edx
1803ced44: f7 da                       	neg	edx
1803ced46: b9 07 00 00 00              	mov	ecx, 0x7
1803ced4b: 29 c1                       	sub	ecx, eax
1803ced4d: d3 c2                       	rol	edx, cl
1803ced4f: be 07 00 00 00              	mov	esi, 0x7
1803ced54: f7 da                       	neg	edx
1803ced56: 83 c0 07                    	add	eax, 0x7
1803ced59: 89 c1                       	mov	ecx, eax
1803ced5b: d3 ca                       	ror	edx, cl
1803ced5d: 48 63 c2                    	movsxd	rax, edx
1803ced60: 48 8d bd 90 01 00 00        	lea	rdi, [rbp + 0x190]
1803ced67: 48 89 f9                    	mov	rcx, rdi
1803ced6a: 4c 8d 35 ff ee 3e 00        	lea	r14, [rip + 0x3eeeff]   # 0x1807bdc70
1803ced71: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803ced75: 48 63 05 c4 d4 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd4c4] # 0x1807cc240
1803ced7c: 31 c9                       	xor	ecx, ecx
1803ced7e: 2b 0c 83                    	sub	ecx, dword ptr [rbx + 4*rax]
1803ced81: 81 f1 5e d5 36 84           	xor	ecx, 0x8436d55e
1803ced87: 0f c9                       	bswap	ecx
1803ced89: 89 c8                       	mov	eax, ecx
1803ced8b: f7 d8                       	neg	eax
1803ced8d: 48 98                       	cdqe
1803ced8f: ba 69 dd 03 06              	mov	edx, 0x603dd69
1803ced94: 41 33 14 87                 	xor	edx, dword ptr [r15 + 4*rax]
1803ced98: ff ca                       	dec	edx
1803ced9a: 0f ca                       	bswap	edx
1803ced9c: 83 c1 09                    	add	ecx, 0x9
1803ced9f: d3 c2                       	rol	edx, cl
1803ceda1: 0f ca                       	bswap	edx
1803ceda3: 48 63 c2                    	movsxd	rax, edx
1803ceda6: 48 89 f9                    	mov	rcx, rdi
1803ceda9: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cedad: 48 89 85 00 02 00 00        	mov	qword ptr [rbp + 0x200], rax
1803cedb4: 8b 0d 5e 17 4c 00           	mov	ecx, dword ptr [rip + 0x4c175e] # 0x180890518
1803cedba: 83 c1 18                    	add	ecx, 0x18
1803cedbd: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803cedc2: d3 c8                       	ror	eax, cl
1803cedc4: 48 98                       	cdqe
1803cedc6: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cedca: 29 c6                       	sub	esi, eax
1803cedcc: 89 f1                       	mov	ecx, esi
1803cedce: d3 c2                       	rol	edx, cl
1803cedd0: 0f ca                       	bswap	edx
1803cedd2: 48 63 c2                    	movsxd	rax, edx
1803cedd5: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803cedd9: c6 85 17 06 00 00 01        	mov	byte ptr [rbp + 0x617], 0x1
1803cede0: c6 85 16 06 00 00 00        	mov	byte ptr [rbp + 0x616], 0x0
1803cede7: 4c 89 a5 f0 04 00 00        	mov	qword ptr [rbp + 0x4f0], r12
1803cedee: 48 8d 95 00 02 00 00        	lea	rdx, [rbp + 0x200]
1803cedf5: 4c 89 e1                    	mov	rcx, r12
1803cedf8: ff d0                       	call	rax
1803cedfa: 48 c7 85 60 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x360], 0x0
1803cee05: b9 08 00 00 00              	mov	ecx, 0x8
1803cee0a: 2b 0d ac 1d 4c 00           	sub	ecx, dword ptr [rip + 0x4c1dac] # 0x180890bbc
1803cee10: b8 02 00 00 b5              	mov	eax, 0xb5000002
1803cee15: d3 c0                       	rol	eax, cl
1803cee17: 48 98                       	cdqe
1803cee19: ba 72 a1 71 7e              	mov	edx, 0x7e71a172
1803cee1e: 48 8d 0d ab 4c 3f 00        	lea	rcx, [rip + 0x3f4cab]   # 0x1807c3ad0
1803cee25: 33 14 81                    	xor	edx, dword ptr [rcx + 4*rax]
1803cee28: b9 12 00 00 00              	mov	ecx, 0x12
1803cee2d: 29 c1                       	sub	ecx, eax
1803cee2f: d3 c2                       	rol	edx, cl
1803cee31: 4c 8d 85 68 03 00 00        	lea	r8, [rbp + 0x368]
1803cee38: 0f ca                       	bswap	edx
1803cee3a: f7 da                       	neg	edx
1803cee3c: 48 63 c2                    	movsxd	rax, edx
1803cee3f: 48 8d 0d 2a ee 3e 00        	lea	rcx, [rip + 0x3eee2a]   # 0x1807bdc70
1803cee46: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803cee4a: c6 85 17 06 00 00 01        	mov	byte ptr [rbp + 0x617], 0x1
1803cee51: c6 85 16 06 00 00 00        	mov	byte ptr [rbp + 0x616], 0x0
1803cee58: 4c 89 85 f0 04 00 00        	mov	qword ptr [rbp + 0x4f0], r8
1803cee5f: 48 8d 95 c0 00 00 00        	lea	rdx, [rbp + 0xc0]
1803cee66: 4c 89 c1                    	mov	rcx, r8
1803cee69: ff d0                       	call	rax
1803cee6b: 48 c7 85 78 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x378], 0x0
1803cee76: 48 b8 0e b6 a0 be 79 2e 65 10       	movabs	rax, 0x10652e79bea0b60e
1803cee80: 48 33 05 31 61 3e 00        	xor	rax, qword ptr [rip + 0x3e6131] # 0x1807b4fb8
1803cee87: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cee8b: 48 8d 04 c5 50 03 00 00     	lea	rax, [8*rax + 0x350]
1803cee93: 48 01 e8                    	add	rax, rbp
1803cee96: 48 b9 a8 6b 25 12 0f c8 1d 73       	movabs	rcx, 0x731dc80f12256ba8
1803ceea0: 48 01 c1                    	add	rcx, rax
1803ceea3: 48 8d 85 50 03 00 00        	lea	rax, [rbp + 0x350]
1803ceeaa: 48 89 85 70 05 00 00        	mov	qword ptr [rbp + 0x570], rax
1803ceeb1: 48 89 8d 78 05 00 00        	mov	qword ptr [rbp + 0x578], rcx
1803ceeb8: 44 0f b6 0d 30 09 3e 00     	movzx	r9d, byte ptr [rip + 0x3e0930] # 0x1807af7f0
1803ceec0: 8b 0d 5a 16 4c 00           	mov	ecx, dword ptr [rip + 0x4c165a] # 0x180890520
1803ceec6: ff c1                       	inc	ecx
1803ceec8: b8 e2 08 00 00              	mov	eax, 0x8e2
1803ceecd: d3 c8                       	ror	eax, cl
1803ceecf: 41 80 f1 ea                 	xor	r9b, -0x16
1803ceed3: 41 80 c1 83                 	add	r9b, -0x7d
1803ceed7: 48 63 c8                    	movsxd	rcx, eax
1803ceeda: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803ceedf: 48 8d 15 ea 4b 3f 00        	lea	rdx, [rip + 0x3f4bea]   # 0x1807c3ad0
1803ceee6: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803ceee9: ff c8                       	dec	eax
1803ceeeb: 83 c1 0b                    	add	ecx, 0xb
1803ceeee: d3 c8                       	ror	eax, cl
1803ceef0: 0f c8                       	bswap	eax
1803ceef2: 48 98                       	cdqe
1803ceef4: 48 8d 0d 75 ed 3e 00        	lea	rcx, [rip + 0x3eed75]   # 0x1807bdc70
1803ceefb: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803ceeff: c6 85 03 06 00 00 01        	mov	byte ptr [rbp + 0x603], 0x1
1803cef06: 48 8d 95 70 05 00 00        	lea	rdx, [rbp + 0x570]
1803cef0d: 48 8d 8d 38 03 00 00        	lea	rcx, [rbp + 0x338]
1803cef14: 41 b0 01                    	mov	r8b, 0x1
1803cef17: ff d0                       	call	rax
1803cef19: 48 c7 85 48 03 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x348], 0x0
1803cef24: 48 8d 85 90 02 00 00        	lea	rax, [rbp + 0x290]
1803cef2b: 48 89 85 60 01 00 00        	mov	qword ptr [rbp + 0x160], rax
1803cef32: 48 b8 a6 76 85 7a af 8f 61 1b       	movabs	rax, 0x1b618faf7a8576a6
1803cef3c: 48 33 05 85 60 3e 00        	xor	rax, qword ptr [rip + 0x3e6085] # 0x1807b4fc8
1803cef43: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cef47: 48 8d 04 c5 90 02 00 00     	lea	rax, [8*rax + 0x290]
1803cef4f: 48 01 e8                    	add	rax, rbp
1803cef52: 48 b9 30 85 19 00 d7 01 10 63       	movabs	rcx, 0x631001d700198530
1803cef5c: 48 01 c1                    	add	rcx, rax
1803cef5f: 48 89 8d 68 01 00 00        	mov	qword ptr [rbp + 0x168], rcx
1803cef66: 44 0f b6 0d fa 5f 3e 00     	movzx	r9d, byte ptr [rip + 0x3e5ffa] # 0x1807b4f68
1803cef6e: 41 80 f1 6c                 	xor	r9b, 0x6c
1803cef72: 41 80 c1 30                 	add	r9b, 0x30
1803cef76: 48 8d 8d 70 05 00 00        	lea	rcx, [rbp + 0x570]
1803cef7d: 48 8d 95 60 01 00 00        	lea	rdx, [rbp + 0x160]
1803cef84: 41 b0 01                    	mov	r8b, 0x1
1803cef87: e8 e4 13 f4 ff              	call	0x180310370 <.text+0x300370>
1803cef8c: b8 59 00 40 ea              	mov	eax, 0xea400059
1803cef91: 33 05 49 60 3e 00           	xor	eax, dword ptr [rip + 0x3e6049] # 0x1807b4fe0
1803cef97: 05 c2 ac 7f a5              	add	eax, 0xa57facc2
1803cef9c: 48 98                       	cdqe
1803cef9e: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cefa2: 48 8d 34 c5 90 02 00 00     	lea	rsi, [8*rax + 0x290]
1803cefaa: 48 01 ee                    	add	rsi, rbp
1803cefad: bf a8 00 00 00              	mov	edi, 0xa8
1803cefb2: 4c 8d 3d b7 ec 3e 00        	lea	r15, [rip + 0x3eecb7]   # 0x1807bdc70
1803cefb9: 48 8d 1d 10 4b 3f 00        	lea	rbx, [rip + 0x3f4b10]   # 0x1807c3ad0
1803cefc0: 4c 8d 35 39 dd 28 00        	lea	r14, [rip + 0x28dd39]   # 0x18065cd00
1803cefc7: 66 0f 1f 84 00 00 00 00 00  	nop	word ptr [rax + rax]
1803cefd0: 48 63 05 71 d2 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd271] # 0x1807cc248
1803cefd7: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cefdb: b9 0f 00 00 00              	mov	ecx, 0xf
1803cefe0: 29 c1                       	sub	ecx, eax
1803cefe2: d3 c2                       	rol	edx, cl
1803cefe4: f7 da                       	neg	edx
1803cefe6: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cefe9: d3 ca                       	ror	edx, cl
1803cefeb: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803ceff1: 4c 63 c2                    	movsxd	r8, edx
1803ceff4: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803ceff8: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cefff: 89 c1                       	mov	ecx, eax
1803cf001: 41 d3 c9                    	ror	r9d, cl
1803cf004: 41 0f c9                    	bswap	r9d
1803cf007: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf00c: 44 29 c2                    	sub	edx, r8d
1803cf00f: 89 d1                       	mov	ecx, edx
1803cf011: 41 d3 c1                    	rol	r9d, cl
1803cf014: 89 c1                       	mov	ecx, eax
1803cf016: 41 d3 c9                    	ror	r9d, cl
1803cf019: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf01d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf024: 41 d3 c9                    	ror	r9d, cl
1803cf027: 89 d1                       	mov	ecx, edx
1803cf029: 41 d3 c1                    	rol	r9d, cl
1803cf02c: 41 d3 c1                    	rol	r9d, cl
1803cf02f: 49 63 c1                    	movsxd	rax, r9d
1803cf032: 4c 89 c1                    	mov	rcx, r8
1803cf035: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf039: 48 83 c7 e8                 	add	rdi, -0x18
1803cf03d: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf041: 75 8d                       	jne	0x1803cefd0 <.text+0x3befd0>
1803cf043: b8 33 1b 3a 18              	mov	eax, 0x183a1b33
1803cf048: 33 05 76 5f 3e 00           	xor	eax, dword ptr [rip + 0x3e5f76] # 0x1807b4fc4
1803cf04e: 05 d5 37 c2 0b              	add	eax, 0xbc237d5
1803cf053: 48 98                       	cdqe
1803cf055: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf059: 48 8d 34 c5 50 03 00 00     	lea	rsi, [8*rax + 0x350]
1803cf061: 48 01 ee                    	add	rsi, rbp
1803cf064: bf 18 00 00 00              	mov	edi, 0x18
1803cf069: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf070: 48 63 05 c5 d1 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd1c5] # 0x1807cc23c
1803cf077: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf07b: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf080: 29 c1                       	sub	ecx, eax
1803cf082: d3 c2                       	rol	edx, cl
1803cf084: f7 da                       	neg	edx
1803cf086: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf089: d3 ca                       	ror	edx, cl
1803cf08b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf091: 4c 63 c2                    	movsxd	r8, edx
1803cf094: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf098: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf09f: 89 c1                       	mov	ecx, eax
1803cf0a1: 41 d3 c9                    	ror	r9d, cl
1803cf0a4: 41 0f c9                    	bswap	r9d
1803cf0a7: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf0ac: 44 29 c2                    	sub	edx, r8d
1803cf0af: 89 d1                       	mov	ecx, edx
1803cf0b1: 41 d3 c1                    	rol	r9d, cl
1803cf0b4: 89 c1                       	mov	ecx, eax
1803cf0b6: 41 d3 c9                    	ror	r9d, cl
1803cf0b9: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf0bd: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf0c4: 41 d3 c9                    	ror	r9d, cl
1803cf0c7: 89 d1                       	mov	ecx, edx
1803cf0c9: 41 d3 c1                    	rol	r9d, cl
1803cf0cc: 41 d3 c1                    	rol	r9d, cl
1803cf0cf: 49 63 c1                    	movsxd	rax, r9d
1803cf0d2: 4c 89 c1                    	mov	rcx, r8
1803cf0d5: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf0d9: 48 83 c7 e8                 	add	rdi, -0x18
1803cf0dd: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf0e1: 75 8d                       	jne	0x1803cf070 <.text+0x3bf070>
1803cf0e3: b8 df 1d 85 c6              	mov	eax, 0xc6851ddf
1803cf0e8: 33 05 d2 5e 3e 00           	xor	eax, dword ptr [rip + 0x3e5ed2] # 0x1807b4fc0
1803cf0ee: 05 46 97 cf 8c              	add	eax, 0x8ccf9746
1803cf0f3: 48 98                       	cdqe
1803cf0f5: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf0f9: 48 8d 34 c5 90 03 00 00     	lea	rsi, [8*rax + 0x390]
1803cf101: 48 01 ee                    	add	rsi, rbp
1803cf104: bf 18 00 00 00              	mov	edi, 0x18
1803cf109: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf110: 48 63 05 35 d1 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd135] # 0x1807cc24c
1803cf117: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf11b: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf120: 29 c1                       	sub	ecx, eax
1803cf122: d3 c2                       	rol	edx, cl
1803cf124: f7 da                       	neg	edx
1803cf126: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf129: d3 ca                       	ror	edx, cl
1803cf12b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf131: 4c 63 c2                    	movsxd	r8, edx
1803cf134: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf138: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf13f: 89 c1                       	mov	ecx, eax
1803cf141: 41 d3 c9                    	ror	r9d, cl
1803cf144: 41 0f c9                    	bswap	r9d
1803cf147: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf14c: 44 29 c2                    	sub	edx, r8d
1803cf14f: 89 d1                       	mov	ecx, edx
1803cf151: 41 d3 c1                    	rol	r9d, cl
1803cf154: 89 c1                       	mov	ecx, eax
1803cf156: 41 d3 c9                    	ror	r9d, cl
1803cf159: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf15d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf164: 41 d3 c9                    	ror	r9d, cl
1803cf167: 89 d1                       	mov	ecx, edx
1803cf169: 41 d3 c1                    	rol	r9d, cl
1803cf16c: 41 d3 c1                    	rol	r9d, cl
1803cf16f: 49 63 c1                    	movsxd	rax, r9d
1803cf172: 4c 89 c1                    	mov	rcx, r8
1803cf175: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf179: 48 83 c7 e8                 	add	rdi, -0x18
1803cf17d: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf181: 75 8d                       	jne	0x1803cf110 <.text+0x3bf110>
1803cf183: b8 24 fa 97 81              	mov	eax, 0x8197fa24
1803cf188: 33 05 4a 5e 3e 00           	xor	eax, dword ptr [rip + 0x3e5e4a] # 0x1807b4fd8
1803cf18e: 05 49 a1 5c db              	add	eax, 0xdb5ca149
1803cf193: 48 98                       	cdqe
1803cf195: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf199: 48 8d 34 c5 40 05 00 00     	lea	rsi, [8*rax + 0x540]
1803cf1a1: 48 01 ee                    	add	rsi, rbp
1803cf1a4: bf 18 00 00 00              	mov	edi, 0x18
1803cf1a9: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf1b0: 48 63 05 ed d1 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd1ed] # 0x1807cc3a4
1803cf1b7: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf1bb: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf1c0: 29 c1                       	sub	ecx, eax
1803cf1c2: d3 c2                       	rol	edx, cl
1803cf1c4: f7 da                       	neg	edx
1803cf1c6: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf1c9: d3 ca                       	ror	edx, cl
1803cf1cb: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf1d1: 4c 63 c2                    	movsxd	r8, edx
1803cf1d4: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf1d8: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf1df: 89 c1                       	mov	ecx, eax
1803cf1e1: 41 d3 c9                    	ror	r9d, cl
1803cf1e4: 41 0f c9                    	bswap	r9d
1803cf1e7: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf1ec: 44 29 c2                    	sub	edx, r8d
1803cf1ef: 89 d1                       	mov	ecx, edx
1803cf1f1: 41 d3 c1                    	rol	r9d, cl
1803cf1f4: 89 c1                       	mov	ecx, eax
1803cf1f6: 41 d3 c9                    	ror	r9d, cl
1803cf1f9: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf1fd: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf204: 41 d3 c9                    	ror	r9d, cl
1803cf207: 89 d1                       	mov	ecx, edx
1803cf209: 41 d3 c1                    	rol	r9d, cl
1803cf20c: 41 d3 c1                    	rol	r9d, cl
1803cf20f: 49 63 c1                    	movsxd	rax, r9d
1803cf212: 4c 89 c1                    	mov	rcx, r8
1803cf215: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf219: 48 83 c7 e8                 	add	rdi, -0x18
1803cf21d: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf221: 75 8d                       	jne	0x1803cf1b0 <.text+0x3bf1b0>
1803cf223: b8 69 f4 06 88              	mov	eax, 0x8806f469
1803cf228: 33 05 b6 5d 3e 00           	xor	eax, dword ptr [rip + 0x3e5db6] # 0x1807b4fe4
1803cf22e: 05 e1 67 73 c4              	add	eax, 0xc47367e1
1803cf233: 48 98                       	cdqe
1803cf235: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf239: 48 8d 34 c5 30 04 00 00     	lea	rsi, [8*rax + 0x430]
1803cf241: 48 01 ee                    	add	rsi, rbp
1803cf244: bf 18 00 00 00              	mov	edi, 0x18
1803cf249: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf250: 48 63 05 25 d1 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd125] # 0x1807cc37c
1803cf257: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf25b: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf260: 29 c1                       	sub	ecx, eax
1803cf262: d3 c2                       	rol	edx, cl
1803cf264: f7 da                       	neg	edx
1803cf266: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf269: d3 ca                       	ror	edx, cl
1803cf26b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf271: 4c 63 c2                    	movsxd	r8, edx
1803cf274: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf278: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf27f: 89 c1                       	mov	ecx, eax
1803cf281: 41 d3 c9                    	ror	r9d, cl
1803cf284: 41 0f c9                    	bswap	r9d
1803cf287: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf28c: 44 29 c2                    	sub	edx, r8d
1803cf28f: 89 d1                       	mov	ecx, edx
1803cf291: 41 d3 c1                    	rol	r9d, cl
1803cf294: 89 c1                       	mov	ecx, eax
1803cf296: 41 d3 c9                    	ror	r9d, cl
1803cf299: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf29d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf2a4: 41 d3 c9                    	ror	r9d, cl
1803cf2a7: 89 d1                       	mov	ecx, edx
1803cf2a9: 41 d3 c1                    	rol	r9d, cl
1803cf2ac: 41 d3 c1                    	rol	r9d, cl
1803cf2af: 49 63 c1                    	movsxd	rax, r9d
1803cf2b2: 4c 89 c1                    	mov	rcx, r8
1803cf2b5: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf2b9: 48 83 c7 e8                 	add	rdi, -0x18
1803cf2bd: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf2c1: 75 8d                       	jne	0x1803cf250 <.text+0x3bf250>
1803cf2c3: b8 d5 ef 54 cb              	mov	eax, 0xcb54efd5
1803cf2c8: 33 05 e2 5c 3e 00           	xor	eax, dword ptr [rip + 0x3e5ce2] # 0x1807b4fb0
1803cf2ce: 05 2f 30 35 d8              	add	eax, 0xd835302f
1803cf2d3: 48 98                       	cdqe
1803cf2d5: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf2d9: 48 8d 34 c5 10 05 00 00     	lea	rsi, [8*rax + 0x510]
1803cf2e1: 48 01 ee                    	add	rsi, rbp
1803cf2e4: bf 18 00 00 00              	mov	edi, 0x18
1803cf2e9: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf2f0: 48 63 05 95 d0 3f 00        	movsxd	rax, dword ptr [rip + 0x3fd095] # 0x1807cc38c
1803cf2f7: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf2fb: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf300: 29 c1                       	sub	ecx, eax
1803cf302: d3 c2                       	rol	edx, cl
1803cf304: f7 da                       	neg	edx
1803cf306: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf309: d3 ca                       	ror	edx, cl
1803cf30b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf311: 4c 63 c2                    	movsxd	r8, edx
1803cf314: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf318: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf31f: 89 c1                       	mov	ecx, eax
1803cf321: 41 d3 c9                    	ror	r9d, cl
1803cf324: 41 0f c9                    	bswap	r9d
1803cf327: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf32c: 44 29 c2                    	sub	edx, r8d
1803cf32f: 89 d1                       	mov	ecx, edx
1803cf331: 41 d3 c1                    	rol	r9d, cl
1803cf334: 89 c1                       	mov	ecx, eax
1803cf336: 41 d3 c9                    	ror	r9d, cl
1803cf339: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf33d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf344: 41 d3 c9                    	ror	r9d, cl
1803cf347: 89 d1                       	mov	ecx, edx
1803cf349: 41 d3 c1                    	rol	r9d, cl
1803cf34c: 41 d3 c1                    	rol	r9d, cl
1803cf34f: 49 63 c1                    	movsxd	rax, r9d
1803cf352: 4c 89 c1                    	mov	rcx, r8
1803cf355: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf359: 48 83 c7 e8                 	add	rdi, -0x18
1803cf35d: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf361: 75 8d                       	jne	0x1803cf2f0 <.text+0x3bf2f0>
1803cf363: b8 fb 06 fb fa              	mov	eax, 0xfafb06fb
1803cf368: 33 05 9a 5c 3e 00           	xor	eax, dword ptr [rip + 0x3e5c9a] # 0x1807b5008
1803cf36e: 05 8e 6b f7 e2              	add	eax, 0xe2f76b8e
1803cf373: 48 98                       	cdqe
1803cf375: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf379: 48 8d 34 c5 b0 05 00 00     	lea	rsi, [8*rax + 0x5b0]
1803cf381: 48 01 ee                    	add	rsi, rbp
1803cf384: bf 18 00 00 00              	mov	edi, 0x18
1803cf389: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf390: 48 63 05 fd cf 3f 00        	movsxd	rax, dword ptr [rip + 0x3fcffd] # 0x1807cc394
1803cf397: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf39b: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf3a0: 29 c1                       	sub	ecx, eax
1803cf3a2: d3 c2                       	rol	edx, cl
1803cf3a4: f7 da                       	neg	edx
1803cf3a6: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf3a9: d3 ca                       	ror	edx, cl
1803cf3ab: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf3b1: 4c 63 c2                    	movsxd	r8, edx
1803cf3b4: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf3b8: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf3bf: 89 c1                       	mov	ecx, eax
1803cf3c1: 41 d3 c9                    	ror	r9d, cl
1803cf3c4: 41 0f c9                    	bswap	r9d
1803cf3c7: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf3cc: 44 29 c2                    	sub	edx, r8d
1803cf3cf: 89 d1                       	mov	ecx, edx
1803cf3d1: 41 d3 c1                    	rol	r9d, cl
1803cf3d4: 89 c1                       	mov	ecx, eax
1803cf3d6: 41 d3 c9                    	ror	r9d, cl
1803cf3d9: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf3dd: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf3e4: 41 d3 c9                    	ror	r9d, cl
1803cf3e7: 89 d1                       	mov	ecx, edx
1803cf3e9: 41 d3 c1                    	rol	r9d, cl
1803cf3ec: 41 d3 c1                    	rol	r9d, cl
1803cf3ef: 49 63 c1                    	movsxd	rax, r9d
1803cf3f2: 4c 89 c1                    	mov	rcx, r8
1803cf3f5: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf3f9: 48 83 c7 e8                 	add	rdi, -0x18
1803cf3fd: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf401: 75 8d                       	jne	0x1803cf390 <.text+0x3bf390>
1803cf403: b8 f7 64 a4 55              	mov	eax, 0x55a464f7
1803cf408: 33 05 f2 5b 3e 00           	xor	eax, dword ptr [rip + 0x3e5bf2] # 0x1807b5000
1803cf40e: 05 27 81 ae d3              	add	eax, 0xd3ae8127
1803cf413: 48 98                       	cdqe
1803cf415: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf419: 48 8d 34 c5 80 05 00 00     	lea	rsi, [8*rax + 0x580]
1803cf421: 48 01 ee                    	add	rsi, rbp
1803cf424: bf 18 00 00 00              	mov	edi, 0x18
1803cf429: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf430: 48 63 05 65 cf 3f 00        	movsxd	rax, dword ptr [rip + 0x3fcf65] # 0x1807cc39c
1803cf437: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf43b: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf440: 29 c1                       	sub	ecx, eax
1803cf442: d3 c2                       	rol	edx, cl
1803cf444: f7 da                       	neg	edx
1803cf446: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf449: d3 ca                       	ror	edx, cl
1803cf44b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf451: 4c 63 c2                    	movsxd	r8, edx
1803cf454: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf458: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf45f: 89 c1                       	mov	ecx, eax
1803cf461: 41 d3 c9                    	ror	r9d, cl
1803cf464: 41 0f c9                    	bswap	r9d
1803cf467: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf46c: 44 29 c2                    	sub	edx, r8d
1803cf46f: 89 d1                       	mov	ecx, edx
1803cf471: 41 d3 c1                    	rol	r9d, cl
1803cf474: 89 c1                       	mov	ecx, eax
1803cf476: 41 d3 c9                    	ror	r9d, cl
1803cf479: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf47d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf484: 41 d3 c9                    	ror	r9d, cl
1803cf487: 89 d1                       	mov	ecx, edx
1803cf489: 41 d3 c1                    	rol	r9d, cl
1803cf48c: 41 d3 c1                    	rol	r9d, cl
1803cf48f: 49 63 c1                    	movsxd	rax, r9d
1803cf492: 4c 89 c1                    	mov	rcx, r8
1803cf495: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf499: 48 83 c7 e8                 	add	rdi, -0x18
1803cf49d: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf4a1: 75 8d                       	jne	0x1803cf430 <.text+0x3bf430>
1803cf4a3: b8 0d 22 db 2e              	mov	eax, 0x2edb220d
1803cf4a8: 33 05 56 5b 3e 00           	xor	eax, dword ptr [rip + 0x3e5b56] # 0x1807b5004
1803cf4ae: 05 ba 6b ce ca              	add	eax, 0xcace6bba
1803cf4b3: 48 98                       	cdqe
1803cf4b5: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf4b9: 48 8d 34 c5 10 02 00 00     	lea	rsi, [8*rax + 0x210]
1803cf4c1: 48 01 ee                    	add	rsi, rbp
1803cf4c4: bf 18 00 00 00              	mov	edi, 0x18
1803cf4c9: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803cf4d0: 48 63 05 b9 ce 3f 00        	movsxd	rax, dword ptr [rip + 0x3fceb9] # 0x1807cc390
1803cf4d7: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803cf4db: b9 0f 00 00 00              	mov	ecx, 0xf
1803cf4e0: 29 c1                       	sub	ecx, eax
1803cf4e2: d3 c2                       	rol	edx, cl
1803cf4e4: f7 da                       	neg	edx
1803cf4e6: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803cf4e9: d3 ca                       	ror	edx, cl
1803cf4eb: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803cf4f1: 4c 63 c2                    	movsxd	r8, edx
1803cf4f4: 46 8b 0c 83                 	mov	r9d, dword ptr [rbx + 4*r8]
1803cf4f8: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803cf4ff: 89 c1                       	mov	ecx, eax
1803cf501: 41 d3 c9                    	ror	r9d, cl
1803cf504: 41 0f c9                    	bswap	r9d
1803cf507: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803cf50c: 44 29 c2                    	sub	edx, r8d
1803cf50f: 89 d1                       	mov	ecx, edx
1803cf511: 41 d3 c1                    	rol	r9d, cl
1803cf514: 89 c1                       	mov	ecx, eax
1803cf516: 41 d3 c9                    	ror	r9d, cl
1803cf519: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803cf51d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803cf524: 41 d3 c9                    	ror	r9d, cl
1803cf527: 89 d1                       	mov	ecx, edx
1803cf529: 41 d3 c1                    	rol	r9d, cl
1803cf52c: 41 d3 c1                    	rol	r9d, cl
1803cf52f: 49 63 c1                    	movsxd	rax, r9d
1803cf532: 4c 89 c1                    	mov	rcx, r8
1803cf535: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803cf539: 48 83 c7 e8                 	add	rdi, -0x18
1803cf53d: 48 83 ff e8                 	cmp	rdi, -0x18
1803cf541: 75 8d                       	jne	0x1803cf4d0 <.text+0x3bf4d0>
1803cf543: 41 b8 f1 bb e7 cd           	mov	r8d, 0xcde7bbf1
1803cf549: 44 33 05 f0 59 3e 00        	xor	r8d, dword ptr [rip + 0x3e59f0] # 0x1807b4f40
1803cf550: 41 81 c0 48 16 7d f3        	add	r8d, 0xf37d1648
1803cf557: 44 0f b6 0d e5 59 3e 00     	movzx	r9d, byte ptr [rip + 0x3e59e5] # 0x1807b4f44
1803cf55f: 41 80 f1 0b                 	xor	r9b, 0xb
1803cf563: 41 80 c1 03                 	add	r9b, 0x3
1803cf567: b8 99 61 30 b6              	mov	eax, 0xb6306199
1803cf56c: 33 05 d6 59 3e 00           	xor	eax, dword ptr [rip + 0x3e59d6] # 0x1807b4f48
1803cf572: 05 b8 fb a0 e5              	add	eax, 0xe5a0fbb8
1803cf577: 89 44 24 28                 	mov	dword ptr [rsp + 0x28], eax
1803cf57b: c6 44 24 20 00              	mov	byte ptr [rsp + 0x20], 0x0
1803cf580: 48 8d 8d 70 05 00 00        	lea	rcx, [rbp + 0x570]
1803cf587: 48 8d 95 90 02 00 00        	lea	rdx, [rbp + 0x290]
1803cf58e: e8 0d b3 f4 ff              	call	0x18031a8a0 <.text+0x30a8a0>
1803cf593: 48 63 15 be cd 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fcdbe] # 0x1807cc358
1803cf59a: 4c 8d 3d 5f d7 28 00        	lea	r15, [rip + 0x28d75f]   # 0x18065cd00
1803cf5a1: 41 8b 04 97                 	mov	eax, dword ptr [r15 + 4*rdx]
1803cf5a5: 41 b8 30 37 6d 22           	mov	r8d, 0x226d3730
1803cf5ab: 41 29 d0                    	sub	r8d, edx
1803cf5ae: 44 89 c1                    	mov	ecx, r8d
1803cf5b1: d3 c0                       	rol	eax, cl
1803cf5b3: 83 f2 10                    	xor	edx, 0x10
1803cf5b6: 89 d1                       	mov	ecx, edx
1803cf5b8: d3 c8                       	ror	eax, cl
1803cf5ba: 44 89 c1                    	mov	ecx, r8d
1803cf5bd: d3 c0                       	rol	eax, cl
1803cf5bf: 89 c1                       	mov	ecx, eax
1803cf5c1: f7 d9                       	neg	ecx
1803cf5c3: 48 63 c9                    	movsxd	rcx, ecx
1803cf5c6: 48 8d 1d 03 45 3f 00        	lea	rbx, [rip + 0x3f4503]   # 0x1807c3ad0
1803cf5cd: 44 8b 04 8b                 	mov	r8d, dword ptr [rbx + 4*rcx]
1803cf5d1: 41 0f c8                    	bswap	r8d
1803cf5d4: ba 28 57 c4 2e              	mov	edx, 0x2ec45728
1803cf5d9: 29 c2                       	sub	edx, eax
1803cf5db: 89 d1                       	mov	ecx, edx
1803cf5dd: 41 d3 c8                    	ror	r8d, cl
1803cf5e0: 05 28 57 c4 2e              	add	eax, 0x2ec45728
1803cf5e5: 89 c1                       	mov	ecx, eax
1803cf5e7: 41 d3 c0                    	rol	r8d, cl
1803cf5ea: 89 d1                       	mov	ecx, edx
1803cf5ec: 41 d3 c8                    	ror	r8d, cl
1803cf5ef: 41 81 f0 d7 a8 3b d1        	xor	r8d, 0xd13ba8d7
1803cf5f6: 41 ff c0                    	inc	r8d
1803cf5f9: 89 c1                       	mov	ecx, eax
1803cf5fb: 41 d3 c0                    	rol	r8d, cl
1803cf5fe: 41 f7 d0                    	not	r8d
1803cf601: 49 63 c0                    	movsxd	rax, r8d
1803cf604: 48 8d b5 00 01 00 00        	lea	rsi, [rbp + 0x100]
1803cf60b: 48 8d bd 90 02 00 00        	lea	rdi, [rbp + 0x290]
1803cf612: 48 89 f1                    	mov	rcx, rsi
1803cf615: 48 89 fa                    	mov	rdx, rdi
1803cf618: 4c 8d 35 51 e6 3e 00        	lea	r14, [rip + 0x3ee651]   # 0x1807bdc70
1803cf61f: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cf623: 48 63 15 4e cd 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fcd4e] # 0x1807cc378
1803cf62a: 41 8b 04 97                 	mov	eax, dword ptr [r15 + 4*rdx]
1803cf62e: b9 13 00 00 00              	mov	ecx, 0x13
1803cf633: 29 d1                       	sub	ecx, edx
1803cf635: d3 c0                       	rol	eax, cl
1803cf637: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803cf63c: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803cf641: 29 c1                       	sub	ecx, eax
1803cf643: 48 63 c9                    	movsxd	rcx, ecx
1803cf646: 31 d2                       	xor	edx, edx
1803cf648: 2b 14 8b                    	sub	edx, dword ptr [rbx + 4*rcx]
1803cf64b: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803cf650: 29 c1                       	sub	ecx, eax
1803cf652: d3 ca                       	ror	edx, cl
1803cf654: d3 ca                       	ror	edx, cl
1803cf656: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803cf65c: d3 ca                       	ror	edx, cl
1803cf65e: 45 31 ff                    	xor	r15d, r15d
1803cf661: 05 d2 45 48 92              	add	eax, 0x924845d2
1803cf666: 89 c1                       	mov	ecx, eax
1803cf668: d3 c2                       	rol	edx, cl
1803cf66a: d3 c2                       	rol	edx, cl
1803cf66c: 48 63 c2                    	movsxd	rax, edx
1803cf66f: 48 89 f9                    	mov	rcx, rdi
1803cf672: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cf676: 48 8d 8d 70 05 00 00        	lea	rcx, [rbp + 0x570]
1803cf67d: e8 ae c5 f4 ff              	call	0x18031bc30 <.text+0x30bc30>
1803cf682: 48 63 05 ff cc 3f 00        	movsxd	rax, dword ptr [rip + 0x3fccff] # 0x1807cc388
1803cf689: 48 8d 0d 70 d6 28 00        	lea	rcx, [rip + 0x28d670]   # 0x18065cd00
1803cf690: 44 2b 3c 81                 	sub	r15d, dword ptr [rcx + 4*rax]
1803cf694: 41 0f cf                    	bswap	r15d
1803cf697: 8d 88 79 d4 73 af           	lea	ecx, [rax - 0x508c2b87]
1803cf69d: 41 d3 cf                    	ror	r15d, cl
1803cf6a0: 41 d3 cf                    	ror	r15d, cl
1803cf6a3: 49 63 c7                    	movsxd	rax, r15d
1803cf6a6: 48 8d 0d 23 44 3f 00        	lea	rcx, [rip + 0x3f4423]   # 0x1807c3ad0
1803cf6ad: 8b 14 81                    	mov	edx, dword ptr [rcx + 4*rax]
1803cf6b0: b9 89 92 20 64              	mov	ecx, 0x64209289
1803cf6b5: 29 c1                       	sub	ecx, eax
1803cf6b7: d3 c2                       	rol	edx, cl
1803cf6b9: d3 c2                       	rol	edx, cl
1803cf6bb: 81 f2 89 92 20 64           	xor	edx, 0x64209289
1803cf6c1: 0f ca                       	bswap	edx
1803cf6c3: 48 63 c2                    	movsxd	rax, edx
1803cf6c6: 48 8d 8d 70 05 00 00        	lea	rcx, [rbp + 0x570]
1803cf6cd: 48 8d 15 9c e5 3e 00        	lea	rdx, [rip + 0x3ee59c]   # 0x1807bdc70
1803cf6d4: ff 14 c2                    	call	qword ptr [rdx + 8*rax]
1803cf6d7: 48 8d 8d c0 01 00 00        	lea	rcx, [rbp + 0x1c0]
1803cf6de: e8 8d c2 f4 ff              	call	0x18031b970 <.text+0x30b970>
1803cf6e3: 48 63 05 9a cb 3f 00        	movsxd	rax, dword ptr [rip + 0x3fcb9a] # 0x1807cc284
1803cf6ea: 4c 8d 3d 0f d6 28 00        	lea	r15, [rip + 0x28d60f]   # 0x18065cd00
1803cf6f1: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cf6f5: 8d 48 04                    	lea	ecx, [rax + 0x4]
1803cf6f8: d3 ca                       	ror	edx, cl
1803cf6fa: f7 d2                       	not	edx
1803cf6fc: b9 04 00 00 00              	mov	ecx, 0x4
1803cf701: 29 c1                       	sub	ecx, eax
1803cf703: d3 c2                       	rol	edx, cl
1803cf705: 81 f2 c4 b7 1f 4b           	xor	edx, 0x4b1fb7c4
1803cf70b: 48 63 c2                    	movsxd	rax, edx
1803cf70e: 48 8d 3d bb 43 3f 00        	lea	rdi, [rip + 0x3f43bb]   # 0x1807c3ad0
1803cf715: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
1803cf718: b9 0e 00 00 00              	mov	ecx, 0xe
1803cf71d: 29 c1                       	sub	ecx, eax
1803cf71f: d3 c2                       	rol	edx, cl
1803cf721: 05 8e ad d3 f2              	add	eax, 0xf2d3ad8e
1803cf726: 89 c1                       	mov	ecx, eax
1803cf728: d3 ca                       	ror	edx, cl
1803cf72a: f7 da                       	neg	edx
1803cf72c: d3 ca                       	ror	edx, cl
1803cf72e: f7 da                       	neg	edx
1803cf730: 81 f2 8e ad d3 f2           	xor	edx, 0xf2d3ad8e
1803cf736: ff ca                       	dec	edx
1803cf738: 48 63 c2                    	movsxd	rax, edx
1803cf73b: 4c 8d b5 10 02 00 00        	lea	r14, [rbp + 0x210]
1803cf742: 4c 89 f1                    	mov	rcx, r14
1803cf745: 48 8d 1d 24 e5 3e 00        	lea	rbx, [rip + 0x3ee524]   # 0x1807bdc70
1803cf74c: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cf74f: 48 63 15 2e cc 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fcc2e] # 0x1807cc384
1803cf756: 41 8b 04 97                 	mov	eax, dword ptr [r15 + 4*rdx]
1803cf75a: b9 13 00 00 00              	mov	ecx, 0x13
1803cf75f: 29 d1                       	sub	ecx, edx
1803cf761: d3 c0                       	rol	eax, cl
1803cf763: 89 c1                       	mov	ecx, eax
1803cf765: f7 d9                       	neg	ecx
1803cf767: 48 63 c9                    	movsxd	rcx, ecx
1803cf76a: 8b 14 8f                    	mov	edx, dword ptr [rdi + 4*rcx]
1803cf76d: 05 32 f6 1c 92              	add	eax, 0x921cf632
1803cf772: 89 c1                       	mov	ecx, eax
1803cf774: d3 c2                       	rol	edx, cl
1803cf776: d3 c2                       	rol	edx, cl
1803cf778: f7 da                       	neg	edx
1803cf77a: d3 c2                       	rol	edx, cl
1803cf77c: 48 63 c2                    	movsxd	rax, edx
1803cf77f: 4c 89 f1                    	mov	rcx, r14
1803cf782: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cf785: 48 63 0d d0 cb 3f 00        	movsxd	rcx, dword ptr [rip + 0x3fcbd0] # 0x1807cc35c
1803cf78c: 41 8b 0c 8f                 	mov	ecx, dword ptr [r15 + 4*rcx]
1803cf790: 0f c9                       	bswap	ecx
1803cf792: f7 d9                       	neg	ecx
1803cf794: 0f c9                       	bswap	ecx
1803cf796: 89 ca                       	mov	edx, ecx
1803cf798: f7 da                       	neg	edx
1803cf79a: 48 63 d2                    	movsxd	rdx, edx
1803cf79d: 45 31 c0                    	xor	r8d, r8d
1803cf7a0: 44 2b 04 97                 	sub	r8d, dword ptr [rdi + 4*rdx]
1803cf7a4: 41 0f c8                    	bswap	r8d
1803cf7a7: 81 c1 11 39 22 28           	add	ecx, 0x28223911
1803cf7ad: 41 d3 c0                    	rol	r8d, cl
1803cf7b0: 41 d3 c0                    	rol	r8d, cl
1803cf7b3: 4d 63 c0                    	movsxd	r8, r8d
1803cf7b6: 48 8d 7d 38                 	lea	rdi, [rbp + 0x38]
1803cf7ba: 48 89 f9                    	mov	rcx, rdi
1803cf7bd: 48 89 c2                    	mov	rdx, rax
1803cf7c0: 42 ff 14 c3                 	call	qword ptr [rbx + 8*r8]
1803cf7c4: 48 89 74 24 20              	mov	qword ptr [rsp + 0x20], rsi
1803cf7c9: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cf7d0: 48 8d 95 e0 00 00 00        	lea	rdx, [rbp + 0xe0]
1803cf7d7: 4c 8d 85 a0 01 00 00        	lea	r8, [rbp + 0x1a0]
1803cf7de: 49 89 f9                    	mov	r9, rdi
1803cf7e1: e8 2a 4e f5 ff              	call	0x180324610 <.text+0x314610>
1803cf7e6: 48 8d 8d 00 01 00 00        	lea	rcx, [rbp + 0x100]
1803cf7ed: e8 7e c1 f4 ff              	call	0x18031b970 <.text+0x30b970>
1803cf7f2: 48 63 15 9f cb 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fcb9f] # 0x1807cc398
1803cf7f9: 48 8d 35 00 d5 28 00        	lea	rsi, [rip + 0x28d500]   # 0x18065cd00
1803cf800: 8b 04 96                    	mov	eax, dword ptr [rsi + 4*rdx]
1803cf803: 8d 4a 05                    	lea	ecx, [rdx + 0x5]
1803cf806: d3 c8                       	ror	eax, cl
1803cf808: b9 05 00 00 00              	mov	ecx, 0x5
1803cf80d: 29 d1                       	sub	ecx, edx
1803cf80f: d3 c0                       	rol	eax, cl
1803cf811: 89 c1                       	mov	ecx, eax
1803cf813: 81 f1 3a c6 f5 a0           	xor	ecx, 0xa0f5c63a
1803cf819: 48 63 d1                    	movsxd	rdx, ecx
1803cf81c: 4c 8d 2d ad 42 3f 00        	lea	r13, [rip + 0x3f42ad]   # 0x1807c3ad0
1803cf823: 45 8b 44 95 00              	mov	r8d, dword ptr [r13 + 4*rdx]
1803cf828: 83 f0 05                    	xor	eax, 0x5
1803cf82b: 89 c1                       	mov	ecx, eax
1803cf82d: 41 d3 c0                    	rol	r8d, cl
1803cf830: 41 81 f0 df 64 05 19        	xor	r8d, 0x190564df
1803cf837: ff ca                       	dec	edx
1803cf839: 89 d1                       	mov	ecx, edx
1803cf83b: 41 d3 c8                    	ror	r8d, cl
1803cf83e: b8 01 00 00 00              	mov	eax, 0x1
1803cf843: 44 29 c0                    	sub	eax, r8d
1803cf846: 35 19 05 64 df              	xor	eax, 0xdf640519
1803cf84b: 0f c8                       	bswap	eax
1803cf84d: 48 98                       	cdqe
1803cf84f: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cf856: 4c 8d 25 13 e4 3e 00        	lea	r12, [rip + 0x3ee413]   # 0x1807bdc70
1803cf85d: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803cf861: 84 c0                       	test	al, al
1803cf863: 0f 84 fc 18 00 00           	je	0x1803d1165 <.text+0x3c1165>
1803cf869: 48 63 05 18 ca 3f 00        	movsxd	rax, dword ptr [rip + 0x3fca18] # 0x1807cc288
1803cf870: 44 8b 04 86                 	mov	r8d, dword ptr [rsi + 4*rax]
1803cf874: b9 10 00 00 00              	mov	ecx, 0x10
1803cf879: 29 c1                       	sub	ecx, eax
1803cf87b: 41 d3 c0                    	rol	r8d, cl
1803cf87e: 41 8d 80 b4 59 16 7f        	lea	eax, [r8 + 0x7f1659b4]
1803cf885: ba b2 59 16 7f              	mov	edx, 0x7f1659b2
1803cf88a: 44 29 c2                    	sub	edx, r8d
1803cf88d: 44 89 c1                    	mov	ecx, r8d
1803cf890: f7 d1                       	not	ecx
1803cf892: 48 63 c9                    	movsxd	rcx, ecx
1803cf895: 45 8b 44 8d 00              	mov	r8d, dword ptr [r13 + 4*rcx]
1803cf89a: 89 c1                       	mov	ecx, eax
1803cf89c: 41 d3 c0                    	rol	r8d, cl
1803cf89f: 89 d1                       	mov	ecx, edx
1803cf8a1: 41 d3 c8                    	ror	r8d, cl
1803cf8a4: 41 d3 c8                    	ror	r8d, cl
1803cf8a7: 89 c1                       	mov	ecx, eax
1803cf8a9: 41 d3 c0                    	rol	r8d, cl
1803cf8ac: 89 d1                       	mov	ecx, edx
1803cf8ae: 41 d3 c8                    	ror	r8d, cl
1803cf8b1: 41 d3 c8                    	ror	r8d, cl
1803cf8b4: 49 63 c0                    	movsxd	rax, r8d
1803cf8b7: 48 89 f7                    	mov	rdi, rsi
1803cf8ba: 48 8d 75 70                 	lea	rsi, [rbp + 0x70]
1803cf8be: 48 89 f1                    	mov	rcx, rsi
1803cf8c1: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803cf8c5: 48 63 05 d4 ca 3f 00        	movsxd	rax, dword ptr [rip + 0x3fcad4] # 0x1807cc3a0
1803cf8cc: 44 8b 04 87                 	mov	r8d, dword ptr [rdi + 4*rax]
1803cf8d0: 41 0f c8                    	bswap	r8d
1803cf8d3: 8d 48 04                    	lea	ecx, [rax + 0x4]
1803cf8d6: 41 d3 c8                    	ror	r8d, cl
1803cf8d9: b9 04 00 00 00              	mov	ecx, 0x4
1803cf8de: 29 c1                       	sub	ecx, eax
1803cf8e0: 41 d3 c0                    	rol	r8d, cl
1803cf8e3: 41 8d 80 8e 1e df aa        	lea	eax, [r8 - 0x5520e172]
1803cf8ea: ba 8c 1e df aa              	mov	edx, 0xaadf1e8c
1803cf8ef: 44 29 c2                    	sub	edx, r8d
1803cf8f2: 44 89 c1                    	mov	ecx, r8d
1803cf8f5: f7 d1                       	not	ecx
1803cf8f7: 48 63 c9                    	movsxd	rcx, ecx
1803cf8fa: 45 8b 44 8d 00              	mov	r8d, dword ptr [r13 + 4*rcx]
1803cf8ff: 41 f7 d0                    	not	r8d
1803cf902: 89 c1                       	mov	ecx, eax
1803cf904: 41 d3 c0                    	rol	r8d, cl
1803cf907: 89 d1                       	mov	ecx, edx
1803cf909: 41 d3 c8                    	ror	r8d, cl
1803cf90c: 89 c1                       	mov	ecx, eax
1803cf90e: 41 d3 c0                    	rol	r8d, cl
1803cf911: 41 d3 c0                    	rol	r8d, cl
1803cf914: 41 f7 d0                    	not	r8d
1803cf917: 41 d3 c0                    	rol	r8d, cl
1803cf91a: 89 d1                       	mov	ecx, edx
1803cf91c: 41 d3 c8                    	ror	r8d, cl
1803cf91f: 49 63 c0                    	movsxd	rax, r8d
1803cf922: 48 89 f1                    	mov	rcx, rsi
1803cf925: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803cf929: 48 89 85 80 01 00 00        	mov	qword ptr [rbp + 0x180], rax
1803cf930: 8b 0d e2 0b 4c 00           	mov	ecx, dword ptr [rip + 0x4c0be2] # 0x180890518
1803cf936: 83 c1 18                    	add	ecx, 0x18
1803cf939: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803cf93e: d3 c8                       	ror	eax, cl
1803cf940: 48 98                       	cdqe
1803cf942: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803cf947: b9 07 00 00 00              	mov	ecx, 0x7
1803cf94c: 29 c1                       	sub	ecx, eax
1803cf94e: d3 c2                       	rol	edx, cl
1803cf950: 0f ca                       	bswap	edx
1803cf952: 48 63 c2                    	movsxd	rax, edx
1803cf955: 49 8b 04 c4                 	mov	rax, qword ptr [r12 + 8*rax]
1803cf959: 4c 89 b5 c0 03 00 00        	mov	qword ptr [rbp + 0x3c0], r14
1803cf960: c6 85 f7 05 00 00 01        	mov	byte ptr [rbp + 0x5f7], 0x1
1803cf967: 48 8d b5 80 05 00 00        	lea	rsi, [rbp + 0x580]
1803cf96e: 48 8d 95 80 01 00 00        	lea	rdx, [rbp + 0x180]
1803cf975: 48 89 f1                    	mov	rcx, rsi
1803cf978: ff d0                       	call	rax
1803cf97a: 48 c7 85 90 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x590], 0x0
1803cf985: 48 63 05 c8 c9 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc9c8] # 0x1807cc354
1803cf98c: 48 8d 0d 6d d3 28 00        	lea	rcx, [rip + 0x28d36d]   # 0x18065cd00
1803cf993: 48 63 04 81                 	movsxd	rax, dword ptr [rcx + 4*rax]
1803cf997: 48 35 40 1f e4 dc           	xor	rax, -0x231be0c0
1803cf99d: 48 8d 1d 2c 41 3f 00        	lea	rbx, [rip + 0x3f412c]   # 0x1807c3ad0
1803cf9a4: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803cf9a7: f7 d2                       	not	edx
1803cf9a9: 8d 88 94 64 58 87           	lea	ecx, [rax - 0x78a79b6c]
1803cf9af: d3 ca                       	ror	edx, cl
1803cf9b1: d3 ca                       	ror	edx, cl
1803cf9b3: f7 da                       	neg	edx
1803cf9b5: d3 ca                       	ror	edx, cl
1803cf9b7: 48 8d 8d 98 05 00 00        	lea	rcx, [rbp + 0x598]
1803cf9be: 0f ca                       	bswap	edx
1803cf9c0: 48 63 c2                    	movsxd	rax, edx
1803cf9c3: 48 8d 15 17 7e 28 00        	lea	rdx, [rip + 0x287e17]   # 0x1806577e1
1803cf9ca: 48 8d 3d 9f e2 3e 00        	lea	rdi, [rip + 0x3ee29f]   # 0x1807bdc70
1803cf9d1: ff 14 c7                    	call	qword ptr [rdi + 8*rax]
1803cf9d4: 48 b8 b9 97 75 93 2a c9 cc 14       	movabs	rax, 0x14ccc92a937597b9
1803cf9de: 48 33 05 2b 56 3e 00        	xor	rax, qword ptr [rip + 0x3e562b] # 0x1807b5010
1803cf9e5: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cf9e9: 48 8d 04 c5 80 05 00 00     	lea	rax, [8*rax + 0x580]
1803cf9f1: 48 01 e8                    	add	rax, rbp
1803cf9f4: 48 b9 38 da 4c db 96 68 43 60       	movabs	rcx, 0x60436896db4cda38
1803cf9fe: 48 01 c1                    	add	rcx, rax
1803cfa01: 48 89 b5 b0 05 00 00        	mov	qword ptr [rbp + 0x5b0], rsi
1803cfa08: 48 89 8d b8 05 00 00        	mov	qword ptr [rbp + 0x5b8], rcx
1803cfa0f: 44 0f b6 0d d9 fd 3d 00     	movzx	r9d, byte ptr [rip + 0x3dfdd9] # 0x1807af7f0
1803cfa17: 41 80 f1 ea                 	xor	r9b, -0x16
1803cfa1b: 8b 0d ff 0a 4c 00           	mov	ecx, dword ptr [rip + 0x4c0aff] # 0x180890520
1803cfa21: ff c1                       	inc	ecx
1803cfa23: b8 e2 08 00 00              	mov	eax, 0x8e2
1803cfa28: d3 c8                       	ror	eax, cl
1803cfa2a: 48 63 c8                    	movsxd	rcx, eax
1803cfa2d: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803cfa32: 33 04 8b                    	xor	eax, dword ptr [rbx + 4*rcx]
1803cfa35: 41 80 c1 83                 	add	r9b, -0x7d
1803cfa39: ff c8                       	dec	eax
1803cfa3b: 83 c1 0b                    	add	ecx, 0xb
1803cfa3e: d3 c8                       	ror	eax, cl
1803cfa40: 0f c8                       	bswap	eax
1803cfa42: 48 98                       	cdqe
1803cfa44: 48 8b 04 c7                 	mov	rax, qword ptr [rdi + 8*rax]
1803cfa48: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803cfa4f: 48 89 8d c8 03 00 00        	mov	qword ptr [rbp + 0x3c8], rcx
1803cfa56: c6 85 f8 05 00 00 01        	mov	byte ptr [rbp + 0x5f8], 0x1
1803cfa5d: 48 8d 9d b0 05 00 00        	lea	rbx, [rbp + 0x5b0]
1803cfa64: 48 89 da                    	mov	rdx, rbx
1803cfa67: 41 b0 01                    	mov	r8b, 0x1
1803cfa6a: ff d0                       	call	rax
1803cfa6c: 48 8d bd 28 02 00 00        	lea	rdi, [rbp + 0x228]
1803cfa73: 48 c7 85 20 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x220], 0x0
1803cfa7e: 48 63 15 1b c8 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fc81b] # 0x1807cc2a0
1803cfa85: 4c 8d 25 74 d2 28 00        	lea	r12, [rip + 0x28d274]   # 0x18065cd00
1803cfa8c: 41 8b 04 94                 	mov	eax, dword ptr [r12 + 4*rdx]
1803cfa90: 0f c8                       	bswap	eax
1803cfa92: b9 1d 00 00 00              	mov	ecx, 0x1d
1803cfa97: 29 d1                       	sub	ecx, edx
1803cfa99: d3 c0                       	rol	eax, cl
1803cfa9b: 8d 48 01                    	lea	ecx, [rax + 0x1]
1803cfa9e: 48 63 c9                    	movsxd	rcx, ecx
1803cfaa1: 4c 8d 3d 28 40 3f 00        	lea	r15, [rip + 0x3f4028]   # 0x1807c3ad0
1803cfaa8: 41 8b 14 8f                 	mov	edx, dword ptr [r15 + 4*rcx]
1803cfaac: 05 cd 60 fe f9              	add	eax, 0xf9fe60cd
1803cfab1: 89 c1                       	mov	ecx, eax
1803cfab3: d3 ca                       	ror	edx, cl
1803cfab5: d3 ca                       	ror	edx, cl
1803cfab7: 81 f2 33 9f 01 06           	xor	edx, 0x6019f33
1803cfabd: ff c2                       	inc	edx
1803cfabf: d3 ca                       	ror	edx, cl
1803cfac1: 0f ca                       	bswap	edx
1803cfac3: 48 63 c2                    	movsxd	rax, edx
1803cfac6: 48 8d b5 80 00 00 00        	lea	rsi, [rbp + 0x80]
1803cfacd: 48 89 f1                    	mov	rcx, rsi
1803cfad0: 4c 8d 35 99 e1 3e 00        	lea	r14, [rip + 0x3ee199]   # 0x1807bdc70
1803cfad7: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cfadb: 48 63 05 9e c8 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc89e] # 0x1807cc380
1803cfae2: 31 d2                       	xor	edx, edx
1803cfae4: 41 2b 14 84                 	sub	edx, dword ptr [r12 + 4*rax]
1803cfae8: b9 10 00 00 00              	mov	ecx, 0x10
1803cfaed: 29 c1                       	sub	ecx, eax
1803cfaef: d3 c2                       	rol	edx, cl
1803cfaf1: 48 63 c2                    	movsxd	rax, edx
1803cfaf4: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cfaf8: 8d 88 18 a9 71 bd           	lea	ecx, [rax - 0x428e56e8]
1803cfafe: d3 ca                       	ror	edx, cl
1803cfb00: f7 da                       	neg	edx
1803cfb02: d3 ca                       	ror	edx, cl
1803cfb04: d3 ca                       	ror	edx, cl
1803cfb06: b9 18 00 00 00              	mov	ecx, 0x18
1803cfb0b: 29 c1                       	sub	ecx, eax
1803cfb0d: d3 c2                       	rol	edx, cl
1803cfb0f: 0f ca                       	bswap	edx
1803cfb11: 48 63 c2                    	movsxd	rax, edx
1803cfb14: 48 89 f1                    	mov	rcx, rsi
1803cfb17: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cfb1b: 48 89 85 90 01 00 00        	mov	qword ptr [rbp + 0x190], rax
1803cfb22: 8b 0d f0 09 4c 00           	mov	ecx, dword ptr [rip + 0x4c09f0] # 0x180890518
1803cfb28: 83 c1 18                    	add	ecx, 0x18
1803cfb2b: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803cfb30: d3 c8                       	ror	eax, cl
1803cfb32: 48 98                       	cdqe
1803cfb34: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cfb38: b9 07 00 00 00              	mov	ecx, 0x7
1803cfb3d: 29 c1                       	sub	ecx, eax
1803cfb3f: d3 c2                       	rol	edx, cl
1803cfb41: 0f ca                       	bswap	edx
1803cfb43: 48 63 c2                    	movsxd	rax, edx
1803cfb46: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803cfb4a: 48 89 9d 70 04 00 00        	mov	qword ptr [rbp + 0x470], rbx
1803cfb51: 48 89 bd 68 04 00 00        	mov	qword ptr [rbp + 0x468], rdi
1803cfb58: c6 85 05 06 00 00 00        	mov	byte ptr [rbp + 0x605], 0x0
1803cfb5f: c6 85 04 06 00 00 01        	mov	byte ptr [rbp + 0x604], 0x1
1803cfb66: 48 8d 95 90 01 00 00        	lea	rdx, [rbp + 0x190]
1803cfb6d: 48 89 d9                    	mov	rcx, rbx
1803cfb70: ff d0                       	call	rax
1803cfb72: 48 c7 85 c0 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x5c0], 0x0
1803cfb7d: 48 63 05 50 c8 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc850] # 0x1807cc3d4
1803cfb84: 48 8d 0d 75 d1 28 00        	lea	rcx, [rip + 0x28d175]   # 0x18065cd00
1803cfb8b: 8b 14 81                    	mov	edx, dword ptr [rcx + 4*rax]
1803cfb8e: 8d 48 19                    	lea	ecx, [rax + 0x19]
1803cfb91: d3 ca                       	ror	edx, cl
1803cfb93: 0f ca                       	bswap	edx
1803cfb95: f7 da                       	neg	edx
1803cfb97: 81 f2 79 c3 2b a3           	xor	edx, 0xa32bc379
1803cfb9d: 48 63 c2                    	movsxd	rax, edx
1803cfba0: 48 8d 1d 29 3f 3f 00        	lea	rbx, [rip + 0x3f3f29]   # 0x1807c3ad0
1803cfba7: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803cfbaa: f7 d2                       	not	edx
1803cfbac: 0f ca                       	bswap	edx
1803cfbae: f7 da                       	neg	edx
1803cfbb0: 8d 48 03                    	lea	ecx, [rax + 0x3]
1803cfbb3: d3 ca                       	ror	edx, cl
1803cfbb5: f7 d2                       	not	edx
1803cfbb7: b9 03 00 00 00              	mov	ecx, 0x3
1803cfbbc: 29 c1                       	sub	ecx, eax
1803cfbbe: d3 c2                       	rol	edx, cl
1803cfbc0: 48 63 c2                    	movsxd	rax, edx
1803cfbc3: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cfbca: 48 8d 35 9f e0 3e 00        	lea	rsi, [rip + 0x3ee09f]   # 0x1807bdc70
1803cfbd1: ff 14 c6                    	call	qword ptr [rsi + 8*rax]
1803cfbd4: b9 08 00 00 00              	mov	ecx, 0x8
1803cfbd9: 2b 0d dd 0f 4c 00           	sub	ecx, dword ptr [rip + 0x4c0fdd] # 0x180890bbc
1803cfbdf: ba 02 00 00 b5              	mov	edx, 0xb5000002
1803cfbe4: d3 c2                       	rol	edx, cl
1803cfbe6: 48 63 d2                    	movsxd	rdx, edx
1803cfbe9: 41 b8 72 a1 71 7e           	mov	r8d, 0x7e71a172
1803cfbef: 44 33 04 93                 	xor	r8d, dword ptr [rbx + 4*rdx]
1803cfbf3: b9 12 00 00 00              	mov	ecx, 0x12
1803cfbf8: 29 d1                       	sub	ecx, edx
1803cfbfa: 41 d3 c0                    	rol	r8d, cl
1803cfbfd: 41 0f c8                    	bswap	r8d
1803cfc00: 41 f7 d8                    	neg	r8d
1803cfc03: 49 63 c8                    	movsxd	rcx, r8d
1803cfc06: 4c 8b 04 ce                 	mov	r8, qword ptr [rsi + 8*rcx]
1803cfc0a: 48 8d 8d c8 05 00 00        	lea	rcx, [rbp + 0x5c8]
1803cfc11: 48 89 8d 70 04 00 00        	mov	qword ptr [rbp + 0x470], rcx
1803cfc18: 48 89 bd 68 04 00 00        	mov	qword ptr [rbp + 0x468], rdi
1803cfc1f: c6 85 05 06 00 00 00        	mov	byte ptr [rbp + 0x605], 0x0
1803cfc26: c6 85 04 06 00 00 01        	mov	byte ptr [rbp + 0x604], 0x1
1803cfc2d: 48 89 c2                    	mov	rdx, rax
1803cfc30: 41 ff d0                    	call	r8
1803cfc33: 48 c7 85 d8 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x5d8], 0x0
1803cfc3e: 48 b8 d0 25 a0 6f ed c3 1b 0a       	movabs	rax, 0xa1bc3ed6fa025d0
1803cfc48: 48 33 05 e9 53 3e 00        	xor	rax, qword ptr [rip + 0x3e53e9] # 0x1807b5038
1803cfc4f: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cfc53: 48 8d 04 c5 b0 05 00 00     	lea	rax, [8*rax + 0x5b0]
1803cfc5b: 48 01 e8                    	add	rax, rbp
1803cfc5e: 48 b9 00 a1 f2 ec 49 b7 50 56       	movabs	rcx, 0x5650b749ecf2a100
1803cfc68: 48 01 c1                    	add	rcx, rax
1803cfc6b: 48 8d 85 b0 05 00 00        	lea	rax, [rbp + 0x5b0]
1803cfc72: 48 89 85 10 05 00 00        	mov	qword ptr [rbp + 0x510], rax
1803cfc79: 48 89 8d 18 05 00 00        	mov	qword ptr [rbp + 0x518], rcx
1803cfc80: 44 0f b6 0d 68 fb 3d 00     	movzx	r9d, byte ptr [rip + 0x3dfb68] # 0x1807af7f0
1803cfc88: 41 80 f1 ea                 	xor	r9b, -0x16
1803cfc8c: 8b 0d 8e 08 4c 00           	mov	ecx, dword ptr [rip + 0x4c088e] # 0x180890520
1803cfc92: ff c1                       	inc	ecx
1803cfc94: b8 e2 08 00 00              	mov	eax, 0x8e2
1803cfc99: d3 c8                       	ror	eax, cl
1803cfc9b: 48 63 c8                    	movsxd	rcx, eax
1803cfc9e: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803cfca3: 48 8d 15 26 3e 3f 00        	lea	rdx, [rip + 0x3f3e26]   # 0x1807c3ad0
1803cfcaa: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803cfcad: 41 80 c1 83                 	add	r9b, -0x7d
1803cfcb1: ff c8                       	dec	eax
1803cfcb3: 83 c1 0b                    	add	ecx, 0xb
1803cfcb6: d3 c8                       	ror	eax, cl
1803cfcb8: 0f c8                       	bswap	eax
1803cfcba: 48 98                       	cdqe
1803cfcbc: 48 8d 0d ad df 3e 00        	lea	rcx, [rip + 0x3edfad]   # 0x1807bdc70
1803cfcc3: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803cfcc7: 48 89 bd d0 03 00 00        	mov	qword ptr [rbp + 0x3d0], rdi
1803cfcce: c6 85 f9 05 00 00 01        	mov	byte ptr [rbp + 0x5f9], 0x1
1803cfcd5: 48 8d 9d 10 05 00 00        	lea	rbx, [rbp + 0x510]
1803cfcdc: 48 89 f9                    	mov	rcx, rdi
1803cfcdf: 48 89 da                    	mov	rdx, rbx
1803cfce2: 41 b0 01                    	mov	r8b, 0x1
1803cfce5: ff d0                       	call	rax
1803cfce7: 48 c7 85 38 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x238], 0x0
1803cfcf2: 48 63 05 9f c5 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc59f] # 0x1807cc298
1803cfcf9: ba 5b e7 52 d0              	mov	edx, 0xd052e75b
1803cfcfe: 4c 8d 25 fb cf 28 00        	lea	r12, [rip + 0x28cffb]   # 0x18065cd00
1803cfd05: 41 33 14 84                 	xor	edx, dword ptr [r12 + 4*rax]
1803cfd09: 0f ca                       	bswap	edx
1803cfd0b: b9 1b 00 00 00              	mov	ecx, 0x1b
1803cfd10: 29 c1                       	sub	ecx, eax
1803cfd12: d3 c2                       	rol	edx, cl
1803cfd14: 0f ca                       	bswap	edx
1803cfd16: 48 63 c2                    	movsxd	rax, edx
1803cfd19: 45 31 c0                    	xor	r8d, r8d
1803cfd1c: 4c 8d 3d ad 3d 3f 00        	lea	r15, [rip + 0x3f3dad]   # 0x1807c3ad0
1803cfd23: 45 2b 04 87                 	sub	r8d, dword ptr [r15 + 4*rax]
1803cfd27: 48 8d b5 40 02 00 00        	lea	rsi, [rbp + 0x240]
1803cfd2e: 41 0f c8                    	bswap	r8d
1803cfd31: ba 0e 21 30 a3              	mov	edx, 0xa330210e
1803cfd36: 29 c2                       	sub	edx, eax
1803cfd38: 89 d1                       	mov	ecx, edx
1803cfd3a: 41 d3 c0                    	rol	r8d, cl
1803cfd3d: 41 81 f0 0e 21 30 a3        	xor	r8d, 0xa330210e
1803cfd44: 41 0f c8                    	bswap	r8d
1803cfd47: 05 0e 21 30 a3              	add	eax, 0xa330210e
1803cfd4c: 89 c1                       	mov	ecx, eax
1803cfd4e: 41 d3 c8                    	ror	r8d, cl
1803cfd51: 41 d3 c8                    	ror	r8d, cl
1803cfd54: 89 d1                       	mov	ecx, edx
1803cfd56: 41 d3 c0                    	rol	r8d, cl
1803cfd59: 49 63 c0                    	movsxd	rax, r8d
1803cfd5c: 48 8d bd 90 00 00 00        	lea	rdi, [rbp + 0x90]
1803cfd63: 48 89 f9                    	mov	rcx, rdi
1803cfd66: 4c 8d 35 03 df 3e 00        	lea	r14, [rip + 0x3edf03]   # 0x1807bdc70
1803cfd6d: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cfd71: 48 63 05 4c c6 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc64c] # 0x1807cc3c4
1803cfd78: ba f9 c0 b1 72              	mov	edx, 0x72b1c0f9
1803cfd7d: 41 33 14 84                 	xor	edx, dword ptr [r12 + 4*rax]
1803cfd81: 8d 42 01                    	lea	eax, [rdx + 0x1]
1803cfd84: 48 98                       	cdqe
1803cfd86: 41 8b 04 87                 	mov	eax, dword ptr [r15 + 4*rax]
1803cfd8a: 0f c8                       	bswap	eax
1803cfd8c: 8d 8a 5a 44 c6 45           	lea	ecx, [rdx + 0x45c6445a]
1803cfd92: d3 c8                       	ror	eax, cl
1803cfd94: f7 d8                       	neg	eax
1803cfd96: d3 c8                       	ror	eax, cl
1803cfd98: f7 d8                       	neg	eax
1803cfd9a: d3 c8                       	ror	eax, cl
1803cfd9c: b9 18 00 00 00              	mov	ecx, 0x18
1803cfda1: 29 d1                       	sub	ecx, edx
1803cfda3: d3 c0                       	rol	eax, cl
1803cfda5: 35 59 44 c6 45              	xor	eax, 0x45c64459
1803cfdaa: 48 98                       	cdqe
1803cfdac: 48 89 f9                    	mov	rcx, rdi
1803cfdaf: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803cfdb3: 48 89 85 f8 04 00 00        	mov	qword ptr [rbp + 0x4f8], rax
1803cfdba: 8b 0d 58 07 4c 00           	mov	ecx, dword ptr [rip + 0x4c0758] # 0x180890518
1803cfdc0: 83 c1 18                    	add	ecx, 0x18
1803cfdc3: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803cfdc8: d3 c8                       	ror	eax, cl
1803cfdca: 48 98                       	cdqe
1803cfdcc: 41 8b 14 87                 	mov	edx, dword ptr [r15 + 4*rax]
1803cfdd0: b9 07 00 00 00              	mov	ecx, 0x7
1803cfdd5: 29 c1                       	sub	ecx, eax
1803cfdd7: d3 c2                       	rol	edx, cl
1803cfdd9: 0f ca                       	bswap	edx
1803cfddb: 48 63 c2                    	movsxd	rax, edx
1803cfdde: 49 8b 04 c6                 	mov	rax, qword ptr [r14 + 8*rax]
1803cfde2: 48 89 b5 80 04 00 00        	mov	qword ptr [rbp + 0x480], rsi
1803cfde9: 48 89 9d 78 04 00 00        	mov	qword ptr [rbp + 0x478], rbx
1803cfdf0: c6 85 07 06 00 00 00        	mov	byte ptr [rbp + 0x607], 0x0
1803cfdf7: c6 85 06 06 00 00 01        	mov	byte ptr [rbp + 0x606], 0x1
1803cfdfe: 48 8d 95 f8 04 00 00        	lea	rdx, [rbp + 0x4f8]
1803cfe05: 48 89 d9                    	mov	rcx, rbx
1803cfe08: ff d0                       	call	rax
1803cfe0a: 48 c7 85 20 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x520], 0x0
1803cfe15: 48 63 05 b4 c5 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc5b4] # 0x1807cc3d0
1803cfe1c: 48 8d 0d dd ce 28 00        	lea	rcx, [rip + 0x28cedd]   # 0x18065cd00
1803cfe23: 8b 14 81                    	mov	edx, dword ptr [rcx + 4*rax]
1803cfe26: 8d 48 19                    	lea	ecx, [rax + 0x19]
1803cfe29: d3 ca                       	ror	edx, cl
1803cfe2b: 0f ca                       	bswap	edx
1803cfe2d: f7 da                       	neg	edx
1803cfe2f: 81 f2 79 c3 2b a3           	xor	edx, 0xa32bc379
1803cfe35: 48 63 c2                    	movsxd	rax, edx
1803cfe38: 48 8d 1d 91 3c 3f 00        	lea	rbx, [rip + 0x3f3c91]   # 0x1807c3ad0
1803cfe3f: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803cfe42: f7 d2                       	not	edx
1803cfe44: 0f ca                       	bswap	edx
1803cfe46: f7 da                       	neg	edx
1803cfe48: 8d 48 03                    	lea	ecx, [rax + 0x3]
1803cfe4b: d3 ca                       	ror	edx, cl
1803cfe4d: f7 d2                       	not	edx
1803cfe4f: b9 03 00 00 00              	mov	ecx, 0x3
1803cfe54: 29 c1                       	sub	ecx, eax
1803cfe56: d3 c2                       	rol	edx, cl
1803cfe58: 48 63 c2                    	movsxd	rax, edx
1803cfe5b: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803cfe62: 48 8d 3d 07 de 3e 00        	lea	rdi, [rip + 0x3ede07]   # 0x1807bdc70
1803cfe69: ff 14 c7                    	call	qword ptr [rdi + 8*rax]
1803cfe6c: b9 08 00 00 00              	mov	ecx, 0x8
1803cfe71: 2b 0d 45 0d 4c 00           	sub	ecx, dword ptr [rip + 0x4c0d45] # 0x180890bbc
1803cfe77: 41 b8 02 00 00 b5           	mov	r8d, 0xb5000002
1803cfe7d: 41 d3 c0                    	rol	r8d, cl
1803cfe80: 48 8d 50 20                 	lea	rdx, [rax + 0x20]
1803cfe84: 49 63 c0                    	movsxd	rax, r8d
1803cfe87: 41 b8 72 a1 71 7e           	mov	r8d, 0x7e71a172
1803cfe8d: 44 33 04 83                 	xor	r8d, dword ptr [rbx + 4*rax]
1803cfe91: b9 12 00 00 00              	mov	ecx, 0x12
1803cfe96: 29 c1                       	sub	ecx, eax
1803cfe98: 41 d3 c0                    	rol	r8d, cl
1803cfe9b: 41 0f c8                    	bswap	r8d
1803cfe9e: 41 f7 d8                    	neg	r8d
1803cfea1: 49 63 c0                    	movsxd	rax, r8d
1803cfea4: 48 8b 04 c7                 	mov	rax, qword ptr [rdi + 8*rax]
1803cfea8: 48 89 b5 80 04 00 00        	mov	qword ptr [rbp + 0x480], rsi
1803cfeaf: 48 8d 8d 28 05 00 00        	lea	rcx, [rbp + 0x528]
1803cfeb6: 48 89 8d 78 04 00 00        	mov	qword ptr [rbp + 0x478], rcx
1803cfebd: c6 85 07 06 00 00 00        	mov	byte ptr [rbp + 0x607], 0x0
1803cfec4: c6 85 06 06 00 00 01        	mov	byte ptr [rbp + 0x606], 0x1
1803cfecb: ff d0                       	call	rax
1803cfecd: 48 c7 85 38 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x538], 0x0
1803cfed8: 48 b8 48 f5 4d 73 b4 eb b9 16       	movabs	rax, 0x16b9ebb4734df548
1803cfee2: 48 33 05 37 51 3e 00        	xor	rax, qword ptr [rip + 0x3e5137] # 0x1807b5020
1803cfee9: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803cfeed: 48 8d 04 c5 10 05 00 00     	lea	rax, [8*rax + 0x510]
1803cfef5: 48 01 e8                    	add	rax, rbp
1803cfef8: 48 b9 b8 0d 89 30 8b 02 e9 2d       	movabs	rcx, 0x2de9028b30890db8
1803cff02: 48 01 c1                    	add	rcx, rax
1803cff05: 48 8d 85 10 05 00 00        	lea	rax, [rbp + 0x510]
1803cff0c: 48 89 85 30 04 00 00        	mov	qword ptr [rbp + 0x430], rax
1803cff13: 48 89 8d 38 04 00 00        	mov	qword ptr [rbp + 0x438], rcx
1803cff1a: 44 0f b6 0d ce f8 3d 00     	movzx	r9d, byte ptr [rip + 0x3df8ce] # 0x1807af7f0
1803cff22: 41 80 f1 ea                 	xor	r9b, -0x16
1803cff26: 8b 0d f4 05 4c 00           	mov	ecx, dword ptr [rip + 0x4c05f4] # 0x180890520
1803cff2c: ff c1                       	inc	ecx
1803cff2e: b8 e2 08 00 00              	mov	eax, 0x8e2
1803cff33: d3 c8                       	ror	eax, cl
1803cff35: 48 63 c8                    	movsxd	rcx, eax
1803cff38: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803cff3d: 48 8d 15 8c 3b 3f 00        	lea	rdx, [rip + 0x3f3b8c]   # 0x1807c3ad0
1803cff44: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803cff47: 41 80 c1 83                 	add	r9b, -0x7d
1803cff4b: ff c8                       	dec	eax
1803cff4d: 83 c1 0b                    	add	ecx, 0xb
1803cff50: d3 c8                       	ror	eax, cl
1803cff52: 0f c8                       	bswap	eax
1803cff54: 48 98                       	cdqe
1803cff56: 48 8d 0d 13 dd 3e 00        	lea	rcx, [rip + 0x3edd13]   # 0x1807bdc70
1803cff5d: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803cff61: 48 89 b5 d8 03 00 00        	mov	qword ptr [rbp + 0x3d8], rsi
1803cff68: c6 85 fa 05 00 00 01        	mov	byte ptr [rbp + 0x5fa], 0x1
1803cff6f: 4c 8d bd 30 04 00 00        	lea	r15, [rbp + 0x430]
1803cff76: 48 89 f1                    	mov	rcx, rsi
1803cff79: 4c 89 fa                    	mov	rdx, r15
1803cff7c: 41 b0 01                    	mov	r8b, 0x1
1803cff7f: ff d0                       	call	rax
1803cff81: 48 c7 85 50 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x250], 0x0
1803cff8c: 48 63 15 f9 c2 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fc2f9] # 0x1807cc28c
1803cff93: 4c 8d 25 66 cd 28 00        	lea	r12, [rip + 0x28cd66]   # 0x18065cd00
1803cff9a: 41 8b 04 94                 	mov	eax, dword ptr [r12 + 4*rdx]
1803cff9e: 8d 4a 18                    	lea	ecx, [rdx + 0x18]
1803cffa1: d3 c8                       	ror	eax, cl
1803cffa3: b9 18 00 00 00              	mov	ecx, 0x18
1803cffa8: 29 d1                       	sub	ecx, edx
1803cffaa: d3 c0                       	rol	eax, cl
1803cffac: 0f c8                       	bswap	eax
1803cffae: 89 c1                       	mov	ecx, eax
1803cffb0: f7 d9                       	neg	ecx
1803cffb2: 48 63 c9                    	movsxd	rcx, ecx
1803cffb5: ba c9 3b 7e df              	mov	edx, 0xdf7e3bc9
1803cffba: 4c 8d 35 0f 3b 3f 00        	lea	r14, [rip + 0x3f3b0f]   # 0x1807c3ad0
1803cffc1: 41 33 14 8e                 	xor	edx, dword ptr [r14 + 4*rcx]
1803cffc5: 83 c0 16                    	add	eax, 0x16
1803cffc8: 89 c1                       	mov	ecx, eax
1803cffca: d3 c2                       	rol	edx, cl
1803cffcc: 48 8d b5 58 02 00 00        	lea	rsi, [rbp + 0x258]
1803cffd3: f7 d2                       	not	edx
1803cffd5: 48 63 c2                    	movsxd	rax, edx
1803cffd8: 48 8d bd a0 00 00 00        	lea	rdi, [rbp + 0xa0]
1803cffdf: 48 89 f9                    	mov	rcx, rdi
1803cffe2: 48 8d 1d 87 dc 3e 00        	lea	rbx, [rip + 0x3edc87]   # 0x1807bdc70
1803cffe9: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803cffec: 48 63 05 c1 c3 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc3c1] # 0x1807cc3b4
1803cfff3: ba 5b 16 0a 3c              	mov	edx, 0x3c0a165b
1803cfff8: 41 33 14 84                 	xor	edx, dword ptr [r12 + 4*rax]
1803cfffc: b9 1b 00 00 00              	mov	ecx, 0x1b
1803d0001: 29 c1                       	sub	ecx, eax
1803d0003: d3 c2                       	rol	edx, cl
1803d0005: 48 63 c2                    	movsxd	rax, edx
1803d0008: 41 8b 04 86                 	mov	eax, dword ptr [r14 + 4*rax]
1803d000c: f7 d0                       	not	eax
1803d000e: 0f c8                       	bswap	eax
1803d0010: 48 98                       	cdqe
1803d0012: 48 89 f9                    	mov	rcx, rdi
1803d0015: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803d0018: 48 89 85 00 05 00 00        	mov	qword ptr [rbp + 0x500], rax
1803d001f: 8b 0d f3 04 4c 00           	mov	ecx, dword ptr [rip + 0x4c04f3] # 0x180890518
1803d0025: 83 c1 18                    	add	ecx, 0x18
1803d0028: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803d002d: d3 c8                       	ror	eax, cl
1803d002f: 48 98                       	cdqe
1803d0031: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803d0035: b9 07 00 00 00              	mov	ecx, 0x7
1803d003a: 29 c1                       	sub	ecx, eax
1803d003c: d3 c2                       	rol	edx, cl
1803d003e: 0f ca                       	bswap	edx
1803d0040: 48 63 c2                    	movsxd	rax, edx
1803d0043: 48 8b 04 c3                 	mov	rax, qword ptr [rbx + 8*rax]
1803d0047: 48 89 b5 90 04 00 00        	mov	qword ptr [rbp + 0x490], rsi
1803d004e: 4c 89 bd 88 04 00 00        	mov	qword ptr [rbp + 0x488], r15
1803d0055: c6 85 09 06 00 00 00        	mov	byte ptr [rbp + 0x609], 0x0
1803d005c: c6 85 08 06 00 00 01        	mov	byte ptr [rbp + 0x608], 0x1
1803d0063: 48 8d 95 00 05 00 00        	lea	rdx, [rbp + 0x500]
1803d006a: 4c 89 f9                    	mov	rcx, r15
1803d006d: ff d0                       	call	rax
1803d006f: 48 c7 85 40 04 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x440], 0x0
1803d007a: 48 63 05 3f c3 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc33f] # 0x1807cc3c0
1803d0081: 48 8d 0d 78 cc 28 00        	lea	rcx, [rip + 0x28cc78]   # 0x18065cd00
1803d0088: 8b 14 81                    	mov	edx, dword ptr [rcx + 4*rax]
1803d008b: 8d 48 19                    	lea	ecx, [rax + 0x19]
1803d008e: d3 ca                       	ror	edx, cl
1803d0090: 0f ca                       	bswap	edx
1803d0092: f7 da                       	neg	edx
1803d0094: 81 f2 79 c3 2b a3           	xor	edx, 0xa32bc379
1803d009a: 48 63 c2                    	movsxd	rax, edx
1803d009d: 48 8d 1d 2c 3a 3f 00        	lea	rbx, [rip + 0x3f3a2c]   # 0x1807c3ad0
1803d00a4: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803d00a7: f7 d2                       	not	edx
1803d00a9: 0f ca                       	bswap	edx
1803d00ab: f7 da                       	neg	edx
1803d00ad: 8d 48 03                    	lea	ecx, [rax + 0x3]
1803d00b0: d3 ca                       	ror	edx, cl
1803d00b2: f7 d2                       	not	edx
1803d00b4: b9 03 00 00 00              	mov	ecx, 0x3
1803d00b9: 29 c1                       	sub	ecx, eax
1803d00bb: d3 c2                       	rol	edx, cl
1803d00bd: 48 63 c2                    	movsxd	rax, edx
1803d00c0: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803d00c7: 48 8d 3d a2 db 3e 00        	lea	rdi, [rip + 0x3edba2]   # 0x1807bdc70
1803d00ce: ff 14 c7                    	call	qword ptr [rdi + 8*rax]
1803d00d1: b9 08 00 00 00              	mov	ecx, 0x8
1803d00d6: 2b 0d e0 0a 4c 00           	sub	ecx, dword ptr [rip + 0x4c0ae0] # 0x180890bbc
1803d00dc: 41 b8 02 00 00 b5           	mov	r8d, 0xb5000002
1803d00e2: 41 d3 c0                    	rol	r8d, cl
1803d00e5: 48 8d 50 40                 	lea	rdx, [rax + 0x40]
1803d00e9: 49 63 c0                    	movsxd	rax, r8d
1803d00ec: 41 b8 72 a1 71 7e           	mov	r8d, 0x7e71a172
1803d00f2: 44 33 04 83                 	xor	r8d, dword ptr [rbx + 4*rax]
1803d00f6: b9 12 00 00 00              	mov	ecx, 0x12
1803d00fb: 29 c1                       	sub	ecx, eax
1803d00fd: 41 d3 c0                    	rol	r8d, cl
1803d0100: 41 0f c8                    	bswap	r8d
1803d0103: 41 f7 d8                    	neg	r8d
1803d0106: 49 63 c0                    	movsxd	rax, r8d
1803d0109: 48 8b 04 c7                 	mov	rax, qword ptr [rdi + 8*rax]
1803d010d: 48 89 b5 90 04 00 00        	mov	qword ptr [rbp + 0x490], rsi
1803d0114: 48 8d 8d 48 04 00 00        	lea	rcx, [rbp + 0x448]
1803d011b: 48 89 8d 88 04 00 00        	mov	qword ptr [rbp + 0x488], rcx
1803d0122: c6 85 09 06 00 00 00        	mov	byte ptr [rbp + 0x609], 0x0
1803d0129: c6 85 08 06 00 00 01        	mov	byte ptr [rbp + 0x608], 0x1
1803d0130: ff d0                       	call	rax
1803d0132: 48 c7 85 58 04 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x458], 0x0
1803d013d: 48 b8 0e 46 ef cb 6f f7 da 0f       	movabs	rax, 0xfdaf76fcbef460e
1803d0147: 48 33 05 1a 4f 3e 00        	xor	rax, qword ptr [rip + 0x3e4f1a] # 0x1807b5068
1803d014e: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d0152: 48 8d 04 c5 30 04 00 00     	lea	rax, [8*rax + 0x430]
1803d015a: 48 01 e8                    	add	rax, rbp
1803d015d: 48 b9 a0 28 da 49 4d b6 96 30       	movabs	rcx, 0x3096b64d49da28a0
1803d0167: 48 01 c1                    	add	rcx, rax
1803d016a: 48 8d 85 30 04 00 00        	lea	rax, [rbp + 0x430]
1803d0171: 48 89 85 40 05 00 00        	mov	qword ptr [rbp + 0x540], rax
1803d0178: 48 89 8d 48 05 00 00        	mov	qword ptr [rbp + 0x548], rcx
1803d017f: 44 0f b6 0d 69 f6 3d 00     	movzx	r9d, byte ptr [rip + 0x3df669] # 0x1807af7f0
1803d0187: 41 80 f1 ea                 	xor	r9b, -0x16
1803d018b: 8b 0d 8f 03 4c 00           	mov	ecx, dword ptr [rip + 0x4c038f] # 0x180890520
1803d0191: ff c1                       	inc	ecx
1803d0193: b8 e2 08 00 00              	mov	eax, 0x8e2
1803d0198: d3 c8                       	ror	eax, cl
1803d019a: 48 63 c8                    	movsxd	rcx, eax
1803d019d: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803d01a2: 48 8d 15 27 39 3f 00        	lea	rdx, [rip + 0x3f3927]   # 0x1807c3ad0
1803d01a9: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803d01ac: 41 80 c1 83                 	add	r9b, -0x7d
1803d01b0: ff c8                       	dec	eax
1803d01b2: 83 c1 0b                    	add	ecx, 0xb
1803d01b5: d3 c8                       	ror	eax, cl
1803d01b7: 0f c8                       	bswap	eax
1803d01b9: 48 98                       	cdqe
1803d01bb: 48 8d 0d ae da 3e 00        	lea	rcx, [rip + 0x3edaae]   # 0x1807bdc70
1803d01c2: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803d01c6: 48 89 b5 e0 03 00 00        	mov	qword ptr [rbp + 0x3e0], rsi
1803d01cd: c6 85 fb 05 00 00 01        	mov	byte ptr [rbp + 0x5fb], 0x1
1803d01d4: 4c 8d bd 40 05 00 00        	lea	r15, [rbp + 0x540]
1803d01db: 48 89 f1                    	mov	rcx, rsi
1803d01de: 4c 89 fa                    	mov	rdx, r15
1803d01e1: 41 b0 01                    	mov	r8b, 0x1
1803d01e4: ff d0                       	call	rax
1803d01e6: 48 c7 85 68 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x268], 0x0
1803d01f1: 48 63 05 9c c0 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc09c] # 0x1807cc294
1803d01f8: 31 c9                       	xor	ecx, ecx
1803d01fa: 4c 8d 25 ff ca 28 00        	lea	r12, [rip + 0x28caff]   # 0x18065cd00
1803d0201: 41 2b 0c 84                 	sub	ecx, dword ptr [r12 + 4*rax]
1803d0205: 81 f1 e2 45 c2 f4           	xor	ecx, 0xf4c245e2
1803d020b: 48 63 c1                    	movsxd	rax, ecx
1803d020e: 4c 8d 35 bb 38 3f 00        	lea	r14, [rip + 0x3f38bb]   # 0x1807c3ad0
1803d0215: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803d0219: 0f ca                       	bswap	edx
1803d021b: b9 d8 75 83 de              	mov	ecx, 0xde8375d8
1803d0220: 29 c1                       	sub	ecx, eax
1803d0222: d3 c2                       	rol	edx, cl
1803d0224: d3 c2                       	rol	edx, cl
1803d0226: 81 f2 d8 75 83 de           	xor	edx, 0xde8375d8
1803d022c: d3 c2                       	rol	edx, cl
1803d022e: d3 c2                       	rol	edx, cl
1803d0230: 31 ff                       	xor	edi, edi
1803d0232: f7 d2                       	not	edx
1803d0234: 83 c0 18                    	add	eax, 0x18
1803d0237: 89 c1                       	mov	ecx, eax
1803d0239: d3 ca                       	ror	edx, cl
1803d023b: 48 63 c2                    	movsxd	rax, edx
1803d023e: 48 8d b5 b0 00 00 00        	lea	rsi, [rbp + 0xb0]
1803d0245: 48 89 f1                    	mov	rcx, rsi
1803d0248: 48 8d 1d 21 da 3e 00        	lea	rbx, [rip + 0x3eda21]   # 0x1807bdc70
1803d024f: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803d0252: 48 63 05 73 c1 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc173] # 0x1807cc3cc
1803d0259: 41 2b 3c 84                 	sub	edi, dword ptr [r12 + 4*rax]
1803d025d: b9 10 00 00 00              	mov	ecx, 0x10
1803d0262: 29 c1                       	sub	ecx, eax
1803d0264: d3 c7                       	rol	edi, cl
1803d0266: 48 63 c7                    	movsxd	rax, edi
1803d0269: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803d026d: 8d 88 18 a9 71 bd           	lea	ecx, [rax - 0x428e56e8]
1803d0273: d3 ca                       	ror	edx, cl
1803d0275: f7 da                       	neg	edx
1803d0277: d3 ca                       	ror	edx, cl
1803d0279: d3 ca                       	ror	edx, cl
1803d027b: b9 18 00 00 00              	mov	ecx, 0x18
1803d0280: 29 c1                       	sub	ecx, eax
1803d0282: d3 c2                       	rol	edx, cl
1803d0284: 0f ca                       	bswap	edx
1803d0286: 48 63 c2                    	movsxd	rax, edx
1803d0289: 48 89 f1                    	mov	rcx, rsi
1803d028c: ff 14 c3                    	call	qword ptr [rbx + 8*rax]
1803d028f: 48 89 85 08 05 00 00        	mov	qword ptr [rbp + 0x508], rax
1803d0296: 8b 0d 7c 02 4c 00           	mov	ecx, dword ptr [rip + 0x4c027c] # 0x180890518
1803d029c: 83 c1 18                    	add	ecx, 0x18
1803d029f: b8 05 00 00 c0              	mov	eax, 0xc0000005
1803d02a4: d3 c8                       	ror	eax, cl
1803d02a6: 48 98                       	cdqe
1803d02a8: 41 8b 14 86                 	mov	edx, dword ptr [r14 + 4*rax]
1803d02ac: b9 07 00 00 00              	mov	ecx, 0x7
1803d02b1: 29 c1                       	sub	ecx, eax
1803d02b3: d3 c2                       	rol	edx, cl
1803d02b5: 0f ca                       	bswap	edx
1803d02b7: 48 63 c2                    	movsxd	rax, edx
1803d02ba: 48 8b 04 c3                 	mov	rax, qword ptr [rbx + 8*rax]
1803d02be: 4c 89 bd 98 04 00 00        	mov	qword ptr [rbp + 0x498], r15
1803d02c5: c6 85 0b 06 00 00 00        	mov	byte ptr [rbp + 0x60b], 0x0
1803d02cc: c6 85 0a 06 00 00 01        	mov	byte ptr [rbp + 0x60a], 0x1
1803d02d3: 48 8d 95 08 05 00 00        	lea	rdx, [rbp + 0x508]
1803d02da: 4c 89 f9                    	mov	rcx, r15
1803d02dd: ff d0                       	call	rax
1803d02df: 48 c7 85 50 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x550], 0x0
1803d02ea: 48 63 05 bf c0 3f 00        	movsxd	rax, dword ptr [rip + 0x3fc0bf] # 0x1807cc3b0
1803d02f1: 48 8d 0d 08 ca 28 00        	lea	rcx, [rip + 0x28ca08]   # 0x18065cd00
1803d02f8: 8b 14 81                    	mov	edx, dword ptr [rcx + 4*rax]
1803d02fb: 8d 48 19                    	lea	ecx, [rax + 0x19]
1803d02fe: d3 ca                       	ror	edx, cl
1803d0300: 0f ca                       	bswap	edx
1803d0302: f7 da                       	neg	edx
1803d0304: 81 f2 79 c3 2b a3           	xor	edx, 0xa32bc379
1803d030a: 48 63 c2                    	movsxd	rax, edx
1803d030d: 48 8d 3d bc 37 3f 00        	lea	rdi, [rip + 0x3f37bc]   # 0x1807c3ad0
1803d0314: 8b 14 87                    	mov	edx, dword ptr [rdi + 4*rax]
1803d0317: f7 d2                       	not	edx
1803d0319: 0f ca                       	bswap	edx
1803d031b: f7 da                       	neg	edx
1803d031d: 8d 48 03                    	lea	ecx, [rax + 0x3]
1803d0320: d3 ca                       	ror	edx, cl
1803d0322: f7 d2                       	not	edx
1803d0324: b9 03 00 00 00              	mov	ecx, 0x3
1803d0329: 29 c1                       	sub	ecx, eax
1803d032b: d3 c2                       	rol	edx, cl
1803d032d: 48 63 c2                    	movsxd	rax, edx
1803d0330: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803d0337: 48 8d 35 32 d9 3e 00        	lea	rsi, [rip + 0x3ed932]   # 0x1807bdc70
1803d033e: ff 14 c6                    	call	qword ptr [rsi + 8*rax]
1803d0341: b9 08 00 00 00              	mov	ecx, 0x8
1803d0346: 2b 0d 70 08 4c 00           	sub	ecx, dword ptr [rip + 0x4c0870] # 0x180890bbc
1803d034c: ba 02 00 00 b5              	mov	edx, 0xb5000002
1803d0351: d3 c2                       	rol	edx, cl
1803d0353: 48 63 d2                    	movsxd	rdx, edx
1803d0356: 41 b8 72 a1 71 7e           	mov	r8d, 0x7e71a172
1803d035c: 44 33 04 97                 	xor	r8d, dword ptr [rdi + 4*rdx]
1803d0360: b9 12 00 00 00              	mov	ecx, 0x12
1803d0365: 29 d1                       	sub	ecx, edx
1803d0367: 41 d3 c0                    	rol	r8d, cl
1803d036a: 48 8d 50 60                 	lea	rdx, [rax + 0x60]
1803d036e: 41 0f c8                    	bswap	r8d
1803d0371: 41 f7 d8                    	neg	r8d
1803d0374: 49 63 c0                    	movsxd	rax, r8d
1803d0377: 48 8b 04 c6                 	mov	rax, qword ptr [rsi + 8*rax]
1803d037b: 48 8d 8d 58 05 00 00        	lea	rcx, [rbp + 0x558]
1803d0382: 48 89 8d 98 04 00 00        	mov	qword ptr [rbp + 0x498], rcx
1803d0389: c6 85 0b 06 00 00 00        	mov	byte ptr [rbp + 0x60b], 0x0
1803d0390: c6 85 0a 06 00 00 01        	mov	byte ptr [rbp + 0x60a], 0x1
1803d0397: ff d0                       	call	rax
1803d0399: 48 c7 85 68 05 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x568], 0x0
1803d03a4: 48 b8 16 e4 65 7e fc d2 a1 05       	movabs	rax, 0x5a1d2fc7e65e416
1803d03ae: 48 33 05 73 4c 3e 00        	xor	rax, qword ptr [rip + 0x3e4c73] # 0x1807b5028
1803d03b5: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d03b9: 48 8d 04 c5 40 05 00 00     	lea	rax, [8*rax + 0x540]
1803d03c1: 48 01 e8                    	add	rax, rbp
1803d03c4: 48 b9 08 43 7e 6f 51 1c 96 b6       	movabs	rcx, -0x4969e3ae9081bcf8
1803d03ce: 48 01 c1                    	add	rcx, rax
1803d03d1: 48 8d 85 40 05 00 00        	lea	rax, [rbp + 0x540]
1803d03d8: 48 89 85 50 03 00 00        	mov	qword ptr [rbp + 0x350], rax
1803d03df: 48 89 8d 58 03 00 00        	mov	qword ptr [rbp + 0x358], rcx
1803d03e6: 44 0f b6 0d 02 f4 3d 00     	movzx	r9d, byte ptr [rip + 0x3df402] # 0x1807af7f0
1803d03ee: 8b 0d 2c 01 4c 00           	mov	ecx, dword ptr [rip + 0x4c012c] # 0x180890520
1803d03f4: ff c1                       	inc	ecx
1803d03f6: b8 e2 08 00 00              	mov	eax, 0x8e2
1803d03fb: d3 c8                       	ror	eax, cl
1803d03fd: 41 80 f1 ea                 	xor	r9b, -0x16
1803d0401: 41 80 c1 83                 	add	r9b, -0x7d
1803d0405: 48 63 c8                    	movsxd	rcx, eax
1803d0408: b8 b4 17 b8 6d              	mov	eax, 0x6db817b4
1803d040d: 48 8d 15 bc 36 3f 00        	lea	rdx, [rip + 0x3f36bc]   # 0x1807c3ad0
1803d0414: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803d0417: ff c8                       	dec	eax
1803d0419: 83 c1 0b                    	add	ecx, 0xb
1803d041c: d3 c8                       	ror	eax, cl
1803d041e: 0f c8                       	bswap	eax
1803d0420: 48 98                       	cdqe
1803d0422: 48 8d 0d 47 d8 3e 00        	lea	rcx, [rip + 0x3ed847]   # 0x1807bdc70
1803d0429: 48 8b 04 c1                 	mov	rax, qword ptr [rcx + 8*rax]
1803d042d: c6 85 fc 05 00 00 01        	mov	byte ptr [rbp + 0x5fc], 0x1
1803d0434: 48 8d 95 50 03 00 00        	lea	rdx, [rbp + 0x350]
1803d043b: 48 8d 8d 70 02 00 00        	lea	rcx, [rbp + 0x270]
1803d0442: 41 b0 01                    	mov	r8b, 0x1
1803d0445: ff d0                       	call	rax
1803d0447: 48 c7 85 80 02 00 00 00 00 00 00    	mov	qword ptr [rbp + 0x280], 0x0
1803d0452: 48 8d 85 10 02 00 00        	lea	rax, [rbp + 0x210]
1803d0459: 48 89 85 70 01 00 00        	mov	qword ptr [rbp + 0x170], rax
1803d0460: 48 b8 6e c3 9f 4e 70 4c a2 1e       	movabs	rax, 0x1ea24c704e9fc36e
1803d046a: 48 33 05 d7 4b 3e 00        	xor	rax, qword ptr [rip + 0x3e4bd7] # 0x1807b5048
1803d0471: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d0475: 48 8d 04 c5 10 02 00 00     	lea	rax, [8*rax + 0x210]
1803d047d: 48 01 e8                    	add	rax, rbp
1803d0480: 48 b9 80 ff f4 d8 9a e4 ec 5c       	movabs	rcx, 0x5cece49ad8f4ff80
1803d048a: 48 01 c1                    	add	rcx, rax
1803d048d: 48 89 8d 78 01 00 00        	mov	qword ptr [rbp + 0x178], rcx
1803d0494: 44 0f b6 0d cd 4a 3e 00     	movzx	r9d, byte ptr [rip + 0x3e4acd] # 0x1807b4f69
1803d049c: 41 80 c1 44                 	add	r9b, 0x44
1803d04a0: 48 8d 8d 80 03 00 00        	lea	rcx, [rbp + 0x380]
1803d04a7: 48 8d 95 70 01 00 00        	lea	rdx, [rbp + 0x170]
1803d04ae: 41 b0 01                    	mov	r8b, 0x1
1803d04b1: e8 ba fe f3 ff              	call	0x180310370 <.text+0x300370>
1803d04b6: 41 b8 e2 0b f3 cb           	mov	r8d, 0xcbf30be2
1803d04bc: 44 33 05 89 4a 3e 00        	xor	r8d, dword ptr [rip + 0x3e4a89] # 0x1807b4f4c
1803d04c3: 41 81 c0 56 0a bf 55        	add	r8d, 0x55bf0a56
1803d04ca: 44 0f b6 0d 7e 4a 3e 00     	movzx	r9d, byte ptr [rip + 0x3e4a7e] # 0x1807b4f50
1803d04d2: 41 80 f1 34                 	xor	r9b, 0x34
1803d04d6: 41 80 c1 8a                 	add	r9b, -0x76
1803d04da: b8 da ec e5 5f              	mov	eax, 0x5fe5ecda
1803d04df: 33 05 6f 4a 3e 00           	xor	eax, dword ptr [rip + 0x3e4a6f] # 0x1807b4f54
1803d04e5: 05 5e fc 36 50              	add	eax, 0x5036fc5e
1803d04ea: 89 44 24 28                 	mov	dword ptr [rsp + 0x28], eax
1803d04ee: c6 44 24 20 00              	mov	byte ptr [rsp + 0x20], 0x0
1803d04f3: 48 8d 8d 80 03 00 00        	lea	rcx, [rbp + 0x380]
1803d04fa: 48 8d 95 90 03 00 00        	lea	rdx, [rbp + 0x390]
1803d0501: e8 9a a3 f4 ff              	call	0x18031a8a0 <.text+0x30a8a0>
1803d0506: 48 63 15 53 be 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fbe53] # 0x1807cc360
1803d050d: 4c 8d 25 ec c7 28 00        	lea	r12, [rip + 0x28c7ec]   # 0x18065cd00
1803d0514: 41 8b 04 94                 	mov	eax, dword ptr [r12 + 4*rdx]
1803d0518: 41 b8 30 37 6d 22           	mov	r8d, 0x226d3730
1803d051e: 41 29 d0                    	sub	r8d, edx
1803d0521: 44 89 c1                    	mov	ecx, r8d
1803d0524: d3 c0                       	rol	eax, cl
1803d0526: 83 f2 10                    	xor	edx, 0x10
1803d0529: 89 d1                       	mov	ecx, edx
1803d052b: d3 c8                       	ror	eax, cl
1803d052d: 44 89 c1                    	mov	ecx, r8d
1803d0530: d3 c0                       	rol	eax, cl
1803d0532: 89 c1                       	mov	ecx, eax
1803d0534: f7 d9                       	neg	ecx
1803d0536: 48 63 c9                    	movsxd	rcx, ecx
1803d0539: 4c 8d 3d 90 35 3f 00        	lea	r15, [rip + 0x3f3590]   # 0x1807c3ad0
1803d0540: 45 8b 04 8f                 	mov	r8d, dword ptr [r15 + 4*rcx]
1803d0544: 41 0f c8                    	bswap	r8d
1803d0547: ba 28 57 c4 2e              	mov	edx, 0x2ec45728
1803d054c: 29 c2                       	sub	edx, eax
1803d054e: 89 d1                       	mov	ecx, edx
1803d0550: 41 d3 c8                    	ror	r8d, cl
1803d0553: 05 28 57 c4 2e              	add	eax, 0x2ec45728
1803d0558: 89 c1                       	mov	ecx, eax
1803d055a: 41 d3 c0                    	rol	r8d, cl
1803d055d: 89 d1                       	mov	ecx, edx
1803d055f: 41 d3 c8                    	ror	r8d, cl
1803d0562: 41 81 f0 d7 a8 3b d1        	xor	r8d, 0xd13ba8d7
1803d0569: 41 ff c0                    	inc	r8d
1803d056c: 89 c1                       	mov	ecx, eax
1803d056e: 41 d3 c0                    	rol	r8d, cl
1803d0571: 41 f7 d0                    	not	r8d
1803d0574: 49 63 c0                    	movsxd	rax, r8d
1803d0577: 48 8d 8d 20 01 00 00        	lea	rcx, [rbp + 0x120]
1803d057e: 48 8d b5 90 03 00 00        	lea	rsi, [rbp + 0x390]
1803d0585: 48 89 f2                    	mov	rdx, rsi
1803d0588: 4c 8d 35 e1 d6 3e 00        	lea	r14, [rip + 0x3ed6e1]   # 0x1807bdc70
1803d058f: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d0593: 48 63 15 22 be 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fbe22] # 0x1807cc3bc
1803d059a: 41 8b 04 94                 	mov	eax, dword ptr [r12 + 4*rdx]
1803d059e: b9 13 00 00 00              	mov	ecx, 0x13
1803d05a3: 29 d1                       	sub	ecx, edx
1803d05a5: d3 c0                       	rol	eax, cl
1803d05a7: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d05ac: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d05b1: 29 c1                       	sub	ecx, eax
1803d05b3: 48 63 c9                    	movsxd	rcx, ecx
1803d05b6: 31 d2                       	xor	edx, edx
1803d05b8: 41 2b 14 8f                 	sub	edx, dword ptr [r15 + 4*rcx]
1803d05bc: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d05c1: 29 c1                       	sub	ecx, eax
1803d05c3: d3 ca                       	ror	edx, cl
1803d05c5: d3 ca                       	ror	edx, cl
1803d05c7: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d05cd: d3 ca                       	ror	edx, cl
1803d05cf: 31 ff                       	xor	edi, edi
1803d05d1: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d05d6: 89 c1                       	mov	ecx, eax
1803d05d8: d3 c2                       	rol	edx, cl
1803d05da: d3 c2                       	rol	edx, cl
1803d05dc: 48 63 c2                    	movsxd	rax, edx
1803d05df: 48 89 f1                    	mov	rcx, rsi
1803d05e2: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d05e6: 48 63 15 bb bd 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fbdbb] # 0x1807cc3a8
1803d05ed: 41 8b 04 94                 	mov	eax, dword ptr [r12 + 4*rdx]
1803d05f1: 8d 4a 19                    	lea	ecx, [rdx + 0x19]
1803d05f4: d3 c8                       	ror	eax, cl
1803d05f6: b9 39 a9 65 f9              	mov	ecx, 0xf965a939
1803d05fb: 29 d1                       	sub	ecx, edx
1803d05fd: d3 c0                       	rol	eax, cl
1803d05ff: d3 c0                       	rol	eax, cl
1803d0601: 8d 48 05                    	lea	ecx, [rax + 0x5]
1803d0604: 89 c2                       	mov	edx, eax
1803d0606: f7 da                       	neg	edx
1803d0608: 48 63 d2                    	movsxd	rdx, edx
1803d060b: 41 2b 3c 97                 	sub	edi, dword ptr [r15 + 4*rdx]
1803d060f: d3 c7                       	rol	edi, cl
1803d0611: b9 05 00 00 00              	mov	ecx, 0x5
1803d0616: 29 c1                       	sub	ecx, eax
1803d0618: 81 f7 1a 0d 76 ac           	xor	edi, 0xac760d1a
1803d061e: ff c7                       	inc	edi
1803d0620: d3 cf                       	ror	edi, cl
1803d0622: f7 d7                       	not	edi
1803d0624: 0f cf                       	bswap	edi
1803d0626: f7 df                       	neg	edi
1803d0628: 48 63 c7                    	movsxd	rax, edi
1803d062b: 48 8d 8d 80 03 00 00        	lea	rcx, [rbp + 0x380]
1803d0632: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d0636: b8 67 bc de 61              	mov	eax, 0x61debc67
1803d063b: 33 05 13 4a 3e 00           	xor	eax, dword ptr [rip + 0x3e4a13] # 0x1807b5054
1803d0641: 05 35 47 09 85              	add	eax, 0x85094735
1803d0646: 48 98                       	cdqe
1803d0648: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d064c: 48 8d 34 c5 10 02 00 00     	lea	rsi, [8*rax + 0x210]
1803d0654: 48 01 ee                    	add	rsi, rbp
1803d0657: bf 60 00 00 00              	mov	edi, 0x60
1803d065c: 0f 1f 40 00                 	nop	dword ptr [rax]
1803d0660: 48 63 05 45 bd 3f 00        	movsxd	rax, dword ptr [rip + 0x3fbd45] # 0x1807cc3ac
1803d0667: 41 8b 14 84                 	mov	edx, dword ptr [r12 + 4*rax]
1803d066b: b9 0f 00 00 00              	mov	ecx, 0xf
1803d0670: 29 c1                       	sub	ecx, eax
1803d0672: d3 c2                       	rol	edx, cl
1803d0674: f7 da                       	neg	edx
1803d0676: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803d0679: d3 ca                       	ror	edx, cl
1803d067b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803d0681: 4c 63 c2                    	movsxd	r8, edx
1803d0684: 47 8b 0c 87                 	mov	r9d, dword ptr [r15 + 4*r8]
1803d0688: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803d068f: 89 c1                       	mov	ecx, eax
1803d0691: 41 d3 c9                    	ror	r9d, cl
1803d0694: 41 0f c9                    	bswap	r9d
1803d0697: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803d069c: 44 29 c2                    	sub	edx, r8d
1803d069f: 89 d1                       	mov	ecx, edx
1803d06a1: 41 d3 c1                    	rol	r9d, cl
1803d06a4: 89 c1                       	mov	ecx, eax
1803d06a6: 41 d3 c9                    	ror	r9d, cl
1803d06a9: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803d06ad: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803d06b4: 41 d3 c9                    	ror	r9d, cl
1803d06b7: 89 d1                       	mov	ecx, edx
1803d06b9: 41 d3 c1                    	rol	r9d, cl
1803d06bc: 41 d3 c1                    	rol	r9d, cl
1803d06bf: 49 63 c1                    	movsxd	rax, r9d
1803d06c2: 4c 89 c1                    	mov	rcx, r8
1803d06c5: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d06c9: 48 83 c7 e8                 	add	rdi, -0x18
1803d06cd: 48 83 ff e8                 	cmp	rdi, -0x18
1803d06d1: 75 8d                       	jne	0x1803d0660 <.text+0x3c0660>
1803d06d3: b8 ff 6e 13 e2              	mov	eax, 0xe2136eff
1803d06d8: 33 05 62 49 3e 00           	xor	eax, dword ptr [rip + 0x3e4962] # 0x1807b5040
1803d06de: 05 ba 76 73 8d              	add	eax, 0x8d7376ba
1803d06e3: 48 98                       	cdqe
1803d06e5: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d06e9: 48 8d 34 c5 40 05 00 00     	lea	rsi, [8*rax + 0x540]
1803d06f1: 48 01 ee                    	add	rsi, rbp
1803d06f4: bf 18 00 00 00              	mov	edi, 0x18
1803d06f9: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803d0700: 48 63 05 b1 bc 3f 00        	movsxd	rax, dword ptr [rip + 0x3fbcb1] # 0x1807cc3b8
1803d0707: 41 8b 14 84                 	mov	edx, dword ptr [r12 + 4*rax]
1803d070b: b9 0f 00 00 00              	mov	ecx, 0xf
1803d0710: 29 c1                       	sub	ecx, eax
1803d0712: d3 c2                       	rol	edx, cl
1803d0714: f7 da                       	neg	edx
1803d0716: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803d0719: d3 ca                       	ror	edx, cl
1803d071b: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803d0721: 4c 63 c2                    	movsxd	r8, edx
1803d0724: 47 8b 0c 87                 	mov	r9d, dword ptr [r15 + 4*r8]
1803d0728: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803d072f: 89 c1                       	mov	ecx, eax
1803d0731: 41 d3 c9                    	ror	r9d, cl
1803d0734: 41 0f c9                    	bswap	r9d
1803d0737: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803d073c: 44 29 c2                    	sub	edx, r8d
1803d073f: 89 d1                       	mov	ecx, edx
1803d0741: 41 d3 c1                    	rol	r9d, cl
1803d0744: 89 c1                       	mov	ecx, eax
1803d0746: 41 d3 c9                    	ror	r9d, cl
1803d0749: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803d074d: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803d0754: 41 d3 c9                    	ror	r9d, cl
1803d0757: 89 d1                       	mov	ecx, edx
1803d0759: 41 d3 c1                    	rol	r9d, cl
1803d075c: 41 d3 c1                    	rol	r9d, cl
1803d075f: 49 63 c1                    	movsxd	rax, r9d
1803d0762: 4c 89 c1                    	mov	rcx, r8
1803d0765: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d0769: 48 83 c7 e8                 	add	rdi, -0x18
1803d076d: 48 83 ff e8                 	cmp	rdi, -0x18
1803d0771: 75 8d                       	jne	0x1803d0700 <.text+0x3c0700>
1803d0773: b8 d0 24 e3 d2              	mov	eax, 0xd2e324d0
1803d0778: 33 05 de 48 3e 00           	xor	eax, dword ptr [rip + 0x3e48de] # 0x1807b505c
1803d077e: 05 64 90 d0 45              	add	eax, 0x45d09064
1803d0783: 48 98                       	cdqe
1803d0785: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d0789: 48 8d 34 c5 30 04 00 00     	lea	rsi, [8*rax + 0x430]
1803d0791: 48 01 ee                    	add	rsi, rbp
1803d0794: bf 18 00 00 00              	mov	edi, 0x18
1803d0799: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803d07a0: 48 63 05 21 bc 3f 00        	movsxd	rax, dword ptr [rip + 0x3fbc21] # 0x1807cc3c8
1803d07a7: 41 8b 14 84                 	mov	edx, dword ptr [r12 + 4*rax]
1803d07ab: b9 0f 00 00 00              	mov	ecx, 0xf
1803d07b0: 29 c1                       	sub	ecx, eax
1803d07b2: d3 c2                       	rol	edx, cl
1803d07b4: f7 da                       	neg	edx
1803d07b6: 8d 48 0f                    	lea	ecx, [rax + 0xf]
1803d07b9: d3 ca                       	ror	edx, cl
1803d07bb: 81 f2 2f c5 3d d7           	xor	edx, 0xd73dc52f
1803d07c1: 4c 63 c2                    	movsxd	r8, edx
1803d07c4: 47 8b 0c 87                 	mov	r9d, dword ptr [r15 + 4*r8]
1803d07c8: 41 8d 80 ea 5a e6 ac        	lea	eax, [r8 - 0x5319a516]
1803d07cf: 89 c1                       	mov	ecx, eax
1803d07d1: 41 d3 c9                    	ror	r9d, cl
1803d07d4: 41 0f c9                    	bswap	r9d
1803d07d7: ba ea 5a e6 ac              	mov	edx, 0xace65aea
1803d07dc: 44 29 c2                    	sub	edx, r8d
1803d07df: 89 d1                       	mov	ecx, edx
1803d07e1: 41 d3 c1                    	rol	r9d, cl
1803d07e4: 89 c1                       	mov	ecx, eax
1803d07e6: 41 d3 c9                    	ror	r9d, cl
1803d07e9: 4c 8d 04 3e                 	lea	r8, [rsi + rdi]
1803d07ed: 41 81 f1 ea 5a e6 ac        	xor	r9d, 0xace65aea
1803d07f4: 41 d3 c9                    	ror	r9d, cl
1803d07f7: 89 d1                       	mov	ecx, edx
1803d07f9: 41 d3 c1                    	rol	r9d, cl
1803d07fc: 41 d3 c1                    	rol	r9d, cl
1803d07ff: 49 63 c1                    	movsxd	rax, r9d
1803d0802: 4c 89 c1                    	mov	rcx, r8
1803d0805: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d0809: 48 83 c7 e8                 	add	rdi, -0x18
1803d080d: 48 83 ff e8                 	cmp	rdi, -0x18
1803d0811: 75 8d                       	jne	0x1803d07a0 <.text+0x3c07a0>
1803d0813: b8 1e 79 79 76              	mov	eax, 0x7679791e
1803d0818: 33 05 42 48 3e 00           	xor	eax, dword ptr [rip + 0x3e4842] # 0x1807b5060
1803d081e: 05 f1 44 61 e9              	add	eax, 0xe96144f1
1803d0823: 48 98                       	cdqe
1803d0825: 48 8d 04 40                 	lea	rax, [rax + 2*rax]
1803d0829: 48 8d 34 c5 10 05 00 00     	lea	rsi, [8*rax + 0x510]
1803d0831: 48 01 ee                    	add	rsi, rbp
1803d0834: bf 18 00 00 00              	mov	edi, 0x18
1803d0839: 0f 1f 80 00 00 00 00        	nop	dword ptr [rax]
1803d0840: 48 63 05 c1 bb 3f 00        	movsxd	rax, dword ptr [rip + 0x3fbbc1] # 0x1807cc408
1803d0847: 41 8b 14 84                 	mov	edx, dword ptr [r12 + 4*rax]
1803d084b: b9 0f 00 00 00              	mov	ecx, 0xf
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
1803d0b21: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d0b26: 89 c1                       	mov	ecx, eax
1803d0b28: d3 c2                       	rol	edx, cl
1803d0b2a: d3 c2                       	rol	edx, cl
1803d0b2c: 48 63 c2                    	movsxd	rax, edx
1803d0b2f: 48 8d 8d 80 05 00 00        	lea	rcx, [rbp + 0x580]
1803d0b36: 4c 8d 25 33 d1 3e 00        	lea	r12, [rip + 0x3ed133]   # 0x1807bdc70
1803d0b3d: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0b41: 48 63 05 b8 b8 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb8b8] # 0x1807cc400
1803d0b48: 31 d2                       	xor	edx, edx
1803d0b4a: 2b 14 83                    	sub	edx, dword ptr [rbx + 4*rax]
1803d0b4d: b9 14 00 00 00              	mov	ecx, 0x14
1803d0b52: 29 c1                       	sub	ecx, eax
1803d0b54: d3 c2                       	rol	edx, cl
1803d0b56: 48 63 ca                    	movsxd	rcx, edx
1803d0b59: 31 c0                       	xor	eax, eax
1803d0b5b: 41 2b 44 8d 00              	sub	eax, dword ptr [r13 + 4*rcx]
1803d0b60: bf 14 00 00 00              	mov	edi, 0x14
1803d0b65: 0f c8                       	bswap	eax
1803d0b67: 81 c1 1d a8 63 e3           	add	ecx, 0xe363a81d
1803d0b6d: d3 c8                       	ror	eax, cl
1803d0b6f: d3 c8                       	ror	eax, cl
1803d0b71: 48 98                       	cdqe
1803d0b73: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803d0b7a: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0b7e: 84 c0                       	test	al, al
1803d0b80: 0f 84 f4 05 00 00           	je	0x1803d117a <.text+0x3c117a>
1803d0b86: 48 63 05 bf b8 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb8bf] # 0x1807cc44c
1803d0b8d: 41 bf 07 60 6d e0           	mov	r15d, 0xe06d6007
1803d0b93: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803d0b96: 44 31 fa                    	xor	edx, r15d
1803d0b99: 0f ca                       	bswap	edx
1803d0b9b: 8d 88 07 60 6d e0           	lea	ecx, [rax - 0x1f929ff9]
1803d0ba1: d3 ca                       	ror	edx, cl
1803d0ba3: d3 ca                       	ror	edx, cl
1803d0ba5: 48 63 c2                    	movsxd	rax, edx
1803d0ba8: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803d0bad: 0f ca                       	bswap	edx
1803d0baf: f7 da                       	neg	edx
1803d0bb1: b9 f4 f0 4b 86              	mov	ecx, 0x864bf0f4
1803d0bb6: 29 c1                       	sub	ecx, eax
1803d0bb8: d3 c2                       	rol	edx, cl
1803d0bba: be f4 f0 4b 86              	mov	esi, 0x864bf0f4
1803d0bbf: f7 da                       	neg	edx
1803d0bc1: 0f ca                       	bswap	edx
1803d0bc3: d3 c2                       	rol	edx, cl
1803d0bc5: 48 63 c2                    	movsxd	rax, edx
1803d0bc8: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803d0bcf: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0bd3: b9 f6 92 3a ec              	mov	ecx, 0xec3a92f6
1803d0bd8: 33 0d ca 43 3e 00           	xor	ecx, dword ptr [rip + 0x3e43ca] # 0x1807b4fa8
1803d0bde: 81 c1 c7 10 50 78           	add	ecx, 0x785010c7
1803d0be4: 39 08                       	cmp	dword ptr [rax], ecx
1803d0be6: 0f 85 8e 05 00 00           	jne	0x1803d117a <.text+0x3c117a>
1803d0bec: 48 63 05 71 b7 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb771] # 0x1807cc364
1803d0bf3: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803d0bf6: 8d 48 0b                    	lea	ecx, [rax + 0xb]
1803d0bf9: d3 ca                       	ror	edx, cl
1803d0bfb: b9 cb b3 a9 49              	mov	ecx, 0x49a9b3cb
1803d0c00: 29 c1                       	sub	ecx, eax
1803d0c02: d3 c2                       	rol	edx, cl
1803d0c04: d3 c2                       	rol	edx, cl
1803d0c06: 0f ca                       	bswap	edx
1803d0c08: 48 63 ca                    	movsxd	rcx, edx
1803d0c0b: b8 cc 37 fb 2d              	mov	eax, 0x2dfb37cc
1803d0c10: 41 33 44 8d 00              	xor	eax, dword ptr [r13 + 4*rcx]
1803d0c15: 81 c1 cc 37 fb 2d           	add	ecx, 0x2dfb37cc
1803d0c1b: d3 c8                       	ror	eax, cl
1803d0c1d: 0f c8                       	bswap	eax
1803d0c1f: f7 d8                       	neg	eax
1803d0c21: d3 c8                       	ror	eax, cl
1803d0c23: d3 c8                       	ror	eax, cl
1803d0c25: 48 98                       	cdqe
1803d0c27: 45 31 f6                    	xor	r14d, r14d
1803d0c2a: 48 8d 7d b8                 	lea	rdi, [rbp - 0x48]
1803d0c2e: 48 89 f9                    	mov	rcx, rdi
1803d0c31: 31 d2                       	xor	edx, edx
1803d0c33: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0c37: 48 63 05 ce b7 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb7ce] # 0x1807cc40c
1803d0c3e: 44 33 3c 83                 	xor	r15d, dword ptr [rbx + 4*rax]
1803d0c42: 41 0f cf                    	bswap	r15d
1803d0c45: 8d 88 07 60 6d e0           	lea	ecx, [rax - 0x1f929ff9]
1803d0c4b: 41 d3 cf                    	ror	r15d, cl
1803d0c4e: 41 d3 cf                    	ror	r15d, cl
1803d0c51: 49 63 c7                    	movsxd	rax, r15d
1803d0c54: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803d0c59: 0f ca                       	bswap	edx
1803d0c5b: f7 da                       	neg	edx
1803d0c5d: 29 c6                       	sub	esi, eax
1803d0c5f: 89 f1                       	mov	ecx, esi
1803d0c61: d3 c2                       	rol	edx, cl
1803d0c63: f7 da                       	neg	edx
1803d0c65: 0f ca                       	bswap	edx
1803d0c67: d3 c2                       	rol	edx, cl
1803d0c69: 48 63 c2                    	movsxd	rax, edx
1803d0c6c: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803d0c73: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0c77: 48 8d 50 08                 	lea	rdx, [rax + 0x8]
1803d0c7b: c6 44 24 28 00              	mov	byte ptr [rsp + 0x28], 0x0
1803d0c80: c6 44 24 20 00              	mov	byte ptr [rsp + 0x20], 0x0
1803d0c85: 48 8d 8d 10 05 00 00        	lea	rcx, [rbp + 0x510]
1803d0c8c: 49 89 f8                    	mov	r8, rdi
1803d0c8f: 41 b1 01                    	mov	r9b, 0x1
1803d0c92: e8 79 c7 f6 ff              	call	0x18033d410 <.text+0x32d410>
1803d0c97: 48 63 05 f2 b5 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb5f2] # 0x1807cc290
1803d0c9e: ba d9 01 ed 2d              	mov	edx, 0x2ded01d9
1803d0ca3: 48 8d 3d 56 c0 28 00        	lea	rdi, [rip + 0x28c056]   # 0x18065cd00
1803d0caa: 33 14 87                    	xor	edx, dword ptr [rdi + 4*rax]
1803d0cad: 8d 88 d9 01 ed 2d           	lea	ecx, [rax + 0x2ded01d9]
1803d0cb3: d3 ca                       	ror	edx, cl
1803d0cb5: d3 ca                       	ror	edx, cl
1803d0cb7: b9 19 00 00 00              	mov	ecx, 0x19
1803d0cbc: 29 c1                       	sub	ecx, eax
1803d0cbe: d3 c2                       	rol	edx, cl
1803d0cc0: 48 63 c2                    	movsxd	rax, edx
1803d0cc3: 48 8d 1d 06 2e 3f 00        	lea	rbx, [rip + 0x3f2e06]   # 0x1807c3ad0
1803d0cca: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803d0ccd: 8d 88 61 a9 46 e3           	lea	ecx, [rax - 0x1cb9569f]
1803d0cd3: d3 ca                       	ror	edx, cl
1803d0cd5: f7 d2                       	not	edx
1803d0cd7: d3 ca                       	ror	edx, cl
1803d0cd9: d3 ca                       	ror	edx, cl
1803d0cdb: 81 f2 9e 56 b9 1c           	xor	edx, 0x1cb9569e
1803d0ce1: b9 01 00 00 00              	mov	ecx, 0x1
1803d0ce6: 29 c1                       	sub	ecx, eax
1803d0ce8: d3 c2                       	rol	edx, cl
1803d0cea: 81 f2 61 a9 46 e3           	xor	edx, 0xe346a961
1803d0cf0: 48 63 c2                    	movsxd	rax, edx
1803d0cf3: 48 8d b5 b0 05 00 00        	lea	rsi, [rbp + 0x5b0]
1803d0cfa: 48 89 f1                    	mov	rcx, rsi
1803d0cfd: 4c 8d 3d 6c cf 3e 00        	lea	r15, [rip + 0x3ecf6c]   # 0x1807bdc70
1803d0d04: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803d0d08: 48 63 05 e5 b6 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb6e5] # 0x1807cc3f4
1803d0d0f: 48 63 04 87                 	movsxd	rax, dword ptr [rdi + 4*rax]
1803d0d13: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803d0d16: f7 d2                       	not	edx
1803d0d18: 8d 48 09                    	lea	ecx, [rax + 0x9]
1803d0d1b: d3 ca                       	ror	edx, cl
1803d0d1d: f7 d2                       	not	edx
1803d0d1f: 0f ca                       	bswap	edx
1803d0d21: 48 63 c2                    	movsxd	rax, edx
1803d0d24: 48 89 f1                    	mov	rcx, rsi
1803d0d27: 41 ff 14 c7                 	call	qword ptr [r15 + 8*rax]
1803d0d2b: 48 63 0d 3e b6 3f 00        	movsxd	rcx, dword ptr [rip + 0x3fb63e] # 0x1807cc370
1803d0d32: 8b 0c 8f                    	mov	ecx, dword ptr [rdi + 4*rcx]
1803d0d35: 0f c9                       	bswap	ecx
1803d0d37: f7 d9                       	neg	ecx
1803d0d39: 0f c9                       	bswap	ecx
1803d0d3b: 89 ca                       	mov	edx, ecx
1803d0d3d: f7 da                       	neg	edx
1803d0d3f: 48 63 d2                    	movsxd	rdx, edx
1803d0d42: 44 2b 34 93                 	sub	r14d, dword ptr [rbx + 4*rdx]
1803d0d46: 41 0f ce                    	bswap	r14d
1803d0d49: 81 c1 11 39 22 28           	add	ecx, 0x28223911
1803d0d4f: 41 d3 c6                    	rol	r14d, cl
1803d0d52: 41 d3 c6                    	rol	r14d, cl
1803d0d55: 4d 63 c6                    	movsxd	r8, r14d
1803d0d58: 48 8d 75 48                 	lea	rsi, [rbp + 0x48]
1803d0d5c: 48 89 f1                    	mov	rcx, rsi
1803d0d5f: 48 89 c2                    	mov	rdx, rax
1803d0d62: 43 ff 14 c7                 	call	qword ptr [r15 + 8*r8]
1803d0d66: 48 8d 8d 80 05 00 00        	lea	rcx, [rbp + 0x580]
1803d0d6d: 48 8d 95 10 05 00 00        	lea	rdx, [rbp + 0x510]
1803d0d74: 4c 8d 85 a0 01 00 00        	lea	r8, [rbp + 0x1a0]
1803d0d7b: 49 89 f1                    	mov	r9, rsi
1803d0d7e: e8 cd 5e f5 ff              	call	0x180326c50 <.text+0x316c50>
1803d0d83: 48 63 0d 8a b6 3f 00        	movsxd	rcx, dword ptr [rip + 0x3fb68a] # 0x1807cc414
1803d0d8a: 48 8d 1d 6f bf 28 00        	lea	rbx, [rip + 0x28bf6f]   # 0x18065cd00
1803d0d91: 8b 04 8b                    	mov	eax, dword ptr [rbx + 4*rcx]
1803d0d94: d3 c8                       	ror	eax, cl
1803d0d96: d3 c8                       	ror	eax, cl
1803d0d98: 8d 48 ff                    	lea	ecx, [rax - 0x1]
1803d0d9b: 48 63 c9                    	movsxd	rcx, ecx
1803d0d9e: 4c 8d 2d 2b 2d 3f 00        	lea	r13, [rip + 0x3f2d2b]   # 0x1807c3ad0
1803d0da5: 41 8b 54 8d 00              	mov	edx, dword ptr [r13 + 4*rcx]
1803d0daa: 0f ca                       	bswap	edx
1803d0dac: b9 ee 26 23 dc              	mov	ecx, 0xdc2326ee
1803d0db1: 29 c1                       	sub	ecx, eax
1803d0db3: d3 c2                       	rol	edx, cl
1803d0db5: f7 da                       	neg	edx
1803d0db7: d3 c2                       	rol	edx, cl
1803d0db9: f7 d2                       	not	edx
1803d0dbb: 0f ca                       	bswap	edx
1803d0dbd: 48 63 c2                    	movsxd	rax, edx
1803d0dc0: 48 8d 8d 80 05 00 00        	lea	rcx, [rbp + 0x580]
1803d0dc7: 4c 8d 25 a2 ce 3e 00        	lea	r12, [rip + 0x3ecea2]   # 0x1807bdc70
1803d0dce: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0dd2: 84 c0                       	test	al, al
1803d0dd4: 0f 84 e5 04 00 00           	je	0x1803d12bf <.text+0x3c12bf>
1803d0dda: 48 63 05 0b b6 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb60b] # 0x1807cc3ec
1803d0de1: 41 be 0e b1 46 ea           	mov	r14d, 0xea46b10e
1803d0de7: 8b 04 83                    	mov	eax, dword ptr [rbx + 4*rax]
1803d0dea: 44 31 f0                    	xor	eax, r14d
1803d0ded: 0f c8                       	bswap	eax
1803d0def: 48 63 d0                    	movsxd	rdx, eax
1803d0df2: 41 8b 44 95 00              	mov	eax, dword ptr [r13 + 4*rdx]
1803d0df7: 0f c8                       	bswap	eax
1803d0df9: 8d 4a 03                    	lea	ecx, [rdx + 0x3]
1803d0dfc: d3 c8                       	ror	eax, cl
1803d0dfe: f7 d0                       	not	eax
1803d0e00: b9 83 1f a2 5d              	mov	ecx, 0x5da21f83
1803d0e05: 29 d1                       	sub	ecx, edx
1803d0e07: d3 c0                       	rol	eax, cl
1803d0e09: f7 d0                       	not	eax
1803d0e0b: d3 c0                       	rol	eax, cl
1803d0e0d: bf 83 1f a2 5d              	mov	edi, 0x5da21f83
1803d0e12: f7 d8                       	neg	eax
1803d0e14: 0f c8                       	bswap	eax
1803d0e16: 48 98                       	cdqe
1803d0e18: 48 8d b5 80 05 00 00        	lea	rsi, [rbp + 0x580]
1803d0e1f: 48 89 f1                    	mov	rcx, rsi
1803d0e22: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0e26: 4c 63 05 3f b5 3f 00        	movsxd	r8, dword ptr [rip + 0x3fb53f] # 0x1807cc36c
1803d0e2d: 42 8b 14 83                 	mov	edx, dword ptr [rbx + 4*r8]
1803d0e31: 41 b9 30 37 6d 22           	mov	r9d, 0x226d3730
1803d0e37: 45 29 c1                    	sub	r9d, r8d
1803d0e3a: 44 89 c9                    	mov	ecx, r9d
1803d0e3d: d3 c2                       	rol	edx, cl
1803d0e3f: 41 83 f0 10                 	xor	r8d, 0x10
1803d0e43: 44 89 c1                    	mov	ecx, r8d
1803d0e46: d3 ca                       	ror	edx, cl
1803d0e48: 44 89 c9                    	mov	ecx, r9d
1803d0e4b: d3 c2                       	rol	edx, cl
1803d0e4d: 89 d1                       	mov	ecx, edx
1803d0e4f: f7 d9                       	neg	ecx
1803d0e51: 48 63 c9                    	movsxd	rcx, ecx
1803d0e54: 45 8b 4c 8d 00              	mov	r9d, dword ptr [r13 + 4*rcx]
1803d0e59: 41 0f c9                    	bswap	r9d
1803d0e5c: 41 b8 28 57 c4 2e           	mov	r8d, 0x2ec45728
1803d0e62: 41 29 d0                    	sub	r8d, edx
1803d0e65: 44 89 c1                    	mov	ecx, r8d
1803d0e68: 41 d3 c9                    	ror	r9d, cl
1803d0e6b: 81 c2 28 57 c4 2e           	add	edx, 0x2ec45728
1803d0e71: 89 d1                       	mov	ecx, edx
1803d0e73: 41 d3 c1                    	rol	r9d, cl
1803d0e76: 44 89 c1                    	mov	ecx, r8d
1803d0e79: 41 d3 c9                    	ror	r9d, cl
1803d0e7c: 41 81 f1 d7 a8 3b d1        	xor	r9d, 0xd13ba8d7
1803d0e83: 41 ff c1                    	inc	r9d
1803d0e86: 89 d1                       	mov	ecx, edx
1803d0e88: 41 d3 c1                    	rol	r9d, cl
1803d0e8b: 41 f7 d1                    	not	r9d
1803d0e8e: 4d 63 c1                    	movsxd	r8, r9d
1803d0e91: 48 8d 8d 40 01 00 00        	lea	rcx, [rbp + 0x140]
1803d0e98: 48 89 c2                    	mov	rdx, rax
1803d0e9b: 43 ff 14 c4                 	call	qword ptr [r12 + 8*r8]
1803d0e9f: 48 63 05 32 b5 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb532] # 0x1807cc3d8
1803d0ea6: 44 33 34 83                 	xor	r14d, dword ptr [rbx + 4*rax]
1803d0eaa: 41 0f ce                    	bswap	r14d
1803d0ead: 49 63 c6                    	movsxd	rax, r14d
1803d0eb0: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803d0eb5: 0f ca                       	bswap	edx
1803d0eb7: 8d 48 03                    	lea	ecx, [rax + 0x3]
1803d0eba: d3 ca                       	ror	edx, cl
1803d0ebc: f7 d2                       	not	edx
1803d0ebe: 29 c7                       	sub	edi, eax
1803d0ec0: 89 f9                       	mov	ecx, edi
1803d0ec2: d3 c2                       	rol	edx, cl
1803d0ec4: f7 d2                       	not	edx
1803d0ec6: d3 c2                       	rol	edx, cl
1803d0ec8: f7 da                       	neg	edx
1803d0eca: 0f ca                       	bswap	edx
1803d0ecc: 48 63 c2                    	movsxd	rax, edx
1803d0ecf: 48 89 f1                    	mov	rcx, rsi
1803d0ed2: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d0ed6: 48 89 c1                    	mov	rcx, rax
1803d0ed9: e8 92 aa f4 ff              	call	0x18031b970 <.text+0x30b970>
1803d0ede: 48 63 05 83 b4 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb483] # 0x1807cc368
1803d0ee5: 48 8d 0d 14 be 28 00        	lea	rcx, [rip + 0x28be14]   # 0x18065cd00
1803d0eec: 8b 14 81                    	mov	edx, dword ptr [rcx + 4*rax]
1803d0eef: 8d 48 0b                    	lea	ecx, [rax + 0xb]
1803d0ef2: d3 ca                       	ror	edx, cl
1803d0ef4: b9 cb b3 a9 49              	mov	ecx, 0x49a9b3cb
1803d0ef9: 29 c1                       	sub	ecx, eax
1803d0efb: d3 c2                       	rol	edx, cl
1803d0efd: d3 c2                       	rol	edx, cl
1803d0eff: 0f ca                       	bswap	edx
1803d0f01: 48 63 ca                    	movsxd	rcx, edx
1803d0f04: b8 cc 37 fb 2d              	mov	eax, 0x2dfb37cc
1803d0f09: 48 8d 15 c0 2b 3f 00        	lea	rdx, [rip + 0x3f2bc0]   # 0x1807c3ad0
1803d0f10: 33 04 8a                    	xor	eax, dword ptr [rdx + 4*rcx]
1803d0f13: 81 c1 cc 37 fb 2d           	add	ecx, 0x2dfb37cc
1803d0f19: d3 c8                       	ror	eax, cl
1803d0f1b: 0f c8                       	bswap	eax
1803d0f1d: f7 d8                       	neg	eax
1803d0f1f: d3 c8                       	ror	eax, cl
1803d0f21: d3 c8                       	ror	eax, cl
1803d0f23: 48 98                       	cdqe
1803d0f25: 48 8d 75 f8                 	lea	rsi, [rbp - 0x8]
1803d0f29: 48 89 f1                    	mov	rcx, rsi
1803d0f2c: 31 d2                       	xor	edx, edx
1803d0f2e: 4c 8d 05 3b cd 3e 00        	lea	r8, [rip + 0x3ecd3b]    # 0x1807bdc70
1803d0f35: 41 ff 14 c0                 	call	qword ptr [r8 + 8*rax]
1803d0f39: c6 44 24 28 00              	mov	byte ptr [rsp + 0x28], 0x0
1803d0f3e: c6 44 24 20 00              	mov	byte ptr [rsp + 0x20], 0x0
1803d0f43: 48 8d 8d b0 05 00 00        	lea	rcx, [rbp + 0x5b0]
1803d0f4a: 48 8d 95 40 01 00 00        	lea	rdx, [rbp + 0x140]
1803d0f51: 49 89 f0                    	mov	r8, rsi
1803d0f54: 41 b1 01                    	mov	r9b, 0x1
1803d0f57: e8 64 d1 f6 ff              	call	0x18033e0c0 <.text+0x32e0c0>
1803d0f5c: 48 8d 8d 40 01 00 00        	lea	rcx, [rbp + 0x140]
1803d0f63: e8 08 aa f4 ff              	call	0x18031b970 <.text+0x30b970>
1803d0f68: 4c 8b a5 e0 05 00 00        	mov	r12, qword ptr [rbp + 0x5e0]
1803d0f6f: 4c 8b ad 08 02 00 00        	mov	r13, qword ptr [rbp + 0x208]
1803d0f76: 48 b8 18 01 b0 6e df 28 67 5a       	movabs	rax, 0x5a6728df6eb00118
1803d0f80: 48 33 05 09 41 3e 00        	xor	rax, qword ptr [rip + 0x3e4109] # 0x1807b5090
1803d0f87: 48 b9 d1 1c 46 52 e6 e7 14 e8       	movabs	rcx, -0x17eb1819adb9e32f
1803d0f91: 48 01 c1                    	add	rcx, rax
1803d0f94: 48 89 8d 40 05 00 00        	mov	qword ptr [rbp + 0x540], rcx
1803d0f9b: 48 63 05 d2 1c 4c 00        	movsxd	rax, dword ptr [rip + 0x4c1cd2] # 0x180892c74
1803d0fa2: 48 8d 1d 57 bd 28 00        	lea	rbx, [rip + 0x28bd57]   # 0x18065cd00
1803d0fa9: 8b 14 83                    	mov	edx, dword ptr [rbx + 4*rax]
1803d0fac: b9 f0 24 07 3b              	mov	ecx, 0x3b0724f0
1803d0fb1: 29 c1                       	sub	ecx, eax
1803d0fb3: d3 c2                       	rol	edx, cl
1803d0fb5: f7 da                       	neg	edx
1803d0fb7: d3 c2                       	rol	edx, cl
1803d0fb9: 0f ca                       	bswap	edx
1803d0fbb: 48 63 c2                    	movsxd	rax, edx
1803d0fbe: 31 f6                       	xor	esi, esi
1803d0fc0: 31 d2                       	xor	edx, edx
1803d0fc2: 4c 8d 3d 07 2b 3f 00        	lea	r15, [rip + 0x3f2b07]   # 0x1807c3ad0
1803d0fc9: 41 2b 14 87                 	sub	edx, dword ptr [r15 + 4*rax]
1803d0fcd: b9 0f 00 00 00              	mov	ecx, 0xf
1803d0fd2: 29 c1                       	sub	ecx, eax
1803d0fd4: d3 c2                       	rol	edx, cl
1803d0fd6: 81 f2 70 94 47 53           	xor	edx, 0x53479470
1803d0fdc: ff c2                       	inc	edx
1803d0fde: 05 8f 6b b8 ac              	add	eax, 0xacb86b8f
1803d0fe3: 89 c1                       	mov	ecx, eax
1803d0fe5: d3 ca                       	ror	edx, cl
1803d0fe7: d3 ca                       	ror	edx, cl
1803d0fe9: 48 63 c2                    	movsxd	rax, edx
1803d0fec: 48 8d bd 30 04 00 00        	lea	rdi, [rbp + 0x430]
1803d0ff3: 48 89 f9                    	mov	rcx, rdi
1803d0ff6: 4c 8d 35 73 cc 3e 00        	lea	r14, [rip + 0x3ecc73]   # 0x1807bdc70
1803d0ffd: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d1001: 48 63 05 fc b3 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb3fc] # 0x1807cc404
1803d1008: 2b 34 83                    	sub	esi, dword ptr [rbx + 4*rax]
1803d100b: 81 f6 5e d5 36 84           	xor	esi, 0x8436d55e
1803d1011: 0f ce                       	bswap	esi
1803d1013: 89 f0                       	mov	eax, esi
1803d1015: f7 d8                       	neg	eax
1803d1017: 48 98                       	cdqe
1803d1019: ba 69 dd 03 06              	mov	edx, 0x603dd69
1803d101e: 41 33 14 87                 	xor	edx, dword ptr [r15 + 4*rax]
1803d1022: ff ca                       	dec	edx
1803d1024: 0f ca                       	bswap	edx
1803d1026: 83 c6 09                    	add	esi, 0x9
1803d1029: 89 f1                       	mov	ecx, esi
1803d102b: d3 c2                       	rol	edx, cl
1803d102d: 0f ca                       	bswap	edx
1803d102f: 48 63 c2                    	movsxd	rax, edx
1803d1032: 48 89 f9                    	mov	rcx, rdi
1803d1035: 41 ff 14 c6                 	call	qword ptr [r14 + 8*rax]
1803d1039: 48 89 85 90 03 00 00        	mov	qword ptr [rbp + 0x390], rax
1803d1040: 48 8d 8d b0 05 00 00        	lea	rcx, [rbp + 0x5b0]
1803d1047: 48 8d 95 90 03 00 00        	lea	rdx, [rbp + 0x390]
1803d104e: 4c 8d 85 40 05 00 00        	lea	r8, [rbp + 0x540]
1803d1055: e8 26 49 00 00              	call	0x1803d5980 <.text+0x3c5980>
1803d105a: 49 3b 45 00                 	cmp	rax, qword ptr [r13]
1803d105e: 4c 8b 8d e8 05 00 00        	mov	r9, qword ptr [rbp + 0x5e8]
1803d1065: 0f 85 6a 02 00 00           	jne	0x1803d12d5 <.text+0x3c12d5>
1803d106b: 48 63 15 02 b3 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fb302] # 0x1807cc374
1803d1072: 48 8d 0d 87 bc 28 00        	lea	rcx, [rip + 0x28bc87]   # 0x18065cd00
1803d1079: 44 8b 04 91                 	mov	r8d, dword ptr [rcx + 4*rdx]
1803d107d: 41 ff c8                    	dec	r8d
1803d1080: b9 11 00 00 00              	mov	ecx, 0x11
1803d1085: 29 d1                       	sub	ecx, edx
1803d1087: 41 d3 c0                    	rol	r8d, cl
1803d108a: 8d 4a 11                    	lea	ecx, [rdx + 0x11]
1803d108d: 41 d3 c8                    	ror	r8d, cl
1803d1090: 49 63 d0                    	movsxd	rdx, r8d
1803d1093: 48 8d 0d 36 2a 3f 00        	lea	rcx, [rip + 0x3f2a36]   # 0x1807c3ad0
1803d109a: 44 8b 04 91                 	mov	r8d, dword ptr [rcx + 4*rdx]
1803d109e: b9 44 37 c1 cd              	mov	ecx, 0xcdc13744
1803d10a3: 29 d1                       	sub	ecx, edx
1803d10a5: 41 d3 c0                    	rol	r8d, cl
1803d10a8: 41 d3 c0                    	rol	r8d, cl
1803d10ab: 41 f7 d0                    	not	r8d
1803d10ae: 41 0f c8                    	bswap	r8d
1803d10b1: 83 c2 04                    	add	edx, 0x4
1803d10b4: 89 d1                       	mov	ecx, edx
1803d10b6: 41 d3 c8                    	ror	r8d, cl
1803d10b9: 41 81 f0 44 37 c1 cd        	xor	r8d, 0xcdc13744
1803d10c0: 4d 63 c0                    	movsxd	r8, r8d
1803d10c3: 4c 89 c9                    	mov	rcx, r9
1803d10c6: 48 89 c2                    	mov	rdx, rax
1803d10c9: 48 8d 05 a0 cb 3e 00        	lea	rax, [rip + 0x3ecba0]   # 0x1807bdc70
1803d10d0: 42 ff 14 c0                 	call	qword ptr [rax + 8*r8]
1803d10d4: e9 51 02 00 00              	jmp	0x1803d132a <.text+0x3c132a>
1803d10d9: 48 63 05 30 b1 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb130] # 0x1807cc210
1803d10e0: b9 35 b9 e5 b0              	mov	ecx, 0xb0e5b935
1803d10e5: 33 0c 87                    	xor	ecx, dword ptr [rdi + 4*rax]
1803d10e8: 8d 41 01                    	lea	eax, [rcx + 0x1]
1803d10eb: 48 98                       	cdqe
1803d10ed: 41 8b 44 85 00              	mov	eax, dword ptr [r13 + 4*rax]
1803d10f2: 0f c8                       	bswap	eax
1803d10f4: 81 c1 d3 b3 92 bf           	add	ecx, 0xbf92b3d3
1803d10fa: d3 c8                       	ror	eax, cl
1803d10fc: 35 2d 4c 6d 40              	xor	eax, 0x406d4c2d
1803d1101: d3 c8                       	ror	eax, cl
1803d1103: 48 8d bb 08 01 00 00        	lea	rdi, [rbx + 0x108]
1803d110a: f7 d8                       	neg	eax
1803d110c: 48 98                       	cdqe
1803d110e: 48 89 f9                    	mov	rcx, rdi
1803d1111: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d1115: 84 c0                       	test	al, al
1803d1117: bb 00 04 be 49              	mov	ebx, 0x49be0400
1803d111c: 0f 85 7e c8 ff ff           	jne	0x1803cd9a0 <.text+0x3bd9a0>
1803d1122: 48 8d 8d e0 00 00 00        	lea	rcx, [rbp + 0xe0]
1803d1129: 48 89 f2                    	mov	rdx, rsi
1803d112c: e8 2f 33 cd ff              	call	0x1800a4460 <.text+0x94460>
1803d1131: 48 8d 8d a0 01 00 00        	lea	rcx, [rbp + 0x1a0]
1803d1138: 48 89 fa                    	mov	rdx, rdi
1803d113b: e8 20 33 cd ff              	call	0x1800a4460 <.text+0x94460>
1803d1140: bb a5 21 0f 19              	mov	ebx, 0x190f21a5
1803d1145: 41 be 16 9b 60 15           	mov	r14d, 0x15609b16
1803d114b: 4c 8d 3d 1a 3e 3e 00        	lea	r15, [rip + 0x3e3e1a]   # 0x1807b4f6c
1803d1152: 4c 8d 25 17 cb 3e 00        	lea	r12, [rip + 0x3ecb17]   # 0x1807bdc70
1803d1159: 4c 8d 2d 70 29 3f 00        	lea	r13, [rip + 0x3f2970]   # 0x1807c3ad0
1803d1160: e9 3b c8 ff ff              	jmp	0x1803cd9a0 <.text+0x3bd9a0>
1803d1165: 8b 05 15 3f 3e 00           	mov	eax, dword ptr [rip + 0x3e3f15] # 0x1807b5080
1803d116b: c7 85 e8 05 00 00 00 00 00 00       	mov	dword ptr [rbp + 0x5e8], 0x0
1803d1175: e9 47 03 00 00              	jmp	0x1803d14c1 <.text+0x3c14c1>
1803d117a: 48 63 05 af b2 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb2af] # 0x1807cc430
1803d1181: 31 d2                       	xor	edx, edx
1803d1183: 2b 14 83                    	sub	edx, dword ptr [rbx + 4*rax]
1803d1186: 29 c7                       	sub	edi, eax
1803d1188: 89 f9                       	mov	ecx, edi
1803d118a: d3 c2                       	rol	edx, cl
1803d118c: 48 63 ca                    	movsxd	rcx, edx
1803d118f: 31 c0                       	xor	eax, eax
1803d1191: 41 2b 44 8d 00              	sub	eax, dword ptr [r13 + 4*rcx]
1803d1196: 0f c8                       	bswap	eax
1803d1198: 81 c1 1d a8 63 e3           	add	ecx, 0xe363a81d
1803d119e: d3 c8                       	ror	eax, cl
1803d11a0: d3 c8                       	ror	eax, cl
1803d11a2: 48 98                       	cdqe
1803d11a4: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803d11ab: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d11af: 48 8d 35 e2 3e 3e 00        	lea	rsi, [rip + 0x3e3ee2]   # 0x1807b5098
1803d11b6: 84 c0                       	test	al, al
1803d11b8: 0f 84 b9 02 00 00           	je	0x1803d1477 <.text+0x3c1477>
1803d11be: 48 63 05 4b b2 3f 00        	movsxd	rax, dword ptr [rip + 0x3fb24b] # 0x1807cc410
1803d11c5: ba 07 60 6d e0              	mov	edx, 0xe06d6007
1803d11ca: 33 14 83                    	xor	edx, dword ptr [rbx + 4*rax]
1803d11cd: 0f ca                       	bswap	edx
1803d11cf: 8d 88 07 60 6d e0           	lea	ecx, [rax - 0x1f929ff9]
1803d11d5: d3 ca                       	ror	edx, cl
1803d11d7: d3 ca                       	ror	edx, cl
1803d11d9: 48 63 c2                    	movsxd	rax, edx
1803d11dc: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803d11e1: 0f ca                       	bswap	edx
1803d11e3: f7 da                       	neg	edx
1803d11e5: b9 f4 f0 4b 86              	mov	ecx, 0x864bf0f4
1803d11ea: 29 c1                       	sub	ecx, eax
1803d11ec: d3 c2                       	rol	edx, cl
1803d11ee: f7 da                       	neg	edx
1803d11f0: 0f ca                       	bswap	edx
1803d11f2: d3 c2                       	rol	edx, cl
1803d11f4: 48 63 c2                    	movsxd	rax, edx
1803d11f7: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803d11fe: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d1202: b9 86 d1 07 58              	mov	ecx, 0x5807d186
1803d1207: 33 0d 9f 3d 3e 00           	xor	ecx, dword ptr [rip + 0x3e3d9f] # 0x1807b4fac
1803d120d: 81 c1 4e c8 21 f5           	add	ecx, 0xf521c84e
1803d1213: 39 08                       	cmp	dword ptr [rax], ecx
1803d1215: 0f 85 9c 00 00 00           	jne	0x1803d12b7 <.text+0x3c12b7>
1803d121b: 48 8b 8d e8 05 00 00        	mov	rcx, qword ptr [rbp + 0x5e8]
1803d1222: e8 09 f4 f7 ff              	call	0x180350630 <.text+0x340630>
1803d1227: 45 31 f6                    	xor	r14d, r14d
1803d122a: 84 c0                       	test	al, al
1803d122c: 4c 8d 25 3d ca 3e 00        	lea	r12, [rip + 0x3eca3d]   # 0x1807bdc70
1803d1233: 4c 8d 2d 96 28 3f 00        	lea	r13, [rip + 0x3f2896]   # 0x1807c3ad0
1803d123a: 0f 84 37 02 00 00           	je	0x1803d1477 <.text+0x3c1477>
1803d1240: 0f b6 05 59 3e 3e 00        	movzx	eax, byte ptr [rip + 0x3e3e59] # 0x1807b50a0
1803d1247: 34 c4                       	xor	al, -0x3c
1803d1249: 04 13                       	add	al, 0x13
1803d124b: 48 8b 8d e0 05 00 00        	mov	rcx, qword ptr [rbp + 0x5e0]
1803d1252: 88 81 a8 00 00 00           	mov	byte ptr [rcx + 0xa8], al
1803d1258: 48 63 05 59 e9 4b 00        	movsxd	rax, dword ptr [rip + 0x4be959] # 0x18088fbb8
1803d125f: b9 dd 43 b3 25              	mov	ecx, 0x25b343dd
1803d1264: 48 8d 15 c5 6f 28 00        	lea	rdx, [rip + 0x286fc5]   # 0x180658230
1803d126b: 33 0c 82                    	xor	ecx, dword ptr [rdx + 4*rax]
1803d126e: ff c1                       	inc	ecx
1803d1270: 0f c9                       	bswap	ecx
1803d1272: 48 63 c1                    	movsxd	rax, ecx
1803d1275: 48 8d 0d 04 57 3e 00        	lea	rcx, [rip + 0x3e5704]   # 0x1807b6980
1803d127c: 44 2b 34 81                 	sub	r14d, dword ptr [rcx + 4*rax]
1803d1280: 41 81 f6 6c 7d 09 e2        	xor	r14d, 0xe2097d6c
1803d1287: 49 63 c6                    	movsxd	rax, r14d
1803d128a: 48 8d 0d 3f 4b 3e 00        	lea	rcx, [rip + 0x3e4b3f]   # 0x1807b5dd0
1803d1291: 48 8b 0c c1                 	mov	rcx, qword ptr [rcx + 8*rax]
1803d1295: e8 46 b9 03 00              	call	0x18040cbe0 <.text+0x3fcbe0>
1803d129a: 41 b6 01                    	mov	r14b, 0x1
1803d129d: 48 8d 35 e0 3d 3e 00        	lea	rsi, [rip + 0x3e3de0]   # 0x1807b5084
1803d12a4: 4c 8d 25 c5 c9 3e 00        	lea	r12, [rip + 0x3ec9c5]   # 0x1807bdc70
1803d12ab: 4c 8d 2d 1e 28 3f 00        	lea	r13, [rip + 0x3f281e]   # 0x1807c3ad0
1803d12b2: e9 c0 01 00 00              	jmp	0x1803d1477 <.text+0x3c1477>
1803d12b7: 45 31 f6                    	xor	r14d, r14d
1803d12ba: e9 b8 01 00 00              	jmp	0x1803d1477 <.text+0x3c1477>
1803d12bf: be 97 e6 94 a4              	mov	esi, 0xa494e697
1803d12c4: bf 52 0b cd 2c              	mov	edi, 0x2ccd0b52
1803d12c9: 48 8d 05 b8 3d 3e 00        	lea	rax, [rip + 0x3e3db8]   # 0x1807b5088
1803d12d0: e9 d5 00 00 00              	jmp	0x1803d13aa <.text+0x3c13aa>
1803d12d5: 0f b6 05 cc 3d 3e 00        	movzx	eax, byte ptr [rip + 0x3e3dcc] # 0x1807b50a8
1803d12dc: 34 95                       	xor	al, -0x6b
1803d12de: 04 cd                       	add	al, -0x33
1803d12e0: 41 88 84 24 a8 00 00 00     	mov	byte ptr [r12 + 0xa8], al
1803d12e8: 48 63 05 c5 e8 4b 00        	movsxd	rax, dword ptr [rip + 0x4be8c5] # 0x18088fbb4
1803d12ef: b9 dd 43 b3 25              	mov	ecx, 0x25b343dd
1803d12f4: 48 8d 15 35 6f 28 00        	lea	rdx, [rip + 0x286f35]   # 0x180658230
1803d12fb: 33 0c 82                    	xor	ecx, dword ptr [rdx + 4*rax]
1803d12fe: ff c1                       	inc	ecx
1803d1300: 0f c9                       	bswap	ecx
1803d1302: 48 63 c1                    	movsxd	rax, ecx
1803d1305: 31 c9                       	xor	ecx, ecx
1803d1307: 48 8d 15 72 56 3e 00        	lea	rdx, [rip + 0x3e5672]   # 0x1807b6980
1803d130e: 2b 0c 82                    	sub	ecx, dword ptr [rdx + 4*rax]
1803d1311: 81 f1 6c 7d 09 e2           	xor	ecx, 0xe2097d6c
1803d1317: 48 63 c1                    	movsxd	rax, ecx
1803d131a: 48 8d 0d af 4a 3e 00        	lea	rcx, [rip + 0x3e4aaf]   # 0x1807b5dd0
1803d1321: 48 8b 0c c1                 	mov	rcx, qword ptr [rcx + 8*rax]
1803d1325: e8 b6 b8 03 00              	call	0x18040cbe0 <.text+0x3fcbe0>
1803d132a: 48 63 15 e7 b0 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fb0e7] # 0x1807cc418
1803d1331: 48 8d 1d c8 b9 28 00        	lea	rbx, [rip + 0x28b9c8]   # 0x18065cd00
1803d1338: 8b 04 93                    	mov	eax, dword ptr [rbx + 4*rdx]
1803d133b: 8d 4a 19                    	lea	ecx, [rdx + 0x19]
1803d133e: d3 c8                       	ror	eax, cl
1803d1340: b9 39 a9 65 f9              	mov	ecx, 0xf965a939
1803d1345: 29 d1                       	sub	ecx, edx
1803d1347: d3 c0                       	rol	eax, cl
1803d1349: d3 c0                       	rol	eax, cl
1803d134b: 8d 48 05                    	lea	ecx, [rax + 0x5]
1803d134e: 89 c2                       	mov	edx, eax
1803d1350: f7 da                       	neg	edx
1803d1352: 48 63 d2                    	movsxd	rdx, edx
1803d1355: 45 31 c0                    	xor	r8d, r8d
1803d1358: 4c 8d 2d 71 27 3f 00        	lea	r13, [rip + 0x3f2771]   # 0x1807c3ad0
1803d135f: 45 2b 44 95 00              	sub	r8d, dword ptr [r13 + 4*rdx]
1803d1364: 41 d3 c0                    	rol	r8d, cl
1803d1367: b9 05 00 00 00              	mov	ecx, 0x5
1803d136c: 29 c1                       	sub	ecx, eax
1803d136e: 41 81 f0 1a 0d 76 ac        	xor	r8d, 0xac760d1a
1803d1375: 41 ff c0                    	inc	r8d
1803d1378: 41 d3 c8                    	ror	r8d, cl
1803d137b: 41 f7 d0                    	not	r8d
1803d137e: 41 0f c8                    	bswap	r8d
1803d1381: 41 f7 d8                    	neg	r8d
1803d1384: 49 63 c0                    	movsxd	rax, r8d
1803d1387: 48 8d 8d b0 05 00 00        	lea	rcx, [rbp + 0x5b0]
1803d138e: 4c 8d 25 db c8 3e 00        	lea	r12, [rip + 0x3ec8db]   # 0x1807bdc70
1803d1395: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d1399: be 27 35 7c c4              	mov	esi, 0xc47c3527
1803d139e: bf 40 5f 9f 07              	mov	edi, 0x79f5f40
1803d13a3: 48 8d 05 e2 3c 3e 00        	lea	rax, [rip + 0x3e3ce2]   # 0x1807b508c
1803d13aa: 33 38                       	xor	edi, dword ptr [rax]
1803d13ac: 48 63 0d 89 b0 3f 00        	movsxd	rcx, dword ptr [rip + 0x3fb089] # 0x1807cc43c
1803d13b3: 8b 04 8b                    	mov	eax, dword ptr [rbx + 4*rcx]
1803d13b6: 81 c1 48 da 5a a4           	add	ecx, 0xa45ada48
1803d13bc: d3 c8                       	ror	eax, cl
1803d13be: d3 c8                       	ror	eax, cl
1803d13c0: d3 c8                       	ror	eax, cl
1803d13c2: 89 c1                       	mov	ecx, eax
1803d13c4: f7 d1                       	not	ecx
1803d13c6: 48 63 c9                    	movsxd	rcx, ecx
1803d13c9: 45 8b 44 8d 00              	mov	r8d, dword ptr [r13 + 4*rcx]
1803d13ce: ba 2f 1d 42 31              	mov	edx, 0x31421d2f
1803d13d3: 29 c2                       	sub	edx, eax
1803d13d5: 89 d1                       	mov	ecx, edx
1803d13d7: 41 d3 c8                    	ror	r8d, cl
1803d13da: 41 0f c8                    	bswap	r8d
1803d13dd: 05 31 1d 42 31              	add	eax, 0x31421d31
1803d13e2: 89 c1                       	mov	ecx, eax
1803d13e4: 41 d3 c0                    	rol	r8d, cl
1803d13e7: 89 d1                       	mov	ecx, edx
1803d13e9: 41 d3 c8                    	ror	r8d, cl
1803d13ec: 41 f7 d0                    	not	r8d
1803d13ef: 41 d3 c8                    	ror	r8d, cl
1803d13f2: 41 81 f0 30 1d 42 31        	xor	r8d, 0x31421d30
1803d13f9: 89 c1                       	mov	ecx, eax
1803d13fb: 41 d3 c0                    	rol	r8d, cl
1803d13fe: 49 63 c0                    	movsxd	rax, r8d
1803d1401: 48 8d 8d 80 05 00 00        	lea	rcx, [rbp + 0x580]
1803d1408: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d140c: 48 63 15 21 b0 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fb021] # 0x1807cc434
1803d1413: 8b 04 93                    	mov	eax, dword ptr [rbx + 4*rdx]
1803d1416: 8d 4a 19                    	lea	ecx, [rdx + 0x19]
1803d1419: d3 c8                       	ror	eax, cl
1803d141b: b9 39 a9 65 f9              	mov	ecx, 0xf965a939
1803d1420: 29 d1                       	sub	ecx, edx
1803d1422: d3 c0                       	rol	eax, cl
1803d1424: d3 c0                       	rol	eax, cl
1803d1426: 8d 48 05                    	lea	ecx, [rax + 0x5]
1803d1429: 89 c2                       	mov	edx, eax
1803d142b: f7 da                       	neg	edx
1803d142d: 48 63 d2                    	movsxd	rdx, edx
1803d1430: 45 31 c0                    	xor	r8d, r8d
1803d1433: 45 2b 44 95 00              	sub	r8d, dword ptr [r13 + 4*rdx]
1803d1438: 41 d3 c0                    	rol	r8d, cl
1803d143b: b9 05 00 00 00              	mov	ecx, 0x5
1803d1440: 29 c1                       	sub	ecx, eax
1803d1442: 45 31 f6                    	xor	r14d, r14d
1803d1445: 41 81 f0 1a 0d 76 ac        	xor	r8d, 0xac760d1a
1803d144c: 41 ff c0                    	inc	r8d
1803d144f: 41 d3 c8                    	ror	r8d, cl
1803d1452: 41 f7 d0                    	not	r8d
1803d1455: 41 0f c8                    	bswap	r8d
1803d1458: 41 f7 d8                    	neg	r8d
1803d145b: 49 63 c0                    	movsxd	rax, r8d
1803d145e: 48 8d 8d 10 05 00 00        	lea	rcx, [rbp + 0x510]
1803d1465: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d1469: 39 f7                       	cmp	edi, esi
1803d146b: 75 0c                       	jne	0x1803d1479 <.text+0x3c1479>
1803d146d: 41 b6 01                    	mov	r14b, 0x1
1803d1470: 48 8d 35 21 3c 3e 00        	lea	rsi, [rip + 0x3e3c21]   # 0x1807b5098
1803d1477: 8b 06                       	mov	eax, dword ptr [rsi]
1803d1479: 44 89 b5 e8 05 00 00        	mov	dword ptr [rbp + 0x5e8], r14d
1803d1480: 48 63 05 99 af 3f 00        	movsxd	rax, dword ptr [rip + 0x3faf99] # 0x1807cc420
1803d1487: 48 8d 35 72 b8 28 00        	lea	rsi, [rip + 0x28b872]   # 0x18065cd00
1803d148e: 8b 14 86                    	mov	edx, dword ptr [rsi + 4*rax]
1803d1491: 8d 48 0c                    	lea	ecx, [rax + 0xc]
1803d1494: d3 ca                       	ror	edx, cl
1803d1496: ff c2                       	inc	edx
1803d1498: 81 f2 8c 18 f5 e9           	xor	edx, 0xe9f5188c
1803d149e: 48 63 ca                    	movsxd	rcx, edx
1803d14a1: 41 8b 44 8d 00              	mov	eax, dword ptr [r13 + 4*rcx]
1803d14a6: 81 c1 3a f5 03 0d           	add	ecx, 0xd03f53a
1803d14ac: d3 c8                       	ror	eax, cl
1803d14ae: 0f c8                       	bswap	eax
1803d14b0: d3 c8                       	ror	eax, cl
1803d14b2: 0f c8                       	bswap	eax
1803d14b4: 48 98                       	cdqe
1803d14b6: 48 8d 8d 10 02 00 00        	lea	rcx, [rbp + 0x210]
1803d14bd: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d14c1: 48 63 05 78 af 3f 00        	movsxd	rax, dword ptr [rip + 0x3faf78] # 0x1807cc440
1803d14c8: 8b 14 86                    	mov	edx, dword ptr [rsi + 4*rax]
1803d14cb: 8d 88 08 c4 97 e4           	lea	ecx, [rax - 0x1b683bf8]
1803d14d1: d3 ca                       	ror	edx, cl
1803d14d3: f7 d2                       	not	edx
1803d14d5: d3 ca                       	ror	edx, cl
1803d14d7: b9 08 00 00 00              	mov	ecx, 0x8
1803d14dc: 29 c1                       	sub	ecx, eax
1803d14de: d3 c2                       	rol	edx, cl
1803d14e0: 48 63 c2                    	movsxd	rax, edx
1803d14e3: 41 8b 54 85 00              	mov	edx, dword ptr [r13 + 4*rax]
1803d14e8: b9 17 00 00 00              	mov	ecx, 0x17
1803d14ed: 29 c1                       	sub	ecx, eax
1803d14ef: d3 c2                       	rol	edx, cl
1803d14f1: 05 d7 34 f9 0b              	add	eax, 0xbf934d7
1803d14f6: 89 c1                       	mov	ecx, eax
1803d14f8: d3 ca                       	ror	edx, cl
1803d14fa: 81 f2 d7 34 f9 0b           	xor	edx, 0xbf934d7
1803d1500: ff c2                       	inc	edx
1803d1502: d3 ca                       	ror	edx, cl
1803d1504: f7 da                       	neg	edx
1803d1506: 81 f2 d7 34 f9 0b           	xor	edx, 0xbf934d7
1803d150c: 48 63 c2                    	movsxd	rax, edx
1803d150f: 48 8d 8d 90 02 00 00        	lea	rcx, [rbp + 0x290]
1803d1516: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d151a: 48 63 15 23 af 3f 00        	movsxd	rdx, dword ptr [rip + 0x3faf23] # 0x1807cc444
1803d1521: 8b 04 96                    	mov	eax, dword ptr [rsi + 4*rdx]
1803d1524: 8d 4a 19                    	lea	ecx, [rdx + 0x19]
1803d1527: d3 c8                       	ror	eax, cl
1803d1529: b9 39 a9 65 f9              	mov	ecx, 0xf965a939
1803d152e: 29 d1                       	sub	ecx, edx
1803d1530: d3 c0                       	rol	eax, cl
1803d1532: d3 c0                       	rol	eax, cl
1803d1534: 8d 48 05                    	lea	ecx, [rax + 0x5]
1803d1537: 89 c2                       	mov	edx, eax
1803d1539: f7 da                       	neg	edx
1803d153b: 48 63 d2                    	movsxd	rdx, edx
1803d153e: 45 31 c0                    	xor	r8d, r8d
1803d1541: 45 2b 44 95 00              	sub	r8d, dword ptr [r13 + 4*rdx]
1803d1546: 41 d3 c0                    	rol	r8d, cl
1803d1549: b9 05 00 00 00              	mov	ecx, 0x5
1803d154e: 29 c1                       	sub	ecx, eax
1803d1550: 41 81 f0 1a 0d 76 ac        	xor	r8d, 0xac760d1a
1803d1557: 41 ff c0                    	inc	r8d
1803d155a: 41 d3 c8                    	ror	r8d, cl
1803d155d: 41 f7 d0                    	not	r8d
1803d1560: 41 0f c8                    	bswap	r8d
1803d1563: 41 f7 d8                    	neg	r8d
1803d1566: 49 63 c0                    	movsxd	rax, r8d
1803d1569: 48 8d 8d 70 05 00 00        	lea	rcx, [rbp + 0x570]
1803d1570: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d1574: 48 63 05 ad ae 3f 00        	movsxd	rax, dword ptr [rip + 0x3faead] # 0x1807cc428
1803d157b: 48 8d 35 7e b7 28 00        	lea	rsi, [rip + 0x28b77e]   # 0x18065cd00
1803d1582: 8b 14 86                    	mov	edx, dword ptr [rsi + 4*rax]
1803d1585: 0f ca                       	bswap	edx
1803d1587: f7 da                       	neg	edx
1803d1589: b9 1a 00 00 00              	mov	ecx, 0x1a
1803d158e: 29 c1                       	sub	ecx, eax
1803d1590: d3 c2                       	rol	edx, cl
1803d1592: 8d 48 1a                    	lea	ecx, [rax + 0x1a]
1803d1595: d3 ca                       	ror	edx, cl
1803d1597: 48 63 d2                    	movsxd	rdx, edx
1803d159a: 45 31 c0                    	xor	r8d, r8d
1803d159d: 4c 8d 2d 2c 25 3f 00        	lea	r13, [rip + 0x3f252c]   # 0x1807c3ad0
1803d15a4: 45 2b 44 95 00              	sub	r8d, dword ptr [r13 + 4*rdx]
1803d15a9: 41 81 f0 6c 18 18 6c        	xor	r8d, 0x6c18186c
1803d15b0: 41 0f c8                    	bswap	r8d
1803d15b3: 8d 82 65 30 d7 f6           	lea	eax, [rdx - 0x928cf9b]
1803d15b9: 89 c1                       	mov	ecx, eax
1803d15bb: 41 d3 c8                    	ror	r8d, cl
1803d15be: b9 05 00 00 00              	mov	ecx, 0x5
1803d15c3: 29 d1                       	sub	ecx, edx
1803d15c5: 41 d3 c0                    	rol	r8d, cl
1803d15c8: 89 c1                       	mov	ecx, eax
1803d15ca: 41 d3 c8                    	ror	r8d, cl
1803d15cd: 49 63 c0                    	movsxd	rax, r8d
1803d15d0: 48 8d 4d 58                 	lea	rcx, [rbp + 0x58]
1803d15d4: 4c 8d 25 95 c6 3e 00        	lea	r12, [rip + 0x3ec695]   # 0x1807bdc70
1803d15db: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d15df: 45 31 ff                    	xor	r15d, r15d
1803d15e2: 8b 85 e8 05 00 00           	mov	eax, dword ptr [rbp + 0x5e8]
1803d15e8: 89 85 e8 05 00 00           	mov	dword ptr [rbp + 0x5e8], eax
1803d15ee: 48 63 05 43 ae 3f 00        	movsxd	rax, dword ptr [rip + 0x3fae43] # 0x1807cc438
1803d15f5: 8b 14 86                    	mov	edx, dword ptr [rsi + 4*rax]
1803d15f8: 8d 88 eb b8 ad c0           	lea	ecx, [rax - 0x3f524715]
1803d15fe: d3 ca                       	ror	edx, cl
1803d1600: d3 ca                       	ror	edx, cl
1803d1602: b9 0b 00 00 00              	mov	ecx, 0xb
1803d1607: 29 c1                       	sub	ecx, eax
1803d1609: d3 c2                       	rol	edx, cl
1803d160b: 81 f2 eb b8 ad c0           	xor	edx, 0xc0adb8eb
1803d1611: 48 63 ca                    	movsxd	rcx, edx
1803d1614: b8 8d 21 69 03              	mov	eax, 0x369218d
1803d1619: 41 33 44 8d 00              	xor	eax, dword ptr [r13 + 4*rcx]
1803d161e: 0f c8                       	bswap	eax
1803d1620: 81 c1 8d 21 69 03           	add	ecx, 0x369218d
1803d1626: d3 c8                       	ror	eax, cl
1803d1628: f7 d8                       	neg	eax
1803d162a: d3 c8                       	ror	eax, cl
1803d162c: f7 d8                       	neg	eax
1803d162e: 48 98                       	cdqe
1803d1630: 48 8d 8d 18 04 00 00        	lea	rcx, [rbp + 0x418]
1803d1637: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d163b: 48 63 15 b6 ad 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fadb6] # 0x1807cc3f8
1803d1642: 8b 04 96                    	mov	eax, dword ptr [rsi + 4*rdx]
1803d1645: b9 13 00 00 00              	mov	ecx, 0x13
1803d164a: 29 d1                       	sub	ecx, edx
1803d164c: d3 c0                       	rol	eax, cl
1803d164e: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d1653: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d1658: 29 c1                       	sub	ecx, eax
1803d165a: 48 63 c9                    	movsxd	rcx, ecx
1803d165d: 31 d2                       	xor	edx, edx
1803d165f: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803d1664: bf 13 00 00 00              	mov	edi, 0x13
1803d1669: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d166e: 29 c1                       	sub	ecx, eax
1803d1670: d3 ca                       	ror	edx, cl
1803d1672: d3 ca                       	ror	edx, cl
1803d1674: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d167a: d3 ca                       	ror	edx, cl
1803d167c: bb fe ff ff ff              	mov	ebx, 0xfffffffe
1803d1681: 49 89 f6                    	mov	r14, rsi
1803d1684: be ce 45 48 92              	mov	esi, 0x924845ce
1803d1689: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d168e: 89 c1                       	mov	ecx, eax
1803d1690: d3 c2                       	rol	edx, cl
1803d1692: d3 c2                       	rol	edx, cl
1803d1694: 48 63 c2                    	movsxd	rax, edx
1803d1697: 48 8d 8d c0 00 00 00        	lea	rcx, [rbp + 0xc0]
1803d169e: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d16a2: 48 63 15 33 ad 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fad33] # 0x1807cc3dc
1803d16a9: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803d16ad: b9 13 00 00 00              	mov	ecx, 0x13
1803d16b2: 29 d1                       	sub	ecx, edx
1803d16b4: d3 c0                       	rol	eax, cl
1803d16b6: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d16bb: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d16c0: 29 c1                       	sub	ecx, eax
1803d16c2: 48 63 c9                    	movsxd	rcx, ecx
1803d16c5: 31 d2                       	xor	edx, edx
1803d16c7: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803d16cc: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d16d1: 29 c1                       	sub	ecx, eax
1803d16d3: d3 ca                       	ror	edx, cl
1803d16d5: d3 ca                       	ror	edx, cl
1803d16d7: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d16dd: d3 ca                       	ror	edx, cl
1803d16df: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d16e4: 89 c1                       	mov	ecx, eax
1803d16e6: d3 c2                       	rol	edx, cl
1803d16e8: d3 c2                       	rol	edx, cl
1803d16ea: 48 63 c2                    	movsxd	rax, edx
1803d16ed: 48 8d 8d 40 01 00 00        	lea	rcx, [rbp + 0x140]
1803d16f4: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d16f8: 48 63 15 e9 ac 3f 00        	movsxd	rdx, dword ptr [rip + 0x3face9] # 0x1807cc3e8
1803d16ff: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803d1703: b9 13 00 00 00              	mov	ecx, 0x13
1803d1708: 29 d1                       	sub	ecx, edx
1803d170a: d3 c0                       	rol	eax, cl
1803d170c: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d1711: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d1716: 29 c1                       	sub	ecx, eax
1803d1718: 48 63 c9                    	movsxd	rcx, ecx
1803d171b: 31 d2                       	xor	edx, edx
1803d171d: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803d1722: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d1727: 29 c1                       	sub	ecx, eax
1803d1729: d3 ca                       	ror	edx, cl
1803d172b: d3 ca                       	ror	edx, cl
1803d172d: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d1733: d3 ca                       	ror	edx, cl
1803d1735: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d173a: 89 c1                       	mov	ecx, eax
1803d173c: d3 c2                       	rol	edx, cl
1803d173e: d3 c2                       	rol	edx, cl
1803d1740: 48 63 c2                    	movsxd	rax, edx
1803d1743: 48 8d 8d 20 01 00 00        	lea	rcx, [rbp + 0x120]
1803d174a: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d174e: 48 63 15 d7 ac 3f 00        	movsxd	rdx, dword ptr [rip + 0x3facd7] # 0x1807cc42c
1803d1755: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803d1759: b9 13 00 00 00              	mov	ecx, 0x13
1803d175e: 29 d1                       	sub	ecx, edx
1803d1760: d3 c0                       	rol	eax, cl
1803d1762: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d1767: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d176c: 29 c1                       	sub	ecx, eax
1803d176e: 48 63 c9                    	movsxd	rcx, ecx
1803d1771: 31 d2                       	xor	edx, edx
1803d1773: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803d1778: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d177d: 29 c1                       	sub	ecx, eax
1803d177f: d3 ca                       	ror	edx, cl
1803d1781: d3 ca                       	ror	edx, cl
1803d1783: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d1789: d3 ca                       	ror	edx, cl
1803d178b: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d1790: 89 c1                       	mov	ecx, eax
1803d1792: d3 c2                       	rol	edx, cl
1803d1794: d3 c2                       	rol	edx, cl
1803d1796: 48 63 c2                    	movsxd	rax, edx
1803d1799: 48 8d 8d 00 01 00 00        	lea	rcx, [rbp + 0x100]
1803d17a0: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d17a4: 48 63 15 35 ac 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fac35] # 0x1807cc3e0
1803d17ab: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803d17af: b9 13 00 00 00              	mov	ecx, 0x13
1803d17b4: 29 d1                       	sub	ecx, edx
1803d17b6: d3 c0                       	rol	eax, cl
1803d17b8: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d17bd: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d17c2: 29 c1                       	sub	ecx, eax
1803d17c4: 48 63 c9                    	movsxd	rcx, ecx
1803d17c7: 31 d2                       	xor	edx, edx
1803d17c9: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803d17ce: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d17d3: 29 c1                       	sub	ecx, eax
1803d17d5: d3 ca                       	ror	edx, cl
1803d17d7: d3 ca                       	ror	edx, cl
1803d17d9: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d17df: d3 ca                       	ror	edx, cl
1803d17e1: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d17e6: 89 c1                       	mov	ecx, eax
1803d17e8: d3 c2                       	rol	edx, cl
1803d17ea: d3 c2                       	rol	edx, cl
1803d17ec: 48 63 c2                    	movsxd	rax, edx
1803d17ef: 48 8d 8d c0 01 00 00        	lea	rcx, [rbp + 0x1c0]
1803d17f6: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d17fa: 48 63 15 e3 ab 3f 00        	movsxd	rdx, dword ptr [rip + 0x3fabe3] # 0x1807cc3e4
1803d1801: 41 8b 04 96                 	mov	eax, dword ptr [r14 + 4*rdx]
1803d1805: b9 13 00 00 00              	mov	ecx, 0x13
1803d180a: 29 d1                       	sub	ecx, edx
1803d180c: d3 c0                       	rol	eax, cl
1803d180e: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d1813: b9 fe ff ff ff              	mov	ecx, 0xfffffffe
1803d1818: 29 c1                       	sub	ecx, eax
1803d181a: 48 63 c9                    	movsxd	rcx, ecx
1803d181d: 31 d2                       	xor	edx, edx
1803d181f: 41 2b 54 8d 00              	sub	edx, dword ptr [r13 + 4*rcx]
1803d1824: b9 ce 45 48 92              	mov	ecx, 0x924845ce
1803d1829: 29 c1                       	sub	ecx, eax
1803d182b: d3 ca                       	ror	edx, cl
1803d182d: d3 ca                       	ror	edx, cl
1803d182f: 81 f2 2f ba b7 6d           	xor	edx, 0x6db7ba2f
1803d1835: d3 ca                       	ror	edx, cl
1803d1837: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d183c: 89 c1                       	mov	ecx, eax
1803d183e: d3 c2                       	rol	edx, cl
1803d1840: d3 c2                       	rol	edx, cl
1803d1842: 48 63 c2                    	movsxd	rax, edx
1803d1845: 48 8d 8d a0 01 00 00        	lea	rcx, [rbp + 0x1a0]
1803d184c: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d1850: 48 63 0d a5 ab 3f 00        	movsxd	rcx, dword ptr [rip + 0x3faba5] # 0x1807cc3fc
1803d1857: 41 8b 04 8e                 	mov	eax, dword ptr [r14 + 4*rcx]
1803d185b: 29 cf                       	sub	edi, ecx
1803d185d: 89 f9                       	mov	ecx, edi
1803d185f: d3 c0                       	rol	eax, cl
1803d1861: 35 ec 77 5a ad              	xor	eax, 0xad5a77ec
1803d1866: 29 c3                       	sub	ebx, eax
1803d1868: 48 63 cb                    	movsxd	rcx, ebx
1803d186b: 45 2b 7c 8d 00              	sub	r15d, dword ptr [r13 + 4*rcx]
1803d1870: 29 c6                       	sub	esi, eax
1803d1872: 89 f1                       	mov	ecx, esi
1803d1874: 41 d3 cf                    	ror	r15d, cl
1803d1877: 41 d3 cf                    	ror	r15d, cl
1803d187a: 41 81 f7 2f ba b7 6d        	xor	r15d, 0x6db7ba2f
1803d1881: 41 d3 cf                    	ror	r15d, cl
1803d1884: 05 d2 45 48 92              	add	eax, 0x924845d2
1803d1889: 89 c1                       	mov	ecx, eax
1803d188b: 41 d3 c7                    	rol	r15d, cl
1803d188e: 41 d3 c7                    	rol	r15d, cl
1803d1891: 49 63 c7                    	movsxd	rax, r15d
1803d1894: 48 8d 8d e0 00 00 00        	lea	rcx, [rbp + 0xe0]
1803d189b: 41 ff 14 c4                 	call	qword ptr [r12 + 8*rax]
1803d189f: 8b 85 e8 05 00 00           	mov	eax, dword ptr [rbp + 0x5e8]
1803d18a5: 48 81 c4 a8 06 00 00        	add	rsp, 0x6a8
1803d18ac: 5b                          	pop	rbx
1803d18ad: 5f                          	pop	rdi
1803d18ae: 5e                          	pop	rsi
1803d18af: 41 5c                       	pop	r12
1803d18b1: 41 5d                       	pop	r13
1803d18b3: 41 5e                       	pop	r14
1803d18b5: 41 5f                       	pop	r15
1803d18b7: 5d                          	pop	rbp
1803d18b8: c3                          	ret
