RoutineService.registerTemplate
	'name': 'update_document'
	'label': 'Update Document'
	'description': "Updates a document with the specified updates"
	'color': '#567CA0'
	'display_order': 50000
	'size': {height: 80, width: 150}
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
			position: [0, 0.25, -1, 0]
		}
		{
			name: 'out'
			type: RoutineService.NODE_TYPE['Outflow'].value
			position: [1, 0.25, 1, 0]
		}
		{
			name: 'document_input'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.6, -1, 0]
			label: 'Document'
			labelPosition: [2.9, 0.5]
		}
		{
			name: 'updates'
			type: RoutineService.NODE_TYPE['Input'].value
			multiple: true
			position: [0, 0.8, -1, 0]
			label: 'Updates'
			labelPosition: [2.6, 0.5]
		}
		{
			name: 'document_output'
			type: RoutineService.NODE_TYPE['Output'].value
			multiple: true
			position: [1, 0.6, 1, 0]
			label: 'Document'
			labelPosition: [-1.85, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Update Document service does not have any inputs") unless service.inputs?
		throw new Meteor.Error('validation', "Update Document service does not have a 'Document' input") unless service.inputs.hasOwnProperty('document_input')
		throw new Meteor.Error('validation', "Update Document service does not have an 'Updates' input") unless service.inputs.hasOwnProperty('updates')
		
		document = service.inputs['document_input']
		
		updates = service.inputs['updates']
		updates.forEach (update) ->
			document['data'][update['attribute_id']] = update['value']

		Meteor.call('Document.update', document)
		updated_document = Document.db.findOne(document['_id'])
		
		return [
			{node: 'out'}
			{node: 'document_output', value: updated_document}
		]