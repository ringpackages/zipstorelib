/*
	ZipStoreLib Demo 9 - ZIP with archive comment
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 9: ZIP with archive comment
# -------------------------------------------------------
? "Demo 9: ZIP with comments..."

oZip = new ZipWriter
oZip.setComment("This archive was created by ZipStoreLib")
oZip.addData("info.txt", "Archive with a comment!")
oZip.save("demo9_comment.zip")

oReader = new ZipReader
if oReader.open("demo9_comment.zip")
	? "  Archive comment: " + oReader.comment()
	oReader.close()
ok
? ""
