
package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef ModchartInfo = {
	var circle:Bool;
	var swap:Bool;
}

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var validScore:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var stage:String = '';
	public var gfVersion:String = 'gf';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = Assets.getText('assets/data/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '.json').trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}
		return parseJSONshit(rawJson);
	}

	public static function loadJsonfromFreeplay():SwagSong
		{
			var rawJson = Assets.getText('assets/data/' + NewFreeplay.songID + '/' + NewFreeplay.songID + FreeplayDiffSelect.diffic + '.json').trim();
	
			while (!rawJson.endsWith("}"))
			{
				rawJson = rawJson.substr(0, rawJson.length - 1);
			}
			return parseJSONshit(rawJson);
		}
	
		public static function loadEasterEgg(jsonInput:String, ?folder:String):SwagSong
			{
				var rawJson = Assets.getText('assets/data/' + 'monochrome' + '/' + 'monochrome' + '.json').trim();
		
				while (!rawJson.endsWith("}"))
				{
					rawJson = rawJson.substr(0, rawJson.length - 1);
				}		
				return parseJSONshit(rawJson);
			}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}