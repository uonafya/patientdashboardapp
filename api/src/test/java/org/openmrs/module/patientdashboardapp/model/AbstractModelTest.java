package org.openmrs.module.patientdashboardapp.model;

import java.util.Date;

import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.test.BaseModuleContextSensitiveTest;

public abstract class AbstractModelTest extends BaseModuleContextSensitiveTest {

	protected Encounter createEncounter() {
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
