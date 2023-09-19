package org.openmrs.module.patientdashboardapp.fragment.controller;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
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

        EncounterType labOPDType = Context.getEncounterService().getEncounterTypeByUuid("ba45c278-f290-11ea-9666-1b3e6e848887");
        List<Encounter> encounters = dashboardService.getEncounter(patient, location, labOPDType, null);
        
        List<VisitSummary> visitSummaries = new ArrayList<VisitSummary>();

        int i=0;
        
        for (Encounter enc : encounters) {
            VisitSummary visitSummary = new VisitSummary();
            visitSummary.setVisitDate(enc.getDateCreated());
            visitSummary.setEncounterId(enc.getEncounterId());
            Concept outcomeConcept = Context.getConceptService().getConceptByUuid("160433AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
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
        KenyaEmrService service =Context.getService(KenyaEmrService.class);
        String mfl =service.getDefaultLocationMflCode();
        boolean hasNupi = false;
        PatientIdentifier patientIdentifier = patient.getPatientIdentifier(Context.getPatientService().getPatientIdentifierTypeByUuid("f85081e2-b4be-4e48-b3a4-7994b69bb101"));
        if(patientIdentifier != null) {
            hasNupi = true;
        }

        model.addAttribute("userLocation",service.getDefaultLocation());
        model.addAttribute("mfl",mfl);
        model.addAttribute("patient", patient);
        model.addAttribute("visitSummaries", visitSummaries);
        model.addAttribute("hasNupi", hasNupi);

	}

	public SimpleObject getVisitSummaryDetails(
			@RequestParam("encounterId") Integer encounterId,UiUtils ui) {
		Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
		VisitDetail visitDetail = VisitDetail.create(encounter);

		SimpleObject detail = SimpleObject.fromObject(visitDetail, ui, "providerName","dateOfService", "investigationNotes","history","diseaseOnSetDate","diagnosis", "symptoms", "procedures", "investigations","physicalExamination","visitOutcome","internalReferral","externalReferral","otherInstructions");
		List<OpdDrugOrder> opdDrugs = Context.getService(PatientDashboardService.class).getOpdDrugOrder(encounter);
		List<SimpleObject> drugs = SimpleObject.fromCollection(opdDrugs, ui, "inventoryDrug.name",
				"inventoryDrug.unit.name", "inventoryDrugFormulation.name", "inventoryDrugFormulation.dozage","dosage", "dosageUnit.name");
		return SimpleObject.create("notes", detail, "drugs", drugs);
	}
}
