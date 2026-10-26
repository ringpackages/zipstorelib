/*
	ZipStoreLib Demo 7 - CRC32 checksum
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 7: CRC32 checksum
# -------------------------------------------------------
? "Demo 7: CRC32 checksum..."

cData = "The quick brown fox jumps over the lazy dog"
? "  Data     : " + cData
? "  CRC32    : " + zipHex8(zipCRC32(cData))
? "  Expected : 414FA339"
? ""
