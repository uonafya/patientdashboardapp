package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.RadiologyService;
import org.openmrs.module.hospitalcore.concept.TestTree;
import org.openmrs.module.hospitalcore.model.RadiologyDepartment;
import org.openmrs.module.hospitalcore.model.RadiologyTest;
import org.openmrs.module.hospitalcore.util.RadiologyUtil;
import org.openmrs.module.hospitalcore.util.TestModel;
import org.openmrs.module.patientdashboardapp.model.SimplifiedRadiologyResults;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class RadiologyFragmentController {

	public void controller(FragmentConfiguration config, FragmentModel model,
			UiUtils uiutils) {
		config.require("patientId");

	}
	
	public SimpleObject getHistoricalRadiologyResutls(
			@RequestParam(value="patientId") int patientId, UiUtils ui){
		
        RadiologyService rs = Context.getService(RadiologyService.class);
        Patient patient = Context.getPatientService().getPatient(patientId);
        List<RadiologyTest> patientTests = new ArrayList<RadiologyTest>();
        Map<Concept, Set<Concept>> allowedInvestigations = getAllowedInvestigations();
        List<SimplifiedRadiologyResults> simplifiedRadiologyResultsList = new ArrayList<SimplifiedRadiologyResults>();
		SimplifiedRadiologyResults simplifiedRadiologyResults;

        
        try {
        	patientTests = rs.getCompletedRadiologyTestsByPatient(patient);
			List<TestModel> tests = RadiologyUtil.generateModelsFromTests(
					patientTests, allowedInvestigations);
	 
	            Collections.sort(tests);
	            for(TestModel model : tests){
					simplifiedRadiologyResults = new SimplifiedRadiologyResults();
					simplifiedRadiologyResults.setStartDate(model.getStartDate());
					simplifiedRadiologyResults.setTestName(model.getTestName());
					simplifiedRadiologyResults.setResults(getObs(model.getTestName(), model.getGivenEncounterId()));
					simplifiedRadiologyResults.setInvestigation(model.getInvestigation());

					simplifiedRadiologyResultsList.add(simplifiedRadiologyResults);
				}
	            return SimpleObject.create("status", "success",
	                    "data",
	                    SimpleObject.fromCollection(simplifiedRadiologyResultsList, ui, "startDate", "testName", "results", "investigation"));
	 			 
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
		

		
		return SimpleObject.create("error","error details not found");
	}
	
	public static Map<Concept, Set<Concept>> getAllowedInvestigations() {
        RadiologyService radiologyService = (RadiologyService) Context.getService(RadiologyService.class);
        RadiologyDepartment department = radiologyService.getCurrentRadiologyDepartment();
        Map<Concept, Set<Concept>> allowedInvestigations = new HashMap<Concept, Set<Concept>>();
        if (department != null) {
            Set<Concept> investigations = department.getInvestigations();
            for (Concept investigation : investigations) {
                TestTree tree = new TestTree(investigation);
                if (tree.getRootNode() != null) {
                    allowedInvestigations.put(tree.getRootNode().getConcept(),
                            tree.getConceptSet());
                }
            }
        }
        return allowedInvestigations;
    }

    private String getObs(String testName, Integer encounterId) {
		Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
		Concept concept = Context.getConceptService().getConcept(testName);
		String results = "";
		if(encounter != null) {
			Set<Obs> obsSet = encounter.getAllObs();
			if(obsSet != null && concept != null) {
				for(Obs obs: obsSet) {
					if(obs.getConcept() != null && obs.getConcept().equals(concept) && obs.getValueText() != null) {
						results = obs.getValueText();
					}
				}
			}

		}
		return results;
	}

}