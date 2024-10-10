# tclUnit

This tclUnit library should be considered as a starting point for creating a bigger unit testing suite for TCL. For now, appart of the core, it only contains the assertEqualInt and assertNotEqualInt functions for checking the results and they didn't check the variables types, so it will work even for other types of data. Actually, TCL has this internal "magic" that automatically cast types from Int to Strings and viceversa according on how the variable is used, storing the values both in Integer and String (for example expr {8 == "8"} will return 1, and expr {8+"8"} will return 16. Feel free to add new functions like assertIsInt and so on.


## Installation

Just download it and use it: You can add it to your source code using the source command or you can also add it to your packages index (and load it with package require).

## Usage

Before use it, take into account to order the unit test by namespace because the tests are run based on the namespace where they are defined. If you do not separate the tests of different namespace into different namespaces, they will be considered as a part of the same namespace. In other words, if you have two namespaces named car and bike, if you define everything in a namespace named ::tests, everything will be considered as a part of the same namespace and you will not able to run them independently by namespace (the beforeEach, afterEach, setUp and tearDown functions will not be independent and cannot be dupplicated).  In that case, I recommend defining the tests in namespaces named carTest and bikeTest.

The best way to learn it is just checking the simple example added at examples. The file simplemath.tcl contains a simple addition procedure. Inside the testexamples.tcl you can find how the library is used for testing this simplemath.tcl file.

A brief summary (you can find the examples in the testexamples.tcl file):

Define what to do before each unit test:
```tcl
::tclunit::beforeEach {
   ...
}
```

Define what to do after each unit test:
```tcl
::tclunit::afterEach {
   ...
}
```

Define what to do before running the unit tests for this namespace. Take into account that if you are using TclOO this will apply to each object, since in TclOO each objects create his own namespace.
```tcl
::tclunit::setUp {
   ...
}
```

Define what to do after running the unit tests for this namespace. Take into account that if you are using TclOO this will apply to each object, since in TclOO each objects create his own namespace.
```tcl
::tclunit::tearDown {
   ...
}
```

The test command is used to define the tests. The idea is like defining a procedure, but using ::tclunit::test instead of using the proc command:
```tcl
::tclunit::test TESTNAME {
   ...
}
# Test example:	
::tclunit::test checkSumOk1 {
    ::tclunit::assertEqualInt 4 [::simplemath::add 1 3]
    ::tclunit::assertNotEqualInt 5 [::simplemath::add 2 1]
}
```

After defining all the test, it is as easy as:

Run all the tests:
```tcl
::tclunit::run
```

Run all the tests inside one specific namespace
```tcl
::tclunit::run namespace
# Example:
::tclunit::run ::carTest
```

Run a single unit test:
```tcl
::tclunit::run namespace testname
#Example
::tclunit::run ::carTest checkLightsOn
```


