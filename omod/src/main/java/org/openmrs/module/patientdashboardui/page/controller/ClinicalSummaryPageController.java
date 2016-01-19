package org.openmrs.module.patientdashboardui.page.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;



    /**
     * Created by Francis on 12/7/2015.
     */
    public class ClinicalSummaryPageController {

        private static final int ORDER_LOCATION_ID = 1;

		public void get(@RequestParam("patientId") Integer patientId, PageModel model) {

            PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
            Location location = Context.getLocationService().getLocation(ORDER_LOCATION_ID);

            Patient patient = Context.getPatientService().getPatient(patientId);

            AdministrationService administrationService = Context.getAdministrationService();
            String gpOPDEncType = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_OPD_ENCOUTNER_TYPE);
            EncounterType labOPDType = Context.getEncounterService().getEncounterType(gpOPDEncType);
            List<Encounter> encounters = dashboardService.getEncounter(patient, location, labOPDType, null);
            
            List<VisitSummary> visitSummaries = new ArrayList<VisitSummary>();
            
            for (Encounter enc : encounters) {
                VisitSummary visitSummary = new VisitSummary();
                visitSummary.setVisitDate(enc.getDateCreated());
                visitSummary.setEncounterId(enc.getEncounterId());
                String outcomeConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_VISIT_OUTCOME);
                Concept outcomeConcept = Context.getConceptService().getConcept(outcomeConceptName);
                for (Obs obs : enc.getAllObs()) {
                    if (obs.getConcept().equals(outcomeConcept)) {
                        visitSummary.setOutcome(obs.getValueText());
                    }
                }
                visitSummaries.add(visitSummary);
            }
            model.addAttribute("patient", patient);
            model.addAttribute("visitSummaries", visitSummaries);
        }

    }
