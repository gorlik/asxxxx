REM asst9 code check
asst9 -ploxffb tst9.asm
asxscn -i tst9.lst
aslink -nmux -g xN=0 -g xNN=0 -g X0=0 -g X1=1 -g X2=2 -g X3=3 -g X4=4 -g X5=5 -g X6=6 -g X7=7 tst9
asxscn tst9.rst
asst9 -ploxffb -i ".define GLOBAL" tst9.asm
aslink -nmux -g xN=0 -g xNN=0 -g X0=0 -g X1=1 -g X2=2 -g X3=3 -g X4=4 -g X5=5 -g X6=6 -g X7=7 tst9
asxscn tst9.rst
