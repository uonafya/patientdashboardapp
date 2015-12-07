<%@ include file="/WEB-INF/template/include.jsp" %>

<script type="text/javascript">
    function clinicalSummary(encounterId){
        var patientId = ${patient.patientId};
        jQuery.ajax({
            type : "GET",
            url : getContextPath() + "/module/patientdashboard/printDetails.form",
            data : ({
                encounterId			: encounterId,
                patientId			: patientId
            }),
            success : function(data) {
                jQuery("#printClinicalSummary").html(data);
                jQuery("#printClinicalSummary").hide();
                printClinicalSummary();
            }

        });
    }
</script>
<script type="text/javascript">
    function printClinicalSummary(){
        jQuery("#printClinicalSummary").printArea({
            mode : "popup",
            popClose : true
        });
    }
</script>
<script type="text/javascript">
    // get context path in order to build controller url
    function getContextPath(){
        pn = location.pathname;
        len = pn.indexOf("/", 1);
        cp = pn.substring(0, len);
        return cp;
    }
</script>

<c:choose>

    <c:when test="${not empty clinicalSummaries}">
        <table cellpadding="5" cellspacing="0" width="100%">
            <tr align="center">
                <th><spring:message code="patientdashboard.clinicalSummary.dateOfVisit"/></th>
                <th><spring:message code="patientdashboard.clinicalSummary.viewVisitDetails"/></th>
                <th><spring:message code="patientdashboard.clinicalSummary.vitalStatistics"/></th>
                <th><spring:message code="patientdashboard.clinicalSummary.symptomlDetails"/></th>
                <th></th>
            </tr>

            <c:forEach items="${clinicalSummaries}" var="clinicalSummary" varStatus="varStatus">
                <tr align="center" class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow" } '>
                    <td><openmrs:formatDate date="${clinicalSummary.dateOfVisit}" type="textbox"/></td>
                    <td><a href="#" onclick="DASHBOARD.detailClinical('${ clinicalSummary.id}');"><small>View details</small></a> </td>
                    <td><a href="#" onclick="DASHBOARD.vitalStatistics('${ clinicalSummary.id}','${ clinicalSummary.id}');"><small>View details</small></a> </td>
                    <td><a href="#" onclick="DASHBOARD.symptomlDetails('${ clinicalSummary.id}');"><small>View details</small></a> </td>
                    <td><a href="#" onclick="clinicalSummary('${ clinicalSummary.id}');"><small>Print</small></a> </td>
                </tr>

            </c:forEach>
        </table>
    </c:when>
</c:choose>

<div id="printClinicalSummary" style="visibility:hidden;">

</div>