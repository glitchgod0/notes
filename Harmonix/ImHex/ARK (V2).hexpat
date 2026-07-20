#pragma author glitchgod
#pragma description Harmonix ARK (Frequency)
#pragma endian little


struct FileEntry {
    u32 offset;
    u32 fileNameIndex;
    u32 folderNameIndex;
    u32 size;
    u32 inflatedSize;
};


struct ArkV2File {
   u32 Version;
   
   std::print("-" * 50);
   std::print("Stats:");
   std::print("-" * 50);
};




ArkV2File Ark @ 0x00;