package org.openmrs.module.patientdashboardui.model;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;

public class Procedure {

	public Procedure(Integer id, String label) {
		this.id = id;
		this.label = label;
	}

	private Integer id;
	private String label;
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
