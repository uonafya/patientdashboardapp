    package org.openmrs.module.patientdashboardapp.patienthistory;

    import org.apache.commons.lang3.StringUtils;
    import org.openmrs.api.context.Context;
    import org.openmrs.module.hospitalcore.PatientQueueService;
    import org.openmrs.module.hospitalcore.model.PatientFamilyHistory;

    /**
     * Created by USER on 2/17/2016.
     */
    public class PatientFamilyHistorySaveHandler {
        private static PatientFamilyHistory patientFamilyHistory;
        public static void save(PatientFamilyHistory updatedPatientFamilyHistory, Integer patientId) {
            PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);
            patientFamilyHistory = patientQueueService.getPatientFamilyHistoryByPatientId(patientId) == null ? new PatientFamilyHistory(): patientQueueService.getPatientFamilyHistoryByPatientId(patientId);
            if (patientFamilyHistory.getPatientId() == null) {
                patientFamilyHistory.setPatientId(patientId);
            }
            if(StringUtils.isNotBlank(updatedPatientFamilyHistory.getFatherStatus())){
                patientFamilyHistory.setFatherStatus(updatedPatientFamilyHistory.getFatherStatus());
            }
            if(StringUtils.isNotBlank(updatedPatientFamilyHistory.getFatherDeathCause())){
                patientFamilyHistory.setFatherDeathCause(updatedPatientFamilyHistory.getFatherDeathCause());
            }
            if(StringUtils.isNotBlank(updatedPatientFamilyHistory.getFatherDeathAge())){
                patientFamilyHistory.setFatherDeathAge(updatedPatientFamilyHistory.getFatherDeathAge());
            }
            if(StringUtils.isNotBlank(updatedPatientFamilyHistory.getMotherStatus())){
                patientFamilyHistory.setMotherStatus(updatedPatientFamilyHistory.getMotherStatus());
            }
            if(StringUtils.isNotBlank(updatedPatientFamilyHistory.getMotherDeathCause())){
                patientFamilyHistory.setMotherDeathCause(updatedPatientFamilyHistory.getMotherDeathCause());
            }
            if (StringUtils.isNotBlank(updatedPatientFamilyHistory.getMotherDeathAge())){
                patientFamilyHistory.setMotherDeathAge(updatedPatientFamilyHistory.getMotherDeathAge());
            }
            if(StringUtils.isNotBlank(updatedPatientFamilyHistory.getSiblingStatus())){
                patientFamilyHistory.setSiblingStatus(updatedPatientFamilyHistory.getSiblingStatus());
            }
            if(StringUtils.isNotBlank(updatedPatientFamilyHistory.getSiblingDeathCause())){
                patientFamilyHistory.setSiblingDeathCause(updatedPatientFamilyHistory.getSiblingDeathCause());
            }
            if (StringUtils.isNotBlank(updatedPatientFamilyHistory.getSiblingDeathAge())){
                patientFamilyHistory.setSiblingDeathAge(updatedPatientFamilyHistory.getSiblingDeathAge());
            }
            if (StringUtils.isNotBlank(updatedPatientFamilyHistory.getFamilyIllnessHistory())){
                patientFamilyHistory.setFamilyIllnessHistory(updatedPatientFamilyHistory.getFamilyIllnessHistory());
            }
            patientQueueService.savePatientFamilyHistory(patientFamilyHistory);
        }

    }
