package org.openmrs.module.patientdashboardapp.model;

import java.util.ArrayList;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Diagnosis {

	//TODO: move to global properties
	private static final String FINAL_DIAGNOSIS_CONCEPT_NAME = "FINAL DIAGNOSIS";
	
	private static final Logger logger = LoggerFactory.getLogger(Diagnosis.class);

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
	public boolean isProvisional() { return provisional; }
	public void setProvisional(boolean provisional) { this.provisional = provisional; }

	private Integer id;
	private String label;
	private boolean provisional;

	public void addObs(Encounter encounter, Obs obsGroup) {
		List<Diagnosis> previousProvisionalDiagnoses = getPreviousDiagnoses(encounter.getPatient().getPatientId());
		if (isProvisional() && !previousProvisionalDiagnoses.contains(this)) {
			String provisionalDiagnosisConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_PROVISIONAL_DIAGNOSIS);
			Concept diagnosisConcept = Context.getConceptService().getConcept(provisionalDiagnosisConceptName);
			addObsToEncounter(encounter, obsGroup, diagnosisConcept);
		}
		
		if (!isProvisional()) {
			Concept diagnosisConcept = Context.getConceptService().getConcept(FINAL_DIAGNOSIS_CONCEPT_NAME);
			addObsToEncounter(encounter, obsGroup, diagnosisConcept);
		}
	}

	private void addObsToEncounter(Encounter encounter, Obs obsGroup,
			Concept diagnosisConcept) {
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
	
	public static List<Diagnosis> getPreviousDiagnoses(Integer patientId) {
		logger.debug("Fetching previous provisional diagnoses");
		List<Diagnosis> previousDiagnoses = new ArrayList<Diagnosis>();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		List<Obs> diagnosisObsns = queueService.getAllDiagnosis(patientId);
		for (Obs diagnosisObs : diagnosisObsns) {
			Diagnosis diagnosis = new Diagnosis(diagnosisObs.getValueCoded());
			diagnosis.setProvisional(true);
			previousDiagnoses.add(diagnosis);
		}
		
		logger.debug("Found " + previousDiagnoses.size() + " previous provisional diagnoses");
		return previousDiagnoses;
	}

	@Override
	public int hashCode() {
		int hash = 1;
		hash = hash * 31;
		hash = hash * 31 + (this.id == null ? 0 : this.id.hashCode());
		return hash;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}

		if (!(obj instanceof Diagnosis)) {
			return false;
		}
		Diagnosis otherDiagnosis = (Diagnosis) obj;
		return (this.id.equals(otherDiagnosis.id))
				&& ((this.id == null)
						? otherDiagnosis.id == null
						: this.id.equals(otherDiagnosis.id));
	}

	@Override
	public String toString() {
		return "{id=" + this.id + ", label=" + this.label + "}";
	}

}
