package org.openmrs.module.patientdashboardapp.model;

import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;

import org.openmrs.module.patientdashboardapp.model.Investigation;

/**
 * Created by Francis on 12/17/2015.
 */
public class InvestigationModelTest  extends AbstractModelTest {
    @Test
    public void save_shouldSaveInvestigations() throws Exception {
        executeDataSet("notes-concepts.xml");
        Encounter encounter = createEncounter();
        Investigation investigation = new Investigation(9996, "Maralia Tests");
        investigation.save(encounter,"My Department Test");
    }
    
    @Test
    @SuppressWarnings("deprecation")
    public void save_shouldCreateOrderForFreeInvestigation() throws Exception {
        executeDataSet("notes-concepts.xml");
        Encounter encounter = createEncounter();
        Investigation investigation = new Investigation(9996, "Maralia Tests");
        investigation.save(encounter,"My Department Test");
        
        Assert.assertEquals(1, Context.getOrderService().getOrdersByPatient(encounter.getPatient()).size());
        Assert.assertEquals(Integer.valueOf(9996), Context.getOrderService().getOrdersByPatient(encounter.getPatient()).get(0).getConcept().getConceptId());
    }
}
