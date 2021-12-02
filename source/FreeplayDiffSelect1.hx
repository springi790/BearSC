package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

using StringTools;

class FreeplayDiffSelect1 extends FlxSubState
{
    var blackScreen:FlxSprite;
    var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
    public static var curDifficulty:Int = 1;
    var arrowleft:FlxSprite;
    var arrowright:FlxSprite;
    var choosemode:FlxSprite;
    public static var diffic = "";

    override function create()
    {
        var ui_tex = Paths.getSparrowAtlas('freeplaydiff');

        blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blackScreen.alpha = 0.7;
        add(blackScreen);

        choosemode = new FlxSprite().loadGraphic(Paths.image('choosemode'));
        choosemode.screenCenter();
        add(choosemode);

        arrowleft = new FlxSprite().loadGraphic(Paths.image('arrowleft'));
        arrowleft.screenCenter();
        add(arrowleft);

        arrowright = new FlxSprite().loadGraphic(Paths.image('arrowright'));
        arrowright.screenCenter();
        add(arrowright);

        sprDifficulty = new FlxSprite();
        sprDifficulty.screenCenter();
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('remix', 'REMIX');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		add(sprDifficulty);

        super.create();
    }

    function changeDifficulty(change:Int = 0):Void
        {
            curDifficulty += change;
    
            if (curDifficulty < 0)
                curDifficulty = 3;
            if (curDifficulty > 3)
                curDifficulty = 0;
    
            sprDifficulty.offset.x = 0;
    
            switch (curDifficulty)
            {
                case 0:
                    sprDifficulty.animation.play('easy');
                    sprDifficulty.x = 364;
                    sprDifficulty.y = 300;
                case 1:
                    sprDifficulty.animation.play('normal');
                    sprDifficulty.x = 284;
                    sprDifficulty.y = 321;
                case 2:
                    sprDifficulty.animation.play('hard');
                    sprDifficulty.x = 350;
                    sprDifficulty.y = 302;
                case 3:
                    sprDifficulty.animation.play('remix');
                    sprDifficulty.x = 274;
                    sprDifficulty.y = 321;
            }
            sprDifficulty.alpha = 0;

		FlxTween.tween(sprDifficulty, {alpha: 1}, 0.07);
        }

        

        override function update(elapsed:Float)
        {
                if(FlxG.keys.justPressed.BACKSPACE)
                {
                    FlxG.switchState(new NewFreeplay());
                }
        
               if(FlxG.keys.justPressed.ESCAPE)
                {
                    FlxG.switchState(new NewFreeplay());
                }

                if(FlxG.keys.justPressed.ENTER)
                    {

                        switch (curDifficulty)
			            {
			          	case 0:
				          	diffic = '-easy';
			        	case 2:
					        diffic = '-hard';
				        case 3:
					        diffic = '-remix';
			}

			PlayState.storyDifficulty = curDifficulty;
                        PlayState.SONG = Song.loadFromJsonbearzerker('');
			
			PlayState.campaignScore = 0;

					if (FlxG.sound.music != null)
						FlxG.sound.music.stop();
					FlxG.switchState(new ChangePlayerState());
}
                    if (FlxG.keys.justPressed.RIGHT)
                        changeDifficulty(1);
                    if (FlxG.keys.justPressed.LEFT)
                        changeDifficulty(-1);
                      

                super.update(elapsed);
        }
}