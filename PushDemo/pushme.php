
<?php
// Put your device token here (without spaces):
$deviceToken = '4d2ff9b253e64842510534fe9a512af8955e04f659493006bd3a8cdcd75b0c64';

// Put your private key's passphrase here:密语
$passphrase = '123456';

// Put your alert message here:
$title = '喝茶';
$subtitle = '10点去喝茶';
$body = '10点喝什么茶，绿茶？红茶？还是青茶?';
$alert = array('title' => $title,
			'subtitle' => $subtitle, 
			'body'	   => $body
			);

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$message['aps'] = array(
	'alert' => $alert,
	'sound' => 'default',
	'badge' => 1,
	'content-available' => 1,	//静默标识
	'mutable-content' => 1 //富文本标识
	);

$message['custom_content'] = [
	'name' => 'bien',
	'age'  => 30
];


// Encode the payload as JSON
$payload = json_encode($message);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) .$payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
    
?>
