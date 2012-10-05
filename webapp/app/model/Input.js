Ext.define('eSalsa.model.Input', {
  extend : 'Ext.data.Model',
  fields : [ 'id', 'comment', { name:'files', defaultValue:[]} ],
  proxy : {
		type : 'rest',
		url : "/resource/inputs",
		reader : {
			type : 'json',
			root : 'rows',
			totalProperty : 'total'
		}
	}
});