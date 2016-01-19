package org.openmrs.module.patientdashboardui.model;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;

import java.util.Date;


/**
 * Created by Francis on 12/22/2015.
 */
public class OutcomeModelTest extends AbstractModelTest {
    @Test
    public void save_shouldSaveOutcome() throws Exception {
        executeDataSet("notes-concepts.xml");
        Option option = new Option(3,"Died");
        Encounter encounter = createEncounter();
        Patient patient = encounter.getPatient();
        Assert.assertEquals(false, patient.getDead());
        Outcome outcome = new Outcome();
        outcome.setOption(option);
        outcome.save(encounter);
        Assert.assertEquals(true, patient.getDead());
    }

    @Test
    public void addobs_shouldAddAdmitObstoEncounter() throws Exception {
        executeDataSet("notes-concepts.xml");
        Encounter encounter = createEncounter();
        Outcome outcome = new Outcome();
        Option option = new Option(2,"Admit");
        Option admitTo = new Option(9985,null);
        outcome.setOption(option);
        outcome.setAdmitTo(admitTo);
        outcome.addObs(encounter, null);
        Assert.assertEquals(admitTo.getId(),encounter.getObs().iterator().next().getValueCoded().getConceptId());
    }

    @Test
    public void addobs_shouldAddFollowUpObstoEncounter() throws Exception {
        executeDataSet("notes-concepts.xml");
        Encounter encounter = createEncounter();
        Outcome outcome = new Outcome();
        Option option = new Option(1,"Follow-up");
        outcome.setOption(option);
        String dateTime = Context.getDateFormat().format(new Date());
        outcome.setFollowUpDate(dateTime);
        outcome.addObs(encounter, null);
        Assert.assertEquals(outcome.getFollowUpDate(),Context.getDateFormat().format(encounter.getObs().iterator().next().getValueDatetime()));
    }
}
