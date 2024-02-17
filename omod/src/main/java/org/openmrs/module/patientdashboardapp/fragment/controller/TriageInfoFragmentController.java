package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.TriagePatientData;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

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
		model.addAttribute("patientId", patientId);
	}
	
	public List <SimpleObject> getTriageId(
			@RequestParam("patientId") Patient patientId,UiUtils ui){
		List<TriagePatientData> triage = Context.getService(PatientQueueService.class).getPatientTriageData(patientId);
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
		TriagePatientData triad = Context.getService(PatientQueueService.class).getPatientTriageData(Id);
		return SimpleObject.fromObject(triad, ui, "temperature" ,"weight" ,"height" ,"BMI" ,"mua" ,"chest" ,"abdominal", "systolic" ,"daistolic", "respiratoryRate" ,"pulsRate" ,"bloodGroup","lastMenstrualDate", "rhesusFactor","pitct", "createdOn", "encounterOpd","oxygenSaturation");
	}

	public void addNewTriageInfo(@RequestParam(value = "patientId", required = false) Patient patient,
								 @RequestParam(value = "temperature", required = false) Double temperature,
								 @RequestParam(value = "daistolicBp", required = false) Integer daistolicBp,
								 @RequestParam(value = "systolicBp", required = false) Integer systolicBp,
								 @RequestParam(value = "respiratoryRate", required = false) Integer respiratoryRate,
								 @RequestParam(value = "pulsRate", required = false) Integer pulsRate,
								 @RequestParam(value = "oxygenSaturation", required = false) Double oxygenSaturation,
								 @RequestParam(value = "weight", required = false) Double weight,
								 @RequestParam(value = "height", required = false) Double height,
								 @RequestParam(value = "mua", required = false) Double mua,
								 @RequestParam(value = "chestCircum", required = false) Double chestCircum,
								 @RequestParam(value = "abdominalCircum", required = false) Double abdominalCircum
								 ) {
		System.out.println("The data captured are as follows>> Temp"+temperature+">>Diastolic"+daistolicBp+">>Systolic"+systolicBp+">>Respiratory"+respiratoryRate+">>Pulse"+pulsRate+">> Oxgyen"+oxygenSaturation+">> Weight"+weight+">>Height"+height+">>"+mua);
		TriagePatientData  triagePatientData = new TriagePatientData();
		triagePatientData.setPatient(patient);
		triagePatientData.setCreatedOn(new Date());
		if(temperature != null){
			triagePatientData.setTemperature(BigDecimal.valueOf(temperature));
		}
		if(daistolicBp != null){
			triagePatientData.setDaistolic(daistolicBp);
		}
		if(systolicBp != null) {
			triagePatientData.setSystolic(systolicBp);
		}
		if(respiratoryRate != null) {
			triagePatientData.setRespiratoryRate(respiratoryRate);
		}
		if(pulsRate != null) {
			triagePatientData.setPulsRate(pulsRate);
		}
		if(oxygenSaturation != null) {
			triagePatientData.setOxygenSaturation(oxygenSaturation);
		}
		if(weight != null) {
			triagePatientData.setWeight(BigDecimal.valueOf(weight));
		}
		if(height != null) {
			triagePatientData.setHeight(BigDecimal.valueOf(height));
		}
		if(mua != null) {
			triagePatientData.setMua(BigDecimal.valueOf(mua));
		}
		if(chestCircum != null) {
			triagePatientData.setChest(BigDecimal.valueOf(chestCircum));
		}
		if(abdominalCircum != null) {
			triagePatientData.setAbdominal(BigDecimal.valueOf(abdominalCircum));
		}
		//Save the object in the triage
			Context.getService(PatientQueueService.class).saveTriagePatientData(triagePatientData);
		//}

	}
}
