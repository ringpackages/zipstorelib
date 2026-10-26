/*
	ZipStoreLib Demo 17 - Verify and compare archives
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 17: Verify and compare archives
# -------------------------------------------------------
? "Demo 17: Verify and compare archives..."

quickZipData("demo17_v1.zip", [
	["readme.txt", "Version 1"],
	["config.ini", "debug=false"],
	["old.txt", "Removed in version 2"]
])
quickZipData("demo17_v2.zip", [
	["readme.txt", "Version 2 with more text"],
	["config.ini", "debug=false"],
	["new.txt", "Added in version 2"]
])

oInfo = new ZipInfo
? "  Verifying demo17_v1.zip:"
if oInfo.verify("demo17_v1.zip")
	? "  All files verified!"
ok
? ""
oInfo.compare("demo17_v1.zip", "demo17_v2.zip")
? ""
