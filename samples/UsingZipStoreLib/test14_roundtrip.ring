/*
	ZipStoreLib Demo 14 - Full roundtrip verification
*/

load "zipstorelib.ring"

# -------------------------------------------------------
# Demo 14: Full roundtrip verification
# -------------------------------------------------------
? "Demo 14: Full roundtrip verification..."

aTestFiles = [
	["text/english.txt", "Hello World! This is a test."],
	["text/arabic.txt", "مرحبا بالعالم"],
	["text/numbers.txt", "3.14159265358979"],
	["binary/bytes.bin", char(0) + char(1) + char(255) + char(128)],
	["empty/empty.txt", ""],
	["code/test.ring", '? "Hello from Ring!"']
]

quickZipData("demo14_roundtrip.zip", aTestFiles)

lAllPassed = true
oReader = new ZipReader
if oReader.open("demo14_roundtrip.zip")
	for aItem in aTestFiles
		if oReader.verifyAt(oReader.indexOf(aItem[1])) and oReader.content(aItem[1]) = aItem[2]
			? "  PASS: " + aItem[1]
		else
			? "  FAIL: " + aItem[1]
			lAllPassed = false
		ok
	next
	oReader.close()
else
	lAllPassed = false
ok

if lAllPassed
	? "  All roundtrip tests PASSED!"
else
	? "  Some tests FAILED!"
ok
? ""
