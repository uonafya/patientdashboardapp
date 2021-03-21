package org.openmrs.module.patientdashboardapp.model;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.GlobalProperty;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.Person;
import org.openmrs.PersonAttribute;
import org.openmrs.Provider;
import org.openmrs.api.ProviderService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingConstants;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.LabService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.RadiologyCoreService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.DepartmentConcept;
import org.openmrs.module.hospitalcore.model.Lab;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.hospitalcore.model.RadiologyDepartment;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.ConceptService;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Investigation {

    private static Set<Integer> collectionOfLabConceptIds = new HashSet<Integer>();
    private static Set<Integer> collectionOfRadiologyConceptIds = new HashSet<Integer>();

    static {
        List<Lab> labs = Context.getService(LabService.class).getAllLab();
        for (Lab lab : labs) {
            for (Concept labInvestigationCategoryConcept : lab.getInvestigationsToDisplay()) {
                for (ConceptAnswer labInvestigationConcept : labInvestigationCategoryConcept.getAnswers()) {
                    collectionOfLabConceptIds.add(labInvestigationConcept.getAnswerConcept().getConceptId());
                }
            }
        }
        List<RadiologyDepartment> radiologyDepts = Context.getService(RadiologyCoreService.class).getAllRadiologyDepartments();
        for (RadiologyDepartment department : radiologyDepts) {
            for (Concept radiologyInvestigationCategoryConcept : department.getInvestigations()) {
                for (ConceptAnswer radiologyInvestigationConcept : radiologyInvestigationCategoryConcept.getAnswers()) {
                    collectionOfRadiologyConceptIds.add(radiologyInvestigationConcept.getAnswerConcept().getConceptId());
                }
            }
        }
    }

    public Investigation(Integer id, String label) {
        this.id = id;
        this.label = label;
    }

    public Investigation(){

    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    private Integer id;
    private String label;


    public void save(Encounter encounter, String departmentName) throws Exception {
        Concept investigationConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_FOR_INVESTIGATION));
        if (investigationConcept == null) {
            throw new Exception("Investigation concept null");
        }
        BillableService billableService = Context.getService(BillingService.class).getServiceByConceptId(this.getId());
        OpdTestOrder opdTestOrder = new OpdTestOrder();
        opdTestOrder.setPatient(encounter.getPatient());
        opdTestOrder.setEncounter(encounter);
        opdTestOrder.setConcept(investigationConcept);
        opdTestOrder.setTypeConcept(DepartmentConcept.TYPES[2]);
        opdTestOrder.setValueCoded(Context.getConceptService().getConcept(this.getId()));
        opdTestOrder.setCreator(encounter.getCreator());
        opdTestOrder.setCreatedOn(encounter.getDateCreated());
        opdTestOrder.setBillableService(billableService);
        opdTestOrder.setScheduleDate(encounter.getDateCreated());
        opdTestOrder.setFromDept(departmentName);
        if (billableService.getPrice().compareTo(BigDecimal.ZERO) == 0) {
            opdTestOrder.setBillingStatus(1);
        }
        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
        List<PersonAttribute> pas = hcs.getPersonAttributes(encounter.getPatient().getPatientId());

        for (PersonAttribute pa : pas) {
            String attributeValue = pa.getValue();
            if(attributeValue.equals("Non-Paying")){
                opdTestOrder.setBillingStatus(1);
            }
        }


        opdTestOrder = Context.getService(PatientDashboardService.class).saveOrUpdateOpdOrder(opdTestOrder);

        processFreeInvestigations(opdTestOrder, encounter.getLocation());
    }
    public void addObs(Encounter encounter, Obs obsGroup) {
        AdministrationService administrationService = Context
                .getAdministrationService();
        GlobalProperty investigationConceptName = administrationService
                .getGlobalPropertyObject(PatientDashboardConstants.PROPERTY_FOR_INVESTIGATION);
        ConceptService conceptService = Context.getConceptService();

        Concept investigationConceptId = conceptService.getConceptByName(investigationConceptName
                .getPropertyValue());

        Obs obsInvestigation = new Obs();
        obsInvestigation.setObsGroup(obsGroup);
        obsInvestigation.setConcept(investigationConceptId);
        obsInvestigation.setValueCoded(Context.getConceptService().getConcept(this.id));
        obsInvestigation.setCreator(encounter.getCreator());
        obsInvestigation.setDateCreated(encounter.getDateCreated());
        obsInvestigation.setEncounter(encounter);
        obsInvestigation.setPerson(encounter.getPatient());
        encounter.addObs(obsInvestigation);
    }

    private void processFreeInvestigations(OpdTestOrder opdTestOrder, Location encounterLocation) {
        if (opdTestOrder.getBillingStatus() == 1) {
            Integer investigationConceptId = opdTestOrder.getValueCoded().getConceptId();
            if (Investigation.collectionOfLabConceptIds.contains(investigationConceptId)) {
                String labEncounterTypeString = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_LAB_ENCOUNTER_TYPE, "LABENCOUNTER");
                EncounterType labEncounterType = Context.getEncounterService().getEncounterType(labEncounterTypeString);
                Encounter encounter = getInvestigationEncounter(opdTestOrder,
                        encounterLocation, labEncounterType);

                String labOrderTypeId = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_LAB_ORDER_TYPE);
                generateInvestigationOrder(opdTestOrder, encounter, labOrderTypeId);
                Context.getEncounterService().saveEncounter(encounter);
            }

            if (Investigation.collectionOfRadiologyConceptIds.contains(investigationConceptId)) {
                String radiologyEncounterTypeString = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_RADIOLOGY_ENCOUNTER_TYPE, "RADIOLOGYENCOUNTER");
                EncounterType radiologyEncounterType = Context.getEncounterService().getEncounterType(radiologyEncounterTypeString);
                Encounter encounter = getInvestigationEncounter(opdTestOrder,
                        encounterLocation, radiologyEncounterType);

                String labOrderTypeId = Context.getAdministrationService().getGlobalProperty(BillingConstants.GLOBAL_PROPRETY_RADIOLOGY_ORDER_TYPE);
                generateInvestigationOrder(opdTestOrder, encounter, labOrderTypeId);
                Context.getEncounterService().saveEncounter(encounter);
            }
        }
    }


    private void generateInvestigationOrder(OpdTestOrder opdTestOrder,
                                            Encounter encounter, String orderTypeId) {
        Order order = new Order();
        order.setConcept(opdTestOrder.getValueCoded());
        order.setCreator(opdTestOrder.getCreator());
        order.setDateCreated(opdTestOrder.getCreatedOn());
        order.setOrderer(getProvider(opdTestOrder.getCreator().getPerson()));
        order.setPatient(opdTestOrder.getPatient());
        order.setDateActivated(new Date());
        order.setAccessionNumber("0");
        try {
            order.setOrderType(Context.getOrderService().getOrderType(Integer.parseInt(orderTypeId)));
        } catch (NumberFormatException nfe) {
            order.setOrderType(Context.getOrderService().getOrderType(8));
        }
        order.setEncounter(encounter);
        encounter.addOrder(order);
    }

    private Encounter getInvestigationEncounter(OpdTestOrder opdTestOrder,
                                                Location encounterLocation, EncounterType encounterType) {
        List<Encounter> investigationEncounters = Context.getEncounterService().getEncounters(opdTestOrder.getPatient(), null, opdTestOrder.getCreatedOn(), null, null, Arrays.asList(encounterType), null, null, null, false);
        Encounter encounter = null;
        if (investigationEncounters.size() > 0) {
            encounter = investigationEncounters.get(0);
        } else {
            encounter = new Encounter();
            encounter.setCreator(opdTestOrder.getCreator());
            encounter.setLocation(encounterLocation);
            encounter.setDateCreated(opdTestOrder.getCreatedOn());
            encounter.setEncounterDatetime(opdTestOrder.getCreatedOn());
            encounter.setEncounterType(encounterType);
            encounter.setPatient(opdTestOrder.getPatient());
        }
        return encounter;
    }

    private Provider getProvider(Person person) {
        Provider provider = null;
        ProviderService providerService = Context.getProviderService();
        List<Provider> providerList = new ArrayList<Provider>(providerService.getProvidersByPerson(person));
        if(providerList.size() > 0){
            provider = providerList.get(0);
        }
        return provider;
    }

}