segment .data
wCounter dd 0
hCounter dd 0
height dd 6
width dd 5
matrix dd 0
newMatrix dd 0
ruleCounter dd 0
rule  dd 0




segment .text
global NextGen

NextGen:

  push ebp
  mov ebp,esp

  mov ecx,[ebp+24]
  mov [rule], ecx
  mov ecx,[ebp+20]
  mov [newMatrix], ecx
  mov ecx,[ebp+16]
  mov [width], ecx
  mov ebx,[ebp+12]
  mov [height], ebx
  mov eax,[ebp+8]
  mov [matrix],eax
  mov [hCounter],dword 0

;*********Loop1*********
HeightIter:

  mov [wCounter],dword 0
;*********Loop2*********
WidthtIter:
  jmp CalculateCellValue
Continue:
  mov eax,[wCounter]
  inc eax
  mov [wCounter],eax
  cmp eax,[width]
  jne WidthtIter
;***********************
  mov eax,[hCounter]
  inc eax
  mov [hCounter],eax
  cmp eax,[height]
  jne HeightIter
;***********************
  mov eax,[newMatrix]
  pop ebp
  ret

CalculateCellValue:
  mov [ruleCounter],dword 0
  mov ecx,[matrix]

  jmp CenterValue
ReturnFromCenter:
  mov ecx,[matrix]
  jmp NorthValue
ReturnFromNorth:
  mov ecx,[matrix]
  jmp EastValue
ReturnFromEast:

  mov ecx,[matrix]
  jmp SouthValue

ReturnFromSouth:

  mov ecx,[matrix]
  jmp WestValue
ReturnFromWest:
  mov ecx,[newMatrix]
  mov edx,[ruleCounter]
  call SetCellValue
  jmp Continue


CenterValue:
  mov edx,[hCounter]
  call GetIntPointer
  mov ecx,eax
  mov edx,[wCounter]
  call GetInt
  mov ebx,[ruleCounter]
  add ebx,[eax]
  shl ebx,1     ;shift left
  mov [ruleCounter],ebx
  jmp ReturnFromCenter

NorthValue:
  mov edx,[hCounter]
  cmp edx,0
  je SetNorthZero
  dec edx
  call GetIntPointer
  mov ecx,eax
  mov edx,[wCounter]
  call GetInt
  mov ebx,[ruleCounter]
  add ebx,[eax]
  shl ebx,1     ;shift left
  mov [ruleCounter],ebx
  jmp ReturnFromNorth
SetNorthZero:
  mov ebx,[ruleCounter]
  shl ebx,1     ;shift left
  mov [ruleCounter],ebx    ;shift left
  jmp ReturnFromNorth

EastValue:
  mov edx,[wCounter]
  inc edx
  cmp edx,[width]
  je SetEastZero
  mov edx,[hCounter]
  call GetIntPointer
  mov edx,[wCounter]
  inc edx
  mov ecx,eax
  call GetInt
  mov ebx,[ruleCounter]
  add ebx,[eax]
  shl ebx,1     ;shift left
  mov [ruleCounter],ebx
  jmp ReturnFromEast
SetEastZero:
  mov ebx,[ruleCounter]
  shl ebx,1     ;shift left
  mov [ruleCounter],ebx
  jmp ReturnFromEast

SouthValue:
  mov edx,[hCounter]
  inc edx
  cmp edx,[height]
  je SetSouthZero
  call GetIntPointer
  mov edx,[wCounter]
  mov ecx,eax
  call GetInt
  mov ebx,[ruleCounter]
  add ebx,[eax]
  shl ebx,1     ;shift left
  mov [ruleCounter],ebx
  jmp ReturnFromSouth
SetSouthZero:
  mov ebx,[ruleCounter]
  shl ebx,1     ;shift left
  mov [ruleCounter],ebx    ;shift left
  jmp ReturnFromSouth

WestValue:
  mov edx,[wCounter]
  cmp edx,0
  je ReturnFromWest
  mov edx,[hCounter]
  call GetIntPointer
  mov edx,[wCounter]
  dec edx
  mov ecx,eax
  call GetInt
  mov ebx,[ruleCounter]
  add ebx,[eax]
  mov [ruleCounter],ebx
  jmp ReturnFromWest


; ecx int **,edx height
GetIntPointer:
  xor ebx,ebx
  ;instead of multipying with four
  add ebx,edx
  add ebx,edx
  add ebx,edx
  add ebx,edx

  add ecx,ebx
  mov eax,[ecx]
  ret
; ecx int* ,edx width
GetInt:
  xor ebx,ebx
  add ebx,edx
  add ebx,edx
  add ebx,edx
  add ebx,edx

  add ecx,ebx
  mov eax,ecx
  ret
;ecx matrix, edx value, height and width will be hCounter and wCounter
SetCellValue:
  mov ebx,edx
  mov edx,[hCounter]
  call GetIntPointer
  mov ecx,eax
  mov edx,[wCounter]
  call GetInt
  mov ebx,[ruleCounter]
  call GetGeneratedCellFromRule
  mov [eax],edx
  ret
GetGeneratedCellFromRule:
  mov edx,[ruleCounter]
  mov ebx,[rule]
IterRule:
  shl ebx,1
  dec edx
  cmp edx,0
  jne IterRule
  dec edx
  and edx,ebx
  js SetCellOne
  mov edx,0
  ret
SetCellOne:
  mov edx,1
  ret
