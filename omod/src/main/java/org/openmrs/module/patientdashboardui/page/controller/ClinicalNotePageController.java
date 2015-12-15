package org.openmrs.module.patientdashboardui.page.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.ConceptService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.ConceptComparator;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.patientdashboardui.model.Note;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

public class ClinicalNotePageController {

	public void get(@RequestParam("patientId") Integer patientId, 
			@RequestParam("opdId") Integer opdId,
			@RequestParam(value = "queueId", required = false) Integer queueId,
			@RequestParam(value = "opdLogId", required = false) Integer opdLogId,
			PageModel model) {
		
		model.addAttribute("patientId", patientId);
		model.addAttribute("opdId", opdId);
		model.addAttribute("queueId", opdId);
		model.addAttribute("opdLogId", opdLogId);
		
	}
	
	public String post(@RequestParam("patientId") Integer patientId,
			@RequestParam(value = "opdLogId", required = false) Integer opdLogId,
			@RequestParam(value = "selectedSymptomList", required = false)Integer[] selectedSymptomList,
			@RequestParam(value = "selectedDiagnosisList", required = false)Integer[] selectedDiagnosisList,
			@RequestParam(value = "selectedProcedureList", required = false)Integer[] selectedProcedureList,
			HttpServletRequest request, UiUtils ui) throws Exception {
		User user = Context.getAuthenticatedUser();
		AdministrationService administrationService = Context.getAdministrationService();
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		PatientService ps = Context.getPatientService();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		IpdService ipdService = Context.getService(IpdService.class);
		ConceptService conceptService = Context.getConceptService();
		
		Obs obsGroup = null;
		Date date = new Date();
		obsGroup = hcs.getObsGroupCurrentDate(patientId);
		Patient patient = ps.getPatient(patientId);
		Encounter encounter = getEncounter(opdLogId, patient);

		//selected procedures post
		if (selectedProcedureList != null) {
			String procedureProperty = administrationService.getGlobalProperty(PatientDashboardConstants.CONCEPT_CLASS_NAME_PROCEDURE);
			if (procedureProperty != null) {
				Concept cProcedure = conceptService.getConceptByName(procedureProperty);
				if (cProcedure == null) {
					throw new Exception("Post for procedure concept null");
				}
				for (Integer pId : selectedProcedureList) {
					Obs obsDiagnosis = new Obs();
					obsDiagnosis.setObsGroup(obsGroup);
					obsDiagnosis.setConcept(cProcedure);
					obsDiagnosis.setValueCoded(conceptService.getConcept(pId));
					obsDiagnosis.setCreator(user);
					obsDiagnosis.setDateCreated(date);
					obsDiagnosis.setEncounter(encounter);
					obsDiagnosis.setPatient(patient);
					encounter.addObs(obsDiagnosis);
				}
			}
		}

		handleSymptoms(selectedSymptomList, obsGroup, patient, encounter);
		
		handleDiagnosis(selectedDiagnosisList, request, obsGroup, patient, encounter);
		//TODO: 

		//create internal/external referrals obs
		//handle dead patients
		//dead patients
		// harsh 14/6/2012 setting death date to today's date and dead variable
		// to true when "died" is selected
		PatientSearch patientSearch = hcs.getPatient(patientId);

		if (StringUtils.equalsIgnoreCase(request.getParameter("died"), "died")) {

				conceptService = Context.getConceptService();
				Concept causeOfDeath = conceptService.getConceptByName("NONE");

				patient.setDead(true);
				patient.setDeathDate(new Date());
				patient.setCauseOfDeath(causeOfDeath);
				ps.savePatient(patient);
				patientSearch.setDead(true);
				hcs.savePatientSearch(patientSearch);
		}


		GlobalProperty externalReferral = administrationService
				.getGlobalPropertyObject(PatientDashboardConstants.PROPERTY_EXTERNAL_REFERRAL);

		// external referral
		if (StringUtils.isNotBlank(request.getParameter("externalReferral"))) {
			Concept cExternalReferral = conceptService
					.getConceptByName(externalReferral.getPropertyValue());
			if (cExternalReferral == null) {
				throw new Exception("ExternalReferral concept null");
			}
			Obs obsExternalReferral = new Obs();
			obsExternalReferral.setObsGroup(obsGroup);
			obsExternalReferral.setConcept(cExternalReferral);
			obsExternalReferral.setValueCoded(conceptService.getConcept(request.getParameter("externalReferral")));
			obsExternalReferral.setCreator(user);
			obsExternalReferral.setDateCreated(date);
			obsExternalReferral.setEncounter(encounter);
			obsExternalReferral.setPatient(patient);
			encounter.addObs(obsExternalReferral);
		}



		Concept illnessHistory = conceptService.getConceptByName("History of Present Illness");

		// illness history
		if (StringUtils.isNotBlank(request.getParameter("note"))) {

			Obs obsDiagnosis = new Obs();
			obsDiagnosis.setObsGroup(obsGroup);
			obsDiagnosis.setConcept(illnessHistory);
			obsDiagnosis.setValueText(request.getParameter("note"));
			obsDiagnosis.setCreator(user);
			obsDiagnosis.setDateCreated(date);
			obsDiagnosis.setEncounter(encounter);
			obsDiagnosis.setPatient(patient);
			encounter.addObs(obsDiagnosis);
		}
		
		handleOtherInstructions(request, obsGroup, patient, encounter);
		
		handleOutcome(request, obsGroup, patient, encounter);
		
		Context.getEncounterService().saveEncounter(encounter);
		
		return "redirect:" + ui.pageLink("patientqueueui", "chooseOpd");
		
	}

	private void handleOtherInstructions(HttpServletRequest request, Obs obsGroup, Patient patient, Encounter encounter) {
		ConceptService conceptService = Context.getConceptService();
		User user = Context.getAuthenticatedUser();
		Concept cOtherInstructions = conceptService.getConceptByName("OTHER INSTRUCTIONS");
		
		// note
		if (StringUtils.isNotBlank(request.getParameter("note"))) {

			Obs obsOtherInstructions = new Obs();
			obsOtherInstructions.setObsGroup(obsGroup);
			// ghanshyam 8-july-2013 New Requirement #1963 Redesign
			// patientdashboard
			obsOtherInstructions.setConcept(cOtherInstructions);
			obsOtherInstructions.setValueText(request.getParameter("note"));
			obsOtherInstructions.setCreator(user);
			obsOtherInstructions.setDateCreated(new Date());
			obsOtherInstructions.setEncounter(encounter);
			obsOtherInstructions.setPatient(patient);
			encounter.addObs(obsOtherInstructions);
		}
	}

	private void handleOutcome(HttpServletRequest request, Obs obsGroup, Patient patient, Encounter encounter)
					throws Exception, ParseException {
		AdministrationService administrationService = Context.getAdministrationService();
		User user = Context.getAuthenticatedUser();
		ConceptService conceptService = Context.getConceptService();
		Concept cOutcome = conceptService.getConceptByName(administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_VISIT_OUTCOME));
		if (cOutcome == null) {
			throw new Exception("Visit Outcome concept =  null");
		}
		Obs obsOutcome = new Obs();
		obsOutcome.setObsGroup(obsGroup);
		obsOutcome.setConcept(cOutcome);
		obsOutcome.setValueText(request.getParameter("radio_f"));
		
		if (StringUtils.equalsIgnoreCase(request.getParameter("radio_f"), "Follow-up")) {
			obsOutcome.setValueDatetime(Context.getDateFormat().parse(request.getParameter("dateFollowUp")));
		}

		if (StringUtils.equalsIgnoreCase(request.getParameter("radio_f"), "admit")) {
			obsOutcome.setValueCoded(conceptService.getConcept(Integer.getInteger(request.getParameter("ipdWard"))));
		}
		
		obsOutcome.setCreator(user);
		obsOutcome.setDateCreated(new Date());
		obsOutcome.setPatient(patient);
		obsOutcome.setEncounter(encounter);
		encounter.addObs(obsOutcome);
	}

	private void handleDiagnosis(Integer[] selectedDiagnosisList, HttpServletRequest request, Obs obsGroup, Patient patient, Encounter encounter) throws Exception {
		User user = Context.getAuthenticatedUser();
		AdministrationService administrationService = Context.getAdministrationService();
		ConceptService conceptService = Context.getConceptService();
		Concept cDiagnosis = conceptService.getConceptByName(administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_PROVISIONAL_DIAGNOSIS));
		Concept cFinalDiagnosis = conceptService.getConcept("FINAL DIAGNOSIS");
		
		if (cDiagnosis == null) {
			throw new Exception("Diagnosis concept not defined");
		}
		if (cFinalDiagnosis == null) {
			throw new Exception("Final Diagnosis concept not defined");
		}
		String selectedDia = request.getParameter("radio_dia");
		for (Integer cId : selectedDiagnosisList) {
			
			Obs obsDiagnosis = new Obs();
			obsDiagnosis.setObsGroup(obsGroup);
			if(selectedDia.equals("prov_dia")){
				obsDiagnosis.setConcept(cDiagnosis);
			}
			else{
				obsDiagnosis.setConcept(cFinalDiagnosis);
			}
			obsDiagnosis.setValueCoded(conceptService.getConcept(cId));
			obsDiagnosis.setCreator(user);
			obsDiagnosis.setDateCreated(new Date());
			obsDiagnosis.setEncounter(encounter);
			obsDiagnosis.setPatient(patient);
			encounter.addObs(obsDiagnosis);
		}
	}

	private void handleSymptoms(Integer[] selectedSymptomList, Obs obsGroup,
			Patient patient, Encounter encounter) throws Exception {
		User user = Context.getAuthenticatedUser();
		AdministrationService administrationService = Context.getAdministrationService();
		ConceptService conceptService = Context.getConceptService();
		String symptomProperty = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_SYMPTOM);
		if (symptomProperty != null) {
			Concept cSymptom = conceptService.getConceptByName(symptomProperty);
			if (cSymptom == null) {
				throw new Exception("Symptom concept not set");
			}
			// symptom
			for (Integer cId : selectedSymptomList) {
				Obs obsSymptom = new Obs();
				obsSymptom.setObsGroup(obsGroup);
				obsSymptom.setConcept(cSymptom);
				obsSymptom.setValueCoded(conceptService.getConcept(cId));
				obsSymptom.setCreator(user);
				obsSymptom.setDateCreated(new Date());
				obsSymptom.setEncounter(encounter);
				obsSymptom.setPatient(patient);
				encounter.addObs(obsSymptom);
			}
		}
	}

	private Encounter getEncounter(Integer opdLogId, Patient patient) {
		AdministrationService administrationService = Context.getAdministrationService();
		EncounterType encounterType = Context.getEncounterService().getEncounterType(administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_OPD_ENCOUTNER_TYPE));
		Encounter encounter = new Encounter();
		Location location = new Location(1);
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		IpdService ipdService = Context.getService(IpdService.class);
		User user = Context.getAuthenticatedUser();
		
		if (opdLogId != null) {
			OpdPatientQueueLog opdPatientQueueLog = queueService
					.getOpdPatientQueueLogById(opdLogId);
			IpdPatientAdmissionLog ipdPatientAdmissionLog=ipdService.getIpdPatientAdmissionLog(opdPatientQueueLog);
			encounter = ipdPatientAdmissionLog.getIpdEncounter();
		} else {
			encounter.setPatient(patient);
			encounter.setCreator(user);
			encounter.setProvider(user);
			encounter.setEncounterDatetime(new Date());
			encounter.setEncounterType(encounterType);
			encounter.setLocation(location);
		}
		return encounter;
	}

}
