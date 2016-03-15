<%
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
ui.includeJavascript("patientqueueapp", "jquery.dataTables.min.js")
%>

<table id="investigations-table">
    <thead>
        <tr>
            <th></th>
            <th>Name</th>
            <th>Order Date</th>
            <th>Requested By</th>
        </tr>
    </thead>
    <tbody>
        <% labOrders.each { labOrder -> %>
            <tr data-order-id="${labOrder.orderId}" data-patient-id="${labOrder.patientId}">
                <td class="details-control"><i class="icon-plus small"></i></td>
                <td>${labOrder.orderName}</td>
                <td>${ui.formatDatePretty(labOrder.orderDate)}</td>
                <td>${labOrder.orderer}</td>
            </tr>
        <% } %>

    </tbody>
</table>

<script>
var investigationsTable;

function format ( results ) {
    var display = "RESULTS:<br>";
    if (results.length == 0) {
        display = "NO RESULTS<br>";
    } else {
        jq.each(results, (function(index, result){
            display += result.label + ": " + (result.value || "--")+ "<br>Day Performed: "+(result.datePerformed ) + "<br>";
        }));
    }
    return display;
}

jq(function(){
    investigationsTable = jq('#investigations-table').DataTable({
        searching: false,
        lengthChange: false,
        pageLength: 15,
        jQueryUI: true,
        pagingType: 'full_numbers',
        sort: false,
        dom: 't<"fg-toolbar ui-toolbar ui-corner-bl ui-corner-br ui-helper-clearfix datatables-info-and-pg"ip>',
        language: {
            zeroRecords: 'No Investigations ordered.',
            paginate: {
                first: 'First',
                previous: 'Previous',
                next: 'Next',
                last: 'Last'
            }
        }
    });

    var detailRows = [];

    jq('#investigations tbody').on( 'click', 'tr td.details-control', function () {
        var tr = jq(this).closest('tr');
        var row = investigationsTable.row( tr );
        var idx = jq.inArray( tr.attr('id'), detailRows );
 
        if ( row.child.isShown() ) {
            jq(this).find('.icon-minus').removeClass('icon-minus').addClass('icon-plus');
            row.child.hide();
 
            // Remove from the 'open' array
            detailRows.splice( idx, 1 );
        }
        else {
            console.log(jq(this).find('.icon-plus'));
            jq(this).find('.icon-plus').removeClass('icon-plus').addClass('icon-minus');
            var orderId = tr[0].dataset.orderId;
            var patientId = tr[0].dataset.patientId;
            jq.getJSON(emr.fragmentActionLink("patientdashboardapp", "investigations", "getInvestigationResults", { "orderId": orderId, "patientId": patientId}))
            .success(function (results) {
                row.child(format(results)).show();
                        console.log(results);
            });
 
            // Add to the 'open' array
            if ( idx === -1 ) {
                detailRows.push( tr.attr('id') );
            }
        }
    } );
});
</script>
