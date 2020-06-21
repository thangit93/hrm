/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

import AdapterBase from '../../../api/AdapterBase';

/**
 * SalaryComponentTypeAdapter
 */

class SalaryComponentTypeAdapter extends AdapterBase {
    getDataMapping() {
        return [
            'id',
            'code',
            'name',
        ];
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Code'},
            {sTitle: 'Name'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['code', {label: 'Code', type: 'text', validation: ''}],
            ['name', {label: 'Name', type: 'text', validation: ''}],
        ];
    }
}


/**
 * SalaryComponentAdapter
 */

class SalaryComponentAdapter extends AdapterBase {
    getDataMapping() {
        return [
            'id',
            'name',
            'componentType',
            'details',
        ];
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Name'},
            {sTitle: 'Salary Component Type'},
            {sTitle: 'Details'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['name', {label: 'Name', type: 'text', validation: ''}],
            ['componentType', {
                label: 'Salary Component Type',
                type: 'select2',
                'remote-source': ['SalaryComponentType', 'id', 'name']
            }],
            ['details', {label: 'Details', type: 'textarea', validation: 'none'}],
        ];
    }
}


/*
 * EmployeeSalaryAdapter
 */

class EmployeeSalaryAdapter extends AdapterBase {
    getDataMapping() {
        return this.getTableFields();
    }

    getTableFields() {
        return [
            'id',
            'employee',
            'component',
            'amount',
            'start_date',
            'details',
        ];
    }

    getCustomTableParams() {
        const that = this;
        return {
            aoColumnDefs: [
                {
                    fnRender(data, cell) {
                        return that.preProcessRemoteTableData(data, cell, 1);
                    },
                    aTargets: [1],
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
    }

    preProcessRemoteTableData(data, cell, id) {
        if (id === 1) {
            cell = cell.split(' ');
            let birthday = cell.splice(cell.length - 1, 1);
            birthday = Date.parse(birthday[0]);
            let value = '';
            cell.map(function(item) {
                value += item + ' ';
            })
            cell = `${value} ${birthday.toString('yyyy')}` ;
        } else if (id === 3) {
            cell = parseInt(cell)
            cell = new Intl.NumberFormat('en-VN').format(cell)
        } else if (id === 4) {
            if (!cell || cell === 'NULL' || cell.length < 1 || cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell == null) {
                return '';
            }
            if (Date.parse(cell)) {
                return Date.parse(cell).toString('d/M/yyyy');
            }

            return '';
        }
        return cell;
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Employee'},
            {sTitle: 'Salary Component'},
            {sTitle: 'Amount'},
            {sTitle: 'Salary Start Date', bSort: false},
            {sTitle: 'Details'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
            ['component', {
                label: 'Salary Component',
                type: 'select2',
                'remote-source': ['SalaryComponent', 'id', 'name']
            }],
            ['amount', {label: 'Amount', type: 'text', validation: 'integer'}],
            ['start_date', {label: 'Salary Start Date', type: 'date', validation: 'none'}],
            ['details', {label: 'Details', type: 'textarea', validation: 'none'}],
        ];
    }

    getFilters() {
        return [
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
        ];
    }
}

/*
 * EmployeeSalaryAdapter
 */

class EmployeeSalaryDepositAdapter extends AdapterBase {
    getDataMapping() {
        return this.getTableFields();
    }

    getTableFields() {
        return [
            'id',
            'employee',
            'amount',
            'date',
            'details',
        ];
    }

    getCustomTableParams() {
        const that = this;
        return {
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
                    fnRender: that.getActionButtons,
                    aTargets: [that.getDataMapping().length],
                },
            ],
        };
    }

    preProcessRemoteTableData(data, cell, id) {
        if (id === 1) {
            cell = cell.split(' ');
            let birthday = cell.splice(cell.length - 1, 1);
            birthday = Date.parse(birthday[0]);
            let value = '';
            cell.map(function(item) {
                value += item + ' ';
            })
            cell = `${value} ${birthday.toString('yyyy')}` ;
        } else if (id === 2) {
            cell = parseInt(cell)
            cell = new Intl.NumberFormat('en-VN').format(cell)
        } else if (id === 3) {
            if (!cell || cell === 'NULL' || cell.length < 1 || cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell == null) {
                return '';
            }
            if (Date.parse(cell)) {
                return Date.parse(cell).toString('d/M/yyyy');
            }

            return '';
        }
        return cell;
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Employee'},
            {sTitle: 'Amount'},
            {sTitle: 'Date', bSort: false},
            {sTitle: 'Details'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
            ['amount', {label: 'Amount', type: 'text', validation: 'integer'}],
            ['date', {label: 'Salary Start Date', type: 'date', validation: 'none'}],
            ['details', {label: 'Details', type: 'textarea', validation: 'none'}],
        ];
    }

    getFilters() {
        return [
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
        ];
    }
}

/*
 * EmployeeSalaryBonusAdapter
 */

class EmployeeSalaryBonusAdapter extends AdapterBase {
    getDataMapping() {
        return this.getTableFields();
    }

    getTableFields() {
        return [
            'id',
            'employee',
            'amount',
            'date',
            'details',
        ];
    }

    getCustomTableParams() {
        const that = this;
        return {
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
                    fnRender: that.getActionButtons,
                    aTargets: [that.getDataMapping().length],
                },
            ],
        };
    }

    preProcessRemoteTableData(data, cell, id) {
        if (id === 1) {
            cell = cell.split(' ');
            let birthday = cell.splice(cell.length - 1, 1);
            birthday = Date.parse(birthday[0]);
            let value = '';
            cell.map(function(item) {
                value += item + ' ';
            })
            cell = `${value} ${birthday.toString('yyyy')}` ;
        } else if (id === 2) {
            cell = parseInt(cell)
            cell = new Intl.NumberFormat('en-VN').format(cell)
        } else if (id === 3) {
            if (!cell || cell === 'NULL' || cell.length < 1 || cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell == null) {
                return '';
            }
            if (Date.parse(cell)) {
                return Date.parse(cell).toString('d/M/yyyy');
            }

            return '';
        }
        return cell;
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Employee'},
            {sTitle: 'Amount'},
            {sTitle: 'Date', bSort: false},
            {sTitle: 'Details'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
            ['amount', {label: 'Amount', type: 'text', validation: 'integer'}],
            ['date', {label: 'Date', type: 'date', validation: 'none'}],
            ['details', {label: 'Details', type: 'textarea', validation: 'none'}],
        ];
    }

    getFilters() {
        return [
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
        ];
    }
}

/*
 * EmployeeSalaryOvertimeAdapter
 */

class EmployeeSalaryOvertimeAdapter extends AdapterBase {
    getDataMapping() {
        return this.getTableFields();
    }

    getTableFields() {
        return [
            'id',
            'employee',
            'amount',
            'date',
        ];
    }

    getCustomTableParams() {
        const that = this;
        return {
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
                    fnRender: that.getActionButtons,
                    aTargets: [that.getDataMapping().length],
                },
            ],
        };
    }

    preProcessRemoteTableData(data, cell, id) {
        if (id === 2) {
            cell = parseInt(cell)
            cell = new Intl.NumberFormat('en-VN').format(cell)
        }else if(id === 3){
            if (!cell || cell === 'NULL' || cell.length < 1 || cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell == null) {
                return '';
            }
            if (Date.parse(cell)) {
                return Date.parse(cell).toString('d/M/yyyy');
            }

            return '';
        }

        return cell;
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Employee'},
            {sTitle: 'Amount'},
            {sTitle: 'Date'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
            ['amount', {label: 'Amount', type: 'text', validation: 'integer'}],
            ['date', {label: 'Date', type: 'date', validation: 'none'}],
        ];
    }
}


/*
 * EmployeeSalaryOvertimeAdapter
 */

class NewEmployeeSalaryAdapter extends AdapterBase {
    getDataMapping() {
        return this.getTableFields();
    }

    getTableFields() {
        return [
            'id',
            'employee',
            'amount',
            'date',
        ];
    }

    getCustomTableParams() {
        const that = this;
        return {
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
                    fnRender: that.getActionButtons,
                    aTargets: [that.getDataMapping().length],
                },
            ],
        };
    }

    preProcessRemoteTableData(data, cell, id) {
        if (id === 2) {
            cell = parseInt(cell)
            cell = new Intl.NumberFormat('en-VN').format(cell)
        }else if(id === 3){
            if (!cell || cell === 'NULL' || cell.length < 1 || cell === '0000-00-00 00:00:00' || cell === '' || cell === undefined || cell == null) {
                return '';
            }
            if (Date.parse(cell)) {
                return Date.parse(cell).toString('d/M/yyyy');
            }

            return '';
        }

        return cell;
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Employee'},
            {sTitle: 'Amount'},
            {sTitle: 'Date'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['employee', {
                label: 'Employee',
                type: 'select2',
                'remote-source': ['Employee', 'id', 'first_name+last_name+birthday']
            }],
            ['amount', {label: 'Amount', type: 'text', validation: 'integer'}],
            ['date', {label: 'Date', type: 'date', validation: 'none'}],
        ];
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
            t: this.table, a: 'ca', sa: 'getEmployeeSalaryReport', mod: 'admin=salary', sm: sourceMappingJson, ft: filterJson, ob: orderBy,
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

        /*for (let i = 0; i < serverData.data.length; i++) {
            const row = [];
            for (let j = 0; j < serverData.data[i]; j++) {
                row[j] = serverData.data[i][j];
            }
            data.push(this.preProcessTableData(row));
        }*/

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

        const data = this.getTableData();
        const headers = this.headers;

        let tableHeaderHtml = '';
        tableHeaderHtml += '<thead>';
        tableHeaderHtml += '<tr>';
        tableHeaderHtml += '<td>&nbsp;</td>';

        $.each(headers, function (index, col) {
            tableHeaderHtml += '<td>';
            tableHeaderHtml += '<b>' + that.gt(col) + '</b>';
            tableHeaderHtml += '</td>';
        });

        tableHeaderHtml += '</tr>';
        tableHeaderHtml += '</thead>';


        /*if (this.showActionButtons()) {
            for (let i = 0; i < data.length; i++) {
                data[i].push(this.getActionButtonsHtml(data[i][0], data[i]));
            }
        }*/

        let html = '';
        html = /*this.getTableTopButtonHtml() +*/ this.getTableHTMLTemplate();

        // Find current page
        const activePage = $(`#${elementId} .dataTables_paginate .active a`).html();
        let start = 0;
        if (activePage !== undefined && activePage != null) {
            start = parseInt(activePage, 10) * 15 - 15;
        }

        $(`#${elementId}`).html(html);
        $('.box-body.table-responsive table').addClass('table table-bordered table-striped table-salary-report').append(tableHeaderHtml);

        let tableHtml = '';
        tableHtml += '<tbody>';
        let rowIndex = 0;

        $.each(data, function (index, row) {
            let rowClass = (rowIndex % 2 === 0) ? 'even' : 'odd;'
            tableHtml += '<tr class="' + rowClass + '">';
            $.each(row, function (index, col) {
                tableHtml += '<td>';
                tableHtml += col;
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
}

module.exports = {
    SalaryComponentTypeAdapter,
    SalaryComponentAdapter,
    EmployeeSalaryAdapter,
    EmployeeSalaryDepositAdapter,
    EmployeeSalaryBonusAdapter,
    EmployeeSalaryOvertimeAdapter,
    NewEmployeeSalaryAdapter,
};
