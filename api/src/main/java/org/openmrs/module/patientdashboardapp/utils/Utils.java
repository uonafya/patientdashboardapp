package org.openmrs.module.patientdashboardapp.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Utils {

  public static Date getDateInddmmmyyyFromStringObject(String date) throws ParseException {
    return  new SimpleDateFormat("dd/MM/yyyy").parse(date);
  }
}
