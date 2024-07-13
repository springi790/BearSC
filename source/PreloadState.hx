package;

import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
#if desktop
import sys.FileSystem;
#end

class PreloadState extends FlxState {

    var globalRescale:Float = 2/3;
    var preloadStart:Bool = false;

    var loadText:FlxText;
    var assetStack:Array<String> = [];
    var maxCount:Int;

    public static var preloadedAssets:Map<String, FlxGraphic>;
    var backgroundGroup:FlxTypedGroup<FlxSprite>;
    var bg:FlxSprite;

    public static var unlockedSongs:Array<Bool> = [false, false];

    override public function create() {
        super.create();
        trace('PreloadState create called');

        FlxG.camera.alpha = 0;

        var imageDirs:Array<String> = 
        ["assets"];

        populateAssetStack(imageDirs);

        maxCount = assetStack.length;
        trace('Max count of assets: ' + maxCount);

        // Create and configure background group
        backgroundGroup = new FlxTypedGroup<FlxSprite>();
        FlxG.mouse.visible = false;

        preloadedAssets = new Map<String, FlxGraphic>();

        bg = new FlxSprite();
        bg.loadGraphic(Paths.image('preloadbg'));
        bg.screenCenter();
        bg.updateHitbox();
        backgroundGroup.add(bg);

        var pendulum:FlxSprite = new FlxSprite();
        pendulum.frames = Paths.getSparrowAtlas('Loading Screen Pendelum');
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
                loadAssets();
            }
        });

        loadText = new FlxText(5, FlxG.height - (32 + 5), 0, 'Please wait, it may take a while, Loading...', 32);
        loadText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(loadText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    var storedPercentage:Float = 0;

    function loadAssets() {
        trace('Asset loading started');
        var countUp:Int = 0;

        for (imagePath in assetStack) {
            trace('Trying to load: ' + imagePath);
            var savedGraphic:FlxGraphic = null;

            if (FileSystem.exists(imagePath)) {
                savedGraphic = FlxG.bitmap.add(imagePath);
                trace('Graphic loaded: ' + imagePath);
            } else {
                trace('File not found: ' + imagePath);
            }

            if (savedGraphic != null) {
                var assetKey = imagePath.substring(imagePath.lastIndexOf('/') + 1, imagePath.lastIndexOf('.'));
                preloadedAssets.set(assetKey, savedGraphic);
                trace(savedGraphic + ', Loaded');
            } else {
                trace('Failed to load asset: ' + imagePath);
            }

            countUp++;
            storedPercentage = countUp / maxCount;
            loadText.text = 'Loading... Progress at ' + Math.floor(storedPercentage * 100) + '%';
        }

        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {
            onComplete: function(tween:FlxTween){
                trace('Switching to TitleState');
                FlxG.switchState(new TitleState());
            }
        });
    }

    function populateAssetStack(baseDir:Array<String>) {
        trace('Populating asset stack');
        function exploreDirectory(path:String):Void {
            trace('Exploring directory: ' + path);
            if (!FileSystem.exists(path)) {
                trace('Directory does not exist: ' + path);
                return;
            }
            for (file in FileSystem.readDirectory(path)) {
                var fullPath = path + "/" + file;
                if (FileSystem.isDirectory(fullPath)) {
                    exploreDirectory(fullPath);
                } else {
                    if (endsWith(fullPath, ".png")) {
                        assetStack.push(fullPath);
                        trace('Added asset: ' + fullPath);
                    }
                }
            }
        }

        for (dir in baseDir) {
            exploreDirectory(dir);
        }
    }

    function endsWith(haystack:String, needle:String):Bool {
        return haystack.length >= needle.length && haystack.substr(haystack.length - needle.length) == needle;
    }
}
