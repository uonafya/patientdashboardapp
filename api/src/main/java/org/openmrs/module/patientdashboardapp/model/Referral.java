package org.openmrs.module.patientdashboardapp.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Referral {

	private static Logger logger = LoggerFactory.getLogger(Note.class);
	private static List<Option> internalReferralOptions;
	private static List<Option> externalReferralOptions;
	private static final List<String> REFFERAL_CLINIC_UUIDS = Collections.unmodifiableList(Arrays.asList("70285bed-156b-47ed-9704-493f10149e84","f5c89e8c-c79e-4e20-9048-b7ef8f30b272"));
	static {
		internalReferralOptions = new ArrayList<Option>();
		for(String refferalClinicUUID: REFFERAL_CLINIC_UUIDS) {
			Concept internalReferralConcept = Context.getConceptService().getConceptByUuid(refferalClinicUUID);
			if(internalReferralConcept != null) {
				for (ConceptAnswer conceptAnswer : internalReferralConcept.getAnswers()) {
					internalReferralOptions.add(new Option(conceptAnswer.getAnswerConcept()));
				}
			}
		}
		externalReferralOptions = new ArrayList<Option>();
		Concept externalReferralConcept = Context.getConceptService().getConcept(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_EXTERNAL_REFERRAL));
		for (ConceptAnswer conceptAnswer : externalReferralConcept.getAnswers()) {
			externalReferralOptions.add(new Option(conceptAnswer.getAnswerConcept()));
		}
	}

	public static List<Option> getInternalReferralOptions() {
		return internalReferralOptions;
	}
	public static List<Option> getExternalReferralOptions() {
		return externalReferralOptions;
	}

	public static void addReferralObs(Option referredTo, Integer referrer, Encounter encounter, String referralComments, Obs obsGroup) {
		Concept referralConcept = null;
		boolean isInternal = false;
		if (internalReferralOptions.contains(referredTo)) {
			isInternal = true;
			referralConcept = Context.getConceptService().getConcept(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_INTERNAL_REFERRAL));
		}else {
			referralConcept = Context.getConceptService().getConcept(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_EXTERNAL_REFERRAL));
		}
		if (referralConcept == null) {
			logger.error("Global property: " + PatientDashboardConstants.PROPERTY_INTERNAL_REFERRAL + " not defined OR\n Internal/External Referral concept not defined");
			throw new RuntimeException("Internal/External Referral Concept is null");
		}

		Concept referredToConcept = Context.getConceptService().getConcept(referredTo.getId());
		Obs obsReferral = new Obs();
		obsReferral.setObsGroup(obsGroup);
		obsReferral.setConcept(referralConcept);
		obsReferral.setValueCoded(referredToConcept);
		obsReferral.setCreator(encounter.getCreator());
		obsReferral.setComment(referralComments);
		obsReferral.setDateCreated(encounter.getDateCreated());
		obsReferral.setEncounter(encounter);
		encounter.addObs(obsReferral);
		
		if (isInternal) {
			Concept referrerConcept = Context.getConceptService().getConcept(referrer);
			refer(encounter.getPatient(), referredToConcept, referrerConcept);
		}
	}
	
	private static void refer(Patient patient, Concept referredTo, Concept referredFrom) {
		PersonAttributeType personAttributeTypePaymentCategory = Context.getPersonService().getPersonAttributeTypeByUuid("09cd268a-f0f5-11ea-99a8-b3467ddbf779");
		List<PersonAttribute> pas = Context.getService(HospitalCoreService.class).getPersonAttributes(patient.getPatientId());
		String selectedCategory = "";
		for (PersonAttribute pa : pas) {
			PersonAttributeType attributeType = pa.getAttributeType();
			if (attributeType.equals(personAttributeTypePaymentCategory)) {
				selectedCategory = pa.getValue();
			}
		}

		OpdPatientQueue queue = new OpdPatientQueue();
		queue.setPatient(patient);
		queue.setCreatedOn(new Date());
		queue.setBirthDate(patient.getBirthdate());
		queue.setPatientIdentifier(patient.getPatientIdentifier().getIdentifier());
		queue.setOpdConcept(referredTo);
		queue.setOpdConceptName(referredTo.getName().getName());
		if (patient.getMiddleName() != null) {
			queue.setPatientName(patient.getGivenName() + " "
					+ patient.getFamilyName() + " "
					+ patient.getMiddleName().replace(",", " "));
		} else {
			queue.setPatientName(patient.getGivenName() + " "
					+ patient.getFamilyName());
		}
		queue.setReferralConcept(referredFrom);
		queue.setReferralConceptName(referredFrom.getName().getName());
		queue.setSex(patient.getGender());
		queue.setTriageDataId(null);
		queue.setCategory(selectedCategory);
		OpdPatientQueue opdPatient = Context.getService(PatientQueueService.class).saveOpdPatientQueue(queue);
		logger.info(opdPatient.toString());
	}
}
