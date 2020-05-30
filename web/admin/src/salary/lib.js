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
            'amount',
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
                    fnRender: that.getActionButtons,
                    aTargets: [that.getDataMapping().length],
                },
            ],
        };
    }

    preProcessRemoteTableData(data, cell, id) {
        if (id === 1) {
            cell = parseInt(cell)
            cell = new Intl.NumberFormat('en-VN').format(cell)
        }

        return cell;
    }

    getHeaders() {
        return [
            {sTitle: 'ID', bVisible: false},
            {sTitle: 'Amount'},
        ];
    }

    getFormFields() {
        return [
            ['id', {label: 'ID', type: 'hidden'}],
            ['amount', {label: 'Amount', type: 'text', validation: 'integer'}],
        ];
    }
}

module.exports = {
    SalaryComponentTypeAdapter,
    SalaryComponentAdapter,
    EmployeeSalaryAdapter,
    EmployeeSalaryDepositAdapter,
    EmployeeSalaryBonusAdapter,
    EmployeeSalaryOvertimeAdapter,
};
