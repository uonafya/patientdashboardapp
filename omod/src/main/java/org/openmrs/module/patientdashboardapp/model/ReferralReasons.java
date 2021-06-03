
package org.openmrs.module.patientdashboardapp.model;

import java.util.ArrayList;

import java.util.List;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Obs;

import org.openmrs.api.context.Context;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ReferralReasons {

    private static Logger logger = LoggerFactory.getLogger(Note.class);
    private static List<Option> referralReasonsOptions;
    public static String PROPERTY_REFERRAL_REASONS = "1887AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";


    static {
        referralReasonsOptions = new ArrayList<Option>();
        Concept referralReasonsConcept = Context.getConceptService().getConceptByUuid(PROPERTY_REFERRAL_REASONS);
        for (ConceptAnswer conceptAnswer : referralReasonsConcept.getAnswers()) {
            referralReasonsOptions.add(new Option(conceptAnswer.getAnswerConcept()));
        }

    }

    public static List<Option> getReferralReasonsOptions() {
        return referralReasonsOptions;
    }


    public static void addReferralReasonsObs(Option referralReasons,String specify, Encounter encounter, Obs obsGroup) {
        Concept referralReasonsConcept = null;

        if (referralReasonsOptions.contains(referralReasons)) {

            referralReasonsConcept = Context.getConceptService().getConceptByUuid(PROPERTY_REFERRAL_REASONS);
        }
        if (referralReasonsConcept == null) {
            logger.error("Global property: " + PROPERTY_REFERRAL_REASONS + " not defined ");
            throw new RuntimeException(" Referral Reasons Concept is null");
        }

        Concept referralReasonsConceptAnswer = Context.getConceptService().getConcept(referralReasons.getId());
        Obs obsReferralReasons = new Obs();
        obsReferralReasons.setObsGroup(obsGroup);
        obsReferralReasons.setConcept(referralReasonsConcept);
        obsReferralReasons.setValueCoded(referralReasonsConceptAnswer);
        obsReferralReasons.setComment(specify);
        obsReferralReasons.setCreator(encounter.getCreator());
        obsReferralReasons.setDateCreated(encounter.getDateCreated());
        obsReferralReasons.setEncounter(encounter);
        encounter.addObs(obsReferralReasons);
    }
}