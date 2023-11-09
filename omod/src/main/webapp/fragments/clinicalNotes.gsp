<%
	ui.includeCss("uicommons", "datetimepicker.css")
	ui.includeCss("ehrconfigs", "onepcssgrid.css")
	ui.includeCss("ehrconfigs", "custom.css")
	ui.includeJavascript("patientdashboardapp", "note.js")
	ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
	ui.includeJavascript("uicommons", "handlebars/handlebars.min.js")
	ui.includeJavascript("uicommons", "navigator/validators.js")
	ui.includeJavascript("uicommons", "navigator/navigator.js")
	ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js")
	ui.includeJavascript("uicommons", "navigator/navigatorModels.js")
	ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js")
	ui.includeJavascript("uicommons", "navigator/exitHandlers.js")
	ui.includeJavascript("patientdashboardapp", "knockout-3.4.0.js")
%>

${ ui.includeFragment("patientdashboardapp", "patientDashboardAppScripts", [note: note, listOfWards: listOfWards, internalReferralSources: internalReferralSources, externalReferralSources: externalReferralSources, referralReasonsSources: referralReasonsSources, outcomeOptions: outcomeOptions ]) }
<style>
.dialog textarea{
	resize: none;
}

.dialog li label span {
	color: #f00;
	float: right;
	margin-right: 10px;
}
.icon-remove{
	cursor: pointer!important;
}
.diagnosis-carrier-div{
	border-width: 1px 1px 1px 10px;
	border-style: solid;
	border-color: #404040;
	padding: 0px 10px 3px;
}
#diagnosis-carrier input[type="radio"] {
	-webkit-appearance: checkbox;
	-moz-appearance: checkbox;
	-ms-appearance: checkbox;
}
#prescriptionAlert {
	text-align: center;
	border:     1px #f00 solid;
	color:      #f00;
	padding:    5px 0;
}
.alert{
	position: relative;
	padding: .75rem 1.25rem;
	margin-bottom: 1rem;
	border: 1px solid transparent;
	border-top-color: transparent;
	border-right-color: transparent;
	border-bottom-color: transparent;
	border-left-color: transparent;
	border-top-color: transparent;
	border-right-color: transparent;
	border-bottom-color: transparent;
	border-left-color: transparent;
	border-radius: .25rem;
	color: #721c24;
	background-color: #f8d7da;
	border-color: #f5c6cb;
}
</style>

<div id="content">
	<form method="post" id="notes-form" class="simple-form-ui">
		<section>
			<span class="title">Clinical Notes</span>
			<fieldset class="no-confirmation">
				<div data-bind="if: !(\$root.admitted !== true)"><div id="errorAlert" class="alert">The patient has been admitted. Cannot proceed!</div></div>
				<legend>Symptoms</legend>
				<div style="padding: 0 4px">
					<label for="symptom" class="label">Symptoms <span class="important">*</span></label>
					<input type="text" id="symptom" name="symptom" placeholder="Add Symptoms" />
					<field>
						<input type="hidden" id="symptoms-set" class="required"/>
						<span id="symptoms-lbl" class="field-error" style="display: none"></span>
					</field>
				</div>

				<div class="tasks" id="task-symptom" style="display:none;">
					<header class="tasks-header">
						<span id="title-symptom" class="tasks-title">PATIENT'S SYMPTOMS</span>
						<a class="tasks-lists"></a>
					</header>

					<div class="symptoms-qualifiers" data-bind="foreach: signs" >
						<div class="symptom-container">
							<div class="symptom-label">
								<span class="right pointer show-qualifiers"><i class="icon-caret-down small" title="more"></i></span>
								<span class="right pointer" data-bind="click: \$root.removeSign"><i class="icon-remove small"></i></span>
								<span data-bind="text: label"></span>
							</div>

							<div class="qualifier-container" style="display: none;">
								<ul class="qualifier" data-bind="foreach: qualifiers">
									<li>
										<span data-bind="text: label"></span>
										<div data-bind="if: options().length >= 1">
											<div data-bind="foreach: options" class="qualifier-option">
												<p class="qualifier-field">
													<input type="radio" data-bind="checkedValue: \$data, checked: \$parent.answer" >
													<label data-bind="text: label"></label>
												</p>
											</div>
										</div>
										<div data-bind="if: options().length === 0" >
											<p>
												<input type="text" data-bind="value: freeText" >
											</p>
										</div>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>History</legend>
				<p>
					<label class="label" for="history">History of present illness</label>
					<span>
						Date of Onset<input data-bind="value: \$root.onSetDate" type="date" id="onSetDate" name="onSetDate" />
					</span>

					<textarea data-bind="value: \$root.illnessHistory" id="history" name="history" rows="10" cols="74"></textarea>
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Physical Examination</legend>
				<p class="input-position-class">
					<label class="label">Physical Examination <span class="important">*</span></label>
					<field>
						<textarea data-bind="value: \$root.physicalExamination" id="examination" name="examination" rows="10" cols="74" class="required"></textarea>
						<span id="examination-lbl" class="field-error" style="display: none"></span>
					</field>
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Diagnosis</legend>
				<div>
					<h2>Patient's Diagnosis <span class="important">*</span></h2>

					<div>
						<p class="input-position-class">
							<input type="text" id="diagnosis" name="diagnosis" placeholder="Select Diagnosis" />
						</p>

						<div id="task-diagnosis" class="tasks" style="display:none;">
							<header class="tasks-header">
								<span id="title-diagnosis" class="tasks-title">DIAGNOSIS</span>
								<a class="tasks-lists"></a>
							</header>

							<div id="diagnosis-carrier" data-bind="foreach: diagnoses" style="margin-top: -2px">
								<div class="diagnosis-container" style="border-top: medium none !important;">
									<span class="right pointer" data-bind="click: \$root.removeDiagnosis"><i class="icon-remove small"></i></span>
									<div class="diagnosis-carrier-div" style="border-width: 1px 1px 1px 10px; border-style: solid; border-color: -moz-use-text-color; padding: 0px 10px 3px;">
										<span data-bind="text: label" style="display: block; font-weight: bold;"></span>

										<label style="display: inline-block; font-size: 11px; padding: 0px; cursor: pointer; margin: 0px 0px 0px -5px;">
											<input value="true"  data-bind="checked: provisional" class="chk-provisional" type="radio" style="margin-top: 3px"/>Provisional
										</label>

										<label style="display: inline-block; font-size: 11px; padding: 0px; cursor: pointer; margin: 0">
											<input value="false" data-bind="checked: provisional" class="chk-final" type="radio" style="margin-top: 3px"/>Final
										</label>
									</div>

								</div>
							</div>
						</div>

						<p class="input-position-class">
							<field>
								<input type="hidden" id="diagnosis-set" class="required" />
								<span id="diagnosis-lbl" class="field-error" style="display: none"></span>
							</field>
						</p>
					</div>
				</div>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Procedures</legend>
				<div class="input-position-class">
					<label class="label" for="procedure">Patient Procedures</label>
					<input type="text" id="procedure" name="procedure" placeholder="Specify a Procedure" />
				</div>

				<div id="task-procedure" class="tasks" style="display:none;">
					<header class="tasks-header">
						<span id="title-procedure" class="tasks-title">PROCEDURES</span>
						<a class="tasks-lists"></a>
					</header>

					<div data-bind="foreach: procedures">
						<div class="procedure-container">
							<span class="right pointer" data-bind="click: \$root.removeProcedure"><i class="icon-remove small"></i></span>
							<p data-bind="text: label"></p>
							<span data-bind="if: schedulable">Schedule:<input type="date"></span>
						</div>
					</div>
				</div>
				<p>
					<input type="hidden" id="procedure-set" />
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Investigations</legend>
				<div>
					<div class="input-position-class">
						<label class="label" for="investigation">Investigation:</label>
						<input type="text" id="investigation" name="investigation" />
					</div>

					<div id="task-investigation" class="tasks" style="display:none;">
						<header class="tasks-header">
							<span id="title-investigation" class="tasks-title">INVESTIGATION</span>
							<a class="tasks-lists"></a>
						</header>

						<div data-bind="foreach: investigations">
							<div class="investigation-container">
								<span class="right pointer" data-bind="click: \$root.removeInvestigation"><i class="icon-remove small"></i></span>
								<p data-bind="text: label"></p>
							</div>
						</div>
					</div>
					<div style="display:none">
						<p><input type="text" ></p>
					</div>
					<p>
						<input type="hidden" id="investigation-set" />
					</p>
				</div>
				<div>
                    <p class="input-position-class">
                        <label class="label">Investigation Notes</label>
                        <field>
                            <textarea data-bind="value: \$root.investigationNotes" id="investigationNotes" name="investigationNotes" rows="10" cols="74"></textarea>
                            <span id="investigationNotes-lbl" class="field-error" style="display: none"></span>
                        </field>
                    </p>
                    <p>
                        <input type="hidden" id="investigationsNotes-set" />
                    </p>
				</div>
			</fieldset>
			<fieldset class="no-confirmation">
				<legend>Prescription</legend>
				<div>
					<div style="display:none">
						<p><input type="text"></p>
					</div>
					<h2>Prescribe Medicine</h2>
					<table id="addDrugsTable">
						<thead>
						<tr>
							<th>Drug Name</th>
							<th>Dosage</th>
							<th>Formulation</th>
							<th>Frequency</th>
							<th>Days</th>
							<th>Comments</th>
							<th></th>
						</tr>
						</thead>
						<tbody data-bind="foreach: drugs">
						<tr>
							<td data-bind="text: drugName"></td>
							<td data-bind="text: dosageAndUnit" ></td>
							<td data-bind="text: formulation().label"></td>
							<td data-bind="text: frequency().label"></td>
							<td data-bind="text: numberOfDays"></td>
							<td data-bind="text: comment"></td>
							<td>
								<a href="#" title="Remove">
									<i data-bind="click: \$root.removePrescription" class="icon-remove small" style="color: red" ></i>
								</a>
								<!-- <a href="#"><i class="icon-edit small"></i></a> -->
							</td>
						</tr>
						</tbody>
					</table>
					<br/>
					<button id="add-prescription">Add</button>
				</div>
				<p>
					<input type="hidden" id="drug-set" />
				</p>
			</fieldset>
			<fieldset class="no-confirmation">
				<legend>Notes/Instructions</legend>
				<p class="input-position-class">
					<label class="label">Notes</label>
					<textarea data-bind="value: \$root.otherInstructions" id="instructions" name="instructions" rows="10" cols="74"></textarea>
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Outcome</legend>
				<div>
					<div class="onerow" style="padding-top:2px;">
						<h2>What is the outcome of this visit? <span class="important">*</span></h2>
						<div data-bind="foreach: availableOutcomes" class="outcomes-container">
							<div data-bind="if: !(\$root.admitted !== false && \$data.id !== 2)">
								<p class="outcome">
									<label style="display: inline-block;">
										<input type="radio" name="outcome" data-bind="click: updateOutcome"/>
										<span data-bind="text: option.label" style="color:#000; font-size: 1em; cursor: pointer"></span>
									</label>
									<span data-bind="if: \$data.option.id === 1 && \$root.outcome() && \$root.outcome().option.id === 1">
										<span id="follow-up-date" class="date" style="float: right;">
											<input data-bind="value : followUpDate" style="width: 378px;" class="required">
											<span class="add-on"><i class="icon-calendar small"></i></span>
										</span>
									</span>

									<span data-bind="if: \$data.option.id === 2 && \$root.outcome() && \$root.outcome().option.id === 2">
										<select data-bind="options: \$root.inpatientWards, optionsText: 'label', value: admitTo" style="width: 400px !important; float: right;"></select>
									</span>

								</p>
							</div>
						</div>
						<span data-bind="if: \$root.outcome() && \$root.outcome().option.id ===6">
							<h2>Internal Referral information</h2>

							<div class="onerow">
								<div class="col4"><label for="internalReferral">Referral Available</label></div>
								<div class="col4"><label for="internalReferral" id="refTitle">Internal Referral</label></div>
							</div>

							<div class="onerow">
								<div class="col4">
									<div class="input-position-class">
										<select id="availableReferral" name="availableReferral">
											<option value="0">Select Option</option>
											<option value="1">Internal Referral</option>
										</select>
									</div>
								</div>

								<div class="col4">
									<div class="input-position-class">
										<div>
											<select id="internalReferral" name="internalReferral" onchange="loadExternalReferralCases();"  data-bind="options: \$root.internalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
											</select>
										</div>
									</div>
								</div>
							</div>

							<div class="onerow" id="refReason1">
								<div class="col4">
									<label for="referralReasons" style="margin-top:20px;">Referral Reasons</label>
								</div>
								<div class="col4">
									<label id="specify-lbl" for="specify" style="margin-top:20px;">If Other, Please Specify</label>
								</div>		
							</div>

							<div class="onerow" id="refReason2">
								<div class="col4">
									<select id="referralReasons" name="referralReasons" data-bind="options: \$root.referralReasonsOptions, optionsText: 'label', value: \$root.referralReasons, optionsCaption: 'Please select...'" style="margin-top: 5px;">
									</select>
								</div>

								<div class="col4 last" style="width: 65%;">
									<input type="text" id="specify" placeholder="Please Specify" name="specify" data-bind="value: \$root.specify"/>
								</div>
							</div>

							<div class="onerow" id="refReason3">
								<div class="col4">
									<label for="referralComments" style="margin-top:20px;">Comments</label>
								</div>
								<div class="col4">		
									<textarea type="text" id="referralComments"   name="referralComments" data-bind="value: \$root.referralComments" placeholder="COMMENTS"  style="height: 80px; width: 650px;"></textarea>
								</div>
							</div>
						</span>
						<span data-bind="if: \$root.outcome() && \$root.outcome().option.id ===7">
              <h2>Go to external referral tab to refer this patient to another facility</h2>
            </span>

					</div>

					<field>
						<input type="hidden" id="outcome-set" class="required" />
						<span id="outcome-lbl" class="field-error" style="display: none"></span>
					</field>

				</div>
			</fieldset>
		</section>

		<div id="confirmation" style="width:74.6%; min-height: 400px;">
			<span id="confirmation_label" class="title">Confirmation</span>

			<div class="dashboard">
				<div class="info-section">
					<div class="info-header">
						<i class="icon-list-ul"></i>
						<h3>OPD SUMMARY & CONFIRMATION</h3>
					</div>

					<div class="info-body">
						<table id="summaryTable">
							<tr>
								<td><span class="status active"></span>Symptoms</td>
								<td data-bind="foreach: signs">
									<span data-bind="text: label"></span>
									<span data-bind="if: (\$index() !== (\$parent.signs().length - 1))"><br/></span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>History</td>
								<td>N/A</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Physical Examination</td>
								<td>N/A</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Diagnosis</td>
								<td data-bind="foreach: diagnoses">
									<span data-bind="text: label"></span>
									<span data-bind="if: (\$index() !== (\$parent.diagnoses().length - 1))"><br/></span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Procedures</td>
								<td>
									<span data-bind="foreach: procedures">
										<span data-bind="text: label"></span>
										<span data-bind="if: (\$index() !== (\$parent.procedures().length - 1))"><br/></span>
									</span>
									<span data-bind="if: (procedures().length === 0)">N/A</span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Investigations</td>
								<td>
									<span data-bind="foreach: investigations">
										<span data-bind="text: label"></span>
										<span data-bind="if: (\$index() !== (\$parent.investigations().length - 1))"><br/></span>
									</span>
									<span data-bind="if: (investigations().length === 0)">N/A</span>
								</td>
							</tr>
							<tr>
								<td><span class="status active"></span>Investigations Notes</td>
								<td>N/A</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Prescriptions</td>
								<td>
									<span data-bind="foreach: drugs">
										<span data-bind="text: drugName()+' '+formulation().label"></span>
										<span data-bind="if: (\$index() !== (\$parent.drugs().length - 1))"><br/></span>
									</span>
									<span data-bind="if: (drugs().length === 0)">N/A</span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Notes</td>
								<td>N/A</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Outcome</td>
								<td>N/A</td>
							</tr>
						</table>
					</div>
				</div>
			</div>

			<div id="confirmationQuestion">
				<p style="display: inline;">
					<button class="submitButton confirm" style="float: right">Submit</button>
				</p>

				<button id="cancelButton" class="cancel cancelButton" style="margin-left: 5px;">Cancel</button>
				<p style="display: inline">&nbsp;</p>
			</div>
		</div>
	</form>
</div>
<div id="confirmDialog" class="dialog" style="display: none;">
	<div class="dialog-header">
		<i class="icon-save"></i>

		<h3>Confirm</h3>
	</div>


	<div class="dialog-content">
		<h3>Cancelling will lead to loss of data,are you sure you want to do this?</h3>

		<span  class="button confirm right" style="float: right">Confrim</span>
		<span class="button cancel" >Cancel</span>
	</div>
</div>

<div id="prescription-dialog" class="dialog" style="display:none;">
	<div class="dialog-header">
		<i class="icon-folder-open"></i>

		<h3>Prescription</h3>
	</div>

	<div class="dialog-content">
		<ul>
			<li id="prescriptionAlert">
				<div>No batches found in Pharmacy for the Selected Drug/Formulation combination</div>
			</li>

			<li>
				<label>Drug<span>*</span></label>
				<input class="drug-name" id="drugSearch" type="text" data-bind="value: prescription.drug().drugName, valueUpdate: 'blur'">
			</li>
			<li>
				<label>Dosage<span>*</span></label>
				<input type="text" class="drug-dosage" data-bind="value: prescription.drug().dosage" style="width: 60px!important;">
				<select id="dosage-unit" class="drug-dosage-unit" data-bind="options: prescription.drug().drugUnitsOptions, value: prescription.drug().drugUnit, optionsText: 'label',  optionsCaption: 'Select Unit'" style="width: 191px!important;"></select>
			</li>

			<li>
				<label>Formulation<span>*</span></label>
				<select id="drugFormulation" class="drug-formulation" data-bind="options: prescription.drug().formulationOpts, value: prescription.drug().formulation, optionsText: 'label',  optionsCaption: 'Select Formulation'"></select>
			</li>
			<li>
				<label>Frequency<span>*</span></label>
				<select class="drug-frequency" data-bind="options: prescription.drug().frequencyOpts, value: prescription.drug().frequency, optionsText: 'label',  optionsCaption: 'Select Frequency'"></select>
			</li>

			<li>
				<label>No. 0f Days<span>*</span></label>
				<input type="text" class="drug-number-of-days" data-bind="value: prescription.drug().numberOfDays">
			</li>
			<li>
				<label>Comment</label>
				<textarea class="drug-comment" data-bind="value: prescription.drug().comment"></textarea>
			</li>
		</ul>

		<label class="button confirm right">Confirm</label>
		<label class="button cancel">Cancel</label>
	</div>
</div>
<script>
	var prescription = {drug: ko.observable(new Drug())};
	ko.applyBindings(prescription, jq("#prescription-dialog")[0]);
</script>