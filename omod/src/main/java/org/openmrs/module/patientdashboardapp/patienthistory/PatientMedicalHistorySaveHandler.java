package org.openmrs.module.patientdashboardapp.patienthistory;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.PatientMedicalHistory;

/**
 * Created by USER on 2/16/2016.
 */
public class PatientMedicalHistorySaveHandler {

        private static PatientMedicalHistory patientMedicalHistory;
        public static void save(PatientMedicalHistory updatedPatientMedicalHistory, Integer patientId) {
            PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);

            patientMedicalHistory = patientQueueService.getPatientHistoryByPatientId(patientId) == null ? new PatientMedicalHistory() : patientQueueService.getPatientHistoryByPatientId(patientId);

            if (patientMedicalHistory.getPatientId() == null) {

                patientMedicalHistory.setPatientId(patientId);
            }

            if(patientMedicalHistory.getCreatedOn() == null){
                patientMedicalHistory.setCreatedOn(updatedPatientMedicalHistory.getCreatedOn());
            }

            if(StringUtils.isNotBlank(updatedPatientMedicalHistory.getIllnessExisting())){

                patientMedicalHistory.setIllnessExisting(updatedPatientMedicalHistory.getIllnessExisting());
            }
            if(StringUtils.isNotBlank(updatedPatientMedicalHistory.getIllnessProblem())){

                patientMedicalHistory.setIllnessProblem(updatedPatientMedicalHistory.getIllnessProblem());
            }
            if(StringUtils.isNotBlank(updatedPatientMedicalHistory.getIllnessLong())){

                patientMedicalHistory.setIllnessLong(updatedPatientMedicalHistory.getIllnessLong());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getIllnessProgress()))){
                patientMedicalHistory.setIllnessProgress(updatedPatientMedicalHistory.getIllnessProgress());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getIllnessRecord()))){

                patientMedicalHistory.setIllnessRecord(updatedPatientMedicalHistory.getIllnessRecord());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getChronicIllness()))){

                patientMedicalHistory.setChronicIllness(updatedPatientMedicalHistory.getChronicIllness());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getIllnessProblem()))){

                patientMedicalHistory.setChronicIllnessProblem(updatedPatientMedicalHistory.getChronicIllnessProblem());
            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getChronicIllnessOccure()))){

                patientMedicalHistory.setChronicIllnessOccure(updatedPatientMedicalHistory.getChronicIllnessOccure());
            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getChronicIllnessOutcome()))){

                patientMedicalHistory.setChronicIllnessOutcome(updatedPatientMedicalHistory.getChronicIllnessOutcome());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getChronicIllnessRecord()))){

                patientMedicalHistory.setChronicIllnessRecord(updatedPatientMedicalHistory.getChronicIllnessRecord());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousAdmission()))){
                patientMedicalHistory.setPreviousAdmission(updatedPatientMedicalHistory.getPreviousAdmission());
            }
            if(StringUtils.isBlank((updatedPatientMedicalHistory.getPreviousAdmissionWhen()))){
                patientMedicalHistory.setPreviousAdmissionWhen(updatedPatientMedicalHistory.getPreviousAdmissionWhen());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousAdmissionProblem()))){
                patientMedicalHistory.setPreviousAdmissionProblem(updatedPatientMedicalHistory.getPreviousAdmissionProblem());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousAdmissionOutcome()))){
                patientMedicalHistory.setPreviousAdmissionOutcome(updatedPatientMedicalHistory.getPreviousAdmissionOutcome());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousAdmissionRecord()))){
                patientMedicalHistory.setPreviousAdmissionRecord(updatedPatientMedicalHistory.getPreviousAdmissionRecord());
            }
            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousInvestigation()))){

                patientMedicalHistory.setPreviousInvestigation(updatedPatientMedicalHistory.getPreviousInvestigation());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousInvestigationWhen()))){

                patientMedicalHistory.setPreviousInvestigationWhen(updatedPatientMedicalHistory.getPreviousInvestigationWhen());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousInvestigationProblem()))){

                patientMedicalHistory.setPreviousInvestigationProblem(updatedPatientMedicalHistory.getPreviousInvestigationProblem());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousInvestigationOutcome()))){

                patientMedicalHistory.setPreviousInvestigationOutcome(updatedPatientMedicalHistory.getPreviousInvestigationOutcome());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPreviousInvestigationRecord()))){

                patientMedicalHistory.setPreviousInvestigationRecord(updatedPatientMedicalHistory.getPreviousInvestigationRecord());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getBcg()))){

                patientMedicalHistory.setBcg(updatedPatientMedicalHistory.getBcg());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getDpt()))){

                patientMedicalHistory.setDpt(updatedPatientMedicalHistory.getDpt());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getYellowFever()))){

                patientMedicalHistory.setYellowFever(updatedPatientMedicalHistory.getYellowFever());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPneumococcal()))){

                patientMedicalHistory.setPneumococcal(updatedPatientMedicalHistory.getPneumococcal());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getPolio()))){

                patientMedicalHistory.setPolio(updatedPatientMedicalHistory.getPolio());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getTetanusFemale()))){

                patientMedicalHistory.setTetanusFemale(updatedPatientMedicalHistory.getTetanusFemale());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getTetanusMale()))){

                patientMedicalHistory.setTetanusMale(updatedPatientMedicalHistory.getTetanusMale());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getMeasles()))){

                patientMedicalHistory.setMeasles(updatedPatientMedicalHistory.getMeasles());

            }

            if(StringUtils.isNotBlank((updatedPatientMedicalHistory.getOtherVaccinations()))){

                patientMedicalHistory.setOtherVaccinations(updatedPatientMedicalHistory.getOtherVaccinations());

            }

            patientQueueService.savePatientMedicalHistory(patientMedicalHistory);

        }

    }


