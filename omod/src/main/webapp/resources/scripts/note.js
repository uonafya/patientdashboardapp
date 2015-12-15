function Note(noteObj) {
	var self = this;
	self.patientId = noteObj.patientId;
	self.queueId = noteObj.queueId;
	self.opdId = noteObj.opdId;
	self.opdLogId = noteObj.opdLogId;
    self.signs = ko.observableArray([]);
    self.diagnoses = ko.observableArray([]);
    self.procedures = ko.observableArray([]);
    self.investigations = ko.observableArray([]);
    self.drugs = ko.observableArray([]);
	self.frequencyOpts = ko.observableArray([]);
	self.formulationOpts = ko.observableArray();
	self.admitted = noteObj.admitted;
    self.availableOutcomes = jq.map(noteObj.availableOutcomes, function(outcome) {
        return new Option(outcome.id, outcome.label);
    });
    self.outcome = ko.observable();
    self.inpatientWards = noteObj.inpatientWards;
    self.referredWard = ko.observable();

    this.addSign = function (symptom) {
        if (this.signs.indexOf(symptom) < 0) {
            this.signs.push(symptom);
        }
    };

    this.removeSign = function (symptom) {
        self.signs.remove(symptom);
    };

    this.addDiagnosis = function (diagnosis) {
        if (self.diagnosis.indexOf(diagnosis)) {
            diagnoses.push(diagnosis);
        }
    };

    this.removeDiagnosis = function (diagnosis) {
        self.diagnoses.remove(diagnosis);
    };

    this.addProcedure = function (procedure) {
        if (self.procedures.indexOf(procedure)) {
            self.procedures.push(procedure);
        }
    };

    this.removeProcedure = function (procedure) {
        self.procedures.remove(procedure);
    };

    this.addInvestigation = function (investigation) {
        if (self.investigations.indexOf(investigation)) {
            self.investigations.push(investigation);
        }
    };

    this.removeInvestigation = function (investigation) {
        self.investigations.remove(investigation);
    };

    this.addDrug = function () {
        self.drugs.push(new Drug());
    };

    this.removeDrug = function (drug) {
    	self.drugs.remove(drug);
    };

}

function Sign (signObj) {
    this.id = signObj.id;
    this.label = signObj.label;
    this.qualifiers = ko.observableArray([]);
    this.qualifiers(signObj.qualifiers);
}

function Qualifier (id, label, options, answer) {
	this.id = id
    this.label = label;
    this.options = ko.observableArray(options);
    this.answer = ko.observable(answer);
    this.freeText= ko.observable();
}

function Option(id, label) {
    this.id = id;
    this.label = label

    this.display = function (data) {
        console.log(data);
        console.log(note);
        return true;
    }
}

function Diagnosis (diagnosisObj) {
	this.id = diagnosisObj.id;
	this.label = diagnosisObj.label;
}

function Investigation (investigationObj) {
	this.id = investigationObj.id;
	this.label = investigationObj.label;
}

function Procedure (procedureObj) {
	this.id = procedureObj.id;
	this.label = procedureObj.label;
}

function Drug () {
	this.name = ko.observable(); 
	this.frequency = ko.observable();
	this.formulation = ko.observable();
	this.comment = ko.observable();
	this.numberOfDays = ko.observable(0);
}

function Frequency (freqObj) {
	this.id = freqObj.id;
	this.label = freqObj.label;
}

function Formulation (formulationObj) {
	this.id = formulationObj.id;
	this.label = formulationObj.label;
}
