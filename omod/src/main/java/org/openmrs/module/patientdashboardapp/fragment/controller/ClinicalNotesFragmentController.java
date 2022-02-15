package org.openmrs.module.patientdashboardapp.fragment.controller;


import org.apache.commons.lang.StringEscapeUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptSet;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.Option;
import org.openmrs.module.hospitalcore.model.Referral;
import org.openmrs.module.hospitalcore.model.ReferralReasons;
import org.openmrs.module.patientdashboardapp.model.Note;
import org.openmrs.module.patientdashboardapp.model.Outcome;
import org.openmrs.module.patientdashboardapp.model.Procedure;
import org.openmrs.module.patientdashboardapp.model.Qualifier;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 *
 */
public class ClinicalNotesFragmentController {

	public void controller(FragmentConfiguration config, FragmentModel model,
			UiUtils ui) {
		config.require("patientId");
		config.require("opdId");

		Integer patientId = Integer
				.parseInt(config.get("patientId").toString());
		Integer opdId = Integer.parseInt(config.get("opdId").toString());
		Integer queueId = null;
		if (config.containsKey("queueId") && config.get("queueId") != null) {
			queueId = Integer.parseInt(config.get("queueId").toString());
		}
		Integer opdLogId = null;
		if (config.containsKey("opdLogId") && config.get("opdLogId") != null) {
			opdLogId = Integer.parseInt(config.get("opdLogId").toString());
		}
		model.addAttribute("outcomeOptions", SimpleObject.fromCollection(Outcome.getAvailableOutcomes(), ui, "label", "id"));
		model.addAttribute("listOfWards", SimpleObject.fromCollection(Outcome.getInpatientWards(), ui, "label", "id"));
		model.addAttribute("internalReferralSources", SimpleObject.fromCollection(Referral.getInternalReferralOptions(), ui, "label", "id"));
        model.addAttribute("externalReferralSources", SimpleObject.fromCollection(Referral.getExternalReferralOptions(), ui, "label", "id"));
		model.addAttribute("referralReasonsSources", SimpleObject.fromCollection(ReferralReasons.getReferralReasonsOptions(), ui, "label", "id"));
		Note note = new Note(patientId, queueId, opdId, opdLogId);
		model.addAttribute("note", StringEscapeUtils.escapeJavaScript(SimpleObject.fromObject(note, ui, "signs.id", "signs.label", "diagnoses.id", "diagnoses.label",
						"investigations", "procedures", "patientId", "queueId","specify",
						"opdId", "opdLogId", "admitted","facility", "onSetDate", "illnessHistory","referralComments","physicalExamination", "otherInstructions").toJson()));
	}

    public List<SimpleObject> getQualifiers(@RequestParam("signId") Integer signId, UiUtils ui) {
    	Concept signConcept = Context.getConceptService().getConcept(signId);
    	List<Qualifier> qualifiers = new ArrayList<Qualifier>();
    	for (ConceptAnswer conceptAnswer : signConcept.getAnswers()) {
    		qualifiers.add(new Qualifier(conceptAnswer.getAnswerConcept()));
    	}
    	return SimpleObject.fromCollection(qualifiers, ui, "id", "label", "uuid", "options.id", "options.label", "options.uuid");
    }

    public List<SimpleObject> getSymptoms(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> symptoms = Context.getService(PatientDashboardService.class).searchSymptom(name);

        List<SimpleObject> symptomsList = SimpleObject.fromCollection(symptoms, ui, "id", "name", "uuid");
        return symptomsList;
    }

    public static String PROPERTY_DRUGUNIT = "patientdashboard.dosingUnitConceptId";

    public List<SimpleObject> getDiagnosis(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> diagnosis = Context.getService(PatientDashboardService.class).searchDiagnosis(name);

        List<SimpleObject> diagnosisList = SimpleObject.fromCollection(diagnosis, ui, "id", "name", "uuid");
        return diagnosisList;
    }
    public List<SimpleObject> getProcedures(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> procedures = Context.getService(PatientDashboardService.class).searchProcedure(name);
        List<Procedure> proceduresPriority = new ArrayList<Procedure>();
        for(Concept myConcept: procedures){
            proceduresPriority.add(new Procedure(myConcept));
        }

        List<SimpleObject> proceduresList = SimpleObject.fromCollection(proceduresPriority, ui, "id", "label", "schedulable", "uuid");
        return proceduresList;
    }

    public List<SimpleObject> getInvestigations(@RequestParam(value="q") String name,UiUtils ui)
    {
        BillingService investigations = Context.getService(BillingService.class);
        List<BillableService> investigation = investigations.searchService(name);
        List<SimpleObject> investigationsList = SimpleObject.fromCollection(investigation, ui, "conceptId", "name");
        return investigationsList;
    }
    public List<SimpleObject> getDrugs(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<InventoryDrug> drugs = Context.getService(PatientDashboardService.class).findDrug(name);
        List<SimpleObject> drugList = SimpleObject.fromCollection(drugs, ui, "id", "name");
        return drugList;
    }
    public List<SimpleObject> getFormulationByDrugName(@RequestParam(value="drugName") String drugName,UiUtils ui)
    {

        InventoryCommonService inventoryCommonService = (InventoryCommonService) Context.getService(InventoryCommonService.class);
        InventoryDrug drug = inventoryCommonService.getDrugByName(drugName);

        List<SimpleObject> formulationsList = null;

        if(drug != null){
            List<InventoryDrugFormulation> formulations = new ArrayList<InventoryDrugFormulation>(drug.getFormulations());
            formulationsList = SimpleObject.fromCollection(formulations, ui, "id", "name","dozage");
        }

        return formulationsList;
    }

    public List<SimpleObject> getFrequencies(UiUtils uiUtils){
        InventoryCommonService inventoryCommonService = Context
                .getService(InventoryCommonService.class);
        List<Concept> drugFrequencyConcept = inventoryCommonService
                .getDrugFrequency();
        if(drugFrequencyConcept != null){
            List<SimpleObject> mydrugFrequencyObj = SimpleObject.fromCollection(drugFrequencyConcept,uiUtils, "id", "name", "uuid");
            return mydrugFrequencyObj;
        }
        else{
            return null;
        }
    }

    public List<SimpleObject> getDrugUnit(UiUtils uiUtils){
        Concept drugUnit = Context.getConceptService().getConcept(Context.getAdministrationService().getGlobalProperty(PROPERTY_DRUGUNIT));
        Collection<ConceptSet> unit = drugUnit.getConceptSets();
        List<Option> drugUnitOptions = new ArrayList<Option>();
        for (ConceptSet conceptSet: unit) {
            drugUnitOptions.add(new Option(conceptSet.getConcept()));
        }
        return SimpleObject.fromCollection(drugUnitOptions,uiUtils,"id","label", "uuid") ;
    }
}
