package org.openmrs.module.patientdashboardapp.fragment.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.RadiologyService;
import org.openmrs.module.hospitalcore.concept.TestTree;
import org.openmrs.module.hospitalcore.model.RadiologyDepartment;
import org.openmrs.module.hospitalcore.model.RadiologyTest;
import org.openmrs.module.hospitalcore.util.RadiologyUtil;
import org.openmrs.module.hospitalcore.util.TestModel;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

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

        
        try {
        	patientTests = rs.getCompletedRadiologyTestsByPatient(patient);
			List<TestModel> tests = RadiologyUtil.generateModelsFromTests(
					patientTests, allowedInvestigations);
	 
	            Collections.sort(tests);
	            return SimpleObject.create("status", "success",
	                    "data",
	                    SimpleObject.fromCollection(tests, ui, "startDate", "patientIdentifier", "patientName", "gender",
	                            "age", "testName", "investigation", "testId", "orderId", "status", "givenFormId", "notGivenFormId", "givenEncounterId", "notGivenEncounterId", "xray"));
	 			 
			
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

}