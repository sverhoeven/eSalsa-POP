Ext.define('eSalsa.store.Workers', {
    extend : 'Ext.data.Store',
    model : 'eSalsa.model.Worker',
    autoLoad : true,
    proxy : {
        type : 'rest',
        url : "http://145.100.61.17:9003/workers",
        reader : {
            type : 'json',
            root : 'workers.rows',
            totalProperty : 'workers.total'
        }
    }
});