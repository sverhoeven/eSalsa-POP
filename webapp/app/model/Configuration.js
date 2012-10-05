Ext.define('eSalsa.model.Configuration', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'comment', 'configuration' ],
	proxy : {
		type : 'rest',
		url : '/resource/configurations',
		reader : {
			type : 'json',
			root : 'rows',
			totalProperty : 'total'
		}
	}
});