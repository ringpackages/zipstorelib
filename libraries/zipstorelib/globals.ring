ZIP_METHOD_STORED  = 0
ZIP_METHOD_DEFLATE = 8

ZIP_SIG_LOCAL   = char(0x50) + char(0x4B) + char(0x03) + char(0x04)
ZIP_SIG_CENTRAL = char(0x50) + char(0x4B) + char(0x01) + char(0x02)
ZIP_SIG_END     = char(0x50) + char(0x4B) + char(0x05) + char(0x06)

# CRC32 lookup table (filled on first use)
aZipCRC32Table = []
