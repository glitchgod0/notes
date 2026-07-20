#pragma author glitchgod
#pragma description Harmonix ARK V2 (Amplitude Final)
#pragma endian little

import type.magic;
import type.size;
import type.time;

import std.io;
import std.mem;

struct FileEntry {
    u32 offset;
    u32 fileNameIndex;
    u32 folderNameIndex;
    u32 size;
    u32 inflatedSize;
};


struct ArkV2File {
   u32 Version;
   u32 entryCount;
   FileEntry file_entries[entryCount][[name("File Entries")]];
   u32 stringTableSize;
   char StringTable[stringTableSize];
   u32 stringIndexCount;
   u32 stringIndexEntries[stringIndexCount];
   
   
   std::print("-" * 50);
   std::print("Stats:");
   std::print("{} Files entries.", entryCount);
   std::print("-" * 50);
};




ArkV2File Ark @ 0x00;