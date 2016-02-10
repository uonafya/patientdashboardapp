package org.openmrs.module.patientdashboardapp.page.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.PatientDrugHistory;
import org.openmrs.module.hospitalcore.model.PatientFamilyHistory;
import org.openmrs.module.hospitalcore.model.PatientMedicalHistory;
import org.openmrs.module.hospitalcore.model.PatientPersonalHistory;
import org.openmrs.module.hospitalcore.model.TriagePatientData;
import org.openmrs.module.hospitalcore.model.TriagePatientQueue;
import org.openmrs.module.hospitalcore.model.TriagePatientQueueLog;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.BindParams;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.session.Session;
import org.springframework.web.bind.annotation.RequestParam;

public class TriagePageController {
	public void get(
			@RequestParam("patientId") Patient patient,
			@RequestParam("queueId") Integer queueId,
			@RequestParam(value = "opdId", required = false) Integer opdId,
			@RequestParam(value = "returnUrl", required = false) String returnUrl,
			PageModel model) {

		PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);
		TriagePatientQueue triagePatientQueue = patientQueueService.getTriagePatientQueueById(queueId);
		if (triagePatientQueue != null) {
			triagePatientQueue.setStatus(Context.getAuthenticatedUser().getGivenName() + " Processing");
			patientQueueService.saveTriagePatientQueue(triagePatientQueue);
		}
		TriagePatientData triagePatientData = getPreviousTriageDetails(queueId, patientQueueService);
		model.addAttribute("vitals", triagePatientData);

		PatientMedicalHistory pmh = patientQueueService.getPatientHistoryByPatientId(patient.getPatientId());
		
		if(pmh !=null) {
			model.addAttribute("patientMedicalHistory", pmh);
		}
		
		PatientDrugHistory pdh = patientQueueService.getPatientDrugHistoryByPatientId(patient.getPatientId());
		if(pdh != null) {
			model.addAttribute("patientDrugHistory", pdh);
		}
		
		PatientFamilyHistory patientFamilyHistory = patientQueueService.getPatientFamilyHistoryByPatientId(patient.getPatientId());
		if(patientFamilyHistory != null) {
			model.addAttribute("familyHistory", patientFamilyHistory);
		}

		PatientPersonalHistory patientPersonalHistory = patientQueueService.getPatientPersonalHistoryByPatientId(patient.getPatientId());
		if(patientPersonalHistory != null) {
			model.addAttribute("personalHistory", patientPersonalHistory);
		}
		

		model.addAttribute("patient", patient);

		model.addAttribute("queueId", queueId);
		model.addAttribute("opdId", opdId);
		OpdPatientQueue opdPatientQueue = patientQueueService.getOpdPatientQueueById(queueId);
		model.addAttribute("inOpdQueue", opdPatientQueue != null && opdPatientQueue.getPatient().equals(triagePatientQueue.getPatient()));
		model.addAttribute("returnUrl", returnUrl);

		Concept opdWardConcept = Context.getConceptService().getConceptByName("OPD WARD");
		List<ConceptAnswer> oList = (opdWardConcept != null ? new ArrayList<ConceptAnswer>(opdWardConcept.getAnswers()) : null);
		if (CollectionUtils.isNotEmpty(oList)) {
			Collections.sort(oList, new ConceptAnswerComparator());
		}
		model.addAttribute("listOPD", oList);
		
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		List<PersonAttribute> pas = hcs.getPersonAttributes(patient.getPatientId());
		 for (PersonAttribute pa : pas) {
			 PersonAttributeType attributeType = pa.getAttributeType(); 
			 if(attributeType.getPersonAttributeTypeId()==14){
				 model.addAttribute("selectedCategory",pa.getValue()); 
			 }
		 }
	}

	private TriagePatientData getPreviousTriageDetails(Integer queueId,
			PatientQueueService patientQueueService) {
		OpdPatientQueue opdPatientQueue = patientQueueService.getOpdPatientQueueById(queueId);
		TriagePatientData triagePatientData = null;
		if (opdPatientQueue != null) {
			triagePatientData = opdPatientQueue.getTriageDataId();
		}
		return triagePatientData;
	}

	public String post(
			@RequestParam("queueId") Integer queueId,
			@RequestParam(value = "roomToVisit", required = false) Integer roomToVisit,
			@RequestParam(value = "returnUrl", required = false) String returnUrl,
			@BindParams TriagePatientData triagePatientData,
			UiUtils ui,
			Session session) {
		User user = Context.getAuthenticatedUser();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		triagePatientData = queueService.saveTriagePatientData(triagePatientData);
		TriagePatientQueue queue = queueService.getTriagePatientQueueById(queueId);
		String triageEncounterType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_TRIAGE_ENCOUTNER_TYPE);
		EncounterType encounterType = Context.getEncounterService().getEncounterType(triageEncounterType);

		if (queue != null) {
			Encounter encounter = new Encounter();
			Date date = new Date();
			encounter.setPatient(queue.getPatient());
			encounter.setCreator(user);
			encounter.setEncounterDatetime(date);
			encounter.setEncounterType(encounterType);
			encounter.setLocation(session.getLocation());
			Context.getEncounterService().saveEncounter(encounter);		
			TriagePatientQueueLog triagePatientLog = logTriagePatient(
					queueService, queue, encounter);
			boolean visitStatus = false;
			if (triagePatientLog.getVisitStatus().equalsIgnoreCase("REVISIT")) {
				visitStatus = true;
			} else {
				visitStatus = false;
			}
			sendPatientToOPDQueue(triagePatientLog.getPatient(), Context
					.getConceptService().getConcept(roomToVisit),
					triagePatientData, visitStatus,
					triagePatientLog.getCategory());
		} else {
			OpdPatientQueue opdPatientQueue = Context.getService(PatientQueueService.class).getOpdPatientQueueById(queueId);
			Encounter encounter = new Encounter();
			Date date = new Date();
			encounter.setPatient(opdPatientQueue.getPatient());
			encounter.setCreator(user);
			encounter.setEncounterDatetime(date);
			encounter.setEncounterType(encounterType);
			encounter.setLocation(session.getLocation());
			Context.getEncounterService().saveEncounter(encounter);
			opdPatientQueue.setTriageDataId(triagePatientData);
			Context.getService(PatientQueueService.class).saveOpdPatientQueue(opdPatientQueue);
		}
		
		if (StringUtils.isBlank(returnUrl)) {
			Map<String,Object> params = new HashMap<String, Object>();
			params.put("app", "patientdashboardapp.triage");
			returnUrl = ui.pageLink("patientqueueui", "queue", params);
		}
		return "redirect:" + returnUrl;
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
