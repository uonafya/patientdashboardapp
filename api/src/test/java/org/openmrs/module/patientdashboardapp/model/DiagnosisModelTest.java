package org.openmrs.module.patientdashboardapp.model;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;

public class DiagnosisModelTest extends AbstractModelTest {

	@Test 
	public void save_shouldSaveAGivenProvisionalDiagnosisOnlyOnceForASingleEncounter() throws Exception {
		executeDataSet("notes-concepts.xml");
		Encounter encounter = createEncounter();
		Diagnosis malaria = new Diagnosis(Context.getConceptService().getConcept(10003));
		malaria.setProvisional(true);

		malaria.addObs(encounter, null);
		Context.getEncounterService().saveEncounter(encounter);
		
		Assert.assertEquals(1, encounter.getObs().size());
		
		//allow time to elaspse for diagnosis to be considered a previous diagnosis
		Thread.sleep(1000);
		
		Encounter anotherEncounter = createEncounter();
		malaria.addObs(anotherEncounter, null);
		
		Diagnosis.getPreviousDiagnoses(anotherEncounter.getPatient().getPatientId());
		
		Assert.assertEquals(0, anotherEncounter.getObs().size());
	}

	@Test public void addObs_shouldAddFinalDiagnosisToEncounterObs() throws Exception {
		executeDataSet("notes-concepts.xml");
		Encounter encounter = createEncounter();
		Diagnosis malaria = new Diagnosis(Context.getConceptService().getConcept(10003));
		malaria.setProvisional(false);
		malaria.addObs(encounter, null);

		Context.getEncounterService().saveEncounter(encounter);

		Assert.assertEquals(1, encounter.getObs().size());

		//allow time to elaspse for diagnosis to be considered a previous diagnosis
		Thread.sleep(1000);

		Encounter anotherEncounter = createEncounter();
		malaria.addObs(anotherEncounter, null);

		Assert.assertEquals(1, anotherEncounter.getObs().size());
	}

}
