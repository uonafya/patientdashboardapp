package org.openmrs.module.patientdashboardapp.model;

import org.openmrs.Concept;
public class Option {

	private Integer id;
	private String label;

	public Option() {
	}

	public Option(int id, String label) {
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

	@Override
	public int hashCode() {
		int hash = 1;
		hash = hash * 31;
		hash = hash * 31 + (this.id == null ? 0 : this.id.hashCode());
		return hash;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}

		if (!(obj instanceof Option)) {
			return false;
		}
		Option otherOption = (Option) obj;
		return (this.id.equals(otherOption.id))
				&& ((this.id == null)
						? otherOption.id == null
						: this.id.equals(otherOption.id));
	}


}
