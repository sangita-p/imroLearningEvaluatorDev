@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Learning Status BO'

define view entity ZI_ILEARNSTATUS
  as select from zilearnstatus as LearningStatus
{
  key ls_uuid         as LearningStatusUuid,
      ls_id           as LearningStatusId,
      learning_status as LearningStatus
}
