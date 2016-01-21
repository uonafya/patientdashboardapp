package org.openmrs.module.patientdashboardui.model;

import org.junit.Test;
import org.openmrs.test.BaseModuleContextSensitiveTest;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Francis on 12/21/2015.
 */
public class NoteModelTest extends BaseModuleContextSensitiveTest {

	@Test
	public void saveNote_shouldSaveNoteWithProcedures() throws Exception {
		executeDataSet("notes-concepts.xml");
		Note note = new Note();
		note.setPatientId(3009);
		List<Procedure> procedures = new ArrayList<Procedure>();
		Procedure procedure = new Procedure(9993, "Allergy Shots");
		procedure.setScheduledDate("18/12/2015");
		procedures.add(procedure);
		note.setProcedures(procedures);
		note.save();
	}
}
