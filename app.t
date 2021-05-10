head
  title: New window
style
  stage
    border: 1px solid
    width:  100px

    on: WM_KEYDOWN VK_SPACE
      {
        addClass( "selected" );
      }
  dark
    border: 2px solid
  intro
    border: 3px solid #0C0
body stage
  e stage dark
  e stage intro

