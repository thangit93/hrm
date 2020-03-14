<?php
$data = file_get_contents('./test.json');
$data = json_decode($data, true);

echo $data['push']['changes'][0]['commits'][0]['hash'] . "\r\n";
