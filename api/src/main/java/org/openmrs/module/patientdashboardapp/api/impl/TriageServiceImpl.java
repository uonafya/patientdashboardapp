package org.openmrs.module.patientdashboardapp.api.impl;

import java.util.List;

import org.openmrs.Patient;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.openmrs.module.hospitalcore.model.TriagePatientData;
import org.openmrs.module.patientdashboardapp.api.TriageService;
import org.openmrs.module.patientdashboardapp.api.db.TriageDAO;

public class TriageServiceImpl extends BaseOpenmrsService implements TriageService {

	public List<TriagePatientData> getPatientTriageData(Patient patient) {
		// TODO Auto-generated method stub
		return triageDAO.getPatientTriageData(patient);
	}
	private TriageDAO triageDAO;
	
	public void setTriageDAO(TriageDAO triageDAO){
		this.triageDAO = triageDAO;
	}

	public TriagePatientData getPatientTriageData(Integer id) {
		return triageDAO.getPatientTriageData(id);
	}

	
}
