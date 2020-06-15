import AdapterBase from '../../../api/AdapterBase';

class LeaveTypeAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "name",
            "leave_accrue",
            "carried_forward",
            "default_per_year"
        ];
    }

    getHeaders() {
        return [
            {"sTitle": "ID", "bVisible": false},
            {"sTitle": "Leave Name"},
            {"sTitle": "Leave Accrue Enabled"},
            {"sTitle": "Leave Carried Forward"},
            {"sTitle": "Leaves Per Year"}
        ];
    }

    getFormFields() {
        return [
            ["id", {"label": "ID", "type": "hidden", "validation": ""}],
            ["name", {"label": "Leave Name", "type": "text", "validation": ""}],
            ["supervisor_leave_assign", {
                "label": "Admin can assign leave to employees",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["employee_can_apply", {
                "label": "Employees can apply for this leave type",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["apply_beyond_current", {
                "label": "Employees can apply beyond the current leave balance",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["leave_accrue", {
                "label": "Leave Accrue Enabled",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["carried_forward", {
                "label": "Leave Carried Forward",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["default_per_year", {"label": "Leaves Per Leave Period", "type": "text", "validation": "number"}]
        ];
    }

    getHelpLink() {
        return 'https://antnest.vn';
    }
}

class LeaveRuleAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "leave_type",
            "job_title",
            "employment_status",
            "employee",
            "default_per_year"
        ];
    }

    getHeaders() {
        return [
            {"sTitle": "ID", "bVisible": false},
            {"sTitle": "Leave Type"},
            {"sTitle": "Job Title"},
            {"sTitle": "Employment Status"},
            {"sTitle": "Employee"},
            {"sTitle": "Leaves Per Year"}
        ];
    }

    getFormFields() {
        return [
            ["id", {"label": "ID", "type": "hidden", "validation": ""}],
            ["leave_type", {
                "label": "Leave Type",
                "type": "select",
                "allow-null": false,
                "remote-source": ["LeaveType", "id", "name"]
            }],
            ["job_title", {
                "label": "Job Title",
                "type": "select",
                "allow-null": true,
                "remote-source": ["JobTitle", "id", "name"]
            }],
            ["employment_status", {
                "label": "Employment Status",
                "type": "select",
                "allow-null": true,
                "remote-source": ["EmploymentStatus", "id", "name"]
            }],
            ["employee", {
                "label": "Employee",
                "type": "select",
                "allow-null": true,
                "remote-source": ["Employee", "id", "first_name+last_name"]
            }],
            ["supervisor_leave_assign", {
                "label": "Admin can assign leave to employees",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["employee_can_apply", {
                "label": "Employees can apply for this leave type",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["apply_beyond_current", {
                "label": "Employees can apply beyond the current leave balance",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["leave_accrue", {
                "label": "Leave Accrue Enabled",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["carried_forward", {
                "label": "Leave Carried Forward",
                "type": "select",
                "source": [["No", "No"], ["Yes", "Yes"]]
            }],
            ["default_per_year", {"label": "Leaves Per Year", "type": "text", "validation": "number"}]
        ];
    }

    getHelpLink() {
        return 'https://antnest.vn';
    }
}

class LeavePeriodAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "name",
            "date_start",
            "date_end"
            //"status"
        ];
    }

    getHeaders() {
        return [
            {"sTitle": "ID", "bVisible": false},
            {"sTitle": "Name"},
            {"sTitle": "Period Start"},
            {"sTitle": "Period End"}
            //{ "sTitle": "Status"}
        ];
    }

    getFormFields() {
        return [
            ["id", {"label": "ID", "type": "hidden", "validation": ""}],
            ["name", {"label": "Name", "type": "text", "validation": ""}],
            ["date_start", {"label": "Period Start", "type": "date", "validation": ""}],
            ["date_end", {"label": "Period End", "type": "date", "validation": ""}]
            //[ "status", {"label":"Status","type":"select","source":[["Active","Active"],["Inactive","Inactive"]]}]
        ];
    }

    get(callBackData) {
        var that = this;
        var callBackData = {"callBack": "checkLeavePeriods"};
        super.get(callBackData);
    }

    checkLeavePeriods() {
        var numberOfActiveLeavePeriods = 0;
        for (var i = 0; i < this.sourceData.length; i++) {
            numberOfActiveLeavePeriods++;
        }

        if (numberOfActiveLeavePeriods < 1) {
            //$('#LeavePeriod_Error').html("You should have one active leave period");
            //$('#LeavePeriod_Error').show();
            this.showMessage("Error", "You should at least have one leave period.");
        }
        /*
        else if(numberOfActiveLeavePeriods > 1){
            //$('#LeavePeriod_Error').html("You should have only one active leave period");
            this.showMessage("Error","You should have only one active leave period");
            //$('#LeavePeriod_Error').show();
        }else{
            //$('#LeavePeriod_Error').html("");
            //$('#LeavePeriod_Error').hide();
        }
        */
    }

    getLeaveDaysReadonly(leaveId) {
        var that = this;
        var object = {"leave_id": leaveId};
        var reqJson = JSON.stringify(object);

        var callBackData = [];
        callBackData.callBackData = [];
        callBackData['callBackSuccess'] = 'getLeaveDaysReadonlySuccessCallBack';
        callBackData['callBackFail'] = 'getLeaveDaysReadonlyFailCallBack';

        this.customAction('getLeaveDaysReadonly', 'admin=leaveman', reqJson, callBackData);
    }

    getLeaveDaysReadonlySuccessCallBack(callBackData) {
        var table = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;"><thead><tr><th>Leave Date</th><th>Leave Type</th></tr></thead><tbody>_days_</tbody></table> ';
        var tableLog = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;"><thead><tr><th>Notes</th></tr></thead><tbody>_days_</tbody></table> ';
        var row = '<tr><td>_date_</td><td>_type_</td></tr>';
        var rowLog = '<tr><td><span class="logTime label label-default">_date_</span>&nbsp;&nbsp;<b>_status_</b><br/>_note_</td></tr>';

        var days = callBackData[0];
        var leaveInfo = callBackData[1];
        var leaveId = callBackData[2];
        var leave = callBackData[3];
        var leaveLogs = callBackData[4];
        var html = "";
        var rows = "";
        var rowsLogs = "";
        var trow = "";

        html += '<span class="label label-default">Number of Leaves available ('+leaveInfo['availableLeaves']+')</span><br/>';

        var leaveCount = this.calculateNumberOfLeavesObject(days);

        if(leaveCount > leaveInfo['availableLeaves']){
            html += '<span class="label label-info">Number of Leaves requested ('+leaveCount+')</span><br/>';
        }else{
            html += '<span class="label label-success">Number of Leaves requested ('+leaveCount+')</span><br/>';
        }


        for(var i=0;i<days.length;i++){
            trow = row;
            trow = trow.replace(/_date_/g,Date.parse(days[i].leave_date).toString('MMM d, yyyy (dddd)'));
            trow = trow.replace(/_type_/g,days[i].leave_type);
            rows += trow;
        }

        for(var i=0;i<leaveLogs.length;i++){
            trow = rowLog;
            trow = trow.replace(/_date_/g,leaveLogs[i].time);
            trow = trow.replace(/_status_/g,leaveLogs[i].status_from+" -> "+leaveLogs[i].status_to);
            trow = trow.replace(/_note_/g,leaveLogs[i].note);
            rowsLogs += trow;
        }

        if(leave != null && leave.details != undefined && leave.details != null && leave.details != ""){
            html += "<br/><b>Reason for Applying leave:</b><br/>";
            html += leave.details+"<br/><br/>";
        }

        table = table.replace('_days_',rows);


        html+= "<br/>";
        html+= table;

        if(rowsLogs != ""){
            tableLog = tableLog.replace('_days_',rowsLogs);
            html+= tableLog;
        }

        if(leaveInfo['attachment'] != null && leaveInfo['attachment'] != undefined && leaveInfo['attachment'] != ""){
            html += '<label onclick="download(\''+leaveInfo['attachment']+'\','+'modJs.getLeaveDaysReadonly,['+leaveId+']);" style="cursor:pointer;">View Attachment <i class="icon-play-circle"></i></label>';
        }
        this.showMessage("Leave Days",html);
        timeUtils.convertToRelativeTime($(".logTime"));
    }

    getHelpLink() {
        return 'https://antnest.vn';
    }
}

class WorkDayAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "name",
            "status",
            // "country"
        ];
    }

    getHeaders() {
        return [
            {"sTitle": "ID", "bVisible": false},
            {"sTitle": "Day"},
            {"sTitle": "Status"},
            // {"sTitle": "Country"}

        ];
    }

    getFormFields() {
        return [
            ["id", {"label": "ID", "type": "hidden", "validation": ""}],
            ["name", {
                "label": "Day",
                "type": "select",
                "source": [["Monday", "Monday"], ["Tuesday", "Tuesday"], ["Wednesday", "Wednesday"], ["Thursday", "Thursday"], ["Friday", "Friday"], ["Saturday", "Saturday"], ["Sunday", "Sunday"]]
            }],
            ["status", {
                "label": "Status",
                "type": "select",
                "source": [["Full Day", "Full Day"], ["Half Day", "Half Day"], ["Non-working Day", "Non-working Day"]]
            }],
            ["country", {
                "label": "Country",
                "type": "select",
                "allow-null": true,
                "null-label": "For All Countries",
                "remote-source": ["Country", "id", "name"]
            }]
        ];
    }

    getFilters(){
        return [
            [ "country", {"label":"Country","type":"select","allow-null":true,"null-label":"For All Countries","remote-source":["Country","id","name"]}]
        ];
    }

    getActionButtonsHtml(id, data){
        var html = '<div style="width:50px;"><img class="tableActionButton" src="_BASE_images/edit.png" style="cursor:pointer;" rel="tooltip" title="Edit" onclick="modJs.edit(_id_);return false;"></img>__DeleteButton__</div>';
        var deleteButton = '<img class="tableActionButton" src="_BASE_images/delete.png" style="margin-left:15px;cursor:pointer;" rel="tooltip" title="Delete" onclick="modJs.deleteRow(_id_);return false;"></img>';


        if(data[3] != undefined && data[3] != null && data[3] != ""){
            html = html.replace(/__DeleteButton__/g,deleteButton);
        }else{
            data[3] = "For All Countries";
            html = html.replace(/__DeleteButton__/g,"");
        }

        html = html.replace(/_id_/g,id);
        html = html.replace(/_BASE_/g,this.baseUrl);

        return html;
    }

    getCustomTableParams(){
        return {
            "bPaginate": false,
            "bFilter": false,
            "bInfo": false
        };
    }

    getHelpLink() {
        return 'https://antnest.vn';
    }
}

class HoliDayAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "name",
            "dateh",
            "status",
            // "country"
        ];
    }

    getHeaders() {
        return [
            { "sTitle": "ID" ,"bVisible":false},
            { "sTitle": "Name" },
            { "sTitle": "Date" },
            { "sTitle": "Status" },
            // { "sTitle": "Country" }
        ];
    }

    getFormFields() {
        return [
            [ "id", {"label":"ID","type":"hidden","validation":""}],
            [ "name", {"label":"Name","type":"text","validation":""}],
            [ "dateh", {"label":"Date","type":"date","validation":""}],
            [ "status", {"label":"Status","type":"select","source":[["Full Day","Full Day"],["Half Day","Half Day"]]}],
            [ "country", {"label":"Country","type":"select","allow-null":true,"null-label":"For All Countries","remote-source":["Country","id","name"]}]
        ];
    }

    getFilters(){
        return [
            [ "country", {"label":"Country","type":"select","allow-null":true,"null-label":"For All Countries","remote-source":["Country","id","name"]}]
        ];
    }

    getHelpLink() {
        return 'https://antnest.vn';
    }

    getActionButtonsHtml(id, data){
        if(data[4] == undefined || data[4] == null && data[4] == ""){
            data[4] = "For All Countries";
        }
        return super.getActionButtonsHtml(id, data);
    }
}

class EmployeeLeaveAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "employee",
            "leave_type",
            "date_start",
            "date_end",
            "status"
        ];
    }

    getHeaders() {
        return [
            { "sTitle": "ID" ,"bVisible":false},
            { "sTitle": "Employee" },
            { "sTitle": "Leave Type" },
            { "sTitle": "Leave Start Date"},
            { "sTitle": "Leave End Date"},
            { "sTitle": "Status"}
        ];
    }

    getFormFields() {
        return [
            [ "id", {"label":"ID","type":"hidden"}],
            [ "employee", {"label":"Employee","type":"select","allow-null":false,"remote-source":["Employee","id","first_name+last_name"]}],
            [ "leave_type", {"label":"Leave Type","type":"select","remote-source":["LeaveType","id","name"]}],
            [ "date_start", {"label":"Leave Start Date","type":"date","validation":""}],
            [ "date_end", {"label":"Leave Start Date","type":"date","validation":""}],
            [ "details", {"label":"Reason","type":"textarea","validation":"none"}]
        ];
    }

    calculateNumberOfLeaves(days){
        var sum = 0.0;
        for (var prop in days) {
            if(days.hasOwnProperty(prop)){
                if(days[prop] == "Full Day"){
                    sum += 1;
                }else{
                    sum += 0.5;
                }
            }
        }
        return sum;
    }

    calculateNumberOfLeavesObject(days){
        var sum = 0.0;
        for(var i=0;i<days.length;i++){
            if(days[i].leave_type == "Full Day"){
                sum += 1;
            }else{
                sum += 0.5;
            }
        }
        return sum;
    }

    getLeaveDaysReadonly(leaveId){
        var that = this;
        var object = {"leave_id":leaveId};
        var reqJson = JSON.stringify(object);

        var callBackData = [];
        callBackData.callBackData = [];
        callBackData['callBackSuccess'] = 'getLeaveDaysReadonlySuccessCallBack';
        callBackData['callBackFail'] = 'getLeaveDaysReadonlyFailCallBack';

        this.customAction('getLeaveDaysReadonly','admin=leaveman',reqJson,callBackData);
    }

    getLeaveDaysReadonlySuccessCallBack(callBackData){

        var table = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;"><thead><tr><th>Leave Date</th><th>Leave Type</th></tr></thead><tbody>_days_</tbody></table> ';
        var tableLog = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;"><thead><tr><th>Notes</th></tr></thead><tbody>_days_</tbody></table> ';
        var row = '<tr><td>_date_</td><td>_type_</td></tr>';
        var rowLog = '<tr><td><span class="logTime label label-default">_date_</span>&nbsp;&nbsp;<b>_status_</b><br/>_note_</td></tr>';

        var days = callBackData[0];
        var leaveInfo = callBackData[1];
        var leaveId = callBackData[2];
        var leave = callBackData[3];
        var leaveLogs = callBackData[4];
        var html = "";
        var rows = "";
        var rowsLogs = "";
        var trow = "";

        html += '<span class="label label-default">Number of Leaves available ('+leaveInfo['availableLeaves']+')</span><br/>';

        var leaveCount = this.calculateNumberOfLeavesObject(days);

        if(leaveCount > leaveInfo['availableLeaves']){
            html += '<span class="label label-info">Number of Leaves requested ('+leaveCount+')</span><br/>';
        }else{
            html += '<span class="label label-success">Number of Leaves requested ('+leaveCount+')</span><br/>';
        }


        for(var i=0;i<days.length;i++){
            trow = row;
            trow = trow.replace(/_date_/g,Date.parse(days[i].leave_date).toString('MMM d, yyyy (dddd)'));
            trow = trow.replace(/_type_/g,days[i].leave_type);
            rows += trow;
        }

        for(var i=0;i<leaveLogs.length;i++){
            trow = rowLog;
            trow = trow.replace(/_date_/g,leaveLogs[i].time);
            trow = trow.replace(/_status_/g,leaveLogs[i].status_from+" -> "+leaveLogs[i].status_to);
            trow = trow.replace(/_note_/g,leaveLogs[i].note);
            rowsLogs += trow;
        }

        if(leave != null && leave.details != undefined && leave.details != null && leave.details != ""){
            html += "<br/><b>Reason for Applying leave:</b><br/>";
            html += leave.details+"<br/><br/>";
        }

        table = table.replace('_days_',rows);


        html+= "<br/>";
        html+= table;

        if(rowsLogs != ""){
            tableLog = tableLog.replace('_days_',rowsLogs);
            html+= tableLog;
        }

        if(leaveInfo['attachment'] != null && leaveInfo['attachment'] != undefined && leaveInfo['attachment'] != ""){
            html += '<label onclick="download(\''+leaveInfo['attachment']+'\','+'modJs.getLeaveDaysReadonly,['+leaveId+']);" style="cursor:pointer;">View Attachment <i class="icon-play-circle"></i></label>';
        }
        this.showMessage("Leave Days",html);
        timeUtils.convertToRelativeTime($(".logTime"));
    }

    getLeaveDaysReadonlyFailCallBack(callBackData) {
        this.showMessage("Error","Error Occured while Reading leave days from Server");
    }

    getActionButtonsHtml(id,data) {
        var html = "";
        html = '<div style="width:80px;"><img class="tableActionButton" src="_BASE_images/info.png" style="cursor:pointer;" rel="tooltip" title="Show Leave Days" onclick="modJs.getLeaveDaysReadonly(_id_);return false;"></img><img class="tableActionButton" src="_BASE_images/run.png" style="cursor:pointer;margin-left:15px;" rel="tooltip" title="Change Leave Status" onclick="modJs.openLeaveStatus(_id_,\'_status_\');return false;"></img><img class="tableActionButton" src="_BASE_images/delete.png" style="margin-left:15px;cursor:pointer;" rel="tooltip" title="Cancel Leave" onclick="modJs.deleteRow(_id_);return false;"></img></div>';

        html = html.replace(/_id_/g,id);
        html = html.replace(/_status_/g,data[5]);
        html = html.replace(/_BASE_/g,this.baseUrl);

        return html;
    }

    getCustomSuccessCallBack(serverData) {
        var data = [];
        var mapping = this.getDataMapping();
        for(var i=0;i<serverData.length;i++){
            var row = [];
            for(var j=0;j<mapping.length;j++){
                row[j] = serverData[i][mapping[j]];
            }
            data.push(row);
        }

        this.tableData = data;

        this.createTable(this.getTableName());
        $("#"+this.getTableName()+'Form').hide();
        $("#"+this.getTableName()).show();

    }

    remoteTableSkipEmployeeRestriction() {
        return true;
    }

    openLeaveStatus(leaveId,status) {
        $('#leaveStatusModel').modal('show');
        $('#leave_status').val(status);
        this.leaveStatusChangeId = leaveId;
    }

    closeLeaveStatus() {
        $('#leaveStatusModel').modal('hide');
    }

    changeLeaveStatus() {
        var leaveStatus = $('#leave_status').val();
        var reason = $('#leave_reason').val();

        if(leaveStatus == undefined || leaveStatus == null || leaveStatus == ""){
            this.showMessage("Error", "Please select leave status");
            return;
        }

        var object = {"id":this.leaveStatusChangeId,"status":leaveStatus,"reason":reason};

        var reqJson = JSON.stringify(object);

        var callBackData = [];
        callBackData.callBackData = [];
        callBackData['callBackSuccess'] = 'changeLeaveStatusSuccessCallBack';
        callBackData['callBackFail'] = 'changeLeaveStatusFailCallBack';

        this.customAction('changeLeaveStatus','admin=leaveman',reqJson,callBackData);

        this.closeLeaveStatus();
        this.leaveStatusChangeId = null;
    }

    changeLeaveStatusSuccessCallBack(callBackData) {
        this.showMessage("Successful", "Leave status changed successfully");
        this.get([]);
    }

    changeLeaveStatusFailCallBack(callBackData) {
        this.showMessage("Error", "Error occured while changing leave status");
    }

    getFilters(){
        return [
            [ "employee", {"label":"Employee","type":"select2","allow-null":false,"remote-source":["Employee","id","first_name+last_name"]}],
            [ "leave_type", {"label":"Leave Type","type":"select","allow-null":true,"null-label":"All Leave Types","remote-source":["LeaveType","id","name"]}]
        ];
    }

    getHelpLink() {
        return 'https://antnest.vn';
    }
}

module.exports = {LeaveTypeAdapter, LeaveRuleAdapter, LeavePeriodAdapter, WorkDayAdapter, HoliDayAdapter, EmployeeLeaveAdapter};