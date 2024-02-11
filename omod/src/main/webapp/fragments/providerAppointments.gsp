<script type="text/javascript">
    var jq = jQuery;
        jq(function () {
            jq('#providerAppointmentCalendar').DataTable({
                 searching: false,
                 lengthChange: false,
                 pageLength: 15,
                 jQueryUI: true,
                 pagingType: 'full_numbers',
                 sort: false,
                 dom: 't<"fg-toolbar ui-toolbar ui-corner-bl ui-corner-br ui-helper-clearfix datatables-info-and-pg"ip>',
                 language: {
                     zeroRecords: 'No appointments recorded.',
                     paginate: {
                         first: 'First',
                         previous: 'Previous',
                         next: 'Next',
                         last: 'Last'
                     }
                 }
             });
        });
</script>
<table id="providerAppointmentCalendar">
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
    </tbody>
</table>