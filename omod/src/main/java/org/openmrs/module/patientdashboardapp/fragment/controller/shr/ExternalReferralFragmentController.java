package org.openmrs.module.patientdashboardapp.fragment.controller.shr;

import org.openmrs.Patient;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

public class ExternalReferralFragmentController {

    public void controller(FragmentModel model, @RequestParam(value = "patientId", required = false) Patient patient){

    }
}
