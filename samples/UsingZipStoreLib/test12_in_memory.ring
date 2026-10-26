/*
	ZipStoreLib Demo 12 - Build and read a ZIP in memory
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 12: Build and read a ZIP in memory
# -------------------------------------------------------
? "Demo 12: Build ZIP in memory..."

oZip = new ZipWriter
oZip.addData("memory.txt", "This ZIP was built entirely in memory!")
cZipData = oZip.build()
? "  ZIP data size: " + len(cZipData) + " bytes"

oReader = new ZipReader
if oReader.openData(cZipData)
	? "  Extracted from memory: " + oReader.content("memory.txt")
	oReader.close()
ok
? ""
