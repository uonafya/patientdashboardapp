package org.openmrs.module.patientdashboardapp.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.PersonAttribute;
import org.openmrs.Provider;
import org.openmrs.TestOrder;
import org.openmrs.User;
import org.openmrs.api.ProviderService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingConstants;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.LabService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmissionLog;
import org.openmrs.module.hospitalcore.model.Lab;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

public class Note {

	private static Logger logger = LoggerFactory.getLogger(Note.class);

	private static Set<Integer> collectionOfLabConceptIds = new HashSet<Integer>();

	static {
		List<Lab> labs = Context.getService(LabService.class).getAllLab();
		System.out.println("All labs have been found here>."+labs);
		for (Lab lab : labs) {
			System.out.println("This for each of the labs that are being done>>>"+lab);
			for (Concept labInvestigationCategoryConcept : lab.getInvestigationsToDisplay()) {
				System.out.println("For every concept to display is this>>"+labInvestigationCategoryConcept);
				for (ConceptAnswer labInvestigationConcept : labInvestigationCategoryConcept.getAnswers()) {
					System.out.println("For every answer we get this one>."+labInvestigationConcept);
					collectionOfLabConceptIds.add(labInvestigationConcept.getAnswerConcept().getConceptId());
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
	}


	private static final String PHYSICAL_EXAMINATION_CONCEPT_NAME = "PHYSICAL EXAM"; // replaced this with PHYSICAL EXAMINATION from afyaehms
    private static final String PREVIOUS_ILLNESS_HISTORY_CONCEPT_NAME = "HISTORY OF PRESENT ILLNESS"  ;

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

	public static String PROPERTY_FACILITY = "patientdashboard.facilityConcept"; //Name of where patient was referred to

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
	public Encounter save() {
		Patient patient = Context.getPatientService().getPatient(this.patientId);
		Obs obsGroup = Context.getService(HospitalCoreService.class).getObsGroupCurrentDate(patient.getPersonId());
		Encounter encounter = createEncounter(patient);
		addObs(obsGroup, encounter);
		Context.getEncounterService().saveEncounter(encounter);
		saveNoteDetails(encounter);
		endEncounter(encounter);
		return encounter;
	}

	private Encounter createEncounter(Patient patient) {
		Encounter encounter = new Encounter();
		KenyaEmrService kenyaEmrService =Context.getService(KenyaEmrService.class);
		User user = Context.getAuthenticatedUser();
		String encounterTypeName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_OPD_ENCOUTNER_TYPE);
		EncounterType encounterType = Context.getEncounterService().getEncounterType(encounterTypeName);
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
			encounter.setLocation(kenyaEmrService.getDefaultLocation());
			encounter.setDateCreated(new Date());
		}
		return encounter;
	}

	private void addObs(Obs obsGroup, Encounter encounter) {
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
			procedure.addObs(encounter,obsGroup);
		}

		for(Investigation investigation : this.investigations) {
			investigation.addObs(encounter,obsGroup);
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

		if (this.outcome != null) {
			this.outcome.addObs(encounter, obsGroup);
		}
	}

	private void addFacility(Encounter encounter, Obs obsGroup) {
		Concept facilityConcept = Context.getConceptService().getConcept(Context.getAdministrationService().getGlobalProperty(PROPERTY_FACILITY));
		Obs obsFacility = new Obs();
		obsFacility.setObsGroup(obsGroup);
		obsFacility.setConcept(facilityConcept);
		obsFacility.setValueText(this.facility);
		obsFacility.setCreator(encounter.getCreator());
		obsFacility.setDateCreated(encounter.getDateCreated());
		obsFacility.setEncounter(encounter);
		encounter.addObs(obsFacility);
	}

	private void addIllnessHistory(Encounter encounter, Obs obsGroup) {
		Concept conceptIllnessHistory = Context.getConceptService().getConcept("HISTORY OF PRESENT ILLNESS");
		Obs obsIllnessHistory = new Obs();
		obsIllnessHistory.setObsGroup(obsGroup);
		obsIllnessHistory.setConcept(conceptIllnessHistory);
		obsIllnessHistory.setValueText(this.illnessHistory);
		obsIllnessHistory.setCreator(encounter.getCreator());
		obsIllnessHistory.setDateCreated(encounter.getDateCreated());
		obsIllnessHistory.setEncounter(encounter);
		encounter.addObs(obsIllnessHistory);
	}



	private void addOtherInstructions(Encounter encounter, Obs obsGroup) {
		Concept conceptOtherInstructions = Context.getConceptService().getConcept("OTHER INSTRUCTIONS");
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
		Concept conceptPhysicalExamination = Context.getConceptService().getConcept(PHYSICAL_EXAMINATION_CONCEPT_NAME);
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

	private void saveNoteDetails(Encounter encounter) {
		for (Drug drug : this.drugs) {
			String referralWardName = Context.getService(PatientQueueService.class).getOpdPatientQueueById(this.queueId)
					.getOpdConceptName();
			drug.save(encounter, referralWardName);
		}
		for (Investigation investigation : this.investigations) {
			String departmentName = Context.getConceptService().getConcept(this.opdId).getName().toString();
			try {
				save(encounter, departmentName, investigation);
			} catch (Exception e) {
				logger.error("Error saving investigation {}({}): {}", new Object[] { investigation.getId(), investigation.getLabel(), e.getMessage() });
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
		Concept conceptPhysicalExamination = Context.getConceptService().getConcept(PHYSICAL_EXAMINATION_CONCEPT_NAME);
		Encounter physicalExaminationEncounter = queueService.getLastOPDEncounter(patient);

		if(physicalExaminationEncounter!=null) {

			Set<Obs> allPhysicalExaminationEncounterObs = physicalExaminationEncounter.getAllObs();

			for (Obs ob : allPhysicalExaminationEncounterObs) {
				if (ob.getConcept() == conceptPhysicalExamination) {
					previousPhysicalExamination = ob.getValueText();
				}
			}
		}

		return  previousPhysicalExamination;
	}

    private String getPreviousIllnessHistory(int patientId){
        String previousIllnessHistory = "";
        Patient patient = Context.getPatientService().getPatient(patientId);
        PatientQueueService queueService = Context.getService(PatientQueueService.class);
        Concept conceptPreviousIllnessHistory = Context.getConceptService().getConcept(PREVIOUS_ILLNESS_HISTORY_CONCEPT_NAME);
        Encounter previousIllnessHistoryEncounter = queueService.getLastOPDEncounter(patient);
        if (previousIllnessHistoryEncounter!=null){
            Set<Obs> allPreviousIllnessHistoryObs = previousIllnessHistoryEncounter.getAllObs();

            for (Obs obs :allPreviousIllnessHistoryObs){
                if (obs.getConcept() == conceptPreviousIllnessHistory ){
                    previousIllnessHistory = obs.getValueText();
                }
            }
        }

        return previousIllnessHistory;
    }

	public void save(Encounter encounter, String departmentName, Investigation investigation) throws Exception {
		Concept investigationConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_FOR_INVESTIGATION));
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
		if (billableService.getPrice().compareTo(BigDecimal.ZERO) == 0) {
			opdTestOrder.setBillingStatus(1);
		}
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		List<PersonAttribute> pas = hcs.getPersonAttributes(encounter.getPatient().getPatientId());

		for (PersonAttribute pa : pas) {
			String attributeValue = pa.getValue();
			if(attributeValue.equals("Non paying")){
				opdTestOrder.setBillingStatus(1);
				break;
			}
		}


		opdTestOrder = Context.getService(PatientDashboardService.class).saveOrUpdateOpdOrder(opdTestOrder);

		processInvestigationsForBillingFree(opdTestOrder, encounter.getLocation());
	}

	private void processInvestigationsForBillingFree(OpdTestOrder opdTestOrder, Location encounterLocation) {
		if(opdTestOrder.getBillingStatus() == 1) {
			Integer investigationConceptId = opdTestOrder.getValueCoded().getConceptId();
			if (collectionOfLabConceptIds.contains(investigationConceptId)) {
				String labEncounterTypeString = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_LAB_ENCOUNTER_TYPE, "LABENCOUNTER");
				EncounterType labEncounterType = Context.getEncounterService().getEncounterType(labEncounterTypeString);
				Encounter encounter = getInvestigationEncounter(opdTestOrder,
						encounterLocation, labEncounterType);

				String labOrderTypeId = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_LAB_ORDER_TYPE);
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
		}
		return encounter;
	}

	private void generateInvestigationOrder(OpdTestOrder opdTestOrder,
											Encounter encounter, String orderTypeId) {
		Order order = new TestOrder();
		order.setConcept(opdTestOrder.getValueCoded());
		order.setCreator(opdTestOrder.getCreator());
		order.setDateCreated(opdTestOrder.getCreatedOn());
		order.setOrderer(getProvider(opdTestOrder.getCreator().getPerson()));
		order.setPatient(opdTestOrder.getPatient());
		order.setDateActivated(new Date());
		order.setAccessionNumber("0");
		order.setOrderType(Context.getOrderService().getOrderTypeByUuid("52a447d3-a64a-11e3-9aeb-50e549534c5e"));
		order.setCareSetting(Context.getOrderService().getCareSettingByUuid("6f0c9a92-6f24-11e3-af88-005056821db0"));
		order.setEncounter(encounter);
		encounter.addOrder(order);
	}

	private Provider getProvider(Person person) {
		Provider provider = null;
		ProviderService providerService = Context.getProviderService();
		List<Provider> providerList = new ArrayList<Provider>(providerService.getProvidersByPerson(person));
		if(providerList.size() > 0){
			provider = providerList.get(0);
		}
		return provider;
	}

	private OrderType getLabOrderType() {
		//Test with Integer class
		Class clazz = Integer.class;
		OrderType orderType = new OrderType();
		orderType.setName("Lab order type");
		orderType.setJavaClassName("org.openmrs.TestOrder");
		return orderType;
	}
}
