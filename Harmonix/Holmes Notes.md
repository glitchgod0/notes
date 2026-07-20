# Intro
This is my notes on how v26 holmes works and the steps to use it.
None of this would be possible without
* Emma's work on [We-r-of-milo](github.com/InvoxiPlayGames/we-r-of-milo)
* All of the contributors of the [DC3 Decomp](https://github.com/rjkiv/dc3-decomp) 

yall are the best.


# Executable patch
* ```xextool -e u ham_xbox_r.xex```
* Open the file in a hex editor
* goto address 0x0059DB8C
* change 280A0000 to 280A0001 and save
* ```xextool -e e ham_xbox_r.xex```

Didnt work but probably worth noting:
* ``gHostCached = OptionBool("host_cached", false);``, 0x005C6E24
* sCacheMode, 0x00F5F8D9

# Launch Arguments

* ``-holmes_host <IP>`` 
* ``-xb_host <IP>`` 
* ``-holmes_target <name>`` 
* ``-holmes_share <sharename>``
* ``-xb_share <sharename>``
TODO



# Opcodes

## kVersion (0x00)
Packet example:
```001a0000000a000000476c697463682d58444b0400000074657374050000007368617265100000002e2e2f2e2e2f73797374656d2f72756e0200```

* 00: Opcode
* 1A000000: Holmes version (26)
* 0A000000: Length of PlatformHostName string
* 476C697463682D58444B: PlatformHostName "Glitch-XDK" 
* 04000000: Length of gHolmesTarget name string
* 74657374: TargetName: "test"
* 05000000: Length of share string
* 7368617265: Share name: "share"
* 10000000:  Length of FileSystemRoot string 
* 2E2E2F2E2E2F73797374656D2F72756E: FileSystemRoot "../../system/run"
* 02 = Platform (kPlatformXBox)
* 00 = GfxMode



Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/abea65e3ce8732abe5290f3b81a6e621e4497e15/src/system/os/HolmesClient.cpp#L317

## kSysExec (0x01)
Packet example: ```0146000000636d64202f63207374617274202e2e2f2e2e2f73797374656d2f72756e2f6d696c6f5f722e6578652075692f6261636b67726f756e642f6261636b67726f756e642e6d696c6f```

Breakdown:
* 01: Opcode
* 46000000: Length of string 
* 636D64202F63207374617274202E2E2F2E2E2F73797374656D2F72756E2F6D696C6F5F722E6578652075692F6261636B67726F756E642F6261636B67726F756E642E6D696C6F: Command "cmd /c start ../../system/run/milo_r.exe ui/background/background.milo"


Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L434

## kGetStat (0x02)
Packet example: ```020c00000078626f785f73686164657273```

Breakdown:
* 02: Opcode
* 0C000000: Length of string 
* 78626F785F73686164657273: File "xbox_shaders"

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L448

## kOpenFile (0x03)
Packet example:
```03270000002e2e5c2e2e5c73797374656d5c72756e5c676573747572655c6465765f64657074682e646174610100```

Breakdown:
* 03: Opcode
* 27000000: Length of string 
* 2E2E5C2E2E5C73797374656D5C72756E5C676573747572655C6465765F64657074682E64617461: File "..\\..\system\run\gesture\dev_depth.data"
* 01: Flag 1
* 00: TODO


Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L537

## kWriteFile (0x04)
Packet example:
Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L580

## kReadFile (0x05)
Packet example: ```052d0400000000000000000200```

Breakdown:
* 05: Opcode
* TODO

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L599

## kCloseFile (0x06)
Packet example: ```06c6010000```

Breakdown:
* 06: Opcode
* C6010000: File handler

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L627

## kPrint (0x07)


## kMkDir (0x08)
Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L469

## kDelete (0x09)
Packet sample:
``09130000005f68697265735f63616368655f30302e646174``

Breakdown
* 09: Opcode
* 13000000: Length of string
* 5F68697265735F63616368655F30302E646174: "_hires_cache_00.dat"

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L484


## kEnumerate (0x0A)
Packet example: ```0a05000000736f6e67730010000000736f6e67732f736f6e67732a2e64746100```

Breakdown:
* 0A: Opcode
* 05000000: Length of string
* 736F6E6773: Directory "songs"
* 00: Resursive bool
* 10000000: Length of the 2nd string
* 736F6E67732F736F6E67732A2E647461: "songs/songs*.dta"
* 00: Mystery bool

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L689

## kCacheFile (0x0b)
Packet example:
```0b1b000000636f6e6669672f68616d5f707265696e69745f6b6565702e64746100```

Breakdown:
* 0B: Opcode
* 1B000000: Length of string
* 636F6E6669672F68616D5F707265696E69745F6B6565702E647461: Directory "config/ham_preinit_keep.dta"
* 00: Mystery bool

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/abea65e3ce8732abe5290f3b81a6e621e4497e15/src/system/os/HolmesClient.cpp#657

## kCompareFileTimes (0x0C)




## kTerminate (0x0D)
Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L771

## kCacheResource (0x0E)
Packet example: ```0e1900000075695c696d6167655c64635f6c6f676f5f6b6565702e706e67```

Breakdown: 
* 0E: Opcode
* 19000000: Length of string
* 75695C696D6167655C64635F6C6F676F5F6B6565702E706E67: "ui\image\dc_logo_keep.png"

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L639

## kPollKeyboard (0x0F)
Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L166

## kPollJoypad (0x10)
Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L174

## kStackTrace (0x11)
```110e00000068616d5f78626f785f722e6d61701200000050e35c82d0ee5b82fc0b5c82c80f5c82e4095c82c80f5c82c0105c82381c5c82a0a15c8268b35c821cbf5c82d0bf5c82f8065e82043833828c423382706033826c0a0a80ccb70980```

Breakdown:
* 11: Opcode
* 0E000000: Length of map file name
* 68616D5F78626F785F722E6D6170: "ham_xbox_r.map"
* 12000000: Number of stack entries
* 50E35C82: "825CE350" Stack offset in little-endian
* D0EE5B82: "825BEED0" Stack offset in little-endian
* FC0B5C82: "825C0BFC" Stack offset in little-endian
* C80F5C82: "825C0FC8" Stack offset in little-endian
* E4095C82: "825C09E4" Stack offset in little-endian
* C80F5C82: "825C0FC8" Stack offset in little-endian
* C0105C82: "825C10C0" Stack offset in little-endian
* 381C5C82: "825C1C38" Stack offset in little-endian
* A0A15C82: "825CA1A0" Stack offset in little-endian
* 68B35C82: "825CB368" Stack offset in little-endian
* 1CBF5C82: "825CBF1C" Stack offset in little-endian
* D0BF5C82: "825CBFD0" Stack offset in little-endian
* F8065E82: "825E06F8" Stack offset in little-endian
* 04383382: "82333804" Stack offset in little-endian
* 8C423382: "8233428C" Stack offset in little-endian
* 70603382: "82336070" Stack offset in little-endian
* 6C0A0A80: "800A0A6C" Stack offset in little-endian
* CCB70980: "8009B7CC" Stack offset in little-endian

Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L718


## kSendMessage (0x12)
Packet sample:
``121000000003000000000000000000000000000500000013000000726e645f636f6e736f6c655f73686f77696e670000000001000000``

Breakdown:
* 12: Opcode
* TODO



Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L739

## kTruncateFile (0x13)
Relevant code:
https://github.com/rjkiv/dc3-decomp/blob/e80847ccbb965e4eca9aadfd1361bff05caac616/src/system/os/HolmesClient.cpp#L521

## kInvalidOpcode (0x14)




# Issues

## Milo files
By default, it expects the original development .Milo files before platform specific conversion. Without executable patches or Milo file editing, it prints the error: ```String chars 100663297 > 512```  from [Binstream.cpp](https://github.com/rjkiv/dc3-decomp/blob/abea65e3ce8732abe5290f3b81a6e621e4497e15/src/system/utl/BinStream.cpp#L182).

## Songs
On-disc songs fail to get added to the songs array, DLC works however.
When loading DLC the game sends kEnumerate commands to Holmes for "songs" and whatever entries are in (song_mgr (alt_dirs))

## World Objects
Running the regular world_objects.dta gives an ``Array closed incorrectly`` error. This can be fixed by editing the CAMSHOT_CATEGORYs definition from ``#define CAMSHOT_CATEGORIES ((#include camera_cats.dta))`` to 
```
#define CAMSHOT_CATEGORIES
(
   (
      #include camera_cats.dta
   )
)
```

# Misc
* Holmes sends commands through the regular network IP and not XBDM IP.
* Ark files seem to take priority over holmes host, renaming the gen folder makes the game load files from the server.
* XBDM magicboot command example: ``` magicboot title="HDD:\DEVKIT\DC3\eecu_ham.xex" directory="HDD:\DEVKIT\DC3\" cmdline="-holmes_host 192.168.1.100""```. You can connect to XBDM through telnet on port 730.
* DTA needs to be in arson/raw DTA formatting, dtab output will not work.
* we-r-of-milo corrects file paths that use `../`, it does not correct `./` by default. Without moving shaders to root, it tries to use .fx_xbox files instead.


### Holmes Guide
* Connect console to PC through ethernet
* Follow executable patch guide from earlier
* Rename the gen folder in the game to something else
* Open we-r-of-milo
* Load the edited dc3 xex over XBDM telnet, following the command above

(please can someone check if this works on an RGH with the hvp plugin)