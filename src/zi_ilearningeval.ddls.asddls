@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Learning BO'

define root view entity ZI_ILEARNINGEVAL
  as select from zilearningeval as Learning
  association [0..1] to ZI_ILEARNOUTCOME  as _LearningOutcome on $projection.LearningOutcomeId = _LearningOutcome.LearningOutcomeId
  association [0..1] to ZI_IAPPROVESTATUS as _ApprovalStatus  on $projection.ApprovalStatusId = _ApprovalStatus.ApprovalStatusId
  association [0..1] to ZI_ILEARNSTATUS   as _LearningStatus  on $projection.LearningStatusId = _LearningStatus.LearningStatusId
{
  key learning_uuid         as LearningUuid,
      learning_id           as LearningId,
      employee_id           as EmployeeId,
      employee_name         as EmployeeName,
      employee_band         as EmployeeBand,
      core_skill            as CoreSkill,
      topic_to_learn        as TopicToLearn,
      learning_mode         as LearningMode,
      learning_outcome_id   as LearningOutcomeId,
      start_date            as StartDate,
      end_date              as EndDate,
      hours_invested        as HoursEstimated,
      hours_of_outcome      as HoursOfOutcome,
      learning_source       as LearningSource,
      approval_status_id    as ApprovalStatusId,
      learning_status_id    as LearningStatusId,
      points_earned         as PointsEarned,
      last_changed_date     as LastChangedDate,
      creation_date         as CreationDate,
      approve_reject_date   as ApproveRejectDate,
      learning_outcome_date as LearningOutcomeDate,

      _LearningOutcome,
      _ApprovalStatus,
      _LearningStatus
}
