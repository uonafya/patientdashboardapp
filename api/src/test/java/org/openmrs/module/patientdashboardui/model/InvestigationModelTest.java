package org.openmrs.module.patientdashboardui.model;

import org.junit.Test;
import org.openmrs.Encounter;

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
}
