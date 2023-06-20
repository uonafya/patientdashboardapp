package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
import org.openmrs.module.ehrconfigs.EHRConfigurationConstants;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.fragment.FragmentModel;

public class PrintHeaderFragmentController {

    public void controller(FragmentModel model){
        KenyaEmrService service = Context.getService(KenyaEmrService.class);
        String mfl =service.getDefaultLocationMflCode();
        model.addAttribute("userLocation",service.getDefaultLocation());
        model.addAttribute("mfl",mfl);

        AdministrationService administrationService = Context.getAdministrationService();
        model.addAttribute("countyCode", administrationService.getGlobalProperty(EHRConfigurationConstants.GP_PROPERTY_COUNTY_CODE, ""));
        model.addAttribute("countyName", administrationService.getGlobalProperty(EHRConfigurationConstants.GP_PROPERTY_COUNTY_NAME, ""));
        model.addAttribute("address", administrationService.getGlobalProperty(EHRConfigurationConstants.GP_PROPERTY_COUNTY_ADDRESS, ""));
        model.addAttribute("email", administrationService.getGlobalProperty(EHRConfigurationConstants.GP_PROPERTY_COUNTY_EMAIL, ""));
        model.addAttribute("phone", administrationService.getGlobalProperty(EHRConfigurationConstants.GP_PROPERTY_COUNTY_PHONE, ""));
        model.addAttribute("website", administrationService.getGlobalProperty(EHRConfigurationConstants.GP_PROPERTY_COUNTY_WEBSITE, ""));
    }
}
