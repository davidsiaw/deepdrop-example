<?

$headers = getallheaders();
$file = new stdClass;
$file->name = basename($headers['X-File-Name']);
$file->size = $headers['X-File-Size'];
$file->content = file_get_contents("php://input");

if ($file->size > 1000000) 
{
	echo "nice try";
}
else
{
	// if everything is ok, save the file somewhere
	$storage = "Content/Uploads/";
	if (file_exists($storage)) {
		$unique = "thefile";

		$path = $storage . $unique;

		$handle = fopen($path, 'w');
		fwrite($handle, $file->content);
		fclose($handle);
		print_r($headers);
	}
}

?>
