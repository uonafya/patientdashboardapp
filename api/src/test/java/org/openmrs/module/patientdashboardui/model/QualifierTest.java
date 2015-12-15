package org.openmrs.module.patientdashboardui.model;

import java.util.Date;

import org.junit.Test;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.Symptom;
import org.openmrs.test.BaseModuleContextSensitiveTest;

import org.junit.Assert;
import org.junit.Ignore;

public class QualifierTest extends BaseModuleContextSensitiveTest {

	@Test
	@Ignore
	public void should_save() throws Exception {
		executeXmlDataSet("notes-concepts.xml");
		PatientDashboardService pds = Context.getService(PatientDashboardService.class);
		Symptom symptom = createSymptom();
		pds.saveSymptom(symptom);
		
		Qualifier qualifier = new Qualifier(Context.getConceptService().getConcept(9991));
		qualifier.setAnswer(new Option(Context.getConceptService().getConcept(9992)));
		
		qualifier.save(symptom);
		
		Assert.assertEquals(qualifier.getAnswer().getId(), pds.getAnswer(pds.getQuestion(symptom).get(0)).getAnswerId());
	}

	private Symptom createSymptom() {
		Symptom symptom = new Symptom();
		symptom.setEncounter(createEncounter());
		symptom.setSymptomConcept(Context.getConceptService().getConcept(9990));
		symptom.setCreatedDate(new Date());
		return symptom;
	}
	
	private Encounter createEncounter() {
		Encounter enc = new Encounter();
		enc.setLocation(Context.getLocationService().getLocation(1));
		enc.setEncounterType(Context.getEncounterService().getEncounterType(1));
		enc.setEncounterDatetime(new Date());
		Concept concept = Context.getConceptService().getConcept(9990);
		Patient patient = Context.getPatientService().getPatient(3);
		enc.setPatient(patient);
		enc.addProvider(Context.getEncounterService().getEncounterRole(1), Context.getProviderService().getProvider(1));
		return enc;
	}

}
