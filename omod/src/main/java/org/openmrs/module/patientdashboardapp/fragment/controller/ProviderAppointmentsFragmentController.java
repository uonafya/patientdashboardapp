package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.appointments.model.Appointment;
import org.openmrs.module.ehrconfigs.utils.EhrConfigsUtils;
import org.openmrs.module.hospitalcore.EhrAppointmentService;
import org.openmrs.module.hospitalcore.model.EhrAppointmentSimplifier;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.patientdashboardapp.utils.Utils;
import org.openmrs.ui.framework.fragment.FragmentModel;

import java.util.ArrayList;
import java.util.List;

public class ProviderAppointmentsFragmentController {
    public void controller(FragmentModel model) {
        EhrAppointmentService ehrAppointmentService = Context.getService(EhrAppointmentService.class);
        List<EhrAppointmentSimplifier> ehrAppointmentSimplifierList = new ArrayList<EhrAppointmentSimplifier>();
        User user = Context.getAuthenticatedUser();
        Provider provider = HospitalCoreUtils.getProvider(user.getPerson());
        if(provider != null) {
            List<Appointment> providersAppointments = new ArrayList<Appointment>(ehrAppointmentService.getEhrAppointmentsByProvider(provider));

            EhrAppointmentSimplifier ehrAppointmentSimplifier;
            for (Appointment ehrAppointment : providersAppointments) {
                ehrAppointmentSimplifier = new EhrAppointmentSimplifier();
                ehrAppointmentSimplifier.setAppointmentNumber(ehrAppointment.getAppointmentNumber());
                ehrAppointmentSimplifier.setPatientIdentifier(EhrConfigsUtils.getPreferredPatientIdentifier(ehrAppointment.getPatient()));
                ehrAppointmentSimplifier.setPatientNames(PatientUtils.getFullName(ehrAppointment.getPatient()));
                ehrAppointmentSimplifier.setAppointmentService(ehrAppointment.getService().getName());
                ehrAppointmentSimplifier.setAppointmentServiceType(ehrAppointment.getServiceType().getName());
                ehrAppointmentSimplifier.setStartTime(Utils.getDateAsString(ehrAppointment.getStartDateTime(), "yyyy-MM-dd HH:mm"));
                ehrAppointmentSimplifier.setAppointmentReason(ehrAppointment.getComments());
                ehrAppointmentSimplifier.setEndTime(Utils.getDateAsString(ehrAppointment.getEndDateTime(), "yyyy-MM-dd HH:mm"));
                ehrAppointmentSimplifier.setStatus(ehrAppointment.getStatus().name());
                ehrAppointmentSimplifierList.add(ehrAppointmentSimplifier);

            }
        }
        model.addAttribute("patientAppointments", ehrAppointmentSimplifierList);
    }
}