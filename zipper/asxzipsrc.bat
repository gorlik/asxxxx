rem  Zip File Created  with Info-Zip   Zip v2.31
rem  Zip File Verified with Info-Zip UnZip v5.52
rem
rem Remove Old Versions
rem
del asxs*.*
rem
rem  Zip The asxv6pxx Directory and Subdirectories
rem
cd ..\..\
asxv6pxx\zipper\zip.exe -r .\asxv6pxx\zipper\asxs6pxx.zip asxv6pxx\*.*
cd asxv6pxx\zipper
zip -T asxs6pxx.zip
rem
rem  Remove Zipped Files and the Zip/Unzip Utilities
rem
zip -d asxs6pxx.zip asxv6pxx\zipper\*.exe asxv6pxx\zipper\*.txt asxv6pxx\zipper\*.zip
zip -T asxs6pxx.zip
rem
rem  Remove Non-Distribution Directories
rem
zip -d asxs6pxx.zip asxv6pxx\asxdoc\asxrno\* asxv6pxx\asxhtmw\*
zip -d asxs6pxx.zip asxv6pxx\updater\* asxv6pxx\misc\*
rem
zip -d asxs6pxx.zip asxv6pxx\asxmak\cygwin\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\djgpp\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\linux\exe\as*
zip -d asxs6pxx.zip asxv6pxx\asxmak\linux\exe\s*
zip -d asxs6pxx.zip asxv6pxx\asxmak\turboc30\exe\*.EXE
zip -d asxs6pxx.zip asxv6pxx\asxmak\vc6\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\vs05\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\vs10\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\vs13\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\vs15\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\vs19\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\vs22\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\watcom\exe\*.exe
zip -d asxs6pxx.zip asxv6pxx\asxmak\symantec\exe\*.EXE
zip -T asxs6pxx.zip
rem
rem  Copy Current readme.txt File To asxv6pxx.txt
rem  And Add To The Zip Archive
rem
copy ..\readme.txt asxs%1.txt
zip -g asxs6pxx.zip asxs%1.txt
zip -T asxs6pxx.zip
rem
rem  Change Name To Current Version
rem
ren asxs6pxx.zip asxs%1.zip
rem
rem  Final File Verification
rem
unzip -t asxs%1.zip

