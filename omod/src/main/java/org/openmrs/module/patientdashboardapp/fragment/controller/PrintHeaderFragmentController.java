package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.fragment.FragmentModel;

public class PrintHeaderFragmentController {

    public void controller(FragmentModel model){
        KenyaEmrService service = Context.getService(KenyaEmrService.class);
        String mfl =service.getDefaultLocationMflCode();
        model.addAttribute("userLocation",service.getDefaultLocation());
        model.addAttribute("mfl",mfl);
    }
}
