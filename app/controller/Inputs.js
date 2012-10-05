Ext.define('eSalsa.controller.Inputs', {
    extend : 'Ext.app.Controller',
    views : [ 'inputs.Tab' ],
    refs : [ {
        ref : 'list',
        selector : 'inputslist'
    }, {
        ref : 'form',
        selector : 'inputsform'
    } ],
    stores : [ 'Inputs', 'Files' ],
    init : function() {
        this.control({
            'inputslist' : {
                select : this.onSelect,
                deselect : this.onDeselect,
                beforedeselect : this.onBeforeDeselect
            },
        });
    },
    onSelect : function(rm, record) {
        this.getForm().loadRecord(record);
        this.getForm().enable();
    },
    onDeselect : function(rm, record) {
        this.getForm().disable();
        this.getForm().reset();
    },
    onBeforeDeselect : function(rm, record) {
        // TODO if unsaved changes then give prompt
    }
});