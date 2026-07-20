#pragma author glitchgod (Unfinished)
#pragma description Xbox 360 Executable Format (.xex)
#pragma endian big
#pragma magic [ 58 45 58 32 ] @ 0

import type.magic;
import type.size;
import type.time;

import std.io;
import std.mem;


bitfield ModuleFlags {
    TitleModule         : 1;
    ExportsToTitle      : 1;
    SystemDebugger      : 1;
    DLLModule           : 1;
    ModulePatch         : 1;
    PatchFull           : 1;
    PatchDelta          : 1;
    UserMode            : 1;
};

enum OptionalHeaderID : u32 {
    ResourceInfo                    = 0x000002FF,
    BaseFileFormat                  = 0x000003FF,
    BaseReference                   = 0x00000405,
    DeltaPatchDescriptor            = 0x000005FF,
    BoundingPath                    = 0x000080FF,
    DeviceID                        = 0x00008105,
    OriginalBaseAddress             = 0x00001001,
    EntryPoint                      = 0x00010100,
    ImageBaseAddress                = 0x00010201,
    ImportLibraries                 = 0x000103FF,
    ChecksumTimestamp               = 0x00018002,
    EnabledForCallcap               = 0x00018102,
    EnabledForFastcap               = 0x00018200,                           
    OriginalPEName                  = 0x000183FF,
    StaticLibraries                 = 0x000200FF,
    TLSInfo                         = 0x00020104,
    DefaultStackSize                = 0x00020200,
    DefaultFilesystemCacheSize      = 0x00020301,
    DefaultHeapSize                 = 0x00020401,
    PageHeapSizeAndFlags            = 0x00028002,
    SystemFlags                     = 0x00030000,
    ExecutionID                     = 0x00040006,
    ServiceIDList                   = 0x000401FF,
    TitleWorkspaceSize              = 0x00040201,
    GameRatings                     = 0x00040310,
    LANKey                          = 0x00040404,
    Xbox360Logo                     = 0x000405FF,
    MultidiscMediaIDs               = 0x000406FF,
    AlternateTitleIDs               = 0x000407FF,
    AdditionalTitleMemory           = 0x00040801,
    ExportsByName                   = 0x00E10402,
};


//this needs proper value processing.
//
//Free60: To handle the data you would first check to see what its size is, to do this you need to AND the Header ID by 0xFF.
//If ID & 0xFF == 0x01 then the Header Data field is used to store the headers data, otherwise it's used to store the data's offset. if ID
//& 0xFF == 0xFF then the Header's data will contain its size if ID & 0xFF == (Anything else) the value of this is the size of the entry in 
//number of DWORDS (times by 4 to get real size)
struct OptionalHeaderEntry {
    OptionalHeaderID id;
    u32 value;    
};


struct XEX2 {
    type::Magic<"XEX2"> magic;
    padding[3];
    le ModuleFlags ModuleFlags;
    u32 *PE_Offset : u32;
    u32 ReservedData;
    u32 *SecurityOffset : u32;
    u32 OptionalHeaderCount;
    OptionalHeaderEntry OptionalHeaders[OptionalHeaderCount];
};

XEX2 xex2 @ 0x00;