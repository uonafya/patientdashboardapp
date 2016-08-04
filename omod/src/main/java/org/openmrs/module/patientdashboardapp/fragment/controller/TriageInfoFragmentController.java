package org.openmrs.module.patientdashboardapp.fragment.controller;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.TriagePatientData;
import org.openmrs.module.patientdashboardapp.api.TriageService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

public class TriageInfoFragmentController {
	public void controller(
			FragmentConfiguration config,
			FragmentModel model,
			UiUtils uiutils
			) {
		config.require("patientId");
		config.require("queueId");
		config.require("opdId");
		
		Integer patientId = Integer.valueOf(config.get("patientId").toString());
		Integer queueId = Integer.valueOf(config.get("queueId").toString());
		
		Patient p = Context.getPatientService().getPatient(patientId);
		
		OpdPatientQueue opdPatientQueue = Context.getService(PatientQueueService.class).getOpdPatientQueueById(queueId);
			
		model.addAttribute("triageInfo", getTriageId(p, uiutils));
		model.addAttribute("triage", opdPatientQueue.getTriageDataId());
		model.addAttribute("patient", Context.getPatientService().getPatient(patientId));
	}
	
	public List <SimpleObject> getTriageId(
			@RequestParam("patientId") Patient patientId,UiUtils ui){
		List<TriagePatientData> triage = Context.getService(TriageService.class).getPatientTriageData(patientId);
		Collections.sort(triage, new Comparator<TriagePatientData>() {
			@Override
			public int compare(TriagePatientData prevEntry, TriagePatientData newEntry) {
				return newEntry.getCreatedOn().compareTo(prevEntry.getCreatedOn()) ;
			}
		});
		return  SimpleObject.fromCollection(triage, ui, "id" , "createdOn");
		
	}	
	public SimpleObject getTriageSummary(
			@RequestParam("Id")Integer Id ,UiUtils ui){
		TriagePatientData triad = Context.getService(TriageService.class).getPatientTriageData(Id);
		return SimpleObject.fromObject(triad, ui, "temperature" ,"weight" ,"height" ,"BMI" ,"mua" ,"chest" ,"abdominal", "systolic" ,"daistolic", "respiratoryRate" ,"pulsRate" ,"bloodGroup","lastMenstrualDate", "rhesusFactor","pitct", "createdOn", "encounterOpd","oxygenSaturation");
	}
}
