package org.openmrs.module.patientdashboardapp.fragment.controller;

import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.EhrAppointmentService;
import org.openmrs.module.hospitalcore.model.EhrAppointment;
import org.openmrs.module.hospitalcore.model.EhrAppointmentSimplifier;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
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
            List<EhrAppointment> providersAppointments = new ArrayList<EhrAppointment>(ehrAppointmentService.getEhrAppointmentsByProvider(provider));

            EhrAppointmentSimplifier ehrAppointmentSimplifier;
            for (EhrAppointment ehrAppointment : providersAppointments) {
                ehrAppointmentSimplifier = new EhrAppointmentSimplifier();
                ehrAppointmentSimplifier.setAppointmentType(ehrAppointment.getAppointmentType().getName());
                ehrAppointmentSimplifier.setProvider(ehrAppointment.getTimeSlot().getAppointmentBlock().getProvider().getName());
                ehrAppointmentSimplifier.setStatus(ehrAppointment.getStatus().getName());
                ehrAppointmentSimplifier.setStartTime(Utils.getDateAsString(ehrAppointment.getTimeSlot().getStartDate(), "yyyy-MM-dd HH:mm"));
                ehrAppointmentSimplifier.setAppointmentReason(ehrAppointment.getReason());
                ehrAppointmentSimplifier.setEndTime(Utils.getDateAsString(ehrAppointment.getTimeSlot().getEndDate(), "yyyy-MM-dd HH:mm"));
                ehrAppointmentSimplifierList.add(ehrAppointmentSimplifier);

            }
        }
        model.addAttribute("patientAppointments", ehrAppointmentSimplifierList);
    }
}
