package org.openmrs.module.patientdashboardapp.model;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;
import org.openmrs.module.patientdashboardapp.model.Procedure;

public class ProcedureModelTest extends AbstractModelTest {

	@Test
	public void save_shouldSaveProcedureOrders() throws Exception {
		executeDataSet("notes-concepts.xml");
		Encounter encounter = createEncounter();
		Procedure procedure = new Procedure(9993, "Allergy Shots");
		procedure.setScheduledDate("18/12/2015");
		
		procedure.save(encounter);
	}
	
	@Test
	public void addobs_shouldAddObstoEncounter() throws Exception {
		executeDataSet("notes-concepts.xml");
		Encounter encounter = createEncounter();

		Assert.assertEquals(0, encounter.getObs().size());
		Procedure procedure = new Procedure(9993, "Allergy Shots");
		procedure.setScheduledDate("18/12/2015");
		procedure.addObs(encounter,null);
		Assert.assertEquals(1,encounter.getObs().size());

		Context.getEncounterService().saveEncounter(encounter);
	}

}
