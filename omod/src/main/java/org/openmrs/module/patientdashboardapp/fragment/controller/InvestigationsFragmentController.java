package org.openmrs.module.patientdashboardapp.fragment.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.patientdashboardapp.model.LabOrderViewModel;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

public class InvestigationsFragmentController {

	public void controller(FragmentConfiguration config, FragmentModel model) {
		config.require("patientId");
		
		Patient patient = Context.getPatientService().getPatient(Integer.valueOf(config.get("patientId").toString()));
		String nameOfLabEncounterType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_LAB_ENCOUTNER_TYPE);
		EncounterType labEncounterType = Context.getEncounterService().getEncounterType(nameOfLabEncounterType);
		List<Encounter> labOrdersEncounters = Context.getEncounterService().getEncounters(patient, null, null, null, null, Arrays.asList(labEncounterType), null, null, null, false);

		List<LabOrderViewModel> labOrders = new ArrayList<LabOrderViewModel>();
		for (Encounter encounter: labOrdersEncounters) {
			for (Order labOrder: encounter.getOrders()) {
				labOrders.add(new LabOrderViewModel(labOrder));

			}
		}
		model.addAttribute("labOrders", labOrders);
			}

	public List<SimpleObject> getInvestigationResults(
			@RequestParam("patientId") Integer patientId,
			@RequestParam("orderId") Integer orderId,
			UiUtils ui
			){
		Patient patient = Context.getPatientService().getPatient(patientId);
		Order labOrder = Context.getOrderService().getOrder(orderId);

		Map<String, String> sortedResults = new TreeMap<String, String>();
		List<SimpleObject> results = new ArrayList<SimpleObject>();
		if (labOrder.getEncounter() != null) {
			for (Obs obs : labOrder.getEncounter().getAllObs()) {
				if (obs.hasGroupMembers()) {
					continue;
				}
				String resultDescription = obs.getConcept().getDisplayString();
				if (obs.getObsGroup() != null) {
					resultDescription = obs.getObsGroup().getConcept().getDisplayString() + " (" + resultDescription + ")";
				}
				String resultValue = obs.getValueAsString(Context.getLocale());
				sortedResults.put(resultDescription, resultValue);
			}
		}
		if (sortedResults.size() == 0) {
			String nameOfLabEncounterType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_LAB_ENCOUTNER_TYPE);
			EncounterType labEncounterType = Context.getEncounterService().getEncounterType(nameOfLabEncounterType);
			List<Encounter> labOrdersEncounters = Context.getEncounterService().getEncounters(patient, null, null, null, null, Arrays.asList(labEncounterType), null, null, null, false);
			Date datePerfomed = null;
			for (Encounter encounter: labOrdersEncounters) {
				for (Obs obs : encounter.getAllObs()) {
					if (obs.getOrder() == null || !obs.getOrder().getOrderId().equals(orderId)) {
						continue;
					}
					String resultDescription = obs.getConcept().getDisplayString();
					if (obs.getObsGroup() != null) {
						resultDescription = obs.getObsGroup().getConcept().getDisplayString() + " (" + resultDescription + ")";
					}
					String resultValue = obs.getValueAsString(Context.getLocale());
					sortedResults.put(resultDescription, resultValue);
					if (datePerfomed == null) {
						datePerfomed = obs.getObsDatetime();
					}
				}
			}
			for (Map.Entry<String, String> result : sortedResults.entrySet()) {
				results.add(SimpleObject.create("label", result.getKey(), "value", result.getValue(), "datePerfomed", ui.formatDatePretty(datePerfomed)));
			}
		}
		return results;
	}
   }
