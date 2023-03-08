package org.openmrs.module.patientdashboardapp.fragment.controller.shr;

import org.hl7.fhir.r4.model.Bundle;
import org.hl7.fhir.r4.model.Encounter;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.api.context.Context;
import org.openmrs.module.patientdashboardapp.FhirConfig;
import org.openmrs.module.patientdashboardapp.PatientDashboardAppConstants;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.fragment.FragmentModel;


public class ShrVisitSummaryFragmentController {

    public void controller(@FragmentParam("patient") Patient patient, FragmentModel model) {


        PatientIdentifier patientIdentifier = patient.getPatientIdentifier(Context.getPatientService().getPatientIdentifierTypeByUuid(PatientDashboardAppConstants.GP_CLIENT_REGISTRY_IDENTIFIER_ROOT));
        FhirConfig fhirConfig = Context.getRegisteredComponents(FhirConfig.class).get(0);


        // get the patient encounters based on this unique ID
        Bundle patientResourceBundle;
        Bundle encounterResourceBundle;
        org.hl7.fhir.r4.model.Resource fhirResource;
        org.hl7.fhir.r4.model.Resource fhirEncounterResource;
        org.hl7.fhir.r4.model.Patient fhirPatient = null;
        org.hl7.fhir.r4.model.Encounter fhirEncounter = null;
        if(patientIdentifier != null) {
            patientResourceBundle = fhirConfig.fetchPatientResource(patientIdentifier.getIdentifier());
            encounterResourceBundle = fhirConfig.fetchEncounterResource(patientIdentifier.getIdentifier());
            fhirResource = patientResourceBundle.getEntry().get(0).getResource();
            if(fhirResource.getResourceType().toString().equals("Patient")) {
                fhirPatient = (org.hl7.fhir.r4.model.Patient) fhirResource;
            }
            fhirEncounterResource = encounterResourceBundle.getEntry().get(0).getResource();
            if(fhirEncounterResource.getResourceType().toString().equals("Encounter")) {
                fhirEncounter = (Encounter) fhirEncounterResource;
            }

        }
        model.addAttribute("patient", fhirPatient != null? fhirPatient.getBirthDate() : "Not found");
        model.addAttribute("encounter", fhirEncounter != null? fhirEncounter.getText() : "Not found");
    }
}
