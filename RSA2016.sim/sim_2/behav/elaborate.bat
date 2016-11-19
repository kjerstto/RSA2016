@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto 7a531b80a5a140c492929972f59d0b98 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot RSACoreTestBench_behav xil_defaultlib.RSACoreTestBench -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
