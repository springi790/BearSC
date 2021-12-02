package;

import flixel.graphics.FlxGraphic;
import sys.thread.Thread;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

enum PreloadType {
    atlas;
    image;
    image1;
}

class PreloadState extends FlxState {

    var globalRescale:Float = 2/3;
    var preloadStart:Bool = false;

    var loadText:FlxText;
    var assetStack:Map<String, PreloadType> = [
        'bear/bearzerker/ground' => PreloadType.image, 
        'bear/bearzerker/ground1' => PreloadType.image, 
        'bear/bearzerker/ground3' => PreloadType.image,
        'bear/bearzerker/sky' => PreloadType.image,
        'bear/bearzerker/towerhuggable' => PreloadType.image, 
        'bear/bearzerker/WHITE' => PreloadType.image,
        'bear/mecha/bg' => PreloadType.image,
        'bear/mecha/lights' => PreloadType.image,
        'bear/mecha/boxes' => PreloadType.image,
        'bear/mecha/necromancer' => PreloadType.image,
        'bear/mecha/partofground' => PreloadType.image,
        'bear/mecha/pr' => PreloadType.image,
        'bear/mecha/shadow' => PreloadType.image,
        'bear/mecha/thing' => PreloadType.image,
        'bear/mecha/will' => PreloadType.image,
        'bear/necromancer/Balloon' => PreloadType.image,
        'bear/necromancer/Beeear' => PreloadType.image,
        'bear/necromancer/Blu' => PreloadType.image,
        'bear/necromancer/Floor' => PreloadType.image,
        'bear/necromancer/Haaands' => PreloadType.image,
        'bear/necromancer/Heads' => PreloadType.image,
        'bear/necromancer/Sky' => PreloadType.image,
        'characters/BOYFRIEND' => PreloadType.image,
        'characters/bearzerker' => PreloadType.image,
        'characters/bf-bw' => PreloadType.image,
        'characters/BF' => PreloadType.image,
        'characters/BoyFriendDeath_Assets' => PreloadType.image,
        'characters/GF_assets' => PreloadType.image,
        'characters/Dia_assets' => PreloadType.image,
        'characters/Leo' => PreloadType.image,
        'characters/Mecha-Bearzerker' => PreloadType.image,
        'characters/NecroMancer1' => PreloadType.image,
        'characters/Necro' => PreloadType.image,
        'die' => PreloadType.image,
        'time' => PreloadType.image,
        'to' => PreloadType.image,
        'notes/normal' => PreloadType.image,
        'notes/necromancer' => PreloadType.image,
        'noteSplashes' => PreloadType.image,
        'healthBar' => PreloadType.image,
        'icons/icon-bearzerker' => PreloadType.image1,
        'icons/icon-mechabearzerker' => PreloadType.image1,
        'icons/icon-necromancer' => PreloadType.image1,
        'icons/icon-bf' => PreloadType.image1,
        'icons/icon-bf-bearzerker' => PreloadType.image1,
        'icons/icon-bearzombie' => PreloadType.image1,
        'icons/icon-gf' => PreloadType.image1,
    ];
    var maxCount:Int;

    public static var preloadedAssets:Map<String, FlxGraphic>;
    var backgroundGroup:FlxTypedGroup<FlxSprite>;
    var bg:FlxSprite;

    public static var unlockedSongs:Array<Bool> = [false, false];

    override public function create() {
        super.create();

        FlxG.camera.alpha = 0;

        maxCount = Lambda.count(assetStack);
        trace(maxCount);
        // create funny assets
        backgroundGroup = new FlxTypedGroup<FlxSprite>();
        FlxG.mouse.visible = false;

        preloadedAssets = new Map<String, FlxGraphic>();

        bg = new FlxSprite();
		bg.loadGraphic(Paths.image('preloadbg', 'shared'));
        bg.screenCenter();
        bg.updateHitbox();
		backgroundGroup.add(bg);

        var pendulum:FlxSprite = new FlxSprite();
        pendulum.frames = Paths.getSparrowAtlas('Loading Screen Pendelum', 'shared');
        pendulum.animation.addByPrefix('load', 'Loading Pendelum Finished', 24, true);
        pendulum.animation.play('load');
        pendulum.setGraphicSize(Std.int(pendulum.width * globalRescale));
        pendulum.updateHitbox();
        backgroundGroup.add(pendulum);
        pendulum.x = FlxG.width - (pendulum.width + 10);
        pendulum.y = FlxG.height - (pendulum.height + 10);

        add(backgroundGroup);
        FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5, {
            onComplete: function(tween:FlxTween){
                Thread.create(function(){
                    assetGenerate();
                });
            }
        });

        // save bullshit

        loadText = new FlxText(5, FlxG.height - (32 + 5), 0, 'Loading...', 32);
		loadText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    var storedPercentage:Float = 0;

    function assetGenerate() {
        //
        var countUp:Int = 0;
        for (i in assetStack.keys()) {
            trace('calling asset $i');

            FlxGraphic.defaultPersist = true;
            switch(assetStack[i]) {
                case PreloadType.image:
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(i, 'shared'));
                    preloadedAssets.set(i, savedGraphic);
                    trace(savedGraphic + ', Loaded');
                case PreloadType.image1:
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(i));
                    preloadedAssets.set(i, savedGraphic);
                    trace(savedGraphic + ', Loaded');
                case PreloadType.atlas:
                    var preloadedCharacter:Character = new Character(FlxG.width / 2, FlxG.height / 2, i);
                    preloadedCharacter.visible = false;
                    add(preloadedCharacter);
                    trace('character loaded ${preloadedCharacter.frames}');
            }
            FlxGraphic.defaultPersist = false;
        
            countUp++;
            storedPercentage = countUp/maxCount;
            loadText.text = 'Loading... Progress at ${Math.floor(storedPercentage * 100)}%';
        }

        ///*
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {
            onComplete: function(tween:FlxTween){
                FlxG.switchState(new TitleState());
            }
        });
        //*/

    }
}