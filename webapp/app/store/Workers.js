Ext.define('eSalsa.store.Workers', {
    extend : 'Ext.data.Store',
    model : 'eSalsa.model.Worker',
    autoLoad : true,
    proxy : {
        type : 'rest',
        url : "/resource/workers",
        reader : {
            type : 'json',
            root : 'rows',
            totalProperty : 'total'
        }
    }
});