<% ui.decorateWith("appui", "standardEmrPage") %>
<script>
    function strReplace(word) {
        var res = word.replace("[", "");
        res=res.replace("]","");
        return res;
    }

    jQuery(document).ready(function () {
        jq('#givenname').html('<small>'+strReplace('${patient.names.givenName}')+'</small>,<em>surname</em>');
        jq('#names').html('<small>'+strReplace('${patient.names.familyName}')+'</small>,<em>name</em>');
        jq('#location').html('<em>Location</em><span>'+strReplace('${patient.addresses.address1}')+'</span>');

    });
</script>
<div class="patient-header new-patient-header">
    <div class="demographics">
        <h1 class="name">
            <span id="givenname"></span>
            <span id="names"></span>
            <span><small>${patient.gender}</small>,<em>Gender</em></span>
            <span><small>${patient.age} year(s)</small><em>Age</em></span>

        </h1>

        <br>

        <div class="status-container">
            <span class="status active"></span>
            ${visitStatus}
        </div>

        <div class="tag">Outpatient (File Number :)</div>
    </div>

    <div class="identifiers">
        <em>Patient ID</em>
        <span>${patientIdentifier}</span>
        <em>Payment Category</em>
        <span>${category}</span>
    </div>

    <div class="identifiers">
        <em>Date/ Time:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em>
        <span>${previousVisit}</span>

    </div>
    <div class="identifiers" id="location"></div>
</div>

<div class="dashboard-tabs">
    <ul>
        <li><a href="#triage-info">Triage Information</a></li>
        <li><a href="#notes">Clinical Note</a></li>
        <li><a href="#summary">Clinical Summary</a></li>
    </ul>

    <div id="triage-info">
        ${ ui.includeFragment("patientdashboardapp", "triageInfo", [patientId: patientId, opdId: opdId, queueId: queueId]) }
    </div>

    <div id="notes">
        ${ ui.includeFragment("patientdashboardapp", "clinicalNotes", [patientId: patientId, opdId: opdId, queueId: queueId, opdLogId: opdLogId]) }
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
