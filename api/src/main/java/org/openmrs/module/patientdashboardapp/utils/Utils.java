package org.openmrs.module.patientdashboardapp.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Utils {

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
}
