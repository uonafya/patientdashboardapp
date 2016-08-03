package org.openmrs.module.patientdashboardapp.model;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.Answer;
import org.openmrs.module.hospitalcore.model.Question;
import org.openmrs.module.hospitalcore.model.Symptom;

public class Qualifier {

	private Integer id;
	private String uuid;
	private String label;
	private Option answer;
	private String freeText;
	private List<Option> options;

	public Qualifier() {
	}

	public Qualifier(Concept qualifierConcept) {
		this.id = qualifierConcept.getConceptId();
		this.label = qualifierConcept.getDisplayString();
		this.setUuid(qualifierConcept.getUuid());
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

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
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
		Concept questionConcept = Context.getConceptService().getConcept(this.id);
		PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
		List<Question> savedQuestions = patientDashboardService.getQuestion(symptom);
		Boolean qualifierHasBeenSaved = false;
		for (Question savedQuestion : savedQuestions) {
			if (savedQuestion.getQuestionConcept().equals(questionConcept)) {
				Answer previousAnswer = patientDashboardService.getAnswer(savedQuestion);
				if (savedQuestion.getQuestionConcept().getDatatype().isCoded()) {
					Concept currentAnswerConcept = Context.getConceptService().getConcept(this.answer.getId());
					if (!previousAnswer.getAnswerConcept().equals(currentAnswerConcept)) {
						previousAnswer.setAnswerConcept(currentAnswerConcept);
					}
				} else {
					if (!StringUtils.equalsIgnoreCase(previousAnswer.getFreeText(), this.getFreeText())) {
						previousAnswer.setFreeText(this.getFreeText());
					}
				}
				patientDashboardService.saveAnswer(previousAnswer);
				qualifierHasBeenSaved = true;
			}
		}
		if (!qualifierHasBeenSaved && (this.answer != null || StringUtils.isNotBlank(this.freeText))) {
			Question question = new Question();
			question.setSymptom(symptom);
			question.setQuestionConcept(questionConcept);
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

}
