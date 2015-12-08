package org.openmrs.module.patientdashboardui.page.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptName;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
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

}
