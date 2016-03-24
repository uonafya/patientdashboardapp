    package org.openmrs.module.patientdashboardapp.patienthistory;

    import org.apache.commons.lang3.StringUtils;
    import org.openmrs.api.context.Context;
    import org.openmrs.module.hospitalcore.PatientQueueService;
    import org.openmrs.module.hospitalcore.model.PatientDrugHistory;

    /**
     * Created by USER on 2/17/2016.
     */
    public class PatientDrugHistorySaveHandler {
        private static PatientDrugHistory patientDrugHistory;
        public static void save(PatientDrugHistory updatedPatientDrugHistory, Integer patientId) {
            PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);
            patientDrugHistory = patientQueueService.getPatientDrugHistoryByPatientId(patientId) == null ? new PatientDrugHistory(): patientQueueService.getPatientDrugHistoryByPatientId(patientId);
            if (patientDrugHistory.getPatientId() == null) {

                patientDrugHistory.setPatientId(patientId);
            }
            if(StringUtils.isNotBlank(updatedPatientDrugHistory.getCurrentMedication())){

                patientDrugHistory.setCurrentMedication(updatedPatientDrugHistory.getCurrentMedication());
            }
            if(StringUtils.isNotBlank(updatedPatientDrugHistory.getMedicationName())){

                patientDrugHistory.setMedicationName(updatedPatientDrugHistory.getMedicationName());
            }
            if (StringUtils.isNotBlank(updatedPatientDrugHistory.getMedicationPeriod())){
                patientDrugHistory.setMedicationPeriod(updatedPatientDrugHistory.getMedicationPeriod());
            }
            if(StringUtils.isNotBlank(updatedPatientDrugHistory.getMedicationReason())){
                patientDrugHistory.setMedicationReason(updatedPatientDrugHistory.getMedicationReason());
            }
            if(StringUtils.isNotBlank(updatedPatientDrugHistory.getMedicationRecord())){
                patientDrugHistory.setMedicationRecord(updatedPatientDrugHistory.getMedicationRecord());
            }
            if(StringUtils.isNotBlank(updatedPatientDrugHistory.getSensitiveMedication())){
                patientDrugHistory.setSensitiveMedication(updatedPatientDrugHistory.getSensitiveMedication());
            }
            if (StringUtils.isNotBlank(updatedPatientDrugHistory.getSensitiveMedicationName())){
                patientDrugHistory.setMedicationName(updatedPatientDrugHistory.getMedicationName());
            }
            if (StringUtils.isNotBlank(updatedPatientDrugHistory.getSensitiveMedicationSymptom())){
                patientDrugHistory.setSensitiveMedicationSymptom(updatedPatientDrugHistory.getSensitiveMedicationSymptom());
            }
            if(StringUtils.isNotBlank(updatedPatientDrugHistory.getInvasiveContraception())){
                patientDrugHistory.setInvasiveContraception(updatedPatientDrugHistory.getInvasiveContraception());
            }
            if(StringUtils.isNotBlank(updatedPatientDrugHistory.getInvasiveContraceptionName())){
                patientDrugHistory.setInvasiveContraceptionName(updatedPatientDrugHistory.getInvasiveContraceptionName());
            }

            patientQueueService.savePatientDrugHistory(patientDrugHistory);

        }


    }


