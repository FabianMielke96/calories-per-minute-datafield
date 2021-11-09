using Toybox.WatchUi;
using Toybox.Activity;
using Toybox.FitContributor as Fit;

class caloriesperminutedatafieldView extends WatchUi.SimpleDataField 
{
	const CALORYPERMINUTE_FIELD_ID = 0;
	
    var calPerMinuteField;
    hidden var lastTime;
    hidden var lastCalories;
    hidden var lastCaloriesPerMinute;
    hidden var calculationTimeStep;
    
    function initialize() 
	{
        SimpleDataField.initialize();
        label = WatchUi.loadResource( Rez.Strings.ui_label );
        
        lastTime = 0.0f;
        lastCalories = 0.0f;
        lastCaloriesPerMinute = 0.0f;
        calculationTimeStep = 20000.0f; // 20 seconds
        
        calPerMinuteField = createField("calories_per_minute",
			CALORYPERMINUTE_FIELD_ID,
			Fit.DATA_TYPE_FLOAT,
			{
				:mesgType=>Fit.MESG_TYPE_RECORD, 
				:units=>"kcal./min."
			});
    }

    function compute(info) 
	{
		if (info == null)
		{
			return lastCaloriesPerMinute;
		}

        if (info has :timerTime && info has :calories && info has:timerState)
        {
			if (info.timerState == null)
			{
				return lastCaloriesPerMinute;
			}

			if (info.timerTime == null)
        	{
        		return lastCaloriesPerMinute;
        	}

			if (info.calories == null)
			{
				return lastCaloriesPerMinute;
			}

			if (info.timerState != 3)
			{
				return lastCaloriesPerMinute;
			}

			if (info.timerTime < lastTime + calculationTimeStep)
			{
				return lastCaloriesPerMinute;
			}
        	
			var deltaCalories = calculateCaloryDifference( info.calories, lastCalories);
			var deltaTimeMinutes = calculateTimeDifferenceAsMinutes ( info.timerTime, lastTime );
    		var currentCaloriesPerMinute = calculateCaloriesPerMinute ( deltaCalories, deltaTimeMinutes );
       		
       		lastTime = info.timerTime;
       		lastCalories = info.calories;
       		lastCaloriesPerMinute = currentCaloriesPerMinute;
    		calPerMinuteField.setData(currentCaloriesPerMinute.toFloat());
       		System.println("DEBUG: Set datafield in FIT file: " + currentCaloriesPerMinute);
       		return currentCaloriesPerMinute;
        } else {
        	return lastCaloriesPerMinute;
        }
    }

	function calculateCaloryDifference( currentCalories, lastCalories ) 
	{
		if (currentCalories == lastCalories)
		{
			return 0.0f;
		}

		var caloryDifference = currentCalories.toFloat() - lastCalories.toFloat();
		System.println("DEBUG: caloryDifference: " + caloryDifference);
		return caloryDifference;
	}

	function calculateTimeDifferenceAsMinutes( currentTimestamp, lastTimestamp )
	{
		if (currentTimestamp == lastTimestamp)
		{
			return 0.0f;
		}

		var deltaTime = currentTimestamp.toFloat() - lastTimestamp.toFloat();
		var deltaTimeMinutes = deltaTime.toFloat() / 60000f;
       	System.println("DEBUG: deltaTimeMinutes: " + deltaTimeMinutes);
		return deltaTimeMinutes;
	}

	function calculateCaloriesPerMinute ( calories, minutes )
	{
		if (calories == null)
		{
			return 0.0f;
		}

		if (calories == 0)
		{
			return 0.0f;
		}

		if (minutes == null)
		{
			return 0.0f;
		}

		if (minutes == 0)
		{
			return 0.0f;
		}

		var calPerMinutes = calories.toFloat() / minutes.toFloat();
		System.println("DEBUG: calPerMinutes: " + calPerMinutes);
		return calPerMinutes;
	}
}