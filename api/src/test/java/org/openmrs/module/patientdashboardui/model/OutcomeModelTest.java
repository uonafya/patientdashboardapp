package org.openmrs.module.patientdashboardui.model;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.Encounter;

public class OutcomeModelTest extends AbstractModelTest {

	@Test
	public void addObs_shouldAddOutcomeObsToEncounter() throws Exception {
		executeDataSet("notes-concepts.xml");
		
		Encounter encounter = createEncounter();
		Assert.assertEquals(0, encounter.getObs().size());
		Outcome outcome = new Outcome();
		outcome.setOption(new Option(Outcome.CURED_OPTION, "Cured"));
		
		outcome.addObs(encounter, null);
		
		Assert.assertEquals(1, encounter.getObs().size());
	}

}
