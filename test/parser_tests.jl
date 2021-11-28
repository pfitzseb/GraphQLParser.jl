function default_args(str)
    buf = codeunits(str)
    len = length(buf)
    return buf, 1, len
end

@testset "name" begin
    str = "name"
    @test GraphQLParser.read_name(default_args(str)...)[1] == "name"

    str = "n"
    @test GraphQLParser.read_name(default_args(str)...)[1] == "n"

    str = " \t\r\nname}"
    @test GraphQLParser.read_name(default_args(str)...)[1]  == "name"

    str = "1name}"
    @test_throws ArgumentError GraphQLParser.read_name(default_args(str)...)
end

@testset "Selection" begin
    str = "name"
    GraphQLParser.read_selection(default_args(str)...)[1]

    str = "alias: name"
    GraphQLParser.read_selection(default_args(str)...)[1]
end

@testset "SelectionSet" begin
    str = "{name}"
    GraphQLParser.read_selection_set(default_args(str)...)[1]

    str = "{name1, name2}"
    GraphQLParser.read_selection_set(default_args(str)...)[1]

    str = "{name1, alias2: name2{subfield\n}}"
    GraphQLParser.read_selection_set(default_args(str)...)[1]
end

@testset "number" begin
    str = "0"
    @test GraphQLParser.read_number(default_args(str)...)[1] === 0

    str = "-0"
    @test GraphQLParser.read_number(default_args(str)...)[1] === 0

    str = "11111"
    @test GraphQLParser.read_number(default_args(str)...)[1] === 11111

    str = "0.0"
    GraphQLParser.read_number(default_args(str)...)[1] === 0.0

    str = "0.01"
    @test GraphQLParser.read_number(default_args(str)...)[1] === 0.01

    str = "-0.01"
    @test GraphQLParser.read_number(default_args(str)...)[1] === -0.01

    str = "-0.01e10"
    @test GraphQLParser.read_number(default_args(str)...)[1] === -0.01e10

    str = "1E+10"
    @test GraphQLParser.read_number(default_args(str)...)[1] === 1e10

    str = "1E-10  asd"
    @test GraphQLParser.read_number(default_args(str)...)[1] === 1e-10
end

@testset "Argument" begin
    str = "number: 1E-10"
    @test GraphQLParser.read_argument(default_args(str)...)[1] == Argument("number", 1e-10)

    str = "bool: true"
    @test GraphQLParser.read_argument(default_args(str)...)[1] == Argument("bool", true)

    str = "bool: false"
    @test GraphQLParser.read_argument(default_args(str)...)[1] == Argument("bool", false)

    str = "null: null"
    @test GraphQLParser.read_argument(default_args(str)...)[1] == Argument("null", nothing)

    str = "var: \$variable_name"
    @test GraphQLParser.read_argument(default_args(str)...)[1] == Argument("var", Variable("variable_name"))
end

@testset "Arguments" begin
    str = "(number: 1E-10)"
    @test GraphQLParser.read_arguments(default_args(str)...)[1] == [Argument("number", 1e-10)]

    str = "(number: 1E-10 bool: true)"
    @test GraphQLParser.read_arguments(default_args(str)...)[1] == [Argument("number", 1e-10), Argument("bool", true)]

    @test_throws ArgumentError GraphQLParser.read_arguments(default_args("()")...)
end

@testset "string" begin
    @testset "one line" begin
        str = raw"\"str\""
        @test GraphQLParser.read_string(default_args(str)...)[1] == "str"

        str = raw"\"str\" \"str\""
        @test GraphQLParser.read_string(default_args(str)...)[1] == "str"

        str = raw"\"str\\ \""
        @test GraphQLParser.read_string(default_args(str)...)[1] == "str\\ "

        str = raw"\"\t\""
        @test GraphQLParser.read_string(default_args(str)...)[1] == "\t"

        str = "\"\t\""
        @test GraphQLParser.read_string(default_args(str)...)[1] == "\t"

        str = "\"\t\\\"\""
        @test GraphQLParser.read_string(default_args(str)...)[1] == "\t\""

        str = raw"\"\u3949\""
        @test GraphQLParser.read_string(default_args(str)...)[1] == "\u3949"
    end

    @testset "block" begin
        buf = [0x22, 0x22, 0x22, 0x61, 0x22, 0x22, 0x22] # """a"""
        len = length(buf)
        @test GraphQLParser.read_string(buf, 1, len)[1] == "a"

        buf = [0x22, 0x22, 0x22, 0x61, 0x09, 0x22, 0x22, 0x22] # """a\t"""
        len = length(buf)
        @test GraphQLParser.read_string(buf, 1, len)[1] == "a\t"

        buf = [0x22, 0x22, 0x22, 0x5c, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22] # """\""""""
        len = length(buf)
        @test GraphQLParser.read_string(buf, 1, len)[1] == "\"\"\""

        buf = [0x22, 0x22, 0x22, 0x5c, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22] # """\""""""
        len = length(buf)
        @test GraphQLParser.read_string(buf, 1, len)[1] == "\"\"\""
    end  
end

@testset "Lists" begin
    str = "[1,2,3]"
    @test GraphQLParser.read_list(default_args(str)...)[1] == Any[1,2,3]

    str = """["a","b","c"]"""
    @test GraphQLParser.read_list(default_args(str)...)[1] == Any["a","b","c"]

    str = "[[1,2],[2,3]]"
    @test GraphQLParser.read_list(default_args(str)...)[1] == Any[Any[1,2], Any[2,3]]

    str = "[]"
    @test GraphQLParser.read_list(default_args(str)...)[1] == Any[]
end

@testset "Input Objects" begin
    str = "{}"
    @test GraphQLParser.read_input_object(default_args(str)...)[1] isa GraphQLParser.InputObject

    str = "{field_name: 1}"
    @test GraphQLParser.read_input_object(default_args(str)...)[1] isa GraphQLParser.InputObject

    str = "{field_name: {subfield: \"str\"}}"
    GraphQLParser.read_input_object(default_args(str)...)[1]
end

@testset "type" begin
    str = "Int"
    @test GraphQLParser.read_type(default_args(str)...)[1] == "Int"

    str = "Int!"
    @test GraphQLParser.read_type(default_args(str)...)[1] == "Int!"

    str = "[[[Int!]]]!"
    @test GraphQLParser.read_type(default_args(str)...)[1] == "[[[Int!]]]!"
end

@testset "VariableDefinition" begin
    str = "(\$name: Int)"
    @test GraphQLParser.read_variable_definitions(default_args(str)...)[1] == [VariableDefinition("name", "Int", nothing, nothing)]
    
    str = "(\$name: Int=1)"
    @test GraphQLParser.read_variable_definitions(default_args(str)...)[1] == [VariableDefinition("name", "Int", 1, nothing)]

    str = "(\$name: Int=1, \$name2: [MyType]!)"
    @test GraphQLParser.read_variable_definitions(default_args(str)...)[1] == [VariableDefinition("name", "Int", 1, nothing), VariableDefinition("name2", "[MyType]!", nothing, nothing)]
end

@testset "directives" begin
    str = "@skip"
    @test GraphQLParser.read_directive(default_args(str)...)[1] == Directive("skip", nothing)
    
    str = "@skip(condition: \$val)"
    @test GraphQLParser.read_directive(default_args(str)...)[1] == Directive("skip", [Argument("condition", Variable("val"))])
end

@testset "fragments" begin
    @testset "definition" begin
        # Example 19 from 2021 spec
        str = """
        fragment friendFields on User {
            id
            name
            profilePic(size: 50)
        }"""
        intended_result = FragmentDefinition(
            "friendFields",
            "User",
            nothing,
            SelectionSet(
                [
                    Field(nothing, "id", nothing, nothing, nothing),
                    Field(nothing, "name", nothing, nothing, nothing),
                    Field(nothing, "profilePic", [Argument("size", 50)], nothing, nothing),
                ]
            )
        )
        @test GraphQLParser.read_fragment_definition(default_args(str)...)[1] == intended_result

        str = """
        fragment friendFields on User @skip(cond: \$cond){
            id
            name
            profilePic(size: 50)
        }"""
        intended_result = FragmentDefinition(
            "friendFields",
            "User",
            [
                Directive("skip", [Argument("cond", Variable("cond"))])
            ],
            SelectionSet(
                [
                    Field(nothing, "id", nothing, nothing, nothing),
                    Field(nothing, "name", nothing, nothing, nothing),
                    Field(nothing, "profilePic", [Argument("size", 50)], nothing, nothing),
                ]
            )
        )
        @test GraphQLParser.read_fragment_definition(default_args(str)...)[1] == intended_result
    end

    @testset "spread" begin
        # From example 19 from 2021 spec
        str = """...friendFields("""
        @test GraphQLParser.read_fragment(default_args(str)...)[1] == FragmentSpread("friendFields", nothing)
    end

    @testset "inline" begin
        # From Example 23, 2021 spec
        str = """... on User {
            friends {
                count
            }
        }
        """
        intended_result = InlineFragment(
            "User",
            nothing,
            SelectionSet([
                Field(nothing, "friends", nothing, nothing, SelectionSet([Field(nothing, "count", nothing, nothing, nothing)]))
            ])
        )
        @test GraphQLParser.read_fragment(default_args(str)...)[1] == intended_result
        
        # From Example 24, 2021 spec
        str = """... @include(if: \$expandedInfo) {
            firstName
            lastName
            birthday
            }
        """
        intended_result = InlineFragment(
            nothing,
            [Directive("include", [Argument("if", Variable("expandedInfo"))])],
            SelectionSet([
                Field(nothing, "firstName", nothing, nothing, nothing),
                Field(nothing, "lastName", nothing, nothing, nothing),
                Field(nothing, "birthday", nothing, nothing, nothing),
            ])
        )
        @test GraphQLParser.read_fragment(default_args(str)...)[1] == intended_result
    end
end

@testset "Full Examples" begin
    # Example No 5
    str = """
    mutation {
        likeStory(storyID: 12345) {
            story {
                likeCount
            }
        }
    }
    """
    @test GraphQLParser.read(str) == Document([
        Operation(
            "mutation",
            nothing,
            nothing,
            nothing,
            SelectionSet([Field(
                nothing,
                "likeStory",
                [Argument("storyID", 12345)],
                nothing,
                SelectionSet([Field(
                    nothing,
                    "story",
                    nothing,
                    nothing,
                    SelectionSet([Field(
                        nothing,
                        "likeCount",
                        nothing,
                        nothing,
                        nothing
                    )])
                )])
            )])
        )
    ])

    # Example No 6
    str = """{
        field
    }"""
    @test GraphQLParser.read(str) == Document([
        Operation(
            "query",
            nothing,
            nothing,
            nothing,
            SelectionSet([Field(nothing, "field", nothing, nothing, nothing)])
        )
    ])

    # Example 19
    str = """query withFragments {
        user(id: 4) {
            friends(first: 10) {
                ...friendFields
            }
            mutualFriends(first: 10) {
                ...friendFields
            }
        }
    }

    fragment friendFields on User {
        id
        name
        profilePic(size: 50)
    }
    """
    @test GraphQLParser.read(str) == Document([
        Operation(
            "query",
            "withFragments",
            nothing,
            nothing,
            SelectionSet([
                Field(
                    nothing,
                    "user",
                    [Argument("id", 4)],
                    nothing,
                    SelectionSet([
                        Field(
                            nothing,
                            "friends",
                            [Argument("first", 10)],
                            nothing,
                            SelectionSet([FragmentSpread("friendFields", nothing)])
                        ),
                        Field(
                            nothing,
                            "mutualFriends",
                            [Argument("first", 10)],
                            nothing,
                            SelectionSet([FragmentSpread("friendFields", nothing)])
                        )
                    ])
                )
            ])
        ),
        FragmentDefinition(
            "friendFields",
            "User",
            nothing,
            SelectionSet([
                Field(nothing, "id", nothing, nothing, nothing),
                Field(nothing, "name", nothing, nothing, nothing),
                Field(nothing, "profilePic", [Argument("size", 50)], nothing, nothing),
            ])
        )
    ])

    str = """
    query withNestedFragments {
        user(id: 4) {
            friends(first: 10) {
                ...friendFields
            }
            mutualFriends(first: 10) {
                ...friendFields
            }
        }
    }
    
    fragment friendFields on User {
        id
        name
        ...standardProfilePic
    }
    
    fragment standardProfilePic on User {
        profilePic(size: 50)
    }
    """
    @test GraphQLParser.read(str) == Document([
        Operation(
            "query",
            "withNestedFragments",
            nothing,
            nothing,
            SelectionSet([
                Field(
                    nothing,
                    "user",
                    [Argument("id", 4)],
                    nothing,
                    SelectionSet([
                        Field(
                            nothing,
                            "friends",
                            [Argument("first", 10)],
                            nothing,
                            SelectionSet([FragmentSpread("friendFields", nothing)])
                        ),
                        Field(
                            nothing,
                            "mutualFriends",
                            [Argument("first", 10)],
                            nothing,
                            SelectionSet([FragmentSpread("friendFields", nothing)])
                        )
                    ])
                )
            ])
        ),
        FragmentDefinition(
            "friendFields",
            "User",
            nothing,
            SelectionSet([
                Field(nothing, "id", nothing, nothing, nothing),
                Field(nothing, "name", nothing, nothing, nothing),
                FragmentSpread("standardProfilePic", nothing),
            ])
        ),
        FragmentDefinition(
            "standardProfilePic",
            "User",
            nothing,
            SelectionSet([
                Field(nothing, "profilePic", [Argument("size", 50)], nothing, nothing),
            ])
        )
    ])

    # Examples 25 and 26
    str_25 = """
    mutation {
        sendEmail(message: \"\"\"
            Hello,
                World!

            Yours,
                GraphQL.
        \"\"\")
    }"""
    @test GraphQLParser.read(str_25) == Document([
        Operation(
            "mutation",
            nothing,
            nothing,
            nothing,
            SelectionSet([Field(
                    nothing,
                    "sendEmail",
                    [Argument("message", "Hello,\n    World!\n\nYours,\n    GraphQL.")],
                    nothing,
                    nothing
            )])
        )
    ])

    str_26 = """mutation {
        sendEmail(message: "Hello,\n    World!\n\nYours,\n    GraphQL.")
    }
    """
    @test GraphQLParser.read(str_25) == GraphQLParser.read(str_26)
end