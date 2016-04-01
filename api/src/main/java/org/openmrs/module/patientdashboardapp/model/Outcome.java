package org.openmrs.module.patientdashboardapp.model;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.model.PatientSearch;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class Outcome {

    static final int FOLLOW_UP_OPTION = 1;
    static final int ADMIT_OPTION = 2;
    static final int DIED_OPTION = 3;
    static final int REVIEWED_OPTION = 4;
    static final int CURED_OPTION = 5;
    private static Logger logger = LoggerFactory.getLogger(Outcome.class);
    private Option option;
    private String followUpDate;
    private Option admitTo;

    public Option getOption() {
        return this.option;
    }

    public void setOption(Option option) {
        this.option = option;
    }

    public String getFollowUpDate() {
        return followUpDate;
    }

    public void setFollowUpDate(String followUpDate) {
        this.followUpDate = followUpDate;
    }

    public Option getAdmitTo() {
        return admitTo;
    }

    public void setAdmitTo(Option admitTo) {
        this.admitTo = admitTo;
    }

    public static List<Option> getAvailableOutcomes() {
        List<Option> options = new ArrayList<Option>();
        options.add(new Option(REVIEWED_OPTION, "Reviewed"));
        options.add(new Option(CURED_OPTION, "Discharged"));
        options.add(new Option(FOLLOW_UP_OPTION, "Next Appointment Date"));
        options.add(new Option(ADMIT_OPTION, "Admit"));
        options.add(new Option(DIED_OPTION, "Died"));
        return options;
    }

    public static List<Option> getInpatientWards() {
        List<Option> inpatientWards = new ArrayList<Option>();
        Concept ipdConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_IPDWARD));
        for (ConceptAnswer inpatientConceptAnswer : ipdConcept.getAnswers()) {
            inpatientWards.add(new Option(inpatientConceptAnswer.getAnswerConcept()));
        }
        return inpatientWards;
    }

    public void addObs(Encounter encounter, Obs obsGroup) {
        String outcomeConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_VISIT_OUTCOME);
        Concept outcomeConcept = Context.getConceptService().getConceptByName(outcomeConceptName);
        Obs obsOutcome = new Obs();
        obsOutcome.setObsGroup(obsGroup);
        obsOutcome.setConcept(outcomeConcept);
        try {
            obsOutcome.setValueText(this.option.getLabel());
            if (this.option.getId() == FOLLOW_UP_OPTION) {
                obsOutcome.setValueDatetime(Context.getDateFormat().parse(this.followUpDate));
            } else if (this.option.getId() == ADMIT_OPTION) {
                obsOutcome.setValueCoded(Context.getConceptService().getConcept(this.admitTo.getId()));
            }
        } catch (ParseException e) {
            logger.error("Error saving outcome obs: {}", new Object[]{e.getMessage()});
        }
        obsOutcome.setCreator(encounter.getCreator());
        obsOutcome.setDateCreated(encounter.getDateCreated());
        obsOutcome.setEncounter(encounter);
        encounter.addObs(obsOutcome);
    }

    public void save(Encounter encounter) {
        if (this.option.getId() == DIED_OPTION) {
            Concept causeOfDeath = Context.getConceptService().getConceptByName("NONE");
            Patient patient = encounter.getPatient();
            patient.setDead(true);
            patient.setDeathDate(encounter.getDateCreated());
            patient.setCauseOfDeath(causeOfDeath);
            Context.getPatientService().savePatient(patient);
            PatientSearch patientSearch = Context.getService(HospitalCoreService.class).getPatient(encounter.getPatient().getId());
            if (patientSearch != null) {
                patientSearch.setDead(true);
                Context.getService(HospitalCoreService.class).savePatientSearch(patientSearch);
            }

        }

        if (this.option.getId() == ADMIT_OPTION) {
            IpdPatientAdmission patientAdmission = new IpdPatientAdmission();
            patientAdmission.setAdmissionDate(encounter.getEncounterDatetime());
            patientAdmission.setAdmissionWard(Context.getConceptService().getConcept(this.admitTo.getId()));
            patientAdmission.setBirthDate(encounter.getPatient().getBirthdate());
            patientAdmission.setGender(encounter.getPatient().getGender());
            patientAdmission.setOpdAmittedUser(encounter.getCreator());
            //patientAdmission.setOpdLog(opdPatientLog);
            patientAdmission.setPatient(encounter.getPatient());
            patientAdmission.setPatientIdentifier(encounter.getPatient()
                    .getPatientIdentifier().getIdentifier());
            if (encounter.getPatient().getMiddleName() != null) {
                patientAdmission.setPatientName(encounter.getPatient().getGivenName()
                        + " " + encounter.getPatient().getFamilyName() + " "
                        + encounter.getPatient().getMiddleName().replace(",", " "));
            } else {
                patientAdmission.setPatientName(encounter.getPatient().getGivenName()
                        + " " + encounter.getPatient().getFamilyName());
            }
            patientAdmission.setAcceptStatus(0);
            Context.getService(IpdService.class).saveIpdPatientAdmission(patientAdmission);
        }
    }
}

