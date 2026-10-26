/*
	ZipStoreLib Demo 11 - ZIP from files on disk
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 11: ZIP from files on disk
# -------------------------------------------------------
? "Demo 11: ZIP from files on disk..."

write("sample_file1.txt", "This is sample file 1")
write("sample_file2.txt", "This is sample file 2")
write("sample_data.csv", "Name,Age,City" + nl + "Alice,30,NYC" + nl + "Bob,25,LA" + nl)

oZip = new ZipWriter
oZip.addFile("documents/file1.txt", "sample_file1.txt")
oZip.addFile("documents/file2.txt", "sample_file2.txt")
oZip.addFile("data/records.csv", "sample_data.csv")

if oZip.save("demo11_files.zip")
	? "  Created: demo11_files.zip"
	oReader = new ZipReader
	if oReader.open("demo11_files.zip")
		for cFile in oReader.fileList()
			? "    " + cFile + " (" + oReader.entry(cFile)[:size] + " bytes)"
		next
		oReader.close()
	ok
ok
? ""
