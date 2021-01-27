package org.openmrs.module.patientdashboardapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Date;

public class MainPageController {

    public String get(UiSessionContext sessionContext,
                    PageModel model,
                    PageRequest pageRequest,
                    UiUtils ui,
                    @RequestParam("patientId") Integer patientId,
                    @RequestParam("opdId") Integer opdId,
                    @RequestParam(value = "queueId", required = false) Integer queueId,
                    @RequestParam(value = "opdLogId", required = false) Integer opdLogId,
                    @RequestParam(value = "visitStatus", required = false) String visitStatus) {
        pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_REDIRECT_URL,ui.thisUrl());
        sessionContext.requireAuthentication();
        Patient patient = Context.getPatientService().getPatient(patientId);
        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
        PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);

        Map<String, String> attributes = PatientUtils.getAttributes(patient);
        Concept category = Context.getConceptService().getConceptByName("Patient Category");
        List<ConceptAnswer> categoryList = (category != null ? new ArrayList<ConceptAnswer>(category.getAnswers()) : null);
        if (CollectionUtils.isNotEmpty(categoryList)) {
            Collections.sort(categoryList, new ConceptAnswerComparator());
        }

        if (patient.getGender().equals("M")){
            model.addAttribute("gender", "MALE");
        }
        else{
            model.addAttribute("gender", "FEMALE");
        }
        PersonAttributeType paymentCategory = Context.getPersonService().getPersonAttributeTypeByUuid("09cd268a-f0f5-11ea-99a8-b3467ddbf779");
        model.addAttribute("patientId", patientId);
        model.addAttribute("opdId", opdId);
        model.addAttribute("queueId", queueId);
        model.addAttribute("opdLogId", opdLogId);
        model.addAttribute("patientIdentifier",patient.getPatientIdentifier());
        model.addAttribute("category",patient.getAttribute(paymentCategory));
        model.addAttribute("address",patient.getPersonAddress());
        model.addAttribute("visitStatus",visitStatus);

        Encounter lastEncounter = patientQueueService.getLastOPDEncounter(patient);
        Date lastVisitDate = null;
        if(lastEncounter!=null) {
            lastVisitDate = lastEncounter.getEncounterDatetime();
        }
        model.addAttribute("previousVisit", lastVisitDate);
        model.addAttribute("date", new Date());

        String status = null;
        if (queueId != null) {
            OpdPatientQueue opdPatientQueue = Context.getService(PatientQueueService.class).getOpdPatientQueueById(queueId);
            if (opdPatientQueue != null) {
                opdPatientQueue.setStatus("Dr. "+Context.getAuthenticatedUser().getGivenName());
                Context.getService(PatientQueueService.class).saveOpdPatientQueue(opdPatientQueue);
                status = opdPatientQueue.getVisitStatus();
            }
            if (status!= null){
                model.addAttribute("patientStatus",status);
            }else{
                model.addAttribute("patientStatus" ,"Unknown");
            }
        }
        return null;
    }
}