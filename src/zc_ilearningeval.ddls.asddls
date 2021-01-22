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
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ILEARNOUTCOME', element: 'LearningOutcomeId'},
                                           additionalBinding: [{ localElement: 'LearningOutcome', element: 'LearningOutcome' }] }]
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ILEARNOUTCOME', element: 'LearningOutcomeId'} }]
//      @ObjectModel.text.element: ['LearningOutcome']
      @Search.defaultSearchElement: true
      LearningOutcomeId,
      LearningOutcome,
      
      @Search.defaultSearchElement: true
//      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      StartDate,
      @Search.defaultSearchElement: true
      EndDate,
      HoursEstimated,
      HoursOfOutcome,
      LearningSource,
      
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_IAPPROVESTATUS', element: 'ApprovalStatusId'} }]
//      @ObjectModel.text.element: ['ApprovalStatus']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_IAPPROVESTATUS', element: 'ApprovalStatusId'},
                                           additionalBinding: [{ localElement: 'ApprovalStatus', element: 'ApprovalStatus' }] }]
      @Search.defaultSearchElement: true
      ApprovalStatusId,
      ApprovalStatus,     
      ApprovalStatusC,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ILEARNSTATUS', element: 'LearningStatusId'} }]
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ILEARNSTATUS', element: 'LearningStatusId'},
//                                           additionalBinding: [{ localElement: 'LearningStatus', element: 'LearningStatus' }] }]
      @ObjectModel.text.element: ['LearningStatus']
      @Search.defaultSearchElement: true
      LearningStatusId,
      LearningStatus,    
      LearningStatusC,
      
      @Search.defaultSearchElement: true
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
