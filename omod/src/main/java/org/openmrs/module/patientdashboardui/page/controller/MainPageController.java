package org.openmrs.module.patientdashboardui.page.controller;

import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class MainPageController {

	public void get(@RequestParam("patientId") Integer patientId, 
			@RequestParam("opdId") Integer opdId,
			@RequestParam(value = "queueId", required = false) Integer queueId,
			@RequestParam(value = "opdLogId", required = false) Integer opdLogId,
			PageModel model) {
		
		model.addAttribute("patientId", patientId);
		model.addAttribute("opdId", opdId);
		model.addAttribute("queueId", opdId);
		model.addAttribute("opdLogId", opdLogId);
		
	}
}
