package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;
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

class VideoState extends MusicBeatState
{
    var video:MP4Handler = new MP4Handler();
    var videoName = PlayState.videoName;

    override function create()
    {
        video.playMP4(Paths.video(videoName));
        trace('video: ' + videoName);
        FlxG.sound.music.stop();
		video.finishCallback = function()
		{
		switch (videoName)
        {
            case 'funkindie':
                {
                    #if desktop
                    Sys.exit(0);
                    #end
                    trace ('CRASH!');
                }
            case 'static':
                {
                    PlayState.SONG = Song.loadEasterEgg('');
                    LoadingState.loadAndSwitchState(new PlayState());
                }
            case 'rage':
                {
                    LoadingState.loadAndSwitchState(new PlayState());
                }
            case 'porqueagregoesto':
                {
                    LoadingState.loadAndSwitchState(new PlayState());
                }
        }
		}

        super.create();
    }
}