<ul class="left-menu">
    <% visitSummaries.each { summary -> %>
        <li class="menu-item visit-summary">
            <input type="hidden" class="encounter-id" value="${summary.encounterId}" >
            <span class="menu-date">
                <i class="icon-time"></i>
                ${ ui.format(summary.visitDate) }
            </span>
            <span class="menu-title">
                <i class="icon-stethoscope"></i>
                <% if (summary.outcome) { %>
                    ${ summary.outcome }
                <% }  else { %>
                    ${ ui.message("patientdashboardapp.noOutcome")}
                <% } %>
            </span>
        </li>
        <span class="arrow-border"></span>
        <span class="arrow"></span>
    <% } %>
</ul>
<div class="main-content">
    <div id="visit-detail"></div>
    <div id="drugs-detail"></div>
</div>

<script>
jq(function(){
    jq("left-menu").on("click", ".visit-summary", function(){
        jq("#visit-detail").html("<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i>")
        var visitSummary = jq(this);
        jq(".visit-summary").removeClass("selected");
        jq(visitSummary).addClass("selected");
        jq.getJSON('${ ui.actionLink("patientdashboardapp", "visitSummary" ,"getVisitSummaryDetails") }',
            { 'encounterId' : jq(visitSummary).find(".encounter-id").val() }
        ).success(function (data) {
            var visitDetailTemplate =  _.template(jq("#visit-detail-template").html());
            jq("#visit-detail").html(visitDetailTemplate(data.notes));

            if (data.drugs.length > 0) {
                var drugsTemplate =  _.template(jq("#drugs-template").html());
                jq("#drugs-detail").html(drugsTemplate(data.drugs));
            }
        })
    });
    var visitSummaries = jq(".visit-summary");
    if (visitSummaries.length > 0) {
        visitSummaries[0].click();
    }
})
</script>

<script id="visit-detail-template" type="text/template">
    <div>
        <p>
            <small>History of Illness</small>
            <span>{{-history}}</span>
        </p>
        <p>
            <small>Symptoms</small>
            <span>{{-symptoms}}</span>
        </p>
        <p>
            <small>Diagnosis</small>
            <span>{{-diagnosis}}</span>
        </p>
        <p>
            <small>Investigations</small>
            <span>{{-investigations}}</span>
        </p>
        <p>
            <small>Procedures</small>
            <span>{{-procedures}}</span>
        </p>
    </div>
</script>

<script id="drugs-template" type="text/template">
    <p>
        <small>Drugs</small>
    </p>
    <table>
        <thead>
            <tr>
                <td>Name</td>
                <td>Unit</td>
                <td>Formulation</td>
                <td>Dosage</td>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>{{-inventoryDrug.name}}</td>
                <td>{{-inventoryDrug.unit.name}}</td>
                <td>{{-inventoryDrugFormulation.name}}</td>
                <td>{{-inventoryDrugFormulation.dozage}}</td>
            </tr>
         </tbody>
    </table>
</script>