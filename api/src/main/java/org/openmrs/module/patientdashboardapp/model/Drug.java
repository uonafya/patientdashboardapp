package org.openmrs.module.patientdashboardapp.model;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.hospitalcore.model.Option;

public class Drug {

	private String drugName;
	private Formulation formulation;
	private Frequency frequency;
	private Integer numberOfDays;
	private String comment;
	private String dosage;
	private Option drugUnit;
	private Option route;

	public Option getDrugUnit() {
		return drugUnit;
	}
	public void setDrugUnit(Option drugUnit) {
		this.drugUnit = drugUnit;
	}
	public String getDosage() {
		return dosage;
	}
	public String getDrugName() {
		return drugName;
	}
	public void setDrugName(String drugName) {
		this.drugName = drugName;
	}
	public Formulation getFormulation() {
		return formulation;
	}
	public void setFormulation(Formulation formulation) {
		this.formulation = formulation;
	}
	public Frequency getFrequency() {
		return frequency;
	}
	public void setFrequency(Frequency frequency) {
		this.frequency = frequency;
	}
	public Integer getNumberOfDays() {
		return numberOfDays;
	}
	public void setNumberOfDays(Integer numberOfDays) {
		this.numberOfDays = numberOfDays;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public void setDosage(String dosage){ this.dosage = dosage;	}
	public Option getRoute() {  return route;    }
	public void setRoute(Option route) {    this.route = route; }

	public void save(Encounter encounter, String referralWardName) {
		InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
		InventoryDrug inventoryDrug = inventoryCommonService.getDrugByName(this.drugName);
		if (inventoryDrug != null) {
			OpdDrugOrder opdDrugOrder = new OpdDrugOrder();
			opdDrugOrder.setPatient(encounter.getPatient());
			opdDrugOrder.setEncounter(encounter);
			opdDrugOrder.setInventoryDrug(inventoryDrug);
			InventoryDrugFormulation inventoryDrugFormulation = inventoryCommonService.getDrugFormulationById(this.formulation.getId());
			opdDrugOrder.setInventoryDrugFormulation(inventoryDrugFormulation);
			Concept frequencyConcept = Context.getConceptService().getConcept(this.frequency.getId());
			opdDrugOrder.setFrequency(frequencyConcept);
			opdDrugOrder.setNoOfDays(this.numberOfDays);
			opdDrugOrder.setComments(this.comment);
			opdDrugOrder.setDosage(this.dosage);
			/* TODO immplement opdDrugOrder.route property in hospitalcore.opdDrugOrder
			opdDrugOrder.setRoute(this.route);*/
            if (drugUnit !=null){
                opdDrugOrder.setDosageUnit(Context.getConceptService().getConcept(this.drugUnit.getId()));
            }
			opdDrugOrder.setCreator(encounter.getCreator());
			opdDrugOrder.setCreatedOn(encounter.getDateCreated());
			opdDrugOrder.setReferralWardName(referralWardName);
			Context.getService(PatientDashboardService.class).saveOrUpdateOpdDrugOrder(opdDrugOrder);
		}
	}
}
