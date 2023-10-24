package game;

import flixel.FlxG;
import utilities.NoteVariables;
import shaders.ColorSwap;
import shaders.NoteColors;
import states.PlayState;
import flixel.FlxSprite;

using StringTools;

/*
	credit to psych engine devs (sorry idk who made this originally, all ik is that srperez modified it for shaggy and then i got it from there)
 */
class StrumNote extends FlxSprite
{
	public var resetAnim:Float = 0;

	private var noteData:Int = 0;

	public var swagWidth:Float = 0;

	public var ui_Skin:String = "default";
	public var ui_settings:Array<String>;
	public var mania_size:Array<String>;
	public var keyCount:Int;

	public var colorSwap:ColorSwap;

	var noteColor:Array<Int> = [255,0,0];

	public function new(x:Float, y:Float, leData:Int, ?ui_Skin:String, ?ui_settings:Array<String>, ?mania_size:Array<String>, ?keyCount:Int, ?isPlayer:Float, customColors:Bool = false)
	{
		if (ui_Skin == null)
			ui_Skin = PlayState.SONG.ui_Skin;

		if (ui_settings == null)
			ui_settings = PlayState.instance.ui_settings;

		if (mania_size == null)
			mania_size = PlayState.instance.mania_size;

		if (keyCount == null)
			keyCount = PlayState.SONG.keyCount;

		noteData = leData;

		var localKeyCount = (isPlayer == 1) ? PlayState.SONG.playerKeyCount : keyCount;

		this.ui_Skin = ui_Skin;
		this.ui_settings = ui_settings;
		this.mania_size = mania_size;
		this.keyCount = keyCount;

		super(x, y);

		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		var charColors = (isPlayer == 1) ? PlayState.boyfriend : PlayState.dad;
		if (!customColors) 
			noteColor = charColors.noteColors[localKeyCount - 1][noteData]; 
		else 
			noteColor = NoteColors.getNoteColor(NoteVariables.Other_Note_Anim_Stuff[keyCount - 1][noteData]);

		//idk why || doesnt work??
		if(Options.getData("customNoteColors"))
			noteColor = NoteColors.getNoteColor(NoteVariables.Other_Note_Anim_Stuff[keyCount - 1][noteData]);

		colorSwap.r = noteColor[0];
		colorSwap.g = noteColor[1];
		colorSwap.b = noteColor[2];
	}

	override function update(elapsed:Float)
	{
		if (resetAnim > 0)
		{
			resetAnim -= elapsed;

			if (resetAnim <= 0)
			{
				playAnim('static');
				resetAnim = 0;
			}
		}

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false)
	{
		animation.play(anim, force);
		// updateHitbox();
		centerOrigin();

		if (anim == "static")
		{
			colorSwap.r = 255;
			colorSwap.g = 0;
			colorSwap.b = 0;

			swagWidth = width;
		}
		else
		{
			colorSwap.r = noteColor[0];
			colorSwap.g = noteColor[1];
			colorSwap.b = noteColor[2];
		}

		if (ui_Skin != "pixel")
		{
			offset.x = frameWidth / 2;
			offset.y = frameHeight / 2;

			var scale = Std.parseFloat(ui_settings[0]) * (Std.parseFloat(ui_settings[2]) - (Std.parseFloat(mania_size[keyCount - 1])));

			offset.x -= 156 * scale / 2;
			offset.y -= 156 * scale / 2;
		}
		else
			centerOffsets();
	}
}
