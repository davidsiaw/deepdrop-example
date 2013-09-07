<?

function requestheaders() {
  $arh = array();
  $rx_http = '/\AHTTP_/';
  foreach($_SERVER as $key => $val) {
    if( preg_match($rx_http, $key) ) {
      $arh_key = preg_replace($rx_http, '', $key);
      $rx_matches = array();
      // do some nasty string manipulations to restore the original letter case
      // this should work in most cases
      $rx_matches = explode('_', $arh_key);
      if( count($rx_matches) > 0 and strlen($arh_key) > 2 ) {
        foreach($rx_matches as $ak_key => $ak_val) $rx_matches[$ak_key] = ucfirst($ak_val);
        $arh_key = implode('-', $rx_matches);
      }
      $arh[$arh_key] = $val;
    }
  }
  return( $arh );
}

$headers = requestheaders();
$file = new stdClass;
$file->name = basename($headers['X-FILE-NAME']);
$file->size = $headers['X-FILE-SIZE'];
$file->content = file_get_contents("php://input");

if ($file->size > 1000000) 
{
	echo "nice try";
}
else
{
	$filenames = glob('Content/Uploads/*'); // get all file names
	foreach($filenames as $filename){ // iterate files
	  if(is_file($filename))
	    unlink($filename); // delete file
	}

	// if everything is ok, save the file somewhere
	$storage = "Content/Uploads/";
	if (file_exists($storage)) {
		$unique = $file->name;
		
		$path = $storage . $unique;

		$handle = fopen($path, 'w');
		fwrite($handle, $file->content);
		fclose($handle);
		print_r($headers);
	}
}

?>
