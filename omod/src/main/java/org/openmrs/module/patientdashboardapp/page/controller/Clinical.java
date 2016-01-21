package org.openmrs.module.patientdashboardapp.page.controller;

import java.util.Date;
import java.util.List;

import org.openmrs.Concept;

/**
 * Created by Francis on 12/7/2015.
 */
public class Clinical {

    private Integer id;
    private Date dateOfVisit;
    private String typeOfVisit;
    private String treatingDoctor;
    private List<Concept> symptoms;
    private List<Concept> diagnosis;
    private String diagnosisNote;
    private List<Concept> procedures;
    private List<String> nonCodedProcedures;
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
    public List<Concept> getSymptoms() {
		return symptoms;
	}
	public void setSymptoms(List<Concept> symptoms) {
		this.symptoms = symptoms;
	}
	public List<Concept> getDiagnosis() {
        return diagnosis;
    }
    public void setDiagnosis(List<Concept> diagnosis) {
        this.diagnosis = diagnosis;
    }
    public String getDiagnosisNote() {
		return diagnosisNote;
	}
	public void setDiagnosisNote(String diagnosisNote) {
		this.diagnosisNote = diagnosisNote;
	}
	public List<Concept> getProcedures() {
        return procedures;
    }
    public void setProcedures(List<Concept> procedures) {
        this.procedures = procedures;
    }
    public List<String> getNonCodedProcedures() {
		return nonCodedProcedures;
	}
	public void setNonCodedProcedures(List<String> nonCodedProcedures) {
		this.nonCodedProcedures = nonCodedProcedures;
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
