func quickZip cZipFileName, aSourceFiles
	oZip = new ZipWriter
	aFiles = aSourceFiles
	if isString(aSourceFiles)
		aFiles = [aSourceFiles]
	ok
	nFileLen = len(aFiles)
	for nFile = 1 to nFileLen
		aItem = aFiles[nFile]
		if isString(aItem)
			cZipPath = aItem
			if !zipIsSafePath(cZipPath)
				cZipPath = zipBaseName(cZipPath)
			ok
			oZip.addFile(cZipPath, aItem)
		but isList(aItem) and len(aItem) = 2
			oZip.addFile(aItem[1], aItem[2])
		ok
	next
	return oZip.save(cZipFileName)

func quickZipData cZipFileName, aDataList
	oZip = new ZipWriter
	nItemLen = len(aDataList)
	for nItem = 1 to nItemLen
		oZip.addData(aDataList[nItem][1], aDataList[nItem][2])
	next
	return oZip.save(cZipFileName)

func quickZipFolder cZipFileName, cFolderPath
	oZip = new ZipWriter
	oZip.addFolder(cFolderPath, "")
	return oZip.save(cZipFileName)

func quickUnzip cZipFileName, cDestFolder
	oZip = new ZipReader
	if !oZip.open(cZipFileName)
		return false
	ok
	lResult = oZip.extractAll(cDestFolder)
	oZip.close()
	return lResult

func zipCRC32 cData
	zipInitCRC32()
	nCRC = 0xFFFFFFFF
	nDataLen = len(cData)
	for nByte = 1 to nDataLen
		nCRC = (nCRC >> 8) ^ aZipCRC32Table[((nCRC ^ ascii(cData[nByte])) & 0xFF) + 1]
	next
	return nCRC ^ 0xFFFFFFFF

func zipHex8 nValue
	cDigits = "0123456789ABCDEF"
	cHex = ""
	for nNibble = 1 to 8
		cHex += cDigits[((nValue >> (32 - nNibble * 4)) & 0x0F) + 1]
	next
	return cHex

func zipInitCRC32
	if len(aZipCRC32Table) > 0 return ok
	for nIndex = 0 to 255
		nCRC = nIndex
		for nBit = 1 to 8
			if (nCRC & 1) = 1
				nCRC = (nCRC >> 1) ^ 0xEDB88320
			else
				nCRC = nCRC >> 1
			ok
		next
		aZipCRC32Table + nCRC
	next

# Little-endian binary helpers

func zipWord nValue
	return char(nValue & 0xFF) + char((nValue >> 8) & 0xFF)

func zipDWord nValue
	return char(nValue & 0xFF) + char((nValue >> 8) & 0xFF) +
		char((nValue >> 16) & 0xFF) + char((nValue >> 24) & 0xFF)

func zipReadWord cData, nPos
	if nPos + 1 > len(cData) return 0 ok
	return ascii(cData[nPos]) | (ascii(cData[nPos + 1]) << 8)

func zipReadDWord cData, nPos
	if nPos + 3 > len(cData) return 0 ok
	return ascii(cData[nPos]) | (ascii(cData[nPos + 1]) << 8) |
		(ascii(cData[nPos + 2]) << 16) | (ascii(cData[nPos + 3]) << 24)

# DOS date/time helpers

func zipDosDateTime
	# date() returns dd/mm/yyyy and time() returns hh:mm:ss
	cDate = date()
	cTime = time()
	nYear = number(substr(cDate, 7, 4))
	if nYear < 1980 nYear = 1980 ok
	nDosDate = ((nYear - 1980) << 9) | (number(substr(cDate, 4, 2)) << 5) | number(left(cDate, 2))
	nDosTime = (number(left(cTime, 2)) << 11) | (number(substr(cTime, 4, 2)) << 5) |
		floor(number(substr(cTime, 7, 2)) / 2)
	return [nDosTime, nDosDate]

func zipDosToReadable nDosDate, nDosTime
	return "" + (((nDosDate >> 9) & 0x7F) + 1980) + "-" +
		right("0" + ((nDosDate >> 5) & 0x0F), 2) + "-" +
		right("0" + (nDosDate & 0x1F), 2) + " " +
		right("0" + ((nDosTime >> 11) & 0x1F), 2) + ":" +
		right("0" + ((nDosTime >> 5) & 0x3F), 2) + ":" +
		right("0" + ((nDosTime & 0x1F) * 2), 2)

# Path helpers

func zipPathSep
	if isWindows() return "\" ok
	return "/"

func zipNormalizePath cPath
	return substr(cPath, "\", "/")

func zipBaseName cPath
	cPath = zipNormalizePath(cPath)
	nPathLen = len(cPath)
	for nPos = nPathLen to 1 step -1
		if cPath[nPos] = "/" return substr(cPath, nPos + 1) ok
	next
	return cPath

func zipParentDir cPath
	cPath = zipNormalizePath(cPath)
	nPathLen = len(cPath)
	for nPos = nPathLen to 1 step -1
		if cPath[nPos] = "/" return left(cPath, nPos) ok
	next
	return ""

func zipIsSafePath cZipPath
	# Reject absolute paths and ".." segments (they could escape the destination folder)
	cPath = zipNormalizePath(cZipPath)
	if cPath = "" return false ok
	if left(cPath, 1) = "/" return false ok
	if len(cPath) >= 2 and cPath[2] = ":" return false ok
	cPath = "/" + cPath + "/"
	return substr(cPath, "/../") = 0

func zipMakeDir cPath
	if right(cPath, 1) = "/" or right(cPath, 1) = "\"
		cPath = left(cPath, len(cPath) - 1)
	ok
	if cPath = "" or direxists(cPath) return ok
	if isWindows()
		system('mkdir "' + substr(cPath, "/", "\") + '" 2>nul')
	else
		system("mkdir -p '" + cPath + "'")
	ok

func zipListFiles cFolderPath
	aFiles = []
	zipListFilesRecursive(cFolderPath, "", aFiles)
	return aFiles

func zipListFilesRecursive cBasePath, cRelPath, aFiles
	cCurrentPath = cBasePath
	if cRelPath != ""
		cCurrentPath = cBasePath + zipPathSep() + substr(cRelPath, "/", zipPathSep())
	ok
	aItems = dir(cCurrentPath)
	nItemLen = len(aItems)
	for nItem = 1 to nItemLen
		cName = aItems[nItem][1]
		if cName = "." or cName = ".." loop ok
		cItemRelPath = cName
		if cRelPath != ""
			cItemRelPath = cRelPath + "/" + cName
		ok
		if aItems[nItem][2] = 0
			aFiles + cItemRelPath
		else
			zipListFilesRecursive(cBasePath, cItemRelPath, aFiles)
		ok
	next
