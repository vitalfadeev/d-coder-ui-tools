module ui.parse.css.display;

import std.stdio : writeln;
import ui.parse.t.tokenize : Tok;


bool parse_display( Tok[] tokenized, ref string[] setters )
{
    // https://developer.mozilla.org/en-US/docs/Web/CSS/display
    // grid: https://developer.mozilla.org/ru/docs/Web/CSS/CSS_Grid_Layout
    // flex: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout
    // flow: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flow_Layout
    //
    // block | inline | run-in
    // flow | flow-root | table | flex | grid

    return false;
}

