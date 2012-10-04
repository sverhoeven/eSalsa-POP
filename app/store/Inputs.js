Ext.define('eSalsa.store.Inputs', {
    extend : 'Ext.data.Store',
    model : 'eSalsa.model.Input',
    // TODO retrieve data from server
    data : [ {
        id : 'input1',
        comment : '',
        files : [ {
            file : 'file1'
        }, {
            file : 'file2'
        } ]
    }, {
        id : 'input2',
        comment : '',
        files : [ {
            file : 'file3'
        }, {
            file : 'file4'
        } ]
    } ]
});