# Meta

head
    title Sample
style
    base
        border 3px solid #ccc

        event WM_KEYDOWN VK_SPACE
            addClass selected
            + selected

        event WM_KEYDOWN 
          VK_SPACE
            addClass selected
          VK_ESCAPE
            addClass selected

        event
          WM_KEYDOWN 
            VK_SPACE
              addClass selected
            VK_ESCAPE
              addClass selected

    selected
        border 3px solid #0c0
body
  e base
    border 3px solid

  event WM_KEYDOWN VK_SPACE
      {
          addClass( "selected" );
      }
  event WM_KEYDOWN VK_SPACE
      selected 
        next
          + selected
      body
        send keyPressed VK_SPACE


// style.d
struct base
{
    string name = "base";

    void setter( Element* element )
    {
        with ( element.computed )
        {
            borderWidth = 3.px;
            borderStyle = LineStyle.solid;
            borderColor = Color( #ccc );
        }
    }

    void process_KeyboardKeyEvent( Element* element, KeyboardKeyEvent event )
    {
        if ( event.code == VK_SPACE )
        {
            element.addClass( "selected" );
        }
    }
}
  

border: 1px solid #ccc
    // settters
    borderTopWidth         = 1.px;
    borderRightWidth       = 1.px;
    borderBottomWidth      = 1.px;
    borderLeftWidth        = 1.px;
    borderTopLeftWidth     = 1.px;
    borderTopRightWidth    = 1.px;
    borderBottomLeftWidth  = 1.px;
    borderBottomRightWidth = 1.px;

    computed.border_top_style          = LineStyle.solid;
    computed.border_right_style        = LineStyle.solid;
    computed.border_bottom_style       = LineStyle.solid;
    computed.border_left_style         = LineStyle.solid;
    computed.border_top_left_style     = LineStyle.solid;
    computed.border_top_right_style    = LineStyle.solid;
    computed.border_bottom_left_style  = LineStyle.solid;
    computed.border_bottom_right_style = LineStyle.solid;

    computed.border_top_color          = 0xccc.rgb;
    computed.border_right_color        = 0xccc.rgb;
    computed.border_bottom_color       = 0xccc.rgb;
    computed.border_left_color         = 0xccc.rgb;
    computed.border_top_left_color     = 0xccc.rgb;
    computed.border_top_right_color    = 0xccc.rgb;
    computed.border_bottom_left_color  = 0xccc.rgb;
    computed.border_bottom_right_color = 0xccc.rgb;

1px solid #ccc
    1px
    solid
    #ccc

1px solid #ccc
    width 1px
    style solid
    color #ccc

// css
parse_border           ( in: tokens, out: setters )
    parse_border_width

parse_border_top       ( in: tokens, out: setters )
    parse_border_width

parse_border_top_width ( in: tokens, out: setters )
    parse_border_width

parse_border_width     ( in: tokens, out: setters )
    parse_line_width

parse_line_width ( in: string, out Width( Length ) )
    parse_length

parse_length ( in: string, out Length( float, Unit ) )


//
deps/
  d-coder-ui/
generated/
  classes.d
  tree.d
source/
  app.d
app.t

app.d
-----
import ui;
import generated;

void main()
{
    initUI();
}


// events
window
  WM_KEYDOWN
    focused element
      foreach ( cls; classes )
        if ( cls.process_KeyboardKeyEvent )
          cls.process_KeyboardKeyEvent( element, event )
      element
        process_KeyboardKeyEvent( element, event )

  event( message, code )
  onKeyDown( code )
