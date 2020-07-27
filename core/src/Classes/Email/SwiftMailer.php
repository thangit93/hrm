<?php
namespace Classes\Email;

use Utils\LogManager;

class SwiftMailer extends EmailSender
{

    public function __construct($settings)
    {
        parent::__construct($settings);
    }

    protected function sendMail(
        $subject,
        $body,
        $toEmail,
        $fromEmail,
        $replyToEmail = null,
        $ccList = array(),
        $bccList = array(),
        $fromName = null
    ) {

        try {
            if (empty($replyToEmail)) {
                $replyToEmail = $fromEmail;
            }

            LogManager::getInstance()->info("Sending email to: " . $toEmail . "/ from: " . $fromEmail);

            $host = $this->settings->getSetting("Email: SMTP Host");
            $username = $this->settings->getSetting("Email: SMTP User");
            $password = $this->settings->getSetting("Email: SMTP Password");
            $port = $this->settings->getSetting("Email: SMTP Port");
            $security = null;

            if (empty($port)) {
                $port = '25';
            } else if (!empty($port) && $port == 465) {
                $security = 'ssl';
            } else if (!empty($port) && $port = 587) {
                $security = 'tls';
            }
            $transport = new \Swift_SmtpTransport($host, $port, $security);
            $mail = new \Swift_Message();

            if ($this->settings->getSetting("Email: SMTP Authentication Required") === "1") {
                $transport->setUsername($username);
                $transport->setPassword($password);
            }

            $mail->addFrom($fromEmail, $fromName);
            $mail->addReplyTo($replyToEmail);
            $mail->addTo($toEmail);
            $mail->setSubject($subject);
            $mail->setCc($ccList);
            $mail->setBcc($bccList);
            $mail->setBody($body);
            $mail->setContentType('text/html');

            // Ha Tran custom ssl stream options for SwiftMailer
            $options['ssl']['allow_self_signed'] = TRUE;
            $options['ssl']['verify_peer'] = FALSE;
            $options['ssl']['verify_peer_name'] = FALSE;
            $transport->setStreamOptions($options);

            $mailer = new \Swift_Mailer($transport);
            return $mailer->send($mail);
        } catch (\Exception $e) {
            LogManager::getInstance()->error("Error sending email:" . $e->getMessage());
            return false;
        }
    }
}
