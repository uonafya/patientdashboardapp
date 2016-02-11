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
				<a href="${ui.pageLink('registration','patientRegistration')}">Registration</a>
			</li>
			<li>
				<i class="icon-chevron-right link"></i>
				Revist Patient
			</li>
		</ul>
	</div>

	<div class="patient-header new-patient-header">
		<div class="demographics">
			<h1 class="name">
				<span>Surname,<em>surname</em></span>
				<span>Other Names &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em></span>
			</h1>
			
			<br>
			<div class="status-container">
				<span class="status active"></span>
				Active Visit
			</div>
			<div class="tag">Outpatient</div>
		</div>

		<div class="identifiers">
			<em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
			<span>KALMSHU893094</span>
			<br>
		</div>
		<div class="close"></div>
	</div>
	
    <form method="post" id="notes-form" class="simple-form-ui" style="margin-top:30px;">
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
		
        <div id="confirmation">
			<div style="display:none;">
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
							
							<li id="li12"><span class="status active"></span><div>Blood Group:</div>		<small id="summ_12">/</small></small></li>
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