Ext.define('eSalsa.controller.Workers', {
  extend : 'Ext.app.Controller',
  views : [ 'workers.Tab' ],
  refs : [ {
    ref : 'list',
    selector : 'workerslist'
  }, {
    ref : 'form',
    selector : 'workersform'
  } ],
  stores : [ 'Workers' ],
  init : function() {
    this.control({
      'workerslist' : {
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