import sys
import os

verbose = 0

#### Helper functions
def helper_get_data(offset, length):
	with open(sys.argv[1], 'rb') as f:
		f.seek(offset)
		return f.read(length)

def helper_get_string(offset):
	with open(sys.argv[1], 'rb') as f:
		f.seek(offset)
		data = bytearray()

		# this sucks, we set the max to 50 as a fail-safe incase we get a bad offset
		for x in range(50):
			value = f.read(1)
			data += value
			if value == b'\x00':
				break

		return data[:-1].decode('utf-8')
	

def helper_write_data(folder_name, file_name, file_offset, file_size):
	with open(sys.argv[1], 'rb') as f:
		f.seek(file_offset)
		data = f.read(file_size)
		f.close()

	ark_name = sys.argv[1][:-4]
	processed_name = ark_name + "/" + folder_name + "/" + file_name
	print(processed_name)
	
	os.makedirs(os.path.dirname(processed_name), exist_ok=True)
	with open(processed_name, "wb") as f:
		print(processed_name)
		f.write(data)

	return

def helper_u32(data):
	out = int.from_bytes(data, byteorder='little', signed=False)
	return out

def helper_u16(data):
	out = int.from_bytes(data, byteorder='little', signed=False)
	return out

## core
def check_ark():
	## TODO CHECK IF FILE IS VALID
	with open(sys.argv[1], 'rb') as f:
		if f.read(4).decode() == "ARK\x00":
			print("ARK (v0) detected") 
			
		else:
			print("Only freq arks are supported")
			sys.exit()

def process_header():
	global version
	version = 				helper_u32(helper_get_data(0x04, 0x4))
	global file_entry_offset
	file_entry_offset =		helper_u32(helper_get_data(0x08, 0x4))
	global file_entry_count
	file_entry_count = 		helper_u32(helper_get_data(0x0C, 0x4))
	global folder_entry_offset
	folder_entry_offset = 	helper_u32(helper_get_data(0x10, 0x4))
	global folder_entry_count
	folder_entry_count = 	helper_u32(helper_get_data(0x14, 0x4))
	global string_table_offset
	string_table_offset = 	helper_u32(helper_get_data(0x18, 0x4))
	global string_count
	string_count = 			helper_u32(helper_get_data(0x1C, 0x4))
	global total_hdr_size
	total_hdr_size = 		helper_u32(helper_get_data(0x20, 0x4))
	global block_size
	block_size = 			helper_u32(helper_get_data(0x24, 0x4))

	if verbose == 1:
		print("version:", version)
		print("file_entry_offset:", file_entry_offset)
		print("file_entry_count:", file_entry_count)
		print("folder_entry_offset:", folder_entry_offset)
		print("folder_entry_count:", folder_entry_count)
		print("string_table_offset:", string_table_offset)
		print("string_count:", string_count)
		print("total_hdr_size:", total_hdr_size)
		print("block_size:", block_size)




def process_file_entry(entrynumber):
	seekvar = file_entry_offset

	# the helper func only does fixed offsets...
	hash = 				helper_u32(helper_get_data(seekvar + 0x18 * entrynumber, 0x04))
	seekvar = seekvar + 0x4
	file_name_offset = 	helper_u32(helper_get_data(seekvar + 0x18 * entrynumber, 0x04))
	seekvar = seekvar + 0x4
	folder_name_index = helper_u16(helper_get_data(seekvar + 0x18 * entrynumber, 0x02))
	seekvar = seekvar + 0x2
	block_offset = 		helper_u16(helper_get_data(seekvar + 0x18 * entrynumber, 0x02))
	seekvar = seekvar + 0x2
	block = 			helper_u32(helper_get_data(seekvar + 0x18 * entrynumber, 0x04))
	seekvar = seekvar + 0x4
	file_size = 		helper_u32(helper_get_data(seekvar + 0x18 * entrynumber, 0x04))
	seekvar = seekvar + 0x4
	inflated_size =		helper_u32(helper_get_data(seekvar + 0x18 * entrynumber, 0x04))
	seekvar = seekvar + 0x4

	if verbose == 1:
		print("hash:", hash)
		print("filenameoffset:", file_name_offset)
		print("foldernameindex:", folder_name_index)
		print("blockoffset:", block_offset)
		print("block:", block)
		print("filesize:", file_size)
		print("inflated:", inflated_size)
		print("###########################")

	file_offset = (block * block_size) + block_offset
	file_name = helper_get_string(file_name_offset)


	# dont want to process the folder block on its own so we:
	folder_index_offset = (folder_entry_offset + (folder_name_index * 8)) + 4 # 1. skip into the end of the folder entry
	folder_index_offset = helper_u32(helper_get_data(folder_index_offset, 0x04)) # 2. process the number in the folder_name_index field
	folder_name = helper_get_string(folder_index_offset) # 3. use that value to get the string

	if verbose == 1:
		print("file:", file_name, "|", file_offset)
		print("folder:", folder_name, "|", folder_index_offset)
		print("====#######################")

	# finally write
	helper_write_data(folder_name, file_name, file_offset, file_size)



def ark_flow():
	check_ark()
	process_header()
	print("====#####################################====")
	for x in range(file_entry_count):
  		process_file_entry(x)
	



if __name__ == "__main__":
	if len(sys.argv) <= 1:
		print("No ARK file provided.")
	else:
		ark_flow()
