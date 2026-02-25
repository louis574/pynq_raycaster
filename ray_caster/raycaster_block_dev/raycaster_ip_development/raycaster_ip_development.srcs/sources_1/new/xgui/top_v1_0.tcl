# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "COORD_FRAC_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "COORD_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAP_HEIGHT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAP_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SCREEN_HEIGHT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SCREEN_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.COORD_FRAC_BITS { PARAM_VALUE.COORD_FRAC_BITS } {
	# Procedure called to update COORD_FRAC_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COORD_FRAC_BITS { PARAM_VALUE.COORD_FRAC_BITS } {
	# Procedure called to validate COORD_FRAC_BITS
	return true
}

proc update_PARAM_VALUE.COORD_SIZE { PARAM_VALUE.COORD_SIZE } {
	# Procedure called to update COORD_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COORD_SIZE { PARAM_VALUE.COORD_SIZE } {
	# Procedure called to validate COORD_SIZE
	return true
}

proc update_PARAM_VALUE.MAP_HEIGHT { PARAM_VALUE.MAP_HEIGHT } {
	# Procedure called to update MAP_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAP_HEIGHT { PARAM_VALUE.MAP_HEIGHT } {
	# Procedure called to validate MAP_HEIGHT
	return true
}

proc update_PARAM_VALUE.MAP_WIDTH { PARAM_VALUE.MAP_WIDTH } {
	# Procedure called to update MAP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAP_WIDTH { PARAM_VALUE.MAP_WIDTH } {
	# Procedure called to validate MAP_WIDTH
	return true
}

proc update_PARAM_VALUE.SCREEN_HEIGHT { PARAM_VALUE.SCREEN_HEIGHT } {
	# Procedure called to update SCREEN_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCREEN_HEIGHT { PARAM_VALUE.SCREEN_HEIGHT } {
	# Procedure called to validate SCREEN_HEIGHT
	return true
}

proc update_PARAM_VALUE.SCREEN_WIDTH { PARAM_VALUE.SCREEN_WIDTH } {
	# Procedure called to update SCREEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCREEN_WIDTH { PARAM_VALUE.SCREEN_WIDTH } {
	# Procedure called to validate SCREEN_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.SCREEN_HEIGHT { MODELPARAM_VALUE.SCREEN_HEIGHT PARAM_VALUE.SCREEN_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCREEN_HEIGHT}] ${MODELPARAM_VALUE.SCREEN_HEIGHT}
}

proc update_MODELPARAM_VALUE.SCREEN_WIDTH { MODELPARAM_VALUE.SCREEN_WIDTH PARAM_VALUE.SCREEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCREEN_WIDTH}] ${MODELPARAM_VALUE.SCREEN_WIDTH}
}

proc update_MODELPARAM_VALUE.MAP_WIDTH { MODELPARAM_VALUE.MAP_WIDTH PARAM_VALUE.MAP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAP_WIDTH}] ${MODELPARAM_VALUE.MAP_WIDTH}
}

proc update_MODELPARAM_VALUE.MAP_HEIGHT { MODELPARAM_VALUE.MAP_HEIGHT PARAM_VALUE.MAP_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAP_HEIGHT}] ${MODELPARAM_VALUE.MAP_HEIGHT}
}

proc update_MODELPARAM_VALUE.COORD_SIZE { MODELPARAM_VALUE.COORD_SIZE PARAM_VALUE.COORD_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COORD_SIZE}] ${MODELPARAM_VALUE.COORD_SIZE}
}

proc update_MODELPARAM_VALUE.COORD_FRAC_BITS { MODELPARAM_VALUE.COORD_FRAC_BITS PARAM_VALUE.COORD_FRAC_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COORD_FRAC_BITS}] ${MODELPARAM_VALUE.COORD_FRAC_BITS}
}

