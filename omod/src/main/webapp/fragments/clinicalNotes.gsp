<%
    ui.includeCss("patientdashboardapp", "patientdashboardapp.css");
    ui.includeCss("uicommons", "datetimepicker.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("patientdashboardapp", "note.js")
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1)
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
    ui.includeJavascript("patientdashboardapp", "knockout-3.4.0.js")
%>

${ ui.includeFragment("patientdashboardapp", "patientDashboardAppScripts", [note: note, listOfWards: listOfWards, internalReferralSources: internalReferralSources, externalReferralSources: externalReferralSources, referralReasonsSources: referralReasonsSources, outcomeOptions: outcomeOptions ]) }

<div id="content">
    <form method="post" id="notes-form" class="simple-form-ui">
        <section>
            <span class="title">Clinical Notes</span>
        <fieldset class="no-confirmation">
			<legend>Symptoms</legend>
			<p class="input-position-class">
				<label for="symptom">Symptom</label>
				<input type="text" id="symptom" name="symptom" placeholder="Add Symptoms" />
			</p>

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
											<input type="text" data-bind="value: \$parent.freeText" >
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
            <legend>Illness History</legend>
            <p>
                <label for="history">History of Presenting illness</label>
                <textarea data-bind="value: \$root.illnessHistory" id="history" name="history" rows="10" cols="74"></textarea>
            </p>
        </fieldset>
		
        <fieldset class="no-confirmation">
            <legend>Physical Examination</legend>
            <p class="input-position-class">
                <label>Physical Examination</label>
                <textarea data-bind="value: \$root.physicalExamination" id="examination" name="examination" rows="10" cols="74"></textarea>
            </p>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Diagnosis</legend>
            <div>
				<h2>Patient's Diagnosis</h2>
				<div class="tasks-list">
					<p class="left">
						<label id="ts01" class="tasks-list-item" for="provisional-diagnosis">
							
							<input type="radio" name="diagnosis_type" id="provisional-diagnosis" value="true" data-bind="checked: diagnosisProvisional" class="tasks-list-cb focused"/>
							
							<span class="tasks-list-mark"></span>
							<span class="tasks-list-desc">Provisional</span>
						</label>
					</p>
					
					<p class="left">
						<label class="tasks-list-item" for="final-diagnosis">
							<input type="radio" name="diagnosis_type" id="final-diagnosis" value="false" data-bind="checked: diagnosisProvisional" class="tasks-list-cb"/>
							<span class="tasks-list-mark"></span>
							<span class="tasks-list-desc">Final</span>
						</label>
					</p>
				</div>
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
							<div class="diagnosis-container">
								<span class="right pointer" data-bind="click: \$root.removeDiagnosis"><i class="icon-remove small"></i></span>
								<p data-bind="text: label"></p>
							</div>
						</div>
					</div>
				</div>
                </div>
            </fieldset>
        <fieldset class="no-confirmation">
            <legend>Procedures</legend>
			<p class="input-position-class">
				<label for="procedure">Patient Procedures</label>
				<input type="text" id="procedure" name="procedure" placeholder="Specify a Procedure" />
			</p>
			
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
        </fieldset>
		
        <fieldset class="no-confirmation">
            <legend>Investigations</legend>
            <div>
                <p class="input-position-class">
                    <label for="investigation">Investigation:</label>
                    <input type="text" id="investigation" name="investigation" />
                </p>
				
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
		</div>
            </fieldset>
            <fieldset class="no-confirmation">
                <legend>Prescription</legend>

                <div>
                    <div style="display:none">
                        <p><input type="text"></p>
                    </div>

                    <h2>Prescribe Medicine</h2>
                    <table>
                        <thead>
                        <tr>
                            <th>Drug Name</th>
                            <th>Dosage</th>
                            <th>Dosage Unit</th>
                            <th>Formulation</th>
                            <th>Frequency</th>
                            <th>No of Days</th>
                            <th>Comments</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody data-bind="foreach: drugs">
                        <tr>
                            <td data-bind="text: drugName"></td>
                            <td data-bind="text: dosage"></td>
                            <td data-bind="text: drugUnit().label"></td>
                            <td data-bind="text: formulation().label"></td>
                            <td data-bind="text: frequency().label"></td>
                            <td data-bind="text: numberOfDays"></td>
                            <td data-bind="text: comment"></td>
                            <td>
                                <a href="#" title="Remove"><i data-bind="click: \$root.removePrescription"
                                                              class="icon-remove small"></i></a>
                                <!-- <a href="#"><i class="icon-edit small"></i></a> -->
                            </td>
                        </tr>
                    </tbody>
                </table>
                <br/>
                <button id="add-prescription">Add</button>
            </div>
        </fieldset>
		
		
        <fieldset class="no-confirmation">
            <legend>Other Instructions</legend>
            <p class="input-position-class">
                <label>Other Instructions</label>
				<textarea data-bind="value: \$root.otherInstructions" id="instructions" name="instructions" rows="10" cols="74"></textarea>
            </p>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Outcome</legend>
            <div>
                <h2> Patient Referral</h2>
				<div class="onerow">
					<div class="col4"><label for="internalReferral">Internal Referral</label></div>
					<div class="col4"><label for="externalReferral">External Referral</label></div>
					<div class="col4 last"><label for="facility"> Facility Name</label></div>
				</div>
				
				<div class="onerow">
					<div class="col4">
						<p class="input-position-class">
							<select id="internalReferral" name="internalReferral" data-bind="options: \$root.internalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
							</select>
						</p>
					</div>
					
					<div class="col4">

						<field><p class="input-position-class">
                            <select id="externalReferral" name="externalReferral" onchange="loadExternalReferralCases();" data-bind="options: \$root.externalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
                            </select>
						</p></field> </div>
					</div>

                    <div class="col4 last">
                        <p class="input-position-class">
                            <input type="text" id="facility" placeholder="Facility Name" name="facility" data-bind="value: \$root.facility">
                            </input>
                        </p>
                    </div> <br/>

                    <div class="onerow" style="padding-top:-5px;">
                        <label for="referralReasons" style="margin-top:20px;">Referral Reasons</label>
                        <select id="referralReasons" name="referralReasons" data-bind="options: \$root.referralReasonsOptions, optionsText: 'label', value: \$root.referralReasons, optionsCaption: 'Please select...'">
                        </select>

                    </div>

                <div class="onerow" style="padding-top:-5px;">
                    <label for="specify" style="margin-top:20px;">If Other Reasons, Please Specify</label>
                        <input type="text" id="specify" placeholder="Please Specify" name="specify" data-bind="value: \$root.specify">
                    </input>

                </div>

                    <div class="onerow" style="padding-top:-5px;">
                        <label for="referralComments" style="margin-top:20px;">Comments</label>
                        <textarea type="text" id="referralComments"   name="referralComments" data-bind="value: \$root.referralComments" placeholder="COMMENTS"  style="height: 80px; width: 650px;"></textarea>
                    </div>

                        <div>
                            <h2>What is the outcome of this visit?</h2>

                            <div data-bind="foreach: availableOutcomes" class="outcomes-container">
                                <div data-bind="if: !(\$root.admitted !== false && \$data.id !== 2)">
                                    <p class="outcome">
                                        <input type="radio" name="outcome" data-bind="click: updateOutcome">
                                        <label data-bind="text: option.label"></label>
                                        <span data-bind="if: \$data.option.id === 1 && \$root.outcome() && \$root.outcome().option.id === 1">
                                            <span id="follow-up-date" class="date">
                                                <input data-bind="value : followUpDate">
                                                <span class="add-on"><i class="icon-calendar small"></i></span>
                                            </span>
                                        </span>
                                        <span data-bind="if: \$data.option.id === 2 && \$root.outcome() && \$root.outcome().option.id === 2">
                                            <select data-bind="options: \$root.inpatientWards, optionsText: 'label', value: admitTo"></select>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
            </fieldset>
        </section>

        <div id="confirmation" style="width:74.6%; min-height: 400px;">
            <span id="confirmation_label" class="title">Confirmation</span>

            <div class="before-dataCanvas"></div>

            <div id="dataCanvas"></div>

            <div class="after-data-canvas"></div>

            <div id="confirmationQuestion">
                &nbsp; &nbsp; Confirm Posting Information?<br/><br/>

                <p style="display: inline">
                    <button class="submitButton confirm" style="float: right">Submit</button>
                </p>

                <p style="display: inline">
                    <button class="cancel">Cancel</button>
                </p>
            </div>
        </div>
    </form>
</div>

<div id="prescription-dialog" class="dialog">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>

        <h3>Prescription</h3>
    </div>

    <div class="dialog-content">
        <ul>
            <li>
                <span>Drug</span>
                <input class="drug-name" type="text"
                       data-bind="value: prescription.drug().drugName, valueUpdate: 'blur'">
            </li>
            <li>
                <span>Dosage</span>
                <input type="text" data-bind="value: prescription.drug().dosage">
            </li>
            <li>
                <span>Dosage Unit</span>
                <select data-bind="options: prescription.drug().drugUnitsOptions, value: prescription.drug().drugUnit, optionsText: 'label',  optionsCaption: 'Select Unit'"></select>
            </li>
            <li>
                <span>Formulation</span>
                <select data-bind="options: prescription.drug().formulationOpts, value: prescription.drug().formulation, optionsText: 'label',  optionsCaption: 'Select Formulation'"></select>
            </li>
            <li>
                <span>Frequency</span>
                <select data-bind="options: prescription.drug().frequencyOpts, value: prescription.drug().frequency, optionsText: 'label',  optionsCaption: 'Select Frequency'"></select>
            </li>

            <li>
                <span>Number of Days</span>
                <input type="text" data-bind="value: prescription.drug().numberOfDays">
            </li>
            <li>
                <span>Comment</span>
                <textarea data-bind="value: prescription.drug().comment"></textarea>
            </li>
        </ul>

        <span class="button confirm right">Confirm</span>
        <span class="button cancel">Cancel</span>
    </div>
</div>

<script>
	var prescription = {drug: ko.observable(new Drug())};
	ko.applyBindings(prescription, jq("#prescription-dialog")[0]);
</script>
