package org.openmrs.module.patientdashboardui.fragment.controller;


import org.openmrs.api.context.Context;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.patientdashboardui.model.Procedure;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.module.patientdashboardui.model.Note;
import org.openmrs.module.patientdashboardui.model.Qualifier;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.ArrayList;
import java.util.List;

/**
 * Created by Francis on 12/7/2015.
 */
public class ClinicalNotesFragmentController {
    public void controller() {}
    
    public SimpleObject getNote(@RequestParam("patientId") Integer patientId, 
			@RequestParam("opdId") Integer opdId,
			@RequestParam(value = "queueId", required = false) Integer queueId,
			@RequestParam(value = "opdLogId", required = false) Integer opdLogId, UiUtils ui) {
    	Note note = new Note(patientId, queueId, opdId, opdLogId);
    	return SimpleObject.fromObject(note, ui, "signs", "diagnoses", "investigations", "procedures", "patientId", "queueId", "opdId", "opdLogId", "availableOutcomes.id", "availableOutcomes.label", "inpatientWards.id", "inpatientWards.label", "admitted","illnessHistory","otherInstructions");
    }
    
    public List<SimpleObject> getQualifiers(@RequestParam("signId") Integer signId, UiUtils ui) {
    	Concept signConcept = Context.getConceptService().getConcept(signId);
    	List<Qualifier> qualifiers = new ArrayList<Qualifier>();
    	for (ConceptAnswer conceptAnswer : signConcept.getAnswers()) {
    		qualifiers.add(new Qualifier(conceptAnswer.getAnswerConcept()));
    	}
    	return SimpleObject.fromCollection(qualifiers, ui, "id", "label", "options.id", "options.label");
    }
    
    public List<SimpleObject> getSymptoms(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> symptoms = Context.getService(PatientDashboardService.class).searchSymptom(name);

        List<SimpleObject> symptomsList = SimpleObject.fromCollection(symptoms, ui, "id", "name");
        return symptomsList;
    }
    public List<SimpleObject> getDiagnosis(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> diagnosis = Context.getService(PatientDashboardService.class).searchDiagnosis(name);

        List<SimpleObject> diagnosisList = SimpleObject.fromCollection(diagnosis, ui, "id", "name");
        return diagnosisList;
    }
    public List<SimpleObject> getProcedures(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> procedures = Context.getService(PatientDashboardService.class).searchProcedure(name);
        List<Procedure> proceduresPriority = new ArrayList<Procedure>();
        for(Concept myConcept: procedures){
            proceduresPriority.add(new Procedure(myConcept));
        }

        List<SimpleObject> proceduresList = SimpleObject.fromCollection(proceduresPriority, ui, "id", "label", "schedulable");
        return proceduresList;
    }

    public List<SimpleObject> getInvestigations(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> investigations = Context.getService(PatientDashboardService.class).searchInvestigation(name);
        List<SimpleObject> investigationsList = SimpleObject.fromCollection(investigations, ui, "id", "name");
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
            formulationsList = SimpleObject.fromCollection(formulations, ui, "id", "name");
        }

        return formulationsList;
    }
}
