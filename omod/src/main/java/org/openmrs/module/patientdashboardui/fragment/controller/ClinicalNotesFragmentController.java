package org.openmrs.module.patientdashboardui.fragment.controller;


import org.openmrs.api.context.Context;
import org.openmrs.Concept;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.module.hospitalcore.model.Symptom;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.ArrayList;
import java.util.List;

/**
 * Created by Francis on 12/7/2015.
 */
public class ClinicalNotesFragmentController {
    public void controller() {}
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

        List<SimpleObject> proceduresList = SimpleObject.fromCollection(procedures, ui, "id", "name");
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
