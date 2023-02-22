package org.openmrs.module.patientdashboardapp.fragment.controller.shr;

import org.hl7.fhir.r4.model.Bundle;
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

        Bundle patientResource = null;

        if(patientIdentifier != null) {
            // get the patient encounters based on this unique ID
            patientResource = fhirConfig.fetchPatientResource(patientIdentifier.getIdentifier());
        }

        model.addAttribute("patient", patientResource);
    }
}
