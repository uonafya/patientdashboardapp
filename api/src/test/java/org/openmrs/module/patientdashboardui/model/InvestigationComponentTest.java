package org.openmrs.module.patientdashboardui.model;

import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.test.BaseModuleContextSensitiveTest;

import java.util.Date;

/**
 * Created by Francis on 12/17/2015.
 */
public class InvestigationComponentTest  extends BaseModuleContextSensitiveTest {
    @Test
    public void save_shouldSaveInvestigations() throws Exception {
        executeDataSet("notes-concepts.xml");
        Encounter encounter = createEncounter();
        Investigation investigation = new Investigation(9996, "Maralia Tests");
        investigation.save(encounter,"My Department Test");
    }

    private Encounter createEncounter() {
        Encounter enc = new Encounter();
        enc.setLocation(Context.getLocationService().getLocation(1));
        enc.setEncounterType(Context.getEncounterService().getEncounterType(1));
        enc.setEncounterDatetime(new Date());
        Patient patient = Context.getPatientService().getPatient(3009);
        enc.setPatient(patient);
        enc.addProvider(Context.getEncounterService().getEncounterRole(1), Context.getProviderService().getProvider(1));
        Context.getEncounterService().saveEncounter(enc);
        return enc;
    }
}
