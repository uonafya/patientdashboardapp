package org.openmrs.module.patientdashboardapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class MainPageController {

    public void get(@RequestParam("patientId") Integer patientId,
            @RequestParam("opdId") Integer opdId,
            @RequestParam(value = "queueId", required = false) Integer queueId,
            @RequestParam(value = "opdLogId", required = false) Integer opdLogId,
            @RequestParam(value = "visitStatus", required = false) String visitStatus,
            PageModel model) {

        model.addAttribute("patientId", patientId);
        model.addAttribute("opdId", opdId);
        model.addAttribute("queueId", queueId);
        model.addAttribute("opdLogId", opdLogId);
        model.addAttribute("patient",Context.getPatientService().getPatient(patientId));



    }
}