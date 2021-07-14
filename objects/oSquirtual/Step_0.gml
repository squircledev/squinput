var _return = sq.Tick();
show_debug_message(_return);
if(_return == true)
{
    current_bind += 1;
    if(current_bind >= array_length(binds))
    {
        current_bind = undefined;
    }
    else
    {
        text = "Wait...";
        alarm[0] = 60;
    }
}