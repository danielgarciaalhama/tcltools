
source {/home/badchicken/tcltools/tclunit/tclunit.tcl}
source [file join [file dirname [file normalize [info script]]] simplemath.tcl]

::tclunit::test ::checkSumOk1 {
    ::tclunit::assertEqualInt 4 [::simplemath::add 1 3]
    ::tclunit::assertNotEqualInt 5 [::simplemath::add 2 1]
}

::tclunit::test ::checkSumFails1 {
    ::tclunit::assertEqualInt 40 [::simplemath::add 7 15]
    ::tclunit::assertNotEqualInt 50 [::simplemath::add 72 71]
}

::tclunit::test ::checkSumOk2 {
    ::tclunit::assertEqualInt 77 [::simplemath::add 70 7]
    ::tclunit::assertNotEqualInt 45 [::simplemath::add 72 71]
}

::tclunit::test ::checkSumOk3 {
    ::tclunit::assertEqualInt 47 [::simplemath::add 27 20]
    ::tclunit::assertNotEqualInt 56 [::simplemath::add 262 31]
}

::tclunit::test ::checkSumFails2 {
    ::tclunit::assertEqualInt 4 [::simplemath::add 1 3]
    ::tclunit::assertNotEqualInt 5 [::simplemath::add 2 3]
}
