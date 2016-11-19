# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7k70tfbv676-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Kjersti/Documents/Skole/Dig.design/Project/RSA2016/RSA2016.cache/wt [current_project]
set_property parent.project_path C:/Users/Kjersti/Documents/Skole/Dig.design/Project/RSA2016/RSA2016.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/Kjersti/Documents/Skole/Dig.design/Project/RSA2016/RSA2016.srcs/sources_1/imports/RSA_2016/blakley_RSA.vhd
  C:/Users/Kjersti/Documents/Skole/Dig.design/Project/RSA2016/RSA2016.srcs/sources_1/imports/RSA_2016/binary_RSA.vhd
  C:/Users/Kjersti/Documents/Skole/Dig.design/Project/RSA2016/RSA2016.srcs/sources_1/imports/RSAExampleTestbench/RSAParameters.vhd
  C:/Users/Kjersti/Documents/Skole/Dig.design/Project/RSA2016/RSA2016.srcs/sources_1/imports/Dig.design/RSACore.vhd
}
synth_design -top RSACore -part xc7k70tfbv676-1
write_checkpoint -noxdef RSACore.dcp
catch { report_utilization -file RSACore_utilization_synth.rpt -pb RSACore_utilization_synth.pb }