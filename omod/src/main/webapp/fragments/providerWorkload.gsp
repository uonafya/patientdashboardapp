<div class="row">
    <div class="col-6">
        <div style="margin-top: -1px " class="onerow">
            <i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
            <label>&nbsp;&nbsp;From&nbsp;</label>${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'fromDate', id: 'summaryFromDate', label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
            <label>&nbsp;&nbsp;To&nbsp;</label  >${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'toDate',    id: 'summaryToDate',   label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
            <button id="opdFilter" type="button" class=" btn btn-primary right">${ui.message("Filter")}</button>
        </div>
    </div>
</div>
<div>
    <table border="0" cellspacing="0" cellpadding="0" style="width=100%;">
        <tr>
          <td valign="top">
            <div class="card">
              <div class="card-header">Patients Served</div>
              <div class="card-body">
                <div id="patientTbody">
                </div>
              </div>
              <div class="card-footer"></div>
            </div>
         </td>
          <td valign="top">
            <div class="card">
              <div class="card-header">Final Diagnosis</div>
              <div class="card-body">
                <div id="diagnosis">
                  <ul id="fDiagnosisDetails"></ul>
                </div>
              </div>
              <div class="card-footer"></div>
            </div>
         </td>
         <td valign="top">
            <div class="card">
              <div class="card-header">Procedures</div>
              <div class="card-body">
                  <div id="procedures">
                      <ul id="proceduresTbody"></ul>
                  </div>
              </div>
              <div class="card-footer"></div>
            </div>
         </td>
         <td valign="top">
            <div class="card">
              <div class="card-header">Laboratory Investigations</div>
              <div class="card-body">
                <div id="laboratory">
                  <ul id="laboratoryTbody"></ul>
                </div>
              </div>
              <div class="card-footer"></div>
            </div>
         </td>
         <td valign="top">
            <div class="card">
              <div class="card-header">Radiology Orders</div>
              <div class="card-body">
                <div id="radiology">
                  <ul id="radiologyTbody"></ul>
                </div>
              </div>
              <div class="card-footer"></div>
            </div>
         </td>
         <td valign="top">
            <div class="card">
              <div class="card-header">Pharmacy Orders</div>
              <div class="card-body">
                <div id="pharmacy">
                  <ul id="pharmacyTbody"></ul>
                </div>
              </div>
              <div class="card-footer"></div>
            </div>
         </td>
        </tr>
    </table>
</div>