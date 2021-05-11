package org.openmrs.module.patientdashboardapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptNumeric;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.PersonAttributeType;
import org.openmrs.User;
import org.openmrs.Visit;
import org.openmrs.api.VisitService;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
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
import org.openmrs.ui.framework.page.PageRequest;
import org.openmrs.ui.framework.session.Session;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.openmrs.Obs;

import org.openmrs.module.kenyaemr.api.KenyaEmrService;

public class TriagePageController {

	private final String TEMPERATURE ="5088";
	private final String SYSTOLIC ="5085";
	private final String DIASTOLIC ="5086";
	private final String RESPIRATORY ="5242";
	private final String HEIGHT ="5090";
	private final String WEIGHT ="5089";
	private final String PULSE ="5087";
	private final String BLOODOXYGEN ="5092";
	private final String MUAC ="1343";


	public String get(
			UiSessionContext sessionContext,
			PageModel model,
			PageRequest pageRequest,
			UiUtils ui,
			@RequestParam("patientId") Patient patient,
			@RequestParam("queueId") Integer queueId,
			@RequestParam(value = "opdId", required = false) Integer opdId,
			@RequestParam(value = "returnUrl", required = false) String returnUrl) {
		pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_REDIRECT_URL,ui.thisUrl());

		PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		TriagePatientQueue triagePatientQueue = patientQueueService.getTriagePatientQueueById(queueId);
		if (triagePatientQueue != null && triagePatientQueue.getPatient().equals(patient)) {
			triagePatientQueue.setStatus(Context.getAuthenticatedUser().getGivenName() + " Processing");
			patientQueueService.saveTriagePatientQueue(triagePatientQueue);
		}
		TriagePatientData triagePatientData = getPreviousTriageDetails(queueId, patientQueueService);
		model.addAttribute("vitals", triagePatientData);

		Encounter lastEncounter = patientQueueService.getLastOPDEncounter(patient);
		Date lastVisitDate = null;
		if(lastEncounter!=null) {
			lastVisitDate = lastEncounter.getEncounterDatetime();
		}
		model.addAttribute("lastVisitDate", lastVisitDate);
		PatientMedicalHistory patientMedicalHistory = patientQueueService.getPatientHistoryByPatientId(patient.getPatientId());
		model.addAttribute("patientMedicalHistory", patientMedicalHistory);
		
		PatientDrugHistory patientDrugHistory = patientQueueService.getPatientDrugHistoryByPatientId(patient.getPatientId());
		model.addAttribute("patientDrugHistory", patientDrugHistory);
		
		PatientFamilyHistory patientFamilyHistory = patientQueueService.getPatientFamilyHistoryByPatientId(patient.getPatientId());
		model.addAttribute("patientFamilyHistory", patientFamilyHistory);

		PatientPersonalHistory patientPersonalHistory = patientQueueService.getPatientPersonalHistoryByPatientId(patient.getPatientId());
		model.addAttribute("patientPersonalHistory", patientPersonalHistory);

		model.addAttribute("patient", patient);
		model.addAttribute("queueId", queueId);
		model.addAttribute("opdId", opdId);
		OpdPatientQueue opdPatientQueue = patientQueueService.getOpdPatientQueueById(queueId);
		model.addAttribute("inOpdQueue", opdPatientQueue != null && opdPatientQueue.getPatient().equals(patient));
		model.addAttribute("returnUrl", returnUrl);

		if (opdPatientQueue != null){
			model.addAttribute("visitStatus", opdPatientQueue.getVisitStatus());
		}
		else if (triagePatientQueue != null){
			model.addAttribute("visitStatus", triagePatientQueue.getVisitStatus());
		}
		else {
			model.addAttribute("visitStatus", "Unknown");
		}

		Concept opdWardConcept = Context.getConceptService().getConceptByName("OPD WARD");

		List<ConceptAnswer> oList = (opdWardConcept != null ? new ArrayList<ConceptAnswer>(opdWardConcept.getAnswers()) : null);
		if (CollectionUtils.isNotEmpty(oList)) {
			Collections.sort(oList, new ConceptAnswerComparator());
		}
		model.addAttribute("listOPD", oList);
		String selectedCategory = "";

		PersonAttributeType paymentCategory = Context.getPersonService().getPersonAttributeTypeByUuid("09cd268a-f0f5-11ea-99a8-b3467ddbf779");

		 model.addAttribute("selectedCategory", patient.getAttribute(paymentCategory));
		return null;
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
			@BindParams ("triagePatientData") TriagePatientData triagePatientData,
			//@BindParams("patientMedicalHistory") PatientMedicalHistory patientMedicalHistory,
			//@BindParams("patientFamilyHistory") PatientFamilyHistory patientFamilyHistory,
			//@BindParams("patientDrugHistory") PatientDrugHistory patientDrugHistory,
            //@BindParams("patientPersonalHistory") PatientPersonalHistory patientPersonalHistory,
            @RequestParam("patientId") Patient patient,
            UiUtils ui,
			Session session) {
		User user = Context.getAuthenticatedUser();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		triagePatientData.setPatient(patient);
		triagePatientData.setCreatedOn(new Date());
        //patientMedicalHistory.setCreatedOn(new Date());
        //patientFamilyHistory.setCreatedOn(new Date());
        //patientDrugHistory.setCreatedOn(new Date());
        //patientPersonalHistory.setCreatedOn(new Date());
		triagePatientData = queueService.saveTriagePatientData(triagePatientData);
        //PatientMedicalHistorySaveHandler.save(patientMedicalHistory,patient.getId());
		//PatientFamilyHistorySaveHandler.save(patientFamilyHistory,patient.getId());
		//PatientDrugHistorySaveHandler.save(patientDrugHistory,patient.getId());
        //PatientPersonalHistorySaveHandler.save(patientPersonalHistory,patient.getId());

		TriagePatientQueue queue = queueService.getTriagePatientQueueById(queueId);
		String triageEncounterType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_TRIAGE_ENCOUTNER_TYPE);
		EncounterType encounterType = Context.getEncounterService().getEncounterType(triageEncounterType);
		Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();
		if (queue != null && queue.getPatient().getId().equals(patient.getId())) {
			Encounter encounter = new Encounter();
			Date date = new Date();
			encounter.setPatient(queue.getPatient());
			encounter.setCreator(user);
			encounter.setEncounterDatetime(date);
			encounter.setEncounterType(encounterType);
			encounter.setLocation(location);
			encounter.setProvider(user);
			Context.getEncounterService().saveEncounter(encounter);	

			if(triagePatientData.getTemperature()!=null){addObs(encounter,TEMPERATURE,triagePatientData.getTemperature().doubleValue());};
			if(triagePatientData.getSystolic()!=null){addObs(encounter,SYSTOLIC,triagePatientData.getSystolic().doubleValue());}
			if(triagePatientData.getDaistolic()!=null){addObs(encounter,DIASTOLIC,triagePatientData.getDaistolic().doubleValue());}
			if(triagePatientData.getRespiratoryRate()!=null){addObs(encounter,RESPIRATORY,triagePatientData.getRespiratoryRate().doubleValue());}
			if(triagePatientData.getHeight()!=null){addObs(encounter,HEIGHT,triagePatientData.getHeight().doubleValue());}
			if(triagePatientData.getWeight()!=null){addObs(encounter,WEIGHT,triagePatientData.getWeight().doubleValue());}
			if(triagePatientData.getPulsRate()!=null){addObs(encounter,PULSE,triagePatientData.getPulsRate().doubleValue());}	
			if(triagePatientData.getOxygenSaturation()!=null){addObs(encounter,BLOODOXYGEN,triagePatientData.getOxygenSaturation().doubleValue());}	
			if(triagePatientData.getMua()!=null){addObs(encounter,MUAC,triagePatientData.getMua().doubleValue());	}
			

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
			try {
				encounter.setPatient(opdPatientQueue.getPatient());
			}
			catch(Exception ex){
				// Handle the error when empty.
				Map<String,Object> params = new HashMap<String, Object>();
				params.put("app", "patientdashboardapp.triage");
				returnUrl = ui.pageLink("patientqueueapp", "triageQueue", params);
				return "redirect:" + returnUrl;
			}
			encounter.setCreator(user);
			encounter.setEncounterDatetime(date);
			encounter.setEncounterType(encounterType);
			encounter.setLocation(location);
			encounter.setProvider(user);
			encounter.setVisit(getLastVisitForPatient(patient));
			Context.getEncounterService().saveEncounter(encounter);
			opdPatientQueue.setTriageDataId(triagePatientData);
			Context.getService(PatientQueueService.class).saveOpdPatientQueue(opdPatientQueue);

			if(triagePatientData.getTemperature()!=null){addObs(encounter,TEMPERATURE,triagePatientData.getTemperature().doubleValue());};
			if(triagePatientData.getSystolic()!=null){addObs(encounter,SYSTOLIC,triagePatientData.getSystolic().doubleValue());}
			if(triagePatientData.getDaistolic()!=null){addObs(encounter,DIASTOLIC,triagePatientData.getDaistolic().doubleValue());}
			if(triagePatientData.getRespiratoryRate()!=null){addObs(encounter,RESPIRATORY,triagePatientData.getRespiratoryRate().doubleValue());}
			if(triagePatientData.getHeight()!=null){addObs(encounter,HEIGHT,triagePatientData.getHeight().doubleValue());}
			if(triagePatientData.getWeight()!=null){addObs(encounter,WEIGHT,triagePatientData.getWeight().doubleValue());}
			if(triagePatientData.getPulsRate()!=null){addObs(encounter,PULSE,triagePatientData.getPulsRate().doubleValue());}	
			if(triagePatientData.getOxygenSaturation()!=null){addObs(encounter,BLOODOXYGEN, triagePatientData.getOxygenSaturation());}
			if(triagePatientData.getMua()!=null){addObs(encounter,MUAC,triagePatientData.getMua().doubleValue());	}
		
		}
		
		if (StringUtils.isBlank(returnUrl)) {
			Map<String,Object> params = new HashMap<String, Object>();
			params.put("app", "patientdashboardapp.triage");
			returnUrl = ui.pageLink("patientqueueapp", "triageQueue", params);
		}
		return "redirect:" + returnUrl;
	}
	public void addObs(Encounter encounter, String conceptGot, Double valueVital) {
        Obs obsTriage = new Obs();
		Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();
		obsTriage.setObsDatetime(new Date());
		obsTriage.setValueNumeric(valueVital);
		obsTriage.setConcept(Context.getConceptService().getConcept(conceptGot));
        obsTriage.setCreator(encounter.getCreator());
		obsTriage.setLocation(encounter.getLocation());
        obsTriage.setDateCreated(encounter.getDateCreated());
        obsTriage.setPerson(encounter.getPatient());
        encounter.addObs(obsTriage);
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
	private Visit getLastVisitForPatient(Patient patient) {
		VisitService visitService = Context.getVisitService();
		return visitService.getActiveVisitsByPatient(patient).get(visitService.getActiveVisitsByPatient(patient).size() - 1);
	}
}
