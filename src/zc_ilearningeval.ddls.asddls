@EndUserText.label: 'Learning Projection View'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZC_ILEARNINGEVAL
  as projection on ZI_ILEARNINGEVAL as Learning
{
  key LearningUuid,
      LearningId,
      @Search.defaultSearchElement: true
      EmployeeId,
      @Search.defaultSearchElement: true
      EmployeeName,
      EmployeeBand,
      @Search.defaultSearchElement: true
      CoreSkill,
      @Search.defaultSearchElement: true
      TopicToLearn,
      LearningMode,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ILEARNOUTCOME', element: 'LearningOutcomeId'} }]
      @ObjectModel.text.element: ['LearningOutcome']
      @Search.defaultSearchElement: true
      LearningOutcomeId,
      _LearningOutcome.LearningOutcome as LearningOutcome,
      
      StartDate,
      EndDate,
      HoursEstimated,
      HoursOfOutcome,
      LearningSource,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_IAPPROVESTATUS', element: 'ApprovalStatusId'} }]
      @ObjectModel.text.element: ['ApprovalStatus']
      @Search.defaultSearchElement: true
      ApprovalStatusId,
      _ApprovalStatus.ApprovalStatus   as ApprovalStatus,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ILEARNSTATUS', element: 'LearningStatusId'} }]
      @ObjectModel.text.element: ['LearningStatus']
      @Search.defaultSearchElement: true
      LearningStatusId,
      _LearningStatus.LearningStatus   as LearningStatus,
      
      PointsEarned,
      LastChangedDate,
      CreationDate,
      ApproveRejectDate,
      LearningOutcomeDate,
      
      /* Associations */
      _LearningOutcome,
      _ApprovalStatus,
      _LearningStatus
}
