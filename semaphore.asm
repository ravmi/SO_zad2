global proberen
global proberen_time
global verhogen

extern get_os_time

section .text

proberen:
    ; rdi is first argument (pointer to semaphore)
    ; esi is second arguement (value)
    mov r11d, esi
    ; r11d := -value
    neg r11d

spin:
    cmp [rdi], esi
    jge try_pass    ; semaphore value >= value, we can try to pass
    jmp spin        ; otherwise busy wait

try_pass:
    ; Reducing semaphore value here after busy waiting.
    ; It's possible that some different program already reduced
    ; it too much right before us. Then we have to increase it back.
    lock xadd [rdi], r11d ; reducing semaphore value. 
    ; r11d is semaphore value right before us trying to pass it.
    ; We have to check if it actually was big enough, if not fix semaphore
    ; and go back to spinning. esi is value(function argument)
    cmp r11d, esi
    jl fix_sem
    jmp done

fix_sem:
    lock add [rdi], esi
    ; Eventually, we didn't succeed, going back to busy waiting 
    jmp spin

done:
    ret

verhogen:
    lock add [rdi], esi
    ret

proberen_time:
    ; rdi is first argument (pointer to semaphore)
    ; esi is second arguement (value)
    ; both go to proberen unchanged
    call get_os_time    ; return value(time) is in rax now
    mov r11, rax        ; hold previous time in r11
    call proberen
    call get_os_time    ; new time again in rax
    sub rax, r11        ; time difference in rax, it's function return value
    ret
