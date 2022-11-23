package org.openmrs.module.patientdashboardapp.model;

import org.openmrs.Concept;
import org.openmrs.Drug;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.api.context.Context;
import org.openmrs.module.patientdashboardapp.utils.Utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static org.openmrs.module.patientdashboardapp.model.Note.PROPERTY_FACILITY;

public class VisitDetail {
	private static final String OTHER_SYMPTOM = "cb46888c-586a-4ba0-98d5-f2e7e49a60f6";
	private String history = "No History";
	private String symptoms = "No symptoms";
	private String diagnosis = "No diagnosis";
	private String investigations = "No Investigations requested";
	private String procedures = "No procedures";
	private String physicalExamination = "No physicalExamination";
	private String visitOutcome = "No Outcome Of Visit";
	private String internalReferral = "No internal Referral";
	private String externalReferral = "No external Referral";
	private String otherInstructions = "No Other instructions given";

	public String getProviderName() {
		return providerName;
	}

	public void setProviderName(String providerName) {
		this.providerName = providerName;
	}

	private String providerName = "";

	public String getDiseaseOnSetDate() {
		return diseaseOnSetDate;
	}

	public void setDiseaseOnSetDate(String diseaseOnSetDate) {
		this.diseaseOnSetDate = diseaseOnSetDate;
	}

	private String diseaseOnSetDate = "No disease on set date";

	public String getExternalReferral() {
		return externalReferral;
	}

	public void setExternalReferral(String externalReferral) {
		this.externalReferral = externalReferral;
	}

	public String getInternalReferral() {
		return internalReferral;
	}

	public void setInternalReferral(String internalReferral) {
		this.internalReferral = internalReferral;
	}

	public String getVisitOutcome() {
		return visitOutcome;
	}

	public void setVisitOutcome(String visitOutcome) {
		this.visitOutcome = visitOutcome;
	}

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

	public String getOtherInstructions() { return otherInstructions; }

	public void setOtherInstructions(String otherInstructions) { this.otherInstructions = otherInstructions; }

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

		Concept symptomConcept = Context.getConceptService().getConceptByUuid("c91a7e0e-4622-4eeb-9edc-00f8ececf428");
		Concept provisionalDiagnosisConcept = Context.getConceptService().getConceptByUuid("160249AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept finalDiagnosisConcept = Context.getConceptService().getConceptByUuid("160250AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept investigationConcept = Context.getConceptService().getConceptByUuid("0179f241-8c1d-47c1-8128-841f6508e251");
		Concept procedureConcept = Context.getConceptService().getConceptByUuid("1651AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept physicalExaminationConcept = Context.getConceptService().getConceptByUuid("1391AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept historyConcept = Context.getConceptService().getConceptByUuid("1390AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept visitOutcomeConcept = Context.getConceptService().getConceptByUuid("160433AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept internalReferralConcept = Context.getConceptService().getConceptByUuid("cf37b5f8-d2a8-4185-9a0d-cebe996d9b80");
		Concept externalReferralConcept = Context.getConceptService().getConceptByUuid("477a7484-0f99-4026-b37c-261be587a70b");
		Concept facilityReferredToConcept = Context.getConceptService().getConceptByUuid(PROPERTY_FACILITY);
		Concept otherSymptom = Context.getConceptService().getConceptByUuid(OTHER_SYMPTOM);
		Concept otherInstructionsConcept = Context.getConceptService().getConceptByUuid("163106AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept onSetConcepts = Context.getConceptService().getConceptByUuid("164428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Concept nextAppointmentConcepts = Context.getConceptService().getConceptByUuid("5096AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

		StringBuilder symptomList = new StringBuilder();
		StringBuilder provisionalDiagnosisList = new StringBuilder();
		StringBuilder finalDiagnosisList = new StringBuilder();
		StringBuilder investigationList = new StringBuilder();
		StringBuilder procedureList = new StringBuilder();
		StringBuilder physicalExamination = new StringBuilder();
		StringBuilder history = new StringBuilder();
		StringBuilder visitOutcome = new StringBuilder();
		StringBuilder internalReferral = new StringBuilder();
		StringBuilder externalReferral = new StringBuilder();
		StringBuilder otherInstructions = new StringBuilder();
		StringBuilder diseaseOnSetDate = new StringBuilder();
		for (Obs obs :encounter.getAllObs()) {
			if (obs.getConcept().equals(symptomConcept)) {
				if (obs.getValueCoded().equals(otherSymptom)) {
					for (Obs obsFromAll: obs.getEncounter().getAllObs()) {
						if(obsFromAll.getConcept() != null && obsFromAll.getConcept().equals(Context.getConceptService().getConceptByUuid("5622AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"))) {
							symptomList.append(obsFromAll.getValueText());
						}
					}
				} else {
					symptomList.append(obs.getValueCoded().getDisplayString());
				}
				symptomList.append(", ");
			}
			if (obs.getConcept().equals(provisionalDiagnosisConcept)) {
				provisionalDiagnosisList.append("(Provisional)").append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(finalDiagnosisConcept)) {
				finalDiagnosisList.append("(Final)").append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(investigationConcept)) {
				investigationList.append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(procedureConcept)) {
				procedureList.append(obs.getValueCoded().getDisplayString()).append(", ");
			}
			if (obs.getConcept().equals(physicalExaminationConcept)){
				physicalExamination.append(obs.getValueText()).append(", ");
			}
			if (obs.getConcept().equals(historyConcept)){
				Set<Obs> getAllObs = encounter.getAllObs();
				String onSetDate = "";
				if(getAllObs != null){
					for(Obs histo : getAllObs){
						if(histo.getConcept().equals(Context.getConceptService().getConceptByUuid("164428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")) && histo.getValueDatetime() != null){

						}
					}
				}
				history.append(obs.getValueText()).append(", ").append(onSetDate);
			}
			if (obs.getConcept().equals(otherInstructionsConcept)){
				otherInstructions.append(obs.getValueText()).append(", ");
			}
			if (obs.getConcept().equals(visitOutcomeConcept)){

				if ((obs.getValueCoded() != null) ){
					System.out.println("Obs value coded not null" + obs.getValueCoded() );
					if (obs.getValueCoded().equals(Context.getConceptService().getConceptByUuid("160523AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"))) {

						Set<Obs> getAllObs = encounter.getAllObs();
						String nextApppointmentDate = "";
						for (Obs obs1 : getAllObs) {
							if (obs1.getConcept().equals(nextAppointmentConcepts)) {
								nextApppointmentDate = Utils.getDateAsString(obs1.getValueDatetime(), "dd/MM/yyyy");
								break;
							}
						}
						visitOutcome.append(obs.getValueText()).append(",").append(nextApppointmentDate);
					} else {
						visitOutcome.append(obs.getValueText()).append(",");
					}
				}else {
					System.out.println("obs.getValueCoded() is currently null");
				}
			}
			if (obs.getConcept().equals(internalReferralConcept)){
				internalReferral.append(obs.getValueCoded().getDisplayString()).append(",");
			}
			if(obs.getConcept().equals(externalReferralConcept)){
				externalReferral.append(obs.getValueCoded().getDisplayString());
			}
			if (obs.getConcept().equals(facilityReferredToConcept)){
				externalReferral.append("("+obs.getValueText()+")");
			}
			if(obs.getConcept().equals(onSetConcepts)) {
				diseaseOnSetDate.append(Utils.getDateAsString(obs.getValueDatetime(), "yyyy-MM-dd"));
			}

		}

		VisitDetail visitDetail = new VisitDetail();
		visitDetail.setProviderName(encounter.getCreator().getPersonName().getFullName());
		if (provisionalDiagnosisList.length() > 0 || finalDiagnosisList.length() > 0) {
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
		if (physicalExamination.length() > 0){
			visitDetail.setPhysicalExamination(physicalExamination.substring(0,physicalExamination.length()-",".length()));
		}
		if (history.length() > 0){
			visitDetail.setHistory(history.substring(0,history.length()-",".length()));
		}
		if (otherInstructions.length() > 0){
			visitDetail.setOtherInstructions(otherInstructions.substring(0,otherInstructions.length()-",".length()));
		}
		if (visitOutcome.length() > 0){
			visitDetail.setVisitOutcome(visitOutcome.substring(0,visitOutcome.length()-",".length()));
		}
		if (internalReferral.length() > 0){
			visitDetail.setInternalReferral(internalReferral.substring(0, internalReferral.length() - ",".length()));
		}
		if (externalReferral.length() > 0){
			visitDetail.setExternalReferral(externalReferral.substring(0));
		}
		if (diseaseOnSetDate.length() > 0){
			visitDetail.setDiseaseOnSetDate(diseaseOnSetDate.substring(0));
		}
		return visitDetail;
	}


}