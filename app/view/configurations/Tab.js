Ext.define('eSalsa.view.configurations.Tab', {
  extend : 'Ext.panel.Panel',
  alias : 'widget.configurationstab',
  title : 'Configurations',
  layout : 'border',
  requires : [ 'eSalsa.view.configurations.List',
      'eSalsa.view.configurations.Form' ],
  items : [ {
    xtype : 'configurationslist',
    region : 'west',
    header : false,
    collapsible : true,
    hideCollapseTool : true,
    split : true,
    width : 200
  }, {
    xtype : 'configurationsform',
    region : 'center'
  } ]
});