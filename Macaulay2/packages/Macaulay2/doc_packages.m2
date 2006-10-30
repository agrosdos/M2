document {
     Key => Package,
     Headline => "the class of all packages",
     "A package is a body of Macaulay2 source code devoted to a 
     particular topic.  Many packages are distributed with Macaulay 2, 
     and others are available from various users on the internet.",
     PARA{},
     "See ", TO "packages", " for an overview about using and writing packages.",
     PARA{},
     BOLD "Available packages",
     UL {
	  TO "packages provided with Macaulay 2",
	  {"The directory containing the packages is ", HREF { LAYOUT#"packages",LAYOUT#"packages" }}
	  },
     PARA{},
     BOLD "Functions useful when ", TO "using packages", ".",
     UL {
	  TO needsPackage,
	  TO loadPackage,
	  TO installPackage,
	  TO check,
	  TO debug
	  },
     BOLD "Parts of a package.  See ", TO "creating a package", ".",
     UL {
	  TO newPackage,
	  TO export,
	  TO exportMutable,
	  TO beginDocumentation,
	  TO document,
	  TO TEST
	  },
     BOLD "Functions useful while writing and debugging a package", ".",
     UL {
	  TO "debugging",
	  TO debug,
	  TO check
	  },
     BOLD "Functions which are only rarely used.",
     UL {
	  TO dismiss,
	  TO uninstallPackage,
	  TO use,
	  TO makePackageIndex,
	  TO "loadedPackages"
	  },
     }

document {
     Key => {loadPackage,(loadPackage,String)},
     Headline => "load a package",     
     Usage => "loadPackage PACKAGENAME",
     Inputs => { "PACKAGENAME" => String => "the name of the package" },
     Outputs => { Package => "the package just loaded." },
     Consequences => { {"Loads the package 'PACKAGENAME' which is in the file 'PACKAGENAME.m2'"} },
     PARA { "The file ", TT "PACKAGENAME.m2", " should be on the load ", TO "path", "
    	   and should contain a package named ", TT "PACKAGENAME", "." },
     EXAMPLE {
	  ///loadPackage "FirstPackage"///
	  },
     SeeAlso => {"packages", "an example of a package", needsPackage, load }
     }
document {
     Key => {needsPackage,(needsPackage,String)},
     Headline => "load a package if not already loaded",
     Usage => "needsPackage PACKAGENAME",
     Inputs => { "PACKAGENAME" => "the name of the package" },
     Outputs => { { "either the ", TO Package, " just loaded, or ", TO null, " if the package has already been loaded."} },
     Consequences => { {"Loads the package ", TT "PACKAGENAME", " in the file ", TT "PACKAGENAME.m2"} },
     PARA { "The file ", TT "PACKAGENAME.m2", " should be on the load ", TO "path", " and should contain a package named ", TT "PACKAGENAME", "." },
     PARA { "For example, to load the sample package ", TT "FirstPackage", ":"},
     EXAMPLE {
	  ///needsPackage "FirstPackage"///,
	  ///needsPackage "FirstPackage"///	  
	  },
     "The second time the package was not reloaded.",
     SeeAlso => {"packages", "an example of a package", loadPackage }
     }
document {
     Key => {makePackageIndex,(makePackageIndex, List), (makePackageIndex, Sequence)},
     Headline => "",
     Usage => "makePackageIndex()",
     Consequences => {"Creates a file 'index.html' in your Macaulay2 directory,
     containing links to the documentation for Macaulay2 and
     all installed packages."},
     "This command may need to be run after installing a package via ", TO installPackage, ".",
     PARA {
	 "This command is run each time the program is started, therefore 
	 overwriting this file.  Thus, one can simply restart Macaulay2 to
	 obtain the same consequence."},
     EXAMPLE {
	  "makePackageIndex()"
	  },
     SeeAlso => {"packages"}
     }

document {
     Key => {export, (export,List), (export,Symbol)},
     Headline => "package item: export functions",
     Usage => "export {symbol1,symbol2,...}",
     Inputs => { { TT "{symbol1,symbol2,...}", ", a list of symbols" } },
     Consequences => {"The symbols in the list, which should refer
	  to functions or other symbols defined in the package, are made available 
	  to the user of the package, and are marked non-mutable."},
     "A package can contain the code for many functions, only some 
     of which should be made visible to the user.  The function ", TT "export", " 
     allows one to specify which symbols are to be made visible.
     For an example see ", TO "an example of a package", ".",
     PARA{ "Use ", TO exportMutable, " to export symbols whose values the user is permitted to modify." },
     SeeAlso => {debug}
     }

document {
     Key => {exportMutable, (exportMutable,List), (exportMutable,Symbol)},
     Headline => "package item: export writable variables",
     Usage => "exportMutable(symbol1,symbol2,...)",
     Inputs => { Nothing => { TT "(symbol1,symbol2,...)", ", a sequence of symbols"  } },
     Consequences => {
	  {"the symbols in the sequence, which should refer to variables defined in the package,
	       are made available to the user of the package, in such a way that their values may be modified by the user"}
	 },
     "This function is needed much less frequently than ", TO export, ".  For an example, see ", TO "an example of a package",
     SeeAlso => {export, debug}
     }

document {
     Key => beginDocumentation,
     Headline => "package item: start documentation section",
     Usage => "beginDocumentation()",
     Consequences => { "Initiates the documentation section of a package" },
     PARA {
	  "Documentation for a package, and tests for the package, are 
	  placed after this point in a package file.  This way, documentation can
	  be loaded separately, Macaulay 2 examples in the documentation can
	  be run, and the whole documentation can be stored in a database."},
     PARA { "For an example, see ", TO "an example of a package" },
     SeeAlso => { installPackage, check, "writing documentation" }
     }
document {
     Key => {TEST, (TEST,String), (TEST,List)},
     Headline => "package item: register a test of the package",
     Usage => "TEST s",
     Inputs => { "s" => {"a string or list of strings containing Macaulay2 code"} },
     Consequences => { {"Registers the string ", TT "s", " as a test of the current package"}},
     "This function should only occur in the documentation section of a package.  Use ", TO check, " to run all of the tests
     associated to a package.",
     PARA{},
     "For an example, see ", TO "an example of a package",
     Caveat => "When creating tests, try to insure that they run relatively quickly.",
     SeeAlso => { beginDocumentation, assert }
     }

document {
     Key => {(newPackage,String), newPackage, Date, [newPackage,Date], Authors, [newPackage,Authors], Version, [newPackage, Version],
	  [newPackage,Headline],HomePage, [newPackage,HomePage],[newPackage,DebuggingMode],Email,Name,[newPackage,Configuration],
	  InfoDirSection, [newPackage,InfoDirSection]
	  }, 
     Headline => "package item: start a new package",
     Usage => "newPackage ( title )",
     Inputs => {
	  "title" => "the name of the new package",
	  Version => String => {"the version number of the package.  A version number less than 1.0 indicates that the package is under
	       development, and the user interface may change."},
	  Date => String => "the date of this version of the package",
	  InfoDirSection => String => {"the title of the section in the info page directory where the menu entry for this package should be made"},
	  Headline => String => {"a brief (5-10 words) description of the package"},
	  Authors => List => {"a list of lists of options, one for each author.  The suboptions are of the form
	       ", TT "Name => x", ", ", TT "Email => x", ", or ", TT "HomePage => x", ", where ", TT "x", " is a string."
	       },
	  HomePage => String => "the URI pointing to the home page of the package, if any",
	  DebuggingMode => Boolean => {"whether ", TO "debuggingMode", " should be true during package loading"},
	  Configuration => List => {"a list of configuration options for the package.  The keys and values should be constant expressions,
	       such as strings and integers, not incorporating symbols to be exported by the package (and not yet defined).
	       The first time the package is loaded by the user, unless the ", TT "-q", " option is specified on the ", TT "M2", " command
	       line, these options will be stored in a file in the user's application
	       directory (see ", TO "applicationDirectory", ").  The user can change the configuration by editing the file.  
	       The user can override the configuration settings when loading the package; see ", TO "[loadPackage,Configuration]", " and 
	       ", TO "[needsPackage,Configuration]", ".  The file will be overwritten when a newer version of the package 
	       with different configuration options is loaded, but a backup will be made and the user's settings for the surviving options will be retained.
	       "
	       },
	  },
     Consequences => {"a package is created"},
     EXAMPLE { 
///newPackage("Foo", 
     Version => "1.1", 
     Headline => "making Foo",
     Configuration => { "foo" => 42, "bar" => "x" }
     )///,
          ///endPackage "Foo"///
     	  },
     "The options can be recovered with ", TO "options", " as follows.",
     EXAMPLE lines ///
     	  options Foo
	  oo.Headline
     	  (options Core).Version
     ///,
     PARA { "Here is a template for a typical ", TT "newPackage", " entry in a package."},
     PRE ///newPackage("PACKAGENAME",
    Headline => "one line description",
    Version => 0.1,
    Date => "month XX, 20XX",
    Authors => {
	 {Name => "author1", Email => "email1", HomePage => "url1"}
	 {Name => "author2", Email => "email2", HomePage => "url2"},
	 },
    DebuggingMode => true,
    HomePage => "http://univ.edu/~user/PACKAGENAME/",
    Configuration => {}
    )///,
	SeeAlso => {"packages"}
  }
     
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
