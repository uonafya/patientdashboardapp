<%
    ui.includeCss("kenyaemr", "referenceapplication.css", 100)
%>
<div>
    <div class="clear"></div>
    <div class="container">
        <div id="content" class="container">
        <div class="dashboard clear">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <fieldset>
                         <legend>Vitals</legend>
                         ${patient}
                        </fieldset>
                    <td>
                    <td>
                        <fieldset>
                         <legend>Conditions</legend>
                         ${encounter}
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
            </div>
        </div>
    </div>
</div>
