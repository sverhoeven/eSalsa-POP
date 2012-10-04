/**
 * Property grid with add and remove buttons.
 * And can be used as form field.
 */
Ext.define('eSalsa.view.workers.AdditionalProperties', {
  extend : 'Ext.grid.property.Grid',
  alias : 'widget.worker.additionalprops',
  mixins : [ 'Ext.form.field.Field' ],
  initComponent : function() {
    this.addAction = Ext.create('Ext.Action', {
      scope : this,
      handler : this.addPropertyPrompt,
      iconCls: 'icon-add',
      text : 'Add property'
    });

    this.removeAction = Ext.create('Ext.Action', {
      itemId : 'remove',
      scope : this,
      handler : this.removeSelectedProperty,
      text : 'Remove selected property',
      iconCls: 'icon-del',
      disabled : true // can only remove a selected property, so start disabled
    });

    Ext.apply(this, {
      dockedItems : Ext.create('widget.toolbar', {
        items : [ this.addAction, this.removeAction ]
      }),
      source: {},
      listeners : {
        'selectionchange' : this.onSelectionChange
      }
    });

    this.callParent(arguments);

    // init field mixin
    this.value = this.getValue();
    this.initField();
  },
  setValue : function(value) {
    this.setSource(value);
  },
  getValue : function() {
    return this.getSource();
  },
  addProperty : function(key) {
    this.setProperty(key, '', true);
    var rec = this.getStore().find(this.nameField, key);
    this.plugins[0].startEdit(rec, this.headerCt.child('#' + this.valueField));
  },
  removeSelectedProperty : function() {
    var recs = this.getSelectionModel().getSelection();
    recs.forEach(function(rec) {
      this.removeProperty(rec.data[this.nameField]);
    }, this);
  },
  onSelectionChange : function(sm, selected) {
    this.removeAction.setDisabled(selected.length == 0);
  },
  addPropertyPrompt : function() {
    var me = this;
    Ext.Msg.prompt('Add property', 'Please enter property name:', function(btn,
        name) {
      if (btn == 'ok') {
        me.addProperty(name);
      }
    });
  }
});