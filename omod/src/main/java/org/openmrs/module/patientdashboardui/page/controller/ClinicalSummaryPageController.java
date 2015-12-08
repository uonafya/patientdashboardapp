package org.openmrs.module.patientdashboardui.page.controller;

import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestParam;



    /**
     * Created by Francis on 12/7/2015.
     */
    public class ClinicalSummaryPageController {

        public String get(@RequestParam("patientId") Integer patientId, Model model) {

            PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
            String orderLocationId = "1";
            Location location = Context.getLocationService().getLocation(Integer.parseInt(orderLocationId));

            Patient patient = Context.getPatientService().getPatient(patientId);

            String gpOPDEncType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_OPD_ENCOUTNER_TYPE);
            EncounterType labOPDType = Context.getEncounterService().getEncounterType(gpOPDEncType);

            ConceptService conceptService = Context.getConceptService();
            AdministrationService administrationService = Context.getAdministrationService();
            String gpDiagnosis = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_PROVISIONAL_DIAGNOSIS);

            String gpProcedure = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_POST_FOR_PROCEDURE);
            //	Sagar Bele Date:29-12-2012 Add field of visit outcome for Bangladesh requirement #552
            String gpVisitOutcome = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_VISIT_OUTCOME);

            //String gpInternalReferral = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_INTERNAL_REFERRAL);

            Concept conDiagnosis = conceptService.getConcept(gpDiagnosis);

            Concept conProcedure = conceptService.getConcept(gpProcedure);
//		Sagar Bele Date:29-12-2012 Add field of visit outcome for Bangladesh requirement #552
            Concept conOutcome = conceptService.getConcept(gpVisitOutcome);

            List<Encounter> encounters = dashboardService.getEncounter(patient, location, labOPDType, null);

            //  condiagnosis
            //
            // command
            String diagnosis = "";
            String procedure = "";
            String outcome = "";
            List<Clinical> clinicalSummaries = new ArrayList<Clinical>();
            for (Encounter enc : encounters) {
                diagnosis = "";
                String note = "";
                procedure = "";
                outcome = "";
                Clinical clinical = new Clinical();
                for (Obs obs : enc.getAllObs()) {
                    //diagnosis
                    if (obs.getConcept().getConceptId().equals(conDiagnosis.getConceptId())) {
//					obs.getV
                        if (obs.getValueCoded() != null) {
                            diagnosis += obs.getValueCoded().getName() + ", ";
                        }
                        if (StringUtils.isNotBlank(obs.getValueText())) {
                            note = "Note: " + obs.getValueText();
                        }
                        //System.out.println(obs.getva);

                    }
                    //procedure
                    if (obs.getConcept().getConceptId().equals(conProcedure.getConceptId())) {
//					obs.getV
                        if (obs.getValueCoded() != null) {
                            procedure += obs.getValueCoded().getName() + ", ";
                        }
                        if (StringUtils.isNotBlank(obs.getValueText())) {
                            procedure += obs.getValueText() + ", ";
                        }
                    }
//				Sagar Bele Date:29-12-2012 Add field of visit outcome for Bangladesh requirement #552
                    //visit outcome
                    if (obs.getConcept().getConceptId().equals(conOutcome.getConceptId())) {
//					obs.getV
                        if (obs.getValueCoded() != null) {
                            outcome += obs.getValueCoded().getName() + ", ";
                        }
                        if (StringUtils.isNotBlank(obs.getValueText())) {
                            outcome += obs.getValueText();
                        }
                        //System.out.println(obs.getva);

                    }

                }
                diagnosis += note;
                if (StringUtils.endsWith(diagnosis, ", ")) {
                    diagnosis = StringUtils.removeEnd(diagnosis, ", ");
                }
                if (StringUtils.endsWith(procedure, ", ")) {
                    procedure = StringUtils.removeEnd(procedure, ", ");
                }
//			Sagar Bele Date:29-12-2012 Add field of visit outcome for Bangladesh requirement #552
                if (StringUtils.endsWith(outcome, ", ")) {
                    outcome = StringUtils.removeEnd(outcome, ", ");
                }

                //${patient.givenName}&nbsp;&nbsp;${patient.middleName}&nbsp;&nbsp; ${patient.familyName}

                if (enc.getCreator().getPerson().getMiddleName() != null) {
                    if (enc.getCreator().getPerson().getFamilyName() != null) {
                        clinical.setTreatingDoctor(enc.getCreator().getPerson().getGivenName() + " " + enc.getCreator().getPerson().getFamilyName() + " " + enc.getCreator().getPerson().getMiddleName());
                    } else {
                        clinical.setTreatingDoctor(enc.getCreator().getPerson().getGivenName() + " " + enc.getCreator().getPerson().getMiddleName());
                    }
                } else {
                    if (enc.getCreator().getPerson().getFamilyName() != null) {
                        clinical.setTreatingDoctor(enc.getCreator().getPerson().getGivenName() + " " + enc.getCreator().getPerson().getFamilyName());
                    } else {
                        clinical.setTreatingDoctor(enc.getCreator().getPerson().getGivenName());
                    }
                }

                clinical.setDateOfVisit(enc.getDateCreated());
                clinical.setId(enc.getId());
                clinical.setDiagnosis(diagnosis);
                clinical.setProcedures(procedure);
                clinical.setVisitOutcomes(outcome);
                clinicalSummaries.add(clinical);

                // set value to command object
                // add command to list
            }
            ;
            //System.out.println("clinicalSummaries: "+clinicalSummaries);
            model.addAttribute("patient", patient);
            model.addAttribute("clinicalSummaries", clinicalSummaries);
            return "module/patientdashboard/clinicalSummary";
        }

    }
