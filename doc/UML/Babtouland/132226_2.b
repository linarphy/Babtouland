class Carte
!!!175106.php!!!	__construct(in contenu : PageElement) : void

		global $config, $lang, $Visiteur;
		$this->setTemplate($config['path_template'].$config['carte_path_template']);
		$this->setFonctions($config['path_func'].$config['carte_path_fonctions']);
		$this->setElements(array('contenu' => $contenu));
