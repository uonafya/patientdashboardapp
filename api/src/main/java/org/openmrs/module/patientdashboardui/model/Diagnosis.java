package org.openmrs.module.patientdashboardui.model;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;

public class Diagnosis {

	//TODO: move to global properties
	private static final String FINAL_DIAGNOSIS_CONCEPT_NAME = "FINAL DIAGNOSIS";

	public Diagnosis(Concept concept) {
		this.id = concept.getConceptId();
		this.label = concept.getName().getName();
	}

	public Diagnosis(){

	}

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

	public void addObs(Encounter encounter, Obs obsGroup, Boolean isProvisional) {
		Concept diagnosisConcept;
		if (!isProvisional) {
			diagnosisConcept = Context.getConceptService().getConcept(FINAL_DIAGNOSIS_CONCEPT_NAME);
		} else {
			String provisionalDiagnosisConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_PROVISIONAL_DIAGNOSIS);
			diagnosisConcept = Context.getConceptService().getConcept(provisionalDiagnosisConceptName);
		}
		Obs obsDiagnosis = new Obs();
		obsDiagnosis.setConcept(diagnosisConcept);
		obsDiagnosis.setObsGroup(obsGroup);
		obsDiagnosis.setValueCoded(Context.getConceptService().getConcept(this.id));
		obsDiagnosis.setCreator(encounter.getCreator());
		obsDiagnosis.setDateCreated(encounter.getDateCreated());
		obsDiagnosis.setEncounter(encounter);
		obsDiagnosis.setPerson(encounter.getPatient());
		encounter.addObs(obsDiagnosis);
	}
}
