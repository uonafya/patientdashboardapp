package org.openmrs.module.patientdashboardui.model;

import org.openmrs.Concept;

public class Diagnosis {

	public Diagnosis(Concept concept) {
		this.id = concept.getConceptId();
		this.label = concept.getName().getName();
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

	private Integer id;
	private String label;

}
