class BDDFactory
!!!134274.php!!!	MysqlConnexion(in dbname : string = 'babtouland') : PDO

		$bdd = new \PDO('mysql:host=localhost;dbname='.$dbname.';charset=utf8', 'root', '', array(\PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION));
		return $bdd;
