@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Learning Outcome BO'

define root view entity ZI_ILEARNOUTCOME
  as select from zilearnoutcome as LearningOutcome
{
  key lo_uuid          as LearningOutcomeUuid,
      lo_id            as LearningOutcomeId,
      learning_outcome as LearningOutcome
}
