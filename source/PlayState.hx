package;

import haxe.iterators.StringIteratorUnicode;
import lime.utils.Bytes;
import haxe.macro.Expr.Case;
import polymod.Polymod.ModMetadata;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxSave;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxTrailEffect;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.IFlxEffect;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets;
import openfl.display.Shader;
import openfl.utils.Assets;
#if mobileC
import ui.Mobilecontrols;
#end

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;

	// Variables go here

	public static var instance:PlayState;

	public static var curStage:String = '';
	var altAnim:String = "";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	var difficultyText:String = "";
	#if desktop
	var video:MP4Handler = new MP4Handler();
	#end
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	var timeTxt:FlxText;
	public static var player:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var bfsel:Int = 0;

	var camX:Int = 0;
	var camY:Int = 0;
	var bfcamX:Int = 0;
	var bfcamY:Int = 0;

	var idleToBeat:Bool = true; // change if bf and dad would idle to the beat of the song
	var idleBeat:Int = 2; // how frequently bf and dad would play their idle animation(1 - every beat, 2 - every 2 beats and so on)
	var forcedToIdle:Bool = false; // change if bf and dad are forced to idle to every (idleBeat) beats of the song
	var allowedToHeadbang:Bool = true; // Will decide if gf is allowed to headbang depending on the song
	var allowedToCheer:Bool = false; // Will decide if gf is allowed to cheer depending on the song
	var canShowIcons:Bool = true;

	var blacklayer:FlxSprite;
	var blu:FlxSprite;
	var creepable:FlxSprite;
	var justbearhands:FlxSprite;

	var bearber:FlxSprite;

	var _rainbow:FlxRainbowEffect;
	var _outline:FlxOutlineEffect;
	var _wave:FlxWaveEffect;
	var _glitch:FlxGlitchEffect;
	var _trail:FlxTrailEffect;
	var _shake:FlxShakeEffect;
	private var SplashNote:NoteSplash;
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;


	public var trackedinputs:Array<FlxActionInput> = [];

	#if mobileC
	var mcontrols:Mobilecontrols; 
	#end

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;

	private var momT:FlxTrail;
	private var bfT:FlxTrail;

	private var updateTime:Bool = false;

	var songLength:Float = 0;
	public var currentSection:SwagSection;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	var halloweenLevel:Bool = false;

	var justabear:FlxSprite;

	var healaura:FlxSprite;
	var fire:FlxSprite;
	var drainaura:FlxSprite;
	var percentaura:FlxSprite;

	var bgstage:FlxSprite;
	var lights:FlxSprite;
	var thing:FlxSprite;
	var lightship:FlxSprite;
	var will:FlxSprite;
	var necromancerhip:FlxSprite;
	var boxeship:FlxSprite;
	var pillar:FlxSprite;
	var ground:FlxSprite;
	var shadow:FlxSprite;
	var pr:FlxSprite;
	var floor2:FlxSprite;
var floor:FlxSprite;
var dacouple:FlxSprite;
var sky:FlxSprite;
var pepperboi:FlxSprite;
var farfloor:FlxSprite;

	var songPercent:Float = 0;


	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end
	private var storyCompleteSave:FlxSave;
    private var isStoryModeCompleted:Bool;
	public var daNote:Note;

	private var vocals:FlxSound;

	public static var dad:Character;
	private var gf:Character;
	private var leo:Character;
	private var creepzerker:Character;
	private var necromancer:Character;
	public static var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;
	private var floatshit:Float = 0;
	private var float2:Float = 0;
	private var float3:Float = 0;

	public var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var bearnotespressed:Int = 0;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

		// modcharting

	var modcharting:Bool = false;
	var modchart:String;

	var lastModchart:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var prelevel:FlxSprite;

	var previousMustHitSection:Bool = false;

	var oliver:FlxSprite;
	var necromancerbe:FlxSprite;
	var orangehuggable:FlxSprite;
	var pepperboibe:FlxSprite;
	var frontbears1:FlxSprite;
	var frontbears2:FlxSprite;
	var frontbears3:FlxSprite;
	var frontbears4:FlxSprite;

	var bg:FlxSprite;
	var rocks:FlxSprite;
	var black:FlxSprite;
	var minis:FlxSprite;
	var huggabletower:FlxSprite;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var cutsceneOp:Bool;
	var noteGlow:Bool;

	var colbear:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var ratingTxt:FlxText;
	var songTxt:FlxText;
	var difficultyTxt:FlxText;
	var replayTxt:FlxText;
	var noisePercent:Int;


    var cameramove:Bool;

    var tailscircle:String = '';

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var ghostTapping:Bool = true;
	public static var thebearremix:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var sectionStart:Bool =  false;
	public static var sectionStartPoint:Int =  0;
	public static var sectionStartTime:Float =  0;

	public static var videoName:String = '';

	override public function create()
	{
		FlxG.mouse.visible = false;
				try {
					modchart = Assets.getText(Paths.mc(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase()).trim());
					modcharting = true;
				} catch(err) {
					trace("no modchart poops cutely");
					modcharting = false;
				}
				
		ghostTapping = true;
		thebearremix = SONG.song.toLowerCase() == 'zombearzerker';
		storyCompleteSave = new FlxSave();
		if (storyCompleteSave.bind("storycomplete"))
			{
				// Verificar si la variable "firstTime" existe
				if (storyCompleteSave.data.storyComplete == null)
				{
					// Si no existe, es la primera vez
					isStoryModeCompleted = false;
				}
				else
				{
					isStoryModeCompleted = true;
				}
			}
	

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		bearnotespressed = 0;

		repPresses = 0;
		repReleases = 0;

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "Remix";
		}

		difficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		ModCharts.dadNotesVisible = FlxG.save.data.dadnotesvisible; // gamer
		ModCharts.bfNotesVisible = FlxG.save.data.bfnotesvisible;
		ModCharts.dadNotesCanKill = FlxG.save.data.dadnotescankill;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		if (SONG.song.toLowerCase() == 'the-bearzerker' || SONG.song.toLowerCase() == 'cy-bearzerker')
		{
			canShowIcons = false;
		}
		else
		{
			canShowIcons = true;
		}

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		if(curSong.toLowerCase() == 'necromancer')
			{
				camera.y += 0.4;
			}

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var sploosh = new NoteSplash(100, 100, 0);
		sploosh.alpha = 0.6;
		grpNoteSplashes.add(sploosh);

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			// Put smth here
		}

		if (!FlxG.save.data.optimization){
    switch(SONG.song.toLowerCase())
	{
		// Here create the stages

		//TEMPLATE
		case 'template'/*replace this for the song the stage is*/:
			{
				defaultCamZoom = 0.9;
				curStage = 'template';//replace this for the stage name
				var bg:FlxSprite = new FlxSprite(-600/*X*/, -200/*Y*/).loadGraphic(Paths.image('stageback'/*Directory*/));//replace this for the sprite directory
				if (FlxG.save.data.antialiasing)
					{
						bg.antialiasing = true;
					}
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				if (!FlxG.save.data.optimization)
					{add(bg);}
	
				var stageFront:FlxSprite = new FlxSprite(-650/*X*/, 600/*Y*/).loadGraphic(Paths.image('stagefront'/*Directory*/));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				if (!FlxG.save.data.antialiasing)
					{
						stageFront.antialiasing = true;
					}
				stageFront.scrollFactor.set(1, 1);
				stageFront.active = false;
				if (!FlxG.save.data.optimization)
					{add(stageFront);}	
	
				var stageCurtains:FlxSprite = new FlxSprite(-500/*X*/, -300/*Y*/).loadGraphic(Paths.image('stagecurtains'/*Directory*/));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				if (FlxG.save.data.antialiasing)
					{
						stageCurtains.antialiasing = true;
					}
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				if (!FlxG.save.data.optimization)
					{add(stageCurtains);}
			}
		case 'zombearzerker':
			{
				defaultCamZoom = 0.55;
				curStage = 'zombocalypse';

				sky = new FlxSprite(0, -200).loadGraphic(Paths.image('bear/zombocalypse/sky'));
				sky.scrollFactor.set(1, 1);
				sky.active = false;
				if (!FlxG.save.data.optimization)
					{add(sky);}

				pepperboi = new FlxSprite();
				pepperboi.frames = Paths.getSparrowAtlas('bear/zombocalypse/pepperboi');
				pepperboi.animation.addByPrefix('idle', 'pepperboi idle', 24, false);			
				pepperboi.scrollFactor.set(1, 1);
				if (!FlxG.save.data.optimization)
					{add(pepperboi);}

				farfloor = new FlxSprite(0, 0).loadGraphic(Paths.image('bear/zombocalypse/farfloor'));
				farfloor.scrollFactor.set(1, 1);
				if (!FlxG.save.data.optimization)
					{add(farfloor);}

				colbear = new FlxSprite();
				colbear.frames = Paths.getSparrowAtlas('bear/zombocalypse/colbear');
				colbear.animation.addByPrefix('idle', 'colbear idle', 24, false);
				colbear.scrollFactor.set(1, 1);
				if (!FlxG.save.data.optimization)
					{add(colbear);}

				floor2 = new FlxSprite();
				floor2.frames = Paths.getSparrowAtlas('bear/zombocalypse/floor2');
				floor2.animation.addByPrefix('idle', 'floor2 idle', 24, false);				
				floor2.scrollFactor.set(1, 1);
				if (!FlxG.save.data.optimization)
					{add(floor2);}

				floor = new FlxSprite();
				floor.frames = Paths.getSparrowAtlas('bear/zombocalypse/floor');
				floor.animation.addByPrefix('idle', 'floor idle', 24, false);					
				floor.scrollFactor.set(1, 1);
				if (!FlxG.save.data.optimization)
					{add(floor);}

				dacouple = new FlxSprite();
				dacouple.frames = Paths.getSparrowAtlas('bear/zombocalypse/couple');
				dacouple.animation.addByPrefix('idle', 'couple idle', 24, false);
				dacouple.scrollFactor.set(1, 1);
				if (!FlxG.save.data.optimization)
					{add(dacouple);}
			}
			
		case 'the-bearzerker':
			{
					defaultCamZoom = 0.45;
					curStage = 'huggable-fields';
					var whitebg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/bearzerker/whitebg'));
					whitebg.setGraphicSize(Std.int(whitebg.width * 1.5));
					if(!FlxG.save.data.antialiasing){whitebg.antialiasing = false;}
					whitebg.scrollFactor.set(1, 1);
					whitebg.active = false;
					
					add(whitebg);

					var bgback:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/bearzerker/bgBack'));
					bgback.setGraphicSize(Std.int(bgback.width * 1.5));
					if(!FlxG.save.data.antialiasing){bgback.antialiasing = false;}
					bgback.scrollFactor.set(1, 1);
					bgback.active = false;
					add(bgback);

					oliver = new FlxSprite(2150, 324.5);
				    oliver.frames = Paths.getSparrowAtlas('bear/bearzerker/Oliver');
					oliver.setGraphicSize(Std.int(oliver.width * 0.25));
				    oliver.animation.addByPrefix('idle', 'Oliver', 24, false);		
				    oliver.scrollFactor.set(1, 1);
				    if (!FlxG.save.data.optimization)
					{add(oliver);}

					var bgmiddle:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/bearzerker/bgMiddle'));
					bgmiddle.setGraphicSize(Std.int(bgmiddle.width * 1.5));
					if(!FlxG.save.data.antialiasing){bgmiddle.antialiasing = false;}
					bgmiddle.scrollFactor.set(1, 1);
					bgmiddle.active = false;
					add(bgmiddle);

					necromancerbe = new FlxSprite(50, -315);
				    necromancerbe.frames = Paths.getSparrowAtlas('bear/bearzerker/necromancer');
					necromancerbe.setGraphicSize(Std.int(necromancerbe.width * 0.35));
				    necromancerbe.animation.addByPrefix('idle', 'Necromancer', 24, false);			
				    necromancerbe.scrollFactor.set(1, 1);
				    if (!FlxG.save.data.optimization)
					{add(necromancerbe);}
		
					var bgfront:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/bearzerker/bgFront'));
					bgfront.setGraphicSize(Std.int(bgfront.width * 1.5));
					if(!FlxG.save.data.antialiasing){bgfront.antialiasing = false;}
					bgfront.scrollFactor.set(1, 1);
					bgfront.active = false;
					add(bgfront);

					orangehuggable = new FlxSprite(2200, 570);
				    orangehuggable.frames = Paths.getSparrowAtlas('bear/bearzerker/Orange_Huggable');
					orangehuggable.setGraphicSize(Std.int(orangehuggable.width * 0.6));
				    orangehuggable.animation.addByPrefix('idle', 'Orange Huggable', 24, false);				
				    orangehuggable.scrollFactor.set(1, 1);
				    if (!FlxG.save.data.optimization)
					{add(orangehuggable);}

					pepperboibe = new FlxSprite(2000, 630);
				    pepperboibe.frames = Paths.getSparrowAtlas('bear/bearzerker/Pepperboi');
					pepperboibe.setGraphicSize(Std.int(pepperboibe.width * 0.6));
				    pepperboibe.animation.addByPrefix('idle', 'Pepperboi', 24, false);			
				    pepperboibe.scrollFactor.set(1, 1);
				    if (!FlxG.save.data.optimization)
					{add(pepperboibe);}
		}
		case 'board-game':
			{
					defaultCamZoom = 0.65;
					curStage = 'boardgame';
					var bgback:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/boardgame/back'));
					if(!FlxG.save.data.antialiasing){bgback.antialiasing = false;}
					bgback.scrollFactor.set(0.7, 0.7);
					bgback.active = false;
					
					add(bgback);

					var bgmiddle:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/boardgame/middle'));
					if(!FlxG.save.data.antialiasing){bgmiddle.antialiasing = false;}
					bgmiddle.scrollFactor.set(0.8, 0.8);
					bgmiddle.active = false;
					add(bgmiddle);
					

					var bgfront:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/boardgame/front'));
					if(!FlxG.save.data.antialiasing){bgfront.antialiasing = false;}
					bgfront.scrollFactor.set(1, 1);
					bgfront.active = false;
					add(bgfront);
		
			}
	case 'mecha-bearzerker' | 'arch' | 'expurgation':
		{
				defaultCamZoom = 0.58;
				curStage = 'H.I.P';
				bgstage = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/bg'));
				bgstage.scrollFactor.set(1, 1);
				if(!FlxG.save.data.antialiasing){bgstage.antialiasing = false;}
				bgstage.active = false;
				add(bgstage);

				thing = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/thing'));
				if(!FlxG.save.data.antialiasing){thing.antialiasing = false;}
				thing.scrollFactor.set(1, 1);
				thing.active = false;
				add(thing);
	
				lights = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/lights'));
				if(!FlxG.save.data.antialiasing){lights.antialiasing = false;}
				lights.scrollFactor.set(1, 1);
				lights.active = false;
				add(lights);

				will = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/will'));
				if(!FlxG.save.data.antialiasing){will.antialiasing = false;}
				will.scrollFactor.set(1, 1);
				add(will);

				justabear = new FlxSprite(-600, -400);
				justabear.frames = Paths.getSparrowAtlas('bear/mecha/necromancer');
				justabear.animation.addByPrefix('idle', 'necromancer idle', 24, false);
				justabear.active = true;
				if(!FlxG.save.data.antialiasing){justabear.antialiasing = false;}
				justabear.updateHitbox();
				justabear.scrollFactor.set(1, 1);
				add(justabear);

				boxeship = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/boxes'));
				if(!FlxG.save.data.antialiasing){boxeship.antialiasing = false;}
				boxeship.scrollFactor.set(1, 1);
				boxeship.active = false;
				add(boxeship);

				pillar = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/partofground'));
				pillar.setGraphicSize(Std.int(pillar.width * 1.1));
				pillar.updateHitbox();
				if(!FlxG.save.data.antialiasing){pillar.antialiasing = false;}
				pillar.scrollFactor.set(1, 1);
				pillar.active = false;
				add(pillar);

				ground = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/ground'));
				if(!FlxG.save.data.antialiasing){ground.antialiasing = false;}
				ground.setGraphicSize(Std.int(ground.width * 1.1));
				ground.updateHitbox();
				ground.antialiasing = true;
				ground.scrollFactor.set(1, 1);
				ground.active = false;
				add(ground);

				shadow = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/mecha/shadow'));
				shadow.setGraphicSize(Std.int(shadow.width * 1.1));
				shadow.updateHitbox();
				if(!FlxG.save.data.antialiasing){shadow.antialiasing = false;}
				shadow.scrollFactor.set(1, 1);
				shadow.active = false;
				add(shadow);

				pr = new FlxSprite(-600, -150).loadGraphic(Paths.image('bear/mecha/pr'));
				if(!FlxG.save.data.antialiasing){pr.antialiasing = false;}
				pr.scrollFactor.set(1, 1);
				pr.active = false;
				add(pr);
		}

				case 'necromancer' | 'slaughter' | 'verruckt':
				{
					defaultCamZoom = 0.75;
					curStage = 'necrotower';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bear/necromancer/Sky'));
					if (!FlxG.save.data.antialiasing)
						{
							bg.antialiasing = false;
						}
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					if (!FlxG.save.data.optimization)
						{add(bg);} 
					
		
					var stageFront:FlxSprite = new FlxSprite(-600, -400).loadGraphic(Paths.image('bear/necromancer/Heads'));
					if (!FlxG.save.data.antialiasing)
						{
							stageFront.antialiasing = false;
						}
					stageFront.scrollFactor.set(1, 1);
					stageFront.active = false;
					if (!FlxG.save.data.optimization)
						{add(stageFront);}	

					justabear = new FlxSprite(-600, -300);
		        	justabear.frames = Paths.getSparrowAtlas('bear/necromancer/Beeear');
			        justabear.animation.addByPrefix('idle', 'Beeear', 24, false);
					justabear.active = true;
					if(!FlxG.save.data.antialiasing){justabear.antialiasing = false;}
					justabear.updateHitbox();
			        justabear.scrollFactor.set(1, 1);
			        add(justabear);
		
					var stageCurtains:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('bear/necromancer/Floor'));
					if (FlxG.save.data.antialiasing)
						{
							stageCurtains.antialiasing = true;
						}
					stageCurtains.scrollFactor.set(1, 1);
					stageCurtains.active = false;
					if (!FlxG.save.data.optimization)
						{add(stageCurtains);}

					justbearhands = new FlxSprite(-600, -300);
		        	justbearhands.frames = Paths.getSparrowAtlas('bear/necromancer/Haaands');
			        justbearhands.animation.addByPrefix('idle', 'Idle', 24, false);
			        justbearhands.scrollFactor.set(1, 1);
					if(!FlxG.save.data.antialiasing){justbearhands.antialiasing = false;}
					justbearhands.active = true;
			        add(justbearhands);

					blu = new FlxSprite(-600, -400);
		        	blu.frames = Paths.getSparrowAtlas('bear/necromancer/Blu');
			        blu.animation.addByPrefix('idle', 'Idle', 24, false);
					if(!FlxG.save.data.antialiasing){blu.antialiasing = false;}
			        blu.scrollFactor.set(1, 1);
			        add(blu);

					
			      

				}
				case 'monochrome':
					{
						defaultCamZoom = 1.0;
						curStage = 'monochrome';

					creepable = new FlxSprite(144, 242);
		        	creepable.frames = Paths.getSparrowAtlas('creepable');
			        creepable.animation.addByPrefix('idle', 'creepable idle', 15, false);
			        creepable.scrollFactor.set(1, 1);
					var widShit = Std.int(creepable.width * 6);
				    creepable.setGraphicSize(Std.int(widShit * 0.22));
					if(!FlxG.save.data.antialiasing){creepable.antialiasing = false;}
					creepable.active = true;
			        add(creepable);
					}
		        case 'cy-bearzerker':
					{

						defaultCamZoom = 0.58;
						curStage = 'The-Core';

					var bg:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('bear/cy/BG'));
					if (FlxG.save.data.antialiasing)
						{
							bg.antialiasing = true;
						}
						bg.scrollFactor.set(1, 1);
			        bg.active = false;
			        if (!FlxG.save.data.optimization)
				       {add(bg);}

					var lightsocket:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('bear/cy/lightsocket'));
					if (FlxG.save.data.antialiasing)
						{
							lightsocket.antialiasing = true;
						}
						lightsocket.scrollFactor.set(1, 1);
						lightsocket.active = false;
			        if (!FlxG.save.data.optimization)
				       {add(lightsocket);}

					var buckets:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('bear/cy/buckets'));
					if (FlxG.save.data.antialiasing)
						{
							buckets.antialiasing = true;
						}
						buckets.scrollFactor.set(1, 1);
						buckets.active = false;
			        if (!FlxG.save.data.optimization)
				       {add(buckets);}

					var core:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('bear/cy/core'));
					if (FlxG.save.data.antialiasing)
						{
							core.antialiasing = true;
						}
						core.scrollFactor.set(1, 1);
						core.active = false;
			        if (!FlxG.save.data.optimization)
				       {add(core);}

					var wires:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('bear/cy/wires'));
					if (FlxG.save.data.antialiasing)
						{
							wires.antialiasing = true;
						}
						wires.scrollFactor.set(1, 1);
						wires.active = false;
			        if (!FlxG.save.data.optimization)
				       {add(wires);}
					}
					case 'dreaming':
			{
					defaultCamZoom = 0.9;
					curStage = 'dream?';
					var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bear/dreaming/bg'));
					if(!FlxG.save.data.antialiasing){bg.antialiasing = false;}
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					
					add(bg);

					var clark:FlxSprite = new FlxSprite(1859, 608);
				    clark.frames = Paths.getSparrowAtlas('bear/dreaming/C.L.A.R.K_BG_sprite');
				    clark.animation.addByPrefix('idle', 'Clark idle', 24);
				    if (curBeat % 2 == 0)
					{
						clark.animation.play('idle');
					}				
				    clark.scrollFactor.set(1, 1);
				    if (!FlxG.save.data.optimization)
					{add(clark);}

					var cable:FlxSprite = new FlxSprite(119, 1004);
				    cable.frames = Paths.getSparrowAtlas('bear/dreaming/Oliver_Back_Recharging_Cable');
				    cable.animation.addByPrefix('idle', 'Cable', 24);
					cable.animation.play('idle', true);		
				    cable.scrollFactor.set(1, 1);
				    if (!FlxG.save.data.optimization)
					{add(cable);}
		}
		default :
		{
			defaultCamZoom = 0.9;
			curStage = 'stage';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			if (FlxG.save.data.antialiasing)
				{
					bg.antialiasing = true;
				}
			bg.scrollFactor.set(1, 1);
			bg.active = false;
			if (!FlxG.save.data.optimization)
				{add(bg);}

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			if (!FlxG.save.data.antialiasing)
				{
					stageFront.antialiasing = true;
				}
			stageFront.scrollFactor.set(1, 1);
			stageFront.active = false;
			if (!FlxG.save.data.optimization)
				{add(stageFront);}	

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			if (FlxG.save.data.antialiasing)
				{
					stageCurtains.antialiasing = true;
				}
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			if (!FlxG.save.data.optimization)
				{add(stageCurtains);}
		}
	}
}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
         // smth
		}

		gf = new Character(400, 130, gfVersion);
		necromancer = new Character(500, 600, 'necromancer');
		leo = new Character(400, 130, 'leo');
		creepzerker = new Character(189, 43, 'creepzerker');
		gf.scrollFactor.set(1, 1);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);


		switch (SONG.player2)
		{
			case 'gf':

				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
					
				

			case 'dad':

				    camPos.x += 400;
			case 'purplewil':
				camPos.x += 1280;
				camPos.y += 700;

			case 'bf':
						camPos.x += 600;
				        dad.y += 300;

			case 'cybearzerker':
				camPos.x += 600;
			default:
				camPos.x += 300;
		}

		switch (SONG.player1)
		{
			case 'bf-bearzerker':
			    camPos.y -= 300;
		}
		switch bfsel{
			case 0:
				boyfriend = new Boyfriend(770, 450, SONG.player1);
				trace("bf!");
			case 1:
				boyfriend = new Boyfriend(650, 350, SONG.player1 + '-dia');
				trace("dia!");
			default:
				trace("default!");
				boyfriend = new Boyfriend(770, 450, SONG.player1);
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'huggable-fields':
				if(dad.curCharacter == 'bearzombie')
					{
						dad.setPosition(600, 345);
					}
					else
					{
						dad.setPosition(401, 163);
					}      
				boyfriend.setPosition(1900, 804);
				gf.setPosition(1120, 390);
				var dadT = new FlxTrail(dad, null, 5, 7, 0.3, 0.2);
					add(dadT);
			
			case 'zombocalypse':
				dad.setPosition(850, 345);
				boyfriend.setPosition(2400, 1200);
				gf.setPosition(1752, 753);
			case 'dream?':
				dad.setPosition(1360, 810);
				boyfriend.setPosition(302, 810);
			case 'necrotower':
					if (dad.curCharacter == 'flippy-blood'){
					dad.y += 200;
					boyfriend.y -= 300;
					dad.x -= 100;
					}
					else{
					boyfriend.y -= 50;
					gf.y -= 50;
					}
			case 'monochrome':
				creepzerker.setPosition(189, 46);
			case 'H.I.P':
				if (dad.curCharacter == 'necromancer')
					{
                        dad.y -= 300;
						dad.x += 100;
					}
				else
					{
						dad.setPosition(200, 442);
					}
				
				boyfriend.setPosition(1600, 1300);
				gf.setPosition(900, 900);
				case 'The-Core':
				if (dad.curCharacter == 'necromancer')
					{
                        dad.y -= 300;
						dad.x += 100;
					}
				else
					{
						dad.setPosition(394, 221);
					}
				
				boyfriend.setPosition(2484, 1340);
				case 'boardgame':
				dad.setPosition(810, 662);
				boyfriend.setPosition(0, 0);
		}
    if (!FlxG.save.data.optimization)
		{
		
		//i didn't knew how to remove gf lol'
    if(curStage == 'The-Core' || curStage == 'monochrome' || curStage == 'boardgame' || curStage == 'dream?')
				{
					//add nothing lol
				}
				else {
					add(gf);
				}

			
		
		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

        
		add(dad);


            if (curStage == 'monochrome' || curStage == 'boardgame')
				{
                    //add nothing lol
				}
				else {
					add(boyfriend);
				}
			//im sure that there is a better way to to this but it works

		
		switch (curStage)
		{
			// add smth in front of characters
			case 'huggable-fields':
			{
				bearsFront();
			}
		}

			
		trace('Loading Characters...');
				}
		

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = 0;

		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 20, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.antialiasing = true;
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = FlxG.save.data.songPosition;
		if(FlxG.save.data.downscroll) timeTxt.y = FlxG.height - 45;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = FlxG.save.data.songPosition;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800;
		timeBar.alpha = 0;
		timeBar.visible = FlxG.save.data.songPosition;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.screenCenter(X);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);


		camFollow.setPosition(camPos.x, camPos.y);
		

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				healthBarBG.alpha = 0;
			}
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

			{healthBar = new FlxBar(healthBarBG.x + 5.5, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
			healthBar.scrollFactor.set();
			healthBar.createFilledBar(dad.healthcolor, boyfriend.healthcolor);
			if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
				{
					healthBar.alpha = 0;
				}
			add(healthBar);}

		bearber = new FlxSprite(0, 171);
		bearber.frames = Paths.getSparrowAtlas('bearber');
		bearber.animation.addByPrefix('idle', 'bearber', 15, false);
		bearber.alpha = 0;
		bearber.antialiasing = true;
		bearber.animation.play('idle');
        add(bearber);

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.antialiasing = true;
		scoreTxt.scrollFactor.set();
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				scoreTxt.alpha = 0;
			}
		add(scoreTxt);

		ratingTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
		ratingTxt.x = healthBarBG.x + healthBarBG.width / 2;
		ratingTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		ratingTxt.antialiasing = true;
		ratingTxt.scrollFactor.set();
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				ratingTxt.alpha = 0;
			}
		if (SONG.song.toLowerCase() == 'monochrome' || FlxG.save.data.optimization || FlxG.save.data.vanillaHUD)
			{}
		else
		{add(ratingTxt);}

		songTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
			songTxt.x = healthBarBG.x + healthBarBG.width / 2;
		songTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		songTxt.antialiasing = true;
		songTxt.scrollFactor.set();
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				songTxt.alpha = 0;
			}
		if (SONG.song.toLowerCase() == 'monochrome' || FlxG.save.data.optimization || FlxG.save.data.vanillaHUD)
			{}
		else
		{add(songTxt);}

		difficultyTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
		difficultyTxt.x = healthBarBG.x + healthBarBG.width / 2;
		difficultyTxt.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		difficultyTxt.antialiasing = true;
		difficultyTxt.scrollFactor.set();
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				difficultyTxt.alpha = 0;
			}
		if (SONG.song.toLowerCase() == 'monochrome' || FlxG.save.data.optimization || FlxG.save.data.vanillaHUD)
			{}
		else
		{add(difficultyTxt);}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				iconP1.alpha = 0;
			}
		add(iconP1);
		trace('Loading Player1 icon...');

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				iconP2.alpha = 0;
			}
		add(iconP2);
		trace('Loading Player2 icon...');

		var hallowTex = Paths.getSparrowAtlas('healaura');
		healaura = new FlxSprite();
		healaura.frames = hallowTex;
		healaura.animation.addByPrefix('idle', 'Idle', 24, true);
		healaura.animation.addByPrefix('heal', 'Heal', 24, false);
		healaura.animation.play('idle');
		healaura.screenCenter();
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				healaura.alpha = 0;
			}
        add(healaura);

		var hallowTex = Paths.getSparrowAtlas('healaura');
		fire = new FlxSprite();
		fire.frames = hallowTex;
		fire.animation.addByPrefix('idle', 'Idle', 24, true);
		fire.animation.addByPrefix('fire', 'Fire', 24, false);
		fire.animation.play('idle');
		fire.screenCenter();
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				fire.alpha = 0;
			}
        add(fire);

		var hallowTex = Paths.getSparrowAtlas('drainaura');
		drainaura = new FlxSprite();
		drainaura.frames = hallowTex;
		drainaura.animation.addByPrefix('idle', 'Idle', 24, true);
		drainaura.animation.addByPrefix('drain', 'Drain', 24, false);
		drainaura.animation.play('idle');
		drainaura.screenCenter();
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				drainaura.alpha = 0;
			}
	    add(drainaura);

		percentaura = new FlxSprite().loadGraphic(Paths.image('minus20healthaura'));
		percentaura.screenCenter();
		percentaura.alpha = 0;
		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				percentaura.alpha = 0;
			}
			add(percentaura);

		creepzerker.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		healaura.cameras = [camHUD];
		fire.cameras = [camHUD];
		drainaura.cameras = [camHUD];
		percentaura.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		bearber.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		difficultyTxt.cameras = [camHUD];
		ratingTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		#if mobileC
			mcontrols = new Mobilecontrols();
			
			switch (mcontrols.mode)
			{
				case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
					controls.setVirtualPad(mcontrols._virtualPad, FULL, NONE);
				case HITBOX:
					controls.setHitBox(mcontrols._hitbox);
				default:
			}
			trackedinputs = controls.trackedinputs;
			controls.trackedinputs = [];

			var camcontrol = new FlxCamera();
			FlxG.cameras.add(camcontrol);
			camcontrol.bgColor.alpha = 0;
			mcontrols.cameras = [camcontrol];

			//mcontrols.visible = false;
			mcontrols.alpha = 0;

			add(mcontrols);
		#end

		if (curStage == 'boardgame')
			{
				healthBarBG.alpha = 0.3;
				healthBar.alpha = 0.3;
				iconP1.alpha = 0.3;
				iconP2.alpha = 1;
			}
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		updateTime = true;



		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'monster':
					monsterIntro();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	//wow, this only for bearzerker bg
	function createBear(x:Float, y:Float, atlas:String, animPrefix:String, scale:Float):FlxSprite {
        var bear:FlxSprite = new FlxSprite(x, y);
        bear.frames = Paths.getSparrowAtlas(atlas);
        bear.setGraphicSize(Std.int(bear.width * scale));
        bear.animation.addByPrefix('idle', animPrefix, 24, false);
        bear.scrollFactor.set(1, 1);
        if (!FlxG.save.data.optimization) {
            add(bear);
        }
        return bear;
    }

    function bearsFront():Void {
        frontbears1 = createBear(240, 1109, 'bear/bearzerker/Huggable_1', 'Huggable 1', 1.5);
        frontbears2 = createBear(1640, 1208, 'bear/bearzerker/Huggable_2', 'Huggable 2', 1.5);
		frontbears3 = createBear(2748, 1092, 'bear/bearzerker/Huggable_3', 'Huggable 3', 1.5);
		frontbears4 = createBear(-645, 1052, 'bear/bearzerker/Huggable_4', 'Huggable 4', 1.5);
    }

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}
	function moveCameraSection(?sec:Null<Int>):Void {
		if(sec == null) sec = curSection;
		if(sec < 0) sec = 0;

		if(SONG.notes[sec] == null) return;


		var isDad:Bool = (SONG.notes[sec].mustHitSection != true);
moveCamera(isDad);

	}

	public function tweenCamIn() {
		if (songName.text == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3)
			 {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
			iconP1.alpha = 0.4;
			iconP2.alpha = 1;
			tweenCamIn();
		}
		else
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];
			iconP1.alpha = 1;
			iconP2.alpha = 0.4;

			if (songName.text == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	public function dontmoveCamera()
		{
          camFollow.screenCenter();
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	function startCountdown():Void
	{
		inCutscene = false;

		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
			{
				iconP1.alpha = 0;
                iconP2.alpha = 0;
			}
		else
			{
				generateStaticArrows(0);
				generateStaticArrows(1);
			}
		
		#if mobileC
		//mcontrols.visible = true;
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			mcontrols.alpha += 0.1;
			if (mcontrols.alpha != 0.7){
				tmr.reset(0.1);
			}
			else{
				trace('aweseom.');
			}
		});
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;
		
		
		if (curSong == 'Dreaming')
			{
				//Only call the timer for the pausesubstate to work
				startTimer = new FlxTimer();
				
			}
		else
			{
				startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
					{
						gf.dance();
						boyfriend.dance();
						dad.dance();

						if (curStage == 'zombocalypse')
						{
						    pepperboi.animation.play('idle', true);
							colbear.animation.play('idle', true);
							floor2.animation.play('idle', true);
							floor.animation.play('idle', true);
							dacouple.animation.play('idle', true);
						}
			
						var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
						introAssets.set('default', ['ready', "set", "go"]);
			
						var introAlts:Array<String> = introAssets.get('default');
						var altSuffix:String = "";
			
						for (value in introAssets.keys())
						{
							if (value == curStage)
							{
								introAlts = introAssets.get(value);
								altSuffix = '-pixel';
							}
						}
			
						switch (swagCounter)
			
						{
							case 0:
								FlxG.sound.play(Paths.sound('intro3'), 0.6);
							case 1:
								var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
								ready.scrollFactor.set();
								ready.updateHitbox();
			
								ready.screenCenter();
								add(ready);
								FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										ready.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro2'), 0.6);
							case 2:
								var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
								set.scrollFactor.set();
								set.screenCenter();
								add(set);
								FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										set.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro1'), 0.6);
							case 3:
								gf.playAnim('cheer', true);
								var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
								go.scrollFactor.set();
								go.updateHitbox();
			
								go.screenCenter();
								add(go);
								FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										go.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('introGo'), 0.6);
							case 4:
						}
			
						swagCounter += 1;
						// generateSong('fresh');
					}, 5);
			}
			
	}

	function monsterIntro():Void
		{
			inCutscene = false;

	
			generateStaticArrows(0);
			generateStaticArrows(1);
	
			talking = false;
			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
	
			var swagCounter:Int = 0;
	
			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				dad.dance();
		        necromancer.dance();
				gf.dance();
				boyfriend.playAnim('scared');
	
				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', "set", "go"]);
				introAssets.set('school', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);
				introAssets.set('schoolEvil', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);
	
				var introAlts:Array<String> = introAssets.get('default');
				var altSuffix:String = "";
	
				for (value in introAssets.keys())
				{
					if (value == curStage)
					{
						introAlts = introAssets.get(value);
						altSuffix = '-pixel';
					}
				}
	
				switch (swagCounter)
	
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3'), 0.6);
					case 1:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						ready.scrollFactor.set();
						ready.updateHitbox();
	
						if (curStage.startsWith('school'))
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
	
						ready.screenCenter();
						add(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								ready.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2'), 0.6);
					case 2:
						var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						set.scrollFactor.set();
	
						if (curStage.startsWith('school'))
							set.setGraphicSize(Std.int(set.width * daPixelZoom));
	
						set.screenCenter();
						add(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								set.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1'), 0.6);
					case 3:
						var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						go.scrollFactor.set();
	
						if (curStage.startsWith('school'))
							go.setGraphicSize(Std.int(go.width * daPixelZoom));
	
						go.updateHitbox();
	
						go.screenCenter();
						add(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								go.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo'), 0.6);
					case 4:
				}
	
				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

			if(sectionStart){
				FlxG.sound.music.time = sectionStartTime;
				Conductor.songPosition = sectionStartTime;
				vocals.time = sectionStartTime;
			}
		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		

		if (SONG.song.toLowerCase() == 'cy-bearzerker' || SONG.song.toLowerCase() == 'the-bearzerker')
		{
			timeBar.alpha = 0;
			timeTxt.alpha = 0;
		}
		else
		{
			FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		    FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		}

		// Updating Discord Rich Presence (with Time Left)



		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
		iconBop(1);
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			if(sectionStart && daBeats < sectionStartPoint){
				daBeats++;
				continue;
			}

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					if (daStrumTime < 0)
						daStrumTime = 0;
					var daNoteData:Int = Std.int(songNotes[1] % 4);
 
					var gottaHitNote:Bool = section.mustHitSection;
 
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}
 
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
 
					var daType = songNotes[3];
					var swagNote:Note;
					if (gottaHitNote) {
						swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, boyfriend.noteStyle);
					} else {
						swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, dad.noteStyle);
					}
					swagNote.sustainLength = songNotes[2];
 
					swagNote.scrollFactor.set(0, 0);	
 
				var susLength:Float = swagNote.sustainLength;
 
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
 
				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
 
					var sustainNote:Note;
					if (gottaHitNote) {
						sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, boyfriend.noteStyle);
					} else {
						sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, dad.noteStyle);
					}
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
 
					sustainNote.mustPress = gottaHitNote;
 
					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}
 
				swagNote.mustPress = gottaHitNote;
 
				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					switch (player)
					{
						case 0:
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + dad.noteStyle);

						case 1:
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + boyfriend.noteStyle);

                        default:
						babyArrow.frames = Paths.getSparrowAtlas('notes/normal');
					}           
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					if (FlxG.save.data.antialiasing)
						{
							babyArrow.antialiasing = true;
						}
					
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', false);
					}
				
			}

			

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

		
			babyArrow.ID = i;

			
			if (player == 1)
				{
					playerStrums.add(babyArrow);
				}
				else
				{
					cpuStrums.add(babyArrow);
				}


	        if (FlxG.save.data.midScroll || curSong.toLowerCase() == 'monochrome' || curStage == 'boardgame')
			{
					babyArrow.x -= 275;
				    if (player != 1) 
				{
					babyArrow.visible = false;
				}
			}
			else
			{
				babyArrow.x += 40;
			}

			if (curStage == 'dream?')
				{
						babyArrow.x -= 500;
						if (player != 1) 
					{
						babyArrow.visible = false;
					}
				}
				
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}


	function finishSong():Void
		{
			var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.
	
			updateTime = false;
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			vocals.pause();

			finishCallback();
		}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ")", "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

	override public function update(elapsed:Float)
	{

		floatshit += 0.05;
		float2 += 0.035;
		float3 += 0.005;
		#if !debug
		perfectMode = false;
		#end


	    if (curSong.toLowerCase() == 'necromancer')
			{
				FlxG.sound.music.volume = 1;
			}


		songPositionBar = Conductor.songPosition;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}


		super.update(elapsed);

		if (FlxG.save.data.vanillaHUD)
        {
			scoreTxt.text = "Score:" + songScore;
		}
		else
		{
			scoreTxt.text = "Score:" + 
			songScore + " / Health:" + 
			healthBar.percent + "%" + 
			" / Misses:" + misses + 
			" / HUGGED!:" + bearnotespressed +
			" / Accuracy:" + truncateFloat(accuracy, 2) + "% "
			 + (fc ? "/ FULL COMBO" : misses == 0 ? "/ A" : accuracy <= 75 ? "/ BAD" : "");
		
            scoreTxt.screenCenter(X);
		}
			
             
		if (FlxG.keys.justPressed.ENTER #if android || FlxG.android.justReleased.BACK #end && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}


		if (curSong.toLowerCase() == 'necromancer'){
			dad.y += Math.sin(floatshit);
		}

		if (curSong.toLowerCase() == 'slaughter'){
			boyfriend.y += Math.sin(floatshit);
		}


		if (FlxG.keys.justPressed.L && dad.curCharacter == 'necromancer')
			{
				dad.playAnim('singDOWN-alt', true);
			}


		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.80)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.80)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			{iconP1.animation.curAnim.curFrame = 1;
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{
						percentaura.alpha += 0.09;
					}, 150);}
		else if (healthBar.percent > 80){
			iconP1.animation.curAnim.curFrame = 2;
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					percentaura.alpha -= 0.09;
				}, 150);}
			
		else
			{iconP1.animation.curAnim.curFrame = 0;
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{
						percentaura.alpha -= 0.09;
					}, 150);}
				

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else if (healthBar.percent < 20)
			iconP2.animation.curAnim.curFrame = 2;
		else
			iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			{
			FlxG.switchState(new AnimationDebug(SONG.player2));	
			}

		if (FlxG.keys.justPressed.FOUR)
			{
			FlxG.switchState(new AnimationDebug(SONG.player1));	
			}
			
		#end

		if(FlxG.save.data.newInput)
        {
			if(FlxG.save.data.perfect)
			{
				if (misses == 1)
					{
						health = 0;
					}
			}
		}

		if (startingSong)
			{
				if (startedCountdown)
				{
					Conductor.songPosition += FlxG.elapsed * 1000;
					Conductor.rawPosition = Conductor.songPosition;
					if (Conductor.songPosition >= 0)
						startSong();
				}
			}
			else
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				Conductor.rawPosition = FlxG.sound.music.time;
				songPositionBar = (Conductor.songPosition - songLength) / 1000;
	
				currentSection = getSectionByTime(Conductor.songPosition);
	
				if (!paused)
				{
					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;
	
					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
					}
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - 0;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

				

				if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null) {
					var currentMustHitSection = PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection;
			
					// Verifica si mustHitSection ha cambiado
					if (currentMustHitSection != previousMustHitSection) {
						previousMustHitSection = currentMustHitSection; // Actualiza el estado anterior
			
						if (currentMustHitSection) {
							// in Boyfriend Cam
							switch (curStage)
							{
								case 'huggable-fields':
									defaultCamZoom = 0.65;
								case 'H.I.P':
									defaultCamZoom = 0.58;
							}	
						} else {
							// In Dad Cam
							switch (curStage)
							{
								case 'huggable-fields':
									defaultCamZoom = 0.45;
								case 'H.I.P':
									defaultCamZoom = 0.4;
							}
						trace('camZoom: ' + defaultCamZoom);
						}
					//pues funciona para cambiar el zoom de la camara dependiendo si la camara esta mirando al jugador o al oponente
					}
			
					if (!currentMustHitSection) {
						// El código existente para cuando mustHitSection está desactivado
						if (curSong.toLowerCase() == "monochrome") {
							camFollow.setPosition(dad.getMidpoint().x + 0, dad.getMidpoint().y - 50);
						} else {
							camFollow.setPosition(dad.getMidpoint().x + 0, dad.getMidpoint().y - 0);
						}
			
						switch (dad.curCharacter) {
							case 'Posh':
								camFollow.y = dad.getMidpoint().y - 100;
							case 'purplewil':
								camFollow.x = dad.getMidpoint().x + 255;
								camFollow.y = dad.getMidpoint().y - 150;
							case 'cybearzerker':
								camFollow.y = dad.getMidpoint().y - 150;
								camFollow.x = dad.getMidpoint().x + 150;
							case 'mechabearzerker':
							    camFollow.x = dad.getMidpoint().x + 120;
						}
			
						if (canShowIcons)
						{
						    iconP1.alpha = 0.7;
						    iconP2.alpha = 1;
						}
						else
						{
							iconP1.alpha = 0;
						    iconP2.alpha = 0;
						}
			
						camFollow.y += camY;
						camFollow.x += camX;
			
						if (dad.curCharacter == 'mom') {
							vocals.volume = 1;
						}
			
						if (SONG.song.toLowerCase() == 'tutorial') {
							tweenCamIn();
						}
					} else {
						// El código existente para cuando mustHitSection está activado
						camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			
						switch (curStage) {
							case 'dream?':
								camFollow.x = boyfriend.getMidpoint().x + 300;
								camFollow.y = boyfriend.getMidpoint().y - 100;
							case 'The-Core':
								camFollow.y = boyfriend.getMidpoint().y - 200;
						}


						if (canShowIcons)
						{
							iconP1.alpha = 1;
							iconP2.alpha = 0.7;
						}
						else
						{
							iconP1.alpha = 0;
							iconP2.alpha = 0;
						}
			
						camFollow.x += bfcamX;
						camFollow.y += bfcamY;
					}
				}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}


		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();


			if (curSong.toLowerCase() == 'monochrome')
			{
				videoName = 'funkindie';
				FlxG.switchState(new VideoState());
				//if you're going to use this bad code check videostate
			}
			else if (curSong.toLowerCase() == 'board-game')
				{
					videoName = 'rage';
					FlxG.switchState(new VideoState());
				}
			else{
			if (FlxG.random.bool(10))
			{
			    videoName = 'static';
			    FlxG.switchState(new VideoState());
		    }
			else if (FlxG.random.bool(5))
			{
				videoName = 'porqueagregoesto';
			    FlxG.switchState(new VideoState());
				//ya enserio, porque lo hago
			}
			else
			{
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
		    }

			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence(detailsText, "GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ")\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	    } 
		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				if (ModCharts.autoStrum && startedCountdown && !inCutscene)
					{ // sex
						strumLine.y = strumLineNotes.members[Std.int(ModCharts.autoStrumNum)].y;
					}
					if (ModCharts.updateNoteVisibilty)
					{
						for (note in 0...strumLineNotes.members.length)
						{
							if (note >= 4)
							{
								strumLineNotes.members[note].visible = true;
							}
							else
							{
								strumLineNotes.members[note].visible = true;
							}
						}
					}
				notes.forEachAlive(function(daNote:Note)
				{	
					if (ModCharts.stickNotes == true)
						{
							var noteNum:Int = 0;
							if (daNote.mustPress)
							{
								noteNum += 4; // set to bfs notes instead
							}
							noteNum += daNote.noteData;
							//daNote.x = strumLineNotes.members[noteNum].x;
						}
						if (daNote.tooLate)
							{
								daNote.active = false;
								daNote.visible = false;
							}
							else
							{
								// mag not be retarded challange(failed instantly)
								if (daNote.mustPress)
								{
									daNote.visible = true;
									daNote.active = true;
								}
								else
								{
									if(FlxG.save.data.midScroll || curSong.toLowerCase() == 'monochrome' || curStage == 'dream?' || curStage == 'boardgame')
										{daNote.visible = false;}
									daNote.active = true;
								}
							}
					
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;
	
						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

						
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
								camY = -50;
								camX = 0;
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										camY = 0;
									});
								creepzerker.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
								camX = 50;
								camY = 0;
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										camX = 0;
									});
								creepzerker.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
								camY = 50;
							    camX = 0;
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										camY = 0;
									});
								creepzerker.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
								camX = -50;
							    camY = 0;
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										camX = 0;
									});
								creepzerker.playAnim('singLEFT' + altAnim, true);
						}

						
						if (FlxG.save.data.enemieDamage)
							{
								switch(dad.curCharacter)
						        {
						           	default:
						         	health -= 0.025;
						        }
							}
						
							switch(curSong.toLowerCase())
							{
								  case 'cy-bearzerker':
									{if (healthBar.percent < 15)
										{}
									else
                                   { health -= 0.03;
									if (daNote.isSustainNote)
										{
											health -= 0.01;
										}}
									camHUD.shake(0.002);
									}
									case 'zombearzerker':
										{if (healthBar.percent < 15)
											{}
										else
									   { health -= 0.015;
										if (daNote.isSustainNote)
											{
												health -= 0.01;
											}}
										}
									case 'verruckt':
										{
									camGame.shake(0.03, 0.02, null, true);
								}
							}
						

						cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
	
						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					
	
					if (FlxG.save.data.downscroll)
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
					else
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							if (daNote.noteType == 1 || daNote.noteType == 0)
								{
									health -= 0.075;
									vocals.volume = 0;
									if (ghostTapping)
										noteMiss(daNote.noteData);
								}
						}
	
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
			cpuStrums.forEach(function(spr:FlxSprite)
				{
					if (spr.animation.finished)
					{
						spr.animation.play('static');
						spr.centerOffsets();
					}
				});


		if (!inCutscene)
			keyShit();


	}



	function endSong():Void
	{

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}
		#if mobileC
		//aaa
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			mcontrols.alpha -= 0.1;
			if (mcontrols.alpha != 0){
				tmr.reset(0.1);
			}
			else{
				trace('aweseom.');
			}
		});
		#end

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				if (SONG.song.toLowerCase() == 'mecha-bearzerker')
					{
						if (isStoryMode && !isStoryModeCompleted)
							{
								isStoryModeCompleted = true;
								storyCompleteSave.data.storyComplete = true; // Guardar que ya no es la primera vez
								storyCompleteSave.flush(); // Guardar los cambios
								FlxG.switchState(new PostStoryState());
							}
					}
				else
				{
					FlxG.switchState(new StoryMenuState());
				}

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				if (storyDifficulty == 3)
					difficulty = '-remix';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();
				
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplaySelect());
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			Conductor.changeBPM(90);
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(daNote:Note):Void
		{
			
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter(X);
			coolText.y += 350;
			coolText.antialiasing = true;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Int = 350;

			var daRating:String = "sick";

			if (noteDiff > Conductor.safeZoneOffset * 2)
				{
					daRating = 'shit';
					totalNotesHit -= 2;
					ss = false;

					if (ghostTapping)
						{
							score = -3000;
							combo = 0;
							misses++;
							health -= 0.2;
						}
					shits++;
				}
				else if (noteDiff < Conductor.safeZoneOffset * -2)
				{
					daRating = 'shit';
					totalNotesHit -= 2;
					ss = false;

					if (ghostTapping)
					{
						score = -3000;
						combo = 0;
						misses++;
						health -= 0.2;
					}
					
					shits++;
				}
				else if (noteDiff < Conductor.safeZoneOffset * -0.45)
				{
					daRating = 'bad';
					totalNotesHit += 0.2;

					if (ghostTapping)
					{
						score = -1000;
						health -= 0.03;
					}
					else
						score = 100;
					ss = false;
					bads++;
				}
				else if (noteDiff > Conductor.safeZoneOffset * 0.45)
				{
					daRating = 'bad';
					totalNotesHit += 0.2;

					if (ghostTapping)
						{
							score = -1000;
							health -= 0.03;
						}
						else
							score = 100;
					ss = false;
					bads++;
				}
				else if (noteDiff < Conductor.safeZoneOffset * -0.25)
				{
					daRating = 'good';
					totalNotesHit += 0.65;

					if (ghostTapping)
					{
						score = 200;
						//health -= 0.01;
					}
					else
						score = 200;
					ss = false;
					goods++;
				}
				else if (noteDiff > Conductor.safeZoneOffset * 0.25)
				{
					daRating = 'good';
					totalNotesHit += 0.65;

					if (ghostTapping)
						{
							score = 200;
							//health -= 0.01;
						}
						else
							score = 200;
					ss = false;
					goods++;
				}
			if (daRating == 'sick')
			{
				totalNotesHit += 1;
				var recycledNote = grpNoteSplashes.recycle(NoteSplash);
			recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
			grpNoteSplashes.add(recycledNote);
				sicks++;
			}

			if (daNote.noteType == 2)
				{
					daRating = 'hugged';
					bearnotespressed++;
					healthDrain();
				}
			else if (daNote.noteType == 3)
				{
					healthGain();
				}
			else if (daNote.noteType == 4)
				{
					necromancerArrow();
				}

			if (combo == 10)
				{
					daRating = 'combo';
				}
		
			
			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += score;
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter(X);
			rating.y += 200;
			rating.setGraphicSize(Std.int(rating.width * 0.36));
			rating.alpha = 0.4;

			if (FlxG.save.data.changedHit)
				{
					rating.x = FlxG.save.data.changedHitX;
					rating.y = FlxG.save.data.changedHitY;
				}
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			
	
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.y += 200;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);
	
	
			comboSpr.updateHitbox();
			rating.updateHitbox();

			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];
	
			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter(X);
				numScore.setGraphicSize(Std.int(numScore.width * 0.3));
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80 + 200;

				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				numScore.cameras = [camHUD];
	
				daLoop++;
			}
				trace(combo);
				trace(seperatedScore);
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});
	
			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
	
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
			{
				repPresses++;
				boyfriend.holdTimer = 0;
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					var diff = -((daNote.strumTime - Conductor.songPosition ));

					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						// the sorting probably doesn't need to be in here? who cares lol
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{
								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
									if (!inIgnoreList && !ghostTapping)
										badNoteCheck();
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
								noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
									noteCheck(controlArray, coolNote);
							}
						}
					}
					else // regular notes?
					{	
					noteCheck(controlArray, daNote);
					}

					
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else if (!ghostTapping)
				{
					badNoteCheck();
				}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && generatedMusic)
			{

				notes.forEachAlive(function(daNote:Note)
				{
					
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);

						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.playAnim('idle');
					bfcamX = 0;
		            bfcamY = 0;
				}
			}
	
			playerStrums.forEach(function(spr:FlxSprite)
			{
				switch (spr.ID)
				{
					case 2:
						if (upP && spr.animation.curAnim.name != 'confirm')
						{
							spr.animation.play('pressed');
							trace('play');
						}
						if (upR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					case 3:
						if (rightP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						
						if (rightR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					case 1:
						if (downP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (downR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					case 0:
						if (leftP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (leftR)
						{
							spr.animation.play('static');
							repReleases++;
						}
				}
				
				if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}

	function updateAccuracy()
		{
			if (misses > 0 || accuracy < 96)
				fc = false;
			else
				fc = true;
			totalPlayed += 1;
			accuracy = totalNotesHit / totalPlayed * 100;
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol

		
		{ 
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			if (controlArray[note.noteData])
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}

					// ANTI MASH CODE FOR THE BOYS

					if (mashing <= getKeyPresses(note) + 1 && mashViolations < 2)
					{
						mashViolations++;
						goodNoteHit(note, (mashing <= getKeyPresses(note) + 1));
					}
					else
					{
						playerStrums.members[note.noteData].animation.play('static');
						trace('mash ' + mashing);
					}

					if (mashing != 0)
						mashing = 0;
				}
			else if (!ghostTapping)
			{
				badNoteCheck();
			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				var noteDiff:Float = -((note.strumTime - Conductor.songPosition));

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else{
						totalNotesHit += 1;
					}

					if (note.noteData >= 0){
						health += 0.023;
					}

					switch (note.noteData)
					{
						case 2:
						boyfriend.playAnim('singUP', true);
						
						case 3:
                        boyfriend.playAnim('singRIGHT', true);
						
						case 1:
						boyfriend.playAnim('singDOWN', true);
						
						case 0:
						boyfriend.playAnim('singLEFT', true);
						
							
					}

					switch (note.noteData)
			{
				case 2:
						bfcamY = -50;
						bfcamX = 0;

				case 3:
						bfcamX = 50;
						bfcamY = 0;

				case 1:
					bfcamY = 50;
					bfcamX = 0;
				case 0:
					bfcamX = -50;
					bfcamY = 0;
			}
		
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	
	public function getSectionByTime(ms:Float):SwagSection
		{
	
			for (i in SONG.notes)
			{
				var start = TimingStruct.getTimeFromBeat((TimingStruct.getBeatFromTime(i.startTime)));
				var end = TimingStruct.getTimeFromBeat((TimingStruct.getBeatFromTime(i.endTime)));


				if (ms >= start && ms < end)
				{
					return i;
				}
			}
	
	
			return null;
		}


	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function healthDrain():Void
		{
			if (FlxG.save.data.aura)
			{drainaura.animation.play('drain', true);}
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				health -= 0.005;
			}, 230);
		}

	function healthGain():Void
		{
			if (FlxG.save.data.aura)
			{healaura.animation.play('heal', true);}
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				health += 0.005;
			}, 230);
		}

	function necromancerArrow():Void
		{
			if (FlxG.save.data.aura)
			{fire.animation.play('fire', true);}
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				health -= 0.005;
			}, 150);
		}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	function sectionHit() {
		// shiet modchart code but it doesnt run often so it should be fine
		// bandaid
		try {
		if (SONG.notes[Math.floor(curStep / 16)].cameracancel) {
			ModCharts.cancelCamera(FlxG.camera);
			ModCharts.tweenCameraAngle(0, 1, FlxG.camera);
		}

		if (SONG.notes[Math.floor(curStep / 16)].camerabounce) {
			ModCharts.cameraBounce(camGame, Conductor.crochet / 1000, 200);
		}

		if (SONG.notes[Math.floor(curStep / 16)].cameraflip) {
			ModCharts.tweenCameraAngle(180, 1, FlxG.camera);
		}

		if (SONG.notes[Math.floor(curStep / 16)].cancel) {
			lastModchart = false;
			for (note in 0...strumLineNotes.members.length) {
				ModCharts.cancelMovement(strumLineNotes.members[note]);
				if (strumLineNotes.members[note].alpha != 1) {
					ModCharts.fadeInObject(strumLineNotes.members[note]);
				}
			}
		}
		if (SONG.notes[Math.floor(curStep / 16)].fadein) {
			lastModchart = false;
			for (note in 0...strumLineNotes.members.length) {
				ModCharts.fadeInObject(strumLineNotes.members[note]);
			}
		}
			if (SONG.notes[Math.floor(curStep / 16)].circle) {
				FlxG.log.add("Circle is true");
					FlxG.log.add("Starting circle");
					lastModchart = true;
					for (note in 0...strumLineNotes.members.length) {
						ModCharts.circleLoop(strumLineNotes.members[note], 100, 3);
					}
			}
			if (SONG.notes[Math.floor(curStep / 16)].fadeout) {
					lastModchart = true;
					for (note in 0...strumLineNotes.members.length) {
						ModCharts.fadeOutObject(strumLineNotes.members[note]);
					}
			}
			 if (SONG.notes[Math.floor(curStep / 16)].bounce) {
					lastModchart = true;
					strumLineNotes.forEach(function(note)
					{
						ModCharts.bounceLoop(note, Conductor.crochet / 1000);
					});
			}
		} catch(err) {
			trace("TRIED TO RUN CHART AT END OF SONG???");
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			{
				resyncVocals();
			}

		if (thebearremix)
		{
			switch (curStep)
			{
				case 578:
					defaultCamZoom += 0.85;
					camHUD.visible = false;
				case 605:
					boyfriend.playAnim('hey', true);
				case 608:
					camHUD.visible = true;
					defaultCamZoom -= 0.85;
			}
		}

		if (curSong.toLowerCase() == 'the-bearzerker')
			{
				switch(curStep)
				{
					//case 16:
						//FlxG.sound.play(Paths.sound('whistle'), 1, false);
						//new FlxTimer().start(0.01, function(tmr:FlxTimer)
							//{
								//bearber.alpha += 0.045;
							//}, 125);
					//case 29:
						//new FlxTimer().start(0.01, function(tmr:FlxTimer)
							//{
								//bearber.alpha -= 0.045;
							//}, 125);
					case 64, 66, 72, 80, 82, 88, 96, 98, 104, 112, 114, 120:
						FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
						FlxG.camera.zoom += 0.030;
				}
			}

		if (curSong.toLowerCase() == 'monochrome')
			{
				switch (curStep)
				{
					case 368, 816, 1264:
						creepable.animation.play('idle', true);
				}
			}

		if (curSong.toLowerCase() == 'necromancer')
			{
				switch (curStep)
				{
					case 760:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('time'));
			ready.scrollFactor.set(0, 0);
			ready.updateHitbox();
			ready.cameras = [camHUD];

			ready.screenCenter();
			ready.y -= 100;
			add(ready);
			FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					ready.destroy();
				}
			});
						dad.playAnim('timetodie', true);
					case 762:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('to'));
			ready.scrollFactor.set(0, 0);
			ready.updateHitbox();
			ready.cameras = [camHUD];

			ready.screenCenter();
			ready.y -= 100;
			add(ready);
			FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					ready.destroy();
				}
			});
					case 764, 800, 896, 992, 1280:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('die'));
			ready.scrollFactor.set(0, 0);
			ready.updateHitbox();
			ready.cameras = [camHUD];

			ready.screenCenter();
			ready.y -= 100;
			add(ready);
			FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					ready.destroy();
				}
			});
			//too lazy to rename the variable lol
					case 768:
						remove(dad);
						dad = new Character(dad.x, dad.y, 'necromancer-schyte');
						add(dad);
					case 1024:
						remove(dad);
						dad = new Character(dad.x, dad.y, 'necromancer');
						add(dad);
			}
		}

		if (SONG.song.toLowerCase() == 'mecha-bearzerker')
			{
				switch (curStep)
				{

					case 1231:
					defaultCamZoom = 1.4;
					new FlxTimer().start(0.3, function(tmr3:FlxTimer)
					{
						iconP1.alpha -= 0.9;
						iconP2.alpha -= 0.9;
						camHUD.alpha -= 0.05;
						healthBar.alpha = 0.09;
						healthBarBG.alpha = 0.09;
						new FlxTimer().start(0.01, function(tmr:FlxTimer)
							{
								dad.alpha -= 0.005;
								gf.alpha -= 0.005;
							}, 230);
		                
					});

					case 1421:
						defaultCamZoom = 0.58;
						new FlxTimer().start(0.3, function(tmr3:FlxTimer)
						{
							iconP1.alpha += 1;
							iconP2.alpha += 1;
							healthBar.alpha += 1;
						    healthBarBG.alpha += 1;
							new FlxTimer().start(0.01, function(tmr:FlxTimer)
								{
									dad.alpha += 0.005;
									gf.alpha += 0.005;
								}, 230);
						});
				}
			}
				
		if (curSong == 'Milf')
          {
			  switch (curStep)
			  {
				case 672:
					momT = new FlxTrail(dad, null, 5, 7, 0.3, 0.2);
			        add(momT);

				case 736:
					bfT = new FlxTrail(boyfriend, null, 5, 7, 0.3, 0.2);
			        add(bfT);
					remove(momT);

				case 800:
                    remove(bfT);
			  }
		  }

		if (curSong.toLowerCase() == 'necromancer')
			{
				switch(curStep)
				{

				case 1285:
				    new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{
						camera.alpha -= 0.009;
						camHUD.alpha -= 0.008;
					}, 230);
				}
				
			}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		if (modcharting) {
			// i doubt its this easy
		//	trace(modchart);
			//trace(PlayState.instance.strumLineNotes.getFirstAlive().x);
			var parser = new hscript.Parser();
			var ast = parser.parseString(modchart);
			var interp = new hscript.Interp();
			interp.variables.set("stepping", true);
			interp.variables.set("beatShit", curBeat);
			interp.variables.set("stepShit", curStep);
			interp.variables.set("ModCharts", ModCharts);
			interp.variables.set("game", PlayState.instance);
			interp.variables.set("strumLineNotes", strumLineNotes);
			interp.variables.set("strumLineNotes", strumLineNotes);
			interp.variables.set("playerStrums", playerStrums);
			interp.variables.set("player2Strums", cpuStrums);
			interp.variables.set("dad", dad);
			interp.variables.set("boyfriend", boyfriend);
			interp.variables.set("gf", gf);
			interp.variables.set("notes", notes);
			interp.variables.set("mainCamera", FlxG.camera);
			interp.variables.set("camHUD", camHUD);
			interp.variables.set("iconP1", iconP1);
			interp.variables.set("iconP2", iconP2);
			interp.variables.set("assets", Assets);
			// shit i *cough* stole *cough* borrowed.
			interp.variables.set("FlxSprite", flixel.FlxSprite);
			interp.variables.set("FlxTimer", FlxTimer);
			interp.variables.set("Math", Math);
			interp.variables.set("Std", Std);
			interp.variables.set("FlxTween", FlxTween);
			interp.variables.set("FlxText", FlxText);

			interp.execute(ast);
		}


		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence("(ON DEVELOPMENT)" + detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{

			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && curBeat % idleBeat == 0)
			{	
				dad.dance();
				camX = 0;
				camY = 0;
			}
		}

		if (modcharting) {
			// i doubt its this easy
		//	trace(modchart);
			var parser = new hscript.Parser();
			var ast = parser.parseString(modchart);
			var interp = new hscript.Interp();
			interp.variables.set("stepping", false);
			interp.variables.set("beatShit", curBeat);
			interp.variables.set("stepShit", curStep);
			interp.variables.set("ModCharts", ModCharts);

			// i hate my life
			interp.variables.set("strumLineNotes", strumLineNotes);
			interp.variables.set("strumLineNotes", strumLineNotes);
			interp.variables.set("playerStrums", playerStrums);
			interp.variables.set("player2Strums", cpuStrums);
			interp.variables.set("dad", dad);
			interp.variables.set("boyfriend", boyfriend);
			interp.variables.set("gf", gf);
			interp.variables.set("notes", notes);
			interp.variables.set("mainCamera", FlxG.camera);
			interp.variables.set("camHUD", camHUD);
			interp.variables.set("iconP1", iconP1);
			interp.variables.set("iconP2", iconP2);
			interp.variables.set("assets", Assets);
			// shit i *cough* stole *cough*
			interp.variables.set("FlxSprite", flixel.FlxSprite);
			interp.variables.set("FlxTimer", FlxTimer);
			interp.variables.set("Math", Math);
			interp.variables.set("Std", Std);
			interp.variables.set("FlxTween", FlxTween);
			interp.variables.set("FlxText", FlxText);
			interp.execute(ast);
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curStage == 'huggable-fields')
		{
			if (curBeat % 2 == 0)
			{
			oliver.animation.play('idle', true);
            necromancerbe.animation.play('idle', true);
            orangehuggable.animation.play('idle', true);
            pepperboibe.animation.play('idle', true);
			}
			frontbears1.animation.play('idle', true);
			frontbears2.animation.play('idle', true);
			frontbears3.animation.play('idle', true);
			frontbears4.animation.play('idle', true);
		}

		if (curSong.toLowerCase() == 'the-bearzerker')
		{
			switch (curBeat){
				case 28:
					generateStaticArrows(0);
				    generateStaticArrows(1);
				case 30:
						new FlxTimer().start(0.01, function(tmr:FlxTimer)
							{
							healthBar.alpha += 0.01;
		                    healthBarBG.alpha += 0.01;
		                    healaura.alpha += 0.01;
		                    fire.alpha += 0.01;
		                    drainaura.alpha += 0.01;
		                    percentaura.alpha += 0.01;
		                    iconP1.alpha += 0.01;
		                    iconP2.alpha += 0.01;
		                    scoreTxt.alpha += 0.01;
		                    songTxt.alpha += 0.01;
		                    timeBarBG.alpha += 0.01;
		                    timeTxt.alpha += 0.01;
		                    timeBar.alpha += 0.01;
		                    difficultyTxt.alpha += 0.01;
		                    ratingTxt.alpha += 0.01;
							}, 230);
				case 31:
					canShowIcons = true;
			}
		}

		

		if (curSong.toLowerCase() == 'cy-bearzerker') {
			switch (curBeat) {
				case 2:
					prelevel = new FlxSprite().loadGraphic(Paths.image('prelevelwarning'));
					prelevel.scrollFactor.set(0, 0);
					prelevel.updateHitbox();
					prelevel.cameras = [camHUD];
		
					prelevel.screenCenter();
					add(prelevel);
					FlxTween.tween(prelevel, {alpha: 1}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut
					});
					return; // Termina el caso 2
				case 10:
					FlxTween.tween(prelevel, {alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(tween:FlxTween) {
							prelevel.destroy();
						}
					});
					return; // Termina el caso 10
				case 52:
					generateStaticArrows(0);
				case 84:
					generateStaticArrows(1);
				case 56:
					new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							healthBar.alpha += 0.01;
		                    healthBarBG.alpha += 0.01;
		                    healaura.alpha += 0.01;
		                    fire.alpha += 0.01;
		                    drainaura.alpha += 0.01;
		                    percentaura.alpha += 0.01;
		                    iconP1.alpha += 0.01;
		                    iconP2.alpha += 0.01;
		                    scoreTxt.alpha += 0.01;
		                    songTxt.alpha += 0.01;
		                    timeBarBG.alpha += 0.01;
		                    timeTxt.alpha += 0.01;
		                    timeBar.alpha += 0.01;
		                    difficultyTxt.alpha += 0.01;
		                    ratingTxt.alpha += 0.01;
						}, 230);
				case 57:
					canShowIcons = true;
			}
		}
		


		if (curSong.toLowerCase() == 'dreaming')
			{
				switch (curBeat)
				{

		case 13:
			var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready'));
			ready.scrollFactor.set(0, 0);
			ready.updateHitbox();
			ready.cameras = [camHUD];

			ready.screenCenter();
			ready.y -= 100;
			add(ready);
			FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					ready.destroy();
				}
			});
			case 14:
				var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('set'));
		set.scrollFactor.set(0, 0);
		set.updateHitbox();
		set.cameras = [camHUD];

		set.screenCenter();
		set.y -= 100;
		add(set);
		FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				set.destroy();
			}
		});
		case 15:
			var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go'));
		go.scrollFactor.set(0, 0);
		go.updateHitbox();
		go.cameras = [camHUD];

		go.screenCenter();
		go.y -= 100;
		add(go);
		FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				go.destroy();
			}
		});
				}
			}

		if (FlxG.save.data.proggresiveDamage)
			{
				health -= 0.019;
			}

		if (curBeat % gfSpeed == 0)
			{
				gf.dance();
				iconBop();
			    FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.20);
			}

					if (curBeat % idleBeat == 0)
					{
						if (idleToBeat && !dad.animation.curAnim.name.startsWith('sing'))
							dad.dance();
						if (idleToBeat && !boyfriend.animation.curAnim.name.startsWith('sing'))
							boyfriend.dance();
					}



		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
			{
				dad.playAnim('cheer', true);
			}
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			
			case 'huggable-fields':

			case 'H.I.P':
			     justabear.animation.play('idle', true);

		    case 'zombocalypse':
				if (curBeat % 2 == 0)
					{
						pepperboi.animation.play('idle', true);
					}	
	
	if (curBeat % 2 == 0)
					{
						colbear.animation.play('idle', true);
					}
	
	if (curBeat % 2 == 0)
					{
						floor2.animation.play('idle', true);
					}
	
	if (curBeat % 4 == 0)
					{
						floor.animation.play('idle', true);
					}
	
	if (curBeat % 2 == 0)
					{
						dacouple.animation.play('idle', true);
					}
	

			
			case 'necrotower':
				blu.animation.play('idle', true);
				justabear.animation.play('idle', true);
				justbearhands.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	function remixzoom() 
	{
	}

	function iconBop(?_scale:Float = 1.25, ?_time:Float = 0.2):Void {
		iconP1.iconScale = iconP1.defualtIconScale * _scale;
		iconP2.iconScale = iconP2.defualtIconScale * _scale;

		FlxTween.tween(iconP1, {iconScale: iconP1.defualtIconScale}, _time, {ease: FlxEase.quintOut});
		FlxTween.tween(iconP2, {iconScale: iconP2.defualtIconScale}, _time, {ease: FlxEase.quintOut});
	}

	var curLight:Int = 0;
}