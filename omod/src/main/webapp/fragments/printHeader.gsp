<div>
    <center>
        <img src="/openmrs/ms/uiframework/resource/ehrinventoryapp/images/kenya_logo.bmp" width="60" height="60" align="middle">
        <h2>${countyCode} - ${countyName}</h2>
        <h3>${userLocation}(${mfl}) </h3>
    </center>
    <hr />
    <center>
        <table>
            <tr>
                <td>Website</td>
                <td>${website}</td>
            </tr>
            <tr>
                <td>Address</td>
                <td>${address}</td>
            </tr>
            <tr>
                <td>Email</td>
                <td>${email}</td>
            </tr>
            <tr>
                <td>Phone</td>
                <td>${phone}</td>
            </tr>
        </table>
    <center>
    <hr />
    <div background-color: #B2BEB5;">
    <center>
        <h3>OFFICIAL RECEIPT</h3>
    </center>
   </div>
   <% if(currentPatient) {%>
       <div id="biodata">
         <p>${names} - ${currentPatient.age} yrs (${ui.formatDatePretty(currentPatient.birthdate)}) - ${currentPatient.gender}</p>
        </div>
   <%}%>
</div>
522533
5746663