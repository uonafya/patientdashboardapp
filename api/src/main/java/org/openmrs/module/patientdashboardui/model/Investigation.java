package org.openmrs.module.patientdashboardui.model;

import org.openmrs.*;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.ConceptService;

import java.util.Date;

public class Investigation {

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

	private Integer id;
	private String label;


	public void save(Encounter encounter, String departmentName) throws Exception {
		Concept investigationConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalPropertyValue(PatientDashboardConstants.PROPERTY_FOR_INVESTIGATION, null).toString());
		if (investigationConcept == null) {
			throw new Exception("Investigation concept null");
		}
		BillableService billableService = Context.getService(BillingService.class).getServiceByConceptId(this.getId());
		OpdTestOrder opdTestOrder = new OpdTestOrder();
		opdTestOrder.setPatient(encounter.getPatient());
		opdTestOrder.setEncounter(encounter);
		opdTestOrder.setConcept(investigationConcept);
		opdTestOrder.setTypeConcept(DepartmentConcept.TYPES[2]);
		opdTestOrder.setValueCoded(Context.getConceptService().getConcept(this.getId()));
		opdTestOrder.setCreator(encounter.getCreator());
		opdTestOrder.setCreatedOn(encounter.getDateCreated());
		opdTestOrder.setBillableService(billableService);
		opdTestOrder.setScheduleDate(encounter.getDateCreated());
		opdTestOrder.setFromDept(departmentName);
		Context.getService(PatientDashboardService.class).saveOrUpdateOpdOrder(opdTestOrder);
	}
	public void addObs(Encounter encounter, Obs obsGroup) {
		AdministrationService administrationService = Context
				.getAdministrationService();
		GlobalProperty investigationn = administrationService
				.getGlobalPropertyObject(PatientDashboardConstants.PROPERTY_FOR_INVESTIGATION);
		ConceptService conceptService = Context.getConceptService();

		Concept investigationConceptId = conceptService.getConceptByName(investigationn
				.getPropertyValue());
		Obs obsInvestigation = new Obs();
		obsInvestigation.setObsGroup(obsGroup);
		obsInvestigation.setConcept(investigationConceptId);
		obsInvestigation.setValueCoded(Context.getConceptService().getConcept(this.id));
		obsInvestigation.setCreator(encounter.getCreator());
		obsInvestigation.setDateCreated(encounter.getDateCreated());
		obsInvestigation.setEncounter(encounter);
		obsInvestigation.setPatient(encounter.getPatient());
		encounter.addObs(obsInvestigation);
	}


}
