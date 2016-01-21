<% ui.decorateWith("appui", "standardEmrPage") %>

<div class="dashboard-tabs">
    <ul>
        <li><a href="#notes">Clinical Note</a></li>
        <li><a href="#summary">Clinical Summary</a></li>
    </ul>
    
    <div id="notes">
        ${ ui.includeFragment("patientdashboardapp", "clinicalNotes", [patientId: patientId, opdId: opdId]) }
    </div>
    
    <div id="summary">
        ${ ui.includeFragment("patientdashboardapp", "visitSummary", [patientId: patientId]) }
    </div>
    
</div>

<script>
jq(function(){
    jq(".dashboard-tabs").tabs();
})
</script>
