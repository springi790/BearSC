package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Song.SwagSong;
import PlayState;

#if windows
import Discord.DiscordClient;
import Sys;
import sys.FileSystem;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class NewFreeplay extends MusicBeatState
{
    var blackScreen:FlxSprite;

    var songs:Array<SongMetadata> = [];
    var curSelected:Int = 0;

    var freeplay:FlxSprite;
    public static var thebearzerker:FlxSprite;
    // making public is the only solution LOL
    var underconstruction:FlxSprite;
    var mechabearzerker:FlxSprite;
    public static var thebearzerkerselected:FlxSprite;
    public static var mechabearzerkerselected:FlxSprite;
    public static var SONG:SwagSong;
    var curWeek:Int = 0;

    override function create()
    {
        
        var pasdasd = new FlxMouseControl();
		FlxG.plugins.add(pasdasd);

        FlxG.mouse.visible = true;

       blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
       add(blackScreen);

       freeplay = new FlxSprite().loadGraphic(Paths.image('freeplay'));
       freeplay.screenCenter();
       add(freeplay);

       thebearzerker = new FlxSprite(0, 178).loadGraphic(Paths.image('thebearzerker'));
       add(thebearzerker);

       thebearzerkerselected = new FlxSprite(0, 178).loadGraphic(Paths.image('thebearzerkerselected'));
       thebearzerkerselected.visible = false;
       add(thebearzerkerselected);

       mechabearzerker = new FlxSprite(437, 177).loadGraphic(Paths.image('mechabearzerker'));
       add(mechabearzerker);

       mechabearzerkerselected = new FlxSprite(437, 177).loadGraphic(Paths.image('mechabearzerkerselected'));
       mechabearzerkerselected.visible = false;
       add(mechabearzerkerselected);

       underconstruction = new FlxSprite(873, 177).loadGraphic(Paths.image('underconstruction'));
       add(underconstruction);

        super.create();
    }

    override function update(elapsed:Float)
        {
                if(FlxG.keys.justPressed.BACKSPACE)
                {
                    FlxG.switchState(new MainMenuState());
                }
        
               if(FlxG.keys.justPressed.ESCAPE)
                {
                    FlxG.switchState(new MainMenuState());
                }

                if (FlxG.mouse.overlaps(thebearzerker))
                {
                thebearzerkerselected.visible = true;
                thebearzerker.visible = false;
                }
                else
                {
                thebearzerkerselected.visible = false;
                thebearzerker.visible = true;
                }
                    

                if (FlxG.mouse.overlaps(mechabearzerker))
                {
                mechabearzerkerselected.visible = true;
                }
                else
                {
                mechabearzerkerselected.visible = false;
                }

                if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(mechabearzerker))
                {
                   openSubState(new FreeplayDiffSelect(curWeek = 1));
                }
                
                if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(thebearzerker))
                {
                    openSubState(new FreeplayDiffSelect1(curWeek = 1));
                }

                if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(underconstruction))
                    {
                        PlayState.SONG = Song.loadFromJsonarch('');
					if (FlxG.sound.music != null)
						FlxG.sound.music.stop();
					FlxG.switchState(new ChangePlayerState());
                    }

                super.update(elapsed);
        }
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}