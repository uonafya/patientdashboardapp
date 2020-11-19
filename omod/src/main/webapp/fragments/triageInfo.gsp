<%
	import java.text.DecimalFormat
    def formatter = new DecimalFormat("#0.00")
	
    def returnUrl = ui.pageLink("patientdashboardapp", "main", [patientId: patientId, opdId: opdId, queueId: queueId])
	ui.includeCss("ehrconfigs", "onepcssgrid.css")
%>

<script>
jq(function(){
	jq("#triage-left-menu").on("click", ".triage-summary", function(){
		jq("#triage-detail").html("<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i>")
		var visitDate = jq(this);
		var visitIdnt = jq(visitDate).find(".triage-idnt").val();
		
		jq(".triage-summary").removeClass("selected");
		jq(visitDate).addClass("selected");
		
		jq.getJSON('${ui.actionLink("patientdashboardapp", "triageInfo", "getTriageSummary")}',
				{'Id' :visitIdnt}
		).success(function (data){
			var triageIdTemplate = _.template(jq("#triage-detail-template").html());
			jq("#triage-detail").html(triageIdTemplate(data));
			})
			//console.log(data);
		});
	var Id = jq(".visit-date");
	if (Id.length > 0){
		Id[0].click();
		jq('#cs').show();
		}else{
			jq('#cs').hide();
			}
	});

</script>

<style>
	.donotprint {
		display: none;
	}

	.spacer {

		font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
		font-style: normal;
		font-size: 12px;
	}

	.printfont {
		font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
		font-style: normal;
		font-size: 12px;
	}

	.new-patient-header .identifiers {
		padding-top: 15px;
	}

	ul.left-menu {
		border-color: #ccc #ccc #ccc -moz-use-text-color;
		border-image: none;
		border-style: solid solid solid solid;
		border-width: 1px 1px 1px medium;
	}

	.dashboard .info-body label {
		width: 190px;
		display: inline-block;
		margin-bottom: 5px;
		font-size: 90%;
		font-weight: bold;
	}

	.checks {
		width: 140px !important;
		margin-bottom: 0px !important;
		font-size: 100% !important;
		font-weight: normal !important;
		cursor: pointer;
	}

	input[type="radio"] {
		cursor: pointer;
	}

	.dashboard .action-section {
		margin-top: 35px;
	}	

	#fileNumberRow {
		margin: 2px 0px 10px 0px;
	}

	.status-container {
		padding: 5px 10px 5px 5px;
	}

	.button {
		height: 25px;
		width: 150px !important;
		text-align: center;
		padding-top: 15px !important;
	}

	.toast-item {
		background-color: #222;
	}

	.red-border {
		border: 1px solid #f00 !important;
	}
	.info-body .status.active {
		margin-right: 10px;
	}
	.menu-title a{
		text-decoration: none;
	}
</style>


<div class="onerow">
	    <div style="padding-top: 15px;" class="col15 clear">
        <ul id="triage-left-menu" class="left-menu">
        <% triageInfo.eachWithIndex {summary, index -> %>
        <li class="menu-item triage-summary" visitid="54" >
            <input type="hidden" class="triage-idnt" value="${summary.id}"/>
            <span class="menu-date">
                <i class="icon-time"></i>
                <span id="triageId"></span>
                <span id="visitdate">
                    ${summary.createdOn}
                </span>
            </span>
            
            <span class="menu-title">
                <% if (index == 0) {%>
                    <i class="icon-edit" style="float: left; margin-top: 1px; margin-right: 3px; color: rgb(0, 127, 255); font-weight: bold;"></i>
                    <a style="float: left;" href="${ ui.pageLink('patientdashboardapp', 'triage', [patientId: patientId, opdId: opdId, queueId: queueId, returnUrl: returnUrl]) }">Edit Triage Details</a>
                <% } else {%>
                    <i class="icon-stethoscope"></i>
                    ${summary.outcome?summary.outcome:'No Outcome Yet' }    
                <% } %>
            </span>
            <span class="arrow-border"></span>
            <span class="arrow"></span>
        </li>
        <% } %>
        
            <li style="height: 295px;" class="menu-item" ">
            </li>
        </ul>    
    </div>
	
	<div class="col16 dashboard">
		<div class="info-section" id="triage-detail">
			<div class="info-header">
				<i class="icon-diagnosis"></i>
				<h3>TRIAGE INFORMATION</h3>
			</div>
			
			<div class="info-body" >
                <label><span class="status active"></span>Temperature:</label>
                <span>${triage?.temperature?:"Not Captured"}</span>
                <br>

                <label><span class="status active"></span>Blood Pressure:</label>
                <span>${ triage?.systolic && triage?.daistolic ? triage?.systolic + "/" + triage?.daistolic : "Not Captured" }</span>
                <br>

                <label><span class="status active"></span>Respiratory Rate:</label>
                <span>${triage?.respiratoryRate?:"Not Captured"}</span>
                <br>
				
				<label><span class="status active"></span>Pulse Rate:</label>
                <span>${triage?.pulsRate?:"Not Captured"}</span>
                <br>

                <% if (patient.gender == "F" && patient.age > 10) {%>
                    <label><span class="status active"></span>Last Periods:</label>
                    <span id="lastPeriods">${triage?.lastMenstrualDate ? ui.formatDatePretty(triage?.lastMenstrualDate): "Not Captured"}</span>
                    <br>
                <% } %>

                <label><span class="status active"></span>Oxygen Saturation:</label>
                <span>${triage?.oxygenSaturation? triage.oxygenSaturation.toString() + "%": "Not Captured"}</span>
                <br>

				<label><span class="status active"></span>Height:</label>
				<span>${triage?.height?:"Not Captured"}</span>
				<br>
				
				<label><span class="status active"></span>Weight:</label>
				<span>${triage?.weight?:"Not Captured"}</span>
				<br>
				
				<% if (patient.age >= 2)  {%>
					<label><span class="status active"></span>BMI:</label>
					<span>${(triage && triage.weight && triage.height) ? formatter.format(triage?.weight/((triage?.height/100) * (triage?.height/100))) : "Not Captured"}</span>
					<br>
				<% } %>
				
				<label><span class="status active"></span>M.U.A Circum:</label>
				<span>${triage?.mua?:"Not Captured"}</span>
				<br>
				
				<label><span class="status active"></span>Chest Circum:</label>
				<span>${triage?.chest?:"Not Captured"}</span>
				<br>
				
				<label><span class="status active"></span>Abdominal Circum:</label>
				<span>${triage?.abdominal?:"Not Captured"}</span>
				<br>
				

				<label><span class="status active"></span>Blood Group:</label>
				<span>${triage?.bloodGroup && triage?.rhesusFactor ? triage?.bloodGroup + "/" + triage?.rhesusFactor : "Not Captured"}</span>
				<br>
				
				<label><span class="status active"></span>HIV Status:</label>
				<span>${triage?.pitct ?: "Not Captured"}</span>
				<br>
			</div>
		</div>
	</div>
</div>

<script id="triage-detail-template" type="text/template">
	<div class="info-header">
		<i class="icon-user-md"></i>
		<h3>TRIAGE SUMMARY INFORMATION</h3>
	</div>

	<div class="info-body">
		<label><span class='status active'></span>Temperature:</label>
		<span>{{-temperature}}</span>
		<br>

		<label><span class="status active"></span>Systolic:</label>
		<span>{{-systolic}}</span>
		<br>

		<label><span class="status active"></span>Daistolic:</label>
		<span>{{-daistolic}}</span>
		<br>

		<label><span class="status active"></span>Respiratory Rate:</label>
		<span>{{-respiratoryRate}}</span>
		<br>

		<label><span class="status active"></span>Pulse Rate:</label>
		<span>{{-pulsRate}}</span>
		<br>

		<label><span class="status active"></span>Blood Group:</label>
		<span>{{-bloodGroup}}</span>
		<br>

		<% if (patient.gender == "F" && patient.age > 10) {%>
		<label><span class="status active"></span>Last Menstrual Date:</label>
		<span>{{-lastMenstrualDate}}</span>
		<br>
        <% } %>
		
		<label><span class="status active"></span>Rhesus Factor:</label>
		<span>{{-rhesusFactor}}</span>
		<br>

        <label><span class="status active"></span>HIV Status:</label>
        <span>{{-pitct}}</span>
        <br>
		<label><span class='status active'></span>Oxygen Saturation:</label>
		<span>{{-oxygenSaturation}}</span>
		<br>

		<label><span class="status active"></span>Weight:</label>
		<span>{{-weight}}</span>
		<br>

		<label><span class="status active"></span>Height:</label>
		<span>{{-height}}</span>
		<br>

				<% if (patient.age >= 2)  {%>
					<label><span class="status active"></span>BMI:</label>
					<span>{{-(weight/((height/100)*(height/100)))}}</span>
					<br>
				<% } %>
		

		<label><span class="status active"></span>M.U.A.Circum:</label>
		<span>{{-mua}}</span>
		<br>

		<label><span class="status active"></span>Chest Circum:</label>
		<span>{{-chest}}</span>
		<br>

		<label><span class="status active"></span>Abdominal Circum:</label>
		<span>{{-abdominal}}</span>
		<br>

	</div>
</script>

<div class="clear">&nbsp; </div>


