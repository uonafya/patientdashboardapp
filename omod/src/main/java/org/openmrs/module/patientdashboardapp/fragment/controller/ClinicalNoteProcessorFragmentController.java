package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.openmrs.module.patientdashboardapp.model.Note;
import org.openmrs.ui.framework.SimpleObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class ClinicalNoteProcessorFragmentController {

	private static Logger log = LoggerFactory.getLogger(ClinicalNoteProcessorFragmentController.class);

	public SimpleObject processNote(HttpServletRequest request) {
		String noteJSON = request.getParameter("note");
		ObjectMapper mapper = new ObjectMapper();
		try {
			Note note = mapper.readValue(noteJSON, Note.class);
			note.saveInvestigations();
		} catch (JsonParseException e) {
			log.error("Unable to parse JSON string: {}.\n Error: {}", new Object[] { noteJSON, e.getMessage() });
			return SimpleObject.create("status", "fail", "message", e.getMessage());
		} catch (JsonMappingException e) {
			log.error("Unable to map JSON string: {}, to class Note.java.\n Error: {}", new Object[] { noteJSON, e.getMessage() });
			return SimpleObject.create("status", "fail", "message", e.getMessage());
		} catch (IOException e) {
			log.error(e.getMessage());
			return SimpleObject.create("status", "fail", "message",e.getMessage());
		} catch (NullPointerException npe) {
			log.error(npe.getMessage());
			return SimpleObject.create("status", "fail", "message", npe.getMessage());
		}
		
		return SimpleObject.create("status", "success");
	}

}
