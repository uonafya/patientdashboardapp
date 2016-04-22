package org.openmrs.module.patientdashboardapp.model;

import java.util.ArrayList;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.Drug;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;

public class VisitDetail {
	private static final String FINAL_DIAGNOSIS_CONCEPT_NAME = "FINAL DIAGNOSIS";
	private String history = "No History";
	private String symptoms = "No symptoms";
	private String diagnosis = "No diagnosis";
	private String investigations = "No Investigations requested";
	private String procedures = "No procedures";
	private String physicalExamination = "No physicalExamination";

	public String getPhysicalExamination() {
		return physicalExamination;
	}

	public void setPhysicalExamination(String physicalExamination) {
		this.physicalExamination = physicalExamination;
	}


	private List<Drug> drugs = new ArrayList<Drug>();

	public String getHistory() {
		return history;
	}

	public void setHistory(String history) {
		this.history = history;
	}

	public String getSymptoms() {
		return symptoms;
	}

	public void setSymptoms(String symptoms) {
		this.symptoms = symptoms;
	}

	public String getDiagnosis() {
		return diagnosis;
	}

	public void setDiagnosis(String diagnosis) {
		this.diagnosis = diagnosis;
	}

	public String getInvestigations() {
		return investigations;
	}

	public void setInvestigations(String investigations) {
		this.investigations = investigations;
	}

	public String getProcedures() {
		return procedures;
	}

	public void setProcedures(String procedures) {
		this.procedures = procedures;
	}

	public List<Drug> getDrugs() {
		return drugs;
	}

	public void setDrugs(List<Drug> drugs) {
		this.drugs = drugs;
	}
	
	public static VisitDetail create(Encounter encounter) {
        String historyConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_HISTORY_OF_PRESENT_ILLNESS);
		String symptomConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_SYMPTOM);
		String provisionalDiagnosisConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_PROVISIONAL_DIAGNOSIS);
		String investigationConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_FOR_INVESTIGATION);
		String procedureConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_POST_FOR_PROCEDURE);
        String physicalExaminationConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_EXAMINATION);
		
		Concept symptomConcept = Context.getConceptService().getConcept(symptomConceptName);
		Concept provisionalDiagnosisConcept = Context.getConceptService().getConcept(provisionalDiagnosisConceptName);
		Concept finalDiagnosisConcept = Context.getConceptService().getConcept(FINAL_DIAGNOSIS_CONCEPT_NAME);
		Concept investigationConcept = Context.getConceptService().getConcept(investigationConceptName);
		Concept procedureConcept = Context.getConceptService().getConcept(procedureConceptName);
		Concept physicalExaminationConcept = Context.getConceptService().getConcept(physicalExaminationConceptName);
        Concept historyConcept = Context.getConceptService().getConcept(historyConceptName);
		
		StringBuffer symptomList = new StringBuffer();
		StringBuffer provisionalDiagnosisList = new StringBuffer();
		StringBuffer finalDiagnosisList = new StringBuffer();
		StringBuffer investigationList = new StringBuffer();
		StringBuffer procedureList = new StringBuffer();
        StringBuffer physicalExamination = new StringBuffer();
        StringBuffer history = new StringBuffer();
		for (Obs obs : encounter.getAllObs()) {
			if (obs.getConcept().equals(symptomConcept)) {
				symptomList.append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(provisionalDiagnosisConcept)) {
				provisionalDiagnosisList.append("(Provisional)").append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(finalDiagnosisConcept)) {
				finalDiagnosisList.append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(investigationConcept)) {
				investigationList.append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(procedureConcept)) {
				procedureList.append(obs.getValueCoded().getDisplayString()).append(", ");
			}
            if (obs.getConcept().equals(physicalExaminationConcept)){
                physicalExamination.append(obs.getValueCoded().getDisplayString()).append(", ");
            }
            if (obs.getConcept().equals(historyConcept)){
                history.append(obs.getValueCoded().getDisplayString()).append(", ");
            }
		}
		
		VisitDetail visitDetail = new VisitDetail();
		if (provisionalDiagnosisList.length() > 0) {
			visitDetail.setDiagnosis(provisionalDiagnosisList.append(finalDiagnosisList).substring(0, provisionalDiagnosisList.length() - ", ".length()));
		}
		if (symptomList.length() > 0) {
			visitDetail.setSymptoms(symptomList.substring(0, symptomList.length() - ", ".length()));
		}
		if (procedureList.length() > 0) {
			visitDetail.setProcedures(procedureList.substring(0, procedureList.length() - ", ".length()));
		}
		if (investigationList.length() > 0) {
			visitDetail.setInvestigations(investigationList.substring(0, investigationList.length() - ", ".length()));
		}
        if (physicalExamination.length()>0){
            visitDetail.setPhysicalExamination(physicalExamination.substring(0,physicalExamination.length()-",".length()));
        }
        if (history.length()>0){
            visitDetail.setHistory(history.substring(0,history.length()-",".length()));
        }
		return visitDetail;
	}
}
