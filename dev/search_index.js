var documenterSearchIndex = {"docs":
[{"location":"private/#Private","page":"Private","title":"Private","text":"","category":"section"},{"location":"private/","page":"Private","title":"Private","text":"Package internals documentation.","category":"page"},{"location":"private/#Parsing","page":"Private","title":"Parsing","text":"","category":"section"},{"location":"private/","page":"Private","title":"Private","text":"Parsing is currently part of the private API as the output types are liable to change. Once this has stabilised, this will move to the public API.","category":"page"},{"location":"private/","page":"Private","title":"Private","text":"GraphQLParser.parse","category":"page"},{"location":"private/#GraphQLParser.parse","page":"Private","title":"GraphQLParser.parse","text":"parse(str::AbstractString)\n\nParses a GraphQL executable document string.\n\n\n\n\n\n","category":"function"},{"location":"private/#Miscellaneous","page":"Private","title":"Miscellaneous","text":"","category":"section"},{"location":"private/","page":"Private","title":"Private","text":"Modules = [GraphQLParser]\nFilter = t -> !in(t, (GraphQLParser.parse,))\nPublic = false","category":"page"},{"location":"private/#GraphQLParser.ValidationError","page":"Private","title":"GraphQLParser.ValidationError","text":"ValidationError\n\nAbstract type for validation errors.\n\n\n\n\n\n","category":"type"},{"location":"private/#GraphQLParser.format_block_string-Tuple{Any}","page":"Private","title":"GraphQLParser.format_block_string","text":"format_block_string(str)\n\nPerform the formatting defined in the specification.\n\n\n\n\n\n","category":"method"},{"location":"private/#GraphQLParser.get_defined_fragments-Tuple{GraphQLParser.Document}","page":"Private","title":"GraphQLParser.get_defined_fragments","text":"get_defined_fragments(doc::Document)\n\nReturns a vector of all fragments that are defined in the document.\n\n\n\n\n\n","category":"method"},{"location":"private/#GraphQLParser.get_defined_operations-Tuple{GraphQLParser.Document}","page":"Private","title":"GraphQLParser.get_defined_operations","text":"get_defined_operations(doc::Document)\n\nReturns a generator over all operations that are defined in the document.\n\n\n\n\n\n","category":"method"},{"location":"public/#Public","page":"Public","title":"Public","text":"","category":"section"},{"location":"public/","page":"Public","title":"Public","text":"Documentation for GraphQLParser's public interface.","category":"page"},{"location":"public/","page":"Public","title":"Public","text":"Modules = [GraphQLParser]\nPublic = true\nPrivate = false","category":"page"},{"location":"public/#GraphQLParser.is_valid_executable_document-Tuple{String}","page":"Public","title":"GraphQLParser.is_valid_executable_document","text":"is_valid_executable_document(str::String; throw_on_error=false)\n\nReturns a Bool indicating whether the document described by str is valid.\n\nThe document is parsed and some validation performed. For further information see validate_executable_document and package documentation.\n\nTo throw an exception if a validation error is found, set throw_on_error to true. (Note, parsing errors will always throw an exception).\n\nTo retrieve a list of validation errors in the document, use validate_executable_document instead.\n\n\n\n\n\n","category":"method"},{"location":"public/#GraphQLParser.validate_executable_document-Tuple{String}","page":"Public","title":"GraphQLParser.validate_executable_document","text":"validate_executable_document(str::String)\n\nReturn a list of validation errors in the GraphQL executable document described by str.\n\nFirstly the document will be parsed with any parsing errors being immediately thrown.\n\nSecondly, the parsed document will be validated against some of the specification with all validation errors being returned. See the package documentation for a full description of what validation is performed.\n\n\n\n\n\n","category":"method"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = GraphQLParser","category":"page"},{"location":"#GraphQLParser","page":"Home","title":"GraphQLParser","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A Julia package to parse and validate GraphQL executable documents","category":"page"},{"location":"","page":"Home","title":"Home","text":"Documentation for GraphQLParser.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The package can be installed with Julia's package manager, either by using the Pkg REPL mode (press ] to enter):","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> add GraphQLParser","category":"page"},{"location":"","page":"Home","title":"Home","text":"or by using Pkg functions","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Pkg; Pkg.add(\"GraphQLParser\")","category":"page"},{"location":"#Use","page":"Home","title":"Use","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package can be used to check whether a document is valid","category":"page"},{"location":"","page":"Home","title":"Home","text":"using GraphQLParser\n\ndocument = \"\"\"\nquery myQuery{\n    findDog\n}\n\"\"\"\n\nis_valid_executable_document(document)\n# true","category":"page"},{"location":"","page":"Home","title":"Home","text":"Or return a list of validation errors","category":"page"},{"location":"","page":"Home","title":"Home","text":"using GraphQLParser\n\ndocument = \"\"\"\nquery myQuery{\n    findDog\n}\n\nquery myQuery{\n    findCat\n}\n\"\"\"\n\nerrors = validate_executable_document(document)\nerrors[1]\n# GQLError\n#       message: There can only be one Operation named \"myQuery\".\n#      location: Line 1 Column 1\nerrors[2]\n# GQLError\n#       message: There can only be one Operation named \"myQuery\".\n#      location: Line 5 Column 1","category":"page"},{"location":"#Validation","page":"Home","title":"Validation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"validate_executable_document performs validation that does not require the schema and therefore does not fully validate the document as per the GraphQL specification. The validation performed includes:","category":"page"},{"location":"","page":"Home","title":"Home","text":"5.2.1.1 Named operation uniqueness\n5.2.2.1 Lone anonymous operation\n5.4.2 Argument Uniqueness\n5.5.1.1 Fragment name uniqueness\n5.5.1.4 Fragments must be used\n5.5.2.1 Fragment spread target defined\n5.6.3 Input Object Field Uniqueness\n5.7.3 Directives Are Unique Per Location\n5.8.1 Variable Uniqueness\n5.8.3 All Variable Uses Defined\n5.8.4 All Variables Used","category":"page"}]
}
