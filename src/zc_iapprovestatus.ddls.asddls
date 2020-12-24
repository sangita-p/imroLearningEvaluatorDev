@EndUserText.label: 'Approval Status Projection View'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZC_IAPPROVESTATUS
  as projection on ZI_IAPPROVESTATUS as ApprovalStatus
{
  key ApprovalStatusUuid,
      ApprovalStatusId,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_IAPPROVESTATUS', element: 'ApprovalStatus'} }]
      ApprovalStatus
}
