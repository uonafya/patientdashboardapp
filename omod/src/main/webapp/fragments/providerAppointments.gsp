<script type="text/javascript">
    var jq = jQuery;
        jq(function () {
            jq("#providerAppointmentCalendar").DataTable({
                   sPaginationType: "full_numbers",
                   bJQueryUI: true,
                   "fnDrawCallback": function ( oSettings ) {
                       /* Need to redo the counters if filtered or sorted */
                       if ( oSettings.bSorted || oSettings.bFiltered )
                       {
                           for ( var i=0, iLen=oSettings.aiDisplay.length ; i<iLen ; i++ )
                           {
                               jq('td:eq(0)', oSettings.aoData[ oSettings.aiDisplay[i] ].nTr ).html( i+1 );
                           }
                       }
                   },
                   "aoColumnDefs": [
                       { "bSortable": false, "aTargets": [ 0 ] }
                   ],
                   "aaSorting": [[ 1, 'asc' ]]
               });
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