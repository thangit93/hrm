/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

import AdapterBase from '../../../api/AdapterBase';
import ApproveAdminAdapter from '../../../api/ApproveAdminAdapter';

/**
 * OvertimeCategoryAdapter
 */

class OvertimeCategoryAdapter extends AdapterBase {
  getDataMapping() {
    return [
      'id',
      'name',
      'coefficient',
      'type',
    ];
  }

  getHeaders() {
    return [
      { sTitle: 'ID', bVisible: false },
      { sTitle: 'Name' },
      { sTitle: 'Coefficient' },
      { sTitle: 'Type' },
    ];
  }

  getFormFields() {
    return [
      ['id', { label: 'ID', type: 'hidden' }],
      ['name', { label: 'Name', type: 'text', validation: '' }],
      ['coefficient', { label: 'Coefficient', type: 'text', validation: '' }],
      ['type', { label: 'Type', type: 'text', validation: '' }],
    ];
  }
}


/**
 * EmployeeOvertimeAdminAdapter
 */


class EmployeeOvertimeAdminAdapter extends ApproveAdminAdapter {
  constructor(endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy);
    this.itemName = 'OvertimeRequest';
    this.itemNameLower = 'overtimerequest';
    this.modulePathName = 'overtime';
  }

  getDataMapping() {
    return [
      'id',
      'employee',
      'category',
      'start_time',
      'end_time',
      // 'project',
      "notes",
      "total_time",
      'status',
    ];
  }

  getHeaders() {
    return [
      { sTitle: 'ID', bVisible: false },
      { sTitle: 'Employee' },
      { sTitle: 'Category' },
      { sTitle: 'Start Time' },
      { sTitle: 'End Time' },
      // { sTitle: 'Project' },
      {"sTitle": "Location"},
      {"sTitle": "Total Time"},
      { sTitle: 'Status' },
    ];
  }

  getFormFields() {
    return [
      ['id', { label: 'ID', type: 'hidden' }],
      ['employee', {
        label: 'Employee',
        type: 'select2',
        sort: 'none',
        'allow-null': false,
        'remote-source': ['Employee', 'id', 'first_name+last_name', 'getActiveSubordinateEmployees'],
      }],
      ['category', {
        label: 'Category', type: 'select2', 'allow-null': false, 'remote-source': ['OvertimeCategory', 'id', 'name'],
      }],
      ['start_time', { label: 'Start Time', type: 'datetime', validation: '' }],
      ['end_time', { label: 'End Time', type: 'datetime', validation: '' }],
      /*['project', {
        label: 'Project', type: 'select2', 'allow-null': true, 'null=label': 'none', 'remote-source': ['Project', 'id', 'name'],
      }],*/
      ['total_time', { label: 'Total Time', type: 'text', readonly: true, validation: 'none' }],
      ['notes', { label: 'Notes', type: 'textarea', validation: 'none' }],
    ];
  }

  renderForm(object) {
    const signatureIds = [];
    if (object == null || object === undefined) {
      this.currentId = null;
    }

    this.preRenderForm(object);

    let formHtml = this.templates.formTemplate;
    let html = '';
    const fields = this.getFormFields();

    for (let i = 0; i < fields.length; i++) {
      const metaField = this.getMetaFieldForRendering(fields[i][0]);
      if (metaField === '' || metaField === undefined) {
        html += this.renderFormField(fields[i]);
      } else {
        const metaVal = object[metaField];
        if (metaVal !== '' && metaVal != null && metaVal !== undefined && metaVal.trim() !== '') {
          html += this.renderFormField(JSON.parse(metaVal));
        } else {
          html += this.renderFormField(fields[i]);
        }
      }
    }
    formHtml = formHtml.replace(/_id_/g, `${this.getTableName()}_submit`);
    formHtml = formHtml.replace(/_fields_/g, html);

    let $tempDomObj;
    const randomFormId = this.generateRandom(14);
    if (!this.showFormOnPopup) {
      $tempDomObj = $(`#${this.getTableName()}Form`);
    } else {
      $tempDomObj = $('<div class="reviewBlock popupForm" data-content="Form"></div>');
      $tempDomObj.attr('id', randomFormId);
    }

    $tempDomObj.html(formHtml);


    $tempDomObj.find('.datefield').datepicker({ viewMode: 2 });
    $tempDomObj.find('.timefield').datetimepicker({
      language: 'en',
      pickDate: false,
    });
    $tempDomObj.find('.datetimefield').datetimepicker({
      language: 'en',
      useSeconds: false,
      onRender: function(date) {
        return date.valueOf() < now.valueOf() ? 'disabled' : '';
      }
    }).on('changeDate', function(ev) {
      let tagId = $(this).attr('id');
      if (tagId === 'start_time_datetime'){
        let startDate = new Date($('#start_time').val()).valueOf();
        let endDate = new Date($('#end_time').val()).valueOf();
        let diff_ms = endDate - startDate;
        let diff_hrs = diff_ms / 3600000;
        $("#total_time").val(diff_hrs);
      } else if (tagId === 'end_time_datetime') {
        let startDate = new Date($('#start_time').val()).valueOf();
        let endDate = new Date($('#end_time').val()).valueOf();
        let diff_ms = endDate - startDate;
        let diff_hrs = diff_ms / 3600000;
        $("#total_time").val(diff_hrs);
      }
    }).data('datepicker');

    $tempDomObj.find('.colorpick').colorpicker();

    tinymce.init({
      selector: `#${$tempDomObj.attr('id')} .tinymce`,
      height: '400',
    });

    $tempDomObj.find('.simplemde').each(function () {
      const simplemde = new SimpleMDE({ element: $(this)[0] });
      $(this).data('simplemde', simplemde);
      // simplemde.value($(this).val());
    });

    // $tempDomObj.find('.select2Field').select2();
    $tempDomObj.find('.select2Field').each(function () {
      $(this).select2().select2('val', $(this).find('option:eq(0)').val());
    });

    $tempDomObj.find('.select2Multi').each(function () {
      $(this).select2().on('change', function (e) {
        const parentRow = $(this).parents('.row');
        const height = parentRow.find('.select2-choices').height();
        parentRow.height(parseInt(height, 10));
      });
    });


    $tempDomObj.find('.signatureField').each(function () {
      // $(this).data('signaturePad',new SignaturePad($(this)));
      signatureIds.push($(this).attr('id'));
    });

    for (let i = 0; i < fields.length; i++) {
      if (fields[i][1].type === 'datagroup') {
        $tempDomObj.find(`#${fields[i][0]}`).data('field', fields[i]);
      }
    }

    if (this.showSave === false) {
      $tempDomObj.find('.saveBtn').remove();
    } else {
      $tempDomObj.find('.saveBtn').off();
      $tempDomObj.find('.saveBtn').data('modJs', this);
      $tempDomObj.find('.saveBtn').on('click', function () {
        if ($(this).data('modJs').saveSuccessItemCallback != null && $(this).data('modJs').saveSuccessItemCallback !== undefined) {
          $(this).data('modJs').save($(this).data('modJs').retriveItemsAfterSave(), $(this).data('modJs').saveSuccessItemCallback);
        } else {
          $(this).data('modJs').save();
        }

        return false;
      });
    }

    if (this.showCancel === false) {
      $tempDomObj.find('.cancelBtn').remove();
    } else {
      $tempDomObj.find('.cancelBtn').off();
      $tempDomObj.find('.cancelBtn').data('modJs', this);
      $tempDomObj.find('.cancelBtn').on('click', function () {
        $(this).data('modJs').cancel();
        return false;
      });
    }

    // Input mask
    $tempDomObj.find('[mask]').each(function () {
      $(this).inputmask($(this).attr('mask'));
    });

    $tempDomObj.find('[datemask]').each(function () {
      $(this).inputmask({
        mask: 'y-1-2',
        placeholder: 'YYYY-MM-DD',
        leapday: '-02-29',
        separator: '-',
        alias: 'yyyy/mm/dd',
      });
    });

    $tempDomObj.find('[datetimemask]').each(function () {
      $(this).inputmask('datetime', {
        mask: 'y-2-1 h:s',
        placeholder: 'YYYY-MM-DD hh:mm',
        leapday: '-02-29',
        separator: '-',
        alias: 'yyyy/mm/dd',
      });

    });

    if (!this.showFormOnPopup) {
      $(`#${this.getTableName()}Form`).show();
      $(`#${this.getTableName()}`).hide();

      for (let i = 0; i < signatureIds.length; i++) {
        $(`#${signatureIds[i]}`)
            .data('signaturePad',
                new SignaturePad(document.getElementById(signatureIds[i])));
      }

      if (object !== undefined && object != null) {
        this.fillForm(object);
      } else {
        this.setDefaultValues();
      }

      this.scrollToTop();
    } else {
      // var tHtml = $tempDomObj.wrap('<div>').parent().html();
      // this.showMessage("Edit",tHtml,null,null,true);
      this.showMessage('Edit', '', null, null, true);

      $('#plainMessageModel .modal-body').html('');
      $('#plainMessageModel .modal-body').append($tempDomObj);


      for (let i = 0; i < signatureIds.length; i++) {
        $(`#${signatureIds[i]}`)
            .data('signaturePad',
                new SignaturePad(document.getElementById(signatureIds[i])));
      }

      if (object !== undefined && object != null) {
        this.fillForm(object, `#${randomFormId}`);
      } else {
        this.setDefaultValues(`#${randomFormId}`);
      }
    }

    this.postRenderForm(object, $tempDomObj);
  }
}

class ReportOvertimeAdapter extends AdapterBase {
  getDataMapping() {
    return [
      "id",
      "name",
      "startTime",
      "endTime",
      "totalTime",
      "notes",
    ];
  }

  getHeaders() {
    return [
      {"sTitle": "ID", "bVisible": false},
      {"sTitle": "Name"},
      {"sTitle": "Start Time"},
      {"sTitle": "End Time"},
      {"sTitle": "Total Time"},
      {"sTitle": "Notes"},
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
    var object = {
      ft: that.filter
    };
    var reqJson = JSON.stringify(object);
    var callBackData = [];
    callBackData['callBackData'] = [];
    callBackData['callBackSuccess'] = 'getOvertimeSuccessCallBack';
    callBackData['callBackFail'] = 'getOvertimeFailCallBack';

    this.customAction('getReportOvertime', 'admin=overtime', reqJson, callBackData);
  }

  getOvertimeSuccessCallBack(data) {
    var callBackData = [];
    callBackData['noRender'] = false;
    this.getSuccessCallBack(callBackData, data);
  }

  getOvertimeFailCallBack(data) {

  }

  getFilters() {
    return [
      ['date_start', {
        label: 'Start Date', type: 'yearmonth'
      }],
      ['date_end', {
        label: 'End Date', type: 'yearmonth'
      }]
    ];
  }

  getCustomTableParams() {
    return {
      "bPaginate": false,
      "bFilter": false,
      "bInfo": false
    };
  }

  createTable(elementId) {
    const that = this;

    if (this.getRemoteTable()) {
      this.createTableServer(elementId);
      return;
    }


    const headers = this.getHeaders();

    // add translations
    for (const index in headers) {
      headers[index].sTitle = this.gt(headers[index].sTitle);
    }

    const data = this.getTableData();

    if (this.showActionButtons()) {
      headers.push(this.getActionButtonHeader());
    }


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

    $(`#${elementId} #grid`).dataTable(dataTableParams);

    $('.dataTables_paginate ul').addClass('pagination');
    $('.dataTables_length').hide();
    $('.dataTables_filter input').addClass('form-control');
    $('.dataTables_filter input').attr('placeholder', 'Search');
    $('.dataTables_filter label').contents().filter(function () {
      return (this.nodeType === 3);
    }).remove();
    $('.tableActionButton').tooltip();
  }

  getTableTopButtonHtml() {
    let html = '';
    if (this.getShowAddNew()) {
      html = `<button onclick="modJs.renderForm();return false;" class="btn btn-small btn-primary">${this.gt(this.getAddNewLabel())} <i class="fa fa-plus"></i></button>`;
    }

    if (html !== '') {
      html += '&nbsp;&nbsp;';
    }
    html += `<button onclick="modJs.showFilters();return false;" class="btn btn-small btn-primary">${this.gt('Export Report')} <i class="fa fa-download"></i></button>`;

    if (this.getFilters() != null) {
      if (html !== '') {
        html += '&nbsp;&nbsp;';
      }
      html += `<button onclick="modJs.showFilters();return false;" class="btn btn-small btn-primary">${this.gt('Filter')} <i class="fa fa-filter"></i></button>`;
      html += '&nbsp;&nbsp;';
      if (this.filtersAlreadySet) {
        html += '<button id="__id___resetFilters" onclick="modJs.resetFilters();return false;" class="btn btn-small btn-default">__filterString__ <i class="fa fa-times"></i></button>';
      } else {
        html += '<button id="__id___resetFilters" onclick="modJs.resetFilters();return false;" class="btn btn-small btn-default" style="display:none;">__filterString__ <i class="fa fa-times"></i></button>';
      }
    }

    html = html.replace(/__id__/g, this.getTableName());

    if (this.currentFilterString !== '' && this.currentFilterString != null) {
      html = html.replace(/__filterString__/g, this.currentFilterString);
    } else {
      html = html.replace(/__filterString__/g, 'Reset Filters');
    }

    if (html !== '') {
      html = `<div class="row"><div class="col-xs-12">${html}</div></div>`;
    }

    return html;
  }

  getHelpLink() {
    return 'https://antnest.vn';
  }
}

module.exports = {
  OvertimeCategoryAdapter,
  EmployeeOvertimeAdminAdapter,
  ReportOvertimeAdapter
};
