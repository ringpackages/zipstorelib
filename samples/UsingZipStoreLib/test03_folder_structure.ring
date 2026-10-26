/*
	ZipStoreLib Demo 3 - ZIP with folder structure
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 3: ZIP with folder structure
# -------------------------------------------------------
? "Demo 3: ZIP with folder structure..."

oZip = new ZipWriter
oZip.addData("project/src/main.ring", 'load "mylib.ring"' + nl + nl + 'sayHello("Ring")' + nl)
oZip.addData("project/src/mylib.ring", 'func sayHello cName' + nl + char(9) + '? "Hello, " + cName + "!"' + nl)
oZip.addData("project/docs/README.md", "# My Ring Project" + nl + nl + "A sample project." + nl)
oZip.addData("project/config.ini", "[app]" + nl + "name=MyProject" + nl + "version=1.0.0" + nl)
oZip.setComment("Created with ZipStoreLib")

if oZip.save("demo3_project.zip")
	? "  Created: demo3_project.zip (" + oZip.count() + " files)"
	for cFile in oZip.fileList()
		? "    " + cFile
	next
ok
? ""
