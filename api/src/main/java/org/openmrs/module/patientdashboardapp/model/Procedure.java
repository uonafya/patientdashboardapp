package org.openmrs.module.patientdashboardapp.model;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.api.context.Context;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class Procedure {
	public Procedure(){

	}

	public Procedure(Integer id, String label) {
		this(id, label, null);
	}

	public Procedure(Integer id, String label, String uuid) {
		this.id = id;
		this.label = label;
	}

	public Procedure(Concept concept){
		this(concept.getConceptId(), concept.getDisplayString(), concept.getUuid());
		if(majorMinorOperationsConceptIds.contains(concept.getConceptId())) {
			schedulable = true;
		}
	}

	//check for minor and major procedures
	private static List<Integer> majorMinorOperationsConceptIds;
	static{
		majorMinorOperationsConceptIds = new ArrayList<Integer>();
		Collection<ConceptAnswer> minorOperationConcepts = Context.getConceptService().getConceptByUuid("3c3946b1-d71d-41b3-a2e4-2d755006200a").getAnswers();
		Collection<ConceptAnswer> majorOperationConcepts = Context.getConceptService().getConceptByUuid("3798940f-87b8-464e-b36a-17da246f034e").getAnswers();
		minorOperationConcepts.addAll(majorOperationConcepts);
		for(ConceptAnswer conceptAnswer : minorOperationConcepts){
			majorMinorOperationsConceptIds.add(conceptAnswer.getAnswerConcept().getConceptId());
		}
	}


	private Integer id;
	private String uuid;
	private String label;
	private boolean schedulable;
	private String scheduledDate;
	
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
	public void setLabel(String label) {
		this.label = label;
	}
	public boolean isSchedulable() {return schedulable;	}
	public void setSchedulable(boolean schedulable) {this.schedulable = schedulable;}
	public String getScheduledDate() {
		return scheduledDate;
	}
	public void setScheduledDate(String scheduledDate) {
		this.scheduledDate = scheduledDate;
	}
}
