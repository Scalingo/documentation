---
title: Sending emails from PHP
nav: Sending Emails
modified_at: 2024-12-10 10:45:00
tags: php email phpmailer smtp mail
index: 100
---

For sending emails from your PHP application you will need to use an external SMTP server. 
Several options are listed on our [dedicated section]({% post_url platform/app/2000-01-01-sending-emails %}).

You can use a mailing library such as [PHPMailer](https://github.com/PHPMailer/PHPMailer) (or equivalent) to send from your PHP application, via an external SMTP server.

### Example Using PHPMailer
 
```php
<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php';

$mail = new PHPMailer(true);

try {
    // Server settings
    $mail->isSMTP();
    $mail->Host       = getenv('SMTP_SERVER');
    $mail->SMTPAuth   = true;
    $mail->Username   = getenv('SMTP_USERNAME');
    $mail->Password   = getenv('SMTP_PASSWORD');
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port       = getenv('SMTP_PORT');

    // Recipients
    $mail->setFrom('from@example.com', 'Sender Name');
    $mail->addAddress('recipient@example.com', 'Recipient Name');
    $mail->addReplyTo('reply@example.com', 'Reply Name');

    // Content
    $mail->isHTML(true);
    $mail->Subject = 'Test Email from PHPMailer';
    $mail->Body    = '<p>This is a test email sent using PHPMailer from my app hosted on Scalingo.</p>';
    $mail->AltBody = 'This is a test email sent using PHPMailer from my app hosted on Scalingo.';

    $mail->send();
    echo 'Message has been sent';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
```