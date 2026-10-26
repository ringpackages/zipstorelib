/*
	ZipStoreLib Demo 8 - ZIP inspection utility
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 8: ZIP inspection utility
# -------------------------------------------------------
? "Demo 8: ZIP inspection utility..."
? ""

oZip = new ZipWriter
oZip.setComment("Inspection demo")
oZip.addData("docs/readme.txt", "Hello")
oZip.addData("docs/license.txt", "MIT License")
oZip.addEmptyFolder("images")
oZip.save("demo8_inspect.zip")

oInfo = new ZipInfo
oInfo.inspect("demo8_inspect.zip")
? ""
