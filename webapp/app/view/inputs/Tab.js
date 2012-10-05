Ext.define('eSalsa.view.inputs.Tab', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.inputstab',
    title: 'Inputs',
    layout: 'border',
    requires: [
        'eSalsa.view.inputs.List',
        'eSalsa.view.inputs.Form'
    ],
    items: [{
        xtype: 'inputslist',
        region: 'west',
        header: false,
        collapsible: true,
        hideCollapseTool: true,
        split: true,
        width: 200
    }, {
        xtype: 'inputsform',
        region: 'center'
    }]
});