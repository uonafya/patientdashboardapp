package org.openmrs.module.patientdashboardapp.api;

import java.util.List;

import org.openmrs.Patient;
import org.openmrs.api.OpenmrsService;
import org.openmrs.module.hospitalcore.model.TriagePatientData;
import org.springframework.transaction.annotation.Transactional;



public interface TriageService extends OpenmrsService {
	/*List<TriagePatientData> getPatientTriageData(Patient patient);
	TriagePatientData getPatientTriageData(Integer id);*/
}
