REM tz.bat
echo on

del *.rel
del *.lst
del *.rst
del *.map
del *.hlr
del *.sym

asz280 -lbcoxff -p -o+ tzx_cl asz_cl tz280x 
asxscn tzx_cl.lst

asz280 -lbcoxff -p -o+ tzx_cr asz_cr tz280x 
aslink -nf tzx_cr
asxscn tzx_cr.rst

asz280 -lbcoxff -p -o+ tzx_xl asz_xl tz280x 
asxscn tzx_xl.lst

asz280 -lbcoxff -p -o+ tzx_xr asz_xr tz280x 
aslink -nf tzx_xr
asxscn tzx_xr.rst

asz280 -lbcoxff -p -o+ tzx_exl asz_exl tz280x 
asxscn tzx_exl.lst

asz280 -lbcoxff -p -o+ tzx_exr asz_exr tz280x 
aslink -nf tzx_exr
asxscn tzx_exr.rst

