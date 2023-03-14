<%
    ui.includeCss("kenyaemr", "referenceapplication.css", 100)
%>
<div>
    <div class="clear"></div>
    <div class="container">
        <div id="content" class="container">
            <div class="dashboard clear">
                 <% if (vitals) { %>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <fieldset>
                                 <legend>Vitals</legend>
                                 <table>
                                     <% vitals.each { it -> %>
                                     <tr>
                                         <td>${it.display}</td>
                                         <td colspan="2">${it.value}</td>
                                     </tr>
                                     <% } %>
                                 </table>
                                </fieldset>
                            <td>
                            <td>
                                <fieldset>
                                 <legend>Conditions</legend>
                                </fieldset>
                            <td>
                        </tr>
                        <tr>
                            <td>
                                <fieldset>
                                 <legend>Investigations</legend>
                                </fieldset>
                            <td>
                            <td>
                                <fieldset>
                                 <legend>Diagnosis/Medications</legend>
                                </fieldset>
                            <td>
                        </tr>
                    </table>
                 <% } else { %>
                    <p>No records found</p>
                 <%}%>
            </div>
        </div>
    </div>
</div>
