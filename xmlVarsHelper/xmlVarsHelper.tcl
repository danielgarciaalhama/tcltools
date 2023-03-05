package require tdom

package provide xmlVarsHelper


namespace eval ::xmlVarsHelper {

 	# list - dots - dash - underscore - plus
	variable getterFormat "list"
	
	variable data [dict create]
	
	variable curDocElement ""
	
	variable valueKey "#value"
}


proc ::xmlVarsHelper::ReadSeveralFiles {filenames} {
	foreach filename $filenames {
		::xmlVarsHelper::ReadFile $filename
	}
}

proc ::xmlVarsHelper::ReadFile {filename} {
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

proc ::xmlVarsHelper::PrintRawData {} {
	variable data
	puts $data
}

proc ::xmlVarsHelper::ConfigureGetter {} {
	variable getterFormat
	set dataGetterName "Get"

	if {$getterFormat ne "list"} {
		set dataGetterName "GetFromList"
		switch -- $getterFormat {
			"dots" {
				proc ::xmlVarsHelper::Get {varPath} {return [::xmlVarsHelper::GetFromList [split $varPath "."]]}
			}
			"dash" {
				proc ::xmlVarsHelper::Get {varPath} {return [::xmlVarsHelper::GetFromList [split $varPath "-"]]}
			}
			"underscore" {
				proc ::xmlVarsHelper::Get {varPath} {return [::xmlVarsHelper::GetFromList [split $varPath "_"]]}
			}
			"plus" {
				proc ::xmlVarsHelper::Get {varPath} {return [::xmlVarsHelper::GetFromList [split $varPath "+"]]}
			}
			default {
				error "Invalid definition for getter format"
			}
		}
		
	}


	proc ::xmlVarsHelper::$dataGetterName {varPath} {
		variable data
		variable valueKey
		if {[dict exists $data {*}$varPath $valueKey]} {
			return [dict get $data {*}$varPath $valueKey]
		}
		if {[dict exists $data {*}$varPath]} {
			return [dict get $data {*}$varPath]	
		}
		error "Key not found"
		
	}
}


proc ::xmlVarsHelper::ResetData {} {
	variable data
	set data [dict create]
}

proc ::xmlVarsHelper::Remove {key} {
	variable data
	set data [dict remove $data $key]
}


::xmlVarsHelper::ConfigureGetter






