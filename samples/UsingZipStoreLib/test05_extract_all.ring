/*
	ZipStoreLib Demo 5 - Extract a ZIP to a folder
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 5: Extract a ZIP to a folder
# -------------------------------------------------------
? "Demo 5: Extracting ZIP to folder..."

# Create the ZIP file to extract
quickZipData("demo5_project.zip", [
	["project/src/main.ring", '? "Hello from Ring!"'],
	["project/docs/README.md", "# My Ring Project"]
])

oReader = new ZipReader
if oReader.open("demo5_project.zip")
	if oReader.extractAll("extracted_demo5")
		? "  Extracted all files to 'extracted_demo5/'"
		if fexists("extracted_demo5/project/src/main.ring")
			? "  Verified: project/src/main.ring exists"
		ok
		if fexists("extracted_demo5/project/docs/README.md")
			? "  Verified: project/docs/README.md exists"
		ok
	ok
	oReader.close()
ok
? ""
