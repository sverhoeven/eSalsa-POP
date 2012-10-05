Ext.define('eSalsa.store.Files', {
  extend : 'Ext.data.Store',
  model : 'eSalsa.model.File',
  proxy: {
      type: 'memory'
  }
});