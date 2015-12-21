package org.openmrs.module.patientdashboardui.model;

import org.junit.Ignore;
import org.junit.Test;
import org.openmrs.test.BaseModuleContextSensitiveTest;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Francis on 12/21/2015.
 */
public class NoteModelTest extends BaseModuleContextSensitiveTest {
    @Ignore
    public void saveNote_shouldSaveNote() throws Exception {
        executeDataSet("notes-concepts.xml");
        Note note = new Note();
        note.setPatientId(3009);
        note.setPatientId(3009);
        List<Procedure> procedures = new ArrayList<Procedure>();
        note.setProcedures(procedures);
        note.save();
    }
}
