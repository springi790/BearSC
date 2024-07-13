package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var cameraPosition:Array<Float> = [0, 0];
	public var curCharacter:String = 'bf';
    public var noteStyle:String = 'normal';
	public var healthcolor:Int = 0x00FF00;

	public var holdTimer:Float = 0;
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose


	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				noteStyle = 'normal';
				healthcolor = 0xFFca1f6f;
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', false);
				animation.addByPrefix('singLEFT', 'GF left note', false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', false);
				animation.addByPrefix('singUP', 'GF Up Note', false);
				animation.addByPrefix('singDOWN', 'GF Down Note', false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29], "", false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "");
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", false);
				animation.addByPrefix('scared', 'GF FEAR');

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'flippy-blood':
					noteStyle = 'flippy';
					healthcolor = 0xFFca1f6f;
					tex = Paths.getSparrowAtlas("characters/FLIPPY_bloody");
					frames = tex;
					animation.addByPrefix('idle', "FLIPPY Idle", 24, true);
					animation.addByPrefix('singUP', 'FLP M UP', 24, false);
					animation.addByPrefix('singDOWN', 'FLP M DOWN', 24, false);
					animation.addByPrefix('singLEFT', 'FLP M LEFT', 24, false);
					animation.addByPrefix('singRIGHT', 'FLP M RIGHT', 24, false);
	
					addOffset('idle');
					addOffset("singUP", 66, 89);
					addOffset("singRIGHT", 68, 32);
					addOffset("singLEFT", 140, 94);
					addOffset("singDOWN", -14, -131);
	
					playAnim('idle');
					if(!FlxG.save.data.antialiasing){antialiasing = false;}

			case 'gf-christmas':
				noteStyle = 'normal';
				healthcolor = 0xFFca1f6f;
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', false);
				animation.addByPrefix('singLEFT', 'GF left note', false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', false);
				animation.addByPrefix('singUP', 'GF Up Note', false);
				animation.addByPrefix('singDOWN', 'GF Down Note', false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29], "", false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "");
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", false);
				animation.addByPrefix('scared', 'GF FEAR');

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

			case 'gf-car':
				noteStyle = 'normal';
				healthcolor = 0xFFca1f6f;
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29], "",
					false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

			case 'gf-pixel':
				noteStyle = 'normal';
				healthcolor = 0xFFca1f6f;
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29], "", false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				noteStyle = 'normal';
				healthcolor = 0xFFc885e5;
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance');
				animation.addByPrefix('singUP', 'Dad Sing Note UP');
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT');
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN');
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT');

				loadOffsetFile(curCharacter);

				playAnim('idle');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'necromancer':
				noteStyle = 'necromancer';
				healthcolor = 0xFF272727;
				tex = Paths.getSparrowAtlas('characters/necromancer-test');
				frames = tex;
				animation.addByPrefix('danceRight', 'Necromancer Idle', 24, false);
				animation.addByPrefix('danceLeft', 'Necromancer Alt-idle', 24, false);
				animation.addByPrefix('singUP', 'Necromancer Up', false);
				if (isPlayer)
					{
						animation.addByPrefix('singRIGHT', 'Necromancer Right', false);
						animation.addByPrefix('singDOWN', 'Necromancer Down', false);
						animation.addByPrefix('singLEFT', 'Necromancer Left', false);
					}
				else
					{
						animation.addByPrefix('singRIGHT', 'Necromancer Right', false);
						animation.addByPrefix('singDOWN', 'Necromancer Down', false);
						animation.addByPrefix('singLEFT', 'Necromancer Left', false);
					}
				animation.addByPrefix('singDOWN-alt', 'Necomancer Laughing', 24, false);
				animation.addByPrefix('timetodie', 'Necromancer Time To Die', 15, false);

				addOffset('idle', 0, 0);

				if (isPlayer){
                addOffset('singUP', 45, 112);
				addOffset('singRIGHT', 115, -22);
				addOffset('singLEFT', 192, 138);
				addOffset('singDOWN', 15, 0);
				addOffset('singDOWN-alt', -44, -56);
				addOffset('danceLeft', 107, 2);
				addOffset('timetodie', 103, -13);
				}else{
				addOffset('singUP', 32, 112);
				addOffset('singRIGHT', -7, -22);
				addOffset('singLEFT', 261, 138);
				addOffset('singDOWN', 186, 0);
				addOffset('singDOWN-alt', 38, 54);
				addOffset('danceLeft', 107, 2);
				addOffset('timetodie', 103, -13);
				}
				
				var widShit = Std.int(width * 10);
				setGraphicSize(Std.int(widShit * -2));
		     	updateHitbox();

				playAnim('danceRight');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'necromancer-schyte':
				noteStyle = 'necromancer';
				healthcolor = 0xFF272727;
				tex = Paths.getSparrowAtlas('characters/necromancer-test');
				frames = tex;
				animation.addByPrefix('danceRight', 'Necromancer Idle', 24, false);
				animation.addByPrefix('danceLeft', 'Necromancer Alt-idle', 24, false);
				animation.addByPrefix('singUP', 'Necromancer Up', false);
				if (isPlayer)
					{
						animation.addByPrefix('singRIGHT', 'Necromancer Right', false);
						animation.addByPrefix('singDOWN', 'Necromancer Down', false);
						animation.addByPrefix('singLEFT', 'Necromancer Left', false);
					}
				else
					{
						animation.addByPrefix('singRIGHT', 'Necromancer Right', false);
						animation.addByPrefix('singDOWN', 'Necromancer Down', false);
						animation.addByPrefix('singLEFT', 'Necromancer Left', false);
					}
				animation.addByPrefix('singDOWN-alt', 'Necomancer Laughing', 24, false);
				animation.addByPrefix('timetodie', 'Necromancer Time To Die', 15, false);

				addOffset('idle', 0, 0);

				if (isPlayer){
                addOffset('singUP', 45, 112);
				addOffset('singRIGHT', 115, -22);
				addOffset('singLEFT', 192, 138);
				addOffset('singDOWN', 15, 0);
				addOffset('singDOWN-alt', -44, -56);
				addOffset('danceLeft', 107, 2);
				addOffset('timetodie', 103, -13);
				}else{
				addOffset('singUP', 32, 112);
				addOffset('singRIGHT', -7, -22);
				addOffset('singLEFT', 261, 138);
				addOffset('singDOWN', 186, 0);
				addOffset('singDOWN-alt', 38, 54);
				addOffset('danceLeft', 107, 2);
				addOffset('timetodie', 103, -13);
				}
				
				var widShit = Std.int(width * 10);
				setGraphicSize(Std.int(widShit * -2));
		     	updateHitbox();

				playAnim('danceLeft');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'necromancer-player':
				noteStyle = 'necromancer';
				healthcolor = 0xFF272727;
				tex = Paths.getSparrowAtlas('characters/necromancer-test');
				frames = tex;
				animation.addByPrefix('idle', 'Necromancer Alt-idle', 24, false);
				animation.addByPrefix('timetodie', 'Necromancer Time To Die', 15, false);
				animation.addByPrefix('singUP', 'Necromancer Up', false);
				animation.addByPrefix('singRIGHT', 'Necromancer Left', false);
				animation.addByPrefix('singDOWN', 'Necromancer Down', false);
				animation.addByPrefix('singLEFT', 'Necromancer Right', false);
				animation.addByPrefix('singUPmiss', 'Necromancer Up', false);
				animation.addByPrefix('singRIGHTmiss', 'Necromancer Left', false);
				animation.addByPrefix('singDOWNmiss', 'Necromancer Down', false);
				animation.addByPrefix('singLEFTmiss', 'Necromancer Right', false);
				animation.addByPrefix('singDOWN-alt', 'Necromancer Laughing', 24, false);

				addOffset('idle', 0, 0);
                addOffset('timetodie', 250, -5);
                addOffset('singUP', 45, 112);
				addOffset('singLEFT', 115, -22);
				addOffset('singRIGHT', 192, 138);
				addOffset('singDOWN', 15, 0);
				addOffset('singUPmiss', 45, 112);
				addOffset('singLEFTmiss', 115, -22);
				addOffset('singRIGHTmiss', 192, 138);
				addOffset('singDOWNmiss', 15, 0);
				addOffset('singDOWN-alt', -44, -56);
				
				var widShit = Std.int(width * 10);
				setGraphicSize(Std.int(widShit * -2));
		     	updateHitbox();

				playAnim('idle');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'necro':
					noteStyle = 'necromancer';
					healthcolor = 0xFF272727;
					tex = Paths.getSparrowAtlas('characters/Necro');
				    frames = tex;
					animation.addByPrefix('idle', 'Necro idle', 24, false);
					animation.addByPrefix('timetodie', 'Necro timetodie', 15, false);
					addOffset('idle', 0, 0);
					addOffset('idle-alt', -50, 0);
					addOffset('timetodie', -50, 0);
					playAnim('idle');
					if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'bearzerker':
					noteStyle = 'normal';
					healthcolor = 0xFFFFA0DF;
					tex = Paths.getSparrowAtlas('characters/Bearzerker');
					frames = tex;
					animation.addByPrefix('idle', 'Bearzerker_Idle', 24, false);
					animation.addByPrefix('singUP', 'Bearzerker up pose', 24, false);
					animation.addByPrefix('singRIGHT', 'Bearzerker Right pose', 24, false);
					animation.addByPrefix('singDOWN', 'Bearzerker Down pose', 24, false);
					animation.addByPrefix('singLEFT', 'Bearzerker Left pose', 24, false);
	
					addOffset('idle');
					addOffset("singUP", 340, 570);
					addOffset("singRIGHT", -20, -140);
					addOffset("singLEFT", 200, 13);
					addOffset("singDOWN", 230, -180);
	
					playAnim('idle');
					if(!FlxG.save.data.antialiasing){antialiasing = false;}
				
				case 'purplewil':
					noteStyle = 'normal';
					healthcolor = 0xFFA257AA;
					tex = Paths.getSparrowAtlas('characters/purple-wil');
					frames = tex;
					animation.addByPrefix('idle', 'purple Wil Idle', 24, false);
					animation.addByPrefix('singUP', 'purple Wil Up pose', 24, false);
					animation.addByPrefix('singRIGHT', 'purple Wil Left pose', 24, false);
					animation.addByPrefix('singDOWN', 'purple Wil Down pose', 24, false);
					animation.addByPrefix('singLEFT', 'purple Wil Right pose', 24, false);
		
					addOffset('idle');
					addOffset("singUP", -191, 366);
					addOffset("singRIGHT", -270, 40);
					addOffset("singLEFT", -10, 190);
					addOffset("singDOWN", -250, -10);
		
					playAnim('idle');
					if(!FlxG.save.data.antialiasing){antialiasing = false;}
	
				case 'mechabearzerker':
					noteStyle = 'normal';
					healthcolor = 0xFFC085AC;
					tex = Paths.getSparrowAtlas('characters/Mecha-Bearzerker');
					frames = tex;
					animation.addByPrefix('idle', 'Mecha_Idle', 24, false);
					animation.addByPrefix('singUP', 'Mecha_Up', 24, false);
					animation.addByPrefix('singRIGHT', 'Mecha_Right', 24, false);
					animation.addByPrefix('singDOWN', 'Mecha_Down', 24, false);
					animation.addByPrefix('singLEFT', 'Mecha_Left', 24, false);
	
					addOffset('idle');
					addOffset("singUP", 278, 180);
					addOffset("singRIGHT", 173, 137);
					addOffset("singLEFT", 350, 41);
					addOffset("singDOWN", 460, -5);
	
					playAnim('idle');
					if(!FlxG.save.data.antialiasing){antialiasing = false;}	

					case 'cybearzerker':
						noteStyle = 'cy-bearzerker';
						healthcolor = 0xFF5C5C5C;
						tex = Paths.getSparrowAtlas('characters/Cy-Bearzerker');
						frames = tex;
						animation.addByPrefix('idle', 'Cy Idle', 24, false);
						animation.addByPrefix('singUP', 'Cy Up', 24, false);
						animation.addByPrefix('singRIGHT', 'Cy Right', 24, false);
						animation.addByPrefix('singDOWN', 'Cy Down', 24, false);
						animation.addByPrefix('singLEFT', 'Cy Left', 24, false);
		
						addOffset('idle');
						addOffset("singUP", 418, -104);
						addOffset("singRIGHT", -590, -4);
						addOffset("singLEFT", 0, 0);
						addOffset("singDOWN", -129, -240);
		
						playAnim('idle');
						if(!FlxG.save.data.antialiasing){antialiasing = false;}	

					case 'creepzerker':
						noteStyle = 'normal';
						healthcolor = 0xFF7E335B;
						tex = Paths.getSparrowAtlas('characters/Creepzerker');
						frames = tex;
						animation.addByPrefix('idle', 'Creepzerker Idle', 24, false);
						animation.addByPrefix('singUP', 'Creepzerker Up', 24, false);
						animation.addByPrefix('singRIGHT', 'Creepzerker Right', 24, false);
						animation.addByPrefix('singDOWN', 'Creepzerker Down', 24, false);
						animation.addByPrefix('singLEFT', 'Creepzerker Left', 24, false);
		
						addOffset('idle');
						addOffset("singUP", 0, 37);
						addOffset("singRIGHT", 0, -78);
						addOffset("singLEFT", 0, -60);
						addOffset("singDOWN", 0, -47);
		
						playAnim('idle');
						if(!FlxG.save.data.antialiasing){antialiasing = false;}

			case 'bf':
				noteStyle = 'normal';
				healthcolor = 0xFF51d8fb;
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', false);
				animation.addByPrefix('hey', 'BF HEY!!', false);
				animation.addByPrefix('hit', 'BF hit', false);
				animation.addByPrefix('dodge', 'boyfriend dodge', false);

				animation.addByPrefix('firstDeath', "BF Death", false);
				animation.addByPrefix('deathLoop', "Bf Dies Loop B", true);
				animation.addByPrefix('deathConfirm', "Bf Dies Loop B", false);

				animation.addByPrefix('scared', 'BF idle shaking');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'oliver':
					noteStyle = 'normal';
					healthcolor = 0xFF5B4536;
					var tex = Paths.getSparrowAtlas('characters/Oliver');
					frames = tex;
					animation.addByPrefix('idle', 'Oliver idle', 24, false);
					animation.addByPrefix('singUP', 'Oliver up pose', false);
					animation.addByPrefix('singLEFT', 'Oliver left pose', false);
					animation.addByPrefix('singRIGHT', 'Oliver right pose', false);
					animation.addByPrefix('singDOWN', 'Oliver down pose', false);
					animation.addByPrefix('singUPmiss', 'Oliver up wrong', false);
					animation.addByPrefix('singLEFTmiss', 'Oliver Left Wrong', false);
					animation.addByPrefix('singRIGHTmiss', 'Oliver right wrong', false);
					animation.addByPrefix('singDOWNmiss', 'Oliver down wrong', false);
	
					addOffset('idle');
					addOffset("singUP", 74, 197);
					addOffset("singRIGHT", -70, 20);
					addOffset("singLEFT", 0, 17);
					addOffset("singDOWN", -31, 0);
					addOffset("singUPmiss", 80, 222);
					addOffset("singRIGHTmiss", -50, 140);
					addOffset("singLEFTmiss", -4, 45);
					addOffset("singDOWNmiss", 0, 33);

					playAnim('idle');

					flipX = true;

				case 'leo':
				noteStyle = 'normal';
				var tex = Paths.getSparrowAtlas('characters/Leo');
				frames = tex;
				animation.addByIndices('danceRight', 'Leo Idle', [14, 1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24);
				animation.addByIndices('danceLeft', 'Leo Idle', [14, 1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24);
				playAnim('danceRight');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'bf-bearzerker':
					noteStyle = 'normal';
					healthcolor = 0xFF51d8fb;
				var tex = Paths.getSparrowAtlas('characters/BF');
				frames = tex;
				animation.addByPrefix('idle', 'BF IDLE0', 24, false);
				animation.addByPrefix('singUP', 'BF UP0', false);
				animation.addByPrefix('singLEFT', 'BF LEFT0', false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT0', false);
				animation.addByPrefix('singDOWN', 'BF DOWN0', false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS0', false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS0', false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS0', false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS0', false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'bf-bw':
				noteStyle = 'normal';
				healthcolor = 0xFF51d8fb;
				var tex = Paths.getSparrowAtlas('characters/bf-bw');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP0', false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT0', false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT0', false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN0', false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'bf-dead':
				var tex = Paths.getSparrowAtlas('characters/BoyFriendDeath_Assets');
				frames = tex;

				animation.addByPrefix('singUP', "Bf Death", 10, false);
				animation.addByPrefix('firstDeath', "Bf Death", 10, false);
				animation.addByPrefix('deathLoop', "Bf A Death Loop", true);
				animation.addByPrefix('deathConfirm', "Bf B Death Confirm", 10, false);
				animation.play('firstDeath');

				loadOffsetFile(curCharacter);

				playAnim('firstDeath');

				flipX = true;
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'bf-dia':
				noteStyle = 'normal';
				healthcolor = 0xFF000000;
				var tex = Paths.getSparrowAtlas('characters/Dia_assets');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', false);
				animation.addByPrefix('singLEFT', 'Left', false);
				animation.addByPrefix('singRIGHT', 'Right', false);
				animation.addByPrefix('singDOWN', 'Down', false);
				animation.addByPrefix('singUPmiss', '1Miss Up', false);
				animation.addByPrefix('singLEFTmiss', '2Miss Left', false);
				animation.addByPrefix('singRIGHTmiss', '3MissRight', false);
				animation.addByPrefix('singDOWNmiss', '4MissDown', false);

				addOffset('idle');
				addOffset("singUP", -17, 9);
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss", -7, 4);
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss", -8, 0);
				addOffset("singDOWNmiss");

				playAnim('idle');

				var widShit = Std.int(width * 6);
				setGraphicSize(Std.int(widShit * 0.22));

				flipX = true;
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'bearzombie':
				noteStyle = 'zombearzerker';
				healthcolor = 0xFFB16F9B;
				var tex = Paths.getSparrowAtlas('characters/Bearzombie');
				frames = tex;
				animation.addByPrefix('idle', 'Bearzombie Idle', 24, false);
				animation.addByPrefix('singUP', 'Bearzombie Up', false);
				animation.addByPrefix('singRIGHT', 'Bearzombie Right', false);
				animation.addByPrefix('singDOWN', 'Bearzombie Down', false);
				animation.addByPrefix('singLEFT', 'Bearzombie Left', false);
	
				addOffset('idle');
				addOffset("singUP", 94, 202);
				addOffset("singRIGHT", -244, -79);
				addOffset("singLEFT", 304, -134);
				addOffset("singDOWN", -232, -374);
	
				playAnim('idle');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}

				case 'Posh':
				noteStyle = 'normal';
				healthcolor = 0xFFB16F9B;
				var tex = Paths.getSparrowAtlas('characters/Posh');
				frames = tex;
				animation.addByPrefix('idle', 'Posh Idle', 24, false);
				animation.addByPrefix('singUP', 'Posh up pose', false);
				animation.addByPrefix('singRIGHT', 'Posh right pose', false);
				animation.addByPrefix('singDOWN', 'Posh down pose', false);
				animation.addByPrefix('singLEFT', 'Posh left pose', false);
	
				addOffset('idle');
				addOffset("singUP", 80, 60);
				addOffset("singRIGHT", -50, 45);
				addOffset("singLEFT", 38, 8);
				addOffset("singDOWN", 8, 15);
	
				playAnim('idle');
				if(!FlxG.save.data.antialiasing){antialiasing = false;}
		}	

		dance();

		if (isPlayer)
		{
			if (curCharacter == 'necromancer-player'){
			flipX = !flipX;
			}else{
			flipX = !flipX;	
			}
			// Doesn't flip for BF, since his are already in the right place???
			if (!isPlayer)
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String)
		{
			var offset:Array<String> = CoolUtil.coolTextFile(Paths.loadOffsetFile('images/characters/' + character + "Offsets"));
	
			for (i in 0...offset.length)
			{
				var data:Array<String> = offset[i].split(' ');
				addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
			}
		}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false)
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
					case 'necromancer':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceRight');

					case 'necromancer-schyte':
					danced = !danced;

					if (danced)
						playAnim('danceLeft');
					else
						playAnim('danceLeft');
				        						
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
