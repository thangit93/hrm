/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */
import ApproveModuleAdapter from '../../../api/ApproveModuleAdapter';

import {
  EmployeeOvertimeAdminAdapter,
} from '../../../admin/src/overtime/lib';


class EmployeeOvertimeAdapter extends ApproveModuleAdapter {
  constructor(endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy);
    this.itemName = 'Overtime';
    this.itemNameLower = 'employeeovertime';
    this.modulePathName = 'overtime';
  }

  getDataMapping() {
    return [
      'id',
      'category',
      'start_time',
      'end_time',
      'project',
      'status',
    ];
  }

  getHeaders() {
    return [
      { sTitle: 'ID', bVisible: false },
      { sTitle: 'Category' },
      { sTitle: 'Start Time' },
      { sTitle: 'End Time' },
      { sTitle: 'Project' },
      { sTitle: 'Status' },
    ];
  }

  getFormFields() {
    return [
      ['id', { label: 'ID', type: 'hidden' }],
      ['category', {
        label: 'Category', type: 'select2', 'allow-null': false, 'remote-source': ['OvertimeCategory', 'id', 'name'],
      }],
      ['start_time', { label: 'Start Date', type: 'datetime', validation: '' }],
      ['end_time', { label: 'End Time', type: 'datetime', validation: '' }],
      /*['project', {
        label: 'Project',
        type: 'select2',
        'allow-null': true,
        'null=label': 'none',
        'remote-source': ['Project', 'id', 'name'],
      }],*/
      ['total_time', { label: 'Total Time', type: 'text', readonly: true, validation: 'none' }],
      ['notes', { label: 'Reason', type: 'textarea', validation: 'none' }],
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

/*
 EmployeeOvertimeApproverAdapter
 */

class EmployeeOvertimeApproverAdapter extends EmployeeOvertimeAdminAdapter {
  constructor(endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy);
    this.itemName = 'Overtime';
    this.itemNameLower = 'employeeovertime';
    this.modulePathName = 'overtime';
  }

  getActionButtonsHtml(id, data) {
    const statusChangeButton = '<img class="tableActionButton" src="_BASE_images/run.png" style="cursor:pointer;" '
      + 'rel="tooltip" title="Change Status" onclick="modJs.openStatus(_id_, \'_cstatus_\');return false;">'
      + '</img>';

    const viewLogsButton = '<img class="tableActionButton" src="_BASE_images/log.png" '
      + 'style="margin-left:15px;cursor:pointer;" rel="tooltip" title="View Logs" '
      + 'onclick="modJs.getLogs(_id_);return false;"></img>';

    let html = '<div style="width:80px;">_status__logs_</div>';


    html = html.replace('_logs_', viewLogsButton);


    if (data[this.getStatusFieldPosition()] === 'Processing') {
      html = html.replace('_status_', statusChangeButton);
    } else {
      html = html.replace('_status_', '');
    }

    html = html.replace(/_id_/g, id);
    html = html.replace(/_BASE_/g, this.baseUrl);
    html = html.replace(/_cstatus_/g, data[this.getStatusFieldPosition()]);
    return html;
  }

  getStatusOptionsData(currentStatus) {
    const data = {};
    if (currentStatus === 'Processing') {
      data.Approved = 'Approved';
      data.Rejected = 'Rejected';
    }

    return data;
  }

  getStatusOptions(currentStatus) {
    return this.generateOptions(this.getStatusOptionsData(currentStatus));
  }
}


/*
 EmployeeOvertimeAdapter
 */

class SubordinateEmployeeOvertimeAdapter extends EmployeeOvertimeAdminAdapter {
  constructor(endPoint, tab, filter, orderBy) {
    super(endPoint, tab, filter, orderBy);
    this.itemName = 'Overtime';
    this.itemNameLower = 'employeeovertime';
    this.modulePathName = 'overtime';
  }
}

module.exports = {
  EmployeeOvertimeAdapter,
  EmployeeOvertimeApproverAdapter,
  SubordinateEmployeeOvertimeAdapter,
};
