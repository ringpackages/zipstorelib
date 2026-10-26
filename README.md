# ZipStoreLib Package

## Overview

ZipStoreLib is a pure Ring library for merging files into ZIP archives without compression, and for reading and extracting them.

Entries are written with the ZIP **Stored** method (method 0): file content is copied into the archive as is. This keeps the library small and fast, and the archives open in every ZIP tool, including Windows Explorer, 7-Zip, macOS Archive Utility, and Microsoft Office (for `.docx`, `.xlsx` and `.pptx` packages).

It requires no external dependencies and works on Windows, Linux, and macOS.

## Features

- Create ZIP archives from in-memory data, files on disk, and whole folders
- Build archives in memory (`build()`) and read archives from memory (`openData()`)
- List archive contents with size, CRC32, date/time and comments
- Read entries as strings or extract them to disk (single file or whole archive)
- CRC32 validation of every entry that is read
- Archive comments and per-entry comments
- Empty folder entries
- Inspect, verify and compare archives with the `ZipInfo` class
- Protection against unsafe paths (`../`, absolute paths) when extracting
- Cross-platform (Windows, Linux, macOS)

## Installation

	ringpm install zipstorelib from ringpackages

## Screen Shot

![Screen Shot 1](https://raw.githubusercontent.com/ringpackages/zipstorelib/main/images/zipstorelib_shot1.png)


## Quick Start

### Create a ZIP File

```ring
load "zipstorelib.ring"

oZip = new ZipWriter
oZip.addData("hello.txt", "Hello World!")
oZip.addData("docs/readme.txt", "Welcome to my project!")
oZip.addFile("images/logo.png", "logo.png")
oZip.save("output.zip")
```

### Read a ZIP File

```ring
load "zipstorelib.ring"

oReader = new ZipReader
if oReader.open("output.zip")
	? oReader.content("hello.txt")      # Output: Hello World!
	oReader.extractAll("extracted")
	oReader.close()
ok
```

### Quick Functions

```ring
load "zipstorelib.ring"

# Create from data
quickZipData("data.zip", [
	["file1.txt", "Content 1"],
	["file2.txt", "Content 2"]
])

# Create from files on disk
quickZip("files.zip", ["doc1.txt", "doc2.txt"])

# Create from folder
quickZipFolder("project.zip", "myproject")

# Extract all
quickUnzip("archive.zip", "output")
```

---

## API Reference

### Quick Functions

| Function | Description |
|----------|-------------|
| `quickZip(cZipFileName, aSourceFiles)` | Create a ZIP from files on disk; returns true if the file exists. `aSourceFiles` is a file name, a list of file names, or a list of `[zipPath, localPath]` pairs (a file name with an absolute path or `..` is stored by its base name) |
| `quickZipData(cZipFileName, aDataList)` | Create a ZIP from a list of `[zipPath, content]` pairs |
| `quickZipFolder(cZipFileName, cFolderPath)` | Create a ZIP from all files in a folder (recursive); paths are relative to the folder |
| `quickUnzip(cZipFileName, cDestFolder)` | Extract all entries to a folder; returns true if every entry was extracted |

### Utility Functions

| Function | Description |
|----------|-------------|
| `zipCRC32(cData)` | Calculate the CRC32 checksum of a string (returns a number) |
| `zipHex8(nValue)` | Format a 32-bit number as 8 uppercase hex digits (e.g. `414FA339`) |

---

### ZipWriter Class

Create ZIP archives. Entries are kept in memory until you call `build()` or `save()`.

#### Adding Entries

ZIP paths use forward slashes; backslashes are converted automatically.

| Method | Description |
|--------|-------------|
| `addData(cZipPath, cContent)` | Add in-memory data |
| `addDataWithComment(cZipPath, cContent, cEntryComment)` | Add in-memory data with an entry comment |
| `addFile(cZipPath, cLocalPath)` | Add a file from disk (prints a warning and skips it if not found) |
| `addFileWithComment(cZipPath, cLocalPath, cEntryComment)` | Add a file from disk with an entry comment |
| `addFolder(cFolderPath, cZipPrefix)` | Add all files in a folder recursively, under `cZipPrefix` (use `""` for the archive root) |
| `addEmptyFolder(cZipPath)` | Add an empty folder entry (a trailing `/` is added if missing) |
| `setComment(cText)` | Set the archive comment |

#### Output and State

| Method | Description |
|--------|-------------|
| `build()` | Return the ZIP archive as a string |
| `save(cFileName)` | Write the ZIP archive to disk; returns true if the file exists |
| `count()` | Return the number of entries |
| `fileList()` | Return the ZIP paths of the entries |
| `clear()` | Remove all entries and the archive comment |

The adding methods, `setComment()` and `clear()` return `self`, so they can be chained:

```ring
oZip = new ZipWriter
oZip.setComment("My Archive").addData("a.txt", "A").addData("b.txt", "B").save("ab.zip")
```

All entries get the date and time of the `build()`/`save()` call.

---

### ZipReader Class

Read, inspect, and extract ZIP archives. The whole archive is loaded into memory.

#### Open / Close

| Method | Description |
|--------|-------------|
| `open(cFileName)` | Open a ZIP file from disk; returns true on success (prints an error otherwise) |
| `openData(cZipData)` | Open a ZIP archive from a string; returns true on success |
| `close()` | Close the archive and free its data |
| `isOpen()` | Check if an archive is open |

#### Query Contents

| Method | Description |
|--------|-------------|
| `count()` | Number of entries |
| `fileList()` | List of ZIP paths |
| `comment()` | Archive comment |
| `exists(cZipPath)` | Check if an entry exists |
| `indexOf(cZipPath)` | Index of an entry, 1-based (0 if not found) |
| `entry(cZipPath)` | Entry information (see below); `[]` if not found |
| `entryAt(nIndex)` | Entry information by index; `[]` if out of range |
| `printContents()` | Print a table of the entries |

#### Entry Information

`entry()` and `entryAt()` return a list with these keys:

| Key | Description |
|-----|-------------|
| `:zipPath` | Path inside the archive (folders end with `/`) |
| `:method` | Compression method (`ZIP_METHOD_STORED` or `ZIP_METHOD_DEFLATE`) |
| `:crc32` | CRC32 checksum |
| `:compSize` | Size inside the archive in bytes |
| `:size` | Original size in bytes |
| `:dosTime`, `:dosDate` | Date and time in DOS format |
| `:dateTime` | Date and time as `YYYY-MM-DD HH:MM:SS` |
| `:localOffset` | Offset of the local file header |
| `:comment` | Entry comment |

#### Read and Extract

| Method | Description |
|--------|-------------|
| `content(cZipPath)` | Return the content of an entry as a string |
| `contentAt(nIndex)` | Return the content of an entry by index |
| `extractFile(cZipPath, cDestPath)` | Extract one entry to a file (parent folders are created); returns true on success |
| `extractAll(cDestFolder)` | Extract all entries to a folder; returns true if every entry was extracted |
| `verify()` | Return true if every entry can be read and its CRC32 matches |
| `verifyAt(nIndex)` | Same as `verify()` for one entry |

`content()` and `contentAt()` return `NULL` (an empty string) when the entry is not found or cannot be read, which is the same value as an empty file. Use `exists()` and `verifyAt()` when you need to tell them apart.

Every entry that is read is checked against its size and CRC32; a mismatch prints an error. `extractAll()` skips entries with absolute paths or `..` segments (and returns false), so an archive cannot write outside the destination folder.

Entries compressed by other tools (DEFLATE) are listed with their information, but their content cannot be read: reading them prints an error.

---

### ZipInfo Class

Print reports about ZIP files. Each method returns false if a file cannot be opened.

| Method | Description |
|--------|-------------|
| `inspect(cFileName)` | Print the entry count, archive comment and contents table |
| `verify(cFileName)` | Print `OK` or `FAILED` for each entry; returns true if all entries pass |
| `compare(cFileName1, cFileName2)` | Print the entries found in only one archive, and the entries whose CRC32 or size differ |

---

### Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `ZIP_METHOD_STORED` | 0 | No compression (used for all entries written by ZipStoreLib) |
| `ZIP_METHOD_DEFLATE` | 8 | DEFLATE compression (can appear in archives made by other tools) |

---

## Usage Examples

### Example 1: Archive Source Code

```ring
load "zipstorelib.ring"

oZip = new ZipWriter
oZip.setComment("Source code backup - v1.0")
oZip.addFolder("src", "myapp/src")
oZip.addFile("myapp/README.md", "README.md")
oZip.save("myapp-v1.0.zip")
```

### Example 2: Read Configuration from a ZIP

```ring
load "zipstorelib.ring"

oReader = new ZipReader
if oReader.open("app-config.zip")
	if oReader.exists("settings.ini")
		? oReader.content("settings.ini")
	ok
	oReader.close()
ok
```

### Example 3: Modify a ZIP (Read and Rewrite)

```ring
load "zipstorelib.ring"

oReader = new ZipReader
oReader.open("original.zip")

oWriter = new ZipWriter
nCount = oReader.count()
for nEntry = 1 to nCount
	cZipPath = oReader.entryAt(nEntry)[:zipPath]
	cContent = oReader.contentAt(nEntry)
	if cZipPath = "config.txt"
		cContent = "updated=true" + nl + cContent
	ok
	oWriter.addData(cZipPath, cContent)
next
oWriter.addData("changelog.txt", "v1.1 - Updated config")
oWriter.save("modified.zip")
oReader.close()
```

### Example 4: In-Memory ZIP (No Disk I/O)

```ring
load "zipstorelib.ring"

oZip = new ZipWriter
oZip.addData("data.json", '{"name": "Ring"}')
cZipData = oZip.build()

oReader = new ZipReader
oReader.openData(cZipData)
? oReader.content("data.json")
oReader.close()
```

### Example 5: Verify and Compare Archives

```ring
load "zipstorelib.ring"

oInfo = new ZipInfo
oInfo.inspect("backup.zip")
if oInfo.verify("backup.zip")
	? "All files verified!"
ok
oInfo.compare("version1.zip", "version2.zip")
```

---

## License

MIT License
