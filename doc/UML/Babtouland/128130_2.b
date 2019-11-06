class Managed
!!!135170.php!!!	__construct(in attributs : array = array()) : void

		$this->hydrater($attributs);
!!!135298.php!!!	hydrater(in attributs : array) : void

		foreach ($attributs as $key => $value)
		{
			$method='set'.ucfirst($key);
			if (method_exists($this, $method))
			{
				$this->$method($value);
			}
		}
!!!135426.php!!!	Manager() : Manager

		$BDDFactory=new \core\BDDFactory;
		$object=get_class($this).'Manager';
		return new $object($BDDFactory->MysqlConnexion());
!!!135554.php!!!	get(in index : mixed) : void

		$Manager=$this->Manager();
		$this->hydrater($Manager->get($index));
!!!135682.php!!!	similaire(in objet : Managed) : bool

		$resultat=0;
		foreach ($this::CRITERES_SIMILAIRE as $critere)
		{
			$accesseur='get'.ucfirst($critere);
			if ($this->$accesseur()==$objet->$accesseur())
			{
				$resultat+=1;
			}
		}
		return $resultat==count($this::CRITERES_SIMILAIRE);
