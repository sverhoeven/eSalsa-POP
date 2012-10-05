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
			'workerslist component[action=add-worker]' : {
				click : this.addWorker
			},
			'workersform component[action=save-worker]' : {
				click : this.saveWorker
			},
			'workersform component[action=del-worker]' : {
				click : this.deleteWorker
			}
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
	},
	saveWorker : function() {
		var worker = Ext.create('eSalsa.model.Worker', this.getForm()
				.getValues(false, false, false, true));
		worker.save();
	},
	deleteWorker : function() {
		var me = this;
		var worker = Ext.create('eSalsa.model.Worker', this.getForm()
				.getValues(false, false, false, true));
		worker.destroy({callback: function(worker) {
			me.getWorkersStore().load();
		}});
	},
	addWorker : function() {
		var me = this;
		Ext.Msg.prompt('Add worker', 'Please enter worker ID:', function(btn,
				id) {
			if (btn == 'ok') {
				var worker = Ext.create('eSalsa.model.Worker', {
					id : id
				});
				me.getWorkersStore().add(worker);
				me.getList().getSelectionModel().select(worker);
			}
		});
	}
});