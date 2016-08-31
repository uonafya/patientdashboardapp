<%
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
ui.includeJavascript("patientqueueapp", "jquery.dataTables.min.js")
%>

<script>
var results = [];
jq(function(){
	jq("#ui-id-5").on("click", function(){
	    jq.getJSON('${ui.actionLink('patientdashboardapp','radiology','getHistoricalRadiologyResutls')}',
	            {
	        patientId:${patientId}
	        }).success(function(data){
		        
	            jq.each(data.data,function(i,item){
                    var radiologyResult = {};
                    radiologyResult["Start Date"] = item["startDate"];
                    radiologyResult["Test Name"] = item["testName"];
                    radiologyResult["Investigation"] = item["investigation"];
                    results.push(radiologyResult);
                });
                radiologyTable('#radiologyData', results);
            });
	    });

	function radiologyTable(selector, data){
	    var columns = addAllColumnHeaders(data, selector);
        for (var i = 0 ; i < data.length ; i++){
            var row  = jq('<tr/>');
            for ( var colIndex = 0 ; colIndex < columns.length ; colIndex++){
                var cellValue = data[i][columns[colIndex]];
                if (cellValue == null) { cellValue = "";}
                row.append(jq('<td/>').html(cellValue));
            }
            jq(selector).append(row);
        }
    }

	    function addAllColumnHeaders(data, selector){
	        var columnSet = [];
	        var headerTr =jq('<tr/>');

	            for (var i = 0 ; i < data.length ; i++){
	        var rowHash = data[i];
	            for (var key in rowHash){
	                if (jq.inArray(key, columnSet) == -1){
	                columnSet.push(key);
	                headerTr.append(jq('<th/>').html(key));
	            }
	        }
	    }
	    jq(selector).append(headerTr);
	    return columnSet;
	}
    

    });


</script>
<style>
    .radiology-details-control i{
        cursor: pointer;
    }
</style>
<table id="radiologyData">
    <tbody>
    </tbody>
</table>


    

