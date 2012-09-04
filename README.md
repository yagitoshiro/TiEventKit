# tieventkit Module

## Description

Ti.EventKit brings in iOS EventKit into the Titanium namespace.  You can add events to iOS apps using the native calendar app.
The compiled module zip file is available in the /dist folder.

## Accessing the tieventkit Module

To access this module from JavaScript, you would do the following:

	  Titanium.event = require('ti.eventkit');

The Titanium.event variable is a reference to the Module object.	Alternatively you can instantiate the module into a separate variable:
  
    var tieventkit = require('ti.eventkit');

## Reference

Note: You'll need to pass the times based on the 24 hour clock, pre-adjusted to UTC to get the expected results.

### ti.eventkit.function

    newEvent(args);

### ti.eventkit.property

None.

## Usage

```
    Titanium.event = require('ti.eventkit');
    var results = Titanium.event.newEvent({
    	 timezone:'JST',
    	 startDate:'2013-02-22 00:00:00 JST',
    	 endDate:'2013-02-23 00:00:00 JST',
    	 title:"Soyo's birthday!",
    	 location:'Here, there, everywhere!',
    	 notes:"My lovely daughter's birthday"
    });
    Titanium.API.log(results);
```

## Author

Terry Martin
http://twitter.com/tzmartin

Mark Pemburn
http://developer.appcelerator.com/user/831551/mark-pemburn

Toshiro Yagi
http://twitter.com/yagi_

## License

This content is released under the  MIT License.
http://www.opensource.org/licenses/mit-license.php
