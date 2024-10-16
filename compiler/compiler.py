import sys

# read argv
if len(sys.argv) < 2:
	print("please run with asm file, e.g., python3 compiler.py matmul.asm")
	exit()
file_to_read = sys.argv[1]
file_to_write = file_to_read + '.o'

# parse asm
f_read = open(file_to_read, 'r') 
f_write = open(file_to_write, 'w') 
## branch tag & pc
tag_list = []
pc_list = []
inst_cnt = 0
## read each line of asm
lines = f_read.readlines() 
for line in lines:
	# empty line
	if(not len(line.strip())):
		continue
	# remove space & split by ';' (comment)
	str_list = line.strip().split(';')
	# print("len:%d"%len(str_list))
	# print(str_list[0])

	first_str = str_list[0]
	# data, TODO
	if(first_str[0] == '.'):
		# print(first_str)
		continue
	
	# get rs/rt/rd
	str_split_by_space = first_str.strip().split(' ')
	machine_code = ''
	# print("len of str_split_by_space %d"%len(str_split_by_space))
	# print(str_split_by_space)
	
	# add branch tag & pc;
	if str_split_by_space[0][-1] == ':':
		tag_list.append(str_split_by_space[0][0:-1])
		pc_list.append(inst_cnt)

	# parser rs/rt/rd/imm's value, include 3 spec registers, i.e., blockIdx, blockDim, threadIdx
	# note: BR has no rs/rt/rd/imm
	if str_split_by_space[0][0:2] != 'BR':
		if len(str_split_by_space)>1:
			if(str_split_by_space[1][0] == '%'):
				if(str_split_by_space[1][1:] == 'blockIdx'):
					r1_bin = bin(13)
				elif(str_split_by_space[1][1:] == 'blockDim'):
					r1_bin = bin(14)
				elif(str_split_by_space[1][1:] == 'threadIdx'):
					r1_bin = bin(15)
				else:
					print("meet error in parse r1")
					exit()
			else:
				r1_bin = bin(int(str_split_by_space[1][1:-1]))
			r1_bin = r1_bin[2:].rjust(4,'0')
		if len(str_split_by_space)>2:
			if(str_split_by_space[2][0] == '%'):
				if(str_split_by_space[2][1:] == 'blockIdx' or str_split_by_space[2][1:] == 'blockIdx,'):
					r2_bin = bin(13)
				elif(str_split_by_space[2][1:] == 'blockDim' or str_split_by_space[2][1:] == 'blockDim,'):
					r2_bin = bin(14)
				elif(str_split_by_space[2][1:] == 'threadIdx' or str_split_by_space[2][1:] == 'threadIdx,'):
					r2_bin = bin(15)
				else:
					print("meet error in parse r2")
					exit()
			elif str_split_by_space[2][0] == '#':
				imm = bin(int(str_split_by_space[2][1:]))[2:].rjust(8,'0')
			else:
				if len(str_split_by_space) == 3:
					r2_bin = bin(int(str_split_by_space[2][1:]))
				else:
					r2_bin = bin(int(str_split_by_space[2][1:-1]))
			r2_bin = r2_bin[2:].rjust(4,'0')
		if len(str_split_by_space)>3:
			if(str_split_by_space[3][0] == '%'):
				if(str_split_by_space[3][1:] == 'blockIdx' or str_split_by_space[3][1:] == 'blockIdx,'):
					r3_bin = bin(13)
				elif(str_split_by_space[3][1:] == 'blockDim' or str_split_by_space[3][1:] == 'blockDim,'):
					r3_bin = bin(14)
				elif(str_split_by_space[3][1:] == 'threadIdx' or str_split_by_space[3][1:] == 'threadIdx,'):
					r3_bin = bin(15)
				else:
					print("meet error in parse r3")
					exit()
			else:
				if len(str_split_by_space) == 4:
					r3_bin = bin(int(str_split_by_space[3][1:]))
				else:
					r3_bin = bin(int(str_split_by_space[3][1:-1]))
			r3_bin = r3_bin[2:].rjust(4,'0')

	# parse opcode
	if(str_split_by_space[0] == 'NOP'):
		machine_code += '0000000000000000'
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'BRn'):
		machine_code += '00011000'
		for tag in tag_list:
			if tag == str_split_by_space[1]:
				pc = bin(pc_list[tag_list.index(tag)])[2:].rjust(8,'0')
		machine_code += pc
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'CMP'):
		machine_code += '00100000'
		machine_code += r1_bin + r2_bin
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'ADD'):
		machine_code += '0011'
		machine_code += r1_bin + r2_bin + r3_bin
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'SUB'):
		machine_code += '0100'
		machine_code += r1_bin + r2_bin + r3_bin
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'MUL'):
		machine_code += '0101'
		machine_code += r1_bin + r2_bin + r3_bin
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'DIV'):
		machine_code += '0110'
		machine_code += r1_bin + r2_bin + r3_bin
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'LDR'):
		machine_code += '0111'
		machine_code += r1_bin + r2_bin + '0000'
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'STR'):
		machine_code += '1000'
		machine_code += '0000' + r1_bin + r2_bin
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'CONST'):
		machine_code += '1001'
		machine_code += r1_bin + imm
		f_write.write(machine_code+'\n')
		inst_cnt += 1
	elif(str_split_by_space[0] == 'RET'):
		machine_code += '1111000000000000'
		f_write.write(machine_code+'\n')
		inst_cnt += 1