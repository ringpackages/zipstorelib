/*
	ZipStoreLib Demo 19 - Method chaining
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 19: Method chaining
# -------------------------------------------------------
? "Demo 19: Method chaining..."

oZip = new ZipWriter
oZip.setComment("Chained").addData("a.txt", "A").addData("b.txt", "B").addEmptyFolder("c")
? "  Entries: " + oZip.count()

# Braces give direct access to the object methods
oZip {
	addData("d.txt", "D")
	save("demo19_chain.zip")
}

oReader = new ZipReader
if oReader.open("demo19_chain.zip")
	? "  Saved entries: " + oReader.count()
	? "  Comment: " + oReader.comment()
	oReader.close()
ok
? ""
