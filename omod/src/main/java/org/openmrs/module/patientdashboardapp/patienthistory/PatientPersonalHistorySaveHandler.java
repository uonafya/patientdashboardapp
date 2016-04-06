package org.openmrs.module.patientdashboardapp.patienthistory;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.PatientMedicalHistory;
import org.openmrs.module.hospitalcore.model.PatientPersonalHistory;

/**
 * Created by USER on 2/17/2016.
 */
public class PatientPersonalHistorySaveHandler {
    private static PatientPersonalHistory patientPersonalHistory;
    public static void save(PatientPersonalHistory updatedPatientPersonalHistory, Integer patientId) {
        PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);
        patientPersonalHistory = patientQueueService.getPatientPersonalHistoryByPatientId(patientId) == null ? new PatientPersonalHistory() : patientQueueService.getPatientPersonalHistoryByPatientId(patientId);

        if (patientPersonalHistory.getPatientId() == null) {
            patientPersonalHistory.setPatientId(patientId);
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getSmoke())){
            patientPersonalHistory.setSmoke(updatedPatientPersonalHistory.getSmoke());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getSmokeItem())){
            patientPersonalHistory.setSmokeItem(updatedPatientPersonalHistory.getSmokeItem());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getSmokeAverage())){
            patientPersonalHistory.setSmokeAverage(updatedPatientPersonalHistory.getSmokeAverage());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getAlcohol())){
            patientPersonalHistory.setAlcohol(updatedPatientPersonalHistory.getAlcohol());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getAlcoholItem())){
            patientPersonalHistory.setAlcoholItem(updatedPatientPersonalHistory.getAlcoholItem());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getAlcoholAverage())){
            patientPersonalHistory.setAlcoholAverage(updatedPatientPersonalHistory.getAlcoholAverage());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getDrug())){
            patientPersonalHistory.setDrug(updatedPatientPersonalHistory.getDrug());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getDrugItem())){
            patientPersonalHistory.setDrugItem(updatedPatientPersonalHistory.getDrugItem());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getDrugAverage())){
            patientPersonalHistory.setDrugAverage(updatedPatientPersonalHistory.getDrugAverage());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getHivStatus())){
            patientPersonalHistory.setHivStatus(updatedPatientPersonalHistory.getHivStatus());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getExposedHiv())){
            patientPersonalHistory.setExposedHiv(updatedPatientPersonalHistory.getExposedHiv());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getExposedHivFactor())){
            patientPersonalHistory.setExposedHivFactor(updatedPatientPersonalHistory.getExposedHivFactor());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getFamilyHelp())){
            patientPersonalHistory.setFamilyHelp(updatedPatientPersonalHistory.getFamilyHelp());
        }
        if(StringUtils.isNotBlank(updatedPatientPersonalHistory.getOtherHelp())){
            patientPersonalHistory.setOtherHelp(updatedPatientPersonalHistory.getOtherHelp());
        }
        if (StringUtils.isNotBlank(updatedPatientPersonalHistory.getIncomeSource())){
            patientPersonalHistory.setIncomeSource(updatedPatientPersonalHistory.getIncomeSource());
        }
        patientQueueService.savePatientPersonalHistory(patientPersonalHistory);
      }
    }
