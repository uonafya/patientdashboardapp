<%
    def returnUrl = ui.pageLink("patientdashboardapp", "main", [patientId: patientId, opdId: opdId, queueId: queueId])
%>

<p>
  <a href="${ui.pageLink("patientdashboardapp", "triage", [opdId: opdId, patientId: patientId, queueId: queueId, returnUrl: returnUrl])}">Edit</a>
</p>
<div class="dashboard" >
  <div class="info-body">
    <p>
      <small>Height</small>
      <span>${triage?.height?:"Not Captured"}</span>
    </p>
    <p>
      <small>Weight</small>
      <span>${triage?.weight?:"Not Captured"}</span>
    </p>
    <% if (patient.age > 18)  {%>
      <p>
          <small>BMI</small>
          <span>${(triage && triage.weight && triage.height) ? triage?.weight/((triage?.height/100) * (triage?.height/100)) : "" }</span>
      </p>
    <% } %>
    <p>
      <small>MUAC</small>
      <span>${triage?.mua?:"Not Captured"}</span>
    </p>
    <p>
      <small>Chest Circumference</small>
      <span>${triage?.chest?:"Not Captured"}</span>
    </p>
    <p>
      <small>Abdominal Circumference</small>
      <span>${triage?.abdominal?:"Not Captured"}</span>
    </p>
    <p>
      <small>Temperature</small>
      <span>${triage?.temperature?:"Not Captured"}</span>
    </p>
    <p>
      <small>Blood Pressure</small>
      <span>${ triage?.systolic && triage?.daistolic ? triage?.systolic + "/" + triage?.daistolic : "Not captured" }</span>
    </p>
    <p>
        <small>Respiratory Rate</small>
        <span>${triage?.respiratoryRate?:"Not Captured"}</span>
    </p>
    <% if (patient.gender == 'F' && patient.age > 10) {%>
        <p>
            <small>Last Menstual Period</small>
            <span>${triage?.lastMenstrualDate ?: "Not captured"}</span>
        </p>
	<% } %>
    <p>
        <small>Blood Group</small>
        <span>${triage?.bloodGroup && triage?.rhesusFactor ? triage?.bloodGroup + "/" + triage?.rhesusFactor : "Not captured"}</span>
    </p>
    <p>
        <small>PITCT</small>
        <span>${triage?.pitct}</span>
    </p>
  </div>
</div>