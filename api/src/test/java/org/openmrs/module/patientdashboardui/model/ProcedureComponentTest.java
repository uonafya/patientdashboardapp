package org.openmrs.module.patientdashboardui.model;

import java.util.Date;

import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.test.BaseModuleContextSensitiveTest;

public class ProcedureComponentTest extends BaseModuleContextSensitiveTest {

	@Test
	public void save_shouldSaveProcedureOrders() throws Exception {
		executeDataSet("notes-concepts.xml");
		Encounter encounter = createEncounter();
		Procedure procedure = new Procedure(9993, "Allergy Shots");
		procedure.setScheduledDate("18/12/2015");
		
		procedure.save(encounter);
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
