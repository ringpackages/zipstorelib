/*
	ZipStoreLib Demo 16 - ZIP a folder
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 16: ZIP a folder
# -------------------------------------------------------
? "Demo 16: Zipping a folder..."

# Create a folder with files to archive
quickZipData("demo16_source.zip", [
	["readme.txt", "Project readme"],
	["src/app.ring", '? "App"'],
	["src/lib/util.ring", "func util"]
])
quickUnzip("demo16_source.zip", "demo16_folder")

# The whole folder
if quickZipFolder("demo16_folder.zip", "demo16_folder")
	? "  Created: demo16_folder.zip"
ok

# The folder under a prefix, plus an empty folder entry
oZip = new ZipWriter
oZip.addFolder("demo16_folder", "backup/project")
oZip.addEmptyFolder("backup/logs")
oZip.save("demo16_prefix.zip")

oReader = new ZipReader
if oReader.open("demo16_prefix.zip")
	for cFile in oReader.fileList()
		? "    " + cFile
	next
	oReader.close()
ok
? ""
