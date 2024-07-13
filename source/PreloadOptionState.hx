package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;

class PreloadOptionState extends FlxState
{
    private var questionText:FlxText;
    private var yesButton:FlxButton;
    private var noButton:FlxButton;

    override public function create():Void
    {
        super.create();

        // Create a text to ask the question
        questionText = new FlxText(0, FlxG.height / 4, FlxG.width, "Do you want to preload resources?");
        questionText.setFormat(null, 16, 0xFFFFFFFF, "center");
        add(questionText);

        // Create the Yes button
        yesButton = new FlxButton(FlxG.width / 2 - 80, FlxG.height / 2, "Yes", onYesClick);
        add(yesButton);

        // Create the No button
        noButton = new FlxButton(FlxG.width / 2 + 20, FlxG.height / 2, "No", onNoClick);
        add(noButton);
    }

    private function onYesClick():Void
    {
        trace("User chose to preload resources.");
        FlxG.switchState(new PreloadState());
    }

    private function onNoClick():Void
    {
        trace("User chose not to preload resources.");
        FlxG.switchState(new TitleState());
    }
}
