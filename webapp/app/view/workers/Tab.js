Ext.define('eSalsa.view.workers.Tab', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.workerstab',
    title: 'Workers',
    layout: 'border',
    requires: [
        'eSalsa.view.workers.List',
        'eSalsa.view.workers.Form'
    ],
    items: [{
        xtype: 'workerslist',
        region: 'west',
        header: false,
        collapsible: true,
        hideCollapseTool: true,
        split: true,
        width: 200
    }, {
        xtype: 'workersform',
        region: 'center'
    }]
});