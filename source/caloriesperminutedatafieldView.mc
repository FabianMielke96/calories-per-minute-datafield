using Toybox.WatchUi;
using Toybox.Activity;
using Toybox.FitContributor as Fit;

class caloriesperminutedatafieldView extends WatchUi.SimpleDataField 
{
	const CALORYPERMINUTE_FIELD_ID = 0;
	
    var calPerMinuteField;
    
    function initialize() 
	{
        SimpleDataField.initialize();
        label = WatchUi.loadResource( Rez.Strings.ui_label );
        
        calPerMinuteField = createField(
			"calories_per_minute",
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
			return 0.0f;
		}

        if (info has:energyExpenditure)
        {

			if (info.energyExpenditure == null)
			{
				return 0.0f;
			}

       		System.println("DEBUG: Set datafield in FIT file: " + info.energyExpenditure);
			calPerMinuteField.setData(info.energyExpenditure);
       		return info.energyExpenditure;
        } 
		else 
		{
			return 0.0f;
		}
    }
}