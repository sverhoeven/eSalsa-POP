Ext.define('eSalsa.view.inputs.Form', {
    extend : 'Ext.form.Panel',
    alias : 'widget.inputsform',
    defaultType : 'textfield',
    bodyPadding : 5,
    layout : 'anchor',
    disabled : true,
    uses : [ 'eSalsa.view.inputs.Files' ],
    defaults : {
        anchor : '100%',
        labelAlign : 'top'
    },
    items : [ {
        fieldLabel : 'ID',
        name : 'id',
        allowBlank : false
    }, {
        fieldLabel : 'Comment',
        name : 'comment',
        emptyText : 'Enter comment',
        xtype : 'textarea'
    }, {
        fieldLabel : 'Files',
        xtype : 'inputfileslist',
        name : 'files'
    } ],
    buttons : [ {
        text : 'Clear',
    }, {
        text : 'Save',
    }, {
        text : 'Delete',
    } ],
    reset : function() {
        this.getForm().reset();
    }
});