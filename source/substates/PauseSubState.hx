package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class CustomPauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<FlxText>;
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Chart Editor', 'Exit to Menu'];
	var curSelected:Int = 0;

	var bg:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super();

		// Background gelap transparan dengan animasi fade-in
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartOut});
		add(bg);

		grpMenuShit = new FlxTypedGroup<FlxText>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var menuItem:FlxText = new FlxText(100, (150 + (i * 80)), 0, menuItems[i], 32);
			menuItem.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			menuItem.borderSize = 2;
			menuItem.ID = i;
			
			// Animasi masuk: teks bergeser dari kiri ke posisi normal
			menuItem.x = -400;
			FlxTween.tween(menuItem, {x: 100}, 0.4 + (i * 0.1), {ease: FlxEase.backOut});
			
			grpMenuShit.add(menuItem);
		}

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Kontrol navigasi atas/bawah
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					MusicBeatState.resetState();
				case "Chart Editor":
					FlxG.switchState(new ChartingState());
				case "Exit to Menu":
					FlxG.switchState(new MainMenuState());
			}
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.alpha = 0.6;
			
			// Animasi ukuran teks saat dipilih (efek membesar halus)
			if (item.ID == curSelected)
			{
				item.alpha = 1;
				FlxTween.cancelTweensOf(item.scale);
				item.scale.set(1.1, 1.1);
				FlxTween.tween(item.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.quadOut});
			}

			bullShit++;
		}
	}
}
