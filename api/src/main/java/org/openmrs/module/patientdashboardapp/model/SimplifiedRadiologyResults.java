package org.openmrs.module.patientdashboardapp.model;

public class SimplifiedRadiologyResults {

  private String startDate;

  public String getStartDate() {
    return startDate;
  }

  public void setStartDate(String startDate) {
    this.startDate = startDate;
  }

  public String getTestName() {
    return testName;
  }

  public void setTestName(String testName) {
    this.testName = testName;
  }

  public String getResults() {
    return results;
  }

  public void setResults(String results) {
    this.results = results;
  }

  private String testName;
  private String results;

  public String getInvestigation() {
    return investigation;
  }

  public void setInvestigation(String investigation) {
    this.investigation = investigation;
  }

  private String investigation;
}
