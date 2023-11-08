package org.openmrs.module.patientdashboardapp.utils;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.node.ObjectNode;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
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


import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class Utils {

  @Autowired
  @Qualifier("adminService")
  AdministrationService administrationService;

  public static final String GP_SHR_API_TOKEN = "kenyaemril.fhir.server.token";
  public static final String GP_SHR_SERVER_TOKEN_URL = "kenyaemril.fhir.server.token.url";

  public static final String GP_SHR_OAUTH2_SCOPE = "kenyaemril.fhir.server.oath2.scope";

  private static final Pattern pat = Pattern.compile(".*\"access_token\"\\s*:\\s*\"([^\"]+)\".*");

  public static final String GP_SHR_OAUTH2_CLIENT_SECRET = "kenyaemril.fhir.server.oath2.client.secret";

  public static final String GP_SHR_OAUTH2_CLIENT_ID = "kenyaemril.fhir.server.oath2.client.id";

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

  public static String getShrServerUrl() {
    return Context.getAdministrationService().getGlobalProperty("kenyaemril.fhir.server.url");
  }

  public static String getShrUserName() {
    return Context.getAdministrationService().getGlobalProperty(PatientDashboardAppConstants.GP_SHR_USER_NAME);
  }

  public static String getShrPassword() {
    return Context.getAdministrationService().getGlobalProperty(PatientDashboardAppConstants.GP_SHR_PASSWORD);
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

  public static String getShrToken() {
    //check if current token is valid
    if(isValidShrToken()) {
      return(Context.getAdministrationService().getGlobalProperty(GP_SHR_API_TOKEN));
    } else {
      // Init the auth vars
      boolean varsOk = initAuthVars(getAouthShrServerTokenUrl(),getGpShrOauth2Scope(),getGpShrOauth2ClientSecret(),getGpShrOauth2ClientId());
      if (varsOk) {
        //Get the OAuth Token
        String credentials = getClientCredentials(getAouthShrServerTokenUrl(),getGpShrOauth2Scope(),getGpShrOauth2ClientSecret(),getGpShrOauth2ClientId());
        //Save on global and return token
        if (credentials != null) {
          Context.getAdministrationService().setGlobalProperty(GP_SHR_API_TOKEN, credentials);
          return(credentials);
        }
      }
    }
    return(null);
  }

  private static boolean isValidShrToken() {
    String currentToken = Context.getAdministrationService().getGlobalProperty(GP_SHR_API_TOKEN);
    ObjectMapper mapper = new ObjectMapper();
    try {
      ObjectNode jsonNode = (ObjectNode) mapper.readTree(currentToken);
      if (jsonNode != null) {
        String token = jsonNode.get("access_token").getTextValue();
        if(token != null && token.length() > 0)
        {
          String[] chunks = token.split("\\.");
          Base64.Decoder decoder = Base64.getUrlDecoder();

          String header = new String(decoder.decode(chunks[0]));
          String payload = new String(decoder.decode(chunks[1]));

          ObjectNode payloadNode = (ObjectNode) mapper.readTree(payload);
          long expiryTime = payloadNode.get("exp").getLongValue();
          // reduce expiry by 4 hours
          long updatedExpiryTime = expiryTime - (60*60*4);

          long currentTime = System.currentTimeMillis()/1000;

          // check if expired
          if (currentTime < updatedExpiryTime) {
            return(true);
          } else {
            return(false);
          }
        }
      }
      return(false);
    } catch(Exception e) {
      return(false);
    }
  }

  public static boolean initAuthVars(String strTokenUrl,String strScope, String strClientSecret, String strClientId) {
    if (strTokenUrl == null || strScope == null || strClientSecret == null || strClientId == null) {
      System.err.println("Get oauth data: Please set OAuth2 credentials");
      return (false);
    }
    return (true);
  }

  public static String getAouthShrServerTokenUrl() {
    return Context.getAdministrationService().getGlobalProperty(GP_SHR_SERVER_TOKEN_URL);
  }

  public static String getGpShrOauth2Scope() {
    return Context.getAdministrationService().getGlobalProperty(GP_SHR_OAUTH2_SCOPE);
  }

  private static String getClientCredentials(String strTokenUrl,String strScope, String strClientSecret, String strClientId) {

    String auth = strClientId + ":" + strClientSecret;
    String authentication = Base64.getEncoder().encodeToString(auth.getBytes());
    BufferedReader reader = null;
    HttpsURLConnection connection = null;
    String returnValue = "";
    try {
      StringBuilder parameters = new StringBuilder();
      parameters.append("grant_type=" + URLEncoder.encode("client_credentials", "UTF-8"));
      parameters.append("&");
      parameters.append("scope=" + URLEncoder.encode(strScope, "UTF-8"));
      URL url = new URL(strTokenUrl);
      connection = (HttpsURLConnection) url.openConnection();
      connection.setRequestMethod("POST");
      connection.setDoOutput(true);
      connection.setRequestProperty("Authorization", "Basic " + authentication);
      connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
      connection.setRequestProperty("Accept", "application/json");
      connection.setConnectTimeout(10000); // set timeout to 10 seconds
      PrintStream os = new PrintStream(connection.getOutputStream());
      os.print(parameters);
      os.close();
      reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
      String line = null;
      StringWriter out = new StringWriter(connection.getContentLength() > 0 ? connection.getContentLength() : 2048);
      while ((line = reader.readLine()) != null) {
        out.append(line);
      }
      String response = out.toString();
      Matcher matcher = pat.matcher(response);
      if (matcher.matches() && matcher.groupCount() > 0) {
        returnValue = matcher.group(1);
      } else {
        System.err.println("OAUTH2 Error : Token pattern mismatch");
      }

    }
    catch (Exception e) {
      System.err.println("OAUTH2 - Error : " + e.getMessage());
    }
    finally {
      if (reader != null) {
        try {
          reader.close();
        }
        catch (IOException e) {}
      }
      connection.disconnect();
    }
    return returnValue;
  }

  public static String getGpShrOauth2ClientSecret() {
    return Context.getAdministrationService().getGlobalProperty(GP_SHR_OAUTH2_CLIENT_SECRET);
  }

  public static String getGpShrOauth2ClientId() {
    return Context.getAdministrationService().getGlobalProperty(GP_SHR_OAUTH2_CLIENT_ID);
  }

}
