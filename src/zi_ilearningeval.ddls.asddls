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
      _LearningOutcome.LearningOutcome as LearningOutcome,
      
      start_date            as StartDate,
      end_date              as EndDate,
      hours_invested        as HoursEstimated,
      hours_of_outcome      as HoursOfOutcome,
      learning_source       as LearningSource,
      approval_status_id    as ApprovalStatusId,
      _ApprovalStatus.ApprovalStatus as ApprovalStatus,
           
      case _ApprovalStatus.ApprovalStatus
        when 'Open'     then 2 //Yellow Color
        when 'Approved' then 3 //Green Color
        when 'Rejected' then 1 //Red color
        else 2
      end as ApprovalStatusC,
      
      learning_status_id    as LearningStatusId,
      _LearningStatus.LearningStatus as LearningStatus,
      
      case _LearningStatus.LearningStatus
        when 'New'                      then 2 //Yellow Color
        when 'Send for Approval'        then 2 //Yellow Color
        when 'In Process'               then 3 //Green Color
        when 'Learning Outcome Planned' then 3 //Green Color
        when 'Complete'                 then 3 //Green Color
        else 2
      end as LearningStatusC,
      
      points_earned         as PointsEarned,
      last_changed_date     as LastChangedDate,
      creation_date         as CreationDate,
      approve_reject_date   as ApproveRejectDate,
      learning_outcome_date as LearningOutcomeDate,

      _LearningOutcome,
      _ApprovalStatus,
      _LearningStatus
}
