
<script type="text/javascript">
   var jq = jQuery.noConflict();
</script>
<script type="text/javascript">
    var jq = jQuery;
        jq(function () {
            jq("#providerAppointmentCalendar").DataTable();
        });
</script>
<table border="0" cellpadding="0" cellspacing="0" id="providerAppointmentCalendar" width="100%">
    <thead>
        <tr>
            <th>Appointment Number</th>
            <th>Patient Identifier</th>
            <th>Patient Names</th>
            <th>Appointment Service</th>
            <th>Appointment Service type</th>
            <th>Status</th>
            <th>Appointment reason</th>
            <th>Start time</th>
            <th>End time</th>
        </tr>
    </thead>
    <tbody>
        <% if (patientAppointments.empty) { %>
            <tr>
                <td colspan="9">
                    No records found for specified period
                </td>
            </tr>
        <% } %>
        <% if (patientAppointments) { %>
            <% patientAppointments.each {%>
                <tr>
                    <td>${it.appointmentNumber}</td>
                    <td>${it.patientIdentifier}</td>
                    <td>${it.patientNames}</td>
                    <td>${it.appointmentService}</td>
                    <td>${it.appointmentServiceType}</td>
                    <td>${it.status}</td>
                    <td>${it.startTime}</td>
                    <td>${it.endTime}</td>
                </tr>
            <%}%>
        <%}%>
    </tbody>
</table>