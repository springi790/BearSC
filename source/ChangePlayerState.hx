package;

import openfl.display.Preloader.DefaultPreloader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.ui.FlxVirtualPad;
import flixel.effects.FlxFlicker;

using StringTools;

class ChangePlayerState extends MusicBeatState
{


    var bflist:Array<String> = ['BOYFRIEND', 'DIA'];

	var curSelected:Int = 0;



	var BG:FlxSprite;


	var arrowsz_left:FlxSprite;
	var arrowsz_right:FlxSprite;

	var characters:FlxSprite;
	var characters1:FlxSprite;

	var curselected_text:FlxText;

	var selected:Bool = false;

	var icon:FlxSprite;


	override function create()
	{

        //bg
		BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/BG1.png');

		//characterselect_text
		var characterselect_text:Alphabet = new Alphabet(0, 0, "character select", true, false);
		characterselect_text.screenCenter();
		characterselect_text.y = 50;


		//curselected_text
		curselected_text = new FlxText(0, 10, bflist[0], 24);
		curselected_text.alpha = 0.5;
		curselected_text.x = (FlxG.width) - (curselected_text.width) - 25;



		// arrowsz
		arrowsz_left = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/arrowsz_left.png');

		arrowsz_right = new FlxSprite(arrowsz_left.width, 0).loadGraphic('assets/images/charSelect/arrowsz_right.png');



		// characters
		characters = new FlxSprite();
		characters.screenCenter();

		characters.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/selectbf.png', 'assets/images/charSelect/selectbf.xml');
		characters.antialiasing = true;
		
		characters.animation.addByPrefix('bf', 'bf', 24);
		characters.animation.addByPrefix('dia', 'dia', 24);

		characters.animation.addByPrefix('diaselect', 'player2hey', 24);
		characters.animation.addByPrefix('bfselect', 'boyfriendhey', 24);

		
		characters.updateHitbox();
		
		characters.setGraphicSize(Std.int(275));
		
		characters.x = (FlxG.width / 2) - (characters.width / 2);
		characters.y = (FlxG.height / 2) - (characters.height / 2);







		icon = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/frame1.png');


		icon.screenCenter();

		icon.y = FlxG.height - 200;

		//trace(BG.height);


        add(BG);

		add(arrowsz_left);
		add(arrowsz_right);

		add(curselected_text);
        add(characterselect_text);
		add(characters);
		add(characters1);


		add(icon);

		changeSelection(0);

		super.create();
	}



	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT){
			switch curSelected{
				case 0:
					characters.animation.play('bfselect');
				case 1:
					characters.animation.play('diaselect');
				default:
					characters.animation.play('bfselect');

			}
			
			
			selected = true;
			PlayState.bfsel = curSelected;

			
			FlxG.sound.play(Paths.sound('confirmMenu'));

			FlxFlicker.flicker(characters, 1.1, 0.04);

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});		
		
	}


			if (controls.RIGHT_P){
				changeSelection(1);
			}
	
			if (controls.LEFT_P){
				changeSelection(-1);
			}
		

		if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}

			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(arrowsz_left))
                {
					changeSelection(-1);
                }
                
                if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(arrowsz_right))
                {
                    changeSelection(1);
                }

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
		{
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = bflist.length - 1;
			if (curSelected >= bflist.length)
				curSelected = 0;
			trace(curSelected);
	
			curselected_text.text = bflist[curSelected];

			icon.loadGraphic('assets/images/charSelect/frame' + (curSelected + 1) + '.png');


			switch curSelected{
				case 0:
					characters.animation.play('bf');
					BG.loadGraphic('assets/images/charSelect/BG1.png');
				case 1:
					characters.animation.play('dia');
					BG.loadGraphic('assets/images/charSelect/BG2.png');
				default:
					characters.animation.play('bf');
					BG.loadGraphic('assets/images/charSelect/BG1.png');

			}

	
		}
}