/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */
class NotificationManager {
  constructor() {
    this.baseUrl = '';
    this.templates = {};
  }

  setBaseUrl(url) {
    this.baseUrl = url;
  }

  setTemplates(data) {
    this.templates = data;
  }

  setTimeUtils(timeUtils) {
    this.timeUtils = timeUtils;
  }

  getNotifications(name, data) {
    const that = this;
    $.getJSON(this.baseUrl, { a: 'getNotifications' }, (_data) => {
      if (_data.status === 'SUCCESS') {
        that.renderNotifications(_data.data[1], _data.data[0]);
      }
    });
  }

  clearPendingNotifications(name, data) {
    const that = this;
    $.getJSON(this.baseUrl, { a: 'clearNotifications' }, (_data) => {

    });
  }

  renderNotifications(notifications, unreadCount) {
    if (notifications.length === 0) {
      return;
    }

    let t = this.templates.notifications;
    if (unreadCount > 0) {
      t = t.replace('#_count_#', unreadCount);
      if (unreadCount > 1) {
        t = t.replace('#_header_#', modJs.gt(`You have %unreadCount% new notifications`)
            .replace('%unreadCount%', unreadCount));
      } else {
        t = t.replace('#_header_#', modJs.gt(`You have %unreadCount% new notifications`)
            .replace('%unreadCount%', unreadCount));
      }
    } else {
      t = t.replace('#_count_#', '');
      t = t.replace('#_header_#', modJs.gt('You have no new notifications'));
    }

    let notificationStr = '';

    for (const index in notifications) {
      notificationStr += this.renderNotification(notifications[index]);
    }

    t = t.replace('#_notifications_#', notificationStr);

    const $obj = $(t);

    if (unreadCount === 0) {
      $obj.find('.label-danger').remove();
    }

    $obj.attr('id', 'notifications');
    const k = $('#notifications');
    k.replaceWith($obj);

    $('.navbar .menu').slimscroll({
      height: '320px',
      alwaysVisible: false,
      size: '3px',
    }).css('width', '100%');

    this.timeUtils.convertToRelativeTime($('.notificationTime'));
  }


  renderNotification(notification) {
    let t = this.templates.notification;
    t = t.replace('#_image_#', notification.image);

    try {
      const json = JSON.parse(notification.action);
      t = t.replace('#_url_#', this.baseUrl.replace('service.php', '?') + json.url);
    } catch (e) {
      t = t.replace('#_url_#', '');
    }

    t = t.replace('#_time_#', modJs.dt(notification.time));
    t = t.replace('#_fromName_#', modJs.gt(notification.type));

    let translateMessage = notification.message;
    translateMessage = translateMessage.replace('A new OvertimeRequest has been added by ',
        modJs.gt('A new OvertimeRequest has been added by '));
    translateMessage = translateMessage.replace('. Please visit Overtime Management module to review it',
        modJs.gt('. Please visit Overtime Management module to review it'));
    translateMessage = translateMessage.replace('. You are getting this notification since you are an administrator and the user do not have any supervisor assigned.',
        modJs.gt('. You are getting this notification since you are an administrator and the user do not have any supervisor assigned.'));
    translateMessage = translateMessage.replace('applied for a leave. Visit leave module to approve or reject',
        modJs.gt('applied for a leave. Visit leave module to approve or reject'));

    t = t.replace('#_message_#', this.getLineBreakString(translateMessage, 27));
    return t;
  }


  getLineBreakString(str, len) {
    let t = '';
    try {
      const arr = str.split(' ');
      let count = 0;
      for (let i = 0; i < arr.length; i++) {
        count += arr[i].length + 1;
        if (count > len) {
          t += `${arr[i]}<br/>`;
          count = 0;
        } else {
          t += `${arr[i]} `;
        }
      }
    } catch (e) {
      // Do nothing
    }
    return t;
  }
}

export default NotificationManager;
