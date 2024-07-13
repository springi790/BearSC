package;

import flixel.FlxG;
import flixel.FlxSprite;

class ClickableSprite extends FlxSprite
{
    var clickable:Bool;

    public function new(X:Float, Y:Float, Graphic:Null<Dynamic>)
    {
        super(X, Y, Graphic);
        clickable = true; // Por defecto, el sprite es cliclable
        FlxG.mouse.show(); // Mostrar el cursor del mouse (opcional)
    }

    public function setClickable(value:Bool):Void
    {
        clickable = value;
        if (clickable)
        {
            FlxG.mouse.cursor.setHandCursor(); // Cambiar el cursor a mano para indicar que es cliclable
        }
        else
        {
            FlxG.mouse.cursor = FlxG.mouse.cursor.getDefaultCursor(); // Restaurar el cursor por defecto
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (clickable && FlxG.mouse.justPressed())
        {
            if (FlxG.mouse.cursor.getScreenPosition().overlaps(getScreenXY(), true, FlxG.camera))
            {
                onMouseClick(); // Llama a tu función de manejo de clics aquí
            }
        }
    }

    private function onMouseClick():Void
    {
        // Implementa lo que quieras que ocurra cuando se haga clic en el sprite
        trace("Sprite clickeado!");
    }
}
