<?php
/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

$moduleName = 'attendance';
$moduleGroup = 'modules';
define('MODULE_PATH',dirname(__FILE__));
include APP_BASE_PATH.'header.php';
include APP_BASE_PATH.'modulejslibs.inc.php';
$useServerTime = \Classes\SettingsManager::getInstance()->getSetting('Attendance: Use Department Time Zone');
$photoAttendance = \Classes\SettingsManager::getInstance()->getSetting('Attendance: Photo Attendance');
$currentEmployeeTimeZone = \Classes\BaseService::getInstance()->getCurrentEmployeeTimeZone();
if(empty($currentEmployeeTimeZone)){
    $useServerTime = 0;
}
?><div class="span9">

	<ul class="nav nav-tabs" id="modTab" style="margin-bottom:0px;margin-left:5px;border-bottom: none;">
		<li class="active"><a id="tabAttendance" href="#tabPageAttendance"><?=t('Attendance')?></a></li>
	</ul>

	<div class="tab-content">
		<div class="tab-pane active" id="tabPageAttendance">
			<div id="Attendance" class="reviewBlock" data-content="List" style="padding-left:5px;">

			</div>
		</div>
	</div>

</div>
<style>
#Attendance .dataTables_filter label{
	float:left;
}
</style>
<script>
var modJsList = [];
modJsList['tabAttendance'] = new AttendanceAdapter('Attendance','Attendance','','in_time desc');
modJsList['tabAttendance'].setUseServerTime(<?=$useServerTime?>);
modJsList['tabAttendance'].setPhotoAttendance(false);
modJsList['tabAttendance'].setRemoteTable(false);
modJsList['tabAttendance'].updatePunchButton(false);
modJsList['tabAttendance'].setShowAddNew(false);


var modJs = modJsList['tabAttendance'];

</script>
<div class="modal" id="PunchModel" tabindex="-1" role="dialog" aria-labelledby="messageModelLabel" aria-hidden="true">
<div class="modal-dialog">
<div class="modal-content">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><li class="fa fa-times"/></button>
		<h3 style="font-size: 17px;">Punch Time</h3>
	</div>
	<div class="modal-body" style="max-height:530px;" id="AttendanceForm">

	</div>
</div>
</div>
</div>
<?php include APP_BASE_PATH.'footer.php';?>
