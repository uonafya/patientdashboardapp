package org.openmrs.module.patientdashboardui.model;

import java.util.Date;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.Symptom;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;

public class Sign {

	public Sign() {
	}

	public Sign(Concept concept) {
		this.id = concept.getConceptId();
		this.label = concept.getDisplayString();
		this.symptomConcept = concept;
	}

	private Integer id;
	private String label;
	private Concept symptomConcept;
	private List<Qualifier> qualifiers;

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

	public List<Qualifier> getQualifiers() {
		return qualifiers;
	}

	public void setQualifiers(List<Qualifier> qualifiers) {
		this.qualifiers = qualifiers;
	}

	private Concept getSymtomConcept() {
		return this.symptomConcept == null ?
				Context.getConceptService().getConcept(this.id) : this.symptomConcept;
	}

	public void addObs(Encounter encounter, Obs obsGroup) {
		String symptomConceptId = Context.getAdministrationService()
				.getGlobalProperty(PatientDashboardConstants.PROPERTY_SYMPTOM);
		Obs obsSymptom = new Obs();
		obsSymptom.setConcept(Context.getConceptService().getConcept(Integer.parseInt(symptomConceptId)));
		obsSymptom.setValueCoded(getSymtomConcept());
		obsSymptom.setObsGroup(obsGroup);
		obsSymptom.setCreator(encounter.getCreator());
		obsSymptom.setDateCreated(encounter.getDateCreated());
		obsSymptom.setEncounter(encounter);
		encounter.addObs(obsSymptom);
	}

	public void save(Encounter encounter) {

		Symptom symptom = new Symptom();
		symptom.setEncounter(encounter);
		symptom.setSymptomConcept(getSymtomConcept());
		symptom.setCreatedDate(new Date());
		symptom.setCreator(Context.getAuthenticatedUser());

		PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
		Symptom sym = patientDashboardService.saveSymptom(symptom);

		for (Qualifier qualifier : this.qualifiers) {
			qualifier.save(sym);
		}
	}

}
