package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;

#if desktop
import Discord.DiscordClient;
#end

import flixel.FlxCamera;

import flixel.tweens.FlxTween;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;

using StringTools;

class FreeplayState extends MusicBeatState
{
    var songs:Array<SongMetadata> = [];
    var selector:FlxText;
	var songTimer:FlxTimer;
    var curSelected:Int = 0;
    var curDifficulty:Int = 1;
    var scoreText:FlxText;
    var diffText:FlxText;
    var lerpScore:Int = 0;
    var intendedScore:Int = 0;
    var fpSelected:String = '';

    private var grpSongs:FlxTypedGroup<Alphabet>;
    private var curPlaying:Bool = false;
    private var iconArray:Array<HealthIcon> = [];

    override function create()
    {
        super.create();

        // Determinar la lista de canciones según el modo seleccionado
        if (FreeplaySelect.curFpSelected == 'newsongs') {
            fpSelected = 'newsongslist';
        } else if (FreeplaySelect.curFpSelected == 'remixes') {
            fpSelected = 'remixeslist';
        }

        // Cargar la lista de canciones
        loadSongList(fpSelected);

        #if windows
        // Actualizar el estado de Discord
        DiscordClient.changePresence("In the Freeplay Menu " + FreeplaySelect.curFpSelected, null);
        #end

        // Configurar el fondo y los elementos UI
        setupUI();

        changeSelection();
        changeDiff();
    }

    function loadSongList(fpSelected:String):Void {
        var initSonglist = CoolUtil.coolTextFile(Paths.txt(fpSelected));
        for (i in 0...initSonglist.length) {
            var data:Array<String> = initSonglist[i].split(':');
            songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
        }
    }

    function setupUI():Void {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
        add(bg);

        grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);

        for (i in 0...songs.length) {
            var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
            songText.isMenuItem = true;
            songText.targetY = i;
            grpSongs.add(songText);

            var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
            icon.sprTracker = songText;

            iconArray.push(icon);
            add(icon);
        }

        scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
        scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

        var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
        scoreBG.alpha = 0.6;
        add(scoreBG);

        diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
        diffText.font = scoreText.font;
        add(diffText);
        add(scoreText);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			{
				Conductor.songPosition = FlxG.sound.music.time;
			}
	
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
	

        lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

        if (Math.abs(lerpScore - intendedScore) <= 10) {
            lerpScore = intendedScore;
        }

        scoreText.text = "PERSONAL BEST: " + lerpScore;

        var upP = controls.UP_P;
        var downP = controls.DOWN_P;
        var accepted = controls.ACCEPT;

        if (upP) {
            changeSelection(-1);
        }
        if (downP) {
            changeSelection(1);
        }

        if (controls.LEFT_P) {
            changeDiff(-1);
        }
        if (controls.RIGHT_P) {
            changeDiff(1);
        }

        if (controls.BACK) {
            FlxG.switchState(new FreeplaySelect());
        }

        if (accepted) {
            startSong();
        }
    }

    function startSong():Void {
        var songLowercase = StringTools.replace(songs[curSelected].songName, " ", "-").toLowerCase();

        var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");

        var poop:String = Highscore.formatSong(songHighscore, curDifficulty);

        PlayState.SONG = Song.loadFromJson(poop, songLowercase);
        PlayState.isStoryMode = false;
        PlayState.storyDifficulty = curDifficulty;
        PlayState.storyWeek = songs[curSelected].week;
        LoadingState.loadAndSwitchState(new PlayState());
    }

    function changeDiff(change:Int = 0):Void {
		if (FreeplaySelect.curFpSelected == 'remixes')
			{
				curDifficulty = 3;
			}
		else if (FreeplaySelect.curFpSelected == 'newsongs')
			{
				curDifficulty = 1;
			}
        

        var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");

        #if !switch
        intendedScore = Highscore.getScore(songHighscore, curDifficulty);
        #end

        switch (curDifficulty) {
            case 0:
                if (FreeplaySelect.curFpSelected == 'remixes') {
                    diffText.text = "REMIX";
                } else if (FreeplaySelect.curFpSelected == 'newsongs') {
                    diffText.text = "NORMAL";
                }
        }
    }

	override function beatHit()
		{
			super.beatHit();
			
			FlxG.camera.zoom += 0.03;
			FlxTween.tween(FlxG.camera, { zoom: 1 }, 0.1);
		}

		function changeSelection(change:Int = 0):Void {
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
			curSelected += change;
		
			if (curSelected < 0) {
				curSelected = songs.length - 1;
			}
			if (curSelected >= songs.length) {
				curSelected = 0;
			}
		
			if (FlxG.sound.music.playing) {
				FlxG.sound.music.stop();
			}
			if (songTimer != null) {
				songTimer.cancel();
				songTimer.destroy();
			}
		
			// Replace spaces with hyphens in the song name
			var songNameFormatted:String = songs[curSelected].songName.replace(' ', '-');
		
			songTimer = new FlxTimer().start(2, function(tmr:FlxTimer) {
				if (FlxG.sound.music.playing) {
					FlxG.sound.music.stop();
				}
				FlxG.sound.playMusic(Paths.inst(songNameFormatted), 0);
				Conductor.changeBPM(Song.loadFromJson(songNameFormatted.toLowerCase(), songNameFormatted.toLowerCase()).bpm);
			}, 1);
		
			var bullShit:Int = 0;
		
			for (i in 0...iconArray.length) {
				iconArray[i].alpha = 0.6;
			}
		
			iconArray[curSelected].alpha = 1;
		
			for (item in grpSongs.members) {
				item.targetY = bullShit - curSelected;
				bullShit++;
		
				item.alpha = 0.6;
		
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}		
}

class SongMetadata
{
    public var songName:String;
    public var week:Int;
    public var songCharacter:String;

    public function new(song:String, week:Int, songCharacter:String)
    {
        this.songName = song;
        this.week = week;
        this.songCharacter = songCharacter;
    }
}
