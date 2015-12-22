package org.openmrs.module.patientdashboardui.model;

import org.openmrs.Concept;

public class Option {

	private Integer id;
	private String label;

	public Option() {
	}

	public Option(int id, String label){
		this.id = id;
		this.label = label;
	}

	public Option(Concept answerConcept) {
		this.id = answerConcept.getConceptId();
		this.label = answerConcept.getDisplayString();
	}

	public Option(Integer id) {
		this.id = id;
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

	public void setLabel(String label) {
		this.label = label;
	}
}
