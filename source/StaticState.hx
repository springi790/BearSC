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

class StaticState extends MusicBeatState
{
    var video:MP4Handler = new MP4Handler();

    override function create()
    {
        video.playMP4(Paths.video('static'));
		video.finishCallback = function()
		{
		PlayState.SONG = Song.loadEasterEgg('');
	    FlxG.sound.music.stop();
		FlxG.switchState(new PlayState());
		}

        super.create();
    }
}