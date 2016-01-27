<%
    ui.includeCss("uicommons", "datetimepicker.css")
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
	
    def successUrl = ui.pageLink("patientqueueui", "chooseOpd")
%>
<script>
var jq = jQuery,
    NavigatorController,
    previousNote = JSON.parse('${note}'),
    note = new Note(previousNote);

var getJSON = function (dataToParse) {
	if (typeof dataToParse === "string") {
		return JSON.parse(dataToParse);
	}
	return dataToParse;
}
var outcomeOptions = ${outcomeOptions.collect { it.toJson() }}
note.availableOutcomes = jq.map(outcomeOptions, function(outcomeOption){
	return new Outcome(outcomeOption);
});
note.inpatientWards = ${listOfWards.collect { it.toJson() }};
note.internalReferralOptions = ${internalReferralSources.collect { it.toJson() }};
note.externalReferralOptions = ${externalReferralSources.collect { it.toJson() }}

var mappedSigns = jq.map(getJSON(previousNote.signs), function(sign) {
    return new Sign(sign);
});
note.signs(mappedSigns);

var mappedDiagnoses = jq.map(getJSON(previousNote.diagnoses), function(diagnosis) {
    return new Diagnosis(diagnosis);
});
note.diagnoses(mappedDiagnoses);

var mappedInvestigations = jq.map(getJSON(previousNote.investigations), function(investigation) {
    return new Investigation(investigation);
});
note.investigations(mappedInvestigations);

var mappedProcedures = jq.map(getJSON(previousNote.procedures), function(procedure) {
    return new Procedure(procedure);
});
note.procedures(mappedProcedures);

note

jq(function() {
    NavigatorController = new KeyboardController();
    ko.applyBindings(note, jq("#notes-form")[0]);
    jq( "#symptom" ).autocomplete({
         source: function( request, response ) {
          jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getSymptoms") }',
              {
                  q: request.term
              }
          ).success(function(data) {
              var results = [];
              for (var i in data) {
                 var result = { label: data[i].name, value: data[i].id};
                 results.push(result);
              }
              console.log(data);
              response(results);
          });
         },
         minLength: 3,
         select: function( event, ui ) {
           event.preventDefault();
           jq(this).val(ui.item.label);
           jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getQualifiers") }',
               {
                   signId: ui.item.value
               }
           ).success(function(data) {
               var qualifiers = jq.map(data, function (qualifier) {
                   return new Qualifier(qualifier.id, qualifier.label, 
                       jq.map(qualifier.options, function (option) {
                           return new Option(option.id, option.label);
                       }));
               });
               note.addSign(new Sign({"id": ui.item.value, "label": ui.item.label, "qualifiers": qualifiers}));
           });
         },
         open: function() {
           jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
         },
         close: function() {
           jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
         }
       });

    jq("#diagnosis").autocomplete({
      source: function( request, response ) {
        jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getDiagnosis") }',
          {
            q: request.term
          }
        ).success(function(data) {
          var results = [];
          for (var i in data) {
            var result = { label: data[i].name, value: data[i].id};
            results.push(result);
          }
          response(results);
        });
      },
      minLength: 3,
      select: function( event, ui ) {
        event.preventDefault();
        jq(this).val(ui.item.label);
        note.addDiagnosis(new Diagnosis({id: ui.item.value, label: ui.item.label}));
      },
      open: function() {
        jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
      },
      close: function() {
        jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
      }
    });

    jq("#procedure").autocomplete({
        source: function( request, response ) {
            jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getProcedures") }',
                    {
                        q: request.term
                    }
            ).success(function(data) {
                        procedureMatches = [];
                        for (var i in data) {
                            var result = { label: data[i].label, value: data[i].id, schedulable: data[i].schedulable };
                            procedureMatches.push(result);
                        }
                        response(procedureMatches);
                    });
        },
        minLength: 3,
        select: function( event, ui ) {
            event.preventDefault();
            jq(this).val(ui.item.label);
            var procedure = procedureMatches.find(function (procedureMatch) {
               return procedureMatch.value === ui.item.value;
            });
            note.addProcedure(new Procedure({id: procedure.value, label: procedure.label, schedulable: procedure.schedulable}));
        },
        open: function() {
            jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });

    jq("#investigation").autocomplete({
        source: function( request, response ) {
            jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getInvestigations") }',
                    {
                        q: request.term
                    }
            ).success(function(data) {
                        var results = [];
                        for (var i in data) {
                            var result = { label: data[i].name, value: data[i].id};
                            results.push(result);
                        }
                        response(results);
                    });
        },
        minLength: 3,
        select: function( event, ui ) {
            event.preventDefault();
            jq(this).val(ui.item.label);
            note.addInvestigation(new Investigation({id: ui.item.value, label: ui.item.label}));
        },
        open: function() {
            jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });

    jq(".symptoms-qualifiers").on("click", "span.show-qualifiers", function(){
        console.log("Clicked");
        var qualifierContainer = jq(this).parents(".symptom-container").find(".qualifier-container");
        var icon = jq(this).find("i");
        qualifierContainer.toggle();
        if (qualifierContainer.is(":visible")) {
            icon.removeClass("icon-caret-down").addClass("icon-caret-up");
        } else {
            icon.removeClass("icon-caret-up").addClass("icon-caret-down");
        }
    });

    jq(".submitButton").on("click", function(event){
        event.preventDefault();
        jq.ajax({
          type: 'POST',
          url: '${ ui.actionLink("patientdashboardapp", "clinicalNoteProcessor", "processNote", [ successUrl: successUrl ]) }',
          data :{ note: ko.toJSON(note, ["label", "id", "admitted", "diagnosisProvisional","diagnoses", "illnessHistory", "inpatientWarads", "investigations", "opdId", "opdLogId", "otherInstructions", "patientId", "procedures", "queueId", "signs", "referredTo"]) },
          success: function (data, status, xhr) {
              var redirectUrl = xhr.getResponseHeader('Location');
              console.log(xhr.getAllResponseHeaders());
              console.log(redirectUrl);
              window.location.href = '${ui.pageLink("patientqueueui", "queue", [app: "patientdashboardapp.opdqueue"])}';
          }
        });
    });

    jq(".cancel").on("click", function(e){
        e.preventDefault();
    });
});
</script>

<div id="content">
<form method="post" id="notes-form" class="simple-form-ui">
    <section>
        <span class="title">Clinical Notes</span>
        <fieldset class="no-confirmation">
            <legend>Illness History</legend>
            <p>
                <label for="history">History of Presenting illness</label>
                <textarea data-bind="value: \$root.illnessHistory" id="history" name="history" rows="10" cols="74"></textarea>
            </p>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Symptoms</legend>
                <p class="input-position-class">
                    <label for="symptom">Symptom</label>
                    <input type="text" id="symptom" name="symptom" />
                </p>

                <div class="symptoms-qualifiers" data-bind="foreach: signs" >
                    <div class="symptom-container">
                        <p class="symptom-label">
                            <span class="right pointer show-qualifiers"><i class="icon-caret-down small" title="more"></i></span>
                            <span class="right pointer" data-bind="click: \$root.removeSign"><i class="icon-remove small"></i></span>
                            <span data-bind="text: label"></span>
                        </p>
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
                <p class="input-position-class">
                    <input type="radio" name="diagnosis_type" id="provisional-diagnosis" value="true" data-bind="checked: diagnosisProvisional" />
                    <label for="provisional-diagnosis">Provisional</label>
                </p>
                <p class="input-position-class">
                    <input type="radio" name="diagnosis_type" id="final-diagnosis" value="false" data-bind="checked: diagnosisProvisional"/>
                    <label for="final-diagnosis">Final</label>
                </p>

                <div>
                    <p class="input-position-class">
                        <label for="diagnosis">Diagnosis:</label>
                        <input type="text" id="diagnosis" name="diagnosis" />
                    </p>
                    <div data-bind="foreach: diagnoses">
                        <div class="diagnosis-container">
                            <span class="right pointer" data-bind="click: \$root.removeDiagnosis"><i class="icon-remove small"></i></span>
                            <p data-bind="text: label"></p>
                        </div>
                    </div>
                </div>
            </div>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Procedures</legend>
            <div>
                <p class="input-position-class">
                    <label for="procedure">Procedure:</label>
                    <input type="text" id="procedure" name="procedure" />
                </p>
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
                <div data-bind="foreach: investigations">
                    <div class="investigation-container">
                        <span class="right pointer" data-bind="click: \$root.removeInvestigation"><i class="icon-remove small"></i></span>
                        <p data-bind="text: label"></p>
                    </div>
                </div>
            </div>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Prescription</legend>
            <div>
                <div style="display:none">
                    <p><input type="text" ></p>
                </div>
                <h3>Prescribe</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Drug Name</th>
                            <th>Formulation</th>
                            <th>Frequency</th>
                            <th>Number of Days</th>
                            <th>Comments</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: drugs">
                        <tr>
                            <td data-bind="text: name"></td>
                            <td data-bind="text: formulation.label"></td>
                            <td data-bind="text: frequency.label"></td>
                            <td data-bind="text: numberOfDays"></td>
                            <td data-bind="text: comment"></td>
                            <td>
                                <a href="#" title="Remove"><i data-bind="click: \$root.removePrescription" class="icon-remove small"></i></a>
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
                <input  data-bind="value: \$root.otherInstructions" type="text" />
            </p>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Outcome</legend>
            <div>
                <h3>Refer patient:</h3>
                <p class="input-position-class">
                    <label for="internalReferral">Internal Referral</label>
                    <select id="internalReferral" name="internalReferral" data-bind="options: \$root.internalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
                    </select>
                </p>
        
                <p class="input-position-class">
                    <label for="externalReferral">External Referral</label>
                    <select id="externalReferral" name="externalReferral" data-bind="options: \$root.externalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
                    </select>
                </p>
            </div>
            <div>
                <h3>What is the outcome of this visit?</h3>
                <div data-bind="foreach: availableOutcomes" class="outcomes-container">
                    <div data-bind="if: !(\$root.admitted !== false && \$data.id !== 2)">
                        <p class="outcome">
                            <input type="radio" name="outcome" data-bind="click: updateOutcome" >
                            <label data-bind="text: label"></label>
                            <span data-bind="if: \$data.id === 1 && \$root.outcome() && \$root.outcome().id === 1">
                                <span id="follow-up-date" class="date">
                                    <input data-bind="value : followUp" >
                                    <span class="add-on"><i class="icon-calendar small"></i></span>
                                </span>
                            </span>
                            <span data-bind="if: \$data.id === 2 && \$root.outcome() && \$root.outcome().id === 2">
                                <select data-bind="options: \$root.inpatientWards, optionsText: 'label', value: admitTo" ></select>
                            </span>
                        </p>
                    </div>
                </div>
            </div>
        </fieldset>
    </section>
    <div id="confirmation">
        <span id="confirmation_label" class="title">Confirmation</span>
        <div class="before-dataCanvas"></div>
        <div id="dataCanvas"></div>
        <div class="after-data-canvas"></div>
        <div id="confirmationQuestion">
            Proceed?
            <p style="display: inline">
                <button class="submitButton confirm right">Submit</button>
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
                <input class="drug-name" type="text" data-bind="value: name, valueUpdate: 'blur'" >
            </li>
            <li>
                <span>Formulation</span>
                <select data-bind="options: formulationOpts, value: formulation, optionsText: 'label'"></select>
            </li>
            <li>
                <span>Frequency</span>
                <select data-bind="options: frequencyOpts, value: frequency, optionsText: 'label'"></select>
            </li>
            <li>
                <span>Number of Days</span>
                <input type="text" data-bind="value: numberOfDays" >
            </li>
            <li>
                <span>Comment</span>
                <textarea data-bind="value: comment"></textarea>
            </li>
        </ul>
       
        <span class="button confirm right"> Confirm </span>
        <span class="button cancel"> Cancel </span>
    </div>
</div>

<script>
var prescription = {}
jq(function(){
	jq("#notes-form").on('focus', '#follow-up-date', function () {
		jq(this).datetimepicker({
		  minView: 2,
		  autoclose: true,
		  pickerPosition: "bottom-left",
		  todayHighlight: false,
		  startDate: "+0d",
		  format: "dd/mm/yyyy"});
	});

	var prescriptionDialog = emr.setupConfirmationDialog({
	    selector: '#prescription-dialog',
	    actions: {
		    confirm: function() {
			    console.log(prescription.name());
			    note.addPrescription(prescription);
		        prescriptionDialog.close();
			},
			cancel: function() {
			    prescription = {};
			    prescriptionDialog.close();
			}
	    }
	});

	jq("#add-prescription").on("click", function(e){
		e.preventDefault();
	    prescription = new Drug();
	    prescription.frequencyOpts(note.frequencyOpts());
	    ko.applyBindings(prescription, jq("#prescription-dialog")[0]);
	    prescriptionDialog.show();
	});

	jq(".drug-name").on("focus.autocomplete", function () {
	      var selectedInput = this;
	      jq(this).autocomplete({
	        source: function( request, response ) {
	          jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getDrugs") }',
	            {
	              q: request.term
	            }
	          ).success(function(data) {
	            var results = [];
	            for (var i in data) {
	              var result = { label: data[i].name, value: data[i].id};
	              results.push(result);
	            }
	            response(results);
	          });
	        },
	        minLength: 3,
	        select: function( event, ui ) {
	          event.preventDefault();
	          jq(selectedInput).val(ui.item.label);
	        },
	        change: function (event, ui) {
	          event.preventDefault();
	          jq(selectedInput).val(ui.item.label);
	          console.log(ui.item.label);
	          jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getFormulationByDrugName") }',
	            {
	              "drugName": ui.item.label
	            }
	          ).success(function(data) {
	            var formulations = jq.map(data, function (formulation) {
	              return new Formulation({ id: formulation.id, label: formulation.name});
	            });
	            prescription.formulationOpts(formulations);
	          });
	        },
	        open: function() {
	          jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
	        },
	        close: function() {
	          jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
	        }
	      });
	    });
});
</script>

<style>
.simple-form-ui section {
   width: 74%;
}
.dialog input {
    display: block;
    margin: 5px 0;
    color: #363463;
    padding: 5px 0 5px 10px;
    background-color: #FFF;
    border: 1px solid #DDD;
    width: 97%;
}
.symptom-container, .diagnosis-container, .procedure-container, .investigation-container {
    border-top: darkgrey dashed 1px;
    margin-top: 8px;
}
.qualifier-container {
    margin-left: 20px;
    background-color: white;
    padding: 5px 0 5px 15px;
    font-size: .95em;
}
.qualifier-container p.qualifier-field label, .outcomes-container p.outcome {
    font-size: .95em;
    line-height: 19px;
}
.qualifier-option {
    margin-bottom: 10px;
}
.pointer :hover {
    cursor: pointer;
}
</style>
