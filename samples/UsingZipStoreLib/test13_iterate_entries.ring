/*
	ZipStoreLib Demo 13 - Iterate entries with details
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 13: Iterate entries with details
# -------------------------------------------------------
? "Demo 13: Iterating entries with details..."

quickZipData("demo13_entries.zip", [
	["src/main.ring", '? "Hello from Ring!"'],
	["docs/README.md", "# My Ring Project"],
	["config.ini", "[app]"]
])

oReader = new ZipReader
if oReader.open("demo13_entries.zip")
	nCount = oReader.count()
	for nEntry = 1 to nCount
		aEntry = oReader.entryAt(nEntry)
		? "  [" + nEntry + "] " + aEntry[:zipPath]
		? "      Size  : " + aEntry[:size] + " bytes"
		? "      CRC32 : " + zipHex8(aEntry[:crc32])
		? "      Date  : " + aEntry[:dateTime]
		if aEntry[:method] = ZIP_METHOD_STORED
			? "      Method: Stored"
		but aEntry[:method] = ZIP_METHOD_DEFLATE
			? "      Method: Deflate"
		ok
	next
	oReader.close()
ok
? ""
