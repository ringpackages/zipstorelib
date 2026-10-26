class ZipWriter

	# Each entry is [cZipPath, cContent, cEntryComment]
	aEntries = []
	cComment = ""

	func setComment cText
		cComment = cText
		return self

	func addData cZipPath, cContent
		aEntries + [zipNormalizePath(cZipPath), cContent, ""]
		return self

	func addDataWithComment cZipPath, cContent, cEntryComment
		aEntries + [zipNormalizePath(cZipPath), cContent, cEntryComment]
		return self

	func addFile cZipPath, cLocalPath
		return addFileWithComment(cZipPath, cLocalPath, "")

	func addFileWithComment cZipPath, cLocalPath, cEntryComment
		if !fexists(cLocalPath)
			? "ZipStoreLib Warning: File not found: " + cLocalPath
			return self
		ok
		aEntries + [zipNormalizePath(cZipPath), read(cLocalPath), cEntryComment]
		return self

	func addFolder cFolderPath, cZipPrefix
		cSep = zipPathSep()
		if right(cFolderPath, 1) = "/" or right(cFolderPath, 1) = "\"
			cFolderPath = left(cFolderPath, len(cFolderPath) - 1)
		ok
		if cZipPrefix != ""
			cZipPrefix = zipNormalizePath(cZipPrefix)
			if right(cZipPrefix, 1) != "/" cZipPrefix += "/" ok
		ok
		aFiles = zipListFiles(cFolderPath)
		nFileLen = len(aFiles)
		for nFile = 1 to nFileLen
			addFile(cZipPrefix + aFiles[nFile], cFolderPath + cSep + substr(aFiles[nFile], "/", cSep))
		next
		return self

	func addEmptyFolder cZipPath
		cZipPath = zipNormalizePath(cZipPath)
		if right(cZipPath, 1) != "/" cZipPath += "/" ok
		aEntries + [cZipPath, "", ""]
		return self

	func build
		aDosDateTime = zipDosDateTime()
		nDosTime = aDosDateTime[1]
		nDosDate = aDosDateTime[2]
		cOut = ""
		cCentralDir = ""
		nOffset = 0
		nEntryLen = len(aEntries)
		for nEntry = 1 to nEntryLen
			cZipPath = aEntries[nEntry][1]
			cContent = aEntries[nEntry][2]
			cEntryComment = aEntries[nEntry][3]
			nCRC = zipCRC32(cContent)
			nSize = len(cContent)

			# Fields shared by the local header and the central directory entry
			cCommon = zipWord(20) +				# Version needed to extract (2.0)
				zipWord(0) +				# General purpose bit flag
				zipWord(ZIP_METHOD_STORED) +		# Compression method
				zipWord(nDosTime) + zipWord(nDosDate) +
				zipDWord(nCRC) +
				zipDWord(nSize) +			# Compressed size
				zipDWord(nSize) +			# Uncompressed size
				zipWord(len(cZipPath)) +
				zipWord(0)				# Extra field length

			cLocalHeader = ZIP_SIG_LOCAL + cCommon + cZipPath
			cOut += cLocalHeader + cContent

			cCentralDir += ZIP_SIG_CENTRAL + zipWord(20) + cCommon +
				zipWord(len(cEntryComment)) +
				zipWord(0) +				# Disk number start
				zipWord(0) +				# Internal file attributes
				zipDWord(0) +				# External file attributes
				zipDWord(nOffset) +			# Offset of local header
				cZipPath + cEntryComment

			nOffset += len(cLocalHeader) + nSize
		next

		cOut += cCentralDir + ZIP_SIG_END +
			zipWord(0) + zipWord(0) +			# Disk numbers
			zipWord(nEntryLen) + zipWord(nEntryLen) +
			zipDWord(len(cCentralDir)) +
			zipDWord(nOffset) +				# Offset of central directory
			zipWord(len(cComment)) + cComment
		return cOut

	func save cFileName
		write(cFileName, build())
		return fexists(cFileName)

	func count
		return len(aEntries)

	func fileList
		aFiles = []
		nEntryLen = len(aEntries)
		for nEntry = 1 to nEntryLen
			aFiles + aEntries[nEntry][1]
		next
		return aFiles

	func clear
		aEntries = []
		cComment = ""
		return self
