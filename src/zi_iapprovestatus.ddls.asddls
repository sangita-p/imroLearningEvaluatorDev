@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Approval Status BO'

define root view entity ZI_IAPPROVESTATUS
  as select from ziapprovestatus as ApprovalStatus
{
  key as_uuid         as ApprovalStatusUuid,
      as_id           as ApprovalStatusId,
      approval_status as ApprovalStatus
}
