# xmlVarsHelper

This is a helper for reading variables and configurations stored in an XML File. It just simplifies the data loading and the data accessing. The idea was creating a very general purpose and simple reader, without thinking in special cases and so on. This means that depending on your needs, it may not work. 

## Why use it?

You can do with tdom the same that you can do with this package (actually this package uses tdom for reading the xml file). The point is that with tdom you will have to manage the variable where the tdom structure is stored and you will have to access to the attributes and nodes in a unnatural way (for TCL developers). This package manages the variable where the data is stored and makes the access more naturally for TCL developers.

## Installation

Just download it and use it: You can add it to your source code using the source command or you can also add it to your packages index (and load it with package require).

## Usage

Read the XML using the ReadFile procedure:

```tcl
::xmlVarsHelper::ReadFile xmlfile.xml
```

Read several XML files using the ReadSeveralFiles procedure:
```tcl
::xmlVarsHelper::ReadSeveralFiles [list xmlfile1.xml xmlfile2.xml xmlfile3.xml]
```

Then just access to an attribute using the Get procedure:
```tcl
::xmlVarsHelper::Get [list rootNode nodeName nodeName ... attribute]
```

Or access to a node text:
```tcl
::xmlVarsHelper::Get [list rootNode nodeName nodeName ... nodeName]
```

Take into account that the Get procedure will return the requested value, so you will have to store it in a variable or use it as needed.


Using multiple xml files (check the section limitations):
```tcl
# Read one by one in different parts of the code:
::xmlVarsHelper::ReadFile xmlfile1.xml
::xmlVarsHelper::ReadFile xmlfile2.xml
...
::xmlVarsHelper::ReadFile xmlfileN.xml


# Read all of them together
::xmlVarsHelper::ReadSeveralFiles [list xmlfile1.xml xmlfile2.xml ... xmlfileN.xml]

::xmlVarsHelper::Get [list rootNode1 nodeName nodeName ... attribute]
::xmlVarsHelper::Get [list rootNode2 nodeName nodeName ... attribute]
::xmlVarsHelper::Get [list rootNodeN nodeName nodeName ... attribute]
```

For each file the data can be removed using the **root node name**:
```tcl
::xmlVarsHelper::Remove rootNode
```

Also, all the data can be removed:
```tcl
::xmlVarsHelper::ResetData
```

By default, the Get function's argument is a list with the nodes' path (This is the TCL most natural way). This behavior could be changed modifying the getterFormat variable's value defined in the main namespace:
```tcl
# list (default value)
::xmlVarsHelper::Get [list rootNode nodeName attribute]

# dots
::xmlVarsHelper::Get rootNode.nodeName.attribute

# dash 
::xmlVarsHelper::Get rootNode-nodeName-attribute

# underscore
::xmlVarsHelper::Get rootNode_nodeName_attribute

# plus
::xmlVarsHelper::Get rootNode+nodeName+attribute
```

This character list could be extended, (even with more than one character, with something like ->) but probably this does not help to keep it simple, so I suggest using the default behavior.

## Examples

Let's say that we have an XML file named config.xml describing the configuration of a random editor:
```xml
<config>
	<textfiles>
		<autosave>1</autosave>
		<extension>txt</extension>
	</textfiles>
	<imagefiles allow="1">
		<autosave>0</autosave>
		<extension>img</extension>
	</imagefiles>
	<appearance>
		<theme value="black" allowed="white grey black"/>
		<widgets>
			<font family="Arial" size="14" bold="0"/>
			<button style="3D" styles="3D plain"/>
		</widgets>
	</appearance>
	<about>
		<version major="1" minor="5"/>
		<description>This is an awesome editor</description>
	</about>
</config>
```

We read the xml file:
```tcl
::xmlVarsHelper::ReadFile config.xml
```

After reading it, we could access to the data:
```tcl
# Access to the autosave node content:
set autoSave [::xmlVarsHelper::Get [list config textfiles autosave]]

# Enable some awesome image stuff based on the imagefiles' allow attribute:
if {[::xmlVarsHelper::Get [list config imagefiles allow]]} {
	enableImagesFunctionalities
}

# Show the theme selector:
set currentTheme [::xmlVarsHelper::Get [list config appearance theme value]]
set allowedThemes [::xmlVarsHelper::Get [list config appearance theme allowed]]
ttk::combobox .themeSelector -values $allowedThemes
.themeSelector set $currentTheme 

# Create the about screen:
set majorVersion [::xmlVarsHelper::Get [list config about version major]]
set minorVersion [::xmlVarsHelper::Get [list config about version minor]]
set description  [::xmlVarsHelper::Get [list config about description]]
createAboutScreen $majorVersion $minorVersion $description

```

Maybe this configuration is not needed anymore, so it can be deleted:
```tcl
::xmlVarsHelper::Remove config
```

Several xml files could be loaded simultaneously. Let's say that we have the config1.xml, config2.xml and config3.xml where their root node is config1, config2 and config 3 respectively:

```xml
<config1>
    ...
</config1>
```

```xml
<config2>
    ...
</config2>
```

```xml
<config3>
    ...
</config3>
```

Let's read the files:
```tcl
::xmlVarsHelper::ReadSeveralFiles [list config1.xml config2.xml config3.xml]
```

After using them, maybe we want to remove the data inside config2.xml:
```tcl
::xmlVarsHelper::Remove config2
```

Or maybe for any reason we want to clear all the data:
```tcl
::xmlVarsHelper::ResetData
```

**Note:** During these samples always the filename was the same that the root node name into that file. It has been done in that way just to avoid misunderstandings, but it is not needed (P.E: the file screenConfig.xml could have their root node named as scrConf).

## Limitations
This package depends on the [tdom](http://tdom.org) package, so it cannot be used without it. This readme file does not cover the installation of the tdom package, since it depends on the operating system.

This package supports using several xml files simultaneously, but these xml files' root nodes must have different names, otherwise it will not work.

This package was designed as a simple xml reader, so it does not validate any kind of data, it does not provide any XML functionalities and it does not allow creating new data in the read data structure. Depending on your requirements, you can extend this library, but probably it has more sense for you using tdom.

This package is totally implemented as an XML file reader, so it does not provide any kind of writing functionalities. If you need to implement an extension or a new library that writes the data to a file into the disk, I would suggest avoiding using attributes into your nodes, it will just increase the complexity of the code.

The behavior of the getter cannot be changed after loading the package (Actually, it has not much sense doing it).

Probably there are other not specified limitations.

