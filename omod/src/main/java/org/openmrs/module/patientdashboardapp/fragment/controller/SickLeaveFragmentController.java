package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.Patient;
import org.openmrs.api.ProviderService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.model.SickOff;
import org.openmrs.module.hospitalcore.model.SickOffSimplifier;
import org.openmrs.module.patientdashboardapp.utils.Utils;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

public class SickLeaveFragmentController {

    public void controller(FragmentModel model, @RequestParam(value = "patientId", required = false) Patient patient){
        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
        ProviderService providerService = Context.getProviderService();
        SickOffSimplifier sickOffSimplifier;
        List<SickOffSimplifier> patientSearchList = new ArrayList<SickOffSimplifier>();
        for (SickOff sickOff : hcs.getPatientSickOffs(patient, null, null)) {
            sickOffSimplifier = new SickOffSimplifier();
            sickOffSimplifier.setSickOffId(sickOff.getSickOffId());
            sickOffSimplifier.setNotes(sickOff.getClinicianNotes());
            sickOffSimplifier.setUser(sickOff.getCreator().getGivenName() + " " + sickOff.getCreator().getFamilyName());
            sickOffSimplifier.setProvider(sickOff.getProvider().getName());
            sickOffSimplifier.setPatientName(sickOff.getPatient().getGivenName() + " "
                    + sickOff.getPatient().getFamilyName());
            sickOffSimplifier.setPatientIdentifier(sickOff.getPatient().getActiveIdentifiers().get(0).getIdentifier());
            sickOffSimplifier.setSickOffStartDate(Utils.getDateAsString(sickOff.getSickOffStartDate(), "yyyy-MM-dd"));
            sickOffSimplifier.setSickOffEndDate(Utils.getDateAsString(sickOff.getSickOffEndDate(), "yyyy-MM-dd"));
            sickOffSimplifier.setCreatedOn(Utils.getDateAsString(sickOff.getCreatedOn(), "yyyy-MM-dd"));

            patientSearchList.add(sickOffSimplifier);
        }
        model.addAttribute("sickOffs", patientSearchList);
        model.addAttribute("providerList", providerService.getAllProviders());
    }
}
