module ui.parse.parser;

import std.stdio;
import ui.parse.t.parser : Doc;
import std.stdio : File;
import std.file  : exists;
import std.file  : mkdir;
import std.path  : buildPath;

// create .def
// dub build
//   read .def
//     parse
//     write generated/class.d
//     write generated/package.d
//       import all generated/*


bool parse( string fileName )
{
    Doc doc;

    remove_pre_generated();

    parse_t( fileName, &doc );

    generate_style( &doc );
    generate_body( &doc );
    generate_package( &doc );

    return true;
}


void remove_pre_generated()
{
    import std.file  : rmdirRecurse;

    if ( exists( buildPath( "source", "generated" ) ) )
    {
        rmdirRecurse( buildPath( "source", "generated" ) );
    }
}

bool parse_t( string fileName, Doc* doc )
{
    import ui.parse.t.parser : TParser;
    
    auto tparser = new TParser;
    tparser.parseFile( fileName );

    *doc = tparser.doc;

    return true;
}


void generate_body( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated.tree;\n";
    s ~= "\n";
    s ~= "\n";

    s ~= "import ui;\n";
    s ~= "import generated.style;\n";
    s ~= "\n";

    s ~= "void initUI( Document* document )\n";
    s ~= "{\n";
    s ~= "  Element* element;\n";
    s ~= "  Element* parentElement;\n";
    s ~= "  \n";

    s ~= "  // body \n";
    foreach ( className; doc.body.classes )
    s ~= format!"  document.body.addClass!%s;\n"(  className );
    s ~= "  \n";

    foreach ( element; doc.body.childs )
    {
        s ~= format!"    // %s\n"( element.tagName );
        s ~= format!"    element = document.createElement( %s );\n"( element.tagName.quote() );
        foreach ( className; element.classes )
        s ~= format!"    element.addClass!%s;\n"(  className );
        s ~=        "    document.body.appendChild( element );\n";
        s ~=        "    \n";

        if ( element.childs.length > 0 )
        s ~=        "    parentElement = element;\n";
        s ~=        "    \n";

        foreach ( e; element.childs )
        {
            s ~= format!"      // %s\n"( e.tagName );
            s ~= format!"      element = document.createElement( %s );\n"( e.tagName.quote() );
            foreach ( className; element.classes )
            s ~= format!"      element.addClass!%s;\n"(  className );
            s ~=        "      parentElement.appendChild( element );\n";
            s ~=        "      \n";
        }
    }

    s ~= "}\n";

    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "tree.d" ), s );
}


string quote( string s )
{
    return '"' ~ s ~ '"';
}


void generate_style( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated.style;\n";
    s ~= "\n";
    s ~= "\n";
    s ~= "import ui;\n";
    s ~= "\n";

    foreach ( cls; doc.style.classes )
    {
        s ~= format!"struct %s\n"( cls.className );
        s ~=        "{\n";
        s ~= format!"    string name = %s;\n"( cls.className.quote );
        s ~=        "    \n";
        s ~=        "    static\n";
        s ~= format!"    void setter( Element* element )\n";
        s ~=        "    {\n";
        s ~=        "        with ( element.computed )\n";
        s ~=        "        {\n";
        foreach ( setter; cls.setters )
        {
        s ~= format!"            %s\n"( setter );
        }
        s ~=        "        }\n";
        s ~=        "    }\n";
        s ~=        "}\n";
        s ~=        "\n";
    }


    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "style.d" ), s );
}

void createFolder( string path )
{
    if ( !exists( path ) )
    {
        mkdir( path );
    }
}

void writeText( string path, string text )
{
    auto f = File( path, "w" );
    f.write( text );
    f.close();
}

void generate_package( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated;\n";
    s ~= "\n";
    s ~= "public import generated.style;\n";
    s ~= "public import generated.tree;\n";
    s ~= "\n";

    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "package.d" ), s );
}

