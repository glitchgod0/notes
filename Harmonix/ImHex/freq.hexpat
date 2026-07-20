#pragma author glitchgod
#pragma description Harmonix ARK (Frequency)
#pragma endian little
#pragma magic [ 41 52 4B 00 ] @ 0

// imhex remake of PikminGuts92's 010 Pattern
// https://github.com/PikminGuts92/re-notes/tree/master/templates/freq_ark.bt

import type.magic;
import type.size;
import type.time;

import std.io;
import std.mem;

struct Header {
    type::Magic<"ARK"> magic;
    padding[1];
    u32 version;
    u32 file_entry_offset;
    u32 file_entry_count;
    u32 folder_entry_offset;
    u32 folder_entry_count;
    u32 string_table_offset;
    u32 string_count;
    u32 total_hdr_size;
    u32 block_size;
    
};

struct FileEntry{
    u32 hash;
    u32 file_name_offset;
    u16 folder_name_index;
    u16 block_offset;
    u32 block;
    u32 file_size;
    u32 inflated_size;
    
    u32 file_offset = (block * parent.Header.block_size) + block_offset; // not to be confused with file_name_offset
    char file_name[] @ file_name_offset [[hidden]];
   
    u32 folder_name_offset @ (parent.Header.folder_entry_offset + (folder_name_index * 8)) + 4 [[hidden]]; 
    char folder_name[] @ folder_name_offset [[hidden]];
  
    // for some reason the strings dont work in get_file_name with some trickery
    str fileworkaround = file_name;
    str folderworkaround = folder_name;
    
    std::mem::Bytes<file_size> @ file_offset [[name("File")]];
    std::print("{}/{} ({})", folder_name, file_name, hash);

}[[format("get_file_name")]];

fn get_file_name(FileEntry entry) {
    std::print(entry.file_name);
    return std::format("{}/{} ({})", entry.folderworkaround, entry.fileworkaround, entry.hash);
};

struct FolderEntry {
    u32 unknown;
    u32 folder_name_index;
};

struct FreqArkFile {
    Header Header;
    FileEntry file_entries[Header.file_entry_count] @ Header.file_entry_offset [[name("File Entries")]];
    FolderEntry folder_entries[Header.folder_entry_count] @ Header.folder_entry_offset [[name("Folder Entries")]];

    char string_table[Header.total_hdr_size - $] @ Header.string_table_offset [[name("String Table")]];
    
   std::print("-" * 50);
   std::print("Stats:");
   std::print("{} Files, {} Folders.", Header.file_entry_count, Header.folder_entry_count);
   std::print("-" * 50);
};

FreqArkFile Ark @ 0x00;