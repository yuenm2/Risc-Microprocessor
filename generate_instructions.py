import numpy as np

address_width = 5
data_width = 16

data_max = (2**data_width -1)/(2**address_width)

def random_binary():
	rbin = np.binary_repr(np.random.randint(0,data_max)).zfill(data_width)
	return rbin

def no_op():
	return np.binary_repr(48896).zfill(data_width)

def move_const(rd, im8):
	cmd = np.binary_repr(4).zfill(5)
	const = np.binary_repr(im8).zfill(8)
	r = np.binary_repr(rd).zfill(3)
	return (cmd + const + r)

def move(rd, rm):
	cmd = np.binary_repr(140).zfill(9)
	r_m = np.binary_repr(rm).zfill(4)
	r_d = np.binary_repr(rd).zfill(3)
	return (cmd + r_m + r_d)

def add(rm, rn, rd, rm_const):
	cmd = np.binary_repr(3).zfill(5)
	if (rm_const):
		cmd = cmd + np.binary_repr(2).zfill(2)
	else:
		cmd = cmd + np.binary_repr(0).zfill(2)
	r_n = np.binary_repr(rn).zfill(3)
	r_m = np.binary_repr(rm).zfill(3)
	r_d = np.binary_repr(rd).zfill(3)
	return (cmd + r_m + r_n + r_d)

def add_sp(im7):
	cmd = np.binary_repr(352).zfill(9)
	r = np.binary_repr(im7).zfill(7)
	return (cmd + r)

def sub(rm, rn, rd, rm_const):
	cmd = np.binary_repr(3).zfill(5)
	if (rm_const):
		cmd = cmd + np.binary_repr(3).zfill(2)
	else:
		cmd = cmd + np.binary_repr(1).zfill(2)
	r_n = np.binary_repr(rn).zfill(3)
	r_m = np.binary_repr(rm).zfill(3)
	r_d = np.binary_repr(rd).zfill(3)
	return (cmd + r_m + r_n + r_d)

def sub_sp(im7):
	cmd = np.binary_repr(353).zfill(9)
	r = np.binary_repr(im7).zfill(7)
	return (cmd + r)

def logic(rm, rd, l):
	cmd = np.binary_repr(16).zfill(6)
	if (l == 'CMP'):
		cmd = cmd + np.binary_repr(10).zfill(4)
	elif (l == 'ANDS'):
		cmd = cmd + np.binary_repr(0).zfill(4)
	elif (l == 'EORS'):
		cmd = cmd + np.binary_repr(1).zfill(4)
	elif (l == 'ORRS'):
		cmd = cmd + np.binary_repr(12).zfill(4)
	elif (l == 'MVNS'):
		cmd = cmd + np.binary_repr(15).zfill(4)
	elif (l == 'LSLS'):
		cmd = cmd + np.binary_repr(2).zfill(4)
	elif (l == 'LSRS'):
		cmd = cmd + np.binary_repr(3).zfill(4)
	elif (l == 'ASRS'):
		cmd = cmd + np.binary_repr(4).zfill(4)
	elif (l == 'RORS'):
		cmd = cmd + np.binary_repr(7).zfill(4)
	else: # and by default
		cmd = cmd + np.binary_repr(0).zfill(4)
	r_d = np.binary_repr(rd).zfill(3)
	r_m = np.binary_repr(rm).zfill(3)
	return (cmd + r_m + r_d)

def load_store(im5, rn, rd, l):
	if (l == 'LOAD'):
		cmd = np.binary_repr(12).zfill(5)
	else: # STORE by default
		cmd = np.binary_repr(13).zfill(5)

	const = np.binary_repr(im5).zfill(5)
	r_n = np.binary_repr(rn).zfill(3)
	r_d = np.binary_repr(rd).zfill(3)
	return (cmd + const + r_n + r_d)

def cond_branch(cond, im8):
	const = np.binary_repr(im8).zfill(8)
	cond = np.binary_repr(cond).zfill(4)
	cmd = np.binary_repr(13).zfill(4)
	return (cmd + cond + const)

def branch_const11(im11):
	const = np.binary_repr(im11).zfill(11)
	cmd = np.binary_repr(28).zfill(5)
	return (cmd + const)

def branch_const6(im6):
	const = np.binary_repr(im6).zfill(6)
	cmd = np.binary_repr(276).zfill(10)
	return (cmd + const)

def branch(rm):
	const = np.binary_repr(0).zfill(3)
	r_m = np.binary_repr(rm).zfill(4)
	cmd = np.binary_repr(142).zfill(9)
	return (cmd + r_m + const)

inst = []

# add instructions here to test
inst.append(move_const(1, 9))
inst.append(move(1, 9))
inst.append(add(1,7,7, True))
inst.append(add(1,7,7, False))
inst.append(no_op())
inst.append(add_sp(120))
inst.append(sub(1,7,7, True))
inst.append(sub(1,7,7, False))
inst.append(sub_sp(120))
inst.append(logic(1, 1, 'CMP'))
inst.append(logic(1, 1, 'ANDS'))
inst.append(logic(1, 1, 'EORS'))
inst.append(logic(1, 1, 'ORRS'))
inst.append(logic(1, 1, 'MVNS'))
inst.append(logic(1, 1, 'LSLS'))
inst.append(logic(1, 1, 'LSRS'))
inst.append(logic(1, 1, 'ASRS'))
inst.append(logic(1, 1, 'RORS'))
inst.append(load_store(1, 1, 1, 'LOAD'))
inst.append(load_store(1, 1, 1, 'STORE'))
inst.append(cond_branch(0, 1))
inst.append(branch_const11(11))
inst.append(branch_const6(6))
inst.append(branch(4))

print('Total instructions: ', len(inst))

for i in range(2**address_width-len(inst)):
	inst.append(no_op())

f = open("instructions.txt", "w+")

for i in range(2**address_width):
	rand_bin_str = inst[i]
	f.write(rand_bin_str + '\n')

f.close()
