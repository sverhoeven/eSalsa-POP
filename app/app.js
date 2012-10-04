Ext.Loader.setConfig({
  enabled : true,
// disableCaching: false, // uncomment to use firebug breakpoints
});

Ext.application({
  name : 'eSalsa',
  autoCreateViewport : true,
  controllers : [ 'Workers', 'Inputs', 'Configurations', 'Experiments' ]
});