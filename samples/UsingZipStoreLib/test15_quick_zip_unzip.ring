/*
	ZipStoreLib Demo 15 - Quick ZIP and unzip of files
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 15: Quick ZIP and unzip of files
# -------------------------------------------------------
? "Demo 15: quickZip() and quickUnzip()..."

write("demo15_a.txt", "File A")
write("demo15_b.txt", "File B")

# A file name keeps its name, a [zipPath, localPath] pair renames the file
if quickZip("demo15_quick.zip", ["demo15_a.txt", ["renamed/b.txt", "demo15_b.txt"]])
	? "  Created: demo15_quick.zip"
ok

if quickUnzip("demo15_quick.zip", "extracted_demo15")
	? "  Extracted to 'extracted_demo15/'"
	? "  demo15_a.txt  : " + read("extracted_demo15/demo15_a.txt")
	? "  renamed/b.txt : " + read("extracted_demo15/renamed/b.txt")
ok
? ""
