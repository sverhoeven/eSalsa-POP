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
			'configurationslist component[action=add-conf]' : {
				click : this.addConf
			},
			'configurationsform component[action=save-conf]' : {
				click : this.saveConf
			},
			'configurationsform component[action=del-conf]' : {
				click : this.deleteConf
			}
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
    },
	saveConf : function() {
		var conf = Ext.create('eSalsa.model.Configuration', this.getForm()
				.getValues(false, false, false, true));
		conf.save();
	},
	deleteConf : function() {
		var me = this;
		var conf = Ext.create('eSalsa.model.Configuration', this.getForm()
				.getValues(false, false, false, true));
		conf.destroy({callback: function(conf) {
			me.getConfigurationsStore().load();
		}});
	},
	addConf : function() {
		var me = this;
		Ext.Msg.prompt('Add conf', 'Please enter conf ID:', function(btn,
				id) {
			if (btn == 'ok') {
				var conf = Ext.create('eSalsa.model.Configuration', {
					id : id
				});
				me.getConfigurationsStore().add(conf);
				me.getList().getSelectionModel().select(conf);
			}
		});
	}
});