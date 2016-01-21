package org.openmrs.module.patientdashboardapp.model;

import java.util.ArrayList;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.Answer;
import org.openmrs.module.hospitalcore.model.Question;
import org.openmrs.module.hospitalcore.model.Symptom;

public class Qualifier {

	private Integer id;
	private String label;
	private Option answer;
	private String freeText;
	private List<Option> options;

	public Qualifier() {
	}

	public Qualifier(Concept qualifierConcept) {
		this.id = qualifierConcept.getConceptId();
		this.label = qualifierConcept.getDisplayString();
		this.options = new ArrayList<Option>();
		for (ConceptAnswer conceptAnswer : qualifierConcept.getAnswers()) {
			options.add(new Option(conceptAnswer.getAnswerConcept()));
		}
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String name) {
		this.label = name;
	}

	public void setFreeText(String freeText) {
		this.freeText = freeText;
	}

	public String getFreeText() {
		return this.freeText;
	}

	public List<Option> getOptions() {
		return options;
	}

	public void setOptions(List<Option> options) {
		this.options = options;
	}

	public Option getAnswer() {
		return answer;
	}

	public void setAnswer(Option answer) {
		this.answer = answer;
	}

	public void save(Symptom symptom) {
		Question question = new Question();
		question.setSymptom(symptom);
		Concept questionConcept = Context.getConceptService().getConcept(this.id);
		question.setQuestionConcept(questionConcept);
		PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
		question = patientDashboardService.saveQuestion(question);

		Answer answer = new Answer();
		if (questionConcept.getDatatype().isCoded()) {
			answer.setQuestion(question);
			answer.setAnswerConcept(Context.getConceptService().getConcept(this.answer.getId()));
			answer.setFreeText(null);
		} else {
			answer.setQuestion(question);
			answer.setAnswerConcept(null);
			answer.setFreeText(this.getFreeText());
		}
		patientDashboardService.saveAnswer(answer);
	}

}
