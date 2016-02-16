package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;

public class TriageInfoFragmentController {
	public void controller(
			FragmentConfiguration config,
			FragmentModel model
			) {
		config.require("patientId");
		config.require("queueId");
		config.require("opdId");
		
		Integer  patientId = Integer.valueOf(config.get("patientId").toString());
		Integer queueId = Integer.valueOf(config.get("queueId").toString());
		OpdPatientQueue opdPatientQueue = Context.getService(PatientQueueService.class).getOpdPatientQueueById(queueId);
		model.addAttribute("triage", opdPatientQueue.getTriageDataId());
		model.addAttribute("patient", Context.getPatientService().getPatient(patientId));
	}
}
