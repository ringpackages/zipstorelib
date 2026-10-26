/*
	ZipStoreLib Demo 18 - Modify an archive (read and rewrite)
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 18: Modify an archive (read and rewrite)
# -------------------------------------------------------
? "Demo 18: Modify an archive..."

quickZipData("demo18_original.zip", [
	["config.txt", "mode=test"],
	["data.txt", "Some data"]
])

oReader = new ZipReader
oReader.open("demo18_original.zip")

oWriter = new ZipWriter
nCount = oReader.count()
for nEntry = 1 to nCount
	cZipPath = oReader.entryAt(nEntry)[:zipPath]
	cContent = oReader.contentAt(nEntry)
	if cZipPath = "config.txt"
		cContent = "updated=true" + nl + cContent
	ok
	oWriter.addData(cZipPath, cContent)
next
oWriter.addData("changelog.txt", "v1.1 - Updated config")
oWriter.save("demo18_modified.zip")
oReader.close()

oReader.open("demo18_modified.zip")
? "  Files: " + oReader.count()
? "  config.txt:"
? oReader.content("config.txt")
oReader.close()
? ""
