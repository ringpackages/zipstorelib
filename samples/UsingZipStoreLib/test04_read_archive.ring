/*
	ZipStoreLib Demo 4 - Read and inspect a ZIP file
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 4: Read and inspect a ZIP file
# -------------------------------------------------------
? "Demo 4: Reading and inspecting ZIP..."

# Create the ZIP file to read
quickZipData("demo4_project.zip", [
	["project/src/main.ring", '? "Hello from Ring!"'],
	["project/docs/README.md", "# My Ring Project"],
	["project/config.ini", "[app]" + nl + "name=MyProject"]
])

oReader = new ZipReader
if oReader.open("demo4_project.zip")
	? "  Number of entries: " + oReader.count()
	? "  Content of README.md: " + oReader.content("project/docs/README.md")

	if oReader.exists("project/config.ini")
		? "  config.ini exists in the archive"
	ok

	aEntry = oReader.entry("project/src/main.ring")
	if len(aEntry) > 0
		? "  main.ring size: " + aEntry[:size] + " bytes"
		? "  main.ring date: " + aEntry[:dateTime]
	ok
	oReader.close()
else
	? "  Failed to open archive!"
ok
? ""
