package org.openmrs.module.patientdashboardui.model;

import java.util.Date;

import org.junit.Test;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.Symptom;
import org.junit.Assert;

public class QualifierModelTest extends AbstractModelTest {

	@Test
	public void save_shouldSaveQualifierAndAnswer() throws Exception {		
		executeDataSet("notes-concepts.xml");
		PatientDashboardService pds = Context.getService(PatientDashboardService.class);
		Symptom symptom = createSymptom();
		symptom = pds.saveSymptom(symptom);
		
		Qualifier qualifier = new Qualifier(Context.getConceptService().getConcept(9991));
		qualifier.setAnswer(new Option(Context.getConceptService().getConcept(9992)));
		
		qualifier.save(symptom);
		
		Assert.assertEquals(qualifier.getAnswer().getId(), pds.getAnswer(pds.getQuestion(symptom).get(0)).getAnswerConcept().getConceptId());
	}

	private Symptom createSymptom() {
		Symptom symptom = new Symptom();
		symptom.setEncounter(createEncounter());
		symptom.setSymptomConcept(Context.getConceptService().getConcept(9990));
		symptom.setCreatedDate(new Date());
		return symptom;
	}

}
