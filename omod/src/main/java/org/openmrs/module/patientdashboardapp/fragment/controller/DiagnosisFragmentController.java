package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.Diagnosis;
import org.openmrs.Patient;
import org.openmrs.api.DiagnosisService;
import org.openmrs.api.context.Context;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public class DiagnosisFragmentController {

    public void controller(FragmentModel model, @RequestParam(value = "patientId", required = false) Patient patient){
        DiagnosisService  diagnosisService = Context.getDiagnosisService();
        List<Diagnosis> diagnosisList = diagnosisService.getDiagnoses(patient, null);

        model.addAttribute("diagnosis", diagnosisList);
    }
}
