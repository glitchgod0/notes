#pragma author glitchgod
#pragma description Harmonix ARK V1 (Amplitude Beta)
#pragma endian little

// Based on PikminGuts92's 010 Pattern
// https://github.com/PikminGuts92/re-notes/blob/master/templates/amp_ark.bt

import type.magic;
import type.size;
import type.time;

import std.io;
import std.mem;

struct FileEntry {
    u32 fileNameIndex;
    u32 folderNameIndex;
    u32 offset;
    u32 size;
    u32 inflatedSize;
    
    std::mem::Bytes<size> @ offset [[name("File")]];
    std::print("{}/{} ({})", folderNameIndex, fileNameIndex, size);
};

struct NumString {
    u32 count;
    
    if (count > 0)
    {
        char text[count];
    }
};


struct ArkV1File {
   u32 Version;
   u32 entryCount;
   FileEntry file_entries[entryCount][[name("File Entries")]];
   u32 stringTableSize;
   
   NumString stringTable[stringTableSize];
   

   
   std::print("-" * 50);
   std::print("Stats:");
   std::print("{} Files entries.", entryCount);
   std::print("-" * 50);
};




ArkV1File Ark @ 0x00;