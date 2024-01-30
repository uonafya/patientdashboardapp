package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.util.DateUtils;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class ProviderWorkloadFragmentController {

    public void controller(FragmentModel model){}

    public SimpleObject fetchPatientsPerProviderEntry(
            @RequestParam(value = "fromDate", required = false) String fromDate,
            @RequestParam(value = "toDate", required = false) String toDate, UiUtils uiUtils) {
        Date startDate = null;
        Date endDate = null;
        Provider provider = HospitalCoreUtils.getProvider(Context.getAuthenticatedUser().getPerson());
        Set<Patient> patientSet = new HashSet<Patient>();
        int patientSize = 0;
        SimpleObject simpleObject = new SimpleObject();

        if (StringUtils.isNotBlank(fromDate) && StringUtils.isNotBlank(toDate)) {
            startDate = DateUtils.getDateFromString(fromDate, "yyyy-MM-dd");
            endDate = DateUtils.getDateFromString(toDate, "yyyy-MM-dd");
        }
        HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);
        List<Encounter> encounterList = hospitalCoreService.getProviderEncounters(startDate, endDate, provider,
                Arrays.asList(Context.getEncounterService().getEncounterTypeByUuid("ba45c278-f290-11ea-9666-1b3e6e848887")));

        if(!encounterList.isEmpty()) {
            for(Encounter encounter :encounterList) {
                patientSet.add(encounter.getPatient());
            }
        }
        if(patientSet.size() > 0) {
            patientSize = patientSet.size();
        }
        simpleObject.put("size", patientSize);
        return simpleObject;
    }
}
