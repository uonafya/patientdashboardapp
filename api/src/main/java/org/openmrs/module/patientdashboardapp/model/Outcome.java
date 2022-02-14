package org.openmrs.module.patientdashboardapp.model;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.model.Option;
import org.openmrs.module.hospitalcore.model.PatientSearch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;


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
        options.add(new Option(REVIEWED_OPTION, null, "Reviewed"));
        options.add(new Option(CURED_OPTION, null, "Discharged"));
        options.add(new Option(FOLLOW_UP_OPTION, null, "Next Appointment Date"));
        options.add(new Option(ADMIT_OPTION, null, "Admit"));
        options.add(new Option(DIED_OPTION, null, "Died"));
        return options;
    }

    public static List<Option> getInpatientWards() {
        List<Option> inpatientWards = new ArrayList<Option>();
        Concept ipdConcept = Context.getConceptService().getConceptByUuid("5fc29316-0869-4b3b-ae2f-cc37c6014eb7");
        for (ConceptAnswer inpatientConceptAnswer : ipdConcept.getAnswers()) {
            inpatientWards.add(new Option(inpatientConceptAnswer.getAnswerConcept()));
        }
        return inpatientWards;
    }

    public void addObs(Encounter encounter, Obs obsGroup) {
        Concept outcomeConcept = Context.getConceptService().getConceptByUuid("160433AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        Obs obsOutcome = new Obs();
        obsOutcome.setObsGroup(obsGroup);
        obsOutcome.setConcept(outcomeConcept);
        obsOutcome.setValueText(this.option.getLabel());
        obsOutcome.setCreator(encounter.getCreator());
        obsOutcome.setDateCreated(encounter.getDateCreated());
        obsOutcome.setEncounter(encounter);
        encounter.addObs(obsOutcome);
        if (this.option.getId() == FOLLOW_UP_OPTION) {
            Concept nextAppointmentDate = Context.getConceptService().getConceptByUuid("5096AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
            Obs nextAppointmentDateObs = new Obs();
            nextAppointmentDateObs.setObsGroup(obsGroup);
            nextAppointmentDateObs.setConcept(nextAppointmentDate);
            try {
                nextAppointmentDateObs.setValueDatetime(Context.getDateFormat().parse(this.followUpDate));
            } catch (ParseException e) {
                e.printStackTrace();
            }
            nextAppointmentDateObs.setCreator(encounter.getCreator());
            nextAppointmentDateObs.setEncounter(encounter);
            nextAppointmentDateObs.setDateCreated(encounter.getDateCreated());
            encounter.addObs(nextAppointmentDateObs);
        }
        if (this.option.getId() == ADMIT_OPTION) {
            Obs admitObs = new Obs();
            admitObs.setObsGroup(obsGroup);
            admitObs.setConcept(outcomeConcept);
            admitObs.setValueCoded(Context.getConceptService().getConcept(this.admitTo.getId()));
            admitObs.setDateCreated(encounter.getDateCreated());
            admitObs.setEncounter(encounter);
            encounter.addObs(admitObs);
        }
    }

    public void save(Encounter encounter) {
        if (this.option.getId() == DIED_OPTION) {
            Concept causeOfDeath = Context.getConceptService().getConceptByUuid("1107AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");//provide cause of death as a concept
            Patient patient = encounter.getPatient();
            patient.setDead(true);
            patient.setDeathDate(encounter.getDateCreated());// please provide a date picker to allow someone to enter the death date
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

