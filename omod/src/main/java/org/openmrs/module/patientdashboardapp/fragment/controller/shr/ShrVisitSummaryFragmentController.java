package org.openmrs.module.patientdashboardapp.fragment.controller.shr;

import lombok.extern.slf4j.Slf4j;
import org.hl7.fhir.r4.model.Bundle;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.api.context.Context;
import org.openmrs.module.fhir2.api.translators.EncounterTranslator;
import org.openmrs.module.patientdashboardapp.EhrFhirConfig;
import org.openmrs.module.patientdashboardapp.PatientDashboardAppConstants;
import org.openmrs.module.patientdashboardapp.utils.Utils;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


@Slf4j
public class ShrVisitSummaryFragmentController {
    @Autowired
   EncounterTranslator encounterTranslator;

    public void controller(@FragmentParam("patientId") Patient patient, FragmentModel model) {

        PatientIdentifier patientIdentifier = null;
        List<PatientIdentifier> patientIdentifierSet = new ArrayList<PatientIdentifier>(Context.getPatientService().getPatientIdentifiers(null, Arrays.asList(Context.getPatientService().getPatientIdentifierTypeByUuid(PatientDashboardAppConstants.GP_CLIENT_REGISTRY_IDENTIFIER_ROOT)), null, Arrays.asList(patient), false));
        if(!patientIdentifierSet.isEmpty()) {
            patientIdentifier = patientIdentifierSet.get(0);
        }
        EhrFhirConfig fhirConfig = Context.getRegisteredComponents(EhrFhirConfig.class).get(0);
        // get the patient encounters based on this unique ID
        Bundle patientResourceBundle;
        Bundle observationResourceBundle;
        Bundle serviceRequestResourceBundle;
        Bundle encounterResourceBundle;
        org.hl7.fhir.r4.model.Resource fhirResource = null;
        org.hl7.fhir.r4.model.Patient fhirPatient = null;
        org.hl7.fhir.r4.model.Resource fhirObservationResource = null;
        org.hl7.fhir.r4.model.Resource fhirServiceRequestResource = null;
        org.hl7.fhir.r4.model.Resource fhirEncounterResource = null;
        org.hl7.fhir.r4.model.Observation fhirObservation = null;
        org.hl7.fhir.r4.model.ServiceRequest fhirServiceRequest = null;
        org.hl7.fhir.r4.model.Encounter fhirEncounter = null;
        List<SimpleObject> vitalObs = new ArrayList<SimpleObject>();
        List<SimpleObject> diagnosisObs = new ArrayList<SimpleObject>();
        List<SimpleObject> conditionsObs = new ArrayList<SimpleObject>();
        List<SimpleObject> investigationObs = new ArrayList<SimpleObject>();
        List<SimpleObject> appointmentObs = new ArrayList<SimpleObject>();
        List<SimpleObject> procedureObs = new ArrayList<SimpleObject>();
        if(patientIdentifier != null) {
            patientResourceBundle = fhirConfig.fetchPatientResource(patientIdentifier.getIdentifier());

            if(patientResourceBundle.getEntry() != null && !patientResourceBundle.getEntry().isEmpty() && patientResourceBundle.getEntry().get(0) != null) {
                fhirResource = patientResourceBundle.getEntry().get(0).getResource();
            }
            if(fhirResource != null && fhirResource.getResourceType().toString().equals("Patient")) {
                fhirPatient = (org.hl7.fhir.r4.model.Patient) fhirResource;
            }
        }
        if(fhirPatient != null) {
            System.out.println("The patient resource is NOT NULL >>"+fhirPatient);
            observationResourceBundle = fhirConfig.fetchObservationResource(fhirPatient);
            serviceRequestResourceBundle = fhirConfig.fetchServiceRequestResource(fhirPatient);
            encounterResourceBundle = fhirConfig.fetchEncounterResource(fhirPatient);
            System.out.println("The encounter resource is >>"+encounterResourceBundle);
            System.out.println("The service request resource is >>"+serviceRequestResourceBundle);
            System.out.println("The observation  resource is >>"+observationResourceBundle);
            if (observationResourceBundle != null && observationResourceBundle.getEntry() != null) {
                for (int i = 0; i < observationResourceBundle.getEntry().size(); i++) {
                    fhirObservationResource = observationResourceBundle.getEntry().get(i).getResource();
                    fhirObservation = (org.hl7.fhir.r4.model.Observation) fhirObservationResource;
                    if(Utils.vitalConceptNames().contains(fhirObservation.getCode().getCodingFirstRep().getDisplay().toLowerCase())) {
                        vitalObs.add(SimpleObject.create(
                                "display", fhirObservation.getCode().getCodingFirstRep().getDisplay(),
                                "value", Utils.getObservationValue(fhirObservation)));
                    }
                    else if(Utils.diagnosisConceptNames().contains(fhirObservation.getCode().getCodingFirstRep().getDisplay().toLowerCase())) {
                        diagnosisObs.add(SimpleObject.create(
                                "display", fhirObservation.getCode().getCodingFirstRep().getDisplay(),
                                "value", Utils.getObservationValue(fhirObservation)));
                    }
                    else if(Utils.proceduresConceptNames().contains(fhirObservation.getCode().getCodingFirstRep().getDisplay().toLowerCase())) {
                        procedureObs.add(SimpleObject.create(
                                "display", fhirObservation.getCode().getCodingFirstRep().getDisplay(),
                                "value", Utils.getObservationValue(fhirObservation)));
                    }
                }
            }
            if(serviceRequestResourceBundle != null && serviceRequestResourceBundle.getEntry() != null) {
                for (int i = 0; i < serviceRequestResourceBundle.getEntry().size(); i++) {
                    fhirServiceRequestResource = serviceRequestResourceBundle.getEntry().get(i).getResource();
                    fhirServiceRequest = (org.hl7.fhir.r4.model.ServiceRequest) fhirServiceRequestResource;
                }
            }
            if(encounterResourceBundle != null && encounterResourceBundle.getEntry() != null) {
                for (int i = 0; i < encounterResourceBundle.getEntry().size(); i++) {
                    fhirEncounterResource = encounterResourceBundle.getEntry().get(i).getResource();
                    fhirEncounter = (org.hl7.fhir.r4.model.Encounter) fhirEncounterResource;
                }
            }
        }

        model.addAttribute("patient", fhirPatient);
        model.addAttribute("vitals", vitalObs);
        model.addAttribute("diagnosis", diagnosisObs);
        model.addAttribute("conditions", conditionsObs);
        model.addAttribute("investigations", investigationObs);
        model.addAttribute("appointments", appointmentObs);
        model.addAttribute("procedures", procedureObs);
        model.addAttribute("fhirObs", fhirObservation);
        model.addAttribute("fhirServiceRequest", fhirServiceRequest);
        model.addAttribute("fhirEncounter", fhirEncounter);
    }
}
