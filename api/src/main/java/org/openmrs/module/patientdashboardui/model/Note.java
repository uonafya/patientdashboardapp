package org.openmrs.module.patientdashboardui.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmissionLog;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@JsonIgnoreProperties({"referral"})
public class Note {

	private static Logger logger = LoggerFactory.getLogger(Note.class);
	
	public Note () {
	}

	public Note(int patientId, Integer queueId, Integer opdId, Integer opdLogId) {
		super();
		this.patientId = patientId;
		this.queueId = queueId;
		this.opdId = opdId;
		this.admitted = Context.getService(IpdService.class).getAdmittedByPatientId(patientId) != null;
		this.opdLogId = opdLogId;
		this.signs = new ArrayList<Sign>();
		this.diagnoses = new ArrayList<Diagnosis>();
		this.investigations = new ArrayList<Investigation>();
		this.procedures = new ArrayList<Procedure>();
		loadDiagnoses(patientId);
		loadSigns(patientId);
		this.availableOutcomes = Outcome.getAvailableOutcomes();
		this.inpatientWards = Outcome.getInpatientWards();
	}

	private int patientId;
	private Integer queueId;
	private Integer opdId;
	private boolean admitted;
	private Integer opdLogId;
	private List<Sign> signs = new ArrayList<Sign>() ;
	private Boolean diagnosisProvisional;
	private List<Diagnosis> diagnoses = new ArrayList<Diagnosis>();
	private List<Investigation> investigations = new ArrayList<Investigation>();
	private List<Procedure> procedures = new ArrayList<Procedure>();
	private List<Drug> drugs = new ArrayList<Drug>();
	private Referral referral = new Referral();;
	private Option referredTo;
	private Outcome outcome;
	private List<Option> availableOutcomes = new ArrayList<Option>();
	private List<Option> inpatientWards = new ArrayList<Option>();
	private String illnessHistory;

	private String otherInstructions;

	public int getPatientId() {
		return patientId;
	}

	public void setPatientId(int patientId) {
		this.patientId = patientId;
	}

	public Integer getQueueId() {
		return queueId;
	}

	public void setQueueId(Integer queueId) {
		this.queueId = queueId;
	}

	public Integer getOpdId() {
		return opdId;
	}

	public void setOpdId(Integer opdId) {
		this.opdId = opdId;
	}

	public boolean isAdmitted() {
		return admitted;
	}

	public void setAdmitted(boolean admitted) {
		this.admitted = admitted;
	}

	public Integer getOpdLogId() {
		return opdLogId;
	}

	public void setOpdLogId(Integer opdLogId) {
		this.opdLogId = opdLogId;
	}

	public List<Sign> getSigns() {
		return signs;
	}

	public void setSigns(List<Sign> symptoms) {
		this.signs = symptoms;
	}

	public Boolean getDiagnosisProvisional() {
		return diagnosisProvisional;
	}

	public void setDiagnosisProvisional(Boolean diagnosisProvisional) {
		this.diagnosisProvisional = diagnosisProvisional;
	}

	public List<Diagnosis> getDiagnoses() {
		return diagnoses;
	}

	public void setDiagnoses(List<Diagnosis> diagnoses) {
		this.diagnoses = diagnoses;
	}

	public List<Investigation> getInvestigations() {
		return investigations;
	}

	public void setInvestigations(List<Investigation> investigations) {
		this.investigations = investigations;
	}

	public List<Procedure> getProcedures() {
		return procedures;
	}

	public void setProcedures(List<Procedure> procedures) {
		this.procedures = procedures;
	}

	public Referral getReferral() {
		return referral;
	}

	public void setReferral(Referral referral) {
		this.referral = referral;
	}

	public Option getReferredTo() {
		return referredTo;
	}

	public void setReferredTo(Option referredTo) {
		this.referredTo = referredTo;
	}

	public Outcome getOutcome() {
		return this.outcome;
	}

	public void setOutcome(Outcome outcome) {
		this.outcome = outcome;
	}

	public List<Drug> getDrugs() {
		return drugs;
	}

	public void setDrugs(List<Drug> drugs) {
		this.drugs = drugs;
	}

	public List<Option> getAvailableOutcomes() {
		return availableOutcomes;
	}

	public void setAvailableOutcomes(List<Option> availableOutcomes) {
		this.availableOutcomes = availableOutcomes;
	}

	public List<Option> getInpatientWards() {
		return inpatientWards;
	}

	public void setInpatientWards(List<Option> inpatientWards) {
		this.inpatientWards = inpatientWards;
	}

	public String getIllnessHistory() {
		return illnessHistory;
	}

	public void setIllnessHistory(String illnessHistory) {
		this.illnessHistory = illnessHistory;
	}

	public String getOtherInstructions() {
		return otherInstructions;
	}

	public void setOtherInstructions(String otherInstructions) {
		this.otherInstructions = otherInstructions;
	}

	private void loadSigns(Integer patientId) {
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		List<Obs> symptomObs = queueService.getAllSymptom(patientId);
		for (Obs signObs : symptomObs) {
			signs.add(new Sign(signObs.getValueCoded()));
		}
	}

	private void loadDiagnoses(Integer patientId) {
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		List<Obs> diagnosisObsns = queueService.getAllDiagnosis(patientId);
		for (Obs diagnosisObs : diagnosisObsns) {
			diagnoses.add(new Diagnosis(diagnosisObs.getValueCoded()));
		}
		if (diagnoses.size() > 0) {
			this.diagnosisProvisional = true;
		}
	}

	public Encounter save() {
		Patient patient = Context.getPatientService().getPatient(this.patientId);
		Obs obsGroup = Context.getService(HospitalCoreService.class).getObsGroupCurrentDate(patient.getPersonId());
		Encounter encounter = createEncounter(patient);
		addObs(obsGroup, encounter);
		Context.getEncounterService().saveEncounter(encounter);
		saveNoteDetails(encounter);
		return encounter;
	}

	private Encounter createEncounter(Patient patient) {
		Encounter encounter = new Encounter();
		User user = Context.getAuthenticatedUser();
		String encounterTypeName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_OPD_ENCOUTNER_TYPE);
		EncounterType encounterType = Context.getEncounterService().getEncounterType(encounterTypeName);
		Location location = new Location(1);
		if (this.opdLogId != null) {
			OpdPatientQueueLog opdPatientQueueLog = Context.getService(PatientQueueService.class)
					.getOpdPatientQueueLogById(opdLogId);
			IpdPatientAdmissionLog ipdPatientAdmissionLog = Context.getService(IpdService.class)
					.getIpdPatientAdmissionLog(opdPatientQueueLog);
			encounter = ipdPatientAdmissionLog.getIpdEncounter();
		} else {
			encounter.setPatient(patient);
			encounter.setCreator(user);
			encounter.setEncounterDatetime(new Date());
			encounter.setEncounterType(encounterType);
			encounter.setLocation(location);
			encounter.setDateCreated(new Date());
		}
		return encounter;
	}

	private void addObs(Obs obsGroup, Encounter encounter) {
		for (Sign sign : this.signs) {
			sign.addObs(encounter, obsGroup);
		}
		for (Procedure procedure : this.procedures)
		{
			procedure.addObs(encounter,obsGroup);
		}
		for(Investigation investigation : this.investigations)
		{
			investigation.addObs(encounter,obsGroup);
		}
		for (Diagnosis diagnosis : this.diagnoses)
		{
			diagnosis.addObs(encounter, obsGroup, this.diagnosisProvisional);
		}
		
		if (referredTo != null) {
			referral.addReferralObs(referredTo, opdId, encounter, obsGroup);
		}
	}

	private void saveNoteDetails(Encounter encounter) {
		for (Drug drug : this.drugs) {
			String referralWardName = Context.getService(PatientQueueService.class).getOpdPatientQueueById(this.opdId)
					.getReferralConceptName();
			drug.save(encounter, referralWardName);
		}
		for (Investigation investigation : this.investigations) {
			String departmentName = Context.getConceptService().getConcept(this.opdId).getName().toString();
			try {
				investigation.save(encounter, departmentName);
			} catch (Exception e) {
				logger.error("Error saving investigation {}({}): {}", new Object[] { investigation.getId(), investigation.getLabel(), e.getMessage() });
			}
		}
		if (this.outcome != null) {
			this.outcome.save(encounter);
		}
	}
}
