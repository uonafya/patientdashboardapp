package org.openmrs.module.patientdashboardapp.fragment.controller;

import java.util.ArrayList;
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
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.module.patientdashboardapp.model.VisitDetail;
import org.openmrs.module.patientdashboardapp.model.VisitSummary;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

public class VisitSummaryFragmentController {



	public void controller(FragmentConfiguration config,
			FragmentModel model) {
		config.require("patientId");
		Integer patientId = Integer.parseInt(config.get("patientId").toString());
        PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
        Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();
        Patient patient = Context.getPatientService().getPatient(patientId);

        AdministrationService administrationService = Context.getAdministrationService();
        String gpOPDEncType = administrationService.getGlobalProperty(PatientDashboardConstants.PROPERTY_OPD_ENCOUTNER_TYPE);

        EncounterType labOPDType = Context.getEncounterService().getEncounterType(gpOPDEncType);
        List<Encounter> encounters = dashboardService.getEncounter(patient, location, labOPDType, null);
        
        List<VisitSummary> visitSummaries = new ArrayList<VisitSummary>();

        int i=0;
        
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

            i++;

            if (i >=20){
                break;
            }
        }
        model.addAttribute("patient", patient);
        System.out.println("Patient " +patient);
        model.addAttribute("visitSummaries", visitSummaries);
        System.out.println("Visist Summaries........."+visitSummaries);
	}

	public SimpleObject getVisitSummaryDetails(
			@RequestParam("encounterId") Integer encounterId,UiUtils ui) {
	    //System.out.println("The encounter id is ........."+encounterId);
		Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
		VisitDetail visitDetail = VisitDetail.create(encounter);
        System.out.println("The encounter........."+encounter);

		
		SimpleObject detail = SimpleObject.fromObject(visitDetail, ui, "history","diagnosis", "symptoms", "procedures", "investigations","physicalExamination","visitOutcome","internalReferral","externalReferral");
        System.out.println("detail is ...."+detail);
		List<OpdDrugOrder> opdDrugs = Context.getService(PatientDashboardService.class).getOpdDrugOrder(encounter);
		List<SimpleObject> drugs = SimpleObject.fromCollection(opdDrugs, ui, "inventoryDrug.name",
				"inventoryDrug.unit.name", "inventoryDrugFormulation.name", "inventoryDrugFormulation.dozage","dosage", "dosageUnit.name");
        System.out.println("The drug  ........."+drugs);
		return SimpleObject.create("notes", detail, "drugs", drugs);
	}
}
