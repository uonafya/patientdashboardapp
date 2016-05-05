<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Triage Dashboard"])
	
    ui.includeCss("uicommons", "datetimepicker.css")
	ui.includeCss("patientdashboardapp", "onepcssgrid.css")
	
    ui.includeJavascript("patientdashboardapp", "note.js")
	
	ui.includeJavascript("billingui", "moment.js")
	
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1)
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
%>

<script>
	var NavigatorController;

	var emrMessages = {};

	emrMessages["numericRangeHigh"] = "value should be less than {0}";
	emrMessages["numericRangeLow"] = "value should be more than {0}";
	emrMessages["requiredField"] = "Required Field";
	emrMessages["numberField"] = "Value not a number";

	function isNombre(numb){
	    return !isNaN(parseFloat(numb));
	}
	
	jq(document).ready(function () {
		jq(".lab-tabs").tabs();
		
		jq('#surname').html(strReplace('${patient.names.familyName}')+',<em>surname</em>');
		jq('#othname').html(strReplace('${patient.names.givenName}')+' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em>other names</em>');
		jq('#agename').html('${patient.age} years ('+ moment('${patient.birthdate}').format('DD,MMM YYYY') +')');
		
		jq('.tad').text('Last Visit: '+ moment('${lastVisitDate}').format('DD.MM.YYYY hh:mm')+' HRS');
		
		function strReplace(word) {
			var res = word.replace("[", "");
			res=res.replace("]","");
			return res;
		}

		jq('.col5 input:radio[name]').on('change',function(){
			if (jq(this).attr('name') == "patientMedicalHistory.illnessExisting"){
				if (jq('input[name="patientMedicalHistory.illnessExisting"]:checked', '#notes-form').val() == "Yes"){
					jq('#illness').show(500)
				}
				else {
					jq('#illness').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientMedicalHistory.chronicIllness"){
				if (jq('input[name="patientMedicalHistory.chronicIllness"]:checked', '#notes-form').val() == "Yes"){
					jq('#chronic').show(500)
				}
				else {
					jq('#chronic').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientMedicalHistory.previousAdmission"){
				if (jq('input[name="patientMedicalHistory.previousAdmission"]:checked', '#notes-form').val() == "Yes"){
					jq('#admissions').show(500)
				}
				else {
					jq('#admissions').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientMedicalHistory.previousInvestigation"){
				if (jq('input[name="patientMedicalHistory.previousInvestigation"]:checked', '#notes-form').val() == "Yes"){
					jq('#operations').show(500)
				}
				else {
					jq('#operations').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientDrugHistory.currentMedication"){
				if (jq('input[name="patientDrugHistory.currentMedication"]:checked', '#notes-form').val() == "Yes"){
					jq('#medication').show(500)
				}
				else {
					jq('#medication').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientDrugHistory.sensitiveMedication"){
				if (jq('input[name="patientDrugHistory.sensitiveMedication"]:checked', '#notes-form').val() == "Yes"){
					jq('#sensitives').show(500)
				}
				else {
					jq('#sensitives').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientDrugHistory.invasiveContraception"){
				if (jq('input[name="patientDrugHistory.invasiveContraception"]:checked', '#notes-form').val() == "Yes"){
					jq('#invasives').show(500)
				}
				else {
					jq('#invasives').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientFamilyHistory.fatherStatus"){
				if (jq('input[name="patientFamilyHistory.fatherStatus"]:checked', '#notes-form').val() == "Dead"){
					jq('#father-status').show(500)
				}
				else {
					jq('#father-status').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientFamilyHistory.motherStatus"){
				if (jq('input[name="patientFamilyHistory.motherStatus"]:checked', '#notes-form').val() == "Dead"){
					jq('#mother-status').show(500)
				}
				else {
					jq('#mother-status').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientFamilyHistory.siblingStatus"){
				if (jq('input[name="patientFamilyHistory.siblingStatus"]:checked', '#notes-form').val() == "Dead"){
					jq('#sibling-status').show(500)
				}
				else {
					jq('#sibling-status').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientPersonalHistory.smoke"){
				if (jq('input[name="patientPersonalHistory.smoke"]:checked', '#notes-form').val() == "Yes"){
					jq('#do-smoke').show(500)
				}
				else {
					jq('#do-smoke').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientPersonalHistory.alcohol"){
				if (jq('input[name="patientPersonalHistory.alcohol"]:checked', '#notes-form').val() == "Yes"){
					jq('#do-alcohol').show(500)
				}
				else {
					jq('#do-alcohol').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientPersonalHistory.drug"){
				if (jq('input[name="patientPersonalHistory.drug"]:checked', '#notes-form').val() == "Yes"){
					jq('#do-drugs').show(500)
				}
				else {
					jq('#do-drugs').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientPersonalHistory.exposedHiv"){
				if (jq('input[name="patientPersonalHistory.exposedHiv"]:checked', '#notes-form').val() == "Yes"){
					jq('#do-exposed').show(500)
				}
				else {
					jq('#do-exposed').hide(500)
				}
			}
			else if (jq(this).attr('name') == "patientPersonalHistory.familyHelp"){
				if (jq('input[name="patientPersonalHistory.familyHelp"]:checked', '#notes-form').val() == "Yes"){
					jq('#do-support').show(500)
				}
				else {
					jq('#do-support').hide(500)
				}
			}
		});
		
		jq('.noidnt input:radio[name]').on('change',function(){
			if (jq('input[name="patientMedicalHistory.otherVaccinations"]:checked', '#notes-form').val() == "Yes"){
				jq('#p-otherVaccinations').show(500)
			}
			else {
				jq('#p-otherVaccinations').hide(500)
			}
		});
		
		jq('input:text[id]').on('input',function(event){
			var idd = jq(event.target).attr('id');
			var txt = jq(event.target).val();
            
			if (idd == 'weight-field'){
				if (txt == ''){
					jq('#li01').hide();
				}
				else {
					jq('#li01').show();
					jq('#summ_01').text(jq(event.target).val() +' kgs');
				}
			}
			
			else if (idd == 'height-field'){
				if (txt == ''){
					jq('#li02').hide();
				}
				else {
					jq('#li02').show();
					jq('#summ_02').text(jq(event.target).val() +' cm');
				}
			}
			
			else if (idd == 'muac-field'){
				if (txt == ''){
					jq('#li03').hide();
				}
				else {
					jq('#li03').show();
					jq('#summ_03').text(jq(event.target).val() +' cm');
				}
			}
			
			else if (idd == 'chest-circum-field'){
				if (txt == ''){
					jq('#li04').hide();
				}
				else {
					jq('#li04').show();
					jq('#summ_04').text(jq(event.target).val() +' cm');
				}
			}
			
			else if (idd == 'abdominal-circum-field'){
				if (txt == ''){
					jq('#li05').hide();
				}
				else {
					jq('#li05').show();
					jq('#summ_05').text(jq(event.target).val() +' cm');
				}
			}
			
			else if (idd == 'temperature-field'){
				if (txt == ''){
					jq('#li06').hide();
				}
				else {
					jq('#li06').show();
					jq('#summ_06').html(jq(event.target).val() +' &#8451;');
				}
			}
			
			else if (idd == 'systolic-bp-field'){
				if (txt == ''){
					jq('#li07').hide();
				}
				else {
					jq('#li07').show();
					jq('#summ_07').text(jq(event.target).val());
				}
			}
			
			else if (idd == 'diastolic-bp-field'){
				if (txt == ''){
					jq('#li08').hide();
				}
				else {
					jq('#li08').show();
					jq('#summ_08').text(jq(event.target).val());
				}
			}
			
			else if (idd == 'resp-rate-field'){
				if (txt == ''){
					jq('#li09').hide();
				}
				else {
					jq('#li09').show();
					jq('#summ_09').text(jq(event.target).val());
				}
			}
			
			else if (idd == 'pulse-rate-field'){
				if (txt == ''){
					jq('#li10').hide();
				}
				else {
					jq('#li10').show();
					jq('#summ_10').text(jq(event.target).val());
				}
			}

			else if (idd == 'oxygenSaturation-field'){
				if (txt == ''){
				    jq('#li16').hide();
				}
				else {
				    jq('#li16').show();
				    jq('#summ_16').text(jq(event.target).val().formatToAccounting(2)+'%');
				}
			}
        	});

		jq('#datetime-display').on("change", function (dateText) {
			jq('#li11').show();
			jq('#summ_11').text(jq('#datetime-display').val());
        	});
		
		jq('select').bind('change keyup', function(event) {
            		var idd = jq(event.target).attr('id');
			var txt = jq(event.target).val();
			
			if (idd == 'bloodGroup-field'){
				if (txt == ''){
					jq('#li12').hide();
				}
				else {
					jq('#li12').show();
					jq('#summ_12').text(jq(event.target).val());
				}
			}
			else if (idd == 'rhesusFactor-field'){
				if (txt == ''){
					jq('#li13').hide();
				}
				else {
					jq('#li13').show();
					jq('#summ_13').text(jq(event.target).val());
				}
			}
			else if (idd == 'pitct-field'){
				if (txt == ''){
					jq('#li14').hide();
				}
				else {
					jq('#li14').show();
					jq('#summ_14').text(jq(event.target).val());
				}
			}
			else if (idd == 'room-to-visit'){
				if (txt == ''){
					jq('#li15').hide();
				}
				else {
					jq('#li15').show();
					jq('#summ_15').text(jq('#room-to-visit option:selected').text());
				}
			}
        	});


		
		jq('.col5 input:radio').each(function() {
			var name = jq(this).attr("name");
			if(jq("input:radio[name='"+name+"']:checked").length == 0){
			}
			else if(jq("input:radio[name='"+name+"']:checked").val() == "Yes") {
				jq("input[name='"+name+"'][value='Yes']").attr('checked', 'checked').change();
			}
			else if(jq("input:radio[name='"+name+"']:checked").val() == "Dead") {
				jq("input[name='"+name+"'][value='Dead']").attr('checked', 'checked').change();
			}
		});
		
		jq('.noidnt input:radio').each(function() {
			var name = jq(this).attr("name");
			if(jq("input:radio[name='"+name+"']:checked").length == 0){
				jq("input[name='"+name+"'][value='No']").attr('checked', 'checked').change();
		  	}
		});
	});

	function getFloatValue(source) {
		return isNaN(parseFloat(source)) ? 0 : parseFloat(source);
	}

	jq(function(){
		NavigatorController = new KeyboardController();

		emrMessages["numericRangeHigh"] = "value should be less than {0}";
		emrMessages["numericRangeLow"] = "value should be more than {0}";

		jq("#height-field,#weight-field").change(function () {
			console.log("Value changed.")
			var height = getFloatValue(jq("#height-field").val())/100;
			var weight = getFloatValue(jq("#weight-field").val());
			var bmi = weight/(height * height);
			console.log("BMI " + bmi);
			jq(".bmi").html(String(bmi).formatToAccounting());
			
			console.log(isNombre(bmi));

			if (isNombre(bmi)){
				jq('#li17').show();
				jq('#summ_17').text(String(bmi).formatToAccounting());
			}

        	});


		jq(".next").on("click", function (e) {
			e.preventDefault();
			if (!jq(this).hasClass("disabled")) {
				navigateToQuestion(1);
			}
		});

		jq(".previous").on("click", function (e) {
			e.preventDefault();
			if (!jq(this).hasClass("disabled")) {
				navigateToQuestion(-1);
			}
		});
	});

	function setIllnessHistory () {
		var str = "${patientFamilyHistory?.familyIllnessHistory}";
		var temp = new Array();
		temp = str.split(",");
		jq.each(temp, function (index, value1) {
			jq("input:checkbox[value='" + value1 + "']").attr("checked", true);
		})
	}

	function toggleSelection(){
		var currentModel = selectedModel(NavigatorController.getSections());
		currentModel.toggleSelection();
		NavigatorController.getSections()[NavigatorController.getSections().length - 1]
		NavigatorController.getSections()[0].toggleSelection();
		NavigatorController.getQuestions()[0].toggleSelection();
		NavigatorController.getFields()[0].toggleSelection();
	}

	function strReplace(word) {
		var res = word.replace("null", "");
		res=res.replace("null","");
		return res;
	}		

	function navigateToQuestion(step) {
		var questions = NavigatorController.getQuestions();
		var selectedQuestion = selectedModel(questions);
		var selectedQuestionIndex = _.indexOf(questions, selectedQuestion);
		var nextQuestion = questions[selectedQuestionIndex + step];

		if (!selectedQuestion.isValid()) {
			return;
		}
		selectedQuestion.toggleSelection();
		nextQuestion.toggleSelection();
		selectedModel(selectedQuestion.fields) && selectedModel(selectedQuestion.fields).toggleSelection();
		nextQuestion.fields[0] && nextQuestion.fields[0].toggleSelection();
		if (selectedQuestion.parentSection != nextQuestion.parentSection) {
			selectedQuestion.parentSection.toggleSelection();
			nextQuestion.parentSection.toggleSelection();
		}
	}

</script>

<style>
	.simple-form-ui section fieldset select:focus, 
	.simple-form-ui section fieldset input:focus, 
	.simple-form-ui section #confirmationQuestion select:focus, 
	.simple-form-ui section #confirmationQuestion input:focus, 
	.simple-form-ui #confirmation fieldset select:focus,
	.simple-form-ui #confirmation fieldset input:focus, 
	.simple-form-ui #confirmation #confirmationQuestion select:focus, 
	.simple-form-ui #confirmation #confirmationQuestion input:focus, 
	.simple-form-ui form section fieldset select:focus, 
	.simple-form-ui form section fieldset input:focus, 
	.simple-form-ui form section #confirmationQuestion select:focus, 
	.simple-form-ui form section #confirmationQuestion input:focus, 
	.simple-form-ui form #confirmation fieldset select:focus, 
	.simple-form-ui form #confirmation fieldset input:focus, 
	.simple-form-ui form #confirmation #confirmationQuestion select:focus, 
	.simple-form-ui form #confirmation #confirmationQuestion input:focus{
		outline: 2px none #007fff;
		box-shadow: 0 0 2px 0 #888 !important;
	}
	input[type="text"], 
	input[type="password"],
	select, .bmi {
		border: 1px solid #aaa;
		border-radius: 3px !important;
		box-shadow: none !important;
		box-sizing: border-box !important;
		height: 38px !important;
		line-height: 18px !important;
		padding: 8px 10px !important;
		width: 100% !important;
	}
	.bmi{
		background: #fff none repeat scroll 0 0;
		margin-top: 2px;
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
		margin: 0;
	}
	.col5 {
		width: 15%;
	}
	.col6 {
		border-left: 1px solid #ddd;
		padding-left: 20px;
		width: 80%;
	}
	.col5 input,
	.testbox input{
		margin-top: 12px!important;
		cursor: pointer!important;
	}
	.col5 label, .testbox label{
		cursor: pointer!important;
	}
	.col6 label{
		cursor: pointer!important;
		margin-bottom: 0px!important;
		margin-left: 0px!important;
		padding-left: 0px!important;
	}
	.col6 input{
		margin-top: 0px!important;
	}
	.underline h2{
		padding-bottom: 5px;
		border-bottom: 1px solid #ddd;
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

	.dashboard .info-body li small{
		
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
	.catg {
		color: #363463;
		margin: 40px 10px 0 0;
	}
	.testbox {
		background-color: rgba(0, 0, 0, 0.01);
		border: 1px solid rgba(51, 51, 51, 0.1);
		float: left;
		height: 160px;
		margin: 5px 0 0 5px;
		width: 23.8%;
	}
	.testbox div {
		background: #5b57a6 none repeat scroll 0 0;
		border-bottom: 1px solid rgba(51, 51, 51, 0.1);
		color: #fff;
		margin: -1px;
		padding: 2px 5px;
	}
	.small {
		font-size: 10px;
	}
	.col6 {
		display: none;
	}
</style>

<openmrs:require privilege="Triage Queue" otherwise="/login.htm" redirect="/module/patientqueueapp/queue.page?app=patientdashboardapp.triage"></openmrs:require>
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
				<a href="${ui.pageLink('patientqueueapp', 'triageQueue', [app:'patientdashboardapp.triage'])}">Triage</a>
			</li>
			<li>
				<i class="icon-chevron-right link"></i>
				Capture Vitals
			</li>
		</ul>
	</div>

	<div class="patient-header new-patient-header">
		<div class="demographics">
			<h1 class="name">
				<span id="surname">${patient.names.familyName},<em>surname</em></span>
				<span id="othname">${patient.names.givenName} &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em></span>
				
				<span class="gender-age">
					<span>
						<% if (patient.gender == "F") { %>
							Female
						<% } else { %>
							Male
						<% } %>
						</span>
					<span id="agename">${patient.age} years (15.Oct.1996) </span>
					
				</span>
			</h1>
			
			<br/>
			<div id="stacont" class="status-container">
				<span class="status active"></span>
				Visit Status
			</div>
			<div class="tag">${visitStatus}</div>
			<div class="tad">Last Visit</div>
		</div>

		<div class="identifiers">
			<em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
			<span>${patient.getPatientIdentifier()}</span>
			<br>
			
			<div class="catg">
				<i class="icon-tags small" style="font-size: 16px"></i>${selectedCategory}
			</div>
		</div>
		<div class="close"></div>
	</div>

	<form method="post" id="notes-form" class="simple-form-ui" style="margin-top:10px;">
		<input type="hidden" value="${returnUrl?:""}" name="returnUrl" >
		<section>
			<span class="title">Vital Stats</span>
			<fieldset>
				<legend>Vitals</legend>
					<div>
			                        <div class="onerow" style="padding-top: 10px;">
							<h2 style="border-bottom: 1px solid #008394">Vital Summary</h2>
							
							<div class="col4">
								<label for="temperature-field"> Temperature </label>
							</div>
							
							<div class="col4">
								<label for="systolic-bp-field">Blood Pressure (Systolic)</label>
							</div>
							
							<div class="col4 last">
								<label for="diastolic-bp-field">Blood Pressure (Diastolic)</label>
							</div>
						</div>

			                        <div class="onerow">
							<div class="col4">
								<p>
									<input id="temperature-field" class="numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.temperature?:''}" name="triagePatientData.temperature">
									<span class="append-to-value">..&#8451;</span>
									<span id="fr8998" class="field-error" style="display: none"></span>
								</p>
							</div>
							
							<div class="col4">
								<p>
									<input id="systolic-bp-field" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4" value="${vitals?.systolic?:''}" name="triagePatientData.systolic">
									<span id="fr5882" class="field-error" style="display: none"></span>
								</p>
							</div>
							
							<div class="col4 last">
								<p>
									<input id="diastolic-bp-field" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4" value="${vitals?.daistolic?:''}" name="triagePatientData.daistolic">
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
			
				                        <div class="col4 last>
				                                <label for="oxygenSaturation-field">Oxygen Saturation </label>
				                        </div>
			                        </div>

					<div class="onerow">
						<div class="col4">
							<p>
		                                    		<input id="resp-rate-field" class="numeric-range focused" type="text" max="999" min="0" maxlength="7" value="${vitals?.respiratoryRate?:''}" name="triagePatientData.respiratoryRate">
								<span id="fr1753" class="field-error" style="display: none"></span>
		                                	</p>
						</div>
		
		                        	<div class="col4">
							<p>
								<input id="pulse-rate-field" class="numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.pulsRate?:''}" name="triagePatientData.pulsRate">
								<span id="fr8917" class="field-error" style="display: none"></span>
							</p>
		                            	</div>
		
		                            	<div class="col4 last">
			                                <p>
				                                <input id="oxygenSaturation-field" class="numeric-range" type="text" max="100" min="0" value="${vitals?.oxygenSaturation?:''}" name="triagePatientData.oxygenSaturation">
				                                <span class="append-to-value">%</span>
				                                <span id="fr8998" class="field-error" style="display: non"></span>
			                                </p>
		                            	</div>
		                        </div>

		                        <div class="onerow">
		                        	<div class="col4 last">
			                              	<% if (patient.gender == "F" && patient.age > 10)  { %>
			                                	<label for="datetime-display"> Last Menstrual Period </label>
			                                <% } %>
		                            	</div>
		                        </div>
		
		                        <div class="onerow">
						<div class="col4">
							<p>
								<% if (patient.gender == "F" && patient.age > 10)  { %>
									${ui.includeFragment("uicommons", "field/datetimepicker", [
						                                id: 'datetime',
						                                label: '',
						                                formFieldName: 'triagePatientData.lastMenstrualDate',
						                                initialValue: vitals?.lastMenstrualDate?:'',
						                                useTime: false,
						                                defaultToday: false,
						                                endDate: new Date()])
					                                }
								<% } %>
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
								<input id="weight-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.weight?:''}" name="triagePatientData.weight">
								<span class="append-to-value">kg</span>
								<span id="fr1139" class="field-error" style="display: none"></span>
							</p>
						</div>
		
		                        	<div class="col4">
		                                	<p class="left">
		                                    		<input id="height-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.height?:''}" name="triagePatientData.height">
		                                    		<span class="append-to-value">cm</span>
		                                    		<span id="fr9875" class="field-error" style="display: none"></span>
		                                	</p>
		                            	</div>
		
		                            	<div class="col4 last">
		                                	<% if (patient.age >= 2) { %>
		                                		<p>
		                                    			<div class="bmi"></div>
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
								<input id="muac-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.mua?:''}" name="triagePatientData.mua">
								<span class="append-to-value">cm</span>
								<span id="fr801" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4">
							<p>
								<input id="chest-circum-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.chest?:''}" name="triagePatientData.chest">
								<span class="append-to-value">cm</span>
								<span id="fr3193" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4 last">
							<p>
								<input id="abdominal-circum-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.abdominal?:''}" name="triagePatientData.abdominal">
								<span class="append-to-value">cm</span>
								<span id="fr76" class="field-error" style="display: none"></span>
							</p>
						</div>
		                        </div>

					<div class="onerow" style="margin-top: 50px">
						<div class="col4">&nbsp;</div>
						<div class="col4">&nbsp;</div>
						<div class="col4 last">
							<a class="button next confirm" style="float:right; display:inline-block;margin-right:5px;" >
								<span>NEXT PAGE</span>
							</a>
						</div>
					</div>
				</div>
			</fieldset>
			
			
			<fieldset>
				<legend>B-G/HIV Status</legend>
				<div>
					<div class="onerow">
						
						
						<div class="col4">
							<label for="bloodGroup-field"> Blood Group </label>
						</div>
						
						<div class="col4">
							<label for="rhesusFactor-field"> Rhesus Factor</label>
						</div>
						
						<div class="col4 last">
							<label for="pitct-field">&nbsp;</label>
						</div>
					</div>
					
					<div class="onerow">
						<div class="col4">
							<p id="bloodGroup">
								<select id="bloodGroup-field" class="focused" name="triagePatientData.bloodGroup">
									<option value="">- Please select -</option>
									<option value="O">O</option>
									<option value="A">A</option>
									<option value="B">B</option>
									<option value="AB">AB</option>
									<option value="Not Known">Not Known</option>
								</select>
								<span id="fr1924" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4">
							<p id="rhesusFactor">
								<select id="rhesusFactor-field" name="triagePatientData.rhesusFactor">
									<option value="">- Please select -</option>
									<option value="Positive (+)">Positive (+)</option>
									<option value="Negative (-)">Negative (-)</option>
									<option value="Not Known">Not Known</option>
								</select>
								<span id="fr2550" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4 last">
							
						</div>
					</div>
					
					<div class="onerow" style="margin-top:50px">
						<div class="col4 last">
							<label for="pitct-field">HIV Status </label>
						</div>
						
						<div class="col4">&nbsp;</div>						
						<div class="col4">&nbsp;</div>
					</div>
					
					<div class="onerow">
						<div class="col4">
							<p id="pitct">
								<select id="pitct-field" class="focused" name="triagePatientData.pitct">
									<option value=""							>- Please select -</option>
									<option value="Known Positive"				>Known Positive</option>
									<option value="Positive at time of visit"	>Positive at time of visit</option>
									<option value="Negative"					>Negative</option>
									<option value="Not Known"					>Not Known</option>
								</select>
								<span id="fr4863" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4">&nbsp;</div>
						<div class="col4 last">&nbsp;</div>						
					</div>
					
					<div class="onerow" style="margin-top: 50px">
						<div class="col4" style="padding-left: 5px">
							<a class="button previous task" >
								<span style="padding: 15px;">PREVIOUS</span>
							</a>
						</div>
						<div class="col4">&nbsp;</div>
						<div class="col4 last">
							<a class="button next confirm" style="float:right; display:inline-block;margin-right:5px;" >
								<span>NEXT PAGE</span>
							</a>
						</div>
					</div>
				</div>
			</fieldset>
			
			<% if (!inOpdQueue) {%>
				<fieldset>
					<legend>Room to Visit</legend>
					<div>
						<div class="onerow">
							<h2>Room to Visit</h2>
							
							<div class="col4">
								<p>
									<select id="room-to-visit" name="roomToVisit" class="required">
										<option value="">-Please select-</option>
										<% listOPD.each { opd -> %>
											<option value="${opd.answerConcept.id }">${opd.answerConcept.name}</option>
										<% } %>
									</select>
									<span id="fr3417" class="field-error" style="display: none"></span>
								</p>
							</div>
							
							<div class="col4">
								&nbsp;
							</div>
							
							<div class="col4 last">
								&nbsp;
							</div>
						</div>
						
						<div class="onerow" style="margin-top: 50px">
							<div class="col4" style="padding-left: 5px">
								<a class="button previous task" >
									<span style="padding: 15px;">PREVIOUS</span>
								</a>
							</div>
							<div class="col4">&nbsp;</div>
							<div class="col4 last">
								<a class="button next confirm" style="float:right; display:inline-block;margin-right:5px;" >
									<span>NEXT PAGE</span>
								</a>
							</div>
						</div>
					</div>
                		</fieldset>
        		<% } %>
        	</section>
		
        	<section>
        		<span class="title">Patient History</span>
        		<fieldset>
                		<legend>Medical and Surgical</legend>
                		<span> </span>
                		<div>
                    			<div class="onerow underline">
						<h2>Any existing illness/ conditions?</h2>
						<div class="col5">
							<p>
								<label>
									<input type="radio" name="patientMedicalHistory.illnessExisting" value="Yes" id="illnessExisting" <% if (patientMedicalHistory?.illnessExisting == "Yes") { %> checked="checked" <% } %>/>
									Yes 
								</label>
							</p>
								
							<p>
								<label>
									<input type="radio" name="patientMedicalHistory.illnessExisting" value="No"  <% if (patientMedicalHistory?.illnessExisting == "No") { %> checked="checked" <% } %>/>
									No 
								</label>
							</p>
						</div>
						
						<div id="illness" class="col6 last">
							<p>
								<label>What is the problem?</label>
								<input type="text"id="illnessProblem" name="patientMedicalHistory.illnessProblem" value="${patientMedicalHistory?.illnessProblem ?: ""}">
							</p>
							
							<p>
								<label>How long have you had it?</label>
								<input type="text"id="illnessLong" name="patientMedicalHistory.illnessLong" value="${patientMedicalHistory?.illnessLong ?: ""}">
							</p>
							
							<p>
								<label>How is your progress?</label> 
								<input type="text" id="illnessProgress" name="patientMedicalHistory.illnessProgress" value="${patientMedicalHistory?.illnessProgress ?: ""}">
							</p>
							
							<p>
								<label>Where are the Medical Records? </label>
								<input type="text" id="illnessRecord"name="patientMedicalHistory.illnessRecord" value="${patientMedicalHistory?.illnessRecord ?: ""}">
							</p>
						</div>
					</div>
					
                    			<div class="onerow underline" style="padding-top: 20px;">
                        			<h2>Suffered from any chronic illness?</h2>
						
						<div class="col5">
							<p><label><input type="radio" name="patientMedicalHistory.chronicIllness" value="Yes" id="chronicIllness" <% if (patientMedicalHistory?.chronicIllness == "Yes") { %> checked="checked" <% } %>/>Yes </label></p>
							<p><label><input type="radio" name="patientMedicalHistory.chronicIllness" value="No"  <% if (patientMedicalHistory?.chronicIllness == "No") { %> checked="checked" <% } %>/>No</label></p>
						</div>
						

                        			<div class="col6 last" id="chronic">
                            				<p>
								<label>What is the problem?</label>
								<input type="text" id="chronicIllnessProblem" name="patientMedicalHistory.chronicIllnessProblem" value="${patientMedicalHistory?.chronicIllnessProblem ?: ""}">
							</p>
							
							<p>
								<label>How long have you had it?</label>
								<input type="text" id="chronicIllnessOccure" name="patientMedicalHistory.chronicIllnessOccure" value="${patientMedicalHistory?.chronicIllnessOccure ?: ""}">
							</p>
							
							<p>
								<label>How is your progress?</label>
								<input type="text" id="chronicIllnessOutcome" name="patientMedicalHistory.chronicIllnessOutcome" value="${patientMedicalHistory?.chronicIllnessOutcome ?: ""}">
							</p>
							
							<p>
								<label>Where are the Medical Records?</label>
								<input type="text" id="chronicIllnessRecord" name="patientMedicalHistory?.chronicIllnessRecord" value="${patientMedicalHistory?.chronicIllnessRecord ?: ""}">
							</p>
                        			</div>
                    			</div>
					
                    			<div class="onerow underline" style="padding-top: 20px;">
                        			<h2> Any previous hospital admissions?</h2>
						<div class="col5">
							<p><label><input id="previousAdmission" type="radio" value="Yes" name="patientMedicalHistory.previousAdmission"<% if (patientMedicalHistory?.previousAdmission == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
                            				<p><label><input type="radio"  value="No" name="patientMedicalHistory.previousAdmission"<% if (patientMedicalHistory?.previousAdmission == "No") { %> checked="checked" <% } %>/>No</label></p>
						</div>
						
                        			<div class="col6 last" id="admissions">
							<p>
								<label>When was this?</label>
								<input type="text" id="previousAdmissionWhen" name="patientMedicalHistory.previousAdmissionWhen" value="${patientMedicalHistory?.previousAdmissionWhen ?: ""}">
							</p>
							
							<p>
								<label>What was the problem?</label>
								<input type="text" id="previousAdmissionProblem" name="patientMedicalHistory.previousAdmissionProblem" value="${patientMedicalHistory?.previousAdmissionProblem ?: ""}">
							</p>
							
							<p>
								<label>What was the outcome?</label>
								<input type="text" id="previousAdmissionOutcome" name="patientMedicalHistory.previousAdmissionOutcome" value="${patientMedicalHistory?.previousAdmissionOutcome ?: ""}">
							</p>
							
							<p>
								<label>Where are the Medical Records?</label>
								<input type="text" id="previousAdmissionRecord" name="patientMedicalHistory.previousAdmissionRecord" value="${patientMedicalHistory?.previousAdmissionRecord ?: ""}">
							</p>
						</div>
                    			</div>
					
                    			<div class="onerow underline" style="padding-top: 20px;">
                        			<h2>Any previous Operations / Investigations?</h2>
						<div class="col5">
							<p><label><input id="previousInvestigation" type="radio" value="Yes" name="patientMedicalHistory.previousInvestigation"<% if (patientMedicalHistory?.previousInvestigation == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
							<p><label><input type="radio" value="No" name="patientMedicalHistory.previousInvestigation"<% if (patientMedicalHistory?.previousInvestigation == "No") { %> checked="checked" <% } %>/>No</label></p>
						</div>
					
						<div class="col6 last" id="operations">
							<p>
								<label>When was this?</label>
								<input type="text" id="previousInvestigationWhen" name="patientMedicalHistory.previousInvestigationWhen" value="${patientMedicalHistory?.previousInvestigationWhen ?: ""}">
							</p>
							
							<p>
								<label>What was the problem?</label>
								<input type="text" id="previousInvestigationProblem" name="patientMedicalHistory.previousInvestigationProblem" value="${patientMedicalHistory?.previousInvestigationProblem ?: ""}">
							</p>
							
							<p>
								<label>What was the outcome?</label>
								<input type="text" id="previousInvestigationOutcome" name="patientMedicalHistory.previousInvestigationOutcome" value="${patientMedicalHistory?.previousInvestigationOutcome ?: ""}">
							</p>
							
							<p>
								<label>Where are the Medical Records?</label>
								<input type="text" id="previousInvestigationRecord" name="patientMedicalHistory.previousInvestigationRecord" value="${patientMedicalHistory?.previousInvestigationRecord ?: ""}">
							</p>
						</div>
                    			</div>
					
                    			<div class="onerow underline" style="padding-top: 20px;">
                        			<h2>Any previous Tests / Vaccines? </h2>
						<div class="testbox">
							<div><i class="icon-diagnosis small"> </i> B.C.G ?</div>
							
							<p><label><input id="bcg" type="radio" value="Yes" name="patientMedicalHistory.bcg"<% if (patientMedicalHistory?.bcg == "Yes") { %> checked="checked" <% } %>/>Yes </label></p> 
							<p><label><input type="radio" value="No" name="patientMedicalHistory.bcg" <% if (patientMedicalHistory?.bcg == "No") { %> checked="checked" <% } %>/>No</label></p>
							<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.bcg" <% if (patientMedicalHistory?.bcg == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>
						</div>
						
						<div class="testbox">
							<div><i class="icon-diagnosis small"> </i> 3 Polio Doses?</div>
							
							<p><label><input type="radio" value="Yes" name="patientMedicalHistory.polio"<% if (patientMedicalHistory?.polio == "Yes") { %> checked="checked" <% } %>/>Yes </label></p> 
							<p><label><input type="radio" value="No" name="patientMedicalHistory.polio" <% if (patientMedicalHistory?.polio == "No") { %> checked="checked" <% } %>/>No</label></p> 
							<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.polio" <% if (patientMedicalHistory?.polio == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>
						</div>
						
						<div class="testbox">
							<div><i class="icon-diagnosis small"> </i> 3DPT Doses?</div>
							
							<p><label><input type="radio" value="Yes" name="patientMedicalHistory.dpt"<% if (patientMedicalHistory?.dpt == "Yes") { %> checked="checked" <% } %>/>Yes</label></p> 
							<p><label><input type="radio" value="No" name="patientMedicalHistory.dpt"<% if (patientMedicalHistory?.dpt == "No") { %> checked="checked" <% } %>/>No</label></p> 
							<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.dpt"<% if (patientMedicalHistory?.dpt == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>
						</div>
						
						<div class="testbox">
							<div><i class="icon-diagnosis small"> </i> Measles ?</div>
							
							<p><label><input type="radio" value="Yes" name="patientMedicalHistory.measles"<% if (patientMedicalHistory?.measles == "Yes") { %> checked="checked" <% } %>/>Yes </label></p> 
							<p><label><input type="radio" value="No" name="patientMedicalHistory.measles" <% if (patientMedicalHistory?.measles == "No") { %> checked="checked" <% } %>/>No</label></p> 
							<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.measles"<% if (patientMedicalHistory?.measles == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>
						</div>
						
						<div class="testbox">
							<div><i class="icon-diagnosis small"> </i> Pneumococcal?</div>
							
							<p><label><input type="radio" value="Yes" name="patientMedicalHistory.pneumococcal"<% if (patientMedicalHistory?.pneumococcal == "Yes") { %> checked="checked" <% } %>/>Yes </label></p> 
							<p><label><input type="radio" value="No" name="patientMedicalHistory.pneumococcal" <% if (patientMedicalHistory?.pneumococcal == "No") { %> checked="checked" <% } %>/>No</label></p> 
							<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.pneumococcal"<% if (patientMedicalHistory?.pneumococcal == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>
						</div>
						
						<div class="testbox">
							<div><i class="icon-diagnosis small"> </i> Yellow Fever??</div>
							
							<p><label><input type="radio" value="Yes" name="patientMedicalHistory.yellowFever"<% if (patientMedicalHistory?.yellowFever == "Yes") { %> checked="checked" <% } %>/>Yes</label></p> 
							<p><label><input type="radio" value="No" name="patientMedicalHistory.yellowFever" <% if (patientMedicalHistory?.yellowFever == "No") { %> checked="checked" <% } %>/>No</label></p> 
							<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.yellowFever"<% if (patientMedicalHistory?.yellowFever == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>
						</div>
						
						<div class="testbox">
							<% if (patient.gender == "F")  { %>
								<div><i class="icon-diagnosis small"> </i> 5 Tetanus Doses?</div>
								
								<p><label><input type="radio" value="Yes" name="patientMedicalHistory.tetanusFemale"<% if (patientMedicalHistory?.tetanusFemale == "Yes") { %> checked="checked" <% } %>/>Yes </label></p> 
								<p><label><input type="radio" value="No" name="patientMedicalHistory.tetanusFemale"<% if (patientMedicalHistory?.tetanusFemale == "No") { %> checked="checked" <% } %>/>No</label></p>
                                				<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.tetanusFemale"<% if (patientMedicalHistory?.tetanusFemale == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>

							<% } else { %>
								<div><i class="icon-diagnosis small"> </i> 3 Tetanus Doses?</div>

								<p><label><input type="radio" value="Yes" name="patientMedicalHistory.tetanusMale"<% if (patientMedicalHistory?.tetanusMale == "Yes") { %> checked="checked" <% } %>/>Yes </label></p>
                                				<p><label><input type="radio" value="No" name="patientMedicalHistory.tetanusMale"<% if (patientMedicalHistory?.tetanusMale == "No") { %> checked="checked" <% } %>/>No</label></p>
								<p><label><input type="radio" value="Not Sure" name="patientMedicalHistory.tetanusMale"<% if (patientMedicalHistory?.tetanusMale == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</label></p>
                                    			<% } %>
                                    		</div>

						<div class="testbox noidnt">
							<div><i class="icon-diagnosis small"> </i> Others ?</div>

							<p><label><input type="radio" value="Yes" name="patientMedicalHistory.otherVaccinations" <% if (patientMedicalHistory?.otherVaccinations == "Yes") { %> checked="checked" <% } %> />Yes</label></p>
                            				<p><label><input type="radio" value="No"  name="patientMedicalHistory.otherVaccinations"<% if (patientMedicalHistory?.otherVaccinations == "No") { %> checked="checked" <% } %> />No </label></p>
						</div>
        				</div>

                    			<div class="onerow" id="p-otherVaccinations" style="padding-left: 15px;">
						<label for="otherVaccinations">Specify Others </label>
                        			<textarea type="text" id="otherVaccinations" name="patientMedicalHistory.otherVaccinations" value="${patientMedicalHistory?.otherVaccinations}" style="width: 675px;"></textarea>
					</div>

                    		</div>
            		</fieldset>

            		<fieldset>
            			<legend>Drug History</legend>
                		<div>
                 			<div class="onerow underline">
                  				<h2>Current medications?</h2>
            					<div class="col5">
				                <p><label><input type="radio" id="currentMedication" value="Yes" name="patientDrugHistory.currentMedication"<% if (patientDrugHistory?.currentMedication == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
				                <p><label><input type="radio" value="No" name="patientDrugHistory.currentMedication"<% if (patientDrugHistory?.currentMedication == "No") { %> checked="checked" <% } %>/>No</label></p>
            				</div>

				        <div class="col6 last" id="medication">
                				<p>
                  					<label>What is the medication?</label>
							<input type="text" id="medicationName" name="patientDrugHistory.medicationName" value="${patientDrugHistory?.medicationName ?: ""}">
                				</p>

						<p>
							<label>For how long it has been taken?</label>
                    					<input type="text" id="medicationPeriod" name="patientDrugHistory.medicationPeriod" value="${patientDrugHistory?.medicationPeriod ?: ""}">
                				</p>

						<p>
							<label>Why is it being taken?</label>
                    					<input type="text" id="medicationReason" name="patientDrugHistory.medicationReason" value="${patientDrugHistory?.medicationReason ?: ""}">
                				</p>

						<p>
							<label>Where are the Medical Records?</label>
                    					<input type="text" id="medicationRecord" name="patientDrugHistory.medicationRecord" value="${patientDrugHistory?.medicationRecord ?: ""}">
                				</p>
					</div>
                		</div>

                		<div class="onerow underline" style="padding-top: 20px">
					<h2>Any medication you are sensitive to?</h2>
                    			<div class="col5">
                        			<p><label><input type="radio" id="sensitiveMedication" value="Yes" name="patientDrugHistory.sensitiveMedication"<% if (patientDrugHistory?.sensitiveMedication == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
                        			<p><label><input type="radio" value="No"  name="patientDrugHistory.sensitiveMedication"<% if (patientDrugHistory?.sensitiveMedication == "No") { %> checked="checked" <% } %>/>No</label></p>
                    			</div>

					<div class="col6 last" id="sensitives">
						<p>
							<label>What is the medication?</label>
                        				<input type="text" id="sensitiveMedicationName" name="patientDrugHistory.sensitiveMedicationName" value="${patientDrugHistory?.sensitiveMedicationName ?: ""}">
                        			</p>

						<p>
							<label>What are the symptoms you experience?</label>
                        				<input type="text" id="sensitiveMedicationSymptom" name="patientDrugHistory.sensitiveMedicationSymptom" value="${patientDrugHistory?.sensitiveMedicationSymptom ?: ""}">
                        			</p>
					</div>
                		</div>

				<div class="onerow underline" style="padding-top: 20px">
					<h2>Are you using any invasive contraception?</h2>
                    			<div class="col5">
                        			<p><label><input type="radio" id="invasiveContraception" value="Yes" name="patientDrugHistory.invasiveContraception"<% if (patientDrugHistory?.invasiveContraception == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
						<p><label><input type="radio" value="No"  name="patientDrugHistory.invasiveContraception"<% if (patientDrugHistory?.invasiveContraception == "No") { %> checked="checked" <% } %>/>No</label></p>
                    			</div>

                    			<div class="col6 last" id="invasives">
						<label>What is the medication?</label>
                        			<input type="text" id="invasiveContraceptionName" name="patientDrugHistory.invasiveContraceptionName" value="${patientDrugHistory?.invasiveContraceptionName ?: ""}">
                    			</div>
				</div>
            		</div>
		</fieldset>

        	<fieldset>
            		<legend>Family History</legend>
                	<div>
                    		<div class="onerow underline">
                        		<h2>Status of father?</h2>
                    			<div class="col5">
                        		<p><label><input type="radio" value="Alive" id="fatherStatus" name="patientFamilyHistory.fatherStatus"<% if (patientFamilyHistory?.fatherStatus == "Alive") { %> checked="checked" <% } %>/>Alive </label></p>
                        		<p><label><input type="radio" value="Dead"  name="patientFamilyHistory.fatherStatus"<% if (patientFamilyHistory?.fatherStatus == "Dead") { %> checked="checked" <% } %>/>Dead</label></p>
                    		</div>

                    		<div class="col6 last" id="father-status">
                        		<p>
                            			<label>What was the cause of death?</label>
                            			<input type="text" id="fatherDeathCause" name="patientFamilyHistory.fatherDeathCause" value="${patientFamilyHistory?.fatherDeathCause ?: ""}">
                        		</p>

					<p>
						<label>How old were they?</label>
                            			<input type="text" id="fatherDeathAge" name="patientFamilyHistory.fatherDeathAge" value="${patientFamilyHistory?.fatherDeathAge ?: ""}">
                        		</p>
				</div>
                	</div>

                	<div class="onerow underline" style="padding-top: 20px">
                    		<h2>Status of mother?</h2>
                		<div class="col5">
                    			<p><label><input type="radio" id="motherStatus" value="Alive" name="patientFamilyHistory.motherStatus"<% if (patientFamilyHistory?.motherStatus == "Alive") { %> checked="checked" <% } %>/>Alive </label></p>
                     			<p><label><input type="radio"  value="Dead"  name="patientFamilyHistory.motherStatus"<% if (patientFamilyHistory?.motherStatus == "Dead")  { %> checked="checked" <% } %>/>Dead  </label></p>
                		</div>

				<div class="col6 last" id="mother-status">
					<p>
                        			<label>What was the cause of death?</label>
                        			<input type="text" id="motherDeathCause" name="patientFamilyHistory.motherDeathCause" value="${patientFamilyHistory?.motherDeathCause ?: ""}">
                    			</p>

					<p>
                        			<label>How old were they?</label>
                        			<input type="text" id="motherDeathAge" name="patientFamilyHistory.motherDeathAge" value="${patientFamilyHistory?.motherDeathAge ?: ""}">
                    			</p>
				</div>
            		</div>

            		<div class="onerow underline" style="padding-top: 20px">
                		<h2>Status of sibling?</h2>
                		<div class="col5">
                    			<p><label><input type="radio" id="siblingStatus" value="Alive" name="patientFamilyHistory.siblingStatus"<% if (patientFamilyHistory?.siblingStatus == "Alive") { %> checked="checked" <% } %>/>Alive </label></p>
                    			<p><label><input type="radio" value="Dead"  name="patientFamilyHistory.siblingStatus" <% if (patientFamilyHistory?.siblingStatus == "Dead") { %> checked="checked" <% } %>/>Dead</label></p>
                		</div>

				<div class="col6 last" id="sibling-status">
					<p>
						<label>What was the cause of death?</label>
                        			<input type="text" id="siblingDeathCause" name="patientFamilyHistory.siblingDeathCause" value="${patientFamilyHistory?.siblingDeathCause ?: ""}">
                    			</p>
					<p>
						<label>How old were they?</label>
                        			<input type="text" id="siblingDeathAge" name="patientFamilyHistory.siblingDeathAge" value="${patientFamilyHistory?.siblingDeathAge ?: ""}">
                    			</p>
                 		</div>
            		</div>

			<div class="onerow underline" style="padding-top: 20px;">
				<h2>Any family history of the following illness? </h2>
                		<div><i class="icon-diagnosis small"> </i><p><label>  <input type="checkbox" id="Hypertension" value="Hypertension" name="patientFamilyHistory.familyIllnessHistory" <%if(patientFamilyHistory?.familyIllnessHistory == "Hypertension") { %> checked="checked"<% } %>/>Hypertension </label></p></div>

				<div><i class="icon-diagnosis small"> </i><p><label>  <input type="checkbox" id="Tuberculosis" value="Tuberculosis" name="patientFamilyHistory.familyIllnessHistory" <%if (patientFamilyHistory?.familyIllnessHistory == "Tuberculosis") {%> checked="checked"<%} %>/> Tuberculosis</label></p></div>

                		<div><i class="icon-diagnosis small"> </i><p><label>  <input type="checkbox" id="Sudden Death" value="Sudden Death" name="patientFamilyHistory.familyIllnessHistory" <% if(patientFamilyHistory?.familyIllnessHistory == "Sudden Death") {%> checked="checked"<% }%>/>Sudden Death </label></p></div>

                		<div><i class="icon-diagnosis small"> </i><p><label>  <input type="checkbox" id="Stroke" value="Stroke" name="patientFamilyHistory.familyIllnessHistory"<%if (patientFamilyHistory?.familyIllnessHistory=="Stroke"){%> checked="checked"<%}%> /> Stroke</label></p></div>

                		<div><i class="icon-diagnosis small"> </i><p><label>  <input type="checkbox" id="Asthma" value="Asthma" name="patientFamilyHistory.familyIllnessHistory" <%if(patientFamilyHistory?.familyIllnessHistory=="Asthma"){%> checked="checked" <%}%>/> Asthma</label></p></div>

				<div><i class="icon-diagnosis small"> </i><p><label>  <input type="checkbox" id="Diabetes" value="Diabetes" name="patientFamilyHistory.familyIllnessHistory" <%if(patientFamilyHistory?.familyIllnessHistory=="Diabetes"){%>checked="checked" <%}%> /> Diabetes</label></p></div>

                		<div><i class="icon-diagnosis small"> </i><p><label>  <input type="checkbox" id="Others" value="Others" name="patientFamilyHistory.familyIllnessHistory" <%if(patientFamilyHistory?.familyIllnessHistory=="Others"){%>checked="checked"<%}%>/> Others </label></p></div>

                		<div><i class="icon-diagnosis small"> </i> <p><label>  <input type="checkbox" id="None" value="None" name="patientFamilyHistory.familyIllnessHistory" <%if(patientFamilyHistory?.familyIllnessHistory=="None"){%>checked="checked"<%}%>/> None</label></p></div>
        		</div>
    		</fieldset>

    		<fieldset>
        		<legend>Personal and Social</legend>
        		<div>
        			<div class="onerow underline">
        				<h2>Do you smoke?</h2>
					<div class="col5">
					<p><label><input type="radio" id="smoke" value="Yes" name="patientPersonalHistory.smoke"<% if (patientPersonalHistory?.smoke == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
            				<p><label><input type="radio" value="No"  name="patientPersonalHistory.smoke"<% if (patientPersonalHistory?.smoke == "No") { %> checked="checked" <% } %>/> No</label></p>
				</div>

        			<div class="col6 last" id="do-smoke">
            				<p>
                				<label>What do you smoke?</label>
                				<input type="text" id="smokeItem" name="patientPersonalHistory.smokeItem" value="${patientPersonalHistory?.smokeItem ?: ""}">
					</p>

            				<p>
                				<label>What is your average in a day?</label>
						<input type="text" id="smokeAverage" name="patientPersonalHistory.smokeAverage" value="${patientPersonalHistory?.smokeAverage ?: ""}">
					</p>
        			</div>
         		</div>

        		<div class="onerow underline" style="padding-top: 20px">
            			<h2> Do you drink alcohol?</h2>
				<div class="col5">
					<p><label><input type="radio" id="alcohol" value="Yes" name="patientPersonalHistory.alcohol"<% if (patientPersonalHistory?.smoke == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
                    			<p><label><input type="radio" value="No" name="patientPersonalHistory.alcohol"<% if (patientPersonalHistory?.smoke == "No") { %> checked="checked" <% } %>/>No</label></p>
				</div>

                		<div class="col6 last" id="do-alcohol">
                    			<p>
                        			<label>What alcohol do you drink?</label>
						<input type="text" id="alcoholItem" name="patientPersonalHistory.alcoholItem" value="${patientPersonalHistory?.alcoholItem ?: ""}">
					</p>

                    			<p>
                        			<label>What is your average in a day?</label>
						<input type="text" id="alcoholAverage" name="patientPersonalHistory.alcoholAverage" value="${patientPersonalHistory?.alcoholAverage ?: ""}">
					</p>
                		</div>
        		</div>

        		<div class="onerow underline" style="padding-top: 20px">
        			<h2>Do you take any recreational drugs?</h2>
				<div class="col5">
                			<p><label><input type="radio" id="drug" value="Yes" name="patientPersonalHistory.drug"<% if (patientPersonalHistory?.drug == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
                			<p><label><input type="radio" value="No" name="patientPersonalHistory.drug"<% if (patientPersonalHistory?.drug == "No") { %> checked="checked" <% } %>/>No</label> </p>
				</div>

            			<div class="col6 last" id="do-drugs">
                			<p>
                    				<label>What drugs do you take?</label>
                    				<input type="text" id="drugItem" name="patientPersonalHistory.drugItem" value="${patientPersonalHistory?.drugItem ?: ""}">
					</p>

                			<p>
                    				<label>What is your average in a day?</label>
						<input type="text" id="drugAverage" name="patientPersonalHistory.drugAverage" value="${patientPersonalHistory?.drugAverage ?: ""}">
					</p>
            			</div>
        		</div>

        		<div class="onerow underline" style="padding-top: 20px">
        			<h2>Are you aware of your current HIV status?</h2>
				<div class="col5">
					<p><label><input type="radio" id="hivStatus" value="Yes" name="patientPersonalHistory.hivStatus"<% if (patientPersonalHistory?.hivStatus == "Yes") { %> checked="checked" <% } %>/>Yes</label> </p>
                			<p><label><input type="radio" value="No" name="patientPersonalHistory.hivStatus"<% if (patientPersonalHistory?.hivStatus == "No") { %> checked="checked" <% } %>/>No</label> </p>
				</div>
        		</div>

			<div class="onerow underline" style="padding-top: 20px">
				<h2> Have you been exposed to any HIV/ AIDS factor in the past year, or since your last HIV Test?</h2>
				<div class="col5">
					<p><label><input type="radio" id="exposedHiv" value="Yes" name="patientPersonalHistory.exposedHiv"<% if (patientPersonalHistory?.exposedHiv == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
                			<p><label><input type="radio" value="No"  name="patientPersonalHistory.exposedHiv"<% if (patientPersonalHistory?.exposedHiv == "No" ) { %> checked="checked" <% } %>/>No</label> </p>
				</div>

            			<div class="col6 last" id="do-exposed">
                			<p>
                    				<label>Which factors?</label>
                    				<input type="text" id="exposedHivFactor" name="patientPersonalHistory.exposedHivFactor" value="${patientPersonalHistory?.exposedHivFactor ?: ""}">
                			</p>
            			</div>
			</div>

        		<div class="onerow underline" style="padding-top: 20px">
        			<h2>Any close member in the family who can support during illness?</h2>
				<div class="col5">
					<p><label><input type="radio" id="familyHelp" value="Yes" name="patientPersonalHistory.familyHelp"<% if (patientPersonalHistory?.familyHelp == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
        				<p><label><input type="radio" value="No" name="patientPersonalHistory.familyHelp"<% if (patientPersonalHistory?.familyHelp == "No") { %> checked="checked" <% } %>/>No</label></p>
				</div>

    				<div class="col6 last" id="do-support">
        				<label>Who else can support you during illness?</label>
					<input type="text" id="otherHelp" name="patientPersonalHistory.otherHelp" value="${patientPersonalHistory?.otherHelp ?: ""}">
    				</div>
        		</div>

         		<div class="onerow">
            			<h2>Do you have a regular source of income?</h2>
				<div class="col5">
					<p><label><input type="radio" id="incomeSource" value="Yes" name="patientPersonalHistory.incomeSource"<% if (patientPersonalHistory?.incomeSource == "Yes") { %> checked="checked" <% } %>/>Yes</label></p>
					<p><label><input type="radio" value="No"  name="patientPersonalHistory.incomeSource"<% if (patientPersonalHistory?.incomeSource == "No" ) { %> checked="checked" <% } %>/>No</label> </p>
				</div>
         		</div>
        	</div>
     </fieldset>

	<div class="onerow" style="margin-top: 50px">
		<div class="col4" style="padding-left: 5px">
			<a class="button previous task" >
				<span style="padding: 15px;">PREVIOUS</span>
			</a>
		</div>
		<div class="col4">&nbsp;</div>
        	<div class="col4 last">
			<a class="button next confirm" style="float:right; display:inline-block;margin-right:5px;" >
				<span>NEXT PAGE</span>
			</a>
        	</div>
	</div>
</section>

<div id="confirmation">
	<span id="confirmation_label" class="title">Confirm</span>

        <div style="display:none;">
        	<div class="before-dataCanvas"></div>
                <div id="dataCanvas"></div>
                	<div class="after-data-canvas"></div>
				<div id="confirmationQuestion"></div>
                    	</div>
			<div class="dashboard">
                    		<div class="info-section">
		                	<div class="info-header">
                        			<i class="icon-list-ul"></i>
                        			<h3>Vitals Summary</h3>
                                        </div>
                        		<div class="info-body">
                            			<ul>
                                			<li id="li01"><span class="status active"></span><div>Weight:</div> <small id="summ_01">/</small></li>
                                			<li id="li02"><span class="status active"></span><div>Height:</div> <small id="summ_02">/</small></li>
                                			<% if (patient.age >= 2) { %>
                                				<li id="li17"><span class="status active"></span><div>BMI:</div>                <small id="summ_17">/</small></li>
                                			<% } %>
                                			<li id="li03"><span class="status active"></span><div>MUA CC:</div> 			<small id="summ_03">/</small></li>
                                			<li id="li04"><span class="status active"></span><div>Chest CC:</div> 			<small id="summ_04">/</small></li>
                                			<li id="li05"><span class="status active"></span><div>Abdominal CC:</div>		<small id="summ_05">/</small></li>
                                			<li id="li06"><span class="status active"></span><div>Temperature:</div>		<small id="summ_06">/</small></li>
                                			<li id="li07"><span class="status active"></span><div>BP (Systolic):</div>		<small id="summ_07">/</small></li>
                                			<li id="li08"><span class="status active"></span><div>BP (Diastolic):</div>		<small id="summ_08">/</small></li>
                                			<li id="li09"><span class="status active"></span><div>Respiratory Rate:</div>	<small id="summ_09">/</small></li>
                                			<li id="li10"><span class="status active"></span><div>Pulse Rate:</div>			<small id="summ_10">/</small></li>
                                			<li id="li11"><span class="status active"></span><div>Last Periods:</div>		<small id="summ_11">/</small></li>
                                			<li id="li16"><span class="status active"></span><div>Oxygen saturation:</div>  <small id="summ_16">/</small></li>

                                			<li id="li12"><span class="status active"></span><div>Blood Group:</div>		<small id="summ_12">/</small></li>
                                			<li id="li13"><span class="status active"></span><div>Rhesus Factor:</div>		<small id="summ_13">/</small></li>
                                			<li id="li14"><span class="status active"></span><div>HIV Status:</div>				<small id="summ_14">/</small></li>
                                			<li id="li15"><span class="status active"></span><div>Room to Visit:</div>		<small id="summ_15">/</small></li>
                            			</ul>
                        		</div>
                    		</div>
                	</div>

                	<div class="onerow" style="margin-top: 150px">
                    		<input id="submit" type="submit" class="submitButton confirm right" value="FINISH" style="float:right; display:inline-block; margin-left: 5px;" />
                    		<a class="button cancel" onclick=" toggleSelection();">
                        		<span style="padding: 15px;">REVIEW</span>
                    		</a>
                	</div>
		</div>
        </form>
</div>
