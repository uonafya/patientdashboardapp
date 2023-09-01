package org.openmrs.module.patientdashboardapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.ProviderService;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.ehrconfigs.metadata.EhrCommonMetadata;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.model.SickOff;
import org.openmrs.module.hospitalcore.model.SickOffSimplifier;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.module.patientdashboardapp.utils.Utils;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Date;

@AppPage("patientqueueapp.opdqueue")
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
        PersonAttributeType paymentSubCategory = Context.getPersonService().getPersonAttributeTypeByUuid("972a32aa-6159-11eb-bc2d-9785fed39154");
        model.addAttribute("patientId", patientId);
        model.addAttribute("opdId", opdId);
        model.addAttribute("queueId", queueId);
        model.addAttribute("opdLogId", opdLogId);
        model.addAttribute("patientIdentifier",patient.getPatientIdentifier());
        model.addAttribute("category",patient.getAttribute(paymentCategory));
        model.addAttribute("subCategory",patient.getAttribute(paymentSubCategory));
        model.addAttribute("address",patient.getPersonAddress());
        model.addAttribute("visitStatus",visitStatus);
        PatientIdentifier opdNumber = patient.getPatientIdentifier(Context.getPatientService()
                .getPatientIdentifierTypeByUuid(EhrCommonMetadata._EhrIdenifiers.OPD_NUMBER));
        model.addAttribute("opdNumber",opdNumber);

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
        model.addAttribute("patientId", patient.getPatientId());

        return null;
    }
}