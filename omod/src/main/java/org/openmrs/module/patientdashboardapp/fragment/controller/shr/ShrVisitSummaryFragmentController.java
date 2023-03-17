package org.openmrs.module.patientdashboardapp.fragment.controller.shr;

import lombok.extern.slf4j.Slf4j;
import org.hl7.fhir.r4.model.Bundle;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.api.context.Context;
import org.openmrs.module.fhir2.api.translators.EncounterTranslator;
import org.openmrs.module.patientdashboardapp.FhirConfig;
import org.openmrs.module.patientdashboardapp.PatientDashboardAppConstants;
import org.openmrs.module.patientdashboardapp.utils.Utils;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;


@Slf4j
public class ShrVisitSummaryFragmentController {
    @Autowired
   EncounterTranslator encounterTranslator;

    public void controller(@FragmentParam("patient") Patient patient, FragmentModel model) {


        PatientIdentifier patientIdentifier = patient.getPatientIdentifier(Context.getPatientService().getPatientIdentifierTypeByUuid(PatientDashboardAppConstants.GP_CLIENT_REGISTRY_IDENTIFIER_ROOT));
        FhirConfig fhirConfig = Context.getRegisteredComponents(FhirConfig.class).get(0);


        // get the patient encounters based on this unique ID
        Bundle patientResourceBundle;
        Bundle observationResourceBundle;
        org.hl7.fhir.r4.model.Resource fhirResource = null;
        org.hl7.fhir.r4.model.Patient fhirPatient = null;
        org.hl7.fhir.r4.model.Resource fhirObservationResource;
        org.hl7.fhir.r4.model.Observation fhirObservation;
        List<SimpleObject> vitalObs = new ArrayList<SimpleObject>();
        List<SimpleObject> diagnosisObs = new ArrayList<SimpleObject>();
        List<SimpleObject> conditionsObs = new ArrayList<SimpleObject>();
        List<SimpleObject> investigationObs = new ArrayList<SimpleObject>();
        List<SimpleObject> appointmentObs = new ArrayList<SimpleObject>();
        List<SimpleObject> procedureObs = new ArrayList<SimpleObject>();
        if(patientIdentifier != null) {
            patientResourceBundle = fhirConfig.fetchPatientResource(patientIdentifier.getIdentifier());

            if(patientResourceBundle.getEntry() != null && !patientResourceBundle.getEntry().isEmpty()) {
                fhirResource = patientResourceBundle.getEntry().get(0).getResource();
            }
            if(fhirResource != null && fhirResource.getResourceType().toString().equals("Patient")) {
                fhirPatient = (org.hl7.fhir.r4.model.Patient) fhirResource;
            }

        }
        if(fhirPatient != null) {
            observationResourceBundle = fhirConfig.fetchObservationResource(fhirPatient);
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
        }

        model.addAttribute("patient", fhirPatient != null? fhirPatient.getBirthDate() : "Not found");
        model.addAttribute("vitals", vitalObs);
        model.addAttribute("diagnosis", diagnosisObs);
        model.addAttribute("conditions", conditionsObs);
        model.addAttribute("investigations", investigationObs);
        model.addAttribute("appointments", appointmentObs);
        model.addAttribute("procedures", procedureObs);
    }
}
