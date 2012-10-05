Ext.define('eSalsa.model.Experiment', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'comment', 'worker', 'configuration', 'input' ],
	proxy : {
		type : 'rest',
		url : '/resource/experiments',
		reader : {
			type : 'json',
			root : 'rows',
			totalProperty : 'total'
		}
	}
});