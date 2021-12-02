package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;


	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteType:Int = 0;

	public var hitHealth:Float = 0.023;
	public var missHealth:Float = 0.0475;

	public var playedEditorClick:Bool = false;
	public var editorBFNote:Bool = false;
	public var absoluteNumber:Int;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0, ?noteStyle:String = 'normal')
		{
			super();
 
			if (prevNote == null)
				prevNote = this;
			this.noteType = noteType;
			this.prevNote = prevNote;
			isSustainNote = sustainNote;
 
			x += 50;
			// MAKE SURE ITS DEFINITELY OFF SCREEN?
			y -= 2000;
			this.strumTime = strumTime;
 
			if (this.strumTime < 0 )
				this.strumTime = 0;
 
			this.noteData = noteData;
 
			var daStage:String = PlayState.curStage;
 
			switch (PlayState.SONG.song)
			{
				case 'senpai' | 'roses' | 'thorns':
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels','week6'), true, 17, 17);
 
					if (noteType == 2)
						{
							animation.add('greenScroll', [22]);
							animation.add('redScroll', [23]);
							animation.add('blueScroll', [21]);
							animation.add('purpleScroll', [20]);
						}
					else
						{
							animation.add('greenScroll', [6]);
							animation.add('redScroll', [7]);
							animation.add('blueScroll', [5]);
							animation.add('purpleScroll', [4]);
						}
 
					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds','week6'), true, 7, 6);
 
						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);
 
						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}
 
					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
				default:
						frames = Paths.getSparrowAtlas('notes/' + noteStyle);
						var fuckingSussy = Paths.getSparrowAtlas('NOTE_bear');
						for(amogus in fuckingSussy.frames)
							{
								this.frames.pushFrame(amogus);
							}
 
						switch(noteType)
						{
							case 2:
							{
								frames = Paths.getSparrowAtlas('NOTE_bear');
								animation.addByPrefix('greenScroll', 'bearup', 24, true);
								animation.addByPrefix('redScroll', 'bearright', 24, true);
								animation.addByPrefix('blueScroll', 'beardown', 24, true);
								animation.addByPrefix('purpleScroll', 'bearleft', 24, true);

								animation.addByPrefix('purpleholdend', 'bear tail');
								animation.addByPrefix('greenholdend', 'bear tail');
								animation.addByPrefix('redholdend', 'bear tail');
								animation.addByPrefix('blueholdend', 'bear tail');
 
								animation.addByPrefix('purplehold', 'bear hold');
								animation.addByPrefix('greenhold', 'bear hold');
								animation.addByPrefix('redhold', 'bear hold');
								animation.addByPrefix('bluehold', 'bear hold');
 
								setGraphicSize(Std.int(width * 1));
								updateHitbox();
								if (FlxG.save.data.antialiasing)
									{
										antialiasing = true;
									}
								x = 30;
								if(FlxG.save.data.midScroll || PlayState.SONG.song.toLowerCase() == 'monochrome')
									{
										x -= 295;
									}
				
							}
							case 3:
							{
								frames = Paths.getSparrowAtlas('NOTE_health');
								animation.addByPrefix('greenScroll', 'HealthUp', 24, true);
								animation.addByPrefix('redScroll', 'HealthRight', 24, true);
								animation.addByPrefix('blueScroll', 'HealthDown', 24, true);
								animation.addByPrefix('purpleScroll', 'HealthLeft', 24, true);

								animation.addByPrefix('purpleholdend', 'health tail');
								animation.addByPrefix('greenholdend', 'health tail');
								animation.addByPrefix('redholdend', 'health tail');
								animation.addByPrefix('blueholdend', 'health tail');
 
								animation.addByPrefix('purplehold', 'health hold');
								animation.addByPrefix('greenhold', 'health hold');
								animation.addByPrefix('redhold', 'health hold');
								animation.addByPrefix('bluehold', 'health hold');
 
								setGraphicSize(Std.int(width * 0.7));
								updateHitbox();
								if (FlxG.save.data.antialiasing)
									{
										antialiasing = true;
									}
								x = 45;
								if(FlxG.save.data.midScroll || PlayState.SONG.song.toLowerCase() == 'monochrome')
									{
										x -= 310;
									}
							}
							case 4:
							{
								frames = Paths.getSparrowAtlas('fire-arrow');
								animation.addByPrefix('greenScroll', 'fire-arrow idle', 24, true);
								animation.addByPrefix('redScroll', 'fire-arrow idle', 24, true);
								animation.addByPrefix('blueScroll', 'fire-arrow idle', 24, true);
								animation.addByPrefix('purpleScroll', 'fire-arrow idle', 24, true);
			 
								setGraphicSize(Std.int(width * 0.7));
								updateHitbox();
								if (FlxG.save.data.antialiasing)
									{
										antialiasing = true;
									}
								x = 30;
								if(FlxG.save.data.midScroll || PlayState.SONG.song.toLowerCase() == 'monochrome')
									{
								        x -= 295;
									}
				
							}
							default:
							{
						        frames = Paths.getSparrowAtlas('notes/' + noteStyle);
					            
								animation.addByPrefix('greenScroll', 'green alone');
								animation.addByPrefix('redScroll', 'red alone');
								animation.addByPrefix('blueScroll', 'blue alone');
								animation.addByPrefix('purpleScroll', 'purple alone');
 
								animation.addByPrefix('purpleholdend', 'purple tail');
								animation.addByPrefix('greenholdend', 'green tail');
								animation.addByPrefix('redholdend', 'red tail');
								animation.addByPrefix('blueholdend', 'blue tail');
 
								animation.addByPrefix('purplehold', 'purple hold');
								animation.addByPrefix('greenhold', 'green hold');
								animation.addByPrefix('redhold', 'red hold');
								animation.addByPrefix('bluehold', 'blue hold');
 
								setGraphicSize(Std.int(width * 0.7));
								updateHitbox();
								if (FlxG.save.data.antialiasing)
									{
									antialiasing = true;
									}
							}

							if(FlxG.save.data.midScroll || PlayState.SONG.song.toLowerCase() == 'monochrome')
								{
									x -= 275;
								}
			
							
						}
			}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
					if (FlxG.save.data.downscroll)
						{
							flipY = true;
						}
				case 3:
					animation.play('redholdend');
					if (FlxG.save.data.downscroll)
						{
							flipY = true;
						}
				case 1:
					animation.play('blueholdend');
					if (FlxG.save.data.downscroll)
						{
							flipY = true;
						}
				case 0:
					animation.play('purpleholdend');
					if (FlxG.save.data.downscroll)
						{
							flipY = true;
						}
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}