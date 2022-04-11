package substates;

import states.TitleState;
import utilities.CoolUtil;
import states.MainMenuState;
import states.MusicBeatState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var ver = "v" + Application.current.meta.get('version');

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hey! You are seeing this screen because Discussions hasn't updated this mod yet.\nCurrent version is "
			+ ver
			+ " while the most recent version is "
			+ TitleState.version_New
			+ "! Press ESCAPE to ignore this!! Wait until I updated it.",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			//CoolUtil.openURL("https://github.com/Leather128/LeathersFunkinEngine");
		}

		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new PreloadingState());
		}

		super.update(elapsed);
	}
}
