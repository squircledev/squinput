global.__sq_gamepad_count = gamepad_get_device_count();
global.__keyboard_keys = [];
array_push(global.__keyboard_keys, 8);
array_push(global.__keyboard_keys, 9);
array_push(global.__keyboard_keys, 13);
array_push(global.__keyboard_keys, 16);
array_push(global.__keyboard_keys, 17);
array_push(global.__keyboard_keys, 18);
array_push(global.__keyboard_keys, 19);
array_push(global.__keyboard_keys, 27);
array_push(global.__keyboard_keys, 32);
array_push(global.__keyboard_keys, 33);
array_push(global.__keyboard_keys, 34);
array_push(global.__keyboard_keys, 35);
array_push(global.__keyboard_keys, 36);
array_push(global.__keyboard_keys, 37);
array_push(global.__keyboard_keys, 38);
array_push(global.__keyboard_keys, 39);
array_push(global.__keyboard_keys, 40);
array_push(global.__keyboard_keys, 44);
array_push(global.__keyboard_keys, 45);
array_push(global.__keyboard_keys, 46);
array_push(global.__keyboard_keys, 65);
array_push(global.__keyboard_keys, 66);
array_push(global.__keyboard_keys, 67);
array_push(global.__keyboard_keys, 68);
array_push(global.__keyboard_keys, 69);
array_push(global.__keyboard_keys, 70);
array_push(global.__keyboard_keys, 71);
array_push(global.__keyboard_keys, 72);
array_push(global.__keyboard_keys, 73);
array_push(global.__keyboard_keys, 74);
array_push(global.__keyboard_keys, 75);
array_push(global.__keyboard_keys, 76);
array_push(global.__keyboard_keys, 77);
array_push(global.__keyboard_keys, 78);
array_push(global.__keyboard_keys, 79);
array_push(global.__keyboard_keys, 80);
array_push(global.__keyboard_keys, 81);
array_push(global.__keyboard_keys, 82);
array_push(global.__keyboard_keys, 83);
array_push(global.__keyboard_keys, 84);
array_push(global.__keyboard_keys, 85);
array_push(global.__keyboard_keys, 86);
array_push(global.__keyboard_keys, 87);
array_push(global.__keyboard_keys, 88);
array_push(global.__keyboard_keys, 89);
array_push(global.__keyboard_keys, 90);
array_push(global.__keyboard_keys, 96);
array_push(global.__keyboard_keys, 97);
array_push(global.__keyboard_keys, 98);
array_push(global.__keyboard_keys, 99);
array_push(global.__keyboard_keys, 100);
array_push(global.__keyboard_keys, 101);
array_push(global.__keyboard_keys, 102);
array_push(global.__keyboard_keys, 103);
array_push(global.__keyboard_keys, 104);
array_push(global.__keyboard_keys, 105);
array_push(global.__keyboard_keys, 106);
array_push(global.__keyboard_keys, 107);
array_push(global.__keyboard_keys, 109);
array_push(global.__keyboard_keys, 110);
array_push(global.__keyboard_keys, 111);
array_push(global.__keyboard_keys, 112);
array_push(global.__keyboard_keys, 113);
array_push(global.__keyboard_keys, 114);
array_push(global.__keyboard_keys, 115);
array_push(global.__keyboard_keys, 116);
array_push(global.__keyboard_keys, 117);
array_push(global.__keyboard_keys, 118);
array_push(global.__keyboard_keys, 119);
array_push(global.__keyboard_keys, 120);
array_push(global.__keyboard_keys, 121);
array_push(global.__keyboard_keys, 122);
array_push(global.__keyboard_keys, 123);

enum SQ_BUTTONS
{
    Up,
    Down,
    Left,
    Right,
    Confirm,
    Cancel,
    Total
}

function SquirtualInput(_controller_count) constructor
{
    controllers = array_create(_controller_count);
    for(var i = 0; i < _controller_count; i++)
    {
        controllers[i] = new SquirtualController();
    }
    
    static BindBegin = function(_controller, _button, _slot)
    {
        controllers[_controller].BindBegin(_button, _slot);
    }
    
    static Tick = function()
    {
        for(var i = 0; i < array_length(controllers); i++)
        {
            var _return = controllers[i].Tick();
            if(_return == true)
            {
                return true;
            }
        }
        return false;
    }
    
    static CheckButtonPressed = function(_controller, _button)
    {
        return controllers[_controller].buttons[_button].pressed;
    }
    
    static CheckButton = function(_controller, _button)
    {
        return controllers[_controller].buttons[_button].held;
    }
    
    static CheckButtonReleased = function(_controller, _button)
    {
        return controllers[_controller].buttons[_button].released;
    }
}

function SquirtualController() constructor
{
    buttons = [];
    binds = [];
    binding = false;
    binding_button = undefined;
    binding_slot = undefined;
    for(var i = 0; i < SQ_BUTTONS.Total; i++)
    {
        buttons[i] = new SquirtualButton();
        binds[i] = [];
    }
    
    static BindBegin = function(_button, _slot)
    {
        binding = true;
        binding_button = _button;
        binding_slot = _slot;
    }
    
    static Bind = function(_button, _slot, _bind)
    {
        binds[_button][_slot] = _bind;
    }
    
    static Unbind = function(_button, _slot)
    {
        
    }
    
    static Tick = function()
    {
        if(binding)
        {
            for(var _kb_array_index = 0; _kb_array_index < array_length(global.__keyboard_keys); _kb_array_index++)
            {
                var _keycode = global.__keyboard_keys[_kb_array_index];
                if(keyboard_check_pressed(_keycode))
                {
                    Bind(binding_button, binding_slot, new SquirtualKeyboardKeyBind(_keycode));
                    binding = false;
                    return true;
                }
            }
            for(var _gp_index = 0; _gp_index < gamepad_get_device_count(); _gp_index++)
            {
                if(gamepad_is_connected(_gp_index))
                {
                    for(var _btn_index = 0; _btn_index < gamepad_button_count(_gp_index); _btn_index++)
                    {
                        if(gamepad_button_value(_gp_index, _btn_index) >= 0.8)
                        {
                            Bind(binding_button, binding_slot, new SquirtualGamepadButtonBind(_gp_index, _btn_index));
                            binding = false;
                            return true;
                        }
                    }
                    for(var _axis_index = 0; _axis_index < gamepad_axis_count(_gp_index); _axis_index++)
                    {
                        if(abs(gamepad_axis_value(_gp_index, _axis_index)) >= 0.8)
                        {
                            Bind(binding_button, binding_slot, new SquirtualGamepadAxisBind(_gp_index, _axis_index, sign(gamepad_axis_value(_gp_index, _axis_index)) * 0.8));
                            binding = false;
                            return true;
                        }
                    }
                }
            }
            for(var _mouse_button = 1; _mouse_button <= mb_middle; _mouse_button++)
            {
                if(mouse_check_button_pressed(_mouse_button))
                {
                    Bind(binding_button, binding_slot, new SquirtualMouseButtonBind(_mouse_button));
                    binding = false;
                    return true;
                }
            }
        }
        else
        {
            for(var _button_index = 0; _button_index < SQ_BUTTONS.Total; _button_index++)
            {
                var _btn = buttons[_button_index];
                var _binds = binds[_button_index];
                
                var _check = false;
                for(var _bind_index = 0; _bind_index < array_length(_binds); _bind_index++)
                {
                    var _bind = _binds[_bind_index];
                    _check = max(_check, _bind.Check());
                }
                
                if(_btn.held == false)
                {
                    if(_check)
                    {
                        _btn.Press();
                    }
                }
                else
                {
                    _btn.pressed = false;
                    if(_check < 0.8)
                    {
                        _btn.Release();
                    }
                }
            } 
        }
        return false;
    }
}

function SquirtualButton() constructor
{
    pressed = false;
    held = false;
    released = false;
    toggled = false;
    
    static Toggle = function(_state = true)
    {
        toggled = _state;
    }
    
    static Press = function(_state = true)
    {
        pressed = _state;
        Hold(_state);
    }
    
    static Hold = function(_state = true)
    {
        held = _state;
    }
    
    static Release = function(_state = true)
    {
        released = _state;
        Hold(!_state);
    }
}

function SquirtualBind() constructor
{
    device = undefined;
    input = undefined;
    threshold = 1;
}

function SquirtualKeyboardKeyBind(_key) : SquirtualBind() constructor
{
    input = _key;
    
    static Check = function()
    {
        return (keyboard_check(input));
    }
}

function SquirtualMouseButtonBind(_mb) : SquirtualBind() constructor
{
    input = _mb;
    
    static Check = function()
    {
        return (mouse_check_button(input));
    }
}

function SquirtualGamepadButtonBind(_device, _gp_button) : SquirtualBind() constructor
{
    device = _device;
    input = _gp_button;
    
    static Check = function()
    {
        return (gamepad_button_value(device, input) >= threshold);
    }
}

function SquirtualGamepadAxisBind(_device, _gp_axis, _threshold) : SquirtualBind() constructor
{
    device = _device;
    input = _gp_axis;
    threshold = _threshold;
    
    static Check = function()
    {
        if(threshold < 0)
        {
            return (gamepad_axis_value(device, input) <= threshold);
        }
        return (gamepad_axis_value(device, input) >= threshold);
    }
}

// FOR NOW, DONT USE THIS... DOCUMENTATION IS FUCKY WUCKY??
function SquirtualGamepadHatBind(_device, _gp_hat, _value) : SquirtualBind() constructor
{
    device = _device;
    input = _gp_hat;
    threshold = _value;
    
    static Check = function()
    {
        return (gamepad_hat_value(device, input) == threshold);
    }
}