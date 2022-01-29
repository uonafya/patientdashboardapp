package org.openmrs.module.patientdashboardapp.model;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.Symptom;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Sign {

	private static final int OTHER_NON_CODED_5622 = 5622;
	private static final int NON_CODED_SYMPTOM_5693 = 1000033;

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
	private List<Sign> previousSigns;

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
	
	public static List<Sign> getPreviousSigns(Integer patientId) {
		List<Sign> previousSigns = new ArrayList<Sign>();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		List<Obs> symptomObs = queueService.getAllSymptom(patientId);
		for (Obs signObs : symptomObs) {
			if (signObs.getValueCoded().getConceptId() == NON_CODED_SYMPTOM_5693) {
				if (signObs.getGroupMembers() != null) {
					for (Obs nonCodedSignObs : signObs.getGroupMembers()) {
						Sign nonCodedSign = new Sign();
						nonCodedSign.id = signObs.getValueCoded().getConceptId();
						nonCodedSign.label = nonCodedSignObs.getValueText();
						previousSigns.add(nonCodedSign);
					}
				}
			} else {
				previousSigns.add(new Sign(signObs.getValueCoded()));
			}
		}
		return previousSigns;
	}

	public void addObs(Encounter encounter, Obs obsGroup) {
		if (previousSigns == null) {
			previousSigns = getPreviousSigns(encounter.getPatient().getPatientId());
		}
		if (!previousSigns.contains(this)) {
			Obs obsSymptom = new Obs();
			obsSymptom.setConcept(Context.getConceptService().getConceptByUuid("c91a7e0e-4622-4eeb-9edc-00f8ececf428"));
			obsSymptom.setValueCoded(getSymtomConcept());
			obsSymptom.setObsGroup(obsGroup);
			obsSymptom.setCreator(encounter.getCreator());
			obsSymptom.setDateCreated(encounter.getDateCreated());
			obsSymptom.setEncounter(encounter);
			obsSymptom.setPerson(encounter.getPatient());
			encounter.addObs(obsSymptom);
			System.out.println("Return the value of this object>>"+this.id);
			if (this.id == NON_CODED_SYMPTOM_5693) {
				Obs nonCodedSymptom = new Obs();
				nonCodedSymptom.setConcept(Context.getConceptService().getConcept(OTHER_NON_CODED_5622));
				nonCodedSymptom.setObsGroup(obsSymptom);
				nonCodedSymptom.setValueText(this.label);
				nonCodedSymptom.setCreator(encounter.getCreator());
				nonCodedSymptom.setDateCreated(encounter.getDateCreated());
				nonCodedSymptom.setEncounter(encounter);
				nonCodedSymptom.setPerson(encounter.getPatient());
				encounter.addObs(nonCodedSymptom);
			}
		}
	}

	public void save(Encounter encounter) {
		if (previousSigns != null) {
			previousSigns = getPreviousSigns(encounter.getPatient().getPatientId());
		}
		Symptom savedSymptom = null;
		assert previousSigns != null;
		if (!previousSigns.contains(this)) {

			Symptom symptom = new Symptom();
			symptom.setEncounter(encounter);
			symptom.setSymptomConcept(getSymtomConcept());
			symptom.setCreatedDate(new Date());
			symptom.setCreator(Context.getAuthenticatedUser());
	
			PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
			savedSymptom = patientDashboardService.saveSymptom(symptom);
		} else {
			List<Obs> symptomObs = Context.getService(PatientQueueService.class).getAllSymptom(encounter.getPatient().getPatientId());
			if (symptomObs.size() > 0) {
				List<Symptom> symptoms = Context.getService(PatientDashboardService.class).getSymptom(symptomObs.get(0).getEncounter());
				for (Symptom symptom : symptoms) {
					if (symptom.getSymptomConcept().equals(this.getSymtomConcept())) {
						savedSymptom = symptom;
						break;
					}
				}
			}
		}

		if (this.qualifiers != null && savedSymptom != null) {
			for (Qualifier qualifier : this.qualifiers) {
				qualifier.save(savedSymptom);
			}
		}
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

		if (!(obj instanceof Sign)) {
			return false;
		}
		Sign otherSign = (Sign) obj;
		if (this.id.equals(NON_CODED_SYMPTOM_5693)) {
			return this.label == null ? otherSign.label == null : StringUtils.equalsIgnoreCase(this.label, otherSign.label);
		} else {
			return this.id.equals(otherSign.id);
		}
	}

	@Override
	public String toString() {
		return "{id=" + this.id + ", label=" + this.label + "}";
	}

}
