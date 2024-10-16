/*
 *  Project:            tiny_gpu -- a gpu test.
 *  Module name:        Testbench.
 *  Description:        Testbench of tiny_gpu.
 *  Last updated date:  2024.10.15.
 *
 *  Copyright (C) 2021-2024 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

// `define MATMUL

`timescale 1ns/1ps
module Testbench_wrapper(
);

`ifdef DUMP_FSDB
  initial begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars(0,"+all");
    $fsdbDumpMDA();
    $vcdpluson;
    $vcdplusmemon;
  end
`endif
  parameter DATA_MEM_ADDR_BITS = 8;        // Number of bits in data memory address (256 rows)
  parameter DATA_MEM_DATA_BITS = 8;        // Number of bits in data memory value (8 bit data)
  parameter DATA_MEM_NUM_CHANNELS = 4;     // Number of concurrent channels for sending requests to data memory
  parameter PROGRAM_MEM_ADDR_BITS = 8;     // Number of bits in program memory address (256 rows)
  parameter PROGRAM_MEM_DATA_BITS = 16;    // Number of bits in program memory value (16 bit instruction)
  parameter PROGRAM_MEM_NUM_CHANNELS = 1;  // Number of concurrent channels for sending requests to program memory
  parameter NUM_CORES = 2;                 // Number of cores to include in this GPU
  parameter THREADS_PER_BLOCK = 4;         // Numbe

  reg               clk,rst_n;
  reg               start;
  wire              done;
  reg               device_control_write_enable;
  reg   [7:0]       device_control_data;
  wire  [PROGRAM_MEM_NUM_CHANNELS-1:0]  program_mem_read_valid;
  wire  [PROGRAM_MEM_NUM_CHANNELS-1:0][PROGRAM_MEM_ADDR_BITS-1:0]     program_mem_read_address ;
  reg   [PROGRAM_MEM_NUM_CHANNELS-1:0]  program_mem_read_ready;
  reg   [PROGRAM_MEM_NUM_CHANNELS-1:0][PROGRAM_MEM_DATA_BITS-1:0]     program_mem_read_data ;
  wire  [DATA_MEM_NUM_CHANNELS-1:0]     data_mem_read_valid;
  wire  [DATA_MEM_NUM_CHANNELS-1:0][DATA_MEM_ADDR_BITS-1:0]        data_mem_read_address ;
  reg   [DATA_MEM_NUM_CHANNELS-1:0]     data_mem_read_ready;
  reg   [DATA_MEM_NUM_CHANNELS-1:0][DATA_MEM_DATA_BITS-1:0]        data_mem_read_data ;
  wire  [DATA_MEM_NUM_CHANNELS-1:0]     data_mem_write_valid;
  wire  [DATA_MEM_NUM_CHANNELS-1:0][DATA_MEM_ADDR_BITS-1:0]        data_mem_write_address ;
  wire  [DATA_MEM_NUM_CHANNELS-1:0][DATA_MEM_DATA_BITS-1:0]        data_mem_write_data ;
  reg   [DATA_MEM_NUM_CHANNELS-1:0]     data_mem_write_ready;


  // gpu #(
  //   .DATA_MEM_ADDR_BITS(8),        // Number of bits in data memory address (256 rows)
  //   .DATA_MEM_DATA_BITS(8),        // Number of bits in data memory value (8 bit data)
  //   .DATA_MEM_NUM_CHANNELS(4),     // Number of concurrent channels for sending requests to data memory
  //   .PROGRAM_MEM_ADDR_BITS(8),     // Number of bits in program memory address (256 rows)
  //   .PROGRAM_MEM_DATA_BITS(16),    // Number of bits in program memory value (16 bit instruction)
  //   .PROGRAM_MEM_NUM_CHANNELS(1),  // Number of concurrent channels for sending requests to program memory
  //   .NUM_CORES(2),                 // Number of cores to include in this GPU
  //   .THREADS_PER_BLOCK(4)          // Number of threads to handle per block (determines the compute resources of each core)
  // ) gpu_test(
  gpu gpu_test(
    .clk                        (clk),
    .reset                      (~rst_n),

    // Kernel Execution
    .start                      (start),
    .done                       (done),

    // Device Control Register
    .device_control_write_enable(device_control_write_enable),
    .device_control_data        (device_control_data),

    // Program Memory
    .program_mem_read_valid     (program_mem_read_valid),
    .program_mem_read_address   (program_mem_read_address),
    .program_mem_read_ready     (program_mem_read_ready),
    .program_mem_read_data      (program_mem_read_data),

    // Data Memory
    .data_mem_read_valid        (data_mem_read_valid),
    .data_mem_read_address      (data_mem_read_address),
    .data_mem_read_ready        (data_mem_read_ready),
    .data_mem_read_data         (data_mem_read_data),
    .data_mem_write_valid       (data_mem_write_valid),
    .data_mem_write_address     (data_mem_write_address),
    .data_mem_write_data        (data_mem_write_data),
    .data_mem_write_ready       (data_mem_write_ready)
);

  initial begin
    rst_n = 1;
    #2  rst_n = 0;
    #10 rst_n = 1;
  end
  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end
  initial begin
    #400000 $finish;
  end

  reg   [31:0][15:0]  program_mem;
  reg   [3:0][31:0][ 7:0]  data_mem;
  reg                 start_oneTime, device_control_write_oneTime;
  wire  [15:0]        w_program_mem_read_data = program_mem[program_mem_read_address[4:0]];

  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      `ifdef MATMUL
        //*matmul
        program_mem[0]  <= 'b0101000011011110; // MUL R0, %blockIdx, %blockDim
        program_mem[1]  <= 'b0011000000001111; // ADD R0, R0, %threadIdx         ; i = blockIdx * blockDim + threadIdx
        program_mem[2]  <= 'b1001000100000001; // CONST R1, #1                   ; increment
        program_mem[3]  <= 'b1001001000000010; // CONST R2, #2                   ; N (matrix inner dimension)
        program_mem[4]  <= 'b1001001100000000; // CONST R3, #0                   ; baseA (matrix A base address)
        program_mem[5]  <= 'b1001010000000100; // CONST R4, #4                   ; baseB (matrix B base address)
        program_mem[6]  <= 'b1001010100001000; // CONST R5, #8                   ; baseC (matrix C base address)
        program_mem[7]  <= 'b0110011000000010; // DIV R6, R0, R2                 ; row = i // N
        program_mem[8]  <= 'b0101011101100010; // MUL R7, R6, R2
        program_mem[9]  <= 'b0100011100000111; // SUB R7, R0, R7                 ; col = i % N
        program_mem[10] <= 'b1001100000000000; // CONST R8, #0                   ; acc = 0
        program_mem[11] <= 'b1001100100000000; // CONST R9, #0                   ; k = 0
                                             // LOOP:
        program_mem[12] <= 'b0101101001100010; //   MUL R10, R6, R2
        program_mem[13] <= 'b0011101010101001; //   ADD R10, R10, R9
        program_mem[14] <= 'b0011101010100011; //   ADD R10, R10, R3             ; addr(A[i]) = row * N + k + baseA
        program_mem[15] <= 'b0111101010100000; //   LDR R10, R10                 ; load A[i] from global memory
        program_mem[16] <= 'b0101101110010010; //   MUL R11, R9, R2
        program_mem[17] <= 'b0011101110110111; //   ADD R11, R11, R7
        program_mem[18] <= 'b0011101110110100; //   ADD R11, R11, R4             ; addr(B[i]) = k * N + col + baseB
        program_mem[19] <= 'b0111101110110000; //   LDR R11, R11                 ; load B[i] from global memory
        program_mem[20] <= 'b0101110010101011; //   MUL R12, R10, R11
        program_mem[21] <= 'b0011100010001100; //   ADD R8, R8, R12              ; acc = acc + A[i] * B[i]
        program_mem[22] <= 'b0011100110010001; //   ADD R9, R9, R1               ; increment k
        program_mem[23] <= 'b0010000010010010; //   CMP R9, R2
        program_mem[24] <= 'b0001100000001100; //   BRn LOOP                     ; loop while k < N
        program_mem[25] <= 'b0011100101010000; // ADD R9, R5, R0                 ; addr(C[i]) = baseC + i 
        program_mem[26] <= 'b1000000010011000; // STR R9, R8                     ; store C[i] in global memory
        program_mem[27] <= 'b1111000000000000; // RET 

        for(integer i=0; i<4; i=i+1) begin
          data_mem[i][0]     <= 'd1;
          data_mem[i][1]     <= 'd2; 
          data_mem[i][2]     <= 'd3; 
          data_mem[i][3]     <= 'd4;
          data_mem[i][4]     <= 'd1;
          data_mem[i][5]     <= 'd2; 
          data_mem[i][6]     <= 'd3; 
          data_mem[i][7]     <= 'd4; 
        end
      `else
        //* matadd
        program_mem[0]  <= 'b0101000011011110; // MUL R0, %blockIdx, %blockDim
        program_mem[1]  <= 'b0011000000001111; // ADD R0, R0, %threadIdx         ; i = blockIdx * blockDim + threadIdx
        program_mem[2]  <= 'b1001000100000000; // CONST R1, #0                   ; baseA (matrix A base address)
        program_mem[3]  <= 'b1001001000001000; // CONST R2, #8                   ; baseB (matrix B base address)
        program_mem[4]  <= 'b1001001100010000; // CONST R3, #16                  ; baseC (matrix C base address)
        program_mem[5]  <= 'b0011010000010000; // ADD R4, R1, R0                 ; addr(A[i]) = baseA + i
        program_mem[6]  <= 'b0111010001000000; // LDR R4, R4                     ; load A[i] from global memory
        program_mem[7]  <= 'b0011010100100000; // ADD R5, R2, R0                 ; addr(B[i]) = baseB + i
        program_mem[8]  <= 'b0111010101010000; // LDR R5, R5                     ; load B[i] from global memory
        program_mem[9]  <= 'b0011011001000101; // ADD R6, R4, R5                 ; C[i] = A[i] + B[i]
        program_mem[10] <= 'b0011011100110000; // ADD R7, R3, R0                 ; addr(C[i]) = baseC + i
        program_mem[11] <= 'b1000000001110110; // STR R7, R6                     ; store C[i] in global memory
        program_mem[12] <= 'b1111000000000000; // RET                            ; end of kernel 
        
        for(integer i=0; i<4; i=i+1) begin
          data_mem[i][0]     <= 'd0;
          data_mem[i][1]     <= 'd1; 
          data_mem[i][2]     <= 'd2; 
          data_mem[i][3]     <= 'd3;
          data_mem[i][4]     <= 'd4;
          data_mem[i][5]     <= 'd5; 
          data_mem[i][6]     <= 'd6; 
          data_mem[i][7]     <= 'd7; 
          data_mem[i][8]     <= 'd0;
          data_mem[i][9]     <= 'd1; 
          data_mem[i][10]    <= 'd2; 
          data_mem[i][11]    <= 'd3;
          data_mem[i][12]    <= 'd4;
          data_mem[i][13]    <= 'd5; 
          data_mem[i][14]    <= 'd6; 
          data_mem[i][15]    <= 'd7; 
        end
      `endif

      device_control_write_enable <= '0;
      device_control_data <= 8;
      start           <= '0;
      start_oneTime   <= '0;
      device_control_write_oneTime <= '0; 
    end else begin
      device_control_write_enable <= ~device_control_write_oneTime;
      device_control_write_oneTime<= 1;
      start           <= ~start_oneTime & device_control_write_oneTime;
      start_oneTime   <= device_control_write_oneTime;
      program_mem_read_ready  <= program_mem_read_valid;
      if(program_mem_read_valid)
        program_mem_read_data <= program_mem[program_mem_read_address[0][4:0]];

      data_mem_read_ready     <= data_mem_read_valid;
      data_mem_write_ready    <= data_mem_write_valid;
      for(integer i=0; i<4; i=i+1) begin
        if(data_mem_read_valid[i])
          data_mem_read_data[i]    <= data_mem[i][data_mem_read_address[i][4:0]];
        if(data_mem_write_valid[i])
          data_mem[i][data_mem_write_address[i][4:0]]    <= data_mem_write_data[i];
      end
    end
  end
  


endmodule
