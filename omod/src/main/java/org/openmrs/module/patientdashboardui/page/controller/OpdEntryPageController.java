package org.openmrs.module.patientdashboardui.page.controller;

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
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptName;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.User;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.ConceptService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmissionLog;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.util.ConceptComparator;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class OpdEntryPageController {

	public void get(@RequestParam("patientId") Integer patientId, 
			@RequestParam("opdId") Integer opdId,
			@RequestParam(value = "queueId", required = false) Integer queueId,
			@RequestParam(value = "opdLogId", required = false) Integer opdLogId,
			PageModel model) {

		Concept opdWardConcept = Context.getConceptService().getConceptByName(
				Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_OPDWARD));
		model.addAttribute("listInternalReferral",
				opdWardConcept != null ? new ArrayList<ConceptAnswer>(opdWardConcept.getAnswers()) : null);
		Concept hospitalConcept = Context.getConceptService().getConceptByName(
				Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_HOSPITAL));
		model.addAttribute("listExternalReferral",
				hospitalConcept != null ? new ArrayList<ConceptAnswer>(hospitalConcept.getAnswers()) : null);

		model.addAttribute("patientId", patientId);
		IpdService ipds = Context.getService(IpdService.class);
		model.addAttribute("queueId", queueId);
		model.addAttribute("opdLogId", opdLogId);
		model.addAttribute("admitted", ipds.getAdmittedByPatientId(patientId) != null);
		Concept ipdConcept = Context.getConceptService().getConceptByName(
				Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_IPDWARD));
		model.addAttribute("listIpd",
				ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);

		PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
		InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
		Concept opdConcept = Context.getConceptService().getConcept(opdId);
		List<Concept> diagnosisList = patientDashboardService.listByDepartmentByWard(opdId, DepartmentConcept.TYPES[0]);
		if (CollectionUtils.isNotEmpty(diagnosisList)) {
			Collections.sort(diagnosisList, new ConceptComparator());
		}
		model.addAttribute("diagnosisList", diagnosisList);

		List<Concept> procedures = patientDashboardService.listByDepartmentByWard(opdId, DepartmentConcept.TYPES[1]);
		if (CollectionUtils.isNotEmpty(procedures)) {
			Collections.sort(procedures, new ConceptComparator());
		}
		model.addAttribute("listProcedures", procedures);

		// ghanshyam 1-june-2013 New Requirement #1633 User must be able to send
		// investigation orders from dashboard to billing
		List<Concept> investigations = patientDashboardService.listByDepartmentByWard(opdId,
				DepartmentConcept.TYPES[2]);
		if (CollectionUtils.isNotEmpty(investigations)) {
			Collections.sort(investigations, new ConceptComparator());
		}
		model.addAttribute("listInvestigations", investigations);

		List<Concept> symptomList = patientDashboardService.listByDepartmentByWard(opdId, DepartmentConcept.TYPES[3]);
		if (CollectionUtils.isNotEmpty(symptomList)) {
			Collections.sort(symptomList, new ConceptComparator());
		}
		model.addAttribute("symptomList", symptomList);

		// ghanshyam 12-june-2013 New Requirement #1635 User should be able to
		// send pharmacy orders to issue drugs to a patient from dashboard
		List<Concept> drugFrequencyConcept = inventoryCommonService.getDrugFrequency();
		model.addAttribute("drugFrequencyList", drugFrequencyConcept);

		model.addAttribute("opd", opdConcept);

		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		OpdPatientQueue opdPatientQueue = new OpdPatientQueue();
		if (queueId != null) {
			opdPatientQueue = queueService.getOpdPatientQueueById(queueId);
		}
		if (opdLogId != null) {
			OpdPatientQueueLog opdPatientQueueLog = queueService.getOpdPatientQueueLogById(opdLogId);
			model.addAttribute("opdPatientQueueLog", opdPatientQueueLog);
		} else {
			model.addAttribute("opdPatientQueue", opdPatientQueue);
		}

		String hospitalName = Context.getAdministrationService().getGlobalProperty("hospital.location_user");
		model.addAttribute("hospitalName", hospitalName);

		SimpleDateFormat sdf = new SimpleDateFormat("EEE dd/MM/yyyy kk:mm");
		model.addAttribute("currentDateTime", sdf.format(new Date()));

		List<Obs> diagnosis = queueService.getAllDiagnosis(patientId);
		Set<Concept> diagnosisIdSet = new LinkedHashSet<Concept>();
		Set<ConceptName> diagnosisNameSet = new LinkedHashSet<ConceptName>();

		for (Obs diagnos : diagnosis) {
			diagnosisIdSet.add(diagnos.getValueCoded());
			diagnosisNameSet.add(diagnos.getValueCoded().getName());
		}
		Set<String> diaNameSet = new LinkedHashSet<String>();
		Iterator<ConceptName> itr = diagnosisNameSet.iterator();
		while (itr.hasNext()) {
			diaNameSet.add((itr.next().toString()).replaceAll(",", "@"));
		}

		List<Obs> symptom = queueService.getAllSymptom(patientId);
		Set<Concept> symptomIdSet = new LinkedHashSet<Concept>();
		Set<ConceptName> symptomNameSet = new LinkedHashSet<ConceptName>();
		for (Obs symp : symptom) {
			symptomIdSet.add(symp.getValueCoded());
			symptomNameSet.add(symp.getValueCoded().getName());
		}
		Set<String> symNameSet = new LinkedHashSet<String>();
		Iterator<ConceptName> itr1 = symptomNameSet.iterator();
		while (itr1.hasNext()) {
			symNameSet.add((itr1.next().toString()).replaceAll(",", "@"));
		}

		model.addAttribute("diagnosisIdSet", diagnosisIdSet);
		model.addAttribute("symptomIdSet", symptomIdSet);
		model.addAttribute("diaNameSet", diaNameSet);
		model.addAttribute("symNameSet", symNameSet);
		Patient patient = Context.getPatientService().getPatient(patientId);
		IpdPatientAdmission ipdPatientAdmission = ipds.getIpdPatientAdmissionByPatientId(patient);
		if (ipdPatientAdmission != null) {
			model.addAttribute("ipdPatientAdmission", ipdPatientAdmission.getId());
		}
	}
	
	public void post(@RequestParam("patientId") Integer patientId,
			@RequestParam(value = "opdLogId", required = false) Integer opdLogId,
			@RequestParam(value = "selectedSymptomList", required = false)Integer[] selectedSymptomList,
			@RequestParam(value = "selectedDiagnosisList", required = false)Integer[] selectedDiagnosisList,
			@RequestParam(value = "selectedProcedureList", required = false)Integer[] selectedProcedureList,
			HttpServletRequest request) throws Exception {
		User user = Context.getAuthenticatedUser();
		AdministrationService administrationService = Context.getAdministrationService();
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		PatientService ps = Context.getPatientService();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		IpdService ipdService = Context.getService(IpdService.class);
		ConceptService conceptService = Context.getConceptService();
		
		Date date = new Date();
		Obs obsGroup = null;
		obsGroup = hcs.getObsGroupCurrentDate(patientId);
		
		EncounterType encounterType = Context.getEncounterService().getEncounterType(administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_OPD_ENCOUTNER_TYPE));
		Encounter encounter = new Encounter();
		Location location = new Location(1);
		Patient patient = ps.getPatient(patientId);
		
		if (opdLogId != null) {
			OpdPatientQueueLog opdPatientQueueLog = queueService
					.getOpdPatientQueueLogById(opdLogId);
			IpdPatientAdmissionLog ipdPatientAdmissionLog=ipdService.getIpdPatientAdmissionLog(opdPatientQueueLog);
			encounter = ipdPatientAdmissionLog.getIpdEncounter();
		} else {
			encounter.setPatient(patient);
			encounter.setCreator(user);
			encounter.setProvider(user);
			encounter.setEncounterDatetime(date);
			encounter.setEncounterType(encounterType);
			encounter.setLocation(location);
		}

		//selected symptoms post
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
				obsSymptom.setDateCreated(date);
				obsSymptom.setEncounter(encounter);
				obsSymptom.setPatient(patient);
				encounter.addObs(obsSymptom);
			}
		}

		//selected diagnosis post
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
			obsDiagnosis.setDateCreated(date);
			obsDiagnosis.setEncounter(encounter);
			obsDiagnosis.setPatient(patient);
			encounter.addObs(obsDiagnosis);
		}

		//selected procedures post
		String procedureProperty = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_PROCEDURE);
		if (procedureProperty != null) {
			Concept cProcedure = conceptService.getConceptByName(procedureProperty);
			if (cProcedure == null) {
				throw new Exception("Post for procedure concept null");
			}
			for (Integer pId : selectedProcedureList) {
				Obs obsDiagnosis = new Obs();
				obsDiagnosis.setObsGroup(obsGroup);
				obsDiagnosis.setConcept(pDiagnosis);
				obsDiagnosis.setValueCoded(conceptService.getConcept(pId));
				obsDiagnosis.setCreator(user);
				obsDiagnosis.setDateCreated(date);
				obsDiagnosis.setEncounter(encounter);
				obsDiagnosis.setPatient(patient);
				encounter.addObs(obsDiagnosis);
			}
		}


		//TODO: 

		//create internal/external referrals obs
		//handle dead patients
		
		Concept cOtherInstructions = conceptService.getConceptByName("OTHER INSTRUCTIONS");
		
		// note
		if (StringUtils.isNotBlank(request.getParameter("note"))) {

			Obs obsDiagnosis = new Obs();
			obsDiagnosis.setObsGroup(obsGroup);
			// ghanshyam 8-july-2013 New Requirement #1963 Redesign
			// patientdashboard
			obsDiagnosis.setConcept(cOtherInstructions);
			obsDiagnosis.setValueText(request.getParameter("note"));
			obsDiagnosis.setCreator(user);
			obsDiagnosis.setDateCreated(date);
			obsDiagnosis.setEncounter(encounter);
			obsDiagnosis.setPatient(patient);
			encounter.addObs(obsDiagnosis);
		}

		//dead patients
		// harsh 14/6/2012 setting death date to today's date and dead variable
		// to true when "died" is selected
		if (StringUtils.equalsIgnoreCase(request.getParameter("died"), "died")) {

			ConceptService conceptService = Context.getConceptService();
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
		obsOutcome.setDateCreated(date);
		obsOutcome.setPatient(patient);
		obsOutcome.setEncounter(encounter);
		encounter.addObs(obsOutcome);
		Context.getEncounterService().saveEncounter(encounter);
		
	}

}
