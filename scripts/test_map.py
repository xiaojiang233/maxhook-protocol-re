from unicorn import *
uc = Uc(UC_ARCH_X86, UC_MODE_64)
uc.mem_map(0x180000000, 0x2E40000)
print("FILE RUN OK")
