Ext.define('eSalsa.model.Worker', {
  extend : 'Ext.data.Model',
  fields : [ 'id', 'comment', 'uri', 'template_dir', 'input_dir', 'output_dir',
      'add_props' ]
});