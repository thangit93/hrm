/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

/* global modJs, modJsList, webkitURL */

import AdapterBase from '../../../api/AdapterBase'
import FormValidation from '../../../api/FormValidation'

class AttendanceAdapter extends AdapterBase {
  constructor (endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy)
    this.punch = null
    this.useServerTime = 0
    this.photoTaken = 0
    this.photoAttendance = 0
  }

  updatePunchButton () {
    this.getPunch('changePunchButtonSuccessCallBack')
  }

  setUseServerTime (val) {
    this.useServerTime = val
  }

  setPhotoAttendance (val) {
    this.photoAttendance = parseInt(val, 10)
  }

  getDataMapping () {
    return [
      'id',
      'working_date',
      'in_time',
      'out_time',
      'real_hours',
      'note',
    ]
  }

  getHeaders () {
    return [
      { sTitle: 'ID', bVisible: false },
      { sTitle: 'Working Date' },
      { sTitle: 'Time-In', bSort: false },
      { sTitle: 'Time-Out', bSort: false },
      { sTitle: 'Real Hours', bSort: false },
      { sTitle: 'Note', bSort: false },
    ]
  }

  getFormFields () {
    if (this.useServerTime === 0) {
      return [
        ['id', { label: 'ID', type: 'hidden' }],
        ['time', { label: 'Time', type: 'datetime' }],
        ['note', { label: 'Note', type: 'textarea', validation: 'none' }],
      ]
    }
    return [
      ['id', { label: 'ID', type: 'hidden' }],
      ['note', { label: 'Note', type: 'textarea', validation: 'none' }],
    ]
  }

  getFilters () {
    return [
      ['in_time', {
        label: 'Month', type: 'yearmonth'
      }],
      /*['out_time', {
        label: 'End Date', type: 'date', 'allow-null': true, validation: 'none'
      }],*/
    ]
  }

  /*getCustomTableParams() {
    const that = this;
    const dataTableParams = {
      aoColumnDefs: [
        {
          fnRender(data, cell) {
            return that.preProcessRemoteTableData(data, cell, 1);
          },
          aTargets: [1],
        },
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

  preProcessRemoteTableData (data, cell, id) {
    if (id === 1) {
      if (cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell === null) {
        return ''
      }
      return Date.parse(cell).toString('d/M/yyyy  <b>HH:mm</b>')
    }
    if (id === 2) {
      if (cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell === null) {
        return ''
      }
      return Date.parse(cell).toString('d/M/yyyy  <b>HH:mm</b>')
    }
    if (id === 3) {
      if (cell !== undefined && cell !== null) {
        if (cell.length > 20) {
          return `${cell.substring(0, 20)}..`
        }
      }
      return cell + ' ' + this.gt('attendance working day')
    }
    return cell
  }

  get (callBackData) {
    const that = this
    if (this.getRemoteTable()) {
      this.createTableServer(this.getTableName())
      $(`#${this.getTableName()}Form`).hide()
      $(`#${this.getTableName()}`).show()
      return
    }
    let sourceMappingJson = JSON.stringify(this.getSourceMapping())

    let filterJson = ''
    if (this.getFilter() !== null) {
      filterJson = JSON.stringify(this.getFilter())
    }

    let orderBy = ''
    if (this.getOrderBy() !== null) {
      orderBy = this.getOrderBy()
    }

    sourceMappingJson = this.fixJSON(sourceMappingJson)
    filterJson = this.fixJSON(filterJson)

    that.showLoader()
    $.post(this.moduleRelativeURL, {
      t: this.table,
      a: 'ca',
      sa: 'getUserAttendanceReport',
      mod: 'modules=attendance',
      sm: sourceMappingJson,
      ft: filterJson,
      ob: orderBy,
    }, (data) => {
      if (data.status === 'SUCCESS') {
        that.getSuccessCallBack(callBackData, data)
      } else {
        that.getFailCallBack(callBackData, data)
      }
    }, 'json').always(() => { that.hideLoader() })

    that.initFieldMasterData()

    this.trackEvent('get', this.tab, this.table)
    // var url = this.getDataUrl();
    // console.log(url);
  }

  getSuccessCallBack (callBackData, serverData) {
    const data = serverData.data
    const mapping = this.getDataMapping()
    /*for (let i = 0; i < serverData.data.length; i++) {
      console.log('Data I: ')
      console.log(serverData.data[i])
      const row = []
      for (let j = 0; j < serverData.data[i]; j++) {
        row[j] = serverData.data[i][j]
      }
      data.push(this.preProcessTableData(row))
    }*/

    this.sourceData = data
    if (callBackData.callBack !== undefined && callBackData.callBack !== null) {
      if (callBackData.callBackData === undefined || callBackData.callBackData === null) {
        callBackData.callBackData = []
      }
      callBackData.callBackData.push(serverData)
      callBackData.callBackData.push(data)
      this.callFunction(callBackData.callBack, callBackData.callBackData)
    }

    this.tableData = data

    if (!(callBackData.noRender !== undefined && callBackData.noRender !== null && callBackData.noRender === true)) {
      this.createTable(this.getTableName())
      $(`#${this.getTableName()}Form`).hide()
      $(`#${this.getTableName()}`).show()
    }
  }

  createTable(elementId) {
    const that = this;
    const headers = this.headers;

    let tableHeaderHtml = '';
    tableHeaderHtml += '<thead>';
    tableHeaderHtml += '<tr>';
    tableHeaderHtml += '<td>' +
      this.gt('Working Date') +
      '</td>';
    tableHeaderHtml += '<td>' +
      this.gt('Time-In') +
      '</td>';
    tableHeaderHtml += '<td>' +
      this.gt('Time-Out') +
      '</td>';
    tableHeaderHtml += '<td>' +
      this.gt('Real Hours') +
      '</td>';
    tableHeaderHtml += '<td>' +
      this.gt('Working Type') +
      '</td>';
    tableHeaderHtml += '</tr>';
    tableHeaderHtml += '</thead>';

    const data = this.getTableData();

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
    let total = 0

    $.each(data, function (index, row) {
      let rowClass = (rowIndex % 2 === 0) ? 'even' : 'odd;'
      tableHtml += '<tr class="' + rowClass + '">';
      tableHtml += '<td>';
      tableHtml += row.date;
      tableHtml += '</td>';
      tableHtml += '<td>';
      tableHtml += row.in;
      tableHtml += '</td>';
      tableHtml += '<td>';
      tableHtml += row.out;
      tableHtml += '</td>';
      tableHtml += '<td>';
      tableHtml += row.total;
      tableHtml += '</td>';
      tableHtml += '<td>';
      tableHtml += row.code;
      tableHtml += '</td>';
      tableHtml += '</tr>';
      total += row.total
      rowIndex++;
    })
    tableHtml += '<tr>';
    tableHtml += '<td colspan="4">';
    tableHtml += this.gt('Total');
    tableHtml += '</td>';
    tableHtml += '<td>';
    tableHtml += total;
    tableHtml += '</td>';
    tableHtml += '</tr>';
    tableHtml += '</tbody>';

    $('body .box-body.table-responsive table').on('dblclick', '.editable', function () {
      that.editAttendance(that, this);
    })
    $('.box-body.table-responsive').attr('style', 'width: 100%; overflow-x: scroll;').find('table').append(tableHtml);

    $('.tableActionButton').tooltip();
  }

  createTableServer (elementId) {
    const that = this
    const headers = this.getHeaders()

    headers.push({ sTitle: '', sClass: 'center' })

    // add translations
    for (const index in headers) {
      headers[index].sTitle = this.gt(headers[index].sTitle)
    }

    let html = ''
    html = this.getTableTopButtonHtml() + this.getTableHTMLTemplate()

    // Find current page
    const activePage = $(`#${elementId} .dataTables_paginate .active a`).html()
    let start = 0
    if (activePage !== undefined && activePage != null) {
      start = parseInt(activePage, 10) * 15 - 15
    }

    $(`#${elementId}`).html(html)

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
    }

    if (this.showActionButtons()) {
      dataTableParams.aoColumnDefs = [
        {
          fnRender: that.getActionButtons,
          aTargets: [that.getDataMapping().length],
        },
      ]
    }

    const customTableParams = this.getCustomTableParams()

    $.extend(dataTableParams, customTableParams)

    $(`#${elementId} #grid`).dataTable(dataTableParams)

    $('.dataTables_paginate ul').addClass('pagination')
    $('.dataTables_length').hide()
    $('.dataTables_filter input').addClass('form-control')
    $('.dataTables_filter input').attr('placeholder', 'Search')
    $('.dataTables_filter label').contents().filter(function () {
      return (this.nodeType === 3)
    }).remove()
    $('.dataTables_filter').remove()

    $('.tableActionButton').tooltip()
  }

  getActionButtonsHtml (id, data) {
    return ''
  }

  getTableTopButtonHtml () {
    let html = ''
    if (this.getShowAddNew()) {
      html = `<button onclick="modJs.renderForm();return false;" class="btn btn-small btn-primary">${this.gt(this.getAddNewLabel())} <i class="fa fa-plus"></i></button>`
    }

    if (this.getFilters() != null) {
      if (html !== '') {
        html += '&nbsp;&nbsp;'
      }
      html += `<button onclick="modJs.showFilters();return false;" class="btn btn-small btn-primary">${this.gt('Filter')} <i class="fa fa-filter"></i></button>`
      html += '&nbsp;&nbsp;'
      if (this.filtersAlreadySet) {
        html += '<button id="__id___resetFilters" onclick="modJs.resetFilters();return false;" class="btn btn-small btn-default">__filterString__ <i class="fa fa-times"></i></button>'
      } else {
        html += '<button id="__id___resetFilters" onclick="modJs.resetFilters();return false;" class="btn btn-small btn-default" style="display:none;">__filterString__ <i class="fa fa-times"></i></button>'
      }
    }

    html = html.replace(/__id__/g, this.getTableName())

    if (this.currentFilterString !== '' && this.currentFilterString != null) {
      html = html.replace(/__filterString__/g, this.currentFilterString)
    } else {
      html = html.replace(/__filterString__/g, 'Reset Filters')
    }

    if (html !== '') {
      html = `<div class="row"><div class="col-xs-12">${html}</div></div>`
    }

    return html
  }

  save () {
    const that = this
    const validator = new FormValidation(`${this.getTableName()}_submit`, true, {
      ShowPopup: false,
      LabelErrorClass: 'error'
    })
    if (validator.checkValues()) {
      const msg = this.doCustomValidation()
      if (msg == null) {
        let params = validator.getFormParameters()
        params = this.forceInjectValuesBeforeSave(params)
        params.cdate = this.getClientDate(new Date()).toISOString().slice(0, 19).replace('T', ' ')
        const reqJson = JSON.stringify(params)
        const callBackData = []
        callBackData.callBackData = []
        callBackData.callBackSuccess = 'saveSuccessCallback'
        callBackData.callBackFail = 'getPunchFailCallBack'

        this.customAction('savePunch', 'modules=attendance', reqJson, callBackData, true)
      } else {
        $(`#${this.getTableName()}Form .label`).html(msg)
        $(`#${this.getTableName()}Form .label`).show()
      }
    }
  }

  saveSuccessCallback (callBackData) {
    this.punch = callBackData
    this.getPunch('changePunchButtonSuccessCallBack')
    $('#PunchModel').modal('hide')
    this.get([])
  }

  cancel () {
    $('#PunchModel').modal('hide')
  }

  showPunchDialog () {
    this.getPunch('showPunchDialogShowPunchSuccessCallBack')
  }

  getPunch (successCallBack) {
    const that = this
    const object = {}

    object.date = this.getClientDate(new Date()).toISOString().slice(0, 19).replace('T', ' ')
    object.offset = this.getClientGMTOffset()
    const reqJson = JSON.stringify(object)
    const callBackData = []
    callBackData.callBackData = []
    callBackData.callBackSuccess = successCallBack
    callBackData.callBackFail = 'getPunchFailCallBack'

    this.customAction('getPunch', 'modules=attendance', reqJson, callBackData)
  }

  showPunchDialogShowPunchSuccessCallBack (callBackData) {
    this.punch = callBackData
    $('#PunchModel').modal('show')
    if (this.punch === null) {
      $('#PunchModel').find('h3').html('Punch Time-in')
      modJs.renderForm()
    } else {
      $('#PunchModel').find('h3').html('Punch Time-out')
      modJs.renderForm(this.punch)
    }
    $('#Attendance').show()
    const picker = $('#time_datetime').data('datetimepicker')
    picker.setLocalDate(new Date())
  }

  changePunchButtonSuccessCallBack (callBackData) {
    this.punch = callBackData
    if (this.punch === null) {
      $('#punchButton').html('Punch-in <span class="icon-time"></span>')
    } else {
      $('#punchButton').html('Punch-out <span class="icon-time"></span>')
    }
  }

  getPunchFailCallBack (callBackData) {
    this.showMessage('Error Occured while Time Punch', callBackData)
  }

  getClientDate (date) {
    const offset = this.getClientGMTOffset()
    const tzDate = date.addMinutes(offset * 60)
    return tzDate
  }

  getClientGMTOffset () {
    const rightNow = new Date()
    const jan1 = new Date(rightNow.getFullYear(), 0, 1, 0, 0, 0, 0)
    const temp = jan1.toGMTString()
    const jan2 = new Date(temp.substring(0, temp.lastIndexOf(' ') - 1))
    return (jan1 - jan2) / (1000 * 60 * 60)
  }

  doCustomValidation (params) {
    if (this.photoAttendance === 1 && !this.photoTaken) {
      return 'Please attach a photo before submitting'
    }
    return null
  }

  forceInjectValuesBeforeSave (params) {
    if (this.photoAttendance === 1) {
      const canvas = document.getElementById('attendnaceCanvas')
      params.image = canvas.toDataURL()
    }
    return params
  }

  postRenderForm () {
    if (this.photoAttendance === 1) {
      $('.photoAttendance').show()
      const video = document.getElementById('attendnaceVideo')

      // Get access to the camera!
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: true }).then((stream) => {
          //video.src = (window.URL ? window.URL : webkitURL).createObjectURL(stream);
          video.srcObject = stream
          video.play()
        })
      }
      this.photoTaken = false
      this.configureEvents()
    } else {
      $('.photoAttendance').remove()
    }
  }

  configureEvents () {
    const that = this
    const canvas = document.getElementById('attendnaceCanvas')
    const context = canvas.getContext('2d')
    const video = document.getElementById('attendnaceVideo')
    $('.attendnaceSnap').click(() => {
      context.drawImage(video, 0, 0, 208, 156)
      that.photoTaken = true
      return false
    })
  }
}

class EmployeeAttendanceSheetAdapter extends AdapterBase {
  constructor (endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy)
    this.currentTimesheetId = null
    this.currentTimesheet = null
  }

  getDataMapping () {
    return [
      'id',
      'date_start',
      'date_end',
      'total_time',
      'status',
    ]
  }

  getHeaders () {
    return [
      { sTitle: 'ID', bVisible: false },
      { sTitle: 'Start Date' },
      { sTitle: 'End Date' },
      { sTitle: 'Total Time' },
      { sTitle: 'Status' },
    ]
  }

  getFormFields () {
    return [
      ['id', { label: 'ID', type: 'hidden' }],
      ['date_start', { label: 'TimeSheet Start Date', type: 'date', validation: '' }],
      ['date_end', { label: 'TimeSheet End Date', type: 'date', validation: '' }],
      ['details', { label: 'Reason', type: 'textarea', validation: 'none' }],
    ]
  }

  preProcessTableData (row) {
    row[1] = Date.parse(row[1]).toString('MMM d, yyyy (dddd)')
    row[2] = Date.parse(row[2]).toString('MMM d, yyyy (dddd)')
    return row
  }

  renderForm (object) {
    const formHtml = this.templates.formTemplate
    const html = ''

    $(`#${this.getTableName()}Form`).html(formHtml)
    $(`#${this.getTableName()}Form`).show()
    $(`#${this.getTableName()}`).hide()

    $('#attendnacesheet_start').html(Date.parse(object.date_start).toString('MMM d, yyyy (dddd)'))
    $('#attendnacesheet_end').html(Date.parse(object.date_end).toString('MMM d, yyyy (dddd)'))

    this.currentTimesheet = object

    this.getTimeEntries()
  }

  getTimeEntries () {
    const timesheetId = this.currentId
    const sourceMappingJson = JSON.stringify(modJsList.tabEmployeeTimeEntry.getSourceMapping())

    const reqJson = JSON.stringify({ id: timesheetId, sm: sourceMappingJson })

    const callBackData = []
    callBackData.callBackData = []
    callBackData.callBackSuccess = 'getTimeEntriesSuccessCallBack'
    callBackData.callBackFail = 'getTimeEntriesFailCallBack'

    this.customAction('getTimeEntries', 'modules=time_sheets', reqJson, callBackData)
  }

  getTimeEntriesSuccessCallBack (callBackData) {
    const entries = callBackData
    let html = ''
    const temp = '<tr><td><img class="tableActionButton" src="_BASE_images/delete.png" style="cursor:pointer;" rel="tooltip" title="Delete" onclick="modJsList[\'tabEmployeeTimeEntry\'].deleteRow(_id_);return false;"></img></td><td>_start_</td><td>_end_</td><td>_duration_</td><td>_project_</td><td>_details_</td>'

    for (let i = 0; i < entries.length; i++) {
      try {
        let t = temp
        t = t.replace(/_start_/g, Date.parse(entries[i].date_start).toString('MMM d, yyyy [hh:mm tt]'))
        t = t.replace(/_end_/g, Date.parse(entries[i].date_end).toString('MMM d, yyyy [hh:mm tt]'))

        const mili = Date.parse(entries[i].date_end) - Date.parse(entries[i].date_start)
        const minutes = Math.round(mili / 60000)
        const hourMinutes = (minutes % 60)
        const hours = (minutes - hourMinutes) / 60

        t = t.replace(/_duration_/g, `Hours (${hours}) - Min (${hourMinutes})`)
        if (entries[i].project === 'null' || entries[i].project === null || entries[i].project === undefined) {
          t = t.replace(/_project_/g, 'None')
        } else {
          t = t.replace(/_project_/g, entries[i].project)
        }
        t = t.replace(/_project_/g, entries[i].project)
        t = t.replace(/_details_/g, entries[i].details)
        t = t.replace(/_id_/g, entries[i].id)
        t = t.replace(/_BASE_/g, this.baseUrl)
        html += t
      } catch (e) {
        // DN
      }
    }

    $('.timesheet_entries_table_body').html(html)
    if (modJs.getTableName() === 'SubEmployeeTimeSheetAll') {
      $('#submit_sheet').hide()
      $('#add_time_sheet_entry').hide()
    } else if (this.currentElement.status === 'Approved') {
      $('#submit_sheet').hide()
      $('#add_time_sheet_entry').hide()
    } else {
      $('#submit_sheet').show()
      $('#add_time_sheet_entry').show()
    }
  }

  getTimeEntriesFailCallBack (callBackData) {
    this.showMessage('Error', 'Error occured while getting timesheet entries')
  }

  createPreviousAttendnacesheet (id) {
    const reqJson = JSON.stringify({ id })

    const callBackData = []
    callBackData.callBackData = []
    callBackData.callBackSuccess = 'createPreviousAttendnacesheetSuccessCallBack'
    callBackData.callBackFail = 'createPreviousAttendnacesheetFailCallBack'

    this.customAction('createPreviousAttendnaceSheet', 'modules=attendnace', reqJson, callBackData)
  }

  createPreviousAttendnacesheetSuccessCallBack (callBackData) {
    $('.tooltip').css('display', 'none')
    $('.tooltip').remove()
    // this.showMessage("Success", "Previous Timesheet created");
    this.get([])
  }

  createPreviousAttendnacesheetFailCallBack (callBackData) {
    this.showMessage('Error', callBackData)
  }

  getActionButtonsHtml (id, data) {
    let html = ''
    if (this.getTableName() === 'EmployeeTimeSheetAll') {
      html = '<div style="width:80px;"><img class="tableActionButton" src="_BASE_images/view.png" style="cursor:pointer;" rel="tooltip" title="Edit Timesheet Entries" onclick="modJs.edit(_id_);return false;"></img><img class="tableActionButton" src="_BASE_images/redo.png" style="cursor:pointer;margin-left:15px;" rel="tooltip" title="Create previous time sheet" onclick="modJs.createPreviousAttendnacesheet(_id_);return false;"></img></div>'
    } else {
      html = '<div style="width:80px;"><img class="tableActionButton" src="_BASE_images/view.png" style="cursor:pointer;" rel="tooltip" title="Edit Timesheet Entries" onclick="modJs.edit(_id_);return false;"></img></div>'
    }
    html = html.replace(/_id_/g, id)
    html = html.replace(/_BASE_/g, this.baseUrl)
    return html
  }

  getCustomTableParams () {
    const that = this
    const dataTableParams = {
      aoColumnDefs: [
        {
          fnRender (data, cell) {
            return that.preProcessRemoteTableData(data, cell, 1)
          },
          aTargets: [1],
        },
        {
          fnRender (data, cell) {
            return that.preProcessRemoteTableData(data, cell, 2)
          },
          aTargets: [2],
        },
        {
          fnRender: that.getActionButtons,
          aTargets: [that.getDataMapping().length],
        },
      ],
    }
    return dataTableParams
  }

  preProcessRemoteTableData (data, cell, id) {
    return Date.parse(cell).toString('MMM d, yyyy (dddd)')
  }
}

module.exports = {
  AttendanceAdapter,
  EmployeeAttendanceSheetAdapter,
}
