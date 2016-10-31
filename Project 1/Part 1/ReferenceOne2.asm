segment .data
msg dw "HelloWorld"
segment .bss
retChar resw ""
segment .text
global ASM

ASM:
; [ebp + 8]  --> Rule
; [ebp + 12] --> Size of the past generations
; [ebp + 16] --> Past generation as an integer
; [ebp - 4]  --> Inner function passing position value 0
; [ebp - 8]  --> Inner function passing position value 1
; [ebp - 12] --> Inner function passing position value 1
; [ebp - 16] --> Calculating Rule Shift
; [ebp - 20] --> Past Generation Copy
; [ebp - 24] --> Outer Loop Iteration Value
; [ebp - 28] --> Next generation value
; [ebp - 32] --> Size of past gen - 1
; [ebp - 36] --> Empty Space Just For Setting
; [ebp - 40] --> Inner Loop Shift Amount
; [ebp - 44] --> Rule Copy
; [ebp - 48] --> Last


  push ebp
  mov ebp, esp

  mov ebx, [ebp+8]
  mov ecx, [ebp+12]
  mov edx, [ebp+16]

  mov dword [ebp-4], 0
  mov dword [ebp-8], 0
  mov dword [ebp-16], 0
  mov dword [ebp-20], 0
  mov dword [ebp-24], 0
  mov dword [ebp-28], 0
  mov dword [ebp-32], 0
  mov dword [ebp-36], 0
  mov dword [ebp-40], 0
  mov [ebp-44], ebx

  xor eax, eax

  mov [ebp - 24], eax

  mov eax, ecx
  sub eax, 1
  mov [ebp-32], eax

  mov eax, 32
  sub eax, ecx
Prepare:
  cmp eax, 0
  je  OuterLoop
  shl edx, 1
  mov [ebp-20] , edx
  dec eax
  jmp Prepare
OuterLoop:
  mov edx, [ebp-20]
  mov eax, [ebp-24]
  cmp eax, ecx
  je Done
  cmp eax, 0 ; Compare If It is at the beginning
  je ZeroSpecialCase
  cmp eax, [ebp - 32] ; Compare If It reached The End of The Generation
  je EndSpecialCase
  jmp NormalCase
ZeroSpecialCase:
  xor eax, eax
  push 0;mov [ebp-4], 0
  call CallSet
  push eax;mov [ebp-8], eax
  call CallSet
  push eax;mov [ebp-12], eax
  jmp AddToIter
EndSpecialCase:
  call CallSet
  push eax;mov [ebp-4], eax
  call CallSet
  push eax;;mov [ebp-8], eax
  push 0;
  ;mov eax, 0
  ;mov [ebp-12], eax
  jmp AddToIter
NormalCase:
  call CallSet
  push eax;mov [ebp-4], eax
  call CallSet
  push eax;mov [ebp-8], eax
  call CallSet
  push eax;mov [ebp-12], eax
  jmp AddToIter
AddToIter:
  mov eax, [ebp-28]
  shl eax, 1
  mov [ebp-28], eax
;;;;;;;;;;;
  xor edx, edx
  xor eax, eax

  pop eax
  pop edx
  shl edx,1
  add eax, edx
  pop edx
  shl edx, 2
  add eax, edx
  mov edx, eax
  call InnerLoop
AfterInnerLoop:
  add eax, [ebp-28]
  mov [ebp-28], eax
  mov eax, [ebp-24]
  add eax, 1
  mov [ebp-24], eax
  call EqualTheShift
  jmp OuterLoop
Done:
  mov eax, [ebp-28]
  shl eax, 1
  pop ebp
  ret

EqualTheShift:
  mov eax, [ebp-24]
  cmp eax, 3
  jl EndShift
  mov edx, [ebp-20]
  shl edx, 1
  mov [ebp-20], edx
EndShift:
  ret

CallSet:
  mov eax, edx
  cmp eax, 0
  jnl Set0
  jmp Set1
Set0:
  mov eax,0
  shl edx,1
  ret
Set1:
  mov eax,1
  shl edx,1
  ret

InnerLoop:
  mov eax, edx
  mov [ebp-40], eax
  mov eax, 7
  sub eax, [ebp-40]
  mov edx, ebx
Rotate:
  cmp eax, 0
  je Check
  shl edx, 1
  dec eax
  jmp Rotate

Check:
  shl edx, 24
  js Set1
  jns Set0
