package org.openmrs.module.patientdashboardapp.utils;

import org.apache.commons.lang.StringUtils;
import org.openmrs.api.AdministrationService;
import org.openmrs.module.patientdashboardapp.PatientDashboardAppConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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
}
