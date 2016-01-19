<%
    ui.includeJavascript("patientdashboardui", "note.js")
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeCss("uicommons", "datetimepicker.css")
%>
<script>
var jq = jQuery,
    previousNote = JSON.parse('${note}');
    note = new Note(previousNote);

var mappedSigns = jq.map(jq.parseJSON(previousNote.signs), function(sign) {
    return new Sign(sign);
});
note.signs(mappedSigns);

var mappedDiagnoses = jq.map(jq.parseJSON(previousNote.diagnoses), function(diagnosis) {
    return new Diagnosis(diagnosis);
});
note.diagnoses(mappedDiagnoses);

var mappedInvestigations = jq.map(jq.parseJSON(previousNote.investigations), function(investigation) {
    return new Investigation(investigation);
});
note.investigations(mappedInvestigations);

var mappedProcedures = jq.map(jq.parseJSON(previousNote.procedures), function(procedure) {
    return new Procedure(procedure);
});
note.procedures(mappedProcedures);

jq(function() {
    ko.applyBindings(note, jq("#notes-form")[0]);
    jq( "#symptom" ).autocomplete({
         source: function( request, response ) {
          jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getSymptoms") }',
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
           jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getQualifiers") }',
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
        jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getDiagnosis") }',
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
            jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getProcedures") }',
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
            jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getInvestigations") }',
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

    jq("#symptoms-qualifiers").on("click", ".showquestions",function(){

        if (jq(this).attr("value") == "less")
        {
            jq(this).attr("value","more");
        }
        else
        {
            jq(this).attr("value","less");
        };

        var symptom = jq(this).parent("div");
        var qualifiers = symptom.siblings(".qualifier");
        qualifiers.toggle();
    });

    jq(".submit").on("click", function(event){
        event.preventDefault();
        jq.ajax({
          type: 'POST',
          url: '${ ui.actionLink("patientdashboardui", "clinicalNoteProcessor", "processNote") }',
          data :{ note: ko.toJSON(note, ["label", "id", "admitted","availableOutcomes", "diagnoses", "illnessHistory", "inpatientWarads", "investigations", "opdId", "opdLogId", "otherInstructions", "patientId", "procedures", "queueId", "signs"]) }
        });
    });
});
</script>

<form method="post" id="notes-form">
    <fieldset>
        <legend>
            Clinical Notes
        </legend>
        <p class="input-position-class">
            <label for="history">History of Presenting illness</label>
            <textarea data-bind="value: \$root.illnessHistory" id="history" name="history" rows="1" cols="15"></textarea>
        </p>
        
        <div>
            <p class="input-position-class">
                <label for="symptom">Symptom</label>
                <input type="text" id="symptom" name="symptom" />
            </p>

            <div id="symptoms-qualifiers" data-bind="foreach: signs" >
                <div class="symptom">
                    <p data-bind="text: label"></p>
                    <input value="more" type="button" class="showquestions">
                    <button data-bind="click: \$parent.removeSign">Remove</button>
                </div>
                <div class="qualifier" data-bind="foreach: qualifiers" style="display: none;" >
                    <label data-bind="text: label"></label>
                    <div data-bind="if: options().length >= 1">
                        <div data-bind="foreach: options">
                            <p>
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
                </div> 
            </div>
        </div>

        <p class="input-position-class left">
            <input type="radio" name="radio_dia" value="prov_dia" id="prov_dia" onclick="loadSelectedDiagnosisList();"/>
            <label for="prov_dia">Provisional</label>
        </p>
        <p class="input-position-class">
            <input type="radio" name="radio_dia" value="final_dia" id="final_dia" onclick="removeSelectedDia();"/>
            <label for="final_dia">Final</label>
        </p>

        <div>
            <p class="input-position-class">
                <label for="diagnosis">Diagnosis:</label>
                <input type="text" id="diagnosis" name="diagnosis" />
            </p>
            <div data-bind="foreach: diagnoses">
                <p data-bind="text: label"></p>
                <button data-bind="click: \$root.removeDiagnosis">Remove</button>
            </div>
        </div>
        
        <div>
            <p class="input-position-class">
                <label for="procedure">Post for Procedure:</label>
                <input type="text" id="procedure" name="procedure" />
            </p>
            <div data-bind="foreach: procedures">
                <p data-bind="text: label"></p>
                <span data-bind="if: schedulable">Schedule:<input type="date"></span>
                <button data-bind="click: \$root.removeProcedure">Remove</button>
            </div>
        </div>

        <div>
            <p class="input-position-class">
                <label for="investigation">Investigation:</label>
                <input type="text" id="investigation" name="investigation" />
            </p>
            <div data-bind="foreach: investigations">
                <p data-bind="text: label"></p>
                <button data-bind="click: \$root.removeInvestigation">Remove</button>
            </div>
        </div>
        
        <p>Prescription</p>
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
        <p class="input-position-class">
            <label for="note">Other Instructions</label>
            <input  data-bind="value: \$root.otherInstructions" type="text" />
        </p>
        
        <p class="input-position-class">
        <label for="internalReferral">Internal Referral</label>
        <select id="internalReferral" name="internalReferral">
            <option value="">Select Referral</option>
        </select>
        </p>
        
        <p class="input-position-class">
            <label for="externalReferral">External Referral</label>
            <select id="externalReferral" name="externalReferral">
                <option value="">Select Referral</option>
            </select>
        </p>
        
        <div class="input-position-class">
            <label>Outcome:</label>
            <div data-bind="foreach: availableOutcomes">
                <div data-bind="if: !(\$root.admitted !== false && \$data.id !== 2)">
                    <p>
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

        <p><button class="submit">Submit</button></p>

    </fieldset>
</form>

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
	          jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getDrugs") }',
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
	          jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getFormulationByDrugName") }',
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
.dialog input {
    display: block;
    margin: 5px 0;
    color: #363463;
    padding: 5px 0 5px 10px;
    background-color: #FFF;
    border: 1px solid #DDD;
    width: 97%;
}
</style>
