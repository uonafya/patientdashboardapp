package org.openmrs.module.patientdashboardapp;

import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.rest.client.api.IGenericClient;
import ca.uhn.fhir.rest.client.interceptor.BasicAuthInterceptor;
import lombok.extern.slf4j.Slf4j;
import org.hl7.fhir.r4.model.Bundle;
import org.hl7.fhir.r4.model.Patient;
import org.openmrs.module.patientdashboardapp.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
@Slf4j
@Component
public class FhirConfig {

    @Autowired
    private Utils utils;

    @Autowired
    @Qualifier("fhirR4")
    private FhirContext fhirContext;

    public IGenericClient getFhirClient() throws Exception {
        IGenericClient fhirClient = fhirContext.newRestfulGenericClient(utils.getShrServerUrl());
        if (!utils.getShrUserName().isEmpty()) {
            BasicAuthInterceptor authInterceptor = new BasicAuthInterceptor(utils.getShrUserName(),
                    utils.getShrPassword());
            fhirClient.registerInterceptor(authInterceptor);
        }
        return fhirClient;
    }

    public Bundle fetchPatientResource(String identifier) {
        try {
            IGenericClient client = getFhirClient();
            Bundle resource = client.search().forResource("Patient").where(Patient.IDENTIFIER.exactly().code(identifier))
                    .returnBundle(Bundle.class).execute();
            return resource;
        }
        catch (Exception e) {
            log.error(String.format("Failed fetching FHIR resource %s", e));
            return null;
        }
    }

}
