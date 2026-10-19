# Rebuilds the Vivado project from the repo sources.
# Run:  vivado -mode batch -source create_project.tcl
# Or in the GUI: Tools -> Run Tcl Script

set origin_dir [file dirname [file normalize [info script]]]
set repo_dir   [file normalize "$origin_dir/.."]

create_project riscv_core $origin_dir/riscv_core -part xc7z020clg400-1 -force

add_files -fileset sources_1 [glob $repo_dir/src/*.sv]
add_files -fileset sim_1     [glob $repo_dir/sim/*.sv]
add_files -fileset sim_1     [glob $repo_dir/mem/*.mem]

set_property file_type SystemVerilog [get_files *.sv]
set_property top riscv [get_filesets sources_1]
set_property top tb    [get_filesets sim_1]

update_compile_order -fileset sources_1