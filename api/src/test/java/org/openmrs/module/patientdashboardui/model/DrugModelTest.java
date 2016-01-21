package org.openmrs.module.patientdashboardui.model;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;

public class DrugModelTest extends AbstractModelTest {

	@Test
	public void save_shouldSaveDrugPrescription() throws Exception {
		executeDataSet("notes-concepts.xml");
		Encounter encounter = createEncounter();
		String referralWardName = "WARD";
		
		Drug drug = new Drug();
		drug.setDrugName("AMOX");
		Frequency frequency = new Frequency();
		frequency.setId(9960);
		frequency.setLabel("QD");
		Formulation formulation = new Formulation();
		formulation.setId(1);
		drug.setFrequency(frequency);
		drug.setFormulation(formulation);
		drug.setNumberOfDays(5);
		
		drug.save(encounter, referralWardName);
		
		PatientDashboardService pds = Context.getService(PatientDashboardService.class);
		List<OpdDrugOrder> odO = pds.getOpdDrugOrder(encounter);
		
		Assert.assertEquals(1, odO.size());
		Assert.assertEquals(frequency.getId(), odO.get(0).getFrequency().getConceptId());
	}

}
