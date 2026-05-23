@echo off
REM _xfiles.bat
REM
REM   Purge Deleted Files
rmdir /s /q deleted
REM   Purge Assembled Files
REM
del *.cdb
del *.exe
del *.hex
del *.hlr
del *.ihx
del *.i86
del *.lst
del *.map
del *.noi
del *.o
del *.out
del *.rel
del *.rst
del *.s19
del *.s28
del *.s37
del *.sym

