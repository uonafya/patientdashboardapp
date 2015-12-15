package org.openmrs.module.patientdashboardui.model;

import java.util.ArrayList;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;

public class Referral {

	public Referral() {
		this.internalReferralOptions = new ArrayList<Option>();
		Concept internalReferralConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_OPDWARD));
		for (ConceptAnswer conceptAnswer : internalReferralConcept.getAnswers()) {
			internalReferralOptions.add(new Option(conceptAnswer.getAnswerConcept()));
		}
		this.externalReferralOptions = new ArrayList<Option>();
		Concept externalReferralConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_HOSPITAL));
		for (ConceptAnswer conceptAnswer : externalReferralConcept.getAnswers()) {
			externalReferralOptions.add(new Option(conceptAnswer.getAnswerConcept()));
		}
	}

	private List<Option> internalReferralOptions;
	private List<Option> externalReferralOptions;
	private Option referral;
	
	public List<Option> getInternalReferralOptions() {
		return internalReferralOptions;
	}
	public void setInternalReferralOptions(List<Option> internalReferralOptions) {
		this.internalReferralOptions = internalReferralOptions;
	}
	public List<Option> getExternalReferralOptions() {
		return externalReferralOptions;
	}
	public void setExternalReferralOptions(List<Option> externalReferralOptions) {
		this.externalReferralOptions = externalReferralOptions;
	}
	public Option getReferral() {
		return referral;
	}
	public void setReferral(Option referral) {
		this.referral = referral;
	}

}
