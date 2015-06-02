angular.module('app-factory').directive('afAttributeDocumentInput', ['$modal', 'SelectDocumentModal', 'DocumentUtils', ($modal, SelectDocumentModal, DocumentUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-input.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='	
	link: ($scope) ->

		$scope.documentDisplayName = ''

		$scope.hasValue = ->
			return $scope.document.data[$scope.attribute['id']]?

		$scope.lookupDocument = ->
			documentSchemaId = $scope.attribute['configuration']['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			$modal.open(new SelectDocumentModal(documentSchema)).result.then (document) ->
				$scope.document.data[$scope.attribute['id']] = document['_id']
				$scope.loadDocument()

		$scope.clearDocument = ->
			$scope.document.data[$scope.attribute['id']] = null
			$scope.loadDocument()

		$scope.loadDocument = ->
			documentId = $scope.document['data'][$scope.attribute['id']]
			DocumentUtils.getById(documentId)
				.then (document) ->
					documentSchema = DocumentSchema.db.findOne(document['document_schema_id'])
					attributeId = documentSchema['attributes'][0]['id']
					$scope.documentDisplayName = document['data'][attributeId]
				.catch ->
					$scope.documentDisplayName = null

		# Initialize
		$scope.loadDocument()
])