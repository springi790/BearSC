package;

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.util.FlxColor;
import flixel.FlxG;

using StringTools;

class OptionsAdvisor extends MusicBeatState
{
    var text:FlxText;
    var bg:FlxSprite;

    override public function create()
    {
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));
        bg.screenCenter();
        bg.alpha = 0.5;
        add(bg);

        var txt:FlxText = new FlxText(0, 0, FlxG.width,
            "\nHello, thank you for downloading our Mod / Hola, gracias por descargar nuestro Mod"
            + "\n"
			+ "\nPlease Make sure to have all your options right for better experience"
			+ "\n------------------------"
			+ "\nPorfavor asegurate de tener todos tus ajustes correctos para una mejor experiencia"
            + "\n"
			+ "\nEn el directorio del juego hay una nota con las opciones sugeridas"
            + "\n------------------------"
            + "\nIn the game directory there is a note with suggested options",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
        
        var txt:FlxText = new FlxText(168, 22, FlxG.width,
            "Press ENTER to go to the Menu or ESC to go to Options", 16);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE);
		add(txt);

        super.create();
    }

    override public function update(elapsed:Float)
    {

        if (FlxG.keys.justPressed.ENTER)
            {
                FlxG.switchState(new MainMenuState());
            }
        if (FlxG.keys.justPressed.ESCAPE)
            {
               FlxG.switchState(new OptionsMenu());
            }
        
        super.update(elapsed);
    }
}