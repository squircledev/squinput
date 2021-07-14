if(current_bind != undefined)
{
    text_line(600, 300, text, binds[current_bind]);
}

text_line(0, 0, "Up", sq.CheckButton(0, SQ_BUTTONS.Up));
text_line(0, 16, "Down", sq.CheckButton(0, SQ_BUTTONS.Down));
text_line(0, 32, "Left", sq.CheckButton(0, SQ_BUTTONS.Left));
text_line(0, 48, "Right", sq.CheckButton(0, SQ_BUTTONS.Right));
text_line(0, 64, "Confirm", sq.CheckButton(0, SQ_BUTTONS.Confirm));
text_line(0, 80, "Cancel", sq.CheckButton(0, SQ_BUTTONS.Cancel));
