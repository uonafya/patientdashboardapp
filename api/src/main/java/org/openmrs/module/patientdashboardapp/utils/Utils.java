package org.openmrs.module.patientdashboardapp.utils;

import org.apache.commons.lang.StringUtils;
import org.openmrs.api.AdministrationService;
import org.openmrs.module.patientdashboardapp.PatientDashboardAppConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.hl7.fhir.r4.model.Quantity;
import org.hl7.fhir.r4.model.CodeableConcept;
import org.hl7.fhir.r4.model.DateTimeType;
import org.hl7.fhir.r4.model.IntegerType;
import org.hl7.fhir.r4.model.StringType;
import org.hl7.fhir.r4.model.BooleanType;


import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Component
public class Utils {

  @Autowired
  @Qualifier("adminService")
  AdministrationService administrationService;

  public static Date getDateInddmmmyyyFromStringObject(String date) throws ParseException {
    return  new SimpleDateFormat("dd/MM/yyyy").parse(date);
  }

  public static Date getDateInddyyyymmddFromStringObject(String date) throws ParseException {
    return  new SimpleDateFormat("yyyy-MM-dd").parse(date);
  }

  public static String getDateAsString(Date date, String formatString) {
    DateFormat dateFormat = new SimpleDateFormat(formatString);
    return  dateFormat.format(date);
  }

  public boolean shrConnectionEnabled() {
    return StringUtils.isNotBlank(getShrServerUrl());
  }

  public String getShrServerUrl() {
    return administrationService.getGlobalProperty(PatientDashboardAppConstants.GP_SHR_SERVER_URL);
  }

  public String getShrUserName() {
    return administrationService.getGlobalProperty(PatientDashboardAppConstants.GP_SHR_USER_NAME);
  }

  public String getShrPassword() {
    return administrationService.getGlobalProperty(PatientDashboardAppConstants.GP_SHR_PASSWORD);
  }

  public static String getObservationValue(org.hl7.fhir.r4.model.Observation fhirObservation) {
    if (fhirObservation != null) {
      if (fhirObservation.getValue() instanceof Quantity) {
        return fhirObservation.getValueQuantity().getValue().toString();
      } else if (fhirObservation.getValue() instanceof CodeableConcept) {
        return fhirObservation.getValueCodeableConcept().getCodingFirstRep().getDisplay();
      } else if (fhirObservation.getValue() instanceof DateTimeType) {
        return fhirObservation.getValueDateTimeType().getValue().toString();
      } else if (fhirObservation.getValue() instanceof IntegerType) {
        return fhirObservation.getValueIntegerType().getValue().toString();
      } else if (fhirObservation.getValue() instanceof BooleanType) {
        return fhirObservation.getValueBooleanType().getValue().toString();
      } else if (fhirObservation.getValue() instanceof StringType) {
        return fhirObservation.getValueStringType().getValue();
      }
    }
    return "";
  }

  public static List<String> vitalConceptNames() {
    return Arrays.asList("Temperature (C)".toLowerCase(),
            "Weight (kg)".toLowerCase(),
            "Height (cm)".toLowerCase(),
            "Systolic blood pressure".toLowerCase(),
            "Diastolic blood pressure".toLowerCase());
  }
  public static List<String> diagnosisConceptNames() {
    return Arrays.asList("Final diagnosis".toLowerCase(),
            "Provisional diagnosis".toLowerCase(),
            "PROBLEM ADDED".toLowerCase(),
            "DIAGNOSIS ADDED".toLowerCase(),
            "PROBLEM LIST".toLowerCase());
  }
  public static List<String> proceduresConceptNames() {
    return Arrays.asList("Procedure performed".toLowerCase(),
            "Procedure outcome".toLowerCase(),
            "Procedure performed (text)".toLowerCase());
  }
}
