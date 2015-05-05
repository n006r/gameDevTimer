package;

import flixel.util.FlxSave;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
    var time:FlxText;
    //var _gameSave.data.hours:Int = 14;
    //var _gameSave.data.minutes:Int = 59;
    //var _gameSave.data.seconds:Float = 59;

    var _gameSave:FlxSave;

    var count:Bool= false;

    var startButton:FlxButton;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        FlxG.autoPause = false;

        _gameSave = new FlxSave();
        _gameSave.bind("timerSave");
        
        if (_gameSave.data.hours == null)
        {
             _gameSave.data.hours = 14;
             _gameSave.data.minutes = 59;
             _gameSave.data.seconds = 59;
            _gameSave.close();
            _gameSave.bind("timerSave");
        }

		var testText = new FlxText (0,0,200, "GameDev Timer", 32);
		add (testText);

		time = new FlxText (FlxG.width/2, FlxG.height/2, 500, "Timer here", 64);
        time.x = FlxG.width/2- time.width/2;
        time.y = FlxG.height/2 - time.height/2;
        time.text = _gameSave.data.hours + ":" + _gameSave.data.minutes +":"+_gameSave.data.seconds;
        add (time);
        startButton = new FlxButton
         (time.x, time.y +200, "start", pressStartButton);
        startButton.setGraphicSize (200);
        startButton.updateHitbox();
        add (startButton);

        var newTimerButton = new FlxButton (startButton.x + 200, startButton.y, "new timer", pressNewTimerButton);
        newTimerButton.setGraphicSize (200);
        newTimerButton.updateHitbox();
        add (newTimerButton);
	}

    function pressStartButton ()
    {
        count = !count;

        if (count) startButton.text = "stop";
        else startButton.text = "start";
    }

    function pressNewTimerButton ()
    {
        count = !count;

        if (count) startButton.text = "stop";
        else startButton.text = "start";

        _gameSave.data.hours = 14;
        _gameSave.data.minutes = 59;
        _gameSave.data.seconds = 59;
        _gameSave.close();
        _gameSave.bind("timerSave");
    }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

        if (count)
        {
            _gameSave.data.seconds -= FlxG.elapsed;
        }
        if (_gameSave.data.seconds < 0)
        {
            _gameSave.data.seconds = 59;
            _gameSave.data.minutes -=1;
        }
        if (_gameSave.data.minutes < 0)
        {
            _gameSave.data.minutes = 59;
            _gameSave.data.hours -=1;
        }

        if (count)
        {
            _gameSave.close();
            _gameSave.bind("timerSave");
        }

        if (_gameSave.data.hours < 0)
        {
            time.text = "Expired";
        }
        else time.text = _gameSave.data.hours + ":" + _gameSave.data.minutes +":"+_gameSave.data.seconds;
	}	
}