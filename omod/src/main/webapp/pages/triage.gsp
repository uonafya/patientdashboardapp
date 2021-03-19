<%
	ui.decorateWith("appui", "standardEmrPage", [title: "Triage Dashboard"])

	ui.includeCss("uicommons", "datetimepicker.css")
	ui.includeCss("ehrconfigs", "onepcssgrid.css")

	ui.includeJavascript("patientdashboardapp", "note.js")

	ui.includeJavascript("ehrconfigs", "moment.js")
	ui.includeCss("ehrconfigs", "referenceapplication.css")

	ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
	ui.includeJavascript("uicommons", "handlebars/handlebars.min.js")
%>

<script>

	var emrMessages = {};
	var filledFields = {
		"Temperature":null,
		"Blood Pressure (Systolic)":null,
		"Blood Pressure (Diastolic)":null,
		"room":null
	};
	emrMessages["numericRangeHigh"] = "value should be less than {0}";
	emrMessages["numericRangeLow"] = "value should be more than {0}";
	emrMessages["requiredField"] = "Required Field";
	emrMessages["numberField"] = "Value not a number";

	function isNombre(numb){
		return !isNaN(parseFloat(numb));
	}

	jq(document).ready(function () {
		jq(".button.confirm").addClass("disabled");
		jq(".button.confirm").attr("onclick","");
		jq(".lab-tabs").tabs();
		jq.fn.exists = function(){ return this.length > 0; }
		if(!jq("select[name='roomToVisit']").exists()){
			delete filledFields['room'];
			checkValues();
		}
		jq('#surname').html(strReplace('${patient.names.familyName}')+',<em>surname</em>');
		jq('#othname').html(strReplace('${patient.names.givenName}')+' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em>other names</em>');
		jq('#agename').html('${patient.age} years ('+ moment('${patient.birthdate}').format('DD,MMM YYYY') +')');

		function strReplace(word) {
			var res = word.replace("[", "");
			res=res.replace("]","");
			return res;
		}

		jq('input:text[id]').on('input',function(event){
			var idd = jq(event.target).attr('id');
			var txt = jq(event.target).val();

			if (idd === 'weight-field'){
				if (txt === ''){
					jq('#li01').hide();
				}
				else {
					jq('#li01').show();
					jq('#summ_01').text(jq(event.target).val() +' kgs');
				}
			}

			else if (idd === 'height-field'){
				if (txt === ''){
					jq('#li02').hide();
				}
				else {
					jq('#li02').show();
					jq('#summ_02').text(jq(event.target).val() +' cm');
				}
			}

			else if (idd === 'muac-field'){
				if (txt === ''){
					jq('#li03').hide();
				}
				else {
					jq('#li03').show();
					jq('#summ_03').text(jq(event.target).val() +' cm');
				}
			}

			else if (idd === 'chest-circum-field'){
				if (txt === ''){
					jq('#li04').hide();
				}
				else {
					jq('#li04').show();
					jq('#summ_04').text(jq(event.target).val() +' cm');
				}
			}

			else if (idd === 'abdominal-circum-field'){
				if (txt === ''){
					jq('#li05').hide();
				}
				else {
					jq('#li05').show();
					jq('#summ_05').text(jq(event.target).val() +' cm');
				}
			}

			else if (idd === 'temperature-field'){
				if (txt === ''){
					jq('#li06').hide();
				}
				else {
					jq('#li06').show();
					jq('#summ_06').html(jq(event.target).val() +' &#8451;');
				}
			}

			else if (idd === 'systolic-bp-field'){
				if (txt === ''){
					jq('#li07').hide();
				}
				else {
					jq('#li07').show();
					jq('#summ_07').text(jq(event.target).val());
				}
			}

			else if (idd === 'diastolic-bp-field'){
				if (txt === ''){
					jq('#li08').hide();
				}
				else {
					jq('#li08').show();
					jq('#summ_08').text(jq(event.target).val());
				}
			}

			else if (idd === 'resp-rate-field'){
				if (txt === ''){
					jq('#li09').hide();
				}
				else {
					jq('#li09').show();
					jq('#summ_09').text(jq(event.target).val());
				}
			}

			else if (idd === 'pulse-rate-field'){
				if (txt === ''){
					jq('#li10').hide();
				}
				else {
					jq('#li10').show();
					jq('#summ_10').text(jq(event.target).val());
				}
			}

			else if (idd === 'oxygenSaturation-field'){
				if (txt === ''){
					jq('#li16').hide();
				}
				else {
					jq('#li16').show();
					jq('#summ_16').text(formatToAccounting(jq(event.target).val())+'%');
				}
			}
		});

		jq('#datetime-display').on("change", function (dateText) {
			jq('#li11').show();
			jq('#summ_11').text(jq('#datetime-display').val());
		});

		jq("input[type='text']").on("keyup", function() {
			var inputText = jq(this).val();
			inputText = inputText.replace(/[^0-9.]/g, '');
			jq(this).val(inputText);
		});

		jq('#temperature-field').on("focusout", function(){
			var maxVal =43;
			var minVal=25;
			var fieldTypeVal="Temperature";
			var idVal = jq(this).attr("id");
			var localid ="#fr89981";
			checkError(minVal,maxVal,idVal,localid,fieldTypeVal);
		});

		jq('#systolic-bp-field').on("focusout", function() {
			var maxVal = 250;
			var minVal = 0;
			var fieldTypeVal = "Blood Pressure (Systolic)";
			var idVal = jq(this).attr("id");
			var localid = "#fr5882";
			checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
		});

		jq('#diastolic-bp-field').on("focusout", function() {
			var maxVal = 150;
			var minVal = 0;
			var fieldTypeVal = "Blood Pressure (Diastolic)";
			var idVal = jq(this).attr("id")
			var localid = "#fr9945";
			checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
		});

		jq('#resp-rate-field').on("focusout", function() {
			var maxVal = 99;
			var minVal = 0;
			var fieldTypeVal = "Respiratory Rate";
			var idVal = jq(this).attr("id")
			var localid = "#fr1753";
			checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
		});

		jq('#oxygenSaturation-field').on("focusout", function() {
			var maxVal = 100;
			var minVal = 0;
			var fieldTypeVal = "Oxygen Saturation";
			var idVal = jq(this).attr("id")
			var localid = "#fr8998";
			checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
		});

		jq('#pulse-rate-field').on("focusout", function() {
			var maxVal = 230;
			var minVal = 0;
			var fieldTypeVal = "Pulse Rate";
			var idVal = jq(this).attr("id")
			var localid = "#fr8917";
			checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
		});

		jq('#weight-field').on("focusout", function() {
			var maxVal = 250;
			var minVal = 0;
			var fieldTypeVal = "Weight";
			var idVal = jq(this).attr("id")
			var localid = "#fr1139";
			checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
		});

		jq('#height-field').on("focusout", function() {
			var maxVal = 272;
			var minVal = 10;
			var fieldTypeVal = "Height";
			var idVal = jq(this).attr("id")
			var localid = "#fr9875";
			checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
		});

		jq('#room-to-visit').on("change", function() {
			var roomVar = '#room-to-visit';
			var tempVal = jq(roomVar).val()
			if (tempVal !== '') {
				filledFields["room"] = tempVal;
				checkFilled();
			} else {
				filledFields["room"] = null;
				jq(roomVar).prop("style", "border-color:red");
				jq("#fr3417").html('<span style="color:#ff0000">Please Select a room</span>');
				checkFilled();
			}
		});

		function checkError(minVal, maxVal, idField, idError, fieldType) {
			var tempVal = jq('#'+idField).val();
			var errorLocal = '';
			var valTemp = 0;
			if (isNaN(tempVal) && tempVal !== "") {
				jq(idError).html('<span style="color:#ff0000">' + fieldType + ' must be a number!</span>');
				jq(idError).show();
			} else if (tempVal > maxVal && !isNaN(tempVal)) {
				errorLocal = 'greater';
				valTemp = maxVal;
				filledFields[fieldType] = null;
			} else if (tempVal < minVal && !isNaN(tempVal)) {
				errorLocal = 'lower';
				valTemp = minVal;
				filledFields[fieldType] = null;
			} else {
				if (filledFields[fieldType] !== undefined && tempVal !== "") {
					filledFields[fieldType] = tempVal;
					noError(idError, idField);
				} else if (filledFields[fieldType] !== undefined && tempVal === "") {
					jq(idField).prop("style", "border-color:red");
					jq(idError).html('<span style="color:#ff0000">' + fieldType + ' must be filled in!</span>');
					jq(idError).show();
				} else {
					noError(idError, idField);
				}
				checkFilled();
				return;
			}
			jq(idField).prop("style", "border-color:red");
			jq(idError).html('<span style="color:#ff0000">' + fieldType + ' cannot be ' + errorLocal + ' than ' + valTemp + '</span>');
			jq(idError).show();
			checkFilled();
		}

		function noError(idField, fieldTypeid) {
			jq(fieldTypeid).prop("style", "background-color: #ddffdd;");
			jq(idField).hide();
		}

		function checkFilled() {
			var checkComplete = true;
			for (let items in filledFields) {
				if (filledFields[items] === null) {
						checkComplete = false;
				}
			}
			if (checkComplete) {
				jq(".button.confirm").removeClass("disabled");
				jq(".button.confirm").attr("onclick", "PAGE.submit();");
			}
			else{
				jq(".button.confirm").addClass("disabled");
				jq(".button.confirm").attr("onclick", "");
			}
			console.log(checkComplete);
		}
		function checkValues(){
			filledFields['Temperature']=jq("#temperature-field").val();
			filledFields['Blood Pressure (Systolic)']=jq("#systolic-bp-field").val();
			filledFields['Blood Pressure (Diastolic)']=jq("#diastolic-bp-field").val();
		}

		jq('select').bind('change keyup', function(event) {
			var idd = jq(event.target).attr('id');
			var txt = jq(event.target).val();

			if (idd === 'bloodGroup-field'){
				if (txt === ''){
					jq('#li12').hide();
				}
				else {
					jq('#li12').show();
					jq('#summ_12').text(jq(event.target).val());
				}
			}
			else if (idd === 'rhesusFactor-field'){
				if (txt === ''){
					jq('#li13').hide();
				}
				else {
					jq('#li13').show();
					jq('#summ_13').text(jq(event.target).val());
				}
			}
			else if (idd === 'pitct-field'){
				if (txt === ''){
					jq('#li14').hide();
				}
				else {
					jq('#li14').show();
					jq('#summ_14').text(jq(event.target).val());
				}
			}
			else if (idd === 'room-to-visit'){
				if (txt === ''){
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
			if(jq("input:radio[name='"+name+"']:checked").length === 0){
			}
			else if(jq("input:radio[name='"+name+"']:checked").val() === "Yes") {
				jq("input[name='"+name+"'][value='Yes']").attr('checked', 'checked').change();
			}
			else if(jq("input:radio[name='"+name+"']:checked").val() === "Dead") {
				jq("input[name='"+name+"'][value='Dead']").attr('checked', 'checked').change();
			}
		});

		jq('.noidnt input:radio').each(function() {
			var name = jq(this).attr("name");
			if(jq("input:radio[name='"+name+"']:checked").length === 0){
				jq("input[name='"+name+"'][value='No']").attr('checked', 'checked').change();
			}
		});
	});

	function getFloatValue(source) {
		return isNaN(parseFloat(source)) ? 0 : parseFloat(source);
	}

	jq(function(){
		emrMessages["numericRangeHigh"] = "value should be less than {0}";
		emrMessages["numericRangeLow"] = "value should be more than {0}";

		jq("#height-field,#weight-field").change(function () {
			console.log("Value changed.")
			var height = getFloatValue(jq("#height-field").val())/100;
			var weight = getFloatValue(jq("#weight-field").val());
			var bmi = weight/(height * height);
			console.log("BMI " + bmi);
			jq(".bmi").html(formatToAccounting(String(bmi)));

			console.log(isNombre(bmi));

			if (isNombre(bmi)){
				jq('#li17').show();
				jq('#summ_17').text(formatToAccounting(String(bmi)));
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

	function strReplace(word) {
		var res = word.replace("null", "");
		res=res.replace("null","");
		return res;
	}

	function formatToAccounting(nStr) {
		nStr = parseFloat(nStr).toFixed(2);
		nStr += '';
		x = nStr.split('.');
		x1 = x[0];
		x2 = x.length > 1 ? '.' + x[1] : '';
		var rgx = /(\\d+)(\\d{3})/;
		while (rgx.test(x1)) {
			x1 = x1.replace(rgx, '\$1' + ',' + '\$2');
		}
		return x1 + x2;
	}
	PAGE = {
		/** SUBMIT */
		submit: function () {
			jq("#vitalRegistrationForm").submit();
		}
	};

</script>

<style>
.name {
	color: #f26522;
}
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
h2 span{
	color: #f00 !important;
	padding-left: 5px;
}
#modal-overlay {
	background: #000 none repeat scroll 0 0;
	opacity: 0.4 !important;
}
</style>

<openmrs:require privilege="Triage Queue" otherwise="/login.htm" redirect="/module/patientqueueapp/queue.page?app=patientdashboardapp.triage"></openmrs:require>
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>


<div class="clear"></div>
<div id="content">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="${ui.pageLink('kenyaemr','userHome')}">
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
			<div class="tag">${visitStatus?visitStatus:'Unknown'}</div>
			<div class="tad">Last Visit: ${lastVisitDate?ui.formatDatetimePretty(lastVisitDate):'N/A'}</div>
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
	<table>
		<tr>
			<td width="15%" valign="top" style="padding-left: 5px">&nbsp;</td>
			<td>
				<form form id="vitalRegistrationForm" method="post">
					<div class="container">
						<section>
							<div class="onerow" style="padding-top: 10px;">
								<h2 style="border-bottom: 1px solid #008394">Vital Summary</h2>

								<div class="col4">
									<label for="temperature-field"> Temperature <span style="color: #f00 !important;
									padding-left: 5px;">*</span></label>
								</div>

								<div class="col4">
									<label for="systolic-bp-field">Blood Pressure (Systolic)<span style="color: #f00 !important;
									padding-left: 5px;">*</span></label>
								</div>

								<div class="col4 last">
									<label for="diastolic-bp-field">Blood Pressure (Diastolic)<span style="color: #f00 !important;
									padding-left: 5px;">*</span></label>
								</div>
							</div>
							<div class="onerow">
								<div class="col4">
									<p>
										<input id="temperature-field" class="numeric-range" type="text" max="999" min="0" maxlength="7" value="${vitals?.temperature?:''}" name="triagePatientData.temperature">
										<span class="append-to-value">..&#8451;</span>
										<span id="fr89981" class="field-error" style="display: none"></span>
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

								<div class="col4 last">
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
							<% if (!inOpdQueue) {%>
							<div class="onerow">
								<h2>Room to Visit<span>*</span></h2>

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
							<% } %>

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
			</td>
		</tr>
	</table>

</div>
