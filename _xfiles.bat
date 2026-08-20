@echo off
REM _xfiles.bat
REM
REM   Purge Deleted Files
rmdir /s /q deleted
REM   Purge Assembled Files
REM
del /q *.cdb
del /q *.exe
del /q *.hex
del /q *.hlr
del /q *.ihx
del /q *.i86
del /q *.lst
del /q *.map
del /q *.noi
del /q *.o
del /q *.out
del /q *.rel
del /q *.rst
del /q *.s19
del /q *.s28
del /q *.s37
del /q *.sym

