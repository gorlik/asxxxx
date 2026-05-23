rem  Zip File Created  with Info-Zip   Zip v2.31
rem  Zip File Verified with Info-Zip UnZip v5.52
rem
rem  Remove Old Version Files
rem
del asxv*.*
rem
rem  Zip The asxv6pxx Directory and Subdirectories
rem
cd ..\..\
asxv6pxx\zipper\zip.exe -r .\asxv6pxx\zipper\asxv6pxx.zip asxv6pxx\*.*
cd asxv6pxx\zipper
zip -T asxv6pxx.zip
rem
rem  Remove Zipped Files and the Zip/Unzip Utilities
rem
zip -d asxv6pxx.zip asxv6pxx\zipper\*.exe asxv6pxx\zipper\*.txt asxv6pxx\zipper\*.zip
zip -T asxv6pxx.zip
rem
rem  Remove Non-Distribution Directories
rem
zip -d asxv6pxx.zip asxv6pxx\asxdoc\asxrno\* asxv6pxx\asxhtmw\*
zip -d asxv6pxx.zip asxv6pxx\updater\* asxv6pxx\misc\*
rem
rem  Copy Current readme.txt File To asxv6pxx.txt
rem  And Add To The Zip Archive
rem
copy ..\readme.txt asxv%1.txt
zip -g asxv6pxx.zip asxv%1.txt
zip -T asxv6pxx.zip
rem
rem  Change Name To Current Version
rem
ren asxv6pxx.zip asxv%1.zip
rem
rem  Final File Verification
rem
unzip -t asxv%1.zip

