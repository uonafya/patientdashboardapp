package org.openmrs.module.patientdashboardapp.fragment.controller.shr;

import ca.uhn.fhir.parser.JsonParser;
import lombok.extern.slf4j.Slf4j;
import org.hl7.fhir.r4.model.Bundle;
import org.hl7.fhir.r4.model.Encounter;
import org.json.JSONException;
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
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;


@Slf4j
public class ShrVisitSummaryFragmentController {
    @Autowired
   EncounterTranslator encounterTranslator;

    public void controller(@FragmentParam("patient") Patient patient, FragmentModel model) throws JSONException {


        PatientIdentifier patientIdentifier = patient.getPatientIdentifier(Context.getPatientService().getPatientIdentifierTypeByUuid(PatientDashboardAppConstants.GP_CLIENT_REGISTRY_IDENTIFIER_ROOT));
        FhirConfig fhirConfig = Context.getRegisteredComponents(FhirConfig.class).get(0);


        // get the patient encounters based on this unique ID
        Bundle patientResourceBundle;
        Bundle encounterResourceBundle;
        Bundle observationResourceBundle;
        org.hl7.fhir.r4.model.Resource fhirResource;
        org.hl7.fhir.r4.model.Resource fhirEncounterResource = null;
        org.hl7.fhir.r4.model.Patient fhirPatient = null;
        org.hl7.fhir.r4.model.Encounter fhirEncounter = null;
        org.hl7.fhir.r4.model.Resource fhirObservationResource;
        org.hl7.fhir.r4.model.Observation fhirObservation;
        List<SimpleObject> vitalObs = new ArrayList<SimpleObject>();
        if(patientIdentifier != null) {
            patientResourceBundle = fhirConfig.fetchPatientResource(patientIdentifier.getIdentifier());

            fhirResource = patientResourceBundle.getEntry().get(0).getResource();
            if(fhirResource.getResourceType().toString().equals("Patient")) {
                fhirPatient = (org.hl7.fhir.r4.model.Patient) fhirResource;
            }
            /*encounterResourceBundle = fhirConfig.fetchEncounterResource(fhirPatient);
            if(encounterResourceBundle != null && encounterResourceBundle.getEntry() != null && encounterResourceBundle.getEntry().get(0) != null) {
                fhirEncounterResource = encounterResourceBundle.getEntry().get(0).getResource();
                if (fhirEncounterResource.getResourceType().toString().equals("Encounter")) {
                    fhirEncounter = (Encounter) fhirEncounterResource;
                }
            }*/

        }
        /*org.openmrs.Encounter encounter = null;
        if(fhirEncounter != null) {
            encounter = (org.openmrs.Encounter) encounterTranslator.toOpenmrsType(fhirEncounter);
            System.out.println("The encounters are >>>"+encounter.getAllObs().size());
        }*/

        if(fhirPatient != null) {
            observationResourceBundle = fhirConfig.fetchObservationResource(fhirPatient);
            if (observationResourceBundle != null && observationResourceBundle.getEntry() != null) {
                for (int i = 0; i < observationResourceBundle.getEntry().size(); i++) {
                    fhirObservationResource = observationResourceBundle.getEntry().get(i).getResource();
                    fhirObservation = (org.hl7.fhir.r4.model.Observation) fhirObservationResource;
                    vitalObs.add(SimpleObject.create(
                            "display",fhirObservation.getCode().getCodingFirstRep().getDisplay(),
                            "value", Utils.getObservationValue(fhirObservation)));
                }
            }
        }

        model.addAttribute("patient", fhirPatient != null? fhirPatient.getBirthDate() : "Not found");
       // model.addAttribute("encounter", encounter != null? encounter.getAllObs() : "No Obs found");
        model.addAttribute("vitals", vitalObs);
    }
}
