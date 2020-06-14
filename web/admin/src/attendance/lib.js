/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

import AdapterBase from '../../../api/AdapterBase';
import FormValidation from '../../../api/FormValidation';

class AttendanceAdapter extends AdapterBase {
  constructor(endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy);
    this.photoAttendance = false;
  }

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

  createTableServer(elementId) {
    const that = this;
    const headers = this.getHeaders();

    headers.push({ sTitle: '', sClass: 'center' });

    // add translations
    for (const index in headers) {
      headers[index].sTitle = this.gt(headers[index].sTitle);
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

    const dataTableParams = {
      oLanguage: {
        sLengthMenu: '_MENU_ records per page',
      },
      bProcessing: true,
      bServerSide: true,
      sAjaxSource: that.getDataUrl(that.getDataMapping()),
      aoColumns: headers,
      bSort: that.isSortable(),
      parent: that,
      iDisplayLength: 15,
      iDisplayStart: start,
    };

    if (this.showActionButtons()) {
      dataTableParams.aoColumnDefs = [
        {
          fnRender: that.getActionButtons,
          aTargets: [that.getDataMapping().length],
        },
      ];
    }

    const customTableParams = this.getCustomTableParams();

    $.extend(dataTableParams, customTableParams);

    $(`#${elementId} #grid`).dataTable(dataTableParams);

    $('.dataTables_paginate ul').addClass('pagination');
    $('.dataTables_length').hide();
    $('.dataTables_filter input').addClass('form-control');
    $('.dataTables_filter input').attr('placeholder', 'Search');
    $('.dataTables_filter label').contents().filter(function () {
      return (this.nodeType === 3);
    }).remove();
    $('.dataTables_filter').remove();

    $('.tableActionButton').tooltip();
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
