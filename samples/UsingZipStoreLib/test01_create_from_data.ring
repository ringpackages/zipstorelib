/*
	ZipStoreLib Demo 1 - Create a ZIP from in-memory data
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 1: Create a ZIP from in-memory data
# -------------------------------------------------------
? "Demo 1: Creating ZIP from in-memory data..."

oZip = new ZipWriter
oZip.addData("hello.txt", "Hello World from ZipStoreLib!")
oZip.addData("numbers.txt", "1, 2, 3, 4, 5")
oZip.addData("greeting.txt", "Welcome to the Ring programming language!")

if oZip.save("demo1_simple.zip")
	? "  Created: demo1_simple.zip (" + oZip.count() + " files)"
else
	? "  Error creating ZIP file!"
ok
? ""
