<table id="diagnosis-table">
    <thead>
        <tr>
            <th>Diagnosis Date</th>
            <th>Diagnosis Coded</th>
            <th>Diagnosis Non Coded</th>
            <th>Diagnosis Coded Name</th>
            <th>Certainty</th>
        </tr>
    </thead>
    <tbody>
        <% diagnosis.each {%>
            <tr>
                <td>${ui.formatDatetimePretty(it.encounter.encounterDatetime)}</td>
                <td>${it.diagnosis.coded}</td>
                <td>${it.diagnosis.nonCoded}</td>
                <td>${it.diagnosis.specificName}</td>
                <td>${it.certainty}</td>
            </tr>
        <%
            } %>
    </tbody>
</table>
<script>
var diagnosisTable;
jq(function(){
    diagnosisTable = jq('#diagnosis-table').DataTable({
        searching: false,
        lengthChange: false,
        pageLength: 15,
        jQueryUI: true,
        pagingType: 'full_numbers',
        sort: false,
        dom: 't<"fg-toolbar ui-toolbar ui-corner-bl ui-corner-br ui-helper-clearfix datatables-info-and-pg"ip>',
        language: {
            zeroRecords: 'No Encounter Diagnosis recorded.',
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
