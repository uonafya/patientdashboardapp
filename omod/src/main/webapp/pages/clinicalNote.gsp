<head>
	<% ui.includeJavascript("patientdashboardui", "note.js"); %>
	
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/jquery-1.10.2.js"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/knockout/3.4.0/knockout-debug.js"></script>
	<script src="/openmrs/ms/uiframework/resource/patientdashboardui/scripts/note.js"></script>
</head>
<script>
jq = jQuery;
jq(function() {

    jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getNote") }',
        {
            'patientId': ${patientId},
            'opdId': ${opdId},
            'queueId':${queueId},
            'opdLogId':${opdLogId}
        }
    ).success(function(data) {    
        console.log(data);
        note = new Note(data);
        ko.applyBindings(note);
        var mappedSigns = jq.map(jq.parseJSON(data.signs), function(sign) {
            return new Sign(sign);
        });
        note.signs(mappedSigns);
        
        var mappedDiagnoses = jq.map(jq.parseJSON(data.diagnoses), function(diagnosis) {
            return new Diagnosis(diagnosis);
        });
        note.diagnoses(mappedDiagnoses);
        
        var mappedInvestigations = jq.map(jq.parseJSON(data.investigations), function(investigation) {
            return new Investigation(investigation);
        });
        note.investigations(mappedInvestigations);
        
        var mappedProcedures = jq.map(jq.parseJSON(data.procedures), function(procedure) {
            return new Procedure(procedure);
        });
        note.procedures(mappedProcedures);
    });

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

    jq(".prescription").on("focus.autocomplete", ".drug-name", function () {
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
          jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getFormulationByDrugName") }',
            {
              "drugName": ui.item.label
            }
          ).success(function(data) {
            var formulations = jq.map(data, function (formulation) {
              return new Formulation({ id: formulation.id, label: formulation.name});
            });
            note.formulationOpts(formulations);
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
            note.addProcedure(new Procedure({id: ui.item.value, label: ui.item.label}));
        },
        open: function() {
            jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });



  });
</script>

<form method="post">
    <fieldset>
        <legend>
            Clinical Notes
        </legend>
        <p class="input-position-class">
            <label for="history">History of Presenting illness</label>
            <textarea id="history" name="history" rows="1" cols="15"></textarea>
        </p>
        
        <div>
            <p class="input-position-class">
                <label for="symptom">Symptom</label>
                <input type="text" id="symptom" name="symptom" />
            </p>
            <div id="symptoms-qualifiers" data-bind="foreach: signs" >
                <div class="symptom">
                    <p data-bind="text: label"></p>
                    <button data-bind="click: \$parent.removeSign">Remove</button>
                </div>
                <div class="qualifier" data-bind="foreach: qualifiers">
                    <label data-bind="text: label"></label>
                    <div data-bind="if: options().length >= 1">
                        <p data-bind="foreach: options">
	                        <input type="radio" data-bind="checkedValue: \$data, checked: \$parent.answer" >
	                        <label data-bind="text: label"></label>
                        </p>
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
        <p class="input-position-class left">
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
                <button data-bind="click: \$root.removeProcedure">Remove</button>
            </div>
        </div>

       
        
        <p class="input-position-class prescription">
            <label>Prescription</label>
            <table>
                <thead>
                    <th>Drug Name</th>
                    <th>Formulation</th>
                    <th>Frequency</th>
                    <th>Number of Days</th>
                    <th>Comment</th>
                </thead>
                <tbody data-bind="foreach: drugs">
                    <td>
                        <input class="drug-name" type="text" data-bind="value: name" >
                    </td>
                    <td>
                        <select data-bind="options: \$root.formulationOpts, value: formulation, optionsText: 'label'"></select>
                    </td>
                    <td>
                        <select data-bind="options: \$root.frequencyOpts, value: frequency, optionsText: 'label'"></select>
                    </td>
                    <td>
                        <input type="text" data-bind="value: numberOfDays" >
                    </td>
                    <td>
                        <textarea data-bind="value: comment"></textarea>
                    </td>
                </tbody>
            </table>
            <button data-bind="click: addDrug">Add</button>
            <select data-bind="options: formulationOpts, optionsText: 'label'"></select>
        </p>
        
        <p class="input-position-class">
            <label for="note">Other Instructions</label>
            <input type="text" id="note" name="note" />
        </p>
        
        <p class="input-position-class left">
        <label for="internalReferral">Internal Referral</label>
        <select id="internalReferral" name="internalReferral">
            <option value="">Select Referral</option>
        </select>
        </p>
        
        <p class="input-position-class left">
            <label for="externalReferral">External Referral</label>
            <select id="externalReferral" name="externalReferral">
                <option value="">Select Referral</option>
            </select>
        </p>
        
        <p class="input-position-class">
            <label>Outcome:</label>
            <span data-bind="foreach: availableOutcomes">
            	<span data-bind="if: !(\$root.admitted !== false && \$data.id !== 2)">
                <input type="radio" data-bind="checkedValue: \$data, checked: \$root.outcome, click: display" >
                <label data-bind="text: label"></label>
                <span data-bind="if: \$data.id === 1 && \$root.outcome() && \$root.outcome().id === 1">
                    <input data-bind="value : FollowUpDate" type="date">
                </span>
                <span data-bind="if: \$data.id === 2 && \$root.outcome() && \$root.outcome().id === 2">
                    <select data-bind="options: \$root.inpatientWards, optionsText: 'label', value: \$root.referredWard" ></select>
                </span>
                </span>
            </span>
        </p>

    </fieldset>
    <div>
        <h2>Debug Vals</h2>
        <p>
            queueId=${queueId}
        </p>
        <p>
            opdLogId=${opdLogId}
        </p>
    </div>
</form>
