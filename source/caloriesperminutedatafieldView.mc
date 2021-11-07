using Toybox.WatchUi;
using Toybox.Activity;
using Toybox.FitContributor as Fit;

class caloriesperminutedatafieldView extends WatchUi.SimpleDataField {

	const CALORYPERMINUTE_FIELD_ID = 0;
	
    var calPerMinuteField;
    hidden var lastElapsedTime;
    hidden var lastCaloryValue;
    hidden var lastCaloriesPerMinute;
    hidden var frequency;
    
    
    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = WatchUi.loadResource( Rez.Strings.data_field_label );
        
        lastElapsedTime = 0.0f;
        lastCaloryValue = 0.0f;
        lastCaloriesPerMinute = 0.0f;
        frequency = 10000.0f;
        
        calPerMinuteField = createField("calories_per_minute",
			CALORYPERMINUTE_FIELD_ID,
			Fit.DATA_TYPE_FLOAT,
			{
				:mesgType=>Fit.MESG_TYPE_RECORD, 
				:units=>"kcal./min."
			});
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // ELAPSED TIME MAY BE WRONG? TOO MUCH CALORIES?
        
        if (info has :elapsedTime && info has :calories)
        {
        	if (info.elapsedTime == null || info.calories == null)
        	{
        		return lastCaloriesPerMinute;
        	}
        	
        	if (info.elapsedTime >= lastElapsedTime + frequency)
       		{
				var deltaCalories = calculateCaloryDifference( info.calories, lastCaloryValue);

				var deltaTimeMinutes = calculateTimeDifferenceAsMinutes ( info.elapsedTime, lastElapsedTime );
       		
       			var currentCaloriesPerMinute = calculateCaloriesPerMinute ( deltaCalories, deltaTimeMinutes );
       		
       			lastElapsedTime = info.elapsedTime;
       			lastCaloryValue = info.calories;
       			lastCaloriesPerMinute = currentCaloriesPerMinute;
       		
       			calPerMinuteField.setData(currentCaloriesPerMinute);
       			System.println("Field object:" + calPerMinuteField);
       			return currentCaloriesPerMinute;
       		}
       		else {
       			calPerMinuteField.setData(lastCaloriesPerMinute);
       			return lastCaloriesPerMinute;
       		}
        } else {
        	return lastCaloriesPerMinute;
        }
    }

	function calculateCaloryDifference( currentCalories, lastCalories ) 
	{
		var caloryDifference = currentCalories.toFloat() - lastCalories.toFloat();
		System.println("DEBUG: caloryDifference = " + caloryDifference);
		return caloryDifference;
	}

	function calculateTimeDifferenceAsMinutes( currentTimestamp, lastTimestamp )
	{
		var deltaTime = info.elapsedTime.toFloat() - lastElapsedTime.toFloat();
		var deltaTimeMinutes = deltaTime.toFloat() / 60000f;
       	System.println("DEBUG: deltaTimeMinutes: " + deltaTimeMinutes);
		return deltaTimeMinutes;
	}

	function calculateCaloriesPerMinute ( calories, minutes )
	{
		var calPerMinutes = calories.toFloat() / minutes.toFloat();
		System.println("DEBUG: calPerMinutes: " + calPerMinutes);
		return calPerMinutes;
	}
}