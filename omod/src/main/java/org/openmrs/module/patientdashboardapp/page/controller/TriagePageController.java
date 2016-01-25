package org.openmrs.module.patientdashboardapp.page.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.User;
import org.openmrs.api.EncounterService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.model.PatientDrugHistory;
import org.openmrs.module.hospitalcore.model.PatientFamilyHistory;
import org.openmrs.module.hospitalcore.model.PatientMedicalHistory;
import org.openmrs.module.hospitalcore.model.PatientPersonalHistory;
import org.openmrs.module.hospitalcore.model.TriagePatientData;
import org.openmrs.module.hospitalcore.model.TriagePatientQueue;
import org.openmrs.module.hospitalcore.model.TriagePatientQueueLog;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.ui.framework.annotation.BindParams;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.session.Session;
import org.springframework.web.bind.annotation.RequestParam;

public class TriagePageController {
	public void get(
			@RequestParam("patientId") Patient patient,
			@RequestParam(value = "opdId", required = false) Integer opdId,
			@RequestParam("queueId") Integer queueId,
			PageModel model) {
		PatientQueueService pqs = Context.getService(PatientQueueService.class);
		IpdService ipdService = Context.getService(IpdService.class);
		TriagePatientQueue triagePatientQueue = pqs.getTriagePatientQueueById(queueId);
		Date createdOn = null;
		if (queueId != null) {
			createdOn = triagePatientQueue.getCreatedOn();
		}

		Encounter encounter;
		EncounterService es = Context.getEncounterService();
		List<Encounter> listEncounter = es.getEncounters(patient, null, createdOn, createdOn, null, getEncounterTypes(), null, null, null, false);
		if (1 == listEncounter.size()) {
			encounter = listEncounter.get(0);
		} else {
			HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
			encounter = hcs.getLastVisitEncounter(patient, getEncounterTypes());
		}

		Concept referredTypeConcept = Context.getConceptService().getConcept("REASON FOR REFERRAL");
		Concept temporaryCategoryConcept = Context.getConceptService().getConcept("MEDICO LEGAL CASE");

		List<Obs> listObsTemporaryCategories = new ArrayList<Obs>();
		Obs referral = null;

		Set<Obs> setObs = encounter.getAllObs();
		Iterator<Obs> obs = setObs.iterator();
		Obs o;
		while (obs.hasNext()) {
			o = obs.next();
			if (temporaryCategoryConcept.getId().equals(o.getConcept().getId()))
				listObsTemporaryCategories.add(o); 
												
			if (referredTypeConcept.getId().equals(o.getConcept().getId()))
				referral = o; 
								
		}
		
		PatientMedicalHistory pmh = pqs.getPatientHistoryByPatientId(triagePatientQueue.getPatient().getPatientId());
		
		if(pmh !=null) {
			model.addAttribute("patientMedicalHistory", pmh);
		}
		
		PatientDrugHistory pdh = pqs.getPatientDrugHistoryByPatientId(triagePatientQueue.getPatient().getPatientId());
		if(pdh != null) {
			model.addAttribute("patientDrugHistory", pdh);
		}
		
		PatientFamilyHistory patientFamilyHistory = pqs.getPatientFamilyHistoryByPatientId(triagePatientQueue.getPatient().getPatientId());
		if(patientFamilyHistory != null) {
			model.addAttribute("familyHistory", patientFamilyHistory);
		}

		PatientPersonalHistory patientPersonalHistory = pqs.getPatientPersonalHistoryByPatientId(triagePatientQueue.getPatient().getPatientId());
		if(patientPersonalHistory != null) {
			model.addAttribute("personalHistory", patientPersonalHistory);
		}
		
		Date birthday = patient.getBirthdate();

		model.addAttribute("observation", listObsTemporaryCategories);
		model.addAttribute("patient", patient);
		model.addAttribute("patientCategory", PatientUtils.getPatientCategory(patient));

		model.addAttribute("queueId", queueId);
		model.addAttribute("age", PatientUtils.estimateAge(birthday));
		model.addAttribute("ageCategory", calcAgeClass(patient.getAge()));
		model.addAttribute("opdId", opdId);

		if (null != referral) {
			model.addAttribute("referredType", referral.getValueCoded().getName());
		}

		model.addAttribute("visitStatus",triagePatientQueue.getVisitStatus());

		IpdPatientAdmitted admitted = ipdService.getAdmittedByPatientId(patient.getPatientId());

		if (admitted != null) {
			model.addAttribute("admittedStatus", "Admitted");
		}

		Concept opdWardConcept = Context.getConceptService().getConceptByName("OPD WARD");
		List<ConceptAnswer> oList = (opdWardConcept != null ? new ArrayList<ConceptAnswer>(opdWardConcept.getAnswers()) : null);
		if (CollectionUtils.isNotEmpty(oList)) {
			Collections.sort(oList, new ConceptAnswerComparator());
		}
		model.addAttribute("listOPD", oList);
		
		Encounter enc = pqs.getLastOPDEncounter(patient);
		OpdPatientQueueLog opdPatientQueueLog = pqs.getOpdPatientQueueLogByEncounter(enc);
		model.addAttribute("opdPatientQueueLog", opdPatientQueueLog);
		Obs ob = pqs.getObservationByPersonConceptAndEncounter(Context.getPersonService().getPerson(patient.getPatientId()),Context.getConceptService().getConcept("VISIT OUTCOME"),enc);
		model.addAttribute("ob", ob);
		
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		List<PersonAttribute> pas = hcs.getPersonAttributes(patient.getPatientId());
		 for (PersonAttribute pa : pas) {
			 PersonAttributeType attributeType = pa.getAttributeType(); 
			 if(attributeType.getPersonAttributeTypeId()==14){
				 model.addAttribute("selectedCategory",pa.getValue()); 
			 }
		 }
	}

	private List<EncounterType> getEncounterTypes() {
		List<EncounterType> types = new ArrayList<EncounterType>();

		EncounterType reginit = Context.getEncounterService().getEncounterType(
				"REGINITIAL");
		types.add(reginit);
		EncounterType regrevisit = Context.getEncounterService()
				.getEncounterType("REGREVISIT");
		types.add(regrevisit);
		EncounterType labencounter = Context.getEncounterService()
				.getEncounterType("LABENCOUNTER");
		types.add(labencounter);
		EncounterType radiologyencounter = Context.getEncounterService()
				.getEncounterType("RADIOLOGYENCOUNTER");
		types.add(radiologyencounter);
		EncounterType opdencounter = Context.getEncounterService()
				.getEncounterType("OPDENCOUNTER");
		types.add(opdencounter);
		EncounterType ipdencounter = Context.getEncounterService()
				.getEncounterType("IPDENCOUNTER");
		types.add(ipdencounter);
		return types;
	}

	private String calcAgeClass(int patientAge) {
		if (patientAge >= 0 && patientAge <= 12)
			return "Child";
		else if (patientAge > 12 && patientAge <= 19)
			return "Adolescent";
		else if (patientAge > 19 && patientAge <= 59)
			return "Adult";
		else
			return "Senior Citizen";
	}
	
	public void post(
			@RequestParam("queueId") Integer queueId,
			@RequestParam("opdId")Integer opdId,
			@BindParams TriagePatientData triagePatientData, 
			Session session) {
		User user = Context.getAuthenticatedUser();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		TriagePatientQueue queue = queueService.getTriagePatientQueueById(queueId);
		String triageEncounterType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_TRIAGE_ENCOUTNER_TYPE);
		EncounterType encounterType = Context.getEncounterService().getEncounterType(triageEncounterType);
		Encounter encounter = new Encounter();
		Date date = new Date();
		encounter.setPatient(queue.getPatient());
		encounter.setCreator(user);
		encounter.setEncounterDatetime(date);
		encounter.setEncounterType(encounterType);
		encounter.setLocation(session.getLocation());
		Context.getEncounterService().saveEncounter(encounter);		

		TriagePatientQueueLog triagePatientLog = logTriagePatient(queueService, queue, encounter);

		boolean visitStatus=false;
		if(triagePatientLog.getVisitStatus().equalsIgnoreCase("REVISIT")) {
			visitStatus=true;
		} else {
			visitStatus=false;
		}
		sendPatientToOPDQueue(triagePatientLog.getPatient(), Context.getConceptService().getConcept(opdId), triagePatientData, visitStatus, triagePatientLog.getCategory());
	}

	private TriagePatientQueueLog logTriagePatient(PatientQueueService queueService,
			TriagePatientQueue queue, Encounter encounter) {
		TriagePatientQueueLog queueLog = new TriagePatientQueueLog();
		queueLog.setTriageConcept(queue.getTriageConcept());
		queueLog.setTriageConceptName(queue.getTriageConceptName());
		queueLog.setPatient(queue.getPatient());
		queueLog.setCreatedOn(queue.getCreatedOn());
		queueLog.setPatientIdentifier(queue.getPatientIdentifier());
		queueLog.setPatientName(queue.getPatientName());
		queueLog.setReferralConcept(queue.getReferralConcept());
		queueLog.setReferralConceptName(queue.getReferralConceptName());
		queueLog.setSex(queue.getSex());
		queueLog.setUser(Context.getAuthenticatedUser());
		queueLog.setStatus("Processed");
		queueLog.setBirthDate(queue.getBirthDate());
		queueLog.setEncounter(encounter);
		queueLog.setCategory(queue.getCategory());
		queueLog.setVisitStatus(queue.getVisitStatus());
		
		queueService.deleteTriagePatientQueue(queue);
		return queueService.saveTriagePatientQueueLog(queueLog);
	}
	
	public static void sendPatientToOPDQueue(Patient patient, Concept selectedOPDConcept, TriagePatientData triagePatientData, boolean revisit, String selectedCategory) {
		Concept visitStatus = null;
		if (!revisit) {
			visitStatus = Context.getConceptService().getConcept("NEW PATIENT");
		} else {
			visitStatus = Context.getConceptService().getConcept("REVISIT");
		}
		
		OpdPatientQueue queue = Context.getService(PatientQueueService.class).getOpdPatientQueue(patient.getPatientIdentifier().getIdentifier(), selectedOPDConcept.getConceptId());
		if (queue == null) {
			queue = new OpdPatientQueue();
			queue.setUser(Context.getAuthenticatedUser());
			queue.setPatient(patient);
			queue.setCreatedOn(new Date());
			queue.setBirthDate(patient.getBirthdate());
			queue.setPatientIdentifier(patient.getPatientIdentifier().getIdentifier());
			queue.setOpdConcept(selectedOPDConcept);
			queue.setOpdConceptName(selectedOPDConcept.getName().getName());
			if( patient.getMiddleName() != null){
				queue.setPatientName(patient.getGivenName() + " " + patient.getFamilyName() + " " + patient.getMiddleName().replace(",", " "));
			} else {
				queue.setPatientName(patient.getGivenName()+ " " + patient.getFamilyName());
			}
			queue.setSex(patient.getGender());
			queue.setTriageDataId(triagePatientData);
			queue.setCategory(selectedCategory);
			queue.setVisitStatus(visitStatus.getName().getName());
			PatientQueueService queueService = Context.getService(PatientQueueService.class);
			queueService.saveOpdPatientQueue(queue);
			
		}
		
	}
}
