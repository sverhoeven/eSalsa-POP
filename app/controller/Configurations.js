Ext.define('eSalsa.controller.Configurations', {
    extend: 'Ext.app.Controller',
    views: ['configurations.Tab'],
    refs: [{
        ref: 'list', selector: 'configurationslist'
    }, {
        ref: 'form', selector: 'configurationsform'
    }],
    stores: ['Configurations'],
    init: function() {
        this.control({
            'configurationslist': {
                select: this.onSelect,
                deselect: this.onDeselect,
                beforedeselect: this.onBeforeDeselect
            },
        });
    },
    onSelect: function(rm, record) {
        this.getForm().loadRecord(record);
        this.getForm().enable();
    },
    onDeselect: function(rm, record) {
        this.getForm().disable();
        this.getForm().reset();
    },
    onBeforeDeselect: function(rm, record) {
        // TODO if unsaved changes then give prompt
    }
});