package org.openmrs.module.patientdashboardapp.model;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.LocationAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.TestOrder;
import org.openmrs.User;
import org.openmrs.Visit;
import org.openmrs.api.VisitService;
import org.openmrs.api.context.Context;
import org.openmrs.module.appointments.model.Appointment;
import org.openmrs.module.appointments.model.AppointmentStatus;
import org.openmrs.module.appointments.service.AppointmentsService;
import org.openmrs.module.ehrconfigs.metadata.EhrCommonMetadata;
import org.openmrs.module.ehrconfigs.utils.EhrConfigsUtils;
import org.openmrs.module.hospitalcore.BillingConstants;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.EhrAppointmentService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.LabService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.RadiologyCoreService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.EhrAppointment;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmissionLog;
import org.openmrs.module.hospitalcore.model.Lab;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.hospitalcore.model.Option;
import org.openmrs.module.hospitalcore.model.RadiologyDepartment;
import org.openmrs.module.hospitalcore.model.Referral;
import org.openmrs.module.hospitalcore.model.ReferralReasons;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.module.patientdashboardapp.utils.Utils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Note {

	private static Logger logger = LoggerFactory.getLogger(Note.class);

	private static Set<Integer> collectionOfLabConceptIds = new HashSet<Integer>();
	private static Set<Integer> collectionOfRadiologyConceptIds = new HashSet<Integer>();

	static {
		List<Lab> labs = Context.getService(LabService.class).getAllLab();
		for (Lab lab : labs) {
			for (Concept labInvestigationCategoryConcept : lab.getInvestigationsToDisplay()) {
				for (ConceptAnswer labInvestigationConcept : labInvestigationCategoryConcept.getAnswers()) {
					collectionOfLabConceptIds.add(labInvestigationConcept.getAnswerConcept().getConceptId());
				}
			}
		}
		List<RadiologyDepartment> radiologyDepts = Context.getService(RadiologyCoreService.class).getAllRadiologyDepartments();
		for (RadiologyDepartment department : radiologyDepts) {
			for (Concept radiologyInvestigationCategoryConcept : department.getInvestigations()) {
				for (ConceptAnswer radiologyInvestigationConcept : radiologyInvestigationCategoryConcept.getAnswers()) {
					collectionOfRadiologyConceptIds.add(radiologyInvestigationConcept.getAnswerConcept().getConceptId());
				}
			}
		}
	}



	public Note () {
	}

	public Note(int patientId, Integer queueId, Integer opdId, Integer opdLogId) {
		super();
		this.patientId = patientId;
		this.queueId = queueId;
		this.opdId = opdId;
		this.admitted = Context.getService(IpdService.class).getAdmittedByPatientId(patientId) != null;
		this.opdLogId = opdLogId;
		this.diagnoses = Diagnosis.getPreviousDiagnoses(patientId);
		this.signs = Sign.getPreviousSigns(patientId);
		this.physicalExamination = getPreviousPhysicalExamination(patientId);
		this.illnessHistory = getPreviousIllnessHistory(patientId);
		this.onSetDate = getPreviousDateOfOnSetOfIlliness(patientId);
		this.investigationNotes = getPreviousInvestigationNotes(patientId);
	}

	private int patientId;
	private Integer queueId;
	private Integer opdId;
	private boolean admitted;
	private Integer opdLogId;
	private List<Sign> signs = new ArrayList<Sign>() ;
	private List<Diagnosis> diagnoses = new ArrayList<Diagnosis>();
	private List<Investigation> investigations = new ArrayList<Investigation>();
	private List<Procedure> procedures = new ArrayList<Procedure>();
	private List<Drug> drugs = new ArrayList<Drug>();
	private Option referredTo;
	private Option referralReasons;
	private Outcome outcome;
	private String illnessHistory;
	private String facility;
	private String referralComments;
    private String specify;
	private String otherInstructions;
	private String physicalExamination;

	public String getInvestigationNotes() {
		return investigationNotes;
	}

	public void setInvestigationNotes(String investigationNotes) {
		this.investigationNotes = investigationNotes;
	}

	private String investigationNotes;

	public String getOnSetDate() {
		return onSetDate;
	}

	public void setOnSetDate(String onSetDate) {
		this.onSetDate = onSetDate;
	}

	private String onSetDate;

	public static String PROPERTY_FACILITY = "161562AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; //Name of where patient was referred to

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

	public Option getReferredTo() {
		return referredTo;
	}

	public void setReferredTo(Option referredTo) {
		this.referredTo = referredTo;
	}

	public Option getReferralReasons() {
		return referralReasons;
	}

	public void setReferralReasons(Option referralReasons) {
		this.referralReasons = referralReasons;
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

	public String getIllnessHistory() {
		return illnessHistory;
	}

	public void setIllnessHistory(String illnessHistory) {
		this.illnessHistory = illnessHistory;
	}

	public String getFacility() {
		return facility;
	}

	public void setFacility(String facility) {
		this.facility = facility;
	}

	public String getSpecify() {
		return specify;
	}

	public void setSpecify(String specify) {
		this.specify = specify;
	}

	public String getReferralComments() {
		return referralComments;
	}

	public void setReferralComments(String referralComments) {
		this.referralComments = referralComments;
	}

	public String getOtherInstructions() {
		return otherInstructions;
	}

	public void setOtherInstructions(String otherInstructions) {
		this.otherInstructions = otherInstructions;
	}

	public String getPhysicalExamination() {
		return physicalExamination;
	}

	public void setPhysicalExamination(String physicalExamination) {
		this.physicalExamination = physicalExamination;
	}

	@Transactional
	public Encounter saveInvestigations() {
		Patient patient = Context.getPatientService().getPatient(this.patientId);
		Obs obsGroup = Context.getService(HospitalCoreService.class).getObsGroupCurrentDate(patient.getPersonId());
		Encounter encounter = createEncounter(patient);
		addObs(obsGroup, encounter);
        try {
			encounter.setVisit(EhrConfigsUtils.getLastVisitForPatient(patient));
			//save an encounter with all the other entries
			Context.getEncounterService().saveEncounter(encounter);
			saveNoteDetails(encounter);
			endEncounter(encounter);
			updateAppointmentIfAny(patient);
        } catch (Exception e) {
            e.printStackTrace();
        }

		return encounter;
	}

	private Encounter createEncounter(Patient patient) {
		Encounter encounter = new Encounter();
		KenyaEmrService kenyaEmrService =Context.getService(KenyaEmrService.class);
		User user = Context.getAuthenticatedUser();
		EncounterType encounterType = Context.getEncounterService().getEncounterTypeByUuid("ba45c278-f290-11ea-9666-1b3e6e848887");
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
			encounter.setProvider(EhrConfigsUtils.getDefaultEncounterRole(), EhrConfigsUtils.getProvider(user.getPerson()));
			encounter.setEncounterType(encounterType);
			encounter.setLocation(kenyaEmrService.getDefaultLocation());
			encounter.setDateCreated(new Date());
		}
		return encounter;
	}

	private void addObs(Obs obsGroup, Encounter encounter) {
		if (StringUtils.isNotBlank(this.onSetDate)) {
			addOnSetDate(encounter, obsGroup);
		}
		if (StringUtils.isNotBlank(this.illnessHistory)) {
			addIllnessHistory(encounter, obsGroup);
		}
		
		if (StringUtils.isNotBlank(this.otherInstructions)) {
			addOtherInstructions(encounter, obsGroup);
		}

		if (StringUtils.isNotBlank(this.facility)) {
			addFacility(encounter, obsGroup);
		}

		if(StringUtils.isNotBlank(this.physicalExamination)){
			addPhysicalExamination(encounter,obsGroup);
		}
		
		for (Sign sign : this.signs) {
			sign.addObs(encounter, obsGroup);
		}
		for (Procedure procedure : this.procedures) {
			addObsForProcedures(encounter,obsGroup, procedure);
		}

		for(Investigation investigation : this.investigations) {
			investigation.addObs(encounter,obsGroup);
		}
		if(StringUtils.isNotBlank(this.investigationNotes)){
			addInvestigationNotes(encounter,obsGroup);
		}
		
		for (Diagnosis diagnosis : this.diagnoses) {
			diagnosis.addObs(encounter, obsGroup);
		}
		
		if (referredTo != null) {
			Referral.addReferralObs(referredTo, opdId, encounter, referralComments, obsGroup);
		}

		if (referralReasons != null) {
			ReferralReasons.addReferralReasonsObs(referralReasons, specify, encounter, obsGroup);
		}
		if(this.outcome != null) {
			this.outcome.addObs(encounter, obsGroup);
		}
	}

	private void addFacility(Encounter encounter, Obs obsGroup) {
		Concept facilityConcept = Context.getConceptService().getConceptByUuid(PROPERTY_FACILITY);
		Obs obsFacility = new Obs();
		obsFacility.setObsGroup(obsGroup);
		obsFacility.setConcept(facilityConcept);
		Location location = Context.getLocationService().getLocation(Integer.parseInt(facility));
		String mflCode = " ";
		for (LocationAttribute locationAttribute :
				location.getAttributes()) {
			if (locationAttribute.getAttributeType().equals(Context.getLocationService().getLocationAttributeTypeByUuid("8a845a89-6aa5-4111-81d3-0af31c45c002"))){
				mflCode=locationAttribute.getValueReference();
			}
		}
		obsFacility.setValueText(location.getName()+" "+mflCode);
		obsFacility.setCreator(encounter.getCreator());
		obsFacility.setDateCreated(encounter.getDateCreated());
		obsFacility.setEncounter(encounter);
		encounter.addObs(obsFacility);
	}

	private void addIllnessHistory(Encounter encounter, Obs obsGroup) {
		Concept conceptIllnessHistory = Context.getConceptService().getConceptByUuid("1390AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		if (conceptIllnessHistory == null) {
			throw new NullPointerException("Illness history concept is not defined");
		}
		Obs obsIllnessHistory = new Obs();
		obsIllnessHistory.setObsGroup(obsGroup);
		obsIllnessHistory.setConcept(conceptIllnessHistory);
		obsIllnessHistory.setValueText(this.illnessHistory);
		obsIllnessHistory.setCreator(encounter.getCreator());
		obsIllnessHistory.setDateCreated(encounter.getDateCreated());
		obsIllnessHistory.setEncounter(encounter);
		encounter.addObs(obsIllnessHistory);
	}

	private void addOnSetDate(Encounter encounter, Obs obsGroup) {
		Concept onSetConcepts = Context.getConceptService().getConceptByUuid("164428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		if (onSetConcepts == null) {
			throw new NullPointerException("Date on set  concept is not defined");
		}
		Obs obsOnSetDate = new Obs();
		obsOnSetDate.setObsGroup(obsGroup);
		obsOnSetDate.setConcept(onSetConcepts);
		try {
		obsOnSetDate.setValueDatetime(Utils.getDateInddyyyymmddFromStringObject(this.onSetDate));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		obsOnSetDate.setCreator(encounter.getCreator());
		obsOnSetDate.setDateCreated(encounter.getDateCreated());
		obsOnSetDate.setEncounter(encounter);
		encounter.addObs(obsOnSetDate);
	}



	private void addOtherInstructions(Encounter encounter, Obs obsGroup) {
		Concept conceptOtherInstructions = Context.getConceptService().getConceptByUuid("163106AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		if (conceptOtherInstructions == null) {
			throw new NullPointerException("Other instructions concept is not defined");
		}
		Obs obsOtherInstructions = new Obs();
		obsOtherInstructions.setObsGroup(obsGroup);
		obsOtherInstructions.setConcept(conceptOtherInstructions);
		obsOtherInstructions.setValueText(this.otherInstructions);
		obsOtherInstructions.setCreator(encounter.getCreator());
		obsOtherInstructions.setDateCreated(encounter.getDateCreated());
		obsOtherInstructions.setEncounter(encounter);
		encounter.addObs(obsOtherInstructions);
	}



	public void addPhysicalExamination(Encounter encounter, Obs obsGroup)
	{
		Concept conceptPhysicalExamination = Context.getConceptService().getConceptByUuid("1391AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		if (conceptPhysicalExamination == null) {
			throw new NullPointerException("Physical examination concept is not defined");
		}
		Obs obsPhysicalExamination = new Obs();
		obsPhysicalExamination.setObsGroup(obsGroup);
		obsPhysicalExamination.setConcept(conceptPhysicalExamination);
		obsPhysicalExamination.setValueText(this.physicalExamination);
		obsPhysicalExamination.setCreator(encounter.getCreator());
		obsPhysicalExamination.setDateCreated(encounter.getDateCreated());
		obsPhysicalExamination.setEncounter(encounter);
		encounter.addObs(obsPhysicalExamination);
	}

	public void addInvestigationNotes(Encounter encounter, Obs obsGroup)
	{
		Concept conceptInvestigationNotes = Context.getConceptService().getConceptByUuid("162749AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		if (conceptInvestigationNotes == null) {
			throw new NullPointerException("Investigation notes concept is not defined");
		}
		Obs obsInvestigationNotes = new Obs();
		obsInvestigationNotes.setObsGroup(obsGroup);
		obsInvestigationNotes.setConcept(conceptInvestigationNotes);
		obsInvestigationNotes.setValueText(this.investigationNotes);
		obsInvestigationNotes.setCreator(encounter.getCreator());
		obsInvestigationNotes.setDateCreated(encounter.getDateCreated());
		obsInvestigationNotes.setEncounter(encounter);
		encounter.addObs(obsInvestigationNotes);
	}

	private void saveNoteDetails(Encounter encounter) {
		for (Drug drug : this.drugs) {
			String referralWardName = Context.getService(PatientQueueService.class).getOpdPatientQueueById(this.queueId)
					.getOpdConceptName();
			drug.save(encounter, referralWardName);
		}
		for (Investigation investigation : this.investigations) {
			String departmentName = Context.getConceptService().getConcept(this.opdId).getName().toString();
			try {
				saveInvestigations(encounter, departmentName, investigation);
			} catch (Exception e) {
				logger.error("Error saving investigation {}({}): {}", new Object[] { investigation.getId(), investigation.getLabel(), e.getMessage() });
			}
		}
		for(Procedure procedure : this.procedures) {
			String departmentName = Context.getConceptService().getConcept(this.opdId).getName().toString();
			try {
				saveProcedures(encounter, departmentName, procedure);
			}
			catch (Exception e) {
				logger.error("Error saving procedure {}({}): {}", new Object[] { procedure.getId(), procedure.getLabel(), e.getMessage() });
			}
		}
		for(Sign sign: this.signs) {
			sign.save(encounter);
		}
		if (this.outcome != null) {
			this.outcome.save(encounter);
		}
	}
	
	private void endEncounter(Encounter encounter) {
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		if (this.queueId != null) {
			OpdPatientQueue queue = queueService.getOpdPatientQueueById(this.queueId);
			OpdPatientQueueLog queueLog = new OpdPatientQueueLog();
			queueLog.setOpdConcept(queue.getOpdConcept());
			queueLog.setOpdConceptName(queue.getOpdConceptName());
			queueLog.setPatient(queue.getPatient());
			queueLog.setCreatedOn(queue.getCreatedOn());
			queueLog.setPatientIdentifier(queue.getPatientIdentifier());
			queueLog.setPatientName(queue.getPatientName());
			queueLog.setReferralConcept(queue.getReferralConcept());
			queueLog.setReferralConceptName(queue.getReferralConceptName());
			queueLog.setSex(queue.getSex());
			queueLog.setUser(Context.getAuthenticatedUser());
			queueLog.setStatus("processed");
			queueLog.setBirthDate(encounter.getPatient().getBirthdate());
			queueLog.setEncounter(encounter);
			queueLog.setCategory(queue.getCategory());
			queueLog.setVisitStatus(queue.getVisitStatus());
			queueLog.setTriageDataId(queue.getTriageDataId());

			queueService.saveOpdPatientQueueLog(queueLog);
			queueService.deleteOpdPatientQueue(queue);
		}
	}
	private String getPreviousPhysicalExamination(int patientId){
		String previousPhysicalExamination = "";
		Patient patient = Context.getPatientService().getPatient(patientId);
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		Concept conceptPhysicalExamination = Context.getConceptService().getConceptByUuid("1391AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Encounter physicalExaminationEncounter = queueService.getLastOPDEncounter(patient);

		if(physicalExaminationEncounter!=null) {

			Set<Obs> allPhysicalExaminationEncounterObs = physicalExaminationEncounter.getAllObs();

			for (Obs ob : allPhysicalExaminationEncounterObs) {
				if (ob.getConcept().equals(conceptPhysicalExamination)) {
					previousPhysicalExamination = ob.getValueText();
				}
			}
		}

		return  previousPhysicalExamination;
	}

	private String getPreviousInvestigationNotes(int patientId){
		String previousInvestigationNotes = "";
		Patient patient = Context.getPatientService().getPatient(patientId);
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		Concept conceptInvestigationNotes = Context.getConceptService().getConceptByUuid("162749AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Encounter investigationNotesEncounter = queueService.getLastOPDEncounter(patient);

		if(investigationNotesEncounter!=null) {

			Set<Obs> allInvestigationCommentsEncounterObs = investigationNotesEncounter.getAllObs();

			for (Obs ob : allInvestigationCommentsEncounterObs) {
				if (ob.getConcept().equals(conceptInvestigationNotes)) {
					previousInvestigationNotes = ob.getValueText();
				}
			}
		}

		return  previousInvestigationNotes;
	}

    private String getPreviousIllnessHistory(int patientId){
        String previousIllnessHistory = "";
        Patient patient = Context.getPatientService().getPatient(patientId);
        PatientQueueService queueService = Context.getService(PatientQueueService.class);
        Concept conceptPreviousIllnessHistory = Context.getConceptService().getConceptByUuid("1390AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        Encounter previousIllnessHistoryEncounter = queueService.getLastOPDEncounter(patient);
        if (previousIllnessHistoryEncounter != null){
            Set<Obs> allPreviousIllnessHistoryObs = previousIllnessHistoryEncounter.getAllObs();

            for (Obs obs :allPreviousIllnessHistoryObs){
                if (obs.getConcept().equals(conceptPreviousIllnessHistory )){
                    previousIllnessHistory = obs.getValueText();
                }
            }
        }

        return previousIllnessHistory;
    }

    private String getPreviousDateOfOnSetOfIlliness(int patientId){
		String previousOnSetDate = "";
		Patient patient = Context.getPatientService().getPatient(patientId);
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		Concept onSetConcepts = Context.getConceptService().getConceptByUuid("164428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		Encounter previousOnSetDateEncounter = queueService.getLastOPDEncounter(patient);
		if(previousOnSetDateEncounter != null) {
			Set<Obs> allPreviousObs = previousOnSetDateEncounter.getAllObs();
			for(Obs obs :allPreviousObs) {
				if (obs.getConcept().equals(onSetConcepts )){
					previousOnSetDate = Utils.getDateAsString(obs.getValueDatetime(), "dd/MM/yyyy");
				}
			}
		}
		return previousOnSetDate;

	}

	public void saveInvestigations(Encounter encounter, String departmentName, Investigation investigation) throws Exception {
		Concept investigationConcept = Context.getConceptService().getConceptByUuid("0179f241-8c1d-47c1-8128-841f6508e251");
		if (investigationConcept == null) {
			throw new Exception("Investigation concept null");
		}
		BillableService billableService = Context.getService(BillingService.class).getServiceByConceptId(investigation.getId());
		OpdTestOrder opdTestOrder = new OpdTestOrder();
		opdTestOrder.setPatient(encounter.getPatient());
		opdTestOrder.setEncounter(encounter);
		opdTestOrder.setConcept(investigationConcept);
		opdTestOrder.setTypeConcept(DepartmentConcept.TYPES[2]);
		opdTestOrder.setValueCoded(Context.getConceptService().getConcept(investigation.getId()));
		opdTestOrder.setCreator(encounter.getCreator());
		opdTestOrder.setCreatedOn(encounter.getDateCreated());
		opdTestOrder.setBillableService(billableService);
		opdTestOrder.setScheduleDate(encounter.getDateCreated());
		opdTestOrder.setFromDept(departmentName);
		if (billableService.getPrice() != null && billableService.getPrice().compareTo(BigDecimal.ZERO) == 0) {
			opdTestOrder.setBillingStatus(1);
		}

		PersonAttributeType patientCategoryAttributeType = Context.getPersonService().getPersonAttributeTypeByUuid(
				"09cd268a-f0f5-11ea-99a8-b3467ddbf779");
		PersonAttributeType payingCategoryAttributeType = Context.getPersonService().getPersonAttributeTypeByUuid(
				"972a32aa-6159-11eb-bc2d-9785fed39154");

		PersonAttribute patientCategoryAttribute = encounter.getPatient().getAttribute(patientCategoryAttributeType);
		PersonAttribute payingCategoryAttribute = encounter.getPatient().getAttribute(payingCategoryAttributeType);

		if((patientCategoryAttribute != null && patientCategoryAttribute.getValue().equals("Non paying")) ||
				(payingCategoryAttribute != null && payingCategoryAttribute.getValue().equals("NHIF patient"))) {
			opdTestOrder.setBillingStatus(1);
		}

		opdTestOrder = Context.getService(PatientDashboardService.class).saveOrUpdateOpdOrder(opdTestOrder);

		processInvestigationsForBillingFree(opdTestOrder, encounter.getLocation());
	}

	private void processInvestigationsForBillingFree(OpdTestOrder opdTestOrder, Location encounterLocation) {
		String radiologyClass = "8caa332c-efe4-4025-8b18-3398328e1323";
		String labSet = "8d492026-c2cc-11de-8d13-0010c6dffd0f";
		String test = "8d4907b2-c2cc-11de-8d13-0010c6dffd0f";

		if(opdTestOrder.getBillingStatus() == 1) {
			if (opdTestOrder.getValueCoded().getConceptClass().getUuid().equals(labSet) || opdTestOrder.getValueCoded().getConceptClass().getUuid().equals(test)) {
				EncounterType labEncounterType = Context.getEncounterService().getEncounterTypeByUuid(EhrCommonMetadata._EhrEncounterTypes.LABENCOUNTER);
				Encounter encounter = getInvestigationEncounter(opdTestOrder,
						encounterLocation, labEncounterType);

				String labOrderTypeId = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_LAB_ORDER_TYPE);
				generateInvestigationOrder(opdTestOrder, encounter, labOrderTypeId);
				Context.getEncounterService().saveEncounter(encounter);
			}

			if (opdTestOrder.getValueCoded().getConceptClass().getUuid().equals(radiologyClass)) {
				EncounterType radiologyEncounterType = Context.getEncounterService().getEncounterTypeByUuid(EhrCommonMetadata._EhrEncounterTypes.RADIOLOGYENCOUNTER);
				Encounter encounter = getInvestigationEncounter(opdTestOrder,
						encounterLocation, radiologyEncounterType);

				String labOrderTypeId = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_RADIOLOGY_ORDER_TYPE);
				generateInvestigationOrder(opdTestOrder, encounter, labOrderTypeId);
				Context.getEncounterService().saveEncounter(encounter);
			}
		}

	}

	private Encounter getInvestigationEncounter(OpdTestOrder opdTestOrder,
												Location encounterLocation, EncounterType encounterType) {
		List<Encounter> investigationEncounters = Context.getEncounterService().getEncounters(opdTestOrder.getPatient(), null, opdTestOrder.getCreatedOn(), null, null, Arrays.asList(encounterType), null, null, null, false);
		Encounter encounter = null;
		if (investigationEncounters.size() > 0) {
			encounter = investigationEncounters.get(0);
		} else {
			encounter = new Encounter();
			encounter.setCreator(opdTestOrder.getCreator());
			encounter.setLocation(encounterLocation);
			encounter.setDateCreated(opdTestOrder.getCreatedOn());
			encounter.setEncounterDatetime(opdTestOrder.getCreatedOn());
			encounter.setEncounterType(encounterType);
			encounter.setPatient(opdTestOrder.getPatient());
			encounter.setProvider(EhrConfigsUtils.getDefaultEncounterRole(), EhrConfigsUtils.getProvider(opdTestOrder.getCreator().getPerson()));
		}
		return encounter;
	}

	private void generateInvestigationOrder(OpdTestOrder opdTestOrder,
											Encounter encounter, String orderTypeId) {
		Order order = new TestOrder();
		order.setConcept(opdTestOrder.getValueCoded());
		order.setCreator(opdTestOrder.getCreator());
		order.setDateCreated(opdTestOrder.getCreatedOn());
		order.setOrderer(EhrConfigsUtils.getProvider(opdTestOrder.getCreator().getPerson()));
		order.setPatient(opdTestOrder.getPatient());
		order.setDateActivated(new Date());
		order.setAccessionNumber("0");
		order.setOrderType(Context.getOrderService().getOrderTypeByUuid("52a447d3-a64a-11e3-9aeb-50e549534c5e"));
		order.setCareSetting(Context.getOrderService().getCareSettingByUuid("6f0c9a92-6f24-11e3-af88-005056821db0"));
		order.setEncounter(encounter);
		encounter.addOrder(order);
	}

	private void saveProcedures(Encounter encounter, String departmentName, Procedure procedure) throws Exception {
		Concept procedureConcept = Context.getConceptService().getConceptByUuid("1651AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		if (procedureConcept == null) {
			throw new Exception("Post for procedure concept null");
		}
		BillableService billableService = Context.getService(BillingService.class).getServiceByConceptId(procedure.getId());
		OpdTestOrder opdTestOrder = new OpdTestOrder();
		opdTestOrder.setPatient(encounter.getPatient());
		opdTestOrder.setEncounter(encounter);
		opdTestOrder.setConcept(procedureConcept);
		opdTestOrder.setTypeConcept(DepartmentConcept.TYPES[1]);
		opdTestOrder.setValueCoded(Context.getConceptService().getConcept(procedure.getId()));
		opdTestOrder.setCreator(encounter.getCreator());
		opdTestOrder.setCreatedOn(encounter.getDateCreated());
		opdTestOrder.setBillableService(billableService);
		opdTestOrder.setScheduleDate(encounter.getDateCreated());
		opdTestOrder.setFromDept(departmentName);
		if (billableService.getPrice() != null && billableService.getPrice().compareTo(BigDecimal.ZERO) == 0) {
			opdTestOrder.setBillingStatus(1);
		}
		PersonAttributeType patientCategoryAttributeType = Context.getPersonService().getPersonAttributeTypeByUuid(
				"09cd268a-f0f5-11ea-99a8-b3467ddbf779");
		PersonAttributeType payingCategoryAttributeType = Context.getPersonService().getPersonAttributeTypeByUuid(
				"972a32aa-6159-11eb-bc2d-9785fed39154");

		PersonAttribute patientCategoryAttribute = encounter.getPatient().getAttribute(patientCategoryAttributeType);
		PersonAttribute payingCategoryAttribute = encounter.getPatient().getAttribute(payingCategoryAttributeType);

		if((patientCategoryAttribute != null && patientCategoryAttribute.getValue().equals("Non paying")) ||
				(payingCategoryAttribute != null && payingCategoryAttribute.getValue().equals("NHIF patient"))) {
			opdTestOrder.setBillingStatus(1);
		}

		Context.getService(PatientDashboardService.class).saveOrUpdateOpdOrder(opdTestOrder);
	}

	private void addObsForProcedures(Encounter encounter, Obs obsGroup, Procedure procedure) {
		Obs obsProcedure = new Obs();
		obsProcedure.setObsGroup(obsGroup);
		obsProcedure.setConcept(Context.getConceptService().getConceptByUuid("1651AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"));
		obsProcedure.setValueCoded(Context.getConceptService().getConcept(procedure.getId()));
		obsProcedure.setCreator(encounter.getCreator());
		obsProcedure.setDateCreated(encounter.getDateCreated());
		obsProcedure.setEncounter(encounter);
		obsProcedure.setPerson(encounter.getPatient());
		encounter.addObs(obsProcedure);
	}


	private void updateAppointmentIfAny(Patient patient){
		EhrAppointmentService ehrAppointmentService = Context.getService(EhrAppointmentService.class);
		AppointmentsService appointmentService = Context.getService(AppointmentsService.class);
		Appointment ehrAppointment = ehrAppointmentService.getLastEhrAppointment(patient);
		if(ehrAppointment != null && ehrAppointment.getStatus() != null && (ehrAppointment.getStatus().equals(AppointmentStatus.CheckedIn)
				|| ehrAppointment.getStatus().equals(AppointmentStatus.Rescheduled)
				|| ehrAppointment.getStatus().equals(AppointmentStatus.Scheduled))) {
			ehrAppointment.setStatus(AppointmentStatus.Completed);
			appointmentService.validateAndSave(ehrAppointment);
		}
	}
}
