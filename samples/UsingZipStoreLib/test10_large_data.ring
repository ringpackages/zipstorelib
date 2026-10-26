/*
	ZipStoreLib Demo 10 - Large data handling
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 10: Large data handling
# -------------------------------------------------------
? "Demo 10: Large data handling..."

cLargeData = ""
for nLine = 1 to 1000
	cLargeData += "Line " + nLine + ": This is a test line with some content." + nl
next

oZip = new ZipWriter
oZip.addData("large_file.txt", cLargeData)
oZip.addData("small_file.txt", "Small!")

if oZip.save("demo10_large.zip")
	? "  Created ZIP with " + len(cLargeData) + " bytes of data"
	oReader = new ZipReader
	if oReader.open("demo10_large.zip")
		if oReader.content("large_file.txt") = cLargeData
			? "  Data integrity verified (extracted matches original)"
		else
			? "  WARNING: Data mismatch!"
		ok
		oReader.close()
	ok
ok
? ""
