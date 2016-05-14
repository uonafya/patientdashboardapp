<% 
	ui.decorateWith("appui", "standardEmrPage", [title: "OPD Dashboard"]);
	ui.includeJavascript("patientdashboardapp", "jq.print.js")
	ui.includeCss("patientdashboardapp", "patientdashboardapp.css");
%>
<script>
    jq(document).ready(function () {
		jq(".dashboard-tabs").tabs();	

		<% if (previousVisit) { %>
			jq('.tad').text('Last Visit: ${ui.formatDatetimePretty(previousVisit)}');
		<% } else { %>
			jq('.tad').text('Last Visit: N/A');
		<% } %>
    });
</script>

<style>
	.name {
		color: #f26522;
	}
	input[type="text"], 
	input[type="password"],
	select {
		border: 1px solid #aaa !important;
		border-radius: 2px !important;
		box-shadow: none !important;
		box-sizing: border-box !important;
		height: 38px !important;
		line-height: 18px !important;
		padding: 0px 10px !important;
		width: 100% !important;
	}
	input[type="text"]:focus, textarea:focus{
		outline: 2px none #007fff!important;
		box-shadow: 0 0 2px 0 #888 !important
	}
	textarea{
		width: 97%;
	}
	.append-to-value{
		color: #999;
		float: right;
		left: auto;
		margin-left: -50px;
		margin-top: 5px;
		padding-right: 10px;
		position: relative;
	}
	form h2{
		margin: 10px 0 0;
		padding: 0 5px
	}
	.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
		float: left;
	}
	form label, .form label {
		margin: 5px 0 0;
		padding: 0 5px
	}
	#datetime label{
		display: none;
	}
	.add-on {
		float: right;
		left: auto;
		margin-left: -29px;
		margin-top: 10px;
		position: absolute;
	}
	.dashboard .info-section {
		margin: 0 5px 5px;
	}
	.dashboard .info-body li{
		padding-bottom: 2px;
	}

	.dashboard .info-body li span{
		margin-right:10px;
	}
	.dashboard .info-body li div{
		width: 150px;
		display: inline-block;
	}
	.info-body ul li{
		display:none;
	}
	.simple-form-ui section.focused {
		width: 75%;
	}
	
	.new-patient-header .demographics .gender-age {
		font-size: 14px;
		margin-left: -55px;
		margin-top: 12px;
	}
	.new-patient-header .demographics .gender-age span {
		border-bottom: 1px none #ddd;
	}
	.new-patient-header .identifiers {
		margin-top: 5px;
	}
	.tag {
		padding: 2px 10px;
	}
	.tad {
		background: #666 none repeat scroll 0 0;
		border-radius: 1px;
		color: white;
		display: inline;
		font-size: 0.8em;
		padding: 2px 10px;
	}
	.status-container {
		padding: 5px 10px 5px 5px;
	}
	.catg{
		color: #363463;
		margin: 25px 10px 0 0;
	}
	.ui-tabs {
		margin-top: 5px;
	}
	.simple-form-ui section.focused {
		width: 74.6%;
		min-height: 400px;
	}
	.no-confirmation{
		margin-top: -10px;
	}
	.no-confirmation .label{
		color: #009384;
		cursor: pointer;
		font-size: 1.3em;
		font-weight: normal;
		margin: 10px 0 0;
		padding: 0 5px;
	}
	.col15 {
		min-width: 22%;
		max-width: 22%;
		float: left;
		display: inline-block;
	}
	.col16 {
		display: inline-block;
		float: left;
		width: 730px;
	}
	
	.important{
		color: #f00 !important;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	#summaryTable tr:nth-child(2n),
	#summaryTable tr:nth-child(2n+1){
		background: none;
	}
	#summaryTable{
		margin: -5px 0 -6px 0px;
	}
	#summaryTable tr, 
	#summaryTable th, 
	#summaryTable td {
		border: 		1px none  #eee;
		border-bottom: 	1px solid #eee;
	}
	#summaryTable td:first-child{
		vertical-align: top;
		width: 170px;
	}
	.result-title{
		display: inline-block;
		float: left;
		margin: 0 60px 0 0;
	}
	.result-page{
		display: inline-block;
	}
	.result-page i{
		color: #aaa;
	}
	#person-detail{
		display: none;
	}
</style>

<openmrs:require privilege="Triage Queue" otherwise="/login.htm" redirect="/module/patientqueueapp/queue.page?app=patientdashboardapp.triage"/>
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>

<div class="clear"></div>
<div id="content">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="${ui.pageLink('referenceapplication','home')}">
					<i class="icon-home small"></i></a>
			</li>
			<li>
				<i class="icon-chevron-right link"></i>
				<a href="${ui.pageLink('patientqueueapp','opdQueue', [app:'patientdashboardapp.opdqueue'])}">OPD</a>
			</li>
			<li>
				<i class="icon-chevron-right link"></i>
				Doctor's Review
			</li>
		</ul>
	</div>
	
	<div class="patient-header new-patient-header">
		<div class="demographics">
			<h1 class="name">
				<span id="surname">${patient.familyName},<em>surname</em></span>
				<span id="othname">${patient.givenName} ${patient.middleName?patient.middleName:''}&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em></span>
				
				<span class="gender-age">
					<span>
						<% if (patient.gender == "F") { %>
							Female
						<% } else { %>
							Male
						<% } %>
						</span>
					<span id="agename">${patient.age} years (${ui.formatDatePretty(patient.birthdate)}) </span>
					
				</span>
			</h1>
			
			<br/>
			<div id="stacont" class="status-container">
				<span class="status active"></span>
				Visit Status
			</div>
			<div class="tag">${patientStatus}</div>
			<div class="tad">Last Visit</div>
		</div>

		<div class="identifiers">
			<em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
			<span>${patient.getPatientIdentifier()}</span>
			<br>
			
			<div class="catg">
				<i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small> ${category} 
			</div>
		</div>
		<div class="close"></div>
	</div>
	
	<div class="dashboard-tabs">
		<ul>
			<li id="cn"><a href="#notes">Clinical Notes</a></li>
			<li id="ti"><a href="#triage-info">Triage Information</a></li>
			<li id="cs"><a href="#summary">Clinical Summary</a></li>
			<li id="lr"><a href="#investigations">Lab Reports</a></li>
		</ul>
		
		<div id="notes">
			${ ui.includeFragment("patientdashboardapp", "clinicalNotes", [patientId: patientId, opdId: opdId, queueId: queueId, opdLogId: opdLogId]) }
		</div>

		<div id="triage-info">
			${ ui.includeFragment("patientdashboardapp", "triageInfo", [patientId: patientId, opdId: opdId, queueId: queueId]) }
		</div>
		
		<div id="summary">
			${ ui.includeFragment("patientdashboardapp", "visitSummary", [patientId: patientId]) }
		</div>
		
		<div id="investigations">
            ${ ui.includeFragment("patientdashboardapp", "investigations", [patientId: patientId]) }
		</div>
	</div>
</div>


