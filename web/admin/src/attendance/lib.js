/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

import AdapterBase from '../../../api/AdapterBase';
import FormValidation from '../../../api/FormValidation';

class AttendanceAdapter extends AdapterBase {
  /*constructor(endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy);
    this.photoAttendance = false;
    this.setRemoteTable(false);
  }*/

  getDataMapping() {
    return [
      'id',
      'employee',
      'working_date',
      'in_time',
      'out_time',
      'real_hours',
      'note',
    ];
  }

  getHeaders() {
    return [
      { sTitle: 'ID', bVisible: false },
      { sTitle: 'Employee' },
      { sTitle: 'Working Date' },
      { sTitle: 'Time-In', bSort: false },
      { sTitle: 'Time-Out', bSort: false },
      { sTitle: 'Real Hours', bSort: false },
      { sTitle: 'Note', bSort: false },
    ];
  }

  getFormFields() {
    return [
      ['employee', {
        label: 'Employee', type: 'select2', 'allow-null': false, 'remote-source': ['Employee', 'id', 'first_name+last_name+birthday'],
      }],
      ['id', { label: 'ID', type: 'hidden' }],
      ['date', { label: 'Working Date', type: 'date' }],
      ['in_time', { label: 'Time-In', type: 'time', validation: 'none' }],
      ['out_time', { label: 'Time-Out', type: 'time', validation: 'none' }],
    ];
  }

  getFilters() {
    return [
      ['employee', {
        label: 'Employee', type: 'select2', 'allow-null': true, 'remote-source': ['Employee', 'id', 'first_name+last_name+birthday'],
      }],
      ['in_time', {
        label: 'Start Date', type: 'yearmonth'
      }],
      /*['out_time', {
        label: 'End Date', type: 'date', 'allow-null': true, validation: 'none'
      }],*/
    ];
  }

  setPhotoAttendance(val) {
    this.photoAttendance = parseInt(val, 10);
  }


  /*getCustomTableParams() {
    const that = this;
    const dataTableParams = {
      aoColumnDefs: [
        {
          fnRender(data, cell) {
            return that.preProcessRemoteTableData(data, cell, 2);
          },
          aTargets: [2],
        },
        {
          fnRender(data, cell) {
            return that.preProcessRemoteTableData(data, cell, 3);
          },
          aTargets: [3],
        },
        {
          fnRender(data, cell) {
            return that.preProcessRemoteTableData(data, cell, 4);
          },
          aTargets: [4],
        },
        {
          fnRender: that.getActionButtons,
          aTargets: [that.getDataMapping().length],
        },
      ],
    };
    return dataTableParams;
  }*/

  preProcessRemoteTableData(data, cell, id) {
    if (id === 2) {
      if (cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell == null) {
        return '';
      }
      return Date.parse(cell).toString('d/M/yyyy  <b>HH:mm</b>');
    } if (id === 3) {
      if (cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell == null) {
        return '';
      }
      return Date.parse(cell).toString('d/M/yyyy  <b>HH:mm</b>');
    } if (id === 4) {
      if (cell !== undefined && cell !== null) {
        if (cell.length > 10) {
          return `${cell.substring(0, 10)}..`;
        }
      }
      return cell;
    }
  }


  save() {
    const validator = new FormValidation(`${this.getTableName()}_submit`, true, { ShowPopup: false, LabelErrorClass: 'error' });
    if (validator.checkValues()) {
      const params = validator.getFormParameters();

      const msg = this.doCustomValidation(params);
      if (msg == null) {
        const id = $(`#${this.getTableName()}_submit #id`).val();
        if (id != null && id !== undefined && id !== '') {
          params.id = id;
        }

        const reqJson = JSON.stringify(params);
        const callBackData = [];
        callBackData.callBackData = [];
        callBackData.callBackSuccess = 'saveSuccessCallback';
        callBackData.callBackFail = 'saveFailCallback';

        this.customAction('savePunch', 'admin=attendance', reqJson, callBackData);
      } else {
        const label = $(`#${this.getTableName()}Form .label`);
        label.html(msg);
        label.show();
      }
    }
  }


  saveSuccessCallback(callBackData) {
    this.get(callBackData);
  }


  saveFailCallback(callBackData) {
    this.showMessage('Error saving attendance entry', callBackData);
  }

  isSubProfileTable() {
    return this.user.user_level !== 'Admin' && this.user.user_level !== 'Manager';
  }

  showPunchImages(id) {
    const reqJson = JSON.stringify({ id });
    const callBackData = [];
    callBackData.callBackData = [];
    callBackData.callBackSuccess = 'getImagesSuccessCallback';
    callBackData.callBackFail = 'getImagesFailCallback';
    this.customAction('getImages', 'admin=attendance', reqJson, callBackData);
  }

  getImagesSuccessCallback(callBackData) {
    $('#attendnaceMapCanvasIn').remove();
    $('#attendnaceCanvasInWrapper').html('<canvas id="attendnaceCanvasIn" height="156" width="208" style="border: 1px #222 dotted;"></canvas>');

    $('#attendnaceCanvasOut').remove();
    $('#attendnaceCanvasOutWrapper').html('<canvas id="attendnaceCanvasOut" height="156" width="208" style="border: 1px #222 dotted;"></canvas>');

    $('#attendnaceCanvasPunchInTime').html('');
    $('#attendnaceCanvasPunchOutTime').html('');
    $('#punchInLocation').html('');
    $('#punchOutLocation').html('');
    $('#punchInIp').html('');
    $('#punchOutIp').html('');

    $('#attendnaceMapCanvasIn').remove();
    $('#attendnaceMapCanvasInWrapper').html('<canvas id="attendnaceMapCanvasIn" height="156" width="208" style="border: 1px #222 dotted;"></canvas>');

    $('#attendnaceMapCanvasOut').remove();
    $('#attendnaceMapCanvasOutWrapper').html('<canvas id="attendnaceMapCanvasOut" height="156" width="208" style="border: 1px #222 dotted;"></canvas>');

    $('#attendancePhotoModel').modal('show');
    $('#attendnaceCanvasEmp').html(callBackData.employee_Name);
    if (callBackData.in_time) {
      $('#attendnaceCanvasPunchInTime').html(Date.parse(callBackData.in_time).toString('yyyy MMM d  <b>HH:mm</b>'));
    }

    if (callBackData.image_in) {
      $('#attendancePhoto').show();
      const myCanvas = document.getElementById('attendnaceCanvasIn');
      const ctx = myCanvas.getContext('2d');
      const img = new Image();
      img.onload = function () {
        ctx.drawImage(img, 0, 0); // Or at whatever offset you like
      };
      img.src = callBackData.image_in;
    }

    if (callBackData.out_time) {
      $('#attendnaceCanvasPunchOutTime').html(Date.parse(callBackData.out_time).toString('yyyy MMM d  <b>HH:mm</b>'));
    }

    if (callBackData.image_out) {
      $('#attendancePhoto').show();
      const myCanvas = document.getElementById('attendnaceCanvasOut');
      const ctx = myCanvas.getContext('2d');
      const img = new Image();
      img.onload = function () {
        ctx.drawImage(img, 0, 0); // Or at whatever offset you like
      };
      img.src = callBackData.image_out;
    }

    if (callBackData.map_lat) {
      $('#attendanceMap').show();
      $('#punchInLocation').html(`${callBackData.map_lat},${callBackData.map_lng}`);
    }

    if (callBackData.map_out_lat) {
      $('#attendanceMap').show();
      $('#punchOutLocation').html(`${callBackData.map_out_lat},${callBackData.map_out_lng}`);
    }

    if (callBackData.in_ip) {
      $('#punchInIp').html(callBackData.in_ip);
    }
    if (callBackData.out_ip) {
      $('#punchOutIp').html(callBackData.out_ip);
    }

    if (callBackData.map_snapshot) {
      $('#attendanceMap').show();
      const myCanvas = document.getElementById('attendnaceMapCanvasIn');
      const ctx = myCanvas.getContext('2d');
      const img = new Image();
      img.onload = function () {
        ctx.drawImage(img, 0, 0); // Or at whatever offset you like
      };
      img.src = callBackData.map_snapshot;
    }

    if (callBackData.map_out_snapshot) {
      $('#attendanceMap').show();
      const myCanvas = document.getElementById('attendnaceMapCanvasOut');
      const ctx = myCanvas.getContext('2d');
      const img = new Image();
      img.onload = function () {
        ctx.drawImage(img, 0, 0); // Or at whatever offset you like
      };
      img.src = callBackData.map_out_snapshot;
    }
  }


  getImagesFailCallback(callBackData) {
    this.showMessage('Error', callBackData);
  }

  get(callBackData) {
    const that = this;
    if (this.getRemoteTable()) {
      this.createTableServer(this.getTableName());
      $(`#${this.getTableName()}Form`).hide();
      $(`#${this.getTableName()}`).show();
      return;
    }

    let sourceMappingJson = JSON.stringify(this.getSourceMapping());

    let filterJson = '';
    if (this.getFilter() !== null) {
      filterJson = JSON.stringify(this.getFilter());
    }

    let orderBy = '';
    if (this.getOrderBy() !== null) {
      orderBy = this.getOrderBy();
    }

    sourceMappingJson = this.fixJSON(sourceMappingJson);
    filterJson = this.fixJSON(filterJson);

    that.showLoader();
    $.post(this.moduleRelativeURL, {
      t: this.table, a: 'ca', sa: 'getAttendanceReport', mod: 'admin=attendance', sm: sourceMappingJson, ft: filterJson, ob: orderBy,
    }, (data) => {
      if (data.status === 'SUCCESS') {
        that.getSuccessCallBack(callBackData, data.data);
      } else {
        that.getFailCallBack(callBackData, data.data);
      }
    }, 'json').always(() => { that.hideLoader(); });

    that.initFieldMasterData();

    this.trackEvent('get', this.tab, this.table);
    // var url = this.getDataUrl();
    // console.log(url);
  }

  getSuccessCallBack(callBackData, serverData) {
    const headers = serverData.header;
    const data = serverData.data;
    const mapping = this.getDataMapping();

    for (let i = 0; i < serverData.data.length; i++) {
      console.log("Data I: ");
      console.log(serverData.data[i]);
      const row = [];
      for (let j = 0; j < serverData.data[i]; j++) {
        row[j] = serverData.data[i][j];
      }
      data.push(this.preProcessTableData(row));
    }

    this.sourceData = serverData.data;
    if (callBackData.callBack !== undefined && callBackData.callBack !== null) {
      if (callBackData.callBackData === undefined || callBackData.callBackData === null) {
        callBackData.callBackData = [];
      }
      callBackData.callBackData.push(serverData);
      callBackData.callBackData.push(data);
      this.callFunction(callBackData.callBack, callBackData.callBackData);
    }

    this.headers = headers;
    this.tableData = data;

    if (!(callBackData.noRender !== undefined && callBackData.noRender !== null && callBackData.noRender === true)) {
      this.createTable(this.getTableName());
      $(`#${this.getTableName()}Form`).hide();
      $(`#${this.getTableName()}`).show();
    }
  }

  createTable(elementId) {
    const that = this;

    if (this.getRemoteTable()) {
      this.createTableServer(elementId);
      return;
    }

    const headers = this.headers;

    let tableHeaderHtml = '';
    tableHeaderHtml += '<thead>';
    tableHeaderHtml += '<tr>';
    tableHeaderHtml += '<td>&nbsp;</td>';

    $.each(headers, function (index, col) {
      if ((index + 1) === headers.length) {
        tableHeaderHtml += '<td rowspan="2">';
        tableHeaderHtml += '<b>' + that.gt(col) + '</b>';
        tableHeaderHtml += '</td>';
        return;
      }

      tableHeaderHtml += '<td colspan="3">';
      tableHeaderHtml += '<b>' + that.gt(col) + '</b>';
      tableHeaderHtml += '</td>';
    });

    tableHeaderHtml += '</tr>';

    tableHeaderHtml += '<tr>';
    tableHeaderHtml += '<td>&nbsp;</td>';
    $.each(headers, function (index, col) {
      if ((index + 1) === headers.length) {
        return;
      }

      tableHeaderHtml += '<td width="50">';
      tableHeaderHtml += '<b>' + that.gt("In") + '</b>';
      tableHeaderHtml += '</td>';
      tableHeaderHtml += '<td width="50">';
      tableHeaderHtml += '<b>' + that.gt("Out") + '</b>';
      tableHeaderHtml += '</td>';
      tableHeaderHtml += '<td width="50">';
      tableHeaderHtml += '<b>' + that.gt("Total") + '</b>';
      tableHeaderHtml += '</td>';
    });

    tableHeaderHtml += '</tr>';
    tableHeaderHtml += '</thead>';

    const data = this.getTableData();

    if (this.showActionButtons()) {
      for (let i = 0; i < data.length; i++) {
        data[i].push(this.getActionButtonsHtml(data[i][0], data[i]));
      }
    }

    let html = '';
    html = this.getTableTopButtonHtml() + this.getTableHTMLTemplate();

    // Find current page
    const activePage = $(`#${elementId} .dataTables_paginate .active a`).html();
    let start = 0;
    if (activePage !== undefined && activePage != null) {
      start = parseInt(activePage, 10) * 15 - 15;
    }

    $(`#${elementId}`).html(html);
    $('.box-body.table-responsive table').addClass('table table-bordered table-striped table-attendance').append(tableHeaderHtml);

    const dataTableParams = {
      oLanguage: {
        sLengthMenu: '_MENU_ records per page',
      },
      aaData: data,
      aoColumns: headers,
      bSort: that.isSortable(),
      iDisplayLength: 15,
      iDisplayStart: start,
    };

    const customTableParams = this.getCustomTableParams();

    $.extend(dataTableParams, customTableParams);

    let tableHtml = '';
    tableHtml += '<tbody>';
    let rowIndex = 0;

    $.each(data, function (index, row) {
      let rowClass = (rowIndex % 2 === 0) ? 'even' : 'odd;'
      tableHtml += '<tr class="' + rowClass + '">';
      tableHtml += '<td style="border-right: 2px solid #333">';
      tableHtml += row[0].name;
      tableHtml += '</td>';
      $.each(row, function (index, col) {
        let colClass = '';

        if (index % 3 === 0 && index > 0) {
          colClass += 'total ';
        }

        if((index + 1 ) === row.length){
          tableHtml += '<td>';
          tableHtml += col;
          tableHtml += '</td>';
          return;
        }

        tableHtml += '<td data-fieldname="in" data-date="' + col.date + '" data-employee_id="' + col.employee_id + '" data-in="' + col.in + '" data-out="' + col.out + '" class="editable ' + colClass + '">';
        tableHtml += col.in;
        tableHtml += '</td>';
        tableHtml += '<td data-fieldname="out" data-date="' + col.date + '" data-employee_id="' + col.employee_id + '" data-in="' + col.in + '" data-out="' + col.out + '" class="editable ' + colClass + '">';
        tableHtml += col.out;
        tableHtml += '</td>';
        tableHtml += '<td style="background-color: #428bcac2;color: #ffffff;font-weight: bold;" class="' + colClass + " total-" + col.employee_id + col.date + '">';
        tableHtml += col.total;
        tableHtml += '</td>';
      });
      tableHtml += '</tr>';
      rowIndex++;
    })
    tableHtml += '</tbody>';

    $('body .box-body.table-responsive table').on('dblclick', '.editable', function () {
      that.editAttendance(that, this);
    })
    $('.box-body.table-responsive').attr('style', 'width: 100%; overflow-x: scroll;').find('table').append(tableHtml);

    $('.tableActionButton').tooltip();
  }

  editAttendance(that, el) {
    const data = $(el).data();
    let value = (data.fieldname === 'in') ? data.in : data.out;
    let input = '<input data-fieldname="' + data.fieldname + '" data-date="' + data.date + '" data-employee_id="' + data.employee_id + '" type="text" value="' + value + '"/>';

    $(el).html(input);
    $(el).find('input').inputmask('datetime', {
      mask: '99:99',
      placeholder: 'hh:mm',
      separator: ':',
      alias: 'h:s',
    }).on('change', function () {
      const value = $(this).val();

      if (data.fieldname === 'in') {
        data.in = value;
      } else {
        data.out = value;
      }
      that.showLoader();
      $.post(that.moduleRelativeURL, {
        t: this.table, a: 'ca', sa: 'updateAttendance', mod: 'admin=attendance', sm: "", ft: "", ob: "", fieldname: data.fieldname, date: data.date, employee_id: data.employee_id, in: data.in, out: data.out,
      }, (res) => {
        if(res.status === "SUCCESS"){
          let data = res.data;
          $(el).attr('data-in', data.in).attr('data-out', data.out).html(value);
          $('body .box-body.table-responsive table').find(".total-" + data.employee_id + data.date).html(data.total)
        }
      }, 'json').always(() => {
        that.hideLoader();
      });
    })
  }

  getActionButtonsHtml(id, data) {
    $('.dataTables_filter').remove();

    const editButton = '<img class="tableActionButton" src="_BASE_images/edit.png" style="cursor:pointer;" rel="tooltip" title="Edit" onclick="modJs.edit(_id_);return false;"></img>';
    const deleteButton = '<img class="tableActionButton" src="_BASE_images/delete.png" style="margin-left:15px;cursor:pointer;" rel="tooltip" title="Delete" onclick="modJs.deleteRow(_id_);return false;"></img>';
    /*const photoButton = '<img class="tableActionButton" src="_BASE_images/map.png" style="margin-left:15px;cursor:pointer;" rel="tooltip" title="Show Photo" onclick="modJs.showPunchImages(_id_);return false;"></img>';*/

    let html = '<div style="width:80px;">_edit__delete_</div>';
    /*if (this.photoAttendance === 1) {
      html = '<div style="width:80px;">_edit__delete__photo_</div>';
    } else {
      html = '<div style="width:80px;">_edit__delete_</div>';
    }*/

    // html = html.replace('_photo_', photoButton);

    /*if (this.showDelete) {
      html = html.replace('_delete_', deleteButton);
    } else {
      html = html.replace('_delete_', '');
    }

    if (this.showEdit) {
      html = html.replace('_edit_', editButton);
    } else {
      html = html.replace('_edit_', '');
    }
    html = html.replace(/_id_/g, id);
    html = html.replace(/_BASE_/g, this.baseUrl);
    return html;*/
    return '';
  }
}


/*
 Attendance Status
 */

class AttendanceStatusAdapter extends AdapterBase {
  getDataMapping() {
    return [
      'id',
      'employee',
      'status',
    ];
  }

  getHeaders() {
    return [
      { sTitle: 'ID', bVisible: false },
      { sTitle: 'Employee' },
      { sTitle: 'Clocked In Status' },
    ];
  }

  getFormFields() {
    return [

    ];
  }

  getFilters() {
    return [
      ['employee', {
        label: 'Employee', type: 'select2', 'allow-null': false, 'remote-source': ['Employee', 'id', 'first_name+last_name'],
      }],

    ];
  }

  getActionButtonsHtml(id, data) {
    let html = '<div class="online-button-_COLOR_"></div>';
    html = html.replace(/_BASE_/g, this.baseUrl);
    if (data[2] == 'Not Clocked In') {
      html = html.replace(/_COLOR_/g, 'gray');
    } else if (data[2] == 'Clocked Out') {
      html = html.replace(/_COLOR_/g, 'yellow');
    } else if (data[2] == 'Clocked In') {
      html = html.replace(/_COLOR_/g, 'green');
    }
    return html;
  }


  isSubProfileTable() {
    return this.user.user_level !== 'Admin';
  }
}

module.exports = { AttendanceAdapter, AttendanceStatusAdapter };
