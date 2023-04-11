# TODO: REMOVE PREVIOUS DATA OF THE TEST
# TODO: Implement and add the rule of creating the test on their own namespace
# TODO: Implement before each
# TODO: Implement after each
# TODO: Implement setup
# TODO: Implement teardown
# TODO: Implement run tag
# TODO: Define status
# TODO: Implement options


namespace eval ::tclunit {
	set testData [dict create]

}

proc ::tclunit::test {testName body args} {
	variable testData 
	puts "CURRENT NS [uplevel 1 [list namespace current]]"
	eval [list proc $testName {} $body]
	dict set testData $testName [dict create status 0 tags {} errormsg {}]
}

proc ::tclunit::beforeRun {} {
	variable passed 0
	variable failed 0
	variable testData
	variable run 0
	foreach testName [dict keys $testData] {
		dict set testData $testName status 0
		dict set testData $testName errormsg {}
	}
}

proc ::tclunit::runAll {} {
	variable testData
	
	::tclunit::beforeRun
	
	dict for {testName data} $testData {
			::tclunit::run $testName
	}
	
	::tclunit::ReportResult
}

proc ::tclunit::run {testName} {
	variable passed
	variable failed
	variable testData
	variable run
	incr run
	
	if {[catch {${testName}} msg]} {
		dict set testData $testName errormsg $msg
		dict set testData $testName status 2
		incr failed
	} else {
		dict set testData $testName status 1
		incr passed
	}

}

proc ::tclunit::ReportResult {} {
	variable passed
	variable failed
	variable testData
	variable run
	
	dict for {testName data} $testData {
		if {[dict get $data status] == 2} {
			puts "Test $testName failed: [dict get $data errormsg]"
		} else {
			puts "Test $testName passed."
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



