<?php

$moduleName = 'payroll';
$moduleGroup = 'admin';
define('MODULE_PATH',dirname(__FILE__));
include APP_BASE_PATH.'header.php';
include APP_BASE_PATH.'modulejslibs.inc.php';
?><script type="text/javascript" src="<?=BASE_URL?>js/mindmup-editabletable.js?v=<?=$jsVersion?>"></script>
<style type="text/css">
    .sorting_disabled{min-width: 80px;}
</style>
<div class="span9">
    <ul class="nav nav-tabs" id="modTab" style="margin-bottom:0px;margin-left:5px;border-bottom: none;">
        <li class="active"><a id="tabPayrollEmployee" href="#tabPagePayrollEmployee"><?=t('Company Payroll')?></a></li>
        <li class=""><a id="tabPayroll" href="#tabPagePayroll"><?=t('Payroll Reports')?></a></li>
        <li class=""><a id="tabPayrollColumn" href="#tabPagePayrollColumn"><?=t('Payroll Columns')?></a></li>
        <li class=""><a id="tabDeductionGroup" href="#tabPageDeductionGroup"><?=t('Calculation Groups')?></a></li>
<!--        <li class=""><a id="tabDeduction" href="#tabPageDeduction">--><?//=t('Calculation Methods')?><!--</a></li>-->
<!--        <li class=""><a id="tabPayslipTemplate" href="#tabPagePayslipTemplate">--><?//=t('Payslip Templates')?><!--</a></li>-->
    </ul>

    <div class="tab-content">
        <div class="tab-pane active" id="tabPagePayrollEmployee">
            <div id="PayrollEmployee" class="reviewBlock" data-content="List" style="padding-left:5px;">

            </div>
            <div id="PayrollEmployeeForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">

            </div>
        </div>

        <div class="tab-pane " id="tabPagePayroll">
            <div id="Payroll" class="reviewBlock" data-content="List" style="padding-left:5px;">

            </div>
            <div id="PayrollForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">

            </div>
            <div id="PayrollData" class="reviewBlock" data-content="List" style="padding-left:5px;display:none;overflow-x: auto;">

            </div>
            <div id="PayrollDataButtons" style="text-align: right;margin-top: 10px;">
                <button class="cancelBtnTable btn" style="margin-right:5px;"><i class="fa fa-times-circle-o"></i> <?php echo t('Cancel') ?></button>
                <button class="saveBtnTable btn btn-primary" style="margin-right:5px;"><i class="fa fa-save"></i> <?php echo t('Save') ?></button>
                <button class="downloadBtnTable btn btn-primary" style="margin-right:5px;"><i class="fa fa-check"></i> <?php echo t('Download') ?></button>
<!--              YViet-->
                <button class="downloadBtnTable2 btn btn-primary" style="margin-right:5px;"><i class="fa fa-check"></i> <?php echo t('Download') . " " . t('Payment on Behalf') . " ACB" ?> - YViet</button>
                <button class="downloadBtnTable3 btn btn-primary" style="margin-right:5px;"><i class="fa fa-check"></i> <?php echo t('Download') . " " . t('Payment on Behalf') ?> - YViet</button>
<!--              VMED-->
                <button class="downloadBtnTable4 btn btn-primary" style="margin-right:5px;"><i class="fa fa-check"></i> <?php echo t('Download') . " " . t('Payment on Behalf') . " ACB" ?> - VMED</button>
                <button class="downloadBtnTable5 btn btn-primary" style="margin-right:5px;"><i class="fa fa-check"></i> <?php echo t('Download') . " " . t('Payment on Behalf') ?> - VMED</button>
<!--              SKB-->
                <button class="downloadBtnTable6 btn btn-primary" style="margin-right:5px;"><i class="fa fa-check"></i> <?php echo t('Download') . " " . t('Payment on Behalf') . " ACB - SKB" ?></button>
                <button class="downloadBtnTable7 btn btn-primary" style="margin-right:5px;"><i class="fa fa-check"></i> <?php echo t('Download') . " " . t('Payment on Behalf') ?> - SKB</button>
                <button class="completeBtnTable btn btn-primary" style="margin-right:5px;"><i class="fa fa-check-square-o"></i> <?php echo t('Finalize') ?></button>
                <button class="reviewPayslipBtnTable btn btn-primary" style="margin-right:5px;"><i class="fa fa-check-square-o"></i> <?php echo t('Review Payslip') ?></button>
                <button class="sendPayslipBtnTable btn btn-primary" style="margin-right:5px;"><i class="fa fa-check-square-o"></i> <?php echo t('Send Payslip') ?></button>
            </div>
        </div>

        <div class="tab-pane" id="tabPagePayrollColumn">
            <div id="PayrollColumn" class="reviewBlock" data-content="List" style="padding-left:5px;">

            </div>
            <div id="PayrollColumnForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">

            </div>
        </div>

        <!--<div class="tab-pane" id="tabPagePayrollColumnTemplate">
            <div id="PayrollColumnTemplate" class="reviewBlock" data-content="List" style="padding-left:5px;">

            </div>
            <div id="PayrollColumnTemplateForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">

            </div>
        </div>-->

        <div class="tab-pane" id="tabPageDeductionGroup">
            <div id="DeductionGroup" class="reviewBlock" data-content="List" style="padding-left:5px;">

            </div>
            <div id="DeductionGroupForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">

            </div>
        </div>

        <div class="tab-pane" id="tabPageDeduction">
            <div id="Deduction" class="reviewBlock" data-content="List" style="padding-left:5px;">

            </div>
            <div id="DeductionForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">

            </div>
        </div>

        <div class="tab-pane" id="tabPagePayslipTemplate">
            <div id="PayslipTemplate" class="reviewBlock" data-content="List" style="padding-left:5px;">

            </div>
            <div id="PayslipTemplateForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">

            </div>
        </div>


    </div>

</div>
<script>
    var modJsList = new Array();

    modJsList['tabPayday'] = new PaydayAdapter('PayFrequency','Payday');
    modJsList['tabPayroll'] = new PayrollAdapter('Payroll','Payroll');

    modJsList['tabPayrollData'] = new PayrollDataAdapter('PayrollData','PayrollData');
    modJsList['tabPayrollData'].setRemoteTable(false);
    modJsList['tabPayrollData'].setShowAddNew(false);
    modJsList['tabPayrollData'].setModulePath('admin=payroll');
    modJsList['tabPayrollData'].setRowFieldName('employee');
    modJsList['tabPayrollData'].setColumnFieldName('payroll_item');
    modJsList['tabPayrollData'].setTables('PayrollEmployee','PayrollColumn','PayrollData');

    modJsList['tabPayrollColumn'] = new PayrollColumnAdapter('PayrollColumn','PayrollColumn','','deduction_group, colorder');
    modJsList['tabPayrollColumn'].setRemoteTable(true);
    //modJsList['tabPayrollColumnTemplate'] = new PayrollColumnTemplateAdapter('PayrollColumnTemplate','PayrollColumnTemplate');

    modJsList['tabPayrollEmployee'] = new PayrollEmployeeAdapter('PayrollEmployee','PayrollEmployee');
    modJsList['tabPayrollEmployee'].setRemoteTable(true);

    modJsList['tabPayslipTemplate'] = new PayslipTemplateAdapter('PayslipTemplate','PayslipTemplate');
    modJsList['tabPayslipTemplate'].setRemoteTable(true);

    var modJs = modJsList['tabPayrollEmployee'];

    $(".saveBtnTable").off().on('click',function(){
        modJsList['tabPayrollData'].sendCellDataUpdates();
    });

    $(".completeBtnTable").off().on('click',function(){
        modJsList['tabPayrollData'].sendAllCellDataUpdates();
        $(".completeBtnTable").hide();
        $(".saveBtnTable").hide();
    });

    $(".downloadBtnTable").off().on('click',function(){
        modJsList['tabPayrollData'].exportAllData(1);
    });

    $(".downloadBtnTable2").off().on('click',function(){
        modJsList['tabPayrollData'].exportAllData(2);
    });

    $(".downloadBtnTable3").off().on('click',function(){
        modJsList['tabPayrollData'].exportAllData(3);
    });

    $(".downloadBtnTable4").off().on('click',function(){
        modJsList['tabPayrollData'].exportAllData(4);
    });

    $(".downloadBtnTable5").off().on('click',function(){
        modJsList['tabPayrollData'].exportAllData(5);
    });

    $(".downloadBtnTable6").off().on('click',function(){
        modJsList['tabPayrollData'].exportAllData(6);
    });

    $(".downloadBtnTable7").off().on('click',function(){
        modJsList['tabPayrollData'].exportAllData(7);
    });

    $(".sendPayslipBtnTable").off().on('click',function(){
        modJsList['tabPayrollData'].sendPayslip();
    });

    $(".reviewPayslipBtnTable").off().on('click',function(){
        modJsList['tabPayrollData'].sendPayslip(1);
    });

    $(".cancelBtnTable").off().on('click',function(){
        modJs = modJsList['tabPayroll'];
        modJs.get([]);
    });

    modJsList['tabDeduction'] = new DeductionAdapter('Deduction','Deduction');
    modJsList['tabDeduction'].setRemoteTable(true);

    modJsList['tabDeductionGroup'] = new DeductionGroupAdapter('DeductionGroup','DeductionGroup');
    modJsList['tabDeductionGroup'].setRemoteTable(true);


</script>
<?php include APP_BASE_PATH.'footer.php';?>
