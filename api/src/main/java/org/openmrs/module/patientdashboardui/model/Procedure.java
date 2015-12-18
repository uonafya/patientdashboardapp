package org.openmrs.module.patientdashboardui.model;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class Procedure {

	public Procedure(Integer id, String label) {
		this.id = id;
		this.label = label;
	}

	public Procedure(Concept concept){
		this(concept.getConceptId(), concept.getDisplayString());
		if(majorMinorOperationsConceptIds.contains(concept.getConceptId())) {
			schedulable = true;
		}
	}

	//check for minor and major procedures
	private static List<Integer> majorMinorOperationsConceptIds;
	static{
		majorMinorOperationsConceptIds = new ArrayList<Integer>();
		Collection<ConceptAnswer> minorOperationConcepts = Context.getConceptService().getConceptByName("MINOR OPERATION").getAnswers();
		Collection<ConceptAnswer> majorOperationConcepts = Context.getConceptService().getConceptByName("MAJOR OPERATION").getAnswers();
		minorOperationConcepts.addAll(majorOperationConcepts);
		for(ConceptAnswer conceptAnswer : minorOperationConcepts){
			majorMinorOperationsConceptIds.add(conceptAnswer.getAnswerConcept().getConceptId());
		}
	}


	private Integer id;
	private String label;
	private boolean schedulable;
	private String scheduledDate;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public boolean isSchedulable() {return schedulable;	}
	public void setSchedulable(boolean schedulable) {this.schedulable = schedulable;}
	public String getScheduledDate() {
		return scheduledDate;
	}
	public void setScheduledDate(String scheduledDate) {
		this.scheduledDate = scheduledDate;
	}



	public void save(Encounter encounter) throws Exception {
		Concept procedureConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_POST_FOR_PROCEDURE, null));
		if (procedureConcept == null) {
			throw new Exception("Post for procedure concept null");
		}
		BillableService billableService = Context.getService(BillingService.class).getServiceByConceptId(this.getId());
		OpdTestOrder opdTestOrder = new OpdTestOrder();
		opdTestOrder.setPatient(encounter.getPatient());
		opdTestOrder.setEncounter(encounter);
		opdTestOrder.setConcept(procedureConcept);
		opdTestOrder.setTypeConcept(DepartmentConcept.TYPES[1]);
		opdTestOrder.setValueCoded(Context.getConceptService().getConcept(this.getId()));
		opdTestOrder.setCreator(encounter.getCreator());
		opdTestOrder.setCreatedOn(encounter.getDateCreated());
		opdTestOrder.setBillableService(billableService);
		opdTestOrder.setScheduleDate(Context.getDateFormat().parse(this.getScheduledDate()));
		
		Context.getService(PatientDashboardService.class).saveOrUpdateOpdOrder(opdTestOrder);
	}
}
