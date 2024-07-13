package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var char:String = 'bf';
	public var isPlayer:Bool = false;
	public var isOldIcon:Bool = false;
	public var iconScale:Float = 1;
	public var iconSize:Float;
	public var defualtIconScale:Float = 1;

	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(?char:String = "bf", ?isPlayer:Bool = false)
	{
		super();

		this.char = char;
		this.isPlayer = isPlayer;

		isPlayer = isOldIcon = false;

		if (FlxG.save.data.antialiasing)
		{
			switch(char)
			{
				case 'bf-pixel', 'senpai', 'senpai-angry', 'spirit', 'gf-pixel':
					antialiasing = false;
				default:
					antialiasing = true;
			}
		}

		changeIcon(char);
		scrollFactor.set();
		
		iconScale = defualtIconScale;
		iconSize = width;
	}

	public function swapOldIcon()
	{
		(isOldIcon = !isOldIcon) ? changeIcon("bf-old") : changeIcon(char);
	}

	public function changeIcon(char:String)
	{
		if (char != 'bf-pixel' && char != 'bf-old' && char != 'bf-dia' && char != 'flippy-blood')
			char = char.split("-")[0];

		var iconPath:String = 'assets/images/icons/icon-' + char + '.png';
		var defaultIconPath:String = 'assets/images/icons/icon-dad.png';

		// Comprobar si el archivo específico existe
		if (sys.FileSystem.exists(iconPath)) {
			loadGraphic(iconPath, true, 150, 150);
			trace ('icon found');
		} else {
			// Cargar el icono predeterminado
			loadGraphic(defaultIconPath, true, 150, 150);
			trace ('there is no icon for this character');
		}

		animation.add(char, [0, 1, 2], 0, false, isPlayer);
		animation.play(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		setGraphicSize(Std.int(iconSize * iconScale));
		updateHitbox();

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
