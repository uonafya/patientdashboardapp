function Note(noteObj) {
	var self = this;
	self.patientId = noteObj.patientId;
	self.queueId = noteObj.queueId;
	self.opdId = noteObj.opdId;
	self.opdLogId = noteObj.opdLogId;
	self.signs = ko.observableArray([]);
	self.diagnosisProvisional = ko.observable(noteObj.diagnosisProvisional);
	self.diagnoses = ko.observableArray([]);
	self.procedures = ko.observableArray([]);
	self.investigations = ko.observableArray([]);
	self.drugs = ko.observableArray([]);
	self.frequencyOpts = ko.observableArray([]);
    self.drugUnitsOptions= ko.observableArray([]);
	self.referralReasonsOptions = ko.observableArray([]);
	self.admitted = noteObj.admitted;
	self.illnessHistory = noteObj.illnessHistory;
	self.physicalExamination = noteObj.physicalExamination;
	self.otherInstructions = noteObj.otherInstructions;
	self.comments = noteObj.comments;
	self.facility = noteObj.facility;
	self.dosage = noteObj.dosage;
	self.specify = noteObj.specify;
	self.referredTo;
	self.referralReasons;


	self.outcome = ko.observable();
	self.referredWard = ko.observable();

	this.addSign = function(symptom) {
		//check if the item has already been added
		var match = ko.utils.arrayFirst(self.signs(), function(item) {
			return symptom.id === item.id;
		});

		if (!match) {
			this.signs.push(symptom);
		}
	};

	this.removeSign = function(symptom) {
		self.signs.remove(symptom);
	};

	this.addDiagnosis = function(diagnosis) {
		//check if the item has already been added
		var match = ko.utils.arrayFirst(self.diagnoses(), function(item) {
			return diagnosis.id === item.id;
		});

		if (!match) {
			self.diagnoses.push(diagnosis);
		}
	};

	this.removeDiagnosis = function(diagnosis) {
		self.diagnoses.remove(diagnosis);
	};

	this.addProcedure = function(procedure) {
		//check if the item has already been added
		var match = ko.utils.arrayFirst(self.procedures(), function(item) {
			return procedure.id === item.id;
		});

		if (!match) {
			self.procedures.push(procedure);
		}
	};

	this.removeProcedure = function(procedure) {
		self.procedures.remove(procedure);
	};

	this.addInvestigation = function(investigation) {
		//check if the item has already been added
		var match = ko.utils.arrayFirst(self.investigations(), function(item) {
			return investigation.id === item.id;
		});

		if (!match) {
			self.investigations.push(investigation);
		}
	};

	this.removeInvestigation = function(investigation) {
		self.investigations.remove(investigation);
	};

	self.getPrescription = function(drugName) {
		var match = ko.utils.arrayFirst(self.drugs(), function(drug) {
			return drug.name().toLowerCase() === drugName.toLowerCase();
		});
		return match;
	}

	this.addPrescription = function(prescription) {
		self.drugs.push(prescription);
	};

	this.removePrescription = function(drug) {
		self.drugs.remove(drug);
	};

	this.refer = function(referTo) {
		self.referral(referTo);
	}

}

function Sign(signObj) {
	this.id = signObj.id;
	this.label = signObj.label;
	this.qualifiers = ko.observableArray([]);
	this.qualifiers(signObj.qualifiers);
}

function Qualifier(id, label, options, answer) {
	self = this;
	self.id = id
	self.label = label;
	self.options = ko.observableArray(options);
	self.answer = ko.observable(answer);
	self.freeText = ko.observable();
}

function Option(id, label) {
	this.id = id;
	this.label = label;

	this.display = function(data) {
		console.log(data);
	}
}

function Diagnosis(diagnosisObj) {
	this.id = diagnosisObj.id;
	this.label = diagnosisObj.label;
}

function Investigation(investigationObj) {
	this.id = investigationObj.id;
	this.label = investigationObj.label;
}

function Procedure(procedureObj) {
	this.id = procedureObj.id;
	this.label = procedureObj.label;
	this.schedulable = procedureObj.schedulable;
}

function Drug() {
	this.drugName = ko.observable();
	this.frequencyOpts = ko.observableArray([]);
    this.drugUnitsOptions = ko.observableArray([]);
    this.drugUnit=ko.observable();
	this.frequency = ko.observable();
	this.formulationOpts = ko.observableArray([]);
	this.formulation = ko.observable();
	this.dosage = ko.observable();
	this.comment = ko.observable();
	this.numberOfDays = ko.observable(0);
}

function Frequency(freqObj) {
	this.id = freqObj.id;
	this.label = freqObj.label;
}



function Formulation(formulationObj) {
	this.id = formulationObj.id;
	this.label = formulationObj.label;
}

function DrugUnit(unitObj) {
	this.id = unitObj.id;
	this.label = unitObj.label;
}

function Outcome(outcomeObj) {
	this.option = new Option(outcomeObj.id,outcomeObj.label);
	this.followUpDate = outcomeObj.followUpDate;
	this.admitTo = outcomeObj.admitTo;

	this.updateOutcome = function(data) {
		note.outcome(this);
		return true;
	}
}

function Referral(referralObj) {
	this.id = referralObj.id;
	this.label = referralObj.label;
	this.referral;
}

if (!Array.prototype.find) {
	Array.prototype.find = function(predicate) {
		if (this === null) {
			throw new TypeError(
					'Array.prototype.find called on null or undefined');
		}
		if (typeof predicate !== 'function') {
			throw new TypeError('predicate must be a function');
		}
		var list = Object(this);
		var length = list.length >>> 0;
		var thisArg = arguments[1];
		var value;

		for (var i = 0; i < length; i++) {
			value = list[i];
			if (predicate.call(thisArg, value, i, list)) {
				return value;
			}
		}
		return undefined;
	};
}
