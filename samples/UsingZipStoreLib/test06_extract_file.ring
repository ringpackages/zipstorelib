/*
	ZipStoreLib Demo 6 - Extract a single file
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 6: Extract a single file
# -------------------------------------------------------
? "Demo 6: Extracting single file..."

# Create the ZIP file to extract from
quickZipData("demo6_project.zip", [
	["project/config.ini", "[app]" + nl + "name=MyProject" + nl + "version=1.0.0"],
	["project/readme.txt", "Read me"]
])

oReader = new ZipReader
if oReader.open("demo6_project.zip")
	if oReader.extractFile("project/config.ini", "extracted_config.ini")
		? "  Extracted config.ini"
		? read("extracted_config.ini")
	ok
	oReader.close()
ok
? ""
