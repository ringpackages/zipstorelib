/*
	ZipStoreLib Demo 2 - Quick ZIP from data
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 2: Quick ZIP from data
# -------------------------------------------------------
? "Demo 2: Quick ZIP from data..."

lResult = quickZipData("demo2_quick.zip", [
	["readme.txt", "This is a quick ZIP demo."],
	["data/config.txt", "setting1=value1" + nl + "setting2=value2"],
	["data/notes.txt", "Some notes go here."]
])

if lResult
	? "  Created: demo2_quick.zip"
ok
? ""
