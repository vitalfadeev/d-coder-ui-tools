module ui.parse.css.margin;

import std.stdio : writeln;
import ui.parse.t.tokenize : Tok;


bool parse_margin( Tok[] tokenized, ref string[] setters )
{
    // https://developer.mozilla.org/ru/docs/Web/CSS/margin
    //
    // Применяется ко всем четырём сторонам
    // margin: 1em;
    //
    // по вертикали | по горизонтали/
    // margin: 5% auto;
    //
    // сверху | горизонтально | снизу
    // margin: 1em auto 2em;
    //
    // сверху | справа | снизу | слева
    // margin: 2px 1em 0 auto;
    //
    // Глобальные значения
    // margin: inherit;
    // margin: initial;
    // margin: unset;

    // margin: top-right-bottom-left
    // margin: top-bottom right-left
    // margin: top right-left bottom
    // margin: top right bottom left

    // margin: length | percantage | auto

    auto args = tokenized[ 2 .. $ ]; // skip ["border", ":"]

    // margin: args...
    if ( !args.empty )
    {
        auto word = args.front.s;

        if ( args.length == 1 )
        {
            parse_margin_length( args, setters );
            //parse_margin_percentage();
            //parse_margin_auto();
        }
    }
    else

    // margin: <empty>
    {
        import std.conv : to;
        assert( 0, "error: expect margin args: " ~ tokenized.to!string );
        //return false;
    }

    return false;
}

