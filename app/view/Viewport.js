Ext.define('eSalsa.view.Viewport' ,{
    extend: 'Ext.container.Viewport',
    layout: 'fit',
    items: [
        {
            xtype: 'tabpanel',
            activeTab: 0,
            items: [{
                xtype: 'experimentslist'
            }, {
                xtype: 'workerstab'
            }, {
                xtype: 'inputstab'
            }, {
                xtype: 'configurationstab'
            }]
        }
    ]
});