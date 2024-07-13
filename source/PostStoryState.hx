package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;

class PostStoryState extends MusicBeatState {
    private var image:FlxSprite;

    override public function create():Void {
        super.create();

        // Cargar la imagen
        image = new FlxSprite(0, 0);
        image.loadGraphic("assets/images/poststory.png");
        add(image);

        // Centrar la imagen si no es del mismo tamaño que la pantalla
        image.screenCenter();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Si se presiona cualquier tecla, cambiar al siguiente estado
        if (FlxG.keys.justPressed.ANY) {
            FlxG.switchState(new MainMenuState());
        }
    }
}
