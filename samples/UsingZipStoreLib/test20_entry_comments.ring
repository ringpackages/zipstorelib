/*
	ZipStoreLib Demo 20 - Per-entry comments
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 20: Per-entry comments
# -------------------------------------------------------
? "Demo 20: Per-entry comments..."

write("demo20_report.txt", "Monthly report")

oZip = new ZipWriter
oZip.addDataWithComment("notes.txt", "Some notes", "Written from memory")
oZip.addFileWithComment("report.txt", "demo20_report.txt", "Copied from disk")
oZip.save("demo20_comments.zip")

oReader = new ZipReader
if oReader.open("demo20_comments.zip")
	for cFile in oReader.fileList()
		? "  " + cFile + " : " + oReader.entry(cFile)[:comment]
	next
	oReader.close()
ok
? ""
