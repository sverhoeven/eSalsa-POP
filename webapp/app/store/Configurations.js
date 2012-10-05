Ext.define('eSalsa.store.Configurations', {
  extend : 'Ext.data.Store',
  model : 'eSalsa.model.Configuration',
  // TODO retrieve data from server
  data : [ {
    id : 'config1',
    comment : '',
    configuration : 'My config'
  }, {
    id : 'config2',
    comment : '',
    configuration : 'My other config'
  } ]
});