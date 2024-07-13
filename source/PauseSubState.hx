package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
#if desktop
import sys.io.File;
#end
import haxe.ds.StringMap;
import haxe.Log;

class PauseSubState extends MusicBeatSubstate
{
    var grpMenuShit:FlxTypedGroup<Alphabet>;
    var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
    var curSelected:Int = 0;
    var pauseMusic:FlxSound;
    var charter:String = "";
    var composer:String = "";

    public function new(x:Float, y:Float, ?optionalTexts:Array<{text:String, offsetX:Float, offsetY:Float}>)
    {
        super();

        // Initialize optionalTexts if it's null
        if (optionalTexts == null) {
            optionalTexts = [];
        }

        // Load credits based on the current song
        loadCredits(PlayState.SONG.song);

        pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
        pauseMusic.volume = 0;
        pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

        FlxG.sound.list.add(pauseMusic);

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        bg.scrollFactor.set();
        add(bg);

        var defaultTexts:Array<{text:String, offsetX:Float, offsetY:Float}> = [
            {text: PlayState.SONG.song, offsetX: -20, offsetY: 15},
            {text: CoolUtil.difficultyString(), offsetX: -20, offsetY: 47}
        ];

        var texts:Array<FlxText> = [];
        for (entry in defaultTexts) {
            texts.push(createText(entry.text, FlxG.width + entry.offsetX, entry.offsetY));
        }

        texts.push(createText('Charter: ' + charter, FlxG.width - 20, 79));
        texts.push(createText('Composer: ' + composer, FlxG.width - 20, 111));

        for (entry in optionalTexts) {
            texts.push(createText(entry.text, FlxG.width + entry.offsetX, entry.offsetY));
        }

        for (text in texts) {
            add(text);
        }

        FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
        for (i in 0...texts.length) {
            FlxTween.tween(texts[i], {alpha: 1, y: texts[i].y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 + (i * 0.2)});
        }

        grpMenuShit = new FlxTypedGroup<Alphabet>();
        add(grpMenuShit);

        for (i in 0...menuItems.length)
        {
            var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
            songText.isMenuItem = true;
            songText.targetY = i;
            grpMenuShit.add(songText);
        }

        changeSelection();

        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }

    override function update(elapsed:Float)
    {
        if (pauseMusic.volume < 0.5)
            pauseMusic.volume += 0.01 * elapsed;

        super.update(elapsed);

        var upP = controls.UP_P;
        var downP = controls.DOWN_P;
        var accepted = controls.ACCEPT;

        if (upP)
        {
            changeSelection(-1);
        }
        if (downP)
        {
            changeSelection(1);
        }

        if (accepted)
        {
            var daSelected:String = menuItems[curSelected];

            switch (daSelected)
            {
                case "Resume":
                    close();
                case "Restart Song":
                    FlxG.resetState();
                case "Exit to menu":
                    FlxG.switchState(new MainMenuState());
            }
        }

        if (FlxG.keys.justPressed.J)
        {
            // for reference later!
            // PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
        }
    }

    override function destroy()
    {
        pauseMusic.destroy();
        super.destroy();
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = menuItems.length - 1;
        if (curSelected >= menuItems.length)
            curSelected = 0;

        var bullShit:Int = 0;

        for (item in grpMenuShit.members)
        {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;
            // item.setGraphicSize(Std.int(item.width * 0.8));

            if (item.targetY == 0)
            {
                item.alpha = 1;
                // item.setGraphicSize(Std.int(item.width));
            }
        }
    }

    function createText(content:String, x:Float, y:Float):FlxText
    {
        var text:FlxText = new FlxText(x, y, 0, content, 32);
        text.scrollFactor.set();
        text.setFormat(Paths.font('vcr.ttf'), 32);
        text.updateHitbox();
        text.alpha = 0;
        text.x = FlxG.width - (text.width + 20);
        return text;
    }

    function loadCredits(songName:String):Void
    {
        var lines:Array<String> = File.getContent("assets/data/credits.txt").split("\n");
        var inSection:Bool = false;
        for (line in lines)
        {
            line = trim(line);
            if (line == '[' + songName + ']') {
                inSection = true;
                continue;
            }
            if (inSection) {
                if (StringTools.startsWith(line, "[") && StringTools.endsWith(line, "]")) {
                    break; // End of section
                }
                var parts:Array<String> = line.split(":");
                if (parts.length == 2)
                {
                    var key = trim(parts[0]);
                    var value = trim(parts[1]);
                    switch (key)
                    {
                        case "Charter":
                            charter = value;
                        case "Composer":
                            composer = value;
                    }
                }
            }
        }
    }

    function trim(str:String):String
    {
        var re:EReg = ~/^\s+|\s+$/g;
        return re.replace(str, "");
    }
}
