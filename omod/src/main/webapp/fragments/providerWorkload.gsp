<div>
    <div>
        <div style="margin-top: -1px ">
            <i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
            <label>&nbsp;&nbsp;From&nbsp;</label>${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'fromDate', id: 'summaryFromDate', label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
            <label>&nbsp;&nbsp;To&nbsp;</label  >${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'toDate',    id: 'summaryToDate',   label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
            <label>&nbsp;&nbsp;&nbsp;</label  ><button id="opdFilter" type="button">${ui.message("Filter")}</button>
        </div>
    </div>
</div>
<div>
    <table border="0" cellspacing="0" cellpadding="0" style="width=100%;">
        <tr>
          <td valign="top">
            <table>
              <tr>
                <th style="font-size: 16px!important; color: #5b57a6">Patients Served</th>
              </tr>
              <tr>
                <td>
                  <div id="patientTbody" style="display: inline;float: none;font-weight: bold;font-size: 16px;">
                </td>
              </tr>
            </table>
         </td>
          <td valign="top">
            <table>
              <tr>
                <th style="font-size: 16px!important; color: #5b57a6">Final Diagnosis</th>
              </tr>
              <tr>
                <td>
                  <div id="diagnosis">
                    <ul id="fDiagnosisDetails"></ul>
                  </div>
                </td>
              </tr>
            </table>
         </td>
         <td valign="top">
           <table>
             <tr>
               <th style="font-size: 16px!important; color: #5b57a6">Procedures</th>
             </tr>
             <tr>
               <td>
                 <div id="procedures">
                     <ul id="proceduresTbody"></ul>
                 </div>
               </td>
             </tr>
           </table>
         </td>
         <td valign="top">
           <table>
              <tr>
                <th style="font-size: 16px!important; color: #5b57a6">Laboratory Investigations</th>
              </tr>
              <tr>
                <td>
                  <div id="laboratory">
                    <ul id="laboratoryTbody"></ul>
                  </div>
                </td>
              </tr>
            </table>
         </td>
         <td valign="top">
            <table>
              <tr>
                <th style="font-size: 16px!important; color: #5b57a6">Radiology Orders</th>
              </tr>
              <tr>
                <td>
                  <div id="radiology">
                    <ul id="radiologyTbody"></ul>
                  </div>
                </td>
              </tr>
            </table>
         </td>
         <td valign="top">
            <table>
               <tr>
                 <th style="font-size: 16px!important; color: #5b57a6">Pharmacy Orders</th>
               </tr>
               <tr>
                 <td>
                   <div id="pharmacy">
                     <ul id="pharmacyTbody"></ul>
                   </div>
                 </td>
               </tr>
             </table>
         </td>
        </tr>
    </table>
</div>