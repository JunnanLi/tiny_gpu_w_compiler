sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-sverilog" "+v2k" "-f" "file_list.f" "-top" "Testbench_wrapper"
debLoadSimResult /home/lijunnan/Documents/0-code/vcs_prj/tiny-gpu/sim/wave.fsdb
wvCreateWindow
wvSetCursor -win $_nWave2 7715036.961462
wvSetCursor -win $_nWave2 7715036.961462
wvSelectGroup -win $_nWave2 {G1}
wvSetCursor -win $_nWave2 7012487.221295
wvSetCursor -win $_nWave2 14948697.249106
wvSetCursor -win $_nWave2 14948697.249106
srcHBSelect "Testbench_wrapper.gpu_test" -win $_nTrace1
wvSetCursor -win $_nWave2 8430596.882002
srcHBSelect "Testbench_wrapper.gpu_test" -win $_nTrace1
srcSetScope -win $_nTrace1 "Testbench_wrapper.gpu_test" -delim "."
srcHBSelect "Testbench_wrapper.gpu_test" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 20 -pos 1 -win $_nTrace1
srcSelect -signal "reset" -line 21 -pos 1 -win $_nTrace1
srcSelect -signal "start" -line 24 -pos 1 -win $_nTrace1
srcSelect -signal "done" -line 25 -pos 1 -win $_nTrace1
srcSelect -signal "device_control_write_enable" -line 28 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {19 31 4 1 1 1} -backward
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetCursor -win $_nWave2 11448958.728645 -snap {("G2" 0)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "start" -line 24 -pos 1 -win $_nTrace1
srcAction -pos 23 5 2 -win $_nTrace1 -name "start" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "start" -line 24 -pos 1 -win $_nTrace1
srcAction -pos 23 5 0 -win $_nTrace1 -name "start" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "start" -line 24 -pos 1 -win $_nTrace1
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 0.000000 442346.132698
wvZoom -win $_nWave2 6151.018929 14938.188828
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSetOptions -win $_nTrace1 -annotate on
schSetOptions -win $_nSchema1 -annotate on
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "PROGRAM_MEM_NUM_CHANNELS" -line 33 -pos 1 -win $_nTrace1
srcSelect -signal "PROGRAM_MEM_ADDR_BITS" -line 33 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "PROGRAM_MEM_ADDR_BITS" -line 33 -pos 1 -win $_nTrace1
srcAction -pos 32 13 9 -win $_nTrace1 -name "PROGRAM_MEM_ADDR_BITS" -ctrlKey off
srcHierTreeSort -win $_nTrace1 -hierAscending
srcHBSelect "Testbench_wrapper" -win $_nTrace1
srcSetScope -win $_nTrace1 "Testbench_wrapper" -delim "."
srcHBSelect "Testbench_wrapper" -win $_nTrace1
srcSearchString "PROGRAM_MEM_ADDR_BITS" -win $_nTrace1 -next -case
srcHBSelect "Testbench_wrapper" -win $_nTrace1
srcHBSelect "Testbench_wrapper.gpu_test" -win $_nTrace1
srcSetScope -win $_nTrace1 "Testbench_wrapper.gpu_test" -delim "."
srcHBSelect "Testbench_wrapper.gpu_test" -win $_nTrace1
