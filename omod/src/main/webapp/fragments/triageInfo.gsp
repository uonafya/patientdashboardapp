<%
	import java.text.DecimalFormat
    def formatter = new DecimalFormat("#0.00")
	
    def returnUrl = ui.pageLink("patientdashboardapp", "main", [patientId: patientId, opdId: opdId, queueId: queueId])
	ui.includeCss("ehrconfigs", "onepcssgrid.css")
%>

<script>
	var emrMessages = {};
	emrMessages["numericRangeHigh"] = "value should be less than {0}";
	emrMessages["numericRangeLow"] = "value should be more than {0}";
	emrMessages["requiredField"] = "Required Field";
	emrMessages["numberField"] = "Value not a number";
	var errorList ={};
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
		selector: '#new-vitals-dialog',
		actions: {
			confirm: function () {
               addVitals();
			},
			cancel: function () {
				location.reload();
			}
		}
	});
	jq("#newVitalsModal").on("click", function (e) {
		e.preventDefault();
		//onDialogLoad();
		addvitalsDialog.show();
	});
});
function addVitals() {
        jq.getJSON('${ ui.actionLink("patientdashboardapp", "triageInfo", "addNewTriageInfo") }', {
            traigePatient:jq("#traigePatient").val(),
            temperature:jq("#temperature").val(),
            daistolicBp: jq("#diastolicBp").val(),
            systolicBp: jq("#systolicBp").val(),
            respiratoryRate: jq("#respiratoryRate").val(),
            pulsRate: jq("#pulseRate").val(),
            oxygenSaturation: jq("#oxygenSaturation").val(),
            weight: jq("#weight").val(),
            height: jq("#height").val(),
            mua: jq("#muac").val(),
            chestCircum: jq("#chestCircum").val(),
            abdominalCircum: jq("#abdominalCircum").val(),
        }).success(function(data) {
            console.log("The data is ", data);
            jq().toastmessage('showSuccessToast', "Patient's new triage information captured successfully");
            location.reload();
        });
    }
function isNombre(numb){
	return !isNaN(parseFloat(numb));
}

function onDialogLoad() {
	injectRequired();
	checkFilled();
	jq(".button.confirm").addClass("disabled");
	jq(".button.confirm").attr("onclick","");

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
		var localid ="fr89981";
		checkError(minVal,maxVal,idVal,localid,fieldTypeVal);
	});

	jq('#systolic-bp-field').on("focusout", function() {
		var maxVal = 250;
		var minVal = 0;
		var fieldTypeVal = "Blood Pressure (Systolic)";
		var idVal = jq(this).attr("id");
		var localid = "fr5882";
		checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
	});

	jq('#diastolic-bp-field').on("focusout", function() {
		var maxVal = 150;
		var minVal = 0;
		var fieldTypeVal = "Blood Pressure (Diastolic)";
		var idVal = jq(this).attr("id")
		var localid = "fr9945";
		checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
	});

	jq('#resp-rate-field').on("focusout", function() {
		var maxVal = 99;
		var minVal = 0;
		var fieldTypeVal = "Respiratory Rate";
		var idVal = jq(this).attr("id")
		var localid = "fr1753";
		checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
	});

	jq('#oxygenSaturation-field').on("focusout", function() {
		var maxVal = 100;
		var minVal = 0;
		var fieldTypeVal = "Oxygen Saturation";
		var idVal = jq(this).attr("id")
		var localid = "fr8998";
		checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
	});

	jq('#pulse-rate-field').on("focusout", function() {
		var maxVal = 230;
		var minVal = 0;
		var fieldTypeVal = "Pulse Rate";
		var idVal = jq(this).attr("id")
		var localid = "fr8917";
		checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
	});

	jq('#weight-field').on("focusout", function() {
		var maxVal = 250;
		var minVal = 0;
		var fieldTypeVal = "Weight";
		var idVal = jq(this).attr("id")
		var localid = "fr1139";
		checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
	});

	jq('#height-field').on("focusout", function() {
		var maxVal = 272;
		var minVal = 10;
		var fieldTypeVal = "Height";
		var idVal = jq(this).attr("id")
		var localid = "fr9875";
		checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
	});
}

function checkError(minVal, maxVal, idField, idError, fieldType) {
	var tempVal = jq('#'+idField).val();
	var errorLocal = '';
	var valTemp = 0;
	if (isNaN(tempVal) && tempVal !== "") {
		jq("#"+idError).html('<span style="color:#ff0000">' + fieldType + ' must be a number!</span>');
		jq("#"+idError).show();
		jq('#'+idField).attr("validation","false");
		errorList[fieldType]= "<i>"+fieldType+" must be a number</i><br>";
	} else if (tempVal > maxVal && !isNaN(tempVal)) {
		errorLocal = 'greater';
		valTemp = maxVal;
		jq('#'+idField).attr("validation","false");
	} else if (tempVal < minVal && !isNaN(tempVal)) {
		errorLocal = 'lower';
		valTemp = minVal;
		jq('#'+idField).attr("validation","false");
	} else {
		if (tempVal === "" && jq('#'+idField).attr("required")==="required") {
			jq("#"+idField).prop("style", "border-color:red");
			jq("#"+idError).html('<span style="color:#ff0000">' + fieldType + ' must be filled in!</span>');
			jq("#"+idError).show();
			jq("#"+idField).prop("style", "background-color: #f2bebe;");
			jq('#'+idField).attr("validation","false");
			errorList[fieldType]= "<i>"+fieldType+" must be filled in!</i><br/>";
		} else {
			delete errorList[fieldType];
			noError(idError, idField);
		}
		checkFilled();
		return;
	}
	jq("#"+idField).prop("style", "border-color:red");
	jq("#"+idError).html('<span style="color:#ff0000">' + fieldType + ' cannot be ' + errorLocal + ' than ' + valTemp + '</span>');
	jq("#"+idError).show();
	jq("#"+idField).prop("style", "background-color: #f2bebe;");
	errorList[fieldType]= '<i>'+fieldType+' cannot be ' + errorLocal + ' than ' + valTemp + '</i></br>';
	checkFilled();
}

function noError(idField, fieldTypeid) {
	jq('#'+idField).attr("validation","true");
	jq("#"+fieldTypeid).prop("style", "background-color: #ddffdd;");
	jq("#"+idField).hide();
	jq('#'+fieldTypeid).attr("validation","true");
}

function checkFilled() {
	var checkComplete = true;
	jq("input[required]").map(function(idx, elem) {
		if(jq(elem).val()==''){
			checkComplete=false;
		}
	}).get();
	jq("input[validation='false']").map(function(idx, elem) {
		if(jq(elem).attr("validation")==='false'){
			checkComplete=false;
		}
	}).get();
	if(!checkTempFilled()){checkComplete = false;}
	if (checkComplete) {
		jq(".button.confirm").removeClass("disabled");
		jq(".button.confirm").attr("onclick", "PAGE.submit();");
		jq("#errorsHere").html("");
		jq("#errorAlert").hide();
		errorList={};
	}
	else{
		jq(".button.confirm").addClass("disabled");
		jq(".button.confirm").attr("onclick", "");
		var count = 0;
		var i;
		var allErrors='';
		for (i in errorList) {
			if (errorList.hasOwnProperty(i)) {
				count++;
				allErrors+=errorList[i];
			}
		}
		if(count!==0) {
			jq("#errorsHere").html(allErrors);
			jq("#errorAlert").show();
		}
	}
	console.log(checkComplete);
}

function checkTempFilled(){
	jq.fn.exists = function(){ return this.length > 0; }
	if(jq("input[id='temperature-field']").exists() && jq("input[id='temperature-field']").val()==="" ){
		return false;
	}
	else{
		return true;
	}
}
function injectRequired(){
	var elements =['input[id="temperature-field"]'];
	for(var i in elements){
		jq(elements[i]).attr("required","");
	}
}
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
        
            <li style="height: 295px;" class="menu-item" >
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
			</div>
		</div>
	</div>
</div>
<div >
	<button class="btn btn-sm btn-primary float-right mb-3" id="newVitalsModal">
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

<div id="new-vitals-dialog" class="dialog" style="display:none; width: 1009px;">
<input type="text" id="traigePatient" name="traigePatient" value="${patientId}" />
	<div class="dialog-header">
		<i class="icon-folder-open"></i>

		<h3>Capture New Vitals</h3>
	</div>

	<div class="dialog-content">
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
								<input id="temperature" class="numeric-range" type="text" max="999" min="0" maxlength="7"  name="temperature" >
								<span class="append-to-value">..&#8451;</span>
								<span id="fr89981" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p>
								<input id="systolicBp" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4"  name="systolicBp" >
								<span id="fr5882" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4 last">
							<p>
								<input id="diastolicBp" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4" name="daistolicBp" >
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
								<input id="respiratoryRate" class="numeric-range focused" type="text" max="999" min="0" maxlength="7" name="respiratoryRate">
								<span id="fr1753" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p>
								<input id="pulseRate" class="numeric-range" type="text" max="999" min="0" maxlength="7"  name="pulsRate">
								<span id="fr8917" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4 last">
							<p>
								<input id="oxygenSaturation" class="numeric-range" type="text" max="100" min="0"  name="oxygenSaturation">
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
								<input id="weight" class="number numeric-range" type="text" max="999" min="0" maxlength="7"  name="weight">
								<span class="append-to-value">kg</span>
								<span id="fr1139" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p class="left">
								<input id="height" class="number numeric-range" type="text" max="999" min="0" maxlength="7" name="height">
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
								<input id="muac" class="number numeric-range" type="text" max="999" min="0" maxlength="3" name="mua">
								<span class="append-to-value">cm</span>
								<span id="fr801" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4">
							<p>
								<input id="chestCircum" class="number numeric-range" type="text" max="999" min="0" maxlength="3"  name="chestCircum">
								<span class="append-to-value">cm</span>
								<span id="fr3193" class="field-error" style="display: none"></span>
							</p>
						</div>

						<div class="col4 last">
							<p>
								<input id="abdominalCircum" class="number numeric-range" type="text" max="999" min="0" maxlength="3"  name="abdominalCircum">
								<span class="append-to-value">cm</span>
								<span id="fr76" class="field-error" style="display: none"></span>
							</p>
						</div>
					</div>


          <div class="onerow">

            <a class="button confirm"
               style="float:right; display:inline-block; margin-left: 5px;">
              <span>FINISH</span>
            </a>

            <a class="button cancel"
                 style="float:left; display:inline-block;"/>
              <span>CANCEL</span>
              </a>
          </div>
        </section>
			</div>
	</div>
</div>
