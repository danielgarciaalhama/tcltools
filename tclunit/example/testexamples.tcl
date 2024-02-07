
source [file join [file dirname [file normalize [info script]]] .. tclunit.tcl]
source [file join [file dirname [file normalize [info script]]] simplemath.tcl]

namespace eval ::testSimpleMath {

	variable one 
	variable two 
	variable three
	variable account
	
	::tclunit::beforeEach {
		variable account
		incr account
	}
	
	
	::tclunit::afterEach {
		variable account
		incr account -1	
	}
	
	::tclunit::setUp {
		variable one 1
		variable two 2
		variable three 3
		variable account 1
	}
	
	::tclunit::tearDown {
		variable one 0
		variable two 0
		variable three 0
		variable account 1
	}
	
	::tclunit::test testSetup {
 	    variable one 
	    variable two 
	    variable three
	    ::tclunit::assertEqualInt $three [::simplemath::add $one $two]
	}
	

	::tclunit::test checkSumOk1 {
	    ::tclunit::assertEqualInt 4 [::simplemath::add 1 3]
	    ::tclunit::assertNotEqualInt 5 [::simplemath::add 2 1]
	}

	::tclunit::test checkSumFails1 {
	    ::tclunit::assertEqualInt 40 [::simplemath::add 7 15]
	    ::tclunit::assertNotEqualInt 50 [::simplemath::add 72 71]
	}

	::tclunit::test checkSumOk2 {
	    ::tclunit::assertEqualInt 77 [::simplemath::add 70 7]
	    ::tclunit::assertNotEqualInt 45 [::simplemath::add 72 71]
	}

	::tclunit::test checkSumOk3 {
	    ::tclunit::assertEqualInt 47 [::simplemath::add 27 20]
	    ::tclunit::assertNotEqualInt 56 [::simplemath::add 262 31]
	}

	::tclunit::test ::checkSumFails2 {
	    ::tclunit::assertEqualInt 4 [::simplemath::add 1 3]
	    ::tclunit::assertNotEqualInt 5 [::simplemath::add 2 3]
	}
}

# WARNING: PUT THE TESTS INSIDE THE NS EVAL COMMAND. THIS WILL WORK BUT INTERNALLY TCLUNIT WILL CONSIDER THE TEST AS A ROOT NS TEST (::)
::tclunit::test ::testSimpleMath::checkSumFails3 {
    ::tclunit::assertEqualInt 4 [::simplemath::add 1 3]
    ::tclunit::assertNotEqualInt 5 [::simplemath::add 2 3]
}

puts "RUN ALL:"
::tclunit::runAll

puts "RUN NS:"
::tclunit::runns ::testSimpleMath

puts "RUN TEST"
::tclunit::runTest ::testSimpleMath checkSumOk2

puts "RUN ALL with run"
::tclunit::run

puts "RUN NS with run"
::tclunit::run ::testSimpleMath

puts "RUN TEST with run:"
::tclunit::run ::testSimpleMath checkSumOk2
