# TODO: REMOVE PREVIOUS DATA OF THE TEST
# TODO: Implement before each
# TODO: Implement after each
# TODO: Implement teardown
# TODO: Implement run tag
# TODO: Define status
# TODO: Implement options



namespace eval ::tclunit {
	set testData [dict create]

	set STATUS_NOT_RUN 0
	set STATUS_OK 1
	set STATUS_ERROR 2
}

proc ::tclunit::setUp {body} {
	variable testData 
	set testns [uplevel 1 [list namespace current]]
	
	::tclunit::initnsIfNeeded
	
		
	eval [list proc "${testns}::setUp" {} $body]
	
	dict set testData $testns setUp "setUp"
	
	# Avoid returning the content of testData when this procedure is invoked:
	return ""
}

proc ::tclunit::test {testName body args} {
	variable testData 
	variable STATUS_NOT_RUN
	
	set testns [uplevel 1 [list namespace current]]
	
	::tclunit::initnsIfNeeded 
	
	set testName [string trimleft $testName ":"]
	
	eval [list proc "${testns}::${testName}" {} $body]
	dict set testData $testns tests $testName [dict create status $STATUS_NOT_RUN tags {} errormsg {}]
	
	# Avoid returning the content of testData when this procedure is invoked:
	return ""
}

proc ::tclunit::initnsIfNeeded {} {
	variable testData
	set testns [uplevel 2 [list namespace current]]
	if {![dict exists $testData $testns]} { 
		dict set testData $testns [dict create setUp "" beforeEach "" afterEach "" tearDown "" tests [list]] 
	}
}

proc ::tclunit::beforeRun {} {
	variable passed 0
	variable failed 0
	variable testData
	variable run 0
	foreach testns [dict keys $testData] {
		foreach testName [dict keys [dict get $testData $testns tests]] {
			dict set testData $testns tests $testName status 0
			dict set testData $testns tests $testName errormsg {}
		}
	}
}

proc ::tclunit::runAll {} {
	variable testData
	
	::tclunit::beforeRun
	
	foreach testns [dict keys $testData] {
		::tclunit::runns $testns
	}
	
	::tclunit::ReportResult
}

proc ::tclunit::runns {testns} {
	variable testData
	
	if {[dict get $testData $testns setUp] eq "setUp"} {
		if {[catch {"${testns}::setUp"} msg]} {
			puts "Error on ${testns} setUp. Some tests might fail."
		}
	}
	foreach testName [dict keys [dict get $testData $testns tests]] {
		puts "Invoking $testName"
		::tclunit::run $testns $testName
	}
	
}


proc ::tclunit::run {testns testName} {
	variable passed
	variable failed
	variable testData
	variable run
	variable STATUS_OK
	variable STATUS_ERROR
	incr run
	
	if {[catch {"${testns}::${testName}"} msg]} {
		dict set testData $testns tests $testName errormsg $msg
		dict set testData $testns tests $testName status $STATUS_ERROR
		incr failed
	} else {
		dict set testData $testns tests $testName status $STATUS_OK
		incr passed
	}

}

proc ::tclunit::ReportResult {} {
	variable passed
	variable failed
	variable testData
	variable run
	variable STATUS_ERROR
	
	dict for {testns nsData} $testData {
		dict for {testName data} [dict get $nsData tests] {
			if {[dict get $data status] == $STATUS_ERROR} {
				puts "Test $testName failed: [dict get $data errormsg]"
			} else {
				puts "Test $testName passed."
			}
		}
	}
	
	puts "Run ${run} tests.  Passed:${passed}  Failed:${failed}"
}

proc ::tclunit::assertEqualInt {expected value} {
	if {$expected != $value} {
		error "Integers should be equal. Expected ${expected}."
	}
} 

proc ::tclunit::assertNotEqualInt {expected value} {
	if {$expected == $value} {
		error "Integers should not be equal. Expected different than ${expected}"
	}
} 



