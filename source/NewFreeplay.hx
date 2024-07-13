package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import Song.SwagSong;
import PlayState;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

#if windows
import Discord.DiscordClient;
import Sys;
import sys.FileSystem;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

// Define a structure to hold sprite data
typedef SpriteData = {
    var sprite:FlxSprite;          // The main sprite
    var selectedSprite:FlxSprite;  // The sprite displayed when the main sprite is selected
    var id:String;                 // The ID associated with the sprite
};

class NewFreeplay extends MusicBeatState
{
    var blackScreen:FlxSprite;     // Black screen background
    var freeplay:FlxSprite;        // Freeplay sprite
    public static var songID:String = '';  // ID of the current selected song
    public static var SONG:SwagSong;
    var curWeek:Int = 0;           // Current week (not used in this snippet)
    var curSelected:Int = 0;       // Current selected index (not used in this snippet)
    var necromancerSprite:FlxSprite; // The necromancer sprite
    var lock:FlxSprite;
    var selectedSprite:FlxSprite;
    var spriteData:Array<SpriteData> = []; // Array to hold sprite data structures
    var lastSongID:String = '';    // To keep track of the last song ID for detecting changes
    private var storyCompleteSave:FlxSave;
    private var isStoryModeCompleted:Bool;
    public static var necromancerlocked:Bool;
    private var lockOpened:Bool = false;
    private var lockOffsetX:Float = 0; // Offset for the lock animation on the X axis
    private var lockOffsetY:Float = 0; // Offset for the lock animation on the Y axis

    override function create()
    {
        // Initialize mouse control plugin
        var mouseControl = new FlxMouseControl();
        FlxG.plugins.add(mouseControl);

        // Make mouse visible
        FlxG.mouse.visible = true;

        storyCompleteSave = new FlxSave();

        if (storyCompleteSave.bind("storycomplete"))
        {
            if (storyCompleteSave.data.storyComplete == null)
            {
                isStoryModeCompleted = false;
                necromancerlocked = true;
                storyCompleteSave.data.lockOpened = false;
                storyCompleteSave.flush();
            }
            else
            {
                isStoryModeCompleted = true;
                necromancerlocked = false;
                lockOpened = storyCompleteSave.data.lockOpened;
            }
        }
        trace('necromancer locked?: ' + necromancerlocked);
        trace('lock opened?: ' + lockOpened);

        // Create and add black screen background
        blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(blackScreen);

        // Create and add freeplay sprite
        freeplay = new FlxSprite().loadGraphic(Paths.image('freeplay'));
        freeplay.screenCenter();
        freeplay.antialiasing = true;
        add(freeplay);

        // Initialize sprite data with their positions and IDs
        addSprite('thebearzerker', 0, 178, 'the-bearzerker');
        addSprite('mechabearzerker', 437, 177, 'mecha-bearzerker');
        addNecromancerSprite('necromancer', 873, 177, 'necromancer');

        if (!lockOpened)
        {
            initializeLockSprite();
        }

        super.create();
    }

    // Function to add a sprite and its selected version to the game
    function addSprite(imageName:String, x:Float, y:Float, id:String)
    {
        // Create main sprite
        var sprite = new FlxSprite(x, y).loadGraphic(Paths.image(imageName));
        sprite.antialiasing = true;
        add(sprite);

        // Create selected sprite
        selectedSprite = new FlxSprite(x, y).loadGraphic(Paths.image(imageName + 'selected'));
        selectedSprite.visible = false; // Initially, the selected sprite is not visible
        selectedSprite.antialiasing = true;
        add(selectedSprite);

        // Add the sprites and ID to the spriteData array
        spriteData.push({sprite: sprite, selectedSprite: selectedSprite, id: id});
    }

    function addNecromancerSprite(imageName:String, x:Float, y:Float, id:String)
    {
        // Create main sprite with alpha 0
        necromancerSprite = new FlxSprite(x, y).loadGraphic(Paths.image(imageName));
        necromancerSprite.alpha = (lockOpened && !necromancerlocked) ? 1 : 0; // Initially, the necromancer sprite is invisible if locked
        necromancerSprite.antialiasing = true;
        add(necromancerSprite);

        // Create selected sprite
        selectedSprite = new FlxSprite(x, y).loadGraphic(Paths.image(imageName + 'selected'));
        selectedSprite.alpha = (lockOpened && !necromancerlocked) ? 1 : 0; // Initially, the selected sprite is invisible if locked
        selectedSprite.visible = false; // Initially, the selected sprite is not visible
        selectedSprite.antialiasing = true;
        add(selectedSprite);

        // Add the sprites and ID to the spriteData array
        spriteData.push({sprite: necromancerSprite, selectedSprite: selectedSprite, id: id});
    }

    // Function to initialize lock sprite
    function initializeLockSprite()
    {
        lock = new FlxSprite(1005, 306);
        lock.frames = Paths.getSparrowAtlas('Candado');
        lock.antialiasing = true;
        lock.animation.addByPrefix('idle', 'Candado animacion cerrado estatico', 24, false);
        lock.animation.addByPrefix('trytoclick', 'Candado animacion cerrado al clickear', 24, false);
        lock.animation.addByPrefix('opening', 'Candado animacion abierto', 24, false);

        if (!necromancerlocked && !lockOpened)
        {
            lock.x -= 100;
            lock.y -= 200;
            lock.animation.play('opening', true);
            lockOpened = true;
            storyCompleteSave.data.lockOpened = true;
            storyCompleteSave.flush();
            new FlxTimer().start(3, function(timer:FlxTimer) {
                lock.visible = false;
            });
            // Fade in the necromancer sprite
            new FlxTimer().start(0.01, function(tmr:FlxTimer)
            {
                necromancerSprite.alpha += 0.009;
                selectedSprite.alpha += 0.008;
            }, 230);
        }
        else
        {
            lock.animation.play('idle', false);
        }

        lock.updateHitbox();
        add(lock);
    }

    override function update(elapsed:Float)
    {
        // Check for BACKSPACE or ESCAPE key press to switch state to MainMenuState
        if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new MainMenuState());
        }

        var isOverAnySprite = false; // To track if the mouse is over any sprite

        // Loop through each sprite data
        for (data in spriteData)
        {
            // If mouse is over the main sprite
            if (FlxG.mouse.overlaps(data.sprite))
            {
                // Show selected sprite and hide main sprite
                data.selectedSprite.visible = true;
                data.sprite.visible = false;
                songID = data.id;  // Update song ID
                isOverAnySprite = true; // Indicate that mouse is over a sprite
            }
            else
            {
                // Show main sprite and hide selected sprite
                data.selectedSprite.visible = false;
                data.sprite.visible = true;
            }
        }

        // If mouse is not over any sprite, reset songID
        if (!isOverAnySprite)
        {
            songID = '';
        }

        // If songID has changed, print it
        if (songID != lastSongID)
        {
            trace(songID);
            lastSongID = songID; // Update lastSongID
        }

        // Check if mouse is just pressed and overlaps any sprite to switch state
        if (FlxG.mouse.justPressed)
        {
            for (data in spriteData)
            {
                if (FlxG.mouse.overlaps(data.sprite))
                {
                    if (songID == 'necromancer' && !isStoryModeCompleted)
                        {
                            lock.animation.play('trytoclick');
                            trace('trying to click');
                            trace('loading sound...');
                            
                            var soundPath:String = Paths.sound('locked');
                            try
                            {
                                if (FileSystem.exists(soundPath))
                                {
                                    FlxG.sound.play(soundPath);
                                }
                                else
                                {
                                    trace('Sound file not found: ' + soundPath);
                                }
                            }
                            catch (e:Dynamic)
                            {
                                trace('Error playing sound: ' + e);
                            }
                        }                                            
                    else
                    {
                        openSubState(new FreeplayDiffSelect(curWeek = 1)); // Switch to FreeplayDiffSelect state
                        break;
                    }
                }
            }
        }

        super.update(elapsed); // Call parent class update method
    }
}
