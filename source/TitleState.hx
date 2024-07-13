package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.util.FlxSave;
import openfl.Assets;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var devs:FlxSprite;
	var lfg:FlxSprite;

	private var isFirstTime:Bool;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		var save:FlxSave = new FlxSave();

		 // Intentar cargar el estado guardado
		 if (save.bind("firsttime"))
			{
				// Verificar si la variable "firstTime" existe
				if (save.data.firstTime == null)
				{
					// Si no existe, es la primera vez
					isFirstTime = true;
					SEData.initSave();
					trace('loading default settings');
					save.data.firstTime = false; // Guardar que ya no es la primera vez
					save.flush(); // Guardar los cambios
				}
				else
				{
					// Si existe, no es la primera vez
					isFirstTime = false;
				}
			}
			
			// Hacer un trace para indicar si es la primera vez o no
			if (isFirstTime)
			{
				trace("Its first time: true.");
			}
			else
			{
				trace("Its first time: false.");
			}

		// DEBUG BULLSHIT

		super.create();

		FlxG.save.bind('funkin', 'BearzerkerFNFTeam');

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		#if desktop
		DiscordClient.initialize();
		
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileCircle);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 1000, height: 1000},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(90);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titleBG'));
		logo.screenCenter();
		logo.antialiasing = true;
		add(logo);


		logoBl = new FlxSprite(0, 0);
		logoBl.frames = Paths.getSparrowAtlas('logo');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'Logo animation', 24, false);
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.3));
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'Idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'Idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		
		gfDance.screenCenter();
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite();
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Static", 24, true);
		titleText.animation.addByPrefix('press', "Pressed", 24, true);
		titleText.antialiasing = true;
		titleText.screenCenter();
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		lfg = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('LFG'));
		add(lfg);
		lfg.visible = false;
		lfg.setGraphicSize(Std.int(lfg.width * 0.8));
		lfg.updateHitbox();
		lfg.screenCenter(X);
		lfg.antialiasing = true;

		devs = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('moddevs'));
		add(devs);
		devs.visible = false;
		devs.setGraphicSize(Std.int(devs.width * 0.8));
		devs.updateHitbox();
		devs.screenCenter(X);
		devs.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{

			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
					FlxG.switchState(new OptionsAdvisor());
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			if (!isFirstTime)
				{
					skipIntro();
				}
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 100;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 100;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

			FlxG.log.add(curBeat);
			if (curBeat % 2 == 0){
				gfDance.animation.play('danceRight');
				gfDance.animation.play('danceLeft');
				logoBl.animation.play('bump', false);
				
				}
				FlxG.camera.zoom += 0.03;
		FlxTween.tween(FlxG.camera, { zoom: 1 }, 0.1);


				switch (curBeat)
				{
					case 2:
									createCoolText(['Oh']);
								// credTextShit.visible = true;
								case 3:
									if (isFirstTime)
										{
											addMoreText('Hello There');
										}
										else
											{
												addMoreText('Hello Again');
											}
								case 4:
									addMoreText(':]');
								case 6:
									deleteCoolText();
									createCoolText(['A MOD ORIGINALLY CREATED BY']);
								case 7:
									addMoreText('IGNITEDBOI');
								case 8:
									addMoreText('RADG');
								case 9:
									addMoreText('SPRINGI');
									devs.visible = true;
								case 11:
									devs.visible = false;
									deleteCoolText();
									createCoolText(['With our new pals']);
									addMoreText('of the Dev Team:');
									addMoreText(':');
								case 12:
									addMoreText('Anon');
									addMoreText('Sushi');
									addMoreText('The Car');
									addMoreText('And Charter');
								case 14:
									deleteCoolText();
									createCoolText(['Newer special thanks to:']);
									addMoreText('');
								case 15:
									addMoreText('Benvu - Blue - Skyvu');
									addMoreText('Animate a thing - JustsallyKM');
									addMoreText('Happie - Capnugly - Sined');
									addMoreText('Extinct - Radicalmailbox');
									addMoreText('OhLookItsBenny');
								case 17:
									deleteCoolText();
									createCoolText(['a mod created for the']);
									addMoreText('Battle bears community');
									addMoreText('We Present to you...');
								case 19:
									deleteCoolText();
									createCoolText(['Beartastic']);
								case 20:
									addMoreText('Night');
								case 21:
									addMoreText('Funkin');
								case 22:
									addMoreText('VS BEARZERKER');
					                lfg.visible = true;
								case 24:
									deleteCoolText();
									lfg.visible = false;
									skipIntro();
				}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(devs);
			remove(lfg);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}