class ZipInfo

	func inspect cFileName
		oZip = new ZipReader
		if !oZip.open(cFileName) return false ok
		? "Archive: " + cFileName
		? "Entries: " + oZip.count()
		if oZip.comment() != ""
			? "Comment: " + oZip.comment()
		ok
		? ""
		oZip.printContents()
		oZip.close()
		return true

	func verify cFileName
		oZip = new ZipReader
		if !oZip.open(cFileName) return false ok
		lAllOk = true
		nEntryLen = oZip.count()
		for nEntry = 1 to nEntryLen
			cZipPath = oZip.entryAt(nEntry)[:zipPath]
			if oZip.verifyAt(nEntry)
				? "  OK      " + cZipPath
			else
				? "  FAILED  " + cZipPath
				lAllOk = false
			ok
		next
		oZip.close()
		return lAllOk

	func compare cFileName1, cFileName2
		oZip1 = new ZipReader
		oZip2 = new ZipReader
		if !oZip1.open(cFileName1) return false ok
		if !oZip2.open(cFileName2)
			oZip1.close()
			return false
		ok
		aFiles1 = oZip1.fileList()
		aFiles2 = oZip2.fileList()

		? "Only in " + cFileName1 + ":"
		nFileLen = len(aFiles1)
		for nFile = 1 to nFileLen
			if !oZip2.exists(aFiles1[nFile])
				? "  - " + aFiles1[nFile]
			ok
		next

		? "Only in " + cFileName2 + ":"
		nFileLen = len(aFiles2)
		for nFile = 1 to nFileLen
			if !oZip1.exists(aFiles2[nFile])
				? "  + " + aFiles2[nFile]
			ok
		next

		? "Modified:"
		nFileLen = len(aFiles1)
		for nFile = 1 to nFileLen
			aEntry2 = oZip2.entry(aFiles1[nFile])
			if len(aEntry2) > 0
				aEntry1 = oZip1.entry(aFiles1[nFile])
				if aEntry1[:crc32] != aEntry2[:crc32] or aEntry1[:size] != aEntry2[:size]
					? "  ~ " + aFiles1[nFile] + " (" + aEntry1[:size] + " -> " + aEntry2[:size] + " bytes)"
				ok
			ok
		next

		oZip1.close()
		oZip2.close()
		return true
