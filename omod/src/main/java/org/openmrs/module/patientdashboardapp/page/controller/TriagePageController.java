package org.openmrs.module.patientdashboardapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PersonAttributeType;
import org.openmrs.User;
import org.openmrs.Visit;
import org.openmrs.api.VisitService;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.ehrconfigs.utils.EhrConfigsUtils;
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
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.BindParams;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.session.Session;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
			UiUtils ui,
			@RequestParam("patientId") Patient patient,
			@RequestParam("queueId") Integer queueId,
			@RequestParam(value = "opdId", required = false) Integer opdId,
			@RequestParam(value = "returnUrl", required = false) String returnUrl) {

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

		Concept opdWardConcept = Context.getConceptService().getConceptByUuid("03880388-07ce-4961-abe7-0e58f787dd23");

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
            @RequestParam("patientId") Patient patient,
            UiUtils ui,
			Session session) {
		User user = Context.getAuthenticatedUser();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		triagePatientData.setPatient(patient);
		triagePatientData.setCreatedOn(new Date());

		TriagePatientQueue queue = queueService.getTriagePatientQueueById(queueId);
		String triageEncounterType = "2af60550-f291-11ea-b725-9753b5f685ae";
		EncounterType encounterType = Context.getEncounterService().getEncounterTypeByUuid(triageEncounterType);
		Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();
		if (queue != null && queue.getPatient().getId().equals(patient.getId())) {

			Encounter encounter = new Encounter();
			encounter.setPatient(queue.getPatient());
			encounter.setCreator(user);
			encounter.setEncounterDatetime(new Date());
			encounter.setEncounterType(encounterType);
			encounter.setLocation(location);
			encounter.setProvider(EhrConfigsUtils.getDefaultEncounterRole(),EhrConfigsUtils.getProvider(user.getPerson()));
			encounter.setVisit(getLastVisitForPatient(queue.getPatient()));


			if(triagePatientData.getTemperature() != null){
				addObs(encounter,TEMPERATURE,triagePatientData.getTemperature().doubleValue());
			}
			if(triagePatientData.getSystolic() != null){
				addObs(encounter,SYSTOLIC,triagePatientData.getSystolic().doubleValue());
			}
			if(triagePatientData.getDaistolic() != null){
				addObs(encounter,DIASTOLIC,triagePatientData.getDaistolic().doubleValue());
			}
			if(triagePatientData.getRespiratoryRate() != null){
				addObs(encounter,RESPIRATORY,triagePatientData.getRespiratoryRate().doubleValue());
			}
			if(triagePatientData.getHeight() != null){
				addObs(encounter,HEIGHT,triagePatientData.getHeight().doubleValue());
			}
			if(triagePatientData.getWeight() != null){
				addObs(encounter,WEIGHT,triagePatientData.getWeight().doubleValue());
			}
			if(triagePatientData.getPulsRate() != null){
				addObs(encounter,PULSE,triagePatientData.getPulsRate().doubleValue());
			}
			if(triagePatientData.getOxygenSaturation() != null){
				addObs(encounter,BLOODOXYGEN,triagePatientData.getOxygenSaturation().doubleValue());
			}
			if(triagePatientData.getMua() != null){
				addObs(encounter,MUAC,triagePatientData.getMua().doubleValue());
			}

			//save the encounter here with the obs
			Context.getEncounterService().saveEncounter(encounter);
			TriagePatientData triagePatientDataToUse = queueService.saveTriagePatientData(triagePatientData);

			TriagePatientQueueLog triagePatientLog = logTriagePatient(
					queueService, queue, encounter);
			boolean visitStatus = false;
			if (triagePatientLog.getVisitStatus().equalsIgnoreCase("Revisit patient")) {
				visitStatus = true;
			} else {
				visitStatus = false;
			}

			sendPatientToOPDQueue(triagePatientLog.getPatient(), Context
					.getConceptService().getConcept(roomToVisit),
							triagePatientDataToUse, visitStatus,
					triagePatientLog.getCategory());
			//delete the queue here
			queueService.deleteTriagePatientQueue(queue);
		} else {
			OpdPatientQueue opdPatientQueue = Context.getService(PatientQueueService.class).getOpdPatientQueueById(queueId);
			Encounter encounterNew = new Encounter();
			try {
				encounterNew.setPatient(opdPatientQueue.getPatient());
			}
			catch(Exception ex){
				// Handle the error when empty.
				Map<String,Object> params = new HashMap<String, Object>();
				params.put("app", "patientdashboardapp.triage");
				returnUrl = ui.pageLink("patientqueueapp", "triageQueue", params);
				return "redirect:" + returnUrl;
			}
			encounterNew.setCreator(user);
			encounterNew.setEncounterDatetime(new Date());
			encounterNew.setEncounterType(encounterType);
			encounterNew.setLocation(location);
			encounterNew.setProvider(EhrConfigsUtils.getDefaultEncounterRole(),EhrConfigsUtils.getProvider(user.getPerson()));
			encounterNew.setVisit(getLastVisitForPatient(patient));
			Context.getEncounterService().saveEncounter(encounterNew);

			if(triagePatientData.getTemperature()!=null){addObs(encounterNew,TEMPERATURE,triagePatientData.getTemperature().doubleValue());};
			if(triagePatientData.getSystolic()!=null){addObs(encounterNew,SYSTOLIC,triagePatientData.getSystolic().doubleValue());}
			if(triagePatientData.getDaistolic()!=null){addObs(encounterNew,DIASTOLIC,triagePatientData.getDaistolic().doubleValue());}
			if(triagePatientData.getRespiratoryRate()!=null){addObs(encounterNew,RESPIRATORY,triagePatientData.getRespiratoryRate().doubleValue());}
			if(triagePatientData.getHeight()!=null){addObs(encounterNew,HEIGHT,triagePatientData.getHeight().doubleValue());}
			if(triagePatientData.getWeight()!=null){addObs(encounterNew,WEIGHT,triagePatientData.getWeight().doubleValue());}
			if(triagePatientData.getPulsRate()!=null){addObs(encounterNew,PULSE,triagePatientData.getPulsRate().doubleValue());}
			if(triagePatientData.getOxygenSaturation()!=null){addObs(encounterNew,BLOODOXYGEN, triagePatientData.getOxygenSaturation());}
			if(triagePatientData.getMua()!=null){addObs(encounterNew,MUAC,triagePatientData.getMua().doubleValue());	}
			//save the triage data
			queueService.saveTriagePatientData(triagePatientData);
			opdPatientQueue.setTriageDataId(triagePatientData);
			Context.getService(PatientQueueService.class).saveOpdPatientQueue(opdPatientQueue);
		
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
		obsTriage.setObsDatetime(encounter.getEncounterDatetime());
		obsTriage.setValueNumeric(valueVital);
		obsTriage.setConcept(Context.getConceptService().getConcept(conceptGot));
        obsTriage.setCreator(encounter.getCreator());
		obsTriage.setLocation(encounter.getLocation());
        obsTriage.setDateCreated(encounter.getDateCreated());
        obsTriage.setPerson(encounter.getPatient());
		obsTriage.setEncounter(encounter);
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
		queueService.saveTriagePatientQueueLog(queueLog);
		//queueService.deleteTriagePatientQueue(queue);
		return queueService.saveTriagePatientQueueLog(queueLog);
	}
	
	public static void sendPatientToOPDQueue(Patient patient, Concept selectedOPDConcept, TriagePatientData triagePatientData, boolean revisit, String selectedCategory) {
		Concept visitStatus = null;
		if (!revisit) {
			visitStatus = Context.getConceptService().getConceptByUuid("164144AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		} else {
			visitStatus = Context.getConceptService().getConceptByUuid("d5ea1533-7346-4e0b-8626-9bff6cd183b2");
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
		return visitService.getActiveVisitsByPatient(patient).get(0);
	}
}
