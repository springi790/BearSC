package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Song.SwagSong;
import PlayState;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.FlxObject;

#if windows
import Discord.DiscordClient;
import Sys;
import sys.FileSystem;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class FreeplaySelect extends MusicBeatState
{
    var curSelected:Int = 0;
    var freeplay:FlxSprite;
    var camGame:FlxCamera;
    public static var curFpSelected:String = '';

    var modes:Array<{normal:FlxSprite, selected:FlxSprite, name:String, state:FlxState}>;

    public static var SONG:SwagSong;
    var curWeek:Int = 0;

    override function create()
    {
        freeplay = new FlxSprite().loadGraphic(Paths.image('freeplaybg'));
        freeplay.screenCenter();
        add(freeplay);

        camGame = new FlxCamera();
		FlxCamera.defaultCameras = [camGame];
        FlxG.cameras.reset(camGame);


        var pasdasd = new FlxMouseControl();
        FlxG.plugins.add(pasdasd);

        FlxG.mouse.visible = true;

        modes = [
            createMode('storymode', 'storymodeselected', 244, 109, 207, 74, new NewFreeplay()),
            createMode('newsongs', 'newsongsselected', 695, 109, 674, 91, new FreeplayState(), 'newsongs'),
            createMode('remixes', 'remixesselected', 695, 404, 671, 379, new FreeplayState(), 'remixes')
        ];

        super.create();
    }

    function createMode(normalGraphic:String, selectedGraphic:String, x:Float, y:Float, selX:Float, selY:Float, state:FlxState, name:String = ''): {normal:FlxSprite, selected:FlxSprite, name:String, state:FlxState} {
        var normalSprite = new FlxSprite(x, y).loadGraphic(Paths.image(normalGraphic));
        normalSprite.antialiasing = true;
        add(normalSprite);

        var selectedSprite = new FlxSprite(selX, selY).loadGraphic(Paths.image(selectedGraphic));
        selectedSprite.visible = false;
        selectedSprite.antialiasing = true;
        add(selectedSprite);

        return {normal: normalSprite, selected: selectedSprite, name: name, state: state};
    }

    override function update(elapsed:Float)
    {
        if(FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
        {
            LoadingState.loadAndSwitchState(new MainMenuState());
        }

        for (mode in modes)
        {
            handleMouseOverlap(mode);
        }

        super.update(elapsed);
    }

    function handleMouseOverlap(mode:{normal:FlxSprite, selected:FlxSprite, name:String, state:FlxState}):Void
    {
        if (FlxG.mouse.overlaps(mode.normal))
        {
            mode.selected.visible = true;
            if (FlxG.mouse.justPressed)
            {
                if (mode.name != '')
                {
                    curFpSelected = mode.name;
                }
                LoadingState.loadAndSwitchState(mode.state);
            }
        }
        else
        {
            mode.selected.visible = false;
        }
    }
}
