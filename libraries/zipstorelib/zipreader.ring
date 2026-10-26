class ZipReader

	cData = ""
	aEntries = []
	cComment = ""
	lOpen = false

	func open cFileName
		close()
		if !fexists(cFileName)
			? "ZipStoreLib Error: File not found: " + cFileName
			return false
		ok
		if !openData(read(cFileName))
			? "ZipStoreLib Error: Invalid ZIP archive: " + cFileName
			return false
		ok
		return true

	func openData cZipData
		close()
		cData = cZipData
		if len(cData) < 22 or !parseArchive()
			close()
			return false
		ok
		lOpen = true
		return true

	func close
		cData = ""
		aEntries = []
		cComment = ""
		lOpen = false

	func isOpen
		return lOpen

	func count
		return len(aEntries)

	func fileList
		aFiles = []
		nEntryLen = len(aEntries)
		for nEntry = 1 to nEntryLen
			aFiles + aEntries[nEntry][:zipPath]
		next
		return aFiles

	func comment
		return cComment

	func exists cZipPath
		return indexOf(cZipPath) > 0

	func indexOf cZipPath
		cZipPath = zipNormalizePath(cZipPath)
		nEntryLen = len(aEntries)
		for nEntry = 1 to nEntryLen
			if aEntries[nEntry][:zipPath] = cZipPath
				return nEntry
			ok
		next
		return 0

	func entry cZipPath
		return entryAt(indexOf(cZipPath))

	func entryAt nIndex
		if nIndex < 1 or nIndex > len(aEntries)
			return []
		ok
		return aEntries[nIndex]

	func content cZipPath
		return contentAt(indexOf(cZipPath))

	func contentAt nIndex
		if nIndex < 1 or nIndex > len(aEntries)
			return NULL
		ok
		return readEntry(nIndex)[2]

	func extractFile cZipPath, cDestPath
		nIndex = indexOf(cZipPath)
		if nIndex = 0
			? "ZipStoreLib Error: Entry not found: " + cZipPath
			return false
		ok
		aResult = readEntry(nIndex)
		if !aResult[1] return false ok
		zipMakeDir(zipParentDir(cDestPath))
		write(cDestPath, aResult[2])
		return fexists(cDestPath)

	func extractAll cDestFolder
		cSep = zipPathSep()
		if right(cDestFolder, 1) != "/" and right(cDestFolder, 1) != "\"
			cDestFolder += cSep
		ok
		zipMakeDir(cDestFolder)
		lAllOk = true
		nEntryLen = len(aEntries)
		for nEntry = 1 to nEntryLen
			cZipPath = aEntries[nEntry][:zipPath]
			if !zipIsSafePath(cZipPath)
				? "ZipStoreLib Warning: Skipped unsafe path: " + cZipPath
				lAllOk = false
				loop
			ok
			cDestPath = cDestFolder + substr(cZipPath, "/", cSep)
			if right(cZipPath, 1) = "/"
				zipMakeDir(cDestPath)
				loop
			ok
			aResult = readEntry(nEntry)
			if !aResult[1]
				lAllOk = false
				loop
			ok
			zipMakeDir(zipParentDir(cDestPath))
			write(cDestPath, aResult[2])
		next
		return lAllOk

	func verify
		# Return true if every entry can be read and its CRC32 matches
		nEntryLen = len(aEntries)
		for nEntry = 1 to nEntryLen
			if !readEntry(nEntry)[1] return false ok
		next
		return true

	func verifyAt nIndex
		if nIndex < 1 or nIndex > len(aEntries)
			return false
		ok
		return readEntry(nIndex)[1]

	func printContents
		? "    Length  Method   CRC-32    Date       Time      Name"
		? "  --------  -------  --------  ---------- --------  ----"
		nTotal = 0
		nEntryLen = len(aEntries)
		for nEntry = 1 to nEntryLen
			aEntry = aEntries[nEntry]
			cMethod = "Unknown"
			if aEntry[:method] = ZIP_METHOD_STORED
				cMethod = "Stored "
			but aEntry[:method] = ZIP_METHOD_DEFLATE
				cMethod = "Deflate"
			ok
			? padLeft("" + aEntry[:size], 10) + "  " + cMethod + "  " +
				zipHex8(aEntry[:crc32]) + "  " + aEntry[:dateTime] + "  " + aEntry[:zipPath]
			nTotal += aEntry[:size]
		next
		? "  --------                                         ----"
		? padLeft("" + nTotal, 10) + "                                         " +
			nEntryLen + " file(s)"

	private

	func padLeft cText, nWidth
		while len(cText) < nWidth
			cText = " " + cText
		end
		return cText

	func parseArchive
		# Find the End of Central Directory record (search backwards, the comment can be up to 65535 bytes)
		nDataLen = len(cData)
		nEndPos = 0
		nSearchEnd = nDataLen - 65556
		if nSearchEnd < 1 nSearchEnd = 1 ok
		for nPos = nDataLen - 21 to nSearchEnd step -1
			if substr(cData, nPos, 4) = ZIP_SIG_END
				nEndPos = nPos
				exit
			ok
		next
		if nEndPos = 0 return false ok

		nEntryCount = zipReadWord(cData, nEndPos + 10)
		nCDOffset = zipReadDWord(cData, nEndPos + 16)
		nCommentLen = zipReadWord(cData, nEndPos + 20)
		if nCommentLen > 0
			cComment = substr(cData, nEndPos + 22, nCommentLen)
		ok

		aEntries = []
		nPos = nCDOffset + 1
		for nEntry = 1 to nEntryCount
			if nPos + 45 > nDataLen exit ok
			if substr(cData, nPos, 4) != ZIP_SIG_CENTRAL exit ok
			nDosTime = zipReadWord(cData, nPos + 12)
			nDosDate = zipReadWord(cData, nPos + 14)
			nNameLen = zipReadWord(cData, nPos + 28)
			nExtraLen = zipReadWord(cData, nPos + 30)
			nEntryCommentLen = zipReadWord(cData, nPos + 32)
			cEntryComment = ""
			if nEntryCommentLen > 0
				cEntryComment = substr(cData, nPos + 46 + nNameLen + nExtraLen, nEntryCommentLen)
			ok
			aEntries + [
				:zipPath     = substr(cData, nPos + 46, nNameLen),
				:method      = zipReadWord(cData, nPos + 10),
				:crc32       = zipReadDWord(cData, nPos + 16),
				:compSize    = zipReadDWord(cData, nPos + 20),
				:size        = zipReadDWord(cData, nPos + 24),
				:dosTime     = nDosTime,
				:dosDate     = nDosDate,
				:dateTime    = zipDosToReadable(nDosDate, nDosTime),
				:localOffset = zipReadDWord(cData, nPos + 42),
				:comment     = cEntryComment
			]
			nPos += 46 + nNameLen + nExtraLen + nEntryCommentLen
		next
		return len(aEntries) = nEntryCount

	func readEntry nIndex
		# Return [lOk, cContent]
		aEntry = aEntries[nIndex]
		nPos = aEntry[:localOffset] + 1
		if substr(cData, nPos, 4) != ZIP_SIG_LOCAL
			? "ZipStoreLib Error: Invalid local file header: " + aEntry[:zipPath]
			return [false, ""]
		ok
		if aEntry[:method] != ZIP_METHOD_STORED
			? "ZipStoreLib Error: Compressed entries are not supported: " + aEntry[:zipPath]
			return [false, ""]
		ok
		nDataStart = nPos + 30 + zipReadWord(cData, nPos + 26) + zipReadWord(cData, nPos + 28)
		cContent = ""
		if aEntry[:compSize] > 0
			cContent = substr(cData, nDataStart, aEntry[:compSize])
		ok
		if len(cContent) != aEntry[:size] or zipCRC32(cContent) != aEntry[:crc32]
			? "ZipStoreLib Error: CRC32 mismatch: " + aEntry[:zipPath]
			return [false, cContent]
		ok
		return [true, cContent]
