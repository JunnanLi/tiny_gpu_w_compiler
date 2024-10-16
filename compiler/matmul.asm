MUL R0, %blockIdx, %blockDim
ADD R0, R0, %threadIdx         ; i = blockIdx * blockDim + threadIdx
CONST R1, #1                   ; increment
CONST R2, #2                   ; N (matrix inner dimension)
CONST R3, #0                   ; baseA (matrix A base address)
CONST R4, #4                   ; baseB (matrix B base address)
CONST R5, #8                   ; baseC (matrix C base address)
DIV R6, R0, R2                 ; row = i // N
MUL R7, R6, R2
SUB R7, R0, R7                 ; col = i % N
CONST R8, #0                   ; acc = 0
CONST R9, #0                   ; k = 0
LOOP:
  MUL R10, R6, R2
  ADD R10, R10, R9
  ADD R10, R10, R3             ; addr(A[i]) = row * N + k + baseA
  LDR R10, R10                 ; load A[i] from global memory
  MUL R11, R9, R2
  ADD R11, R11, R7
  ADD R11, R11, R4             ; addr(B[i]) = k * N + col + baseB
  LDR R11, R11                 ; load B[i] from global memory
  MUL R12, R10, R11
  ADD R8, R8, R12              ; acc = acc + A[i] * B[i]
  ADD R9, R9, R1               ; increment k
  CMP R9, R2
  BRn LOOP                     ; loop while k < N
ADD R9, R5, R0                 ; addr(C[i]) = baseC + i 
STR R9, R8                     ; store C[i] in global memory
RET                            ; end of kernel