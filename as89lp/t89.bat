del /Q *.lst
del /Q *.rel
del /Q *.rst
as89lp -gloaxff t89
asxscn t89.lst
as89lp -gloaxff t89r
asxscn t89r.lst
as89lp -gloaxff t89rl
aslink -nu t89rl
asxscn t89rl.rst

