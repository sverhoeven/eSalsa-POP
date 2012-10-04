Ext.define('eSalsa.store.Experiments', {
  extend : 'Ext.data.Store',
  model : 'eSalsa.model.Experiment',
  // TODO retrieve data from server
  data : [ {
    id : 'exp1',
    comment : '',
    worker : 'DAS4VU1d.c',
    configuration : 'config1',
    input : 'input1'
  }, {
    id : 'exp1',
    comment : '',
    worker : 'DAS4LD1d.c',
    configuration : 'config2',
    input : 'input2'
  } ]
});