package org.openmrs.module.patientdashboardapp.model;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;

public class SignModelTest extends AbstractModelTest {

	@Test
	public void addObs_shouldSaveAGivenSymptomOnlyOnceForASingleEncounter() throws Exception {
		executeDataSet("notes-concepts.xml");
		Encounter encounter = createEncounter();
		Sign headache = new Sign(Context.getConceptService().getConcept(9900));
		headache.addObs(encounter, null);
		Context.getEncounterService().saveEncounter(encounter);
		headache.save(encounter);
		
		Assert.assertEquals(1, encounter.getObs().size());
		
		//allow time to elaspse for diagnosis to be considered a previous diagnosis
		Thread.sleep(1000);
		
		Encounter anotherEncounter = createEncounter();
		headache = new Sign(Context.getConceptService().getConcept(9900));
		headache.addObs(anotherEncounter, null);
		
		Assert.assertEquals(0, anotherEncounter.getObs().size());
	}

}
