package org.openmrs.module.patientdashboardui.controller.page;

import java.util.Date;

/**
 * Created by Francis on 12/7/2015.
 */
public class Clinical {

    private Integer id;
    private Date dateOfVisit;
    private String typeOfVisit;
    private String treatingDoctor;
    private String diagnosis;
    private String procedures ;
    private String visitOutcomes;
    private String linkedVisit;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public Date getDateOfVisit() {
        return dateOfVisit;
    }
    public void setDateOfVisit(Date dateOfVisit) {
        this.dateOfVisit = dateOfVisit;
    }
    public String getTypeOfVisit() {
        return typeOfVisit;
    }
    public void setTypeOfVisit(String typeOfVisit) {
        this.typeOfVisit = typeOfVisit;
    }
    public String getTreatingDoctor() {
        return treatingDoctor;
    }
    public void setTreatingDoctor(String treatingDoctor) {
        this.treatingDoctor = treatingDoctor;
    }
    public String getDiagnosis() {
        return diagnosis;
    }
    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }
    public String getProcedures() {
        return procedures;
    }
    public void setProcedures(String procedures) {
        this.procedures = procedures;
    }
    public String getLinkedVisit() {
        return linkedVisit;
    }
    public void setLinkedVisit(String linkedVisit) {
        this.linkedVisit = linkedVisit;
    }
    //	Sagar Bele Date:29-12-2012 Add field of visit outcome for Bangladesh requirement #552
    public String getVisitOutcomes() {
        return visitOutcomes;
    }
    public void setVisitOutcomes(String visitOutcomes) {
        this.visitOutcomes = visitOutcomes;
    }

}
