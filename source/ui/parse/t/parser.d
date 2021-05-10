﻿module ui.parse.t.parser;

//import ui : Element;
import std.traits               : ReturnType;
import std.stdio;
import std.conv                 : to;
import std.string               : stripRight;
import std.algorithm            : startsWith;
import std.file                 : readText;
import std.stdio                : writefln;
import std.stdio                : writeln;
import std.range                : front;
import std.string               : splitLines;
import std.range                : popFront;
import ui.parse.css.number      : parse_number;
import ui.parse.t.tokenize      : Tok;
import ui.parse.t.sectionreader : SectionReader;


struct Doc
{
    ParsedElement head  = { tagName: "head" };
    ParsedElement meta  = { tagName: "meta" };
    StyleSection  style;
    ParsedElement body  = { tagName: "body" };
}

struct ParsedClass
{
    string          className;
    string[]        setters;
    EventCallback[] eventCallbacks;
}

struct StyleSection
{
    ParsedClass*[] classes;
}

struct PropRecord
{
    string name;
    string value;
}

struct PropList
{
    PropRecord[] lst;
    alias lst this;
}

struct ParsedElement
{
    size_t           indentLength;
    string           tagName;
    string[]         classes;
    string[]         setters;
    EventCallback[]  eventCallbacks;
    ParsedElement*   parent;
    ParsedElement*[] childs;
}


struct EventCallback
{
    string   name;      // = "WM_KEYPRESS"
    Tok[]    args;      // = "VK_SPACE"
    string[] eventBody; // = [ "  addClass selected" ]


    auto arg1()
    {
        import std.range : empty;
        import std.range : front;

        return !args.empty ? args.front.s : "";
    }

    /*
    static
    void on( Element* element, Event* event )
    {
        // route by event type
        switch ( event.type )
        {
            case WM_KEYDOWN: on_WM_KEYDOWN( element, event ); break;
            default:
        }
    }

    static
    void on_WM_KEYDOWN( Element* element, Event* event )
    {
        if ( event.code == VK_SPACE )
        {
            element.addClass( "selected" );
        }
    }
    */    
}


class TParser
{
    Doc doc;

    void parseFile( string fileName )
    {
        import std.stdio;
        import std.range      : front;
        import std.range      : empty;
        import std.range      : popFront;
        import std.conv       : to;
        import std.string     : strip;
        import std.string     : stripRight;
        import std.array      : array;
        import std.array      : array;
        import std.algorithm  : map;
        import std.algorithm  : filter;


        string s = readText( fileName );

        auto sectionReader = SectionReader( s );

        //foreach ( section; sectionReader )
        if ( !sectionReader.empty )
        for ( string[] section; !sectionReader.empty; sectionReader.popFront() )
        {
            section = sectionReader.front;

            auto cleaned = 
                section
                    .map!( a => a.stripRight )
                    .filter!( a => a.length > 0 )
                    .array;

            if ( cleaned.length > 0 )
            {
                parseSection( cleaned, 0, &doc );
            }

            if ( sectionReader.empty )
            {
                break;
            }
        }

        dump( &doc );
    }
}


void dump( Doc* doc )
{
    writeln( "doc: ", doc );

    writeln( "style: " );
    foreach ( cls; doc.style.classes )
    {
        writeln( "  ", cls.className );

        foreach( setter; cls.setters )
        {
            writeln( "    ", setter );
        }

        foreach( ecb; cls.eventCallbacks )
        {
            writeln( "    ", ecb );
        }
    }

    writeln( "body: " );
    foreach ( element; doc.body.childs )
    {
        writeln( "  ", *element );

        foreach( e; element.childs )
        {
            writeln( "    ", *e );
        }
    }
}


// body, head, meta
void parseSection( string[] lines, size_t indent, Doc* doc )
{
    import std.range        : front;
    import ui.parse.t.tokenize : tokenize;
    import ui.parse.t.head     : parseSection_head;
    import ui.parse.t.meta     : parseSection_meta;
    import ui.parse.t.style    : parseSection_style;
    import ui.parse.t.body     : parseSection_body;

    const
    string[] sections = 
    [
        "head",
        "meta",
        "style",
        //"script",
        "body",
    ];

    //
    size_t indentLength;
    string line = lines.front;
    Tok[] tokenized = tokenize( line, &indentLength );
    writeln( "lines     : ", lines );
    writeln( "line      : ", line );
    writeln( "tokenized : ", tokenized );
    writeln();

    auto word = tokenized.front.s;

    //
    static
    foreach ( SEC; sections )
    {
        if ( word == SEC )
        {
            mixin ( "parseSection_" ~ SEC ~ "( lines, tokenized, indentLength, doc );" );
        }
    }
}


void attachTo( ParsedElement* newElement, ParsedElement* preElement )
{
    // pre
    //   new
    if ( newElement.indentLength > preElement.indentLength )
    {
        preElement.childs ~= newElement;
        newElement.parent  = preElement;
    }
    else

    // pre
    // new
    if ( newElement.indentLength == preElement.indentLength )
    {
        preElement.parent.childs ~= newElement;
        newElement.parent         = preElement.parent;
    }
    else
    
    //   pre
    // new
    if ( newElement.indentLength < preElement.indentLength )
    {
        // find parent
        auto parent = preElement.parent;
        while ( parent !is null )
        {
            if ( newElement.indentLength > parent.indentLength )
            {
                break;
            }

            parent = parent.parent;
        }

        //
        if ( parent !is null )
        {
            parent.childs ~= newElement;
            newElement.parent = parent;
        }
        else
        {
            assert( 0, "error: can not find parent for: " ~ newElement.tagName );
        }
    }
}


// Aaaa Aaaa Aaaa
//   Aaaa
//   Aaaa
//   Aaaa

// Aaaa Bbbb Bbbb Aaaa Bbbb Bbbb
//   Aaaa
//   Bbbb
//   Bbbb
//
//   Aaaa
//   Bbbb
//   Bbbb

// BlockReader
//   Rule1
//   Rule2
//   delegate1 block
//   delegate2 block

// \n
// \n' '   // small block
// !\n' '  // large block

// char            // block
// char char \n    // block
// char char \n    // block | block
//   char char \n  // block |

// Find Block Start
// find '\n', !' '

// char, char
// line, line
// section, section


