<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Triage Information"])
	
    ui.includeCss("uicommons", "datetimepicker.css")
	ui.includeCss("patientdashboardapp", "onepcssgrid.css")
	
    ui.includeJavascript("patientdashboardapp", "note.js")
	
	ui.includeJavascript("uicommons", "moment.js")
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
	
	jq(document).ready(function () {
		var diff = ''
		
		jq('#surname').html(strReplace('${patient.names.familyName}')+',<em>surname</em>');
		jq('#othname').html(strReplace('${patient.names.givenName}')+' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em>other names</em>');
		jq('#agename').html('${patient.age} years ('+ moment('${patient.birthdate}').format('DD,MMM YYYY') +')');
		
		jq('.tad').text('Last Visit: '+ moment('${lastVisitDate}').format('DD.MM.YYYY hh:mm')+' HRS');
		
		function strReplace(word) {
			var res = word.replace("[", "");
			res=res.replace("]","");
			return res;
		}
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
	
	function goto_next_tab(current_tab){
		if (current_tab == 1){
			var currents = '';
			
			while (jQuery(':focus') != jQuery('#bloodGroup-field')) {
				if (currents == jQuery(':focus').attr('id')){
					NavigatorController.stepForward();
					break;
				}
				else {
					currents = jQuery(':focus').attr('id');
				}
				
				if (jQuery(':focus').attr('id')=='bloodGroup-field'){
					break;
				}
				else {
					NavigatorController.stepForward();
				}
			}
			// jQuery(':focus')
		
			//NavigatorController.getFieldById('passportNumber').select();
			
		}
		else if (current_tab == 2){
			var currents = '';
			
			while (jQuery(':focus') != jQuery('#room-to-visit')) {
				if (currents == jQuery(':focus').attr('id')){
					NavigatorController.stepForward();
					break;
				}
				else {
					currents = jQuery(':focus').attr('id');
				}
				
				if (jQuery(':focus').attr('id')=='room-to-visit'){
					break;
				}
				else {
					NavigatorController.stepForward();
				}
			}
		}
		else if (current_tab == 3){
			NavigatorController.stepForward();
		}
	}
	
	function goto_previous_tab(current_tab){
		if (current_tab == 2){
			while (jQuery(':focus') != jQuery('#pulse-rate-field')) {
				if (jQuery(':focus').attr('id') == 'pulse-rate-field' || jQuery(':focus').attr('id') == 'datetime-field'){
					break;
				}
				else {
					NavigatorController.stepBackward();
				}
			}
		}
		else if (current_tab == 3){
			while (jQuery(':focus') != jQuery('#pitct-field')) {
				if (jQuery(':focus').attr('id') == 'pitct-field'){
					break;
				}
				else {
					NavigatorController.stepBackward();
				}
			}
		}
		else if (current_tab == 4){
			NavigatorController.stepBackward();
		}
	}
    function strReplace(word) {
        var res = word.replace("null", "");
        res=res.replace("null","");
        return res;
    }
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
	.catg{
		color: #363463;
		margin: 40px 10px 0 0;
	}
</style>

<openmrs:require privilege="Triage Queue" otherwise="/login.htm" redirect="/module/patientqueueui/queue.page?app=patientdashboardapp.triage"/>
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
				<a href="${ui.pageLink('patientqueueui','queue', [app:'patientdashboardapp.triage'])}">Triage</a>
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
							<label for="systolic-bp-field">Blood Pressure (Systolic)</label>
						</div>
						
						<div class="col4 last">
							<label for="diastolic-bp-field">Blood Pressure (Diastolic)</label>
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
							<% if (patient.gender == "F" && patient.age > 10)  { %>
								<label for="datetime-display"> Last Menstual Period </label>
							<% } %>
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
						
						<div class="col4 last">
							<% if (patient.gender == "F" && patient.age > 10)  { %>
							${ui.includeFragment("uicommons", "field/datetimepicker", [
								id: 'datetime',
								label: '',
								formFieldName: 'lastMenstrualDate',
								initialValue: vitals?.lastMenstrualDate,
								useTime: false,
								defaultToday: false,
								endDate: new Date()])
							}
							<% } %>
						</div>
					</div>

					<div class="onerow" style="margin-top: 50px">
						<div class="col4">&nbsp;</div>
						<div class="col4">&nbsp;</div>
						<div class="col4 last">
							<a class="button confirm" style="float:right; display:inline-block;margin-right:5px;" onclick="goto_next_tab(1);">
								<span>NEXT PAGE</span>
							</a>
						</div>
					</div>
                </div>
            </fieldset>
			
			
            <fieldset>
                <legend>Blood Group</legend>
				<div>
					<div class="onerow">
						<h2>Blood Measures</h2>
						
						<div class="col4">
							<label for="bloodGroup-field"> Blood Group </label>
						</div>
						
						<div class="col4">
							<label for="rhesusFactor-field"> Rhesus Factor</label>
						</div>
						
						<div class="col4 last">
							<label for="pitct-field"> PITCT </label>
						</div>
					</div>
					
					<div class="onerow">
						<div class="col4">
							<p id="bloodGroup">
								<select id="bloodGroup-field" class="focused" name="bloodGroup">
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
								<select id="rhesusFactor-field" name="rhesusFactor">
									<option value="">- Please select -</option>
									<option value="Positive (+)">Positive (+)</option>
									<option value="Negative (-)">Negative (-)</option>
									<option value="Not Known">Not Known</option>
								</select>
								<span id="fr2550" class="field-error" style="display: none"></span>
							</p>
						</div>
						
						<div class="col4 last">
							<p id="pitct">
								<select id="pitct-field" class="focused" name="pitct">
									<option value="">- Please select -</option>
									<option value="Reactive">Reactive</option>
									<option value="Non-Reactive">Non-Reactive</option>
									<option value="Not Known">Not Known</option>
								</select>
								<span id="fr4863" class="field-error" style="display: none"></span>
							</p>
						</div>
					</div>
					
					<div class="onerow" style="margin-top: 50px">
						<div class="col4" style="padding-left: 5px">
							<a class="button task" onclick="goto_previous_tab(2);">
								<span style="padding: 15px;">PREVIOUS</span>
							</a>
						</div>
						<div class="col4">&nbsp;</div>
						<div class="col4 last">
							<a class="button confirm" style="float:right; display:inline-block;margin-right:5px;" onclick="goto_next_tab(2);">
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
								<a class="button task" onclick="goto_previous_tab(3);">
									<span style="padding: 15px;">PREVIOUS</span>
								</a>
							</div>
							<div class="col4">&nbsp;</div>
							<div class="col4 last">
								<a class="button confirm" style="float:right; display:inline-block;margin-right:5px;" onclick="goto_next_tab(3);">
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
                    <div class="onerow">

                        <h2>Any existing illness/ conditions?
                            <p><input id="illnessExisting" type="radio" name="radiogroup1"<% if (patientMedicalHistory?.illnessExisting == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p><input type="radio" name="radiogroup1"<% if (patientMedicalHistory?.illnessExisting == "No") { %> checked="checked" <% } %>/> </p>No </h2>

                        <div class="col4">
                            What is the problem? <input type="text" value="${patientMedicalHistory?.illnessProblem}">
                        </div>

                        <div class="col4">
                            How long have you had it? <input type="text" value="${patientMedicalHistory?.illnessLong}">
                        </div>

                        <div class="col4 ">
                            How is your progress? <input type="text" value="${patientMedicalHistory?.illnessProgress}">
                        </div>
                        <div class="col4last ">
                            Where are the Medical Records? <input type="text" value="${patientMedicalHistory?.illnessRecord}">
                        </div>
                    </div>
                    <div class="onerow">
                        <h2>Suffered from any chronic illness?
                            <p><input id="chronicIllness" type="radio" name="radiogroup2"<% if (patientMedicalHistory?.chronicIllness == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p><input type="radio" name="radiogroup2"<% if (patientMedicalHistory?.chronicIllness == "No") { %> checked="checked" <% } %>/></p>No</h2>

                        <div class="col4">
                            What is the problem? <input type="text" value="${patientMedicalHistory?.chronicIllnessProblem}">
                        </p>
                        </div>

                        <div class="col4">
                            How long have you had it? <input type="text" value="${patientMedicalHistory?.chronicIllnessOccure}">
                        </div>

                        <div class="col4 ">
                            How is your progress? <input type="text" value="${patientMedicalHistory?.chronicIllnessOutcome}">
                        </div>
                        <div class="col4last ">
                            Where are the Medical Records? <input type="text" value="${patientMedicalHistory?.chronicIllnessRecord}">
                        </div>
                    </div>
                    <div class="onerow">
                        <h2> Any previous hospital admissions?
                            <p><input id="previousAdmission" type="radio" name="radiogroup3"<% if (patientMedicalHistory?.previousAdmission == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p>No<input type="radio" name="radiogroup3"<% if (patientMedicalHistory?.previousAdmission == "No") { %> checked="checked" <% } %>/></p></h2>

                        <div class="col4">
                            When was this? <input type="text" value="${patientMedicalHistory?.previousAdmissionWhen}">
                        </p>
                        </div>

                        <div class="col4">
                            What was the problem? <input type="text" value="${patientMedicalHistory?.previousAdmissionProblem}">
                        </div>

                        <div class="col4 ">
                            What was the outcome? <input type="text" value="${patientMedicalHistory?.previousAdmissionOutcome}">
                        </div>
                        <div class="col4last ">
                            Where are the Medical Records? <input type="text" value="${patientMedicalHistory?.previousAdmissionRecord}">
                        </div>
                    </div>
                    <div class="onerow">
                        <h2>Any previous operations/ investigations?
                            <p><input id="previousInvestigation" type="radio" name="radiogroup4"<% if (patientMedicalHistory?.previousInvestigation == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p>No<input type="radio" name="radiogroup4"<% if (patientMedicalHistory?.previousInvestigation == "No") { %> checked="checked" <% } %>/></p></h2>

                        <div class="col4">
                            When was this? <input type="text" value="${patientMedicalHistory?.previousInvestigationWhen}">
                        </p>
                        </div>

                        <div class="col4">
                            What was the problem? <input type="text" value="${patientMedicalHistory?.previousInvestigationProblem}">
                        </div>

                        <div class="col4 ">
                            What was the outcome? <input type="text" value="${patientMedicalHistory?.previousInvestigationOutcome}">
                        </div>
                        <div class="col4last ">
                            Where are the Medical Records? <input type="text" value="${patientMedicalHistory?.previousInvestigationRecord}">
                        </div>
                    </div>
                    <div>
                        <h2>Any previous operations/ investigations? </h2>
                        <p>BCG?</p><p><input id="bcg" type="radio" name="radiogroup5"<% if (patientMedicalHistory?.bcg == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p>No<input type="radio" name="radiogroup5" ></p> <p>Not Sure<input type="radio" name="radiogroup5"></p>
                        <p>3 Polio Doses?</p><p><input type="radio" name="radiogroup6"<% if (patientMedicalHistory?.polio == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p><p><input type="radio" name="radiogroup6" <% if (patientMedicalHistory?.polio == "No") { %> checked="checked" <% } %>/>No</p> <p><input type="radio" name="radiogroup6" <% if (patientMedicalHistory?.polio == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</p>
                        <p>3DPT/ Pentavalent Doses?</p><p><input type="radio" name="radiogroup7"<% if (patientMedicalHistory?.dpt == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p><input type="radio" name="radiogroup7"<% if (patientMedicalHistory?.dpt == "No") { %> checked="checked" <% } %>/>No</p> <p><input type="radio" name="radiogroup7"<% if (patientMedicalHistory?.dpt == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</p>
                        <p>Measles?</p><p><input type="radio" name="radiogroup8"<% if (patientMedicalHistory?.measles == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p><input type="radio" name="radiogroup8" <% if (patientMedicalHistory?.measles == "No") { %> checked="checked" <% } %>/>No</p> <p><input type="radio" name="radiogroup8"<% if (patientMedicalHistory?.measles == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</p>
                        <p>Pneumococcal?</p><p><input type="radio" name="radiogroup9"<% if (patientMedicalHistory?.pneumococcal == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p><input type="radio" name="radiogroup9" <% if (patientMedicalHistory?.pneumococcal == "No") { %> checked="checked" <% } %>/>No</p> <p><input type="radio" name="radiogroup9"<% if (patientMedicalHistory?.pneumococcal == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</p>
                        <p>Yellow Fever?</p><p><input type="radio" name="radiogroup10"<% if (patientMedicalHistory?.yellowFever == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p><input type="radio" name="radiogroup10" <% if (patientMedicalHistory?.yellowFever == "No") { %> checked="checked" <% } %>/>No</p> <p><input type="radio" name="radiogroup10"<% if (patientMedicalHistory?.yellowFever == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</p>
                        <p> 5 Tetanus Doses (If Female)?</p><p><input type="radio" name="radiogroup11"<% if (patientMedicalHistory?.tetanusMale == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p><input type="radio" name="radiogroup11"<% if (patientMedicalHistory?.tetanusMale == "No") { %> checked="checked" <% } %>/>No</p> <p><input type="radio" name="radiogroup11"<% if (patientMedicalHistory?.tetanusMale == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</p>
                        <p>3 Tetanus Doses (If Male)?</p><p><input type="radio" name="radiogroup12"<% if (patientMedicalHistory?.tetanusFemale == "Yes") { %> checked="checked" <% } %>/>Yes </p> <p><input type="radio" name="radiogroup12"<% if (patientMedicalHistory?.tetanusFemale == "No") { %> checked="checked" <% } %>/>No</p> <p><input type="radio" name="radiogroup12"<% if (patientMedicalHistory?.tetanusFemale == "Not Sure") { %> checked="checked" <% } %>/>Not Sure</p>

                    </div>
                    <div class="col4last ">
                        Other? <input type="text" value="${patientMedicalHistory?.otherVaccinations}">
                    </div>
                </div>
            </fieldset>
                <fieldset>
                    <legend>Drug History</legend>
                    <div>
                        <div class="onerow">

                            <h2>Current medications?
                                <p><input type="radio" name="radiogroup13"<% if (patientDrugHistory?.currentMedication == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                                <p><input type="radio" name="radiogroup13"<% if (patientDrugHistory?.currentMedication == "No") { %> checked="checked" <% } %>/>No</p> </h2>

                            <div class="col4">
                                What is the medication? <input type="text" value="${patientDrugHistory?.medicationName}">
                            </div>

                            <div class="col4">
                                For how long it has been taken? <input type="text" value="${patientDrugHistory?.medicationPeriod}">
                            </div>

                            <div class="col4 ">
                                Why is it being taken? <input type="text" value="${patientDrugHistory?.medicationReason}">
                            </div>
                            <div class="col4last ">
                                Where are the Medical Records? <input type="text" value="${patientDrugHistory?.medicationRecord}">
                            </div>
                        </div>
                        <div class="onerow">

                            <h2>Any medication you are sensitive to?
                                <p><input type="radio" name="radiogroup14"<% if (patientDrugHistory?.sensitiveMedication == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                                <p>No<input type="radio" name="radiogroup14"<% if (patientDrugHistory?.sensitiveMedication == "No") { %> checked="checked" <% } %>/> </p> </h2>

                            <div class="col4">
                                What is the medication? <input type="text" value="${patientDrugHistory?.sensitiveMedicationName}">
                            </div>

                            <div class="col4">
                                What are the symptoms you experience? <input type="text" value="${patientDrugHistory?.sensitiveMedicationSymptom}">
                            </div>
                        </div>
                        <div class="onerow">

                            <h2> Are you using any invasive contraception?
                                <p><input type="radio" name="radiogroup15"<% if (patientDrugHistory?.invasiveContraception == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                                <p>No<input type="radio" name="radiogroup15"<% if (patientDrugHistory?.invasiveContraception == "No") { %> checked="checked" <% } %>/></p> </h2>

                            <div class="col4">
                                What is the medication?<input type="text" value="${patientDrugHistory?.invasiveContraceptionName}">
                            </div>
                        </div>

                    </div>
                </fieldset>
            <fieldset>
                <legend>Family History</legend>
                <div>
                    <div class="onerow">

                        <h2>Status of father?
                            <p><input type="radio" name="radiogroup16"<% if (familyHistory?.fatherStatus == "Alive") { %> checked="checked" <% } %>/>Alive </p>
                            <p><input type="radio" name="radiogroup16"<% if (familyHistory?.fatherStatus == "Dead") { %> checked="checked" <% } %>/>Dead</p> </h2>

                        <div class="col4">
                            What was the cause of death? <input type="text" value="${familyHistory?.fatherDeathCause}">
                        </div>

                        <div class="col4">
                            How old were they? <input type="text" value="${familyHistory?.fatherDeathAge}">
                        </div>
                    </div>

                    <div class="onerow">

                        <h2>Status of mother?
                            <p><input type="radio" name="radiogroup17"<% if (familyHistory?.motherStatus == "Alive") { %> checked="checked" <% } %>/>Alive </p>
                            <p><input type="radio" name="radiogroup17"<% if (familyHistory?.motherStatus == "Dead") { %> checked="checked" <% } %>/> Dead</p> </h2>

                        <div class="col4">
                            What was the cause of death? <input type="text" value="${familyHistory?.motherDeathCause}">
                        </div>

                        <div class="col4">
                            How old were they? <input type="text" value="${familyHistory?.motherDeathAge}">
                        </div>
                    </div>

                    <div class="onerow">

                        <h2>Status of sibling?
                            <p><input type="radio" name="radiogroup18"<% if (familyHistory?.siblingStatus == "Alive") { %> checked="checked" <% } %>/>Alive </p>
                            <p>Dead<input type="radio" name="radiogroup18"> </p> </h2>

                        <div class="col4">
                            What was the cause of death? <input type="text" value="${familyHistory?.siblingDeathCause}">
                        </div>

                        <div class="col4">
                            How old were they? <input type="text" value="${familyHistory?.siblingDeathAge}">
                        </div>
                    </div>
                    <div class="col4last ">
                        Any family history of the following illness? <input type="text" value="${familyHistory?.familyIllnessHistory}">
                    </div>

                </div>
            </fieldset>
            <fieldset>
                <legend>Personal and Social</legend>
                <div>
                    <div class="onerow">

                        <h2> Do you smoke?
                            <p><input type="radio" name="radiogroup19"<% if (personalHistory?.smoke == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p><input type="radio" name="radiogroup19"<% if (personalHistory?.smoke == "No") { %> checked="checked" <% } %>/> </p>No</h2>

                        <div class="col4">
                            What do you smoke? <input type="text" value="${personalHistory?.smokeItem}">
                        </div>

                        <div class="col4">
                            What is your average in a day? <input type="text" value="${personalHistory?.smokeAverage}">
                        </div>

                    </div>
                    <div class="onerow">

                        <h2> Do you drink alcohol?
                            <p><input type="radio" name="radiogroup20"<% if (personalHistory?.smoke == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p>No<input type="radio" name="radiogroup20"<% if (personalHistory?.smoke == "No") { %> checked="checked" <% } %>/> </p> </h2>

                        <div class="col4">
                            What alcohol do you drink? <input type="text" value="${personalHistory?.alcoholItem}">
                        </div>

                        <div class="col4">
                            What is your average in a day? <input type="text" value="${personalHistory?.alcoholAverage}">
                        </div>
                    </div>

                    <div class="onerow">

                        <h2> Do you take any recreational drugs?
                            <p><input type="radio" name="radiogroup21"<% if (personalHistory?.drug == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p>No<input type="radio" name="radiogroup21"<% if (personalHistory?.drug == "No") { %> checked="checked" <% } %>/> </p> </h2>

                        <div class="col4">
                            What drugs do you take? <input type="text" value="${personalHistory?.drugItem}">
                        </div>

                        <div class="col4">
                            What is your average in a day? <input type="text" value="${personalHistory?.drugAverage}">
                        </div>
                    </div>
                    <div>
                        <div class="onerow">

                            <h2> Are you aware of your current HIV status?
                                <p><input type="radio" name="radiogroup22"<% if (personalHistory?.hivStatus == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                                <p>No<input type="radio" name="radiogroup22"<% if (personalHistory?.hivStatus == "No") { %> checked="checked" <% } %>/> </p> </h2>
                    </div>
                        <div class="onerow">
                            <h2> Have you been exposed to any HIV/ AIDS factor in the past year, or since your last HIV Test?
                                <p><input type="radio" name="radiogroup23"<% if (personalHistory?.exposedHiv == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                                <p>No<input type="radio" name="radiogroup23"<% if (personalHistory?.exposedHiv == "No") { %> checked="checked" <% } %>/> </p> </h2>

                            <div class="col4">
                                Which factors? <input type="text" value="${personalHistory?.exposedHivFactor}">
                            </div>
                        </div>
                    </div>
                    <div class="onerow">
                        <h2> Any close member in the family who can support during illness?
                            <p><input type="radio" name="radiogroup24"<% if (personalHistory?.familyHelp == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p>No<input type="radio" name="radiogroup24"<% if (personalHistory?.familyHelp == "No") { %> checked="checked" <% } %>/> </p> </h2>

                        <div class="col4">
                            Who else can support you during illness? <input type="text" value="${personalHistory?.otherHelp}">
                        </div>
                    </div>
                    <div class="onerow">
                        <h2>  Do you have a regular source of income?
                            <p><input type="radio" name="radiogroup25"<% if (personalHistory?.incomeSource == "Yes") { %> checked="checked" <% } %>/>Yes </p>
                            <p>No<input type="radio" name="radiogroup26"<% if (personalHistory?.incomeSource == "No") { %> checked="checked" <% } %>/> </p> </h2>
                    </div>
                </div>
            </fieldset>

        </section>
        <div id="confirmation">
			<div style="display:none;">
				<span id="confirmation_label" class="title">Confirm</span>
				<div class="before-dataCanvas"></div>
				<div id="dataCanvas"></div>
				<div class="after-data-canvas"></div>
				<div id="confirmationQuestion">

				</div>
			</div>
			
			<div class="dashboard">
				<div class="info-section">
					<div class="info-header">
						<i class="icon-list-ul"></i>
						<h3>Vitals Summary</h3>
					</div>
					<div class="info-body">
						<ul>
							<li id="li01"><span class="status active"></span><div>Weight:</div> 			<small id="summ_01">/</small></li>
							<li id="li02"><span class="status active"></span><div>Height:</div> 			<small id="summ_02">/</small></li>
							<li id="li03"><span class="status active"></span><div>MUA CC:</div> 			<small id="summ_03">/</small></li>
							<li id="li04"><span class="status active"></span><div>Chest CC:</div> 			<small id="summ_04">/</small></li>
							<li id="li05"><span class="status active"></span><div>Abdominal CC:</div>		<small id="summ_05">/</small></li>
							<li id="li06"><span class="status active"></span><div>Temperature:</div>		<small id="summ_06">/</small></li>
							
							<li id="li07"><span class="status active"></span><div>BP (Systolic):</div>		<small id="summ_07">/</small></li>
							<li id="li08"><span class="status active"></span><div>BP (Diastolic):</div>		<small id="summ_08">/</small></li>
							<li id="li09"><span class="status active"></span><div>Respiratory Rate:</div>	<small id="summ_09">/</small></li>
							<li id="li10"><span class="status active"></span><div>Pulse Rate:</div>			<small id="summ_10">/</small></li>
							<li id="li11"><span class="status active"></span><div>Last Periods:</div>		<small id="summ_11">/</small></li>
							
							<li id="li12"><span class="status active"></span><div>Blood Group:</div>		<small id="summ_12">/</small></li>
							<li id="li13"><span class="status active"></span><div>Rhesus Factor:</div>		<small id="summ_13">/</small></li>
							<li id="li14"><span class="status active"></span><div>PITCT:</div>				<small id="summ_14">/</small></li>
							<li id="li15"><span class="status active"></span><div>Room to Visit:</div>		<small id="summ_15">/</small></li>
						</ul>
					</div>
				</div>
			</div>
			
			<div class="onerow" style="margin-top: 150px">
				<a class="button task ui-tabs-anchor" onclick="goto_previous_tab(4);">
					<span style="padding: 15px;">PREVIOUS</span>
				</a>
				
				<input id="submit" type="submit" class="submitButton confirm right" value="FINISH" style="float:right; display:inline-block; margin-left: 5px;" />
				<input id="cancelSubmission" class="cancel" type="button" value="RESET" style="float:right; display:inline-block;" onclick="location.reload();"/>
			</div>
        </div>
    </form>
</div>