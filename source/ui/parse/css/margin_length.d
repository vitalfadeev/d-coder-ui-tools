module ui.parse.css.margin_length;

import ui.parse.t.tokenize : Tok;


bool parse_margin_length( Tok[] tokenized, ref string[] setters )
{
    Length len;

    if ( args.length == 1 )
    {
        auto word = args.front.s;

        if ( parse_length( new StringIterator( word ), &len ) )
        {
            setters ~= format!"marginLeft   = (%f).%s;"( len.length, len.unit );
            setters ~= format!"marginTop    = (%f).%s;"( len.length, len.unit );
            setters ~= format!"marginRight  = (%f).%s;"( len.length, len.unit );
            setters ~= format!"marginBottom = (%f).%s;"( len.length, len.unit );
            return true;
        }
    }

    return false;
}
