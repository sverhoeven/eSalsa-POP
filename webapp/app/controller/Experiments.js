Ext.define('eSalsa.controller.Experiments', {
	extend : 'Ext.app.Controller',
	views : [ 'experiments.List' ],
	stores : [ 'Experiments' ],
	init : function() {
		this.control({
			'experimentslist' : {
				edit : this.saveExperiment,
				deleteExperiment : this.deleteExperiment
			}
		});
	},
	saveExperiment : function(editor, e) {
		e.record.save({
			callback : function() {
				e.record.commit();
			}
		});
	},
	deleteExperiment : function(rec) {
		var me = this;
		rec.destroy({
			callback : function() {
				me.getExperimentsStore().load();
			}
		});
	}
});