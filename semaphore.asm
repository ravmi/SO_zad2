#compare flag, should i fix them
# what about stack
# check registers and fix them(which ones can you use)
# https://0xax.github.io/asm_3/

section .text
global _start

_start:
active_wait:
cmp [semval], value
jge try_pass                     ;semval >= value, we can try open
jmp active_wait

try_pass:

lock
xadd [semval], value



;mov bl, 127
;xor al, bl
