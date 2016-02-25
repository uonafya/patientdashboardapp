package org.openmrs.module.patientdashboardapp.model;

import java.util.Date;

import org.junit.Test;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.Symptom;
import org.openmrs.module.patientdashboardapp.model.Option;
import org.openmrs.module.patientdashboardapp.model.Qualifier;
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
	
	@Test public void save_shouldUpdateSymptomQualifierIfItHasChanged() throws Exception {
		executeDataSet("notes-concepts.xml");
		PatientDashboardService pds = Context.getService(PatientDashboardService.class);
		Symptom headache = createSymptom();
		headache = pds.saveSymptom(headache);
		
		Qualifier severity = new Qualifier(Context.getConceptService().getConcept(10004));
		Option aFive = new Option(Context.getConceptService().getConcept(10006));
		severity.setAnswer(aFive);
		severity.save(headache);
		
		//confirm qualifier has been saved
		Assert.assertEquals(aFive.getId(), pds.getAnswer(pds.getQuestion(headache).get(0)).getAnswerConcept().getConceptId());
		
		Option aTen = new Option(Context.getConceptService().getConcept(10007));
		severity.setAnswer(aTen);
		severity.save(headache);
		
		
		Assert.assertEquals(aTen.getId(), pds.getAnswer(pds.getQuestion(headache).get(0)).getAnswerConcept().getConceptId());
		Assert.assertEquals(1, pds.getQuestion(headache).size());
		
	}
	
	@Test public void save_shouldAddQualifiersToSymptom() throws Exception {
		executeDataSet("notes-concepts.xml");
		PatientDashboardService pds = Context.getService(PatientDashboardService.class);
		Symptom headache = createSymptom();
		headache = pds.saveSymptom(headache);
		
		Qualifier severity = new Qualifier(Context.getConceptService().getConcept(10004));
		Option aFive = new Option(Context.getConceptService().getConcept(10006));
		severity.setAnswer(aFive);
		severity.save(headache);
		
		//confirm qualifier has been saved
		Assert.assertEquals(aFive.getId(), pds.getAnswer(pds.getQuestion(headache).get(0)).getAnswerConcept().getConceptId());
		
		Qualifier comment = new Qualifier(Context.getConceptService().getConcept(10008));
		String aComment = "Some comment...";
		comment.setFreeText(aComment);
		comment.save(headache);
		
		
		Assert.assertEquals(aComment, pds.getAnswer(pds.getQuestion(headache).get(1)).getFreeText());
		Assert.assertEquals(2, pds.getQuestion(headache).size());
	}

	private Symptom createSymptom() {
		Symptom symptom = new Symptom();
		symptom.setEncounter(createEncounter());
		symptom.setSymptomConcept(Context.getConceptService().getConcept(9990));
		symptom.setCreatedDate(new Date());
		return symptom;
	}

}
