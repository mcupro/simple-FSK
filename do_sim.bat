 

:start 
del a.out 
del *.vcd
iverilog      *.v 
vvp -n a.out 
pause 
goto start 


