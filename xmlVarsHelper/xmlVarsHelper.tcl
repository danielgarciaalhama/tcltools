package require tdom



namespace eval ::xmlVarsHelper {

 # dots - list - "->"
	variable getterFormat "dots"
	
	variable data [dict create]
	
	variable curDocElement ""
	
	variable valueKey "#value"
}

proc ::xmlVarsHelper::ReadConfiguration {filename} {
	variable curDocElement
	set rootNode [::xmlVarsHelper::GetRootNode $filename]
	
	# recursively read the ndoes:
	::xmlVarsHelper::ProcessNode $rootNode [list]
	
	# Clean the dom data from the memory:
	$curDocElement delete
}


proc ::xmlVarsHelper::GetRootNode {filename} {
    variable curDocElement
    set rootNode ""

    if {[catch {
    
	set xmlStr [string trim [tDOM::xmlReadFile $filename]]
    	set curDocElement [dom parse $xmlStr]
    	set rootNode [$curDocElement documentElement]	
    	
    } err]} {
    	error "Error processing file $filename. Reason: $err"
    }
    
    return $rootNode
}


proc ::xmlVarsHelper::ProcessNode {node dictKey} {
	variable data
	variable valueKey
	
	if {[$node nodeType] != "ELEMENT_NODE"} {
		return
	}

	set nodeName [$node nodeName]

	lappend dictKey $nodeName
	
	if {[dict exists $data $dictKey]} {
		error "Node $nodeName is duplicated or defined as an attribute on their parent [[$node parent] nodeName]" 
	}
	
	dict set data {*}$dictKey [dict create]


	foreach attribute [$node attributes] {
		dict set data {*}$dictKey $attribute [$node getAttribute $attribute]
	}
	
	
	if {[$node text] ne ""} {
		dict set data {*}$dictKey $valueKey [$node text]
	} else {
		foreach child [$node childNodes] {
			::xmlVarsHelper::ProcessNode $child $dictKey
		}
	}

}


# TODO: configure the getter according the getter format

proc ::xmlVarsHelper::Get {input} {
	#TODO: Depending on configuration
	variable data
	variable valueKey
	if {[dict exists $data {*}$input $valueKey]} {
		return [dict get $data {*}$input $valueKey]
	}
	if {[dict exists $data {*}$input]} {
		return [dict get $data {*}$input]	
	}
	error "Key not found"
}

proc ::xmlVarsHelper::PrintData {} {
	variable data
	puts $data
}

package provide xmlVarsHelper
