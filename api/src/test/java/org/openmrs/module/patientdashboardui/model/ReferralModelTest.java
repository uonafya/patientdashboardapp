package org.openmrs.module.patientdashboardui.model;

import org.hamcrest.Matchers;
import org.junit.Assert;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;

public class ReferralModelTest extends AbstractModelTest {

	@Test public void refer_shouldReferPatientToCorrectWardWhenInternal() throws Exception {
		executeDataSet("notes-concepts.xml");
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		
		Assert.assertThat(queueService.getAllPatientInQueue().size(), Matchers.is(0));
		
		Encounter encounter = createEncounter();
		Referral.addReferralObs(new Option(9986), 9986, encounter, null);
		
		Assert.assertThat(queueService.countOpdPatientQueue(encounter.getPatient().getFamilyName(), null, null, null), Matchers.is(1));
	}

}
