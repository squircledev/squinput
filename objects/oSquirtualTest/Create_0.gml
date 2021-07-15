binds = ["Up", "Down", "Left", "Right", "Confirm", "Cancel"];
current_bind = 0;

sq = new SquirtualInput(1);

text_line = function(_x, _y, _input_name, _value)
{
    draw_text(_x, _y, string(_input_name) + ": " + string(_value));
}

alarm[0] = 60;

text = "Wait...";