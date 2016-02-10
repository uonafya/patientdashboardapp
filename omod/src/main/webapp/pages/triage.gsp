<%
    ui.decorateWith("appui", "standardEmrPage")
	
    ui.includeCss("uicommons", "datetimepicker.css")
	ui.includeCss("patientdashboardapp", "onepcssgrid.css")
	
    ui.includeJavascript("patientdashboardapp", "note.js")
	
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
	emrMessages["requiredField"] = "Required";
	emrMessages["numberField"] = "Value not a number";
	
	jq(document).ready(function () {
	
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
			jq(".bmi").html(bmi.toFixed(2));
		});
	});
</script>

<style>
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
	input:focus{
		outline: 2px none #007fff!important;
		border: 1px solid #007fff;
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
	form label, .form label {
		margin: 5px 0 0;
		padding: 0 5px
	}
</style>

${ui.includeFragment("coreapps", "patientHeader", [patient: patient])}

<div id="content">
    <form method="post" id="notes-form" class="simple-form-ui">
        <input type="hidden" value="${returnUrl?:""}" name="returnUrl" >
        <section>
            <span class="title">Vital Stats</span>
            <fieldset>
                <legend>Vitals</legend>
                <div>
					<div class="onerow">
						<h2>Body Mass Index</h2>
						
						<div class="col4">
							<label for="weight-field"> Weight </label>
						</div>
						
						<div class="col4">
							<label for="height-field"> Height </label>
						</div>
						
						<div class="col4 last">
							<% if (patient.age >= 18) { %>
							<label>BMI:</label>
							<% } %>
						</div>
					</div>
					
					<div class="onerow">
						<div class="col4">
							<p class="left">
								<input id="weight-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="" name="weight">
								<span class="append-to-value">kg</span>
								<span id="fr1139" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4">
							<p class="left">
								<input id="height-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="" name="height">
								<span class="append-to-value">cm</span>
								<span id="fr9875" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4 last">
							<% if (patient.age >= 18) { %>
							<p>
								<div class="bmi"></div>
							</p>
							<% } %>
						</div>
					</div>
					
					<div class="onerow" style="padding-top: 10px;">
						<h2>Circumference</h2>
						
						<div class="col4">
							<label for="muac-field"> M.U.A </label>
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
								<input id="muac-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="" name="mua">
								<span class="append-to-value">cm</span>
								<span id="fr801" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4">
							<p>
								<input id="chest-circum-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="" name="chest">
								<span class="append-to-value">cm</span>
								<span id="fr3193" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4 last">
							<p>
								<input id="abdominal-circum-field" class="number numeric-range" type="text" max="999" min="0" maxlength="7" value="" name="abdominal">
								<span class="append-to-value">cm</span>
								<span id="fr76" class="field-error" style="display: none"></span>
							</p>
						</div>
					</div>
					
					<div class="onerow" style="padding-top: 10px;">
						<h2>Others Measures</h2>
						
						<div class="col4">
							<label for="temperature-field"> Temperature </label>
						</div>
						
						<div class="col4">
							<label for="systolic-bp-field">Systolic B.P</label>
						</div>
						
						<div class="col4 last">
							<label for="diastolic-bp-field">Diastolic B.P</label>
						</div>
					</div>
					
					<div class="onerow">
						<div class="col4">
							<p>
								<input id="temperature-field" class="numeric-range" type="text" max="999" min="0" maxlength="7" value="" name="temperature">
								<span class="append-to-value">..&#8451;</span>
								<span id="fr8998" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4">
							<p>
								<input id="systolic-bp-field" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4" value="" name="systolic">
								<span id="fr5882" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4 last">
							 <p>
								<input id="diastolic-bp-field" class="numeric-range" type="text" max="999" min="0" maxlength="3" size="4" value="" name="diastolic">
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
							&nbsp;
						</div>
					</div>
					
					<div class="onerow">
						<div class="col4">
							<p>
								<input id="resp-rate-field" class="numeric-range focused" type="text" max="999" min="0" maxlength="7" value="" name="respiratoryRate">
								<span id="fr1753" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4">
							<p>
								<input id="pulse-rate-field" class="numeric-range" type="text" max="999" min="0" maxlength="7" value="" name="pulsRate">
								<span id="fr8917" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4 last"> &nbsp;
						</div>
					</div>
					
					
					
                   
					
					
                   
                   
					
                   
					
					
					
                    <% if (patient.gender == "F" && patient.age > 10)  { %>
                        ${ui.includeFragment("uicommons", "field/datetimepicker", [
                            id: 'datetime',
                            label: 'Last Menstual Period',
                            formFieldName: 'lastMenstrualDate',
                            initialValue: vitals?.lastMenstrualDate,
                            useTime: false])
                        }
                    <% } %>
                </div>
            </fieldset>
            <fieldset>
                <legend>Blood Group</legend>
                ${ ui.includeFragment("uicommons", "field/dropDown", [
                     id : 'bloodGroup',
                     label : 'Blood Group',
                     formFieldName: 'bloodGroup',
                     emptyOptionLabel: '- Please select -', 
                     options: [
                         [value: 'O', label: 'O' ],
                         [value: 'A', label: 'A' ],
                         [value: 'B', label: 'B' ],
                         [value: 'AB', label: 'AB' ],
                         [value: 'Not Known', label: 'Not Known' ]],
                     initialValue : vitals?.bloodGroup
                 ]) }
                ${ ui.includeFragment("uicommons", "field/dropDown", [
                     id : 'rhesusFactor',
                     label : 'Rhesus Factor',
                     formFieldName: 'rhesusFactor',
                     emptyOptionLabel: '- Please select -', 
                     options: [
                         [value: 'Positive (+)', label: 'Positive (+)' ],
                         [value: 'Negative (-)', label: 'Negative (-)' ], 
                         [value: 'Not Known', label: 'Not Known' ]],
                     initialValue : vitals?.rhesusFactor
                 ]) }
            </fieldset>
            <fieldset>
                <legend>PITCT</legend>
                ${ ui.includeFragment("uicommons", "field/dropDown", [
                     id : 'pitct',
                     label : 'PITCT',
                     formFieldName: 'pitct',
                     emptyOptionLabel: '- Please select -', 
                     options: [
                         [value: 'Reactive', label: 'Reactive' ],
                         [value: 'Non-Reactive', label: 'Non-Reactive' ], 
                         [value: 'Not Known', label: 'Not Known' ]],
                     initialValue : vitals?.pitct
                 ]) }
            </fieldset>
            <% if (!inOpdQueue) {%>
                <fieldset>
                    <legend>Room to Visit</legend>
                    <p>
                        <select id="room-to-visit" name="roomToVisit">
                            <option value="">-Please select-</option>
                            <% listOPD.each { opd -> %>
                                <option value="${opd.answerConcept.id }">${opd.answerConcept.name}</option>
                            <% } %>
                        </select>
                    </p>
                </fieldset>
            <% } %>
        </section>
        <div id="confirmation">
            <span id="confirmation_label" class="title">Confirm</span>
            <div class="before-dataCanvas"></div>
            <div id="dataCanvas"></div>
            <div class="after-data-canvas"></div>
            <div id="confirmationQuestion">
                Are the details correct?
                <p style="display: inline">
                    <input id="submit" type="submit" class="submitButton confirm right" value="YES" />
                </p>
                <p style="display: inline">
                    <input id="cancelSubmission" class="cancel" type="button" value="NO" />
                </p>
            </div>
        </div>
    </form>
</div>

<style>
.simple-form-ui section.focused {
    width: 75%;
}
</style>