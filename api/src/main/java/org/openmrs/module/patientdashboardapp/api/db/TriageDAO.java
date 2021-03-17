package org.openmrs.module.patientdashboardapp.api.db;

import java.util.List;

import org.openmrs.Patient;
import org.openmrs.module.hospitalcore.model.TriagePatientData;

public interface TriageDAO {
	List<TriagePatientData> getPatientTriageData(Patient patient);
	TriagePatientData getPatientTriageData(Integer id);
}
