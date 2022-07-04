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
//Add dialog function
var jq = jQuery;
jq(function () {
	var addvitalsDialog = emr.setupConfirmationDialog({
		dialogOpts: {
			overlayClose: false,
			close: true
		},
		selector: '#new-room-dialog',
		actions: {
			reset: function () {

//make an ajax call to initiate the posting
					addvitalsDialog.close();

			},
			finish: function () {
				addvitalsDialog.close();
			}
		}
	});
	jq("#newVitalsModal").on("click", function (e) {
		e.preventDefault();
		addvitalsDialog.show();
	});
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
<div >
	<button class="btn btn-sm btn-primary float-right mb-3" data-toggle="modal" data-target="#newVitalsModal" id="newVitalsModal">
		Capture new vitals
	</button>
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

<div id="new-room-dialog" class="dialog" style="display:none; width: 1009px;">
	<div class="dialog-header">
		<i class="icon-folder-open"></i>

		<h3>Capture New Vitals</h3>
	</div>

	<div class="dialog-content">
		<form form id="vitalRegistrationForm" method="post">
			<div class="container">
				<div>
					<div id="errorAlert" class="alert" style="display: none"><b>Please correct the following errors:</b><hr>
						<ul id="errorsHere"></ul>
					</div>
				</div>
				<section>
					<div class="onerow" style="padding-top: 10px;">
						<h2 style="border-bottom: 1px solid #008394">Vital Summary</h2>

						<div class="col4">
							<label for="temperature-field"> Temperature <span style="color: #f00 !important;
							padding-left: 5px;">*</span></label>
						</div>

						<div class="col4">
							<label for="systolic-bp-field">Blood Pressure (Systolic)<span style="color: #f00 !important;
							padding-left: 5px;"></span></label>
						</div>

						<div class="col4 last">
							<label for="diastolic-bp-field">Blood Pressure (Diastolic)<span style="color: #f00 !important;
							padding-left: 5px;"></span></label>
						</div>
					</div>
					<div class="onerow">
						<div class="col4">
							<p>
								<input id="temperature-field" class="numeric-range" type="text" max="999" min="0" maxlength="7"  name="triagePatientData.temperature" >
								<span class="append-to-value">..&#8451;</span>
								<span id="fr89981" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p>
								<input id="systolic-bp-field" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4"  name="triagePatientData.systolic" >
								<span id="fr5882" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4 last">
							<p>
								<input id="diastolic-bp-field" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4" name="triagePatientData.daistolic" >
								<span id="fr9945" class="field-error" style="display: none"></span>
							</p>
						</div>
					</div>
					<div class="onerow" style="padding-top: 10px;">
						<div class="col4">
							<label for="resp-rate-field"> Respiratory Rate </label>
						</div>

						<div class="col4">
							<label for="pulse-rate-field"> Pulse Rate </label>
						</div>

						<div class="col4 last">
							<label for="oxygenSaturation-field">Oxygen Saturation </label>
						</div>
					</div>
					<div class="onerow">
						<div class="col4">
							<p>
								<input id="resp-rate-field" class="numeric-range focused" type="text" max="999" min="0" maxlength="7" name="triagePatientData.respiratoryRate">
								<span id="fr1753" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p>
								<input id="pulse-rate-field" class="numeric-range" type="text" max="999" min="0" maxlength="7"  name="triagePatientData.pulsRate">
								<span id="fr8917" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4 last">
							<p>
								<input id="oxygenSaturation-field" class="numeric-range" type="text" max="100" min="0"  name="triagePatientData.oxygenSaturation">
								<span class="append-to-value">%</span>
								<span id="fr8998" class="field-error" style="display: none"></span>
							</p>
						</div>
					</div>
					<div class="onerow">
						<h2>&nbsp;</h2>
						<h2 style="border-bottom: 1px solid #008394">Body Mass Index</h2>

						<div class="col4">
							<label for="weight-field"> Weight </label>
						</div>

						<div class="col4">
							<label for="height-field"> Height </label>
						</div>

						<div class="col4 last">
							<% if (patient.age >= 2) { %>
							<label for="bmi">BMI:</label>
							<% } %>
						</div>
					</div>
					<div class="onerow">
						<div class="col4">
							<p class="left">
								<input id="weight-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7"  name="triagePatientData.weight">
								<span class="append-to-value">kg</span>
								<span id="fr1139" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p class="left">
								<input id="height-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" name="triagePatientData.height">
								<span class="append-to-value">cm</span>
								<span id="fr9875" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4 last">
							<% if (patient.age >= 2) { %>
							<p>
							<div class="bmi" id="bmi"></div>
						</p>
							<% } %>
						</div>
					</div>

					<div class="onerow" style="padding-top: 10px;">
						<h2 style="border-bottom: 1px solid #008394">Circumferences</h2>

						<div class="col4">
							<label for="muac-field"> M.U.A.C </label>
						</div>

						<div class="col4">
							<label for="chest-circum-field"> Chest </label>
						</div>

						<div class="col4 last">
							<label for="abdominal-circum-field"> Abdominal </label>
						</div>
					</div>

					<div class="onerow">
						<div class="col4">
							<p>
								<input id="muac-field" class="number numeric-range" type="text" max="999" min="0" maxlength="3" name="triagePatientData.mua">
								<span class="append-to-value">cm</span>
								<span id="fr801" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p>
								<input id="chest-circum-field" class="number numeric-range" type="text" max="999" min="0" maxlength="3"  name="triagePatientData.chest">
								<span class="append-to-value">cm</span>
								<span id="fr3193" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4 last">
							<p>
								<input id="abdominal-circum-field" class="number numeric-range" type="text" max="999" min="0" maxlength="3"  name="triagePatientData.abdominal">
								<span class="append-to-value">cm</span>
								<span id="fr76" class="field-error" style="display: none"></span>
							</p>
						</div>
					</div>

				</section>
				<div class="onerow" style="margin-top: 100px">

					<a class="button confirm" onclick="PAGE.submit();"
					   style="float:right; display:inline-block; margin-left: 5px;">
						<span>FINISH</span>
					</a>

					<a class="button cancel" onclick="window.location.href = window.location.href"
					   style="float:right; display:inline-block;"/>
					<span>RESET</span>
				</a>
				</div>
			</div>
		</form>
	</div>
</div>
