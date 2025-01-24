ECHO "Creating working library"
vlib work
IF errorlevel 2 (
    ECHO failed to create library
    GOTO done:
)
 
ECHO "invoking ==============> vlog adc_calibration.sv adc_calibration_tb.sv"
vlog  lib_switchblock_pkg.sv TopModule.sv tb_TopModule.sv  +acc
REM vlog  lib_switchblock_pkg.sv quantizer.sv quantizer_tb.sv  +acc
REM vlog  lib_switchblock_pkg.sv SwitchingBlock.sv tb_SwitchingBlock.sv  +acc
REM vlog  lib_switchblock_pkg.sv pn_sequence_generator.sv tb_pn_sequence_generator.sv  +acc
REM vlog  lib_switchblock_pkg.sv SecondOrderIIRNotchFilter.sv tb_SecondOrderIIRNotchFilter.sv  +acc
IF errorlevel 2 (
    ECHO there was an error, fix it and try again
    GOTO done:
)
 
ECHO "invoking ==============> vsim adc_calibration_tb"
vsim -do "add wave -r *; run -all; quit" tb_TopModule
REM vsim -do "add wave -r *; run -all; quit" quantizer_tb
REM vsim -do "add wave -r *; run -all; quit" tb_SwitchingBlock
REM vsim -do "add wave -r *; run -all; quit" tb_pn_sequence_generator
REM vsim -do "add wave -r *; run -all; quit" tb_SecondOrderIIRNotchFilter
IF errorlevel 2 (
    ECHO there was an error, fix it and try again
    GOTO done:
)
 
:done
ECHO Done
 
 
has context menu