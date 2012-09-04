// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
win.open();

// TODO: write your module tests here
var tieventkit = require('ti.eventkit');
Ti.API.info("module is => " + tieventkit);

var recur = {
  frequency:'yearly'
};
var cal_args = {
  recur:recur,
  startDate:'2013-02-22 00:00:00 GMT',
  endDate:'2013-02-23 00:00:00 GMT',
  title:"Soyo's birthday!",
  location:'Here, there, everywhere!',
  notes:"My lovely daughter's birthday"
};
var results = tieventkit.newEvent(cal_args);
if(results == 1){
  alert('OK');
}else{
  alert('Error');
}
