module ui.parse.t.event;

import ui.parse.t.tokenize : Tok;
import ui.parse.t.parser : EvemtCallback;

bool parse_event( R )( R range, Tok[] tokenized, EvemtCallback[] evemtCallbacks )
{
    auto args = tokenized[ 2 .. $ ]; // skip ["event", ":"]

    // event: args...
    if ( !args.empty )
    {
        auto eventName = args.front.s; // = WM_KEYDOWN

        switch ( eventName )
        {
            case "WM_KEYDOWN":
            {
                auto eventKeyCodeName = args.drop(1).front.s; // = VK_SPACE

                static
                foreach ( KEY_CODE_NAME; ui.keycodes. enum )
                {
                    if ( eventKeyCodeName == KEY_CODE_NAME )
                    {
                        //
                    }
                }

                break;
            }

            default:
        }
    }
}

/*
    void process_KeyboardKeyEvent( Element* element, KeyboardKeyEvent event )
    {
        if ( event.code == VK_SPACE )
        {
            element.addClass( "selected" );
        }
    }
*/
