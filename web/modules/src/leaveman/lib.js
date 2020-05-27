/*
 @author Ha tran <manhhaniit@gmail.com>
 */
import AdapterBase from '../../../api/AdapterBase';
import FormValidation from "../../../api/FormValidation";

class EmployeeLeaveAdapter extends AdapterBase {
    constructor(endPoint, tab, filter, orderBy) {
        super(endPoint, tab, filter, orderBy);
        this.currentLeaveRule = null;
        this.leaveInfo = null;
    }

    getDataMapping() {
        return [
            "id",
            //"number",
            "leave_type",
            "date_start",
            "date_end",
            "supervisor",
            "details",
            "status"
        ];
    }

    getHeaders() {
        return [
            {"sTitle": "ID", "bVisible": false},
            //{"sTitle": "No."},
            {"sTitle": "Leave Type"},
            {"sTitle": "Leave Start Date"},
            {"sTitle": "Leave End Date"},
            {"sTitle": "Supervisor"},
            {"sTitle": "Reason"},
            {"sTitle": "Status"}
        ];
    }

    getFormFields() {
        return [
            ["id", {"label": "ID", "type": "hidden"}],
            ["leave_type", {"label": "Leave Type", "type": "select", "remote-source": ["LeaveType", "id", "name"]}],
            ["date_start", {"label": "Leave Start Date", "type": "date", "validation": ""}],
            ["date_end", {"label": "Leave End Date", "type": "date", "validation": ""}],
            ["details", {"label": "Reason", "type": "textarea", "validation": "none"}],
            ["attachment", {"label": "Attachment", "type": "fileupload", "validation": "none"}]
        ];
    }

    getLeaveDays() {
        const validator = new FormValidation(`${this.getTableName()}_submit`, true, {
            ShowPopup: false,
            LabelErrorClass: 'error'
        });
        if (validator.checkValues()) {
            const params = validator.getFormParameters(),
                msg = this.doCustomValidation(params);
            if (null == msg) {
                $("#EmployeeLeaveAll_submit_error").html(""), $("#EmployeeLeaveAll_submit_error").hide();
                var l = $("#" + this.getTableName() + "_submit #id").val();
                null != l && "" !== l && (t.id = l);
                var reqJson = JSON.stringify(params),
                    callBackData = [];
                callBackData.callBackData = [];
                callBackData.callBackSuccess = "getLeaveDaysSuccessCallBack";
                callBackData.callBackFail = "getLeaveDaysFailCallBack";
                this.customAction("getLeaveDays", "modules=leaveman", reqJson, callBackData)
            } else {
                $("#EmployeeLeaveAll_submit_error").html(msg), $("#EmployeeLeaveAll_submit_error").show();
            }
        }
    }

    getLeaveDaysSuccessCallBack(callBackData, serverData) {
        var days = callBackData[0];
        this.leaveInfo = callBackData[1];
        this.currentLeaveRule = callBackData[2];
        $('#leave_days_table_body').html('');
        let hdm = this.gt('Half Day - Morning');
        let hda = this.gt('Half Day - Afternoon');
        let fd = this.gt('Full Day');
        let nwd = this.gt('Non working day');
        var selectH = '<select id="_id_" class="days" onchange="modJs.updateLeaveDate()">' +
            '<option value="Half Day - Morning">' + hdm + '</option>' +
            '<option value="Half Day - Afternoon">' + hda + '</option>' +
            '</select>';
        var selectF = '<select id="_id_" class="days" onchange="modJs.updateLeaveDate()">' +
            '<option value="Full Day">' + fd + '</option>' +
            '<option value="Half Day - Morning">' + hdm + '</option>' +
            '<option value="Half Day - Afternoon">' + hda + '</option>' +
            '</select>';
        var row = '<tr><td>_date_</td><td>_select_</td></tr>';
        var select;
        var html = "";
        $.each(days, function (key, value) {

            if (value + '' != '2') {

                if (value + '' == '1') {
                    select = selectF;
                } else {
                    select = selectH;
                }
                var tkey = key.split("-").join("");
                select = select.replace(/_id_/g, tkey);

            } else {
                select = '<span class="label label-info">' + nwd + '</span>';
            }
            var trow = row;

            trow = trow.replace(/_date_/g, Date.parse(key).toString('MMM d, yyyy (dddd)'));
            trow = trow.replace(/_select_/g, select);
            html += trow;
        });

        $('#leave_days_table_body').html(html);
        $('#leave_days_table').show();
        $('#EmployeeLeaveAll_submit').hide();
        $('#leave_days_table_cont').show();

        $('#pending_leave_count').html(this.leaveInfo['pendingLeaves']);
        $('#available_leave_count').html(this.leaveInfo['availableLeaves']);
        $('#approved_leave_count').html(this.leaveInfo['approvedLeaves']);
        this.updateLeaveDate();
    }

    add(object, callBackData) {
        var that = this;
        var days = {};
        $('.days').each(function (index) {
            days[$(this).attr('id')] = $(this).val();
        });

        var numberOfLeaves = this.calculateNumberOfLeaves(days);
        var availableLeaves = parseFloat(this.leaveInfo['availableLeaves']);

        if (numberOfLeaves > availableLeaves && this.currentLeaveRule.apply_beyond_current == "No") {
            this.showMessage("Error Applying Leave", "You are trying to apply " + numberOfLeaves + " leaveman. But you are only allowed to apply for " + availableLeaves + " leaveman.");
            return;
        }

        object['days'] = JSON.stringify(days);

        var reqJson = JSON.stringify(object);

        callBackData['callBackData'] = [];
        callBackData['callBackSuccess'] = 'addSuccessCallBack';
        callBackData['callBackFail'] = 'addFailCallBack';

        this.customAction('addLeave', 'modules=leaveman', reqJson, callBackData);
    }

    calculateNumberOfLeaves(days) {
        var sum = 0.0;
        for (var prop in days) {
            if (days.hasOwnProperty(prop)) {
                if (days[prop] == "Full Day") {
                    sum += 1;
                } else {
                    sum += 0.5;
                }
            }
        }
        return sum;
    }

    getLeaveDaysFailCallBack(callBackData, serverData) {
        this.showMessage("Error Occured while Applying Leave", callBackData)
    }

    addSuccessCallBack(callbackData) {
        this.showMessage("Successful", this.gt("Leave application successful. You will be notified once your supervisor approve your leaveman."));
        this.get([]);
    }

    addFailCallBack(callBackData) {
        this.showMessage("Error Occured while Applying Leave", callBackData);
    }

    updateLeaveDate() {
        var days = {};
        $('.days').each(function (index) {
            days[$(this).attr('id')] = $(this).val();
        });
        var numberOfLeaves = this.calculateNumberOfLeaves(days);
        $('#total_leave_days').html(numberOfLeaves);
        let totalLeaveHours = numberOfLeaves * 8;
        $('#total_leave_hours').html(totalLeaveHours);
    }

    showLeaveView() {
        $('#EmployeeLeaveAll_submit').show();
        $('#leave_days_table_cont').hide();
    }

    getLeaveDaysReadonly(leaveId) {
        var that = this;
        var object = {"leave_id": leaveId};
        var reqJson = JSON.stringify(object);

        var callBackData = [];
        callBackData['callBackData'] = [];
        callBackData['callBackSuccess'] = 'getLeaveDaysReadonlySuccessCallBack';
        callBackData['callBackFail'] = 'getLeaveDaysReadonlyFailCallBack';

        this.customAction('getLeaveDaysReadonly', 'modules=leaveman', reqJson, callBackData);
    }

    getLeaveDaysReadonlySuccessCallBack(callBackData) {
        var table = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;">' +
            '<thead><tr><th>' + this.gt("Leave Date") + '</th><th> ' + this.gt("Leave Type") +
            ' </th></tr></thead><tbody>_days_</tbody></table> ';
        var tableLog = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;">' +
            '<thead><tr><th>Notes</th></tr></thead><tbody>_days_</tbody></table> ';
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

        html += '<span class="label label-default">' + this.gt("Number of Leaves available") + ' (' + leaveInfo['availableLeaves'] + ')</span><br/>';

        var leaveCount = this.calculateNumberOfLeavesObject(days);

        if (leaveCount > leaveInfo['availableLeaves']) {
            html += '<span class="label label-info">' + this.gt("Number of Leaves requested") + ' (' + leaveCount + ')</span><br/>';
        } else {
            html += '<span class="label label-success">' + this.gt("Number of Leaves requested") + ' (' + leaveCount + ')</span><br/>';
        }


        for (var i = 0; i < days.length; i++) {
            trow = row;
            trow = trow.replace(/_date_/g, Date.parse(days[i].leave_date).toString('MMM d, yyyy (dddd)'));
            trow = trow.replace(/_type_/g, days[i].leave_type);
            rows += trow;
        }

        for (var i = 0; i < leaveLogs.length; i++) {
            trow = rowLog;
            trow = trow.replace(/_date_/g, leaveLogs[i].time);
            trow = trow.replace(/_status_/g, leaveLogs[i].status_from + " -> " + leaveLogs[i].status_to);
            trow = trow.replace(/_note_/g, leaveLogs[i].note);
            rowsLogs += trow;
        }

        if (leave != null && leave.details != undefined && leave.details != null && leave.details != "") {
            html += "<br/><b>" + this.gt("Reason for Applying leave") + ":</b><br/>";
            html += leave.details + "<br/><br/>";
        }

        table = table.replace('_days_', rows);


        html += "<br/>";
        html += table;

        if (rowsLogs != "") {
            tableLog = tableLog.replace('_days_', rowsLogs);
            html += tableLog;
        }

        if (leaveInfo['attachment'] != null && leaveInfo['attachment'] != undefined && leaveInfo['attachment'] != "") {
            html += '<label onclick="download(\'' + leaveInfo['attachment'] + '\',' + 'modJs.getLeaveDaysReadonly,[' + leaveId + ']);" style="cursor:pointer;">View Attachment <i class="icon-play-circle"></i></label>';
        }
        this.showMessage("Leave Days", html);
        timeUtils.convertToRelativeTime($(".logTime"));
    }

    getLeaveDaysReadonlyFailCallBack(callBackData) {
        this.showMessage("Error", "Error Occured while Reading leave days from Server");
    }

    getActionButtonsHtml(id, data) {
        var html = "";
        if ((this.getTableName() != "EmployeeLeaveAll" && this.getTableName() != "EmployeeLeavePending") || data[6] == "Approved" || data[6] == "Rejected") {
            html = '<div style="width:80px;"><img class="tableActionButton" src="_BASE_images/info.png" style="cursor:pointer;" rel="tooltip" title="Show Leave Days" onclick="modJs.getLeaveDaysReadonly(_id_);return false;"></img></div>';
        } else {
            html = '<div style="width:80px;">' +
                '<img class="tableActionButton" src="_BASE_images/info.png" style="cursor:pointer;" rel="tooltip" title="Show Leave Days" onclick="modJs.getLeaveDaysReadonly(_id_);return false;">' +
                '</img><img class="tableActionButton" src="_BASE_images/delete.png" style="margin-left:15px;cursor:pointer;" rel="tooltip" title="Cancel Leave" onclick="modJs.deleteRow(_id_);return false;"></img></div>';
        }
        html = html.replace(/_id_/g, id);
        html = html.replace(/_BASE_/g, this.baseUrl);

        return html;
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
}

class EmployeeLeaveEntitlementAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "name",
            "availableLeaves",
            "pendingLeaves",
            "approvedLeaves",
            "rejectedLeaves",
            "tobeAccrued",
            "carriedForward"
        ];
    }

    getHeaders() {
        return [
            {"sTitle": "ID", "bVisible": false},
            {"sTitle": "Leave Type"},
            {"sTitle": "Available Leaves"},
            {"sTitle": "Pending Leaves"},
            {"sTitle": "Approved Leaves"},
            {"sTitle": "Rejected Leaves"},
            {"sTitle": "Leaves to be Accured"},
            {"sTitle": "Leaves Carried Forward"}
        ];
    }

    getFormFields() {
        return [];
    }

    showActionButtons() {
        return false;
    }

    get() {
        var that = this;
        var object = {};
        var reqJson = JSON.stringify(object);
        var callBackData = [];
        callBackData['callBackData'] = [];
        callBackData['callBackSuccess'] = 'getEntitlementSuccessCallBack';
        callBackData['callBackFail'] = 'getEntitlementFailCallBack';

        this.customAction('getEntitlement', 'modules=leaveman', reqJson, callBackData);
    }

    getEntitlementSuccessCallBack(data) {
        var callBackData = [];
        callBackData['noRender'] = false;
        this.getSuccessCallBack(callBackData, data);
    }

    getEntitlementFailCallBack(data) {

    }
}

class SubEmployeeLeaveAdapter extends AdapterBase {
    constructor(endPoint, tab, filter, orderBy) {
        super(endPoint, tab, filter, orderBy);
        this.leaveStatusChangeId = null;
    }

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
            {"sTitle": "ID", "bVisible": false},
            {"sTitle": "Employee"},
            {"sTitle": "Leave Type"},
            {"sTitle": "Leave Start Date"},
            {"sTitle": "Leave End Date"},
            {"sTitle": "Status"}
        ];
    }

    getFormFields() {
        return [
            ["id", {"label": "ID", "type": "hidden"}],
            ["employee", {
                "label": "Employee",
                "type": "select",
                "allow-null": false,
                "remote-source": ["Employee", "id", "first_name+last_name"]
            }],
            ["leave_type", {"label": "Leave Type", "type": "select", "remote-source": ["LeaveType", "id", "name"]}],
            ["date_start", {"label": "Leave Start Date", "type": "date", "validation": ""}],
            ["date_end", {"label": "Leave End Date", "type": "date", "validation": ""}],
            ["details", {"label": "Reason", "type": "textarea", "validation": "none"}]
        ];
    }

    isSubProfileTable() {
        return true;
    }

    /*get() {
        var that = this;
        var sourceMappingJson = JSON.stringify(this.getSourceMapping());

        var filterJson = "";
        if (this.getFilter() != null) {
            filterJson = JSON.stringify(this.getFilter());
        }

        var orderBy = "";
        if (this.getOrderBy() != null) {
            orderBy = this.getOrderBy();
        }

        var object = {'sm': sourceMappingJson, 'ft': filterJson, 'ob': orderBy};
        var reqJson = JSON.stringify(object);

        var callBackData = [];
        callBackData['callBackData'] = [];
        callBackData['callBackSuccess'] = 'getCustomSuccessCallBack';
        callBackData['callBackFail'] = 'getFailCallBack';

        this.customAction('getSubEmployeeLeaves', 'modules=leaveman', reqJson, callBackData);
    }*/

    getCustomSuccessCallBack(serverData) {
        var data = [];
        var mapping = this.getDataMapping();
        for (var i = 0; i < serverData.length; i++) {
            var row = [];
            for (var j = 0; j < mapping.length; j++) {
                row[j] = serverData[i][mapping[j]];
            }
            data.push(row);
        }

        this.tableData = data;

        this.createTable(this.getTableName());
        $("#" + this.getTableName() + 'Form').hide();
        $("#" + this.getTableName()).show();
    }

    openLeaveStatus(leaveId, status) {
        $('#leaveStatusModel').modal('show');
        $('#leave_status').val(status);
        $('#leave_reason').val("");
        this.leaveStatusChangeId = leaveId;
    }

    closeLeaveStatus() {
        $('#leaveStatusModel').modal('hide');
    }

    changeLeaveStatus() {
        var leaveStatus = $('#leave_status').val();
        var reason = $('#leave_reason').val();
        if (leaveStatus == undefined || leaveStatus == null || leaveStatus == "") {
            this.showMessage("Error", "Please select leave status");
            return;
        }
        var object = {"id": this.leaveStatusChangeId, "status": leaveStatus, "reason": reason};

        var reqJson = JSON.stringify(object);

        var callBackData = [];
        callBackData['callBackData'] = [];
        callBackData['callBackSuccess'] = 'changeLeaveStatusSuccessCallBack';
        callBackData['callBackFail'] = 'changeLeaveStatusFailCallBack';

        this.customAction('changeLeaveStatus', 'modules=leaveman', reqJson, callBackData);

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

    getLeaveDaysReadonly(leaveId) {
        var that = this;
        var object = {"leave_id": leaveId};
        var reqJson = JSON.stringify(object);

        var callBackData = [];
        callBackData['callBackData'] = [];
        callBackData['callBackSuccess'] = 'getLeaveDaysReadonlySuccessCallBack';
        callBackData['callBackFail'] = 'getLeaveDaysReadonlyFailCallBack';

        this.customAction('getLeaveDaysReadonly', 'modules=leaveman', reqJson, callBackData);
    }

    getLeaveDaysReadonlySuccessCallBack(callBackData) {
        var table = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;">' +
            '<thead><tr><th>' + this.gt("Leave Date") + '</th><th>' + this.gt("Leave Type") + '</th></tr></thead><tbody>_days_</tbody></table> ';
        var tableLog = '<table class="table table-condensed table-bordered table-striped" style="font-size:14px;">' +
            '<thead><tr><th>' + this.gt("Notes") + '</th></tr></thead><tbody>_days_</tbody></table> ';
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

        html += '<span class="label label-default">' + this.gt("Number of Leaves available") + ' (' + leaveInfo['availableLeaves'] + ')</span><br/>';

        var leaveCount = this.calculateNumberOfLeavesObject(days);

        if (leaveCount > leaveInfo['availableLeaves']) {
            html += '<span class="label label-info">' + this.gt("Number of Leaves requested") + ' (' + leaveCount + ')</span><br/>';
        } else {
            html += '<span class="label label-success">' + this.gt("Number of Leaves requested") + ' (' + leaveCount + ')</span><br/>';
        }


        for (var i = 0; i < days.length; i++) {
            trow = row;
            trow = trow.replace(/_date_/g, Date.parse(days[i].leave_date).toString('MMM d, yyyy (dddd)'));
            trow = trow.replace(/_type_/g, days[i].leave_type);
            rows += trow;
        }

        for (var i = 0; i < leaveLogs.length; i++) {
            trow = rowLog;
            trow = trow.replace(/_date_/g, leaveLogs[i].time);
            trow = trow.replace(/_status_/g, leaveLogs[i].status_from + " -> " + leaveLogs[i].status_to);
            trow = trow.replace(/_note_/g, leaveLogs[i].note);
            rowsLogs += trow;
        }

        if (leave != null && leave.details != undefined && leave.details != null && leave.details != "") {
            html += `<br/><b>${this.gt("Reason for Applying leave")}:</b><br/>`;
            html += leave.details + "<br/><br/>";
        }

        table = table.replace('_days_', rows);


        html += "<br/>";
        html += table;

        if (rowsLogs != "") {
            tableLog = tableLog.replace('_days_', rowsLogs);
            html += tableLog;
        }

        if (leaveInfo['attachment'] != null && leaveInfo['attachment'] != undefined && leaveInfo['attachment'] != "") {
            html += '<label onclick="download(\'' + leaveInfo['attachment'] + '\',' + 'modJs.getLeaveDaysReadonly,[' + leaveId + ']);" style="cursor:pointer;">View Attachment <i class="icon-play-circle"></i></label>';
        }
        this.showMessage("Leave Days", html);
        timeUtils.convertToRelativeTime($(".logTime"));
    }

    getLeaveDaysReadonlyFailCallBack(callBackData) {
        this.showMessage("Error", "Error Occured while Reading leave days from Server");
    }

    getActionButtonsHtml(id, data) {
        var html = "";
        html = '<div style="width:80px;"><img class="tableActionButton" src="_BASE_images/info.png" style="cursor:pointer;" rel="tooltip" title="Show Leave Days" onclick="modJs.getLeaveDaysReadonly(_id_);return false;"></img><img class="tableActionButton" src="_BASE_images/run.png" style="cursor:pointer;margin-left:15px;" rel="tooltip" title="Change Leave Status" onclick="modJs.openLeaveStatus(_id_,\'_status_\');return false;"></img></div>';

        html = html.replace(/_id_/g, id);
        html = html.replace(/_status_/g, data[5]);
        html = html.replace(/_BASE_/g, this.baseUrl);

        return html;
    }

    getLeaveOptions(e) {
        var option = {};
        return "Approved" === e || ("Pending" === e ? (option.Approved = "Approved", option.Rejected = "Rejected") : "Rejected" === e ? option.Rejected = "Rejected" : "Cancelled" === e || "Processing" === e || (option["Cancellation Requested"] = "Cancellation Requested", option.Cancelled = "Cancelled"))
            , this.generateOptions(option)
    }

    getFilters() {
        return [
            ["employee", {
                label: "Employee",
                type: "select2",
                "allow-null": !0,
                "null-label": "All Employees",
                "remote-source": ["Employee", "id", "first_name+last_name"]
            }],
            ["leave_type", {
                label: "Leave Type",
                type: "select",
                "allow-null": !0,
                "null-label": "All Leave Types",
                "remote-source": ["LeaveType", "id", "name"]
            }],
            ["leave_period", {
                label: "Leave Period",
                type: "select2",
                "allow-null": !0,
                "remote-source": ["LeavePeriod", "id", "name"]
            }],
            ["status", {
                label: "Status",
                type: "select",
                source: [
                    ["Approved", "Approved"],
                    ["Pending", "Pending"],
                    ["Rejected", "Rejected"],
                    ["Cancelled", "Cancelled"],
                    ["Cancellation Requested", "Cancellation Requested"],
                    ["Processing", "Processing"]
                ]
            }]
        ]
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
}

class EmployeeLeaveBalanceAdapter extends AdapterBase {
    getDataMapping() {
        return [
            "id",
            "name",
            "totalLeaves",
            "bonusLeaveDays",
            "previousBalanceDays",
            "approvedLeaves",
            "rejectedLeaves",
            "pendingLeaves",
            "availableLeaves",
        ];
    }

    getHeaders() {
        return [
            {"sTitle": "ID", "bVisible": false},
            {"sTitle": "Leave Type"},
            {"sTitle": "Days Per Year"},
            {"sTitle": "Bonus Leave Days"},
            {"sTitle": "Previous Balance Days"},
            {"sTitle": "Approved Leaves"},
            {"sTitle": "Rejected Leaves"},
            {"sTitle": "Pending Leaves"},
            {"sTitle": "Available Leaves"},
        ];
    }

    getFormFields() {
        return [];
    }

    showActionButtons() {
        return false;
    }

    get() {
        var that = this;
        var object = {};
        var reqJson = JSON.stringify(object);
        var callBackData = [];
        callBackData['callBackData'] = [];
        callBackData['callBackSuccess'] = 'getBalanceSuccessCallBack';
        callBackData['callBackFail'] = 'getBalanceFailCallBack';

        this.customAction('getLeaveBalance', 'modules=leaveman', reqJson, callBackData);
    }

    getBalanceSuccessCallBack(data) {
        var callBackData = [];
        callBackData['noRender'] = false;
        this.getSuccessCallBack(callBackData, data);
    }

    getBalanceFailCallBack(data) {

    }
}

module.exports = {EmployeeLeaveAdapter, EmployeeLeaveEntitlementAdapter, SubEmployeeLeaveAdapter, EmployeeLeaveBalanceAdapter};
